Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4358F3423
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389036AbfKGQHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:07:38 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:38337 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKGQHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:07:38 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA7G7XpV024025;
        Thu, 7 Nov 2019 08:07:34 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 4/6] cxgb4: add ETHOFLD hardware queue support
Date:   Thu,  7 Nov 2019 21:29:07 +0530
Message-Id: <baefee56344a0fca3965a0344025e1140d7376e1.1573140612.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring and managing ETHOFLD hardware queues.
Keep the queue count and MSI-X allocation scheme same as NIC queues.
ETHOFLD hardware queues are dynamically allocated/destroyed as
TC-MQPRIO Qdisc offload is enabled/disabled on the corresponding
interface, respectively.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |   3 +
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    |  21 +++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  20 +++
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  53 +++++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  72 ++++++--
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  | 168 ++++++++++++++++++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |  10 ++
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    |  40 ++---
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  95 +++++++---
 9 files changed, 419 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
index 69746696a929..f5be3ee1bdb4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
@@ -325,6 +325,9 @@ enum cudbg_qdesc_qtype {
 	CUDBG_QTYPE_CRYPTO_FLQ,
 	CUDBG_QTYPE_TLS_RXQ,
 	CUDBG_QTYPE_TLS_FLQ,
+	CUDBG_QTYPE_ETHOFLD_TXQ,
+	CUDBG_QTYPE_ETHOFLD_RXQ,
+	CUDBG_QTYPE_ETHOFLD_FLQ,
 	CUDBG_QTYPE_MAX,
 };
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index c2e92786608b..c9d3dea4413e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -2930,6 +2930,10 @@ void cudbg_fill_qdesc_num_and_size(const struct adapter *padap,
 	tot_size += CXGB4_ULD_MAX * MAX_ULD_QSETS * SGE_MAX_IQ_SIZE *
 		    MAX_RXQ_DESC_SIZE;
 
+	/* ETHOFLD TXQ, RXQ, and FLQ */
+	tot_entries += MAX_OFLD_QSETS * 3;
+	tot_size += MAX_OFLD_QSETS * MAX_TXQ_ENTRIES * MAX_TXQ_DESC_SIZE;
+
 	tot_size += sizeof(struct cudbg_ver_hdr) +
 		    sizeof(struct cudbg_qdesc_info) +
 		    sizeof(struct cudbg_qdesc_entry) * tot_entries;
@@ -3087,6 +3091,23 @@ int cudbg_collect_qdesc(struct cudbg_init *pdbg_init,
 		}
 	}
 
+	/* ETHOFLD TXQ */
+	if (s->eohw_txq)
+		for (i = 0; i < s->eoqsets; i++)
+			QDESC_GET_TXQ(&s->eohw_txq[i].q,
+				      CUDBG_QTYPE_ETHOFLD_TXQ, out);
+
+	/* ETHOFLD RXQ and FLQ */
+	if (s->eohw_rxq) {
+		for (i = 0; i < s->eoqsets; i++)
+			QDESC_GET_RXQ(&s->eohw_rxq[i].rspq,
+				      CUDBG_QTYPE_ETHOFLD_RXQ, out);
+
+		for (i = 0; i < s->eoqsets; i++)
+			QDESC_GET_FLQ(&s->eohw_rxq[i].fl,
+				      CUDBG_QTYPE_ETHOFLD_FLQ, out);
+	}
+
 out_unlock:
 	mutex_unlock(&uld_mutex);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 04a81276e9c8..d9d92dc0d0c5 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -835,6 +835,16 @@ struct sge_eosw_txq {
 	struct tasklet_struct qresume_tsk; /* Restarts the queue */
 };
 
