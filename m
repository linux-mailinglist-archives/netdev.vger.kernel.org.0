Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AFD2D1EED
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgLHAXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:23:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgLHAXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 19:23:23 -0500
Message-ID: <5465830698257f18ae474877648f4a9fe2e1eefe.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607386961;
        bh=tTkRslH/ok88bKb7NB2iafguo4FPxOwJHmdsIXGzJLs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=S8FfaeoWrylqbX9SQvra9tACzIYfbwd33KAvqZ4WaQk5AFNMOf0HwIskF5wLWGBvN
         6nyX0P1ANOjVyxE8sfU9FSzqGg1cotg0FHs7wCeWdhvdgMFSSpkifhYzGxFKD6rat6
         0xi7uBg3Ac9vm8XD9goRbD21S28jpiQhLbBb1NtSYKhFwsZnvBwG0o6aDXeOz8Zs07
         ijiuKbG58fgwyg+DNk4FIjEfar/C5bhFCv/e3o2rAKxRPHoThklmO3WJ6sWeLtod/q
         CvD2lZSRKInjQ9WzLKSEWpQGRK8u/pqOu3OxFcRehztrMKXakD/7gJzRZwhrfVU1Aj
         8Nz7JlLLpJ7iw==
Subject: Re: [PATCH v5 bpf-next 03/14] xdp: add xdp_shared_info data
 structure
From:   Saeed Mahameed <saeed@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        jasowang@redhat.com
Date:   Mon, 07 Dec 2020 16:22:39 -0800
In-Reply-To: <21d27f233e37b66c9ad4073dd09df5c2904112a4.1607349924.git.lorenzo@kernel.org>
References: <cover.1607349924.git.lorenzo@kernel.org>
         <21d27f233e37b66c9ad4073dd09df5c2904112a4.1607349924.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-07 at 17:32 +0100, Lorenzo Bianconi wrote:
> Introduce xdp_shared_info data structure to contain info about
> "non-linear" xdp frame. xdp_shared_info will alias skb_shared_info
> allowing to keep most of the frags in the same cache-line.
> Introduce some xdp_shared_info helpers aligned to skb_frag* ones
> 

is there or will be a more general purpose use to this xdp_shared_info
? other than hosting frags ?

> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 62 +++++++++++++++--------
> ----
>  include/net/xdp.h                     | 52 ++++++++++++++++++++--
>  2 files changed, 82 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c
> b/drivers/net/ethernet/marvell/mvneta.c
> index 1e5b5c69685a..d635463609ad 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2033,14 +2033,17 @@ int mvneta_rx_refill_queue(struct mvneta_port
> *pp, struct mvneta_rx_queue *rxq)
>  

[...]

