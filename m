Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96736D19D9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjCaI3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjCaI3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:29:51 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C351992
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8AdyBxGPxwu/Q2U3TLVIv37Me+2lfXzA/GTCC5dQa30=; b=W3dQneWIBnrlLvvYZbBpLzlOZd
        adYrvmrz3gwpFr4DllC48hj8b7bVcqKNre5SWxbHsybuxCn9geUg+Brewt7bvuln9srNPI6dCUnMj
        TsKXLEa5vNih/QpxtkbSf/fsaSD0p9KLLQuMqHfNfcVCYIZXHDSq4o4ZB8sGU0drnxN8=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1piA8o-008qbG-CX; Fri, 31 Mar 2023 10:29:46 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH net-next 2/3] net: ethernet: mtk_eth_soc: fix ppe flow accounting for L2 flows
Date:   Fri, 31 Mar 2023 10:29:44 +0200
Message-Id: <20230331082945.75075-2-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230331082945.75075-1-nbd@nbd.name>
References: <20230331082945.75075-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For L2 flows, the packet/byte counters should report the sum of the
counters of their subflows, both current and expired.
In order to make this work, change the way that accounting data is tracked.
Reset counters when a flow enters bind. Once it expires (or enters unbind),
store the last counter value in struct mtk_flow_entry.

Fixes: 3fbe4d8c0e53 ("net: ethernet: mtk_eth_soc: ppe: add support for flow accounting")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 137 ++++++++++--------
 drivers/net/ethernet/mediatek/mtk_ppe.h       |   8 +-
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   2 +-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  17 +--
 4 files changed, 88 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index e9bcbdbe9c12..64e8dc8d814b 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -80,9 +80,9 @@ static int mtk_ppe_mib_wait_busy(struct mtk_ppe *ppe)
 	int ret;
 	u32 val;
 
-	ret = readl_poll_timeout(ppe->base + MTK_PPE_MIB_SER_CR, val,
-				 !(val & MTK_PPE_MIB_SER_CR_ST),
-				 20, MTK_PPE_WAIT_TIMEOUT_US);
+	ret = readl_poll_timeout_atomic(ppe->base + MTK_PPE_MIB_SER_CR, val,
+					!(val & MTK_PPE_MIB_SER_CR_ST),
+					20, MTK_PPE_WAIT_TIMEOUT_US);
 
 	if (ret)
 		dev_err(ppe->dev, "MIB table busy");
@@ -90,18 +90,32 @@ static int mtk_ppe_mib_wait_busy(struct mtk_ppe *ppe)
 	return ret;
 }
 
-static int mtk_mib_entry_read(struct mtk_ppe *ppe, u16 index, u64 *bytes, u64 *packets)
+static inline struct mtk_foe_accounting *
+mtk_ppe_acct_data(struct mtk_ppe *ppe, u16 index)
+{
+	if (!ppe->acct_table)
+		return NULL;
+
+	return ppe->acct_table + index * sizeof(struct mtk_foe_accounting);
+}
+
+struct mtk_foe_accounting *mtk_ppe_mib_entry_read(struct mtk_ppe *ppe, u16 index)
 {
 	u32 byte_cnt_low, byte_cnt_high, pkt_cnt_low, pkt_cnt_high;
 	u32 val, cnt_r0, cnt_r1, cnt_r2;
+	struct mtk_foe_accounting *acct;
 	int ret;
 
 	val = FIELD_PREP(MTK_PPE_MIB_SER_CR_ADDR, index) | MTK_PPE_MIB_SER_CR_ST;
 	ppe_w32(ppe, MTK_PPE_MIB_SER_CR, val);
 
+	acct = mtk_ppe_acct_data(ppe, index);
+	if (!acct)
+		return NULL;
+
 	ret = mtk_ppe_mib_wait_busy(ppe);
 	if (ret)
-		return ret;
+		return acct;
 
 	cnt_r0 = readl(ppe->base + MTK_PPE_MIB_SER_R0);
 	cnt_r1 = readl(ppe->base + MTK_PPE_MIB_SER_R1);
@@ -111,10 +125,11 @@ static int mtk_mib_entry_read(struct mtk_ppe *ppe, u16 index, u64 *bytes, u64 *p
 	byte_cnt_high = FIELD_GET(MTK_PPE_MIB_SER_R1_BYTE_CNT_HIGH, cnt_r1);
 	pkt_cnt_low = FIELD_GET(MTK_PPE_MIB_SER_R1_PKT_CNT_LOW, cnt_r1);
 	pkt_cnt_high = FIELD_GET(MTK_PPE_MIB_SER_R2_PKT_CNT_HIGH, cnt_r2);
-	*bytes = ((u64)byte_cnt_high << 32) | byte_cnt_low;
-	*packets = (pkt_cnt_high << 16) | pkt_cnt_low;
 
-	return 0;
+	acct->bytes += ((u64)byte_cnt_high << 32) | byte_cnt_low;
+	acct->packets += (pkt_cnt_high << 16) | pkt_cnt_low;
+
+	return acct;
 }
 
 static void mtk_ppe_cache_clear(struct mtk_ppe *ppe)
@@ -503,14 +518,6 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
 		dma_wmb();
 		mtk_ppe_cache_clear(ppe);
-
-		if (ppe->accounting) {
-			struct mtk_foe_accounting *acct;
-
-			acct = ppe->acct_table + entry->hash * sizeof(*acct);
-			acct->packets = 0;
-			acct->bytes = 0;
-		}
 	}
 	entry->hash = 0xffff;
 
