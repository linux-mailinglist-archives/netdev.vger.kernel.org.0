Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7430A1646E5
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 15:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgBSO1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 09:27:36 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52357 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgBSO1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 09:27:36 -0500
X-Originating-IP: 90.65.102.129
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 38923E0003;
        Wed, 19 Feb 2020 14:27:33 +0000 (UTC)
Date:   Wed, 19 Feb 2020 15:27:32 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: macb: Properly handle phylink on at91rm9200
Message-ID: <20200219142732.GA3390@piout.net>
References: <20200219141551.5152-1-alexandre.belloni@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219141551.5152-1-alexandre.belloni@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/02/2020 15:15:51+0100, Alexandre Belloni wrote:
> at91ether_init was handling the phy mode and speed but since the switch to
> phylink, the NCFGR register got overwritten by macb_mac_config(). The issue
> is that the RM9200_RMII bit and the MACB_CLK_DIV32 field are cleared
> but never restored as they conflict with the PAE, GBE and PCSSEL bits.
> 
> Add new capability to differentiate between EMAC and the other versions of
> the IP and use it to set and avoid clearing the relevant bits.
> 
> Also, this fixes a NULL pointer dereference in macb_mac_link_up as the EMAC
> doesn't use any rings/bufffers/queues.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> ---

And I forgot the changelog:

Changes in v2:
 - reworked the commit message to be clearer about the issue
 - avoided defining a new phylink_mac_ops by moving the differentation
   directly in the callbacks

>  drivers/net/ethernet/cadence/macb.h      |  1 +
>  drivers/net/ethernet/cadence/macb_main.c | 60 +++++++++++++-----------
>  2 files changed, 33 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index dbf7070fcdba..a3f0f27fc79a 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -652,6 +652,7 @@
>  #define MACB_CAPS_GEM_HAS_PTP			0x00000040
>  #define MACB_CAPS_BD_RD_PREFETCH		0x00000080
>  #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
> +#define MACB_CAPS_MACB_IS_EMAC			0x08000000
>  #define MACB_CAPS_FIFO_MODE			0x10000000
>  #define MACB_CAPS_GIGABIT_MODE_AVAILABLE	0x20000000
>  #define MACB_CAPS_SG_DISABLED			0x40000000
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index def94e91883a..2c28da1737fe 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -572,8 +572,21 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
>  	old_ctrl = ctrl = macb_or_gem_readl(bp, NCFGR);
>  
>  	/* Clear all the bits we might set later */
> -	ctrl &= ~(GEM_BIT(GBE) | MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE) |
> -		  GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
> +	ctrl &= ~(MACB_BIT(SPD) | MACB_BIT(FD) | MACB_BIT(PAE));
> +
> +	if (bp->caps & MACB_CAPS_MACB_IS_EMAC) {
> +		if (state->interface == PHY_INTERFACE_MODE_RMII)
> +			ctrl |= MACB_BIT(RM9200_RMII);
> +	} else {
> +		ctrl &= ~(GEM_BIT(GBE) | GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL));
> +
> +		/* We do not support MLO_PAUSE_RX yet */
> +		if (state->pause & MLO_PAUSE_TX)
> +			ctrl |= MACB_BIT(PAE);
> +
> +		if (state->interface == PHY_INTERFACE_MODE_SGMII)
> +			ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
> +	}
>  
>  	if (state->speed == SPEED_1000)
>  		ctrl |= GEM_BIT(GBE);
> @@ -583,13 +596,6 @@ static void macb_mac_config(struct phylink_config *config, unsigned int mode,
>  	if (state->duplex)
>  		ctrl |= MACB_BIT(FD);
>  
> -	/* We do not support MLO_PAUSE_RX yet */
> -	if (state->pause & MLO_PAUSE_TX)
> -		ctrl |= MACB_BIT(PAE);
> -
> -	if (state->interface == PHY_INTERFACE_MODE_SGMII)
> -		ctrl |= GEM_BIT(SGMIIEN) | GEM_BIT(PCSSEL);
> -
>  	/* Apply the new configuration, if any */
>  	if (old_ctrl ^ ctrl)
>  		macb_or_gem_writel(bp, NCFGR, ctrl);
> @@ -608,9 +614,10 @@ static void macb_mac_link_down(struct phylink_config *config, unsigned int mode,
>  	unsigned int q;
>  	u32 ctrl;
>  
> -	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> -		queue_writel(queue, IDR,
> -			     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
> +	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC))
> +		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> +			queue_writel(queue, IDR,
> +				     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
>  
>  	/* Disable Rx and Tx */
>  	ctrl = macb_readl(bp, NCR) & ~(MACB_BIT(RE) | MACB_BIT(TE));
> @@ -627,17 +634,19 @@ static void macb_mac_link_up(struct phylink_config *config, unsigned int mode,
>  	struct macb_queue *queue;
>  	unsigned int q;
>  
> -	macb_set_tx_clk(bp->tx_clk, bp->speed, ndev);
> +	if (!(bp->caps & MACB_CAPS_MACB_IS_EMAC)) {
> +		macb_set_tx_clk(bp->tx_clk, bp->speed, ndev);
>  
> -	/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
> -	 * cleared the pipeline and control registers.
> -	 */
> -	bp->macbgem_ops.mog_init_rings(bp);
> -	macb_init_buffers(bp);
> +		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
> +		 * cleared the pipeline and control registers.
> +		 */
> +		bp->macbgem_ops.mog_init_rings(bp);
> +		macb_init_buffers(bp);
>  
> -	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> -		queue_writel(queue, IER,
> -			     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
> +		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> +			queue_writel(queue, IER,
> +				     bp->rx_intr_mask | MACB_TX_INT_FLAGS | MACB_BIT(HRESP));
> +	}
>  
>  	/* Enable Rx and Tx */
>  	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
> @@ -4041,7 +4050,6 @@ static int at91ether_init(struct platform_device *pdev)
>  	struct net_device *dev = platform_get_drvdata(pdev);
>  	struct macb *bp = netdev_priv(dev);
>  	int err;
> -	u32 reg;
>  
>  	bp->queues[0].bp = bp;
>  
> @@ -4055,11 +4063,7 @@ static int at91ether_init(struct platform_device *pdev)
>  
>  	macb_writel(bp, NCR, 0);
>  
> -	reg = MACB_BF(CLK, MACB_CLK_DIV32) | MACB_BIT(BIG);
> -	if (bp->phy_interface == PHY_INTERFACE_MODE_RMII)
> -		reg |= MACB_BIT(RM9200_RMII);
> -
> -	macb_writel(bp, NCFGR, reg);
> +	macb_writel(bp, NCFGR, MACB_BF(CLK, MACB_CLK_DIV32) | MACB_BIT(BIG));
>  
>  	return 0;
>  }
> @@ -4218,7 +4222,7 @@ static const struct macb_config sama5d4_config = {
>  };
>  
>  static const struct macb_config emac_config = {
> -	.caps = MACB_CAPS_NEEDS_RSTONUBR,
> +	.caps = MACB_CAPS_NEEDS_RSTONUBR | MACB_CAPS_MACB_IS_EMAC,
>  	.clk_init = at91ether_clk_init,
>  	.init = at91ether_init,
>  };
> -- 
> 2.24.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
