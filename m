Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93823F271F
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 09:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238730AbhHTG6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 02:58:48 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:14291 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhHTG6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 02:58:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GrXWw5qC0z87RS;
        Fri, 20 Aug 2021 14:57:48 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 14:57:58 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 14:57:58 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <hawk@kernel.org>, <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 2/2] page_pool: optimize the cpu sync operation when DMA mapping
Date:   Fri, 20 Aug 2021 14:56:51 +0800
Message-ID: <1629442611-61547-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629442611-61547-1-git-send-email-linyunsheng@huawei.com>
References: <1629442611-61547-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the DMA_ATTR_SKIP_CPU_SYNC is not set, cpu syncing is
also done in dma_map_page_attrs(), so set the attrs according
to pool->p.flags to avoid calling cpu sync function again.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/page_pool.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a69784..3df5554 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -191,8 +191,12 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
 
 static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 {
+	unsigned long attrs = DMA_ATTR_SKIP_CPU_SYNC;
 	dma_addr_t dma;
 
+	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
+		attrs = 0;
+
 	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
 	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
 	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
@@ -200,15 +204,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
 	 */
 	dma = dma_map_page_attrs(pool->p.dev, page, 0,
 				 (PAGE_SIZE << pool->p.order),
-				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
+				 pool->p.dma_dir, attrs);
 	if (dma_mapping_error(pool->p.dev, dma))
 		return false;
 
 	page_pool_set_dma_addr(page, dma);
 
-	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
-		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
-
 	return true;
 }
 
-- 
2.7.4

