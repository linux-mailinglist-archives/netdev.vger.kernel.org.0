Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312F32A6C80
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 19:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730386AbgKDSJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 13:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728380AbgKDSJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 13:09:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77993C0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 10:09:55 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kaNEE-0007Hl-Ee; Wed, 04 Nov 2020 19:09:50 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kaNEE-00049j-16; Wed, 04 Nov 2020 19:09:50 +0100
Date:   Wed, 4 Nov 2020 19:09:50 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next v2 05/19] net: phy: at803x: remove the use of
 .ack_interrupt()
Message-ID: <20201104180950.p4bqar7v36aougcz@pengutronix.de>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
 <20201101125114.1316879-6-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201101125114.1316879-6-ciorneiioana@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:09:27 up 355 days,  9:28, 376 users,  load average: 0.03, 0.05,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 02:51:00PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> In preparation of removing the .ack_interrupt() callback, we must replace
> its occurrences (aka phy_clear_interrupt), from the 2 places where it is
> called from (phy_enable_interrupts and phy_disable_interrupts), with
> equivalent functionality.
> 
> This means that clearing interrupts now becomes something that the PHY
> driver is responsible of doing, before enabling interrupts and after
> clearing them. Make this driver follow the new contract.
> 
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Michael Walle <michael@walle.cc>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
> Changes in v2:
>  - none
> 
>  drivers/net/phy/at803x.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index c7f91934cf82..d0b36fd6c265 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -614,6 +614,11 @@ static int at803x_config_intr(struct phy_device *phydev)
>  	value = phy_read(phydev, AT803X_INTR_ENABLE);
>  
>  	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		/* Clear any pending interrupts */
> +		err = at803x_ack_interrupt(phydev);
> +		if (err)
> +			return err;
> +
>  		value |= AT803X_INTR_ENABLE_AUTONEG_ERR;
>  		value |= AT803X_INTR_ENABLE_SPEED_CHANGED;
>  		value |= AT803X_INTR_ENABLE_DUPLEX_CHANGED;
> @@ -621,9 +626,14 @@ static int at803x_config_intr(struct phy_device *phydev)
>  		value |= AT803X_INTR_ENABLE_LINK_SUCCESS;
>  
>  		err = phy_write(phydev, AT803X_INTR_ENABLE, value);
> -	}
> -	else
> +	} else {
>  		err = phy_write(phydev, AT803X_INTR_ENABLE, 0);
> +		if (err)
> +			return err;
> +
> +		/* Clear any pending interrupts */
> +		err = at803x_ack_interrupt(phydev);
> +	}
>  
>  	return err;
>  }
> @@ -1088,7 +1098,6 @@ static struct phy_driver at803x_driver[] = {
>  	.resume			= at803x_resume,
>  	/* PHY_GBIT_FEATURES */
>  	.read_status		= at803x_read_status,
> -	.ack_interrupt		= at803x_ack_interrupt,
>  	.config_intr		= at803x_config_intr,
>  	.handle_interrupt	= at803x_handle_interrupt,
>  	.get_tunable		= at803x_get_tunable,
> @@ -1109,7 +1118,6 @@ static struct phy_driver at803x_driver[] = {
>  	.suspend		= at803x_suspend,
>  	.resume			= at803x_resume,
>  	/* PHY_BASIC_FEATURES */
> -	.ack_interrupt		= at803x_ack_interrupt,
>  	.config_intr		= at803x_config_intr,
>  	.handle_interrupt	= at803x_handle_interrupt,
>  }, {
> @@ -1128,7 +1136,6 @@ static struct phy_driver at803x_driver[] = {
>  	/* PHY_GBIT_FEATURES */
>  	.read_status		= at803x_read_status,
>  	.aneg_done		= at803x_aneg_done,
> -	.ack_interrupt		= &at803x_ack_interrupt,
>  	.config_intr		= &at803x_config_intr,
>  	.handle_interrupt	= at803x_handle_interrupt,
>  	.get_tunable		= at803x_get_tunable,
> @@ -1149,7 +1156,6 @@ static struct phy_driver at803x_driver[] = {
>  	.suspend		= at803x_suspend,
>  	.resume			= at803x_resume,
>  	/* PHY_BASIC_FEATURES */
> -	.ack_interrupt		= at803x_ack_interrupt,
>  	.config_intr		= at803x_config_intr,
>  	.handle_interrupt	= at803x_handle_interrupt,
>  	.cable_test_start	= at803x_cable_test_start,
> @@ -1162,7 +1168,6 @@ static struct phy_driver at803x_driver[] = {
>  	.resume			= at803x_resume,
>  	.flags			= PHY_POLL_CABLE_TEST,
>  	/* PHY_BASIC_FEATURES */
> -	.ack_interrupt		= &at803x_ack_interrupt,
>  	.config_intr		= &at803x_config_intr,
>  	.handle_interrupt	= at803x_handle_interrupt,
>  	.cable_test_start	= at803x_cable_test_start,
> -- 
> 2.28.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
