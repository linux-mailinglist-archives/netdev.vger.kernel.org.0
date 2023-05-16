Return-Path: <netdev+bounces-2988-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A05B4704E1A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:50:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DA391C20DC4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5511261D2;
	Tue, 16 May 2023 12:50:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98B8261C9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:50:07 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A3D5FD3;
	Tue, 16 May 2023 05:50:04 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QLGDk6d78z18LWL;
	Tue, 16 May 2023 20:45:42 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 20:50:01 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Lorenzo Bianconi <lorenzo@kernel.org>, Alexander
 Duyck <alexander.duyck@gmail.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Eric Dumazet
	<edumazet@google.com>
Subject: [RFC 1/3] page_pool: unify frag page and non-frag page handling
Date: Tue, 16 May 2023 20:47:59 +0800
Message-ID: <20230516124801.2465-2-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230516124801.2465-1-linyunsheng@huawei.com>
References: <20230516124801.2465-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
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
 include/net/page_pool.h | 24 ++++++++++++++++++------
 net/core/page_pool.c    |  3 ++-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index c8ec2f34722b..14ac46297ae4 100644
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
@@ -295,7 +298,8 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
  */
 static inline void page_pool_fragment_page(struct page *page, long nr)
 {
-	atomic_long_set(&page->pp_frag_count, nr);
+	if (!PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
+		atomic_long_set(&page->pp_frag_count, nr);
 }
 
 static inline long page_pool_defrag_page(struct page *page, long nr)
@@ -316,14 +320,25 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
 
 	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
 	WARN_ON(ret < 0);
+
+	/* Reset it to 1 to allow only one user in case the page is
+	 * recycled and allocated as non-frag page if it is the last
+	 * user, this should be the rare case as it only happen when
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
 
@@ -357,9 +372,6 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	page_pool_put_full_page(pool, page, true);
 }
 
-#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
-		(sizeof(dma_addr_t) > sizeof(unsigned long))
-
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
 	dma_addr_t ret = page->dma_addr;
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index e212e9d7edcb..5d93c5dc0549 100644
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
@@ -698,7 +699,7 @@ struct page *page_pool_alloc_frag(struct page_pool *pool,
 	unsigned int max_size = PAGE_SIZE << pool->p.order;
 	struct page *page = pool->frag_page;
 
-	if (WARN_ON(!(pool->p.flags & PP_FLAG_PAGE_FRAG) ||
+	if (WARN_ON(PAGE_POOL_DMA_USE_PP_FRAG_COUNT ||
 		    size > max_size))
 		return NULL;
 
-- 
2.33.0


