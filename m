Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F33A189A36
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 12:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgCRLF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 07:05:57 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:56198 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgCRLF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 07:05:57 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02IB5rLb010855;
        Wed, 18 Mar 2020 04:05:54 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next] cxgb4: rework TC filter rule insertion across regions
Date:   Wed, 18 Mar 2020 16:24:51 +0530
Message-Id: <1584528891-24714-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chelsio NICs have 3 filter regions, in following order of priority:
1. High Priority (HPFILTER) region (Highest Priority).
2. HASH region.
3. Normal FILTER region (Lowest Priority).

Currently, there's a 1-to-1 mapping between the prio value passed
by TC and the filter region index. However, it's possible to have
multiple TC rules with the same prio value. In this case, if a region
is exhausted, no attempt is made to try inserting the rule in the
next available region.

So, rework and remove the 1-to-1 mapping. Instead, dynamically select
the region to insert the filter rule, as long as the new rule's prio
value doesn't conflict with existing rules across all the 3 regions.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 305 +++++++++++++-----
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.h |   1 -
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 121 +++++--
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  22 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c |  79 +++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   5 +-
 6 files changed, 381 insertions(+), 152 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 2a2938bbb93a..e8852dfcc1f1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -438,13 +438,118 @@ int cxgb4_get_filter_counters(struct net_device *dev, unsigned int fidx,
 	return get_filter_count(adapter, fidx, hitcnt, bytecnt, hash);
 }
 
