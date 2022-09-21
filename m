Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24755E53D4
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 21:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiIUTd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 15:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIUTdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 15:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252959A9F5
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 12:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663788802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lyl8d0UTqhTNQVdabaCnbEqAj4eSP16PP7QEpQvfXco=;
        b=MOZz8IVJzzRIelJJkUoO7WoYZQUjRbzzTmZIDJKk90Z2VmyLjDh2duYP2vzOqtCEZyu5+g
        Xj5lxuDqzmJvblQU3hrp28MyglwUApGUCVX/ORw7ONifhZJtPS3mMk9SkUtBL5kypIy8Q6
        V+7XCdJKEOrC0BVOTS/J3kYAwoj5VD4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-184-APLQbTohNFOZE4O2l99pJA-1; Wed, 21 Sep 2022 15:33:21 -0400
X-MC-Unique: APLQbTohNFOZE4O2l99pJA-1
Received: by mail-qk1-f197.google.com with SMTP id w10-20020a05620a444a00b006ce9917ea1fso4962644qkp.16
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 12:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=lyl8d0UTqhTNQVdabaCnbEqAj4eSP16PP7QEpQvfXco=;
        b=jttVzYPXT7kkAXEsNTT/NOtPkv3rsTjH8De+fuVu3b23o3SHIq2+u6+P2XUHNKoel6
         9fAkw+Yl9LGZk6j8iaohm9f5Ng9hsAVoTDm+xR5mPna7nmHWq9rjl/1qBnX4KEjmr8/1
         glfRneZmZiTI9AQLblNH1lW3xszpQe2Z7Bhlm77cu3LaBnrMt8QHxgX0fS8guUn2BM+A
         lxHeXoNlykMqeUSMjq8dGkzfGya/6wP0XkD5+EGlXo1edev7xp/tlRJQvIHHMPai6VBv
         LerE6+v8LpIJSLMMtzeuTGAC7O7Ur8ZD2M8Qb4whXSt2qbBY+f4BJrLuBUzRSpW19oYZ
         7b2Q==
X-Gm-Message-State: ACrzQf2Mderzw8TIJUwQnZIFk3AqJv/zt9IWv0Ya5wUg+RYB1Lxl3Dww
        e87n4y3gXT5r6packJ9x9Fp+v3FjWJd4zqyQMUioZRBj2TtJNYczQMI3nKVLpSdiIb4d21rcPs8
        SiYNG+Z7QYXzFnFG3
X-Received: by 2002:a05:6214:5187:b0:4ad:77a0:f088 with SMTP id kl7-20020a056214518700b004ad77a0f088mr1973122qvb.0.1663788800263;
        Wed, 21 Sep 2022 12:33:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6/Huz4u/l4X4FZHjlKKIrrDIAmTYcpdE1KhsFWIH/dUVRKOad89eawM0HQXTQfDY1BAT+Tnw==
X-Received: by 2002:a05:6214:5187:b0:4ad:77a0:f088 with SMTP id kl7-20020a056214518700b004ad77a0f088mr1973099qvb.0.1663788799930;
        Wed, 21 Sep 2022 12:33:19 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id bp36-20020a05620a45a400b006bb78d095c5sm2531506qkb.79.2022.09.21.12.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 12:33:19 -0700 (PDT)
Message-ID: <cb3f22f20f3ecb8b049c3e590fd99c52006ef964.camel@redhat.com>
Subject: Re: [PATCH net-next] net: skb: introduce and use a single page frag
 cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 21 Sep 2022 21:33:16 +0200
In-Reply-To: <e2bf192391a86358f5c7502980268f17682bb328.camel@gmail.com>
References: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
         <e2bf192391a86358f5c7502980268f17682bb328.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-21 at 11:11 -0700, Alexander H Duyck wrote:
