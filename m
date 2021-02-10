Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD1C315CA1
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhBJBxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:53:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59100 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234459AbhBJBwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 20:52:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9efG-005Dku-19; Wed, 10 Feb 2021 02:51:34 +0100
Date:   Wed, 10 Feb 2021 02:51:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: introduce phydev->port
Message-ID: <YCM8JiO4FfKx5ECo@lunn.ch>
References: <20210209163852.17037-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209163852.17037-1-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1552,6 +1552,7 @@ static int marvell_read_status_page(struct phy_device *phydev, int page)
>  	phydev->asym_pause = 0;
>  	phydev->speed = SPEED_UNKNOWN;
>  	phydev->duplex = DUPLEX_UNKNOWN;
> +	phydev->port = fiber ? PORT_FIBRE : PORT_TP;
>  
>  	if (phydev->autoneg == AUTONEG_ENABLE)
>  		err = marvell_read_status_page_an(phydev, fiber, status);

...

> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -308,7 +308,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
>  	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
>  		cmd->base.port = PORT_BNC;
>  	else
> -		cmd->base.port = PORT_MII;
> +		cmd->base.port = phydev->port;
>  	cmd->base.transceiver = phy_is_internal(phydev) ?
>  				XCVR_INTERNAL : XCVR_EXTERNAL;
>  	cmd->base.phy_address = phydev->mdio.addr;

This is a general comment, not a problem specific to this patch.

There is some interesting race conditions here. The marvell driver
first checks the fibre page and gets the status of the fiber port. As
you can see from the hunk above, it clears out pause, duplex, speed,
sets port to PORT_FIBRE, and then reads the PHY registers to set these
values. If link is not detected on the fibre, it swaps page and does
it all again, but for the copper port. So once per second,
phydev->port is going to flip flop PORT_FIBER->PORT_TP, if copper has
link.

Now, the read_status() call into the driver should be performed while
holding the phydev->lock. So to the PHY state machine, this flip/flop
does not matter, it is atomic with respect to the lock. But
phy_ethtool_ksettings_get() is not talking the lock. It could see
speed, duplex, and port while they have _UNKNOWN values, or port is
part way through a flip flop. I think we need to take the lock here.
phy_ethtool_ksettings_set() should also probably take the lock.

     Andrew
