Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84AA091276
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfHQSzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 14:55:15 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:52508 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbfHQSy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 14:54:59 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6E3D7C01E4;
        Sat, 17 Aug 2019 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1566068098; bh=qSsoDw5Kb8id+IBnMSMyV/giu6lyQZG3grmqFoY0f4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=SlgPT9pYG9wNvvMc4cJYT3cv1qC6j7D5TokY+pPK386CURzXVa/sHqxdFZ3IhunuQ
         ogwp0u17PgSoXYb6LaxiD2ClNApUx0O65nkCytGkJbV93IOkCa03FPEycZvWL2xGVV
         FmVp/HqsetaYzjATQb16fDK0z9TQQOibtIhWAQNVX6N5rh5S1fxeIHenOAJh43m8Uw
         ML69o1ESG9cXUGt2mCw1EihG28GfH7UOpU1kBbkpzpAhm5td+UUMWwIxCKNqdNA37R
         MD+7Zn2DMqinWkHTpGaYLsKiqSTsoOfG6qloDe3Vn3EAKjQHW9tBdN9uID9EgCphVe
         N3azd1l8YxGaA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 13661A007F;
        Sat, 17 Aug 2019 18:54:56 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 11/12] net: stmmac: Add support for VLAN Insertion Offload
Date:   Sat, 17 Aug 2019 20:54:50 +0200
Message-Id: <908ef3f484172f1e7a8bb86c1788bdc426c9c41e.1566067803.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
In-Reply-To: <cover.1566067802.git.joabreu@synopsys.com>
References: <cover.1566067802.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the logic to insert a given VLAN ID in a packet. This is offloaded
to HW and its descriptor based. For now, only XGMAC implements the
necessary callbacks.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/common.h       |  8 ++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 15 +++++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 14 ++++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   | 35 +++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  2 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         | 10 +++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 52 +++++++++++++++++++++-
 7 files changed, 135 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 1303ec81fd3d..49aa56ca09cc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -358,6 +358,8 @@ struct dma_features {
 	unsigned int rssen;
 	unsigned int vlhash;
 	unsigned int sphen;
+	unsigned int vlins;
+	unsigned int dvlan;
 };
 
 /* GMAC TX FIFO is 8K, Rx FIFO is 16K */
