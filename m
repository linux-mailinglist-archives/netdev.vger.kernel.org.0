Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7478C1D676E
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 12:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgEQKgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 06:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgEQKgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 06:36:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1B3C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 03:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=j5ZQXcz1r5cus5J4w59CqRGQmTlzFc/9sKCJMyIb4RM=; b=CkRuKSvoFmKzJBCXrJs2Kgl1/
        HUkksJYPrMO45ItZgOmPIB0eEuTj4jAHjvAhj2ujHefj84L3NOKQr3oCLW/CL101aSCTNmoZ9FlLs
        s2VBgZK8jcPnSzGEPTOi1ydabO58DtXw5UP/ElyyoMxk+CjyMmXWuSUN5lfr1L8ggGmKJKRjLwHhM
        1TJA1KBF+j5qgwXBAO1tBO81HAo/TsR/i67MDvzM0mpax7G/gHPtT4q33oJBhNuymK2V8BmwqAHYf
        FAtGlgAJ2iUUjYvOAMQ9cxjzWFXbswdbkFNA4NxZsedrJhrvX9lYdvYC8yJXw6xxKFZ/Q4f1u+u1X
        05UybqbnA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:41384)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jaGeG-0002wR-Nk; Sun, 17 May 2020 11:36:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jaGeE-0003c3-TB; Sun, 17 May 2020 11:35:58 +0100
Date:   Sun, 17 May 2020 11:35:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] drivers: net: mdio_bus: try indirect clause 45 regs
 access
Message-ID: <20200517103558.GT1551@shell.armlinux.org.uk>
References: <3e2c01449dc29bc3d138d3a19e0c2220495dd7ed.1589710856.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e2c01449dc29bc3d138d3a19e0c2220495dd7ed.1589710856.git.baruch@tkos.co.il>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 01:20:56PM +0300, Baruch Siach wrote:
> When the MDIO bus does not support directly clause 45 access, fallback
> to indirect registers access method to read/write clause 45 registers
> using clause 22 registers.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
> 
> Is that the right course?
> 
> Currently, this does not really work on the my target machine, which is
> using the Armada 385 native MDIO bus (mvmdio) connected to clause 45
> Marvell 88E2110 PHY. Registers MDIO_DEVS1 and MDIO_DEVS1 read bogus
> values which breaks PHY identification. However, the phytool utility
> reads the same registers correctly:
> 
> phytool eth1/2:1/5
> ieee-phy: reg:0x05 val:0x008a
> 
> eth1 is connected to another PHY (clause 22) on the same MDIO bus.
> 
> The same hardware works nicely with the mdio-gpio bus implementation,
> when mdio pins are muxed as GPIOs.

Not all C45 PHYs are required to provide C22.  I'm pretty sure that
accessing a C45 PHY through the indirect method is likely something
that isn't well tested with PHYs, so getting wrong device IDs doesn't
surprise me.  Is there a reason to try switching back to mvmdio on
this device?

Some comments on the patch:

> ---
>  drivers/net/phy/mdio_bus.c | 12 ++++++++++++
>  drivers/net/phy/phy-core.c |  2 +-
>  include/linux/phy.h        |  2 ++
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 7a4eb3f2cb74..12e39f794b29 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -790,6 +790,12 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
>  	WARN_ON_ONCE(!mutex_is_locked(&bus->mdio_lock));
>  
>  	retval = bus->read(bus, addr, regnum);
> +	if (retval == -EOPNOTSUPP && regnum & MII_ADDR_C45) {
> +		int c45_devad = (regnum >> 16) & 0x1f;
> +
> +		mmd_phy_indirect(bus, addr, c45_devad, regnum & 0xfff);
> +		retval = bus->read(bus, addr, MII_MMD_DATA);
> +	}

I don't think this should be done at mdiobus level; I think this is a
layering violation.  It needs to happen at the PHY level because the
indirect C45 access via C22 registers is specific to PHYs.

It also needs to check in the general case that the PHY does indeed
support the C22 register set - not all C45 PHYs do.

So, I think we want this fallback to be conditional on:

- are we probing for the PHY, trying to read its IDs and
  devices-in-package registers - if yes, allow fallback.
- does the C45 PHY support the C22 register set - if yes, allow
  fallback.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
