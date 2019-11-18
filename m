Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA51009EC
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 18:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfKRRIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 12:08:54 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:44074 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfKRRIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 12:08:53 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAIH8n2q018672;
        Mon, 18 Nov 2019 09:08:50 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next v4 2/3] cxgb4: check rule prio conflicts before offload
Date:   Mon, 18 Nov 2019 22:30:18 +0530
Message-Id: <f93ecd0a1607d3eebdbf3f9738abef7d8166eba0.1574089391.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1574089391.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574089391.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1574089391.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574089391.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only offload rule if it satisfies following conditions:
1. The immediate previous rule has priority < current rule's priority.
2. The immediate next rule has priority > current rule's priority.

Also rework free entry fetch logic to search from end of TCAM, instead
of beginning, because higher indices have lower priority than lower
indices. This is similar to how TC auto generates priority values.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
v4:
- Patch added in this version.

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   5 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 113 ++++++++++++++----
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.h |   1 +
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  31 ++++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c |  36 +++---
 5 files changed, 142 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 9376be6e51a3..3121ed83d8e2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1286,8 +1286,11 @@ struct ch_filter_specification {
 	u16 nat_lport;		/* local port to use after NAT'ing */
 	u16 nat_fport;		/* foreign port to use after NAT'ing */
 
+	u32 tc_prio;		/* TC's filter priority index */
+	u64 tc_cookie;		/* Unique cookie identifying TC rules */
+
 	/* reservation for future additions */
-	u8 rsvd[24];
+	u8 rsvd[12];
 
 	/* Filter rule value/mask pairs.
 	 */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 43b0f8c57da7..f19fd4efcd08 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -440,36 +440,48 @@ int cxgb4_get_free_ftid(struct net_device *dev, int family)
 {
 	struct adapter *adap = netdev2adap(dev);
 	struct tid_info *t = &adap->tids;
+	bool found = false;
+	u8 i, n, cnt;
 	int ftid;
 
-	spin_lock_bh(&t->ftid_lock);
-	if (family == PF_INET) {
-		ftid = find_first_zero_bit(t->ftid_bmap, t->nftids);
-		if (ftid >= t->nftids)
-			ftid = -1;
-	} else {
-		if (is_t6(adap->params.chip)) {
-			ftid = bitmap_find_free_region(t->ftid_bmap,
-						       t->nftids, 1);
-			if (ftid < 0)
-				goto out_unlock;
-
-			/* this is only a lookup, keep the found region
-			 * unallocated
-			 */
-			bitmap_release_region(t->ftid_bmap, ftid, 1);
-		} else {
-			ftid = bitmap_find_free_region(t->ftid_bmap,
-						       t->nftids, 2);
-			if (ftid < 0)
-				goto out_unlock;
+	/* IPv4 occupy 1 slot. IPv6 occupy 2 slots on T6 and 4 slots
+	 * on T5.
+	 */
+	n = 1;
+	if (family == PF_INET6) {
+		n++;
+		if (CHELSIO_CHIP_VERSION(adap->params.chip) < CHELSIO_T6)
+			n += 2;
+	}
+
+	if (n > t->nftids)
+		return -ENOMEM;
 
-			bitmap_release_region(t->ftid_bmap, ftid, 2);
+	/* Find free filter slots from the end of TCAM. Appropriate
+	 * checks must be done by caller later to ensure the prio
+	 * passed by TC doesn't conflict with prio saved by existing
+	 * rules in the TCAM.
+	 */
+	spin_lock_bh(&t->ftid_lock);
+	ftid = t->nftids - 1;
+	while (ftid >= n - 1) {
+		cnt = 0;
+		for (i = 0; i < n; i++) {
+			if (test_bit(ftid - i, t->ftid_bmap))
+				break;
+			cnt++;
 		}
+		if (cnt == n) {
+			ftid &= ~(n - 1);
+			found = true;
+			break;
+		}
+
+		ftid -= n;
 	}
-out_unlock:
 	spin_unlock_bh(&t->ftid_lock);
-	return ftid;
+
+	return found ? ftid : -ENOMEM;
 }
 
 static int cxgb4_set_ftid(struct tid_info *t, int fidx, int family,
@@ -510,6 +522,59 @@ static void cxgb4_clear_ftid(struct tid_info *t, int fidx, int family,
 	spin_unlock_bh(&t->ftid_lock);
 }
 
+bool cxgb4_filter_prio_in_range(struct net_device *dev, u32 idx, u32 prio)
+{
+	struct adapter *adap = netdev2adap(dev);
+	struct filter_entry *prev_fe, *next_fe;
+	struct tid_info *t = &adap->tids;
+	u32 prev_ftid, next_ftid;
+	bool valid = true;
+
+	/* Only insert the rule if following conditions are met:
+	 * 1. The immediate previous rule has priority < @prio.
+	 * 2. The immediate next rule has priority > @prio.
+	 */
+	spin_lock_bh(&t->ftid_lock);
+	/* Don't insert if there's a rule already present at @idx. */
+	if (test_bit(idx, t->ftid_bmap)) {
+		valid = false;
+		goto out_unlock;
+	}
+
+	next_ftid = find_next_bit(t->ftid_bmap, t->nftids, idx);
+	if (next_ftid >= t->nftids)
+		next_ftid = idx;
+
+	next_fe = &adap->tids.ftid_tab[next_ftid];
+
+	prev_ftid = find_last_bit(t->ftid_bmap, idx);
+	if (prev_ftid >= idx)
+		prev_ftid = idx;
+
+	/* See if the filter entry belongs to an IPv6 rule, which
+	 * occupy 4 slots on T5 and 2 slots on T6. Adjust the
+	 * reference to the previously inserted filter entry
+	 * accordingly.
+	 */
+	if (CHELSIO_CHIP_VERSION(adap->params.chip) < CHELSIO_T6) {
+		prev_fe = &adap->tids.ftid_tab[prev_ftid & ~0x3];
+		if (!prev_fe->fs.type)
+			prev_fe = &adap->tids.ftid_tab[prev_ftid];
+	} else {
+		prev_fe = &adap->tids.ftid_tab[prev_ftid & ~0x1];
+		if (!prev_fe->fs.type)
+			prev_fe = &adap->tids.ftid_tab[prev_ftid];
+	}
+
+	if ((prev_fe->valid && prio < prev_fe->fs.tc_prio) ||
+	    (next_fe->valid && prio > next_fe->fs.tc_prio))
+		valid = false;
+
+out_unlock:
+	spin_unlock_bh(&t->ftid_lock);
+	return valid;
+}
+
 /* Delete the filter at a specified index. */
 static int del_filter_wr(struct adapter *adapter, int fidx)
 {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
index b0751c0611ec..b3e4a645043d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
@@ -53,4 +53,5 @@ void clear_all_filters(struct adapter *adapter);
 void init_hash_filter(struct adapter *adap);
 bool is_filter_exact_match(struct adapter *adap,
 			   struct ch_filter_specification *fs);
+bool cxgb4_filter_prio_in_range(struct net_device *dev, u32 idx, u32 prio);
 #endif /* __CXGB4_FILTER_H */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index e447976bdd3e..5179ad23be3c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -636,12 +636,12 @@ static int cxgb4_validate_flow_actions(struct net_device *dev,
 int cxgb4_tc_flower_replace(struct net_device *dev,
 			    struct flow_cls_offload *cls)
 {
+	struct netlink_ext_ack *extack = cls->common.extack;
 	struct adapter *adap = netdev2adap(dev);
 	struct ch_tc_flower_entry *ch_flower;
 	struct ch_filter_specification *fs;
 	struct filter_ctx ctx;
-	int fidx;
-	int ret;
+	int fidx, ret;
 
 	if (cxgb4_validate_flow_actions(dev, cls))
 		return -EOPNOTSUPP;
@@ -664,14 +664,35 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	if (fs->hash) {
 		fidx = 0;
 	} else {
-		fidx = cxgb4_get_free_ftid(dev, fs->type ? PF_INET6 : PF_INET);
-		if (fidx < 0) {
-			netdev_err(dev, "%s: No fidx for offload.\n", __func__);
+		u8 inet_family;
+
+		inet_family = fs->type ? PF_INET6 : PF_INET;
+
+		/* Note that TC uses prio 0 to indicate stack to
+		 * generate automatic prio and hence doesn't pass prio
+		 * 0 to driver. However, the hardware TCAM index
+		 * starts from 0. Hence, the -1 here.
+		 */
+		if (cls->common.prio <= adap->tids.nftids)
+			fidx = cls->common.prio - 1;
+		else
+			fidx = cxgb4_get_free_ftid(dev, inet_family);
+
+		/* Only insert FLOWER rule if its priority doesn't
+		 * conflict with existing rules in the LETCAM.
+		 */
+		if (fidx < 0 ||
+		    !cxgb4_filter_prio_in_range(dev, fidx, cls->common.prio)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "No free LETCAM index available");
 			ret = -ENOMEM;
 			goto free_entry;
 		}
 	}
 
+	fs->tc_prio = cls->common.prio;
+	fs->tc_cookie = cls->cookie;
+
 	init_completion(&ctx.completion);
 	ret = __cxgb4_set_filter(dev, fidx, fs, &ctx);
 	if (ret) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
index 02fc63fa7f25..133f8623ba86 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
@@ -36,6 +36,7 @@
 #include <net/tc_act/tc_mirred.h>
 
 #include "cxgb4.h"
+#include "cxgb4_filter.h"
 #include "cxgb4_tc_u32_parse.h"
 #include "cxgb4_tc_u32.h"
 
@@ -148,6 +149,7 @@ static int fill_action_fields(struct adapter *adap,
 int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 {
 	const struct cxgb4_match_field *start, *link_start = NULL;
+	struct netlink_ext_ack *extack = cls->common.extack;
 	struct adapter *adapter = netdev2adap(dev);
 	__be16 protocol = cls->common.protocol;
 	struct ch_filter_specification fs;
@@ -164,14 +166,21 @@ int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 	if (protocol != htons(ETH_P_IP) && protocol != htons(ETH_P_IPV6))
 		return -EOPNOTSUPP;
 
-	/* Fetch the location to insert the filter. */
-	filter_id = cls->knode.handle & 0xFFFFF;
+	/* Note that TC uses prio 0 to indicate stack to generate
+	 * automatic prio and hence doesn't pass prio 0 to driver.
+	 * However, the hardware TCAM index starts from 0. Hence, the
+	 * -1 here.
+	 */
+	filter_id = TC_U32_NODE(cls->knode.handle) - 1;
 
-	if (filter_id > adapter->tids.nftids) {
-		dev_err(adapter->pdev_dev,
-			"Location %d out of range for insertion. Max: %d\n",
-			filter_id, adapter->tids.nftids);
-		return -ERANGE;
+	/* Only insert U32 rule if its priority doesn't conflict with
+	 * existing rules in the LETCAM.
+	 */
+	if (filter_id >= adapter->tids.nftids ||
+	    !cxgb4_filter_prio_in_range(dev, filter_id, cls->common.prio)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "No free LETCAM index available");
+		return -ENOMEM;
 	}
 
 	t = adapter->tc_u32;
@@ -190,6 +199,9 @@ int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 
 	memset(&fs, 0, sizeof(fs));
 
+	fs.tc_prio = cls->common.prio;
+	fs.tc_cookie = cls->knode.handle;
+
 	if (protocol == htons(ETH_P_IPV6)) {
 		start = cxgb4_ipv6_fields;
 		is_ipv6 = true;
@@ -350,14 +362,10 @@ int cxgb4_delete_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 		return -EOPNOTSUPP;
 
 	/* Fetch the location to delete the filter. */
-	filter_id = cls->knode.handle & 0xFFFFF;
-
-	if (filter_id > adapter->tids.nftids) {
-		dev_err(adapter->pdev_dev,
-			"Location %d out of range for deletion. Max: %d\n",
-			filter_id, adapter->tids.nftids);
+	filter_id = TC_U32_NODE(cls->knode.handle) - 1;
+	if (filter_id >= adapter->tids.nftids ||
+	    cls->knode.handle != adapter->tids.ftid_tab[filter_id].fs.tc_cookie)
 		return -ERANGE;
-	}
 
 	t = adapter->tc_u32;
 	handle = cls->knode.handle;
-- 
2.24.0

