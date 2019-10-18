Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE76DCFC0
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443297AbfJRUIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:08:41 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40496 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439822AbfJRUIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:08:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HciCFesvA27iCdnjlIefcu2/VlKDIS7QwTam3wnk7rM=; b=XIv2ntq0ykLG/ptuvqm6Qwysb
        7FwI8P8pZ89cIjzzExJJiQOPDY1lyDUJsjyu1kV2u9s5u8eJWlgk+qgxJ+CAxjdSUPtApwhDVLdZN
        3+5PA3NECqbQcLDXJAYJE2zhzFDdPYliKc6+gp5NqiMOq0wZ347P6CXjU7vqvy2w5HzNB6zGNJPXj
        eyOMrxRsomVSK117rmiVgxF5Aaak9M+0x71Gsj4p4GV4NVz2gvocemhAZvwN5iBA+b+ri7RRyQ5Qb
        azM1HzylfD1pCS1BNPtoMNntS43K3uDbJC0LRhZteR6fNBDV1tXplaqaB/LLWuKih4ph9UJUPu8PP
        Mp2plnBjA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56078)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iLYXz-0001Lm-7Z; Fri, 18 Oct 2019 21:08:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iLYXv-0000zC-EW; Fri, 18 Oct 2019 21:08:23 +0100
Date:   Fri, 18 Oct 2019 21:08:23 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: macb: convert to phylink
Message-ID: <20191018200823.GK25745@shell.armlinux.org.uk>
References: <20191018143924.7375-1-antoine.tenart@bootlin.com>
 <20191018190810.GH24810@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018190810.GH24810@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thanks, review comments for Antoine below.

On Fri, Oct 18, 2019 at 09:08:10PM +0200, Andrew Lunn wrote:
> On Fri, Oct 18, 2019 at 04:39:24PM +0200, Antoine Tenart wrote:
> > This patch converts the MACB Ethernet driver to the Phylink framework.
> > The MAC configuration is moved to the Phylink ops and Phylink helpers
> > are now used in the ethtools functions.

What seems to be missing is "why".  It isn't obvious from the patch why
this conversion is being done...

> > Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> 
> Hi Antoine
> 
> Please include Russell King on any phylink patches.
> 
> Thanks
> 	Andrew
> 
> > ---
> >  drivers/net/ethernet/cadence/Kconfig     |   2 +-
> >  drivers/net/ethernet/cadence/macb.h      |   7 +-
> >  drivers/net/ethernet/cadence/macb_main.c | 439 +++++++++++++----------
> >  3 files changed, 252 insertions(+), 196 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
> > index f4b3bd85dfe3..53b50c24d9c9 100644
> > --- a/drivers/net/ethernet/cadence/Kconfig
> > +++ b/drivers/net/ethernet/cadence/Kconfig
> > @@ -22,7 +22,7 @@ if NET_VENDOR_CADENCE
> >  config MACB
> >  	tristate "Cadence MACB/GEM support"
> >  	depends on HAS_DMA && COMMON_CLK
> > -	select PHYLIB
> > +	select PHYLINK
> >  	---help---
> >  	  The Cadence MACB ethernet interface is found on many Atmel AT32 and
> >  	  AT91 parts.  This driver also supports the Cadence GEM (Gigabit
> > diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> > index 03983bd46eef..63fdf81eae47 100644
> > --- a/drivers/net/ethernet/cadence/macb.h
> > +++ b/drivers/net/ethernet/cadence/macb.h
> > @@ -7,7 +7,7 @@
> >  #ifndef _MACB_H
> >  #define _MACB_H
> >  
> > -#include <linux/phy.h>
> > +#include <linux/phylink.h>
> >  #include <linux/ptp_clock_kernel.h>
> >  #include <linux/net_tstamp.h>
> >  #include <linux/interrupt.h>
> > @@ -1186,9 +1186,8 @@ struct macb {
> >  
> >  	struct mii_bus		*mii_bus;
> >  	struct device_node	*phy_node;
> > -	int 			link;
> > -	int 			speed;
> > -	int 			duplex;
> > +	struct phylink		*phylink;
> > +	struct phylink_config	phylink_config;
> >  
> >  	u32			caps;
> >  	unsigned int		dma_burst_length;
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index 8e8d557901a9..effa333aa569 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -25,7 +25,7 @@
> >  #include <linux/dma-mapping.h>
> >  #include <linux/platform_data/macb.h>
> >  #include <linux/platform_device.h>
> > -#include <linux/phy.h>
> > +#include <linux/phylink.h>
> >  #include <linux/of.h>
> >  #include <linux/of_device.h>
> >  #include <linux/of_gpio.h>
> > @@ -388,6 +388,27 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> >  	return status;
> >  }
> >  
> > +static void macb_init_buffers(struct macb *bp)
> > +{
> > +	struct macb_queue *queue;
> > +	unsigned int q;
> > +
> > +	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
> > +		queue_writel(queue, RBQP, lower_32_bits(queue->rx_ring_dma));
> > +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> > +		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> > +			queue_writel(queue, RBQPH,
> > +				     upper_32_bits(queue->rx_ring_dma));
> > +#endif
> > +		queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
> > +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> > +		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> > +			queue_writel(queue, TBQPH,
> > +				     upper_32_bits(queue->tx_ring_dma));
> > +#endif
> > +	}
> > +}
> > +
> >  /**
> >   * macb_set_tx_clk() - Set a clock to a new frequency
> >   * @clk		Pointer to the clock to change
> > @@ -432,70 +453,194 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
> >  		netdev_err(dev, "adjusting tx_clk failed.\n");
> >  }
> >  
> > -static void macb_handle_link_change(struct net_device *dev)
> > +static void macb_validate(struct phylink_config *config,
> > +			  unsigned long *supported,
> > +			  struct phylink_link_state *state)
> >  {
> > -	struct macb *bp = netdev_priv(dev);
> > -	struct phy_device *phydev = dev->phydev;
> > +	struct net_device *ndev = to_net_dev(config->dev);
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +	struct macb *bp = netdev_priv(ndev);
> > +
> > +	/* We only support MII, RMII, GMII, RGMII & SGMII. */
> > +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> > +	    state->interface != PHY_INTERFACE_MODE_MII &&
> > +	    state->interface != PHY_INTERFACE_MODE_RMII &&
> > +	    state->interface != PHY_INTERFACE_MODE_GMII &&
> > +	    state->interface != PHY_INTERFACE_MODE_SGMII &&
> > +	    !phy_interface_mode_is_rgmii(state->interface)) {
> > +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +		return;
> > +	}
> > +
> > +	if (!macb_is_gem(bp) &&
> > +	    (state->interface == PHY_INTERFACE_MODE_GMII ||
> > +	     phy_interface_mode_is_rgmii(state->interface))) {
> > +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +		return;
> > +	}
> > +
> > +	phylink_set_port_modes(mask);
> > +	phylink_set(mask, Autoneg);
> > +	phylink_set(mask, Asym_Pause);
> > +
> > +	phylink_set(mask, 10baseT_Half);
> > +	phylink_set(mask, 10baseT_Full);
> > +	phylink_set(mask, 100baseT_Half);
> > +	phylink_set(mask, 100baseT_Full);
> > +
> > +	if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE &&
> > +	    (state->interface == PHY_INTERFACE_MODE_NA ||
> > +	     state->interface == PHY_INTERFACE_MODE_GMII ||
> > +	     state->interface == PHY_INTERFACE_MODE_SGMII ||
> > +	     phy_interface_mode_is_rgmii(state->interface))) {
> > +		phylink_set(mask, 1000baseT_Full);
> > +		phylink_set(mask, 1000baseX_Full);
> > +
> > +		if (!(bp->caps & MACB_CAPS_NO_GIGABIT_HALF))
> > +			phylink_set(mask, 1000baseT_Half);
> > +	}
> > +
> > +	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +	bitmap_and(state->advertising, state->advertising, mask,
> > +		   __ETHTOOL_LINK_MODE_MASK_NBITS);

This looks fine.

