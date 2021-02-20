Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F98B320629
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 17:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBTQ21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 11:28:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50712 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhBTQ20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 11:28:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lDV6W-007XT5-Nm; Sat, 20 Feb 2021 17:27:36 +0100
Date:   Sat, 20 Feb 2021 17:27:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     netdev@vger.kernel.org, system@metrotek.ru, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: add Marvell 88X2222 transceiver support
Message-ID: <YDE4eJFly/to0SMn@lunn.ch>
References: <20210201192250.gclztkomtsihczz6@dhcp-179.ddg>
 <20210220094621.tl6fawj7c5hjrp6s@dhcp-179.ddg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210220094621.tl6fawj7c5hjrp6s@dhcp-179.ddg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ivan

> +static int sfp_module_insert(void *_priv, const struct sfp_eeprom_id *id)
> +{
> +	struct phy_device *phydev = _priv;
> +	struct device *dev = &phydev->mdio.dev;
> +	struct mv2222_data *priv = phydev->priv;
> +	phy_interface_t sfp_interface;

Reverse Christmas tree please. Which means you will need to move some
of the assignments to the body of the function. Please also drop the _
from _priv.

> +
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_supported) = { 0, };
> +
> +	sfp_parse_support(phydev->sfp_bus, id, sfp_supported);
> +	sfp_interface = sfp_select_interface(phydev->sfp_bus, sfp_supported);
> +
> +	dev_info(dev, "%s SFP module inserted", phy_modes(sfp_interface));
> +
> +	switch (sfp_interface) {
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		phydev->speed = SPEED_10000;
> +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_10GBR);
> +		break;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		phydev->speed = SPEED_1000;
> +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_1GBX_AN);
> +		break;
> +	case PHY_INTERFACE_MODE_SGMII:
> +		phydev->speed = SPEED_1000;

SPEED_UNKNOWN might be better here, until auto negotiation has
completed and you then know if it is 10/100/1G.

> +		phy_write_mmd(phydev, MDIO_MMD_VEND2, MV_PCS_CONFIG,
> +			      MV_PCS_HOST_XAUI | MV_PCS_LINE_SGMII_AN);
> +		phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_1GBX_CTRL,
> +			       BMCR_SPEED1000 | BMCR_SPEED100, BMCR_SPEED1000);
> +		break;
> +	default:
> +		dev_err(dev, "Incompatible SFP module inserted\n");
> +
> +		return -EINVAL;
> +	}
> +
> +	linkmode_and(phydev->supported, priv->supported, sfp_supported);
> +	priv->line_interface = sfp_interface;
> +
> +	return mv2222_soft_reset(phydev);
> +}
> +
> +static void sfp_module_remove(void *_priv)
> +{
> +	struct phy_device *phydev = _priv;
> +	struct mv2222_data *priv = phydev->priv;

More reverse christmass tree.

> +
> +	priv->line_interface = PHY_INTERFACE_MODE_NA;
> +	linkmode_copy(phydev->supported, priv->supported);
> +}
> +
> +static int mv2222_config_aneg(struct phy_device *phydev)
> +{

> +	/* Try 10G first */
> +	if (mv2222_is_10g_capable(phydev)) {
> +		phydev->speed = SPEED_10000;
> +		mv2222_update_interface(phydev);
> +
> +		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_10GBR_STAT_RT);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (ret & MDIO_STAT1_LSTATUS) {
> +			phydev->autoneg = AUTONEG_DISABLE;
> +
> +			return mv2222_disable_aneg(phydev);
> +		}
> +
> +		/* 10G link was not established, switch back to 1G
> +		 * and proceed with true autonegotiation */
> +		phydev->speed = SPEED_1000;
> +		mv2222_update_interface(phydev);

So you are assuming the cable is plugged in and the peer is ready to
go? Try 10G once, and then fall back to 1G? This does not seem very
reliable, and likely to cause confusion. It works sometimes, not
others. I'm not sure this is a good idea.

> +static void mv2222_remove(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	struct mv2222_data *priv = phydev->priv;
> +
> +	if (priv)
> +		devm_kfree(dev, priv);

Why can devm_kfree(). The point of devm_ is that it frees itself.

    Andrew
