Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AA7482B7B
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 15:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiABOM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 09:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiABOM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 09:12:57 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF503C061761;
        Sun,  2 Jan 2022 06:12:56 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id D446C4246F;
        Sun,  2 Jan 2022 14:12:45 +0000 (UTC)
Message-ID: <0efb9361-62da-f064-200a-eefe2d258b65@marcan.st>
Date:   Sun, 2 Jan 2022 23:12:42 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 01/34] dt-bindings: net: bcm4329-fmac: Add Apple
 properties & chips
Content-Language: en-US
To:     Mark Kettenis <mark.kettenis@xs4all.nl>
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
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-2-marcan@marcan.st>
 <YcnrjySZ9mPbkidZ@robh.at.kernel.org>
 <1e5e88a1-5457-2211-dc08-fe98415ae21b@marcan.st>
 <d3cb7aff430324ca@bloch.sibelius.xs4all.nl>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <d3cb7aff430324ca@bloch.sibelius.xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/12/30 1:38, Mark Kettenis wrote:
>> From: Hector Martin <marcan@marcan.st>
>> Date: Tue, 28 Dec 2021 02:23:02 +0900
>>
>> On 28/12/2021 01.36, Rob Herring wrote:
>>> On Mon, Dec 27, 2021 at 12:35:51AM +0900, Hector Martin wrote:
>>>> +  brcm,cal-blob:
>>>> +    $ref: /schemas/types.yaml#/definitions/uint8-array
>>>> +    description: A per-device calibration blob for the Wi-Fi radio. This
>>>> +      should be filled in by the bootloader from platform configuration
>>>> +      data, if necessary, and will be uploaded to the device if present.
>>>> +
>>>> +  apple,module-instance:
>>>> +    $ref: /schemas/types.yaml#/definitions/string
>>>> +    description: Module codename used to identify a specific board on
>>>> +      Apple platforms. This is used to build the firmware filenames, to allow
>>>> +      different platforms to have different firmware and/or NVRAM config.
>>>> +
>>>> +  apple,antenna-sku:
>>>> +    $def: /schemas/types.yaml#/definitions/string
>>>> +    description: Antenna SKU used to identify a specific antenna configuration
>>>> +      on Apple platforms. This is use to build firmware filenames, to allow
>>>> +      platforms with different antenna configs to have different firmware and/or
>>>> +      NVRAM. This would normally be filled in by the bootloader from platform
>>>> +      configuration data.
>>>
>>> Is there a known set of strings that can be defined?
>>
>> For apple,module-instance there is, though it will grow with every new
>> machine. If you're happy with me pushing updates to this through
>> asahi-soc I can keep it maintained as we add DTs and compatibles there.
>>
>> I'm curious whether you prefer this approach or something like
>> brcm,board-name instead. Right now we do:
>>
>> apple,module-instance = "honshu"
>>
>> That gets converted to board_name="apple,honshu" in the code, which is
>> what the firmwares are named after (plus extra info later appended, if
>> the rest of the Apple data is available).
>>
>> But we could also do:
>>
>> brcm,board-name = "apple,honshu"
>>
>> The latter would be more generically useful for other platforms, since
>> it would allow e.g. having DTs for different boards that use the same
>> WiFi module/subsystem and thus a compatible NVRAM fw file alias to the
>> same file name (right now this is done with symlinks in /lib/firmware,
>> one for each equivalent board). For non-Apple platforms (i.e. if
>> antenna-sku and/or the OTP aren't available to do the funky Apple
>> firmware selection), this just ends up replacing what would normally be
>> the OF root node compatible in the firmware filename.
>>
>> E.g. right now we have:
>>
>> brcmfmac43430-sdio.AP6212.txt
>> brcmfmac43430-sdio.raspberrypi,3-model-b.txt
>> brcmfmac43430-sdio.raspberrypi,model-zero-w.txt -> brcmfmac43430-sdio.raspberrypi,3-model-b.txt
>> brcmfmac43430-sdio.sinovoip,bpi-m2-plus.txt -> brcmfmac43430-sdio.AP6212.txt
>> brcmfmac43430-sdio.sinovoip,bpi-m2-ultra.txt -> brcmfmac43430-sdio.AP6212.txt
>> brcmfmac43430-sdio.sinovoip,bpi-m2-zero.txt -> brcmfmac43430-sdio.AP6212.txt
>> brcmfmac43430-sdio.sinovoip,bpi-m3.txt -> brcmfmac43430-sdio.AP6212.txt
>>
>> And this could allow the sinovoip.* DTs to say:
>> 	brcm,board-name = "AP6212";
>>
>> And the rPi zero one:
>> 	brcm,board-name = "raspberrypi,3-model-b";
>>
>> And avoid the symlinks.
>>
>> The antenna-sku thing is specific to the Apple firmware selection
>> process and doesn't make sense as a more generic property.
>>
>> antenna-sku right now always seems to be one of "ID", "X0", "X2", "X3",
>> though that could presumably change in the future. I can add this to the
>> binding if you want, though since this will be filled in by the
>> bootloader from platform data we wouldn't be validating it anyway. Not
>> sure if it's worth it.
> 
> Actually what Apple does here makes quite a bit of sense.  Typically
> WiFi chips are integrated with some analog components into a shielded
> module.  The AP6212 mentioned above is an example of such a module.  I
> suspect that the module defines some of the characteristics encoded in
> the "nvmram" files, but certainly not all because the connected
> antenna will also affect how the thing behaves.  Of course many SBCs
> come without an antenna so the actual antenna depends on whatever the
> user connects to the board.  So using a module-specific "nvram" file
> is probably the best one can do here.  So I think if you want to have
> a generic module name property, it should be called "brcm,module-name"
> instead of "brcm,board-name".  However...
> 
>>> There's also the somewhat standard 'firmware-name' property that
>>> serves similar purpose, but if there's multiple files, then I guess
>>> this approach is fine.
>>
>> Yeah, and the firmware name is constructed using non-DT information too
>> (and we have several attempted filenames times several firmware types),
>> so it wouldn't be complete.
> 
> ...if the way the firmware name is constructed remains Apple-specific
> because of this non-DT information, keeping the "apple,xxx" properties
> has the benefit of signalling that firmware names constructed this way
> are desired.  Or rather, their absence can signal that the
> Apple-specific code in the driver should be skipped.
> 

The current logic is that if all the information is available (OTP,
antenna-sku, board-name but that always gets filled in by default from
DT/DMI global info) it will use the Apple mechanism, otherwise it will
use the standard one. So in this case we could still use
brcm,board-name/module-name for Apple devices, and we'd keep
apple,antenna-sku as one of the two triggers to do Apple firmware
selection. Other devices may use nothing (use default DMI or DT device
name/compatible as module-name) or specify an override, and they will
still get firmwares with that name in them and a fallback to generic
firmware, which is the current behavior.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
