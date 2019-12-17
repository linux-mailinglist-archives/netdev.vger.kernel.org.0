Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEE11224EB
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfLQGnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:43:12 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:14789 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfLQGnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:43:11 -0500
Received: from fcoe-test9.blr.asicdesigners.com (fcoe-test9.blr.asicdesigners.com [10.193.185.176])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBH6grft026325;
        Mon, 16 Dec 2019 22:43:05 -0800
From:   Shahjada Abul Husain <shahjada@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com, Shahjada Abul Husain <shahjada@chelsio.com>
Subject: [PATCH net-next 2/2] cxgb4/chtls: fix ULD connection failures due to wrong TID base
Date:   Tue, 17 Dec 2019 12:12:09 +0530
Message-Id: <20191217064209.8526-3-shahjada@chelsio.com>
X-Mailer: git-send-email 2.23.0.256.g4c86140
In-Reply-To: <20191217064209.8526-1-shahjada@chelsio.com>
References: <20191217064209.8526-1-shahjada@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the hardware TID index is assumed to start from index 0.
However, with the following changeset,

commit c21939998802 ("cxgb4: add support for high priority filters")

hardware TID index can start after the high priority region, which
has introduced a regression resulting in connection failures for
ULDs.

So, fix all related code to properly recalculate the TID start index
based on whether high priority filters are enabled or not.

Fixes: c21939998802 ("cxgb4: add support for high priority filters")
Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c       |  2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 22 +++++++++----------
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 12 +++++-----
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 13 ++++++-----
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  9 +++++++-
 5 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index aca75237bbcf..72e5b0f65a91 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1273,7 +1273,7 @@ static int chtls_pass_accept_req(struct chtls_dev *cdev, struct sk_buff *skb)
 	ctx = (struct listen_ctx *)data;
 	lsk = ctx->lsk;
 
