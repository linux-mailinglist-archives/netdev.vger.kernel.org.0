Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB22A7DBAD
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731370AbfHAMkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:40:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3733 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730319AbfHAMkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:40:32 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A512C8B9F84EAAE75344;
        Thu,  1 Aug 2019 20:40:30 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 20:40:22 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <andrew@lunn.ch>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] bcm63xx_enet: use devm_platform_ioremap_resource() to simplify code
Date:   Thu, 1 Aug 2019 20:39:08 +0800
Message-ID: <20190801123908.62396-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 291e4af..620cd3f 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1693,7 +1693,7 @@ static int bcm_enet_probe(struct platform_device *pdev)
 	struct bcm_enet_priv *priv;
 	struct net_device *dev;
 	struct bcm63xx_enet_platform_data *pd;
-	struct resource *res_mem, *res_irq, *res_irq_rx, *res_irq_tx;
+	struct resource *res_irq, *res_irq_rx, *res_irq_tx;
 	struct mii_bus *bus;
 	int i, ret;
 
@@ -1719,8 +1719,7 @@ static int bcm_enet_probe(struct platform_device *pdev)
 	if (ret)
 		goto out;
 
-	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->base = devm_ioremap_resource(&pdev->dev, res_mem);
+	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);
 		goto out;
@@ -2762,15 +2761,13 @@ struct platform_driver bcm63xx_enetsw_driver = {
 /* reserve & remap memory space shared between all macs */
 static int bcm_enet_shared_probe(struct platform_device *pdev)
 {
-	struct resource *res;
 	void __iomem *p[3];
 	unsigned int i;
 
 	memset(bcm_enet_shared_base, 0, sizeof(bcm_enet_shared_base));
 
 	for (i = 0; i < 3; i++) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		p[i] = devm_ioremap_resource(&pdev->dev, res);
+		p[i] = devm_platform_ioremap_resource(pdev, i);
 		if (IS_ERR(p[i]))
 			return PTR_ERR(p[i]);
 	}
-- 
2.7.4


