Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5BCF500B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKHPmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:42:39 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:54617 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfKHPmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 10:42:38 -0500
X-Originating-IP: 86.206.246.123
Received: from localhost (lfbn-tou-1-421-123.w86-206.abo.wanadoo.fr [86.206.246.123])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id D804E20003;
        Fri,  8 Nov 2019 15:42:34 +0000 (UTC)
Date:   Fri, 8 Nov 2019 16:42:34 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Milind Parab <mparab@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, piotrs@cadence.com,
        dkangude@cadence.com, ewanm@cadence.com, arthurm@cadence.com,
        stevenh@cadence.com
Subject: Re: [PATCH 1/4] net: macb: add phylink support
Message-ID: <20191108154234.GA208063@kwain>
References: <1573220027-15842-1-git-send-email-mparab@cadence.com>
 <1573220063-17470-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1573220063-17470-1-git-send-email-mparab@cadence.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Milind,

I sent a similar patch a few weeks ago. Have you seen
https://lore.kernel.org/netdev/20191018145230.GJ3125@piout.net/T/?
I also intended to send the v2 in the next days. I looked briefly at
your patch and it seems it has some of the issues my first version had
(such as not using state->link in mac_config()). This is why I would
suggest to wait for my v2 and to see if the rest of your series could be
based on it. What do you think? I pushed it in the meantime on GH[1].

Also, one of the comments I got was that it should be possible to get
the status of the negotiation, and that it would be very nice to
implement the get_link_state() helper. I couldn't get lots of info
about the status register (NSR), but I had the feeling this register is
exposing the info we need. Do you have more info about this?

Thanks!
Antoine

[1] https://github.com/atenart/linux/commit/eef7734734310e6759a0c5e0b61bc71cf978e46b

