Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05162622323
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 05:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiKIEdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 23:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiKIEdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 23:33:19 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C151FF83
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 20:33:17 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N6XC40cgZz15MQ1;
        Wed,  9 Nov 2022 12:33:04 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 9 Nov
 2022 12:33:15 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <u.kleine-koenig@pengutronix.de>, <mkl@pengutronix.de>,
        <tie-fei.zang@freescale.com>, <akpm@osdl.org>,
        <Alexandre.Bounine@tundra.com>, <jeff@garzik.org>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net] ethernet: tundra: free irq when alloc ring failed in tsi108_open()
Date:   Wed, 9 Nov 2022 12:40:16 +0800
Message-ID: <20221109044016.126866-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When alloc tx/rx ring failed in tsi108_open(), it doesn't free irq. Fix
it.

Fixes: 5e123b844a1c ("[PATCH] Add tsi108/9 On Chip Ethernet device driver support")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: move free_irq to error handling path and modify fixes tag
---
 drivers/net/ethernet/tundra/tsi108_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 2cd2afc3fff0..d09d352e1c0a 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1290,12 +1290,15 @@ static int tsi108_open(struct net_device *dev)
 
 	data->rxring = dma_alloc_coherent(&data->pdev->dev, rxring_size,
 					  &data->rxdma, GFP_KERNEL);
-	if (!data->rxring)
+	if (!data->rxring) {
+		free_irq(data->irq_num, dev);
 		return -ENOMEM;
+	}
 
 	data->txring = dma_alloc_coherent(&data->pdev->dev, txring_size,
 					  &data->txdma, GFP_KERNEL);
 	if (!data->txring) {
+		free_irq(data->irq_num, dev);
 		dma_free_coherent(&data->pdev->dev, rxring_size, data->rxring,
 				    data->rxdma);
 		return -ENOMEM;
-- 
2.17.1