@@ -535,11 +542,14 @@ static int __mtk_foe_entry_idle_time(struct mtk_ppe *ppe, u32 ib1)
 }
 
 static bool
-mtk_flow_entry_update(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
+mtk_flow_entry_update(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
+		      u64 *packets, u64 *bytes)
 {
+	struct mtk_foe_accounting *acct;
 	struct mtk_foe_entry foe = {};
 	struct mtk_foe_entry *hwe;
 	u16 hash = entry->hash;
+	bool ret = false;
 	int len;
 
 	if (hash == 0xffff)
@@ -550,18 +560,35 @@ mtk_flow_entry_update(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	memcpy(&foe, hwe, len);
 
 	if (!mtk_flow_entry_match(ppe->eth, entry, &foe, len) ||
-	    FIELD_GET(MTK_FOE_IB1_STATE, foe.ib1) != MTK_FOE_STATE_BIND)
-		return false;
+	    FIELD_GET(MTK_FOE_IB1_STATE, foe.ib1) != MTK_FOE_STATE_BIND) {
+		acct = mtk_ppe_acct_data(ppe, hash);
+		if (acct) {
+			entry->prev_packets += acct->packets;
+			entry->prev_bytes += acct->bytes;
+		}
+
+		goto out;
+	}
 
 	entry->data.ib1 = foe.ib1;
+	acct = mtk_ppe_mib_entry_read(ppe, hash);
+	ret = true;
 
-	return true;
+out:
+	if (acct) {
+		*packets += acct->packets;
+		*bytes += acct->bytes;
+	}
+
+	return ret;
 }
 
 static void
 mtk_flow_entry_update_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
 	u32 ib1_ts_mask = mtk_get_ib1_ts_mask(ppe->eth);
+	u64 *packets = &entry->packets;
+	u64 *bytes = &entry->bytes;
 	struct mtk_flow_entry *cur;
 	struct hlist_node *tmp;
 	int idle;
@@ -570,7 +597,9 @@ mtk_flow_entry_update_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	hlist_for_each_entry_safe(cur, tmp, &entry->l2_flows, l2_list) {
 		int cur_idle;
 
-		if (!mtk_flow_entry_update(ppe, cur)) {
+		if (!mtk_flow_entry_update(ppe, cur, packets, bytes)) {
+			entry->prev_packets += cur->prev_packets;
+			entry->prev_bytes += cur->prev_bytes;
 			__mtk_foe_entry_clear(ppe, entry, false);
 			continue;
 		}
@@ -585,10 +614,29 @@ mtk_flow_entry_update_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	}
 }
 
+void mtk_foe_entry_get_stats(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
+			     int *idle)
+{
+	entry->packets = entry->prev_packets;
+	entry->bytes = entry->prev_bytes;
+
+	spin_lock_bh(&ppe_lock);
+
+	if (entry->type == MTK_FLOW_TYPE_L2)
+		mtk_flow_entry_update_l2(ppe, entry);
+	else
+		mtk_flow_entry_update(ppe, entry, &entry->packets, &entry->bytes);
+
+	*idle = __mtk_foe_entry_idle_time(ppe, entry->data.ib1);
+
+	spin_unlock_bh(&ppe_lock);
+}
+
 static void
 __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 		       u16 hash)
 {
+	struct mtk_foe_accounting *acct;
 	struct mtk_eth *eth = ppe->eth;
 	u16 timestamp = mtk_eth_timestamp(eth);
 	struct mtk_foe_entry *hwe;
@@ -613,6 +661,12 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 
 	dma_wmb();
 
+	acct = mtk_ppe_mib_entry_read(ppe, hash);
+	if (acct) {
+		acct->packets = 0;
+		acct->bytes = 0;
+	}
+
 	mtk_ppe_cache_clear(ppe);
 }
 
