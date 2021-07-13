Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DC53C6D49
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 11:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhGMJ2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 05:28:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15008 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbhGMJ2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 05:28:05 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GPFWm3b2DzbbwG;
        Tue, 13 Jul 2021 17:21:56 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:25:13 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 13 Jul 2021 17:25:12 +0800
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
Subject: [PATCH rfc v4 2/4] page_pool: add interface to manipulate bias in page pool
Date:   Tue, 13 Jul 2021 17:24:30 +0800
Message-ID: <1626168272-25622-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626168272-25622-1-git-send-email-linyunsheng@huawei.com>
References: <1626168272-25622-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Alexander, "A DMA mapping should be page
aligned anyway so the lower 12 bits would be reserved 0",
so it might make more sense to repurpose the lower 12 bits
of the dma address to store the bias for frag page support
in page pool for 32 bit systems with 64 bit dma, which
should be rare those days.

For normal system, the dma_addr[1] in 'struct page' is not
used, so we can reuse the dma_addr[1] for storing bias.

The PAGE_POOP_USE_DMA_ADDR_1 macro is used to decide where
to store the bias, as the "sizeof(dma_addr_t) > sizeof(
unsigned long)" is false for normal system, so hopefully the
compiler will optimize out the unused code for those system.

The newly added page_pool_set_bias() should be called before
the page is passed to any user. Otherwise, call the newly
added page_pool_atomic_sub_bias_return().

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/page_pool.h | 70 ++++++++++++++++++++++++++++++++++++++++++++++---
 net/core/page_pool.c    | 10 +++++++
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 8d7744d..315b9f2 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -198,21 +198,85 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 	page_pool_put_full_page(pool, page, true);
 }
 
+#define PAGE_POOP_USE_DMA_ADDR_1	(sizeof(dma_addr_t) > sizeof(unsigned long))
+
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	dma_addr_t ret = page->dma_addr[0];
-	if (sizeof(dma_addr_t) > sizeof(unsigned long))
+	dma_addr_t ret;
+
+	if (PAGE_POOP_USE_DMA_ADDR_1) {
+		ret = READ_ONCE(page->dma_addr[0]) & PAGE_MASK;
 		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
+	} else {
+		ret = page->dma_addr[0];
+	}
+
 	return ret;
 }
 
 static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 {
 	page->dma_addr[0] = addr;
-	if (sizeof(dma_addr_t) > sizeof(unsigned long))
+	if (PAGE_POOP_USE_DMA_ADDR_1)
 		page->dma_addr[1] = upper_32_bits(addr);
 }
 
+static inline int page_pool_atomic_sub_bias_return(struct page *page, int nr)
+{
+	int bias;
+
+	if (PAGE_POOP_USE_DMA_ADDR_1) {
+		unsigned long *bias_ptr = &page->dma_addr[0];
+		unsigned long old_bias = READ_ONCE(*bias_ptr);
+		unsigned long new_bias;
+
+		do {
+			bias = (int)(old_bias & ~PAGE_MASK);
+
+			/* Warn when page_pool_dev_alloc_pages() is called
+			 * with PP_FLAG_PAGE_FRAG flag in driver.
+			 */
+			WARN_ON(!bias);
+
+			/* already the last user */
+			if (!(bias - nr))
+				return 0;
+
+			new_bias = old_bias - nr;
+		} while (!try_cmpxchg(bias_ptr, &old_bias, new_bias));
+
+		WARN_ON((new_bias & PAGE_MASK) != (old_bias & PAGE_MASK));
+
+		bias = new_bias & ~PAGE_MASK;
+	} else {
+		atomic_t *v = (atomic_t *)&page->dma_addr[1];
+
+		if (atomic_read(v) == nr)
+			return 0;
+
+		bias = atomic_sub_return(nr, v);
+		WARN_ON(bias < 0);
+	}
+
+	return bias;
+}
+
+static inline void page_pool_set_bias(struct page *page, int bias)
+{
+	if (PAGE_POOP_USE_DMA_ADDR_1) {
+		unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
+
+		dma_addr_0 &= PAGE_MASK;
+		dma_addr_0 |= bias;
+
+		WRITE_ONCE(page->dma_addr[0], dma_addr_0);
+	} else {
+		atomic_t *v = (atomic_t *)&page->dma_addr[1];
+
+		atomic_set(v, bias);
+	}
+}
+
 static inline bool is_page_pool_compiled_in(void)
 {
 #ifdef CONFIG_PAGE_POOL
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 78838c6..6ac5b00 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -198,6 +198,16 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 	if (dma_mapping_error(pool->p.dev, dma))
 		return false;
 
+	if (PAGE_POOP_USE_DMA_ADDR_1 &&
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