> On Wed, 2022-09-21 at 18:41 +0200, Paolo Abeni wrote:
> > After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> > for tiny skbs") we are observing 10-20% regressions in performance
> > tests with small packets. The perf trace points to high pressure on
> > the slab allocator.
> > 
> > This change tries to improve the allocation schema for small packets
> > using an idea originally suggested by Eric: a new per CPU page frag is
> > introduced and used in __napi_alloc_skb to cope with small allocation
> > requests.
> > 
> > To ensure that the above does not lead to excessive truesize
> > underestimation, the frag size for small allocation is inflated to 1K
> > and all the above is restricted to build with 4K page size.
> > 
> > Note that we need to update accordingly the run-time check introduced
> > with commit fd9ea57f4e95 ("net: add napi_get_frags_check() helper").
> > 
> > Alex suggested a smart page refcount schema to reduce the number
> > of atomic operations and deal properly with pfmemalloc pages.
> > 
> > Under small packet UDP flood, I measure a 15% peak tput increases.
> > 
> > Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Suggested-by: Alexander H Duyck <alexander.duyck@gmail.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > @Eric, @Alex please let me know if you are comfortable with the
> > attribution
> > ---
> >  include/linux/netdevice.h |   1 +
> >  net/core/dev.c            |  17 ------
> >  net/core/skbuff.c         | 115 +++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 113 insertions(+), 20 deletions(-)
> > 
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 9f42fc871c3b..a1938560192a 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3822,6 +3822,7 @@ void netif_receive_skb_list(struct list_head *head);
> >  gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb);
> >  void napi_gro_flush(struct napi_struct *napi, bool flush_old);
> >  struct sk_buff *napi_get_frags(struct napi_struct *napi);
> > +void napi_get_frags_check(struct napi_struct *napi);
> >  gro_result_t napi_gro_frags(struct napi_struct *napi);
> >  struct packet_offload *gro_find_receive_by_type(__be16 type);
> >  struct packet_offload *gro_find_complete_by_type(__be16 type);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index d66c73c1c734..fa53830d0683 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6358,23 +6358,6 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
> >  }
> >  EXPORT_SYMBOL(dev_set_threaded);
> >  
> > -/* Double check that napi_get_frags() allocates skbs with
> > - * skb->head being backed by slab, not a page fragment.
> > - * This is to make sure bug fixed in 3226b158e67c
> > - * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > - * does not accidentally come back.
> > - */
> > -static void napi_get_frags_check(struct napi_struct *napi)
> > -{
> > -	struct sk_buff *skb;
> > -
> > -	local_bh_disable();
> > -	skb = napi_get_frags(napi);
> > -	WARN_ON_ONCE(skb && skb->head_frag);
> > -	napi_free_frags(napi);
> > -	local_bh_enable();
> > -}
> > -
> >  void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
> >  			   int (*poll)(struct napi_struct *, int), int weight)
> >  {
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index f1b8b20fc20b..2be11b487df1 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -134,8 +134,73 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
> >  #define NAPI_SKB_CACHE_BULK	16
> >  #define NAPI_SKB_CACHE_HALF	(NAPI_SKB_CACHE_SIZE / 2)
> >  
> > +/* the compiler doesn't like 'SKB_TRUESIZE(GRO_MAX_HEAD) > 512', but we
> > + * can imply such condition checking the double word and MAX_HEADER size
> > + */
> > +#if PAGE_SIZE == SZ_4K && (defined(CONFIG_64BIT) || MAX_HEADER > 64)
> > +
> > +#define NAPI_HAS_SMALL_PAGE_FRAG 1
> > +
> > +/* specializzed page frag allocator using a single order 0 page
> > + * and slicing it into 1K sized fragment. Constrained to system
> > + * with:
> > + * - a very limited amount of 1K fragments fitting a single
> > + *   page - to avoid excessive truesize underestimation
> > + * - reasonably high truesize value for napi_get_frags()
> > + *   allocation - to avoid memory usage increased compared
> > + *   to kalloc, see __napi_alloc_skb()
> > + *
> > + */
> > +struct page_frag_1k {
> > +	void *va;
> > +	u16 offset;
> > +	bool pfmemalloc;
> > +};
> > +
> > +static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
> > +{
> > +	struct page *page;
> > +	int offset;
> > +
> > +	if (likely(nc->va)) {
> > +		offset = nc->offset - SZ_1K;
> > +		if (likely(offset >= 0))
> > +			goto out;
> > +
> > +		put_page(virt_to_page(nc->va));
> > +	}
> > +
> > +	page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
> > +	if (!page) {
> > +		nc->va = NULL;
> > +		return NULL;
> > +	}
> > +
> > +	nc->va = page_address(page);
> > +	nc->pfmemalloc = page_is_pfmemalloc(page);
> > +	page_ref_add(page, PAGE_SIZE / SZ_1K);
> > +	offset = PAGE_SIZE - SZ_1K;
> > +
> > +out:
> > +	nc->offset = offset;
> > +	return nc->va + offset;
> 
> So you might be better off organizing this around the offset rather
> than the virtual address. As long as offset is 0 you know the page
> isn't there and has to be replaced.
> 
> 	offset = nc->offset - SZ_1K;
> 	if (offset >= 0)
> 		goto out;
> 
> 	page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
> 	if (!page)
> 		return NULL;
> 
> 	nc->va = page_address(page);
> 	nc->pfmemalloc = page_is_pfmemalloc(page);
> 	offset = PAGE_SIZE - SZ_1K;
> 	page_ref_add(page, offset / SZ_1K);
> out:
> 	nc->offset = offset;
> 	return nc->va + offset;
> 
> That will save you from having to call put_page and cleans it up so you
> only have to perform 1 conditional check instead of 2 in the fast path.

Nice! I'll use that in v2, with page_ref_add(page, offset / SZ_1K - 1);
or we will leak the page.

> > +}
> > +#else
> > +#define NAPI_HAS_SMALL_PAGE_FRAG 0
> > +
> > +struct page_frag_1k {
> > +};
> > +
> > +static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp_mask)
> > +{
> > +	return NULL;
> > +}
> > +
> > +#endif
> > +
> 
> Rather than have this return NULL why not just point it at the
> page_frag_alloc?

