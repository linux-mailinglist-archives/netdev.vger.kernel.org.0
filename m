Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C67234B35
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387852AbgGaSiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:38:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37364 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387767AbgGaSiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 14:38:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1Zum-007jBm-CA; Fri, 31 Jul 2020 20:37:56 +0200
Date:   Fri, 31 Jul 2020 20:37:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <dthompson@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Asmaa Mnebhi <asmaa@mellanox.com>
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Message-ID: <20200731183756.GF1748118@lunn.ch>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 02:29:15PM -0400, David Thompson wrote:

Hi David

> +static void mlxbf_gige_get_pauseparam(struct net_device *netdev,
> +				      struct ethtool_pauseparam *pause)
> +{
> +	pause->autoneg = AUTONEG_ENABLE;
> +	pause->rx_pause = 1;
> +	pause->tx_pause = 1;

This is incorrect. You say autoneg is supported. So you should be
returning the result of the autoneg. But what is also wrong is you
don't appear to be programming the MAC with the result of the autoneg.
mlxbf_gige_handle_link_change() should be doing this.

> +}
> +
> +static int mlxbf_gige_get_link_ksettings(struct net_device *netdev,
> +					 struct ethtool_link_ksettings *link_ksettings)
> +{
> +	struct phy_device *phydev = netdev->phydev;
> +	u32 supported, advertising;
> +	u32 lp_advertising = 0;
> +	int status;

phy_ethtool_ksettings_get() and maybe phy_ethtool_ksettings_set().

> +
> +	supported = SUPPORTED_TP | SUPPORTED_1000baseT_Full |
> +		    SUPPORTED_Autoneg | SUPPORTED_Pause;
> +
> +	advertising = ADVERTISED_1000baseT_Full | ADVERTISED_Autoneg |
> +		      ADVERTISED_Pause;
> +
> +	status = phy_read(phydev, MII_LPA);
> +	if (status >= 0)
> +		lp_advertising = mii_lpa_to_ethtool_lpa_t(status & 0xffff);
> +
> +	status = phy_read(phydev, MII_STAT1000);
> +	if (status >= 0)
> +		lp_advertising |= mii_stat1000_to_ethtool_lpa_t(status & 0xffff);
> +

The MAC driver has no business poking around in PHY registers. Call
into phylib.

> +static void mlxbf_gige_handle_link_change(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +	struct phy_device *phydev = netdev->phydev;
> +	irqreturn_t ret;
> +
> +	ret = mlxbf_gige_mdio_handle_phy_interrupt(priv);

You are polling the PHY. I don't see anywhere you link the interrupt
to phylib.

> +	if (ret != IRQ_HANDLED)
> +		return;
> +
> +	/* print new link status only if the interrupt came from the PHY */
> +	phy_print_status(phydev);
> +}

> +static int mlxbf_gige_open(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +	struct phy_device *phydev = netdev->phydev;
> +	u64 int_en;
> +	int err;
> +
> +	mlxbf_gige_cache_stats(priv);
> +	mlxbf_gige_clean_port(priv);
> +	mlxbf_gige_rx_init(priv);
> +	mlxbf_gige_tx_init(priv);
> +	netif_napi_add(netdev, &priv->napi, mlxbf_gige_poll, NAPI_POLL_WEIGHT);
> +	napi_enable(&priv->napi);
> +	netif_start_queue(netdev);
> +
> +	err = mlxbf_gige_request_irqs(priv);
> +	if (err)
> +		return err;
> +
> +	phy_start(phydev);
> +
> +	/* Set bits in INT_EN that we care about */
> +	int_en = MLXBF_GIGE_INT_EN_HW_ACCESS_ERROR |
> +		 MLXBF_GIGE_INT_EN_TX_CHECKSUM_INPUTS |
> +		 MLXBF_GIGE_INT_EN_TX_SMALL_FRAME_SIZE |
> +		 MLXBF_GIGE_INT_EN_TX_PI_CI_EXCEED_WQ_SIZE |
> +		 MLXBF_GIGE_INT_EN_SW_CONFIG_ERROR |
> +		 MLXBF_GIGE_INT_EN_SW_ACCESS_ERROR |
> +		 MLXBF_GIGE_INT_EN_RX_RECEIVE_PACKET;
> +	writeq(int_en, priv->base + MLXBF_GIGE_INT_EN);
> +
> +	return 0;
> +}
> +
> +static int mlxbf_gige_stop(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +
> +	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> +	netif_stop_queue(netdev);
> +	napi_disable(&priv->napi);
> +	netif_napi_del(&priv->napi);
> +	mlxbf_gige_free_irqs(priv);
> +
> +	if (netdev->phydev)
> +		phy_stop(netdev->phydev);

In open() you unconditionally start the phy. Do you expect the PHY to
disappear between open and stop?

> +static int mlxbf_gige_probe(struct platform_device *pdev)
> +{

> +	phydev = phy_find_first(priv->mdiobus);
> +	if (!phydev)
> +		return -EIO;

-ENODEV would seem more appropriate.

	Andrew
