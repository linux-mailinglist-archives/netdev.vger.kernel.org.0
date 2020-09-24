Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8320277C15
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 01:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgIXXA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 19:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgIXXA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 19:00:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B041D2344C;
        Thu, 24 Sep 2020 23:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600988457;
        bh=DQzpuoYZUfKk+jPO2SjXA0gkIztwNug3jrzIWT5GVhc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EGkh+tVbXFJugm5RL/1Y7nhjl867DCCHV70Zc4W+rfzEH8dMveDvc7M1dpi9uI8bo
         hP4XELESxKxD9aJY5RuPm1BH0Sv+geL/laLE/FF80sPrxdhsye+cou6x1wrLpDDn32
         hvXw1+ZScsjuJMPDbcXhFrmmOpemmqGhqrOPh+8I=
Date:   Thu, 24 Sep 2020 16:00:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] gve: Rx Buffer Recycling
Message-ID: <20200924160055.1e7be259@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924010104.3196839-4-awogbemila@google.com>
References: <20200924010104.3196839-1-awogbemila@google.com>
        <20200924010104.3196839-4-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Sep 2020 18:01:03 -0700 David Awogbemila wrote:
> This patch lets the driver reuse buffers that have been freed by the
> networking stack.
> 
> In the raw addressing case, this allows the driver avoid allocating new
> buffers.
> In the qpl case, the driver can avoid copies.
> 
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h    |  10 +-
>  drivers/net/ethernet/google/gve/gve_rx.c | 197 +++++++++++++++--------
>  2 files changed, 133 insertions(+), 74 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
> index b853efb0b17f..9cce2b356235 100644
> --- a/drivers/net/ethernet/google/gve/gve.h
> +++ b/drivers/net/ethernet/google/gve/gve.h
> @@ -50,6 +50,7 @@ struct gve_rx_slot_page_info {
>  	struct page *page;
>  	void *page_address;
>  	u32 page_offset; /* offset to write to in page */
> +	bool can_flip;
>  };
>  
>  /* A list of pages registered with the device during setup and used by a queue
> @@ -505,15 +506,6 @@ static inline enum dma_data_direction gve_qpl_dma_dir(struct gve_priv *priv,
>  		return DMA_FROM_DEVICE;
>  }
>  
> -/* Returns true if the max mtu allows page recycling */
> -static inline bool gve_can_recycle_pages(struct net_device *dev)
> -{
> -	/* We can't recycle the pages if we can't fit a packet into half a
> -	 * page.
> -	 */
> -	return dev->max_mtu <= PAGE_SIZE / 2;
> -}
> -
>  /* buffers */
>  int gve_alloc_page(struct gve_priv *priv, struct device *dev,
>  		   struct page **page, dma_addr_t *dma,
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index ae76d2547d13..bea483db28f5 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -263,8 +263,7 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
>  	return PKT_HASH_TYPE_L2;
>  }
>  
> -static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
> -				   struct net_device *dev,
> +static struct sk_buff *gve_rx_copy(struct net_device *dev,
>  				   struct napi_struct *napi,
>  				   struct gve_rx_slot_page_info *page_info,
>  				   u16 len)
> @@ -282,10 +281,6 @@ static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
>  
>  	skb->protocol = eth_type_trans(skb, dev);
>  
> -	u64_stats_update_begin(&rx->statss);
> -	rx->rx_copied_pkt++;
> -	u64_stats_update_end(&rx->statss);
> -
>  	return skb;
>  }
>  
> @@ -331,22 +326,91 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info,
>  {
>  	u64 addr = be64_to_cpu(data_ring->addr);
>  
> +	/* "flip" to other packet buffer on this page */
>  	page_info->page_offset ^= PAGE_SIZE / 2;
>  	addr ^= PAGE_SIZE / 2;
>  	data_ring->addr = cpu_to_be64(addr);
>  }
>  
> +static bool gve_rx_can_flip_buffers(struct net_device *netdev)
> +{
> +#if PAGE_SIZE == 4096
> +	/* We can't flip a buffer if we can't fit a packet
> +	 * into half a page.
> +	 */
> +	if (netdev->max_mtu + GVE_RX_PAD + ETH_HLEN  > PAGE_SIZE / 2)

double space

> +		return false;
> +	return true;

Flip the condition and just return it.

return netdev->max_mtu + GVE_RX_PAD + ETH_HLEN <= PAGE_SIZE / 2

Also you should probably look at mtu not max_mtu. More likely to be in
cache.

> +#else
> +	/* PAGE_SIZE != 4096 - don't try to reuse */
> +	return false;
> +#endif
> +}
> +
> +static int gve_rx_can_recycle_buffer(struct page *page)
> +{
> +	int pagecount = page_count(page);
> +
> +	/* This page is not being used by any SKBs - reuse */
> +	if (pagecount == 1) {
> +		return 1;
> +	/* This page is still being used by an SKB - we can't reuse */
> +	} else if (pagecount >= 2) {
> +		return 0;
> +	}

parenthesis not necessary around single line statements.

> +	WARN(pagecount < 1, "Pagecount should never be < 1");
> +	return -1;
> +}
> +
>  static struct sk_buff *
>  gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
>  		      struct gve_rx_slot_page_info *page_info, u16 len,
>  		      struct napi_struct *napi,
> -		      struct gve_rx_data_slot *data_slot)
> +		      struct gve_rx_data_slot *data_slot, bool can_flip)
>  {
>  	struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);

