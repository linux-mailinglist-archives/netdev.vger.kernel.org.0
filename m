Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE39D5B790D
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiIMSBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiIMSAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:00:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568A08E44A;
        Tue, 13 Sep 2022 10:02:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35248B80F96;
        Tue, 13 Sep 2022 17:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D35C433C1;
        Tue, 13 Sep 2022 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663088543;
        bh=OaC8UScHhr8eCVY6QI/rTPBW0T/Cv32I6j4GOZtNjrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HA67xDgk6MBH2q2w8511PIBGkhEa0Z8Pw9Ltz50+5FKE+4dImAM9HQ+pXnj1C3vRR
         wLmiOSNYEXiRXJM7YumjGLjAQYRZMpeAmDlrKmBIRAcU8OLKLOBPGIbVUUJBhOEkFr
         OmlJWtTR1W7Q7vgcFTRpbITq+8xa4JTtTV1ESKMBakO2Z2cDcYmE6HyyfOH3T0siUj
         0AgpDdhnsaHXhMmEKS3UIIsjCUiKb2FjGPBmoeVtE838eJXSLjmXwiQDhj8skmo+q/
         B1TK4T1t0zHrpjHvi4GcmwQAqufAbGa58rw35mIPqAXoUJw0hTOd81IJQ6Ne08gL25
         qXXjfYcb0qUmg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org, daniel@makrotopia.org
Subject: [PATCH v2 net-next 11/11] net: ethernet: mtk_eth_soc: introduce flow offloading support for mt7986
Date:   Tue, 13 Sep 2022 19:01:01 +0200
Message-Id: <324078ce1e273c7b634cab27a1a2ed053377b608.1663087836.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663087836.git.lorenzo@kernel.org>
References: <cover.1663087836.git.lorenzo@kernel.org>
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

Introduce hw flow offload support for mt7986 chipset. PPE is not enabled
yet in mt7986 since mt76 support is not available yet.

