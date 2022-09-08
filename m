Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FEE5B26E5
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiIHTgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiIHTfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:35:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4FCC6FF2;
        Thu,  8 Sep 2022 12:35:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2017961DFA;
        Thu,  8 Sep 2022 19:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F281BC433C1;
        Thu,  8 Sep 2022 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662665748;
        bh=N3gGUtPQnoarYcxL8xMDNl4MjAyEvlH2AOujjg7IviY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtTgWZ21IgLgZN9BGhoFLOfOjFs1hCqGPu9QOxyUXs7n2Rg5OE9v1AA8/vcgIKlzT
         /PPYoEKYV7Rj9SNIKjMScLxi9U8nbSJUif8KYw3ouAfO4s93K4jlxD0x8UvUXzbdU/
         rgdaPBzJNR3/WGwWVZmV40e+Zws3F2SbRWxClwzIFHrSMxuAnRhP5FahOxEE+GbOH1
         m5KsDEt5IW/UCCKXCn98UWLvXesTiT27gD7a74ArPqHIzUBP41k/XEGano0N02PJp2
         7B+OBIOV3nhBaVeZO1TH1x/SVJ3lmHSLeMpGbmWVpH41Z5bf3HLEswr7WNECbNNNCK
         AVaCfVAjybLag==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: [PATCH net-next 12/12] net: ethernet: mtk_eth_soc: introduce flow offloading support for mt7986
Date:   Thu,  8 Sep 2022 21:33:46 +0200
Message-Id: <6775ed6546cacd174a165c7085f7e1f77db9f30c.1662661555.git.lorenzo@kernel.org>
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

Introduce hw flow offload support for mt7986 chipset. PPE is not enabled
yet in mt7986 since mt76 support is not available yet.

Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 27 +++++++++--
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 45 ++++++++++++++-----
 drivers/net/ethernet/mediatek/mtk_ppe.h       | 10 ++++-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 15 ++++++-
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |  8 ++++
 5 files changed, 87 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 7dae650c4586..cc790f12c9cc 100644
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
 
