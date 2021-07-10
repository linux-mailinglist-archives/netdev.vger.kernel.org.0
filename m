Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1773C3396
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbhGJHq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:46:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6798 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhGJHqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:46:48 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GMMMm0x3dzXrLh;
        Sat, 10 Jul 2021 15:38:28 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 10 Jul 2021 15:44:00 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 10 Jul 2021 15:44:00 +0800
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
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: [PATCH rfc v2 2/5] page_pool: add interface for getting and setting pagecnt_bias
Date:   Sat, 10 Jul 2021 15:43:19 +0800
Message-ID: <1625903002-31619-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com>
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

Other three interfaces using page->dma_addr[0] is only called
in the softirq context during normal rx processing, hopefully
the barrier in the rx processing will ensure the correct order
between getting and setting pagecnt_bias.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/page_pool.h | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 8d7744d..5746f17 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -200,7 +200,7 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
 
 static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 {
-	dma_addr_t ret = page->dma_addr[0];
+	dma_addr_t ret = READ_ONCE(page->dma_addr[0]) & PAGE_MASK;
 	if (sizeof(dma_addr_t) > sizeof(unsigned long))
 		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
 	return ret;
@@ -208,11 +208,31 @@ static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
 
 static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
 {
-	page->dma_addr[0] = addr;
+	unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
+
+	dma_addr_0 &= ~PAGE_MASK;
+	dma_addr_0 |= (addr & PAGE_MASK);
+	WRITE_ONCE(page->dma_addr[0], dma_addr_0);
+
 	if (sizeof(dma_addr_t) > sizeof(unsigned long))
 		page->dma_addr[1] = upper_32_bits(addr);
 }
 
+static inline int page_pool_get_pagecnt_bias(struct page *page)
+{
+	return (READ_ONCE(page->dma_addr[0]) & ~PAGE_MASK);
+}
+
+static inline void page_pool_set_pagecnt_bias(struct page *page, int bias)
+{
+	unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
+
+	dma_addr_0 &= PAGE_MASK;
+	dma_addr_0 |= (bias & ~PAGE_MASK);
+
+	WRITE_ONCE(page->dma_addr[0], dma_addr_0);
+}
+
 static inline bool is_page_pool_compiled_in(void)
 {
 #ifdef CONFIG_PAGE_POOL
-- 
2.7.4

