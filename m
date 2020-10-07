Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25ADB286A5C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJGVkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:40:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:63896 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgJGVkf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 17:40:35 -0400
IronPort-SDR: p5xPXIhPbdu0vTGnOKhRrWonfrUTal0Zmo2U5Y2NVWKEf191roZuoXvqWAKuh5lejyzILkutC+
 L4MogWSWXa+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="152074815"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="152074815"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 14:40:34 -0700
IronPort-SDR: BVYzcNozB6kH0TLwnYze4ReudDgYFlC75nFVBWj8qp8qesrIu4iMZ+3Rg0Rgm2vU7xmddo50AJ
 Fz5Qm0sRinyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="388553525"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 07 Oct 2020 14:40:31 -0700
Date:   Wed, 7 Oct 2020 23:32:57 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sven.auhagen@voleatech.de
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH 5/7] igb: use igb_rx_buffer_flip
Message-ID: <20201007213257.GD48010@ranger.igk.intel.com>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
 <20201007152506.66217-6-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007152506.66217-6-sven.auhagen@voleatech.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 05:25:04PM +0200, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Also use the new helper function igb_rx_buffer_flip in
> igb_build_skb/igb_add_rx_frag.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 87 +++++++++--------------
>  1 file changed, 35 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 36ff8725fdaf..f34faf24190a 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -8255,6 +8255,34 @@ static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
>  	return true;
>  }
>  
> +static unsigned int igb_rx_frame_truesize(struct igb_ring *rx_ring,
> +					  unsigned int size)
> +{
> +	unsigned int truesize;
> +
> +#if (PAGE_SIZE < 8192)
> +	truesize = igb_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
> +#else
> +	truesize = ring_uses_build_skb(rx_ring) ?
> +		SKB_DATA_ALIGN(IGB_SKB_PAD + size) +
> +		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> +		SKB_DATA_ALIGN(size);
> +#endif
> +	return truesize;
> +}
> +
> +static void igb_rx_buffer_flip(struct igb_ring *rx_ring,
> +			       struct igb_rx_buffer *rx_buffer,
> +			       unsigned int size)
> +{
> +	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
> +#if (PAGE_SIZE < 8192)
> +	rx_buffer->page_offset ^= truesize;
> +#else
> +	rx_buffer->page_offset += truesize;
> +#endif
> +}
> +
>  /**
>   *  igb_add_rx_frag - Add contents of Rx buffer to sk_buff
>   *  @rx_ring: rx descriptor ring to transact packets on
> @@ -8269,20 +8297,12 @@ static void igb_add_rx_frag(struct igb_ring *rx_ring,
>  			    struct sk_buff *skb,
>  			    unsigned int size)
>  {
> -#if (PAGE_SIZE < 8192)
> -	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
> -#else
> -	unsigned int truesize = ring_uses_build_skb(rx_ring) ?
> -				SKB_DATA_ALIGN(IGB_SKB_PAD + size) :
> -				SKB_DATA_ALIGN(size);
> -#endif
> +	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);

I don't think we need to account the size of skb_shared_info when adding
another frag as we already have the skb in place with its skb_shared_info.

Also, please make sure that you list all of the changes that patch
contains in the commit message, you simply skipped the fact that you're
making use of igb_rx_frame_truesize on other places.

> +
>  	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
>  			rx_buffer->page_offset, size, truesize);
> -#if (PAGE_SIZE < 8192)
> -	rx_buffer->page_offset ^= truesize;
> -#else
> -	rx_buffer->page_offset += truesize;
> -#endif
> +
> +	igb_rx_buffer_flip(rx_ring, rx_buffer, size);
>  }
>  
>  static struct sk_buff *igb_construct_skb(struct igb_ring *rx_ring,
> @@ -8345,14 +8365,9 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
>  				     struct xdp_buff *xdp,
>  				     union e1000_adv_rx_desc *rx_desc)
>  {
> +	unsigned int size = xdp->data_end - xdp->data_hard_start;
> +	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);

Here you will be counting the IGB_SKB_PAD twice for pages > 4k.
xdp->data_end - xdp->data_hard_start already includes the IGB_SKB_PAD and
then igb_rx_frame_truesize will add this IGB_SKB_PAD once again to the
size you're providing.

Please drop the additional usage of igb_rx_frame_truesize in this patch.

>  	unsigned int metasize = xdp->data - xdp->data_meta;
> -#if (PAGE_SIZE < 8192)
> -	unsigned int truesize = igb_rx_pg_size(rx_ring) / 2;
> -#else
> -	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
> -				SKB_DATA_ALIGN(xdp->data_end -
> -					       xdp->data_hard_start);
> -#endif
>  	struct sk_buff *skb;
>  
>  	/* prefetch first cache line of first page */
> @@ -8377,11 +8392,7 @@ static struct sk_buff *igb_build_skb(struct igb_ring *rx_ring,
>  	}
>  
>  	/* update buffer offset */
> -#if (PAGE_SIZE < 8192)
> -	rx_buffer->page_offset ^= truesize;
> -#else
> -	rx_buffer->page_offset += truesize;
> -#endif
> +	igb_rx_buffer_flip(rx_ring, rx_buffer, size);
>  
>  	return skb;
>  }
> @@ -8431,34 +8442,6 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
>  	return ERR_PTR(-result);
>  }
>  
> -static unsigned int igb_rx_frame_truesize(struct igb_ring *rx_ring,
> -					  unsigned int size)
> -{
> -	unsigned int truesize;
> -
> -#if (PAGE_SIZE < 8192)
> -	truesize = igb_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
> -#else
> -	truesize = ring_uses_build_skb(rx_ring) ?
> -		SKB_DATA_ALIGN(IGB_SKB_PAD + size) +
> -		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> -		SKB_DATA_ALIGN(size);
> -#endif
> -	return truesize;
> -}
> -
> -static void igb_rx_buffer_flip(struct igb_ring *rx_ring,
> -			       struct igb_rx_buffer *rx_buffer,
> -			       unsigned int size)
> -{
> -	unsigned int truesize = igb_rx_frame_truesize(rx_ring, size);
> -#if (PAGE_SIZE < 8192)
> -	rx_buffer->page_offset ^= truesize;
> -#else
> -	rx_buffer->page_offset += truesize;
> -#endif
> -}
> -
>  static inline void igb_rx_checksum(struct igb_ring *ring,
>  				   union e1000_adv_rx_desc *rx_desc,
>  				   struct sk_buff *skb)
> -- 
> 2.20.1
> 
