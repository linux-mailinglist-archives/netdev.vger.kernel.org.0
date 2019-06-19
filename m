Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9F994B4DD
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbfFSJW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:22:28 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60516 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730996AbfFSJW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:22:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pAwimO5Lo/uvB3CsSC/tQ6L9pFDwH53vNS5t+MNMajU=; b=DEgnUsQoWVd+ekhNjNBhNrONi
        zbc3prJsmG0eDt6IimumV0RzDBi3uQFF+ceL9H0LxOYRarKcBu0rlfT/oCWbhawCzPCV9vQfqp5Hs
        4p2E+tCthbl2ogFS//2kxSVKMMEUJfygrwGDU7kSvX/BRC1F3U9RJ9MScYsBLIIzhoRZiqHMajOIT
        0aD2+rsVz29ALvKbCpcHB3VjsNhzfldSGbwSRvnxyuWHM0OCs4XC5nCQlst2ymkKF9UdAuOQUqebr
        xNAds/mTAC0AUs0G8Hg1umbc4xNEea8EC8PRoEc2iGFi02rq1/vwO71fnnr8j4Ri1zwzbbHeYXmpJ
        W+4Q+Gx+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59816)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hdWnJ-0007q2-K4; Wed, 19 Jun 2019 10:22:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hdWnF-0001ME-GN; Wed, 19 Jun 2019 10:22:13 +0100
Date:   Wed, 19 Jun 2019 10:22:13 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v2 1/5] net: macb: add phylink support
Message-ID: <20190619092213.32fpgehe74qhln5z@shell.armlinux.org.uk>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
 <1560933636-29684-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560933636-29684-1-git-send-email-pthombar@cadence.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 09:40:36AM +0100, Parshuram Thombare wrote:
> This patch replace phylib API's by phylink API's.
> 
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
> ---
>  drivers/net/ethernet/cadence/Kconfig     |   2 +-
>  drivers/net/ethernet/cadence/macb.h      |   3 +
>  drivers/net/ethernet/cadence/macb_main.c | 312 +++++++++++++----------
>  3 files changed, 182 insertions(+), 135 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
> index 1766697c9c5a..d71411a71587 100644
> --- a/drivers/net/ethernet/cadence/Kconfig
> +++ b/drivers/net/ethernet/cadence/Kconfig
> @@ -22,7 +22,7 @@ if NET_VENDOR_CADENCE
>  config MACB
>  	tristate "Cadence MACB/GEM support"
>  	depends on HAS_DMA
> -	select PHYLIB
> +	select PHYLINK
>  	---help---
>  	  The Cadence MACB ethernet interface is found on many Atmel AT32 and
>  	  AT91 parts.  This driver also supports the Cadence GEM (Gigabit
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 00ee5e8e0ff0..35ed13236c8b 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -14,6 +14,7 @@
>  #include <linux/ptp_clock_kernel.h>
>  #include <linux/net_tstamp.h>
>  #include <linux/interrupt.h>
> +#include <linux/phylink.h>
>  
>  #if defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) || defined(CONFIG_MACB_USE_HWSTAMP)
>  #define MACB_EXT_DESC
> @@ -1227,6 +1228,8 @@ struct macb {
>  	u32	rx_intr_mask;
>  
>  	struct macb_pm_data pm_data;
> +	struct phylink *pl;
> +	struct phylink_config pl_config;
>  };
>  
>  #ifdef CONFIG_MACB_USE_HWSTAMP
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index c545c5b435d8..830af86d3c65 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -39,6 +39,7 @@
>  #include <linux/tcp.h>
>  #include <linux/iopoll.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/phylink.h>
>  #include "macb.h"
>  
>  /* This structure is only used for MACB on SiFive FU540 devices */
> @@ -438,115 +439,150 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
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
> -	unsigned long flags;
> -	int status_change = 0;
> +	struct net_device *netdev = to_net_dev(pl_config->dev);
> +	struct macb *bp = netdev_priv(netdev);
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_GMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
> +			phylink_set(mask, 1000baseT_Full);
> +			phylink_set(mask, 1000baseX_Full);
> +			if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF)) {
> +				phylink_set(mask, 1000baseT_Half);
> +				phylink_set(mask, 1000baseT_Half);
> +			}
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
> +		break;
> +	}
>  
> -	spin_lock_irqsave(&bp->lock, flags);
> +	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);

Consider using linkmode_and() here.

