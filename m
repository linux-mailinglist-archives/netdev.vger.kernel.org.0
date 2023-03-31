Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB76D19DA
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjCaI3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCaI3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:29:51 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC111BCE
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NZeq0MFMDrSPFsdCzFurY6nko8ys6JrpWaoMV8qlwUA=; b=R5AEE2eDWeVtiTt7bdRvXhk9bb
        0YtYFtPgtLtlfIDAY3apExjNYayWk1/hyVfS5bvpS6b5ZIAQvtKrCjr+AbimIa8jO9+nlhrlmlNdo
        +1/RD+9zSzGqcsXSca0X3k7O+AKgiXR7RaCILkLqS6zhbXtJjS/hm1PZvK0GhfhqVl2s=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1piA8o-008qbG-65; Fri, 31 Mar 2023 10:29:46 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH net-next 1/3] net: ethernet: mtk_eth_soc: improve keeping track of offloaded flows
Date:   Fri, 31 Mar 2023 10:29:43 +0200
Message-Id: <20230331082945.75075-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
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

Unify tracking of L2 and L3 flows. Use the generic list field in struct
mtk_foe_entry for tracking L2 subflows. Preparation for improving
flow accounting support.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 162 ++++++++++++------------
 drivers/net/ethernet/mediatek/mtk_ppe.h |  15 +--
 2 files changed, 86 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index dd9581334b05..e9bcbdbe9c12 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -460,42 +460,43 @@ int mtk_foe_entry_set_queue(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 	return 0;
 }
 
+static int
+mtk_flow_entry_match_len(struct mtk_eth *eth, struct mtk_foe_entry *entry)
+{
+	int type = mtk_get_ib1_pkt_type(eth, entry->ib1);
+
+	if (type > MTK_PPE_PKT_TYPE_IPV4_DSLITE)
+		return offsetof(struct mtk_foe_entry, ipv6._rsv);
+	else
+		return offsetof(struct mtk_foe_entry, ipv4.ib2);
+}
+
 static bool
 mtk_flow_entry_match(struct mtk_eth *eth, struct mtk_flow_entry *entry,
-		     struct mtk_foe_entry *data)
+		     struct mtk_foe_entry *data, int len)
 {
-	int type, len;
-
 	if ((data->ib1 ^ entry->data.ib1) & MTK_FOE_IB1_UDP)
 		return false;
 
-	type = mtk_get_ib1_pkt_type(eth, entry->data.ib1);
-	if (type > MTK_PPE_PKT_TYPE_IPV4_DSLITE)
-		len = offsetof(struct mtk_foe_entry, ipv6._rsv);
-	else
-		len = offsetof(struct mtk_foe_entry, ipv4.ib2);
-
 	return !memcmp(&entry->data.data, &data->data, len - 4);
 }
 
 static void
