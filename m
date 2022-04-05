Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DD84F5406
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiDFEUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358230AbiDEUuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:50:04 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E5DF32AE;
        Tue,  5 Apr 2022 13:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aESVeg9GOyVeYgINR3qkbZYK7RCX3gela3Wj1L1I0LE=; b=jhiku1VlZN44aNwiBrveb08HSq
        wciE2IrrLsvja98f+EI0k5HpZRkbDofGiltHAA99DqN9gnXBmOXLOMrK2Dd2+AieSRgoe4ilihSbT
        KHFu4bMqIBfOK6IABKmFqLGcSwN7ifFMBzU/YSIqV3Zvfq4UdgrauiraU9IiCnHl6BKM=;
Received: from p200300daa70ef200456864e8b8d10029.dip0.t-ipconnect.de ([2003:da:a70e:f200:4568:64e8:b8d1:29] helo=Maecks.lan)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nbpJZ-00035V-4k; Tue, 05 Apr 2022 21:58:09 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/14] net: ethernet: mtk_eth_soc: rework hardware flow table management
Date:   Tue,  5 Apr 2022 21:57:53 +0200
Message-Id: <20220405195755.10817-13-nbd@nbd.name>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405195755.10817-1-nbd@nbd.name>
References: <20220405195755.10817-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware was designed to handle flow detection and creation of flow entries
by itself, relying on the software primarily for filling in egress routing
information.
When there is a hash collision between multiple flows, this allows the hardware
to maintain the entry for the most active flow.
Additionally, the hardware only keeps offloading active for entries with at
least 30 packets per second.

With this rework, the code no longer creates a hardware entries directly.
Instead, the hardware entry is only created when the PPE reports a matching
unbound flow with the minimum target rate.
In order to reduce CPU overhead, looking for flows belonging to a hash entry
is rate limited to once every 100ms.

This rework is also used as preparation for emulating bridge offload by
managing L4 offload entries on demand.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  10 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c       | 134 ++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_ppe.h       |  38 ++++-
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |  42 ++----
 4 files changed, 170 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5a2f3cb26e66..209d00f56f62 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -21,6 +21,7 @@
 #include <linux/pinctrl/devinfo.h>
 #include <linux/phylink.h>
 #include <linux/jhash.h>
+#include <linux/bitfield.h>
 #include <net/dsa.h>
 
 #include "mtk_eth_soc.h"
@@ -1239,7 +1240,7 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 		struct net_device *netdev;
 		unsigned int pktlen;
 		dma_addr_t dma_addr;
-		u32 hash;
+		u32 hash, reason;
 		int mac;
 
 		ring = mtk_get_rx_ring(eth);
@@ -1315,6 +1316,11 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			skb_set_hash(skb, hash, PKT_HASH_TYPE_L4);
 		}
 
