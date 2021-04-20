Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800C1364FFD
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 03:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhDTBrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 21:47:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59350 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229528AbhDTBrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 21:47:52 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lYfU0-0001e8-FE; Tue, 20 Apr 2021 03:47:20 +0200
Date:   Tue, 20 Apr 2021 03:47:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>
Subject: Re: [PATCH 3/3] net: ethernet: ixp4xx: Use OF MDIO bus registration
Message-ID: <YH4yqLn6llQdLVax@lunn.ch>
References: <20210419225133.2005360-1-linus.walleij@linaro.org>
 <20210419225133.2005360-3-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419225133.2005360-3-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1381,25 +1382,12 @@ static struct eth_plat_info *ixp4xx_of_get_platdata(struct device *dev)
>  	/* NPE ID 0x00, 0x10, 0x20... */
>  	plat->npe = (val << 4);
>  
> -	phy_np = of_parse_phandle(np, "phy-handle", 0);
> -	if (phy_np) {
> -		ret = of_property_read_u32(phy_np, "reg", &val);
> -		if (ret) {
> -			dev_err(dev, "cannot find phy reg\n");
> -			return NULL;
> -		}
> -		of_node_put(phy_np);
> -	} else {
> -		dev_err(dev, "cannot find phy instance\n");
> -		val = 0;
> -	}
> -	plat->phy = val;
> -

Isn't this code you just added in the previous patch?

>  	/* Check if this device has an MDIO bus */
>  	mdio_np = of_get_child_by_name(np, "mdio");
>  	if (mdio_np) {
>  		plat->has_mdio = true;
> -		of_node_put(mdio_np);
> +		mdio_bus_np = mdio_np;
> +		/* DO NOT put the mdio_np, it will be used */
>  	}
>  
>  	/* Get the rx queue as a resource from queue manager */
> @@ -1539,10 +1527,14 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
>  	__raw_writel(DEFAULT_CORE_CNTRL, &port->regs->core_control);
>  	udelay(50);
>  
> -	snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
> -		 mdio_bus->id, plat->phy);
> -	phydev = phy_connect(ndev, phy_id, &ixp4xx_adjust_link,
> -			     PHY_INTERFACE_MODE_MII);
> +	if (np) {
> +		phydev = of_phy_get_and_connect(ndev, np, ixp4xx_adjust_link);
> +	} else {
> +		snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
> +			 mdio_bus->id, plat->phy);

mdiobus_get_phy() and phy_connect_direct() might be better.

	  Andrew
