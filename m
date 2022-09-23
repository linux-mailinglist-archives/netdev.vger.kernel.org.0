Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376BB5E7F97
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiIWQVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbiIWQUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:20:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03B51A21C
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663949952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BzaafTuUqewrWXj7vYgZEtgaCTa2dI4dC0ftOasCvDA=;
        b=gPZJN7iBSTifqx18lnSpGYNW5Up2Bz1NXDVNIUarRls7mk8wzdCnmycm1gGtVaJ2uk6cwb
        Kz8FhITVtft5VRCYMoWQKMruOXd58JgnAR2YUilZLAjakM8DRyAyNy6Lo5IOXVrECv0JST
        Na1Bqk58kI8LxLGnI5AiMylOwTo1UbM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-575-y0K1BKXrOw2rNoK8QOilGQ-1; Fri, 23 Sep 2022 12:19:11 -0400
X-MC-Unique: y0K1BKXrOw2rNoK8QOilGQ-1
Received: by mail-wm1-f72.google.com with SMTP id p24-20020a05600c1d9800b003b4b226903dso2936858wms.4
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=BzaafTuUqewrWXj7vYgZEtgaCTa2dI4dC0ftOasCvDA=;
        b=XENyyBm0cPSiq0jIiXJCuLcSyZc/w8Xa7hnbBPPfgsvr6oaQrq0NBAxlrWEhT2b8ml
         VGy67jcQWnmyq4OJre02/0/YlGoY84XsIWIxV5m3RbbY3LJJhZPmsvjSDLAId5dB53g2
         wFo8ozr7RW5VD2R00/JFB8ONZEVmBvIEIDiLND5Cb4NwicACqT32vTqB5K38bzZrJayl
         EGfhinHUgttvoGlv25kcke8dBsy4tH+imp/C2PO1bUTH00sLbjFXtI7lnz63pypr92Ay
         rwY/LgB+QMZXM+ONFgV0HzHzhI0yqN+6gUZHrflSaQm3+MnZenVtqGflqPl9/Uh63AFp
         wPJg==
X-Gm-Message-State: ACrzQf1GgdWBYVgu5vMlutof78CFVKPbwNauWnhKOYSVsZAjgCMa09sV
        HMBSjNGY+sHRGf05BRJYV/UAsiRbeE/Lyq30hmvTY3NmzQ413PpL4CQKX6GNHLkQrCwRwg/9eKT
        7J/6rnstIswvbKJ+H
X-Received: by 2002:a05:6000:81e:b0:228:a17f:92f0 with SMTP id bt30-20020a056000081e00b00228a17f92f0mr5919058wrb.31.1663949949897;
        Fri, 23 Sep 2022 09:19:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7zTp6XQYzwHwuvZOD9Q4KahxduuvQpI4aeMFaDOy0IGBvyjIHQ+4Os/t8UFnzflNTqlAjoLw==
X-Received: by 2002:a05:6000:81e:b0:228:a17f:92f0 with SMTP id bt30-20020a056000081e00b00228a17f92f0mr5919041wrb.31.1663949949548;
        Fri, 23 Sep 2022 09:19:09 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-76.dyn.eolo.it. [146.241.104.76])
        by smtp.gmail.com with ESMTPSA id o3-20020a05600c4fc300b003a5ca627333sm2966723wmq.8.2022.09.23.09.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:19:08 -0700 (PDT)
Message-ID: <6633c62c7a59f887eb15d3309c9cc408a74fb46f.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net: skb: introduce and use a single page
 frag cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 23 Sep 2022 18:19:07 +0200
In-Reply-To: <CAKgT0Ud+U4NO+adYeUdegVbbS2EMaqTg2B-a0Z8Q2n9H7MaePg@mail.gmail.com>
References: <162fe40c387cd395d633729fa4f2b5245531514a.1663879752.git.pabeni@redhat.com>
         <CAKgT0Uc2qmKTeZMCTR3ZkibioxEwKHjKqLrnz-=cfSt+5TAv=g@mail.gmail.com>
         <efa64c44b1e53510f972954e4670b2d8ecde97eb.camel@redhat.com>
         <CAKgT0Ud+U4NO+adYeUdegVbbS2EMaqTg2B-a0Z8Q2n9H7MaePg@mail.gmail.com>
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

