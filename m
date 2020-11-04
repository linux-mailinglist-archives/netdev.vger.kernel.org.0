Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6DF2A5B0B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 01:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgKDAg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 19:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728319AbgKDAfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 19:35:02 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD87B223C7;
        Wed,  4 Nov 2020 00:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604450102;
        bh=iaDCxc4Txew7JaAp2sBWUN8ZenvYBN/cmW2TMh2T2KE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=km0uL0a6RlXAI8AqlMLXqWk5bzOynJNRhhXBi+aC8l6DNNC4dU3LDbYvOnmvc9ryx
         pws3JcLYz/oDc4WppGG88NRXT7YOZWQHNxJEa3ioWEBt1M0wrtyR9hMdqiKTIBfY53
         1v4nnpq8h10fo1aecBQe4+q7XN+LB8pNiHXmPMy0=
Message-ID: <62b6f6ffc874938072b914fbc9969dd437a9745e.camel@kernel.org>
Subject: Re: [PATCH 4/4] gve: Add support for raw addressing in the tx path
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Awogbemila <awogbemila@google.com>, netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Date:   Tue, 03 Nov 2020 16:35:01 -0800
In-Reply-To: <20201103174651.590586-5-awogbemila@google.com>
References: <20201103174651.590586-1-awogbemila@google.com>
         <20201103174651.590586-5-awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-03 at 09:46 -0800, David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> During TX, skbs' data addresses are dma_map'ed and passed to the NIC.
> This means that the device can perform DMA directly from these
> addresses
> and the driver does not have to copy the buffer content into
> pre-allocated buffers/qpls (as in qpl mode).
> 
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h        |  18 +-
>  drivers/net/ethernet/google/gve/gve_adminq.c |   4 +-
>  drivers/net/ethernet/google/gve/gve_desc.h   |   8 +-
>  drivers/net/ethernet/google/gve/gve_tx.c     | 207 +++++++++++++++
> ----
>  4 files changed, 194 insertions(+), 43 deletions(-)
> 

