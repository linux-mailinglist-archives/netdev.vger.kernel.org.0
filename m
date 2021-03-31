Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BBC350478
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhCaQ2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:28:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56500 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232319AbhCaQ1t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:27:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRdgv-00ECMX-OU; Wed, 31 Mar 2021 18:27:37 +0200
Date:   Wed, 31 Mar 2021 18:27:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Danilo Krummrich <danilokrummrich@dk-develop.de>
Cc:     linux@armlinux.org.uk, davem@davemloft.net, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YGSi+b/r4zlq9rm8@lunn.ch>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331141755.126178-3-danilokrummrich@dk-develop.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -670,19 +670,21 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
>  	struct phy_device *phydev = ERR_PTR(-ENODEV);
>  	int err;
>  
> +	/* In case of NO_CAP and C22 only, we still can try to scan for C45
> +	 * devices, since indirect access will be used for busses that are not
> +	 * capable of C45 frame format.
> +	 */
>  	switch (bus->capabilities) {
>  	case MDIOBUS_NO_CAP:
>  	case MDIOBUS_C22:
> -		phydev = get_phy_device(bus, addr, false);
> -		break;
> -	case MDIOBUS_C45:
> -		phydev = get_phy_device(bus, addr, true);
> -		break;
>  	case MDIOBUS_C22_C45:
>  		phydev = get_phy_device(bus, addr, false);
>  		if (IS_ERR(phydev))
>  			phydev = get_phy_device(bus, addr, true);
>  		break;
> +	case MDIOBUS_C45:
> +		phydev = get_phy_device(bus, addr, true);
> +		break;
>  	}

I think this is going to cause problems.

commit 0231b1a074c672f8c00da00a57144072890d816b
Author: Kevin Hao <haokexin@gmail.com>
Date:   Tue Mar 20 09:44:53 2018 +0800

    net: phy: realtek: Use the dummy stubs for MMD register access for rtl8211b
    
    The Ethernet on mpc8315erdb is broken since commit b6b5e8a69118
    ("gianfar: Disable EEE autoneg by default"). The reason is that
    even though the rtl8211b doesn't support the MMD extended registers
    access, it does return some random values if we trying to access
    the MMD register via indirect method. This makes it seem that the
    EEE is supported by this phy device. And the subsequent writing to
    the MMD registers does cause the phy malfunction. So use the dummy
    stubs for the MMD register access to fix this issue.

Indirect access to C45 via C22 is not a guaranteed part of C22. So
there are C22 only PHYs which return random junk when you try to use
this access method.

I'm also a bit confused why this is actually needed. PHY drivers which
make use of C45 use the functions phy_read_mmd(), phy_write_mmd().

int __phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum)
{
	int val;

	if (regnum > (u16)~0 || devad > 32)
		return -EINVAL;

	if (phydev->drv && phydev->drv->read_mmd) {
		val = phydev->drv->read_mmd(phydev, devad, regnum);
	} else if (phydev->is_c45) {
		val = __mdiobus_c45_read(phydev->mdio.bus, phydev->mdio.addr,
					 devad, regnum);
	} else {
		struct mii_bus *bus = phydev->mdio.bus;
		int phy_addr = phydev->mdio.addr;

		mmd_phy_indirect(bus, phy_addr, devad, regnum);

		/* Read the content of the MMD's selected register */
		val = __mdiobus_read(bus, phy_addr, MII_MMD_DATA);
	}
	return val;
}

So if the device is a c45 device, C45 transfers are used, otherwise it
falls back to mmd_phy_indirect(), which is C45 over C22.

Why does this not work for you?

    Andrew