-int cxgb4_get_free_ftid(struct net_device *dev, int family)
+static bool cxgb4_filter_prio_in_range(struct tid_info *t, u32 idx, u8 nslots,
+				       u32 prio)
+{
+	struct filter_entry *prev_tab, *next_tab, *prev_fe, *next_fe;
+	u32 prev_ftid, next_ftid;
+
+	/* Only insert the rule if both of the following conditions
+	 * are met:
+	 * 1. The immediate previous rule has priority <= @prio.
+	 * 2. The immediate next rule has priority >= @prio.
+	 */
+
+	/* High Priority (HPFILTER) region always has higher priority
+	 * than normal FILTER region. So, all rules in HPFILTER region
+	 * must have prio value <= rules in normal FILTER region.
+	 */
+	if (idx < t->nhpftids) {
+		/* Don't insert if there's a rule already present at @idx
+		 * in HPFILTER region.
+		 */
+		if (test_bit(idx, t->hpftid_bmap))
+			return false;
+
+		next_tab = t->hpftid_tab;
+		next_ftid = find_next_bit(t->hpftid_bmap, t->nhpftids, idx);
+		if (next_ftid >= t->nhpftids) {
+			/* No next entry found in HPFILTER region.
+			 * See if there's any next entry in normal
+			 * FILTER region.
+			 */
+			next_ftid = find_first_bit(t->ftid_bmap, t->nftids);
+			if (next_ftid >= t->nftids)
+				next_ftid = idx;
+			else
+				next_tab = t->ftid_tab;
+		}
+
+		/* Search for the closest previous filter entry in HPFILTER
+		 * region. No need to search in normal FILTER region because
+		 * there can never be any entry in normal FILTER region whose
+		 * prio value is < last entry in HPFILTER region.
+		 */
+		prev_ftid = find_last_bit(t->hpftid_bmap, idx);
+		if (prev_ftid >= idx)
+			prev_ftid = idx;
+
+		prev_tab = t->hpftid_tab;
+	} else {
+		idx -= t->nhpftids;
+
+		/* Don't insert if there's a rule already present at @idx
+		 * in normal FILTER region.
+		 */
+		if (test_bit(idx, t->ftid_bmap))
+			return false;
+
+		prev_tab = t->ftid_tab;
+		prev_ftid = find_last_bit(t->ftid_bmap, idx);
+		if (prev_ftid >= idx) {
+			/* No previous entry found in normal FILTER
+			 * region. See if there's any previous entry
+			 * in HPFILTER region.
+			 */
+			prev_ftid = find_last_bit(t->hpftid_bmap, t->nhpftids);
+			if (prev_ftid >= t->nhpftids)
+				prev_ftid = idx;
+			else
+				prev_tab = t->hpftid_tab;
+		}
+
+		/* Search for the closest next filter entry in normal
+		 * FILTER region. No need to search in HPFILTER region
+		 * because there can never be any entry in HPFILTER
+		 * region whose prio value is > first entry in normal
+		 * FILTER region.
+		 */
+		next_ftid = find_next_bit(t->ftid_bmap, t->nftids, idx);
+		if (next_ftid >= t->nftids)
+			next_ftid = idx;
+
+		next_tab = t->ftid_tab;
+	}
+
+	next_fe = &next_tab[next_ftid];
+
+	/* See if the filter entry belongs to an IPv6 rule, which
+	 * occupy 4 slots on T5 and 2 slots on T6. Adjust the
+	 * reference to the previously inserted filter entry
+	 * accordingly.
+	 */
+	prev_fe = &prev_tab[prev_ftid & ~(nslots - 1)];
+	if (!prev_fe->fs.type)
+		prev_fe = &prev_tab[prev_ftid];
+
+	if ((prev_fe->valid && prev_fe->fs.tc_prio > prio) ||
+	    (next_fe->valid && next_fe->fs.tc_prio < prio))
+		return false;
+
+	return true;
+}
+
+int cxgb4_get_free_ftid(struct net_device *dev, u8 family, bool hash_en,
+			u32 tc_prio)
 {
 	struct adapter *adap = netdev2adap(dev);
 	struct tid_info *t = &adap->tids;
+	struct filter_entry *tab, *f;
+	u32 bmap_ftid, max_ftid;
+	unsigned long *bmap;
 	bool found = false;
-	u8 i, n, cnt;
-	int ftid;
+	u8 i, cnt, n;
+	int ftid = 0;
 
 	/* IPv4 occupy 1 slot. IPv6 occupy 2 slots on T6 and 4 slots
 	 * on T5.
@@ -456,34 +561,129 @@ int cxgb4_get_free_ftid(struct net_device *dev, int family)
 			n += 2;
 	}
 
-	if (n > t->nftids)
-		return -ENOMEM;
-
-	/* Find free filter slots from the end of TCAM. Appropriate
-	 * checks must be done by caller later to ensure the prio
-	 * passed by TC doesn't conflict with prio saved by existing
-	 * rules in the TCAM.
+	/* There are 3 filter regions available in hardware in
+	 * following order of priority:
+	 *
+	 * 1. High Priority (HPFILTER) region (Highest Priority).
+	 * 2. HASH region.
+	 * 3. Normal FILTER region (Lowest Priority).
+	 *
+	 * Entries in HPFILTER and normal FILTER region have index
+	 * 0 as the highest priority and the rules will be scanned
+	 * in ascending order until either a rule hits or end of
+	 * the region is reached.
+	 *
+	 * All HASH region entries have same priority. The set of
+	 * fields to match in headers are pre-determined. The same
+	 * set of header match fields must be compulsorily specified
+	 * in all the rules wanting to get inserted in HASH region.
+	 * Hence, HASH region is an exact-match region. A HASH is
+	 * generated for a rule based on the values in the
+	 * pre-determined set of header match fields. The generated
+	 * HASH serves as an index into the HASH region. There can
+	 * never be 2 rules having the same HASH. Hardware will
+	 * compute a HASH for every incoming packet based on the
+	 * values in the pre-determined set of header match fields
+	 * and uses it as an index to check if there's a rule
+	 * inserted in the HASH region at the specified index. If
+	 * there's a rule inserted, then it's considered as a filter
+	 * hit. Otherwise, it's a filter miss and normal FILTER region
+	 * is scanned afterwards.
 	 */
+
 	spin_lock_bh(&t->ftid_lock);
-	ftid = t->nftids - 1;
-	while (ftid >= n - 1) {
+
+	ftid = (tc_prio <= t->nhpftids) ? 0 : t->nhpftids;
+	max_ftid = t->nftids + t->nhpftids;
+	while (ftid < max_ftid) {
+		if (ftid < t->nhpftids) {
+			/* If the new rule wants to get inserted into
+			 * HPFILTER region, but its prio is greater
+			 * than the rule with the highest prio in HASH
+			 * region, then reject the rule.
+			 */
+			if (t->tc_hash_tids_max_prio &&
+			    tc_prio > t->tc_hash_tids_max_prio)
+				break;
+
+			/* If there's not enough slots available
+			 * in HPFILTER region, then move on to
+			 * normal FILTER region immediately.
+			 */
+			if (ftid + n > t->nhpftids) {
+				ftid = t->nhpftids;
+				continue;
+			}
+
+			bmap = t->hpftid_bmap;
+			bmap_ftid = ftid;
+			tab = t->hpftid_tab;
+		} else if (hash_en) {
+			/* Ensure priority is >= last rule in HPFILTER
+			 * region.
+			 */
+			ftid = find_last_bit(t->hpftid_bmap, t->nhpftids);
+			if (ftid < t->nhpftids) {
+				f = &t->hpftid_tab[ftid];
+				if (f->valid && tc_prio < f->fs.tc_prio)
+					break;
+			}
+
+			/* Ensure priority is <= first rule in normal
+			 * FILTER region.
+			 */
+			ftid = find_first_bit(t->ftid_bmap, t->nftids);
+			if (ftid < t->nftids) {
+				f = &t->ftid_tab[ftid];
+				if (f->valid && tc_prio > f->fs.tc_prio)
+					break;
+			}
+
+			found = true;
+			ftid = t->nhpftids;
+			goto out_unlock;
+		} else {
+			/* If the new rule wants to get inserted into
+			 * normal FILTER region, but its prio is less
+			 * than the rule with the highest prio in HASH
+			 * region, then reject the rule.
+			 */
+			if (t->tc_hash_tids_max_prio &&
+			    tc_prio < t->tc_hash_tids_max_prio)
+				break;
+
+			if (ftid + n > max_ftid)
+				break;
+
+			bmap = t->ftid_bmap;
+			bmap_ftid = ftid - t->nhpftids;
+			tab = t->ftid_tab;
+		}
+
 		cnt = 0;
 		for (i = 0; i < n; i++) {
-			if (test_bit(ftid - i, t->ftid_bmap))
+			if (test_bit(bmap_ftid + i, bmap))
 				break;
 			cnt++;
 		}
+
 		if (cnt == n) {
-			ftid &= ~(n - 1);
-			found = true;
-			break;
+			/* Ensure the new rule's prio doesn't conflict
+			 * with existing rules.
+			 */
+			if (cxgb4_filter_prio_in_range(t, ftid, n,
+						       tc_prio)) {
+				ftid &= ~(n - 1);
+				found = true;
+				break;
+			}
 		}
 
-		ftid -= n;
+		ftid += n;
 	}
-	spin_unlock_bh(&t->ftid_lock);
-	ftid += t->nhpftids;
 
+out_unlock:
+	spin_unlock_bh(&t->ftid_lock);
 	return found ? ftid : -ENOMEM;
 }
 
@@ -555,73 +755,6 @@ static void cxgb4_clear_hpftid(struct tid_info *t, int fidx, int family)
 	spin_unlock_bh(&t->ftid_lock);
 }
 
