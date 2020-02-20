Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B30165B4D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 11:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgBTKSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 05:18:37 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgBTKSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 05:18:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eI2UGWY4j3mAog5Dp/NLUvC2N+pK0givrkk3PPJLngg=; b=QL5u04aFgABw+gltfPHeD91SM
        0n6IaoXnYAiqRCNhI+T9d5OqjfCaJd3gQfAFEbyu/IHwJogwZqbpIVW76vBQppxVeejdBy00vb8Dj
        ldESQwsf46NzHtbfxaa1WhTgpwSd+oQu2tgMfNUwMRnUXv7Ns6TUDDBEDovGJkWMh4MevwuBkWDM+
        CPv3BIIpqzrjUU/PIeYL+qHvX1GojxSWp7Z0HnEu28s+4UMl0OfKHDsPSvqNC1MhzsJTEKf998Bzn
        jYPqrcOku6RrcVQ4S/7H3xVtaPKTqI/ZQXvTF0K0qOrtomLVnOs7yAApDKIG6uulyTxrpzLnsKQbX
        isDUxw/cw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54480)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4iuc-0002dA-VM; Thu, 20 Feb 2020 10:18:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4iua-0002LI-Ub; Thu, 20 Feb 2020 10:18:28 +0000
Date:   Thu, 20 Feb 2020 10:18:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [CFT 6/8] net: macb: use resolved link config in mac_link_up()
Message-ID: <20200220101828.GV25745@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k85-00072l-RK@rmk-PC.armlinux.org.uk>
 <20200219143036.GB3390@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219143036.GB3390@piout.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 03:30:36PM +0100, Alexandre Belloni wrote:
> Hi,
> 
> On 17/02/2020 17:24:21+0000, Russell King wrote:
> > Convert the macb ethernet driver to use the finalised link
> > parameters in mac_link_up() rather than the parameters in mac_config().
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/ethernet/cadence/macb.h      |  1 -
> >  drivers/net/ethernet/cadence/macb_main.c | 46 ++++++++++++++----------
> >  2 files changed, 27 insertions(+), 20 deletions(-)
> > 
> 
> I did test the series after rebasing on top of the at91rm9200 fix.
> 
> Here is what I tested:
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index a3f0f27fc79a..ab827fb4b6b9 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -1200,7 +1200,6 @@ struct macb {
>  	unsigned int		dma_burst_length;
>  
>  	phy_interface_t		phy_interface;
> -	int			speed;
>  
>  	/* AT91RM9200 transmit */
>  	struct sk_buff *skb;			/* holds skb until xmit interrupt completes */
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 7ab0bef5e1bd..3a7c26b08607 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -571,37 +571,20 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
>  
>  	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
>  
> -	/* Clear all the bits we might set later */
> -	ctrl &= ~(MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE));
> -
>  	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
>  		if (state->interface == PHY_INTERFACE_MODE_RMII)
>  			ctrl |= MACB_BIT(RM9200_RMII);
>  	} else {
> -		ctrl &= ~(GEM_BIT(GBE) | GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
> -
> -		/* We do not support MLO_PAUSE_RX yet */
> -		if (state->pause & MLO_PAUSE_TX)
> -			ctrl |= MACB_BIT(PAE);
> +		ctrl &= ~(GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
>  
>  		if (state->interface == PHY_INTERFACE_MODE_SGMII)
>  			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
>  	}
>  
> -	if (state->speed == SPEED_1000)
> -		ctrl |= GEM_BIT(GBE);
> -	else if (state->speed == SPEED_100)
> -		ctrl |= MACB_BIT(SPD);
> -
> -	if (state->duplex)
> -		ctrl |= MACB_BIT(FD);
> -
>  	/* Apply the new configuration, if any */
>  	if (old_ctrl ^ ctrl)
>  		macb_or_gem_writel(bp, NCFGR, ctrl);
>  
> -	bp->speed = state->speed;
> -
>  	spin_unlock_irqrestore(&bp->lock, flags);
>  }
>  
> @@ -635,10 +618,33 @@ static void macb_mac_link_up(struct phylink_config *config,
>  	struct net_device *ndev = to_net_dev(config->dev);
>  	struct macb *bp = netdev_priv(ndev);
>  	struct macb_queue *queue;
> +	unsigned long flags;
>  	unsigned int q;
> +	u32 ctrl;
> +
> +	spin_lock_irqsave(&bp->lock, flags);
> +
> +	ctrl = macb_or_gem_readl(bp, NCFGR);
> +
> +	ctrl &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
> +
> +	if (speed == SPEED_100)
> +		ctrl |= MACB_BIT(SPD);
> +
> +	if (duplex)
> +		ctrl |= MACB_BIT(FD);
>  
>  	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC)) {
> -		macb_set_tx_clk(bp->tx_clk, bp->speed, ndev);
> +		ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(PAE));
> +
> +		if (speed == SPEED_1000)
> +			ctrl |= GEM_BIT(GBE);
> +
> +		/* We do not support MLO_PAUSE_RX yet */
> +		if (tx_pause)
> +			ctrl |= MACB_BIT(PAE);
> +
> +		macb_set_tx_clk(bp->tx_clk, speed, ndev);
>  
>  		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
>  		 * cleared the pipeline and control registers.
> @@ -651,6 +657,10 @@ static void macb_mac_link_up(struct phylink_config *config,
>  				     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
>  	}
>  
> +	macb_or_gem_writel(bp, NCFGR, ctrl);
> +
> +	spin_unlock_irqrestore(&bp->lock, flags);
> +
>  	/* Enable Rx and Tx */
>  	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
>  
> @@ -4432,8 +4442,6 @@ static int macb_probe(struct platform_device *pdev)
>  	else
>  		bp->phy_interface = interface;
>  
> -	bp->speed = SPEED_UNKNOWN;
> -
>  	/* IP specific init */
>  	err = init(pdev);
>  	if (err)
> 
> 

Thanks, that looks reasonable to me. I'll replace my patch with this
one if it's appropriate for net-next when I send this series for
merging.  However, I see most affected network driver maintainers
haven't responded yet, which is rather disappointing.  So, thanks
for taking the time to look at this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
