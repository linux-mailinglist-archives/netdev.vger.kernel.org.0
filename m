Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1064947C1
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358945AbiATHCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:02:54 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:60306 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1358868AbiATHCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 02:02:43 -0500
X-UUID: a7202e029b854287956135aa83f6173d-20220120
X-UUID: a7202e029b854287956135aa83f6173d-20220120
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 725971310; Thu, 20 Jan 2022 15:02:41 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 20 Jan 2022 15:02:38 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Jan 2022 15:02:37 +0800
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
Subject: [PATCH net-next v1 8/9] net: ethernet: mtk-star-emac: add support for MII interface
Date:   Thu, 20 Jan 2022 15:02:25 +0800
Message-ID: <20220120070226.1492-9-biao.huang@mediatek.com>
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

Add support for MII interface.
If user wants to use MII, assign "MII" to "phy-mode" property in dts.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index e37fa2cb5433..08a372848651 100644
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
@@ -1613,6 +1616,9 @@ static int mt8516_set_interface_mode(struct net_device *ndev)
 	unsigned int intf_val = 0, rmii_rxc = 0;
 
 	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_MII:
+		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_MII;
+		break;
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
 		rmii_rxc = priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK;
@@ -1638,6 +1644,9 @@ static int mt8365_set_interface_mode(struct net_device *ndev)
 	unsigned int intf_val = 0;
 
 	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_MII:
+		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_MII;
+		break;
 	case PHY_INTERFACE_MODE_RMII:
 		intf_val = MTK_PERICFG_BIT_NIC_CFG_CON_RMII;
 		intf_val |= priv->rmii_rxc ? 0 : MTK_PERICFG_BIT_NIC_CFG_CON_CLK_V2;
-- 
2.25.1