-bool cxgb4_filter_prio_in_range(struct net_device *dev, u32 idx, u32 prio)
-{
-	struct filter_entry *prev_fe, *next_fe, *tab;
-	struct adapter *adap = netdev2adap(dev);
-	u32 prev_ftid, next_ftid, max_tid;
-	struct tid_info *t = &adap->tids;
-	unsigned long *bmap;
-	bool valid = true;
-
-	if (idx < t->nhpftids) {
-		bmap = t->hpftid_bmap;
-		tab = t->hpftid_tab;
-		max_tid = t->nhpftids;
-	} else {
-		idx -= t->nhpftids;
-		bmap = t->ftid_bmap;
-		tab = t->ftid_tab;
-		max_tid = t->nftids;
-	}
-
-	/* Only insert the rule if both of the following conditions
-	 * are met:
-	 * 1. The immediate previous rule has priority <= @prio.
-	 * 2. The immediate next rule has priority >= @prio.
-	 */
-	spin_lock_bh(&t->ftid_lock);
-
-	/* Don't insert if there's a rule already present at @idx. */
-	if (test_bit(idx, bmap)) {
-		valid = false;
-		goto out_unlock;
-	}
-
-	next_ftid = find_next_bit(bmap, max_tid, idx);
-	if (next_ftid >= max_tid)
-		next_ftid = idx;
-
-	next_fe = &tab[next_ftid];
-
-	prev_ftid = find_last_bit(bmap, idx);
-	if (prev_ftid >= idx)
-		prev_ftid = idx;
-
-	/* See if the filter entry belongs to an IPv6 rule, which
-	 * occupy 4 slots on T5 and 2 slots on T6. Adjust the
-	 * reference to the previously inserted filter entry
-	 * accordingly.
-	 */
-	if (CHELSIO_CHIP_VERSION(adap->params.chip) < CHELSIO_T6) {
-		prev_fe = &tab[prev_ftid & ~0x3];
-		if (!prev_fe->fs.type)
-			prev_fe = &tab[prev_ftid];
-	} else {
-		prev_fe = &tab[prev_ftid & ~0x1];
-		if (!prev_fe->fs.type)
-			prev_fe = &tab[prev_ftid];
-	}
-
-	if ((prev_fe->valid && prio < prev_fe->fs.tc_prio) ||
-	    (next_fe->valid && prio > next_fe->fs.tc_prio))
-		valid = false;
-
-out_unlock:
-	spin_unlock_bh(&t->ftid_lock);
-	return valid;
-}
-
 /* Delete the filter at a specified index. */
 static int del_filter_wr(struct adapter *adapter, int fidx)
 {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
index b3e4a645043d..b0751c0611ec 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.h
@@ -53,5 +53,4 @@ void clear_all_filters(struct adapter *adapter);
 void init_hash_filter(struct adapter *adap);
 bool is_filter_exact_match(struct adapter *adap,
 			   struct ch_filter_specification *fs);
-bool cxgb4_filter_prio_in_range(struct net_device *dev, u32 idx, u32 prio);
 #endif /* __CXGB4_FILTER_H */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index b457f2505f97..aec9b90313e7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -635,6 +635,64 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 	return 0;
 }
 
