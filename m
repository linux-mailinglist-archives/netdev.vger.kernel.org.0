Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25C9116FA99
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgBZJVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:21:54 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44656 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbgBZJVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:21:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+Os/7yUni0JJHrrhjZ+cA+bqBG4cxaWE6UbZw8s44OM=; b=CrDwixOK6nLbMxCygaOTCyF1n
        BxFSaKZIbyk/KJ6vddrVI1/Y9trjIDDKAJzjZG7fGsH4nzd5Zowh5nZIpAIdD6W1Zwu+EoTcyBNWh
        LdV+vEwLb68c57RPhMgvsGMyYfMggPg7I75goE3MSBTnIaR0j25ixMvUK8qxAwrHF/IUB3WLqD8fm
        BB9G1bF7Hw0TgOcldTxlWAD6kc394N4tlihiT2BvLdcfihYwsIlabBpXZ8kHeA66Ha+SeNWXWSlPH
        hwhNkCx4jzSBek1OaS0DEL0NztyEwxwA/wEwLBiu2j4UlrQQfYZu2fpXSOl5AMfSQR8F/E7hkyslj
        vL+xk1b5w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57098)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j6ssu-0006Z7-Sy; Wed, 26 Feb 2020 09:21:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j6sss-0008I5-BR; Wed, 26 Feb 2020 09:21:38 +0000
Date:   Wed, 26 Feb 2020 09:21:38 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v8 1/1] net: ag71xx: port to phylink
Message-ID: <20200226092138.GV25745@shell.armlinux.org.uk>
References: <20200226054624.14199-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226054624.14199-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 06:46:24AM +0100, Oleksij Rempel wrote:
> The port to phylink was done as close as possible to initial
> functionality.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> changes v8:
> - set the autoneg bit
> - provide implementations for the mac_pcs_get_state and mac_an_restart
>   methods
> - do phylink_disconnect_phy() on _stop()
> - rename ag71xx_phy_setup() to ag71xx_phylink_setup() 

There will be one more change required; I'm changing the prototype for
the mac_link_up() function, and I suggest as you don't support in-band
AN that most of the setup for speed and duplex gets moved out of your
mac_config() implementation to mac_link_up().

The patches have been available on netdev for just over a week now.