-__mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
+__mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
+		      bool set_state)
 {
-	struct hlist_head *head;
 	struct hlist_node *tmp;
 
 	if (entry->type == MTK_FLOW_TYPE_L2) {
 		rhashtable_remove_fast(&ppe->l2_flows, &entry->l2_node,
 				       mtk_flow_l2_ht_params);
 
-		head = &entry->l2_flows;
-		hlist_for_each_entry_safe(entry, tmp, head, l2_data.list)
-			__mtk_foe_entry_clear(ppe, entry);
+		hlist_for_each_entry_safe(entry, tmp, &entry->l2_flows, l2_list)
+			__mtk_foe_entry_clear(ppe, entry, set_state);
 		return;
 	}
 
-	hlist_del_init(&entry->list);
-	if (entry->hash != 0xffff) {
+	if (entry->hash != 0xffff && set_state) {
 		struct mtk_foe_entry *hwe = mtk_foe_get_entry(ppe, entry->hash);
 
 		hwe->ib1 &= ~MTK_FOE_IB1_STATE;
@@ -516,7 +517,8 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 	if (entry->type != MTK_FLOW_TYPE_L2_SUBFLOW)
 		return;
 
-	hlist_del_init(&entry->l2_data.list);
+	hlist_del_init(&entry->l2_list);
+	hlist_del_init(&entry->list);
 	kfree(entry);
 }
 
@@ -532,68 +534,57 @@ static int __mtk_foe_entry_idle_time(struct mtk_ppe *ppe, u32 ib1)
 		return now - timestamp;
 }
 
+static bool
+mtk_flow_entry_update(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
+{
+	struct mtk_foe_entry foe = {};
+	struct mtk_foe_entry *hwe;
+	u16 hash = entry->hash;
+	int len;
+
+	if (hash == 0xffff)
+		return false;
+
+	hwe = mtk_foe_get_entry(ppe, hash);
+	len = mtk_flow_entry_match_len(ppe->eth, &entry->data);
+	memcpy(&foe, hwe, len);
+
+	if (!mtk_flow_entry_match(ppe->eth, entry, &foe, len) ||
+	    FIELD_GET(MTK_FOE_IB1_STATE, foe.ib1) != MTK_FOE_STATE_BIND)
+		return false;
+
+	entry->data.ib1 = foe.ib1;
+
+	return true;
+}
+
 static void
 mtk_flow_entry_update_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
 	u32 ib1_ts_mask = mtk_get_ib1_ts_mask(ppe->eth);
 	struct mtk_flow_entry *cur;
-	struct mtk_foe_entry *hwe;
 	struct hlist_node *tmp;
 	int idle;
 
 	idle = __mtk_foe_entry_idle_time(ppe, entry->data.ib1);
-	hlist_for_each_entry_safe(cur, tmp, &entry->l2_flows, l2_data.list) {
+	hlist_for_each_entry_safe(cur, tmp, &entry->l2_flows, l2_list) {
 		int cur_idle;
-		u32 ib1;
-
-		hwe = mtk_foe_get_entry(ppe, cur->hash);
-		ib1 = READ_ONCE(hwe->ib1);
 
-		if (FIELD_GET(MTK_FOE_IB1_STATE, ib1) != MTK_FOE_STATE_BIND) {
-			cur->hash = 0xffff;
-			__mtk_foe_entry_clear(ppe, cur);
+		if (!mtk_flow_entry_update(ppe, cur)) {
+			__mtk_foe_entry_clear(ppe, entry, false);
 			continue;
 		}
 
-		cur_idle = __mtk_foe_entry_idle_time(ppe, ib1);
+		cur_idle = __mtk_foe_entry_idle_time(ppe, cur->data.ib1);
 		if (cur_idle >= idle)
 			continue;
 
 		idle = cur_idle;
 		entry->data.ib1 &= ~ib1_ts_mask;
-		entry->data.ib1 |= hwe->ib1 & ib1_ts_mask;
+		entry->data.ib1 |= cur->data.ib1 & ib1_ts_mask;
 	}
 }
 
-static void
-mtk_flow_entry_update(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
-{
-	struct mtk_foe_entry foe = {};
-	struct mtk_foe_entry *hwe;
-
-	spin_lock_bh(&ppe_lock);
-
-	if (entry->type == MTK_FLOW_TYPE_L2) {
-		mtk_flow_entry_update_l2(ppe, entry);
-		goto out;
-	}
-
-	if (entry->hash == 0xffff)
-		goto out;
-
-	hwe = mtk_foe_get_entry(ppe, entry->hash);
-	memcpy(&foe, hwe, ppe->eth->soc->foe_entry_size);
-	if (!mtk_flow_entry_match(ppe->eth, entry, &foe)) {
-		entry->hash = 0xffff;
-		goto out;
-	}
-
-	entry->data.ib1 = foe.ib1;
-
-out:
-	spin_unlock_bh(&ppe_lock);
-}
-
 static void
 __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 		       u16 hash)
@@ -628,7 +619,8 @@ __mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_foe_entry *entry,
 void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
 	spin_lock_bh(&ppe_lock);
-	__mtk_foe_entry_clear(ppe, entry);
+	__mtk_foe_entry_clear(ppe, entry, true);
+	hlist_del_init(&entry->list);
 	spin_unlock_bh(&ppe_lock);
 }
 
@@ -675,8 +667,8 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 {
 	const struct mtk_soc_data *soc = ppe->eth->soc;
 	struct mtk_flow_entry *flow_info;
-	struct mtk_foe_entry foe = {}, *hwe;
 	struct mtk_foe_mac_info *l2;
+	struct mtk_foe_entry *hwe;
 	u32 ib1_mask = mtk_get_ib1_pkt_type_mask(ppe->eth) | MTK_FOE_IB1_UDP;
 	int type;
 
@@ -684,30 +676,30 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 	if (!flow_info)
 		return;
 
-	flow_info->l2_data.base_flow = entry;
 	flow_info->type = MTK_FLOW_TYPE_L2_SUBFLOW;
 	flow_info->hash = hash;
 	hlist_add_head(&flow_info->list,
 		       &ppe->foe_flow[hash / soc->hash_offset]);
-	hlist_add_head(&flow_info->l2_data.list, &entry->l2_flows);
+	hlist_add_head(&flow_info->l2_list, &entry->l2_flows);
 
 	hwe = mtk_foe_get_entry(ppe, hash);
-	memcpy(&foe, hwe, soc->foe_entry_size);
-	foe.ib1 &= ib1_mask;
-	foe.ib1 |= entry->data.ib1 & ~ib1_mask;
+	memcpy(&flow_info->data, hwe, soc->foe_entry_size);
+	flow_info->data.ib1 &= ib1_mask;
+	flow_info->data.ib1 |= entry->data.ib1 & ~ib1_mask;
 
-	l2 = mtk_foe_entry_l2(ppe->eth, &foe);
+	l2 = mtk_foe_entry_l2(ppe->eth, &flow_info->data);
 	memcpy(l2, &entry->data.bridge.l2, sizeof(*l2));
 
-	type = mtk_get_ib1_pkt_type(ppe->eth, foe.ib1);
+	type = mtk_get_ib1_pkt_type(ppe->eth, flow_info->data.ib1);
 	if (type == MTK_PPE_PKT_TYPE_IPV4_HNAPT)
-		memcpy(&foe.ipv4.new, &foe.ipv4.orig, sizeof(foe.ipv4.new));
+		memcpy(&flow_info->data.ipv4.new, &flow_info->data.ipv4.orig,
+		       sizeof(flow_info->data.ipv4.new));
 	else if (type >= MTK_PPE_PKT_TYPE_IPV6_ROUTE_3T && l2->etype == ETH_P_IP)
 		l2->etype = ETH_P_IPV6;
 
-	*mtk_foe_entry_ib2(ppe->eth, &foe) = entry->data.bridge.ib2;
+	*mtk_foe_entry_ib2(ppe->eth, &flow_info->data) = entry->data.bridge.ib2;
 
-	__mtk_foe_entry_commit(ppe, &foe, hash);
+	__mtk_foe_entry_commit(ppe, &flow_info->data, hash);
 }
 
 void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
@@ -717,9 +709,11 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 	struct mtk_foe_entry *hwe = mtk_foe_get_entry(ppe, hash);
 	struct mtk_flow_entry *entry;
 	struct mtk_foe_bridge key = {};
+	struct mtk_foe_entry foe = {};
 	struct hlist_node *n;
 	struct ethhdr *eh;
 	bool found = false;
+	int entry_len;
 	u8 *tag;
 
 	spin_lock_bh(&ppe_lock);
@@ -727,20 +721,14 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 	if (FIELD_GET(MTK_FOE_IB1_STATE, hwe->ib1) == MTK_FOE_STATE_BIND)
 		goto out;
 
-	hlist_for_each_entry_safe(entry, n, head, list) {
-		if (entry->type == MTK_FLOW_TYPE_L2_SUBFLOW) {
-			if (unlikely(FIELD_GET(MTK_FOE_IB1_STATE, hwe->ib1) ==
-				     MTK_FOE_STATE_BIND))
-				continue;
-
-			entry->hash = 0xffff;
-			__mtk_foe_entry_clear(ppe, entry);
-			continue;
-		}
+	entry_len = mtk_flow_entry_match_len(ppe->eth, hwe);
+	memcpy(&foe, hwe, entry_len);
 
-		if (found || !mtk_flow_entry_match(ppe->eth, entry, hwe)) {
+	hlist_for_each_entry_safe(entry, n, head, list) {
+		if (found ||
+		    !mtk_flow_entry_match(ppe->eth, entry, &foe, entry_len)) {
 			if (entry->hash != 0xffff)
-				entry->hash = 0xffff;
+				__mtk_foe_entry_clear(ppe, entry, false);
 			continue;
 		}
 
@@ -791,9 +779,17 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 
 int mtk_foe_entry_idle_time(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
-	mtk_flow_entry_update(ppe, entry);
+	int idle;
+
+	spin_lock_bh(&ppe_lock);
+	if (entry->type == MTK_FLOW_TYPE_L2)
+		mtk_flow_entry_update_l2(ppe, entry);
+	else
+		mtk_flow_entry_update(ppe, entry);
+	idle = __mtk_foe_entry_idle_time(ppe, entry->data.ib1);
+	spin_unlock_bh(&ppe_lock);
 
-	return __mtk_foe_entry_idle_time(ppe, entry->data.ib1);
+	return idle;
 }
 
 int mtk_ppe_prepare_reset(struct mtk_ppe *ppe)
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index e1aab2e8e262..6823256016a2 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -265,7 +265,12 @@ enum {
 
 struct mtk_flow_entry {
 	union {
-		struct hlist_node list;
+		/* regular flows + L2 subflows */
+		struct {
+			struct hlist_node list;
+			struct hlist_node l2_list;
+		};
+		/* L2 flows */
 		struct {
 			struct rhash_head l2_node;
 			struct hlist_head l2_flows;
@@ -275,13 +280,7 @@ struct mtk_flow_entry {
 	s8 wed_index;
 	u8 ppe_index;
 	u16 hash;
-	union {
-		struct mtk_foe_entry data;
-		struct {
-			struct mtk_flow_entry *base_flow;
-			struct hlist_node list;
-		} l2_data;
-	};
+	struct mtk_foe_entry data;
 	struct rhash_head node;
 	unsigned long cookie;
 };
-- 
2.39.0

