Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5767E1C6E36
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgEFKTZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 6 May 2020 06:19:25 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:50207 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbgEFKTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 06:19:23 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 442881BF238;
        Wed,  6 May 2020 10:16:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200504213136.26458-4-michael@walle.cc>
References: <20200504213136.26458-1-michael@walle.cc> <20200504213136.26458-4-michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next v2 3/3] net: phy: mscc: use phy_package_shared
To:     Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Message-ID: <158876019421.468345.17020929384276599315@kwain>
Date:   Wed, 06 May 2020 12:16:35 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Michael,

Quoting Michael Walle (2020-05-04 23:31:36)
> 
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index 5391acdece05..a505286b2195 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> -static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
> +static void vsc8584_get_base_addr(struct phy_device *phydev)
>  {
> -       struct mii_bus *bus = phydev->mdio.bus;
> -       struct vsc8531_private *vsc8531;
> -       struct phy_device *phy;
> -       int i, addr;
> -
> -       /* VSC8584 is a Quad PHY */
> -       for (i = 0; i < 4; i++) {
> -               vsc8531 = phydev->priv;
> -
> -               if (reversed)
> -                       addr = vsc8531->base_addr - i;
> -               else
> -                       addr = vsc8531->base_addr + i;
> -
> -               phy = mdiobus_get_phy(bus, addr);
> -               if (!phy)
> -                       continue;
> +       struct vsc8531_private *vsc8531 = phydev->priv;
> +       u16 val, addr;
>  
> -               if ((phy->phy_id & phydev->drv->phy_id_mask) !=
> -                   (phydev->drv->phy_id & phydev->drv->phy_id_mask))
> -                       continue;
> +       mutex_lock(&phydev->mdio.bus->mdio_lock);
> +       __phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED);
>  
> -               vsc8531 = phy->priv;
> +       addr = __phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_4);
> +       addr >>= PHY_CNTL_4_ADDR_POS;
>  
> -               if (vsc8531 && vsc8531->pkg_init)
> -                       return true;
> -       }
> +       val = __phy_read(phydev, MSCC_PHY_ACTIPHY_CNTL);

You should restore the page to MSCC_PHY_PAGE_STANDARD here.

> +       mutex_unlock(&phydev->mdio.bus->mdio_lock);
>  
> -       return false;
> +       if (val & PHY_ADDR_REVERSED)
> +               vsc8531->base_addr = phydev->mdio.addr + addr;
> +       else
> +               vsc8531->base_addr = phydev->mdio.addr - addr;
>  }

Thanks for the series!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
