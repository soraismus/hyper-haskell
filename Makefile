.PHONY: test run interpreter pkg-darwin zip hackage

ELECTRON=/Applications/Electron.app/Contents/MacOS/Electron

STACK=stack --stack-yaml=haskell/stack.yaml --install-ghc

VERSION=0.2.1.0

######################################################################
# Development targets

test: interpreter
	TESTING=1 $(ELECTRON) app
	killall hyper-haskell-server

run: interpreter
	$(ELECTRON) app

interpreter:
	$(STACK) build


######################################################################
# Release targets

DIR_DARWIN=build/HyperHaskell-darwin-x64

pkg-darwin:
	mkdir -p build && electron-packager app \
		--out=build/ --overwrite \
		--platform=darwin --icon=resources/icons/icon.icns \
		--extend-info=resources/macOS-Info.plist \
		&& rm $(DIR_DARWIN)/LICENSE \
		&& cp resources/LICENSE.electron.txt $(DIR_DARWIN)/LICENSE.electron.txt \
		&& rm $(DIR_DARWIN)/version

zip:
	cd $(DIR_DARWIN) && zip -r ../HyperHaskell-v$(VERSION)-darwin-x64.zip *

hackage:
	$(STACK) sdist \
	&& $(STACK) upload --no-signature haskell/hyper \
	&& $(STACK) upload --no-signature haskell/hyper-extra \
	&& $(STACK) upload --no-signature haskell/hyper-haskell-server

