Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8119D63E320
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 23:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiK3WIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 17:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiK3WI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 17:08:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA4C92A3F
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 14:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=C/sNw3veMKtURCiokaJ/pKwRw1nL+1aLdsvQ8DTvuXU=; b=Y2Vnb4q6B2LdiNZqzDkLmgkd5G
        oCHJ0xUNeKs/dX0mnLHSVVQ0m+7vvvsIwq+5+MPmYSoXhlQYlPYezaywNAgpnosOMkqrpTFsAliaS
        F7Lz5ggiPxWHlsZfgWK348a0JqDAKf0AWkaSgrqrzeLlJ/N46vF4a+XcE0m1kxc1hWA+jox+fsSYl
        FNE4C1o/rK8w1TpGrW+TaIBmlwCeFhhQ2xySgFyRSoZC61WXyr5TLVvF9RSAfUdEpPSR3itFZEcD0
        rgK0i9vcLSdhGjtRh+0EzKyie7SyCbulwBgi+SfDWw+F9WEsJJN4cuL6yQKdhnAEzpI8xIGjmCtYP
        Get9KnLw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p0VFN-00FLVQ-Dp; Wed, 30 Nov 2022 22:08:05 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 10/24] page_pool: Convert page_pool_put_defragged_page() to netmem
Date:   Wed, 30 Nov 2022 22:07:49 +0000
Message-Id: <20221130220803.3657490-11-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130220803.3657490-1-willy@infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
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
index bfb77b75f333..db617073025e 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -362,7 +362,7 @@ static inline void page_pool_release_page(struct page_pool *pool,
 	page_pool_release_netmem(pool, page_netmem(page));
 }
 
-void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
+void page_pool_put_defragged_netmem(struct page_pool *pool, struct netmem *nmem,
 				  unsigned int dma_sync_size,
 				  bool allow_direct);
 
@@ -398,15 +398,15 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
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
@@ -414,13 +414,22 @@ static inline void page_pool_put_page(struct page_pool *pool,
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

