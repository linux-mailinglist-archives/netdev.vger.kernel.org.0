Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF0B679840
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbjAXMnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjAXMnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:43:15 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD2918D;
        Tue, 24 Jan 2023 04:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=227WHg8XMGQOt5KWOZSFB1DzK0nKdtSPwCgG4ajgWvs=; b=Nvz7q52sqs+Bbdxp8QJF6I0a8M
        Hhs2Tq9vGJ49O1cZGfviIlb97ywW92QOBWOHADpjuyVF0KVnbMfJTZeW5I+UZrYv5IaHHQ2T0pwO3
        LNj0inHaTg7UyDqGnYjq3iGJz2SJ8LP9yPrmrbq6GKToCPtfi6Dv/s0oEZlmrq7QjVgc=;
Received: from p4ff1378e.dip0.t-ipconnect.de ([79.241.55.142] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pKIdk-00218F-4b; Tue, 24 Jan 2023 13:43:04 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] net: page_pool: fix refcounting issues with fragmented allocation
Date:   Tue, 24 Jan 2023 13:43:00 +0100
Message-Id: <20230124124300.94886-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing fragmented page_pool allocation in the mt76 driver, I was able
to reliably trigger page refcount underflow issues, which did not occur with
full-page page_pool allocation.
It appears to me, that handling refcounting in two separate counters
(page->pp_frag_count and page refcount) is racy when page refcount gets
incremented by code dealing with skb fragments directly, and
page_pool_return_skb_page is called multiple times for the same fragment.

Dropping page->pp_frag_count and relying entirely on the page refcount makes
these underflow issues and crashes go away.

Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/mm_types.h | 17 +++++------------
 include/net/page_pool.h  | 19 ++++---------------
 net/core/page_pool.c     | 12 ++++--------
 3 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 9757067c3053..96ec3b19a86d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -125,18 +125,11 @@ struct page {
 			struct page_pool *pp;
 			unsigned long _pp_mapping_pad;
 			unsigned long dma_addr;
-			union {
-				/**
-				 * dma_addr_upper: might require a 64-bit
-				 * value on 32-bit architectures.
-				 */
-				unsigned long dma_addr_upper;
-				/**
-				 * For frag page support, not supported in
-				 * 32-bit architectures with 64-bit DMA.
-				 */
-				atomic_long_t pp_frag_count;
-			};
+			/**
+			 * dma_addr_upper: might require a 64-bit
+			 * value on 32-bit architectures.
+			 */
+			unsigned long dma_addr_upper;
 		};
 		struct {	/* Tail pages of compound page */
 			unsigned long compound_head;	/* Bit zero is set */
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 813c93499f20..28e1fdbdcd53 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -279,14 +279,14 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
 
 static inline void page_pool_fragment_page(struct page *page, long nr)
 {
-	atomic_long_set(&page->pp_frag_count, nr);
+	page_ref_add(page, nr);
 }
 
 static inline long page_pool_defrag_page(struct page *page, long nr)
 {
 	long ret;
 
-	/* If nr == pp_frag_count then we have cleared all remaining
+	/* If nr == page_ref_count then we have cleared all remaining
 	 * references to the page. No need to actually overwrite it, instead
 	 * we can leave this to be overwritten by the calling function.
 	 *
@@ -295,22 +295,14 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
 	 * especially when dealing with a page that may be partitioned
 	 * into only 2 or 3 pieces.
 	 */
-	if (atomic_long_read(&page->pp_frag_count) == nr)
+	if (page_ref_count(page) == nr)
 		return 0;
 
-	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
+	ret = page_ref_sub_return(page, nr);
 	WARN_ON(ret < 0);
 	return ret;
 }
 
-static inline bool page_pool_is_last_frag(struct page_pool *pool,
-					  struct page *page)
-{
-	/* If fragments aren't enabled or count is 0 we were the last user */
-	return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
-	       (page_pool_defrag_page(page, 1) == 0);
-}
-
 static inline void page_pool_put_page(struct page_pool *pool,
 				      struct page *page,
 				      unsigned int dma_sync_size,
@@ -320,9 +312,6 @@ static inline void page_pool_put_page(struct page_pool *pool,
 	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
 	 */
 #ifdef CONFIG_PAGE_POOL
-	if (!page_pool_is_last_frag(pool, page))
-		return;
-
 	page_pool_put_defragged_page(pool, page, dma_sync_size, allow_direct);
 #endif
 }
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b203d8660e4..0defcadae225 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -25,7 +25,7 @@
 #define DEFER_TIME (msecs_to_jiffies(1000))
 #define DEFER_WARN_INTERVAL (60 * HZ)
 
-#define BIAS_MAX	LONG_MAX
+#define BIAS_MAX(pool)	(PAGE_SIZE << ((pool)->p.order))
 
 #ifdef CONFIG_PAGE_POOL_STATS
 /* alloc_stat_inc is intended to be used in softirq context */
@@ -619,10 +619,6 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 	for (i = 0; i < count; i++) {
 		struct page *page = virt_to_head_page(data[i]);
 
-		/* It is not the last user for the page frag case */
-		if (!page_pool_is_last_frag(pool, page))
-			continue;
-
 		page = __page_pool_put_page(pool, page, -1, false);
 		/* Approved for bulk recycling in ptr_ring cache */
 		if (page)
@@ -659,7 +655,7 @@ EXPORT_SYMBOL(page_pool_put_page_bulk);
 static struct page *page_pool_drain_frag(struct page_pool *pool,
 					 struct page *page)
 {
-	long drain_count = BIAS_MAX - pool->frag_users;
+	long drain_count = BIAS_MAX(pool) - pool->frag_users;
 
 	/* Some user is still using the page frag */
 	if (likely(page_pool_defrag_page(page, drain_count)))
@@ -678,7 +674,7 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
 
 static void page_pool_free_frag(struct page_pool *pool)
 {
-	long drain_count = BIAS_MAX - pool->frag_users;
+	long drain_count = BIAS_MAX(pool) - pool->frag_users;
 	struct page *page = pool->frag_page;
 
 	pool->frag_page = NULL;
@@ -724,7 +720,7 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
 		pool->frag_users = 1;
 		*offset = 0;
 		pool->frag_offset = size;
-		page_pool_fragment_page(page, BIAS_MAX);
+		page_pool_fragment_page(page, BIAS_MAX(pool));
 		return page;
 	}
 
-- 
2.39.0

