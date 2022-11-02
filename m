Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9827C61569B
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 01:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiKBAnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 20:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKBAnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 20:43:09 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCC718E31;
        Tue,  1 Nov 2022 17:43:05 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1oq1qC-0007tB-AT; Wed, 02 Nov 2022 01:42:48 +0100
Date:   Wed, 2 Nov 2022 00:42:40 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: ethernet: mediatek: ppe: add support for flow
 accounting
Message-ID: <Y2G9ANkdaaENNnOd@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PPE units found in MT7622 and newer support packet and byte
accounting of hw-offloaded flows. Add support for reading those
counters as found in MediaTek's SDK[1].

[1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
v3: don't bother to set 'false' values in any zero-initialized struct
    use mtk_foe_entry_ib2
    both changes were requested by Felix Fietkau

v2: fix wrong variable name in return value check spotted by Denis Kirjanov


 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   7 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |   1 +
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 110 +++++++++++++++++-
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  23 +++-
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   9 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |   7 ++
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |  14 +++
 7 files changed, 166 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 789268b15106ec..c059315d9c080d 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4140,7 +4140,9 @@ static int mtk_probe(struct platform_device *pdev)
 			u32 ppe_addr = eth->soc->reg_map->ppe_base + i * 0x400;
 
 			eth->ppe[i] = mtk_ppe_init(eth, eth->base + ppe_addr,
-						   eth->soc->offload_version, i);
+						   eth->soc->offload_version, i,
+						   eth->soc->has_accounting);
+
 			if (!eth->ppe[i]) {
 				err = -ENOMEM;
 				goto err_free_dev;
@@ -4259,6 +4261,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.required_pctl = false,
 	.offload_version = 2,
 	.hash_offset = 2,
+	.has_accounting = true,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
@@ -4296,6 +4299,7 @@ static const struct mtk_soc_data mt7629_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7629_CLKS_BITMAP,
 	.required_pctl = false,
+	.has_accounting = true,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4315,6 +4319,7 @@ static const struct mtk_soc_data mt7986_data = {
 	.required_pctl = false,
 	.hash_offset = 4,
 	.foe_entry_size = sizeof(struct mtk_foe_entry),
+	.has_accounting = true,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma_v2),
 		.rxd_size = sizeof(struct mtk_rx_dma_v2),
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 589f27ddc40163..6c2a0a1826c3c7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -993,6 +993,7 @@ struct mtk_soc_data {
 	u8		hash_offset;
 	u16		foe_entry_size;
 	netdev_features_t hw_features;
+	bool		has_accounting;
 	struct {
 		u32	txd_size;
 		u32	rxd_size;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 2d8ca99f2467ff..349cdfb92ae029 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -74,6 +74,46 @@ static int mtk_ppe_wait_busy(struct mtk_ppe *ppe)
 	return ret;
 }
 
+static int mtk_ppe_mib_wait_busy(struct mtk_ppe *ppe)
+{
+	int ret;
+	u32 val;
+
+	ret = readl_poll_timeout(ppe->base + MTK_PPE_MIB_SER_CR, val,
+				 !(val & MTK_PPE_MIB_SER_CR_ST),
+				 20, MTK_PPE_WAIT_TIMEOUT_US);
+
+	if (ret)
+		dev_err(ppe->dev, "MIB table busy");
+
+	return ret;
+}
+
+int mtk_mib_entry_read(struct mtk_ppe *ppe, u16 index, u64 *bytes, u64 *packets)
+{
+	u32 val, cnt_r0, cnt_r1, cnt_r2;
+	u32 byte_cnt_low, byte_cnt_high, pkt_cnt_low, pkt_cnt_high;
+
+	val = FIELD_PREP(MTK_PPE_MIB_SER_CR_ADDR, index) | MTK_PPE_MIB_SER_CR_ST;
+	ppe_w32(ppe, MTK_PPE_MIB_SER_CR, val);
+
+	if (mtk_ppe_mib_wait_busy(ppe))
+		return -ETIMEDOUT;
+
+	cnt_r0 = readl(ppe->base + MTK_PPE_MIB_SER_R0);
+	cnt_r1 = readl(ppe->base + MTK_PPE_MIB_SER_R1);
+	cnt_r2 = readl(ppe->base + MTK_PPE_MIB_SER_R2);
+
+	byte_cnt_low = FIELD_GET(MTK_PPE_MIB_SER_R0_BYTE_CNT_LOW, cnt_r0);
+	byte_cnt_high = FIELD_GET(MTK_PPE_MIB_SER_R1_BYTE_CNT_HIGH, cnt_r1);
+	pkt_cnt_low = FIELD_GET(MTK_PPE_MIB_SER_R1_PKT_CNT_LOW, cnt_r1);
+	pkt_cnt_high = FIELD_GET(MTK_PPE_MIB_SER_R2_PKT_CNT_HIGH, cnt_r2);
+	*bytes = ((u64)byte_cnt_high << 32) | byte_cnt_low;
+	*packets = (pkt_cnt_high << 16) | pkt_cnt_low;
+
+	return 0;
+}
+
 static void mtk_ppe_cache_clear(struct mtk_ppe *ppe)
 {
 	ppe_set(ppe, MTK_PPE_CACHE_CTL, MTK_PPE_CACHE_CTL_CLEAR);
@@ -438,6 +478,13 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 		hwe->ib1 &= ~MTK_FOE_IB1_STATE;
 		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
 		dma_wmb();
+		if (ppe->accounting) {
+			struct mtk_foe_accounting *acct;
+
+			acct = ppe->acct_table + entry->hash * sizeof(*acct);
+			acct->packets = 0;
+			acct->bytes = 0;
+		}
 	}
 	entry->hash = 0xffff;
 
@@ -545,6 +592,9 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 	wmb();
 	hwe->ib1 = entry->ib1;
 
+	if (ppe->accounting)
+		*mtk_foe_entry_ib2(eth, hwe) |= MTK_FOE_IB2_MIB_CNT;
+
 	dma_wmb();
 
 	mtk_ppe_cache_clear(ppe);
@@ -710,14 +760,42 @@ int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	return __mtk_foe_entry_idle_time(ppe, entry->data.ib1);
 }
 
+struct mtk_foe_accounting *mtk_foe_entry_get_mib(struct mtk_ppe *ppe, u32 index,
+						 struct mtk_foe_accounting *diff)
+{
+	struct mtk_foe_accounting *acct;
+	int size = sizeof(struct mtk_foe_accounting);
+	u64 bytes, packets;
+
+	if (!ppe->accounting)
+		return NULL;
+
+	if (mtk_mib_entry_read(ppe, index, &bytes, &packets))
+		return NULL;
+
+	acct = ppe->acct_table + index * size;
+
+	acct->bytes += bytes;
+	acct->packets += packets;
+
+	if (diff) {
+		diff->bytes = bytes;
+		diff->packets = packets;
+	}
+
+	return acct;
+}
+
 struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
-			     int version, int index)
+			     int version, int index, bool accounting)
 {
 	const struct mtk_soc_data *soc = eth->soc;
 	struct device *dev = eth->dev;
 	struct mtk_ppe *ppe;
 	u32 foe_flow_size;
 	void *foe;
+	struct mtk_mib_entry *mib;
+	struct mtk_foe_accounting *acct;
 
 	ppe = devm_kzalloc(dev, sizeof(*ppe), GFP_KERNEL);
 	if (!ppe)
@@ -732,6 +810,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 	ppe->eth = eth;
 	ppe->dev = dev;
 	ppe->version = version;
+	ppe->accounting = accounting;
 
 	foe = dmam_alloc_coherent(ppe->dev,
 				  MTK_PPE_ENTRIES * soc->foe_entry_size,
@@ -747,6 +826,25 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 	if (!ppe->foe_flow)
 		return NULL;
 
+	if (accounting) {
+		mib = dmam_alloc_coherent(ppe->dev, MTK_PPE_ENTRIES * sizeof(*mib),
+					  &ppe->mib_phys, GFP_KERNEL);
+		if (!mib)
+			return NULL;
+
+		memset(mib, 0, MTK_PPE_ENTRIES * sizeof(*mib));
+
+		ppe->mib_table = mib;
+
+		acct = devm_kzalloc(dev, MTK_PPE_ENTRIES * sizeof(*acct),
+				    GFP_KERNEL);
+
+		if (!acct)
+			return NULL;
+
+		ppe->acct_table = acct;
+	}
+
 	mtk_ppe_debugfs_init(ppe, index);
 
 	return ppe;
@@ -861,6 +959,16 @@ void mtk_ppe_start(struct mtk_ppe *ppe)
 		ppe_w32(ppe, MTK_PPE_DEFAULT_CPU_PORT1, 0xcb777);
 		ppe_w32(ppe, MTK_PPE_SBW_CTRL, 0x7f);
 	}
+
+	if (ppe->accounting && ppe->mib_phys) {
+		ppe_w32(ppe, MTK_PPE_MIB_TB_BASE, ppe->mib_phys);
+		ppe_m32(ppe, MTK_PPE_MIB_CFG, MTK_PPE_MIB_CFG_EN,
+			MTK_PPE_MIB_CFG_EN);
+		ppe_m32(ppe, MTK_PPE_MIB_CFG, MTK_PPE_MIB_CFG_RD_CLR,
+			MTK_PPE_MIB_CFG_RD_CLR);
+		ppe_m32(ppe, MTK_PPE_MIB_CACHE_CTL, MTK_PPE_MIB_CACHE_CTL_EN,
+			MTK_PPE_MIB_CFG_RD_CLR);
+	}
 }
 
 int mtk_ppe_stop(struct mtk_ppe *ppe)
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 0b7a67a958e4ca..b77509a2b0fa30 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -57,6 +57,7 @@ enum {
 #define MTK_FOE_IB2_MULTICAST		BIT(8)
 
 #define MTK_FOE_IB2_WDMA_QID2		GENMASK(13, 12)
+#define MTK_FOE_IB2_MIB_CNT		BIT(15)
 #define MTK_FOE_IB2_WDMA_DEVIDX		BIT(16)
 #define MTK_FOE_IB2_WDMA_WINFO		BIT(17)
 
@@ -284,16 +285,34 @@ struct mtk_flow_entry {
 	unsigned long cookie;
 };
 
+struct mtk_mib_entry {
+	u32	byt_cnt_l;
+	u16	byt_cnt_h;
+	u32	pkt_cnt_l;
+	u8	pkt_cnt_h;
+	u8	_rsv0;
+	u32	_rsv1;
+} __packed;
+
+struct mtk_foe_accounting {
+	u64	bytes;
+	u64	packets;
+};
+
 struct mtk_ppe {
 	struct mtk_eth *eth;
 	struct device *dev;
 	void __iomem *base;
 	int version;
 	char dirname[5];
+	bool accounting;
 
 	void *foe_table;
 	dma_addr_t foe_phys;
 
+	struct mtk_mib_entry *mib_table;
+	dma_addr_t mib_phys;
+
 	u16 foe_check_time[MTK_PPE_ENTRIES];
 	struct hlist_head *foe_flow;
 
@@ -303,7 +322,7 @@ struct mtk_ppe {
 };
 
 struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
-			     int version, int index);
+			     int version, int index, bool accounting);
 void mtk_ppe_start(struct mtk_ppe *ppe);
 int mtk_ppe_stop(struct mtk_ppe *ppe);
 