> 
>  drivers/net/ethernet/atheros/Kconfig  |   2 +-
>  drivers/net/ethernet/atheros/ag71xx.c | 150 +++++++++++++++++---------
>  2 files changed, 98 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/Kconfig b/drivers/net/ethernet/atheros/Kconfig
> index 0058051ba925..2720bde5034e 100644
> --- a/drivers/net/ethernet/atheros/Kconfig
> +++ b/drivers/net/ethernet/atheros/Kconfig
> @@ -20,7 +20,7 @@ if NET_VENDOR_ATHEROS
>  config AG71XX
>  	tristate "Atheros AR7XXX/AR9XXX built-in ethernet mac support"
>  	depends on ATH79
> -	select PHYLIB
> +	select PHYLINK
>  	help
>  	  If you wish to compile a kernel for AR7XXX/91XXX and enable
>  	  ethernet support, then you should always answer Y to this.
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> index e95687a780fb..9692ae1734a8 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -32,6 +32,7 @@
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include <linux/of_platform.h>
> +#include <linux/phylink.h>
>  #include <linux/regmap.h>
>  #include <linux/reset.h>
>  #include <linux/clk.h>
> @@ -314,6 +315,8 @@ struct ag71xx {
>  	dma_addr_t stop_desc_dma;
>  
>  	phy_interface_t phy_if_mode;
> +	struct phylink *phylink;
> +	struct phylink_config phylink_config;
>  
>  	struct delayed_work restart_work;
>  	struct timer_list oom_timer;
> @@ -845,24 +848,23 @@ static void ag71xx_hw_start(struct ag71xx *ag)
>  	netif_wake_queue(ag->ndev);
>  }
>  
> -static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
> +static void ag71xx_mac_config(struct phylink_config *config, unsigned int mode,
> +			      const struct phylink_link_state *state)
>  {
> -	struct phy_device *phydev = ag->ndev->phydev;
> +	struct ag71xx *ag = netdev_priv(to_net_dev(config->dev));
>  	u32 cfg2;
>  	u32 ifctl;
>  	u32 fifo5;
>  
> -	if (!phydev->link && update) {
> -		ag71xx_hw_stop(ag);
> +	if (phylink_autoneg_inband(mode))
>  		return;
> -	}
>  
>  	if (!ag71xx_is(ag, AR7100) && !ag71xx_is(ag, AR9130))
>  		ag71xx_fast_reset(ag);
>  
>  	cfg2 = ag71xx_rr(ag, AG71XX_REG_MAC_CFG2);
>  	cfg2 &= ~(MAC_CFG2_IF_1000 | MAC_CFG2_IF_10_100 | MAC_CFG2_FDX);
> -	cfg2 |= (phydev->duplex) ? MAC_CFG2_FDX : 0;
> +	cfg2 |= (state->duplex) ? MAC_CFG2_FDX : 0;
>  
>  	ifctl = ag71xx_rr(ag, AG71XX_REG_MAC_IFCTL);
>  	ifctl &= ~(MAC_IFCTL_SPEED);
> @@ -870,7 +872,7 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>  	fifo5 = ag71xx_rr(ag, AG71XX_REG_FIFO_CFG5);
>  	fifo5 &= ~FIFO_CFG5_BM;
>  
> -	switch (phydev->speed) {
> +	switch (state->speed) {
>  	case SPEED_1000:
>  		cfg2 |= MAC_CFG2_IF_1000;
>  		fifo5 |= FIFO_CFG5_BM;
> @@ -883,7 +885,6 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>  		cfg2 |= MAC_CFG2_IF_10_100;
>  		break;
>  	default:
> -		WARN(1, "not supported speed %i\n", phydev->speed);
>  		return;
>  	}
>  
> @@ -897,58 +898,91 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>  	ag71xx_wr(ag, AG71XX_REG_MAC_CFG2, cfg2);
>  	ag71xx_wr(ag, AG71XX_REG_FIFO_CFG5, fifo5);
>  	ag71xx_wr(ag, AG71XX_REG_MAC_IFCTL, ifctl);
> +}
>  
> -	ag71xx_hw_start(ag);
> +static void ag71xx_mac_validate(struct phylink_config *config,
> +			    unsigned long *supported,
> +			    struct phylink_link_state *state)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> +	    state->interface != PHY_INTERFACE_MODE_GMII &&
> +	    state->interface != PHY_INTERFACE_MODE_MII) {
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		return;
> +	}
> +
> +	phylink_set(mask, MII);
> +
> +	phylink_set(mask, Autoneg);
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
> +
> +	if (state->interface == PHY_INTERFACE_MODE_NA ||
> +	    state->interface == PHY_INTERFACE_MODE_GMII) {
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 1000baseX_Full);
> +	}
>  
> -	if (update)
> -		phy_print_status(phydev);
> +	bitmap_and(supported, supported, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
>  }
>  
> -static void ag71xx_phy_link_adjust(struct net_device *ndev)
> +static void ag71xx_mac_pcs_get_state(struct phylink_config *config,
> +				     struct phylink_link_state *state)
>  {
> -	struct ag71xx *ag = netdev_priv(ndev);
> +	state->link = 0;
> +}
>  
> -	ag71xx_link_adjust(ag, true);
> +static void ag71xx_mac_an_restart(struct phylink_config *config)
> +{
> +	/* Not Supported */
>  }
>  
> -static int ag71xx_phy_connect(struct ag71xx *ag)
> +static void ag71xx_mac_link_down(struct phylink_config *config,
> +				 unsigned int mode, phy_interface_t interface)
>  {
> -	struct device_node *np = ag->pdev->dev.of_node;
> -	struct net_device *ndev = ag->ndev;
> -	struct device_node *phy_node;
> -	struct phy_device *phydev;
> -	int ret;
> +	struct ag71xx *ag = netdev_priv(to_net_dev(config->dev));
>  
> -	if (of_phy_is_fixed_link(np)) {
> -		ret = of_phy_register_fixed_link(np);
> -		if (ret < 0) {
> -			netif_err(ag, probe, ndev, "Failed to register fixed PHY link: %d\n",
> -				  ret);
> -			return ret;
> -		}
> +	ag71xx_hw_stop(ag);
> +}
>  
> -		phy_node = of_node_get(np);
> -	} else {
> -		phy_node = of_parse_phandle(np, "phy-handle", 0);
> -	}
> +static void ag71xx_mac_link_up(struct phylink_config *config, unsigned int mode,
> +			       phy_interface_t interface,
> +			       struct phy_device *phy)
> +{
> +	struct ag71xx *ag = netdev_priv(to_net_dev(config->dev));
>  
> -	if (!phy_node) {
> -		netif_err(ag, probe, ndev, "Could not find valid phy node\n");
> -		return -ENODEV;
> -	}
> +	ag71xx_hw_start(ag);
> +}
>  
> -	phydev = of_phy_connect(ag->ndev, phy_node, ag71xx_phy_link_adjust,
> -				0, ag->phy_if_mode);
> +static const struct phylink_mac_ops ag71xx_phylink_mac_ops = {
> +	.validate = ag71xx_mac_validate,
> +	.mac_pcs_get_state = ag71xx_mac_pcs_get_state,
> +	.mac_an_restart = ag71xx_mac_an_restart,
> +	.mac_config = ag71xx_mac_config,
> +	.mac_link_down = ag71xx_mac_link_down,
> +	.mac_link_up = ag71xx_mac_link_up,
> +};
>  
> -	of_node_put(phy_node);
> +static int ag71xx_phylink_setup(struct ag71xx *ag)
> +{
> +	struct phylink *phylink;
>  
> -	if (!phydev) {
> -		netif_err(ag, probe, ndev, "Could not connect to PHY device\n");
> -		return -ENODEV;
> -	}
> +	ag->phylink_config.dev = &ag->ndev->dev;
> +	ag->phylink_config.type = PHYLINK_NETDEV;
>  
> -	phy_attached_info(phydev);
> +	phylink = phylink_create(&ag->phylink_config, ag->pdev->dev.fwnode,
> +				 ag->phy_if_mode, &ag71xx_phylink_mac_ops);
> +	if (IS_ERR(phylink))
> +		return PTR_ERR(phylink);
>  
> +	ag->phylink = phylink;
>  	return 0;
>  }
>  
> @@ -1239,6 +1273,13 @@ static int ag71xx_open(struct net_device *ndev)
>  	unsigned int max_frame_len;
>  	int ret;
>  
> +	ret = phylink_of_phy_connect(ag->phylink, ag->pdev->dev.of_node, 0);
> +	if (ret) {
> +		netif_err(ag, link, ndev, "phylink_of_phy_connect filed with err: %i\n",
> +			  ret);
> +		goto err;
> +	}
> +
>  	max_frame_len = ag71xx_max_frame_len(ndev->mtu);
>  	ag->rx_buf_size =
>  		SKB_DATA_ALIGN(max_frame_len + NET_SKB_PAD + NET_IP_ALIGN);
> @@ -1251,11 +1292,7 @@ static int ag71xx_open(struct net_device *ndev)
>  	if (ret)
>  		goto err;
>  
> -	ret = ag71xx_phy_connect(ag);
> -	if (ret)
> -		goto err;
> -
> -	phy_start(ndev->phydev);
> +	phylink_start(ag->phylink);
>  
>  	return 0;
>  
> @@ -1268,8 +1305,8 @@ static int ag71xx_stop(struct net_device *ndev)
>  {
>  	struct ag71xx *ag = netdev_priv(ndev);
>  
> -	phy_stop(ndev->phydev);
> -	phy_disconnect(ndev->phydev);
> +	phylink_stop(ag->phylink);
> +	phylink_disconnect_phy(ag->phylink);
>  	ag71xx_hw_disable(ag);
>  
>  	return 0;
> @@ -1414,13 +1451,14 @@ static void ag71xx_restart_work_func(struct work_struct *work)
>  {
>  	struct ag71xx *ag = container_of(work, struct ag71xx,
>  					 restart_work.work);
> -	struct net_device *ndev = ag->ndev;
>  
>  	rtnl_lock();
>  	ag71xx_hw_disable(ag);
>  	ag71xx_hw_enable(ag);
> -	if (ndev->phydev->link)
> -		ag71xx_link_adjust(ag, false);
> +
> +	phylink_stop(ag->phylink);
> +	phylink_start(ag->phylink);
> +
>  	rtnl_unlock();
>  }
>  
> @@ -1759,6 +1797,12 @@ static int ag71xx_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, ndev);
>  
> +	err = ag71xx_phylink_setup(ag);
> +	if (err) {
> +		netif_err(ag, probe, ndev, "failed to setup phylink (%d)\n", err);
> +		goto err_mdio_remove;
> +	}
> +
>  	err = register_netdev(ndev);
>  	if (err) {
>  		netif_err(ag, probe, ndev, "unable to register net device\n");
> -- 
> 2.25.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