> +}
>  
> -	if (phydev->link) {
> -		if ((bp->speed != phydev->speed) ||
> -		    (bp->duplex != phydev->duplex)) {
> -			u32 reg;
> +static int gem_phylink_mac_link_state(struct phylink_config *pl_config,
> +				      struct phylink_link_state *state)
> +{
> +	struct net_device *netdev = to_net_dev(pl_config->dev);
> +	struct macb *bp = netdev_priv(netdev);
>  
> -			reg = macb_readl(bp, NCFGR);
> -			reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
> -			if (macb_is_gem(bp))
> -				reg &= ~GEM_BIT(GBE);
> +	state->speed = bp->speed;
> +	state->duplex = bp->duplex;
> +	state->link = bp->link;

You can't read from the hardware what the actual MAC is doing?

> +	return 1;
> +}
>  
> -			if (phydev->duplex)
> -				reg |= MACB_BIT(FD);
> -			if (phydev->speed == SPEED_100)
> -				reg |= MACB_BIT(SPD);
> -			if (phydev->speed == SPEED_1000 &&
> -			    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> -				reg |= GEM_BIT(GBE);
> +static void gem_mac_config(struct phylink_config *pl_config, unsigned int mode,
> +			   const struct phylink_link_state *state)
> +{
> +	struct net_device *netdev = to_net_dev(pl_config->dev);
> +	struct macb *bp = netdev_priv(netdev);
> +	unsigned long flags;
>  
> -			macb_or_gem_writel(bp, NCFGR, reg);
> +	spin_lock_irqsave(&bp->lock, flags);
>  
> -			bp->speed = phydev->speed;
> -			bp->duplex = phydev->duplex;
> -			status_change = 1;
> -		}
> -	}
> +	if (bp->speed != state->speed ||
> +	    bp->duplex != state->duplex) {

Please read the updated phylink documentation - state->{speed,duplex}
are not always valid depending on the negotiation mode.

> +		u32 reg;
>  
> -	if (phydev->link != bp->link) {
> -		if (!phydev->link) {
> -			bp->speed = 0;
> -			bp->duplex = -1;
> +		reg = macb_readl(bp, NCFGR);
> +		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
> +		if (macb_is_gem(bp))
> +			reg &= ~GEM_BIT(GBE);
> +		if (state->duplex)
> +			reg |= MACB_BIT(FD);
> +
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
> -		bp->link = phydev->link;
> +		macb_or_gem_writel(bp, NCFGR, reg);
> +
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
> +}
> +
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
>  }
>  
> +static const struct phylink_mac_ops gem_phylink_ops = {
> +	.validate = gem_phylink_validate,
> +	.mac_link_state = gem_phylink_mac_link_state,
> +	.mac_config = gem_mac_config,
> +	.mac_link_up = gem_mac_link_up,
> +	.mac_link_down = gem_mac_link_down,
> +};
> +
>  /* based on au1000_eth. c*/
>  static int macb_mii_probe(struct net_device *dev)
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
> +				bp->phy_interface, &gem_phylink_ops);
> +	if (IS_ERR(bp->pl)) {
> +		netdev_err(dev,
> +			   "error creating PHYLINK: %ld\n", PTR_ERR(bp->pl));
> +		return PTR_ERR(bp->pl);
>  	}

At this point bp->pl can never be NULL.

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
> @@ -554,29 +590,18 @@ static int macb_mii_probe(struct net_device *dev)
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
>  	bp->speed = 0;
>  	bp->duplex = -1;
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int macb_mii_init(struct macb *bp)
> @@ -604,17 +629,7 @@ static int macb_mii_init(struct macb *bp)
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
> @@ -630,7 +645,6 @@ static int macb_mii_init(struct macb *bp)
>  err_out_free_fixed_link:
>  	if (np && of_phy_is_fixed_link(np))
>  		of_phy_deregister_fixed_link(np);
> -err_out_free_mdiobus:
>  	of_node_put(bp->phy_node);
>  	mdiobus_free(bp->mii_bus);
>  err_out:
> @@ -2422,7 +2436,7 @@ static int macb_open(struct net_device *dev)
>  	netif_carrier_off(dev);
>  
>  	/* if the phy is not yet register, retry later*/
> -	if (!dev->phydev) {
> +	if (!bp->pl) {

So this check is unnecessary.

>  		err = -EAGAIN;
>  		goto pm_exit;
>  	}
> @@ -2444,7 +2458,7 @@ static int macb_open(struct net_device *dev)
>  	macb_init_hw(bp);
>  
>  	/* schedule a link state check */
> -	phy_start(dev->phydev);
> +	phylink_start(bp->pl);
>  
>  	netif_tx_start_all_queues(dev);
>  
> @@ -2471,8 +2485,8 @@ static int macb_close(struct net_device *dev)
>  	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
>  		napi_disable(&queue->napi);
>  
> -	if (dev->phydev)
> -		phy_stop(dev->phydev);
> +	if (bp->pl)
> +		phylink_stop(bp->pl);

Ditto.

>  
>  	spin_lock_irqsave(&bp->lock, flags);
>  	macb_reset_hw(bp);
> @@ -3161,6 +3175,29 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
>  	return ret;
>  }
>  
> +static int gem_ethtool_get_link_ksettings(struct net_device *netdev,
> +					  struct ethtool_link_ksettings *cmd)
> +{
> +	struct macb *bp = netdev_priv(netdev);
> +
> +	if (!bp->pl)
> +		return -ENOTSUPP;

Ditto.

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
> +	if (!bp->pl)
> +		return -ENOTSUPP;

Ditto.

> +
> +	return phylink_ethtool_ksettings_set(bp->pl, cmd);
> +}
> +
>  static const struct ethtool_ops macb_ethtool_ops = {
>  	.get_regs_len		= macb_get_regs_len,
>  	.get_regs		= macb_get_regs,
> @@ -3168,8 +3205,8 @@ static const struct ethtool_ops macb_ethtool_ops = {
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
> @@ -3182,8 +3219,8 @@ static const struct ethtool_ops gem_ethtool_ops = {
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
> @@ -3192,17 +3229,16 @@ static const struct ethtool_ops gem_ethtool_ops = {
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
> +	if (!bp->pl)
>  		return -ENODEV;

Ditto.

>  
>  	if (!bp->ptp_info)
> -		return phy_mii_ioctl(phydev, rq, cmd);
> +		return phylink_mii_ioctl(bp->pl, rq, cmd);
>  
>  	switch (cmd) {
>  	case SIOCSHWTSTAMP:
> @@ -3210,7 +3246,7 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>  	case SIOCGHWTSTAMP:
>  		return bp->ptp_info->get_hwtst(dev, rq);
>  	default:
> -		return phy_mii_ioctl(phydev, rq, cmd);
> +		return phylink_mii_ioctl(bp->pl, rq, cmd);
>  	}
>  }
>  
> @@ -3710,7 +3746,7 @@ static int at91ether_open(struct net_device *dev)
>  			     MACB_BIT(HRESP));
>  
>  	/* schedule a link state check */
> -	phy_start(dev->phydev);
> +	phylink_start(lp->pl);
>  
>  	netif_start_queue(dev);
>  
> @@ -4183,13 +4219,12 @@ static int macb_probe(struct platform_device *pdev)
>  	struct clk *tsu_clk = NULL;
>  	unsigned int queue_mask, num_queues;
>  	bool native_io;
> -	struct phy_device *phydev;
>  	struct net_device *dev;
>  	struct resource *regs;
>  	void __iomem *mem;
>  	const char *mac;
>  	struct macb *bp;
> -	int err, val;
> +	int err, val, phy_mode;
>  
>  	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	mem = devm_ioremap_resource(&pdev->dev, regs);
> @@ -4310,12 +4345,12 @@ static int macb_probe(struct platform_device *pdev)
>  		macb_get_hwaddr(bp);
>  	}
>  
> -	err = of_get_phy_mode(np);
> -	if (err < 0)
> +	phy_mode = of_get_phy_mode(np);
> +	if (phy_mode < 0)
>  		/* not found in DT, MII by default */
>  		bp->phy_interface = PHY_INTERFACE_MODE_MII;
>  	else
> -		bp->phy_interface = err;
> +		bp->phy_interface = phy_mode;

The phy interface mode is managed by phylink - and there are phys out
there that dynamically change their link mode.  You may wish to update
the link mode in your mac_config() implementation too.

>  
>  	/* IP specific init */
>  	err = init(pdev);
> @@ -4326,8 +4361,6 @@ static int macb_probe(struct platform_device *pdev)
>  	if (err)
>  		goto err_out_free_netdev;
>  
> -	phydev = dev->phydev;
> -
>  	netif_carrier_off(dev);
>  
>  	err = register_netdev(dev);
> @@ -4339,7 +4372,8 @@ static int macb_probe(struct platform_device *pdev)
>  	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
>  		     (unsigned long)bp);
>  
> -	phy_attached_info(phydev);
> +	if (dev->phydev)
> +		phy_attached_info(dev->phydev);

phylink already prints information about the attached phy, why do we
need another print here?

>  
>  	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
>  		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
> @@ -4351,7 +4385,9 @@ static int macb_probe(struct platform_device *pdev)
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
> @@ -4385,13 +4421,18 @@ static int macb_remove(struct platform_device *pdev)
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
> @@ -4434,8 +4475,9 @@ static int __maybe_unused macb_suspend(struct device *dev)
>  		for (q = 0, queue = bp->queues; q < bp->num_queues;
>  		     ++q, ++queue)
>  			napi_disable(&queue->napi);
> -		phy_stop(netdev->phydev);
> -		phy_suspend(netdev->phydev);
> +		phylink_stop(bp->pl);
> +		if (netdev->phydev)
> +			phy_suspend(netdev->phydev);

When the attached phy is stopped, the state machine suspends the phy.
Why do we need an explicit call to phy_suspend() here, bypassing
phylink?

>  		spin_lock_irqsave(&bp->lock, flags);
>  		macb_reset_hw(bp);
>  		spin_unlock_irqrestore(&bp->lock, flags);
> @@ -4483,9 +4525,11 @@ static int __maybe_unused macb_resume(struct device *dev)
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

When the phy is started, the phy state machine will resume the phy.
Same question as above.

>  	}
>  
>  	bp->macbgem_ops.mog_init_rings(bp);
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
