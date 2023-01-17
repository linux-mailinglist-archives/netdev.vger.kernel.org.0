Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1061E66DF06
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 14:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjAQNkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 08:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjAQNkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 08:40:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21BD59C6
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 05:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673962807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=i9PEgqUHqyQJNAleeBEFgDDSWNqsnvJXCZKuturWNw8=;
        b=Gmw6kR5QW31UcxY0GZ9wUeknmfcnylhA+isPqSINEpeRpJUI3Ep1oyiUaRa0C8Dz3fU6BO
        oA3qa6ycGvNdUPgFhQHAqHfsS82GQeyLKSxnJZqpmhpUL9H2VCOt+jx+WEz4vqSyzJQFdx
        49plz5fo/HfmsHzVhDMYXH+qDjJzXos=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-JsaqHhlKMWmm04iTOFCIAg-1; Tue, 17 Jan 2023 08:40:03 -0500
X-MC-Unique: JsaqHhlKMWmm04iTOFCIAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BF52857F43;
        Tue, 17 Jan 2023 13:40:03 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9185740C2064;
        Tue, 17 Jan 2023 13:40:01 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 8BA3830721A6C;
        Tue, 17 Jan 2023 14:40:00 +0100 (CET)
Subject: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, linux-mm@kvack.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
        penberg@kernel.org, vbabka@suse.cz,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Tue, 17 Jan 2023 14:40:00 +0100
Message-ID: <167396280045.539803.7540459812377220500.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow API users of kmem_cache_create to specify that they don't want
any slab merge or aliasing (with similar sized objects). Use this in
network stack and kfence_test.

The SKB (sk_buff) kmem_cache slab is critical for network performance.
Network stack uses kmem_cache_{alloc,free}_bulk APIs to gain
performance by amortising the alloc/free cost.

For the bulk API to perform efficiently the slub fragmentation need to
be low. Especially for the SLUB allocator, the efficiency of bulk free
API depend on objects belonging to the same slab (page).

When running different network performance microbenchmarks, I started
to notice that performance was reduced (slightly) when machines had
longer uptimes. I believe the cause was 'skbuff_head_cache' got
aliased/merged into the general slub for 256 bytes sized objects (with
my kernel config, without CONFIG_HARDENED_USERCOPY).

For SKB kmem_cache network stack have reasons for not merging, but it
varies depending on kernel config (e.g. CONFIG_HARDENED_USERCOPY).
We want to explicitly set SLAB_NEVER_MERGE for this kmem_cache.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/slab.h    |    2 ++
 mm/kfence/kfence_test.c |    7 +++----
 mm/slab.h               |    5 +++--
 mm/slab_common.c        |    8 ++++----
 net/core/skbuff.c       |   13 ++++++++++++-
 5 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 45af70315a94..83a89ba7c4be 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -138,6 +138,8 @@
 #define SLAB_SKIP_KFENCE	0
 #endif
 
+#define SLAB_NEVER_MERGE	((slab_flags_t __force)0x40000000U)
+
 /* The following flags affect the page allocator grouping pages by mobility */
 /* Objects are reclaimable */
 #ifndef CONFIG_SLUB_TINY
diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index b5d66a69200d..9e83e344ee3c 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -191,11 +191,10 @@ static size_t setup_test_cache(struct kunit *test, size_t size, slab_flags_t fla
 	kunit_info(test, "%s: size=%zu, ctor=%ps\n", __func__, size, ctor);
 
 	/*
-	 * Use SLAB_NOLEAKTRACE to prevent merging with existing caches. Any
-	 * other flag in SLAB_NEVER_MERGE also works. Use SLAB_ACCOUNT to
-	 * allocate via memcg, if enabled.
+	 * Use SLAB_NEVER_MERGE to prevent merging with existing caches.
+	 * Use SLAB_ACCOUNT to allocate via memcg, if enabled.
 	 */
-	flags |= SLAB_NOLEAKTRACE | SLAB_ACCOUNT;
+	flags |= SLAB_NEVER_MERGE | SLAB_ACCOUNT;
 	test_cache = kmem_cache_create("test", size, 1, flags, ctor);
 	KUNIT_ASSERT_TRUE_MSG(test, test_cache, "could not create cache");
 
diff --git a/mm/slab.h b/mm/slab.h
index 7cc432969945..be1383176d3e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -341,11 +341,11 @@ static inline slab_flags_t kmem_cache_flags(unsigned int object_size,
 #if defined(CONFIG_SLAB)
 #define SLAB_CACHE_FLAGS (SLAB_MEM_SPREAD | SLAB_NOLEAKTRACE | \
 			  SLAB_RECLAIM_ACCOUNT | SLAB_TEMPORARY | \
-			  SLAB_ACCOUNT)
+			  SLAB_ACCOUNT | SLAB_NEVER_MERGE)
 #elif defined(CONFIG_SLUB)
 #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
 			  SLAB_TEMPORARY | SLAB_ACCOUNT | \
-			  SLAB_NO_USER_FLAGS | SLAB_KMALLOC)
+			  SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NEVER_MERGE)
 #else
 #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE)
 #endif
@@ -366,6 +366,7 @@ static inline slab_flags_t kmem_cache_flags(unsigned int object_size,
 			      SLAB_TEMPORARY | \
 			      SLAB_ACCOUNT | \
 			      SLAB_KMALLOC | \
+			      SLAB_NEVER_MERGE | \
 			      SLAB_NO_USER_FLAGS)
 
 bool __kmem_cache_empty(struct kmem_cache *);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 1cba98acc486..269f67c5fee6 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -45,9 +45,9 @@ static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
 /*
  * Set of flags that will prevent slab merging
  */
-#define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
+#define SLAB_NEVER_MERGE_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER |\
 		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB | kasan_never_merge())
+		SLAB_FAILSLAB | SLAB_NEVER_MERGE | kasan_never_merge())
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
@@ -137,7 +137,7 @@ static unsigned int calculate_alignment(slab_flags_t flags,
  */
 int slab_unmergeable(struct kmem_cache *s)
 {
-	if (slab_nomerge || (s->flags & SLAB_NEVER_MERGE))
+	if (slab_nomerge || (s->flags & SLAB_NEVER_MERGE_FLAGS))
 		return 1;
 
 	if (s->ctor)
@@ -173,7 +173,7 @@ struct kmem_cache *find_mergeable(unsigned int size, unsigned int align,
 	size = ALIGN(size, align);
 	flags = kmem_cache_flags(size, flags, name);
 
-	if (flags & SLAB_NEVER_MERGE)
+	if (flags & SLAB_NEVER_MERGE_FLAGS)
 		return NULL;
 
 	list_for_each_entry_reverse(s, &slab_caches, list) {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 79c9e795a964..799b9914457b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4629,12 +4629,23 @@ static void skb_extensions_init(void)
 static void skb_extensions_init(void) {}
 #endif
 
+/* The SKB kmem_cache slab is critical for network performance.  Never
+ * merge/alias the slab with similar sized objects.  This avoids fragmentation
+ * that hurts performance of kmem_cache_{alloc,free}_bulk APIs.
+ */
+#ifndef CONFIG_SLUB_TINY
+#define FLAG_SKB_NEVER_MERGE	SLAB_NEVER_MERGE
+#else /* CONFIG_SLUB_TINY - simple loop in kmem_cache_alloc_bulk */
+#define FLAG_SKB_NEVER_MERGE	0
+#endif
+
 void __init skb_init(void)
 {
 	skbuff_head_cache = kmem_cache_create_usercopy("skbuff_head_cache",
 					      sizeof(struct sk_buff),
 					      0,
-					      SLAB_HWCACHE_ALIGN|SLAB_PANIC,
+					      SLAB_HWCACHE_ALIGN|SLAB_PANIC|
+						FLAG_SKB_NEVER_MERGE,
 					      offsetof(struct sk_buff, cb),
 					      sizeof_field(struct sk_buff, cb),
 					      NULL);


