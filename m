Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80CB5B26DC
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiIHTfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbiIHTfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:35:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BA285FDB;
        Thu,  8 Sep 2022 12:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64282B8223C;
        Thu,  8 Sep 2022 19:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB86C43142;
        Thu,  8 Sep 2022 19:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662665733;
        bh=hzSyrFozf/wc40X1iyhOy3ho3ArY0BksXYwIX46bLyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJQ5XOzT6tPEI9ZSU1GtrMZfamQs7UKSyzZrRiOzgGdT41LyYJDze067cKbJ6s8Cv
         4hJzYurMhmfjflyig++7a+XzzWAoA9n9a9yFt2utWmZbggtB9Ji4xpBWZ4nv7mKSg/
         myLlK4cqGjbScyQOPFGv8iM1qzyTsqaRToVKjwDBkXv5A/SqHqZL3QZ8fCoBvmc+LW
         bHOtBCtkVDaj2pjN5Sf0X6C0WIabhPTLjKNrw0VxSQqmiYSB5TTVfdQa80TwXkudlk
         jgIKkQDn1NUwSAK1lRucML/UyVpqV7wNYyx8Jb05vaSNzbW+4ODVMvorwgg/jGib0G
         01qviM1eBbnYA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH net-next 08/12] net: ethernet: mtk_eth_soc: add foe info in mtk_soc_data structure
