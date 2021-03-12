Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0A433835E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhCLB5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 20:57:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhCLB4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 20:56:46 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKX2i-00AS3V-0g; Fri, 12 Mar 2021 02:56:44 +0100
Date:   Fri, 12 Mar 2021 02:56:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <davthompson@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        limings@nvidia.com, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v4] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <YErKXAhto42RU+xn@lunn.ch>
References: <1615380399-31970-1-git-send-email-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615380399-31970-1-git-send-email-davthompson@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void mlxbf_gige_get_pauseparam(struct net_device *netdev,
> +				      struct ethtool_pauseparam *pause)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +
> +	pause->autoneg = priv->aneg_pause;
> +	pause->rx_pause = priv->tx_pause;
> +	pause->tx_pause = priv->rx_pause;
> +}

> +static int mlxbf_gige_probe(struct platform_device *pdev)
> +{
> +	err = phy_connect_direct(netdev, phydev,
> +				 mlxbf_gige_adjust_link,
> +				 PHY_INTERFACE_MODE_GMII);
> +	if (err) {
> +		dev_err(&pdev->dev, "Could not attach to PHY\n");
> +		mlxbf_gige_mdio_remove(priv);
> +		return err;
> +	}
> +
> +	/* MAC only supports 1000T full duplex mode */
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Full_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> +	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> +
> +	/* MAC supports symmetric flow control */
> +	phy_support_sym_pause(phydev);
> +
> +	/* Enable pause */
> +	priv->rx_pause = phydev->pause;
> +	priv->tx_pause = phydev->pause;
> +	priv->aneg_pause = AUTONEG_ENABLE;

Hi David

I'm pretty sure mlxbf_gige_get_pauseparam() is broken.

This is the only code which sets priv->rx_pause, etc. And this is
before the PHY has had time to do anything. auto-neg has not completed
so you have no idea what has been negotiated for pause.
mlxbf_gige_adjust_link() should be adjusting priv->??_pause once the
link has been established.

     Andrew
