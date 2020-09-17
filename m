Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6230F26D3EE
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgIQGt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:49:59 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60136 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726106AbgIQGt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 02:49:59 -0400
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 02:49:58 EDT
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F07A2AB09F246D0E5BCC;
        Thu, 17 Sep 2020 14:34:19 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Thu, 17 Sep 2020
 14:34:11 +0800
From:   Wang Xiaojun <wangxiaojun11@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH -next] can: ti_hecc: use devm_platform_ioremap_resource_byname
Date:   Thu, 17 Sep 2020 14:36:34 +0800
Message-ID: <20200917063634.2183792-1-wangxiaojun11@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the devm_platform_ioremap_resource_byname() helper instead of
calling platform_get_resource_byname() and devm_ioremap_resource()
separately.

Signed-off-by: Wang Xiaojun <wangxiaojun11@huawei.com>
---
 drivers/net/can/ti_hecc.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/net/can/ti_hecc.c b/drivers/net/can/ti_hecc.c
index 94b1491b569f..d2712de34b74 100644
--- a/drivers/net/can/ti_hecc.c
+++ b/drivers/net/can/ti_hecc.c
@@ -857,7 +857,7 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	struct net_device *ndev = (struct net_device *)0;
 	struct ti_hecc_priv *priv;
 	struct device_node *np = pdev->dev.of_node;
-	struct resource *res, *irq;
+	struct resource *irq;
 	struct regulator *reg_xceiver;
 	int err = -ENODEV;
 
@@ -878,39 +878,22 @@ static int ti_hecc_probe(struct platform_device *pdev)
 	priv = netdev_priv(ndev);
 
 	/* handle hecc memory */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "hecc");
-	if (!res) {
-		dev_err(&pdev->dev, "can't get IORESOURCE_MEM hecc\n");
-		return -EINVAL;
-	}
-
-	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	priv->base = devm_platform_ioremap_resource_byname(pdev, "hecc");
 	if (IS_ERR(priv->base)) {
 		dev_err(&pdev->dev, "hecc ioremap failed\n");
 		return PTR_ERR(priv->base);
 	}
 
 	/* handle hecc-ram memory */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "hecc-ram");
-	if (!res) {
-		dev_err(&pdev->dev, "can't get IORESOURCE_MEM hecc-ram\n");
-		return -EINVAL;
-	}
-
-	priv->hecc_ram = devm_ioremap_resource(&pdev->dev, res);
+	priv->hecc_ram = devm_platform_ioremap_resource_byname(pdev,
+						"hecc-ram");
 	if (IS_ERR(priv->hecc_ram)) {
 		dev_err(&pdev->dev, "hecc-ram ioremap failed\n");
 		return PTR_ERR(priv->hecc_ram);
 	}
 
 	/* handle mbx memory */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mbx");
-	if (!res) {
-		dev_err(&pdev->dev, "can't get IORESOURCE_MEM mbx\n");
-		return -EINVAL;
-	}
-
-	priv->mbx = devm_ioremap_resource(&pdev->dev, res);
+	priv->mbx = devm_platform_ioremap_resource_byname(pdev, "mbx");
 	if (IS_ERR(priv->mbx)) {
 		dev_err(&pdev->dev, "mbx ioremap failed\n");
 		return PTR_ERR(priv->mbx);
-- 
2.25.1

