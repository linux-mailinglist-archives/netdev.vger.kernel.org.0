Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A6411859F
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfLJK5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:57:16 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:11055 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfLJK5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:57:16 -0500
Received: from fcoe-test9.blr.asicdesigners.com (fcoe-test9.blr.asicdesigners.com [10.193.185.176])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBAAv8x8001528;
        Tue, 10 Dec 2019 02:57:09 -0800
From:   Shahjada Abul Husain <shahjada@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com, Shahjada Abul Husain <shahjada@chelsio.com>
Subject: [PATCH net-next] cxgb4: add support for high priority filters
Date:   Tue, 10 Dec 2019 16:25:33 +0530
Message-Id: <20191210105533.7868-1-shahjada@chelsio.com>
X-Mailer: git-send-email 2.23.0.256.g4c86140
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T6 has a separate region known as high priority filter region
that allows classifying packets going through ULD path. So,
query firmware for HPFILTER resources and enable the high
priority offload filter support when it is available.

Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  11 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   3 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 220 ++++++++++++------
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  53 +++--
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |   7 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |   2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c |  18 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   5 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |   1 +
 9 files changed, 234 insertions(+), 86 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index a70ac2097892..eda8e1269551 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -56,6 +56,7 @@
 #include <asm/io.h>
 #include "t4_chip_type.h"
 #include "cxgb4_uld.h"
+#include "t4fw_api.h"
 
 #define CH_WARN(adap, fmt, ...) dev_warn(adap->pdev_dev, fmt, ## __VA_ARGS__)
 extern struct list_head adapter_list;
@@ -68,6 +69,16 @@ extern struct mutex uld_mutex;
 #define ETHTXQ_STOP_THRES \
 	(1 + DIV_ROUND_UP((3 * MAX_SKB_FRAGS) / 2 + (MAX_SKB_FRAGS & 1), 8))
 
+#define FW_PARAM_DEV(param) \
+	(FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) | \
+	 FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_##param))
+
+#define FW_PARAM_PFVF(param) \
+	(FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_PFVF) | \
+	 FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_PFVF_##param) |  \
+	 FW_PARAMS_PARAM_Y_V(0) | \
+	 FW_PARAMS_PARAM_Z_V(0))
+
 enum {
 	MAX_NPORTS	= 4,     /* max # of ports */
 	SERNUM_LEN	= 24,    /* Serial # length */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 93868dca186a..b6a79536e143 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3240,6 +3240,9 @@ static int tid_info_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "SFTID range: %u..%u in use: %u\n",
 			   t->sftid_base, t->sftid_base + t->nsftids - 2,
 			   t->sftids_in_use);