Date:   Thu,  8 Sep 2022 21:33:42 +0200
Message-Id: <0d0bfa99e313c0b00bf75f943f58b6fe552ed004.1662661555.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1662661555.git.lorenzo@kernel.org>
References: <cover.1662661555.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce foe struct in mtk_soc_data as a container for foe table chip
related definitions.
This is a preliminary patch to enable mt7986 wed support.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  70 +++++++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  27 ++-
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 161 ++++++++++--------
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  29 ++--
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  34 ++--
 5 files changed, 208 insertions(+), 113 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b4bccd42a22c..8aa0a61b35fc 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4216,8 +4216,6 @@ static const struct mtk_soc_data mt7621_data = {
 	.required_clks = MT7621_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
-	.hash_offset = 2,
-	.foe_entry_size = sizeof(struct mtk_foe_entry),
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4226,6 +4224,26 @@ static const struct mtk_soc_data mt7621_data = {
 		.dma_max_len = MTK_TX_DMA_BUF_LEN,
 		.dma_len_offset = 16,
 	},
+	.foe = {
+		.entry_size = sizeof(struct mtk_foe_entry),
+		.hash_offset = 2,
+		.ib1 = {
+			.bind_ppoe = BIT(19),
+			.bind_vlan_tag = BIT(20),
+			.bind_cache = BIT(22),
+			.bind_ttl = BIT(24),
+			.bind_ts = GENMASK(14, 0),
+			.bind_vlan_layer = GENMASK(18, 16),
+			.pkt_type = GENMASK(27, 25),
+		},
+		.ib2 = {
+			.multicast = BIT(8),
+			.wdma_winfo = BIT(17),
+			.port_ag = GENMASK(23, 18),
+			.port_mg = GENMASK(17, 12),
+			.dst_port = GENMASK(7, 5),
+		},
+	},
 };
 
 static const struct mtk_soc_data mt7622_data = {
@@ -4236,8 +4254,6 @@ static const struct mtk_soc_data mt7622_data = {
 	.required_clks = MT7622_CLKS_BITMAP,
 	.required_pctl = false,
 	.offload_version = 2,
-	.hash_offset = 2,
-	.foe_entry_size = sizeof(struct mtk_foe_entry),
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4246,6 +4262,26 @@ static const struct mtk_soc_data mt7622_data = {
 		.dma_max_len = MTK_TX_DMA_BUF_LEN,
 		.dma_len_offset = 16,
 	},
+	.foe = {
+		.entry_size = sizeof(struct mtk_foe_entry),
+		.hash_offset = 2,
+		.ib1 = {
+			.bind_ppoe = BIT(19),
+			.bind_vlan_tag = BIT(20),
+			.bind_cache = BIT(22),
+			.bind_ttl = BIT(24),
+			.bind_ts = GENMASK(14, 0),
+			.bind_vlan_layer = GENMASK(18, 16),
+			.pkt_type = GENMASK(27, 25),
+		},
+		.ib2 = {
+			.multicast = BIT(8),
+			.wdma_winfo = BIT(17),
+			.port_ag = GENMASK(23, 18),
+			.port_mg = GENMASK(17, 12),
+			.dst_port = GENMASK(7, 5),
+		},
+	},
 };
 
 static const struct mtk_soc_data mt7623_data = {
@@ -4255,8 +4291,6 @@ static const struct mtk_soc_data mt7623_data = {
 	.required_clks = MT7623_CLKS_BITMAP,
 	.required_pctl = true,
 	.offload_version = 2,
-	.hash_offset = 2,
-	.foe_entry_size = sizeof(struct mtk_foe_entry),
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4265,6 +4299,26 @@ static const struct mtk_soc_data mt7623_data = {
 		.dma_max_len = MTK_TX_DMA_BUF_LEN,
 		.dma_len_offset = 16,
 	},
+	.foe = {
+		.entry_size = sizeof(struct mtk_foe_entry),
+		.hash_offset = 2,
+		.ib1 = {
+			.bind_ppoe = BIT(19),
+			.bind_vlan_tag = BIT(20),
+			.bind_cache = BIT(22),
+			.bind_ttl = BIT(24),
+			.bind_ts = GENMASK(14, 0),
+			.bind_vlan_layer = GENMASK(18, 16),
+			.pkt_type = GENMASK(27, 25),
+		},
+		.ib2 = {
+			.multicast = BIT(8),
+			.wdma_winfo = BIT(17),
+			.port_ag = GENMASK(23, 18),
+			.port_mg = GENMASK(17, 12),
+			.dst_port = GENMASK(7, 5),
+		},
+	},
 };
 
 static const struct mtk_soc_data mt7629_data = {
@@ -4290,7 +4344,6 @@ static const struct mtk_soc_data mt7986_data = {
 	.caps = MT7986_CAPS,
 	.required_clks = MT7986_CLKS_BITMAP,
 	.required_pctl = false,
-	.hash_offset = 4,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma_v2),
 		.rxd_size = sizeof(struct mtk_rx_dma_v2),
@@ -4299,6 +4352,9 @@ static const struct mtk_soc_data mt7986_data = {
 		.dma_max_len = MTK_TX_DMA_BUF_LEN_V2,
 		.dma_len_offset = 8,
 	},
+	.foe = {
+		.hash_offset = 4,
+	},
 };
 
 static const struct mtk_soc_data rt5350_data = {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 08236e054616..6d0b080c2048 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -967,14 +967,13 @@ struct mtk_reg_map {
  *				the target SoC
  * @required_pctl		A bool value to show whether the SoC requires
  *				the extra setup for those pins used by GMAC.
- * @hash_offset			Flow table hash offset.
- * @foe_entry_size		Foe table entry size.
  * @txd_size			Tx DMA descriptor size.
  * @rxd_size			Rx DMA descriptor size.
  * @rx_irq_done_mask		Rx irq done register mask.
  * @rx_dma_l4_valid		Rx DMA valid register mask.
  * @dma_max_len			Max DMA tx/rx buffer length.
  * @dma_len_offset		Tx/Rx DMA length field offset.
+ * @foe				Foe table chip info.
  */
 struct mtk_soc_data {
 	const struct mtk_reg_map *reg_map;
@@ -983,8 +982,6 @@ struct mtk_soc_data {
 	u32		required_clks;
 	bool		required_pctl;
 	u8		offload_version;
-	u8		hash_offset;
-	u16		foe_entry_size;
 	netdev_features_t hw_features;
 	struct {
 		u32	txd_size;
@@ -994,6 +991,26 @@ struct mtk_soc_data {
 		u32	dma_max_len;
 		u32	dma_len_offset;
 	} txrx;
+	struct {
+		u16	entry_size;
+		u8	hash_offset;
+		struct {
+			u32 bind_ppoe;
+			u32 bind_vlan_tag;
+			u32 bind_cache;
+			u32 bind_ttl;
+			u32 bind_ts;
+			u32 bind_vlan_layer;
+			u32 pkt_type;
+		} ib1;
+		struct {
+			u32 wdma_winfo;
+			u32 port_ag;
+			u32 port_mg;
+			u16 multicast;
+			u16 dst_port;
+		} ib2;
+	} foe;
 };
 
 /* currently no SoC has more than 2 macs */
@@ -1150,7 +1167,7 @@ mtk_foe_get_entry(struct mtk_ppe *ppe, u16 hash)
 {
 	const struct mtk_soc_data *soc = ppe->eth->soc;
 
-	return ppe->foe_table + hash * soc->foe_entry_size;
+	return ppe->foe_table + hash * soc->foe.entry_size;
 }
 
 /* read the hardware status register */
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 8c52cfc7ce76..4248a3b78aa6 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -56,7 +56,7 @@ static u32 ppe_clear(struct mtk_ppe *ppe, u32 reg, u32 val)
 
 static u32 mtk_eth_timestamp(struct mtk_eth *eth)
 {
-	return mtk_r32(eth, 0x0010) & MTK_FOE_IB1_BIND_TIMESTAMP;
+	return mtk_r32(eth, 0x0010) & eth->soc->foe.ib1.bind_ts;
 }
 
 static int mtk_ppe_wait_busy(struct mtk_ppe *ppe)
@@ -93,7 +93,7 @@ static u32 mtk_ppe_hash_entry(struct mtk_eth *eth, struct mtk_foe_entry *e)
 	u32 hv1, hv2, hv3;
 	u32 hash;
 
-	switch (FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, e->ib1)) {
+	switch (MTK_FIELD_GET(eth->soc->foe.ib1.pkt_type, e->ib1)) {
 		case MTK_PPE_PKT_TYPE_IPV4_ROUTE:
 		case MTK_PPE_PKT_TYPE_IPV4_HNAPT:
 			hv1 = e->ipv4.orig.ports;
@@ -122,16 +122,16 @@ static u32 mtk_ppe_hash_entry(struct mtk_eth *eth, struct mtk_foe_entry *e)
 	hash = (hash >> 24) | ((hash & 0xffffff) << 8);
 	hash ^= hv1 ^ hv2 ^ hv3;
 	hash ^= hash >> 16;
-	hash <<= (ffs(eth->soc->hash_offset) - 1);
+	hash <<= (ffs(eth->soc->foe.hash_offset) - 1);
 	hash &= MTK_PPE_ENTRIES - 1;
 
 	return hash;
 }
 
 static inline struct mtk_foe_mac_info *
-mtk_foe_entry_l2(struct mtk_foe_entry *entry)
+mtk_foe_entry_l2(struct mtk_eth *eth, struct mtk_foe_entry *entry)
 {
-	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
+	int type = MTK_FIELD_GET(eth->soc->foe.ib1.pkt_type, entry->ib1);
 
 	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
 		return &entry->bridge.l2;
@@ -143,9 +143,9 @@ mtk_foe_entry_l2(struct mtk_foe_entry *entry)
 }
 
 static inline u32 *
-mtk_foe_entry_ib2(struct mtk_foe_entry *entry)
+mtk_foe_entry_ib2(struct mtk_eth *eth, struct mtk_foe_entry *entry)
 {
-	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
+	int type = MTK_FIELD_GET(eth->soc->foe.ib1.pkt_type, entry->ib1);
 
 	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
 		return &entry->bridge.ib2;
@@ -156,8 +156,9 @@ mtk_foe_entry_ib2(struct mtk_foe_entry *entry)
 	return &entry->ipv4.ib2;
 }
 
-int mtk_foe_entry_prepare(struct mtk_foe_entry *entry, int type, int l4proto,
-			  u8 pse_port, u8 *src_mac, u8 *dest_mac)
+int mtk_foe_entry_prepare(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			  int type, int l4proto, u8 pse_port, u8 *src_mac,
+			  u8 *dest_mac)
 {
 	struct mtk_foe_mac_info *l2;
 	u32 ports_pad, val;
@@ -165,18 +166,18 @@ int mtk_foe_entry_prepare(struct mtk_foe_entry *entry, int type, int l4proto,
 	memset(entry, 0, sizeof(*entry));
 
 	val = FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_BIND) |
-	      FIELD_PREP(MTK_FOE_IB1_PACKET_TYPE, type) |
+	      MTK_FIELD_PREP(eth->soc->foe.ib1.pkt_type, type) |
 	      FIELD_PREP(MTK_FOE_IB1_UDP, l4proto == IPPROTO_UDP) |
-	      MTK_FOE_IB1_BIND_TTL |
-	      MTK_FOE_IB1_BIND_CACHE;
+	      eth->soc->foe.ib1.bind_ttl |
+	      eth->soc->foe.ib1.bind_cache;
 	entry->ib1 = val;
 
-	val = FIELD_PREP(MTK_FOE_IB2_PORT_MG, 0x3f) |
-	      FIELD_PREP(MTK_FOE_IB2_PORT_AG, 0x1f) |
-	      FIELD_PREP(MTK_FOE_IB2_DEST_PORT, pse_port);
+	val = MTK_FIELD_PREP(eth->soc->foe.ib2.port_mg, 0x3f) |
+	      MTK_FIELD_PREP(eth->soc->foe.ib2.port_ag, 0x1f) |
+	      MTK_FIELD_PREP(eth->soc->foe.ib2.dst_port, pse_port);
 
 	if (is_multicast_ether_addr(dest_mac))
-		val |= MTK_FOE_IB2_MULTICAST;
+		val |= eth->soc->foe.ib2.multicast;
 
 	ports_pad = 0xa5a5a500 | (l4proto & 0xff);
 	if (type == MTK_PPE_PKT_TYPE_IPV4_ROUTE)
@@ -210,24 +211,26 @@ int mtk_foe_entry_prepare(struct mtk_foe_entry *entry, int type, int l4proto,
 	return 0;
 }
 
-int mtk_foe_entry_set_pse_port(struct mtk_foe_entry *entry, u8 port)
+int mtk_foe_entry_set_pse_port(struct mtk_eth *eth,
+			       struct mtk_foe_entry *entry, u8 port)
 {
-	u32 *ib2 = mtk_foe_entry_ib2(entry);
+	u32 *ib2 = mtk_foe_entry_ib2(eth, entry);
 	u32 val;
 
 	val = *ib2;
-	val &= ~MTK_FOE_IB2_DEST_PORT;
-	val |= FIELD_PREP(MTK_FOE_IB2_DEST_PORT, port);
+	val &= ~eth->soc->foe.ib2.dst_port;
+	val |= MTK_FIELD_PREP(eth->soc->foe.ib2.dst_port, port);
 	*ib2 = val;
 
 	return 0;
 }
 
-int mtk_foe_entry_set_ipv4_tuple(struct mtk_foe_entry *entry, bool egress,
+int mtk_foe_entry_set_ipv4_tuple(struct mtk_eth *eth,
+				 struct mtk_foe_entry *entry, bool egress,
 				 __be32 src_addr, __be16 src_port,
 				 __be32 dest_addr, __be16 dest_port)
 {
-	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
+	int type = MTK_FIELD_GET(eth->soc->foe.ib1.pkt_type, entry->ib1);
 	struct mtk_ipv4_tuple *t;
 
 	switch (type) {
@@ -262,11 +265,12 @@ int mtk_foe_entry_set_ipv4_tuple(struct mtk_foe_entry *entry, bool egress,
 	return 0;
 }
 
-int mtk_foe_entry_set_ipv6_tuple(struct mtk_foe_entry *entry,
+int mtk_foe_entry_set_ipv6_tuple(struct mtk_eth *eth,
+				 struct mtk_foe_entry *entry,
 				 __be32 *src_addr, __be16 src_port,
 				 __be32 *dest_addr, __be16 dest_port)
 {
-	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
+	int type = MTK_FIELD_GET(eth->soc->foe.ib1.pkt_type, entry->ib1);
 	u32 *src, *dest;
 	int i;
 
@@ -297,39 +301,45 @@ int mtk_foe_entry_set_ipv6_tuple(struct mtk_foe_entry *entry,
 	return 0;
 }
 
-int mtk_foe_entry_set_dsa(struct mtk_foe_entry *entry, int port)
+int mtk_foe_entry_set_dsa(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			  int port)
 {
-	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(entry);
+	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(eth, entry);
+	const struct mtk_soc_data *soc = eth->soc;
 
 	l2->etype = BIT(port);
 
-	if (!(entry->ib1 & MTK_FOE_IB1_BIND_VLAN_LAYER))
-		entry->ib1 |= FIELD_PREP(MTK_FOE_IB1_BIND_VLAN_LAYER, 1);
+	if (!(entry->ib1 & soc->foe.ib1.bind_vlan_layer))
+		entry->ib1 |= MTK_FIELD_PREP(soc->foe.ib1.bind_vlan_layer, 1);
 	else
 		l2->etype |= BIT(8);
 
-	entry->ib1 &= ~MTK_FOE_IB1_BIND_VLAN_TAG;
+	entry->ib1 &= ~soc->foe.ib1.bind_vlan_tag;
 
 	return 0;
 }
 
-int mtk_foe_entry_set_vlan(struct mtk_foe_entry *entry, int vid)
+int mtk_foe_entry_set_vlan(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			   int vid)
 {
-	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(entry);
+	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(eth, entry);
+	const struct mtk_soc_data *soc = eth->soc;
 
-	switch (FIELD_GET(MTK_FOE_IB1_BIND_VLAN_LAYER, entry->ib1)) {
+	switch (MTK_FIELD_GET(soc->foe.ib1.bind_vlan_layer, entry->ib1)) {
 	case 0:
-		entry->ib1 |= MTK_FOE_IB1_BIND_VLAN_TAG |
-			      FIELD_PREP(MTK_FOE_IB1_BIND_VLAN_LAYER, 1);
+		entry->ib1 |= soc->foe.ib1.bind_vlan_tag |
+			      MTK_FIELD_PREP(soc->foe.ib1.bind_vlan_layer, 1);
 		l2->vlan1 = vid;
 		return 0;
 	case 1:
-		if (!(entry->ib1 & MTK_FOE_IB1_BIND_VLAN_TAG)) {
+		if (!(entry->ib1 & soc->foe.ib1.bind_vlan_tag)) {
 			l2->vlan1 = vid;
 			l2->etype |= BIT(8);
 		} else {
 			l2->vlan2 = vid;
-			entry->ib1 += FIELD_PREP(MTK_FOE_IB1_BIND_VLAN_LAYER, 1);
+			entry->ib1 +=
+				MTK_FIELD_PREP(soc->foe.ib1.bind_vlan_layer,
+					       1);
 		}
 		return 0;
 	default:
@@ -337,28 +347,29 @@ int mtk_foe_entry_set_vlan(struct mtk_foe_entry *entry, int vid)
 	}
 }
 
-int mtk_foe_entry_set_pppoe(struct mtk_foe_entry *entry, int sid)
+int mtk_foe_entry_set_pppoe(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			    int sid)
 {
-	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(entry);
+	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(eth, entry);
 
-	if (!(entry->ib1 & MTK_FOE_IB1_BIND_VLAN_LAYER) ||
-	    (entry->ib1 & MTK_FOE_IB1_BIND_VLAN_TAG))
+	if (!(entry->ib1 & eth->soc->foe.ib1.bind_vlan_layer) ||
+	    (entry->ib1 & eth->soc->foe.ib1.bind_vlan_tag))
 		l2->etype = ETH_P_PPP_SES;
 
-	entry->ib1 |= MTK_FOE_IB1_BIND_PPPOE;
+	entry->ib1 |= eth->soc->foe.ib1.bind_ppoe;
 	l2->pppoe_id = sid;
 
 	return 0;
 }
 
-int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
-			   int bss, int wcid)
+int mtk_foe_entry_set_wdma(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			   int wdma_idx, int txq, int bss, int wcid)
 {
-	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(entry);
-	u32 *ib2 = mtk_foe_entry_ib2(entry);
+	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(eth, entry);
+	u32 *ib2 = mtk_foe_entry_ib2(eth, entry);
 
-	*ib2 &= ~MTK_FOE_IB2_PORT_MG;
-	*ib2 |= MTK_FOE_IB2_WDMA_WINFO;
+	*ib2 &= ~eth->soc->foe.ib2.port_mg;
+	*ib2 |= eth->soc->foe.ib2.wdma_winfo;
 	if (wdma_idx)
 		*ib2 |= MTK_FOE_IB2_WDMA_DEVIDX;
 
@@ -376,14 +387,15 @@ static inline bool mtk_foe_entry_usable(struct mtk_foe_entry *entry)
 }
 
 static bool
-mtk_flow_entry_match(struct mtk_flow_entry *entry, struct mtk_foe_entry *data)
+mtk_flow_entry_match(struct mtk_eth *eth, struct mtk_flow_entry *entry,
+		     struct mtk_foe_entry *data)
 {
 	int type, len;
 
 	if ((data->ib1 ^ entry->data.ib1) & MTK_FOE_IB1_UDP)
 		return false;
 
-	type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->data.ib1);
+	type = MTK_FIELD_GET(eth->soc->foe.ib1.pkt_type, entry->data.ib1);
 	if (type > MTK_PPE_PKT_TYPE_IPV4_DSLITE)
 		len = offsetof(struct mtk_foe_entry, ipv6._rsv);
 	else
@@ -430,11 +442,11 @@ static int __mtk_foe_entry_idle_time(struct mtk_ppe *ppe, u32 ib1)
 	u16 timestamp;
 	u16 now;
 
-	now = mtk_eth_timestamp(ppe->eth) & MTK_FOE_IB1_BIND_TIMESTAMP;
-	timestamp = ib1 & MTK_FOE_IB1_BIND_TIMESTAMP;
+	now = mtk_eth_timestamp(ppe->eth) & ppe->eth->soc->foe.ib1.bind_ts;
+	timestamp = ib1 & ppe->eth->soc->foe.ib1.bind_ts;
 
 	if (timestamp > now)
-		return MTK_FOE_IB1_BIND_TIMESTAMP + 1 - timestamp + now;
+		return ppe->eth->soc->foe.ib1.bind_ts + 1 - timestamp + now;
 	else
 		return now - timestamp;
 }
@@ -466,8 +478,8 @@ mtk_flow_entry_update_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 			continue;
 
 		idle = cur_idle;
-		entry->data.ib1 &= ~MTK_FOE_IB1_BIND_TIMESTAMP;
-		entry->data.ib1 |= hwe->ib1 & MTK_FOE_IB1_BIND_TIMESTAMP;
+		entry->data.ib1 &= ~ppe->eth->soc->foe.ib1.bind_ts;
+		entry->data.ib1 |= hwe->ib1 & ppe->eth->soc->foe.ib1.bind_ts;
 	}
 }
 
@@ -488,8 +500,8 @@ mtk_flow_entry_update(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 		goto out;
 
 	hwe = mtk_foe_get_entry(ppe, entry->hash);
-	memcpy(&foe, hwe, ppe->eth->soc->foe_entry_size);
-	if (!mtk_flow_entry_match(entry, &foe)) {
+	memcpy(&foe, hwe, ppe->eth->soc->foe.entry_size);
+	if (!mtk_flow_entry_match(ppe->eth, entry, &foe)) {
 		entry->hash = 0xffff;
 		goto out;
 	}
@@ -508,12 +520,12 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 	u16 timestamp;
 
 	timestamp = mtk_eth_timestamp(ppe->eth);
-	timestamp &= MTK_FOE_IB1_BIND_TIMESTAMP;
-	entry->ib1 &= ~MTK_FOE_IB1_BIND_TIMESTAMP;
-	entry->ib1 |= FIELD_PREP(MTK_FOE_IB1_BIND_TIMESTAMP, timestamp);
-
+	timestamp &= ppe->eth->soc->foe.ib1.bind_ts;
+	entry->ib1 &= ~ppe->eth->soc->foe.ib1.bind_ts;
+	entry->ib1 |= MTK_FIELD_PREP(ppe->eth->soc->foe.ib1.bind_ts,
+				     timestamp);
 	hwe = mtk_foe_get_entry(ppe, hash);
-	memcpy(&hwe->data, &entry->data, ppe->eth->soc->foe_entry_size);
+	memcpy(&hwe->data, &entry->data, ppe->eth->soc->foe.entry_size);
 	wmb();
 	hwe->ib1 = entry->ib1;
 
@@ -540,8 +552,8 @@ mtk_foe_entry_commit_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 
 int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
-	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->data.ib1);
 	const struct mtk_soc_data *soc = ppe->eth->soc;
+	int type = MTK_FIELD_GET(soc->foe.ib1.pkt_type, entry->data.ib1);
 	u32 hash;
 
 	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
@@ -550,7 +562,8 @@ int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	hash = mtk_ppe_hash_entry(ppe->eth, &entry->data);
 	entry->hash = 0xffff;
 	spin_lock_bh(&ppe_lock);
-	hlist_add_head(&entry->list, &ppe->foe_flow[hash / soc->hash_offset]);
+	hlist_add_head(&entry->list,
+		       &ppe->foe_flow[hash / soc->foe.hash_offset]);
 	spin_unlock_bh(&ppe_lock);
 
 	return 0;
@@ -564,7 +577,7 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 	struct mtk_flow_entry *flow_info;
 	struct mtk_foe_entry foe = {}, *hwe;
 	struct mtk_foe_mac_info *l2;
-	u32 ib1_mask = MTK_FOE_IB1_PACKET_TYPE | MTK_FOE_IB1_UDP;
+	u32 ib1_mask = soc->foe.ib1.pkt_type | MTK_FOE_IB1_UDP;
 	int type;
 
 	flow_info = kzalloc(offsetof(struct mtk_flow_entry, l2_data.end),
@@ -576,24 +589,24 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 	flow_info->type = MTK_FLOW_TYPE_L2_SUBFLOW;
 	flow_info->hash = hash;
 	hlist_add_head(&flow_info->list,
-		       &ppe->foe_flow[hash / soc->hash_offset]);
+		       &ppe->foe_flow[hash / soc->foe.hash_offset]);
 	hlist_add_head(&flow_info->l2_data.list, &entry->l2_flows);
 
 	hwe = mtk_foe_get_entry(ppe, hash);
-	memcpy(&foe, hwe, soc->foe_entry_size);
+	memcpy(&foe, hwe, soc->foe.entry_size);
 	foe.ib1 &= ib1_mask;
 	foe.ib1 |= entry->data.ib1 & ~ib1_mask;
 
-	l2 = mtk_foe_entry_l2(&foe);
+	l2 = mtk_foe_entry_l2(ppe->eth, &foe);
 	memcpy(l2, &entry->data.bridge.l2, sizeof(*l2));
 
-	type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, foe.ib1);
+	type = MTK_FIELD_GET(soc->foe.ib1.pkt_type, foe.ib1);
 	if (type == MTK_PPE_PKT_TYPE_IPV4_HNAPT)
 		memcpy(&foe.ipv4.new, &foe.ipv4.orig, sizeof(foe.ipv4.new));
 	else if (type >= MTK_PPE_PKT_TYPE_IPV6_ROUTE_3T && l2->etype == ETH_P_IP)
 		l2->etype = ETH_P_IPV6;
 
-	*mtk_foe_entry_ib2(&foe) = entry->data.bridge.ib2;
+	*mtk_foe_entry_ib2(ppe->eth, &foe) = entry->data.bridge.ib2;
 
 	__mtk_foe_entry_commit(ppe, &foe, hash);
 }
@@ -601,7 +614,7 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 {
 	const struct mtk_soc_data *soc = ppe->eth->soc;
-	struct hlist_head *head = &ppe->foe_flow[hash / soc->hash_offset];
+	struct hlist_head *head = &ppe->foe_flow[hash / soc->foe.hash_offset];
 	struct mtk_foe_entry *hwe = mtk_foe_get_entry(ppe, hash);
 	struct mtk_flow_entry *entry;
 	struct mtk_foe_bridge key = {};
@@ -626,7 +639,7 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 			continue;
 		}
 
-		if (found || !mtk_flow_entry_match(entry, hwe)) {
+		if (found || !mtk_flow_entry_match(ppe->eth, entry, hwe)) {
 			if (entry->hash != 0xffff)
 				entry->hash = 0xffff;
 			continue;
@@ -706,14 +719,14 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 	ppe->version = version;
 
 	foe = dmam_alloc_coherent(ppe->dev,
-				  MTK_PPE_ENTRIES * soc->foe_entry_size,
+				  MTK_PPE_ENTRIES * soc->foe.entry_size,
 				  &ppe->foe_phys, GFP_KERNEL);
 	if (!foe)
 		return NULL;
 
 	ppe->foe_table = foe;
 
-	foe_flow_size = (MTK_PPE_ENTRIES / soc->hash_offset) *
+	foe_flow_size = (MTK_PPE_ENTRIES / soc->foe.hash_offset) *
 			sizeof(*ppe->foe_flow);
 	ppe->foe_flow = devm_kzalloc(dev, foe_flow_size, GFP_KERNEL);
 	if (!ppe->foe_flow)
@@ -730,7 +743,7 @@ static void mtk_ppe_init_foe_table(struct mtk_ppe *ppe)
 	int i, k;
 
 	memset(ppe->foe_table, 0,
-	       MTK_PPE_ENTRIES * ppe->eth->soc->foe_entry_size);
+	       MTK_PPE_ENTRIES * ppe->eth->soc->foe.entry_size);
 
 	if (!IS_ENABLED(CONFIG_SOC_MT7621))
 		return;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 6d4c91acd1a5..a364f45edf38 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -61,6 +61,8 @@ enum {
 #define MTK_FOE_VLAN2_WINFO_WCID	GENMASK(13, 6)
 #define MTK_FOE_VLAN2_WINFO_RING	GENMASK(15, 14)
 
+#define MTK_FIELD_PREP(mask, val)	(((typeof(mask))(val) << __bf_shf(mask)) & (mask))
+#define MTK_FIELD_GET(mask, val)	((typeof(mask))(((val) & (mask)) >> __bf_shf(mask)))
 enum {
 	MTK_FOE_STATE_INVALID,
 	MTK_FOE_STATE_UNBIND,
@@ -306,20 +308,27 @@ mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 	__mtk_ppe_check_skb(ppe, skb, hash);
 }
 
-int mtk_foe_entry_prepare(struct mtk_foe_entry *entry, int type, int l4proto,
-			  u8 pse_port, u8 *src_mac, u8 *dest_mac);
-int mtk_foe_entry_set_pse_port(struct mtk_foe_entry *entry, u8 port);
-int mtk_foe_entry_set_ipv4_tuple(struct mtk_foe_entry *entry, bool orig,
+int mtk_foe_entry_prepare(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			  int type, int l4proto, u8 pse_port, u8 *src_mac,
+			  u8 *dest_mac);
+int mtk_foe_entry_set_pse_port(struct mtk_eth *eth,
+			       struct mtk_foe_entry *entry, u8 port);
+int mtk_foe_entry_set_ipv4_tuple(struct mtk_eth *eth,
+				 struct mtk_foe_entry *entry, bool orig,
 				 __be32 src_addr, __be16 src_port,
 				 __be32 dest_addr, __be16 dest_port);
-int mtk_foe_entry_set_ipv6_tuple(struct mtk_foe_entry *entry,
+int mtk_foe_entry_set_ipv6_tuple(struct mtk_eth *eth,
+				 struct mtk_foe_entry *entry,
 				 __be32 *src_addr, __be16 src_port,
 				 __be32 *dest_addr, __be16 dest_port);
-int mtk_foe_entry_set_dsa(struct mtk_foe_entry *entry, int port);
-int mtk_foe_entry_set_vlan(struct mtk_foe_entry *entry, int vid);
-int mtk_foe_entry_set_pppoe(struct mtk_foe_entry *entry, int sid);
-int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
-			   int bss, int wcid);
+int mtk_foe_entry_set_dsa(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			  int port);
+int mtk_foe_entry_set_vlan(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			   int vid);
+int mtk_foe_entry_set_pppoe(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			    int sid);
+int mtk_foe_entry_set_wdma(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			   int wdma_idx, int txq, int bss, int wcid);
 int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 0324e7750065..56c49ac712b9 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -52,18 +52,19 @@ static const struct rhashtable_params mtk_flow_ht_params = {
 };
 
 static int
-mtk_flow_set_ipv4_addr(struct mtk_foe_entry *foe, struct mtk_flow_data *data,
-		       bool egress)
+mtk_flow_set_ipv4_addr(struct mtk_eth *eth, struct mtk_foe_entry *foe,
+		       struct mtk_flow_data *data, bool egress)
 {
-	return mtk_foe_entry_set_ipv4_tuple(foe, egress,
+	return mtk_foe_entry_set_ipv4_tuple(eth, foe, egress,
 					    data->v4.src_addr, data->src_port,
 					    data->v4.dst_addr, data->dst_port);
 }
 
 static int
-mtk_flow_set_ipv6_addr(struct mtk_foe_entry *foe, struct mtk_flow_data *data)
+mtk_flow_set_ipv6_addr(struct mtk_eth *eth, struct mtk_foe_entry *foe,
+		       struct mtk_flow_data *data)
 {
-	return mtk_foe_entry_set_ipv6_tuple(foe,
+	return mtk_foe_entry_set_ipv6_tuple(eth, foe,
 					    data->v6.src_addr.s6_addr32, data->src_port,
 					    data->v6.dst_addr.s6_addr32, data->dst_port);
 }
@@ -190,8 +191,8 @@ mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 	int pse_port, dsa_port;
 
 	if (mtk_flow_get_wdma_info(dev, dest_mac, &info) == 0) {
-		mtk_foe_entry_set_wdma(foe, info.wdma_idx, info.queue, info.bss,
-				       info.wcid);
+		mtk_foe_entry_set_wdma(eth, foe, info.wdma_idx, info.queue,
+				       info.bss, info.wcid);
 		pse_port = 3;
 		*wed_index = info.wdma_idx;
 		goto out;
@@ -199,7 +200,7 @@ mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 
 	dsa_port = mtk_flow_get_dsa_port(&dev);
 	if (dsa_port >= 0)
-		mtk_foe_entry_set_dsa(foe, dsa_port);
+		mtk_foe_entry_set_dsa(eth, foe, dsa_port);
 
 	if (dev == eth->netdev[0])
 		pse_port = 1;
@@ -209,7 +210,7 @@ mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 		return -EOPNOTSUPP;
 
 out:
-	mtk_foe_entry_set_pse_port(foe, pse_port);
+	mtk_foe_entry_set_pse_port(eth, foe, pse_port);
 
 	return 0;
 }
@@ -333,9 +334,8 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	    !is_valid_ether_addr(data.eth.h_dest))
 		return -EINVAL;
 
-	err = mtk_foe_entry_prepare(&foe, offload_type, l4proto, 0,
-				    data.eth.h_source,
-				    data.eth.h_dest);
+	err = mtk_foe_entry_prepare(eth, &foe, offload_type, l4proto, 0,
+				    data.eth.h_source, data.eth.h_dest);
 	if (err)
 		return err;
 
@@ -360,7 +360,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 		data.v4.src_addr = addrs.key->src;
 		data.v4.dst_addr = addrs.key->dst;
 
-		mtk_flow_set_ipv4_addr(&foe, &data, false);
+		mtk_flow_set_ipv4_addr(eth, &foe, &data, false);
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
@@ -371,7 +371,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 		data.v6.src_addr = addrs.key->src;
 		data.v6.dst_addr = addrs.key->dst;
 
-		mtk_flow_set_ipv6_addr(&foe, &data);
+		mtk_flow_set_ipv6_addr(eth, &foe, &data);
 	}
 
 	flow_action_for_each(i, act, &rule->action) {
@@ -401,7 +401,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-		err = mtk_flow_set_ipv4_addr(&foe, &data, true);
+		err = mtk_flow_set_ipv4_addr(eth, &foe, &data, true);
 		if (err)
 			return err;
 	}
@@ -413,10 +413,10 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 		if (data.vlan.proto != htons(ETH_P_8021Q))
 			return -EOPNOTSUPP;
 
-		mtk_foe_entry_set_vlan(&foe, data.vlan.id);
+		mtk_foe_entry_set_vlan(eth, &foe, data.vlan.id);
 	}
 	if (data.pppoe.num == 1)
-		mtk_foe_entry_set_pppoe(&foe, data.pppoe.sid);
+		mtk_foe_entry_set_pppoe(eth, &foe, data.pppoe.sid);
 
 	err = mtk_flow_set_output_device(eth, &foe, odev, data.eth.h_dest,
 					 &wed_index);
-- 
2.37.3

