Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFE4690033
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 07:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBIGGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 01:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjBIGGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 01:06:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CEE55AD;
        Wed,  8 Feb 2023 22:06:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C17EB81FCF;
        Thu,  9 Feb 2023 06:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82C5C433EF;
        Thu,  9 Feb 2023 06:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675922805;
        bh=F4Dini/3haDAbJX9+qU9F/d91A/VtBRaWh0rj4yOi2g=;
        h=From:To:Cc:Subject:Date:From;
        b=IwKXRqxQN1zEYly4MlLknqtKCZ/u5TD1K9JUngVcfxFa0TnDYNOjhNt++ZA1+e5MV
         Yo1BvrfPf6cjM8cOkDIJCTy2BvePUZHCzQr9ye3mzsToo58pkuujs5ld6UJtr1kjL+
         nOLjceycPltc4GaWl0tdTzfjZU16aPe+85Ri5fPOnVcXN/yry/qrjgb54zuVs5voam
         Nf7tCOA5Vtss6QO59VHZpUJTwJ6noboga/c3BERYjw9j12T27HX7NePOdEmWs7dlF2
         iyNQDBo6j+v1sSx3pUEUkRpA6E/+80DNlCDbSdz3Hxct/IvcgrTVGMidNenYqGx6nW
         FUrfu3TX9/8Vg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: skbuff: drop the word head from skb cache
Date:   Wed,  8 Feb 2023 22:06:42 -0800
Message-Id: <20230209060642.115752-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skbuff_head_cache is misnamed (perhaps for historical reasons?)
because it does not hold heads. Head is the buffer which skb->data
points to, and also where shinfo lives. struct sk_buff is a metadata
structure, not the head.

Eric recently added skb_small_head_cache (which allocates actual
head buffers), let that serve as an excuse to finally clean this up :)

Leave the user-space visible name intact, it could possibly be uAPI.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h |  2 +-
 kernel/bpf/cpumap.c    |  2 +-
 net/bpf/test_run.c     |  2 +-
 net/core/skbuff.c      | 31 +++++++++++++++----------------
 net/core/xdp.c         |  5 ++---
 5 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c3df3b55da97..47ab28a37f2f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1243,7 +1243,7 @@ static inline void consume_skb(struct sk_buff *skb)
 
 void __consume_stateless_skb(struct sk_buff *skb);
 void  __kfree_skb(struct sk_buff *skb);
