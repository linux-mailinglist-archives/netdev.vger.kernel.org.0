Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C4A40AD2E
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhINMOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:14:00 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19975 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhINMN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 08:13:58 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H82Dy2WxZzbmNX;
        Tue, 14 Sep 2021 20:08:34 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:12:39 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 14 Sep 2021 20:12:39 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next v2 1/3] page_pool: support non-split page with PP_FLAG_PAGE_FRAG
Date:   Tue, 14 Sep 2021 20:11:12 +0800
Message-ID: <20210914121114.28559-2-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210914121114.28559-1-linyunsheng@huawei.com>
References: <20210914121114.28559-1-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when PP_FLAG_PAGE_FRAG is set, the caller is not
expected to call page_pool_alloc_pages() directly because of
the PP_FLAG_PAGE_FRAG checking in __page_pool_put_page().

The patch removes the above checking to enable non-split page
support when PP_FLAG_PAGE_FRAG is set.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/page_pool.h |  6 ++++++
 net/core/page_pool.c    | 12 +++++++-----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index a4082406a003..2ad0706566c5 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -238,6 +238,9 @@ static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 
 static inline void page_pool_set_frag_count(struct page *page, long nr)
 {
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
+		return;
+
 	atomic_long_set(&page->pp_frag_count, nr);
 }
 
@@ -246,6 +249,9 @@ static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
 {
 	long ret;
 
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
+		return 0;
+
 	/* As suggested by Alexander, atomic_long_read() may cover up the
 	 * reference count errors, so avoid calling atomic_long_read() in
 	 * the cases of freeing or draining the page_frags, where we would
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a6978427d6c..ba9f14deacf4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -313,11 +313,14 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
 
 	/* Fast-path: Get a page from cache */
 	page = __page_pool_get_cached(pool);
-	if (page)
-		return page;
 
 	/* Slow-path: cache empty, do real allocation */
-	page = __page_pool_alloc_pages_slow(pool, gfp);
+	if (!page)
+		page = __page_pool_alloc_pages_slow(pool, gfp);
+
+	if (likely(page))
+		page_pool_set_frag_count(page, 1);
+
 	return page;
 }
 EXPORT_SYMBOL(page_pool_alloc_pages);
@@ -426,8 +429,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
 		     unsigned int dma_sync_size, bool allow_direct)
 {
 	/* It is not the last user for the page frag case */
-	if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
-	    page_pool_atomic_sub_frag_count_return(page, 1))
+	if (page_pool_atomic_sub_frag_count_return(page, 1))
 		return NULL;
 
 	/* This allocator is optimized for the XDP mode that uses
-- 
2.33.0