+static void cxgb4_tc_flower_hash_prio_add(struct adapter *adap, u32 tc_prio)
+{
+	spin_lock_bh(&adap->tids.ftid_lock);
+	if (adap->tids.tc_hash_tids_max_prio < tc_prio)
+		adap->tids.tc_hash_tids_max_prio = tc_prio;
+	spin_unlock_bh(&adap->tids.ftid_lock);
+}
+
+static void cxgb4_tc_flower_hash_prio_del(struct adapter *adap, u32 tc_prio)
+{
+	struct tid_info *t = &adap->tids;
+	struct ch_tc_flower_entry *fe;
+	struct rhashtable_iter iter;
+	u32 found = 0;
+
+	spin_lock_bh(&t->ftid_lock);
+	/* Bail if the current rule is not the one with the max
+	 * prio.
+	 */
+	if (t->tc_hash_tids_max_prio != tc_prio)
+		goto out_unlock;
+
+	/* Search for the next rule having the same or next lower
+	 * max prio.
+	 */
+	rhashtable_walk_enter(&adap->flower_tbl, &iter);
+	do {
+		rhashtable_walk_start(&iter);
+
+		fe = rhashtable_walk_next(&iter);
+		while (!IS_ERR_OR_NULL(fe)) {
+			if (fe->fs.hash &&
+			    fe->fs.tc_prio <= t->tc_hash_tids_max_prio) {
+				t->tc_hash_tids_max_prio = fe->fs.tc_prio;
+				found++;
+
+				/* Bail if we found another rule
+				 * having the same prio as the
+				 * current max one.
+				 */
+				if (fe->fs.tc_prio == tc_prio)
+					break;
+			}
+
+			fe = rhashtable_walk_next(&iter);
+		}
+
+		rhashtable_walk_stop(&iter);
+	} while (fe == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
+
+	if (!found)
+		t->tc_hash_tids_max_prio = 0;
+
+out_unlock:
+	spin_unlock_bh(&t->ftid_lock);
+}
+
 int cxgb4_tc_flower_replace(struct net_device *dev,
 			    struct flow_cls_offload *cls)
 {
@@ -644,6 +702,7 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	struct ch_tc_flower_entry *ch_flower;
 	struct ch_filter_specification *fs;
 	struct filter_ctx ctx;
+	u8 inet_family;
 	int fidx, ret;
 
 	if (cxgb4_validate_flow_actions(dev, &rule->action, extack))
@@ -664,39 +723,32 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	cxgb4_process_flow_actions(dev, &rule->action, fs);
 
 	fs->hash = is_filter_exact_match(adap, fs);
-	if (fs->hash) {
-		fidx = 0;
-	} else {
-		u8 inet_family;
+	inet_family = fs->type ? PF_INET6 : PF_INET;
 
-		inet_family = fs->type ? PF_INET6 : PF_INET;
-
-		/* Note that TC uses prio 0 to indicate stack to
-		 * generate automatic prio and hence doesn't pass prio
-		 * 0 to driver. However, the hardware TCAM index
-		 * starts from 0. Hence, the -1 here.
-		 */
-		if (cls->common.prio <= (adap->tids.nftids +
-					 adap->tids.nhpftids)) {
-			fidx = cls->common.prio - 1;
-			if (fidx < adap->tids.nhpftids)
-				fs->prio = 1;
-		} else {
-			fidx = cxgb4_get_free_ftid(dev, inet_family);
-		}
+	/* Get a free filter entry TID, where we can insert this new
+	 * rule. Only insert rule if its prio doesn't conflict with
+	 * existing rules.
+	 */
+	fidx = cxgb4_get_free_ftid(dev, inet_family, fs->hash,
+				   cls->common.prio);
+	if (fidx < 0) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "No free LETCAM index available");
+		ret = -ENOMEM;
+		goto free_entry;
+	}
 
-		/* Only insert FLOWER rule if its priority doesn't
-		 * conflict with existing rules in the LETCAM.
-		 */
-		if (fidx < 0 ||
-		    !cxgb4_filter_prio_in_range(dev, fidx, cls->common.prio)) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "No free LETCAM index available");
-			ret = -ENOMEM;
-			goto free_entry;
-		}
+	if (fidx < adap->tids.nhpftids) {
+		fs->prio = 1;
+		fs->hash = 0;
 	}
 
