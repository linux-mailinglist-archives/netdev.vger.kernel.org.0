Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A695E5476
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 22:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiIUUXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 16:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiIUUXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 16:23:33 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D1AA4B0B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:23:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so4381566pjb.0
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date;
        bh=aGQJorkmLb2mT6TRXHkb14jfmbq6wubGFCZXBNCDrY8=;
        b=PYYhMxZOW9LLqr5Rsv6FLVCc23su5HC9x7+ceXWx+yV/P5qvZxMpeERV9T2ldy8vUO
         riZDSI0jBXedVigszWV9De2Vgx5znCNeQQL01r+0sMkQniUCpXit2ytb1JgtriSkP3+4
         csUSh1MQ+A32Zv3qq3T+Hn0Tr17VAkts/unAJo4IUNno6LMDB4I2NK4DRNN9EZ9VZu6t
         eR8GYRRkz8rTpY/BtYYMMiDwCF2KxgX4BC8igPzIHfghfzDj50mvy2FnNr7rgu+NeJ7q
         6exoQB82Zye+aSN9h/e2p8umpB7wiYV3DhDGJBNo5pSOaSXNe4nnnmhQat3xKAMxlwlK
         Oi3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=aGQJorkmLb2mT6TRXHkb14jfmbq6wubGFCZXBNCDrY8=;
        b=l8Kov66zRhMwZW5WNs97pBXjaPDRCfFg5v0+ttyqik+pKwSgbtqrRdq+6ESjB33RDg
         0F37mfwRsj/Kh25avZ0mTXAXwRFxg1dD3tHrODiKsiA5eG715VSvdR7nhkUK/GJK3HCO
         TeM85LOGT1tBSAokHiBtCaXWELiU9zxnrMk75g1Ircm2M+Nc/VDqjjZ7VfUti4Z/bIZG
         FZuvat/68mJNWrGlDCuWvY4odS+52rekBO4ACFr8iw5WOMHdq0+tKxO4b+yGUp+x2b+x
         X9spyz+kjUL0JBysPq7euQa8WORt59uBrpeHP0v6XivtTQqXMCsRVTKOHhT3C7QBwlC2
         YgFQ==
X-Gm-Message-State: ACrzQf2VNsVnowzhEOowFjbfPhaEZeQZAmf7EaHORF3Vd09ba2qdadJg
        J6JbrwDO6gKSZOMc0Ra8gVg=
X-Google-Smtp-Source: AMsMyM5ekTaa0eodZog3F50k6NA+Ik+fEMkDUmAeQK8yAc8BPcJhH2CaMIKEjBOK0X/2qlNa+H2/Rg==
X-Received: by 2002:a17:90b:4a48:b0:202:9bcb:b89c with SMTP id lb8-20020a17090b4a4800b002029bcbb89cmr11766588pjb.161.1663791810862;
        Wed, 21 Sep 2022 13:23:30 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.37.164])
        by smtp.googlemail.com with ESMTPSA id 5-20020a620505000000b00541206f9379sm2648340pff.99.2022.09.21.13.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 13:23:30 -0700 (PDT)
Message-ID: <1642882091e772bcdbf44e61fe5fce125a034e52.camel@gmail.com>
Subject: Re: [PATCH net-next] net: skb: introduce and use a single page frag
 cache
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Wed, 21 Sep 2022 13:23:28 -0700
In-Reply-To: <cb3f22f20f3ecb8b049c3e590fd99c52006ef964.camel@redhat.com>
References: <59a54c9a654fe19cc9fb7da5b2377029d93a181e.1663778475.git.pabeni@redhat.com>
         <e2bf192391a86358f5c7502980268f17682bb328.camel@gmail.com>
         <cb3f22f20f3ecb8b049c3e590fd99c52006ef964.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-21 at 21:33 +0200, Paolo Abeni wrote:
