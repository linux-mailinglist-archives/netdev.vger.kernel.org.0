Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED3A2A6C7D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 19:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730323AbgKDSJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 13:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728403AbgKDSJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 13:09:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21266C0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 10:09:40 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kaNDk-0007Ga-Ve; Wed, 04 Nov 2020 19:09:20 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kaNDj-00049W-SI; Wed, 04 Nov 2020 19:09:19 +0100
Date:   Wed, 4 Nov 2020 19:09:19 +0100
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
Subject: Re: [PATCH net-next v2 04/19] net: phy: at803x: implement generic
 .handle_interrupt() callback
Message-ID: <20201104180919.ytvsekksjcldpkqd@pengutronix.de>
References: <20201101125114.1316879-1-ciorneiioana@gmail.com>
 <20201101125114.1316879-5-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201101125114.1316879-5-ciorneiioana@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:08:44 up 355 days,  9:27, 376 users,  load average: 0.07, 0.06,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 02:50:59PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> In an attempt to actually support shared IRQs in phylib, we now move the
> responsibility of triggering the phylib state machine or just returning
> IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
> 3 different IRQ handling callbacks (.handle_interrupt(),
> .did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
> driver implement directly an IRQ handler like any other device driver.
> Make this driver follow the new convention.
> 
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: Michael Walle <michael@walle.cc>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
> Changes in v2:
>  - adjust .handle_interrupt() so that we only take into account the
>    enabled IRQs.
> 
>  drivers/net/phy/at803x.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index ed601a7e46a0..c7f91934cf82 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -628,6 +628,32 @@ static int at803x_config_intr(struct phy_device *phydev)
>  	return err;
>  }
>  
> +static irqreturn_t at803x_handle_interrupt(struct phy_device *phydev)
> +{
> +	int irq_status, int_enabled;
> +
> +	irq_status = phy_read(phydev, AT803X_INTR_STATUS);
> +	if (irq_status < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	/* Read the current enabled interrupts */
> +	int_enabled = phy_read(phydev, AT803X_INTR_ENABLE);
> +	if (int_enabled < 0) {
> +		phy_error(phydev);
> +		return IRQ_NONE;
> +	}
> +
> +	/* See if this was one of our enabled interrupts */
> +	if (!(irq_status & int_enabled))
> +		return IRQ_NONE;
> +
> +	phy_trigger_machine(phydev);
> +
> +	return IRQ_HANDLED;
> +}
> +
>  static void at803x_link_change_notify(struct phy_device *phydev)
>  {
>  	/*
> @@ -1064,6 +1090,7 @@ static struct phy_driver at803x_driver[] = {
>  	.read_status		= at803x_read_status,
>  	.ack_interrupt		= at803x_ack_interrupt,
>  	.config_intr		= at803x_config_intr,
> +	.handle_interrupt	= at803x_handle_interrupt,
>  	.get_tunable		= at803x_get_tunable,
>  	.set_tunable		= at803x_set_tunable,
>  	.cable_test_start	= at803x_cable_test_start,
> @@ -1084,6 +1111,7 @@ static struct phy_driver at803x_driver[] = {
>  	/* PHY_BASIC_FEATURES */
>  	.ack_interrupt		= at803x_ack_interrupt,
>  	.config_intr		= at803x_config_intr,
> +	.handle_interrupt	= at803x_handle_interrupt,
>  }, {
>  	/* Qualcomm Atheros AR8031/AR8033 */
>  	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
> @@ -1102,6 +1130,7 @@ static struct phy_driver at803x_driver[] = {
>  	.aneg_done		= at803x_aneg_done,
>  	.ack_interrupt		= &at803x_ack_interrupt,
>  	.config_intr		= &at803x_config_intr,
> +	.handle_interrupt	= at803x_handle_interrupt,
>  	.get_tunable		= at803x_get_tunable,
>  	.set_tunable		= at803x_set_tunable,
>  	.cable_test_start	= at803x_cable_test_start,
> @@ -1122,6 +1151,7 @@ static struct phy_driver at803x_driver[] = {
>  	/* PHY_BASIC_FEATURES */
>  	.ack_interrupt		= at803x_ack_interrupt,
>  	.config_intr		= at803x_config_intr,
> +	.handle_interrupt	= at803x_handle_interrupt,
>  	.cable_test_start	= at803x_cable_test_start,
>  	.cable_test_get_status	= at803x_cable_test_get_status,
>  }, {
> @@ -1134,6 +1164,7 @@ static struct phy_driver at803x_driver[] = {
>  	/* PHY_BASIC_FEATURES */
>  	.ack_interrupt		= &at803x_ack_interrupt,
>  	.config_intr		= &at803x_config_intr,
> +	.handle_interrupt	= at803x_handle_interrupt,
>  	.cable_test_start	= at803x_cable_test_start,
>  	.cable_test_get_status	= at803x_cable_test_get_status,
>  	.read_status		= at803x_read_status,
> -- 
> 2.28.0
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
