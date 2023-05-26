Return-Path: <netdev+bounces-5599-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B5A71239A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1F941C211DB
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C48D11C84;
	Fri, 26 May 2023 09:28:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D83511C80
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:28:28 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2780F95;
	Fri, 26 May 2023 02:28:22 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QSKKt0CHTzsSPV;
	Fri, 26 May 2023 17:26:10 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 26 May 2023 17:28:19 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Lorenzo Bianconi <lorenzo@kernel.org>, Alexander
 Duyck <alexander.duyck@gmail.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet
	<edumazet@google.com>
Subject: [PATCH net-next 1/2] page_pool: unify frag page and non-frag page handling
Date: Fri, 26 May 2023 17:26:14 +0800
Message-ID: <20230526092616.40355-2-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230526092616.40355-1-linyunsheng@huawei.com>
References: <20230526092616.40355-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently page_pool_dev_alloc_pages() can not be called
when PP_FLAG_PAGE_FRAG is set, because it does not use
the frag reference counting.

As we are already doing a optimization by not updating
page->pp_frag_count in page_pool_defrag_page() for the
last frag user, and non-frag page only have one user,
so we utilize that to unify frag page and non-frag page
handling, so that page_pool_dev_alloc_pages() can also
be called with PP_FLAG_PAGE_FRAG set.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
CC: Lorenzo Bianconi <lorenzo@kernel.org>
CC: Alexander Duyck <alexander.duyck@gmail.com>
---
 include/net/page_pool.h | 38 +++++++++++++++++++++++++++++++-------
 net/core/page_pool.c    |  1 +
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index c8ec2f34722b..ea7a0c0592a5 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -50,6 +50,9 @@
 				 PP_FLAG_DMA_SYNC_DEV |\
 				 PP_FLAG_PAGE_FRAG)
 
+#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT \
+		(sizeof(dma_addr_t) > sizeof(unsigned long))
+
 /*
  * Fast allocation side cache array/stack
  *
@@ -295,13 +298,20 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
  */
 static inline void page_pool_fragment_page(struct page *page, long nr)
 {
-	atomic_long_set(&page->pp_frag_count, nr);
+	if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
+		atomic_long_set(&page->pp_frag_count, nr);
 }
 
+/* We need to reset frag_count back to 1 for the last user to allow
+ * only one user in case the page is recycled and allocated as non-frag
+ * page.
+ */
 static inline long page_pool_defrag_page(struct page *page, long nr)
 {
 	long ret;
 
+	BUILD_BUG_ON(__builtin_constant_p(nr) && nr != 1);
+
 	/* If nr == pp_frag_count then we have cleared all remaining
 	 * references to the page. No need to actually overwrite it, instead
 	 * we can leave this to be overwritten by the calling function.
@@ -311,19 +321,36 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
 	 * especially when dealing with a page that may be partitioned
 	 * into only 2 or 3 pieces.
 	 */
-	if (atomic_long_read(&page->pp_frag_count) == nr)
+	if (atomic_long_read(&page->pp_frag_count) == nr) {
+		/* As we have ensured nr is always one for constant case
+		 * using the BUILD_BUG_ON() as above, only need to handle
+		 * the non-constant case here for frag count draining.
+		 */
+		if (!__builtin_constant_p(nr))
+			atomic_long_set(&page->pp_frag_count, 1);
+
 		return 0;
+	}
 
 	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
 	WARN_ON(ret < 0);
+
+	/* Reset frag count back to 1, this should be the rare case when
+	 * two users call page_pool_defrag_page() currently.
+	 */
+	if (!ret)
+		atomic_long_set(&page->pp_frag_count, 1);
+
 	return ret;
 }
 
 static inline bool page_pool_is_last_frag(struct page_pool *pool,
 					  struct page *page)
 {
-	/* If fragments aren't enabled or count is 0 we were the last user */
-	return !(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
+	/* When dma_addr_upper is overlapped with pp_frag_count
+	 * or we were the last page frag user.
+	 */
+	return PAGE_POOL_DMA_USE_PP_FRAG_COUNT ||
 	       (page_pool_defrag_page(page, 1) == 0);
 }
 
@@ -357,9 +384,6 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	page_pool_put_full_page(pool, page, true);
 }
 
-#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
-		(sizeof(dma_addr_t) > sizeof(unsigned long))
-
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
 	dma_addr_t ret = page->dma_addr;
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e212e9d7edcb..0868aa8f6323 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -334,6 +334,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
 {
 	page->pp = pool;
 	page->pp_magic |= PP_SIGNATURE;
+	page_pool_fragment_page(page, 1);
 	if (pool->p.init_callback)
 		pool->p.init_callback(page, pool->p.init_arg);
 }
-- 
2.33.0


