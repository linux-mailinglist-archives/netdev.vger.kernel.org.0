Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED45A35CFF4
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243376AbhDLSEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:04:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240038AbhDLSEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 14:04:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lW0v6-00GJyj-J1; Mon, 12 Apr 2021 20:04:20 +0200
Date:   Mon, 12 Apr 2021 20:04:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
Message-ID: <YHSLpGQclt6EshDF@lunn.ch>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static const struct nxp_c45_phy_stats nxp_c45_hw_stats[] = {
> +	{ "phy_symbol_error_cnt", MDIO_MMD_VEND1, SYMBOL_ERROR_COUNTER, 0, GENMASK(15, 0) },
> +	{ "phy_link_status_drop_cnt", MDIO_MMD_VEND1, LINK_DROP_COUNTER, 8, GENMASK(13, 8) },
> +	{ "phy_link_availability_drop_cnt", MDIO_MMD_VEND1, LINK_DROP_COUNTER, 0, GENMASK(5, 0) },

netdev tries to keep with the old 80 character limit. Please wrap the
long lines.

> +static void nxp_c45_set_delays(struct phy_device *phydev)
> +{
> +	struct nxp_c45_phy *priv = phydev->priv;
> +	u64 tx_delay = priv->tx_delay;
> +	u64 rx_delay = priv->rx_delay;
> +	u64 degree;
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +		degree = tx_delay / PS_PER_DEGREE;
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, VND1_TXID,
> +			      ID_ENABLE | nxp_c45_get_phase_shift(degree));
> +	}

You are missing an else clause. You need to ensure the delay is 0 if
delays are not required. You have no idea what the bootloader has
done.

> +static int nxp_c45_get_delays(struct phy_device *phydev)
> +{
> +	struct nxp_c45_phy *priv = phydev->priv;
> +	int ret;
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +		ret = device_property_read_u32(&phydev->mdio.dev, "tx-internal-delay-ps",
> +					       &priv->tx_delay);
> +		if (ret) {
> +			phydev_err(phydev, "tx-internal-delay-ps property missing\n");

This is not normally mandatory. Default to 2ns if not specified in DT.

> +static int nxp_c45_set_phy_mode(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, ABILITIES);
> +	phydev_dbg(phydev, "Clause 45 managed PHY abilities 0x%x\n", ret);
> +
> +	switch (phydev->interface) {
> +	case PHY_INTERFACE_MODE_RGMII:
> +		if (!(ret & RGMII_ABILITY)) {
> +			phydev_err(phydev, "rgmii mode not supported\n");
> +			return -EINVAL;
> +		}
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_RGMII);
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		if (!(ret & RGMII_ID_ABILITY)) {
> +			phydev_err(phydev, "rgmii-id, rgmii-txid, rgmii-rxid modes are not supported\n");
> +			return -EINVAL;
> +		}
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_RGMII);
> +		ret = nxp_c45_get_delays(phydev);
> +		if (ret)
> +			return ret;
> +
> +		nxp_c45_set_delays(phydev);
> +		break;

Again, for PHY_INTERFACE_MODE_RGMII you need to ensure the hardware is
not inserting a delay.

> +	case PHY_INTERFACE_MODE_SGMII:
> +		if (!(ret & SGMII_ABILITY)) {
> +			phydev_err(phydev, "sgmii mode not supported\n");
> +			return -EINVAL;
> +		}
> +		phy_write_mmd(phydev, MDIO_MMD_VEND1, MII_BASIC_CONFIG, MII_BASIC_CONFIG_SGMII);
> +		break;

Interested. What gets reported over the inband signalling?

	    Andrew