Tested-by: Daniel Golle <daniel@makrotopia.org>
Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  11 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |  72 ++++++
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 213 +++++++++++-------
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  52 ++++-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  49 ++--
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |   8 +
 6 files changed, 289 insertions(+), 116 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f706924b249b..516875cd698f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1906,12 +1906,14 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		bytes += skb->len;
 
 		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+			reason = FIELD_GET(MTK_RXD5_PPE_CPU_REASON, trxd.rxd5);
 			hash = trxd.rxd5 & MTK_RXD5_FOE_ENTRY;
 			if (hash != MTK_RXD5_FOE_ENTRY)
 				skb_set_hash(skb, jhash_1word(hash, 0),
 					     PKT_HASH_TYPE_L4);
 			rxdcsum = &trxd.rxd3;
 		} else {
+			reason = FIELD_GET(MTK_RXD4_PPE_CPU_REASON, trxd.rxd4);
 			hash = trxd.rxd4 & MTK_RXD4_FOE_ENTRY;
 			if (hash != MTK_RXD4_FOE_ENTRY)
 				skb_set_hash(skb, jhash_1word(hash, 0),
@@ -1925,7 +1927,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			skb_checksum_none_assert(skb);
 		skb->protocol = eth_type_trans(skb, netdev);
 
-		reason = FIELD_GET(MTK_RXD4_PPE_CPU_REASON, trxd.rxd4);
 		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
 			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
 
@@ -4233,7 +4234,7 @@ static const struct mtk_soc_data mt7621_data = {
 	.required_pctl = false,
 	.offload_version = 2,
 	.hash_offset = 2,
-	.foe_entry_size = sizeof(struct mtk_foe_entry),
+	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4253,7 +4254,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.required_pctl = false,
 	.offload_version = 2,
 	.hash_offset = 2,
-	.foe_entry_size = sizeof(struct mtk_foe_entry),
+	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4272,7 +4273,7 @@ static const struct mtk_soc_data mt7623_data = {
 	.required_pctl = true,
 	.offload_version = 2,
 	.hash_offset = 2,
-	.foe_entry_size = sizeof(struct mtk_foe_entry),
+	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4304,9 +4305,11 @@ static const struct mtk_soc_data mt7986_data = {
 	.reg_map = &mt7986_reg_map,
 	.ana_rgc3 = 0x128,
 	.caps = MT7986_CAPS,
+	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7986_CLKS_BITMAP,
 	.required_pctl = false,
 	.hash_offset = 4,
+	.foe_entry_size = sizeof(struct mtk_foe_entry),
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma_v2),
 		.rxd_size = sizeof(struct mtk_rx_dma_v2),
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 08236e054616..1efaba5d4337 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1153,6 +1153,78 @@ mtk_foe_get_entry(struct mtk_ppe *ppe, u16 hash)
 	return ppe->foe_table + hash * soc->foe_entry_size;
 }
 
+static inline u32 mtk_get_ib1_ts_mask(struct mtk_eth *eth)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return MTK_FOE_IB1_BIND_TIMESTAMP_V2;
+
+	return MTK_FOE_IB1_BIND_TIMESTAMP;
+}
+
+static inline u32 mtk_get_ib1_ppoe_mask(struct mtk_eth *eth)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return MTK_FOE_IB1_BIND_PPPOE_V2;
+
+	return MTK_FOE_IB1_BIND_PPPOE;
+}
+
+static inline u32 mtk_get_ib1_vlan_tag_mask(struct mtk_eth *eth)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return MTK_FOE_IB1_BIND_VLAN_TAG_V2;
+
+	return MTK_FOE_IB1_BIND_VLAN_TAG;
+}
+
+static inline u32 mtk_get_ib1_vlan_layer_mask(struct mtk_eth *eth)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return MTK_FOE_IB1_BIND_VLAN_LAYER_V2;
+
+	return MTK_FOE_IB1_BIND_VLAN_LAYER;
+}
+
+static inline u32 mtk_prep_ib1_vlan_layer(struct mtk_eth *eth, u32 val)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return FIELD_PREP(MTK_FOE_IB1_BIND_VLAN_LAYER_V2, val);
+
+	return FIELD_PREP(MTK_FOE_IB1_BIND_VLAN_LAYER, val);
+}
+
+static inline u32 mtk_get_ib1_vlan_layer(struct mtk_eth *eth, u32 val)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return FIELD_GET(MTK_FOE_IB1_BIND_VLAN_LAYER_V2, val);
+
+	return FIELD_GET(MTK_FOE_IB1_BIND_VLAN_LAYER, val);
+}
+
+static inline u32 mtk_get_ib1_pkt_type_mask(struct mtk_eth *eth)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return MTK_FOE_IB1_PACKET_TYPE_V2;
+
+	return MTK_FOE_IB1_PACKET_TYPE;
+}
+
+static inline u32 mtk_get_ib1_pkt_type(struct mtk_eth *eth, u32 val)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return FIELD_GET(MTK_FOE_IB1_PACKET_TYPE_V2, val);
+
+	return FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, val);
+}
+
+static inline u32 mtk_get_ib2_multicast_mask(struct mtk_eth *eth)
+{
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		return MTK_FOE_IB2_MULTICAST_V2;
+
+	return MTK_FOE_IB2_MULTICAST;
+}
+
 /* read the hardware status register */
 void mtk_stats_update_mac(struct mtk_mac *mac);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 8c52cfc7ce76..25f8738a062b 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -56,7 +56,7 @@ static u32 ppe_clear(struct mtk_ppe *ppe, u32 reg, u32 val)
 
 static u32 mtk_eth_timestamp(struct mtk_eth *eth)
 {
-	return mtk_r32(eth, 0x0010) & MTK_FOE_IB1_BIND_TIMESTAMP;
+	return mtk_r32(eth, 0x0010) & mtk_get_ib1_ts_mask(eth);
 }
 
 static int mtk_ppe_wait_busy(struct mtk_ppe *ppe)
@@ -93,7 +93,7 @@ static u32 mtk_ppe_hash_entry(struct mtk_eth *eth, struct mtk_foe_entry *e)
 	u32 hv1, hv2, hv3;
 	u32 hash;
 
-	switch (FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, e->ib1)) {
+	switch (mtk_get_ib1_pkt_type(eth, e->ib1)) {
 		case MTK_PPE_PKT_TYPE_IPV4_ROUTE:
 		case MTK_PPE_PKT_TYPE_IPV4_HNAPT:
 			hv1 = e->ipv4.orig.ports;
@@ -129,9 +129,9 @@ static u32 mtk_ppe_hash_entry(struct mtk_eth *eth, struct mtk_foe_entry *e)
 }
 
 static inline struct mtk_foe_mac_info *
-mtk_foe_entry_l2(struct mtk_foe_entry *entry)
+mtk_foe_entry_l2(struct mtk_eth *eth, struct mtk_foe_entry *entry)
 {
-	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
+	int type = mtk_get_ib1_pkt_type(eth, entry->ib1);
 
 	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
 		return &entry->bridge.l2;
@@ -143,9 +143,9 @@ mtk_foe_entry_l2(struct mtk_foe_entry *entry)
 }
 
 static inline u32 *
-mtk_foe_entry_ib2(struct mtk_foe_entry *entry)
+mtk_foe_entry_ib2(struct mtk_eth *eth, struct mtk_foe_entry *entry)
 {
-	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
+	int type = mtk_get_ib1_pkt_type(eth, entry->ib1);
 
 	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
 		return &entry->bridge.ib2;
@@ -156,27 +156,38 @@ mtk_foe_entry_ib2(struct mtk_foe_entry *entry)
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
 
 	memset(entry, 0, sizeof(*entry));
 
-	val = FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_BIND) |
-	      FIELD_PREP(MTK_FOE_IB1_PACKET_TYPE, type) |
-	      FIELD_PREP(MTK_FOE_IB1_UDP, l4proto == IPPROTO_UDP) |
-	      MTK_FOE_IB1_BIND_TTL |
-	      MTK_FOE_IB1_BIND_CACHE;
-	entry->ib1 = val;
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		val = FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_BIND) |
+		      FIELD_PREP(MTK_FOE_IB1_PACKET_TYPE_V2, type) |
+		      FIELD_PREP(MTK_FOE_IB1_UDP, l4proto == IPPROTO_UDP) |
+		      MTK_FOE_IB1_BIND_CACHE_V2 | MTK_FOE_IB1_BIND_TTL_V2;
+		entry->ib1 = val;
 