When NAPI_HAS_SMALL_PAGE_FRAG is 0, page_frag_alloc_1k() is never used.
the definition is there just to please the compiler. I preferred this
style to avoid more #ifdef in __napi_alloc_skb().

> >  struct napi_alloc_cache {
> >  	struct page_frag_cache page;
> > +	struct page_frag_1k page_small;
> >  	unsigned int skb_count;
> >  	void *skb_cache[NAPI_SKB_CACHE_SIZE];
> >  };
> > @@ -143,6 +208,23 @@ struct napi_alloc_cache {
> >  static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
> >  static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
> >  
> > +/* Double check that napi_get_frags() allocates skbs with
> > + * skb->head being backed by slab, not a page fragment.
> > + * This is to make sure bug fixed in 3226b158e67c
> > + * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > + * does not accidentally come back.
> > + */
> > +void napi_get_frags_check(struct napi_struct *napi)
> > +{
> > +	struct sk_buff *skb;
> > +
> > +	local_bh_disable();
> > +	skb = napi_get_frags(napi);
> > +	WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
> > +	napi_free_frags(napi);
> > +	local_bh_enable();
> > +}
> > +
> >  void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
> >  {
> >  	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> > @@ -561,15 +643,39 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> >  {
> >  	struct napi_alloc_cache *nc;
> >  	struct sk_buff *skb;
> > +	bool pfmemalloc;
> >  	void *data;
> >  
> >  	DEBUG_NET_WARN_ON_ONCE(!in_softirq());
> >  	len += NET_SKB_PAD + NET_IP_ALIGN;
> >  
> > +	/* When the small frag allocator is available, prefer it over kmalloc
> > +	 * for small fragments
> > +	 */
> > +	if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
> > +		nc = this_cpu_ptr(&napi_alloc_cache);
> > +
> > +		if (sk_memalloc_socks())
> > +			gfp_mask |= __GFP_MEMALLOC;
> > +
> > +		/* we are artificially inflating the allocation size, but
> > +		 * that is not as bad as it may look like, as:
> > +		 * - 'len' less then GRO_MAX_HEAD makes little sense
> > +		 * - larger 'len' values lead to fragment size above 512 bytes
> > +		 *   as per NAPI_HAS_SMALL_PAGE_FRAG definition
> > +		 * - kmalloc would use the kmalloc-1k slab for such values
> > +		 */
> > +		len = SZ_1K;
> > +
> > +		data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
> > +		pfmemalloc = nc->page_small.pfmemalloc;
> > +		goto check_data;
> > +	}
> > +
> 
> It might be better to place this code further down as a branch rather
> than having to duplicate things up here such as the __GFP_MEMALLOC
> setting.
> 
> You could essentially just put the lines getting the napi_alloc_cache
> and adding the shared info after the sk_memalloc_socks() check. Then it
> could just be an if/else block either calling page_frag_alloc or your
> page_frag_alloc_1k.

I thought about that option, but I did not like it much because adds a
conditional in the fast-path for small-size allocation, and the
duplicate code is very little.

I can change the code that way, if you have strong opinion in that
regards.

> >  	/* If requested length is either too small or too big,
> >  	 * we use kmalloc() for skb->head allocation.
> >  	 */
> > -	if (len <= SKB_WITH_OVERHEAD(1024) ||
> > +	if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
> >  	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> >  	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> >  		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
> > @@ -587,6 +693,9 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> >  		gfp_mask |= __GFP_MEMALLOC;
> >  
> >  	data = page_frag_alloc(&nc->page, len, gfp_mask);
> > +	pfmemalloc = nc->page.pfmemalloc;
> > +
> > +check_data:
> >  	if (unlikely(!data))
> >  		return NULL;
> >  
> > @@ -596,8 +705,8 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> >  		return NULL;
> >  	}
> >  
> > -	if (nc->page.pfmemalloc)
> > -		skb->pfmemalloc = 1;
> > +	if (pfmemalloc)
> > +		skb->pfmemalloc = pfmemalloc;
> >  	skb->head_frag = 1;
> >  
> >  skb_success:
> 
> In regards to the pfmemalloc bits I wonder if it wouldn't be better to
> just have them both using the page_frag_cache and just use a pointer to
> that to populate the skb->pfmemalloc based on frag_cache->pfmemalloc at
> the end?

Why? in the end we will still use an ancillary variable and the
napi_alloc_cache struct will be bigger (probaly not very relevant, but
for no gain at all).

Thanks!

Paolo

