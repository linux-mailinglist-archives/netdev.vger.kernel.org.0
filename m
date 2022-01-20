Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568E84947BA
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358910AbiATHCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:02:52 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:60306 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1358855AbiATHCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 02:02:42 -0500
X-UUID: 4ceba44099a34812bacbbb28f3531204-20220120
X-UUID: 4ceba44099a34812bacbbb28f3531204-20220120
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 444237999; Thu, 20 Jan 2022 15:02:37 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 20 Jan 2022 15:02:36 +0800
Received: from localhost.localdomain (10.17.3.154) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Jan 2022 15:02:35 +0800
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
Subject: [PATCH net-next v1 6/9] net: ethernet: mtk-star-emac: add timing adjustment support
Date:   Thu, 20 Jan 2022 15:02:23 +0800
Message-ID: <20220120070226.1492-7-biao.huang@mediatek.com>
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

Add simple clock inversion for timing adjustment in driver.
Add property "mediatek,txc-inverse" or "mediatek,rxc-inverse" to
device node when necessary.

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Signed-off-by: Yinghua Pan <ot_yinghua.pan@mediatek.com>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index ab2fe72fdd6a..e37fa2cb5433 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -131,6 +131,11 @@ static const char *const mtk_star_clk_names[] = { "core", "reg", "trans" };
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
@@ -268,6 +273,8 @@ struct mtk_star_priv {
 	int duplex;
 	int pause;
 	bool rmii_rxc;
+	bool rx_inv;
+	bool tx_inv;
 
 	const struct mtk_star_compat *compat_data;
 
@@ -1450,6 +1457,25 @@ static void mtk_star_clk_disable_unprepare(void *data)
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
+	regmap_write(priv->regs, MTK_STAR_REG_TEST0, delay_val);
+
+	return 0;
+}
 static int mtk_star_probe(struct platform_device *pdev)
 {
 	struct device_node *of_node;
@@ -1532,6 +1558,8 @@ static int mtk_star_probe(struct platform_device *pdev)
 	}
 
 	priv->rmii_rxc = of_property_read_bool(of_node, "mediatek,rmii-rxc");
+	priv->rx_inv = of_property_read_bool(of_node, "mediatek,rxc-inverse");
+	priv->tx_inv = of_property_read_bool(of_node, "mediatek,txc-inverse");
 
 	if (priv->compat_data->set_interface_mode) {
 		ret = priv->compat_data->set_interface_mode(ndev);
@@ -1541,6 +1569,12 @@ static int mtk_star_probe(struct platform_device *pdev)
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