+struct sge_eohw_txq {
+	spinlock_t lock; /* Per queue lock */
+	struct sge_txq q; /* HW Txq */
+	struct adapter *adap; /* Backpointer to adapter */
+	unsigned long tso; /* # of TSO requests */
+	unsigned long tx_cso; /* # of Tx checksum offloads */
+	unsigned long vlan_ins; /* # of Tx VLAN insertions */
+	unsigned long mapping_err; /* # of I/O MMU packet mapping errors */
+};
+
 struct sge {
 	struct sge_eth_txq ethtxq[MAX_ETH_QSETS];
 	struct sge_eth_txq ptptxq;
@@ -848,11 +858,16 @@ struct sge {
 	struct sge_rspq intrq ____cacheline_aligned_in_smp;
 	spinlock_t intrq_lock;
 
+	struct sge_eohw_txq *eohw_txq;
+	struct sge_ofld_rxq *eohw_rxq;
+
 	u16 max_ethqsets;           /* # of available Ethernet queue sets */
 	u16 ethqsets;               /* # of active Ethernet queue sets */
 	u16 ethtxq_rover;           /* Tx queue to clean up next */
 	u16 ofldqsets;              /* # of active ofld queue sets */
 	u16 nqs_per_uld;	    /* # of Rx queues per ULD */
+	u16 eoqsets;                /* # of ETHOFLD queues */
+
 	u16 timer_val[SGE_NTIMERS];
 	u8 counter_val[SGE_NCOUNTERS];
 	u16 dbqtimer_tick;
@@ -1466,6 +1481,9 @@ int t4_sge_mod_ctrl_txq(struct adapter *adap, unsigned int eqid,
 int t4_sge_alloc_uld_txq(struct adapter *adap, struct sge_uld_txq *txq,
 			 struct net_device *dev, unsigned int iqid,
 			 unsigned int uld_type);
+int t4_sge_alloc_ethofld_txq(struct adapter *adap, struct sge_eohw_txq *txq,
+			     struct net_device *dev, u32 iqid);
+void t4_sge_free_ethofld_txq(struct adapter *adap, struct sge_eohw_txq *txq);
 irqreturn_t t4_sge_intr_msix(int irq, void *cookie);
 int t4_sge_init(struct adapter *adap);
 void t4_sge_start(struct adapter *adap);
@@ -1995,4 +2013,6 @@ int cxgb4_get_msix_idx_from_bmap(struct adapter *adap);
 void cxgb4_free_msix_idx_in_bmap(struct adapter *adap, u32 msix_idx);
 int cxgb_open(struct net_device *dev);
 int cxgb_close(struct net_device *dev);
+void cxgb4_enable_rx(struct adapter *adap, struct sge_rspq *q);
+void cxgb4_quiesce_rx(struct sge_rspq *q);
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index ae6a47dd7dc9..a13b03f771cc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2658,6 +2658,7 @@ static int sge_qinfo_uld_ciq_entries(const struct adapter *adap, int uld)
 
 static int sge_qinfo_show(struct seq_file *seq, void *v)
 {
+	int eth_entries, ctrl_entries, eo_entries = 0;
 	int uld_rxq_entries[CXGB4_ULD_MAX] = { 0 };
 	int uld_ciq_entries[CXGB4_ULD_MAX] = { 0 };
 	int uld_txq_entries[CXGB4_TX_MAX] = { 0 };
@@ -2665,11 +2666,12 @@ static int sge_qinfo_show(struct seq_file *seq, void *v)
 	const struct sge_uld_rxq_info *urxq_info;
 	struct adapter *adap = seq->private;
 	int i, n, r = (uintptr_t)v - 1;
-	int eth_entries, ctrl_entries;
 	struct sge *s = &adap->sge;
 
 	eth_entries = DIV_ROUND_UP(adap->sge.ethqsets, 4);
 	ctrl_entries = DIV_ROUND_UP(MAX_CTRL_QUEUES, 4);
+	if (adap->sge.eohw_txq)
+		eo_entries = DIV_ROUND_UP(adap->sge.eoqsets, 4);
 
 	mutex_lock(&uld_mutex);
 	if (s->uld_txq_info)
@@ -2761,6 +2763,54 @@ do { \
 	}
 
 	r -= eth_entries;
+	if (r < eo_entries) {
+		int base_qset = r * 4;
+		const struct sge_ofld_rxq *rx = &s->eohw_rxq[base_qset];
+		const struct sge_eohw_txq *tx = &s->eohw_txq[base_qset];
+
+		n = min(4, s->eoqsets - 4 * r);
+
+		S("QType:", "ETHOFLD");
+		S("Interface:",
+		  rx[i].rspq.netdev ? rx[i].rspq.netdev->name : "N/A");
+		T("TxQ ID:", q.cntxt_id);
+		T("TxQ size:", q.size);
+		T("TxQ inuse:", q.in_use);
+		T("TxQ CIDX:", q.cidx);
+		T("TxQ PIDX:", q.pidx);
+		R("RspQ ID:", rspq.abs_id);
+		R("RspQ size:", rspq.size);
+		R("RspQE size:", rspq.iqe_len);
+		R("RspQ CIDX:", rspq.cidx);
+		R("RspQ Gen:", rspq.gen);
+		S3("u", "Intr delay:", qtimer_val(adap, &rx[i].rspq));
+		S3("u", "Intr pktcnt:", s->counter_val[rx[i].rspq.pktcnt_idx]);
+		R("FL ID:", fl.cntxt_id);
+		S3("u", "FL size:", rx->fl.size ? rx->fl.size - 8 : 0);
+		R("FL pend:", fl.pend_cred);
+		R("FL avail:", fl.avail);
+		R("FL PIDX:", fl.pidx);
+		R("FL CIDX:", fl.cidx);
+		RL("RxPackets:", stats.pkts);
+		RL("RxImm:", stats.imm);
+		RL("RxAN", stats.an);
+		RL("RxNoMem", stats.nomem);
+		TL("TSO:", tso);
+		TL("TxCSO:", tx_cso);
+		TL("VLANins:", vlan_ins);
+		TL("TxQFull:", q.stops);
+		TL("TxQRestarts:", q.restarts);
+		TL("TxMapErr:", mapping_err);
+		RL("FLAllocErr:", fl.alloc_failed);
+		RL("FLLrgAlcErr:", fl.large_alloc_failed);
+		RL("FLMapErr:", fl.mapping_err);
+		RL("FLLow:", fl.low);
+		RL("FLStarving:", fl.starving);
+
+		goto unlock;
+	}
+
+	r -= eo_entries;
 	if (r < uld_txq_entries[CXGB4_TX_OFLD]) {
 		const struct sge_uld_txq *tx;
 
@@ -3007,6 +3057,7 @@ static int sge_queue_entries(const struct adapter *adap)
 	mutex_unlock(&uld_mutex);
 
 	return DIV_ROUND_UP(adap->sge.ethqsets, 4) +
+	       (adap->sge.eohw_txq ? DIV_ROUND_UP(adap->sge.eoqsets, 4) : 0) +
 	       tot_uld_entries +
 	       DIV_ROUND_UP(MAX_CTRL_QUEUES, 4) + 1;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index fe3ea60843c3..b5148c57e8bf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -880,6 +880,12 @@ static unsigned int rxq_to_chan(const struct sge *p, unsigned int qid)
 	return netdev2pinfo(p->ingr_map[qid]->netdev)->tx_chan;
 }
 
+void cxgb4_quiesce_rx(struct sge_rspq *q)
+{
+	if (q->handler)
+		napi_disable(&q->napi);
+}
+
 /*
  * Wait until all NAPI handlers are descheduled.
  */
@@ -890,8 +896,10 @@ static void quiesce_rx(struct adapter *adap)
 	for (i = 0; i < adap->sge.ingr_sz; i++) {
 		struct sge_rspq *q = adap->sge.ingr_map[i];
 
-		if (q && q->handler)
-			napi_disable(&q->napi);
+		if (!q)
+			continue;
+
+		cxgb4_quiesce_rx(q);
 	}
 }
 
@@ -913,6 +921,17 @@ static void disable_interrupts(struct adapter *adap)
 	}
 }
 
+void cxgb4_enable_rx(struct adapter *adap, struct sge_rspq *q)
+{
+	if (q->handler)
+		napi_enable(&q->napi);
+
+	/* 0-increment GTS to start the timer and enable interrupts */
+	t4_write_reg(adap, MYPF_REG(SGE_PF_GTS_A),
+		     SEINTARM_V(q->intr_params) |
+		     INGRESSQID_V(q->cntxt_id));
+}
+
 /*
  * Enable NAPI scheduling and interrupt generation for all Rx queues.
  */
@@ -925,13 +944,8 @@ static void enable_rx(struct adapter *adap)
 
 		if (!q)
 			continue;
-		if (q->handler)
-			napi_enable(&q->napi);
 
-		/* 0-increment GTS to start the timer and enable interrupts */
-		t4_write_reg(adap, MYPF_REG(SGE_PF_GTS_A),
-			     SEINTARM_V(q->intr_params) |
-			     INGRESSQID_V(q->cntxt_id));
+		cxgb4_enable_rx(adap, q);
 	}
 }
 