@@ -389,6 +391,12 @@ struct dma_features {
 #define STMMAC_RSS_HASH_KEY_SIZE	40
 #define STMMAC_RSS_MAX_TABLE_SIZE	256
 
+/* VLAN */
+#define STMMAC_VLAN_NONE	0x0
+#define STMMAC_VLAN_REMOVE	0x1
+#define STMMAC_VLAN_INSERT	0x2
+#define STMMAC_VLAN_REPLACE	0x3
+
 extern const struct stmmac_desc_ops enh_desc_ops;
 extern const struct stmmac_desc_ops ndesc_ops;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 79c145ba25a8..7357b8bdc128 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -63,6 +63,11 @@
 #define XGMAC_VLAN_ETV			BIT(16)
 #define XGMAC_VLAN_VID			GENMASK(15, 0)
 #define XGMAC_VLAN_HASH_TABLE		0x00000058
+#define XGMAC_VLAN_INCL			0x00000060
+#define XGMAC_VLAN_VLTI			BIT(20)
+#define XGMAC_VLAN_CSVL			BIT(19)
+#define XGMAC_VLAN_VLC			GENMASK(17, 16)
+#define XGMAC_VLAN_VLC_SHIFT		16
 #define XGMAC_RXQ_CTRL0			0x000000a0
 #define XGMAC_RXQEN(x)			GENMASK((x) * 2 + 1, (x) * 2)
 #define XGMAC_RXQEN_SHIFT(x)		((x) * 2)
@@ -128,6 +133,7 @@
 #define XGMAC_HWFEAT_RXQCNT		GENMASK(3, 0)
 #define XGMAC_HW_FEATURE3		0x00000128
 #define XGMAC_HWFEAT_ASP		GENMASK(15, 14)
+#define XGMAC_HWFEAT_DVLAN		BIT(13)
 #define XGMAC_HWFEAT_FRPES		GENMASK(12, 11)
 #define XGMAC_HWFEAT_FRPPB		GENMASK(10, 9)
 #define XGMAC_HWFEAT_FRPSEL		BIT(3)
@@ -337,10 +343,14 @@
 #define XGMAC_REGSIZE			((0x0000317c + (0x80 * 15)) / 4)
 
 /* Descriptors */
+#define XGMAC_TDES2_IVT			GENMASK(31, 16)
+#define XGMAC_TDES2_IVT_SHIFT		16
 #define XGMAC_TDES2_IOC			BIT(31)
 #define XGMAC_TDES2_TTSE		BIT(30)
 #define XGMAC_TDES2_B2L			GENMASK(29, 16)
 #define XGMAC_TDES2_B2L_SHIFT		16
+#define XGMAC_TDES2_VTIR		GENMASK(15, 14)
+#define XGMAC_TDES2_VTIR_SHIFT		14
 #define XGMAC_TDES2_B1L			GENMASK(13, 0)
 #define XGMAC_TDES3_OWN			BIT(31)
 #define XGMAC_TDES3_CTXT		BIT(30)
@@ -353,10 +363,15 @@
 #define XGMAC_TDES3_SAIC_SHIFT		23
 #define XGMAC_TDES3_THL			GENMASK(22, 19)
 #define XGMAC_TDES3_THL_SHIFT		19
+#define XGMAC_TDES3_IVTIR		GENMASK(19, 18)
+#define XGMAC_TDES3_IVTIR_SHIFT		18
 #define XGMAC_TDES3_TSE			BIT(18)
+#define XGMAC_TDES3_IVLTV		BIT(17)
 #define XGMAC_TDES3_CIC			GENMASK(17, 16)
 #define XGMAC_TDES3_CIC_SHIFT		16
 #define XGMAC_TDES3_TPL			GENMASK(17, 0)
+#define XGMAC_TDES3_VLTV		BIT(16)
+#define XGMAC_TDES3_VT			GENMASK(15, 0)
 #define XGMAC_TDES3_FL			GENMASK(14, 0)
 #define XGMAC_RDES2_HL			GENMASK(9, 0)
 #define XGMAC_RDES3_OWN			BIT(31)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index d8483d088711..e534a3aaf4a3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -1150,6 +1150,19 @@ static void dwxgmac2_sarc_configure(void __iomem *ioaddr, int val)
 	writel(value, ioaddr + XGMAC_TX_CONFIG);
 }
 
+static void dwxgmac2_enable_vlan(struct mac_device_info *hw, u32 type)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	value = readl(ioaddr + XGMAC_VLAN_INCL);
+	value |= XGMAC_VLAN_VLTI;
+	value |= XGMAC_VLAN_CSVL; /* Only use SVLAN */
+	value &= ~XGMAC_VLAN_VLC;
+	value |= (type << XGMAC_VLAN_VLC_SHIFT) & XGMAC_VLAN_VLC;
+	writel(value, ioaddr + XGMAC_VLAN_INCL);
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -1189,6 +1202,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.get_mac_tx_timestamp = dwxgmac2_get_mac_tx_timestamp,
 	.flex_pps_config = dwxgmac2_flex_pps_config,
 	.sarc_configure = dwxgmac2_sarc_configure,
+	.enable_vlan = dwxgmac2_enable_vlan,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index ab11e73ac6b1..ae48154f933c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -305,6 +305,39 @@ static void dwxgmac2_set_sarc(struct dma_desc *p, u32 sarc_type)
 	p->des3 |= cpu_to_le32(sarc_type & XGMAC_TDES3_SAIC);
 }
 
+static void dwxgmac2_set_vlan_tag(struct dma_desc *p, u16 tag, u16 inner_tag,
+				  u32 inner_type)
+{
+	p->des0 = 0;
+	p->des1 = 0;
+	p->des2 = 0;
+	p->des3 = 0;
+
+	/* Inner VLAN */
+	if (inner_type) {
+		u32 des = inner_tag << XGMAC_TDES2_IVT_SHIFT;
+
+		des &= XGMAC_TDES2_IVT;
+		p->des2 = cpu_to_le32(des);
+
+		des = inner_type << XGMAC_TDES3_IVTIR_SHIFT;
+		des &= XGMAC_TDES3_IVTIR;
+		p->des3 = cpu_to_le32(des | XGMAC_TDES3_IVLTV);
+	}
+
+	/* Outer VLAN */
+	p->des3 |= cpu_to_le32(tag & XGMAC_TDES3_VT);
+	p->des3 |= cpu_to_le32(XGMAC_TDES3_VLTV);
+
+	p->des3 |= cpu_to_le32(XGMAC_TDES3_CTXT);
+}
+
+static void dwxgmac2_set_vlan(struct dma_desc *p, u32 type)
+{
+	type <<= XGMAC_TDES2_VTIR_SHIFT;
+	p->des2 |= cpu_to_le32(type & XGMAC_TDES2_VTIR);
+}
+
 const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.tx_status = dwxgmac2_get_tx_status,
 	.rx_status = dwxgmac2_get_rx_status,
