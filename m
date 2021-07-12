Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9157A3C5A0E
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242415AbhGLJXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 05:23:36 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6915 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349720AbhGLJXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 05:23:18 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GNdSL60pCz7BY5;
        Mon, 12 Jul 2021 17:16:50 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 17:20:22 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 17:20:22 +0800
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
Subject: [PATCH rfc v3 2/4] page_pool: add interface for getting and setting pagecnt_bias
Date:   Mon, 12 Jul 2021 17:19:38 +0800
Message-ID: <1626081581-54524-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626081581-54524-1-git-send-email-linyunsheng@huawei.com>
References: <1626081581-54524-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Alexander, "A DMA mapping should be page
aligned anyway so the lower 12 bits would be reserved 0",
so it might make more sense to repurpose the lower 12 bits
of the dma address to store the pagecnt_bias for elevated
refcnt case in page pool.

As newly added page_pool_get_pagecnt_bias() may be called
outside of the softirq context, so annotate the access to
page->dma_addr[0] with READ_ONCE() and WRITE_ONCE().

And page_pool_get_pagecnt_bias_ptr() is added to implement
the pagecnt_bias atomic updating.

Other three interfaces using page->dma_addr[0] is only called
in the softirq context during normal rx processing, hopefully
the barrier in the rx processing will ensure the correct order
between getting and setting pagecnt_bias.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/page_pool.h | 29 +++++++++++++++++++++++++++--
 net/core/page_pool.c    |  8 +++++++-
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 8d7744d..84cd972 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -200,17 +200,42 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	dma_addr_t ret = page->dma_addr[0];
+	dma_addr_t ret = READ_ONCE(page->dma_addr[0]) & PAGE_MASK;
 	if (sizeof(dma_addr_t) > sizeof(unsigned long))
 		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
 	return ret;
 }
 
-static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
+static inline bool page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 {
+	if (WARN_ON(addr & ~PAGE_MASK))
+		return false;
+
 	page->dma_addr[0] = addr;
 	if (sizeof(dma_addr_t) > sizeof(unsigned long))
 		page->dma_addr[1] = upper_32_bits(addr);
+
+	return true;
+}
+
+static inline int page_pool_get_pagecnt_bias(struct page *page)
+{
+	return READ_ONCE(page->dma_addr[0]) & ~PAGE_MASK;
+}
+
+static inline unsigned long *page_pool_pagecnt_bias_ptr(struct page *page)
+{
+	return page->dma_addr;
+}
+
+static inline void page_pool_set_pagecnt_bias(struct page *page, int bias)
+{
+	unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
+
+	dma_addr_0 &= PAGE_MASK;
+	dma_addr_0 |= bias;
+
+	WRITE_ONCE(page->dma_addr[0], dma_addr_0);
 }
 
 static inline bool is_page_pool_compiled_in(void)
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 78838c6..1abefc6 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -198,7 +198,13 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 	if (dma_mapping_error(pool->p.dev, dma))
 		return false;
 
-	page_pool_set_dma_addr(page, dma);
+	if (unlikely(!page_pool_set_dma_addr(page, dma))) {
+		dma_unmap_page_attrs(pool->p.dev, dma,
+				     PAGE_SIZE << pool->p.order,
+				     pool->p.dma_dir,
+				     DMA_ATTR_SKIP_CPU_SYNC);
+		return false;
+	}
 
 	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
 		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
-- 
2.7.4