IMHO it looks weird when a function is called on variable init and then
error checking is done after an empty line.

>  	if (!skb)
>  		return NULL;
>  
> +	/* Optimistically stop the kernel from freeing the page by increasing
> +	 * the page bias. We will check the refcount in refill to determine if
> +	 * we need to alloc a new page.
> +	 */
> +	get_page(page_info->page);
> +	page_info->can_flip = can_flip;
> +
> +	return skb;
> +}
> +
> +static struct sk_buff *
> +gve_rx_qpl(struct device *dev, struct net_device *netdev,
> +	   struct gve_rx_ring *rx, struct gve_rx_slot_page_info *page_info,
> +	   u16 len, struct napi_struct *napi,
> +	   struct gve_rx_data_slot *data_slot, bool recycle)
> +{
> +	struct sk_buff *skb;

empty line here

> +	/* if raw_addressing mode is not enabled gvnic can only receive into
> +	 * registered segmens. If the buffer can't be recycled, our only

segments?

> +	 * choice is to copy the data out of it so that we can return it to the
> +	 * device.
> +	 */
> +	if (recycle) {
> +		skb = gve_rx_add_frags(napi, page_info, len);
> +		/* No point in recycling if we didn't get the skb */
> +		if (skb) {
> +			/* Make sure the networking stack can't free the page */
> +			get_page(page_info->page);
> +			gve_rx_flip_buff(page_info, data_slot);
> +		}
> +	} else {
> +		skb = gve_rx_copy(netdev, napi, page_info, len);
> +		if (skb) {
> +			u64_stats_update_begin(&rx->statss);
> +			rx->rx_copied_pkt++;
> +			u64_stats_update_end(&rx->statss);
> +		}
> +	}
>  	return skb;
>  }

> @@ -490,14 +525,46 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
>  
>  	while ((fill_cnt & rx->mask) != (rx->cnt & rx->mask)) {
>  		u32 idx = fill_cnt & rx->mask;
> -		struct gve_rx_slot_page_info *page_info = &rx->data.page_info[idx];
> -		struct gve_rx_data_slot *data_slot = &rx->data.data_ring[idx];
> -		struct device *dev = &priv->pdev->dev;
> +		struct gve_rx_slot_page_info *page_info =
> +						&rx->data.page_info[idx];
>  
> -		gve_rx_free_buffer(dev, page_info, data_slot);
> -		page_info->page = NULL;
> -		if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot, rx))
> -			break;
> +		if (page_info->can_flip) {
> +			/* The other half of the page is free because it was
> +			 * free when we processed the descriptor. Flip to it.
> +			 */
> +			struct gve_rx_data_slot *data_slot =
> +						&rx->data.data_ring[idx];
> +
> +			gve_rx_flip_buff(page_info, data_slot);
> +			page_info->can_flip = false;
> +		} else {
> +			/* It is possible that the networking stack has already
> +			 * finished processing all outstanding packets in the buffer
> +			 * and it can be reused.
> +			 * Flipping is unnecessary here - if the networking stack still
> +			 * owns half the page it is impossible to tell which half. Either
> +			 * the whole page is free or it needs to be replaced.
> +			 */
> +			int recycle = gve_rx_can_recycle_buffer(page_info->page);
> +
> +			if (recycle < 0) {
> +				gve_schedule_reset(priv);
> +				return false;
> +			}
> +			if (!recycle) {
> +				/* We can't reuse the buffer - alloc a new one*/
> +				struct gve_rx_data_slot *data_slot =
> +						&rx->data.data_ring[idx];
> +				struct device *dev = &priv->pdev->dev;
> +
> +				gve_rx_free_buffer(dev, page_info, data_slot);
> +				page_info->page = NULL;
> +				if (gve_rx_alloc_buffer(priv, dev, page_info,
> +							data_slot, rx)) {
> +					break;

What if the queue runs completely dry during memory shortage? 
You need some form of delayed work to periodically refill 
the free buffers, right?

> +				}

parens unnecessary

> +			}
> +		}
>  		fill_cnt++;
>  	}
>  	rx->fill_cnt = fill_cnt;