> > +}
> > +
> > +static int macb_mac_link_state(struct phylink_config *config,
> > +			       struct phylink_link_state *state)
> > +{
> > +	return -EOPNOTSUPP;

Without this implemented, phylink can't support in-band link modes
necessary for SFP support.  Since phylink is mostly about supporting
SFP cages and similar, I'm not sure what the point is.

Is there a future patch to add something here?

> > +}
> > +
> > +static void macb_mac_an_restart(struct phylink_config *config)
> > +{
> > +	/* Not supported */
> > +}
> > +
> > +static void macb_mac_config(struct phylink_config *config, unsigned int mode,
> > +			    const struct phylink_link_state *state)
> > +{
> > +	struct net_device *ndev = to_net_dev(config->dev);
> > +	struct macb *bp = netdev_priv(ndev);
> >  	unsigned long flags;
> > -	int status_change = 0;
> > +	u32 old_ctrl, ctrl;
> >  
> >  	spin_lock_irqsave(&bp->lock, flags);
> >  
> > -	if (phydev->link) {
> > -		if ((bp->speed != phydev->speed) ||
> > -		    (bp->duplex != phydev->duplex)) {
> > -			u32 reg;
> > +	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
> >  
> > -			reg = macb_readl(bp, NCFGR);
> > -			reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
> > -			if (macb_is_gem(bp))
> > -				reg &= ~GEM_BIT(GBE);
> > +	/* Clear all the bits we might set later */
> > +	ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE) |
> > +		  GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
> >  
> > -			if (phydev->duplex)
> > -				reg |= MACB_BIT(FD);
> > -			if (phydev->speed == SPEED_100)
> > -				reg |= MACB_BIT(SPD);
> > -			if (phydev->speed == SPEED_1000 &&
> > -			    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> > -				reg |= GEM_BIT(GBE);
> > +	if (state->speed == SPEED_1000)
> > +		ctrl |= GEM_BIT(GBE);
> > +	else if (state->speed == SPEED_100)
> > +		ctrl |= MACB_BIT(SPD);
> >  
> > -			macb_or_gem_writel(bp, NCFGR, reg);
> > +	if (state->duplex)
> > +		ctrl |= MACB_BIT(FD);
> >  
> > -			bp->speed = phydev->speed;
> > -			bp->duplex = phydev->duplex;
> > -			status_change = 1;
> > -		}
> > -	}
> > +	/* We do not support MLO_PAUSE_RX yet */
> > +	if (state->pause & MLO_PAUSE_TX)
> > +		ctrl |= MACB_BIT(PAE);
> >  
> > -	if (phydev->link != bp->link) {
> > -		if (!phydev->link) {
> > -			bp->speed = 0;
> > -			bp->duplex = -1;
> > -		}
> > -		bp->link = phydev->link;
> > +	if (state->interface == PHY_INTERFACE_MODE_SGMII)
> > +		ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);

Hmm, so you support SGMII but have no way to read the results of SGMII
negotiation?

> > +
> > +	/* Apply the new configuration, if any */
> > +	if (old_ctrl ^ ctrl) {
> > +		macb_or_gem_writel(bp, NCFGR, ctrl);
> >  
> > -		status_change = 1;
> > +		if (state->link)
> > +			macb_set_tx_clk(bp->tx_clk, state->speed, ndev);

Please see include/linux/phylink.h for documentation on the mac_config()
method.  It exhaustively describes which members of the state are valid
for each value of "mode", and describes which are not valid to be used.
"state->link" is one such case of an invalid use.

> >  	}
> >  
> >  	spin_unlock_irqrestore(&bp->lock, flags);
> > +}
> >  
> > -	if (status_change) {
> > -		if (phydev->link) {
> > -			/* Update the TX clock rate if and only if the link is
> > -			 * up and there has been a link change.
> > -			 */
> > -			macb_set_tx_clk(bp->tx_clk, phydev->speed, dev);
> > +static void macb_mac_link_down(struct phylink_config *config, unsigned int mode,
> > +			       phy_interface_t interface)
> > +{
> > +	struct net_device *ndev = to_net_dev(config->dev);
> > +	struct macb *bp = netdev_priv(ndev);
> > +	struct macb_queue *queue;
> > +	unsigned int q;
> > +	u32 ctrl;
> >  
> > -			netif_carrier_on(dev);
> > -			netdev_info(dev, "link up (%d/%s)\n",
> > -				    phydev->speed,
> > -				    phydev->duplex == DUPLEX_FULL ?
> > -				    "Full" : "Half");
> > -		} else {
> > -			netif_carrier_off(dev);
> > -			netdev_info(dev, "link down\n");
> > +	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> > +		queue_writel(queue, IDR,
> > +			     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
> > +
> > +	/* Disable Rx and Tx */
> > +	ctrl = macb_readl(bp, NCR) & ~(MACB_BIT(RE) | MACB_BIT(TE));
> > +	macb_writel(bp, NCR, ctrl);
> > +
> > +	netif_tx_stop_all_queues(ndev);
> > +}
> > +
> > +static void macb_mac_link_up(struct phylink_config *config, unsigned int mode,
> > +			     phy_interface_t interface, struct phy_device *phy)
> > +{
> > +	struct net_device *ndev = to_net_dev(config->dev);
> > +	struct macb *bp = netdev_priv(ndev);
> > +	struct macb_queue *queue;
> > +	unsigned int q;
> > +
> > +	/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
> > +	 * cleared the pipeline and control registers.
> > +	 */
> > +	bp->macbgem_ops.mog_init_rings(bp);
> > +	macb_init_buffers(bp);
> > +
> > +	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> > +		queue_writel(queue, IER,
> > +			     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
> > +
> > +	/* Enable Rx and Tx */
> > +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
> > +
> > +	netif_tx_wake_all_queues(ndev);
> > +}
> > +
> > +static const struct phylink_mac_ops macb_phylink_ops = {
> > +	.validate = macb_validate,
> > +	.mac_link_state = macb_mac_link_state,
> > +	.mac_an_restart = macb_mac_an_restart,
> > +	.mac_config = macb_mac_config,
> > +	.mac_link_down = macb_mac_link_down,
> > +	.mac_link_up = macb_mac_link_up,
> > +};
> > +
> > +static int macb_phylink_connect(struct macb *bp)
> > +{
> > +	struct net_device *dev = bp->dev;
> > +	struct phy_device *phydev;
> > +	int ret;
> > +
> > +	if (bp->phy_node) {
> > +		ret = phylink_of_phy_connect(bp->phylink, bp->phy_node, 0);

This looks quite odd.

phylink expects the second argument to always be the container device
node of the "phy-handle", "phy" or "phy-device" property, never the
node of the PHY itself.  Looking at how the driver sets up
bp->phy_node, it is the PHY's node itself sometimes, and in that case
will almost certainly fail.

> > +		if (ret) {
> > +			netdev_err(dev, "Could not attach PHY (%d)\n", ret);
> > +			return ret;
> > +		}
> > +	} else {
> > +		phydev = phy_find_first(bp->mii_bus);
> > +		if (!phydev) {
> > +			netdev_err(dev, "no PHY found\n");
> > +			return -ENXIO;
> > +		}
> > +
> > +		/* attach the mac to the phy */
> > +		ret = phylink_connect_phy(bp->phylink, phydev);
> > +		if (ret) {
> > +			netdev_err(dev, "Could not attach to PHY (%d)\n", ret);
> > +			return ret;
> >  		}

I'm not entirely sure what this is trying to achieve.

> >  	}
> > +
> > +	phylink_start(bp->phylink);

You're ready to handle a link-up event at this point in the driver?
I guess it's no worse than what the driver was doing with phylib.

> > +
> > +	return 0;
> >  }
> >  
> >  /* based on au1000_eth. c*/
> > @@ -534,42 +679,17 @@ static int macb_mii_probe(struct net_device *dev)
> >  		}
> >  	}
> >  
> > -	if (bp->phy_node) {
> > -		phydev = of_phy_connect(dev, bp->phy_node,
> > -					&macb_handle_link_change, 0,
> > -					bp->phy_interface);
> > -		if (!phydev)
> > -			return -ENODEV;
> > -	} else {
> > -		phydev = phy_find_first(bp->mii_bus);
> > -		if (!phydev) {
> > -			netdev_err(dev, "no PHY found\n");
> > -			return -ENXIO;
> > -		}
> > +	bp->phylink_config.dev = &dev->dev;
> > +	bp->phylink_config.type = PHYLINK_NETDEV;
> >  
> > -		/* attach the mac to the phy */
> > -		ret = phy_connect_direct(dev, phydev, &macb_handle_link_change,
> > -					 bp->phy_interface);
> > -		if (ret) {
> > -			netdev_err(dev, "Could not attach to PHY\n");
> > -			return ret;
> > -		}
> > +	bp->phylink = phylink_create(&bp->phylink_config, dev->dev.fwnode,
> > +				     bp->phy_interface, &macb_phylink_ops);
> > +	if (IS_ERR(bp->phylink)) {
> > +		netdev_err(dev, "Could not create a phylink instance (%ld)\n",
> > +			   PTR_ERR(bp->phylink));
> > +		return PTR_ERR(bp->phylink);
> >  	}

This looks fine.

> >  
> > -	/* mask with MAC supported features */
> > -	if (macb_is_gem(bp) && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> > -		phy_set_max_speed(phydev, SPEED_1000);
> > -	else
> > -		phy_set_max_speed(phydev, SPEED_100);
> > -
> > -	if (bp->caps & MACB_CAPS_NO_GIGABIT_HALF)
> > -		phy_remove_link_mode(phydev,
> > -				     ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> > -
> > -	bp->link = 0;
> > -	bp->speed = 0;
> > -	bp->duplex = -1;
> > -
> >  	return 0;
> >  }
> >  
> > @@ -598,20 +718,10 @@ static int macb_mii_init(struct macb *bp)
> >  	dev_set_drvdata(&bp->dev->dev, bp->mii_bus);
> >  
> >  	np = bp->pdev->dev.of_node;
> > -	if (np && of_phy_is_fixed_link(np)) {
> > -		if (of_phy_register_fixed_link(np) < 0) {
> > -			dev_err(&bp->pdev->dev,
> > -				"broken fixed-link specification %pOF\n", np);
> > -			goto err_out_free_mdiobus;
> > -		}
> > -
> > -		err = mdiobus_register(bp->mii_bus);
> > -	} else {
> > -		err = of_mdiobus_register(bp->mii_bus, np);
> > -	}
> >  
> > +	err = of_mdiobus_register(bp->mii_bus, np);
> >  	if (err)
> > -		goto err_out_free_fixed_link;
> > +		goto err_out_free_mdiobus;
> >  
> >  	err = macb_mii_probe(bp->dev);
> >  	if (err)
> > @@ -621,11 +731,7 @@ static int macb_mii_init(struct macb *bp)
> >  
> >  err_out_unregister_bus:
> >  	mdiobus_unregister(bp->mii_bus);
> > -err_out_free_fixed_link:
> > -	if (np && of_phy_is_fixed_link(np))
> > -		of_phy_deregister_fixed_link(np);
> >  err_out_free_mdiobus:
> > -	of_node_put(bp->phy_node);
> >  	mdiobus_free(bp->mii_bus);
> >  err_out:
> >  	return err;
> > @@ -1314,26 +1420,14 @@ static void macb_hresp_error_task(unsigned long data)
> >  	bp->macbgem_ops.mog_init_rings(bp);
> >  
> >  	/* Initialize TX and RX buffers */
> > -	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
> > -		queue_writel(queue, RBQP, lower_32_bits(queue->rx_ring_dma));
> > -#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> > -		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> > -			queue_writel(queue, RBQPH,
> > -				     upper_32_bits(queue->rx_ring_dma));
> > -#endif
> > -		queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
> > -#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> > -		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> > -			queue_writel(queue, TBQPH,
> > -				     upper_32_bits(queue->tx_ring_dma));
> > -#endif
> > +	macb_init_buffers(bp);
> >  
> > -		/* Enable interrupts */
> > +	/* Enable interrupts */
> > +	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> >  		queue_writel(queue, IER,
> >  			     bp->rx_intr_mask |
> >  			     MACB_TX_INT_FLAGS |
> >  			     MACB_BIT(HRESP));
> > -	}
> >  
> >  	ctrl |= MACB_BIT(RE) | MACB_BIT(TE);
> >  	macb_writel(bp, NCR, ctrl);
> > @@ -2221,19 +2315,13 @@ static void macb_configure_dma(struct macb *bp)
> >  
> >  static void macb_init_hw(struct macb *bp)
> >  {
> > -	struct macb_queue *queue;
> > -	unsigned int q;
> > -
> >  	u32 config;
> >  
> >  	macb_reset_hw(bp);
> >  	macb_set_hwaddr(bp);
> >  
> >  	config = macb_mdc_clk_div(bp);
> > -	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
> > -		config |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
> >  	config |= MACB_BF(RBOF, NET_IP_ALIGN);	/* Make eth data aligned */
> > -	config |= MACB_BIT(PAE);		/* PAuse Enable */
> >  	config |= MACB_BIT(DRFCS);		/* Discard Rx FCS */
> >  	if (bp->caps & MACB_CAPS_JUMBO)
> >  		config |= MACB_BIT(JFRAME);	/* Enable jumbo frames */
> > @@ -2249,36 +2337,11 @@ static void macb_init_hw(struct macb *bp)
> >  	macb_writel(bp, NCFGR, config);
> >  	if ((bp->caps & MACB_CAPS_JUMBO) && bp->jumbo_max_len)
> >  		gem_writel(bp, JML, bp->jumbo_max_len);
> > -	bp->speed = SPEED_10;
> > -	bp->duplex = DUPLEX_HALF;
> >  	bp->rx_frm_len_mask = MACB_RX_FRMLEN_MASK;
> >  	if (bp->caps & MACB_CAPS_JUMBO)
> >  		bp->rx_frm_len_mask = MACB_RX_JFRMLEN_MASK;
> >  
> >  	macb_configure_dma(bp);
> > -
> > -	/* Initialize TX and RX buffers */
> > -	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
> > -		queue_writel(queue, RBQP, lower_32_bits(queue->rx_ring_dma));
> > -#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> > -		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> > -			queue_writel(queue, RBQPH, upper_32_bits(queue->rx_ring_dma));
> > -#endif
> > -		queue_writel(queue, TBQP, lower_32_bits(queue->tx_ring_dma));
> > -#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> > -		if (bp->hw_dma_cap & HW_DMA_CAP_64B)
> > -			queue_writel(queue, TBQPH, upper_32_bits(queue->tx_ring_dma));
> > -#endif
> > -
> > -		/* Enable interrupts */
> > -		queue_writel(queue, IER,
> > -			     bp->rx_intr_mask |
> > -			     MACB_TX_INT_FLAGS |
> > -			     MACB_BIT(HRESP));
> > -	}
> > -
> > -	/* Enable TX and RX */
> > -	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
> >  }
> >  
> >  /* The hash address register is 64 bits long and takes up two
> > @@ -2402,8 +2465,8 @@ static void macb_set_rx_mode(struct net_device *dev)
> >  
> >  static int macb_open(struct net_device *dev)
> >  {
> > -	struct macb *bp = netdev_priv(dev);
> >  	size_t bufsz = dev->mtu + ETH_HLEN + ETH_FCS_LEN + NET_IP_ALIGN;
> > +	struct macb *bp = netdev_priv(dev);
> >  	struct macb_queue *queue;
> >  	unsigned int q;
> >  	int err;
> > @@ -2417,12 +2480,6 @@ static int macb_open(struct net_device *dev)
> >  	/* carrier starts down */
> >  	netif_carrier_off(dev);