@@ -5360,6 +5374,19 @@ static int cfg_queues(struct adapter *adap)
 		avail_qsets -= num_ulds * s->ofldqsets;
 	}
 
+	/* ETHOFLD Queues used for QoS offload should follow same
+	 * allocation scheme as normal Ethernet Queues.
+	 */
+	if (is_ethofld(adap)) {
+		if (avail_qsets < s->max_ethqsets) {
+			adap->params.ethofld = 0;
+			s->eoqsets = 0;
+		} else {
+			s->eoqsets = s->max_ethqsets;
+		}
+		avail_qsets -= s->eoqsets;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(s->ethrxq); i++) {
 		struct sge_eth_rxq *r = &s->ethrxq[i];
 
@@ -5473,9 +5500,9 @@ void cxgb4_free_msix_idx_in_bmap(struct adapter *adap,
 
 static int enable_msix(struct adapter *adap)
 {
+	u32 eth_need, uld_need = 0, ethofld_need = 0;
+	u32 ethqsets = 0, ofldqsets = 0, eoqsets = 0;
 	u8 num_uld = 0, nchan = adap->params.nports;
-	u32 ethqsets = 0, ofldqsets = 0;
-	u32 eth_need, uld_need = 0;
 	u32 i, want, need, num_vec;
 	struct sge *s = &adap->sge;
 	struct msix_entry *entries;
@@ -5499,6 +5526,12 @@ static int enable_msix(struct adapter *adap)
 		need += uld_need;
 	}
 
+	if (is_ethofld(adap)) {
+		want += s->eoqsets;
+		ethofld_need = eth_need;
+		need += ethofld_need;
+	}
+
 	want += EXTRA_VECS;
 	need += EXTRA_VECS;
 
@@ -5531,7 +5564,9 @@ static int enable_msix(struct adapter *adap)
 		adap->params.crypto = 0;
 		adap->params.ethofld = 0;
 		s->ofldqsets = 0;
+		s->eoqsets = 0;
 		uld_need = 0;
+		ethofld_need = 0;
 	}
 
 	num_vec = allocated;
@@ -5543,10 +5578,12 @@ static int enable_msix(struct adapter *adap)
 		ethqsets = eth_need;
 		if (is_uld(adap))
 			ofldqsets = nchan;
+		if (is_ethofld(adap))
+			eoqsets = ethofld_need;
 
 		num_vec -= need;
 		while (num_vec) {
-			if (num_vec < eth_need ||
+			if (num_vec < eth_need + ethofld_need ||
 			    ethqsets > s->max_ethqsets)
 				break;
 
@@ -5557,6 +5594,10 @@ static int enable_msix(struct adapter *adap)
 
 				ethqsets++;
 				num_vec--;
+				if (ethofld_need) {
+					eoqsets++;
+					num_vec--;
+				}
 			}
 		}
 
@@ -5574,6 +5615,8 @@ static int enable_msix(struct adapter *adap)
 		ethqsets = s->max_ethqsets;
 		if (is_uld(adap))
 			ofldqsets = s->ofldqsets;
+		if (is_ethofld(adap))
+			eoqsets = s->eoqsets;
 	}
 
 	if (ethqsets < s->max_ethqsets) {
@@ -5586,6 +5629,9 @@ static int enable_msix(struct adapter *adap)
 		s->nqs_per_uld = s->ofldqsets;
 	}
 