> On Wed, 2022-09-21 at 11:11 -0700, Alexander H Duyck wrote:
> > On Wed, 2022-09-21 at 18:41 +0200, Paolo Abeni wrote:
> > > After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
> > > for tiny skbs") we are observing 10-20% regressions in performance
> > > tests with small packets. The perf trace points to high pressure on
> > > the slab allocator.
> > >=20
> > > This change tries to improve the allocation schema for small packets
> > > using an idea originally suggested by Eric: a new per CPU page frag i=
s
> > > introduced and used in __napi_alloc_skb to cope with small allocation
> > > requests.
> > >=20
> > > To ensure that the above does not lead to excessive truesize
> > > underestimation, the frag size for small allocation is inflated to 1K
> > > and all the above is restricted to build with 4K page size.
> > >=20
> > > Note that we need to update accordingly the run-time check introduced
> > > with commit fd9ea57f4e95 ("net: add napi_get_frags_check() helper").
> > >=20
> > > Alex suggested a smart page refcount schema to reduce the number
> > > of atomic operations and deal properly with pfmemalloc pages.
> > >=20
> > > Under small packet UDP flood, I measure a 15% peak tput increases.
> > >=20
> > > Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> > > Suggested-by: Alexander H Duyck <alexander.duyck@gmail.com>
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > ---
> > > @Eric, @Alex please let me know if you are comfortable with the
> > > attribution
> > > ---
> > >  include/linux/netdevice.h |   1 +
> > >  net/core/dev.c            |  17 ------
> > >  net/core/skbuff.c         | 115 ++++++++++++++++++++++++++++++++++++=
+-
> > >  3 files changed, 113 insertions(+), 20 deletions(-)
> > >=20
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index 9f42fc871c3b..a1938560192a 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -3822,6 +3822,7 @@ void netif_receive_skb_list(struct list_head *h=
ead);
> > >  gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_bu=
ff *skb);
> > >  void napi_gro_flush(struct napi_struct *napi, bool flush_old);
> > >  struct sk_buff *napi_get_frags(struct napi_struct *napi);
> > > +void napi_get_frags_check(struct napi_struct *napi);
> > >  gro_result_t napi_gro_frags(struct napi_struct *napi);
> > >  struct packet_offload *gro_find_receive_by_type(__be16 type);
> > >  struct packet_offload *gro_find_complete_by_type(__be16 type);
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index d66c73c1c734..fa53830d0683 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -6358,23 +6358,6 @@ int dev_set_threaded(struct net_device *dev, b=
ool threaded)
> > >  }
> > >  EXPORT_SYMBOL(dev_set_threaded);
> > > =20
> > > -/* Double check that napi_get_frags() allocates skbs with
> > > - * skb->head being backed by slab, not a page fragment.
> > > - * This is to make sure bug fixed in 3226b158e67c
> > > - * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > > - * does not accidentally come back.
> > > - */
> > > -static void napi_get_frags_check(struct napi_struct *napi)
> > > -{
> > > -	struct sk_buff *skb;
> > > -
> > > -	local_bh_disable();
> > > -	skb =3D napi_get_frags(napi);
> > > -	WARN_ON_ONCE(skb && skb->head_frag);
> > > -	napi_free_frags(napi);
> > > -	local_bh_enable();
> > > -}
> > > -
> > >  void netif_napi_add_weight(struct net_device *dev, struct napi_struc=
t *napi,
> > >  			   int (*poll)(struct napi_struct *, int), int weight)
> > >  {
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index f1b8b20fc20b..2be11b487df1 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -134,8 +134,73 @@ static void skb_under_panic(struct sk_buff *skb,=
 unsigned int sz, void *addr)
> > >  #define NAPI_SKB_CACHE_BULK	16
> > >  #define NAPI_SKB_CACHE_HALF	(NAPI_SKB_CACHE_SIZE / 2)
> > > =20
> > > +/* the compiler doesn't like 'SKB_TRUESIZE(GRO_MAX_HEAD) > 512', but=
 we
> > > + * can imply such condition checking the double word and MAX_HEADER =
size
> > > + */
> > > +#if PAGE_SIZE =3D=3D SZ_4K && (defined(CONFIG_64BIT) || MAX_HEADER >=
 64)
