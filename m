Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD4C45F19E
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354732AbhKZQWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:22:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:3819 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236771AbhKZQUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 11:20:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10180"; a="235926324"
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="235926324"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2021 08:17:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,266,1631602800"; 
   d="scan'208";a="742390899"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 26 Nov 2021 08:17:33 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1AQGHWJj004949;
        Fri, 26 Nov 2021 16:17:32 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] igc: enable XDP metadata in driver
Date:   Fri, 26 Nov 2021 17:16:49 +0100
Message-Id: <20211126161649.151100-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <163700859087.565980.3578855072170209153.stgit@firesoul>
References: <163700856423.565980.10162564921347693758.stgit@firesoul> <163700859087.565980.3578855072170209153.stgit@firesoul>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Mon, 15 Nov 2021 21:36:30 +0100

> Enabling the XDP bpf_prog access to data_meta area is a very small
> change. Hint passing 'true' to xdp_prepare_buff().
> 
> The SKB layers can also access data_meta area, which required more
> driver changes to support. Reviewers, notice the igc driver have two
> different functions that can create SKBs, depending on driver config.
> 
> Hint for testers, ethtool priv-flags legacy-rx enables
> the function igc_construct_skb()
> 
>  ethtool --set-priv-flags DEV legacy-rx on
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c |   29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 76b0a7311369..b516f1b301b4 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -1718,24 +1718,26 @@ static void igc_add_rx_frag(struct igc_ring *rx_ring,
>  
>  static struct sk_buff *igc_build_skb(struct igc_ring *rx_ring,
>  				     struct igc_rx_buffer *rx_buffer,
> -				     union igc_adv_rx_desc *rx_desc,
> -				     unsigned int size)
> +				     struct xdp_buff *xdp)
>  {
> -	void *va = page_address(rx_buffer->page) + rx_buffer->page_offset;
> +	unsigned int size = xdp->data_end - xdp->data;
>  	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
> +	unsigned int metasize = xdp->data - xdp->data_meta;
>  	struct sk_buff *skb;
>  
>  	/* prefetch first cache line of first page */
> -	net_prefetch(va);
> +	net_prefetch(xdp->data);

I'd prefer prefetching xdp->data_meta here. GRO layer accesses it.
Maximum meta size for now is 32, so at least 96 bytes of the frame
will stil be prefetched.

>  
>  	/* build an skb around the page buffer */
> -	skb = build_skb(va - IGC_SKB_PAD, truesize);
> +	skb = build_skb(xdp->data_hard_start, truesize);
>  	if (unlikely(!skb))
>  		return NULL;
>  
>  	/* update pointers within the skb to store the data */
> -	skb_reserve(skb, IGC_SKB_PAD);
> +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>  	__skb_put(skb, size);
> +	if (metasize)
> +		skb_metadata_set(skb, metasize);
>  
>  	igc_rx_buffer_flip(rx_buffer, truesize);
>  	return skb;
> @@ -1746,6 +1748,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
>  					 struct xdp_buff *xdp,
>  					 ktime_t timestamp)
>  {
> +	unsigned int metasize = xdp->data - xdp->data_meta;
>  	unsigned int size = xdp->data_end - xdp->data;
>  	unsigned int truesize = igc_get_rx_frame_truesize(rx_ring, size);
>  	void *va = xdp->data;
> @@ -1756,7 +1759,7 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
>  	net_prefetch(va);

...here as well.

>  
>  	/* allocate a skb to store the frags */
> -	skb = napi_alloc_skb(&rx_ring->q_vector->napi, IGC_RX_HDR_LEN);
> +	skb = napi_alloc_skb(&rx_ring->q_vector->napi, IGC_RX_HDR_LEN + metasize);
>  	if (unlikely(!skb))
>  		return NULL;
>  
> @@ -1769,7 +1772,13 @@ static struct sk_buff *igc_construct_skb(struct igc_ring *rx_ring,
>  		headlen = eth_get_headlen(skb->dev, va, IGC_RX_HDR_LEN);
>  
>  	/* align pull length to size of long to optimize memcpy performance */
> -	memcpy(__skb_put(skb, headlen), va, ALIGN(headlen, sizeof(long)));
> +	memcpy(__skb_put(skb, headlen + metasize), xdp->data_meta,
> +	       ALIGN(headlen + metasize, sizeof(long)));
> +
> +	if (metasize) {
> +		skb_metadata_set(skb, metasize);
> +		__skb_pull(skb, metasize);
> +	}
>  
>  	/* update all of the pointers */
>  	size -= headlen;
> @@ -2354,7 +2363,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
>  		if (!skb) {
>  			xdp_init_buff(&xdp, truesize, &rx_ring->xdp_rxq);
>  			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
> -					 igc_rx_offset(rx_ring) + pkt_offset, size, false);
> +					 igc_rx_offset(rx_ring) + pkt_offset, size, true);
>  
>  			skb = igc_xdp_run_prog(adapter, &xdp);
>  		}
> @@ -2378,7 +2387,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
>  		} else if (skb)
>  			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
>  		else if (ring_uses_build_skb(rx_ring))
> -			skb = igc_build_skb(rx_ring, rx_buffer, rx_desc, size);
> +			skb = igc_build_skb(rx_ring, rx_buffer, &xdp);
>  		else
>  			skb = igc_construct_skb(rx_ring, rx_buffer, &xdp,
>  						timestamp);

Thanks!
Al