+	if (is_ethofld(adap))
+		s->eoqsets = eoqsets;
+
 	/* map for msix */
 	ret = alloc_msix_info(adap, allocated);
 	if (ret)
@@ -5597,8 +5643,8 @@ static int enable_msix(struct adapter *adap)
 	}
 
 	dev_info(adap->pdev_dev,
-		 "%d MSI-X vectors allocated, nic %d per uld %d\n",
-		 allocated, s->max_ethqsets, s->nqs_per_uld);
+		 "%d MSI-X vectors allocated, nic %d eoqsets %d per uld %d\n",
+		 allocated, s->max_ethqsets, s->eoqsets, s->nqs_per_uld);
 
 	kfree(entries);
 	return 0;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index 8cdf3dc1da16..66503ea259e7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -120,6 +120,166 @@ static void cxgb4_free_eosw_txq(struct net_device *dev,
 	tasklet_kill(&eosw_txq->qresume_tsk);
 }
 
+static int cxgb4_mqprio_alloc_hw_resources(struct net_device *dev)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct sge_ofld_rxq *eorxq;
+	struct sge_eohw_txq *eotxq;
+	int ret, msix = 0;
+	u32 i;
+
+	/* Allocate ETHOFLD hardware queue structures if not done already */
+	if (!refcount_read(&adap->tc_mqprio->refcnt)) {
+		adap->sge.eohw_rxq = kcalloc(adap->sge.eoqsets,
+					     sizeof(struct sge_ofld_rxq),
+					     GFP_KERNEL);
+		if (!adap->sge.eohw_rxq)
+			return -ENOMEM;
+
+		adap->sge.eohw_txq = kcalloc(adap->sge.eoqsets,
+					     sizeof(struct sge_eohw_txq),
+					     GFP_KERNEL);
+		if (!adap->sge.eohw_txq) {
+			kfree(adap->sge.eohw_rxq);
+			return -ENOMEM;
+		}
+	}
+
+	if (!(adap->flags & CXGB4_USING_MSIX))
+		msix = -((int)adap->sge.intrq.abs_id + 1);
+
+	for (i = 0; i < pi->nqsets; i++) {
+		eorxq = &adap->sge.eohw_rxq[pi->first_qset + i];
+		eotxq = &adap->sge.eohw_txq[pi->first_qset + i];
+
+		/* Allocate Rxqs for receiving ETHOFLD Tx completions */
+		if (msix >= 0) {
+			msix = cxgb4_get_msix_idx_from_bmap(adap);
+			if (msix < 0)
+				goto out_free_queues;
+
+			eorxq->msix = &adap->msix_info[msix];
+			snprintf(eorxq->msix->desc,
+				 sizeof(eorxq->msix->desc),
+				 "%s-eorxq%d", dev->name, i);
+		}
+
+		init_rspq(adap, &eorxq->rspq,
+			  CXGB4_EOHW_RXQ_DEFAULT_INTR_USEC,
+			  CXGB4_EOHW_RXQ_DEFAULT_PKT_CNT,
+			  CXGB4_EOHW_RXQ_DEFAULT_DESC_NUM,
+			  CXGB4_EOHW_RXQ_DEFAULT_DESC_SIZE);
+
+		eorxq->fl.size = CXGB4_EOHW_FLQ_DEFAULT_DESC_NUM;
+
+		ret = t4_sge_alloc_rxq(adap, &eorxq->rspq, false,
+				       dev, msix, &eorxq->fl, NULL,
+				       NULL, 0);
+		if (ret)
+			goto out_free_queues;
+
+		/* Allocate ETHOFLD hardware Txqs */
+		eotxq->q.size = CXGB4_EOHW_TXQ_DEFAULT_DESC_NUM;
+		ret = t4_sge_alloc_ethofld_txq(adap, eotxq, dev,
+					       eorxq->rspq.cntxt_id);
+		if (ret)
+			goto out_free_queues;
+
+		/* Allocate IRQs, set IRQ affinity, and start Rx */
+		if (adap->flags & CXGB4_USING_MSIX) {
+			ret = request_irq(eorxq->msix->vec, t4_sge_intr_msix, 0,
+					  eorxq->msix->desc, &eorxq->rspq);
+			if (ret)
+				goto out_free_msix;
+
+			cxgb4_set_msix_aff(adap, eorxq->msix->vec,
+					   &eorxq->msix->aff_mask, i);
+		}
+
+		if (adap->flags & CXGB4_FULL_INIT_DONE)
+			cxgb4_enable_rx(adap, &eorxq->rspq);
+	}
+
+	refcount_inc(&adap->tc_mqprio->refcnt);
+	return 0;
+
+out_free_msix:
+	while (i-- > 0) {
+		eorxq = &adap->sge.eohw_rxq[pi->first_qset + i];
+
+		if (adap->flags & CXGB4_FULL_INIT_DONE)
+			cxgb4_quiesce_rx(&eorxq->rspq);
+
+		if (adap->flags & CXGB4_USING_MSIX) {
+			cxgb4_clear_msix_aff(eorxq->msix->vec,
+					     eorxq->msix->aff_mask);
+			free_irq(eorxq->msix->vec, &eorxq->rspq);
+		}
+	}
+
+out_free_queues:
+	for (i = 0; i < pi->nqsets; i++) {
+		eorxq = &adap->sge.eohw_rxq[pi->first_qset + i];
+		eotxq = &adap->sge.eohw_txq[pi->first_qset + i];
+
+		if (eorxq->rspq.desc)
+			free_rspq_fl(adap, &eorxq->rspq, &eorxq->fl);
+		if (eorxq->msix)
+			cxgb4_free_msix_idx_in_bmap(adap, eorxq->msix->idx);
+		t4_sge_free_ethofld_txq(adap, eotxq);
+	}
+
+	kfree(adap->sge.eohw_txq);
+	kfree(adap->sge.eohw_rxq);
+
+	return ret;
+}
+
+void cxgb4_mqprio_free_hw_resources(struct net_device *dev)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct sge_ofld_rxq *eorxq;
+	struct sge_eohw_txq *eotxq;
+	u32 i;
+
+	/* Return if no ETHOFLD structures have been allocated yet */
+	if (!refcount_read(&adap->tc_mqprio->refcnt))
+		return;
+
+	/* Return if no hardware queues have been allocated */
+	if (!adap->sge.eohw_rxq[pi->first_qset].rspq.desc)
+		return;
+
+	for (i = 0; i < pi->nqsets; i++) {
+		eorxq = &adap->sge.eohw_rxq[pi->first_qset + i];
+		eotxq = &adap->sge.eohw_txq[pi->first_qset + i];
+
+		/* Device removal path will already disable NAPI
+		 * before unregistering netdevice. So, only disable
+		 * NAPI if we're not in device removal path
+		 */
+		if (!(adap->flags & CXGB4_SHUTTING_DOWN))
+			cxgb4_quiesce_rx(&eorxq->rspq);
+
+		if (adap->flags & CXGB4_USING_MSIX) {
+			cxgb4_clear_msix_aff(eorxq->msix->vec,
+					     eorxq->msix->aff_mask);
+			free_irq(eorxq->msix->vec, &eorxq->rspq);
+		}
+
+		free_rspq_fl(adap, &eorxq->rspq, &eorxq->fl);
+		t4_sge_free_ethofld_txq(adap, eotxq);
+	}
+
+	/* Free up ETHOFLD structures if there are no users */
+	if (refcount_dec_and_test(&adap->tc_mqprio->refcnt)) {
+		kfree(adap->sge.eohw_txq);
+		kfree(adap->sge.eohw_rxq);
+	}
+}
+
 static int cxgb4_mqprio_enable_offload(struct net_device *dev,
 				       struct tc_mqprio_qopt_offload *mqprio)
 {
@@ -131,6 +291,10 @@ static int cxgb4_mqprio_enable_offload(struct net_device *dev,
 	int eotid, ret;
 	u16 i, j;
 
+	ret = cxgb4_mqprio_alloc_hw_resources(dev);
+	if (ret)
+		return -ENOMEM;
+
 	tc_port_mqprio = &adap->tc_mqprio->port_mqprio[pi->port_id];
 	for (i = 0; i < mqprio->qopt.num_tc; i++) {
 		qoffset = mqprio->qopt.offset[i];
@@ -206,6 +370,7 @@ static int cxgb4_mqprio_enable_offload(struct net_device *dev,
 		}
 	}
 
+	cxgb4_mqprio_free_hw_resources(dev);
 	return ret;
 }
 
@@ -235,6 +400,8 @@ static void cxgb4_mqprio_disable_offload(struct net_device *dev)
 		}
 	}
 
