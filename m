Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA1D6190D3
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 07:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbiKDGSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 02:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiKDGSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 02:18:53 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D90228E1E
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 23:18:50 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N3VnG22xlzmVdM;
        Fri,  4 Nov 2022 14:18:42 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 4 Nov 2022 14:18:48 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 14:18:48 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     Yang Yingliang <yangyingliang@huawei.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        Shailend Chand <shailend@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next] gve: Fix error return code in gve_prefill_rx_pages()
Date:   Fri, 4 Nov 2022 14:17:36 +0800
Message-ID: <20221104061736.1621866-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If alloc_page() fails in gve_prefill_rx_pages(), it should return
an error code in the error path.

Fixes: 82fd151d38d9 ("gve: Reduce alloc and copy costs in the GQ rx path")
Cc: Jeroen de Borst <jeroendb@google.com>
Cc: Catherine Sullivan <csully@google.com>
Cc: Shailend Chand <shailend@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index e2f4494c65fb..1f55137722b0 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -150,8 +150,10 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 		for (j = 0; j < rx->qpl_copy_pool_mask + 1; j++) {
 			struct page *page = alloc_page(GFP_KERNEL);
 
-			if (!page)
+			if (!page) {
+				err = -ENOMEM;
 				goto alloc_err_qpl;
+			}
 
 			rx->qpl_copy_pool[j].page = page;
 			rx->qpl_copy_pool[j].page_offset = 0;
-- 
2.25.1

