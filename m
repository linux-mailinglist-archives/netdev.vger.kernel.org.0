Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB5F18A371
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgCRUEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:04:39 -0400
Received: from mga18.intel.com ([134.134.136.126]:8973 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgCRUEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:04:39 -0400
IronPort-SDR: dWxRQZvPDLCVAAoZOWKvPD6Te2meMX4qaclF9rX3V0hzkh6+60K355nu/A7BVlorAqLFXmnPl4
 BF0bHjYFAzoA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 13:04:38 -0700
IronPort-SDR: sAcU/bJLcTSdQ73nlQ5AbVcU7mnh6s/3F/FzZlonUldslalYkoO7W9K9nDnRSYjYZYcL96hG2q
 Djm4o3ltWELg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="233950259"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga007.jf.intel.com with ESMTP; 18 Mar 2020 13:04:34 -0700
Date:   Wed, 18 Mar 2020 21:03:00 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bjorn.topel@intel.com,
        kuba@kernel.org
Subject: Re: [PATCH RFC v1 05/15] ixgbe: add XDP frame size to driver
Message-ID: <20200318200300.GA18295@ranger.igk.intel.com>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
 <158446617307.702578.17057660405507953624.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158446617307.702578.17057660405507953624.stgit@firesoul>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 06:29:33PM +0100, Jesper Dangaard Brouer wrote:
> The ixgbe driver uses different memory models depending on PAGE_SIZE at
> compile time. For PAGE_SIZE 4K it uses page splitting, meaning for
> normal MTU frame size is 2048 bytes (and headroom 192 bytes).

To be clear the 2048 is the size of buffer given to HW and we slice it up
in a following way:
- 192 bytes dedicated for headroom
- 1500 is max allowed MTU for this setup
- 320 bytes for tailroom (skb shinfo)

In case you go with higher MTU then 3K buffer would be used and it would
came from order1 page and we still do the half split. Just FYI all of this
is for PAGE_SIZE == 4k and L1$ size == 64.

> For PAGE_SIZE larger than 4K, driver advance its rx_buffer->page_offset
> with the frame size "truesize".

Alex, couldn't we base the truesize here somehow on ixgbe_rx_bufsz() since
these are the sizes that we are passing to hw? I must admit I haven't been
in touch with systems with PAGE_SIZE > 4K.

> 
> When driver enable XDP it uses build_skb() which provides the necessary
> tailroom for XDP-redirect.

We still allow to load XDP prog when ring is not using build_skb(). I have
a feeling that we should drop this case now.

Alex/John/Bjorn WDYT?

> 
> When XDP frame size doesn't depend on RX packet size (4K case), then
> xdp.frame_sz can be updated once outside the main NAPI loop.
> 
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   17 +++++++++++++++++
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   18 ++++++++++--------
>  2 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> index 2833e4f041ce..943b643b6ed8 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> @@ -417,6 +417,23 @@ static inline unsigned int ixgbe_rx_pg_order(struct ixgbe_ring *ring)
>  }
>  #define ixgbe_rx_pg_size(_ring) (PAGE_SIZE << ixgbe_rx_pg_order(_ring))
>  
> +static inline unsigned int ixgbe_rx_frame_truesize(struct ixgbe_ring *rx_ring,
> +						   unsigned int size)
> +{
> +	unsigned int truesize;
> +
> +#if (PAGE_SIZE < 8192)
> +	truesize = ixgbe_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
> +#else
> +	/* Notice XDP must use build_skb() mode */
> +	truesize = ring_uses_build_skb(rx_ring) ?
> +		SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) +
> +		SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> +		SKB_DATA_ALIGN(size);
> +#endif
> +	return truesize;
> +}
> +
>  #define IXGBE_ITR_ADAPTIVE_MIN_INC	2
>  #define IXGBE_ITR_ADAPTIVE_MIN_USECS	10
>  #define IXGBE_ITR_ADAPTIVE_MAX_USECS	126
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index ea6834bae04c..f505ed8c9dc1 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -2248,16 +2248,10 @@ static void ixgbe_rx_buffer_flip(struct ixgbe_ring *rx_ring,
>  				 struct ixgbe_rx_buffer *rx_buffer,
>  				 unsigned int size)
>  {
> +	unsigned int truesize = ixgbe_rx_frame_truesize(rx_ring, size);
>  #if (PAGE_SIZE < 8192)
> -	unsigned int truesize = ixgbe_rx_pg_size(rx_ring) / 2;
> -
>  	rx_buffer->page_offset ^= truesize;
>  #else
> -	unsigned int truesize = ring_uses_build_skb(rx_ring) ?
> -				SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) +
> -				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> -				SKB_DATA_ALIGN(size);
> -
>  	rx_buffer->page_offset += truesize;
>  #endif
>  }
> @@ -2291,6 +2285,11 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
>  
>  	xdp.rxq = &rx_ring->xdp_rxq;
>  
> +	/* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
> +#if (PAGE_SIZE < 8192)
> +	xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, 0);
> +#endif
> +
>  	while (likely(total_rx_packets < budget)) {
>  		union ixgbe_adv_rx_desc *rx_desc;
>  		struct ixgbe_rx_buffer *rx_buffer;
> @@ -2324,7 +2323,10 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
>  			xdp.data_hard_start = xdp.data -
>  					      ixgbe_rx_offset(rx_ring);
>  			xdp.data_end = xdp.data + size;
> -
> +#if (PAGE_SIZE > 4096)
> +			/* At larger PAGE_SIZE, frame_sz depend on size */
> +			xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, size);
> +#endif
>  			skb = ixgbe_run_xdp(adapter, rx_ring, &xdp);
>  		}
>  
> 
> 
