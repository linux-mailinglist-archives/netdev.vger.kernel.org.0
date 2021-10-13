Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB1D42BB65
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbhJMJXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:23:19 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:25129 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhJMJXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:23:18 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HTn6c6ZRhz1DHZw;
        Wed, 13 Oct 2021 17:19:36 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 17:21:05 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 13 Oct 2021 17:21:05 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <akpm@linux-foundation.org>,
        <peterz@infradead.org>, <will@kernel.org>, <jhubbard@nvidia.com>,
        <yuzhao@google.com>, <mcroce@microsoft.com>,
        <fenghua.yu@intel.com>, <feng.tang@intel.com>, <jgg@ziepe.ca>,
        <aarcange@redhat.com>, <guro@fb.com>
Subject: [PATCH net-next v6] page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA
Date:   Wed, 13 Oct 2021 17:19:20 +0800
Message-ID: <20211013091920.1106-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
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

As the 32-bit arch with 64-bit DMA seems to rare those days,
and page pool might carry a lot of code and complexity for
systems that possibly.

So disable dma mapping support for such systems, if drivers
really want to work on such systems, they have to implement
their own DMA-mapping fallback tracking outside page_pool.

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V6: Drop pp page tracking support
---
 include/linux/mm_types.h | 13 +------------
 include/net/page_pool.h  | 12 +-----------
 net/core/page_pool.c     | 10 ++++++----
 3 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 7f8ee09c711f..436e0946d691 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -104,18 +104,7 @@ struct page {
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
+			atomic_long_t pp_frag_count;
 		};
 		struct {	/* slab, slob and slub */
 			union {
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index a4082406a003..3855f069627f 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -216,24 +216,14 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	page_pool_put_full_page(pool, page, true);
 }
 
-#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
-		(sizeof(dma_addr_t) > sizeof(unsigned long))
-
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	dma_addr_t ret = page->dma_addr;
-
-	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
-		ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
-
-	return ret;
+	return page->dma_addr;
 }
 
 static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 {
 	page->dma_addr = addr;
-	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
-		page->dma_addr_upper = upper_32_bits(addr);
 }
 
 static inline void page_pool_set_frag_count(struct page *page, long nr)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a6978427d6c..9b60e4301a44 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -49,6 +49,12 @@ static int page_pool_init(struct page_pool *pool,
 	 * which is the XDP_TX use-case.
 	 */
 	if (pool->p.flags & PP_FLAG_DMA_MAP) {
+		/* DMA-mapping is not supported on 32-bit systems with
+		 * 64-bit DMA mapping.
+		 */
+		if (sizeof(dma_addr_t) > sizeof(unsigned long))
+			return -EOPNOTSUPP;
+
 		if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
 		    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
 			return -EINVAL;
@@ -69,10 +75,6 @@ static int page_pool_init(struct page_pool *pool,
 		 */
 	}
 
-	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
-	    pool->p.flags & PP_FLAG_PAGE_FRAG)
-		return -EINVAL;
-
 	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
 		return -ENOMEM;
 
-- 
2.33.0