-extern struct kmem_cache *skbuff_head_cache;
+extern struct kmem_cache *skbuff_cache;
 
 void kfree_skb_partial(struct sk_buff *skb, bool head_stolen);
 bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index e0b2d016f0bf..d2110c1f6fa6 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -361,7 +361,7 @@ static int cpu_map_kthread_run(void *data)
 		/* Support running another XDP prog on this CPU */
 		nframes = cpu_map_bpf_prog_run(rcpu, frames, xdp_n, &stats, &list);
 		if (nframes) {
-			m = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, skbs);
+			m = kmem_cache_alloc_bulk(skbuff_cache, gfp, nframes, skbs);
 			if (unlikely(m == 0)) {
 				for (i = 0; i < nframes; i++)
 					skbs[i] = NULL; /* effect: xdp_return_frame */
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 8da0d73b368e..2b954326894f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -234,7 +234,7 @@ static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
 	int i, n;
 	LIST_HEAD(list);
 
-	n = kmem_cache_alloc_bulk(skbuff_head_cache, gfp, nframes, (void **)skbs);
+	n = kmem_cache_alloc_bulk(skbuff_cache, gfp, nframes, (void **)skbs);
 	if (unlikely(n == 0)) {
 		for (i = 0; i < nframes; i++)
 			xdp_return_frame(frames[i]);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bdb1e015e32b..23779b68f7d2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -84,7 +84,7 @@
 #include "dev.h"
 #include "sock_destructor.h"
 
-struct kmem_cache *skbuff_head_cache __ro_after_init;
+struct kmem_cache *skbuff_cache __ro_after_init;
 static struct kmem_cache *skbuff_fclone_cache __ro_after_init;
 #ifdef CONFIG_SKB_EXTENSIONS
 static struct kmem_cache *skbuff_ext_cache __ro_after_init;
@@ -285,7 +285,7 @@ static struct sk_buff *napi_skb_cache_get(void)
 	struct sk_buff *skb;
 
 	if (unlikely(!nc->skb_count)) {
-		nc->skb_count = kmem_cache_alloc_bulk(skbuff_head_cache,
+		nc->skb_count = kmem_cache_alloc_bulk(skbuff_cache,
 						      GFP_ATOMIC,
 						      NAPI_SKB_CACHE_BULK,
 						      nc->skb_cache);
@@ -294,7 +294,7 @@ static struct sk_buff *napi_skb_cache_get(void)
 	}
 
 	skb = nc->skb_cache[--nc->skb_count];
-	kasan_unpoison_object_data(skbuff_head_cache, skb);
+	kasan_unpoison_object_data(skbuff_cache, skb);
 
 	return skb;
 }
@@ -352,7 +352,7 @@ struct sk_buff *slab_build_skb(void *data)
 	struct sk_buff *skb;
 	unsigned int size;
 
-	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+	skb = kmem_cache_alloc(skbuff_cache, GFP_ATOMIC);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -403,7 +403,7 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
 {
 	struct sk_buff *skb;
 
-	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+	skb = kmem_cache_alloc(skbuff_cache, GFP_ATOMIC);
 	if (unlikely(!skb))
 		return NULL;
 
@@ -585,7 +585,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	u8 *data;
 
 	cache = (flags & SKB_ALLOC_FCLONE)
-		? skbuff_fclone_cache : skbuff_head_cache;
+		? skbuff_fclone_cache : skbuff_cache;
 
 	if (sk_memalloc_socks() && (flags & SKB_ALLOC_RX))
 		gfp_mask |= __GFP_MEMALLOC;
@@ -921,7 +921,7 @@ static void kfree_skbmem(struct sk_buff *skb)
 
 	switch (skb->fclone) {
 	case SKB_FCLONE_UNAVAILABLE:
-		kmem_cache_free(skbuff_head_cache, skb);
+		kmem_cache_free(skbuff_cache, skb);
 		return;
 
 	case SKB_FCLONE_ORIG:
@@ -1035,7 +1035,7 @@ static void kfree_skb_add_bulk(struct sk_buff *skb,
 	sa->skb_array[sa->skb_count++] = skb;
 
 	if (unlikely(sa->skb_count == KFREE_SKB_BULK_SIZE)) {
-		kmem_cache_free_bulk(skbuff_head_cache, KFREE_SKB_BULK_SIZE,
+		kmem_cache_free_bulk(skbuff_cache, KFREE_SKB_BULK_SIZE,
 				     sa->skb_array);
 		sa->skb_count = 0;
 	}
@@ -1060,8 +1060,7 @@ kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
 	}
 
 	if (sa.skb_count)
-		kmem_cache_free_bulk(skbuff_head_cache, sa.skb_count,
-				     sa.skb_array);
+		kmem_cache_free_bulk(skbuff_cache, sa.skb_count, sa.skb_array);
 }
 EXPORT_SYMBOL(kfree_skb_list_reason);
 
@@ -1215,15 +1214,15 @@ static void napi_skb_cache_put(struct sk_buff *skb)
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 	u32 i;
 
-	kasan_poison_object_data(skbuff_head_cache, skb);
+	kasan_poison_object_data(skbuff_cache, skb);
 	nc->skb_cache[nc->skb_count++] = skb;
 
 	if (unlikely(nc->skb_count == NAPI_SKB_CACHE_SIZE)) {
 		for (i = NAPI_SKB_CACHE_HALF; i < NAPI_SKB_CACHE_SIZE; i++)
-			kasan_unpoison_object_data(skbuff_head_cache,
+			kasan_unpoison_object_data(skbuff_cache,
 						   nc->skb_cache[i]);
 
-		kmem_cache_free_bulk(skbuff_head_cache, NAPI_SKB_CACHE_HALF,
+		kmem_cache_free_bulk(skbuff_cache, NAPI_SKB_CACHE_HALF,
 				     nc->skb_cache + NAPI_SKB_CACHE_HALF);
 		nc->skb_count = NAPI_SKB_CACHE_HALF;
 	}
@@ -1807,7 +1806,7 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 		if (skb_pfmemalloc(skb))
 			gfp_mask |= __GFP_MEMALLOC;
 
-		n = kmem_cache_alloc(skbuff_head_cache, gfp_mask);
+		n = kmem_cache_alloc(skbuff_cache, gfp_mask);
 		if (!n)
 			return NULL;
 
@@ -4677,7 +4676,7 @@ static void skb_extensions_init(void) {}
 
 void __init skb_init(void)
 {
-	skbuff_head_cache = kmem_cache_create_usercopy("skbuff_head_cache",
+	skbuff_cache = kmem_cache_create_usercopy("skbuff_head_cache",
 					      sizeof(struct sk_buff),
 					      0,
 					      SLAB_HWCACHE_ALIGN|SLAB_PANIC,
@@ -5550,7 +5549,7 @@ void kfree_skb_partial(struct sk_buff *skb, bool head_stolen)
 {
 	if (head_stolen) {
 		skb_release_head_state(skb);
-		kmem_cache_free(skbuff_head_cache, skb);
+		kmem_cache_free(skbuff_cache, skb);
 	} else {
 		__kfree_skb(skb);
 	}
diff --git a/net/core/xdp.c b/net/core/xdp.c
index a5a7ecf6391c..03938fe6d33a 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -603,8 +603,7 @@ EXPORT_SYMBOL_GPL(xdp_warn);
 
 int xdp_alloc_skb_bulk(void **skbs, int n_skb, gfp_t gfp)
 {
-	n_skb = kmem_cache_alloc_bulk(skbuff_head_cache, gfp,
-				      n_skb, skbs);
+	n_skb = kmem_cache_alloc_bulk(skbuff_cache, gfp, n_skb, skbs);
 	if (unlikely(!n_skb))
 		return -ENOMEM;
 
@@ -673,7 +672,7 @@ struct sk_buff *xdp_build_skb_from_frame(struct xdp_frame *xdpf,
 {
 	struct sk_buff *skb;
 
-	skb = kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+	skb = kmem_cache_alloc(skbuff_cache, GFP_ATOMIC);
 	if (unlikely(!skb))
 		return NULL;
 
-- 
2.39.1

