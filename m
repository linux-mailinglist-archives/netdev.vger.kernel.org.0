Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1A73A08F0
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 03:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhFIBWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 21:22:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3802 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhFIBWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 21:22:40 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G08Lb3nFLzWtJM;
        Wed,  9 Jun 2021 09:15:51 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 09:20:35 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 09:20:34 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <sergei.shtylyov@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
Subject: [PATCH net-next] net: ethernet: ravb: Use devm_platform_get_and_ioremap_resource()
Date:   Wed, 9 Jun 2021 09:24:44 +0800
Message-ID: <20210609012444.3301411-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_get_and_ioremap_resource() to simplify
code.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 4afff320dfd0..69c50f81e1cb 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2047,13 +2047,6 @@ static int ravb_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	/* Get base address */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "invalid resource\n");
-		return -EINVAL;
-	}
-
 	ndev = alloc_etherdev_mqs(sizeof(struct ravb_private),
 				  NUM_TX_QUEUE, NUM_RX_QUEUE);
 	if (!ndev)
@@ -2065,9 +2058,6 @@ static int ravb_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
 
-	/* The Ether-specific entries in the device structure. */
-	ndev->base_addr = res->start;
-
 	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
 
 	if (chip_id == RCAR_GEN3)
@@ -2089,12 +2079,15 @@ static int ravb_probe(struct platform_device *pdev)
 	priv->num_rx_ring[RAVB_BE] = BE_RX_RING_SIZE;
 	priv->num_tx_ring[RAVB_NC] = NC_TX_RING_SIZE;
 	priv->num_rx_ring[RAVB_NC] = NC_RX_RING_SIZE;
-	priv->addr = devm_ioremap_resource(&pdev->dev, res);
+	priv->addr = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->addr)) {
 		error = PTR_ERR(priv->addr);
 		goto out_release;
 	}
 
+	/* The Ether-specific entries in the device structure. */
+	ndev->base_addr = res->start;
+
 	spin_lock_init(&priv->lock);
 	INIT_WORK(&priv->work, ravb_tx_timeout_work);
 
-- 
2.25.1