>  static inline u32 gve_num_tx_qpls(struct gve_priv *priv)
>  {
> -	return priv->tx_cfg.num_queues;
> +	if (priv->raw_addressing)
> +		return 0;
> +	else
> +		return priv->tx_cfg.num_queues;

redundant else statement.
 
>  
> -static void gve_dma_sync_for_device(struct device *dev, dma_addr_t
> *page_buses,
> +static void gve_dma_sync_for_device(struct gve_priv *priv,
> +				    dma_addr_t *page_buses,
>  				    u64 iov_offset, u64 iov_len)
>  {
>  	u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
>  	u64 first_page = iov_offset / PAGE_SIZE;
> -	dma_addr_t dma;
>  	u64 page;
>  
>  	for (page = first_page; page <= last_page; page++) {
> -		dma = page_buses[page];
> -		dma_sync_single_for_device(dev, dma, PAGE_SIZE,
> DMA_TO_DEVICE);
> +		dma_addr_t dma = page_buses[page];
> +
> +		dma_sync_single_for_device(&priv->pdev->dev, dma,
> PAGE_SIZE, DMA_TO_DEVICE);

Why did you change the function params to pass priv here ? 
I don't see any valid reason.

...

> 
> -	gve_dma_sync_for_device(dev, tx->tx_fifo.qpl->page_buses,
> +	gve_dma_sync_for_device(priv, tx->tx_fifo.qpl->page_buses,
>  				info->iov[hdr_nfrags - 1].iov_offset,
>  				info->iov[hdr_nfrags - 1].iov_len);
> 
...

> -		gve_dma_sync_for_device(dev, tx->tx_fifo.qpl-
> >page_buses,
> +		gve_dma_sync_for_device(priv, tx->tx_fifo.qpl-
> >page_buses,
>  					info->iov[i].iov_offset,
>  					info->iov[i].iov_len);
>  		copy_offset += info->iov[i].iov_len;
> @@ -472,6 +499,98 @@ static int gve_tx_add_skb(struct gve_tx_ring
> *tx, struct sk_buff *skb,
>  	return 1 + payload_nfrags;
>  }
>  
> +static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct
> gve_tx_ring *tx,
> +				  struct sk_buff *skb)
> +{
> +	const struct skb_shared_info *shinfo = skb_shinfo(skb);
> +	int hlen, payload_nfrags, l4_hdr_offset, seg_idx_bias;
> +	union gve_tx_desc *pkt_desc, *seg_desc;
> +	struct gve_tx_buffer_state *info;
> +	bool is_gso = skb_is_gso(skb);
> +	u32 idx = tx->req & tx->mask;
> +	struct gve_tx_dma_buf *buf;
> +	int last_mapped = 0;
> +	u64 addr;
> +	u32 len;
> +	int i;
> +
> +	info = &tx->info[idx];
> +	pkt_desc = &tx->desc[idx];
> +
> +	l4_hdr_offset = skb_checksum_start_offset(skb);
> +	/* If the skb is gso, then we want only up to the tcp header in
> the first segment
> +	 * to efficiently replicate on each segment otherwise we want
> the linear portion
> +	 * of the skb (which will contain the checksum because skb-
> >csum_start and
> +	 * skb->csum_offset are given relative to skb->head) in the
> first segment.
> +	 */
> +	hlen = is_gso ? l4_hdr_offset + tcp_hdrlen(skb) :
> +			skb_headlen(skb);
> +	len = skb_headlen(skb);
> +
> +	info->skb =  skb;
> +
> +	addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
> +	if (unlikely(dma_mapping_error(tx->dev, addr))) {
> +		priv->dma_mapping_error++;
> +		goto drop;
> +	}
> +	buf = &info->buf;
> +	dma_unmap_len_set(buf, len, len);
> +	dma_unmap_addr_set(buf, dma, addr);
> +
> +	payload_nfrags = shinfo->nr_frags;
> +	if (hlen < len) {
> +		/* For gso the rest of the linear portion of the skb
> needs to
> +		 * be in its own descriptor.
> +		 */
> +		payload_nfrags++;
> +		gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso,
> l4_hdr_offset,
> +				     1 + payload_nfrags, hlen, addr);
> +
> +		len -= hlen;
> +		addr += hlen;
> +		seg_desc = &tx->desc[(tx->req + 1) & tx->mask];
> +		seg_idx_bias = 2;
> +		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
> +	} else {
> +		seg_idx_bias = 1;
> +		gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso,
> l4_hdr_offset,
> +				     1 + payload_nfrags, hlen, addr);
> +	}
> +	idx = (tx->req + seg_idx_bias) & tx->mask;
> +
> +	for (i = 0; i < payload_nfrags - (seg_idx_bias - 1); i++) {
> +		const skb_frag_t *frag = &shinfo->frags[i];
> +
> +		seg_desc = &tx->desc[idx];
> +		len = skb_frag_size(frag);
> +		addr = skb_frag_dma_map(tx->dev, frag, 0, len,
> DMA_TO_DEVICE);
> +		if (unlikely(dma_mapping_error(tx->dev, addr))) {
> +			priv->dma_mapping_error++;

don't you need to protect this from parallel access ? 
> +			goto unmap_drop;
> +		}
> +		buf = &tx->info[idx].buf;
> +		tx->info[idx].skb = NULL;
> +		dma_unmap_len_set(buf, len, len);
> +		dma_unmap_addr_set(buf, dma, addr);
> +
> +		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
> +		idx = (idx + 1) & tx->mask;
> +	}
> +
> +	return 1 + payload_nfrags;
> +
> +unmap_drop:
> +	i--;
> +	for (last_mapped = i + seg_idx_bias; last_mapped >= 0;
> last_mapped--) {
> +		idx = (tx->req + last_mapped) & tx->mask;
> +		gve_tx_unmap_buf(tx->dev, &tx->info[idx]);
> +	}
> +drop:
> +	tx->dropped_pkt++;
> +	return 0;
> +}
> +
...


