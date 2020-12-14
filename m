Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09AA2DA078
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502728AbgLNT21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:28:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54208 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502707AbgLNT2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 14:28:18 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kotVG-00BxTv-Gf; Mon, 14 Dec 2020 20:27:26 +0100
Date:   Mon, 14 Dec 2020 20:27:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, marex@denx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next] net: phy: mchp: Add 1588 support for LAN8814
 Quad PHY
Message-ID: <20201214192726.GD2846647@lunn.ch>
References: <20201214175658.11138-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214175658.11138-1-Divya.Koppera@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct lan8814_priv {
> +	const struct kszphy_type *type;
> +	int led_mode;
> +	bool rmii_ref_clk_sel;
> +	bool rmii_ref_clk_sel_val;
> +	u64 stats[ARRAY_SIZE(kszphy_hw_stats)];
> +	struct mii_timestamper mii_ts;
> +	struct phy_device *phydev;
> +	struct lan8814_ptp ptp;
> +	int hwts_tx_en;
> +	int hwts_rx_en;
> +	int layer;
> +	int version;
> +};

...

> @@ -304,7 +698,7 @@ static int kszphy_nand_tree_disable(struct phy_device *phydev)
>  /* Some config bits need to be set again on resume, handle them here. */
>  static int kszphy_config_reset(struct phy_device *phydev)
>  {
> -	struct kszphy_priv *priv = phydev->priv;
> +	struct lan8814_priv *priv = phydev->priv;
>  	int ret;
>  
>  	if (priv->rmii_ref_clk_sel) {

...

> +static int lan8814_probe(struct phy_device *phydev)
> +{
> +	struct lan8814_priv *priv;
> +	struct clk *clk;
> +	const struct kszphy_type *type = phydev->drv->driver_data;
> +	const struct device_node *np = phydev->mdio.dev.of_node;
> +
> +	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;

>  static struct phy_driver ksphy_driver[] = {
>  {
>  	.phy_id		= PHY_ID_KS8737,
> @@ -1352,7 +2392,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.phy_id_mask	= MICREL_PHY_ID_MASK,
>  	.name		= "Microchip INDY Gigabit Quad PHY",
>  	.driver_data	= &ksz9021_type,
> -	.probe		= kszphy_probe,
> +	.probe		= lan8814_probe,
>  	.soft_reset	= genphy_soft_reset,
>  	.read_status	= ksz9031_read_status,
>  	.get_sset_count	= kszphy_get_sset_count,
> @@ -1360,6 +2400,8 @@ static struct phy_driver ksphy_driver[] = {
>  	.get_stats	= kszphy_get_stats,
>  	.suspend	= genphy_suspend,
>  	.resume		= kszphy_resume,
> +	.config_intr	= lan8814_config_intr,
> +	.handle_interrupt = lan8814_handle_interrupt,
>  }, {
>  	.phy_id		= PHY_ID_KSZ9131,
>  	.phy_id_mask	= MICREL_PHY_ID_MASK,

If i'm reading this correctly, only PHYs using lan8814_probe() have a
lan8814_priv. All the other phys have a kszphy_priv. Yet in
kszphy_config_reset() you seem to assume it is a lan8814_priv. This is
dangerous.

It would be much better to define a kszphy_ptp_priv structure, and put
a pointer to it in kszphy_priv. Allocate this structure in
lan8814_probe() and leave it NULL otherwise.

	Andrew
