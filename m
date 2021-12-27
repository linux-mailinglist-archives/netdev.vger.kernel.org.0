Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB8D47FC5C
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 12:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhL0Lxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 06:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbhL0Lxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 06:53:31 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073DBC06173E;
        Mon, 27 Dec 2021 03:53:30 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 51CFA419BC;
        Mon, 27 Dec 2021 11:53:20 +0000 (UTC)
Subject: Re: [RFC PATCH 00/34] brcmfmac: Support Apple T2 and M1 platforms
To:     Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        Rafa?? Mi??ecki <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226191728.GA687@wunner.de>
 <06e801a0-7580-48ed-cac2-227c32a74ec2@redhat.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <0a028b79-01eb-b69f-79b2-c9588dd31ad1@marcan.st>
Date:   Mon, 27 Dec 2021 20:53:14 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <06e801a0-7580-48ed-cac2-227c32a74ec2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/12/27 6:42, Hans de Goede wrote:
> Hi,
> 
> On 12/26/21 20:17, Lukas Wunner wrote:
>> On Mon, Dec 27, 2021 at 12:35:50AM +0900, Hector Martin wrote:
>>> # On firmware
>>>
>>> As you might expect, the firmware for these machines is not available
>>> under a redistributable license; however, every owner of one of these
>>> machines *is* implicitly licensed to posess the firmware, and the OS
>>> packages containing it are available under well-known URLs on Apple's
>>> CDN with no authentication.
>>
>> Apple's EFI firmware contains a full-fledged network stack for
>> downloading macOS images from osrecovery.apple.com.  I suspect
>> that it also contains wifi firmware.
>>
>> You may want to check if it's passed to the OS as an EFI property.
>> Using that would sidestep license issues.  There's EDID data,
>> Thunderbolt DROM data and whatnot in those properties, so I
>> wouldn't be surprised if it contained wifi stuff as well.
>>
>> Enable CONFIG_APPLE_PROPERTIES and pass "dump_apple_properties"
>> on the command line to see all EFI properties in dmesg.
>> Alternatively, check "ioreg -l" on macOS.  Generally, what's
>> available in the I/O registry should also be available on Linux
>> either as an ACPI or EFI property.
> 
> Interesting, note that even if the files are not available as
> a property we also have CONFIG_EFI_EMBEDDED_FIRMWARE, see:
> 
> drivers/firmware/efi/embedded-firmware.c
> Documentation/driver-api/firmware/fallback-mechanisms.rst
> 
> I wrote this to pry/dig out some touchscreen firmwares (where
> we have been unable to get permission to redistribute) out of
> EFI boot_services_code mem regions on tablets where
> the touchsceen is supported under the EFI environment.
> 
> This may need some tweaks, but if there is an embedded copy
> of the firmware files in the EFI mem regions somewhere it
> should be possible to adjust this code to grab it and present
> it to the firmware-loader mechanism as a fallback option.

Note that this wouldn't work on M1 Macs anyway, since those don't have
EFI (we provide EFI via U-Boot as a chained bootloader on those), and
their bootloader doesn't support any networking (it doesn't even do USB
or any kind of UI).

Quick recap for those not familiar with the M1 boot process: the
bootloader is iBoot, which is extremely simple (at least compared to
EFI). All it can do is boot kernels from APFS volumes on internal NVMe.
The boot selection menu and recovery options are implemented as macOS
apps running from a recovery image (~1GB), and "USB boot" is implemented
by copying the macOS equivalent of /boot to NVMe. There is a global
recovery image as well as per-OS recovery image. The WiFi firmware is
present in this image as well as on normal macOS root volumes.

Our Linux install script is actually mostly a macOS install script that
sets up all the boot components that macOS would normally have,
including the recovery image, minus the main root filesystem. This is
all required to work properly within Apple's security and multi-boot
framework. So, since we're installing the recovery image, we're already
in an easy position to pull the firmware out and stick it in the EFI
partition for Linux to easily use. The alternative would be for Linux
userspace to read it from APFS directly, but that seems unlikely to be
practical until linux-apfs is upstreamed.

For T2 Macs I'm sure the firmware will be in EFI somewhere, but even if
we can get it from there (I wouldn't be surprised if it's e.g. still
compressed in the normal boot path that doesn't start network services),
I'm not sure it's worth implementing yet another mechanism for those
machines. Once we have the vendor-firmware mechanism implemented for M1,
it's easy to just run the same script on T2s and get the proper firmware
from macOS (which might even be different from the EFI firmware...).
macOS definitely doesn't read the firmware from EFI on those machines,
so a hack to do it by scanning the code would probably not be something
we can rely on to continue working across firmware updates (and they do
update WiFi firmware; it's a rather well known source of security
issues... so then we'd have to play the update-the-sha256 cat and mouse
game). I'm pretty sure there's no property containing the big firmware
blob passed explicitly to the OS; it has its own copy.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
