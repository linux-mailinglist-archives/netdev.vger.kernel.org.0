Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478CE5F23B5
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 16:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJBOzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 10:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJBOzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 10:55:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F787193E8
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 07:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664722518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2hFHk9SD66/7poJjkhG42rSbPp9nlWLfZRTYYNEqEZ0=;
        b=JRzLt55xLDVJzJe+4Pfgl7w0Ws1wnCMMhTAlzuabqxS+Kl3CgnK4LuB0Ajn+xvJ1OuOt9I
        /82LW54AlFRC/H3Q4B3tQt1FKdWmlq5ELnEuo2cX4SY+GD4TZJWEY/QqIhbNiQQ6yR9C3m
        o2dEf6aw1nYzumphqerZRVfYqTI44lY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-119-r-Frcy72Mfmx8ynnO_Vtzg-1; Sun, 02 Oct 2022 10:55:17 -0400
X-MC-Unique: r-Frcy72Mfmx8ynnO_Vtzg-1
Received: by mail-wr1-f71.google.com with SMTP id e11-20020adfa74b000000b0022e39e5c151so100341wrd.3
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 07:55:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=2hFHk9SD66/7poJjkhG42rSbPp9nlWLfZRTYYNEqEZ0=;
        b=Q5qWhAVdv7sXF2rRhEvtdHgHnQFn+FDsneHTskRnFKS7WSq2MgxQeZ4STGv9YQGDEu
         +Y4Y0sjuMPwU4dyYHACdfGD727OlWuLK22BjAJCcxFKd2W4xwIkAZLkuoZXdxKS4EV0p
         eiBpVVAHRbJ8F9U9eDYsxqbSSH8LhYUPKuV0kDUUVmmTi7kL/Z5g4KjdO8FReAab5tCZ
         30Nznhkck4p7gE1I6Uq7gDhklDfwwnqNi3i2PA7/Pa4cmaF7mRgJHOzBII/OLdL3Hdq8
         7Q2wBn08rGOuoPY8sCpmuSnFSnOn1/umj+dRGBkcz83VGR1CqZNoUcXYTYuk5fK95G9L
         tVRA==
X-Gm-Message-State: ACrzQf0uyjQpk1sB6I9gOrllnklHAsoJ/01E46sfvXXEnyly6uaFJkfk
        6np6JQBdx7WK5l1zeReFkMxCQwwG+2O3qZ8RLbLvkoInxm7DFxau8XY6vqI6uo6Plb9tHxHqx7j
        hsnMikh/Ve6zFgshR
X-Received: by 2002:adf:ed41:0:b0:225:3fde:46ea with SMTP id u1-20020adfed41000000b002253fde46eamr10647745wro.345.1664722516082;
        Sun, 02 Oct 2022 07:55:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6KjvJRbBEiP3Xaj9W/A3fZIdJhkxzrvKCfgdkogZKbMrQfkFr6k68W8E80RoIBmalJzvBDAg==
X-Received: by 2002:adf:ed41:0:b0:225:3fde:46ea with SMTP id u1-20020adfed41000000b002253fde46eamr10647734wro.345.1664722515785;
        Sun, 02 Oct 2022 07:55:15 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id l18-20020a1ced12000000b003b341a2cfadsm8688703wmh.17.2022.10.02.07.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 07:55:15 -0700 (PDT)
Message-ID: <06a1cdb330980e3df051c95ae089fd77afee839b.camel@redhat.com>
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page
 frag cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Date:   Sun, 02 Oct 2022 16:55:13 +0200
In-Reply-To: <CANn89i+SjRtpG9e3gJjh7sNELUYETSkOi86Qk_eC2sQOV39UGg@mail.gmail.com>
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
         <166450446690.30186.16482162810476880962.git-patchwork-notify@kernel.org>
         <CANn89iJ=_e9-P4dvRcMzJYqpTBQ5kevEvaYFH1JVvSdv4sguhA@mail.gmail.com>
         <cdbfe4615ffec2bcfde94268dbc77dfa98143f39.camel@redhat.com>
         <CANn89i+SjRtpG9e3gJjh7sNELUYETSkOi86Qk_eC2sQOV39UGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-30 at 10:45 -0700, Eric Dumazet wrote:
> On Fri, Sep 30, 2022 at 10:30 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Fri, 2022-09-30 at 09:43 -0700, Eric Dumazet wrote:
> > > Paolo, this patch adds a regression for TCP RPC workloads (aka TCP_RR)
> > > 
> > > Before the patch, cpus servicing NIC interrupts were allocating
> > > SLAB/SLUB objects for incoming packets,
> > > but they were also freeing skbs from TCP rtx queues when ACK packets
> > > were processed. SLAB/SLUB caches
> > > were efficient (hit ratio close to 100%)
> > 
> > Thank you for the report. Is that reproducible with netperf TCP_RR and
> > CONFIG_DEBUG_SLAB, I guess? Do I need specific request/response sizes?
> 
> No CONFIG_DEBUG_SLAB, simply standard SLAB, and tcp_rr tests on an AMD
> host with 256 cpus...

The most similar host I can easily grab is a 2 numa nodes AMD with 16
cores/32 threads each.

I tried tcp_rr with different number of flows in (1-2048) range with
both slub (I tried first that because is the default allocator in my
builds) and slab but so far I can't reproduce it: results differences
between pre-patch and post-patch kernel are within noise and numastat
never show misses.