-	val = FIELD_PREP(MTK_FOE_IB2_PORT_MG, 0x3f) |
-	      FIELD_PREP(MTK_FOE_IB2_PORT_AG, 0x1f) |
-	      FIELD_PREP(MTK_FOE_IB2_DEST_PORT, pse_port);
+		val = FIELD_PREP(MTK_FOE_IB2_DEST_PORT_V2, pse_port) |
+		      FIELD_PREP(MTK_FOE_IB2_PORT_AG_V2, 0xf);
+	} else {
+		val = FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_BIND) |
+		      FIELD_PREP(MTK_FOE_IB1_PACKET_TYPE, type) |
+		      FIELD_PREP(MTK_FOE_IB1_UDP, l4proto == IPPROTO_UDP) |
+		      MTK_FOE_IB1_BIND_CACHE | MTK_FOE_IB1_BIND_TTL;
+		entry->ib1 = val;
+
+		val = FIELD_PREP(MTK_FOE_IB2_DEST_PORT, pse_port) |
+		      FIELD_PREP(MTK_FOE_IB2_PORT_MG, 0x3f) |
+		      FIELD_PREP(MTK_FOE_IB2_PORT_AG, 0x1f);
+	}
 
 	if (is_multicast_ether_addr(dest_mac))
-		val |= MTK_FOE_IB2_MULTICAST;
+		val |= mtk_get_ib2_multicast_mask(eth);
 
 	ports_pad = 0xa5a5a500 | (l4proto & 0xff);
 	if (type == MTK_PPE_PKT_TYPE_IPV4_ROUTE)
@@ -210,24 +221,30 @@ int mtk_foe_entry_prepare(struct mtk_foe_entry *entry, int type, int l4proto,
 	return 0;
 }
 
