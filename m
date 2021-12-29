Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F91B481523
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 17:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240818AbhL2Qiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 11:38:55 -0500
Received: from sibelius.xs4all.nl ([83.163.83.176]:50849 "EHLO
        sibelius.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbhL2Qiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 11:38:54 -0500
Received: from localhost (bloch.sibelius.xs4all.nl [local])
        by bloch.sibelius.xs4all.nl (OpenSMTPD) with ESMTPA id 7e0a267d;
        Wed, 29 Dec 2021 17:38:51 +0100 (CET)
Date:   Wed, 29 Dec 2021 17:38:51 +0100 (CET)
From:   Mark Kettenis <mark.kettenis@xs4all.nl>
To:     Hector Martin <marcan@marcan.st>
Cc:     robh@kernel.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, rafael@kernel.org, lenb@kernel.org,
        aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, sven@svenpeter.dev, alyssa@rosenzweig.io,
        kettenis@openbsd.org, zajec5@gmail.com,
        pieter-paul.giesberts@broadcom.com, linus.walleij@linaro.org,
        hdegoede@redhat.com, linville@tuxdriver.com,
        sandals@crustytoothpaste.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
In-Reply-To: <1e5e88a1-5457-2211-dc08-fe98415ae21b@marcan.st> (message from
        Hector Martin on Tue, 28 Dec 2021 02:23:02 +0900)
Subject: Re: [PATCH 01/34] dt-bindings: net: bcm4329-fmac: Add Apple
 properties & chips
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-2-marcan@marcan.st>
 <YcnrjySZ9mPbkidZ@robh.at.kernel.org> <1e5e88a1-5457-2211-dc08-fe98415ae21b@marcan.st>
Message-ID: <d3cb7aff430324ca@bloch.sibelius.xs4all.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Hector Martin <marcan@marcan.st>
> Date: Tue, 28 Dec 2021 02:23:02 +0900
> 
> On 28/12/2021 01.36, Rob Herring wrote:
> > On Mon, Dec 27, 2021 at 12:35:51AM +0900, Hector Martin wrote:
> >> +  brcm,cal-blob:
> >> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> >> +    description: A per-device calibration blob for the Wi-Fi radio. This
> >> +      should be filled in by the bootloader from platform configuration
> >> +      data, if necessary, and will be uploaded to the device if present.
> >> +
> >> +  apple,module-instance:
> >> +    $ref: /schemas/types.yaml#/definitions/string
> >> +    description: Module codename used to identify a specific board on
> >> +      Apple platforms. This is used to build the firmware filenames, to allow
> >> +      different platforms to have different firmware and/or NVRAM config.
> >> +
> >> +  apple,antenna-sku:
> >> +    $def: /schemas/types.yaml#/definitions/string
> >> +    description: Antenna SKU used to identify a specific antenna configuration
> >> +      on Apple platforms. This is use to build firmware filenames, to allow
> >> +      platforms with different antenna configs to have different firmware and/or
> >> +      NVRAM. This would normally be filled in by the bootloader from platform
> >> +      configuration data.
> > 
> > Is there a known set of strings that can be defined?
> 
> For apple,module-instance there is, though it will grow with every new
> machine. If you're happy with me pushing updates to this through
> asahi-soc I can keep it maintained as we add DTs and compatibles there.
> 
> I'm curious whether you prefer this approach or something like
> brcm,board-name instead. Right now we do:
> 
> apple,module-instance = "honshu"
> 
> That gets converted to board_name="apple,honshu" in the code, which is
> what the firmwares are named after (plus extra info later appended, if
> the rest of the Apple data is available).
> 
> But we could also do:
> 
> brcm,board-name = "apple,honshu"
> 
> The latter would be more generically useful for other platforms, since
> it would allow e.g. having DTs for different boards that use the same
> WiFi module/subsystem and thus a compatible NVRAM fw file alias to the
> same file name (right now this is done with symlinks in /lib/firmware,
> one for each equivalent board). For non-Apple platforms (i.e. if
> antenna-sku and/or the OTP aren't available to do the funky Apple
> firmware selection), this just ends up replacing what would normally be
> the OF root node compatible in the firmware filename.
> 
> E.g. right now we have:
> 
> brcmfmac43430-sdio.AP6212.txt
> brcmfmac43430-sdio.raspberrypi,3-model-b.txt
> brcmfmac43430-sdio.raspberrypi,model-zero-w.txt -> brcmfmac43430-sdio.raspberrypi,3-model-b.txt
> brcmfmac43430-sdio.sinovoip,bpi-m2-plus.txt -> brcmfmac43430-sdio.AP6212.txt
> brcmfmac43430-sdio.sinovoip,bpi-m2-ultra.txt -> brcmfmac43430-sdio.AP6212.txt
> brcmfmac43430-sdio.sinovoip,bpi-m2-zero.txt -> brcmfmac43430-sdio.AP6212.txt
> brcmfmac43430-sdio.sinovoip,bpi-m3.txt -> brcmfmac43430-sdio.AP6212.txt
> 
> And this could allow the sinovoip.* DTs to say:
> 	brcm,board-name = "AP6212";
> 
> And the rPi zero one:
> 	brcm,board-name = "raspberrypi,3-model-b";
> 
> And avoid the symlinks.
> 
> The antenna-sku thing is specific to the Apple firmware selection
> process and doesn't make sense as a more generic property.
> 
> antenna-sku right now always seems to be one of "ID", "X0", "X2", "X3",
> though that could presumably change in the future. I can add this to the
> binding if you want, though since this will be filled in by the
> bootloader from platform data we wouldn't be validating it anyway. Not
> sure if it's worth it.

Actually what Apple does here makes quite a bit of sense.  Typically
WiFi chips are integrated with some analog components into a shielded
module.  The AP6212 mentioned above is an example of such a module.  I
suspect that the module defines some of the characteristics encoded in
the "nvmram" files, but certainly not all because the connected
antenna will also affect how the thing behaves.  Of course many SBCs
come without an antenna so the actual antenna depends on whatever the
user connects to the board.  So using a module-specific "nvram" file
is probably the best one can do here.  So I think if you want to have
a generic module name property, it should be called "brcm,module-name"
instead of "brcm,board-name".  However...

> > There's also the somewhat standard 'firmware-name' property that
> > serves similar purpose, but if there's multiple files, then I guess
> > this approach is fine.
> 
> Yeah, and the firmware name is constructed using non-DT information too
> (and we have several attempted filenames times several firmware types),
> so it wouldn't be complete.

...if the way the firmware name is constructed remains Apple-specific
because of this non-DT information, keeping the "apple,xxx" properties
has the benefit of signalling that firmware names constructed this way
are desired.  Or rather, their absence can signal that the
Apple-specific code in the driver should be skipped.