+	/* If the rule can be inserted into HASH region, then ignore
+	 * the index to normal FILTER region.
+	 */
+	if (fs->hash)
+		fidx = 0;
+
 	fs->tc_prio = cls->common.prio;
 	fs->tc_cookie = cls->cookie;
 
@@ -727,6 +779,9 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	if (ret)
 		goto del_filter;
 
+	if (fs->hash)
+		cxgb4_tc_flower_hash_prio_add(adap, cls->common.prio);
+
 	return 0;
 
 del_filter:
@@ -742,12 +797,17 @@ int cxgb4_tc_flower_destroy(struct net_device *dev,
 {
 	struct adapter *adap = netdev2adap(dev);
 	struct ch_tc_flower_entry *ch_flower;
+	u32 tc_prio;
+	bool hash;
 	int ret;
 
 	ch_flower = ch_flower_lookup(adap, cls->cookie);
 	if (!ch_flower)
 		return -ENOENT;
 
+	hash = ch_flower->fs.hash;
+	tc_prio = ch_flower->fs.tc_prio;
+
 	ret = cxgb4_del_filter(dev, ch_flower->filter_id, &ch_flower->fs);
 	if (ret)
 		goto err;
@@ -760,6 +820,9 @@ int cxgb4_tc_flower_destroy(struct net_device *dev,
 	}
 	kfree_rcu(ch_flower, rcu);
 
+	if (hash)
+		cxgb4_tc_flower_hash_prio_del(adap, tc_prio);
+
 err:
 	return ret;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index d80dee4d316d..8a5ae8bc9b7d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -198,22 +198,14 @@ static int cxgb4_matchall_alloc_filter(struct net_device *dev,
 	struct ch_filter_specification *fs;
 	int ret, fidx;
 
-	/* Note that TC uses prio 0 to indicate stack to generate
-	 * automatic prio and hence doesn't pass prio 0 to driver.
-	 * However, the hardware TCAM index starts from 0. Hence, the
-	 * -1 here. 1 slot is enough to create a wildcard matchall
-	 * VIID rule.
+	/* Get a free filter entry TID, where we can insert this new
+	 * rule. Only insert rule if its prio doesn't conflict with
+	 * existing rules.
+	 *
+	 * 1 slot is enough to create a wildcard matchall VIID rule.
 	 */
-	if (cls->common.prio <= (adap->tids.nftids + adap->tids.nhpftids))
-		fidx = cls->common.prio - 1;
-	else
-		fidx = cxgb4_get_free_ftid(dev, PF_INET);
-
-	/* Only insert MATCHALL rule if its priority doesn't conflict
-	 * with existing rules in the LETCAM.
-	 */
-	if (fidx < 0 ||
-	    !cxgb4_filter_prio_in_range(dev, fidx, cls->common.prio)) {
+	fidx = cxgb4_get_free_ftid(dev, PF_INET, false, cls->common.prio);
+	if (fidx < 0) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "No free LETCAM index available");
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
index 269b8d9e25e0..3f3c11e54d97 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
@@ -155,9 +155,10 @@ int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 	struct ch_filter_specification fs;
 	struct cxgb4_tc_u32_table *t;
 	struct cxgb4_link *link;
-	unsigned int filter_id;
 	u32 uhtid, link_uhtid;
 	bool is_ipv6 = false;
+	u8 inet_family;
+	int filter_id;
 	int ret;
 
 	if (!can_tc_u32_offload(dev))
@@ -166,18 +167,15 @@ int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 	if (protocol != htons(ETH_P_IP) && protocol != htons(ETH_P_IPV6))
 		return -EOPNOTSUPP;
 
-	/* Note that TC uses prio 0 to indicate stack to generate
-	 * automatic prio and hence doesn't pass prio 0 to driver.
-	 * However, the hardware TCAM index starts from 0. Hence, the
-	 * -1 here.
-	 */
-	filter_id = TC_U32_NODE(cls->knode.handle) - 1;
+	inet_family = (protocol == htons(ETH_P_IPV6)) ? PF_INET6 : PF_INET;
 
-	/* Only insert U32 rule if its priority doesn't conflict with
-	 * existing rules in the LETCAM.
+	/* Get a free filter entry TID, where we can insert this new
+	 * rule. Only insert rule if its prio doesn't conflict with
+	 * existing rules.
 	 */
-	if (filter_id >= adapter->tids.nftids + adapter->tids.nhpftids ||
-	    !cxgb4_filter_prio_in_range(dev, filter_id, cls->common.prio)) {
+	filter_id = cxgb4_get_free_ftid(dev, inet_family, false,
+					TC_U32_NODE(cls->knode.handle));
+	if (filter_id < 0) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "No free LETCAM index available");
 		return -ENOMEM;
@@ -358,23 +356,65 @@ int cxgb4_delete_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 	struct cxgb4_link *link = NULL;
 	struct cxgb4_tc_u32_table *t;
 	struct filter_entry *f;
+	bool found = false;
 	u32 handle, uhtid;
+	u8 nslots;
 	int ret;
 
 	if (!can_tc_u32_offload(dev))
 		return -EOPNOTSUPP;
 
 	/* Fetch the location to delete the filter. */
-	filter_id = TC_U32_NODE(cls->knode.handle) - 1;
-	if (filter_id >= adapter->tids.nftids + adapter->tids.nhpftids)
-		return -ERANGE;
+	max_tids = adapter->tids.nhpftids + adapter->tids.nftids;
+
+	spin_lock_bh(&adapter->tids.ftid_lock);
+	filter_id = 0;
+	while (filter_id < max_tids) {
+		if (filter_id < adapter->tids.nhpftids) {
+			i = filter_id;
+			f = &adapter->tids.hpftid_tab[i];
+			if (f->valid && f->fs.tc_cookie == cls->knode.handle) {
+				found = true;
+				break;
+			}
 
-	if (filter_id < adapter->tids.nhpftids)
-		f = &adapter->tids.hpftid_tab[filter_id];
-	else
-		f = &adapter->tids.ftid_tab[filter_id - adapter->tids.nhpftids];
+			i = find_next_bit(adapter->tids.hpftid_bmap,
+					  adapter->tids.nhpftids, i + 1);
+			if (i >= adapter->tids.nhpftids) {
+				filter_id = adapter->tids.nhpftids;
+				continue;
+			}
+
+			filter_id = i;
+		} else {
+			i = filter_id - adapter->tids.nhpftids;
+			f = &adapter->tids.ftid_tab[i];
+			if (f->valid && f->fs.tc_cookie == cls->knode.handle) {
+				found = true;
+				break;
+			}
+
+			i = find_next_bit(adapter->tids.ftid_bmap,
+					  adapter->tids.nftids, i + 1);
+			if (i >= adapter->tids.nftids)
+				break;
+
+			filter_id = i + adapter->tids.nhpftids;
+		}
+
+		nslots = 0;
+		if (f->fs.type) {
+			nslots++;
+			if (CHELSIO_CHIP_VERSION(adapter->params.chip) <
+			    CHELSIO_T6)
+				nslots += 2;
+		}
+
+		filter_id += nslots;
+	}
+	spin_unlock_bh(&adapter->tids.ftid_lock);
 
-	if (cls->knode.handle != f->fs.tc_cookie)
+	if (!found)
 		return -ERANGE;
 
 	t = adapter->tc_u32;
@@ -407,7 +447,6 @@ int cxgb4_delete_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 	/* If a link is being deleted, then delete all filters
 	 * associated with the link.
 	 */
-	max_tids = adapter->tids.nftids;
 	for (i = 0; i < t->size; i++) {
 		link = &t->table[i];
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 03b9bdc812cc..be831317520a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -149,6 +149,8 @@ struct tid_info {
 	atomic_t conns_in_use;
 	/* lock for setting/clearing filter bitmap */
 	spinlock_t ftid_lock;
+
+	unsigned int tc_hash_tids_max_prio;
 };
 
 static inline void *lookup_tid(const struct tid_info *t, unsigned int tid)
@@ -263,7 +265,8 @@ struct filter_ctx {
 
 struct ch_filter_specification;
 
-int cxgb4_get_free_ftid(struct net_device *dev, int family);
+int cxgb4_get_free_ftid(struct net_device *dev, u8 family, bool hash_en,
+			u32 tc_prio);
 int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 		       struct ch_filter_specification *fs,
 		       struct filter_ctx *ctx);
-- 
2.24.0

