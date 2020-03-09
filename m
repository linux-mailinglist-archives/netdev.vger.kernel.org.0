Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 320EB17E720
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgCISaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:30:04 -0400
Received: from foss.arm.com ([217.140.110.172]:56132 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbgCISaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 14:30:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8606C1FB;
        Mon,  9 Mar 2020 11:30:03 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42EEA3F67D;
        Mon,  9 Mar 2020 11:30:02 -0700 (PDT)
Date:   Mon, 9 Mar 2020 18:29:59 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     Michal Simek <michal.simek@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>, netdev@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 04/14] net: axienet: Fix DMA descriptor cleanup path
Message-ID: <20200309182959.080fa773@donnerap.cambridge.arm.com>
In-Reply-To: <20200309181851.190164-5-andre.przywara@arm.com>
References: <20200309181851.190164-1-andre.przywara@arm.com>
        <20200309181851.190164-5-andre.przywara@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Mar 2020 18:18:41 +0000
Andre Przywara <andre.przywara@arm.com> wrote:

Hi Radhey,

you looked at this patch before, it was [PATCH 03/14] back then.
You ended up saying "Looks fine then.", but I didn't dare to convert this into a "Reviewed-by:" tag.
Just a hint that I didn't change anything, that might simplify the review.

Cheers,
Andre

> When axienet_dma_bd_init() bails out during the initialisation process,
> it might do so with parts of the structure already allocated and
> initialised, while other parts have not been touched yet. Before
> returning in this case, we call axienet_dma_bd_release(), which does not
> take care of this corner case.
> This is most obvious by the first loop happily dereferencing
> lp->rx_bd_v, which we actually check to be non NULL *afterwards*.
> 
> Make sure we only unmap or free already allocated structures, by:
> - directly returning with -ENOMEM if nothing has been allocated at all
> - checking for lp->rx_bd_v to be non-NULL *before* using it
> - only unmapping allocated DMA RX regions
> 
> This avoids NULL pointer dereferences when initialisation fails.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 43 ++++++++++++-------
>  1 file changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 64f73533cabe..9903205d57ec 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -160,24 +160,37 @@ static void axienet_dma_bd_release(struct net_device *ndev)
>  	int i;
>  	struct axienet_local *lp = netdev_priv(ndev);
>  
> +	/* If we end up here, tx_bd_v must have been DMA allocated. */
> +	dma_free_coherent(ndev->dev.parent,
> +			  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
> +			  lp->tx_bd_v,
> +			  lp->tx_bd_p);
> +
> +	if (!lp->rx_bd_v)
> +		return;
> +
>  	for (i = 0; i < lp->rx_bd_num; i++) {
> -		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
> -				 lp->max_frm_size, DMA_FROM_DEVICE);
> +		/* A NULL skb means this descriptor has not been initialised
> +		 * at all.
> +		 */
> +		if (!lp->rx_bd_v[i].skb)
> +			break;
> +
>  		dev_kfree_skb(lp->rx_bd_v[i].skb);
> -	}
>  
> -	if (lp->rx_bd_v) {
> -		dma_free_coherent(ndev->dev.parent,
> -				  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
> -				  lp->rx_bd_v,
> -				  lp->rx_bd_p);
> -	}
> -	if (lp->tx_bd_v) {
> -		dma_free_coherent(ndev->dev.parent,
> -				  sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
> -				  lp->tx_bd_v,
> -				  lp->tx_bd_p);
> +		/* For each descriptor, we programmed cntrl with the (non-zero)
> +		 * descriptor size, after it had been successfully allocated.
> +		 * So a non-zero value in there means we need to unmap it.
> +		 */
> +		if (lp->rx_bd_v[i].cntrl)
> +			dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
> +					 lp->max_frm_size, DMA_FROM_DEVICE);
>  	}
> +
> +	dma_free_coherent(ndev->dev.parent,
> +			  sizeof(*lp->rx_bd_v) * lp->rx_bd_num,
> +			  lp->rx_bd_v,
> +			  lp->rx_bd_p);
>  }
>  
>  /**
> @@ -207,7 +220,7 @@ static int axienet_dma_bd_init(struct net_device *ndev)
>  					 sizeof(*lp->tx_bd_v) * lp->tx_bd_num,
>  					 &lp->tx_bd_p, GFP_KERNEL);
>  	if (!lp->tx_bd_v)
> -		goto out;
> +		return -ENOMEM;
>  
>  	lp->rx_bd_v = dma_alloc_coherent(ndev->dev.parent,
>  					 sizeof(*lp->rx_bd_v) * lp->rx_bd_num,

