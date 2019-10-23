Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6183E154E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390672AbfJWJIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:08:02 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46149 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390394AbfJWJIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:08:02 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 8A384C0004;
        Wed, 23 Oct 2019 09:07:58 +0000 (UTC)
Date:   Wed, 23 Oct 2019 11:07:57 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        davem@davemloft.net, alexandre.belloni@bootlin.com,
        nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: macb: convert to phylink
Message-ID: <20191023090757.GA3355@kwain>
References: <20191018143924.7375-1-antoine.tenart@bootlin.com>
 <20191018190810.GH24810@lunn.ch>
 <20191018200823.GK25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191018200823.GK25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Sorry for not including you at first on this patch, I'll make sure I do
for v2.

On Fri, Oct 18, 2019 at 09:08:23PM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Oct 18, 2019 at 09:08:10PM +0200, Andrew Lunn wrote:
> > On Fri, Oct 18, 2019 at 04:39:24PM +0200, Antoine Tenart wrote:
> > > +
> > > +static int macb_mac_link_state(struct phylink_config *config,
> > > +			       struct phylink_link_state *state)
> > > +{
> > > +	return -EOPNOTSUPP;
> 
> Without this implemented, phylink can't support in-band link modes
> necessary for SFP support.  Since phylink is mostly about supporting
> SFP cages and similar, I'm not sure what the point is.

See the answer below.

> > > +static void macb_mac_config(struct phylink_config *config, unsigned int mode,
> > > +			    const struct phylink_link_state *state)
> > > +{
> > > +	struct net_device *ndev = to_net_dev(config->dev);
> > > +	struct macb *bp = netdev_priv(ndev);
> > >  	unsigned long flags;
> > > -	int status_change = 0;
> > > +	u32 old_ctrl, ctrl;
> > >  
> > >  	spin_lock_irqsave(&bp->lock, flags);
> > >  
> > > -	if (phydev->link) {
> > > -		if ((bp->speed != phydev->speed) ||
> > > -		    (bp->duplex != phydev->duplex)) {
> > > -			u32 reg;
> > > +	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
> > >  
> > > -			reg = macb_readl(bp, NCFGR);
> > > -			reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
> > > -			if (macb_is_gem(bp))
> > > -				reg &= ~GEM_BIT(GBE);
> > > +	/* Clear all the bits we might set later */
> > > +	ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE) |
> > > +		  GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
> > >  
> > > -			if (phydev->duplex)
> > > -				reg |= MACB_BIT(FD);
> > > -			if (phydev->speed == SPEED_100)
> > > -				reg |= MACB_BIT(SPD);
> > > -			if (phydev->speed == SPEED_1000 &&
> > > -			    bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> > > -				reg |= GEM_BIT(GBE);
> > > +	if (state->speed == SPEED_1000)
> > > +		ctrl |= GEM_BIT(GBE);
> > > +	else if (state->speed == SPEED_100)
> > > +		ctrl |= MACB_BIT(SPD);
> > >  
> > > -			macb_or_gem_writel(bp, NCFGR, reg);
> > > +	if (state->duplex)
> > > +		ctrl |= MACB_BIT(FD);
> > >  
> > > -			bp->speed = phydev->speed;
> > > -			bp->duplex = phydev->duplex;
> > > -			status_change = 1;
> > > -		}
> > > -	}
> > > +	/* We do not support MLO_PAUSE_RX yet */
> > > +	if (state->pause & MLO_PAUSE_TX)
> > > +		ctrl |= MACB_BIT(PAE);
> > >  
> > > -	if (phydev->link != bp->link) {
> > > -		if (!phydev->link) {
> > > -			bp->speed = 0;
> > > -			bp->duplex = -1;
> > > -		}
> > > -		bp->link = phydev->link;
> > > +	if (state->interface == PHY_INTERFACE_MODE_SGMII)
> > > +		ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
> 
> Hmm, so you support SGMII but have no way to read the results of SGMII
> negotiation?

That seemed odd, I did not find a way to get the status (at least in the
datasheet I was using). I sent a first version without link_state being
implemented, but I'll double check now.

> > > +	/* Apply the new configuration, if any */
> > > +	if (old_ctrl ^ ctrl) {
> > > +		macb_or_gem_writel(bp, NCFGR, ctrl);
> > >  
> > > -		status_change = 1;
> > > +		if (state->link)
> > > +			macb_set_tx_clk(bp->tx_clk, state->speed, ndev);
> 
> Please see include/linux/phylink.h for documentation on the mac_config()
> method.  It exhaustively describes which members of the state are valid
> for each value of "mode", and describes which are not valid to be used.
> "state->link" is one such case of an invalid use.

I'll have a look at this. I may be done in link_up as well, where we
know the state of the link.

> > > +static int macb_phylink_connect(struct macb *bp)
> > > +{
> > > +	struct net_device *dev = bp->dev;
> > > +	struct phy_device *phydev;
> > > +	int ret;
> > > +
> > > +	if (bp->phy_node) {
> > > +		ret = phylink_of_phy_connect(bp->phylink, bp->phy_node, 0);
> 
> This looks quite odd.
> 
> phylink expects the second argument to always be the container device
> node of the "phy-handle", "phy" or "phy-device" property, never the
> node of the PHY itself.  Looking at how the driver sets up
> bp->phy_node, it is the PHY's node itself sometimes, and in that case
> will almost certainly fail.

That right, thanks for spotting this. I'll fix it.

> > > +		if (ret) {
> > > +			netdev_err(dev, "Could not attach PHY (%d)\n", ret);
> > > +			return ret;
> > > +		}
> > > +	} else {
> > > +		phydev = phy_find_first(bp->mii_bus);
> > > +		if (!phydev) {
> > > +			netdev_err(dev, "no PHY found\n");
> > > +			return -ENXIO;
> > > +		}
> > > +
> > > +		/* attach the mac to the phy */
> > > +		ret = phylink_connect_phy(bp->phylink, phydev);
> > > +		if (ret) {
> > > +			netdev_err(dev, "Could not attach to PHY (%d)\n", ret);
> > > +			return ret;
> > >  		}
> 
> I'm not entirely sure what this is trying to achieve.

You may not have a "phy" property in the MAC node with this driver, so I
kept the logic of what was done previously, using phy_find_first() when
the phy isn't described in the dt. Do you suggest another approach?

> > >  	}
> > > +
> > > +	phylink_start(bp->phylink);
> 
> You're ready to handle a link-up event at this point in the driver?

Yes, the h/w is initialized, and we can handle link events.

> > >  static int macb_open(struct net_device *dev)
> > >  {
> > > -	struct macb *bp = netdev_priv(dev);
> > >  	size_t bufsz = dev->mtu + ETH_HLEN + ETH_FCS_LEN + NET_IP_ALIGN;
> > > +	struct macb *bp = netdev_priv(dev);
> > >  	struct macb_queue *queue;
> > >  	unsigned int q;
> > >  	int err;
> > > @@ -2417,12 +2480,6 @@ static int macb_open(struct net_device *dev)
> > >  	/* carrier starts down */
> > >  	netif_carrier_off(dev);
> 
> Note, that's included in phylink_start().

That's right, I added it to phylink_start... :) I'll fix it.

> > > @@ -2467,8 +2524,8 @@ static int macb_close(struct net_device *dev)
> > >  	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> > >  		napi_disable(&queue->napi);
> > >  
> > > -	if (dev->phydev)
> > > -		phy_stop(dev->phydev);
> > > +	phylink_stop(bp->phylink);
> > > +	phylink_disconnect_phy(bp->phylink);
> 
> This is fine if _this_ driver was the one to attach the PHY, otherwise
> it will disconnect someone else's PHY (eg, the copper SFP PHY if this
> driver supports SFPs.)

Do you suggest removing this? I'm seeing lots (all?) of phylink
converted drivers to still call this, what's the reasoning behind that?

> > > @@ -2703,8 +2760,9 @@ static void macb_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
> > >  	wol->wolopts = 0;
> > >  
> > >  	if (bp->wol & MACB_WOL_HAS_MAGIC_PACKET) {
> > > -		wol->supported = WAKE_MAGIC;
> > > +		phylink_ethtool_get_wol(bp->phylink, wol);
> > >  
> > > +		wol->supported |= WAKE_MAGIC;
> > >  		if (bp->wol & MACB_WOL_ENABLED)
> > >  			wol->wolopts |= WAKE_MAGIC;
> 
> I'm not sure that the logic here is actually correct.  What would be
> the result if the PHY has WOL disabled but bp->wol has both these
> enabled?

That's a good question. We could check if there's a PHY, and if so make
sure it supports WOL before setting those bits.

> > >  static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> > >  {
> > > -	struct phy_device *phydev = dev->phydev;
> > >  	struct macb *bp = netdev_priv(dev);
> > >  
> > >  	if (!netif_running(dev))
> > >  		return -EINVAL;
> > >  
> > > -	if (!phydev)
> > > -		return -ENODEV;
> > > -
> > >  	if (!bp->ptp_info)
> > > -		return phy_mii_ioctl(phydev, rq, cmd);
> > > +		return phylink_mii_ioctl(bp->phylink, rq, cmd);
> > >  
> > >  	switch (cmd) {
> > >  	case SIOCSHWTSTAMP:
> > > @@ -3206,7 +3281,7 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> > >  	case SIOCGHWTSTAMP:
> > >  		return bp->ptp_info->get_hwtst(dev, rq);
> > >  	default:
> > > -		return phy_mii_ioctl(phydev, rq, cmd);
> > > +		return phylink_mii_ioctl(bp->phylink, rq, cmd);
> > >  	}
> 
> This can probably be cleaned up - move
> 
> 	return phylink_mii_ioctl(bp->phylink, rq, cmd);
> 
> to the bottom, and just make the switch() conditional on bp->ptp_info
> being non-NULL.

I'll do this.

> > > @@ -4377,18 +4448,12 @@ static int macb_remove(struct platform_device *pdev)
> > >  {
> > >  	struct net_device *dev;
> > >  	struct macb *bp;
> > > -	struct device_node *np = pdev->dev.of_node;
> > >  
> > >  	dev = platform_get_drvdata(pdev);
> > >  
> > >  	if (dev) {
> > >  		bp = netdev_priv(dev);
> > > -		if (dev->phydev)
> > > -			phy_disconnect(dev->phydev);
> > >  		mdiobus_unregister(bp->mii_bus);
> > > -		if (np && of_phy_is_fixed_link(np))
> > > -			of_phy_deregister_fixed_link(np);
> > > -		dev->phydev = NULL;
> > >  		mdiobus_free(bp->mii_bus);
> > >  
> > >  		unregister_netdev(dev);
> > > @@ -4403,7 +4468,6 @@ static int macb_remove(struct platform_device *pdev)
> > >  			clk_disable_unprepare(bp->tsu_clk);
> > >  			pm_runtime_set_suspended(&pdev->dev);
> > >  		}
> > > -		of_node_put(bp->phy_node);
> > >  		free_netdev(dev);
> > >  	}
> 
> Doesn't this need to cleanup phylink somewhere via a call to
> phylink_destroy() ?

You're right, I'll fix it.

> > > @@ -4421,7 +4485,6 @@ static int __maybe_unused macb_suspend(struct device *dev)
> > >  	if (!netif_running(netdev))
> > >  		return 0;
> > >  
> > > -
> > >  	if (bp->wol & MACB_WOL_ENABLED) {
> > >  		macb_writel(bp, IER, MACB_BIT(WOL));
> > >  		macb_writel(bp, WOL, MACB_BIT(MAG));
> > > @@ -4432,8 +4495,6 @@ static int __maybe_unused macb_suspend(struct device *dev)
> > >  		for (q = 0, queue = bp->queues; q < bp->num_queues;
> > >  		     ++q, ++queue)
> > >  			napi_disable(&queue->napi);
> > > -		phy_stop(netdev->phydev);
> > > -		phy_suspend(netdev->phydev);
> 
> So you don't need to shutdown the phylib state machine after all?
> 
> > >  		spin_lock_irqsave(&bp->lock, flags);
> > >  		macb_reset_hw(bp);
> > >  		spin_unlock_irqrestore(&bp->lock, flags);
> > > @@ -4481,12 +4542,8 @@ static int __maybe_unused macb_resume(struct device *dev)
> > >  		for (q = 0, queue = bp->queues; q < bp->num_queues;
> > >  		     ++q, ++queue)
> > >  			napi_enable(&queue->napi);
> > > -		phy_resume(netdev->phydev);
> > > -		phy_init_hw(netdev->phydev);
> > > -		phy_start(netdev->phydev);
> 
> This looks like it was re-setting up the PHY, but nothing happens here
> after conversion?  Do we need to add something to phylink for this?
> Has this been tested?

I made some tests but after an internal discussion it seems like I can't
test the feature myself. Someone will, and we'll probably have to add a
suspend/resume logic to phylink.

Thanks for the review!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