+	if (t->nhpftids)
+		seq_printf(seq, "HPFTID range: %u..%u\n", t->hpftid_base,
+			   t->hpftid_base + t->nhpftids - 1);
 	if (t->ntids)
 		seq_printf(seq, "HW TID usage: %u IP users, %u IPv6 users\n",
 			   t4_read_reg(adap, LE_DB_ACT_CNT_IPV4_A),
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 1d39fca11810..6a5b0346dad9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -507,6 +507,24 @@ static int cxgb4_set_ftid(struct tid_info *t, int fidx, int family,
 	return 0;
 }
 
+static int cxgb4_set_hpftid(struct tid_info *t, int fidx, int family)
+{
+	spin_lock_bh(&t->ftid_lock);
+
+	if (test_bit(fidx, t->hpftid_bmap)) {
+		spin_unlock_bh(&t->ftid_lock);
+		return -EBUSY;
+	}
+
+	if (family == PF_INET)
+		__set_bit(fidx, t->hpftid_bmap);
+	else
+		bitmap_allocate_region(t->hpftid_bmap, fidx, 1);
+
+	spin_unlock_bh(&t->ftid_lock);
+	return 0;
+}
+
 static void cxgb4_clear_ftid(struct tid_info *t, int fidx, int family,
 			     unsigned int chip_ver)
 {
@@ -522,33 +540,58 @@ static void cxgb4_clear_ftid(struct tid_info *t, int fidx, int family,
 	spin_unlock_bh(&t->ftid_lock);
 }
 
+static void cxgb4_clear_hpftid(struct tid_info *t, int fidx, int family)
+{
+	spin_lock_bh(&t->ftid_lock);
+
+	if (family == PF_INET)
+		__clear_bit(fidx, t->hpftid_bmap);
+	else
+		bitmap_release_region(t->hpftid_bmap, fidx, 1);
+
+	spin_unlock_bh(&t->ftid_lock);
+}
+
 bool cxgb4_filter_prio_in_range(struct net_device *dev, u32 idx, u32 prio)
 {
+	struct filter_entry *prev_fe, *next_fe, *tab;
 	struct adapter *adap = netdev2adap(dev);
-	struct filter_entry *prev_fe, *next_fe;
+	u32 prev_ftid, next_ftid, max_tid;
 	struct tid_info *t = &adap->tids;
-	u32 prev_ftid, next_ftid;
+	unsigned long *bmap;
 	bool valid = true;
 
+	if (idx < t->nhpftids) {
+		bmap = t->hpftid_bmap;
+		tab = t->hpftid_tab;
+		max_tid = t->nhpftids;
+	} else {
+		idx -= t->nhpftids;
+		bmap = t->ftid_bmap;
+		tab = t->ftid_tab;
+		max_tid = t->nftids;
+	}
+
 	/* Only insert the rule if both of the following conditions
 	 * are met:
 	 * 1. The immediate previous rule has priority <= @prio.
 	 * 2. The immediate next rule has priority >= @prio.
 	 */
 	spin_lock_bh(&t->ftid_lock);
+
 	/* Don't insert if there's a rule already present at @idx. */
-	if (test_bit(idx, t->ftid_bmap)) {
+	if (test_bit(idx, bmap)) {
 		valid = false;
 		goto out_unlock;
 	}
 
-	next_ftid = find_next_bit(t->ftid_bmap, t->nftids, idx);
-	if (next_ftid >= t->nftids)
+	next_ftid = find_next_bit(bmap, max_tid, idx);
+	if (next_ftid >= max_tid)
 		next_ftid = idx;
 
-	next_fe = &adap->tids.ftid_tab[next_ftid];
+	next_fe = &tab[next_ftid];
 
-	prev_ftid = find_last_bit(t->ftid_bmap, idx);
+	prev_ftid = find_last_bit(bmap, idx);
 	if (prev_ftid >= idx)
 		prev_ftid = idx;
 
@@ -558,13 +601,13 @@ bool cxgb4_filter_prio_in_range(struct net_device *dev, u32 idx, u32 prio)
 	 * accordingly.
 	 */
 	if (CHELSIO_CHIP_VERSION(adap->params.chip) < CHELSIO_T6) {
-		prev_fe = &adap->tids.ftid_tab[prev_ftid & ~0x3];
+		prev_fe = &tab[prev_ftid & ~0x3];
 		if (!prev_fe->fs.type)
-			prev_fe = &adap->tids.ftid_tab[prev_ftid];
+			prev_fe = &tab[prev_ftid];
 	} else {
-		prev_fe = &adap->tids.ftid_tab[prev_ftid & ~0x1];
+		prev_fe = &tab[prev_ftid & ~0x1];
 		if (!prev_fe->fs.type)
-			prev_fe = &adap->tids.ftid_tab[prev_ftid];
+			prev_fe = &tab[prev_ftid];
 	}
 
 	if ((prev_fe->valid && prio < prev_fe->fs.tc_prio) ||
@@ -579,11 +622,16 @@ bool cxgb4_filter_prio_in_range(struct net_device *dev, u32 idx, u32 prio)
 /* Delete the filter at a specified index. */
 static int del_filter_wr(struct adapter *adapter, int fidx)
 {
-	struct filter_entry *f = &adapter->tids.ftid_tab[fidx];
 	struct fw_filter_wr *fwr;
+	struct filter_entry *f;
 	struct sk_buff *skb;
 	unsigned int len;
 
+	if (fidx < adapter->tids.nhpftids)
+		f = &adapter->tids.hpftid_tab[fidx];
+	else
+		f = &adapter->tids.ftid_tab[fidx - adapter->tids.nhpftids];
+
 	len = sizeof(*fwr);
 
 	skb = alloc_skb(len, GFP_KERNEL);
@@ -609,10 +657,15 @@ static int del_filter_wr(struct adapter *adapter, int fidx)
  */
 int set_filter_wr(struct adapter *adapter, int fidx)
 {
-	struct filter_entry *f = &adapter->tids.ftid_tab[fidx];
 	struct fw_filter2_wr *fwr;
+	struct filter_entry *f;
 	struct sk_buff *skb;
 
+	if (fidx < adapter->tids.nhpftids)
+		f = &adapter->tids.hpftid_tab[fidx];
+	else
+		f = &adapter->tids.ftid_tab[fidx - adapter->tids.nhpftids];
+
 	skb = alloc_skb(sizeof(*fwr), GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
@@ -811,12 +864,22 @@ void clear_all_filters(struct adapter *adapter)
 	struct net_device *dev = adapter->port[0];
 	unsigned int i;
 
+	if (adapter->tids.hpftid_tab) {
+		struct filter_entry *f = &adapter->tids.hpftid_tab[0];
+
+		for (i = 0; i < adapter->tids.nhpftids; i++, f++)
+			if (f->valid || f->pending)
+				cxgb4_del_filter(dev, i, &f->fs);
+	}
+
 	if (adapter->tids.ftid_tab) {
 		struct filter_entry *f = &adapter->tids.ftid_tab[0];
 		unsigned int max_ftid = adapter->tids.nftids +
-					adapter->tids.nsftids;
+					adapter->tids.nsftids +
+					adapter->tids.nhpftids;
+
 		/* Clear all TCAM filters */
-		for (i = 0; i < max_ftid; i++, f++)
+		for (i = adapter->tids.nhpftids; i < max_ftid; i++, f++)
 			if (f->valid || f->pending)
 				cxgb4_del_filter(dev, i, &f->fs);
 	}
@@ -1319,17 +1382,17 @@ static int cxgb4_set_hash_filter(struct net_device *dev,
  * filter specification in order to facilitate signaling completion of the
  * operation.
  */
-int __cxgb4_set_filter(struct net_device *dev, int filter_id,
+int __cxgb4_set_filter(struct net_device *dev, int ftid,
 		       struct ch_filter_specification *fs,
 		       struct filter_ctx *ctx)
 {
 	struct adapter *adapter = netdev2adap(dev);
-	unsigned int chip_ver = CHELSIO_CHIP_VERSION(adapter->params.chip);
-	unsigned int max_fidx, fidx;
-	struct filter_entry *f;
+	unsigned int max_fidx, fidx, chip_ver;
+	int iq, ret, filter_id = ftid;
+	struct filter_entry *f, *tab;
 	u32 iconf;
-	int iq, ret;
 
+	chip_ver = CHELSIO_CHIP_VERSION(adapter->params.chip);
 	if (fs->hash) {
 		if (is_hashfilter(adapter))
 			return cxgb4_set_hash_filter(dev, fs, ctx);
@@ -1338,7 +1401,7 @@ int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 		return -EINVAL;
 	}
 
-	max_fidx = adapter->tids.nftids;
+	max_fidx = adapter->tids.nftids + adapter->tids.nhpftids;
 	if (filter_id != (max_fidx + adapter->tids.nsftids - 1) &&
 	    filter_id >= max_fidx)
 		return -E2BIG;
@@ -1353,6 +1416,13 @@ int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 	if (iq < 0)
 		return iq;
 
+	if (fs->prio) {
+		tab = &adapter->tids.hpftid_tab[0];
+	} else {
+		tab = &adapter->tids.ftid_tab[0];
+		filter_id = ftid - adapter->tids.nhpftids;
+	}
+
 	/* IPv6 filters occupy four slots and must be aligned on
 	 * four-slot boundaries.  IPv4 filters only occupy a single
 	 * slot and have no alignment requirements but writing a new
@@ -1373,9 +1443,8 @@ int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 		else
 			fidx = filter_id & ~0x1;
 
-		if (fidx != filter_id &&
-		    adapter->tids.ftid_tab[fidx].fs.type) {
-			f = &adapter->tids.ftid_tab[fidx];
+		if (fidx != filter_id && tab[fidx].fs.type) {
+			f = &tab[fidx];
 			if (f->valid) {
 				dev_err(adapter->pdev_dev,
 					"Invalid location. IPv6 requires 4 slots and is occupying slots %u to %u\n",
@@ -1399,7 +1468,7 @@ int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 			 */
 			for (fidx = filter_id + 1; fidx < filter_id + 4;
 			     fidx++) {
-				f = &adapter->tids.ftid_tab[fidx];
+				f = &tab[fidx];
 				if (f->valid) {
 					dev_err(adapter->pdev_dev,
 						"Invalid location.  IPv6 requires 4 slots and an IPv4 filter exists at %u\n",
@@ -1415,7 +1484,7 @@ int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 				return -EINVAL;
 			/* Check overlapping IPv4 filter slot */
 			fidx = filter_id + 1;
-			f = &adapter->tids.ftid_tab[fidx];
+			f = &tab[fidx];
 			if (f->valid) {
 				pr_err("%s: IPv6 filter requires 2 indices. IPv4 filter already present at %d. Please remove IPv4 filter first.\n",
 				       __func__, fidx);
@@ -1427,36 +1496,35 @@ int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 	/* Check to make sure that provided filter index is not
 	 * already in use by someone else
 	 */
-	f = &adapter->tids.ftid_tab[filter_id];
+	f = &tab[filter_id];
 	if (f->valid)
 		return -EBUSY;
 
-	fidx = filter_id + adapter->tids.ftid_base;
-	ret = cxgb4_set_ftid(&adapter->tids, filter_id,
-			     fs->type ? PF_INET6 : PF_INET,
-			     chip_ver);
+	if (fs->prio) {
+		fidx = filter_id + adapter->tids.hpftid_base;
+		ret = cxgb4_set_hpftid(&adapter->tids, filter_id,
+				       fs->type ? PF_INET6 : PF_INET);
+	} else {
+		fidx = filter_id + adapter->tids.ftid_base;
+		ret = cxgb4_set_ftid(&adapter->tids, filter_id,
+				     fs->type ? PF_INET6 : PF_INET,
+				     chip_ver);
+	}
+
 	if (ret)
 		return ret;
 
 	/* Check t  make sure the filter requested is writable ... */
 	ret = writable_filter(f);
-	if (ret) {
-		/* Clear the bits we have set above */
-		cxgb4_clear_ftid(&adapter->tids, filter_id,
-				 fs->type ? PF_INET6 : PF_INET,
-				 chip_ver);
-		return ret;
-	}
+	if (ret)
+		goto free_tid;
 
 	if (is_t6(adapter->params.chip) && fs->type &&
 	    ipv6_addr_type((const struct in6_addr *)fs->val.lip) !=
 	    IPV6_ADDR_ANY) {
 		ret = cxgb4_clip_get(dev, (const u32 *)&fs->val.lip, 1);
-		if (ret) {
-			cxgb4_clear_ftid(&adapter->tids, filter_id, PF_INET6,
-					 chip_ver);
-			return ret;
-		}
+		if (ret)
+			goto free_tid;
 	}
 
 	/* Convert the filter specification into our internal format.
@@ -1487,7 +1555,7 @@ int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 						      f->fs.mask.vni,
 						      0, 1, 1);
 			if (ret < 0)
-				goto free_clip;
+				goto free_tid;
 
 			f->fs.val.ovlan = ret;
 			f->fs.mask.ovlan = 0x1ff;
@@ -1501,21 +1569,22 @@ int __cxgb4_set_filter(struct net_device *dev, int filter_id,
 	 */
 	f->ctx = ctx;
 	f->tid = fidx; /* Save the actual tid */
-	ret = set_filter_wr(adapter, filter_id);
-	if (ret) {
+	ret = set_filter_wr(adapter, ftid);
+	if (ret)
+		goto free_tid;
+
+	return ret;
+
+free_tid:
+	if (f->fs.prio)
+		cxgb4_clear_hpftid(&adapter->tids, filter_id,
+				   fs->type ? PF_INET6 : PF_INET);
+	else
 		cxgb4_clear_ftid(&adapter->tids, filter_id,
 				 fs->type ? PF_INET6 : PF_INET,
 				 chip_ver);
-		clear_filter(adapter, f);
-	}
 
-	return ret;
-
-free_clip:
-	if (is_t6(adapter->params.chip) && f->fs.type)
-		cxgb4_clip_release(f->dev, (const u32 *)&f->fs.val.lip, 1);
-	cxgb4_clear_ftid(&adapter->tids, filter_id,
-			 fs->type ? PF_INET6 : PF_INET, chip_ver);
+	clear_filter(adapter, f);
 	return ret;
 }
 
@@ -1590,11 +1659,11 @@ int __cxgb4_del_filter(struct net_device *dev, int filter_id,
 		       struct filter_ctx *ctx)
 {
 	struct adapter *adapter = netdev2adap(dev);
-	unsigned int chip_ver = CHELSIO_CHIP_VERSION(adapter->params.chip);
+	unsigned int max_fidx, chip_ver;
 	struct filter_entry *f;
-	unsigned int max_fidx;
 	int ret;
 
+	chip_ver = CHELSIO_CHIP_VERSION(adapter->params.chip);
 	if (fs && fs->hash) {
 		if (is_hashfilter(adapter))
 			return cxgb4_del_hash_filter(dev, filter_id, ctx);
@@ -1603,21 +1672,31 @@ int __cxgb4_del_filter(struct net_device *dev, int filter_id,
 		return -EINVAL;
 	}
 
-	max_fidx = adapter->tids.nftids;
+	max_fidx = adapter->tids.nftids + adapter->tids.nhpftids;
 	if (filter_id != (max_fidx + adapter->tids.nsftids - 1) &&
 	    filter_id >= max_fidx)
 		return -E2BIG;
 
-	f = &adapter->tids.ftid_tab[filter_id];
+	if (filter_id < adapter->tids.nhpftids)
+		f = &adapter->tids.hpftid_tab[filter_id];
+	else
+		f = &adapter->tids.ftid_tab[filter_id - adapter->tids.nhpftids];
+
 	ret = writable_filter(f);
 	if (ret)
 		return ret;
 
 	if (f->valid) {
 		f->ctx = ctx;
-		cxgb4_clear_ftid(&adapter->tids, filter_id,
-				 f->fs.type ? PF_INET6 : PF_INET,
-				 chip_ver);
+		if (f->fs.prio)
+			cxgb4_clear_hpftid(&adapter->tids,
+					   f->tid - adapter->tids.hpftid_base,
+					   f->fs.type ? PF_INET6 : PF_INET);
+		else
+			cxgb4_clear_ftid(&adapter->tids,
+					 f->tid - adapter->tids.ftid_base,
+					 f->fs.type ? PF_INET6 : PF_INET,
+					 chip_ver);
 		return del_filter_wr(adapter, filter_id);
 	}
 
@@ -1842,11 +1921,18 @@ void filter_rpl(struct adapter *adap, const struct cpl_set_tcb_rpl *rpl)
 	max_fidx = adap->tids.nftids + adap->tids.nsftids;
 	/* Get the corresponding filter entry for this tid */
 	if (adap->tids.ftid_tab) {
-		/* Check this in normal filter region */
-		idx = tid - adap->tids.ftid_base;
-		if (idx >= max_fidx)
-			return;
-		f = &adap->tids.ftid_tab[idx];
+		idx = tid - adap->tids.hpftid_base;
+		if (idx < adap->tids.nhpftids) {
+			f = &adap->tids.hpftid_tab[idx];
+		} else {
+			/* Check this in normal filter region */
+			idx = tid - adap->tids.ftid_base;
+			if (idx >= max_fidx)
+				return;
+			f = &adap->tids.ftid_tab[idx];
+			idx += adap->tids.nhpftids;
+		}
+
 		if (f->tid != tid)
 			return;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 12ff69b3ba91..be750f2de23c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -804,6 +804,26 @@ static int setup_ppod_edram(struct adapter *adap)
 	return 0;
 }
 
+static void adap_config_hpfilter(struct adapter *adapter)
+{
+	u32 param, val = 0;
+	int ret;
+
+	/* Enable HP filter region. Older fw will fail this request and
+	 * it is fine.
+	 */
+	param = FW_PARAM_DEV(HPFILTER_REGION_SUPPORT);
+	ret = t4_set_params(adapter, adapter->mbox, adapter->pf, 0,
+			    1, &param, &val);
+
+	/* An error means FW doesn't know about HP filter support,
+	 * it's not a problem, don't return an error.
+	 */
+	if (ret < 0)
+		dev_err(adapter->pdev_dev,
+			"HP filter region isn't supported by FW\n");
+}
+
 /**
  *	cxgb4_write_rss - write the RSS table for a given port
  *	@pi: the port
@@ -1518,6 +1538,7 @@ static int tid_init(struct tid_info *t)
 	struct adapter *adap = container_of(t, struct adapter, tids);
 	unsigned int max_ftids = t->nftids + t->nsftids;
 	unsigned int natids = t->natids;
+	unsigned int hpftid_bmap_size;
 	unsigned int eotid_bmap_size;
 	unsigned int stid_bmap_size;
 	unsigned int ftid_bmap_size;
@@ -1525,12 +1546,15 @@ static int tid_init(struct tid_info *t)
 
 	stid_bmap_size = BITS_TO_LONGS(t->nstids + t->nsftids);
 	ftid_bmap_size = BITS_TO_LONGS(t->nftids);
+	hpftid_bmap_size = BITS_TO_LONGS(t->nhpftids);
 	eotid_bmap_size = BITS_TO_LONGS(t->neotids);
 	size = t->ntids * sizeof(*t->tid_tab) +
 	       natids * sizeof(*t->atid_tab) +
 	       t->nstids * sizeof(*t->stid_tab) +
 	       t->nsftids * sizeof(*t->stid_tab) +
 	       stid_bmap_size * sizeof(long) +
+	       t->nhpftids * sizeof(*t->hpftid_tab) +
+	       hpftid_bmap_size * sizeof(long) +
 	       max_ftids * sizeof(*t->ftid_tab) +
 	       ftid_bmap_size * sizeof(long) +
 	       t->neotids * sizeof(*t->eotid_tab) +
@@ -1543,7 +1567,9 @@ static int tid_init(struct tid_info *t)
 	t->atid_tab = (union aopen_entry *)&t->tid_tab[t->ntids];
 	t->stid_tab = (struct serv_entry *)&t->atid_tab[natids];
 	t->stid_bmap = (unsigned long *)&t->stid_tab[t->nstids + t->nsftids];
-	t->ftid_tab = (struct filter_entry *)&t->stid_bmap[stid_bmap_size];
+	t->hpftid_tab = (struct filter_entry *)&t->stid_bmap[stid_bmap_size];
+	t->hpftid_bmap = (unsigned long *)&t->hpftid_tab[t->nhpftids];
+	t->ftid_tab = (struct filter_entry *)&t->hpftid_bmap[hpftid_bmap_size];
 	t->ftid_bmap = (unsigned long *)&t->ftid_tab[max_ftids];
 	t->eotid_tab = (struct eotid_entry *)&t->ftid_bmap[ftid_bmap_size];
 	t->eotid_bmap = (unsigned long *)&t->eotid_tab[t->neotids];
@@ -1578,6 +1604,8 @@ static int tid_init(struct tid_info *t)
 			bitmap_zero(t->eotid_bmap, t->neotids);
 	}
 
+	if (t->nhpftids)
+		bitmap_zero(t->hpftid_bmap, t->nhpftids);
 	bitmap_zero(t->ftid_bmap, t->nftids);
 	return 0;
 }
@@ -4351,6 +4379,7 @@ static int adap_init0_config(struct adapter *adapter, int reset)
 			"HMA configuration failed with error %d\n", ret);
 
 	if (is_t6(adapter->params.chip)) {
+		adap_config_hpfilter(adapter);
 		ret = setup_ppod_edram(adapter);
 		if (!ret)
 			dev_info(adapter->pdev_dev, "Successfully enabled "
@@ -4660,16 +4689,6 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 	/*
 	 * Grab some of our basic fundamental operating parameters.
 	 */
-#define FW_PARAM_DEV(param) \
-	(FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) | \
-	FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_##param))
-
-#define FW_PARAM_PFVF(param) \
-	FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_PFVF) | \
-	FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_PFVF_##param)|  \
-	FW_PARAMS_PARAM_Y_V(0) | \
-	FW_PARAMS_PARAM_Z_V(0)
-
 	params[0] = FW_PARAM_PFVF(EQ_START);
 	params[1] = FW_PARAM_PFVF(L2T_START);
 	params[2] = FW_PARAM_PFVF(L2T_END);
@@ -4687,6 +4706,16 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 	adap->sge.ingr_start = val[5];
 
 	if (CHELSIO_CHIP_VERSION(adap->params.chip) > CHELSIO_T5) {
+		params[0] = FW_PARAM_PFVF(HPFILTER_START);
+		params[1] = FW_PARAM_PFVF(HPFILTER_END);
+		ret = t4_query_params(adap, adap->mbox, adap->pf, 0, 2,
+				      params, val);
+		if (ret < 0)
+			goto bye;
+
+		adap->tids.hpftid_base = val[0];
+		adap->tids.nhpftids = val[1] - val[0] + 1;
+
 		/* Read the raw mps entries. In T6, the last 2 tcam entries
 		 * are reserved for raw mac addresses (rawf = 2, one per port).
 		 */
@@ -5050,8 +5079,6 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 		}
 		adap->params.crypto = ntohs(caps_cmd.cryptocaps);
 	}
-#undef FW_PARAM_PFVF
-#undef FW_PARAM_DEV
 
 	/* The MTU/MSS Table is initialized by now, so load their values.  If
 	 * we're initializing the adapter, then we'll make any modifications
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 0fa80bef575d..706b71e1b6c1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -672,10 +672,13 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 		 * 0 to driver. However, the hardware TCAM index
 		 * starts from 0. Hence, the -1 here.
 		 */
-		if (cls->common.prio <= adap->tids.nftids)
+		if (cls->common.prio <= adap->tids.nftids) {
 			fidx = cls->common.prio - 1;
-		else
+			if (fidx < adap->tids.nhpftids)
+				fs->prio = 1;
+		} else {
 			fidx = cxgb4_get_free_ftid(dev, inet_family);
+		}
 
 		/* Only insert FLOWER rule if its priority doesn't
 		 * conflict with existing rules in the LETCAM.
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 102b370fbd3e..53e8db8b2546 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -156,6 +156,8 @@ static int cxgb4_matchall_alloc_filter(struct net_device *dev,
 	fs = &tc_port_matchall->ingress.fs;
 	memset(fs, 0, sizeof(*fs));
 
+	if (fidx < adap->tids.nhpftids)
+		fs->prio = 1;
 	fs->tc_prio = cls->common.prio;
 	fs->tc_cookie = cls->cookie;
 	fs->hitcnts = 1;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
index 133f8623ba86..269b8d9e25e0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c
@@ -176,7 +176,7 @@ int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 	/* Only insert U32 rule if its priority doesn't conflict with
 	 * existing rules in the LETCAM.
 	 */
-	if (filter_id >= adapter->tids.nftids ||
+	if (filter_id >= adapter->tids.nftids + adapter->tids.nhpftids ||
 	    !cxgb4_filter_prio_in_range(dev, filter_id, cls->common.prio)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "No free LETCAM index available");
@@ -199,6 +199,8 @@ int cxgb4_config_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 
 	memset(&fs, 0, sizeof(fs));
 
+	if (filter_id < adapter->tids.nhpftids)
+		fs.prio = 1;
 	fs.tc_prio = cls->common.prio;
 	fs.tc_cookie = cls->knode.handle;
 
@@ -355,6 +357,7 @@ int cxgb4_delete_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 	unsigned int filter_id, max_tids, i, j;
 	struct cxgb4_link *link = NULL;
 	struct cxgb4_tc_u32_table *t;
+	struct filter_entry *f;
 	u32 handle, uhtid;
 	int ret;
 
@@ -363,8 +366,15 @@ int cxgb4_delete_knode(struct net_device *dev, struct tc_cls_u32_offload *cls)
 
 	/* Fetch the location to delete the filter. */
 	filter_id = TC_U32_NODE(cls->knode.handle) - 1;
-	if (filter_id >= adapter->tids.nftids ||
-	    cls->knode.handle != adapter->tids.ftid_tab[filter_id].fs.tc_cookie)
+	if (filter_id >= adapter->tids.nftids + adapter->tids.nhpftids)
+		return -ERANGE;
+
+	if (filter_id < adapter->tids.nhpftids)
+		f = &adapter->tids.hpftid_tab[filter_id];
+	else
+		f = &adapter->tids.ftid_tab[filter_id - adapter->tids.nhpftids];
+
+	if (cls->knode.handle != f->fs.tc_cookie)
 		return -ERANGE;
 
 	t = adapter->tc_u32;
@@ -445,7 +455,7 @@ void cxgb4_cleanup_tc_u32(struct adapter *adap)
 
 struct cxgb4_tc_u32_table *cxgb4_init_tc_u32(struct adapter *adap)
 {
-	unsigned int max_tids = adap->tids.nftids;
+	unsigned int max_tids = adap->tids.nftids + adap->tids.nhpftids;
 	struct cxgb4_tc_u32_table *t;
 	unsigned int i;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 861b25d28ed6..e69de9a296ae 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -111,6 +111,11 @@ struct tid_info {
 	unsigned int natids;
 	unsigned int atid_base;
 
+	struct filter_entry *hpftid_tab;
+	unsigned long *hpftid_bmap;
+	unsigned int nhpftids;
+	unsigned int hpftid_base;
+
 	struct filter_entry *ftid_tab;
 	unsigned long *ftid_bmap;
 	unsigned int nftids;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index ac4fb43bdec6..accad1101ad1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -1321,6 +1321,7 @@ enum fw_params_param_dev {
 	FW_PARAMS_PARAM_DEV_RDMA_WRITE_WITH_IMM = 0x21,
 	FW_PARAMS_PARAM_DEV_PPOD_EDRAM  = 0x23,
 	FW_PARAMS_PARAM_DEV_RI_WRITE_CMPL_WR    = 0x24,
+	FW_PARAMS_PARAM_DEV_HPFILTER_REGION_SUPPORT = 0x26,
 	FW_PARAMS_PARAM_DEV_OPAQUE_VIID_SMT_EXTN = 0x27,
 	FW_PARAMS_PARAM_DEV_HASHFILTER_WITH_OFLD = 0x28,
 	FW_PARAMS_PARAM_DEV_DBQ_TIMER	= 0x29,
-- 
2.23.0.256.g4c86140