-int mtk_foe_entry_set_pse_port(struct mtk_foe_entry *entry, u8 port)
+int mtk_foe_entry_set_pse_port(struct mtk_eth *eth,
+			       struct mtk_foe_entry *entry, u8 port)
 {
-	u32 *ib2 = mtk_foe_entry_ib2(entry);
-	u32 val;
+	u32 *ib2 = mtk_foe_entry_ib2(eth, entry);
+	u32 val = *ib2;
 
-	val = *ib2;
-	val &= ~MTK_FOE_IB2_DEST_PORT;
-	val |= FIELD_PREP(MTK_FOE_IB2_DEST_PORT, port);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		val &= ~MTK_FOE_IB2_DEST_PORT_V2;
+		val |= FIELD_PREP(MTK_FOE_IB2_DEST_PORT_V2, port);
+	} else {
+		val &= ~MTK_FOE_IB2_DEST_PORT;
+		val |= FIELD_PREP(MTK_FOE_IB2_DEST_PORT, port);
+	}
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
+	int type = mtk_get_ib1_pkt_type(eth, entry->ib1);
 	struct mtk_ipv4_tuple *t;
 
 	switch (type) {
@@ -262,11 +279,12 @@ int mtk_foe_entry_set_ipv4_tuple(struct mtk_foe_entry *entry, bool egress,
 	return 0;
 }
 
-int mtk_foe_entry_set_ipv6_tuple(struct mtk_foe_entry *entry,
+int mtk_foe_entry_set_ipv6_tuple(struct mtk_eth *eth,
+				 struct mtk_foe_entry *entry,
 				 __be32 *src_addr, __be16 src_port,
 				 __be32 *dest_addr, __be16 dest_port)
 {
-	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
+	int type = mtk_get_ib1_pkt_type(eth, entry->ib1);
 	u32 *src, *dest;
 	int i;
 
@@ -297,39 +315,41 @@ int mtk_foe_entry_set_ipv6_tuple(struct mtk_foe_entry *entry,
 	return 0;
 }
 
-int mtk_foe_entry_set_dsa(struct mtk_foe_entry *entry, int port)
+int mtk_foe_entry_set_dsa(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			  int port)
 {
-	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(entry);
+	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(eth, entry);
 
 	l2->etype = BIT(port);
 
-	if (!(entry->ib1 & MTK_FOE_IB1_BIND_VLAN_LAYER))
-		entry->ib1 |= FIELD_PREP(MTK_FOE_IB1_BIND_VLAN_LAYER, 1);
+	if (!(entry->ib1 & mtk_get_ib1_vlan_layer_mask(eth)))
+		entry->ib1 |= mtk_prep_ib1_vlan_layer(eth, 1);
 	else
 		l2->etype |= BIT(8);
 
-	entry->ib1 &= ~MTK_FOE_IB1_BIND_VLAN_TAG;
+	entry->ib1 &= ~mtk_get_ib1_vlan_tag_mask(eth);
 
 	return 0;
 }
 
-int mtk_foe_entry_set_vlan(struct mtk_foe_entry *entry, int vid)
+int mtk_foe_entry_set_vlan(struct mtk_eth *eth, struct mtk_foe_entry *entry,
+			   int vid)
 {
-	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(entry);
+	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(eth, entry);
 
-	switch (FIELD_GET(MTK_FOE_IB1_BIND_VLAN_LAYER, entry->ib1)) {
+	switch (mtk_prep_ib1_vlan_layer(eth, entry->ib1)) {
 	case 0:
-		entry->ib1 |= MTK_FOE_IB1_BIND_VLAN_TAG |
-			      FIELD_PREP(MTK_FOE_IB1_BIND_VLAN_LAYER, 1);
+		entry->ib1 |= mtk_get_ib1_vlan_tag_mask(eth) |
+			      mtk_prep_ib1_vlan_layer(eth, 1);
 		l2->vlan1 = vid;
 		return 0;
 	case 1:
-		if (!(entry->ib1 & MTK_FOE_IB1_BIND_VLAN_TAG)) {
+		if (!(entry->ib1 & mtk_get_ib1_vlan_tag_mask(eth))) {
 			l2->vlan1 = vid;
 			l2->etype |= BIT(8);
 		} else {
 			l2->vlan2 = vid;
-			entry->ib1 += FIELD_PREP(MTK_FOE_IB1_BIND_VLAN_LAYER, 1);
+			entry->ib1 += mtk_prep_ib1_vlan_layer(eth, 1);
 		}
 		return 0;
 	default:
@@ -337,34 +357,42 @@ int mtk_foe_entry_set_vlan(struct mtk_foe_entry *entry, int vid)
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
+	if (!(entry->ib1 & mtk_get_ib1_vlan_layer_mask(eth)) ||
+	    (entry->ib1 & mtk_get_ib1_vlan_tag_mask(eth)))
 		l2->etype = ETH_P_PPP_SES;
 
-	entry->ib1 |= MTK_FOE_IB1_BIND_PPPOE;
+	entry->ib1 |= mtk_get_ib1_ppoe_mask(eth);
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
-
-	*ib2 &= ~MTK_FOE_IB2_PORT_MG;
-	*ib2 |= MTK_FOE_IB2_WDMA_WINFO;
-	if (wdma_idx)
-		*ib2 |= MTK_FOE_IB2_WDMA_DEVIDX;
+	struct mtk_foe_mac_info *l2 = mtk_foe_entry_l2(eth, entry);
+	u32 *ib2 = mtk_foe_entry_ib2(eth, entry);
 
-	l2->vlan2 = FIELD_PREP(MTK_FOE_VLAN2_WINFO_BSS, bss) |
-		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_WCID, wcid) |
-		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_RING, txq);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		*ib2 &= ~MTK_FOE_IB2_PORT_MG_V2;
+		*ib2 |=  FIELD_PREP(MTK_FOE_IB2_RX_IDX, txq) |
+			 MTK_FOE_IB2_WDMA_WINFO_V2;
+		l2->winfo = FIELD_PREP(MTK_FOE_WINFO_WCID, wcid) |
+			    FIELD_PREP(MTK_FOE_WINFO_BSS, bss);
+	} else {
+		*ib2 &= ~MTK_FOE_IB2_PORT_MG;
+		*ib2 |= MTK_FOE_IB2_WDMA_WINFO;
+		if (wdma_idx)
+			*ib2 |= MTK_FOE_IB2_WDMA_DEVIDX;
+		l2->vlan2 = FIELD_PREP(MTK_FOE_VLAN2_WINFO_BSS, bss) |
+			    FIELD_PREP(MTK_FOE_VLAN2_WINFO_WCID, wcid) |
+			    FIELD_PREP(MTK_FOE_VLAN2_WINFO_RING, txq);
+	}
 
 	return 0;
 }
@@ -376,14 +404,15 @@ static inline bool mtk_foe_entry_usable(struct mtk_foe_entry *entry)
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
+	type = mtk_get_ib1_pkt_type(eth, entry->data.ib1);
 	if (type > MTK_PPE_PKT_TYPE_IPV4_DSLITE)
 		len = offsetof(struct mtk_foe_entry, ipv6._rsv);
 	else
@@ -427,14 +456,12 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 
 static int __mtk_foe_entry_idle_time(struct mtk_ppe *ppe, u32 ib1)
 {
-	u16 timestamp;
-	u16 now;
-
-	now = mtk_eth_timestamp(ppe->eth) & MTK_FOE_IB1_BIND_TIMESTAMP;
-	timestamp = ib1 & MTK_FOE_IB1_BIND_TIMESTAMP;
+	u32 ib1_ts_mask = mtk_get_ib1_ts_mask(ppe->eth);
+	u16 now = mtk_eth_timestamp(ppe->eth);
+	u16 timestamp = ib1 & ib1_ts_mask;
 
 	if (timestamp > now)
-		return MTK_FOE_IB1_BIND_TIMESTAMP + 1 - timestamp + now;
+		return ib1_ts_mask + 1 - timestamp + now;
 	else
 		return now - timestamp;
 }
@@ -442,6 +469,7 @@ static int __mtk_foe_entry_idle_time(struct mtk_ppe *ppe, u32 ib1)
 static void
 mtk_flow_entry_update_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
+	u32 ib1_ts_mask = mtk_get_ib1_ts_mask(ppe->eth);
 	struct mtk_flow_entry *cur;
 	struct mtk_foe_entry *hwe;
 	struct hlist_node *tmp;
@@ -466,8 +494,8 @@ mtk_flow_entry_update_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 			continue;
 
 		idle = cur_idle;
-		entry->data.ib1 &= ~MTK_FOE_IB1_BIND_TIMESTAMP;
-		entry->data.ib1 |= hwe->ib1 & MTK_FOE_IB1_BIND_TIMESTAMP;
+		entry->data.ib1 &= ~ib1_ts_mask;
+		entry->data.ib1 |= hwe->ib1 & ib1_ts_mask;
 	}
 }
 
@@ -489,7 +517,7 @@ mtk_flow_entry_update(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 
 	hwe = mtk_foe_get_entry(ppe, entry->hash);
 	memcpy(&foe, hwe, ppe->eth->soc->foe_entry_size);
-	if (!mtk_flow_entry_match(entry, &foe)) {
+	if (!mtk_flow_entry_match(ppe->eth, entry, &foe)) {
 		entry->hash = 0xffff;
 		goto out;
 	}
@@ -504,16 +532,22 @@ static void
 __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 		       u16 hash)
 {
+	struct mtk_eth *eth = ppe->eth;
+	u16 timestamp = mtk_eth_timestamp(eth);
 	struct mtk_foe_entry *hwe;
-	u16 timestamp;
 
-	timestamp = mtk_eth_timestamp(ppe->eth);
-	timestamp &= MTK_FOE_IB1_BIND_TIMESTAMP;
-	entry->ib1 &= ~MTK_FOE_IB1_BIND_TIMESTAMP;
-	entry->ib1 |= FIELD_PREP(MTK_FOE_IB1_BIND_TIMESTAMP, timestamp);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		entry->ib1 &= ~MTK_FOE_IB1_BIND_TIMESTAMP_V2;
+		entry->ib1 |= FIELD_PREP(MTK_FOE_IB1_BIND_TIMESTAMP_V2,
+					 timestamp);
+	} else {
+		entry->ib1 &= ~MTK_FOE_IB1_BIND_TIMESTAMP;
+		entry->ib1 |= FIELD_PREP(MTK_FOE_IB1_BIND_TIMESTAMP,
+					 timestamp);
+	}
 
 	hwe = mtk_foe_get_entry(ppe, hash);
-	memcpy(&hwe->data, &entry->data, ppe->eth->soc->foe_entry_size);
+	memcpy(&hwe->data, &entry->data, eth->soc->foe_entry_size);
 	wmb();
 	hwe->ib1 = entry->ib1;
 
@@ -540,8 +574,8 @@ mtk_foe_entry_commit_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 
 int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
-	int type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->data.ib1);
 	const struct mtk_soc_data *soc = ppe->eth->soc;
+	int type = mtk_get_ib1_pkt_type(ppe->eth, entry->data.ib1);
 	u32 hash;
 
 	if (type == MTK_PPE_PKT_TYPE_BRIDGE)
@@ -564,7 +598,7 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 	struct mtk_flow_entry *flow_info;
 	struct mtk_foe_entry foe = {}, *hwe;
 	struct mtk_foe_mac_info *l2;
-	u32 ib1_mask = MTK_FOE_IB1_PACKET_TYPE | MTK_FOE_IB1_UDP;
+	u32 ib1_mask = mtk_get_ib1_pkt_type_mask(ppe->eth) | MTK_FOE_IB1_UDP;
 	int type;
 
 	flow_info = kzalloc(offsetof(struct mtk_flow_entry, l2_data.end),
@@ -584,16 +618,16 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 	foe.ib1 &= ib1_mask;
 	foe.ib1 |= entry->data.ib1 & ~ib1_mask;
 
-	l2 = mtk_foe_entry_l2(&foe);
+	l2 = mtk_foe_entry_l2(ppe->eth, &foe);
 	memcpy(l2, &entry->data.bridge.l2, sizeof(*l2));
 
-	type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, foe.ib1);
+	type = mtk_get_ib1_pkt_type(ppe->eth, foe.ib1);
 	if (type == MTK_PPE_PKT_TYPE_IPV4_HNAPT)
 		memcpy(&foe.ipv4.new, &foe.ipv4.orig, sizeof(foe.ipv4.new));
 	else if (type >= MTK_PPE_PKT_TYPE_IPV6_ROUTE_3T && l2->etype == ETH_P_IP)
 		l2->etype = ETH_P_IPV6;
 
-	*mtk_foe_entry_ib2(&foe) = entry->data.bridge.ib2;
+	*mtk_foe_entry_ib2(ppe->eth, &foe) = entry->data.bridge.ib2;
 
 	__mtk_foe_entry_commit(ppe, &foe, hash);
 }
