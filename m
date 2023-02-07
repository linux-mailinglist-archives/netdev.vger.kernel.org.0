Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF7F68DA80
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjBGOWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbjBGOW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:22:27 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBB636093;
        Tue,  7 Feb 2023 06:22:19 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pPOrQ-00029V-2y;
        Tue, 07 Feb 2023 15:22:17 +0100
Date:   Tue, 7 Feb 2023 14:20:40 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: [PATCH v2 04/11] net: ethernet: mtk_eth_soc: set MDIO bus clock
 frequency
Message-ID: <4bd0d0c834b7e8852504f27fc2db586b3c95979e.1675779094.git.daniel@makrotopia.org>
References: <cover.1675779094.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675779094.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set MDIO bus clock frequency and allow setting a custom maximum
frquency from device tree.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 21 +++++++++++++++++++++
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  7 +++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index fc5174f83ef1..4ee582e39c12 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -789,8 +789,10 @@ static const struct phylink_mac_ops mtk_phylink_ops = {
 
 static int mtk_mdio_init(struct mtk_eth *eth)
 {
+	unsigned int max_clk = 2500000, divider;
 	struct device_node *mii_np;
 	int ret;
+	u32 val;
 
 	mii_np = of_get_child_by_name(eth->dev->of_node, "mdio-bus");
 	if (!mii_np) {
@@ -818,6 +820,25 @@ static int mtk_mdio_init(struct mtk_eth *eth)
 	eth->mii_bus->parent = eth->dev;
 
 	snprintf(eth->mii_bus->id, MII_BUS_ID_SIZE, "%pOFn", mii_np);
+
+	if (!of_property_read_u32(mii_np, "clock-frequency", &val)) {
+		if (val > MDC_MAX_FREQ || val < MDC_MAX_FREQ / MDC_MAX_DIVIDER) {
+			dev_err(eth->dev, "MDIO clock frequency out of range");
+			ret = -EINVAL;
+			goto err_put_node;
+		}
+		max_clk = val;
+	}
+	divider = min_t(unsigned int, DIV_ROUND_UP(MDC_MAX_FREQ, max_clk), 63);
+
+	/* Configure MDC Divider */
+	val = mtk_r32(eth, MTK_PPSC);
+	val &= ~PPSC_MDC_CFG;
+	val |= FIELD_PREP(PPSC_MDC_CFG, divider) | PPSC_MDC_TURBO;
+	mtk_w32(eth, val, MTK_PPSC);
+
+	dev_dbg(eth->dev, "MDC is running on %d Hz\n", MDC_MAX_FREQ / divider);
+
 	ret = of_mdiobus_register(eth->mii_bus, mii_np);
 
 err_put_node:
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 7230dcb29315..7014c02ba2d4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -363,6 +363,13 @@
 #define RX_DMA_VTAG_V2		BIT(0)
 #define RX_DMA_L4_VALID_V2	BIT(2)
 
+/* PHY Polling and SMI Master Control registers */
+#define MTK_PPSC		0x10000
+#define PPSC_MDC_CFG		GENMASK(29, 24)
+#define PPSC_MDC_TURBO		BIT(20)
+#define MDC_MAX_FREQ		25000000
+#define MDC_MAX_DIVIDER		63
+
 /* PHY Indirect Access Control registers */
 #define MTK_PHY_IAC		0x10004
 #define PHY_IAC_ACCESS		BIT(31)
-- 
2.39.1