+	cxgb4_mqprio_free_hw_resources(dev);
+
 	memset(&tc_port_mqprio->mqprio, 0,
 	       sizeof(struct tc_mqprio_qopt_offload));
 
@@ -310,6 +477,7 @@ int cxgb4_init_tc_mqprio(struct adapter *adap)
 	}
 
 	adap->tc_mqprio = tc_mqprio;
+	refcount_set(&adap->tc_mqprio->refcnt, 0);
 	return 0;
 
 out_free_ports:
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
index 125664b82236..6491ef91c8a9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
@@ -8,6 +8,15 @@
 
 #define CXGB4_EOSW_TXQ_DEFAULT_DESC_NUM 128
 
+#define CXGB4_EOHW_TXQ_DEFAULT_DESC_NUM 1024
+
+#define CXGB4_EOHW_RXQ_DEFAULT_DESC_NUM 1024
+#define CXGB4_EOHW_RXQ_DEFAULT_DESC_SIZE 64
+#define CXGB4_EOHW_RXQ_DEFAULT_INTR_USEC 5
+#define CXGB4_EOHW_RXQ_DEFAULT_PKT_CNT 8
+
+#define CXGB4_EOHW_FLQ_DEFAULT_DESC_NUM 72
+
 enum cxgb4_mqprio_state {
 	CXGB4_MQPRIO_STATE_DISABLED = 0,
 	CXGB4_MQPRIO_STATE_ACTIVE,
@@ -20,6 +29,7 @@ struct cxgb4_tc_port_mqprio {
 };
 
 struct cxgb4_tc_mqprio {
+	refcount_t refcnt; /* Refcount for adapter-wide resources */
 	struct cxgb4_tc_port_mqprio *port_mqprio; /* Per port MQPRIO info */
 };
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 3d9401354af2..cce33d279094 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -366,33 +366,19 @@ free_msix_queue_irqs_uld(struct adapter *adap, unsigned int uld_type)
 	}
 }
 