-	if (unlikely(tid >= cdev->tids->ntids)) {
+	if (unlikely(tid_out_of_range(cdev->tids, tid))) {
 		pr_info("passive open TID %u too large\n", tid);
 		return 1;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index b6a79536e143..9a96b01dad56 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3171,14 +3171,12 @@ static const struct file_operations mem_debugfs_fops = {
 
 static int tid_info_show(struct seq_file *seq, void *v)
 {
-	unsigned int tid_start = 0;
 	struct adapter *adap = seq->private;
-	const struct tid_info *t = &adap->tids;
-	enum chip_type chip = CHELSIO_CHIP_VERSION(adap->params.chip);
-
-	if (chip > CHELSIO_T5)
-		tid_start = t4_read_reg(adap, LE_DB_ACTIVE_TABLE_START_INDEX_A);
+	const struct tid_info *t;
+	enum chip_type chip;
 
+	t = &adap->tids;
+	chip = CHELSIO_CHIP_VERSION(adap->params.chip);
 	if (t4_read_reg(adap, LE_DB_CONFIG_A) & HASHEN_F) {
 		unsigned int sb;
 		seq_printf(seq, "Connections in use: %u\n",
@@ -3190,9 +3188,9 @@ static int tid_info_show(struct seq_file *seq, void *v)
 			sb = t4_read_reg(adap, LE_DB_SRVR_START_INDEX_A);
 
 		if (sb) {
-			seq_printf(seq, "TID range: %u..%u/%u..%u", tid_start,
+			seq_printf(seq, "TID range: %u..%u/%u..%u", t->tid_base,
 				   sb - 1, adap->tids.hash_base,
-				   t->ntids - 1);
+				   t->tid_base + t->ntids - 1);
 			seq_printf(seq, ", in use: %u/%u\n",
 				   atomic_read(&t->tids_in_use),
 				   atomic_read(&t->hash_tids_in_use));
@@ -3201,14 +3199,14 @@ static int tid_info_show(struct seq_file *seq, void *v)
 				   t->aftid_base,
 				   t->aftid_end,
 				   adap->tids.hash_base,
-				   t->ntids - 1);
+				   t->tid_base + t->ntids - 1);
 			seq_printf(seq, ", in use: %u/%u\n",
 				   atomic_read(&t->tids_in_use),
 				   atomic_read(&t->hash_tids_in_use));
 		} else {
 			seq_printf(seq, "TID range: %u..%u",
 				   adap->tids.hash_base,
-				   t->ntids - 1);
+				   t->tid_base + t->ntids - 1);
 			seq_printf(seq, ", in use: %u\n",
 				   atomic_read(&t->hash_tids_in_use));
 		}
@@ -3216,8 +3214,8 @@ static int tid_info_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "Connections in use: %u\n",
 			   atomic_read(&t->conns_in_use));
 
-		seq_printf(seq, "TID range: %u..%u", tid_start,
-			   tid_start + t->ntids - 1);
+		seq_printf(seq, "TID range: %u..%u", t->tid_base,
+			   t->tid_base + t->ntids - 1);
 		seq_printf(seq, ", in use: %u\n",
 			   atomic_read(&t->tids_in_use));
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 44deabfa32b5..2a2938bbb93a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -361,13 +361,11 @@ static int get_filter_count(struct adapter *adapter, unsigned int fidx,
 
 	tcb_base = t4_read_reg(adapter, TP_CMM_TCB_BASE_A);
 	if (is_hashfilter(adapter) && hash) {
-		if (fidx < adapter->tids.ntids) {
-			f = adapter->tids.tid_tab[fidx];
-			if (!f)
-				return -EINVAL;
-		} else {
+		if (tid_out_of_range(&adapter->tids, fidx))
 			return -E2BIG;
-		}
+		f = adapter->tids.tid_tab[fidx - adapter->tids.tid_base];
+		if (!f)
+			return -EINVAL;
 	} else {
 		if ((fidx != (adapter->tids.nftids + adapter->tids.nsftids +
 			      adapter->tids.nhpftids - 1)) &&
@@ -1615,7 +1613,7 @@ static int cxgb4_del_hash_filter(struct net_device *dev, int filter_id,
 	netdev_dbg(dev, "%s: filter_id = %d ; nftids = %d\n",
 		   __func__, filter_id, adapter->tids.nftids);
 
-	if (filter_id > adapter->tids.ntids)
+	if (tid_out_of_range(t, filter_id))
 		return -E2BIG;
 
 	f = lookup_tid(t, filter_id);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index be750f2de23c..1930e39f195e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1447,8 +1447,8 @@ static void mk_tid_release(struct sk_buff *skb, unsigned int chan,
 static void cxgb4_queue_tid_release(struct tid_info *t, unsigned int chan,
 				    unsigned int tid)
 {
-	void **p = &t->tid_tab[tid];
 	struct adapter *adap = container_of(t, struct adapter, tids);
+	void **p = &t->tid_tab[tid - t->tid_base];
 
 	spin_lock_bh(&adap->tid_release_lock);
 	*p = adap->tid_release_head;
@@ -1500,13 +1500,13 @@ static void process_tid_release_list(struct work_struct *work)
 void cxgb4_remove_tid(struct tid_info *t, unsigned int chan, unsigned int tid,
 		      unsigned short family)
 {
-	struct sk_buff *skb;
 	struct adapter *adap = container_of(t, struct adapter, tids);
+	struct sk_buff *skb;
 
-	WARN_ON(tid >= t->ntids);
+	WARN_ON(tid_out_of_range(&adap->tids, tid));
 
-	if (t->tid_tab[tid]) {
-		t->tid_tab[tid] = NULL;
+	if (t->tid_tab[tid - adap->tids.tid_base]) {
+		t->tid_tab[tid - adap->tids.tid_base] = NULL;
 		atomic_dec(&t->conns_in_use);
 		if (t->hash_base && (tid >= t->hash_base)) {
 			if (family == AF_INET6)
@@ -4727,6 +4727,9 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 			adap->rawf_start = val[0];
 			adap->rawf_cnt = val[1] - val[0] + 1;
 		}
+
+		adap->tids.tid_base =
+			t4_read_reg(adap, LE_DB_ACTIVE_TABLE_START_INDEX_A);
 	}
 
 	/* qids (ingress/egress) returned from firmware can be anywhere
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index e69de9a296ae..d9d27bc1ae67 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -99,6 +99,7 @@ struct eotid_entry {
  */
 struct tid_info {
 	void **tid_tab;
+	unsigned int tid_base;
 	unsigned int ntids;
 
 	struct serv_entry *stid_tab;
@@ -152,9 +153,15 @@ struct tid_info {
 
 static inline void *lookup_tid(const struct tid_info *t, unsigned int tid)
 {
+	tid -= t->tid_base;
 	return tid < t->ntids ? t->tid_tab[tid] : NULL;
 }
 
+static inline bool tid_out_of_range(const struct tid_info *t, unsigned int tid)
+{
+	return ((tid - t->tid_base) >= t->ntids);
+}
+
 static inline void *lookup_atid(const struct tid_info *t, unsigned int atid)
 {
 	return atid < t->natids ? t->atid_tab[atid].data : NULL;
@@ -176,7 +183,7 @@ static inline void *lookup_stid(const struct tid_info *t, unsigned int stid)
 static inline void cxgb4_insert_tid(struct tid_info *t, void *data,
 				    unsigned int tid, unsigned short family)
 {
-	t->tid_tab[tid] = data;
+	t->tid_tab[tid - t->tid_base] = data;
 	if (t->hash_base && (tid >= t->hash_base)) {
 		if (family == AF_INET6)
 			atomic_add(2, &t->hash_tids_in_use);
-- 
2.23.0.256.g4c86140