Note, that's included in phylink_start().

> >  
> > -	/* if the phy is not yet register, retry later*/
> > -	if (!dev->phydev) {
> > -		err = -EAGAIN;
> > -		goto pm_exit;
> > -	}
> > -
> >  	/* RX buffers initialization */
> >  	macb_init_rx_buffer_size(bp, bufsz);
> >  
> > @@ -2436,11 +2493,11 @@ static int macb_open(struct net_device *dev)
> >  	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> >  		napi_enable(&queue->napi);
> >  
> > -	bp->macbgem_ops.mog_init_rings(bp);
> >  	macb_init_hw(bp);
> >  
> > -	/* schedule a link state check */
> > -	phy_start(dev->phydev);
> > +	err = macb_phylink_connect(bp);
> > +	if (err)
> > +		goto pm_exit;
> >  
> >  	netif_tx_start_all_queues(dev);
> >  
> > @@ -2467,8 +2524,8 @@ static int macb_close(struct net_device *dev)
> >  	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> >  		napi_disable(&queue->napi);
> >  
> > -	if (dev->phydev)
> > -		phy_stop(dev->phydev);
> > +	phylink_stop(bp->phylink);
> > +	phylink_disconnect_phy(bp->phylink);

This is fine if _this_ driver was the one to attach the PHY, otherwise
it will disconnect someone else's PHY (eg, the copper SFP PHY if this
driver supports SFPs.)

