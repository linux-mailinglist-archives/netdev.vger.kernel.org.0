Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E890061D9D9
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 13:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKEMUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 08:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiKEMT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 08:19:57 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4D0E09C
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 05:19:56 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N4Gl86cBXzHvGH;
        Sat,  5 Nov 2022 20:19:32 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 5 Nov 2022 20:19:54 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 5 Nov
 2022 20:19:53 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <jiaxun.yang@flygoat.com>, <zhangqing@loongson.cn>,
        <liupeibao@loongson.cn>, <andrew@lunn.ch>, <kuba@kernel.org>
Subject: [PATCH net 3/3] stmmac: dwmac-loongson: fix missing of_node_put() while module exiting
Date:   Sat, 5 Nov 2022 20:18:40 +0800
Message-ID: <20221105121840.3654266-4-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221105121840.3654266-1-yangyingliang@huawei.com>
References: <20221105121840.3654266-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The node returned by of_get_child_by_name() with refcount decremented,
of_node_put() needs be called when finish using it. So add it in the
error path in loongson_dwmac_probe() and in loongson_dwmac_remove().

Fixes: 2ae34111fe4e ("stmmac: dwmac-loongson: fix invalid mdio_node")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 .../ethernet/stmicro/stmmac/dwmac-loongson.c  | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index e72ca7003f95..0016770f02c9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -75,20 +75,24 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 		plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
 						   sizeof(*plat->mdio_bus_data),
 						   GFP_KERNEL);
-		if (!plat->mdio_bus_data)
-			return -ENOMEM;
+		if (!plat->mdio_bus_data) {
+			ret = -ENOMEM;
+			goto err_put_node;
+		}
 		plat->mdio_bus_data->needs_reset = true;
 	}
 
 	plat->dma_cfg = devm_kzalloc(&pdev->dev, sizeof(*plat->dma_cfg), GFP_KERNEL);
-	if (!plat->dma_cfg)
-		return -ENOMEM;
+	if (!plat->dma_cfg) {
+		ret = -ENOMEM;
+		goto err_put_node;
+	}
 
 	/* Enable pci device */
 	ret = pci_enable_device(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "%s: ERROR: failed to enable device\n", __func__);
-		return ret;
+		goto err_put_node;
 	}
 
 	/* Get the base address of device */
@@ -150,13 +154,18 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	pci_disable_msi(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
+err_put_node:
+	of_node_put(plat->mdio_node);
 	return ret;
 }
 
 static void loongson_dwmac_remove(struct pci_dev *pdev)
 {
+	struct net_device *ndev = dev_get_drvdata(&pdev->dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
 	int i;
 
+	of_node_put(priv->plat->mdio_node);
 	stmmac_dvr_remove(&pdev->dev);
 
 	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
-- 
2.25.1

