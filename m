Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99587DB71
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbfHAM1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:27:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3693 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728903AbfHAM1q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:27:46 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 83F5B7044E6CEC3A93B0;
        Thu,  1 Aug 2019 20:27:44 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 20:27:37 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: dsa: b53: use devm_platform_ioremap_resource() to simplify code
Date:   Thu, 1 Aug 2019 20:27:32 +0800
Message-ID: <20190801122732.37216-1-yuehaibing@huawei.com>
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
 drivers/net/dsa/b53/b53_srab.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index d9c56a7..0a1be52 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -536,7 +536,6 @@ static void b53_srab_mux_init(struct platform_device *pdev)
 	struct b53_device *dev = platform_get_drvdata(pdev);
 	struct b53_srab_priv *priv = dev->priv;
 	struct b53_srab_port_priv *p;
-	struct resource *r;
 	unsigned int port;
 	u32 reg, off = 0;
 	int ret;
@@ -544,8 +543,7 @@ static void b53_srab_mux_init(struct platform_device *pdev)
 	if (dev->pdata && dev->pdata->chip_id != BCM58XX_DEVICE_ID)
 		return;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	priv->mux_config = devm_ioremap_resource(&pdev->dev, r);
+	priv->mux_config = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(priv->mux_config))
 		return;
 
@@ -593,7 +591,6 @@ static int b53_srab_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id = NULL;
 	struct b53_srab_priv *priv;
 	struct b53_device *dev;
-	struct resource *r;
 
 	if (dn)
 		of_id = of_match_node(b53_srab_of_match, dn);
@@ -610,8 +607,7 @@ static int b53_srab_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->regs = devm_ioremap_resource(&pdev->dev, r);
+	priv->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->regs))
 		return -ENOMEM;
 
-- 
2.7.4


