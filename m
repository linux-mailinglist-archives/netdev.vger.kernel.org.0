Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F205547D6
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356276AbiFVJGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356156AbiFVJGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:06:07 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD96D201B8;
        Wed, 22 Jun 2022 02:06:05 -0700 (PDT)
X-UUID: 28b84861db294d038fb93f297ce98955-20220622
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.6,REQID:47d657fa-8183-4043-8c2a-cf5a3d4589c5,OB:30,L
        OB:20,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham
        ,ACTION:release,TS:95
X-CID-INFO: VERSION:1.1.6,REQID:47d657fa-8183-4043-8c2a-cf5a3d4589c5,OB:30,LOB
        :20,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D
        ,ACTION:quarantine,TS:95
X-CID-META: VersionHash:b14ad71,CLOUDID:fdcbbd2d-1756-4fa3-be7f-474a6e4be921,C
        OID:bd337299e01f,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 28b84861db294d038fb93f297ce98955-20220622
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1200368744; Wed, 22 Jun 2022 17:05:58 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 22 Jun 2022 17:05:55 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Wed, 22 Jun 2022 17:05:54 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Fabien Parent <fparent@baylibre.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
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
Subject: [PATCH net-next v3 06/10] net: ethernet: mtk-star-emac: add timing adjustment support
Date:   Wed, 22 Jun 2022 17:05:41 +0800
Message-ID: <20220622090545.23612-7-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220622090545.23612-1-biao.huang@mediatek.com>
References: <20220622090545.23612-1-biao.huang@mediatek.com>
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

Add simple clock inversion for timing adjustment in driver.
Add property "mediatek,txc-inverse" or "mediatek,rxc-inverse" to
device node when necessary.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index b4d37728be69..d0fa45007bbd 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -130,6 +130,11 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
 #define MTK_STAR_REG_INT_MASK			0x0054
 #define MTK_STAR_BIT_INT_MASK_FNRC		BIT(6)
 
+/* Delay-Macro Register */
+#define MTK_STAR_REG_TEST0			0x0058
+#define MTK_STAR_BIT_INV_RX_CLK			BIT(30)
+#define MTK_STAR_BIT_INV_TX_CLK			BIT(31)
+
 /* Misc. Config Register */
 #define MTK_STAR_REG_TEST1			0x005c
 #define MTK_STAR_BIT_TEST1_RST_HASH_MBIST	BIT(31)
@@ -267,6 +272,8 @@ struct mtk_star_priv {
 	int duplex;
 	int pause;
 	bool rmii_rxc;
+	bool rx_inv;
+	bool tx_inv;
 
 	const struct mtk_star_compat *compat_data;
 
@@ -1449,6 +1456,23 @@ static void mtk_star_clk_disable_unprepare(void *data)
 	clk_bulk_disable_unprepare(MTK_STAR_NCLKS, priv->clks);
 }
 
+static int mtk_star_set_timing(struct mtk_star_priv *priv)
+{
+	struct device *dev = mtk_star_get_dev(priv);
+	unsigned int delay_val = 0;
+
+	switch (priv->phy_intf) {
+	case PHY_INTERFACE_MODE_RMII:
+		delay_val |= FIELD_PREP(MTK_STAR_BIT_INV_RX_CLK, priv->rx_inv);
+		delay_val |= FIELD_PREP(MTK_STAR_BIT_INV_TX_CLK, priv->tx_inv);
+		break;
+	default:
+		dev_err(dev, "This interface not supported\n");
+		return -EINVAL;
+	}
+
+	return regmap_write(priv->regs, MTK_STAR_REG_TEST0, delay_val);
+}
 static int mtk_star_probe(struct platform_device *pdev)
 {
 	struct device_node *of_node;
@@ -1531,6 +1555,8 @@ static int mtk_star_probe(struct platform_device *pdev)
 	}
 
 	priv->rmii_rxc = of_property_read_bool(of_node, "mediatek,rmii-rxc");
+	priv->rx_inv = of_property_read_bool(of_node, "mediatek,rxc-inverse");
+	priv->tx_inv = of_property_read_bool(of_node, "mediatek,txc-inverse");
 
 	if (priv->compat_data->set_interface_mode) {
 		ret = priv->compat_data->set_interface_mode(ndev);
@@ -1540,6 +1566,12 @@ static int mtk_star_probe(struct platform_device *pdev)
 		}
 	}
 
+	ret = mtk_star_set_timing(priv);
+	if (ret) {
+		dev_err(dev, "Failed to set timing, err = %d\n", ret);
+		return -EINVAL;
+	}
+
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (ret) {
 		dev_err(dev, "unsupported DMA mask\n");
-- 
2.25.1

