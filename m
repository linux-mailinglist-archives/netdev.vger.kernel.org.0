Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7933620F68
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiKHLsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbiKHLsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:48:09 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267001145C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:48:08 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N65vG4BRvzmVbP;
        Tue,  8 Nov 2022 19:47:54 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 19:48:06 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 19:48:05 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <jiaxun.yang@flygoat.com>, <zhangqing@loongson.cn>,
        <liupeibao@loongson.cn>, <andrew@lunn.ch>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH net v2 1/3] stmmac: dwmac-loongson: fix missing pci_disable_msi() while module exiting
Date:   Tue, 8 Nov 2022 19:46:45 +0800
Message-ID: <20221108114647.4144952-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221108114647.4144952-1-yangyingliang@huawei.com>
References: <20221108114647.4144952-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_enable_msi() has been called in loongson_dwmac_probe(),
so pci_disable_msi() needs be called in remove path and error
path of probe().

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c    | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 79fa7870563b..16915b4d9505 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -125,6 +125,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (res.irq < 0) {
 		dev_err(&pdev->dev, "IRQ macirq not found\n");
 		ret = -ENODEV;
+		goto err_disable_msi;
 	}
 
 	res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
@@ -137,9 +138,18 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (res.lpi_irq < 0) {
 		dev_err(&pdev->dev, "IRQ eth_lpi not found\n");
 		ret = -ENODEV;
+		goto err_disable_msi;
 	}
 
-	return stmmac_dvr_probe(&pdev->dev, plat, &res);
+	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (ret)
+		goto err_disable_msi;
+
+	return ret;
+
+err_disable_msi:
+	pci_disable_msi(pdev);
+	return ret;
 }
 
 static void loongson_dwmac_remove(struct pci_dev *pdev)
@@ -155,6 +165,7 @@ static void loongson_dwmac_remove(struct pci_dev *pdev)
 		break;
 	}
 
+	pci_disable_msi(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.25.1