On Fri, Nov 08, 2019 at 01:34:23PM +0000, Milind Parab wrote:
> This patch replace phylib API's by phylink API's.
> 
> Signed-off-by: Milind Parab <mparab@cadence.com>
> ---
>  drivers/net/ethernet/cadence/Kconfig     |    2 +-
>  drivers/net/ethernet/cadence/macb.h      |    3 +
>  drivers/net/ethernet/cadence/macb_main.c |  326 ++++++++++++++++-------------
>  3 files changed, 184 insertions(+), 147 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
> index f4b3bd8..53b50c2 100644
> --- a/drivers/net/ethernet/cadence/Kconfig
> +++ b/drivers/net/ethernet/cadence/Kconfig
> @@ -22,7 +22,7 @@ if NET_VENDOR_CADENCE
>  config MACB
>  	tristate "Cadence MACB/GEM support"
>  	depends on HAS_DMA && COMMON_CLK
> -	select PHYLIB
> +	select PHYLINK
>  	---help---
>  	  The Cadence MACB ethernet interface is found on many Atmel AT32 and
>  	  AT91 parts.  This driver also supports the Cadence GEM (Gigabit
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 03983bd..a400705 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -11,6 +11,7 @@
>  #include <linux/ptp_clock_kernel.h>
>  #include <linux/net_tstamp.h>
>  #include <linux/interrupt.h>
> +#include <linux/phylink.h>
>  
>  #if defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) || defined(CONFIG_MACB_USE_HWSTAMP)
>  #define MACB_EXT_DESC
> @@ -1232,6 +1233,8 @@ struct macb {
>  	u32	rx_intr_mask;
>  
>  	struct macb_pm_data pm_data;
> +	struct phylink *pl;
> +	struct phylink_config pl_config;
>  };
>  
>  #ifdef CONFIG_MACB_USE_HWSTAMP
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index b884cf7..15016ff 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -432,115 +432,160 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
>  		netdev_err(dev, "adjusting tx_clk failed.\n");
>  }
>  
> -static void macb_handle_link_change(struct net_device *dev)
> +static void gem_phylink_validate(struct phylink_config *pl_config,
> +				 unsigned long *supported,
> +				 struct phylink_link_state *state)
>  {
> -	struct macb *bp = netdev_priv(dev);
> -	struct phy_device *phydev = dev->phydev;
> +	struct net_device *netdev = to_net_dev(pl_config->dev);
> +	struct macb *bp = netdev_priv(netdev);
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_GMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +		if (!macb_is_gem(bp))
> +			goto empty_set;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_GMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> +			phylink_set(mask, 1000baseT_Full);
> +			phylink_set(mask, 1000baseX_Full);
> +			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
> +				phylink_set(mask, 1000baseT_Half);
> +		}
> +	/* fallthrough */
> +	case PHY_INTERFACE_MODE_MII:
> +	case PHY_INTERFACE_MODE_RMII:
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 100baseT_Full);
> +		break;
> +	default:
> +		goto empty_set;
> +	}
> +
> +	linkmode_and(supported, supported, mask);
> +	linkmode_and(state->advertising, state->advertising, mask);
> +	return;
> +
> +empty_set:
> +	linkmode_zero(supported);
> +}
> +
> +static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
> +				      struct phylink_link_state *state)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
> +			   const struct phylink_link_state *state)
> +{
> +	struct net_device *netdev = to_net_dev(pl_config->dev);
> +	struct macb *bp = netdev_priv(netdev);
> +	bool change_interface = bp->phy_interface != state->interface;
>  	unsigned long flags;
> -	int status_change = 0;
>  
>  	spin_lock_irqsave(&bp->lock, flags);
>  
> -	if (phydev->link) {
> -		if ((bp->speed != phydev->speed) ||
> -		    (bp->duplex != phydev->duplex)) {
> -			u32 reg;
> +	if (change_interface)
> +		bp->phy_interface = state->interface;
>  
> -			reg = macb_readl(bp, NCFGR);
> -			reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
> -			if (macb_is_gem(bp))
> -				reg &= ~GEM_BIT(GBE);
> +	if (!phylink_autoneg_inband(mode) &&
> +	    (bp->speed != state->speed ||
> +	     bp->duplex != state->duplex)) {
> +		u32 reg;
>  
> -			if (phydev->duplex)
> -				reg |= MACB_BIT(FD);
> -			if (phydev->speed == SPEED_100)
> -				reg |= MACB_BIT(SPD);
> -			if (phydev->speed == SPEED_1000 &&
> -			    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> -				reg |= GEM_BIT(GBE);
> -
> -			macb_or_gem_writel(bp, NCFGR, reg);
> +		reg = macb_readl(bp, NCFGR);
> +		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
> +		if (macb_is_gem(bp))
> +			reg &= ~GEM_BIT(GBE);
> +		if (state->duplex)
> +			reg |= MACB_BIT(FD);
>  
> -			bp->speed = phydev->speed;
> -			bp->duplex = phydev->duplex;
> -			status_change = 1;
> +		switch (state->speed) {
> +		case SPEED_1000:
> +			reg |= GEM_BIT(GBE);
> +			break;
> +		case SPEED_100:
> +			reg |= MACB_BIT(SPD);
> +			break;
> +		default:
> +			break;
>  		}
> -	}
> +		macb_or_gem_writel(bp, NCFGR, reg);
>  
> -	if (phydev->link != bp->link) {
> -		if (!phydev->link) {
> -			bp->speed = 0;
> -			bp->duplex = -1;
> -		}
> -		bp->link = phydev->link;
> +		bp->speed = state->speed;
> +		bp->duplex = state->duplex;
>  
> -		status_change = 1;
> +		if (state->link)
> +			macb_set_tx_clk(bp->tx_clk, state->speed, netdev);
>  	}
>  
>  	spin_unlock_irqrestore(&bp->lock, flags);
> +}
>  
> -	if (status_change) {
> -		if (phydev->link) {
> -			/* Update the TX clock rate if and only if the link is
> -			 * up and there has been a link change.
> -			 */
> -			macb_set_tx_clk(bp->tx_clk, phydev->speed, dev);
> +static void gem_mac_link_up(struct phylink_config *pl_config, unsigned int mode,
> +			    phy_interface_t interface, struct phy_device *phy)
> +{
> +	struct net_device *netdev = to_net_dev(pl_config->dev);
> +	struct macb *bp = netdev_priv(netdev);
>  
> -			netif_carrier_on(dev);
> -			netdev_info(dev, "link up (%d/%s)\n",
> -				    phydev->speed,
> -				    phydev->duplex == DUPLEX_FULL ?
> -				    "Full" : "Half");
> -		} else {
> -			netif_carrier_off(dev);
> -			netdev_info(dev, "link down\n");
> -		}
> -	}
> +	bp->link = 1;
> +	/* Enable TX and RX */
> +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
>  }
>  
> +static void gem_mac_link_down(struct phylink_config *pl_config,
> +			      unsigned int mode, phy_interface_t interface)
> +{
> +	struct net_device *netdev = to_net_dev(pl_config->dev);
> +	struct macb *bp = netdev_priv(netdev);
> +
> +	bp->link = 0;
> +	/* Disable TX and RX */
> +	macb_writel(bp, NCR,
> +		    macb_readl(bp, NCR) & ~(MACB_BIT(RE) | MACB_BIT(TE)));
> +}
> +
> +static const struct phylink_mac_ops gem_phylink_ops = {
> +	.validate = gem_phylink_validate,
> +	.mac_link_state = gem_phylink_mac_link_state,
> +	.mac_config = gem_mac_config,
> +	.mac_link_up = gem_mac_link_up,
> +	.mac_link_down = gem_mac_link_down,
> +};
> +
>  /* based on au1000_eth. c*/
> -static int macb_mii_probe(struct net_device *dev)
> +static int macb_mii_probe(struct net_device *dev, phy_interface_t phy_mode)
>  {
>  	struct macb *bp = netdev_priv(dev);
>  	struct phy_device *phydev;
>  	struct device_node *np;
> -	int ret, i;
> +	int ret;
>  
>  	np = bp->pdev->dev.of_node;
>  	ret = 0;
>  
> -	if (np) {
> -		if (of_phy_is_fixed_link(np)) {
> -			bp->phy_node = of_node_get(np);
> -		} else {
> -			bp->phy_node = of_parse_phandle(np, "phy-handle", 0);
> -			/* fallback to standard phy registration if no
> -			 * phy-handle was found nor any phy found during
> -			 * dt phy registration
> -			 */
> -			if (!bp->phy_node && !phy_find_first(bp->mii_bus)) {
> -				for (i = 0; i < PHY_MAX_ADDR; i++) {
> -					phydev = mdiobus_scan(bp->mii_bus, i);
> -					if (IS_ERR(phydev) &&
> -					    PTR_ERR(phydev) != -ENODEV) {
> -						ret = PTR_ERR(phydev);
> -						break;
> -					}
> -				}
> -
> -				if (ret)
> -					return -ENODEV;
> -			}
> -		}
> +	bp->pl_config.dev = &dev->dev;
> +	bp->pl_config.type = PHYLINK_NETDEV;
> +	bp->pl = phylink_create(&bp->pl_config, of_fwnode_handle(np),
> +				phy_mode, &gem_phylink_ops);
> +	if (IS_ERR(bp->pl)) {
> +		netdev_err(dev,
> +			   "error creating PHYLINK: %ld\n", PTR_ERR(bp->pl));
> +		return PTR_ERR(bp->pl);
>  	}
>  
> -	if (bp->phy_node) {
> -		phydev = of_phy_connect(dev, bp->phy_node,
> -					&macb_handle_link_change, 0,
> -					bp->phy_interface);
> -		if (!phydev)
> -			return -ENODEV;
> -	} else {
> +	ret = phylink_of_phy_connect(bp->pl, np, 0);
> +	if (ret == -ENODEV && bp->mii_bus) {
>  		phydev = phy_find_first(bp->mii_bus);
>  		if (!phydev) {
>  			netdev_err(dev, "no PHY found\n");
> @@ -548,32 +593,22 @@ static int macb_mii_probe(struct net_device *dev)
>  		}
>  
>  		/* attach the mac to the phy */
> -		ret = phy_connect_direct(dev, phydev, &macb_handle_link_change,
> -					 bp->phy_interface);
> +		ret = phylink_connect_phy(bp->pl, phydev);
>  		if (ret) {
>  			netdev_err(dev, "Could not attach to PHY\n");
>  			return ret;
>  		}
>  	}
>  
> -	/* mask with MAC supported features */
> -	if (macb_is_gem(bp) && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> -		phy_set_max_speed(phydev, SPEED_1000);
> -	else
> -		phy_set_max_speed(phydev, SPEED_100);
> -
> -	if (bp->caps & MACB_CAPS_NO_GIGABIT_HALF)
> -		phy_remove_link_mode(phydev,
> -				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> -
>  	bp->link = 0;
> -	bp->speed = 0;
> -	bp->duplex = -1;
> +	bp->speed = SPEED_UNKNOWN;
> +	bp->duplex = DUPLEX_UNKNOWN;
> +	bp->phy_interface = PHY_INTERFACE_MODE_MAX;
>  
> -	return 0;
> +	return ret;
>  }
>  
> -static int macb_mii_init(struct macb *bp)
> +static int macb_mii_init(struct macb *bp, phy_interface_t phy_mode)
>  {
>  	struct device_node *np;
>  	int err = -ENXIO;
> @@ -598,22 +633,12 @@ static int macb_mii_init(struct macb *bp)
>  	dev_set_drvdata(&bp->dev->dev, bp->mii_bus);
>  
>  	np = bp->pdev->dev.of_node;
> -	if (np && of_phy_is_fixed_link(np)) {
> -		if (of_phy_register_fixed_link(np) < 0) {
> -			dev_err(&bp->pdev->dev,
> -				"broken fixed-link specification %pOF\n", np);
> -			goto err_out_free_mdiobus;
> -		}
> -
> -		err = mdiobus_register(bp->mii_bus);
> -	} else {
> -		err = of_mdiobus_register(bp->mii_bus, np);
> -	}
> +	err = of_mdiobus_register(bp->mii_bus, np);
>  
>  	if (err)
>  		goto err_out_free_fixed_link;
>  
> -	err = macb_mii_probe(bp->dev);
> +	err = macb_mii_probe(bp->dev, phy_mode);
>  	if (err)
>  		goto err_out_unregister_bus;
>  
> @@ -624,7 +649,6 @@ static int macb_mii_init(struct macb *bp)
>  err_out_free_fixed_link:
>  	if (np && of_phy_is_fixed_link(np))
>  		of_phy_deregister_fixed_link(np);
> -err_out_free_mdiobus:
>  	of_node_put(bp->phy_node);
>  	mdiobus_free(bp->mii_bus);
>  err_out:
> @@ -2417,12 +2441,6 @@ static int macb_open(struct net_device *dev)
>  	/* carrier starts down */
>  	netif_carrier_off(dev);
>  
> -	/* if the phy is not yet register, retry later*/
> -	if (!dev->phydev) {
> -		err = -EAGAIN;
> -		goto pm_exit;
> -	}
> -
>  	/* RX buffers initialization */
>  	macb_init_rx_buffer_size(bp, bufsz);
>  
> @@ -2440,7 +2458,7 @@ static int macb_open(struct net_device *dev)
>  	macb_init_hw(bp);
>  
>  	/* schedule a link state check */
> -	phy_start(dev->phydev);
> +	phylink_start(bp->pl);
>  
>  	netif_tx_start_all_queues(dev);
>  
> @@ -2467,8 +2485,7 @@ static int macb_close(struct net_device *dev)
>  	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
>  		napi_disable(&queue->napi);
>  
> -	if (dev->phydev)
> -		phy_stop(dev->phydev);
> +	phylink_stop(bp->pl);
>  
>  	spin_lock_irqsave(&bp->lock, flags);
>  	macb_reset_hw(bp);
> @@ -3157,6 +3174,23 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
>  	return ret;
>  }
>  
> +static int gem_ethtool_get_link_ksettings(struct net_device *netdev,
> +					  struct ethtool_link_ksettings *cmd)
> +{
> +	struct macb *bp = netdev_priv(netdev);
> +
> +	return phylink_ethtool_ksettings_get(bp->pl, cmd);
> +}
> +
> +static int
> +gem_ethtool_set_link_ksettings(struct net_device *netdev,
> +			       const struct ethtool_link_ksettings *cmd)
> +{
> +	struct macb *bp = netdev_priv(netdev);
> +
> +	return phylink_ethtool_ksettings_set(bp->pl, cmd);
> +}
> +
>  static const struct ethtool_ops macb_ethtool_ops = {
>  	.get_regs_len		= macb_get_regs_len,
>  	.get_regs		= macb_get_regs,
> @@ -3164,8 +3198,8 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
>  	.get_ts_info		= ethtool_op_get_ts_info,
>  	.get_wol		= macb_get_wol,
>  	.set_wol		= macb_set_wol,
> -	.get_link_ksettings     = phy_ethtool_get_link_ksettings,
> -	.set_link_ksettings     = phy_ethtool_set_link_ksettings,
> +	.get_link_ksettings     = gem_ethtool_get_link_ksettings,
> +	.set_link_ksettings     = gem_ethtool_set_link_ksettings,
>  	.get_ringparam		= macb_get_ringparam,
>  	.set_ringparam		= macb_set_ringparam,
>  };
> @@ -3178,8 +3212,8 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
>  	.get_ethtool_stats	= gem_get_ethtool_stats,
>  	.get_strings		= gem_get_ethtool_strings,
>  	.get_sset_count		= gem_get_sset_count,
> -	.get_link_ksettings     = phy_ethtool_get_link_ksettings,
> -	.set_link_ksettings     = phy_ethtool_set_link_ksettings,
> +	.get_link_ksettings     = gem_ethtool_get_link_ksettings,
> +	.set_link_ksettings     = gem_ethtool_set_link_ksettings,
>  	.get_ringparam		= macb_get_ringparam,
>  	.set_ringparam		= macb_set_ringparam,
>  	.get_rxnfc			= gem_get_rxnfc,
> @@ -3188,17 +3222,13 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
>  
>  static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>  {
> -	struct phy_device *phydev = dev->phydev;
>  	struct macb *bp = netdev_priv(dev);
>  
>  	if (!netif_running(dev))
>  		return -EINVAL;
>  
> -	if (!phydev)
> -		return -ENODEV;
> -
>  	if (!bp->ptp_info)
> -		return phy_mii_ioctl(phydev, rq, cmd);
> +		return phylink_mii_ioctl(bp->pl, rq, cmd);
>  
>  	switch (cmd) {
>  	case SIOCSHWTSTAMP:
> @@ -3206,7 +3236,7 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>  	case SIOCGHWTSTAMP:
>  		return bp->ptp_info->get_hwtst(dev, rq);
>  	default:
> -		return phy_mii_ioctl(phydev, rq, cmd);
> +		return phylink_mii_ioctl(bp->pl, rq, cmd);
>  	}
>  }
>  
> @@ -3708,7 +3738,7 @@ static int at91ether_open(struct net_device *dev)
>  			     MACB_BIT(HRESP));
>  
>  	/* schedule a link state check */
> -	phy_start(dev->phydev);
> +	phylink_start(lp->pl);
>  
>  	netif_start_queue(dev);
>  
> @@ -4181,7 +4211,7 @@ static int macb_probe(struct platform_device *pdev)
>  	struct clk *tsu_clk = NULL;
>  	unsigned int queue_mask, num_queues;
>  	bool native_io;
> -	struct phy_device *phydev;
> +	//struct phy_device *phydev;
>  	phy_interface_t interface;
>  	struct net_device *dev;
>  	struct resource *regs;
> @@ -4312,21 +4342,17 @@ static int macb_probe(struct platform_device *pdev)
>  	err = of_get_phy_mode(np, &interface);
>  	if (err)
>  		/* not found in DT, MII by default */
> -		bp->phy_interface = PHY_INTERFACE_MODE_MII;
> -	else
> -		bp->phy_interface = interface;
> +		interface = PHY_INTERFACE_MODE_MII;
>  
>  	/* IP specific init */
>  	err = init(pdev);
>  	if (err)
>  		goto err_out_free_netdev;
>  
> -	err = macb_mii_init(bp);
> +	err = macb_mii_init(bp, interface);
>  	if (err)
>  		goto err_out_free_netdev;
>  
> -	phydev = dev->phydev;
> -
>  	netif_carrier_off(dev);
>  
>  	err = register_netdev(dev);
> @@ -4338,8 +4364,6 @@ static int macb_probe(struct platform_device *pdev)
>  	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
>  		     (unsigned long)bp);
>  
> -	phy_attached_info(phydev);
> -
>  	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
>  		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
>  		    dev->base_addr, dev->irq, dev->dev_addr);
> @@ -4350,7 +4374,9 @@ static int macb_probe(struct platform_device *pdev)
>  	return 0;
>  
>  err_out_unregister_mdio:
> -	phy_disconnect(dev->phydev);
> +	rtnl_lock();
> +	phylink_disconnect_phy(bp->pl);
> +	rtnl_unlock();
>  	mdiobus_unregister(bp->mii_bus);
>  	of_node_put(bp->phy_node);
>  	if (np && of_phy_is_fixed_link(np))
> @@ -4384,13 +4410,18 @@ static int macb_remove(struct platform_device *pdev)
>  
>  	if (dev) {
>  		bp = netdev_priv(dev);
> -		if (dev->phydev)
> -			phy_disconnect(dev->phydev);
> +		if (bp->pl) {
> +			rtnl_lock();
> +			phylink_disconnect_phy(bp->pl);
> +			rtnl_unlock();
> +		}
>  		mdiobus_unregister(bp->mii_bus);
>  		if (np && of_phy_is_fixed_link(np))
>  			of_phy_deregister_fixed_link(np);
>  		dev->phydev = NULL;
>  		mdiobus_free(bp->mii_bus);
> +		if (bp->pl)
> +			phylink_destroy(bp->pl);
>  
>  		unregister_netdev(dev);
>  		pm_runtime_disable(&pdev->dev);
> @@ -4433,8 +4464,9 @@ static int __maybe_unused macb_suspend(struct device *dev)
>  		for (q = 0, queue = bp->queues; q < bp->num_queues;
>  		     ++q, ++queue)
>  			napi_disable(&queue->napi);
> -		phy_stop(netdev->phydev);
> -		phy_suspend(netdev->phydev);
> +		phylink_stop(bp->pl);
> +		if (netdev->phydev)
> +			phy_suspend(netdev->phydev);
>  		spin_lock_irqsave(&bp->lock, flags);
>  		macb_reset_hw(bp);
>  		spin_unlock_irqrestore(&bp->lock, flags);
> @@ -4482,9 +4514,11 @@ static int __maybe_unused macb_resume(struct device *dev)
>  		for (q = 0, queue = bp->queues; q < bp->num_queues;
>  		     ++q, ++queue)
>  			napi_enable(&queue->napi);
> -		phy_resume(netdev->phydev);
> -		phy_init_hw(netdev->phydev);
> -		phy_start(netdev->phydev);
> +		if (netdev->phydev) {
> +			phy_resume(netdev->phydev);
> +			phy_init_hw(netdev->phydev);
> +		}
> +		phylink_start(bp->pl);
>  	}
>  
>  	bp->macbgem_ops.mog_init_rings(bp);
> -- 
> 1.7.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
