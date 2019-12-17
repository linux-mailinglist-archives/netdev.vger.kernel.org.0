Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED8912281D
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 11:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfLQKAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 05:00:31 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53962 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfLQKAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 05:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HXRBJPJTNAD25xDwFkoiiYxthmx1p2vZ/XIAdrrAPNo=; b=AH7kX/Nark6A/qqYijTLIAiLS
        FGJjoWYKZhoon2hF9hW80bPPlhTL55ChD7PTZUXF4kXlCr2I9bYvlvB6sv9IlkvossMs1CWZH1dpf
        vB+p9R/Rb0BlzMDTpM+uGAiweqIe3Ggtlq0o0So89LrFZnolW4O2ravGBIiYj6FExc79hINV/jt0K
        XRoVjLVpxbb3TdPHnihzntNhMAehm5dRUvAESXUH31O1X5O2zgNtQLGjvn9A6rnlXF1KnIRciUjO4
        ah0UQVeftQw37IP/gTEw7HUKreU1IZ/XmiPEHE9gkBxpj4/WgrCoDRJG87AIJDr62bWlHG7+dsr4Y
        7znNL6gsw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50020)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ih9eD-0005DW-Tj; Tue, 17 Dec 2019 10:00:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ih9e9-0003J0-Dy; Tue, 17 Dec 2019 10:00:05 +0000
Date:   Tue, 17 Dec 2019 10:00:05 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v6 1/5] net: ag71xx: port to phylink
Message-ID: <20191217100005.GO25745@shell.armlinux.org.uk>
References: <20191217072325.4177-1-o.rempel@pengutronix.de>
 <20191217072325.4177-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217072325.4177-2-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 08:23:21AM +0100, Oleksij Rempel wrote:
> The port to phylink was done as close as possible to initial
> functionality.
> Theoretically this HW can support flow control, practically seems to be not
> enough to just enable it. So, more work should be done.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/ethernet/atheros/Kconfig  |   2 +-
>  drivers/net/ethernet/atheros/ag71xx.c | 147 ++++++++++++++++----------
>  2 files changed, 90 insertions(+), 59 deletions(-)
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
> index ad8b0e3fcd2c..37a62283719e 100644
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
> @@ -315,6 +316,9 @@ struct ag71xx {
>  
>  	int phy_if_mode;
>  
> +	struct phylink *phylink;
> +	struct phylink_config phylink_config;
> +
>  	struct delayed_work restart_work;
>  	struct timer_list oom_timer;
>  
> @@ -845,24 +849,23 @@ static void ag71xx_hw_start(struct ag71xx *ag)
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
> @@ -870,7 +873,7 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>  	fifo5 = ag71xx_rr(ag, AG71XX_REG_FIFO_CFG5);
>  	fifo5 &= ~FIFO_CFG5_BM;
>  
> -	switch (phydev->speed) {
> +	switch (state->speed) {
>  	case SPEED_1000:
>  		cfg2 |= MAC_CFG2_IF_1000;
>  		fifo5 |= FIFO_CFG5_BM;
> @@ -883,7 +886,6 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>  		cfg2 |= MAC_CFG2_IF_10_100;
>  		break;
>  	default:
> -		WARN(1, "not supported speed %i\n", phydev->speed);
>  		return;
>  	}
>  
> @@ -897,58 +899,79 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>  	ag71xx_wr(ag, AG71XX_REG_MAC_CFG2, cfg2);
>  	ag71xx_wr(ag, AG71XX_REG_FIFO_CFG5, fifo5);
>  	ag71xx_wr(ag, AG71XX_REG_MAC_IFCTL, ifctl);
> -
> -	ag71xx_hw_start(ag);
> -
> -	if (update)
> -		phy_print_status(phydev);
>  }
>  
> -static void ag71xx_phy_link_adjust(struct net_device *ndev)
> +static void ag71xx_mac_validate(struct phylink_config *config,
> +			    unsigned long *supported,
> +			    struct phylink_link_state *state)
>  {
> -	struct ag71xx *ag = netdev_priv(ndev);
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
> +	/* flow control is not supported */

You should also set set the autoneg bit.

> +
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
>  
> -	ag71xx_link_adjust(ag, true);
> +	if (state->interface == PHY_INTERFACE_MODE_NA ||
> +	    state->interface == PHY_INTERFACE_MODE_GMII) {
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 1000baseX_Full);
> +	}
> +
> +	bitmap_and(supported, supported, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
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
> +	.mac_config = ag71xx_mac_config,
> +	.mac_link_down = ag71xx_mac_link_down,
> +	.mac_link_up = ag71xx_mac_link_up,

Please provide implementations for the mac_pcs_get_state and
mac_an_restart methods; these are not optional, and if phylink
decides it wants to call them, without anything here the kernel
will oops.  If you don't have anything to do for mac_pcs_get_state,
please set state->link to false.

> +};
>  
> -	of_node_put(phy_node);
> +static int ag71xx_phy_setup(struct ag71xx *ag)
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
> @@ -1239,6 +1262,13 @@ static int ag71xx_open(struct net_device *ndev)
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
> @@ -1251,11 +1281,7 @@ static int ag71xx_open(struct net_device *ndev)
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
> @@ -1268,8 +1294,7 @@ static int ag71xx_stop(struct net_device *ndev)
>  {
>  	struct ag71xx *ag = netdev_priv(ndev);
>  
> -	phy_stop(ndev->phydev);
> -	phy_disconnect(ndev->phydev);
> +	phylink_stop(ag->phylink);

You connect to the phy in _open() but don't disconnect it in _stop().

>  	ag71xx_hw_disable(ag);
>  
>  	return 0;
> @@ -1396,10 +1421,9 @@ static netdev_tx_t ag71xx_hard_start_xmit(struct sk_buff *skb,
>  
>  static int ag71xx_do_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
>  {
> -	if (!ndev->phydev)
> -		return -EINVAL;
> +	struct ag71xx *ag = netdev_priv(ndev);
>  
> -	return phy_mii_ioctl(ndev->phydev, ifr, cmd);
> +	return phylink_mii_ioctl(ag->phylink, ifr, cmd);
>  }
>  
>  static void ag71xx_oom_timer_handler(struct timer_list *t)
> @@ -1422,13 +1446,14 @@ static void ag71xx_restart_work_func(struct work_struct *work)
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
> @@ -1768,6 +1793,12 @@ static int ag71xx_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, ndev);
>  
> +	err = ag71xx_phy_setup(ag);

I think this function would be better called ag71xx_phylink_setup() as
it doesn't seem to be setting up the phy at all (which happens in
_open()).

> +	if (err) {
> +		netif_err(ag, probe, ndev, "failed to setup phy (%d)\n", err);
> +		goto err_mdio_remove;
> +	}
> +
>  	err = register_netdev(ndev);
>  	if (err) {
>  		netif_err(ag, probe, ndev, "unable to register net device\n");
> -- 
> 2.24.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
