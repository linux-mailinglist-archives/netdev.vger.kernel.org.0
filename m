Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C118919A48A
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 07:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbgDAFOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 01:14:14 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:52450 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgDAFOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 01:14:14 -0400
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 3D3AC440953;
        Wed,  1 Apr 2020 08:14:12 +0300 (IDT)
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il> <8f4ecf61-ed50-9de6-f20a-0ade5f3dcb9a@gmail.com>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Shmuel Hazan <sh@tkos.co.il>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
In-reply-to: <8f4ecf61-ed50-9de6-f20a-0ade5f3dcb9a@gmail.com>
Date:   Wed, 01 Apr 2020 08:14:11 +0300
Message-ID: <87369ndbz0.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Tue, Mar 31 2020, Heiner Kallweit wrote:
> On 31.03.2020 19:47, Baruch Siach wrote:
>> When Marvell 88X3310 and 88E2110 hardware configuration SPI_CONFIG strap
>> bit is pulled up, the host must load firmware to the PHY after reset.
>> Add support for loading firmware.
>>
>> Firmware files are available from Marvell under NDA.
>>
>
> Loading firmware files that are available under NDA only in GPL-licensed
> code may be problematic. I'd expect firmware files to be available in
> linux-firmware at least.
> I'd be interested in how the other phylib maintainers see this.

The inside-secure crypto acceleration driver
(drivers/crypto/inside-secure/) original had only NDA firmware.

> Two more remarks inline.
>
> Last but not least:
> The patch should have been annotated "net-next", and net-next is closed currently.
>
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

[...]

>> +	if ((ret & MV_PMA_BOOT_PROGRESS_MASK) == MV_PMA_BOOT_WAITING) {
>> +		ret = mv3310_load_firmware(phydev);
>> +		if (ret < 0)
>> +			return ret;
>
> You bail out from probe if a firmware file can't be loaded that is
> available under NDA only. That doesn't seem to be too nice.

The code verifies that the PHY is in MV_PMA_BOOT_WAITING state. The PHY
is not usable in this state unless the firmware is loaded. This is just
like the MV_PMA_BOOT_FATAL error in the code above.

In the common case of firmware loaded from SPI flash, the code will not
try to load the firmware.

baruch

>
>> +	}
>> +
>>  	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
>>  	if (!priv)
>>  		return -ENOMEM;
>>

--
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
