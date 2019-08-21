Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D839797B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 14:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfHUMck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 08:32:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52346 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726835AbfHUMck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 08:32:40 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AA12EC60DE1C73105FDE;
        Wed, 21 Aug 2019 20:32:35 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 20:32:27 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <thomas.lendacky@amd.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] amd-xgbe: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 21 Aug 2019 20:32:03 +0800
Message-ID: <20190821123203.71404-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_platform_ioremap_resource() to simplify the code a bit.
This is detected by coccinelle.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-platform.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
index dce9e59..4ebd241 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
@@ -301,7 +301,6 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 	struct xgbe_prv_data *pdata;
 	struct device *dev = &pdev->dev;
 	struct platform_device *phy_pdev;
-	struct resource *res;
 	const char *phy_mode;
 	unsigned int phy_memnum, phy_irqnum;
 	unsigned int dma_irqnum, dma_irqend;
@@ -353,8 +352,7 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 	}
 
 	/* Obtain the mmio areas for the device */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	pdata->xgmac_regs = devm_ioremap_resource(dev, res);
+	pdata->xgmac_regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pdata->xgmac_regs)) {
 		dev_err(dev, "xgmac ioremap failed\n");
 		ret = PTR_ERR(pdata->xgmac_regs);
@@ -363,8 +361,7 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 	if (netif_msg_probe(pdata))
 		dev_dbg(dev, "xgmac_regs = %p\n", pdata->xgmac_regs);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	pdata->xpcs_regs = devm_ioremap_resource(dev, res);
+	pdata->xpcs_regs = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(pdata->xpcs_regs)) {
 		dev_err(dev, "xpcs ioremap failed\n");
 		ret = PTR_ERR(pdata->xpcs_regs);
@@ -373,8 +370,8 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 	if (netif_msg_probe(pdata))
 		dev_dbg(dev, "xpcs_regs  = %p\n", pdata->xpcs_regs);
 
-	res = platform_get_resource(phy_pdev, IORESOURCE_MEM, phy_memnum++);
-	pdata->rxtx_regs = devm_ioremap_resource(dev, res);
+	pdata->rxtx_regs = devm_platform_ioremap_resource(phy_pdev,
+							  phy_memnum++);
 	if (IS_ERR(pdata->rxtx_regs)) {
 		dev_err(dev, "rxtx ioremap failed\n");
 		ret = PTR_ERR(pdata->rxtx_regs);
@@ -383,8 +380,8 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 	if (netif_msg_probe(pdata))
 		dev_dbg(dev, "rxtx_regs  = %p\n", pdata->rxtx_regs);
 
-	res = platform_get_resource(phy_pdev, IORESOURCE_MEM, phy_memnum++);
-	pdata->sir0_regs = devm_ioremap_resource(dev, res);
+	pdata->sir0_regs = devm_platform_ioremap_resource(phy_pdev,
+							  phy_memnum++);
 	if (IS_ERR(pdata->sir0_regs)) {
 		dev_err(dev, "sir0 ioremap failed\n");
 		ret = PTR_ERR(pdata->sir0_regs);
@@ -393,8 +390,8 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 	if (netif_msg_probe(pdata))
 		dev_dbg(dev, "sir0_regs  = %p\n", pdata->sir0_regs);
 
-	res = platform_get_resource(phy_pdev, IORESOURCE_MEM, phy_memnum++);
-	pdata->sir1_regs = devm_ioremap_resource(dev, res);
+	pdata->sir1_regs = devm_platform_ioremap_resource(phy_pdev,
+							  phy_memnum++);
 	if (IS_ERR(pdata->sir1_regs)) {
 		dev_err(dev, "sir1 ioremap failed\n");
 		ret = PTR_ERR(pdata->sir1_regs);
-- 
2.7.4


