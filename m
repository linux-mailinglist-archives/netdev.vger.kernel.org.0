Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6371D686B
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 16:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgEQOZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 10:25:42 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:52847 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbgEQOZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 10:25:42 -0400
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id DE99B440428;
        Sun, 17 May 2020 17:25:38 +0300 (IDT)
References: <3e2c01449dc29bc3d138d3a19e0c2220495dd7ed.1589710856.git.baruch@tkos.co.il> <20200517103558.GT1551@shell.armlinux.org.uk>
User-agent: mu4e 1.4.4; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] drivers: net: mdio_bus: try indirect clause 45 regs access
In-reply-to: <20200517103558.GT1551@shell.armlinux.org.uk>
Date:   Sun, 17 May 2020 17:25:38 +0300
Message-ID: <87lflq3afx.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Sun, May 17 2020, Russell King - ARM Linux admin wrote:
> On Sun, May 17, 2020 at 01:20:56PM +0300, Baruch Siach wrote:
>> When the MDIO bus does not support directly clause 45 access, fallback
>> to indirect registers access method to read/write clause 45 registers
>> using clause 22 registers.
>> 
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>> ---
>> 
>> Is that the right course?
>> 
>> Currently, this does not really work on the my target machine, which is
>> using the Armada 385 native MDIO bus (mvmdio) connected to clause 45
>> Marvell 88E2110 PHY. Registers MDIO_DEVS1 and MDIO_DEVS1 read bogus
>> values which breaks PHY identification. However, the phytool utility
>> reads the same registers correctly:
>> 
>> phytool eth1/2:1/5
>> ieee-phy: reg:0x05 val:0x008a
>> 
>> eth1 is connected to another PHY (clause 22) on the same MDIO bus.
>> 
>> The same hardware works nicely with the mdio-gpio bus implementation,
>> when mdio pins are muxed as GPIOs.
>
> Not all C45 PHYs are required to provide C22.  I'm pretty sure that
> accessing a C45 PHY through the indirect method is likely something
> that isn't well tested with PHYs, so getting wrong device IDs doesn't
> surprise me.

The 88E2110 PHY datasheets mentions support for indirect C45 access
(FWIW: Rev B, section 3.9.3).

> Is there a reason to try switching back to mvmdio on this device?

No technical reason. U-Boot does not currently provide bit-band MDIO,
and hardware manufacturing testers would like to do their thing in
U-Boot, for some reason.

I just thought it would be nice to support C45 over C22 mdio if the
hardware allows that.

> Some comments on the patch:
>
>> ---
>>  drivers/net/phy/mdio_bus.c | 12 ++++++++++++
>>  drivers/net/phy/phy-core.c |  2 +-
>>  include/linux/phy.h        |  2 ++
>>  3 files changed, 15 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>> index 7a4eb3f2cb74..12e39f794b29 100644
>> --- a/drivers/net/phy/mdio_bus.c
>> +++ b/drivers/net/phy/mdio_bus.c
>> @@ -790,6 +790,12 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
>>  	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
>>  
>>  	retval = bus->read(bus, addr, regnum);
>> +	if (retval == -EOPNOTSUPP && regnum & MII_ADDR_C45) {
>> +		int c45_devad = (regnum >> 16) & 0x1f;
>> +
>> +		mmd_phy_indirect(bus, addr, c45_devad, regnum & 0xfff);
>> +		retval = bus->read(bus, addr, MII_MMD_DATA);
>> +	}
>
> I don't think this should be done at mdiobus level; I think this is a
> layering violation.  It needs to happen at the PHY level because the
> indirect C45 access via C22 registers is specific to PHYs.
>
> It also needs to check in the general case that the PHY does indeed
> support the C22 register set - not all C45 PHYs do.
>
> So, I think we want this fallback to be conditional on:
>
> - are we probing for the PHY, trying to read its IDs and
>   devices-in-package registers - if yes, allow fallback.
> - does the C45 PHY support the C22 register set - if yes, allow
>   fallback.

I'll take a look. Thanks.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