I'm likely missing some incredient to the recipe. I'll try next to pin
the netperf/netserver processes on a numa node different from the NIC's
one and to increase the number of concurrent flows.

I'm also wondering, after commit 68822bdf76f10 ("net: generalize skb
freeing deferral to per-cpu lists") the CPUs servicing the NIC
interrupts both allocate and (defer) free the memory for the incoming
packets,  so they should not have to access remote caches ?!? Or at
least isn't the allocator behavior always asymmetric, with rx alloc, rx
free, tx free on the same core and tx alloc possibly on a different
one?

> 
> We could first try in tcp_stream_alloc_skb()

I'll try to test something alike the following - after reproducing the
issue.
---
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f15d5b62539b..d5e9be98e8bd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1308,6 +1308,30 @@ static inline struct sk_buff *alloc_skb_fclone(unsigned int size,
 	return __alloc_skb(size, priority, SKB_ALLOC_FCLONE, NUMA_NO_NODE);
 }
 
+#if PAGE_SIZE == SZ_4K
+
+#define NAPI_HAS_SMALL_PAGE_FRAG	1
+
+struct sk_buff *__alloc_skb_fclone_frag(unsigned int size, gfp_t priority);
+
+static inline struct sk_buff *alloc_skb_fclone_frag(unsigned int size, gfp_t priority)
+{
+	if (size <= SKB_WITH_OVERHEAD(1024))
+		return __alloc_skb_fclone_frag(size, priority);
+
+	return alloc_skb_fclone(size, priority);
+}
+
+#else
+#define NAPI_HAS_SMALL_PAGE_FRAG	0
+
+static inline struct sk_buff *alloc_skb_fclone_frag(unsigned int size, gfp_t priority)
+{
+	return alloc_skb_fclone(size, priority);
+}
+
+#endif
+
 struct sk_buff *skb_morph(struct sk_buff *dst, struct sk_buff *src);
 void skb_headers_offset_update(struct sk_buff *skb, int off);
 int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 81d63f95e865..0c63653c9951 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -134,9 +134,8 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
 #define NAPI_SKB_CACHE_BULK	16
 #define NAPI_SKB_CACHE_HALF	(NAPI_SKB_CACHE_SIZE / 2)
 
-#if PAGE_SIZE == SZ_4K
+#if NAPI_HAS_SMALL_PAGE_FRAG
 
-#define NAPI_HAS_SMALL_PAGE_FRAG	1
 #define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	((nc).pfmemalloc)
 
 /* specialized page frag allocator using a single order 0 page
@@ -173,12 +172,12 @@ static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
 	nc->offset = offset;
 	return nc->va + offset;
 }
+
 #else
 
 /* the small page is actually unused in this build; add dummy helpers
  * to please the compiler and avoid later preprocessor's conditionals
  */
-#define NAPI_HAS_SMALL_PAGE_FRAG	0
 #define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	false
 
 struct page_frag_1k {
@@ -543,6 +542,52 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 }
 EXPORT_SYMBOL(__alloc_skb);
 
+#if NAPI_HAS_SMALL_PAGE_FRAG
+/* optimized skb fast-clone allocation variant, using the small
+ * page frag cache
+ */
+struct sk_buff *__alloc_skb_fclone_frag(unsigned int size, gfp_t gfp_mask)
+{
+	struct sk_buff_fclones *fclones;
+	struct napi_alloc_cache *nc;
+	struct sk_buff *skb;
+	bool pfmemalloc;
+	void *data;
+
+	/* Get the HEAD */
+	skb = kmem_cache_alloc_node(skbuff_fclone_cache, gfp_mask & ~GFP_DMA, NUMA_NO_NODE);
+	if (unlikely(!skb))
+		return NULL;
+	prefetchw(skb);
+
+	/* We can access the napi cache only in BH context */
+	nc = this_cpu_ptr(&napi_alloc_cache);
+	local_bh_disable();
+	data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
+	pfmemalloc = nc->page_small.pfmemalloc;
+	local_bh_enable();
+	if (unlikely(!data))
+		goto nodata;
+
+	prefetchw(data + SKB_WITH_OVERHEAD(SZ_1K));
+
+	memset(skb, 0, offsetof(struct sk_buff, tail));
+	__build_skb_around(skb, data, SZ_1K);
+	skb->pfmemalloc = pfmemalloc;
+	skb->fclone = SKB_FCLONE_ORIG;
+	skb->head_frag = 1;
+
+	fclones = container_of(skb, struct sk_buff_fclones, skb1);
+	refcount_set(&fclones->fclone_ref, 1);
+
+	return skb;
+
+nodata:
+	kmem_cache_free(skbuff_fclone_cache, skb);
+	return NULL;
+}
+#endif
+
 /**
  *	__netdev_alloc_skb - allocate an skbuff for rx on a specific device
  *	@dev: network device to receive on
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 829beee3fa32..3bcc3e1d9b19 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -858,7 +858,7 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 {
 	struct sk_buff *skb;
 
-	skb = alloc_skb_fclone(size + MAX_TCP_HEADER, gfp);
+	skb = alloc_skb_fclone_frag(size + MAX_TCP_HEADER, gfp);
 	if (likely(skb)) {
 		bool mem_scheduled;
 

