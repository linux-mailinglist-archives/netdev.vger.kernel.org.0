Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0F255F395
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 04:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiF2Cvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 22:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiF2Cvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 22:51:32 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2823522BD6;
        Tue, 28 Jun 2022 19:51:30 -0700 (PDT)
X-UUID: 31e2c69505a245b8acf8c6a0e4ddc400-20220629
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.7,REQID:0aa3d5fc-fec8-4678-ab5a-667e7b5683c2,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:-5
X-CID-META: VersionHash:87442a2,CLOUDID:19dce762-0b3f-4b2c-b3a6-ed5c044366a0,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 31e2c69505a245b8acf8c6a0e4ddc400-20220629
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1277345089; Wed, 29 Jun 2022 10:51:19 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 29 Jun 2022 10:51:18 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 29 Jun 2022 10:51:16 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "Fabien Parent" <fparent@baylibre.com>
CC:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Biao Huang <biao.huang@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH net-next v4 03/10] net: ethernet: mtk-star-emac: add support for MT8365 SoC
Date:   Wed, 29 Jun 2022 10:51:02 +0800
Message-ID: <20220629025109.21933-4-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629025109.21933-1-biao.huang@mediatek.com>
References: <20220629025109.21933-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index f161a55bd09a..3776af9ac1ff 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -150,6 +150,7 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
 #define MTK_STAR_REG_MAC_CLK_CONF		0x00ac
 #define MTK_STAR_MSK_MAC_CLK_CONF		GENMASK(7, 0)
 #define MTK_STAR_BIT_CLK_DIV_10			0x0a
+#define MTK_STAR_BIT_CLK_DIV_50			0x32
 
 /* Counter registers. */
 #define MTK_STAR_REG_C_RXOKPKT			0x0100
@@ -182,9 +183,11 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
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
@@ -233,6 +236,7 @@ struct mtk_star_ring {
 };
 
 struct mtk_star_compat {
+	int (*set_interface_mode)(struct net_device *ndev);
 	unsigned char bit_clk_div;
 };
 
@@ -908,13 +912,6 @@ static void mtk_star_init_config(struct mtk_star_priv *priv)
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
@@ -1530,7 +1527,13 @@ static int mtk_star_probe(struct platform_device *pdev)
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
 }
 
 #ifdef CONFIG_OF
+static int mt8516_set_interface_mode(struct net_device *ndev)
+{
+	struct mtk_star_priv *priv = netdev_priv(ndev);
+	struct device *dev = mtk_star_get_dev(priv);
+	unsigned int intf_val;
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
+	return regmap_update_bits(priv->pericfg,
+				  MTK_PERICFG_REG_NIC_CFG0_CON,
+				  MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
+				  intf_val);
+}
+
+static int mt8365_set_interface_mode(struct net_device *ndev)
+{
+	struct mtk_star_priv *priv = netdev_priv(ndev);
+	struct device *dev = mtk_star_get_dev(priv);
+	unsigned int intf_val;
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
+	return regmap_update_bits(priv->pericfg,
+				  MTK_PERICFG_REG_NIC_CFG_CON_V2,
+				  MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
+				  intf_val);
+}
+
 static const struct mtk_star_compat mtk_star_mt8516_compat = {
+	.set_interface_mode = mt8516_set_interface_mode,
 	.bit_clk_div = MTK_STAR_BIT_CLK_DIV_10,
 };
 
+static const struct mtk_star_compat mtk_star_mt8365_compat = {
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

