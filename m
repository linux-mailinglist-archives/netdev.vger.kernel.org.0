Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC095ED81D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbiI1IrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiI1Iqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:46:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C641BDCEAE
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664354599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MLwUlcPZRGtXFBlprZzz9zfSeI7N1lCG39cPadvLUFw=;
        b=Nj1BolTfgQVII/rEAuTYqkvdy651A+4PXLU/JwPobMAmdoMSboqAZFrM9pBSu+XINTliRY
        GAzDmyYA/Oj18vQgjbtXGRrXrD24E7KumuW2X/oPbnYzenyjq+9fKjyZZBJV6txJhz44W1
        SfRKZgMAWHLTMzemYI7LKST16RjNMJY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-77-bQfUbVDLMGO0vgzT-F-wVg-1; Wed, 28 Sep 2022 04:43:14 -0400
X-MC-Unique: bQfUbVDLMGO0vgzT-F-wVg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE4E329AB402;
        Wed, 28 Sep 2022 08:43:13 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC405111E3EC;
        Wed, 28 Sep 2022 08:43:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander H Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v4] net: skb: introduce and use a single page frag cache
Date:   Wed, 28 Sep 2022 10:43:09 +0200
Message-Id: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 3226b158e67c ("net: avoid 32 x truesize under-estimation
for tiny skbs") we are observing 10-20% regressions in performance
tests with small packets. The perf trace points to high pressure on
the slab allocator.

This change tries to improve the allocation schema for small packets
using an idea originally suggested by Eric: a new per CPU page frag is
introduced and used in __napi_alloc_skb to cope with small allocation
requests.

To ensure that the above does not lead to excessive truesize
underestimation, the frag size for small allocation is inflated to 1K
and all the above is restricted to build with 4K page size.

Note that we need to update accordingly the run-time check introduced
with commit fd9ea57f4e95 ("net: add napi_get_frags_check() helper").

Alex suggested a smart page refcount schema to reduce the number
of atomic operations and deal properly with pfmemalloc pages.

Under small packet UDP flood, I measure a 15% peak tput increases.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Suggested-by: Alexander H Duyck <alexanderduyck@fb.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v3 -> v4:
 - NAPI_HAS_SMALL_PAGE <-> 4K page (Eric)
 - fixed typos in comments (Eric)

v2 -> v3:
 - updated Alex email address
 - fixed build with !NAPI_HAS_SMALL_PAGE_FRAG

v1 -> v2:
 - better page_frag_alloc_1k() (Alex & Eric)
 - avoid duplicate code and gfp_flags misuse in __napi_alloc_skb() (Alex)
---
 include/linux/netdevice.h |   1 +
 net/core/dev.c            |  17 ------
 net/core/skbuff.c         | 108 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 104 insertions(+), 22 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9f42fc871c3b..a1938560192a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3822,6 +3822,7 @@ void netif_receive_skb_list(struct list_head *head);
 gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb);
 void napi_gro_flush(struct napi_struct *napi, bool flush_old);
 struct sk_buff *napi_get_frags(struct napi_struct *napi);
+void napi_get_frags_check(struct napi_struct *napi);
 gro_result_t napi_gro_frags(struct napi_struct *napi);
 struct packet_offload *gro_find_receive_by_type(__be16 type);
 struct packet_offload *gro_find_complete_by_type(__be16 type);
diff --git a/net/core/dev.c b/net/core/dev.c
index d66c73c1c734..fa53830d0683 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6358,23 +6358,6 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
-/* Double check that napi_get_frags() allocates skbs with
- * skb->head being backed by slab, not a page fragment.
- * This is to make sure bug fixed in 3226b158e67c
- * ("net: avoid 32 x truesize under-estimation for tiny skbs")
- * does not accidentally come back.
- */
-static void napi_get_frags_check(struct napi_struct *napi)
-{
-	struct sk_buff *skb;
-
-	local_bh_disable();
-	skb = napi_get_frags(napi);
-	WARN_ON_ONCE(skb && skb->head_frag);
-	napi_free_frags(napi);
-	local_bh_enable();
-}
-
 void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 			   int (*poll)(struct napi_struct *, int), int weight)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f1b8b20fc20b..81d63f95e865 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -134,8 +134,66 @@ static void skb_under_panic(struct sk_buff *skb, unsigned int sz, void *addr)
 #define NAPI_SKB_CACHE_BULK	16
 #define NAPI_SKB_CACHE_HALF	(NAPI_SKB_CACHE_SIZE / 2)
 
