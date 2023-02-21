Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D708E69DF28
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbjBULnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbjBULnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:43:09 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1066127D78;
        Tue, 21 Feb 2023 03:42:46 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pUR2g-0001R4-2b;
        Tue, 21 Feb 2023 12:42:43 +0100
Date:   Tue, 21 Feb 2023 11:42:38 +0000
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
Subject: [PATCH net-next v10 09/12] net: ethernet: mtk_eth_soc: ppe: add
 support for flow accounting
Message-ID: <a522e75754287fa4425907803d9098079acf7395.1676933805.git.daniel@makrotopia.org>
References: <cover.1676933805.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1676933805.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PPE units found in MT7622 and newer support packet and byte
accounting of hw-offloaded flows. Add support for reading those counters
as found in MediaTek's SDK[1].

[1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
Tested-by: Bj�rn Mork <bjorn@mork.no>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   8 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h   |   1 +
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 114 +++++++++++++++++-
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  25 +++-
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   9 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |   8 ++
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |  14 +++
 7 files changed, 170 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ed32a511adc30..677a39cbde082 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4712,8 +4712,8 @@ static int mtk_probe(struct platform_device *pdev)
 		for (i = 0; i < num_ppe; i++) {
 			u32 ppe_addr = eth->soc->reg_map->ppe_base + i * 0x400;
 
-			eth->ppe[i] = mtk_ppe_init(eth, eth->base + ppe_addr,
-						   eth->soc->offload_version, i);
+			eth->ppe[i] = mtk_ppe_init(eth, eth->base + ppe_addr, i);
+
 			if (!eth->ppe[i]) {
 				err = -ENOMEM;
 				goto err_deinit_ppe;
@@ -4835,6 +4835,7 @@ static const struct mtk_soc_data mt7622_data = {
 	.required_pctl = false,
 	.offload_version = 2,
 	.hash_offset = 2,
+	.has_accounting = true,
 	.foe_entry_size = sizeof(struct mtk_foe_entry) - 16,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
@@ -4872,6 +4873,7 @@ static const struct mtk_soc_data mt7629_data = {
 	.hw_features = MTK_HW_FEATURES,
 	.required_clks = MT7629_CLKS_BITMAP,
 	.required_pctl = false,
+	.has_accounting = true,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma),
 		.rxd_size = sizeof(struct mtk_rx_dma),
@@ -4892,6 +4894,7 @@ static const struct mtk_soc_data mt7981_data = {
 	.offload_version = 2,
 	.hash_offset = 4,
 	.foe_entry_size = sizeof(struct mtk_foe_entry),
+	.has_accounting = true,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma_v2),
 		.rxd_size = sizeof(struct mtk_rx_dma_v2),
@@ -4912,6 +4915,7 @@ static const struct mtk_soc_data mt7986_data = {
 	.offload_version = 2,
 	.hash_offset = 4,
 	.foe_entry_size = sizeof(struct mtk_foe_entry),
+	.has_accounting = true,
 	.txrx = {
 		.txd_size = sizeof(struct mtk_tx_dma_v2),
 		.rxd_size = sizeof(struct mtk_rx_dma_v2),
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 529c95c481b73..f90d61bfa3c18 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1087,6 +1087,7 @@ struct mtk_soc_data {
 	u8		hash_offset;
 	u16		foe_entry_size;
 	netdev_features_t hw_features;
+	bool		has_accounting;
 	struct {
 		u32	txd_size;
 		u32	rxd_size;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 6883eb34cd8b4..c099e87367165 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -74,6 +74,48 @@ static int mtk_ppe_wait_busy(struct mtk_ppe *ppe)
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
+static int mtk_mib_entry_read(struct mtk_ppe *ppe, u16 index, u64 *bytes, u64 *packets)
+{
+	u32 byte_cnt_low, byte_cnt_high, pkt_cnt_low, pkt_cnt_high;
+	u32 val, cnt_r0, cnt_r1, cnt_r2;
+	int ret;
+
+	val = FIELD_PREP(MTK_PPE_MIB_SER_CR_ADDR, index) | MTK_PPE_MIB_SER_CR_ST;
+	ppe_w32(ppe, MTK_PPE_MIB_SER_CR, val);
+
+	ret = mtk_ppe_mib_wait_busy(ppe);
+	if (ret)
+		return ret;
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
@@ -458,6 +500,13 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
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
 
@@ -565,6 +614,9 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 	wmb();
 	hwe->ib1 = entry->ib1;
 
+	if (ppe->accounting)
+		*mtk_foe_entry_ib2(eth, hwe) |= MTK_FOE_IB2_MIB_CNT;
+
 	dma_wmb();
 
 	mtk_ppe_cache_clear(ppe);
@@ -756,11 +808,39 @@ int mtk_ppe_prepare_reset(struct mtk_ppe *ppe)
 	return mtk_ppe_wait_busy(ppe);
 }
 
-struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
-			     int version, int index)
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
+struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int index)
 {
+	bool accounting = eth->soc->has_accounting;
 	const struct mtk_soc_data *soc = eth->soc;
+	struct mtk_foe_accounting *acct;
 	struct device *dev = eth->dev;
+	struct mtk_mib_entry *mib;
 	struct mtk_ppe *ppe;
 	u32 foe_flow_size;
 	void *foe;
@@ -777,7 +857,8 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 	ppe->base = base;
 	ppe->eth = eth;
 	ppe->dev = dev;
-	ppe->version = version;
+	ppe->version = eth->soc->offload_version;
+	ppe->accounting = accounting;
 
 	foe = dmam_alloc_coherent(ppe->dev,
 				  MTK_PPE_ENTRIES * soc->foe_entry_size,
@@ -793,6 +874,23 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 	if (!ppe->foe_flow)
 		goto err_free_l2_flows;
 
+	if (accounting) {
+		mib = dmam_alloc_coherent(ppe->dev, MTK_PPE_ENTRIES * sizeof(*mib),
+					  &ppe->mib_phys, GFP_KERNEL);
+		if (!mib)
+			return NULL;
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
@@ -922,6 +1020,16 @@ void mtk_ppe_start(struct mtk_ppe *ppe)
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
index 5e8bc48252b11..e1aab2e8e2629 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -57,6 +57,7 @@ enum {
 #define MTK_FOE_IB2_MULTICAST		BIT(8)
 
 #define MTK_FOE_IB2_WDMA_QID2		GENMASK(13, 12)
+#define MTK_FOE_IB2_MIB_CNT		BIT(15)
 #define MTK_FOE_IB2_WDMA_DEVIDX		BIT(16)
 #define MTK_FOE_IB2_WDMA_WINFO		BIT(17)
 
@@ -285,16 +286,34 @@ struct mtk_flow_entry {
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
 
@@ -303,8 +322,8 @@ struct mtk_ppe {
 	void *acct_table;
 };
 
-struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
-			     int version, int index);
+struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int index);
+
 void mtk_ppe_deinit(struct mtk_eth *eth);
 void mtk_ppe_start(struct mtk_ppe *ppe);
 int mtk_ppe_stop(struct mtk_ppe *ppe);
@@ -359,5 +378,7 @@ int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_ppe_debugfs_init(struct mtk_ppe *ppe, int index);
+struct mtk_foe_accounting *mtk_foe_entry_get_mib(struct mtk_ppe *ppe, u32 index,
+						 struct mtk_foe_accounting *diff);
 
 #endif
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index 391b071bcff38..53cf87e9acbb5 100644
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
+			      " packets=%llu bytes=%llu\n",
 			   h_source, h_dest, ntohs(l2->etype),
-			   l2->vlan1, l2->vlan2, entry->ib1, ib2);
+			   l2->vlan1, l2->vlan2, entry->ib1, ib2,
+			   acct ? acct->packets : 0, acct ? acct->bytes : 0);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 81afd5ee3fbf1..f02ccffb1e794 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -497,6 +497,7 @@ static int
 mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 {
 	struct mtk_flow_entry *entry;
+	struct mtk_foe_accounting diff;
 	u32 idle;
 
 	entry = rhashtable_lookup(&eth->flow_table, &f->cookie,
@@ -507,6 +508,13 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 	idle = mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
 	f->stats.lastused = jiffies - idle * HZ;
 
+	if (entry->hash != 0xFFFF &&
+	    mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash,
+				  &diff)) {
+		f->stats.pkts += diff.packets;
+		f->stats.bytes += diff.bytes;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h b/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
index 0fdb983b0a88d..a2e61b3eb006d 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_regs.h
@@ -149,6 +149,20 @@ enum {
 
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
2.39.2

