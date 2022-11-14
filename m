Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495EA6277D3
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbiKNIft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236527AbiKNIfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:35:47 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C580F1B9E8;
        Mon, 14 Nov 2022 00:35:46 -0800 (PST)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N9jLD0l7FzHvw1;
        Mon, 14 Nov 2022 16:35:16 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 16:35:29 +0800
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 16:35:29 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Moritz Fischer <mdf@kernel.org>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: nixge: fix potential memory leak in nixge_start_xmit()
Date:   Mon, 14 Nov 2022 16:55:35 +0800
Message-ID: <1668416136-33530-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nixge_start_xmit() returns NETDEV_TX_OK but does not free skb on two
error handling cases, which can lead to memory leak.

To fix this, return NETDEV_TX_BUSY in case of nixge_check_tx_bd_space()
fails and add dev_kfree_skb_any() in case of dma_map_single() fails.

Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/ni/nixge.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 19d043b593cc..b9091f9bbc77 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -521,13 +521,15 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
 	if (nixge_check_tx_bd_space(priv, num_frag)) {
 		if (!netif_queue_stopped(ndev))
 			netif_stop_queue(ndev);
-		return NETDEV_TX_OK;
+		return NETDEV_TX_BUSY;
 	}
 
 	cur_phys = dma_map_single(ndev->dev.parent, skb->data,
 				  skb_headlen(skb), DMA_TO_DEVICE);
-	if (dma_mapping_error(ndev->dev.parent, cur_phys))
+	if (dma_mapping_error(ndev->dev.parent, cur_phys)) {
+		dev_kfree_skb_any(skb);
 		goto drop;
+	}
 	nixge_hw_dma_bd_set_phys(cur_p, cur_phys);
 
 	cur_p->cntrl = skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
-- 
2.31.1