@@ -4241,7 +4242,7 @@ static const struct mtk_soc_data mt7621_data = {
 		.dma_len_offset = 16,
 	},
 	.foe = {
-		.entry_size = sizeof(struct mtk_foe_entry),
+		.entry_size = sizeof(struct mtk_foe_entry) - 16,
 		.hash_offset = 2,
 		.ib1 = {
 			.bind_ppoe = BIT(19),
@@ -4279,7 +4280,7 @@ static const struct mtk_soc_data mt7622_data = {
 		.dma_len_offset = 16,
 	},
 	.foe = {
-		.entry_size = sizeof(struct mtk_foe_entry),
+		.entry_size = sizeof(struct mtk_foe_entry) - 16,
 		.hash_offset = 2,
 		.ib1 = {
 			.bind_ppoe = BIT(19),
@@ -4323,7 +4324,7 @@ static const struct mtk_soc_data mt7623_data = {
 		.dma_len_offset = 16,
 	},
 	.foe = {
-		.entry_size = sizeof(struct mtk_foe_entry),
+		.entry_size = sizeof(struct mtk_foe_entry) - 16,
 		.hash_offset = 2,
 		.ib1 = {
 			.bind_ppoe = BIT(19),
@@ -4365,6 +4366,7 @@ static const struct mtk_soc_data mt7986_data = {
 	.reg_map = &mt7986_reg_map,
 	.ana_rgc3 = 0x128,
 	.caps = MT7986_CAPS,
+	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7986_CLKS_BITMAP,
 	.required_pctl = false,
 	.txrx = {
@@ -4376,7 +4378,24 @@ static const struct mtk_soc_data mt7986_data = {
 		.dma_len_offset = 8,
 	},
 	.foe = {
+		.entry_size = sizeof(struct mtk_foe_entry),
 		.hash_offset = 4,
+		.ib1 = {
+			.bind_ppoe = BIT(17),
+			.bind_vlan_tag = BIT(18),
+			.bind_cache = BIT(20),
+			.bind_ttl = BIT(22),
+			.bind_ts = GENMASK(7, 0),
+			.bind_vlan_layer = GENMASK(16, 14),
+			.pkt_type = GENMASK(27, 23),
+		},
+		.ib2 = {
+			.multicast = BIT(13),
+			.wdma_winfo = BIT(19),
+			.port_ag = GENMASK(23, 20),
+			.port_mg = BIT(7),
+			.dst_port = GENMASK(12, 9),
+		},
 	},
 	.wed = {
 		.desc_ctrl_len1 = GENMASK(13, 0),
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 4248a3b78aa6..4d495c2b19e3 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -172,9 +172,12 @@ int mtk_foe_entry_prepare(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 	      eth->soc->foe.ib1.bind_cache;
 	entry->ib1 = val;
 
-	val = MTK_FIELD_PREP(eth->soc->foe.ib2.port_mg, 0x3f) |
-	      MTK_FIELD_PREP(eth->soc->foe.ib2.port_ag, 0x1f) |
-	      MTK_FIELD_PREP(eth->soc->foe.ib2.dst_port, pse_port);
+	val = MTK_FIELD_PREP(eth->soc->foe.ib2.dst_port, pse_port);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2))
+		val |= MTK_FIELD_PREP(eth->soc->foe.ib2.port_ag, 0xf);
+	else
+		val |= MTK_FIELD_PREP(eth->soc->foe.ib2.port_mg, 0x3f) |
+		       MTK_FIELD_PREP(eth->soc->foe.ib2.port_ag, 0x1f);
 
 	if (is_multicast_ether_addr(dest_mac))
 		val |= eth->soc->foe.ib2.multicast;
@@ -370,12 +373,17 @@ int mtk_foe_entry_set_wdma(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 
 	*ib2 &= ~eth->soc->foe.ib2.port_mg;
 	*ib2 |= eth->soc->foe.ib2.wdma_winfo;
-	if (wdma_idx)
-		*ib2 |= MTK_FOE_IB2_WDMA_DEVIDX;
-
-	l2->vlan2 = FIELD_PREP(MTK_FOE_VLAN2_WINFO_BSS, bss) |
-		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_WCID, wcid) |
-		    FIELD_PREP(MTK_FOE_VLAN2_WINFO_RING, txq);
+	if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
+		*ib2 |=  FIELD_PREP(MTK_FOE_IB2_RX_IDX, txq);
+		l2->winfo = FIELD_PREP(MTK_FOE_WINFO_WCID, wcid) |
+			    FIELD_PREP(MTK_FOE_WINFO_BSS, bss);
+	} else {
+		if (wdma_idx)
+			*ib2 |= MTK_FOE_IB2_WDMA_DEVIDX;
+		l2->vlan2 = FIELD_PREP(MTK_FOE_VLAN2_WINFO_BSS, bss) |
+			    FIELD_PREP(MTK_FOE_VLAN2_WINFO_WCID, wcid) |
+			    FIELD_PREP(MTK_FOE_VLAN2_WINFO_RING, txq);
+	}
 
 	return 0;
 }
@@ -784,6 +792,8 @@ void mtk_ppe_start(struct mtk_ppe *ppe)
 			 MTK_PPE_SCAN_MODE_KEEPALIVE_AGE) |
 	      FIELD_PREP(MTK_PPE_TB_CFG_ENTRY_NUM,
 			 MTK_PPE_ENTRIES_SHIFT);
+	if (MTK_HAS_CAPS(ppe->eth->soc->caps, MTK_NETSYS_V2))
+		val |= MTK_PPE_TB_CFG_INFO_SEL;
 	ppe_w32(ppe, MTK_PPE_TB_CFG, val);
 
 	ppe_w32(ppe, MTK_PPE_IP_PROTO_CHK,
@@ -791,15 +801,21 @@ void mtk_ppe_start(struct mtk_ppe *ppe)
 
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
@@ -833,6 +849,11 @@ void mtk_ppe_start(struct mtk_ppe *ppe)
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
index a364f45edf38..1f584fd0632d 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -53,6 +53,7 @@ enum {
 
 #define MTK_FOE_IB2_PORT_MG		GENMASK(17, 12)
 
+#define MTK_FOE_IB2_RX_IDX		GENMASK(18, 17)
 #define MTK_FOE_IB2_PORT_AG		GENMASK(23, 18)
 
 #define MTK_FOE_IB2_DSCP		GENMASK(31, 24)
@@ -61,8 +62,12 @@ enum {
 #define MTK_FOE_VLAN2_WINFO_WCID	GENMASK(13, 6)
 #define MTK_FOE_VLAN2_WINFO_RING	GENMASK(15, 14)
 
+#define MTK_FOE_WINFO_BSS		GENMASK(5, 0)
+#define MTK_FOE_WINFO_WCID		GENMASK(15, 6)
+
 #define MTK_FIELD_PREP(mask, val)	(((typeof(mask))(val) << __bf_shf(mask)) & (mask))
 #define MTK_FIELD_GET(mask, val)	((typeof(mask))(((val) & (mask)) >> __bf_shf(mask)))
+
 enum {
 	MTK_FOE_STATE_INVALID,
 	MTK_FOE_STATE_UNBIND,
@@ -83,6 +88,9 @@ struct mtk_foe_mac_info {
 
 	u16 pppoe_id;
 	u16 src_mac_lo;
+
+	u16 minfo;
+	u16 winfo;
 };
 
 /* software-only entry type */
@@ -200,7 +208,7 @@ struct mtk_foe_entry {
 		struct mtk_foe_ipv4_dslite dslite;
 		struct mtk_foe_ipv6 ipv6;
 		struct mtk_foe_ipv6_6rd ipv6_6rd;
-		u32 data[19];
+		u32 data[23];
 	};
 };
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 56c49ac712b9..c63eeee0ceba 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -193,7 +193,20 @@ mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
 	if (mtk_flow_get_wdma_info(dev, dest_mac, &info) == 0) {
 		mtk_foe_entry_set_wdma(eth, foe, info.wdma_idx, info.queue,
 				       info.bss, info.wcid);
-		pse_port = 3;
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

