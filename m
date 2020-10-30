Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4152C2A0F49
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgJ3UQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:16:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55398 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgJ3UPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 16:15:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYanr-004PQx-Th; Fri, 30 Oct 2020 21:15:15 +0100
Date:   Fri, 30 Oct 2020 21:15:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20201030201515.GE1042051@lunn.ch>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030172950.12767-5-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dp83td510_config_init(struct phy_device *phydev)
> +{
> +	struct dp83td510_private *dp83td510 = phydev->priv;
> +	int mst_slave_cfg;
> +	int ret = 0;
> +
> +	if (phy_interface_is_rgmii(phydev)) {
> +		if (dp83td510->rgmii_delay) {
> +			ret = phy_set_bits_mmd(phydev, DP83TD510_DEVADDR,
> +					       DP83TD510_MAC_CFG_1, dp83td510->rgmii_delay);
> +			if (ret)
> +				return ret;
> +		}
> +	}

Hi Dan

I'm getting a bit paranoid about RGMII delays...

> +static int dp83td510_read_straps(struct phy_device *phydev)
> +{
> +	struct dp83td510_private *dp83td510 = phydev->priv;
> +	int strap;
> +
> +	strap = phy_read_mmd(phydev, DP83TD510_DEVADDR, DP83TD510_SOR_1);
> +	if (strap < 0)
> +		return strap;
> +
> +	if (strap & DP83TD510_RGMII)
> +		dp83td510->is_rgmii = true;
> +
> +	return 0;
> +};

So dp83td510->is_rgmii is the strapping configuration. So if one of
the four RGMII modes is selected, your appear to ignore which of the
four is selected, and program the hardware with the strapping?

That seems like a bad idea.

> +#if IS_ENABLED(CONFIG_OF_MDIO)
> +static int dp83td510_of_init(struct phy_device *phydev)
> +{
> +	struct dp83td510_private *dp83td510 = phydev->priv;
> +	struct device *dev = &phydev->mdio.dev;
> +	struct device_node *of_node = dev->of_node;
> +	s32 rx_int_delay;
> +	s32 tx_int_delay;
> +	int ret;
> +
> +	if (!of_node)
> +		return -ENODEV;
> +
> +	ret = dp83td510_read_straps(phydev);
> +	if (ret)
> +		return ret;
> +
> +	dp83td510->hi_diff_output = device_property_read_bool(&phydev->mdio.dev,
> +							      "tx-rx-output-high");
> +
> +	if (device_property_read_u32(&phydev->mdio.dev, "tx-fifo-depth",
> +				     &dp83td510->tx_fifo_depth))
> +		dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_5_B_NIB;

Please don't use device_property_read_foo API, we don't want to give
the impression it is O.K. to stuff DT properties in ACPI
tables. Please use of_ API calls.

	Andrew
