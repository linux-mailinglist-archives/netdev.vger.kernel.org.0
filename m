Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295122D50AD
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 03:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgLJCMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 21:12:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47800 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgLJCM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 21:12:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knBQc-00B9IH-95; Thu, 10 Dec 2020 03:11:34 +0100
Date:   Thu, 10 Dec 2020 03:11:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201210021134.GD2638572@lunn.ch>
References: <20201207121345.3818234-1-steen.hegelund@microchip.com>
 <20201207121345.3818234-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207121345.3818234-4-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 01b53f86004c..f6a094c81e86 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -66,9 +66,11 @@ source "drivers/phy/broadcom/Kconfig"
>  source "drivers/phy/cadence/Kconfig"
>  source "drivers/phy/freescale/Kconfig"
>  source "drivers/phy/hisilicon/Kconfig"
> +source "drivers/phy/intel/Kconfig"

That looks odd.

>  source "drivers/phy/lantiq/Kconfig"
>  source "drivers/phy/marvell/Kconfig"
>  source "drivers/phy/mediatek/Kconfig"
> +source "drivers/phy/microchip/Kconfig"
>  source "drivers/phy/motorola/Kconfig"
>  source "drivers/phy/mscc/Kconfig"
>  source "drivers/phy/qualcomm/Kconfig"
> @@ -80,7 +82,6 @@ source "drivers/phy/socionext/Kconfig"
>  source "drivers/phy/st/Kconfig"
>  source "drivers/phy/tegra/Kconfig"
>  source "drivers/phy/ti/Kconfig"
> -source "drivers/phy/intel/Kconfig"
>  source "drivers/phy/xilinx/Kconfig"

Ah. Please make that a separate patch.

> +	value = sdx5_rd(priv, SD25G_LANE_CMU_C0(sd_index));
> +	value = SD25G_LANE_CMU_C0_PLL_LOL_UDL_GET(value);
> +
> +	if (value) {
> +		dev_err(macro->priv->dev, "CMU_C0 pll_lol_udl: 0x%x\n", value);
> +		ret = -EINVAL;
> +	}
> +
> +	value = sdx5_rd(priv, SD_LANE_25G_SD_LANE_STAT(sd_index));
> +	value = SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE_GET(value);
> +
> +	if (value != 0x1) {
> +		dev_err(macro->priv->dev, "sd_lane_stat pma_rst_done: 0x%x\n", value);
> +		ret = -EINVAL;
> +	}

These error messages are not very helpful. Could you be a bit more
descriptive. Or do you think there is sufficient black magic in the
hardware that nobody outside of Microchip will be able to debug it?

> +static int sparx5_serdes_get_serdesmode(phy_interface_t portmode,
> +					struct phy_configure_opts_eth_serdes *conf)
> +{
> +	switch (portmode) {
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		if (conf->speed == SPEED_2500)
> +			return SPX5_SD_MODE_2G5;
> +		if (conf->speed == SPEED_100)
> +			return SPX5_SD_MODE_100FX;
> +		return SPX5_SD_MODE_1000BASEX;

Please could you explain this. Why different speeds for 1000BaseX?

> +	case PHY_INTERFACE_MODE_SGMII:
> +		return SPX5_SD_MODE_1000BASEX;

Here there could be some oddities, depending on how 10Mbps and 100Mbps
is implemented. But 1000BASEX only supports 1Gbps.

> +static int sparx5_serdes_validate(struct phy *phy, enum phy_mode mode,
> +					int submode,
> +					union phy_configure_opts *opts)
> +{
> +	struct sparx5_serdes_macro *macro = phy_get_drvdata(phy);
> +	struct sparx5_serdes_private *priv = macro->priv;
> +	u32 value, analog_sd;
> +
> +	if (mode != PHY_MODE_ETHERNET)
> +		return -EINVAL;
> +
> +	switch (submode) {
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	if (macro->serdestype == SPX5_SDT_6G) {
> +		value = sdx5_rd(priv, SD6G_LANE_LANE_DF(macro->stpidx));
> +		analog_sd = SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
> +	} else if (macro->serdestype == SPX5_SDT_10G) {
> +		value = sdx5_rd(priv, SD10G_LANE_LANE_DF(macro->stpidx));
> +		analog_sd = SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
> +	} else {
> +		value = sdx5_rd(priv, SD25G_LANE_LANE_DE(macro->stpidx));
> +		analog_sd = SD25G_LANE_LANE_DE_LN_PMA_RXEI_GET(value);
> +	}
> +	/* Link up is when analog_sd == 0 */
> +	return analog_sd;

The documentation says:

	/**
	 * @validate:
	 *
	 * Optional.
	 *
	 * Used to check that the current set of parameters can be
	 * handled by the phy. Implementations are free to tune the
	 * parameters passed as arguments if needed by some
	 * implementation detail or constraints. It must not change
	 * any actual configuration of the PHY, so calling it as many
	 * times as deemed fit by the consumer must have no side
	 * effect.
	 *
	 * Returns: 0 if the configuration can be applied, an negative
	 * error code otherwise
	 */

So why are returning link up information?

   Andrew