> > > +
> > > +#define NAPI_HAS_SMALL_PAGE_FRAG 1
> > > +
> > > +/* specializzed page frag allocator using a single order 0 page
> > > + * and slicing it into 1K sized fragment. Constrained to system
> > > + * with:
> > > + * - a very limited amount of 1K fragments fitting a single
> > > + *   page - to avoid excessive truesize underestimation
> > > + * - reasonably high truesize value for napi_get_frags()
> > > + *   allocation - to avoid memory usage increased compared
> > > + *   to kalloc, see __napi_alloc_skb()
> > > + *
> > > + */
> > > +struct page_frag_1k {
> > > +	void *va;
> > > +	u16 offset;
> > > +	bool pfmemalloc;
> > > +};
> > > +
> > > +static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
> > > +{
> > > +	struct page *page;
> > > +	int offset;
> > > +
> > > +	if (likely(nc->va)) {
> > > +		offset =3D nc->offset - SZ_1K;
> > > +		if (likely(offset >=3D 0))
> > > +			goto out;
> > > +
> > > +		put_page(virt_to_page(nc->va));
> > > +	}
> > > +
> > > +	page =3D alloc_pages_node(NUMA_NO_NODE, gfp, 0);
> > > +	if (!page) {
> > > +		nc->va =3D NULL;
> > > +		return NULL;
> > > +	}
> > > +
> > > +	nc->va =3D page_address(page);
> > > +	nc->pfmemalloc =3D page_is_pfmemalloc(page);
> > > +	page_ref_add(page, PAGE_SIZE / SZ_1K);
> > > +	offset =3D PAGE_SIZE - SZ_1K;
> > > +
> > > +out:
> > > +	nc->offset =3D offset;
> > > +	return nc->va + offset;
> >=20
> > So you might be better off organizing this around the offset rather
> > than the virtual address. As long as offset is 0 you know the page
> > isn't there and has to be replaced.
> >=20
> > 	offset =3D nc->offset - SZ_1K;
> > 	if (offset >=3D 0)
> > 		goto out;
> >=20
> > 	page =3D alloc_pages_node(NUMA_NO_NODE, gfp, 0);
> > 	if (!page)
> > 		return NULL;
> >=20
> > 	nc->va =3D page_address(page);
> > 	nc->pfmemalloc =3D page_is_pfmemalloc(page);
> > 	offset =3D PAGE_SIZE - SZ_1K;
> > 	page_ref_add(page, offset / SZ_1K);
> > out:
> > 	nc->offset =3D offset;
> > 	return nc->va + offset;
> >=20
> > That will save you from having to call put_page and cleans it up so you
> > only have to perform 1 conditional check instead of 2 in the fast path.
>=20
> Nice! I'll use that in v2, with page_ref_add(page, offset / SZ_1K - 1);
> or we will leak the page.

No, the offset already takes care of the -1 via the "- SZ_1K". What we
are adding is references for the unused offset.

> > > +}
> > > +#else
> > > +#define NAPI_HAS_SMALL_PAGE_FRAG 0
> > > +
> > > +struct page_frag_1k {
> > > +};
> > > +
> > > +static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp_m=
ask)
> > > +{
> > > +	return NULL;
> > > +}
> > > +
> > > +#endif
> > > +
> >=20
> > Rather than have this return NULL why not just point it at the
> > page_frag_alloc?
>=20
> When NAPI_HAS_SMALL_PAGE_FRAG is 0, page_frag_alloc_1k() is never used.
> the definition is there just to please the compiler. I preferred this
> style to avoid more #ifdef in __napi_alloc_skb().
>=20

Okay, makes sense I guess.

