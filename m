Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACC4554BB6
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 15:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353254AbiFVNso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 09:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357671AbiFVNsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 09:48:30 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C722E9CB;
        Wed, 22 Jun 2022 06:48:27 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LSl622Rl5zhXcb;
        Wed, 22 Jun 2022 21:46:18 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 22 Jun 2022 21:48:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 22 Jun 2022 21:48:25 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH] net: page_pool: optimize page pool page allocation in NUMA scenario
Date:   Wed, 22 Jun 2022 21:42:02 +0800
Message-ID: <20220622134202.7591-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently NIC packet receiving performance based on page pool deteriorates
occasionally. To analysis the causes of this problem page allocation stats
are collected. Here are the stats when NIC rx performance deteriorates:

bandwidth(Gbits/s)		16.8		6.91
rx_pp_alloc_fast		13794308	21141869
rx_pp_alloc_slow		108625		166481
rx_pp_alloc_slow_h		0		0
rx_pp_alloc_empty		8192		8192
rx_pp_alloc_refill		0		0
rx_pp_alloc_waive		100433		158289
rx_pp_recycle_cached		0		0
rx_pp_recycle_cache_full	0		0
rx_pp_recycle_ring		362400		420281
rx_pp_recycle_ring_full		6064893		9709724
rx_pp_recycle_released_ref	0		0

The rx_pp_alloc_waive count indicates that a large number of pages' numa
node are inconsistent with the NIC device numa node. Therefore these pages
can't be reused by the page pool. As a result, many new pages would be
allocated by __page_pool_alloc_pages_slow which is time consuming. This
causes the NIC rx performance fluctuations.

The main reason of huge numa mismatch pages in page pool is that page pool
uses alloc_pages_bulk_array to allocate original pages. This function is
not suitable for page allocation in NUMA scenario. So this patch uses
alloc_pages_bulk_array_node which has a NUMA id input parameter to ensure
the NUMA consistent between NIC device and allocated pages.

Repeated NIC rx performance tests are performed 40 times. NIC rx bandwidth
is higher and more stable compared to the datas above. Here are three test
stats, the rx_pp_alloc_waive count is zero and rx_pp_alloc_slow which
indicates pages allocated from slow patch is relatively low.

bandwidth(Gbits/s)		93		93.9		93.8
rx_pp_alloc_fast		60066264	61266386	60938254
rx_pp_alloc_slow		16512		16517		16539
rx_pp_alloc_slow_ho		0		0		0
rx_pp_alloc_empty		16512		16517		16539
rx_pp_alloc_refill		473841		481910		481585
rx_pp_alloc_waive		0		0		0
rx_pp_recycle_cached		0		0		0
rx_pp_recycle_cache_full	0		0		0
rx_pp_recycle_ring		29754145	30358243	30194023
rx_pp_recycle_ring_full		0		0		0
rx_pp_recycle_released_ref	0		0		0

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 net/core/page_pool.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b151772dd94b..d88c0c24041a 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -377,6 +377,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	unsigned int pp_order = pool->p.order;
 	struct page *page;
 	int i, nr_pages;
+	int pref_nid; /* preferred NUMA node */
 
 	/* Don't support bulk alloc for high-order pages */
 	if (unlikely(pp_order))
@@ -386,10 +387,18 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	if (unlikely(pool->alloc.count > 0))
 		return pool->alloc.cache[--pool->alloc.count];
 
+#ifdef CONFIG_NUMA
+	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;
+#else
+	/* Ignore pool->p.nid setting if !CONFIG_NUMA, helps compiler */
+	pref_nid = numa_mem_id(); /* will be zero like page_to_nid() */
+#endif
+
 	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
 	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
 
-	nr_pages = alloc_pages_bulk_array(gfp, bulk, pool->alloc.cache);
+	nr_pages = alloc_pages_bulk_array_node(gfp, pref_nid, bulk,
+					       pool->alloc.cache);
 	if (unlikely(!nr_pages))
 		return NULL;
 
-- 
2.30.0

