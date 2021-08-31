Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFD63FC404
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 10:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbhHaIAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 04:00:01 -0400
Received: from mx20.baidu.com ([111.202.115.85]:54478 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240092AbhHaH7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 03:59:45 -0400
Received: from BC-Mail-HQEx02.internal.baidu.com (unknown [172.31.51.58])
        by Forcepoint Email with ESMTPS id 924A0CEA675C82569A4B;
        Tue, 31 Aug 2021 15:58:25 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-HQEx02.internal.baidu.com (172.31.51.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 31 Aug 2021 15:58:24 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 31 Aug 2021 15:58:25 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] net: mdio: mscc-miim: Make use of the helper function devm_platform_ioremap_resource()
Date:   Tue, 31 Aug 2021 15:58:18 +0800
Message-ID: <20210831075818.833-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex12.internal.baidu.com (172.31.51.52) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the devm_platform_ioremap_resource() helper instead of
calling platform_get_resource() and devm_ioremap_resource()
separately

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 2d67e12c8262..1ee592d3eae4 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -134,7 +134,6 @@ static int mscc_miim_reset(struct mii_bus *bus)
 
 static int mscc_miim_probe(struct platform_device *pdev)
 {
-	struct resource *res;
 	struct mii_bus *bus;
 	struct mscc_miim_dev *dev;
 	int ret;
@@ -157,13 +156,10 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return PTR_ERR(dev->regs);
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (res) {
-		dev->phy_regs = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(dev->phy_regs)) {
-			dev_err(&pdev->dev, "Unable to map internal phy registers\n");
-			return PTR_ERR(dev->phy_regs);
-		}
+	dev->phy_regs = devm_platform_ioremap_resource(pdev, 1);
+	if (IS_ERR(dev->phy_regs)) {
+		dev_err(&pdev->dev, "Unable to map internal phy registers\n");
+		return PTR_ERR(dev->phy_regs);
 	}
 
 	ret = of_mdiobus_register(bus, pdev->dev.of_node);
-- 
2.25.1