@@ -626,7 +660,7 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 			continue;
 		}
 
-		if (found || !mtk_flow_entry_match(entry, hwe)) {
+		if (found || !mtk_flow_entry_match(ppe->eth, entry, hwe)) {
 			if (entry->hash != 0xffff)
 				entry->hash = 0xffff;
 			continue;
@@ -771,6 +805,8 @@ void mtk_ppe_start(struct mtk_ppe *ppe)
 			 MTK_PPE_SCAN_MODE_KEEPALIVE_AGE) |
 	      FIELD_PREP(MTK_PPE_TB_CFG_ENTRY_NUM,
 			 MTK_PPE_ENTRIES_SHIFT);
+	if (MTK_HAS_CAPS(ppe->eth->soc->caps, MTK_NETSYS_V2))
+		val |= MTK_PPE_TB_CFG_INFO_SEL;
 	ppe_w32(ppe, MTK_PPE_TB_CFG, val);
 
 	ppe_w32(ppe, MTK_PPE_IP_PROTO_CHK,
@@ -778,15 +814,21 @@ void mtk_ppe_start(struct mtk_ppe *ppe)
 
 	mtk_ppe_cache_enable(ppe, true);
 
-	val = MTK_PPE_FLOW_CFG_IP4_TCP_FRAG |
-	      MTK_PPE_FLOW_CFG_IP4_UDP_FRAG |
-	      MTK_PPE_FLOW_CFG_IP6_3T_ROUTE |
+	val = MTK_PPE_FLOW_CFG_IP6_3T_ROUTE |
 	      MTK_PPE_FLOW_CFG_IP6_5T_ROUTE |
 	      MTK_PPE_FLOW_CFG_IP6_6RD |
 	      MTK_PPE_FLOW_CFG_IP4_NAT |
 	      MTK_PPE_FLOW_CFG_IP4_NAPT |
 	      MTK_PPE_FLOW_CFG_IP4_DSLITE |
 	      MTK_PPE_FLOW_CFG_IP4_NAT_FRAG;
+	if (MTK_HAS_CAPS(ppe->eth->soc->caps, MTK_NETSYS_V2))
+		val |= MTK_PPE_MD_TOAP_BYP_CRSN0 |
+		       MTK_PPE_MD_TOAP_BYP_CRSN1 |
+		       MTK_PPE_MD_TOAP_BYP_CRSN2 |
+		       MTK_PPE_FLOW_CFG_IP4_HASH_GRE_KEY;
+	else
+		val |= MTK_PPE_FLOW_CFG_IP4_TCP_FRAG |
+		       MTK_PPE_FLOW_CFG_IP4_UDP_FRAG;
 	ppe_w32(ppe, MTK_PPE_FLOW_CFG, val);
 
 	val = FIELD_PREP(MTK_PPE_UNBIND_AGE_MIN_PACKETS, 1000) |
@@ -820,6 +862,11 @@ void mtk_ppe_start(struct mtk_ppe *ppe)
 	ppe_w32(ppe, MTK_PPE_GLO_CFG, val);
 
 	ppe_w32(ppe, MTK_PPE_DEFAULT_CPU_PORT, 0);
+
+	if (MTK_HAS_CAPS(ppe->eth->soc->caps, MTK_NETSYS_V2)) {
+		ppe_w32(ppe, MTK_PPE_DEFAULT_CPU_PORT1, 0xcb777);
+		ppe_w32(ppe, MTK_PPE_SBW_CTRL, 0x7f);
+	}
 }
 
 int mtk_ppe_stop(struct mtk_ppe *ppe)
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 6d4c91acd1a5..0b7a67a958e4 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -32,6 +32,15 @@
 #define MTK_FOE_IB1_UDP			BIT(30)
 #define MTK_FOE_IB1_STATIC		BIT(31)
 
+/* CONFIG_MEDIATEK_NETSYS_V2 */
+#define MTK_FOE_IB1_BIND_TIMESTAMP_V2	GENMASK(7, 0)
+#define MTK_FOE_IB1_BIND_VLAN_LAYER_V2	GENMASK(16, 14)
+#define MTK_FOE_IB1_BIND_PPPOE_V2	BIT(17)
+#define MTK_FOE_IB1_BIND_VLAN_TAG_V2	BIT(18)
+#define MTK_FOE_IB1_BIND_CACHE_V2	BIT(20)
+#define MTK_FOE_IB1_BIND_TTL_V2		BIT(22)
+#define MTK_FOE_IB1_PACKET_TYPE_V2	GENMASK(27, 23)
+
 enum {
 	MTK_PPE_PKT_TYPE_IPV4_HNAPT = 0,
 	MTK_PPE_PKT_TYPE_IPV4_ROUTE = 1,
@@ -53,14 +62,25 @@ enum {
 
 #define MTK_FOE_IB2_PORT_MG		GENMASK(17, 12)
 
+#define MTK_FOE_IB2_RX_IDX		GENMASK(18, 17)
 #define MTK_FOE_IB2_PORT_AG		GENMASK(23, 18)
 
 #define MTK_FOE_IB2_DSCP		GENMASK(31, 24)
 
+/* CONFIG_MEDIATEK_NETSYS_V2 */
+#define MTK_FOE_IB2_PORT_MG_V2		BIT(7)
+#define MTK_FOE_IB2_DEST_PORT_V2	GENMASK(12, 9)
+#define MTK_FOE_IB2_MULTICAST_V2	BIT(13)
+#define MTK_FOE_IB2_WDMA_WINFO_V2	BIT(19)
+#define MTK_FOE_IB2_PORT_AG_V2		GENMASK(23, 20)
+
 #define MTK_FOE_VLAN2_WINFO_BSS		GENMASK(5, 0)
 #define MTK_FOE_VLAN2_WINFO_WCID	GENMASK(13, 6)
 #define MTK_FOE_VLAN2_WINFO_RING	GENMASK(15, 14)
 
+#define MTK_FOE_WINFO_BSS		GENMASK(5, 0)
+#define MTK_FOE_WINFO_WCID		GENMASK(15, 6)
+
 enum {
 	MTK_FOE_STATE_INVALID,
 	MTK_FOE_STATE_UNBIND,
@@ -81,6 +101,9 @@ struct mtk_foe_mac_info {
 
 	u16 pppoe_id;
 	u16 src_mac_lo;
+
+	u16 minfo;
+	u16 winfo;
 };
 
 /* software-only entry type */
@@ -198,7 +221,7 @@ struct mtk_foe_entry {
 		struct mtk_foe_ipv4_dslite dslite;
 		struct mtk_foe_ipv6 ipv6;
 		struct mtk_foe_ipv6_6rd ipv6_6rd;
-		u32 data[19];
+		u32 data[23];
 	};
 };
 
@@ -306,20 +329,27 @@ mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
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
index 0324e7750065..c63eeee0ceba 100644
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
@@ -190,16 +191,29 @@ mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 	int pse_port, dsa_port;
 
 	if (mtk_flow_get_wdma_info(dev, dest_mac, &info) == 0) {
-		mtk_foe_entry_set_wdma(foe, info.wdma_idx, info.queue, info.bss,
-				       info.wcid);
-		pse_port = 3;
+		mtk_foe_entry_set_wdma(eth, foe, info.wdma_idx, info.queue,
+				       info.bss, info.wcid);
+		if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+			switch (info.wdma_idx) {
+			case 0:
+				pse_port = 8;
+				break;
+			case 1:
+				pse_port = 9;
+				break;
+			default:
+				return -EINVAL;
+			}
+		} else {
+			pse_port = 3;
+		}
 		*wed_index = info.wdma_idx;
 		goto out;
 	}
 
 	dsa_port = mtk_flow_get_dsa_port(&dev);
 	if (dsa_port >= 0)
-		mtk_foe_entry_set_dsa(foe, dsa_port);
+		mtk_foe_entry_set_dsa(eth, foe, dsa_port);
 
 	if (dev == eth->netdev[0])
 		pse_port = 1;
@@ -209,7 +223,7 @@ mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 		return -EOPNOTSUPP;
 
 out:
-	mtk_foe_entry_set_pse_port(foe, pse_port);
+	mtk_foe_entry_set_pse_port(eth, foe, pse_port);
 
 	return 0;
 }
@@ -333,9 +347,8 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	    !is_valid_ether_addr(data.eth.h_dest))
 		return -EINVAL;
 