@@ -332,4 +365,6 @@ const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.get_rx_header_len = dwxgmac2_get_rx_header_len,
 	.set_sec_addr = dwxgmac2_set_sec_addr,
 	.set_sarc = dwxgmac2_set_sarc,
+	.set_vlan_tag = dwxgmac2_set_vlan_tag,
+	.set_vlan = dwxgmac2_set_vlan,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index f2d5901fbaff..64956465c030 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -359,6 +359,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 
 	/*  MAC HW feature 0 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE0);
+	dma_cap->vlins = (hw_cap & XGMAC_HWFEAT_SAVLANINS) >> 27;
 	dma_cap->rx_coe = (hw_cap & XGMAC_HWFEAT_RXCOESEL) >> 16;
 	dma_cap->tx_coe = (hw_cap & XGMAC_HWFEAT_TXCOESEL) >> 14;
 	dma_cap->eee = (hw_cap & XGMAC_HWFEAT_EEESEL) >> 13;
@@ -413,6 +414,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	/* MAC HW feature 3 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE3);
 	dma_cap->asp = (hw_cap & XGMAC_HWFEAT_ASP) >> 14;
+	dma_cap->dvlan = (hw_cap & XGMAC_HWFEAT_DVLAN) >> 13;
 	dma_cap->frpes = (hw_cap & XGMAC_HWFEAT_FRPES) >> 11;
 	dma_cap->frpbs = (hw_cap & XGMAC_HWFEAT_FRPPB) >> 9;
 	dma_cap->frpsel = (hw_cap & XGMAC_HWFEAT_FRPSEL) >> 3;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index e54864cde01b..9435b312495d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -92,6 +92,9 @@ struct stmmac_desc_ops {
 	int (*get_rx_header_len)(struct dma_desc *p, unsigned int *len);
 	void (*set_sec_addr)(struct dma_desc *p, dma_addr_t addr);
 	void (*set_sarc)(struct dma_desc *p, u32 sarc_type);
+	void (*set_vlan_tag)(struct dma_desc *p, u16 tag, u16 inner_tag,
+			     u32 inner_type);
+	void (*set_vlan)(struct dma_desc *p, u32 type);
 };
 
 #define stmmac_init_rx_desc(__priv, __args...) \
@@ -150,6 +153,10 @@ struct stmmac_desc_ops {
 	stmmac_do_void_callback(__priv, desc, set_sec_addr, __args)
 #define stmmac_set_desc_sarc(__priv, __args...) \
 	stmmac_do_void_callback(__priv, desc, set_sarc, __args)
+#define stmmac_set_desc_vlan_tag(__priv, __args...) \
+	stmmac_do_void_callback(__priv, desc, set_vlan_tag, __args)
+#define stmmac_set_desc_vlan(__priv, __args...) \
+	stmmac_do_void_callback(__priv, desc, set_vlan, __args)
 
 struct stmmac_dma_cfg;
 struct dma_features;
@@ -351,6 +358,7 @@ struct stmmac_ops {
 	/* VLAN */
 	void (*update_vlan_hash)(struct mac_device_info *hw, u32 hash,
 				 bool is_double);
+	void (*enable_vlan)(struct mac_device_info *hw, u32 type);
 	/* TX Timestamp */
 	int (*get_mac_tx_timestamp)(struct mac_device_info *hw, u64 *ts);
 	/* Source Address Insertion / Replacement */
@@ -429,6 +437,8 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, rss_configure, __args)
 #define stmmac_update_vlan_hash(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, update_vlan_hash, __args)
+#define stmmac_enable_vlan(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, enable_vlan, __args)
 #define stmmac_get_mac_tx_timestamp(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, get_mac_tx_timestamp, __args)
 #define stmmac_sarc_configure(__priv, __args...) \
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8e38b053d9ab..bd1078433448 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2617,6 +2617,10 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 			stmmac_enable_sph(priv, priv->ioaddr, 1, chan);
 	}
 
