Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AD81D57A5
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEORXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:23:35 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:54306 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgEORXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:23:34 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04FHNV25028042;
        Fri, 15 May 2020 10:23:31 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 3/3] cxgb4: add EOTID tracking and software context dump
Date:   Fri, 15 May 2020 22:41:05 +0530
Message-Id: <07410b9462457cbd39ca276411d6b63525779ba4.1589562017.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
References: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
References: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rework and add support for dumping EOTID software context used by
TC-MQPRIO. Also track number of EOTIDs in use.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 144 ++++++++++++++----
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   1 +
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |  10 ++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |   1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   5 +
 5 files changed, 133 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index ebed99f3d4cf..7818c392da50 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -49,6 +49,7 @@
 #include "cudbg_lib_common.h"
 #include "cudbg_entity.h"
 #include "cudbg_lib.h"
+#include "cxgb4_tc_mqprio.h"
 
 /* generic seq_file support for showing a table of size rows x width. */
 static void *seq_tab_get_idx(struct seq_tab *tb, loff_t pos)
@@ -2657,32 +2658,19 @@ static int sge_qinfo_uld_ciq_entries(const struct adapter *adap, int uld)
 
 static int sge_qinfo_show(struct seq_file *seq, void *v)
 {
-	int eth_entries, ctrl_entries, eo_entries = 0;
+	int eth_entries, ctrl_entries, eohw_entries = 0, eosw_entries = 0;
 	int uld_rxq_entries[CXGB4_ULD_MAX] = { 0 };
 	int uld_ciq_entries[CXGB4_ULD_MAX] = { 0 };
 	int uld_txq_entries[CXGB4_TX_MAX] = { 0 };
 	const struct sge_uld_txq_info *utxq_info;
 	const struct sge_uld_rxq_info *urxq_info;
+	struct cxgb4_tc_port_mqprio *port_mqprio;
 	struct adapter *adap = seq->private;
-	int i, n, r = (uintptr_t)v - 1;
+	int i, j, n, r = (uintptr_t)v - 1;
 	struct sge *s = &adap->sge;
 
 	eth_entries = DIV_ROUND_UP(adap->sge.ethqsets, 4);
 	ctrl_entries = DIV_ROUND_UP(MAX_CTRL_QUEUES, 4);
-	if (adap->sge.eohw_txq)
-		eo_entries = DIV_ROUND_UP(adap->sge.eoqsets, 4);
-
-	mutex_lock(&uld_mutex);
-	if (s->uld_txq_info)
-		for (i = 0; i < ARRAY_SIZE(uld_txq_entries); i++)
-			uld_txq_entries[i] = sge_qinfo_uld_txq_entries(adap, i);
-
-	if (s->uld_rxq_info) {
-		for (i = 0; i < ARRAY_SIZE(uld_rxq_entries); i++) {
-			uld_rxq_entries[i] = sge_qinfo_uld_rxq_entries(adap, i);
-			uld_ciq_entries[i] = sge_qinfo_uld_ciq_entries(adap, i);
-		}
-	}
 
 	if (r)
 		seq_putc(seq, '\n');
@@ -2759,11 +2747,21 @@ do { \
 		RL("FLLow:", fl.low);
 		RL("FLStarving:", fl.starving);
 
-		goto unlock;
+		goto out;
 	}
 
 	r -= eth_entries;
-	if (r < eo_entries) {
+	if (!adap->tc_mqprio)
+		goto skip_mqprio;
+
+	mutex_lock(&adap->tc_mqprio->mqprio_mutex);
+	if (!refcount_read(&adap->tc_mqprio->refcnt)) {
+		mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
+		goto skip_mqprio;
+	}
+
+	eohw_entries = DIV_ROUND_UP(adap->sge.eoqsets, 4);
+	if (r < eohw_entries) {
 		int base_qset = r * 4;
 		const struct sge_ofld_rxq *rx = &s->eohw_rxq[base_qset];
 		const struct sge_eohw_txq *tx = &s->eohw_txq[base_qset];
@@ -2808,10 +2806,71 @@ do { \
 		RL("FLLow:", fl.low);
 		RL("FLStarving:", fl.starving);
 
-		goto unlock;
+		mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
+		goto out;
+	}
+
+	r -= eohw_entries;
+	for (j = 0; j < adap->params.nports; j++) {
+		int entries;
+		u8 tc;
+
+		port_mqprio = &adap->tc_mqprio->port_mqprio[j];
+		entries = 0;
+		for (tc = 0; tc < port_mqprio->mqprio.qopt.num_tc; tc++)
+			entries += port_mqprio->mqprio.qopt.count[tc];
+
+		if (!entries)
+			continue;
+
+		eosw_entries = DIV_ROUND_UP(entries, 4);
+		if (r < eosw_entries) {
+			const struct sge_eosw_txq *tx;
+
+			n = min(4, entries - 4 * r);
+			tx = &port_mqprio->eosw_txq[4 * r];
+
+			S("QType:", "EOSW-TXQ");
+			S("Interface:",
+			  adap->port[j] ? adap->port[j]->name : "N/A");
+			T("EOTID:", hwtid);
+			T("HWQID:", hwqid);
+			T("State:", state);
+			T("Size:", ndesc);
+			T("In-Use:", inuse);
+			T("Credits:", cred);
+			T("Compl:", ncompl);
+			T("Last-Compl:", last_compl);
+			T("PIDX:", pidx);
+			T("Last-PIDX:", last_pidx);
+			T("CIDX:", cidx);
+			T("Last-CIDX:", last_cidx);
+			T("FLOWC-IDX:", flowc_idx);
+
+			mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
+			goto out;
+		}
+
+		r -= eosw_entries;
+	}
+	mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
+
+skip_mqprio:
+	if (!is_uld(adap))
+		goto skip_uld;
+
+	mutex_lock(&uld_mutex);
+	if (s->uld_txq_info)
+		for (i = 0; i < ARRAY_SIZE(uld_txq_entries); i++)
+			uld_txq_entries[i] = sge_qinfo_uld_txq_entries(adap, i);
+
+	if (s->uld_rxq_info) {
+		for (i = 0; i < ARRAY_SIZE(uld_rxq_entries); i++) {
+			uld_rxq_entries[i] = sge_qinfo_uld_rxq_entries(adap, i);
+			uld_ciq_entries[i] = sge_qinfo_uld_ciq_entries(adap, i);
+		}
 	}
 
-	r -= eo_entries;
 	if (r < uld_txq_entries[CXGB4_TX_OFLD]) {
 		const struct sge_uld_txq *tx;
 
@@ -2994,6 +3053,9 @@ do { \
 	}
 
 	r -= uld_txq_entries[CXGB4_TX_CRYPTO];
+	mutex_unlock(&uld_mutex);
+
+skip_uld:
 	if (r < ctrl_entries) {
 		const struct sge_ctrl_txq *tx = &s->ctrlq[r * 4];
 
@@ -3008,7 +3070,7 @@ do { \
 		TL("TxQFull:", q.stops);
 		TL("TxQRestarts:", q.restarts);
 
-		goto unlock;
+		goto out;
 	}
 
 	r -= ctrl_entries;
@@ -3026,11 +3088,9 @@ do { \
 		seq_printf(seq, "%-12s %16u\n", "Intr pktcnt:",
 			   s->counter_val[evtq->pktcnt_idx]);
 
-		goto unlock;
+		goto out;
 	}
 
-unlock:
-	mutex_unlock(&uld_mutex);
 #undef R
 #undef RL
 #undef T
@@ -3039,13 +3099,38 @@ do { \
 #undef R3
 #undef T3
 #undef S3
+out:
+	return 0;
+
+unlock:
+	mutex_unlock(&uld_mutex);
 	return 0;
 }
 
 static int sge_queue_entries(const struct adapter *adap)
 {
-	int tot_uld_entries = 0;
-	int i;
+	int i, tot_uld_entries = 0, eohw_entries = 0, eosw_entries = 0;
+
+	if (adap->tc_mqprio) {
+		struct cxgb4_tc_port_mqprio *port_mqprio;
+		u8 tc;
+
+		mutex_lock(&adap->tc_mqprio->mqprio_mutex);
+		if (adap->sge.eohw_txq)
+			eohw_entries = DIV_ROUND_UP(adap->sge.eoqsets, 4);
+
+		for (i = 0; i < adap->params.nports; i++) {
+			u32 entries = 0;
+
+			port_mqprio = &adap->tc_mqprio->port_mqprio[i];
+			for (tc = 0; tc < port_mqprio->mqprio.qopt.num_tc; tc++)
+				entries += port_mqprio->mqprio.qopt.count[tc];
+
+			if (entries)
+				eosw_entries += DIV_ROUND_UP(entries, 4);
+		}
+		mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
+	}
 
 	if (!is_uld(adap))
 		goto lld_only;
@@ -3062,8 +3147,7 @@ static int sge_queue_entries(const struct adapter *adap)
 
 lld_only:
 	return DIV_ROUND_UP(adap->sge.ethqsets, 4) +
-	       (adap->sge.eohw_txq ? DIV_ROUND_UP(adap->sge.eoqsets, 4) : 0) +
-	       tot_uld_entries +
+	       eohw_entries + eosw_entries + tot_uld_entries +
 	       DIV_ROUND_UP(MAX_CTRL_QUEUES, 4) + 1;
 }
 
@@ -3244,6 +3328,10 @@ static int tid_info_show(struct seq_file *seq, void *v)
 	if (t->nhpftids)
 		seq_printf(seq, "HPFTID range: %u..%u\n", t->hpftid_base,
 			   t->hpftid_base + t->nhpftids - 1);
+	if (t->neotids)
+		seq_printf(seq, "EOTID range: %u..%u, in use: %u\n",
+			   t->eotid_base, t->eotid_base + t->neotids - 1,
+			   atomic_read(&t->eotids_in_use));
 	if (t->ntids)
 		seq_printf(seq, "HW TID usage: %u IP users, %u IPv6 users\n",
 			   t4_read_reg(adap, LE_DB_ACT_CNT_IPV4_A),
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 196451f8006f..d05c2371d8c7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1579,6 +1579,7 @@ static int tid_init(struct tid_info *t)
 	atomic_set(&t->tids_in_use, 0);
 	atomic_set(&t->conns_in_use, 0);
 	atomic_set(&t->hash_tids_in_use, 0);
+	atomic_set(&t->eotids_in_use, 0);
 
 	/* Setup the free list for atid_tab and clear the stid bitmap. */
 	if (natids) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index 56079c9937db..ae7123a9de8e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -574,6 +574,7 @@ static void cxgb4_mqprio_disable_offload(struct net_device *dev)
 int cxgb4_setup_tc_mqprio(struct net_device *dev,
 			  struct tc_mqprio_qopt_offload *mqprio)
 {
+	struct adapter *adap = netdev2adap(dev);
 	bool needs_bring_up = false;
 	int ret;
 
@@ -581,6 +582,8 @@ int cxgb4_setup_tc_mqprio(struct net_device *dev,
 	if (ret)
 		return ret;
 
+	mutex_lock(&adap->tc_mqprio->mqprio_mutex);
+
 	/* To configure tc params, the current allocated EOTIDs must
 	 * be freed up. However, they can't be freed up if there's
 	 * traffic running on the interface. So, ensure interface is
@@ -616,6 +619,7 @@ int cxgb4_setup_tc_mqprio(struct net_device *dev,
 	if (needs_bring_up)
 		cxgb_open(dev);
 
+	mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
 	return ret;
 }
 
@@ -628,6 +632,7 @@ void cxgb4_mqprio_stop_offload(struct adapter *adap)
 	if (!adap->tc_mqprio || !adap->tc_mqprio->port_mqprio)
 		return;
 
+	mutex_lock(&adap->tc_mqprio->mqprio_mutex);
 	for_each_port(adap, i) {
 		dev = adap->port[i];
 		if (!dev)
@@ -639,6 +644,7 @@ void cxgb4_mqprio_stop_offload(struct adapter *adap)
 
 		cxgb4_mqprio_disable_offload(dev);
 	}
+	mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
 }
 
 int cxgb4_init_tc_mqprio(struct adapter *adap)
@@ -660,6 +666,8 @@ int cxgb4_init_tc_mqprio(struct adapter *adap)
 		goto out_free_mqprio;
 	}
 
+	mutex_init(&tc_mqprio->mqprio_mutex);
+
 	tc_mqprio->port_mqprio = tc_port_mqprio;
 	for (i = 0; i < adap->params.nports; i++) {
 		port_mqprio = &tc_mqprio->port_mqprio[i];
@@ -694,6 +702,7 @@ void cxgb4_cleanup_tc_mqprio(struct adapter *adap)
 	u8 i;
 
 	if (adap->tc_mqprio) {
+		mutex_lock(&adap->tc_mqprio->mqprio_mutex);
 		if (adap->tc_mqprio->port_mqprio) {
 			for (i = 0; i < adap->params.nports; i++) {
 				struct net_device *dev = adap->port[i];
@@ -705,6 +714,7 @@ void cxgb4_cleanup_tc_mqprio(struct adapter *adap)
 			}
 			kfree(adap->tc_mqprio->port_mqprio);
 		}
+		mutex_unlock(&adap->tc_mqprio->mqprio_mutex);
 		kfree(adap->tc_mqprio);
 	}
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
index ff8794132b22..be96f1dc0372 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
@@ -33,6 +33,7 @@ struct cxgb4_tc_port_mqprio {
 
 struct cxgb4_tc_mqprio {
 	refcount_t refcnt; /* Refcount for adapter-wide resources */
+	struct mutex mqprio_mutex; /* Lock for accessing MQPRIO info */
 	struct cxgb4_tc_port_mqprio *port_mqprio; /* Per port MQPRIO info */
 };
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index be831317520a..16796785eea3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -147,6 +147,9 @@ struct tid_info {
 	/* TIDs in the HASH */
 	atomic_t hash_tids_in_use;
 	atomic_t conns_in_use;
+	/* ETHOFLD TIDs used for rate limiting */
+	atomic_t eotids_in_use;
+
 	/* lock for setting/clearing filter bitmap */
 	spinlock_t ftid_lock;
 
@@ -221,12 +224,14 @@ static inline void cxgb4_alloc_eotid(struct tid_info *t, u32 eotid, void *data)
 {
 	set_bit(eotid, t->eotid_bmap);
 	t->eotid_tab[eotid].data = data;
+	atomic_inc(&t->eotids_in_use);
 }
 
 static inline void cxgb4_free_eotid(struct tid_info *t, u32 eotid)
 {
 	clear_bit(eotid, t->eotid_bmap);
 	t->eotid_tab[eotid].data = NULL;
+	atomic_dec(&t->eotids_in_use);
 }
 
 int cxgb4_alloc_atid(struct tid_info *t, void *data);
-- 
2.24.0