+		reason = FIELD_GET(MTK_RXD4_PPE_CPU_REASON, trxd.rxd4);
+		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
+			mtk_ppe_check_skb(eth->ppe, skb,
+					  trxd.rxd4 & MTK_RXD4_FOE_ENTRY);
+
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX &&
 		    (trxd.rxd2 & RX_DMA_VTAG))
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
@@ -3262,7 +3268,7 @@ static int mtk_probe(struct platform_device *pdev)
 	}
 
 	if (eth->soc->offload_version) {
-		eth->ppe = mtk_ppe_init(eth->dev, eth->base + MTK_ETH_PPE_BASE, 2);
+		eth->ppe = mtk_ppe_init(eth, eth->base + MTK_ETH_PPE_BASE, 2);
 		if (!eth->ppe) {
 			err = -ENOMEM;
 			goto err_free_dev;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index c56518272729..a7fe33bbde63 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -6,9 +6,12 @@
 #include <linux/iopoll.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
+#include "mtk_eth_soc.h"
 #include "mtk_ppe.h"
 #include "mtk_ppe_regs.h"
 
+static DEFINE_SPINLOCK(ppe_lock);
+
 static void ppe_w32(struct mtk_ppe *ppe, u32 reg, u32 val)
 {
 	writel(val, ppe->base + reg);
@@ -41,6 +44,11 @@ static u32 ppe_clear(struct mtk_ppe *ppe, u32 reg, u32 val)
 	return ppe_m32(ppe, reg, val, 0);
 }
 
+static u32 mtk_eth_timestamp(struct mtk_eth *eth)
+{
+	return mtk_r32(eth, 0x0010) & MTK_FOE_IB1_BIND_TIMESTAMP;
+}
+
 static int mtk_ppe_wait_busy(struct mtk_ppe *ppe)
 {
 	int ret;
@@ -353,26 +361,59 @@ static inline bool mtk_foe_entry_usable(struct mtk_foe_entry *entry)
 	       FIELD_GET(MTK_FOE_IB1_STATE, entry->ib1) != MTK_FOE_STATE_BIND;
 }
 
-int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
-			 u16 timestamp)
+static bool
+mtk_flow_entry_match(struct mtk_flow_entry *entry, struct mtk_foe_entry *data)
+{
+	int type, len;
+
+	if ((data->ib1 ^ entry->data.ib1) & MTK_FOE_IB1_UDP)
+		return false;
+
+	type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->data.ib1);
+	if (type > MTK_PPE_PKT_TYPE_IPV4_DSLITE)
+		len = offsetof(struct mtk_foe_entry, ipv6._rsv);
+	else
+		len = offsetof(struct mtk_foe_entry, ipv4.ib2);
+
+	return !memcmp(&entry->data.data, &data->data, len - 4);
+}
+
+static void
+mtk_flow_entry_update(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
 	struct mtk_foe_entry *hwe;
-	u32 hash;
+	struct mtk_foe_entry foe;
+
+	spin_lock_bh(&ppe_lock);
+	if (entry->hash == 0xffff)
+		goto out;
 
+	hwe = &ppe->foe_table[entry->hash];
+	memcpy(&foe, hwe, sizeof(foe));
+	if (!mtk_flow_entry_match(entry, &foe)) {
+		entry->hash = 0xffff;
+		goto out;
+	}
+
+	entry->data.ib1 = foe.ib1;
+
+out:
+	spin_unlock_bh(&ppe_lock);
+}
+
+static void
+__mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
+		       u16 hash)
+{
+	struct mtk_foe_entry *hwe;
+	u16 timestamp;
+
+	timestamp = mtk_eth_timestamp(ppe->eth);
 	timestamp &= MTK_FOE_IB1_BIND_TIMESTAMP;
 	entry->ib1 &= ~MTK_FOE_IB1_BIND_TIMESTAMP;
 	entry->ib1 |= FIELD_PREP(MTK_FOE_IB1_BIND_TIMESTAMP, timestamp);
 
-	hash = mtk_ppe_hash_entry(entry);
 	hwe = &ppe->foe_table[hash];
-	if (!mtk_foe_entry_usable(hwe)) {
-		hwe++;
-		hash++;
-
-		if (!mtk_foe_entry_usable(hwe))
-			return -ENOSPC;
-	}
-
 	memcpy(&hwe->data, &entry->data, sizeof(hwe->data));
 	wmb();
 	hwe->ib1 = entry->ib1;
@@ -380,13 +421,77 @@ int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 	dma_wmb();
 
 	mtk_ppe_cache_clear(ppe);
+}
 
