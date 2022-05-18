Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E12052B537
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbiERI52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiERI50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:57:26 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A768E13FAB;
        Wed, 18 May 2022 01:57:05 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L36Dh1kP4zCsmj;
        Wed, 18 May 2022 16:52:04 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 18 May 2022 16:56:59 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 16:56:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <haijun.liu@mediatek.com>, <chandrashekar.devegowda@intel.com>,
        <ricardo.martinez@linux.intel.com>, <loic.poulain@linaro.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next] net: wwan: t7xx: use GFP_ATOMIC under spin lock in t7xx_cldma_gpd_set_next_ptr()
Date:   Wed, 18 May 2022 17:07:38 +0800
Message-ID: <20220518090738.2694556-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes t7xx_cldma_gpd_set_next_ptr() is called under spin lock,
so add a parameter in t7xx_cldma_gpd_set_next_ptr() to make if it
use GFP_ATOMIC flag.

Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index 0c52801ed0de..1fa9bb763831 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -91,9 +91,12 @@ static void t7xx_cldma_gpd_set_next_ptr(struct cldma_gpd *gpd, dma_addr_t next_p
 }
 
 static int t7xx_cldma_alloc_and_map_skb(struct cldma_ctrl *md_ctrl, struct cldma_request *req,
-					size_t size)
+					size_t size, bool is_atomic)
 {
-	req->skb = __dev_alloc_skb(size, GFP_KERNEL);
+	if (is_atomic)
+		req->skb = __dev_alloc_skb(size, GFP_ATOMIC);
+	else
+		req->skb = __dev_alloc_skb(size, GFP_KERNEL);
 	if (!req->skb)
 		return -ENOMEM;
 
@@ -174,7 +177,7 @@ static int t7xx_cldma_gpd_rx_from_q(struct cldma_queue *queue, int budget, bool
 		spin_unlock_irqrestore(&queue->ring_lock, flags);
 		req = queue->rx_refill;
 
-		ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, queue->tr_ring->pkt_size);
+		ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, queue->tr_ring->pkt_size, false);
 		if (ret)
 			return ret;
 
@@ -402,7 +405,7 @@ static struct cldma_request *t7xx_alloc_rx_request(struct cldma_ctrl *md_ctrl, s
 	if (!req->gpd)
 		goto err_free_req;
 
-	val = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, pkt_size);
+	val = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, pkt_size, false);
 	if (val)
 		goto err_free_pool;
 
@@ -801,7 +804,7 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
 		if (req->skb)
 			continue;
 
-		ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, rxq->tr_ring->pkt_size);
+		ret = t7xx_cldma_alloc_and_map_skb(md_ctrl, req, rxq->tr_ring->pkt_size, true);
 		if (ret)
 			break;
 
-- 
2.25.1