> > >  struct napi_alloc_cache {
> > >  	struct page_frag_cache page;
> > > +	struct page_frag_1k page_small;
> > >  	unsigned int skb_count;
> > >  	void *skb_cache[NAPI_SKB_CACHE_SIZE];
> > >  };
> > > @@ -143,6 +208,23 @@ struct napi_alloc_cache {
> > >  static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
> > >  static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
> > > =20
> > > +/* Double check that napi_get_frags() allocates skbs with
> > > + * skb->head being backed by slab, not a page fragment.
> > > + * This is to make sure bug fixed in 3226b158e67c
> > > + * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > > + * does not accidentally come back.
> > > + */
> > > +void napi_get_frags_check(struct napi_struct *napi)
> > > +{
> > > +	struct sk_buff *skb;
> > > +
> > > +	local_bh_disable();
> > > +	skb =3D napi_get_frags(napi);
> > > +	WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
> > > +	napi_free_frags(napi);
> > > +	local_bh_enable();
> > > +}
> > > +
> > >  void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int alig=
n_mask)
> > >  {
> > >  	struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
> > > @@ -561,15 +643,39 @@ struct sk_buff *__napi_alloc_skb(struct napi_st=
ruct *napi, unsigned int len,
> > >  {
> > >  	struct napi_alloc_cache *nc;
> > >  	struct sk_buff *skb;
> > > +	bool pfmemalloc;
> > >  	void *data;
> > > =20
> > >  	DEBUG_NET_WARN_ON_ONCE(!in_softirq());
> > >  	len +=3D NET_SKB_PAD + NET_IP_ALIGN;
> > > =20
> > > +	/* When the small frag allocator is available, prefer it over kmall=
oc
> > > +	 * for small fragments
> > > +	 */
> > > +	if (NAPI_HAS_SMALL_PAGE_FRAG && len <=3D SKB_WITH_OVERHEAD(1024)) {
> > > +		nc =3D this_cpu_ptr(&napi_alloc_cache);
> > > +
> > > +		if (sk_memalloc_socks())
> > > +			gfp_mask |=3D __GFP_MEMALLOC;
> > > +
> > > +		/* we are artificially inflating the allocation size, but
> > > +		 * that is not as bad as it may look like, as:
> > > +		 * - 'len' less then GRO_MAX_HEAD makes little sense
> > > +		 * - larger 'len' values lead to fragment size above 512 bytes
> > > +		 *   as per NAPI_HAS_SMALL_PAGE_FRAG definition
> > > +		 * - kmalloc would use the kmalloc-1k slab for such values
> > > +		 */
> > > +		len =3D SZ_1K;
> > > +
> > > +		data =3D page_frag_alloc_1k(&nc->page_small, gfp_mask);
> > > +		pfmemalloc =3D nc->page_small.pfmemalloc;
> > > +		goto check_data;
> > > +	}
> > > +
> >=20
> > It might be better to place this code further down as a branch rather
> > than having to duplicate things up here such as the __GFP_MEMALLOC
> > setting.
> >=20
> > You could essentially just put the lines getting the napi_alloc_cache
> > and adding the shared info after the sk_memalloc_socks() check. Then it
> > could just be an if/else block either calling page_frag_alloc or your
> > page_frag_alloc_1k.
>=20
> I thought about that option, but I did not like it much because adds a
> conditional in the fast-path for small-size allocation, and the
> duplicate code is very little.
>=20
> I can change the code that way, if you have strong opinion in that
> regards.
> >=20

I see, so you are trying to optimize for the smaller packet size.

It occurs to me that I think you are missing the check for the gfp_mask
and the reclaim and DMA flags values as a result with your change. I
think we will need to perform that check before we can do the direct
page allocation based on size.

> > >  	/* If requested length is either too small or too big,
> > >  	 * we use kmalloc() for skb->head allocation.
> > >  	 */
> > > -	if (len <=3D SKB_WITH_OVERHEAD(1024) ||
> > > +	if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <=3D SKB_WITH_OVERHEAD(1024))=
 ||
> > >  	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> > >  	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > >  		skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
> > > @@ -587,6 +693,9 @@ struct sk_buff *__napi_alloc_skb(struct napi_stru=
ct *napi, unsigned int len,
> > >  		gfp_mask |=3D __GFP_MEMALLOC;
> > > =20
> > >  	data =3D page_frag_alloc(&nc->page, len, gfp_mask);
> > > +	pfmemalloc =3D nc->page.pfmemalloc;
> > > +
> > > +check_data:
> > >  	if (unlikely(!data))
> > >  		return NULL;
> > > =20
> > > @@ -596,8 +705,8 @@ struct sk_buff *__napi_alloc_skb(struct napi_stru=
ct *napi, unsigned int len,
> > >  		return NULL;
> > >  	}
> > > =20
> > > -	if (nc->page.pfmemalloc)
> > > -		skb->pfmemalloc =3D 1;
> > > +	if (pfmemalloc)
> > > +		skb->pfmemalloc =3D pfmemalloc;
> > >  	skb->head_frag =3D 1;
> > > =20
> > >  skb_success:
> >=20
> > In regards to the pfmemalloc bits I wonder if it wouldn't be better to
> > just have them both using the page_frag_cache and just use a pointer to
> > that to populate the skb->pfmemalloc based on frag_cache->pfmemalloc at
> > the end?
>=20
> Why? in the end we will still use an ancillary variable and the
> napi_alloc_cache struct will be bigger (probaly not very relevant, but
> for no gain at all).

It was mostly just about reducing instructions. The thought is we could
get rid of the storage of the napi cache entirely since the only thing
used is the page member, so if we just passed that around instead it
would save us the trouble and not really be another variable. Basically
we would be passing a frag cache pointer instead of a napi_alloc_cache.

