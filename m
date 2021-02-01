Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2145C30B303
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 23:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhBAW5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 17:57:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42674 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhBAW5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 17:57:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l6i6z-003iKw-Sn; Mon, 01 Feb 2021 23:56:01 +0100
Date:   Mon, 1 Feb 2021 23:56:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, system@metrotek.ru, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <YBiHAXSYWGO2weK6@lunn.ch>
References: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv2222_config_init(struct phy_device *phydev)
> +{
> +	linkmode_zero(phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT, phydev->supported);
> +
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;
> +	phydev->duplex = DUPLEX_FULL;
> +	phydev->autoneg = AUTONEG_DISABLE;
> +
> +	return 0;
> +}
> +
> +static void mv2222_update_interface(struct phy_device *phydev)
> +{
> +	if ((phydev->speed == SPEED_1000 ||
> +	     phydev->speed == SPEED_100 ||
> +	     phydev->speed == SPEED_10) &&
> +	    phydev->interface != PHY_INTERFACE_MODE_1000BASEX) {
> +		phydev->interface = PHY_INTERFACE_MODE_1000BASEX;

The speeds 10 and 100 seem odd here. 1000BaseX only supports 1G. It
would have to be SGMII in order to also support 10Mbps and 100Mbps.
Plus you are not listing 10 and 100 as a supported value.

> +/* Returns negative on error, 0 if link is down, 1 if link is up */
> +static int mv2222_read_status_1g(struct phy_device *phydev)
> +{
> +	int val, link = 0;
> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_STAT);
> +	if (val < 0)
> +		return val;
> +
> +	if (!(val & MDIO_STAT1_LSTATUS) ||
> +	    (phydev->autoneg == AUTONEG_ENABLE && !(val & MDIO_AN_STAT1_COMPLETE)))
> +		return 0;
> +
> +	link = 1;
> +
> +	if (phydev->autoneg == AUTONEG_DISABLE) {
> +		phydev->speed = SPEED_1000;
> +		phydev->duplex = DUPLEX_FULL;
> +
> +		return link;
> +	}
> +
> +	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_PHY_STAT);
> +	if (val < 0)
> +		return val;
> +
> +	if (val & MV_1GBX_PHY_STAT_AN_RESOLVED) {
> +		if (val & MV_1GBX_PHY_STAT_DUPLEX)
> +			phydev->duplex = DUPLEX_FULL;
> +		else
> +			phydev->duplex = DUPLEX_HALF;
> +
> +		if (val & MV_1GBX_PHY_STAT_SPEED1000)
> +			phydev->speed = SPEED_1000;
> +		else if (val & MV_1GBX_PHY_STAT_SPEED100)
> +			phydev->speed = SPEED_100;
> +		else
> +			phydev->speed = SPEED_10;

Are you sure it is not doing SGMII? Maybe it can do both, 1000BaseX
and SGMII? You would generally use 1000BaseX to connect to a fibre
SFP, and SGMII to connect to a copper SFP. So ideally you want to be
able to swap between these modes as needed.

> +static int mv2222_read_status(struct phy_device *phydev)
> +{
> +	int link;
> +
> +	linkmode_zero(phydev->lp_advertising);
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;
> +
> +	switch (phydev->interface) {
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		link = mv2222_read_status_10g(phydev);
> +		break;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	default:
> +		link = mv2222_read_status_1g(phydev);
> +		break;
> +	}
> +
> +	if (link < 0)
> +		return link;
> +
> +	phydev->link = link;
> +
> +	if (phydev->link)
> +		mv2222_link_led_on(phydev);
> +	else
> +		mv2222_link_led_off(phydev);

You have to manually control the LED? That is odd for a PHY. Normally
you just select a mode and it will do it all in hardware.

    Andrew