>  static void
> @@ -2278,7 +2281,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port
> *pp,
>  			    struct mvneta_rx_desc *rx_desc,
>  			    struct mvneta_rx_queue *rxq,
>  			    struct xdp_buff *xdp, int *size,
> -			    struct skb_shared_info *xdp_sinfo,
> +			    struct xdp_shared_info *xdp_sinfo,
>  			    struct page *page)
>  {
>  	struct net_device *dev = pp->dev;
> @@ -2301,13 +2304,13 @@ mvneta_swbm_add_rx_fragment(struct
> mvneta_port *pp,
>  	if (data_len > 0 && xdp_sinfo->nr_frags < MAX_SKB_FRAGS) {
>  		skb_frag_t *frag = &xdp_sinfo->frags[xdp_sinfo-
> >nr_frags++];
>  
> -		skb_frag_off_set(frag, pp->rx_offset_correction);
> -		skb_frag_size_set(frag, data_len);
> -		__skb_frag_set_page(frag, page);
> +		xdp_set_frag_offset(frag, pp->rx_offset_correction);
> +		xdp_set_frag_size(frag, data_len);
> +		xdp_set_frag_page(frag, page);
>  

why three separate setters ? why not just one 
xdp_set_frag(page, offset, size) ?

>  		/* last fragment */
>  		if (len == *size) {
> -			struct skb_shared_info *sinfo;
> +			struct xdp_shared_info *sinfo;
>  
>  			sinfo = xdp_get_shared_info_from_buff(xdp);
>  			sinfo->nr_frags = xdp_sinfo->nr_frags;
> @@ -2324,10 +2327,13 @@ static struct sk_buff *
>  mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue
> *rxq,
>  		      struct xdp_buff *xdp, u32 desc_status)
>  {
> -	struct skb_shared_info *sinfo =
> xdp_get_shared_info_from_buff(xdp);
> -	int i, num_frags = sinfo->nr_frags;
> +	struct xdp_shared_info *xdp_sinfo =
> xdp_get_shared_info_from_buff(xdp);
> +	int i, num_frags = xdp_sinfo->nr_frags;
> +	skb_frag_t frag_list[MAX_SKB_FRAGS];
>  	struct sk_buff *skb;
>  
> +	memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) *
> num_frags);
> +
>  	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
>  	if (!skb)
>  		return ERR_PTR(-ENOMEM);
> @@ -2339,12 +2345,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp,
> struct mvneta_rx_queue *rxq,
>  	mvneta_rx_csum(pp, desc_status, skb);
>  
>  	for (i = 0; i < num_frags; i++) {
> -		skb_frag_t *frag = &sinfo->frags[i];
> +		struct page *page = xdp_get_frag_page(&frag_list[i]);
>  
>  		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> -				skb_frag_page(frag),
> skb_frag_off(frag),
> -				skb_frag_size(frag), PAGE_SIZE);
> -		page_pool_release_page(rxq->page_pool,
> skb_frag_page(frag));
> +				page,
> xdp_get_frag_offset(&frag_list[i]),
> +				xdp_get_frag_size(&frag_list[i]),
> PAGE_SIZE);
> +		page_pool_release_page(rxq->page_pool, page);
>  	}
>  
>  	return skb;
> @@ -2357,7 +2363,7 @@ static int mvneta_rx_swbm(struct napi_struct
> *napi,
>  {
>  	int rx_proc = 0, rx_todo, refill, size = 0;
>  	struct net_device *dev = pp->dev;
> -	struct skb_shared_info sinfo;
> +	struct xdp_shared_info xdp_sinfo;
>  	struct mvneta_stats ps = {};
>  	struct bpf_prog *xdp_prog;
>  	u32 desc_status, frame_sz;
> @@ -2368,7 +2374,7 @@ static int mvneta_rx_swbm(struct napi_struct
> *napi,
>  	xdp_buf.rxq = &rxq->xdp_rxq;
>  	xdp_buf.mb = 0;
>  
> -	sinfo.nr_frags = 0;
> +	xdp_sinfo.nr_frags = 0;
>  
>  	/* Get number of received packets */
>  	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
> @@ -2412,7 +2418,7 @@ static int mvneta_rx_swbm(struct napi_struct
> *napi,
>  			}
>  
>  			mvneta_swbm_add_rx_fragment(pp, rx_desc, rxq,
> &xdp_buf,
> -						    &size, &sinfo,
> page);
> +						    &size, &xdp_sinfo,
> page);
>  		} /* Middle or Last descriptor */
>  
>  		if (!(rx_status & MVNETA_RXD_LAST_DESC))
> @@ -2420,7 +2426,7 @@ static int mvneta_rx_swbm(struct napi_struct
> *napi,
>  			continue;
>  
>  		if (size) {
> -			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo,
> -1);
> +			mvneta_xdp_put_buff(pp, rxq, &xdp_buf,
> &xdp_sinfo, -1);
>  			goto next;
>  		}
>  
> @@ -2432,7 +2438,7 @@ static int mvneta_rx_swbm(struct napi_struct
> *napi,
>  		if (IS_ERR(skb)) {
>  			struct mvneta_pcpu_stats *stats =
> this_cpu_ptr(pp->stats);
>  
> -			mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo,
> -1);
> +			mvneta_xdp_put_buff(pp, rxq, &xdp_buf,
> &xdp_sinfo, -1);
>  
>  			u64_stats_update_begin(&stats->syncp);
>  			stats->es.skb_alloc_error++;
> @@ -2449,12 +2455,12 @@ static int mvneta_rx_swbm(struct napi_struct
> *napi,
>  		napi_gro_receive(napi, skb);
>  next:
>  		xdp_buf.data_hard_start = NULL;
> -		sinfo.nr_frags = 0;
> +		xdp_sinfo.nr_frags = 0;
>  	}
>  	rcu_read_unlock();
>  
>  	if (xdp_buf.data_hard_start)
> -		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &sinfo, -1);
> +		mvneta_xdp_put_buff(pp, rxq, &xdp_buf, &xdp_sinfo, -1);
>  
>  	if (ps.xdp_redirect)
>  		xdp_do_flush_map();
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index 70559720ff44..614f66d35ee8 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -87,10 +87,54 @@ struct xdp_buff {
>  	((xdp)->data_hard_start + (xdp)->frame_sz -	\
>  	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
>  
> -static inline struct skb_shared_info *
> +struct xdp_shared_info {

xdp_shared_info is a bad name, we need this to have a specific purpose 
xdp_frags should the proper name, so people will think twice before
adding weird bits to this so called shared_info.

> +	u16 nr_frags;
> +	u16 data_length; /* paged area length */
> +	skb_frag_t frags[MAX_SKB_FRAGS];

why MAX_SKB_FRAGS ? just use a flexible array member 
skb_frag_t frags[]; 

and enforce size via the n_frags and on the construction of the
tailroom preserved buffer, which is already being done.

this is waste of unnecessary space, at lease by definition of the
struct, in your use case you do:
memcpy(frag_list, xdp_sinfo->frags, sizeof(skb_frag_t) * num_frags);
And the tailroom space was already preserved for a full skb_shinfo.
so i don't see why you need this array to be of a fixed MAX_SKB_FRAGS
size.

> +};
> +
> +static inline struct xdp_shared_info *
>  xdp_get_shared_info_from_buff(struct xdp_buff *xdp)
>  {
> -	return (struct skb_shared_info *)xdp_data_hard_end(xdp);
> +	BUILD_BUG_ON(sizeof(struct xdp_shared_info) >
> +		     sizeof(struct skb_shared_info));
> +	return (struct xdp_shared_info *)xdp_data_hard_end(xdp);
> +}
> +

Back to my first comment, do we have plans to use this tail room buffer
for other than frag_list use cases ? what will be the buffer format
then ? should we push all new fields to the end of the xdp_shared_info
struct ? or deal with this tailroom buffer as a stack ? 
my main concern is that for drivers that don't support frag list and
still want to utilize the tailroom buffer for other usecases they will
have to skip the first sizeof(xdp_shared_info) so they won't break the
stack.

> +static inline struct page *xdp_get_frag_page(const skb_frag_t *frag)
> +{
> +	return frag->bv_page;
> +}
> +
> +static inline unsigned int xdp_get_frag_offset(const skb_frag_t
> *frag)
> +{
> +	return frag->bv_offset;
> +}
> +
> +static inline unsigned int xdp_get_frag_size(const skb_frag_t *frag)
> +{
> +	return frag->bv_len;
> +}
> +
> +static inline void *xdp_get_frag_address(const skb_frag_t *frag)
> +{
> +	return page_address(xdp_get_frag_page(frag)) +
> +	       xdp_get_frag_offset(frag);
> +}
> +
> +static inline void xdp_set_frag_page(skb_frag_t *frag, struct page
> *page)
> +{
> +	frag->bv_page = page;
> +}
> +
> +static inline void xdp_set_frag_offset(skb_frag_t *frag, u32 offset)
> +{
> +	frag->bv_offset = offset;
> +}
> +
> +static inline void xdp_set_frag_size(skb_frag_t *frag, u32 size)
> +{
> +	frag->bv_len = size;
>  }
>  
>  struct xdp_frame {
> @@ -120,12 +164,12 @@ static __always_inline void
> xdp_frame_bulk_init(struct xdp_frame_bulk *bq)
>  	bq->xa = NULL;
>  }
>  
> -static inline struct skb_shared_info *
> +static inline struct xdp_shared_info *
>  xdp_get_shared_info_from_frame(struct xdp_frame *frame)
>  {
>  	void *data_hard_start = frame->data - frame->headroom -
> sizeof(*frame);
>  
> -	return (struct skb_shared_info *)(data_hard_start + frame-
> >frame_sz -
> +	return (struct xdp_shared_info *)(data_hard_start + frame-
> >frame_sz -
>  				SKB_DATA_ALIGN(sizeof(struct
> skb_shared_info)));
>  }
>  

need a comment here why we preserve the size of skb_shared_info, yet
the usable buffer is of type xdp_shared_info.