-	err = mtk_foe_entry_prepare(&foe, offload_type, l4proto, 0,
-				    data.eth.h_source,
-				    data.eth.h_dest);
+	err = mtk_foe_entry_prepare(eth, &foe, offload_type, l4proto, 0,
+				    data.eth.h_source, data.eth.h_dest);
 	if (err)
 		return err;
 
@@ -360,7 +373,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 		data.v4.src_addr = addrs.key->src;
 		data.v4.dst_addr = addrs.key->dst;
 
-		mtk_flow_set_ipv4_addr(&foe, &data, false);
+		mtk_flow_set_ipv4_addr(eth, &foe, &data, false);
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
@@ -371,7 +384,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 		data.v6.src_addr = addrs.key->src;
 		data.v6.dst_addr = addrs.key->dst;
 
-		mtk_flow_set_ipv6_addr(&foe, &data);
+		mtk_flow_set_ipv6_addr(eth, &foe, &data);
 	}
 
 	flow_action_for_each(i, act, &rule->action) {
@@ -401,7 +414,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	}
 
 	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-		err = mtk_flow_set_ipv4_addr(&foe, &data, true);
+		err = mtk_flow_set_ipv4_addr(eth, &foe, &data, true);
 		if (err)
 			return err;
 	}
@@ -413,10 +426,10 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
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
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h b/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
index 0c45ea0900f1..59596d823d8b 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
@@ -21,6 +21,9 @@
 #define MTK_PPE_GLO_CFG_BUSY			BIT(31)
 
 #define MTK_PPE_FLOW_CFG			0x204