@@ -777,21 +831,6 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 	spin_unlock_bh(&ppe_lock);
 }
 
-int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
-{
-	int idle;
-
-	spin_lock_bh(&ppe_lock);
-	if (entry->type == MTK_FLOW_TYPE_L2)
-		mtk_flow_entry_update_l2(ppe, entry);
-	else
-		mtk_flow_entry_update(ppe, entry);
-	idle = __mtk_foe_entry_idle_time(ppe, entry->data.ib1);
-	spin_unlock_bh(&ppe_lock);
-
-	return idle;
-}
-
 int mtk_ppe_prepare_reset(struct mtk_ppe *ppe)
 {
 	if (!ppe)
@@ -819,32 +858,6 @@ int mtk_ppe_prepare_reset(struct mtk_ppe *ppe)
 	return mtk_ppe_wait_busy(ppe);
 }
 
-struct mtk_foe_accounting *mtk_foe_entry_get_mib(struct mtk_ppe *ppe, u32 index,
-						 struct mtk_foe_accounting *diff)
-{
-	struct mtk_foe_accounting *acct;
-	int size = sizeof(struct mtk_foe_accounting);
-	u64 bytes, packets;
-
-	if (!ppe->accounting)
-		return NULL;
-
-	if (mtk_mib_entry_read(ppe, index, &bytes, &packets))
-		return NULL;
-
-	acct = ppe->acct_table + index * size;
-
-	acct->bytes += bytes;
-	acct->packets += packets;
-
-	if (diff) {
-		diff->bytes = bytes;
-		diff->packets = packets;
-	}
-
-	return acct;
-}
-
 struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int index)
 {
 	bool accounting = eth->soc->has_accounting;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 6823256016a2..13dd7988e95c 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -283,6 +283,8 @@ struct mtk_flow_entry {
 	struct mtk_foe_entry data;
 	struct rhash_head node;
 	unsigned long cookie;
+	u64 prev_packets, prev_bytes;
+	u64 packets, bytes;
 };
 
 struct mtk_mib_entry {
@@ -327,6 +329,7 @@ void mtk_ppe_deinit(struct mtk_eth *eth);
 void mtk_ppe_start(struct mtk_ppe *ppe);
 int mtk_ppe_stop(struct mtk_ppe *ppe);
 int mtk_ppe_prepare_reset(struct mtk_ppe *ppe);
+struct mtk_foe_accounting *mtk_ppe_mib_entry_read(struct mtk_ppe *ppe, u16 index);
 
 void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash);
 
@@ -375,9 +378,8 @@ int mtk_foe_entry_set_queue(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 			    unsigned int queue);
 int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
-int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_ppe_debugfs_init(struct mtk_ppe *ppe, int index);
-struct mtk_foe_accounting *mtk_foe_entry_get_mib(struct mtk_ppe *ppe, u32 index,
-						 struct mtk_foe_accounting *diff);
+void mtk_foe_entry_get_stats(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
+			     int *idle);
 
 #endif
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index 53cf87e9acbb..c13acdbb874c 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -96,7 +96,7 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
 		if (bind && state != MTK_FOE_STATE_BIND)
 			continue;
 
-		acct = mtk_foe_entry_get_mib(ppe, i, NULL);
+		acct = mtk_ppe_mib_entry_read(ppe, i);
 
 		type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
 		seq_printf(m, "%05x %s %7s", i,
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index c9cb317b7a2d..f1e8cdac5792 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -499,24 +499,21 @@ static int
 mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 {
 	struct mtk_flow_entry *entry;
-	struct mtk_foe_accounting diff;
-	u32 idle;
+	u64 packets, bytes;
+	int idle;
 
 	entry = rhashtable_lookup(&eth->flow_table, &f->cookie,
 				  mtk_flow_ht_params);
 	if (!entry)
 		return -ENOENT;
 
-	idle = mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
+	packets = entry->packets;
+	bytes = entry->bytes;
+	mtk_foe_entry_get_stats(eth->ppe[entry->ppe_index], entry, &idle);
+	f->stats.pkts += entry->packets - packets;
+	f->stats.bytes += entry->bytes - bytes;
 	f->stats.lastused = jiffies - idle * HZ;
 
-	if (entry->hash != 0xFFFF &&
-	    mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash,
-				  &diff)) {
-		f->stats.pkts += diff.packets;
-		f->stats.bytes += diff.bytes;
-	}
-
 	return 0;
 }
 
-- 
2.39.0