-	return hash;
+void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
+{
+	spin_lock_bh(&ppe_lock);
+	hlist_del_init(&entry->list);
+	if (entry->hash != 0xffff) {
+		ppe->foe_table[entry->hash].ib1 &= ~MTK_FOE_IB1_STATE;
+		ppe->foe_table[entry->hash].ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE,
+							      MTK_FOE_STATE_BIND);
+		dma_wmb();
+	}
+	entry->hash = 0xffff;
+	spin_unlock_bh(&ppe_lock);
+}
+
+int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
+{
+	u32 hash = mtk_ppe_hash_entry(&entry->data);
+
+	entry->hash = 0xffff;
+	spin_lock_bh(&ppe_lock);
+	hlist_add_head(&entry->list, &ppe->foe_flow[hash / 2]);
+	spin_unlock_bh(&ppe_lock);
+
+	return 0;
+}
+
+void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
+{
+	struct hlist_head *head = &ppe->foe_flow[hash / 2];
+	struct mtk_flow_entry *entry;
+	struct mtk_foe_entry *hwe = &ppe->foe_table[hash];
+	bool found = false;
+
+	if (hlist_empty(head))
+		return;
+
+	spin_lock_bh(&ppe_lock);
+	hlist_for_each_entry(entry, head, list) {
+		if (found || !mtk_flow_entry_match(entry, hwe)) {
+			if (entry->hash != 0xffff)
+				entry->hash = 0xffff;
+			continue;
+		}
+
+		entry->hash = hash;
+		__mtk_foe_entry_commit(ppe, &entry->data, hash);
+		found = true;
+	}
+	spin_unlock_bh(&ppe_lock);
+}
+
+int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
+{
+	u16 now = mtk_eth_timestamp(ppe->eth) & MTK_FOE_IB1_BIND_TIMESTAMP;
+	u16 timestamp;
+
+	mtk_flow_entry_update(ppe, entry);
+	timestamp = entry->data.ib1 & MTK_FOE_IB1_BIND_TIMESTAMP;
+
+	if (timestamp > now)
+		return MTK_FOE_IB1_BIND_TIMESTAMP + 1 - timestamp + now;
+	else
+		return now - timestamp;
 }
 
-struct mtk_ppe *mtk_ppe_init(struct device *dev, void __iomem *base,
+struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
 		 int version)
 {
+	struct device *dev = eth->dev;
 	struct mtk_foe_entry *foe;
 	struct mtk_ppe *ppe;
 
@@ -398,6 +503,7 @@ struct mtk_ppe *mtk_ppe_init(struct device *dev, void __iomem *base,
 	 * not coherent.
 	 */
 	ppe->base = base;
+	ppe->eth = eth;
 	ppe->dev = dev;
 	ppe->version = version;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 190d2560ac86..217b44bed8b6 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -235,7 +235,17 @@ enum {
 	MTK_PPE_CPU_REASON_INVALID			= 0x1f,
 };
 
+struct mtk_flow_entry {
+	struct rhash_head node;
+	struct hlist_node list;
+	unsigned long cookie;
+	struct mtk_foe_entry data;
+	u16 hash;
+	s8 wed_index;
+};
+
 struct mtk_ppe {
+	struct mtk_eth *eth;
 	struct device *dev;
 	void __iomem *base;
 	int version;
@@ -243,18 +253,33 @@ struct mtk_ppe {
 	struct mtk_foe_entry *foe_table;
 	dma_addr_t foe_phys;
 
+	u16 foe_check_time[MTK_PPE_ENTRIES];
+	struct hlist_head foe_flow[MTK_PPE_ENTRIES / 2];
+
 	void *acct_table;
 };
 
-struct mtk_ppe *mtk_ppe_init(struct device *dev, void __iomem *base, int version);
+struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int version);
 int mtk_ppe_start(struct mtk_ppe *ppe);
 int mtk_ppe_stop(struct mtk_ppe *ppe);
 
+void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash);
+
 static inline void
-mtk_foe_entry_clear(struct mtk_ppe *ppe, u16 hash)
+mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 {
-	ppe->foe_table[hash].ib1 = 0;
-	dma_wmb();
+	u16 now, diff;
+
+	if (!ppe)
+		return;
+
+	now = (u16)jiffies;
+	diff = now - ppe->foe_check_time[hash];
+	if (diff < HZ / 10)
+		return;
+
+	ppe->foe_check_time[hash] = now;
+	__mtk_ppe_check_skb(ppe, skb, hash);
 }
 
 static inline int
@@ -282,8 +307,9 @@ int mtk_foe_entry_set_vlan(struct mtk_foe_entry *entry, int vid);
 int mtk_foe_entry_set_pppoe(struct mtk_foe_entry *entry, int sid);
 int mtk_foe_entry_set_wdma(struct mtk_foe_entry *entry, int wdma_idx, int txq,
 			   int bss, int wcid);
-int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
-			 u16 timestamp);
+int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
+void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
+int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry);
 int mtk_ppe_debugfs_init(struct mtk_ppe *ppe);
 
 #endif
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 76a94ec85232..378685fe92b6 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -42,13 +42,6 @@ struct mtk_flow_data {
 	} pppoe;
 };
 
