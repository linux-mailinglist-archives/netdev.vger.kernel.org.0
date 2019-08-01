Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357EA7DB52
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbfHAMWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:22:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52218 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728791AbfHAMWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:22:33 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CB7B23117771CD2C9A52;
        Thu,  1 Aug 2019 20:22:31 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 20:22:21 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <antoine.tenart@bootlin.com>,
        <maxime.chevallier@bootlin.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] mvpp2: use devm_platform_ioremap_resource() to simplify code
Date:   Thu, 1 Aug 2019 20:22:02 +0800
Message-ID: <20190801122202.7800-1-yuehaibing@huawei.com>
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
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 937e4b9..e9d8ffe 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5014,7 +5014,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	struct device_node *port_node = to_of_node(port_fwnode);
 	netdev_features_t features;
 	struct net_device *dev;
-	struct resource *res;
 	struct phylink *phylink;
 	char *mac_from = "";
 	unsigned int ntxqs, nrxqs, thread;
@@ -5118,8 +5117,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	port->comphy = comphy;
 
 	if (priv->hw_version == MVPP21) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 2 + id);
-		port->base = devm_ioremap_resource(&pdev->dev, res);
+		port->base = devm_platform_ioremap_resource(pdev, 2 + id);
 		if (IS_ERR(port->base)) {
 			err = PTR_ERR(port->base);
 			goto err_free_irq;
@@ -5551,14 +5549,12 @@ static int mvpp2_probe(struct platform_device *pdev)
 	if (priv->hw_version == MVPP21)
 		queue_mode = MVPP2_QDIST_SINGLE_MODE;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, res);
+	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
 	if (priv->hw_version == MVPP21) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		priv->lms_base = devm_ioremap_resource(&pdev->dev, res);
+		priv->lms_base = devm_platform_ioremap_resource(pdev, 1);
 		if (IS_ERR(priv->lms_base))
 			return PTR_ERR(priv->lms_base);
 	} else {
-- 
2.7.4


