Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E002CE12D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgLCVxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:53:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37362 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727700AbgLCVxt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 16:53:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkwWz-00A71N-MD; Thu, 03 Dec 2020 22:52:53 +0100
Date:   Thu, 3 Dec 2020 22:52:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201203215253.GL2333853@lunn.ch>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
 <20201203103015.3735373-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203103015.3735373-4-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* map from SD25G28 interface width to configuration value */
> +static u8 sd25g28_get_iw_setting(const u8 interface_width)
> +{
> +	switch (interface_width) {
> +	case 10: return 0;
> +	case 16: return 1;
> +	case 32: return 3;
> +	case 40: return 4;
> +	case 64: return 5;
> +	default:
> +		pr_err("%s: Illegal value %d for interface width\n",
> +		       __func__, interface_width);

Please make use of dev_err(phy->dev, so we know which PHY has
configuration problems.

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
> +}

What i have not yet seen is how this code plugs together with
phylink_pcs_ops?

Can this hardware also be used for SATA, USB? As far as i understand,
the Marvell Comphy is multi-purpose, it is used for networking, USB,
and SATA, etc. Making it a generic PHY then makes sense, because
different subsystems need to use it.

But it looks like this is for networking only? So i'm wondering if it
belongs in driver/net/pcs and it should be accessed using
phylink_pcs_ops?

	Andrew