@@ -354,5 +373,7 @@ int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_ppe_debugfs_init(struct mtk_ppe *ppe, int index);
+struct mtk_foe_accounting *mtk_foe_entry_get_mib(struct mtk_ppe *ppe, u32 index,
+						 struct mtk_foe_accounting *diff);
 
 #endif
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index 391b071bcff38d..39775740340b9e 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -82,6 +82,7 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
 		struct mtk_foe_entry *entry = mtk_foe_get_entry(ppe, i);
 		struct mtk_foe_mac_info *l2;
 		struct mtk_flow_addr_info ai = {};
+		struct mtk_foe_accounting *acct;
 		unsigned char h_source[ETH_ALEN];
 		unsigned char h_dest[ETH_ALEN];
 		int type, state;
@@ -95,6 +96,8 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
 		if (bind && state != MTK_FOE_STATE_BIND)
 			continue;
 
+		acct = mtk_foe_entry_get_mib(ppe, i, NULL);
+
 		type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
 		seq_printf(m, "%05x %s %7s", i,
 			   mtk_foe_entry_state_str(state),
@@ -153,9 +156,11 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
 		*((__be16 *)&h_dest[4]) = htons(l2->dest_mac_lo);
 
 		seq_printf(m, " eth=%pM->%pM etype=%04x"
-			      " vlan=%d,%d ib1=%08x ib2=%08x\n",
+			      " vlan=%d,%d ib1=%08x ib2=%08x"
+			      " packets=%lld bytes=%lld\n",
 			   h_source, h_dest, ntohs(l2->etype),
-			   l2->vlan1, l2->vlan2, entry->ib1, ib2);
+			   l2->vlan1, l2->vlan2, entry->ib1, ib2,
+			   acct->packets, acct->bytes);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 28bbd1df3e3059..42b5f279cfa5bb 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -491,6 +491,7 @@ static int
 mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 {
 	struct mtk_flow_entry *entry;
+	struct mtk_foe_accounting diff;
 	u32 idle;
 
 	entry = rhashtable_lookup(&eth->flow_table, &f->cookie,
@@ -501,6 +502,12 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 	idle = mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
 	f->stats.lastused = jiffies - idle * HZ;
 
+	if (entry->hash != 0xFFFF) {
+		mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash, &diff);
+		f->stats.pkts += diff.packets;
+		f->stats.bytes += diff.bytes;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h b/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
index 59596d823d8b8a..be804571b825e7 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
@@ -143,6 +143,20 @@ enum {
 
 #define MTK_PPE_MIB_TB_BASE			0x338
 
+#define MTK_PPE_MIB_SER_CR			0x33C
+#define MTK_PPE_MIB_SER_CR_ST			BIT(16)
+#define MTK_PPE_MIB_SER_CR_ADDR			GENMASK(13, 0)
+
+#define MTK_PPE_MIB_SER_R0			0x340
+#define MTK_PPE_MIB_SER_R0_BYTE_CNT_LOW		GENMASK(31, 0)
+
+#define MTK_PPE_MIB_SER_R1			0x344
+#define MTK_PPE_MIB_SER_R1_PKT_CNT_LOW		GENMASK(31, 16)
+#define MTK_PPE_MIB_SER_R1_BYTE_CNT_HIGH	GENMASK(15, 0)
+
+#define MTK_PPE_MIB_SER_R2			0x348
+#define MTK_PPE_MIB_SER_R2_PKT_CNT_HIGH		GENMASK(23, 0)
+
 #define MTK_PPE_MIB_CACHE_CTL			0x350
 #define MTK_PPE_MIB_CACHE_CTL_EN		BIT(0)
 #define MTK_PPE_MIB_CACHE_CTL_FLUSH		BIT(2)
-- 
2.38.1

