Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEB449D7BF
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbiA0B7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:59:19 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:41698 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234871AbiA0B7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:59:14 -0500
X-UUID: f2440afa94ab4dbdb97b1d034aabda0d-20220127
X-UUID: f2440afa94ab4dbdb97b1d034aabda0d-20220127
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 259980265; Thu, 27 Jan 2022 09:59:10 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 27 Jan 2022 09:59:09 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 Jan 2022 09:59:08 +0800
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
Subject: [PATCH net-next v2 8/9] net: ethernet: mtk-star-emac: add support for MII interface
Date:   Thu, 27 Jan 2022 09:58:56 +0800
Message-ID: <20220127015857.9868-9-biao.huang@mediatek.com>
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

Add support for MII interface.
If user wants to use MII, assign "MII" to "phy-mode" property in dts.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index d5e974e0db6d..167a019fd8f5 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -193,6 +193,7 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
 #define MTK_PERICFG_REG_NIC_CFG1_CON		0x03c8
 #define MTK_PERICFG_REG_NIC_CFG_CON_V2		0x0c10
 #define MTK_PERICFG_REG_NIC_CFG_CON_CFG_INTF	GENMASK(3, 0)
+#define MTK_PERICFG_BIT_NIC_CFG_CON_MII		0
 #define MTK_PERICFG_BIT_NIC_CFG_CON_RMII	1
 #define MTK_PERICFG_BIT_NIC_CFG_CON_CLK		BIT(0)
 #define MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2	BIT(8)
@@ -1463,6 +1464,7 @@ static int mtk_star_set_timing(struct mtk_star_priv *priv)
 	unsigned int delay_val = 0;
 
 	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_MII:
 	case PHY_INTERFACE_MODE_RMII:
 		delay_val |= FIELD_PREP(MTK_STAR_BIT_INV_RX_CLK, priv->rx_inv);
 		delay_val |= FIELD_PREP(MTK_STAR_BIT_INV_TX_CLK, priv->tx_inv);
@@ -1545,7 +1547,8 @@ static int mtk_star_probe(struct platform_device *pdev)
 	ret = of_get_phy_mode(of_node, &priv->phy_intf);
 	if (ret) {
 		return ret;
-	} else if (priv->phy_intf != PHY_INTERFACE_MODE_RMII) {
+	} else if (priv->phy_intf != PHY_INTERFACE_MODE_RMII &&
+		   priv->phy_intf != PHY_INTERFACE_MODE_MII) {
 		dev_err(dev, "unsupported phy mode: %s\n",
 			phy_modes(priv->phy_intf));
 		return -EINVAL;
@@ -1610,9 +1613,12 @@ static int mt8516_set_interface_mode(struct net_device *ndev)
 {
 	struct mtk_star_priv *priv = netdev_priv(ndev);
 	struct device *dev = mtk_star_get_dev(priv);
-	unsigned int intf_val, ret, rmii_rxc;
+	unsigned int intf_val, ret, rmii_rxc = 0;
 
 	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_MII:
+		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_MII;
+		break;
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
 		rmii_rxc = priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK;
@@ -1642,6 +1648,9 @@ static int mt8365_set_interface_mode(struct net_device *ndev)
 	unsigned int intf_val;
 
 	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_MII:
+		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_MII;
+		break;
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
 		intf_val |= priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2;
-- 
2.25.1