+#if PAGE_SIZE == SZ_4K
+
+#define NAPI_HAS_SMALL_PAGE_FRAG	1
+#define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	((nc).pfmemalloc)
+
+/* specialized page frag allocator using a single order 0 page
+ * and slicing it into 1K sized fragment. Constrained to systems
+ * with a very limited amount of 1K fragments fitting a single
+ * page - to avoid excessive truesize underestimation
+ */
+
+struct page_frag_1k {
+	void *va;
+	u16 offset;
+	bool pfmemalloc;
+};
+
+static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp)
+{
+	struct page *page;
+	int offset;
+
+	offset = nc->offset - SZ_1K;
+	if (likely(offset >= 0))
+		goto use_frag;
+
+	page = alloc_pages_node(NUMA_NO_NODE, gfp, 0);
+	if (!page)
+		return NULL;
+
+	nc->va = page_address(page);
+	nc->pfmemalloc = page_is_pfmemalloc(page);
+	offset = PAGE_SIZE - SZ_1K;
+	page_ref_add(page, offset / SZ_1K);
+
+use_frag:
+	nc->offset = offset;
+	return nc->va + offset;
+}
+#else
+
+/* the small page is actually unused in this build; add dummy helpers
+ * to please the compiler and avoid later preprocessor's conditionals
+ */
+#define NAPI_HAS_SMALL_PAGE_FRAG	0
+#define NAPI_SMALL_PAGE_PFMEMALLOC(nc)	false
+
+struct page_frag_1k {
+};
+
+static void *page_frag_alloc_1k(struct page_frag_1k *nc, gfp_t gfp_mask)
+{
+	return NULL;
+}
+
+#endif
+
 struct napi_alloc_cache {
 	struct page_frag_cache page;
+	struct page_frag_1k page_small;
 	unsigned int skb_count;
 	void *skb_cache[NAPI_SKB_CACHE_SIZE];
 };
@@ -143,6 +201,23 @@ struct napi_alloc_cache {
 static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
 static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
 
+/* Double check that napi_get_frags() allocates skbs with
+ * skb->head being backed by slab, not a page fragment.
+ * This is to make sure bug fixed in 3226b158e67c
+ * ("net: avoid 32 x truesize under-estimation for tiny skbs")
+ * does not accidentally come back.
+ */
+void napi_get_frags_check(struct napi_struct *napi)
+{
+	struct sk_buff *skb;
+
+	local_bh_disable();
+	skb = napi_get_frags(napi);
+	WARN_ON_ONCE(!NAPI_HAS_SMALL_PAGE_FRAG && skb && skb->head_frag);
+	napi_free_frags(napi);
+	local_bh_enable();
+}
+
 void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 {
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
@@ -561,6 +636,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 {
 	struct napi_alloc_cache *nc;
 	struct sk_buff *skb;
+	bool pfmemalloc;
 	void *data;
 
 	DEBUG_NET_WARN_ON_ONCE(!in_softirq());
@@ -568,8 +644,10 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 
 	/* If requested length is either too small or too big,
 	 * we use kmalloc() for skb->head allocation.
+	 * When the small frag allocator is available, prefer it over kmalloc
+	 * for small fragments
 	 */
-	if (len <= SKB_WITH_OVERHEAD(1024) ||
+	if ((!NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) ||
 	    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 	    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
 		skb = __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
@@ -580,13 +658,33 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 	}
 
 	nc = this_cpu_ptr(&napi_alloc_cache);
-	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	len = SKB_DATA_ALIGN(len);
 
 	if (sk_memalloc_socks())
 		gfp_mask |= __GFP_MEMALLOC;
 
-	data = page_frag_alloc(&nc->page, len, gfp_mask);
+	if (NAPI_HAS_SMALL_PAGE_FRAG && len <= SKB_WITH_OVERHEAD(1024)) {
+		/* we are artificially inflating the allocation size, but
+		 * that is not as bad as it may look like, as:
+		 * - 'len' less than GRO_MAX_HEAD makes little sense
+		 * - On most systems, larger 'len' values lead to fragment
+		 *   size above 512 bytes
+		 * - kmalloc would use the kmalloc-1k slab for such values
+		 * - Builds with smaller GRO_MAX_HEAD will very likely do
+		 *   little networking, as that implies no WiFi and no
+		 *   tunnels support, and 32 bits arches.
+		 */
+		len = SZ_1K;
+
+		data = page_frag_alloc_1k(&nc->page_small, gfp_mask);
+		pfmemalloc = NAPI_SMALL_PAGE_PFMEMALLOC(nc->page_small);
+	} else {
+		len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+		len = SKB_DATA_ALIGN(len);
+
+		data = page_frag_alloc(&nc->page, len, gfp_mask);
+		pfmemalloc = nc->page.pfmemalloc;
+	}
+
 	if (unlikely(!data))
 		return NULL;
 
@@ -596,7 +694,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsigned int len,
 		return NULL;
 	}
 
-	if (nc->page.pfmemalloc)
+	if (pfmemalloc)
 		skb->pfmemalloc = 1;
 	skb->head_frag = 1;
 
-- 
2.37.3

