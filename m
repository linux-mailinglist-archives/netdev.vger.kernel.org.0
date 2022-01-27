Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8346B49D7B7
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbiA0B7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:59:17 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:41548 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234786AbiA0B7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:59:10 -0500
X-UUID: efa5da12b9f54990af1a8fe571c71682-20220127
X-UUID: efa5da12b9f54990af1a8fe571c71682-20220127
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1421973521; Thu, 27 Jan 2022 09:59:07 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 27 Jan 2022 09:59:05 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 09:59:04 +0800
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
Subject: [PATCH net-next v2 5/9] net: ethernet: mtk-star-emac: add clock pad selection for RMII
Date:   Thu, 27 Jan 2022 09:58:53 +0800
Message-ID: <20220127015857.9868-6-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220127015857.9868-1-biao.huang@mediatek.com>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a new dts property named "mediatek,rmii-rxc" parsing
in driver, which will configure MAC to select which pin the RMII reference
clock is connected to, TXC or RXC.

TXC pad is the default reference clock pin. If user wants to use RXC pad
instead, add "mediatek,rmii-rxc" to corresponding device node.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index a3884beaa3fe..d69f75661e75 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -189,6 +189,8 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
 #define MTK_PERICFG_REG_NIC_CFG_CON_V2		0x0c10
 #define MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF	GENMASK(3, 0)
 #define MTK_PERICFG_BIT_NIC_CFG_CON_RMII	1
+#define MTK_PERICFG_BIT_NIC_CFG_CON_CLK		BIT(0)
+#define MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2	BIT(8)
 
 /* Represents the actual structure of descriptors used by the MAC. We can
  * reuse the same structure for both TX and RX - the layout is the same, only
@@ -265,6 +267,7 @@ struct mtk_star_priv {
 	int speed;
 	int duplex;
 	int pause;
+	bool rmii_rxc;
 
 	const struct mtk_star_compat *compat_data;
 
@@ -1528,6 +1531,8 @@ static int mtk_star_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	priv->rmii_rxc = of_property_read_bool(of_node, "mediatek,rmii-rxc");
+
 	if (priv->compat_data->set_interface_mode) {
 		ret = priv->compat_data->set_interface_mode(ndev);
 		if (ret) {
@@ -1571,17 +1576,25 @@ static int mt8516_set_interface_mode(struct net_device *ndev)
 {
 	struct mtk_star_priv *priv = netdev_priv(ndev);
 	struct device *dev = mtk_star_get_dev(priv);
-	unsigned int intf_val;
+	unsigned int intf_val, ret, rmii_rxc;
 
 	switch (priv->phy_intf) {
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
+		rmii_rxc = priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK;
 		break;
 	default:
 		dev_err(dev, "This interface not supported\n");
 		return -EINVAL;
 	}
 
+	ret = regmap_update_bits(priv->pericfg,
+				 MTK_PERICFG_REG_NIC_CFG1_CON,
+				 MTK_PERICFG_BIT_NIC_CFG_CON_CLK,
+				 rmii_rxc);
+	if (ret)
+		return ret;
+
 	return regmap_update_bits(priv->pericfg,
 				  MTK_PERICFG_REG_NIC_CFG0_CON,
 				  MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
@@ -1597,6 +1610,7 @@ static int mt8365_set_interface_mode(struct net_device *ndev)
 	switch (priv->phy_intf) {
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
+		intf_val |= priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2;
 		break;
 	default:
 		dev_err(dev, "This interface not supported\n");
@@ -1605,7 +1619,8 @@ static int mt8365_set_interface_mode(struct net_device *ndev)
 
 	return regmap_update_bits(priv->pericfg,
 				  MTK_PERICFG_REG_NIC_CFG_CON_V2,
-				  MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF,
+				  MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF |
+				  MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2,
 				  intf_val);
 }
 
-- 
2.25.1

