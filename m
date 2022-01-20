Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 515374947AE
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358860AbiATHCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:02:42 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:60032 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1358819AbiATHCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 02:02:38 -0500
X-UUID: 9951080691e842b2b880ea06bb800532-20220120
X-UUID: 9951080691e842b2b880ea06bb800532-20220120
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1604621939; Thu, 20 Jan 2022 15:02:34 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 20 Jan 2022 15:02:33 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Jan 2022 15:02:32 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        "John Crispin" <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        <srv_heupstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v1 3/9] net: ethernet: mtk-star-emac: add support for MT8365 SoC
Date:   Thu, 20 Jan 2022 15:02:20 +0800
Message-ID: <20220120070226.1492-4-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220120070226.1492-1-biao.huang@mediatek.com>
References: <20220120070226.1492-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Ethernet driver support for MT8365 SoC.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
Signed-off-by: Fabien Parent <fparent@baylibre.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 75 ++++++++++++++++---
 1 file changed, 64 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 7c2af775d601..403439782db9 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -151,6 +151,7 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
 #define MTK_STAR_REG_MAC_CLK_CONF		0x00ac
 #define MTK_STAR_MSK_MAC_CLK_CONF		GENMASK(7, 0)
 #define MTK_STAR_BIT_CLK_DIV_10			0x0a
+#define MTK_STAR_BIT_CLK_DIV_50			0x32
 
 /* Counter registers. */
 #define MTK_STAR_REG_C_RXOKPKT			0x0100
@@ -183,9 +184,11 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
 #define MTK_STAR_REG_C_RX_TWIST			0x0218
 
 /* Ethernet CFG Control */
-#define MTK_PERICFG_REG_NIC_CFG_CON		0x03c4
-#define MTK_PERICFG_MSK_NIC_CFG_CON_CFG_MII	GENMASK(3, 0)
-#define MTK_PERICFG_BIT_NIC_CFG_CON_RMII	BIT(0)
+#define MTK_PERICFG_REG_NIC_CFG0_CON		0x03c4
+#define MTK_PERICFG_REG_NIC_CFG1_CON		0x03c8
+#define MTK_PERICFG_REG_NIC_CFG_CON_V2		0x0c10
+#define MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF	GENMASK(3, 0)
+#define MTK_PERICFG_BIT_NIC_CFG_CON_RMII	1
 
 /* Represents the actual structure of descriptors used by the MAC. We can
  * reuse the same structure for both TX and RX - the layout is the same, only
@@ -234,6 +237,7 @@ struct mtk_star_ring {
 };
 
 struct mtk_star_compat {
+	int (*set_interface_mode)(struct net_device *ndev);
 	unsigned char bit_clk_div;
 };
 
@@ -909,13 +913,6 @@ static void mtk_star_init_config(struct mtk_star_priv *priv)
 			   priv->compat_data->bit_clk_div);
 }
 
-static void mtk_star_set_mode_rmii(struct mtk_star_priv *priv)
-{
-	regmap_update_bits(priv->pericfg, MTK_PERICFG_REG_NIC_CFG_CON,
-			   MTK_PERICFG_MSK_NIC_CFG_CON_CFG_MII,
-			   MTK_PERICFG_BIT_NIC_CFG_CON_RMII);
-}
-
 static int mtk_star_enable(struct net_device *ndev)
 {
 	struct mtk_star_priv *priv = netdev_priv(ndev);
@@ -1531,7 +1528,13 @@ static int mtk_star_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	mtk_star_set_mode_rmii(priv);
+	if (priv->compat_data->set_interface_mode) {
+		ret = priv->compat_data->set_interface_mode(ndev);
+		if (ret) {
+			dev_err(dev, "Failed to set phy interface, err = %d\n", ret);
+			return -EINVAL;
+		}
+	}
 
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret) {
@@ -1564,10 +1567,58 @@ static int mtk_star_probe(struct platform_device *pdev)
 	return devm_register_netdev(dev, ndev);
 }
 
+static int mt8516_set_interface_mode(struct net_device *ndev)
+{
+	struct mtk_star_priv *priv = netdev_priv(ndev);
+	struct device *dev = mtk_star_get_dev(priv);
+	unsigned int intf_val = 0;
+
+	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_RMII:
+		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
+		break;
+	default:
+		dev_err(dev, "This interface not supported\n");
+		return -EINVAL;
+	}
+
+	regmap_update_bits(priv->pericfg, MTK_PERICFG_REG_NIC_CFG0_CON,
+			   MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
+			   intf_val);
+	return 0;
+}
+
+static int mt8365_set_interface_mode(struct net_device *ndev)
+{
+	struct mtk_star_priv *priv = netdev_priv(ndev);
+	struct device *dev = mtk_star_get_dev(priv);
+	unsigned int intf_val = 0;
+
+	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_RMII:
+		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
+		break;
+	default:
+		dev_err(dev, "This interface not supported\n");
+		return -EINVAL;
+	}
+
+	regmap_update_bits(priv->pericfg, MTK_PERICFG_REG_NIC_CFG_CON_V2,
+			   MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
+			   intf_val);
+	return 0;
+}
+
 static struct mtk_star_compat mtk_star_mt8516_compat = {
+	.set_interface_mode = mt8516_set_interface_mode,
 	.bit_clk_div = MTK_STAR_BIT_CLK_DIV_10,
 };
 
+static struct mtk_star_compat mtk_star_mt8365_compat = {
+	.set_interface_mode = mt8365_set_interface_mode,
+	.bit_clk_div = MTK_STAR_BIT_CLK_DIV_50,
+};
+
 static const struct of_device_id mtk_star_of_match[] = {
 	{ .compatible = "mediatek,mt8516-eth",
 	  .data = &mtk_star_mt8516_compat },
@@ -1575,6 +1626,8 @@ static const struct of_device_id mtk_star_of_match[] = {
 	  .data = &mtk_star_mt8516_compat },
 	{ .compatible = "mediatek,mt8175-eth",
 	  .data = &mtk_star_mt8516_compat },
+	{ .compatible = "mediatek,mt8365-eth",
+	  .data = &mtk_star_mt8365_compat },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, mtk_star_of_match);
-- 
2.25.1

