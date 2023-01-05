Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCBF65F628
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbjAEVrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbjAEVrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:47:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FC3676D9
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=PdoQKhJ3LtOgA1Y51KMPKfFIcW0uZc7eBAEFhZ/WWAE=; b=DIPsPoas28aIXNv1jols4g81YO
        Z9VmoAsDNbFfHhpE8STvqmcx6Wnz2FY8d2Wab+eI2Zo8SSmNDh29Trf2wxQ273Q9OsGcW99diVYyh
        7z9pTa6dk4qHnP32YGwVSAn8D3WriPCTIVPIMHyAiB9ETD7/aGkpkj3zTUHfsk5xbY3du6kzYLa6m
        u8uHMPFKZknCmkCk1NL5UzqlueHRX005EzOgJDzfuMNipSLPvULIS6BA4QvRg0H9Xtkcc1cK9M3tp
        sGP3XahwIQJTLN069G8PTsS/scpstQ5oMNazYNhdNgGJZwh1YN9xe+ni/WP+Tk8alsjMtZIYhMpXu
        KJI/lEow==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDY4I-00GWnD-2C; Thu, 05 Jan 2023 21:46:34 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 10/24] page_pool: Convert page_pool_put_defragged_page() to netmem
Date:   Thu,  5 Jan 2023 21:46:17 +0000
Message-Id: <20230105214631.3939268-11-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230105214631.3939268-1-willy@infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also convert page_pool_is_last_frag(), page_pool_put_page(),
page_pool_recycle_in_ring() and use netmem in page_pool_put_page_bulk().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/net/page_pool.h | 23 ++++++++++++++++-------
 net/core/page_pool.c    | 29 +++++++++++++++--------------
 2 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 8fe494166427..8b826da3b8b0 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -384,7 +384,7 @@ static inline void page_pool_release_page(struct page_pool *pool,
 	page_pool_release_netmem(pool, page_netmem(page));
 }
 
-void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
+void page_pool_put_defragged_netmem(struct page_pool *pool, struct netmem *nmem,
 				  unsigned int dma_sync_size,
 				  bool allow_direct);
 
@@ -420,15 +420,15 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
 }
 
 static inline bool page_pool_is_last_frag(struct page_pool *pool,
-					  struct page *page)
+					  struct netmem *nmem)
 {
 	/* If fragments aren't enabled or count is 0 we were the last user */
 	return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
-	       (page_pool_defrag_page(page, 1) == 0);
+	       (page_pool_defrag_netmem(nmem, 1) == 0);
 }
 
-static inline void page_pool_put_page(struct page_pool *pool,
-				      struct page *page,
+static inline void page_pool_put_netmem(struct page_pool *pool,
+				      struct netmem *nmem,
 				      unsigned int dma_sync_size,
 				      bool allow_direct)
 {
@@ -436,13 +436,22 @@ static inline void page_pool_put_page(struct page_pool *pool,
 	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
 	 */
 #ifdef CONFIG_PAGE_POOL
-	if (!page_pool_is_last_frag(pool, page))
+	if (!page_pool_is_last_frag(pool, nmem))
 		return;
 
-	page_pool_put_defragged_page(pool, page, dma_sync_size, allow_direct);
+	page_pool_put_defragged_netmem(pool, nmem, dma_sync_size, allow_direct);
 #endif
 }
 
+static inline void page_pool_put_page(struct page_pool *pool,
+				      struct page *page,
+				      unsigned int dma_sync_size,
+				      bool allow_direct)
+{
+	page_pool_put_netmem(pool, page_netmem(page), dma_sync_size,
+				allow_direct);
+}
+
 /* Same as above but will try to sync the entire area pool->max_len */
 static inline void page_pool_put_full_page(struct page_pool *pool,
 					   struct page *page, bool allow_direct)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index c54217ce6b77..e727a74504c2 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -516,14 +516,15 @@ static void page_pool_return_netmem(struct page_pool *pool, struct netmem *nmem)
 	 */
 }
 
-static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
+static bool page_pool_recycle_in_ring(struct page_pool *pool,
+					struct netmem *nmem)
 {
 	int ret;
 	/* BH protection not needed if current is serving softirq */
 	if (in_serving_softirq())
-		ret = ptr_ring_produce(&pool->ring, page);
+		ret = ptr_ring_produce(&pool->ring, nmem);
 	else
-		ret = ptr_ring_produce_bh(&pool->ring, page);
+		ret = ptr_ring_produce_bh(&pool->ring, nmem);
 
 	if (!ret) {
 		recycle_stat_inc(pool, ring);
@@ -615,17 +616,17 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 						dma_sync_size, allow_direct));
 }
 
-void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
+void page_pool_put_defragged_netmem(struct page_pool *pool, struct netmem *nmem,
 				  unsigned int dma_sync_size, bool allow_direct)
 {
-	page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
-	if (page && !page_pool_recycle_in_ring(pool, page)) {
+	nmem = __page_pool_put_netmem(pool, nmem, dma_sync_size, allow_direct);
+	if (nmem && !page_pool_recycle_in_ring(pool, nmem)) {
 		/* Cache full, fallback to free pages */
 		recycle_stat_inc(pool, ring_full);
-		page_pool_return_page(pool, page);
+		page_pool_return_netmem(pool, nmem);
 	}
 }
-EXPORT_SYMBOL(page_pool_put_defragged_page);
+EXPORT_SYMBOL(page_pool_put_defragged_netmem);
 
 /* Caller must not use data area after call, as this function overwrites it */
 void page_pool_put_page_bulk(struct page_pool *pool, void **data,
@@ -634,16 +635,16 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 	int i, bulk_len = 0;
 
 	for (i = 0; i < count; i++) {
-		struct page *page = virt_to_head_page(data[i]);
+		struct netmem *nmem = virt_to_netmem(data[i]);
 
 		/* It is not the last user for the page frag case */
-		if (!page_pool_is_last_frag(pool, page))
+		if (!page_pool_is_last_frag(pool, nmem))
 			continue;
 
-		page = __page_pool_put_page(pool, page, -1, false);
+		nmem = __page_pool_put_netmem(pool, nmem, -1, false);
 		/* Approved for bulk recycling in ptr_ring cache */
-		if (page)
-			data[bulk_len++] = page;
+		if (nmem)
+			data[bulk_len++] = nmem;
 	}
 
 	if (unlikely(!bulk_len))
@@ -669,7 +670,7 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 	 * since put_page() with refcnt == 1 can be an expensive operation
 	 */
 	for (; i < bulk_len; i++)
-		page_pool_return_page(pool, data[i]);
+		page_pool_return_netmem(pool, data[i]);
 }
 EXPORT_SYMBOL(page_pool_put_page_bulk);
 
-- 
2.35.1

