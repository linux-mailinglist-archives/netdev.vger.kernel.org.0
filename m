Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD363C81BA
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbhGNJiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:38:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15012 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238362AbhGNJiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:38:19 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GPsj50DW4zbc2x;
        Wed, 14 Jul 2021 17:32:09 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:35:26 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 17:35:25 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
        <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH rfc v5 2/4] page_pool: add interface to manipulate frag count in page pool
Date:   Wed, 14 Jul 2021 17:34:43 +0800
Message-ID: <1626255285-5079-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626255285-5079-1-git-send-email-linyunsheng@huawei.com>
References: <1626255285-5079-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Alexander, "A DMA mapping should be page
aligned anyway so the lower 12 bits would be reserved 0",
so it might make more sense to repurpose the lower 12 bits
of the dma address to store the frag count for frag page
support in page pool for 32 bit systems with 64 bit dma,
which should be rare those days.

For normal system, the dma_addr[1] in 'struct page' is not
used, so we can reuse one of the dma_addr for storing frag
count, which means how many frags this page might be splited
to.

The PAGE_POOL_DMA_USE_PP_FRAG_COUNT macro is added to decide
where to store the frag count, as the "sizeof(dma_addr_t) >
sizeof(unsigned long)" is false for most systems those days,
so hopefully the compiler will optimize out the unused code
for those systems.

The newly added page_pool_set_frag_count() should be called
before the page is passed to any user. Otherwise, call the
newly added page_pool_atomic_sub_frag_count_return().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/mm_types.h |  8 +++++--
 include/net/page_pool.h  | 54 ++++++++++++++++++++++++++++++++++++++++++------
 net/core/page_pool.c     | 10 +++++++++
 3 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d33d97c..82bcbb0 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -103,11 +103,15 @@ struct page {
 			unsigned long pp_magic;
 			struct page_pool *pp;
 			unsigned long _pp_mapping_pad;
+			atomic_long_t pp_frag_count;
 			/**
 			 * @dma_addr: might require a 64-bit value on
-			 * 32-bit architectures.
+			 * 32-bit architectures, if so, store the lower 32
+			 * bits in pp_frag_count, and a DMA mapping should
+			 * be page aligned, so the frag count can be stored
+			 * in lower 12 bits for 4K page size.
 			 */
-			unsigned long dma_addr[2];
+			unsigned long dma_addr;
 		};
 		struct {	/* slab, slob and slub */
 			union {
diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 8d7744d..ef449c2 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -198,19 +198,61 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	page_pool_put_full_page(pool, page, true);
 }
 
+#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
+			(sizeof(dma_addr_t) > sizeof(unsigned long))
+
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	dma_addr_t ret = page->dma_addr[0];
-	if (sizeof(dma_addr_t) > sizeof(unsigned long))
-		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
+	dma_addr_t ret = page->dma_addr;
+
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
+		ret <<= 32;
+		ret |= atomic_long_read(&page->pp_frag_count) & PAGE_MASK;
+	}
+
 	return ret;
 }
 
 static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 {
-	page->dma_addr[0] = addr;
-	if (sizeof(dma_addr_t) > sizeof(unsigned long))
-		page->dma_addr[1] = upper_32_bits(addr);
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
+		atomic_long_set(&page->pp_frag_count, addr & PAGE_MASK);
+		addr >>= 32;
+	}
+
+	page->dma_addr = addr;
+}
+
+static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
+							  long nr)
+{
+	long frag_count = atomic_long_read(&page->pp_frag_count);
+	long ret;
+
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
+		if ((frag_count & ~PAGE_MASK) == nr)
+			return 0;
+
+		ret = atomic_long_sub_return(nr, &page->pp_frag_count);
+		WARN_ON((ret & PAGE_MASK) != (frag_count & PAGE_MASK));
+		ret &= ~PAGE_MASK;
+	} else {
+		if (frag_count == nr)
+			return 0;
+
+		ret = atomic_long_sub_return(nr, &page->pp_frag_count);
+		WARN_ON(ret < 0);
+	}
+
+	return ret;
+}
+
+static inline void page_pool_set_frag_count(struct page *page, long nr)
+{
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
+		nr |= atomic_long_read(&page->pp_frag_count) & PAGE_MASK;
+
+	atomic_long_set(&page->pp_frag_count, nr);
 }
 
 static inline bool is_page_pool_compiled_in(void)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 78838c6..0082f33 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -198,6 +198,16 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 	if (dma_mapping_error(pool->p.dev, dma))
 		return false;
 
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
+	    WARN_ON(pool->p.flags & PP_FLAG_PAGE_FRAG &&
+		    dma & ~PAGE_MASK)) {
+		dma_unmap_page_attrs(pool->p.dev, dma,
+				     PAGE_SIZE << pool->p.order,
+				     pool->p.dma_dir,
+				     DMA_ATTR_SKIP_CPU_SYNC);
+		return false;
+	}
+
 	page_pool_set_dma_addr(page, dma);
 
 	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
-- 
2.7.4

