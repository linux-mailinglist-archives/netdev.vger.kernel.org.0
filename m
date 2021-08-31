Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E80B3FC414
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 10:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240169AbhHaIDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 04:03:36 -0400
Received: from mx21.baidu.com ([220.181.3.85]:59688 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240095AbhHaIDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 04:03:35 -0400
Received: from BC-Mail-Ex05.internal.baidu.com (unknown [172.31.51.45])
        by Forcepoint Email with ESMTPS id 0468D693D23B642341E5;
        Tue, 31 Aug 2021 16:02:38 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex05.internal.baidu.com (172.31.51.45) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 31 Aug 2021 16:02:37 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 31 Aug 2021 16:02:37 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <gsomlo@gmail.com>,
        <asmaa@nvidia.com>, <limings@nvidia.com>, <jgg@ziepe.ca>,
        <davthompson@nvidia.com>
CC:     <netdev@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] net/mlxbf_gige: Make use of devm_platform_ioremap_resourcexxx()
Date:   Tue, 31 Aug 2021 16:02:31 +0800
Message-ID: <20210831080231.878-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex05.internal.baidu.com (10.127.64.15) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the devm_platform_ioremap_resource_byname() helper instead of
calling platform_get_resource_byname() and devm_ioremap_resource()
separately

Use the devm_platform_ioremap_resource() helper instead of
calling platform_get_resource() and devm_ioremap_resource()
separately

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/litex/litex_liteeth.c    |  7 ++-----
 .../mellanox/mlxbf_gige/mlxbf_gige_main.c     | 21 +++----------------
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio.c     |  7 +------
 drivers/net/ethernet/ni/nixge.c               | 10 +++------
 4 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
index 10e6f2dedfad..a9bdbf0dcfe1 100644
--- a/drivers/net/ethernet/litex/litex_liteeth.c
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -227,7 +227,6 @@ static int liteeth_probe(struct platform_device *pdev)
 {
 	struct net_device *netdev;
 	void __iomem *buf_base;
-	struct resource *res;
 	struct liteeth *priv;
 	int irq, err;
 
@@ -249,13 +248,11 @@ static int liteeth_probe(struct platform_device *pdev)
 	}
 	netdev->irq = irq;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mac");
-	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	priv->base = devm_platform_ioremap_resource_byname(pdev, "mac");
 	if (IS_ERR(priv->base))
 		return PTR_ERR(priv->base);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "buffer");
-	buf_base = devm_ioremap_resource(&pdev->dev, res);
+	buf_base = devm_platform_ioremap_resource_byname(pdev, "buffer");
 	if (IS_ERR(buf_base))
 		return PTR_ERR(buf_base);
 
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index d22219613719..3e85b17f5857 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -269,9 +269,6 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 {
 	struct phy_device *phydev;
 	struct net_device *netdev;
-	struct resource *mac_res;
-	struct resource *llu_res;
-	struct resource *plu_res;
 	struct mlxbf_gige *priv;
 	void __iomem *llu_base;
 	void __iomem *plu_base;
@@ -280,27 +277,15 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	int addr;
 	int err;
 
-	mac_res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_MAC);
-	if (!mac_res)
-		return -ENXIO;
-
-	base = devm_ioremap_resource(&pdev->dev, mac_res);
+	base = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MAC);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	llu_res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_LLU);
-	if (!llu_res)
-		return -ENXIO;
-
-	llu_base = devm_ioremap_resource(&pdev->dev, llu_res);
+	llu_base = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_LLU);
 	if (IS_ERR(llu_base))
 		return PTR_ERR(llu_base);
 
-	plu_res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_PLU);
-	if (!plu_res)
-		return -ENXIO;
-
-	plu_base = devm_ioremap_resource(&pdev->dev, plu_res);
+	plu_base = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_PLU);
 	if (IS_ERR(plu_base))
 		return PTR_ERR(plu_base);
 
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index e32dd34fdcc0..7905179a9575 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -145,14 +145,9 @@ static int mlxbf_gige_mdio_write(struct mii_bus *bus, int phy_add,
 int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
 {
 	struct device *dev = &pdev->dev;
-	struct resource *res;
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, MLXBF_GIGE_RES_MDIO9);
-	if (!res)
-		return -ENODEV;
-
-	priv->mdio_io = devm_ioremap_resource(dev, res);
+	priv->mdio_io = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MDIO9);
 	if (IS_ERR(priv->mdio_io))
 		return PTR_ERR(priv->mdio_io);
 
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 36fe2c0f31ff..346145d3180e 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1229,7 +1229,6 @@ static int nixge_of_get_resources(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id;
 	enum nixge_version version;
-	struct resource *ctrlres;
 	struct net_device *ndev;
 	struct nixge_priv *priv;
 
@@ -1248,13 +1247,10 @@ static int nixge_of_get_resources(struct platform_device *pdev)
 		netdev_err(ndev, "failed to map dma regs\n");
 		return PTR_ERR(priv->dma_regs);
 	}
-	if (version <= NIXGE_V2) {
+	if (version <= NIXGE_V2)
 		priv->ctrl_regs = priv->dma_regs + NIXGE_REG_CTRL_OFFSET;
-	} else {
-		ctrlres = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						       "ctrl");
-		priv->ctrl_regs = devm_ioremap_resource(&pdev->dev, ctrlres);
-	}
+	else
+		priv->ctrl_regs = devm_platform_ioremap_resource_byname(pdev, "ctrl");
 	if (IS_ERR(priv->ctrl_regs)) {
 		netdev_err(ndev, "failed to map ctrl regs\n");
 		return PTR_ERR(priv->ctrl_regs);
-- 
2.25.1

