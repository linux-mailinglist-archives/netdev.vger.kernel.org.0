Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785F1629CA1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiKOOv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiKOOvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:51:25 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A4C24BE9;
        Tue, 15 Nov 2022 06:51:24 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NBTdN4208zRpBQ;
        Tue, 15 Nov 2022 22:51:04 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 22:51:22 +0800
Received: from localhost.localdomain (10.175.112.70) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 22:51:22 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mdf@kernel.org>, <romieu@fr.zoreil.com>
CC:     <zhangchangzhong@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2 1/3] net: nixge: fix potential memory leak in nixge_start_xmit()
Date:   Tue, 15 Nov 2022 23:10:22 +0800
Message-ID: <1668525024-38409-2-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
References: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nixge_start_xmit() returns NETDEV_TX_OK but does not free skb in
case of dma_map_single() fails, which leads to memory leak.

Fix it by adding dev_kfree_skb_any() when dma_map_single() fails.

Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/ni/nixge.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 19d043b..d8cd520 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -526,8 +526,10 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
 
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
2.9.5