+	/* VLAN Tag Insertion */
+	if (priv->dma_cap.vlins)
+		stmmac_enable_vlan(priv, priv->hw, STMMAC_VLAN_INSERT);
+
 	/* Start the ball rolling... */
 	stmmac_start_all_dma(priv);
 
@@ -2794,6 +2798,33 @@ static int stmmac_release(struct net_device *dev)
 	return 0;
 }
 
+static bool stmmac_vlan_insert(struct stmmac_priv *priv, struct sk_buff *skb,
+			       struct stmmac_tx_queue *tx_q)
+{
+	u16 tag = 0x0, inner_tag = 0x0;
+	u32 inner_type = 0x0;
+	struct dma_desc *p;
+
+	if (!priv->dma_cap.vlins)
+		return false;
+	if (!skb_vlan_tag_present(skb))
+		return false;
+	if (skb->vlan_proto == htons(ETH_P_8021AD)) {
+		inner_tag = skb_vlan_tag_get(skb);
+		inner_type = STMMAC_VLAN_INSERT;
+	}
+
+	tag = skb_vlan_tag_get(skb);
+
+	p = tx_q->dma_tx + tx_q->cur_tx;
+	if (stmmac_set_desc_vlan_tag(priv, p, tag, inner_tag, inner_type))
+		return false;
+
+	stmmac_set_tx_owner(priv, p);
+	tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, DMA_TX_SIZE);
+	return true;
+}
+
 /**
  *  stmmac_tso_allocator - close entry point of the driver
  *  @priv: driver private structure
@@ -2873,12 +2904,13 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int nfrags = skb_shinfo(skb)->nr_frags;
 	u32 queue = skb_get_queue_mapping(skb);
-	unsigned int first_entry;
 	struct stmmac_tx_queue *tx_q;
+	unsigned int first_entry;
 	int tmp_pay_len = 0;
 	u32 pay_len, mss;
 	u8 proto_hdr_len;
 	dma_addr_t des;
+	bool has_vlan;
 	int i;
 
 	tx_q = &priv->tx_queue[queue];
@@ -2920,12 +2952,18 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 			skb->data_len);
 	}
 
+	/* Check if VLAN can be inserted by HW */
+	has_vlan = stmmac_vlan_insert(priv, skb, tx_q);
+
 	first_entry = tx_q->cur_tx;
 	WARN_ON(tx_q->tx_skbuff[first_entry]);
 
 	desc = tx_q->dma_tx + first_entry;
 	first = desc;
 
+	if (has_vlan)
+		stmmac_set_desc_vlan(priv, first, STMMAC_VLAN_INSERT);
+
 	/* first descriptor: fill Headers on Buf1 */
 	des = dma_map_single(priv->device, skb->data, skb_headlen(skb),
 			     DMA_TO_DEVICE);
@@ -3085,6 +3123,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned int first_entry;
 	unsigned int enh_desc;
 	dma_addr_t des;
+	bool has_vlan;
 	int entry;
 
 	tx_q = &priv->tx_queue[queue];
@@ -3110,6 +3149,9 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 	}
 
+	/* Check if VLAN can be inserted by HW */
+	has_vlan = stmmac_vlan_insert(priv, skb, tx_q);
+
 	entry = tx_q->cur_tx;
 	first_entry = entry;
 	WARN_ON(tx_q->tx_skbuff[first_entry]);
@@ -3123,6 +3165,9 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	first = desc;
 
+	if (has_vlan)
+		stmmac_set_desc_vlan(priv, first, STMMAC_VLAN_INSERT);
+
 	enh_desc = priv->plat->enh_desc;
 	/* To program the descriptors according to the size of the frame */
 	if (enh_desc)
@@ -4473,6 +4518,11 @@ int stmmac_dvr_probe(struct device *device,
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 		ndev->features |= NETIF_F_HW_VLAN_STAG_FILTER;
 	}
+	if (priv->dma_cap.vlins) {
+		ndev->features |= NETIF_F_HW_VLAN_CTAG_TX;
+		if (priv->dma_cap.dvlan)
+			ndev->features |= NETIF_F_HW_VLAN_STAG_TX;
+	}
 #endif
 	priv->msg_enable = netif_msg_init(debug, default_msg_level);
 
-- 
2.7.4