> >  
> >  	spin_lock_irqsave(&bp->lock, flags);
> >  	macb_reset_hw(bp);
> > @@ -2703,8 +2760,9 @@ static void macb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> >  	wol->wolopts = 0;
> >  
> >  	if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET) {
> > -		wol->supported = WAKE_MAGIC;
> > +		phylink_ethtool_get_wol(bp->phylink, wol);
> >  
> > +		wol->supported |= WAKE_MAGIC;
> >  		if (bp->wol & MACB_WOL_ENABLED)
> >  			wol->wolopts |= WAKE_MAGIC;

I'm not sure that the logic here is actually correct.  What would be
the result if the PHY has WOL disabled but bp->wol has both these
enabled?

> >  	}
> > @@ -2713,6 +2771,11 @@ static void macb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> >  static int macb_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> >  {
> >  	struct macb *bp = netdev_priv(netdev);
> > +	int ret;
> > +
> > +	ret = phylink_ethtool_set_wol(bp->phylink, wol);
> > +	if (!ret)
> > +		return 0;
> >  
> >  	if (!(bp->wol & MACB_WOL_HAS_MAGIC_PACKET) ||
> >  	    (wol->wolopts & ~WAKE_MAGIC))
> > @@ -2728,6 +2791,22 @@ static int macb_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> >  	return 0;
> >  }
> >  
> > +static int macb_get_link_ksettings(struct net_device *netdev,
> > +				   struct ethtool_link_ksettings *kset)
> > +{
> > +	struct macb *bp = netdev_priv(netdev);
> > +
> > +	return phylink_ethtool_ksettings_get(bp->phylink, kset);
> > +}
> > +
> > +static int macb_set_link_ksettings(struct net_device *netdev,
> > +				   const struct ethtool_link_ksettings *kset)
> > +{
> > +	struct macb *bp = netdev_priv(netdev);
> > +
> > +	return phylink_ethtool_ksettings_set(bp->phylink, kset);
> > +}
> > +
> >  static void macb_get_ringparam(struct net_device *netdev,
> >  			       struct ethtool_ringparam *ring)
> >  {
> > @@ -3164,8 +3243,8 @@ static const struct ethtool_ops macb_ethtool_ops = {
> >  	.get_ts_info		= ethtool_op_get_ts_info,
> >  	.get_wol		= macb_get_wol,
> >  	.set_wol		= macb_set_wol,
> > -	.get_link_ksettings     = phy_ethtool_get_link_ksettings,
> > -	.set_link_ksettings     = phy_ethtool_set_link_ksettings,
> > +	.get_link_ksettings     = macb_get_link_ksettings,
> > +	.set_link_ksettings     = macb_set_link_ksettings,
> >  	.get_ringparam		= macb_get_ringparam,
> >  	.set_ringparam		= macb_set_ringparam,
> >  };
> > @@ -3178,8 +3257,8 @@ static const struct ethtool_ops gem_ethtool_ops = {
> >  	.get_ethtool_stats	= gem_get_ethtool_stats,
> >  	.get_strings		= gem_get_ethtool_strings,
> >  	.get_sset_count		= gem_get_sset_count,
> > -	.get_link_ksettings     = phy_ethtool_get_link_ksettings,
> > -	.set_link_ksettings     = phy_ethtool_set_link_ksettings,
> > +	.get_link_ksettings     = macb_get_link_ksettings,
> > +	.set_link_ksettings     = macb_set_link_ksettings,
> >  	.get_ringparam		= macb_get_ringparam,
> >  	.set_ringparam		= macb_set_ringparam,
> >  	.get_rxnfc			= gem_get_rxnfc,
> > @@ -3188,17 +3267,13 @@ static const struct ethtool_ops gem_ethtool_ops = {
> >  
> >  static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> >  {
> > -	struct phy_device *phydev = dev->phydev;
> >  	struct macb *bp = netdev_priv(dev);
> >  
> >  	if (!netif_running(dev))
> >  		return -EINVAL;
> >  
> > -	if (!phydev)
> > -		return -ENODEV;
> > -
> >  	if (!bp->ptp_info)
> > -		return phy_mii_ioctl(phydev, rq, cmd);
> > +		return phylink_mii_ioctl(bp->phylink, rq, cmd);
> >  
> >  	switch (cmd) {
> >  	case SIOCSHWTSTAMP:
> > @@ -3206,7 +3281,7 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> >  	case SIOCGHWTSTAMP:
> >  		return bp->ptp_info->get_hwtst(dev, rq);
> >  	default:
> > -		return phy_mii_ioctl(phydev, rq, cmd);
> > +		return phylink_mii_ioctl(bp->phylink, rq, cmd);
> >  	}

This can probably be cleaned up - move

	return phylink_mii_ioctl(bp->phylink, rq, cmd);

to the bottom, and just make the switch() conditional on bp->ptp_info
being non-NULL.

> >  }
> >  
> > @@ -3330,7 +3405,8 @@ static void macb_configure_caps(struct macb *bp,
> >  #ifdef CONFIG_MACB_USE_HWSTAMP
> >  		if (gem_has_ptp(bp)) {
> >  			if (!GEM_BFEXT(TSU, gem_readl(bp, DCFG5)))
> > -				pr_err("GEM doesn't support hardware ptp.\n");
> > +				dev_err(&bp->pdev->dev,
> > +					"GEM doesn't support hardware ptp.\n");
> >  			else {
> >  				bp->hw_dma_cap |= HW_DMA_CAP_PTP;
> >  				bp->ptp_info = &gem_ptp_info;
> > @@ -3707,8 +3783,9 @@ static int at91ether_open(struct net_device *dev)
> >  			     MACB_BIT(ISR_ROVR)	|
> >  			     MACB_BIT(HRESP));
> >  
> > -	/* schedule a link state check */
> > -	phy_start(dev->phydev);
> > +	ret = macb_phylink_connect(lp);
> > +	if (ret)
> > +		return ret;
> >  
> >  	netif_start_queue(dev);
> >  
> > @@ -3737,6 +3814,9 @@ static int at91ether_close(struct net_device *dev)
> >  
> >  	netif_stop_queue(dev);
> >  
> > +	phylink_stop(lp->phylink);
> > +	phylink_disconnect_phy(lp->phylink);

Same comment as other instance.

> > +
> >  	dma_free_coherent(&lp->pdev->dev,
> >  			  AT91ETHER_MAX_RX_DESCR *
> >  			  macb_dma_desc_get_size(lp),
> > @@ -4181,7 +4261,6 @@ static int macb_probe(struct platform_device *pdev)
> >  	struct clk *tsu_clk = NULL;
> >  	unsigned int queue_mask, num_queues;
> >  	bool native_io;
> > -	struct phy_device *phydev;
> >  	struct net_device *dev;
> >  	struct resource *regs;
> >  	void __iomem *mem;
> > @@ -4324,8 +4403,6 @@ static int macb_probe(struct platform_device *pdev)
> >  	if (err)
> >  		goto err_out_free_netdev;
> >  
> > -	phydev = dev->phydev;
> > -
> >  	netif_carrier_off(dev);
> >  
> >  	err = register_netdev(dev);
> > @@ -4337,8 +4414,6 @@ static int macb_probe(struct platform_device *pdev)
> >  	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
> >  		     (unsigned long)bp);
> >  
> > -	phy_attached_info(phydev);
> > -
> >  	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
> >  		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
> >  		    dev->base_addr, dev->irq, dev->dev_addr);
> > @@ -4349,11 +4424,7 @@ static int macb_probe(struct platform_device *pdev)
> >  	return 0;
> >  
> >  err_out_unregister_mdio:
> > -	phy_disconnect(dev->phydev);
> >  	mdiobus_unregister(bp->mii_bus);
> > -	of_node_put(bp->phy_node);
> > -	if (np && of_phy_is_fixed_link(np))
> > -		of_phy_deregister_fixed_link(np);
> >  	mdiobus_free(bp->mii_bus);
> >  
> >  err_out_free_netdev:
> > @@ -4377,18 +4448,12 @@ static int macb_remove(struct platform_device *pdev)
> >  {
> >  	struct net_device *dev;
> >  	struct macb *bp;
> > -	struct device_node *np = pdev->dev.of_node;
> >  
> >  	dev = platform_get_drvdata(pdev);
> >  
> >  	if (dev) {
> >  		bp = netdev_priv(dev);
> > -		if (dev->phydev)
> > -			phy_disconnect(dev->phydev);
> >  		mdiobus_unregister(bp->mii_bus);
> > -		if (np && of_phy_is_fixed_link(np))
> > -			of_phy_deregister_fixed_link(np);
> > -		dev->phydev = NULL;
> >  		mdiobus_free(bp->mii_bus);
> >  
> >  		unregister_netdev(dev);
> > @@ -4403,7 +4468,6 @@ static int macb_remove(struct platform_device *pdev)
> >  			clk_disable_unprepare(bp->tsu_clk);
> >  			pm_runtime_set_suspended(&pdev->dev);
> >  		}
> > -		of_node_put(bp->phy_node);
> >  		free_netdev(dev);
> >  	}

Doesn't this need to cleanup phylink somewhere via a call to
phylink_destroy() ?

> >  
> > @@ -4421,7 +4485,6 @@ static int __maybe_unused macb_suspend(struct device *dev)
> >  	if (!netif_running(netdev))
> >  		return 0;
> >  
> > -
> >  	if (bp->wol & MACB_WOL_ENABLED) {
> >  		macb_writel(bp, IER, MACB_BIT(WOL));
> >  		macb_writel(bp, WOL, MACB_BIT(MAG));
> > @@ -4432,8 +4495,6 @@ static int __maybe_unused macb_suspend(struct device *dev)
> >  		for (q = 0, queue = bp->queues; q < bp->num_queues;
> >  		     ++q, ++queue)
> >  			napi_disable(&queue->napi);
> > -		phy_stop(netdev->phydev);
> > -		phy_suspend(netdev->phydev);

So you don't need to shutdown the phylib state machine after all?

> >  		spin_lock_irqsave(&bp->lock, flags);
> >  		macb_reset_hw(bp);
> >  		spin_unlock_irqrestore(&bp->lock, flags);
> > @@ -4481,12 +4542,8 @@ static int __maybe_unused macb_resume(struct device *dev)
> >  		for (q = 0, queue = bp->queues; q < bp->num_queues;
> >  		     ++q, ++queue)
> >  			napi_enable(&queue->napi);
> > -		phy_resume(netdev->phydev);
> > -		phy_init_hw(netdev->phydev);
> > -		phy_start(netdev->phydev);

This looks like it was re-setting up the PHY, but nothing happens here
after conversion?  Do we need to add something to phylink for this?
Has this been tested?

> >  	}
> >  
> > -	bp->macbgem_ops.mog_init_rings(bp);
> >  	macb_init_hw(bp);
> >  	macb_set_rx_mode(netdev);
> >  	macb_restore_features(bp);
> > -- 
> > 2.21.0
> > 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
