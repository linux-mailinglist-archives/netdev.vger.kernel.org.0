Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F009C3C3399
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhGJHrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:47:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6906 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbhGJHqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:46:53 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GMMQ80Q3Lz79mm;
        Sat, 10 Jul 2021 15:40:32 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 10 Jul 2021 15:44:01 +0800
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
Subject: [PATCH rfc v2 4/5] page_pool: support page frag API for page pool
Date:   Sat, 10 Jul 2021 15:43:21 +0800
Message-ID: <1625903002-31619-5-git-send-email-linyunsheng@huawei.com>
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

Currently each desc use a whole page to do ping-pong page
reusing in most driver. As the page pool has support page
recycling based on elevated refcnt, it makes sense to add
a page frag API in page pool to split a page to different
frag to serve multi descriptions.

This means a huge memory saving for kernel with page size of
64K, as a page can be used by 32 descriptions with 2k buffer
size, comparing to each desc using one page currently.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/net/page_pool.h | 14 ++++++++++++++
 net/core/page_pool.c    | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index f0e708d..06a5e43 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -80,6 +80,7 @@ struct page_pool_params {
 	enum dma_data_direction dma_dir; /* DMA mapping direction */
 	unsigned int	max_len; /* max DMA sync memory size */
 	unsigned int	offset;  /* DMA addr offset */
+	unsigned int	frag_size;
 };
 
 struct page_pool {
@@ -91,6 +92,8 @@ struct page_pool {
 	unsigned long defer_warn;
 
 	u32 pages_state_hold_cnt;
+	unsigned int frag_offset;
+	struct page *frag_page;
 
 	/*
 	 * Data structure for allocation side
@@ -140,6 +143,17 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 	return page_pool_alloc_pages(pool, gfp);
 }
 
+struct page *page_pool_alloc_frag(struct page_pool *pool,
+				  unsigned int *offset, gfp_t gfp);
+
+static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
+						    unsigned int *offset)
+{
+	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
+
+	return page_pool_alloc_frag(pool, offset, gfp);
+}
+
 /* get the stored dma direction. A driver might decide to treat this locally and
  * avoid the extra cache line from page_pool to determine the direction
  */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a87cbe1..b787033 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -350,6 +350,53 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
 }
 EXPORT_SYMBOL(page_pool_alloc_pages);
 
+struct page *page_pool_alloc_frag(struct page_pool *pool,
+				  unsigned int *offset, gfp_t gfp)
+{
+	unsigned int frag_offset = pool->frag_offset;
+	unsigned int frag_size = pool->p.frag_size;
+	struct page *frag_page = pool->frag_page;
+	unsigned int max_len = pool->p.max_len;
+
+	if (!frag_page || frag_offset + frag_size > max_len) {
+		frag_page = page_pool_alloc_pages(pool, gfp);
+		if (unlikely(!frag_page)) {
+			pool->frag_page = NULL;
+			return NULL;
+		}
+
+		pool->frag_page = frag_page;
+		frag_offset = 0;
+
+		page_pool_sub_bias(pool, frag_page,
+				   max_len / frag_size - 1);
+	}
+
+	*offset = frag_offset;
+	pool->frag_offset = frag_offset + frag_size;
+
+	return frag_page;
+}
+EXPORT_SYMBOL(page_pool_alloc_frag);
+
+static void page_pool_empty_frag(struct page_pool *pool)
+{
+	unsigned int frag_offset = pool->frag_offset;
+	unsigned int frag_size = pool->p.frag_size;
+	struct page *frag_page = pool->frag_page;
+	unsigned int max_len = pool->p.max_len;
+
+	if (!frag_page)
+		return;
+
+	while (frag_offset + frag_size <= max_len) {
+		page_pool_put_full_page(pool, frag_page, false);
+		frag_offset += frag_size;
+	}
+
+	pool->frag_page = NULL;
+}
+
 /* Calculate distance between two u32 values, valid if distance is below 2^(31)
  *  https://en.wikipedia.org/wiki/Serial_number_arithmetic#General_Solution
  */
@@ -670,6 +717,8 @@ void page_pool_destroy(struct page_pool *pool)
 	if (!page_pool_put(pool))
 		return;
 
+	page_pool_empty_frag(pool);
+
 	if (!page_pool_release(pool))
 		return;
 
-- 
2.7.4

