Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AC82B9FFA
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgKTBtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:49:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgKTBtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:49:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfvY7-0082oq-Go; Fri, 20 Nov 2020 02:49:19 +0100
Date:   Fri, 20 Nov 2020 02:49:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, ciorneiioana@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20201120014919.GB1804098@lunn.ch>
References: <20201117201555.26723-1-dmurphy@ti.com>
 <20201117201555.26723-5-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117201555.26723-5-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dp83td510_config_init(struct phy_device *phydev)
> +{
> +	struct dp83td510_private *dp83td510 = phydev->priv;
> +	int ret = 0;
> +
> +	if (phy_interface_is_rgmii(phydev)) {

> +		if (dp83td510->rgmii_delay) {
> +			ret = phy_set_bits_mmd(phydev, DP83TD510_DEVADDR,
> +					       DP83TD510_MAC_CFG_1,
> +					       dp83td510->rgmii_delay);

Just to be safe, you should always write rgmii_delay, even if it is
zero. We have had too many bugs with RGMII delays which cause bad
backwards compatibility problems, so i would prefer to do a write
which might be unneeded, that find a bug here in a few years time.

> +			if (ret)
> +				return ret;
> +		}
> +	}
> +
> +	if (phydev->interface == PHY_INTERFACE_MODE_RMII) {
> +		ret = phy_modify(phydev, DP83TD510_GEN_CFG,
> +				 DP83TD510_FIFO_DEPTH_MASK,
> +				 dp83td510->tx_fifo_depth);

So there is no need to set the FIFO depth for the other three RGMII
modes? Or should this also be phy_interface_is_rgmii(phydev)?

> +#if IS_ENABLED(CONFIG_OF_MDIO)
> +static int dp83td510_of_init(struct phy_device *phydev)
> +{
> +	struct dp83td510_private *dp83td510 = phydev->priv;
> +	struct device *dev = &phydev->mdio.dev;
> +	struct device_node *of_node = dev->of_node;

You need to move this assignment to later in order to keep with
reverse christmas tree.

> +#else
> +static int dp83869_of_init(struct phy_device *phydev)
> +{
> +	dp83td510->hi_diff_output = DP83TD510_2_4V_P2P
> +	dp83td510->tx_fifo_depth = DP83TD510_FIFO_DEPTH_5_B_NIB

You don't have DT, so there is no fine control, but you still need to
do the basic 2ns delay as indicated by the phydev->interface value. So
i think you still need to set dp83td510->rgmii_delay depending on
which RGMII mode is requested.

      Andrew
