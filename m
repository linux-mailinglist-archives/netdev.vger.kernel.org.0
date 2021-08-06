Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECB13E21DE
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 04:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242424AbhHFCru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 22:47:50 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7936 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240119AbhHFCrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 22:47:39 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GgqXw16y8z84T2;
        Fri,  6 Aug 2021 10:43:28 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 10:47:19 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 10:47:19 +0800
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
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next v2 2/4] page_pool: add interface to manipulate frag count in page pool
Date:   Fri, 6 Aug 2021 10:46:20 +0800
Message-ID: <1628217982-53533-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
References: <1628217982-53533-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For 32 bit systems with 64 bit dma, dma_addr[1] is used to
store the upper 32 bit dma addr, those system should be rare
those days.

For normal system, the dma_addr[1] in 'struct page' is not
used, so we can reuse dma_addr[1] for storing frag count,
which means how many frags this page might be splited to.

In order to simplify the page frag support in the page pool,
the PAGE_POOL_DMA_USE_PP_FRAG_COUNT macro is added to indicate
the 32 bit systems with 64 bit dma, and the page frag support
in page pool is disabled for such system.

The newly added page_pool_set_frag_count() is called to reserve
the maximum frag count before any page frag is passed to the
user. The page_pool_atomic_sub_frag_count_return() is called
when user is done with the page frag.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/mm_types.h | 18 +++++++++++++-----
 include/net/page_pool.h  | 46 +++++++++++++++++++++++++++++++++++++++-------
 net/core/page_pool.c     |  4 ++++
 3 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 52bbd2b..7f8ee09 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -103,11 +103,19 @@ struct page {
 			unsigned long pp_magic;
 			struct page_pool *pp;
 			unsigned long _pp_mapping_pad;
-			/**
-			 * @dma_addr: might require a 64-bit value on
-			 * 32-bit architectures.
-			 */
-			unsigned long dma_addr[2];
+			unsigned long dma_addr;
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
index 8d7744d..42e6997 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -45,7 +45,10 @@
 					* Please note DMA-sync-for-CPU is still
 					* device driver responsibility
 					*/
-#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
+#define PP_FLAG_PAGE_FRAG	BIT(2) /* for page frag feature */
+#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP |\
+				 PP_FLAG_DMA_SYNC_DEV |\
+				 PP_FLAG_PAGE_FRAG)
 
 /*
  * Fast allocation side cache array/stack
@@ -198,19 +201,48 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	page_pool_put_full_page(pool, page, true);
 }
 
+#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
+		(sizeof(dma_addr_t) > sizeof(unsigned long))
+
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	dma_addr_t ret = page->dma_addr[0];
-	if (sizeof(dma_addr_t) > sizeof(unsigned long))
-		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
+	dma_addr_t ret = page->dma_addr;
+
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
+		ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
+
 	return ret;
 }
 
 static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 {
-	page->dma_addr[0] = addr;
-	if (sizeof(dma_addr_t) > sizeof(unsigned long))
-		page->dma_addr[1] = upper_32_bits(addr);
+	page->dma_addr = addr;
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
+		page->dma_addr_upper = upper_32_bits(addr);
+}
+
+static inline void page_pool_set_frag_count(struct page *page, long nr)
+{
+	atomic_long_set(&page->pp_frag_count, nr);
+}
+
+static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
+							  long nr)
+{
+	long ret;
+
+	/* As suggested by Alexander, atomic_long_read() may cover up the
+	 * reference count errors, so avoid calling atomic_long_read() in
+	 * the cases of freeing or draining the page_frags, where we would
+	 * not expect it to match or that are slowpath anyway.
+	 */
+	if (__builtin_constant_p(nr) &&
+	    atomic_long_read(&page->pp_frag_count) == nr)
+		return 0;
+
+	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
+	WARN_ON(ret < 0);
+	return ret;
 }
 
 static inline bool is_page_pool_compiled_in(void)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 78838c6..68fab94 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -67,6 +67,10 @@ static int page_pool_init(struct page_pool *pool,
 		 */
 	}
 
+	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
+	    pool->p.flags & PP_FLAG_PAGE_FRAG)
+		return -EINVAL;
+
 	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
 		return -ENOMEM;
 
-- 
2.7.4