+#define MTK_PPE_MD_TOAP_BYP_CRSN0		BIT(1)
+#define MTK_PPE_MD_TOAP_BYP_CRSN1		BIT(2)
+#define MTK_PPE_MD_TOAP_BYP_CRSN2		BIT(3)
 #define MTK_PPE_FLOW_CFG_IP4_TCP_FRAG		BIT(6)
 #define MTK_PPE_FLOW_CFG_IP4_UDP_FRAG		BIT(7)
 #define MTK_PPE_FLOW_CFG_IP6_3T_ROUTE		BIT(8)
@@ -54,6 +57,7 @@
 #define MTK_PPE_TB_CFG_HASH_MODE		GENMASK(15, 14)
 #define MTK_PPE_TB_CFG_SCAN_MODE		GENMASK(17, 16)
 #define MTK_PPE_TB_CFG_HASH_DEBUG		GENMASK(19, 18)
+#define MTK_PPE_TB_CFG_INFO_SEL			BIT(20)
 
 enum {
 	MTK_PPE_SCAN_MODE_DISABLED,
@@ -112,6 +116,8 @@ enum {
 #define MTK_PPE_DEFAULT_CPU_PORT		0x248
 #define MTK_PPE_DEFAULT_CPU_PORT_MASK(_n)	(GENMASK(2, 0) << ((_n) * 4))
 
+#define MTK_PPE_DEFAULT_CPU_PORT1		0x24c
+
 #define MTK_PPE_MTU_DROP			0x308
 
 #define MTK_PPE_VLAN_MTU0			0x30c
@@ -141,4 +147,6 @@ enum {
 #define MTK_PPE_MIB_CACHE_CTL_EN		BIT(0)
 #define MTK_PPE_MIB_CACHE_CTL_FLUSH		BIT(2)
 
+#define MTK_PPE_SBW_CTRL			0x374
+
 #endif
-- 
2.37.3

