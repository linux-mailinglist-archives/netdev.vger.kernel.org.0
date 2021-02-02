Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1DF30C676
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236674AbhBBQts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236792AbhBBQsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:48:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378E9C06174A;
        Tue,  2 Feb 2021 08:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mkfxcZ4NHUETyjVwtkGuToIk8gnfSwi5q3L/t6Dx6Jk=; b=WiQAd1lIbSaJpYzJBrlGWSQfs
        33a0hPMKe+c+HRie4tUQudNxE6JQ02yQ5wX+02Vo+X+jTuwIA1QOAV+nNEDXtn5rSk8OQkbEN+A/N
        7XVX49CnmeXokHHVQqLQJbkVt9lJfrKCZp8XfiYMgVDYiCyo+fCPSn1GZE+XeceCYoWbkRAPEMS7M
        tzS21Ds3pCL2fsBXDz31I9bM4Ng9BLGxqnB6UhmycsqoDJTv69l3fwTgU0KZbvKdP9MAEZN3LoiZ9
        QBzr4aRU3V7Dj2pFRo74qSYsV8VmosLnGtyn5RPnZer/fQ1xHPygyDGHGkgrDrPUysVGA8pfHfLvR
        h6PBdVTew==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38284)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l6yqR-0004cJ-Gt; Tue, 02 Feb 2021 16:48:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l6yqQ-0003CO-0l; Tue, 02 Feb 2021 16:48:02 +0000
Date:   Tue, 2 Feb 2021 16:48:01 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, system@metrotek.ru, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <20210202164801.GN1463@shell.armlinux.org.uk>
References: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 10:22:51PM +0300, Ivan Bornyakov wrote:
> +/* PMD Transmit Disable */
> +#define	MV_TX_DISABLE		0x0009
> +#define	MV_TX_DISABLE_GLOBAL	BIT(0)

Please use MDIO_PMA_TXDIS and MDIO_PMD_TXDIS_GLOBAL; this is an
IEEE802.3 defined register.

> +/* 10GBASE-R PCS Status 1 */
> +#define	MV_10GBR_STAT		MDIO_STAT1

Nothing Marvell specific here, please use MDIO_STAT1 directly.

> +/* 1000Base-X/SGMII Control Register */
> +#define	MV_1GBX_CTRL		0x2000
> +
> +/* 1000BASE-X/SGMII Status Register */
> +#define	MV_1GBX_STAT		0x2001
> +
> +/* 1000Base-X Auto-Negotiation Advertisement Register */
> +#define	MV_1GBX_ADVERTISE	0x2004

Marvell have had a habbit of placing other PHY instances within the
register space. This also looks like Clause 22 layout rather than
Clause 45 layout - please use the Clause 22 definitions for the bits
rather than Clause 45. (so BMCR_ANENABLE, BMCR_ANRESTART for
MV_1GBX_CTRL, etc).

Please define these as:

+#define	MV_1GBX_CTRL		(0x2000 + MII_BMCR)
+#define	MV_1GBX_STAT		(0x2000 + MII_BMSR)
+#define	MV_1GBX_ADVERTISE	(0x2000 + MII_ADVERTISE)

to make it clear what is going on here.

> +static int sfp_module_insert(void *_priv, const struct sfp_eeprom_id *id)
> +{
> +	struct phy_device *phydev = _priv;
> +	struct device *dev = &phydev->mdio.dev;
> +	struct mv2222_data *priv = phydev->priv;
> +	phy_interface_t interface;
> +
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
> +
> +	sfp_parse_support(phydev->sfp_bus, id, supported);
> +	interface = sfp_select_interface(phydev->sfp_bus, supported);
> +
> +	dev_info(dev, "%s SFP module inserted", phy_modes(interface));
> +
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		phydev->speed = SPEED_10000;
> +		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
> +		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> +				 phydev->supported);
> +
> +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
> +		mv2222_soft_reset(phydev);
> +		break;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	default:
> +		phydev->speed = SPEED_1000;
> +		phydev->interface = PHY_INTERFACE_MODE_1000BASEX;
> +		linkmode_clear_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> +				   phydev->supported);
> +
> +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
> +		mv2222_soft_reset(phydev);
> +	}
> +
> +	priv->sfp_inserted = true;
> +
> +	if (priv->net_up)
> +		mv2222_tx_enable(phydev);

This is racy. priv->net_up is modified via the suspend/resume
callbacks, which are called with phydev->lock held. No other locks
are guaranteed to be held.

However, this function is called with the SFP sm_mutex, and rtnl
held. Consequently, the use of sfp_inserted and net_up in this
function and the suspend/resume callbacks is racy.

Why are you disabling the transmitter anyway? Is this for power
saving?

> +static void mv2222_update_interface(struct phy_device *phydev)
> +{
> +	if ((phydev->speed == SPEED_1000 ||
> +	     phydev->speed == SPEED_100 ||
> +	     phydev->speed == SPEED_10) &&
> +	    phydev->interface != PHY_INTERFACE_MODE_1000BASEX) {
> +		phydev->interface = PHY_INTERFACE_MODE_1000BASEX;
> +
> +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
> +		mv2222_soft_reset(phydev);
> +	} else if (phydev->speed == SPEED_10000 &&
> +		   phydev->interface != PHY_INTERFACE_MODE_10GBASER) {
> +		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
> +
> +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
> +		mv2222_soft_reset(phydev);
> +	}

This looks wrong. phydev->interface is the _host_ interface, which
you are clearly setting to XAUI here. Some network drivers depend
on this being correct (for instance, when used with the Marvell
88x3310 PHY which changes its host-side interface dynamically.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
