Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55DA454236
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 08:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhKQICJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 03:02:09 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14948 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbhKQICJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 03:02:09 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HvFct2z1zzZd74;
        Wed, 17 Nov 2021 15:56:46 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 17 Nov 2021 15:59:01 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 17 Nov 2021 15:59:01 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <akpm@linux-foundation.org>,
        <peterz@infradead.org>, <vbabka@suse.cz>, <willy@infradead.org>,
        <will@kernel.org>, <feng.tang@intel.com>, <jgg@ziepe.ca>,
        <ebiederm@xmission.com>, <aarcange@redhat.com>,
        <guillaume.tucker@collabora.com>
Subject: [PATCH net] page_pool: Revert "page_pool: disable dma mapping support..."
Date:   Wed, 17 Nov 2021 15:56:52 +0800
Message-ID: <20211117075652.58299-1-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit d00e60ee54b12de945b8493cf18c1ada9e422514.

As reported by Guillaume in [1]:
Enabling LPAE always enables CONFIG_ARCH_DMA_ADDR_T_64BIT
in 32-bit systems, which breaks the bootup proceess when a
ethernet driver is using page pool with PP_FLAG_DMA_MAP flag.
As we were hoping we had no active consumers for such system
when we removed the dma mapping support, and LPAE seems like
a common feature for 32 bits system, so revert it.

1. https://www.spinics.net/lists/netdev/msg779890.html

Fixes: d00e60ee54b1 ("page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/mm_types.h | 13 ++++++++++++-
 include/net/page_pool.h  | 12 +++++++++++-
 net/core/page_pool.c     | 10 ++++------
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index bb8c6f5f19bc..c3a6e6209600 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -105,7 +105,18 @@ struct page {
 			struct page_pool *pp;
 			unsigned long _pp_mapping_pad;
 			unsigned long dma_addr;
-			atomic_long_t pp_frag_count;
+			union {
+				/**
+				 * dma_addr_upper: might require a 64-bit
+				 * value on 32-bit architectures.
+				 */
+				unsigned long dma_addr_upper;
+				/**
+				 * For frag page support, not supported in
+				 * 32-bit architectures with 64-bit DMA.
+				 */
+				atomic_long_t pp_frag_count;
+			};
 		};
 		struct {	/* slab, slob and slub */
 			union {
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 3855f069627f..a4082406a003 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -216,14 +216,24 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	page_pool_put_full_page(pool, page, true);
 }
 
+#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
+		(sizeof(dma_addr_t) > sizeof(unsigned long))
+
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	return page->dma_addr;
+	dma_addr_t ret = page->dma_addr;
+
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
+		ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
+
+	return ret;
 }
 
 static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 {
 	page->dma_addr = addr;
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
+		page->dma_addr_upper = upper_32_bits(addr);
 }
 
 static inline void page_pool_set_frag_count(struct page *page, long nr)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b60e4301a44..1a6978427d6c 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -49,12 +49,6 @@ static int page_pool_init(struct page_pool *pool,
 	 * which is the XDP_TX use-case.
 	 */
 	if (pool->p.flags & PP_FLAG_DMA_MAP) {
-		/* DMA-mapping is not supported on 32-bit systems with
-		 * 64-bit DMA mapping.
-		 */
-		if (sizeof(dma_addr_t) > sizeof(unsigned long))
-			return -EOPNOTSUPP;
-
 		if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
 		    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
 			return -EINVAL;
@@ -75,6 +69,10 @@ static int page_pool_init(struct page_pool *pool,
 		 */
 	}
 
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
+	    pool->p.flags & PP_FLAG_PAGE_FRAG)
+		return -EINVAL;
+
 	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
 		return -ENOMEM;
 
-- 
2.33.0

