Return-Path: <netdev+bounces-9856-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4246772AFCD
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 02:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73F141C209E7
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 00:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E60B10E3;
	Sun, 11 Jun 2023 00:36:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627197F0
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 00:36:04 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AF435AD;
	Sat, 10 Jun 2023 17:36:02 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1q893o-0005Cp-1D;
	Sun, 11 Jun 2023 00:36:00 +0000
Date: Sun, 11 Jun 2023 01:35:17 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Mark Lee <Mark-MC.Lee@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, John Crispin <john@phrozen.org>,
	Felix Fietkau <nbd@nbd.name>, Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh+dt@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sam Shih <Sam.Shih@mediatek.com>
Subject: [PATCH net-next 3/8] net: ethernet: mtk_eth_soc: move MAX_DEVS in
 mtk_soc_data
Message-ID: <ZIUWxQ9H7hNSd6rJ@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
index 7014e0d108b27..f91b661379a94 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4030,7 +4030,10 @@ static void mtk_sgmii_destroy(struct mtk_eth *eth)
 {
 	int i;
 
-	for (i = 0; i < MTK_MAX_DEVS; i++)
+	if (!eth->sgmii_pcs)
+		return;
+
+	for (i = 0; i < eth->soc->num_devs; i++)
 		mtk_pcs_lynxi_destroy(eth->sgmii_pcs[i]);
 }
 
@@ -4489,7 +4492,12 @@ static int mtk_sgmii_init(struct mtk_eth *eth)
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
@@ -4534,6 +4542,18 @@ static int mtk_probe(struct platform_device *pdev)
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
@@ -4719,7 +4739,7 @@ static int mtk_probe(struct platform_device *pdev)
 			goto err_deinit_ppe;
 	}
 
-	for (i = 0; i < MTK_MAX_DEVS; i++) {
+	for (i = 0; i < eth->soc->num_devs; i++) {
 		if (!eth->netdev[i])
 			continue;
 
@@ -4793,6 +4813,7 @@ static const struct mtk_soc_data mt2701_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
+	.num_devs = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4811,6 +4832,7 @@ static const struct mtk_soc_data mt7621_data = {
 	.required_pctl = false,
 	.offload_version = 1,
 	.hash_offset = 2,
+	.num_devs = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
@@ -4832,6 +4854,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.offload_version = 2,
 	.hash_offset = 2,
 	.has_accounting = true,
+	.num_devs = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
@@ -4851,6 +4874,7 @@ static const struct mtk_soc_data mt7623_data = {
 	.required_pctl = true,
 	.offload_version = 1,
 	.hash_offset = 2,
+	.num_devs = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
@@ -4870,6 +4894,7 @@ static const struct mtk_soc_data mt7629_data = {
 	.required_clks = MT7629_CLKS_BITMAP,
 	.required_pctl = false,
 	.has_accounting = true,
+	.num_devs = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4891,6 +4916,7 @@ static const struct mtk_soc_data mt7981_data = {
 	.hash_offset = 4,
 	.foe_entry_size = sizeof(struct mtk_foe_entry),
 	.has_accounting = true,
+	.num_devs = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma_v2),
 		.rxd_size = sizeof(struct mtk_rx_dma_v2),
@@ -4910,6 +4936,7 @@ static const struct mtk_soc_data mt7986_data = {
 	.required_pctl = false,
 	.offload_version = 2,
 	.hash_offset = 4,
+	.num_devs = 2,
 	.foe_entry_size = sizeof(struct mtk_foe_entry),
 	.has_accounting = true,
 	.txrx = {
@@ -4928,6 +4955,7 @@ static const struct mtk_soc_data rt5350_data = {
 	.hw_features = MTK_HW_FEATURES_MT7628,
 	.required_clks = MT7628_CLKS_BITMAP,
 	.required_pctl = false,
+	.num_devs = 2,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index c74c3918113a5..62981e00be7e7 100644
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
2.41.0


