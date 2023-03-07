Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2077E6AE5A8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjCGP7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbjCGP6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:58:13 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CAF9079A;
        Tue,  7 Mar 2023 07:57:03 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZZgS-0001vB-21;
        Tue, 07 Mar 2023 16:57:00 +0100
Date:   Tue, 7 Mar 2023 15:55:24 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
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
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v12 15/18] net: ethernet: mtk_eth_soc: move MAX_DEVS
 in mtk_soc_data
Message-ID: <5667bbae0ca9d261894ef1bab7c9578ec48ada72.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1678201958.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

This is a preliminary patch to add MT7988 SoC support since it runs 3
macs instead of 2.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 34 +++++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 11 +++----
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e34065e17446..c858f21f603c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4082,7 +4082,10 @@ static void mtk_sgmii_destroy(struct mtk_eth *eth)
 {
 	int i;
 
-	for (i = 0; i < MTK_MAX_DEVS; i++)
+	if (!eth->sgmii_pcs)
+		return;
+
+	for (i = 0; i < eth->soc->num_devs; i++)
 		mtk_pcs_lynxi_destroy(eth->sgmii_pcs[i]);
 }
 
@@ -4531,7 +4534,12 @@ static int mtk_sgmii_init(struct mtk_eth *eth)
 	u32 flags;
 	int i;
 
-	for (i = 0; i < MTK_MAX_DEVS; i++) {
+	eth->sgmii_pcs = devm_kzalloc(eth->dev,
+				      sizeof(*eth->sgmii_pcs) *
+				      eth->soc->num_devs,
+				      GFP_KERNEL);
+
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		np = of_parse_phandle(eth->dev->of_node, "mediatek,sgmiisys", i);
 		if (!np)
 			break;
@@ -4576,6 +4584,18 @@ static int mtk_probe(struct platform_device *pdev)
 	if (MTK_HAS_CAPS(eth->soc->caps, MTK_SOC_MT7628))
 		eth->ip_align = NET_IP_ALIGN;
 
+	eth->netdev = devm_kzalloc(eth->dev,
+				   sizeof(*eth->netdev) * eth->soc->num_devs,
+				   GFP_KERNEL);
+	if (!eth->netdev)
+		return -ENOMEM;
+
+	eth->mac = devm_kzalloc(eth->dev,
+				sizeof(*eth->mac) * eth->soc->num_devs,
+				GFP_KERNEL);
+	if (!eth->mac)
+		return -ENOMEM;
+
 	spin_lock_init(&eth->page_lock);
 	spin_lock_init(&eth->tx_irq_lock);
 	spin_lock_init(&eth->rx_irq_lock);
@@ -4761,7 +4781,7 @@ static int mtk_probe(struct platform_device *pdev)
 			goto err_deinit_ppe;
 	}
 
-	for (i = 0; i < MTK_MAX_DEVS; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!eth->netdev[i])
 			continue;
 
@@ -4835,6 +4855,7 @@ static const struct mtk_soc_data mt2701_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
+	.num_devs = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4853,6 +4874,7 @@ static const struct mtk_soc_data mt7621_data = {
 	.required_pctl = false,
 	.offload_version = 1,
 	.hash_offset = 2,
+	.num_devs = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
@@ -4874,6 +4896,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.offload_version = 2,
 	.hash_offset = 2,
 	.has_accounting = true,
+	.num_devs = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
@@ -4893,6 +4916,7 @@ static const struct mtk_soc_data mt7623_data = {
 	.required_pctl = true,
 	.offload_version = 1,
 	.hash_offset = 2,
+	.num_devs = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
@@ -4912,6 +4936,7 @@ static const struct mtk_soc_data mt7629_data = {
 	.required_clks = MT7629_CLKS_BITMAP,
 	.required_pctl = false,
 	.has_accounting = true,
+	.num_devs = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4933,6 +4958,7 @@ static const struct mtk_soc_data mt7981_data = {
 	.hash_offset = 4,
 	.foe_entry_size = sizeof(struct mtk_foe_entry),
 	.has_accounting = true,
+	.num_devs = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma_v2),
 		.rxd_size = sizeof(struct mtk_rx_dma_v2),
@@ -4952,6 +4978,7 @@ static const struct mtk_soc_data mt7986_data = {
 	.required_pctl = false,
 	.offload_version = 2,
 	.hash_offset = 4,
+	.num_devs = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry),
 	.has_accounting = true,
 	.txrx = {
@@ -4970,6 +4997,7 @@ static const struct mtk_soc_data rt5350_data = {
 	.hw_features = MTK_HW_FEATURES_MT7628,
 	.required_clks = MT7628_CLKS_BITMAP,
 	.required_pctl = false,
+	.num_devs = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index cb3cdf0b38d5..f0c38c856cd0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1016,6 +1016,7 @@ struct mtk_reg_map {
  * @required_pctl		A bool value to show whether the SoC requires
  *				the extra setup for those pins used by GMAC.
  * @hash_offset			Flow table hash offset.
+ * @num_devs			SoC number of macs.
  * @foe_entry_size		Foe table entry size.
  * @has_accounting		Bool indicating support for accounting of
  *				offloaded flows.
@@ -1034,6 +1035,7 @@ struct mtk_soc_data {
 	bool		required_pctl;
 	u8		offload_version;
 	u8		hash_offset;
+	u8		num_devs;
 	u16		foe_entry_size;
 	netdev_features_t hw_features;
 	bool		has_accounting;
@@ -1049,9 +1051,6 @@ struct mtk_soc_data {
 
 #define MTK_DMA_MONITOR_TIMEOUT		msecs_to_jiffies(1000)
 
-/* currently no SoC has more than 2 macs */
-#define MTK_MAX_DEVS			2
-
 /* struct mtk_eth -	This is the main datasructure for holding the state
  *			of the driver
  * @dev:		The device pointer
@@ -1106,14 +1105,14 @@ struct mtk_eth {
 	spinlock_t			tx_irq_lock;
 	spinlock_t			rx_irq_lock;
 	struct net_device		dummy_dev;
-	struct net_device		*netdev[MTK_MAX_DEVS];
-	struct mtk_mac			*mac[MTK_MAX_DEVS];
+	struct net_device		**netdev;
+	struct mtk_mac			**mac;
 	int				irq[3];
 	u32				msg_enable;
 	unsigned long			sysclk;
 	struct regmap			*ethsys;
 	struct regmap			*infra;
-	struct phylink_pcs		*sgmii_pcs[MTK_MAX_DEVS];
+	struct phylink_pcs		**sgmii_pcs;
 	struct regmap			*pctl;
 	bool				hwlro;
 	refcount_t			dma_refcnt;
-- 
2.39.2

