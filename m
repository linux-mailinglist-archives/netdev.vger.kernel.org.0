Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A5230CD46
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhBBUrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:47:23 -0500
Received: from mail.pr-group.ru ([178.18.215.3]:56905 "EHLO mail.pr-group.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233670AbhBBUqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 15:46:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:in-reply-to:
         references;
        bh=d6Gf6bpcd2ONz4bqdbBBUk6IulH2fvKA9lG3RuRv53A=;
        b=AZEEyR1I5gO2y1jVj6jq0UipFYPaeC+3YtvNMmvEi+j63AO6L6PkVLV9ZL0CTOdBaUWki7XzYhoBD
         CSRiTnH9jnFZYv34TBqEFtM/mgnrNZQMygwIScET76jzt5Z+y6eZNIuA2oQ1v9FVFh/Jct4/V7IXmF
         Jo07JT3vOA6f2MEj0Bw+0OIuWYvzaHAhLWaHJLT1Sis+JT1EhA4QLz09MKE9bwJogAhFvby8bf6qH8
         M/RMjs2Eq86Doy1hJgPSSkY2ymbU769yxELPjHan08Vo5P8wxCRKBC3fEViDWjdURdeUOa6djvR3/A
         4+RlTajWOCuqu2mvkpnEGuEi77Ukdqw==
X-Spam-Status: No, hits=0.0 required=3.4
        tests=AWL: 0.000, BAYES_00: -1.665, CUSTOM_RULE_FROM: ALLOW,
        TOTAL_SCORE: -1.665,autolearn=ham
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from dhcp-179.ddg ([85.143.252.66])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Tue, 2 Feb 2021 23:45:42 +0300
Date:   Tue, 2 Feb 2021 23:45:22 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, system@metrotek.ru, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <20210202204522.4dwyfsshtzxvh2p7@dhcp-179.ddg>
References: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
 <20210202164801.GN1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202164801.GN1463@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 04:48:01PM +0000, Russell King - ARM Linux admin wrote:
> On Mon, Feb 01, 2021 at 10:22:51PM +0300, Ivan Bornyakov wrote:
> > +/* PMD Transmit Disable */
> > +#define	MV_TX_DISABLE		0x0009
> > +#define	MV_TX_DISABLE_GLOBAL	BIT(0)
> 
> Please use MDIO_PMA_TXDIS and MDIO_PMD_TXDIS_GLOBAL; this is an
> IEEE802.3 defined register.
> 
> > +/* 10GBASE-R PCS Status 1 */
> > +#define	MV_10GBR_STAT		MDIO_STAT1
> 
> Nothing Marvell specific here, please use MDIO_STAT1 directly.
> 
> > +/* 1000Base-X/SGMII Control Register */
> > +#define	MV_1GBX_CTRL		0x2000
> > +
> > +/* 1000BASE-X/SGMII Status Register */
> > +#define	MV_1GBX_STAT		0x2001
> > +
> > +/* 1000Base-X Auto-Negotiation Advertisement Register */
> > +#define	MV_1GBX_ADVERTISE	0x2004
> 
> Marvell have had a habbit of placing other PHY instances within the
> register space. This also looks like Clause 22 layout rather than
> Clause 45 layout - please use the Clause 22 definitions for the bits
> rather than Clause 45. (so BMCR_ANENABLE, BMCR_ANRESTART for
> MV_1GBX_CTRL, etc).
> 
> Please define these as:
> 
> +#define	MV_1GBX_CTRL		(0x2000 + MII_BMCR)
> +#define	MV_1GBX_STAT		(0x2000 + MII_BMSR)
> +#define	MV_1GBX_ADVERTISE	(0x2000 + MII_ADVERTISE)
> 
> to make it clear what is going on here.
> 
> > +static int sfp_module_insert(void *_priv, const struct sfp_eeprom_id *id)
> > +{
> > +	struct phy_device *phydev = _priv;
> > +	struct device *dev = &phydev->mdio.dev;
> > +	struct mv2222_data *priv = phydev->priv;
> > +	phy_interface_t interface;
> > +
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
> > +
> > +	sfp_parse_support(phydev->sfp_bus, id, supported);
> > +	interface = sfp_select_interface(phydev->sfp_bus, supported);
> > +
> > +	dev_info(dev, "%s SFP module inserted", phy_modes(interface));
> > +
> > +	switch (interface) {
> > +	case PHY_INTERFACE_MODE_10GBASER:
> > +		phydev->speed = SPEED_10000;
> > +		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
> > +		linkmode_set_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> > +				 phydev->supported);
> > +
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> > +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
> > +		mv2222_soft_reset(phydev);
> > +		break;
> > +	case PHY_INTERFACE_MODE_1000BASEX:
> > +	default:
> > +		phydev->speed = SPEED_1000;
> > +		phydev->interface = PHY_INTERFACE_MODE_1000BASEX;
> > +		linkmode_clear_bit(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
> > +				   phydev->supported);
> > +
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> > +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
> > +		mv2222_soft_reset(phydev);
> > +	}
> > +
> > +	priv->sfp_inserted = true;
> > +
> > +	if (priv->net_up)
> > +		mv2222_tx_enable(phydev);
> 
> This is racy. priv->net_up is modified via the suspend/resume
> callbacks, which are called with phydev->lock held. No other locks
> are guaranteed to be held.
> 
> However, this function is called with the SFP sm_mutex, and rtnl
> held. Consequently, the use of sfp_inserted and net_up in this
> function and the suspend/resume callbacks is racy.
> 
> Why are you disabling the transmitter anyway? Is this for power
> saving?
> 

Actually, the original thought was to down the link on the other side,
when network interface is down on our side. Power saving is a nice
side-effect.

> > +static void mv2222_update_interface(struct phy_device *phydev)
> > +{
> > +	if ((phydev->speed == SPEED_1000 ||
> > +	     phydev->speed == SPEED_100 ||
> > +	     phydev->speed == SPEED_10) &&
> > +	    phydev->interface != PHY_INTERFACE_MODE_1000BASEX) {
> > +		phydev->interface = PHY_INTERFACE_MODE_1000BASEX;
> > +
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> > +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
> > +		mv2222_soft_reset(phydev);
> > +	} else if (phydev->speed == SPEED_10000 &&
> > +		   phydev->interface != PHY_INTERFACE_MODE_10GBASER) {
> > +		phydev->interface = PHY_INTERFACE_MODE_10GBASER;
> > +
> > +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> > +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
> > +		mv2222_soft_reset(phydev);
> > +	}
> 
> This looks wrong. phydev->interface is the _host_ interface, which
> you are clearly setting to XAUI here. Some network drivers depend
> on this being correct (for instance, when used with the Marvell
> 88x3310 PHY which changes its host-side interface dynamically.)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Overall, thank you for in-depth review, Russell.