-static void enable_rx(struct adapter *adap, struct sge_rspq *q)
-{
-	if (!q)
-		return;
-
-	if (q->handler)
-		napi_enable(&q->napi);
-
-	/* 0-increment GTS to start the timer and enable interrupts */
-	t4_write_reg(adap, MYPF_REG(SGE_PF_GTS_A),
-		     SEINTARM_V(q->intr_params) |
-		     INGRESSQID_V(q->cntxt_id));
-}
-
-static void quiesce_rx(struct adapter *adap, struct sge_rspq *q)
-{
-	if (q && q->handler)
-		napi_disable(&q->napi);
-}
-
 static void enable_rx_uld(struct adapter *adap, unsigned int uld_type)
 {
 	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
 	int idx;
 
-	for_each_uldrxq(rxq_info, idx)
-		enable_rx(adap, &rxq_info->uldrxq[idx].rspq);
+	for_each_uldrxq(rxq_info, idx) {
+		struct sge_rspq *q = &rxq_info->uldrxq[idx].rspq;
+
+		if (!q)
+			continue;
+
+		cxgb4_enable_rx(adap, q);
+	}
 }
 
 static void quiesce_rx_uld(struct adapter *adap, unsigned int uld_type)
@@ -400,8 +386,14 @@ static void quiesce_rx_uld(struct adapter *adap, unsigned int uld_type)
 	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
 	int idx;
 