-struct mtk_flow_entry {
-	struct rhash_head node;
-	unsigned long cookie;
-	u16 hash;
-	s8 wed_index;
-};
-
 static const struct rhashtable_params mtk_flow_ht_params = {
 	.head_offset = offsetof(struct mtk_flow_entry, node),
 	.key_offset = offsetof(struct mtk_flow_entry, cookie),
@@ -56,12 +49,6 @@ static const struct rhashtable_params mtk_flow_ht_params = {
 	.automatic_shrinking = true,
 };
 
-static u32
-mtk_eth_timestamp(struct mtk_eth *eth)
-{
-	return mtk_r32(eth, 0x0010) & MTK_FOE_IB1_BIND_TIMESTAMP;
-}
-
 static int
 mtk_flow_set_ipv4_addr(struct mtk_foe_entry *foe, struct mtk_flow_data *data,
 		       bool egress)
@@ -237,10 +224,8 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	int offload_type = 0;
 	int wed_index = -1;
 	u16 addr_type = 0;
-	u32 timestamp;
 	u8 l4proto = 0;
 	int err = 0;
-	int hash;
 	int i;
 
 	if (rhashtable_lookup(&eth->flow_table, &f->cookie, mtk_flow_ht_params))
@@ -410,23 +395,21 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 		return -ENOMEM;
 
 	entry->cookie = f->cookie;
-	timestamp = mtk_eth_timestamp(eth);
-	hash = mtk_foe_entry_commit(eth->ppe, &foe, timestamp);
-	if (hash < 0) {
-		err = hash;
+	memcpy(&entry->data, &foe, sizeof(entry->data));
+	entry->wed_index = wed_index;
+
+	if (mtk_foe_entry_commit(eth->ppe, entry) < 0)
 		goto free;
-	}
 
-	entry->hash = hash;
-	entry->wed_index = wed_index;
 	err = rhashtable_insert_fast(&eth->flow_table, &entry->node,
 				     mtk_flow_ht_params);
 	if (err < 0)
-		goto clear_flow;
+		goto clear;
 
 	return 0;
-clear_flow:
-	mtk_foe_entry_clear(eth->ppe, hash);
+
+clear:
+	mtk_foe_entry_clear(eth->ppe, entry);
 free:
 	kfree(entry);
 	if (wed_index >= 0)
@@ -444,7 +427,7 @@ mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
 	if (!entry)
 		return -ENOENT;
 
-	mtk_foe_entry_clear(eth->ppe, entry->hash);
+	mtk_foe_entry_clear(eth->ppe, entry);
 	rhashtable_remove_fast(&eth->flow_table, &entry->node,
 			       mtk_flow_ht_params);
 	if (entry->wed_index >= 0)
@@ -458,7 +441,6 @@ static int
 mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 {
 	struct mtk_flow_entry *entry;
-	int timestamp;
 	u32 idle;
 
 	entry = rhashtable_lookup(&eth->flow_table, &f->cookie,
@@ -466,11 +448,7 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
 	if (!entry)
 		return -ENOENT;
 
-	timestamp = mtk_foe_entry_timestamp(eth->ppe, entry->hash);
-	if (timestamp < 0)
-		return -ETIMEDOUT;
-
-	idle = mtk_eth_timestamp(eth) - timestamp;
+	idle = mtk_foe_entry_idle_time(eth->ppe, entry);
 	f->stats.lastused = jiffies - idle * HZ;
 
 	return 0;
-- 
2.35.1

