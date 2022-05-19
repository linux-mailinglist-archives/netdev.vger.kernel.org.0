Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB2E52CCF4
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 09:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiESH0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 03:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbiESH0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 03:26:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C62C6005A
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:26:16 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L3hCq0rGLzQkF9;
        Thu, 19 May 2022 15:23:19 +0800 (CST)
Received: from container.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 19 May 2022 15:26:13 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <chandrashekar.devegowda@intel.com>, <linuxwwan@intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <m.chetan.kumar@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>, <loic.poulain@linaro.org>,
        <ryazanov.s.a@gmail.com>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next v3] net: wwan: t7xx: fix GFP_KERNEL usage in spin_lock context
Date:   Thu, 19 May 2022 15:43:51 +0800
Message-ID: <20220519074351.829774-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
GFP_KERNEL, that will introduce scheduling factor in spin_lock context.

Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so we can
remove the spin_lock from t7xx_cldma_clear_rxq().

Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
Suggested-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
---
v3:
  - Add Suggested-by and simplify comments
v2:
  - Remove spin_lock instead of using GFP_ATOMIC

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
index 46066dcd2607..3a46a5bea24f 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -782,10 +782,11 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
 	struct cldma_queue *rxq = &md_ctrl->rxq[qnum];
 	struct cldma_request *req;
 	struct cldma_gpd *gpd;
-	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&rxq->ring_lock, flags);
+	/* CLDMA has been stopped. There is not any CLDMA IRQ, holding
+	 * ring_lock is not needed.
+	 */
 	t7xx_cldma_q_reset(rxq);
 	list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
 		gpd = req->gpd;
@@ -808,7 +809,6 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
 
 		t7xx_cldma_gpd_set_data_ptr(req->gpd, req->mapped_buff);
 	}
-	spin_unlock_irqrestore(&rxq->ring_lock, flags);
 
 	return ret;
 }
-- 
2.25.1