-	for_each_uldrxq(rxq_info, idx)
-		quiesce_rx(adap, &rxq_info->uldrxq[idx].rspq);
+	for_each_uldrxq(rxq_info, idx) {
+		struct sge_rspq *q = &rxq_info->uldrxq[idx].rspq;
+
+		if (!q)
+			continue;
+
+		cxgb4_quiesce_rx(q);
+	}
 }
 
 static void
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index ed1418d2364f..3ea2eccde262 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3982,30 +3982,30 @@ int t4_sge_mod_ctrl_txq(struct adapter *adap, unsigned int eqid,
 	return t4_set_params(adap, adap->mbox, adap->pf, 0, 1, &param, &val);
 }
 
-int t4_sge_alloc_uld_txq(struct adapter *adap, struct sge_uld_txq *txq,
-			 struct net_device *dev, unsigned int iqid,
-			 unsigned int uld_type)
+static int t4_sge_alloc_ofld_txq(struct adapter *adap, struct sge_txq *q,
+				 struct net_device *dev, u32 cmd, u32 iqid)
 {
 	unsigned int chip_ver = CHELSIO_CHIP_VERSION(adap->params.chip);
-	int ret, nentries;
-	struct fw_eq_ofld_cmd c;
-	struct sge *s = &adap->sge;
 	struct port_info *pi = netdev_priv(dev);
-	int cmd = FW_EQ_OFLD_CMD;
+	struct sge *s = &adap->sge;
+	struct fw_eq_ofld_cmd c;
+	u32 fb_min, nentries;
+	int ret;
 
 	/* Add status entries */
-	nentries = txq->q.size + s->stat_len / sizeof(struct tx_desc);
-
-	txq->q.desc = alloc_ring(adap->pdev_dev, txq->q.size,
-			sizeof(struct tx_desc), sizeof(struct tx_sw_desc),
-			&txq->q.phys_addr, &txq->q.sdesc, s->stat_len,
-			NUMA_NO_NODE);
-	if (!txq->q.desc)
+	nentries = q->size + s->stat_len / sizeof(struct tx_desc);
+	q->desc = alloc_ring(adap->pdev_dev, q->size, sizeof(struct tx_desc),
+			     sizeof(struct tx_sw_desc), &q->phys_addr,
+			     &q->sdesc, s->stat_len, NUMA_NO_NODE);
+	if (!q->desc)
 		return -ENOMEM;
 
+	if (chip_ver <= CHELSIO_T5)
+		fb_min = FETCHBURSTMIN_64B_X;
+	else
+		fb_min = FETCHBURSTMIN_64B_T6_X;
+
 	memset(&c, 0, sizeof(c));
-	if (unlikely(uld_type == CXGB4_TX_CRYPTO))
-		cmd = FW_EQ_CTRL_CMD;
 	c.op_to_vfn = htonl(FW_CMD_OP_V(cmd) | FW_CMD_REQUEST_F |
 			    FW_CMD_WRITE_F | FW_CMD_EXEC_F |
 			    FW_EQ_OFLD_CMD_PFN_V(adap->pf) |
@@ -4017,27 +4017,42 @@ int t4_sge_alloc_uld_txq(struct adapter *adap, struct sge_uld_txq *txq,
 		      FW_EQ_OFLD_CMD_PCIECHN_V(pi->tx_chan) |
 		      FW_EQ_OFLD_CMD_FETCHRO_F | FW_EQ_OFLD_CMD_IQID_V(iqid));
 	c.dcaen_to_eqsize =
-		htonl(FW_EQ_OFLD_CMD_FBMIN_V(chip_ver <= CHELSIO_T5
-					     ? FETCHBURSTMIN_64B_X
-					     : FETCHBURSTMIN_64B_T6_X) |
+		htonl(FW_EQ_OFLD_CMD_FBMIN_V(fb_min) |
 		      FW_EQ_OFLD_CMD_FBMAX_V(FETCHBURSTMAX_512B_X) |
 		      FW_EQ_OFLD_CMD_CIDXFTHRESH_V(CIDXFLUSHTHRESH_32_X) |
 		      FW_EQ_OFLD_CMD_EQSIZE_V(nentries));
-	c.eqaddr = cpu_to_be64(txq->q.phys_addr);
+	c.eqaddr = cpu_to_be64(q->phys_addr);
 
 	ret = t4_wr_mbox(adap, adap->mbox, &c, sizeof(c), &c);
 	if (ret) {
-		kfree(txq->q.sdesc);
-		txq->q.sdesc = NULL;
+		kfree(q->sdesc);
+		q->sdesc = NULL;
 		dma_free_coherent(adap->pdev_dev,
 				  nentries * sizeof(struct tx_desc),
-				  txq->q.desc, txq->q.phys_addr);
-		txq->q.desc = NULL;
+				  q->desc, q->phys_addr);
+		q->desc = NULL;
 		return ret;
 	}
 
+	init_txq(adap, q, FW_EQ_OFLD_CMD_EQID_G(ntohl(c.eqid_pkd)));
+	return 0;
+}
+
+int t4_sge_alloc_uld_txq(struct adapter *adap, struct sge_uld_txq *txq,
+			 struct net_device *dev, unsigned int iqid,
+			 unsigned int uld_type)
+{
+	u32 cmd = FW_EQ_OFLD_CMD;
+	int ret;
+
+	if (unlikely(uld_type == CXGB4_TX_CRYPTO))
+		cmd = FW_EQ_CTRL_CMD;
+
+	ret = t4_sge_alloc_ofld_txq(adap, &txq->q, dev, cmd, iqid);
+	if (ret)
+		return ret;
+
 	txq->q.q_type = CXGB4_TXQ_ULD;
-	init_txq(adap, &txq->q, FW_EQ_OFLD_CMD_EQID_G(ntohl(c.eqid_pkd)));
 	txq->adap = adap;
 	skb_queue_head_init(&txq->sendq);
 	tasklet_init(&txq->qresume_tsk, restart_ofldq, (unsigned long)txq);
@@ -4046,6 +4061,25 @@ int t4_sge_alloc_uld_txq(struct adapter *adap, struct sge_uld_txq *txq,
 	return 0;
 }
 
+int t4_sge_alloc_ethofld_txq(struct adapter *adap, struct sge_eohw_txq *txq,
+			     struct net_device *dev, u32 iqid)
+{
+	int ret;
+
+	ret = t4_sge_alloc_ofld_txq(adap, &txq->q, dev, FW_EQ_OFLD_CMD, iqid);
+	if (ret)
+		return ret;
+
+	txq->q.q_type = CXGB4_TXQ_ULD;
+	spin_lock_init(&txq->lock);
+	txq->adap = adap;
+	txq->tso = 0;
+	txq->tx_cso = 0;
+	txq->vlan_ins = 0;
+	txq->mapping_err = 0;
+	return 0;
+}
+
 void free_txq(struct adapter *adap, struct sge_txq *q)
 {
 	struct sge *s = &adap->sge;
@@ -4101,6 +4135,17 @@ void t4_free_ofld_rxqs(struct adapter *adap, int n, struct sge_ofld_rxq *q)
 				     q->fl.size ? &q->fl : NULL);
 }
 
+void t4_sge_free_ethofld_txq(struct adapter *adap, struct sge_eohw_txq *txq)
+{
+	if (txq->q.desc) {
+		t4_ofld_eq_free(adap, adap->mbox, adap->pf, 0,
+				txq->q.cntxt_id);
+		free_tx_desc(adap, &txq->q, txq->q.in_use, false);
+		kfree(txq->q.sdesc);
+		free_txq(adap, &txq->q);
+	}
+}
+
 /**
  *	t4_free_sge_resources - free SGE resources
  *	@adap: the adapter
-- 
2.23.0