On Fri, 2022-09-23 at 08:22 -0700, Alexander Duyck wrote:
> On Fri, Sep 23, 2022 at 12:41 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > Hello,
> > 
> > On Thu, 2022-09-22 at 14:17 -0700, Alexander Duyck wrote:
> > [...]
> > > My suggestion earlier was to just make the 1k cache a page_frag_cache.
> > > It will allow you to reuse the same structure members and a single
> > > pointer to track them. Waste would be minimal since the only real
> > > difference between the structures is about 8B for the structure, and
> > > odds are the napi_alloc_cache allocation is being rounded up anyway.
> > > 
> > > >         unsigned int skb_count;
> > > >         void *skb_cache[NAPI_SKB_CACHE_SIZE];
> > > >  };
> > > > @@ -143,6 +202,23 @@ struct napi_alloc_cache {
> > > >  static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
> > > >  static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
> > > > 
> > > > +/* Double check that napi_get_frags() allocates skbs with
> > > > + * skb->head being backed by slab, not a page fragment.
> > > > + * This is to make sure bug fixed in 3226b158e67c
> > > > + * ("net: avoid 32 x truesize under-estimation for tiny skbs")
> > > > + * does not accidentally come back.
> > > > + */
> > > > +void napi_get_frags_check(struct napi_struct *napi)
> > > > +{
> > > > +       struct sk_buff *skb;
> > > > +
> > > > +       local_bh_disable();
> > > > +       skb = napi_get_frags(napi);
> > > > +       WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
> > > > +       napi_free_frags(napi);
> > > > +       local_bh_enable();
> > > > +}
> > > > +
> > > >  void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
> > > >  {
> > > >         struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
> > > > @@ -561,6 +637,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > > >  {
> > > >         struct napi_alloc_cache *nc;
> > > >         struct sk_buff *skb;
> > > > +       bool pfmemalloc;
> > > 
> > > Rather than adding this I think you would be better off adding a
> > > struct page_frag_cache pointer. I will reference it here as "pfc".
> > > 
> > > >         void *data;
> > > > 
> > > >         DEBUG_NET_WARN_ON_ONCE(!in_softirq());
> > > > @@ -568,8 +645,10 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > > > 
> > > >         /* If requested length is either too small or too big,
> > > >          * we use kmalloc() for skb->head allocation.
> > > > +        * When the small frag allocator is available, prefer it over kmalloc
> > > > +        * for small fragments
> > > >          */
> > > > -       if (len <= SKB_WITH_OVERHEAD(1024) ||
> > > > +       if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
> > > >             len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> > > >             (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > > >                 skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
> > > > @@ -580,13 +659,30 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > > >         }
> > > > 
> > > >         nc = this_cpu_ptr(&napi_alloc_cache);
> > > > -       len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > > -       len = SKB_DATA_ALIGN(len);
> > > > 
> > > >         if (sk_memalloc_socks())
> > > >                 gfp_mask |= __GFP_MEMALLOC;
> > > > 
> > > > -       data = page_frag_alloc(&nc->page, len, gfp_mask);
> > > > +       if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
> > > 
> > > Then here you would add a line that would be:
> > > pfc = &nc->page_small;
> > > 
> > > > +               /* we are artificially inflating the allocation size, but
> > > > +                * that is not as bad as it may look like, as:
> > > > +                * - 'len' less then GRO_MAX_HEAD makes little sense
> > > > +                * - larger 'len' values lead to fragment size above 512 bytes
> > > > +                *   as per NAPI_HAS_SMALL_PAGE_FRAG definition
> > > > +                * - kmalloc would use the kmalloc-1k slab for such values
> > > > +                */
> > > > +               len = SZ_1K;
> > > > +
> > > > +               data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
> > > > +               pfmemalloc = nc->page_small.pfmemalloc;
> > > 
> > > Instead of setting pfmemalloc you could just update the line below. In
> > > addition you would just be passing pfc as the parameter.
> > > 
> > > > +       } else {
> > > 
> > > Likewise here you would have the line:
> > > pfc = &nc->page;
> > 
> > Probaly I was not clear in my previois email, sorry: before posting
> > this version I tried locally exactly all the above, and the generated
> > code with gcc 11.3.1 is a little bigger (a couple of instructions) than
> > what this version produces (with gcc 11.3.1-2). It has the same number
> > of conditionals and a slightly larger napi_alloc_cache.
> > 
> > Additionally the suggested alternative needs more pre-processor
> > conditionals to handle the !NAPI_HAS_SMALL_PAGE_FRAG case - avoiding
> > adding a 2nd, unused in that case, page_frag_cache.
> > 
> > [...]
> 
> Why would that be? You should still be using the pointer to the
> page_frag_cache in the standard case. Like I was saying what you are
> doing is essentially replacing the use of napi_alloc_cache with the
> page_frag_cache, so for example with the existing setup all references
> to "nc->page" would become "pfc->" so there shouldn't be any extra
> unused variables in such a case since it would be used for both the
> frag allocation and the pfmemalloc check.

The problem is that regardless of the NAPI_HAS_SMALL_PAGE_FRAG value,
under the branch:
	
	if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {

gcc sees nc->page_small so we need page_small to exists and be 0 bytes
wide for !NAPI_HAS_SMALL_PAGE_FRAG.

> One alternate way that occured to me to handle this would be to look
> at possibly having napi_alloc_cache contain an array of
> page_frag_cache structures. With that approach you could just size the
> array and have it stick with a size of 1 in the case that small
> doesn't exist, and support a size of 2 if it does. You could define
> them via an enum so that the max would vary depending on if you add a
> small frag cache or not. With that you could just bump the pointer
> with a ++ so it goes from large to small and you wouldn't have any
> warnings about items not existing in your structures, and the code
> with the ++ could be kept from being called in the
> !NAPI_HAS_SMALL_PAGE_FRAG case.

Yes, the above works nicely from a 'no additional preprocessor
conditional perspective', and the generate code for __napi_alloc_skb()
is 3 bytes shorted then my variant - which boils down to nothing due to
alignment - but the most critical path (small allocations) requires
more instructions and the diff is IMHO less readable, touching all the
other nc->page users.

Allocations >1K should be a less relevant code path, as e.g. there is
still a ~ 32x truesize underestimation there...

> > > > @@ -596,7 +692,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
> > > >                 return NULL;
> > > >         }
> > > > 
> > > > -       if (nc->page.pfmemalloc)
> > > > +       if (pfmemalloc)
> > > 
> > > Instead of passing pfmemalloc you could just check pfc->pfmemalloc.
> > > Alternatively I wonder if it wouldn't be faster to just set the value
> > > directly based on frag_cache->pfmemalloc and avoid the conditional
> > > heck entirely.
> > 
> > Note that:
> > 
> >         skb->pfmemalloc = pfmemalloc;
> > 
> > avoids a branch but requires more instructions than the current code
> > (verified with gcc). The gain looks doubtful?!? Additionally we have
> > statement alike:
> > 
> >         if (<pfmemalloc>)
> >                 skb->pfmemalloc = 1;
> > 
> > in other functions in skbuff.c - still fast-path - and would be better
> > updating all the places together for consistency - if that is really
> > considered an improvement. IMHO it should at least land in a different
> > patch.
> 
> We cannot really use "skb->pfmemalloc = pfmemalloc" because one is a
> bitfield and the other is a boolean value. I suspect the complexity
> would be greatly reduced if we converted the pfmemalloc to a bitfield
> similar to skb->pfmemalloc. It isn't important though. I was mostly
> just speculating on possible future optimizations.
> 
> > I'll post a v3 with your updated email address, but I think the current
> > code is the better option.
> 
> That's fine. Like I mentioned I am mostly just trying to think things
> out and identify any possible gaps we may have missed. I will keep an
> eye out for the next version.

Yep, let me go aheat with this...

Thanks,

Paolo

