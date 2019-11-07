Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DF2F3426
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389190AbfKGQHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:07:45 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:38592 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbfKGQHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:07:45 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA7G7eHH024031;
        Thu, 7 Nov 2019 08:07:41 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 6/6] cxgb4: add FLOWC based QoS offload
Date:   Thu,  7 Nov 2019 21:29:09 +0530
Message-Id: <e3691751a9a56b034393ebac7eeabbc8cf02d220.1573140612.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rework SCHED API to allow offloading TC-MQPRIO QoS configuration.
The existing QUEUE based rate limiting throttles all queues sharing
a traffic class, to the specified max rate limit value. So, if
multiple queues share a traffic class, then all the queues get
the aggregate specified max rate limit.

So, introduce the new FLOWC based rate limiting, where multiple
queues can share a traffic class with each queue getting its own
individual specified max rate limit.

For example, if 2 queues are bound to class 0, which is rate limited
to 1 Gbps, then 2 queues using QUEUE based rate limiting, get the
aggregate output of 1 Gbps only. In FLOWC based rate limiting, each
queue gets its own output of max 1 Gbps each; i.e. 2 queues * 1 Gbps
rate limit = 2 Gbps.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  16 ++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  | 134 ++++++++++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |   3 +
 drivers/net/ethernet/chelsio/cxgb4/sched.c    | 229 ++++++++++++++----
 drivers/net/ethernet/chelsio/cxgb4/sched.h    |  10 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 150 +++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |   6 +
 7 files changed, 495 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 2dfa98c2d525..1fb273b294a1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -805,7 +805,11 @@ struct sge_uld_txq_info {
 
 enum sge_eosw_state {
 	CXGB4_EO_STATE_CLOSED = 0, /* Not ready to accept traffic */
+	CXGB4_EO_STATE_FLOWC_OPEN_SEND, /* Send FLOWC open request */
+	CXGB4_EO_STATE_FLOWC_OPEN_REPLY, /* Waiting for FLOWC open reply */
 	CXGB4_EO_STATE_ACTIVE, /* Ready to accept traffic */
+	CXGB4_EO_STATE_FLOWC_CLOSE_SEND, /* Send FLOWC close request */
+	CXGB4_EO_STATE_FLOWC_CLOSE_REPLY, /* Waiting for FLOWC close reply */
 };
 
 struct sge_eosw_desc {
@@ -822,6 +826,7 @@ struct sge_eosw_txq {
 	u32 last_pidx; /* Last successfully transmitted Producer Index */
 	u32 cidx; /* Current Consumer Index */
 	u32 last_cidx; /* Last successfully reclaimed Consumer Index */
+	u32 flowc_idx; /* Descriptor containing a FLOWC request */
 	u32 inuse; /* Number of packets held in ring */
 
 	u32 cred; /* Current available credits */
@@ -834,6 +839,7 @@ struct sge_eosw_txq {
 	u32 hwqid; /* Underlying hardware queue index */
 	struct net_device *netdev; /* Pointer to netdevice */
 	struct tasklet_struct qresume_tsk; /* Restarts the queue */
+	struct completion completion; /* completion for FLOWC rendezvous */
 };
 
 struct sge_eohw_txq {
@@ -1128,6 +1134,7 @@ enum {
 
 enum {
 	SCHED_CLASS_MODE_CLASS = 0,     /* per-class scheduling */
+	SCHED_CLASS_MODE_FLOW,          /* per-flow scheduling */
 };
 
 enum {
@@ -1151,6 +1158,14 @@ struct ch_sched_queue {
 	s8   class;    /* class index */
 };
 
+/* Support for "sched_flowc" command to allow one or more FLOWC
+ * to be bound to a TX Scheduling Class.
+ */
+struct ch_sched_flowc {
+	s32 tid;   /* TID to bind */
+	s8  class; /* class index */
+};
+
 /* Defined bit width of user definable filter tuples
  */
 #define ETHTYPE_BITWIDTH 16
@@ -1951,6 +1966,7 @@ void free_tx_desc(struct adapter *adap, struct sge_txq *q,
 		  unsigned int n, bool unmap);
 void cxgb4_eosw_txq_free_desc(struct adapter *adap, struct sge_eosw_txq *txq,
 			      u32 ndesc);
+int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc);
 void cxgb4_ethofld_restart(unsigned long data);
 int cxgb4_ethofld_rx_handler(struct sge_rspq *q, const __be64 *rsp,
 			     const struct pkt_gl *si);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index e7d3638131e3..fb28bce01270 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -3,6 +3,7 @@
 
 #include "cxgb4.h"
 #include "cxgb4_tc_mqprio.h"
+#include "sched.h"
 
 static int cxgb4_mqprio_validate(struct net_device *dev,
 				 struct tc_mqprio_qopt_offload *mqprio)
@@ -103,6 +104,7 @@ static void cxgb4_clean_eosw_txq(struct net_device *dev,
 	eosw_txq->last_pidx = 0;
 	eosw_txq->cidx = 0;
 	eosw_txq->last_cidx = 0;
+	eosw_txq->flowc_idx = 0;
 	eosw_txq->inuse = 0;
 	eosw_txq->cred = adap->params.ofldq_wr_cred;
 	eosw_txq->ncompl = 0;
@@ -281,6 +283,109 @@ void cxgb4_mqprio_free_hw_resources(struct net_device *dev)
 	}
 }
 
+static int cxgb4_mqprio_alloc_tc(struct net_device *dev,
+				 struct tc_mqprio_qopt_offload *mqprio)
+{
+	struct ch_sched_params p = {
+		.type = SCHED_CLASS_TYPE_PACKET,
+		.u.params.level = SCHED_CLASS_LEVEL_CL_RL,
+		.u.params.mode = SCHED_CLASS_MODE_FLOW,
+		.u.params.rateunit = SCHED_CLASS_RATEUNIT_BITS,
+		.u.params.ratemode = SCHED_CLASS_RATEMODE_ABS,
+		.u.params.class = SCHED_CLS_NONE,
+		.u.params.weight = 0,
+		.u.params.pktsize = dev->mtu,
+	};
+	struct cxgb4_tc_port_mqprio *tc_port_mqprio;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct sched_class *e;
+	int ret;
+	u8 i;
+
+	tc_port_mqprio = &adap->tc_mqprio->port_mqprio[pi->port_id];
+	p.u.params.channel = pi->tx_chan;
+	for (i = 0; i < mqprio->qopt.num_tc; i++) {
+		/* Convert from bytes per second to Kbps */
+		p.u.params.minrate = mqprio->min_rate[i] * 8 / 1000;
+		p.u.params.maxrate = mqprio->max_rate[i] * 8 / 1000;
+
+		e = cxgb4_sched_class_alloc(dev, &p);
+		if (!e) {
+			ret = -ENOMEM;
+			goto out_err;
+		}
+
+		tc_port_mqprio->tc_hwtc_map[i] = e->idx;
+	}
+
+	return 0;
+
+out_err:
+	while (i--)
+		cxgb4_sched_class_free(dev, tc_port_mqprio->tc_hwtc_map[i]);
+
+	return ret;
+}
+
+static void cxgb4_mqprio_free_tc(struct net_device *dev)
+{
+	struct cxgb4_tc_port_mqprio *tc_port_mqprio;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	u8 i;
+
+	tc_port_mqprio = &adap->tc_mqprio->port_mqprio[pi->port_id];
+	for (i = 0; i < tc_port_mqprio->mqprio.qopt.num_tc; i++)
+		cxgb4_sched_class_free(dev, tc_port_mqprio->tc_hwtc_map[i]);
+}
+
+static int cxgb4_mqprio_class_bind(struct net_device *dev,
+				   struct sge_eosw_txq *eosw_txq,
+				   u8 tc)
+{
+	struct ch_sched_flowc fe;
+	int ret;
+
+	init_completion(&eosw_txq->completion);
+
+	fe.tid = eosw_txq->eotid;
+	fe.class = tc;
+
+	ret = cxgb4_sched_class_bind(dev, &fe, SCHED_FLOWC);
+	if (ret)
+		return ret;
+
+	ret = wait_for_completion_timeout(&eosw_txq->completion,
+					  CXGB4_FLOWC_WAIT_TIMEOUT);
+	if (!ret)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static void cxgb4_mqprio_class_unbind(struct net_device *dev,
+				      struct sge_eosw_txq *eosw_txq,
+				      u8 tc)
+{
+	struct adapter *adap = netdev2adap(dev);
+	struct ch_sched_flowc fe;
+
+	/* If we're shutting down, interrupts are disabled and no completions
+	 * come back. So, skip waiting for completions in this scenario.
+	 */
+	if (!(adap->flags & CXGB4_SHUTTING_DOWN))
+		init_completion(&eosw_txq->completion);
+
+	fe.tid = eosw_txq->eotid;
+	fe.class = tc;
+	cxgb4_sched_class_unbind(dev, &fe, SCHED_FLOWC);
+
+	if (!(adap->flags & CXGB4_SHUTTING_DOWN))
+		wait_for_completion_timeout(&eosw_txq->completion,
+					    CXGB4_FLOWC_WAIT_TIMEOUT);
+}
+
 static int cxgb4_mqprio_enable_offload(struct net_device *dev,
 				       struct tc_mqprio_qopt_offload *mqprio)
 {
@@ -291,6 +396,7 @@ static int cxgb4_mqprio_enable_offload(struct net_device *dev,
 	struct sge_eosw_txq *eosw_txq;
 	int eotid, ret;
 	u16 i, j;
+	u8 hwtc;
 
 	ret = cxgb4_mqprio_alloc_hw_resources(dev);
 	if (ret)
@@ -316,6 +422,11 @@ static int cxgb4_mqprio_enable_offload(struct net_device *dev,
 				goto out_free_eotids;
 
 			cxgb4_alloc_eotid(&adap->tids, eotid, eosw_txq);
+
+			hwtc = tc_port_mqprio->tc_hwtc_map[i];
+			ret = cxgb4_mqprio_class_bind(dev, eosw_txq, hwtc);
+			if (ret)
+				goto out_free_eotids;
 		}
 	}
 
@@ -366,6 +477,10 @@ static int cxgb4_mqprio_enable_offload(struct net_device *dev,
 		qcount = mqprio->qopt.count[i];
 		for (j = 0; j < qcount; j++) {
 			eosw_txq = &tc_port_mqprio->eosw_txq[qoffset + j];
+
+			hwtc = tc_port_mqprio->tc_hwtc_map[i];
+			cxgb4_mqprio_class_unbind(dev, eosw_txq, hwtc);
+
 			cxgb4_free_eotid(&adap->tids, eosw_txq->eotid);
 			cxgb4_free_eosw_txq(dev, eosw_txq);
 		}
@@ -383,6 +498,7 @@ static void cxgb4_mqprio_disable_offload(struct net_device *dev)
 	struct sge_eosw_txq *eosw_txq;
 	u32 qoffset, qcount;
 	u16 i, j;
+	u8 hwtc;
 
 	tc_port_mqprio = &adap->tc_mqprio->port_mqprio[pi->port_id];
 	if (tc_port_mqprio->state != CXGB4_MQPRIO_STATE_ACTIVE)
@@ -396,6 +512,10 @@ static void cxgb4_mqprio_disable_offload(struct net_device *dev)
 		qcount = tc_port_mqprio->mqprio.qopt.count[i];
 		for (j = 0; j < qcount; j++) {
 			eosw_txq = &tc_port_mqprio->eosw_txq[qoffset + j];
+
+			hwtc = tc_port_mqprio->tc_hwtc_map[i];
+			cxgb4_mqprio_class_unbind(dev, eosw_txq, hwtc);
+
 			cxgb4_free_eotid(&adap->tids, eosw_txq->eotid);
 			cxgb4_free_eosw_txq(dev, eosw_txq);
 		}
@@ -403,6 +523,9 @@ static void cxgb4_mqprio_disable_offload(struct net_device *dev)
 
 	cxgb4_mqprio_free_hw_resources(dev);
 
+	/* Free up the traffic classes */
+	cxgb4_mqprio_free_tc(dev);
+
 	memset(&tc_port_mqprio->mqprio, 0,
 	       sizeof(struct tc_mqprio_qopt_offload));
 
@@ -437,7 +560,18 @@ int cxgb4_setup_tc_mqprio(struct net_device *dev,
 	if (!mqprio->qopt.num_tc)
 		goto out;
 
+	/* Allocate free available traffic classes and configure
+	 * their rate parameters.
+	 */
+	ret = cxgb4_mqprio_alloc_tc(dev, mqprio);
+	if (ret)
+		goto out;
+
 	ret = cxgb4_mqprio_enable_offload(dev, mqprio);
+	if (ret) {
+		cxgb4_mqprio_free_tc(dev);
+		goto out;
+	}
 
 out:
 	if (needs_bring_up)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
index 6491ef91c8a9..c532f1ef8451 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
@@ -17,6 +17,8 @@
 
 #define CXGB4_EOHW_FLQ_DEFAULT_DESC_NUM 72
 
+#define CXGB4_FLOWC_WAIT_TIMEOUT (5 * HZ)
+
 enum cxgb4_mqprio_state {
 	CXGB4_MQPRIO_STATE_DISABLED = 0,
 	CXGB4_MQPRIO_STATE_ACTIVE,
@@ -26,6 +28,7 @@ struct cxgb4_tc_port_mqprio {
 	enum cxgb4_mqprio_state state; /* Current MQPRIO offload state */
 	struct tc_mqprio_qopt_offload mqprio; /* MQPRIO offload params */
 	struct sge_eosw_txq *eosw_txq; /* Netdev SW Tx queue array */
+	u8 tc_hwtc_map[TC_QOPT_MAX_QUEUE]; /* MQPRIO tc to hardware tc map */
 };
 
 struct cxgb4_tc_mqprio {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.c b/drivers/net/ethernet/chelsio/cxgb4/sched.c
index 60218dc676a8..0a98c4dbb36b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.c
@@ -92,45 +92,69 @@ static int t4_sched_bind_unbind_op(struct port_info *pi, void *arg,
 
 		pf = adap->pf;
 		vf = 0;
+
+		err = t4_set_params(adap, adap->mbox, pf, vf, 1,
+				    &fw_param, &fw_class);
+		break;
+	}
+	case SCHED_FLOWC: {
+		struct sched_flowc_entry *fe;
+
+		fe = (struct sched_flowc_entry *)arg;
+
+		fw_class = bind ? fe->param.class : FW_SCHED_CLS_NONE;
+		err = cxgb4_ethofld_send_flowc(adap->port[pi->port_id],
+					       fe->param.tid, fw_class);
 		break;
 	}
 	default:
 		err = -ENOTSUPP;
-		goto out;
+		break;
 	}
 
-	err = t4_set_params(adap, adap->mbox, pf, vf, 1, &fw_param, &fw_class);
-
-out:
 	return err;
 }
 
-static struct sched_class *t4_sched_queue_lookup(struct port_info *pi,
-						 const unsigned int qid,
-						 int *index)
+static void *t4_sched_entry_lookup(struct port_info *pi,
+				   enum sched_bind_type type,
+				   const u32 val)
 {
 	struct sched_table *s = pi->sched_tbl;
 	struct sched_class *e, *end;
-	struct sched_class *found = NULL;
-	int i;
+	void *found = NULL;
 
-	/* Look for a class with matching bound queue parameters */
+	/* Look for an entry with matching @val */
 	end = &s->tab[s->sched_size];
 	for (e = &s->tab[0]; e != end; ++e) {
-		struct sched_queue_entry *qe;
-
-		i = 0;
-		if (e->state == SCHED_STATE_UNUSED)
+		if (e->state == SCHED_STATE_UNUSED ||
+		    e->bind_type != type)
 			continue;
 
-		list_for_each_entry(qe, &e->queue_list, list) {
-			if (qe->cntxt_id == qid) {
-				found = e;
-				if (index)
-					*index = i;
-				break;
+		switch (type) {
+		case SCHED_QUEUE: {
+			struct sched_queue_entry *qe;
+
+			list_for_each_entry(qe, &e->entry_list, list) {
+				if (qe->cntxt_id == val) {
+					found = qe;
+					break;
+				}
 			}
-			i++;
+			break;
+		}
+		case SCHED_FLOWC: {
+			struct sched_flowc_entry *fe;
+
+			list_for_each_entry(fe, &e->entry_list, list) {
+				if (fe->param.tid == val) {
+					found = fe;
+					break;
+				}
+			}
+			break;
+		}
+		default:
+			return NULL;
 		}
 
 		if (found)
@@ -142,35 +166,26 @@ static struct sched_class *t4_sched_queue_lookup(struct port_info *pi,
 
 static int t4_sched_queue_unbind(struct port_info *pi, struct ch_sched_queue *p)
 {
-	struct adapter *adap = pi->adapter;
-	struct sched_class *e;
 	struct sched_queue_entry *qe = NULL;
+	struct adapter *adap = pi->adapter;
 	struct sge_eth_txq *txq;
-	unsigned int qid;
-	int index = -1;
+	struct sched_class *e;
 	int err = 0;
 
 	if (p->queue < 0 || p->queue >= pi->nqsets)
 		return -ERANGE;
 
 	txq = &adap->sge.ethtxq[pi->first_qset + p->queue];
-	qid = txq->q.cntxt_id;
-
-	/* Find the existing class that the queue is bound to */
-	e = t4_sched_queue_lookup(pi, qid, &index);
-	if (e && index >= 0) {
-		int i = 0;
 
-		list_for_each_entry(qe, &e->queue_list, list) {
-			if (i == index)
-				break;
-			i++;
-		}
+	/* Find the existing entry that the queue is bound to */
+	qe = t4_sched_entry_lookup(pi, SCHED_QUEUE, txq->q.cntxt_id);
+	if (qe) {
 		err = t4_sched_bind_unbind_op(pi, (void *)qe, SCHED_QUEUE,
 					      false);
 		if (err)
 			return err;
 
+		e = &pi->sched_tbl->tab[qe->param.class];
 		list_del(&qe->list);
 		kvfree(qe);
 		if (atomic_dec_and_test(&e->refcnt)) {
@@ -183,11 +198,11 @@ static int t4_sched_queue_unbind(struct port_info *pi, struct ch_sched_queue *p)
 
 static int t4_sched_queue_bind(struct port_info *pi, struct ch_sched_queue *p)
 {
-	struct adapter *adap = pi->adapter;
 	struct sched_table *s = pi->sched_tbl;
-	struct sched_class *e;
 	struct sched_queue_entry *qe = NULL;
+	struct adapter *adap = pi->adapter;
 	struct sge_eth_txq *txq;
+	struct sched_class *e;
 	unsigned int qid;
 	int err = 0;
 
@@ -215,7 +230,8 @@ static int t4_sched_queue_bind(struct port_info *pi, struct ch_sched_queue *p)
 	if (err)
 		goto out_err;
 
-	list_add_tail(&qe->list, &e->queue_list);
+	list_add_tail(&qe->list, &e->entry_list);
+	e->bind_type = SCHED_QUEUE;
 	atomic_inc(&e->refcnt);
 	return err;
 
@@ -224,6 +240,73 @@ static int t4_sched_queue_bind(struct port_info *pi, struct ch_sched_queue *p)
 	return err;
 }
 
+static int t4_sched_flowc_unbind(struct port_info *pi, struct ch_sched_flowc *p)
+{
+	struct sched_flowc_entry *fe = NULL;
+	struct adapter *adap = pi->adapter;
+	struct sched_class *e;
+	int err = 0;
+
+	if (p->tid < 0 || p->tid >= adap->tids.neotids)
+		return -ERANGE;
+
+	/* Find the existing entry that the flowc is bound to */
+	fe = t4_sched_entry_lookup(pi, SCHED_FLOWC, p->tid);
+	if (fe) {
+		err = t4_sched_bind_unbind_op(pi, (void *)fe, SCHED_FLOWC,
+					      false);
+		if (err)
+			return err;
+
+		e = &pi->sched_tbl->tab[fe->param.class];
+		list_del(&fe->list);
+		kvfree(fe);
+		if (atomic_dec_and_test(&e->refcnt)) {
+			e->state = SCHED_STATE_UNUSED;
+			memset(&e->info, 0, sizeof(e->info));
+		}
+	}
+	return err;
+}
+
+static int t4_sched_flowc_bind(struct port_info *pi, struct ch_sched_flowc *p)
+{
+	struct sched_table *s = pi->sched_tbl;
+	struct sched_flowc_entry *fe = NULL;
+	struct adapter *adap = pi->adapter;
+	struct sched_class *e;
+	int err = 0;
+
+	if (p->tid < 0 || p->tid >= adap->tids.neotids)
+		return -ERANGE;
+
+	fe = kvzalloc(sizeof(*fe), GFP_KERNEL);
+	if (!fe)
+		return -ENOMEM;
+
+	/* Unbind flowc from any existing class */
+	err = t4_sched_flowc_unbind(pi, p);
+	if (err)
+		goto out_err;
+
+	/* Bind flowc to specified class */
+	memcpy(&fe->param, p, sizeof(fe->param));
+
+	e = &s->tab[fe->param.class];
+	err = t4_sched_bind_unbind_op(pi, (void *)fe, SCHED_FLOWC, true);
+	if (err)
+		goto out_err;
+
+	list_add_tail(&fe->list, &e->entry_list);
+	e->bind_type = SCHED_FLOWC;
+	atomic_inc(&e->refcnt);
+	return err;
+
+out_err:
+	kvfree(fe);
+	return err;
+}
+
 static void t4_sched_class_unbind_all(struct port_info *pi,
 				      struct sched_class *e,
 				      enum sched_bind_type type)
@@ -235,10 +318,17 @@ static void t4_sched_class_unbind_all(struct port_info *pi,
 	case SCHED_QUEUE: {
 		struct sched_queue_entry *qe;
 
-		list_for_each_entry(qe, &e->queue_list, list)
+		list_for_each_entry(qe, &e->entry_list, list)
 			t4_sched_queue_unbind(pi, &qe->param);
 		break;
 	}
+	case SCHED_FLOWC: {
+		struct sched_flowc_entry *fe;
+
+		list_for_each_entry(fe, &e->entry_list, list)
+			t4_sched_flowc_unbind(pi, &fe->param);
+		break;
+	}
 	default:
 		break;
 	}
@@ -262,6 +352,15 @@ static int t4_sched_class_bind_unbind_op(struct port_info *pi, void *arg,
 			err = t4_sched_queue_unbind(pi, qe);
 		break;
 	}
+	case SCHED_FLOWC: {
+		struct ch_sched_flowc *fe = (struct ch_sched_flowc *)arg;
+
+		if (bind)
+			err = t4_sched_flowc_bind(pi, fe);
+		else
+			err = t4_sched_flowc_unbind(pi, fe);
+		break;
+	}
 	default:
 		err = -ENOTSUPP;
 		break;
@@ -299,6 +398,12 @@ int cxgb4_sched_class_bind(struct net_device *dev, void *arg,
 		class_id = qe->class;
 		break;
 	}
+	case SCHED_FLOWC: {
+		struct ch_sched_flowc *fe = (struct ch_sched_flowc *)arg;
+
+		class_id = fe->class;
+		break;
+	}
 	default:
 		return -ENOTSUPP;
 	}
@@ -340,6 +445,12 @@ int cxgb4_sched_class_unbind(struct net_device *dev, void *arg,
 		class_id = qe->class;
 		break;
 	}
+	case SCHED_FLOWC: {
+		struct ch_sched_flowc *fe = (struct ch_sched_flowc *)arg;
+
+		class_id = fe->class;
+		break;
+	}
 	default:
 		return -ENOTSUPP;
 	}
@@ -355,10 +466,13 @@ static struct sched_class *t4_sched_class_lookup(struct port_info *pi,
 						const struct ch_sched_params *p)
 {
 	struct sched_table *s = pi->sched_tbl;
-	struct sched_class *e, *end;
 	struct sched_class *found = NULL;
+	struct sched_class *e, *end;
 
-	if (!p) {
+	/* Only allow tc to be shared among SCHED_FLOWC types. For
+	 * other types, always allocate a new tc.
+	 */
+	if (!p || p->u.params.mode != SCHED_CLASS_MODE_FLOW) {
 		/* Get any available unused class */
 		end = &s->tab[s->sched_size];
 		for (e = &s->tab[0]; e != end; ++e) {
@@ -467,9 +581,32 @@ struct sched_class *cxgb4_sched_class_alloc(struct net_device *dev,
 	return t4_sched_class_alloc(pi, p);
 }
 
-static void t4_sched_class_free(struct port_info *pi, struct sched_class *e)
+/**
+ * cxgb4_sched_class_free - free a scheduling class
+ * @dev: net_device pointer
+ * @e: scheduling class
+ *
+ * Frees a scheduling class if there are no users.
+ */
+void cxgb4_sched_class_free(struct net_device *dev, u8 classid)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct sched_table *s = pi->sched_tbl;
+	struct sched_class *e;
+
+	e = &s->tab[classid];
+	if (!atomic_read(&e->refcnt)) {
+		e->state = SCHED_STATE_UNUSED;
+		memset(&e->info, 0, sizeof(e->info));
+	}
+}
+
+static void t4_sched_class_free(struct net_device *dev, struct sched_class *e)
 {
-	t4_sched_class_unbind_all(pi, e, SCHED_QUEUE);
+	struct port_info *pi = netdev2pinfo(dev);
+
+	t4_sched_class_unbind_all(pi, e, e->bind_type);
+	cxgb4_sched_class_free(dev, e->idx);
 }
 
 struct sched_table *t4_init_sched(unsigned int sched_size)
@@ -487,7 +624,7 @@ struct sched_table *t4_init_sched(unsigned int sched_size)
 		memset(&s->tab[i], 0, sizeof(struct sched_class));
 		s->tab[i].idx = i;
 		s->tab[i].state = SCHED_STATE_UNUSED;
-		INIT_LIST_HEAD(&s->tab[i].queue_list);
+		INIT_LIST_HEAD(&s->tab[i].entry_list);
 		atomic_set(&s->tab[i].refcnt, 0);
 	}
 	return s;
@@ -510,7 +647,7 @@ void t4_cleanup_sched(struct adapter *adap)
 
 			e = &s->tab[i];
 			if (e->state == SCHED_STATE_ACTIVE)
-				t4_sched_class_free(pi, e);
+				t4_sched_class_free(adap->port[j], e);
 		}
 		kvfree(s);
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.h b/drivers/net/ethernet/chelsio/cxgb4/sched.h
index 168fb4ce3759..80bed8e59362 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.h
@@ -56,6 +56,7 @@ enum sched_fw_ops {
 
 enum sched_bind_type {
 	SCHED_QUEUE,
+	SCHED_FLOWC,
 };
 
 struct sched_queue_entry {
@@ -64,11 +65,17 @@ struct sched_queue_entry {
 	struct ch_sched_queue param;
 };
 
+struct sched_flowc_entry {
+	struct list_head list;
+	struct ch_sched_flowc param;
+};
+
 struct sched_class {
 	u8 state;
 	u8 idx;
 	struct ch_sched_params info;
-	struct list_head queue_list;
+	enum sched_bind_type bind_type;
+	struct list_head entry_list;
 	atomic_t refcnt;
 };
 
@@ -102,6 +109,7 @@ int cxgb4_sched_class_unbind(struct net_device *dev, void *arg,
 
 struct sched_class *cxgb4_sched_class_alloc(struct net_device *dev,
 					    struct ch_sched_params *p);
+void cxgb4_sched_class_free(struct net_device *dev, u8 classid);
 
 struct sched_table *t4_init_sched(unsigned int size);
 void t4_cleanup_sched(struct adapter *adap);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 6083d54afd00..e346830ebca9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -56,6 +56,7 @@
 #include "cxgb4_ptp.h"
 #include "cxgb4_uld.h"
 #include "cxgb4_tc_mqprio.h"
+#include "sched.h"
 
 /*
  * Rx buffer size.  We use largish buffers if possible but settle for single
@@ -2160,10 +2161,12 @@ static void ethofld_hard_xmit(struct net_device *dev,
 	struct port_info *pi = netdev2pinfo(dev);
 	struct adapter *adap = netdev2adap(dev);
 	u32 wrlen, wrlen16, hdr_len, data_len;
+	enum sge_eosw_state next_state;
 	u64 cntrl, *start, *end, *sgl;
 	struct sge_eohw_txq *eohw_txq;
 	struct cpl_tx_pkt_core *cpl;
 	struct fw_eth_tx_eo_wr *wr;
+	bool skip_eotx_wr = false;
 	struct sge_eosw_desc *d;
 	struct sk_buff *skb;
 	u8 flits, ndesc;
@@ -2178,9 +2181,21 @@ static void ethofld_hard_xmit(struct net_device *dev,
 	skb_tx_timestamp(skb);
 
 	wr = (struct fw_eth_tx_eo_wr *)&eohw_txq->q.desc[eohw_txq->q.pidx];
-	hdr_len = eth_get_headlen(dev, skb->data, skb_headlen(skb));
-	data_len = skb->len - hdr_len;
-	flits = ethofld_calc_tx_flits(adap, skb, hdr_len);
+	if (unlikely(eosw_txq->state != CXGB4_EO_STATE_ACTIVE &&
+		     eosw_txq->last_pidx == eosw_txq->flowc_idx)) {
+		hdr_len = skb->len;
+		data_len = 0;
+		flits = DIV_ROUND_UP(hdr_len, 8);
+		if (eosw_txq->state == CXGB4_EO_STATE_FLOWC_OPEN_SEND)
+			next_state = CXGB4_EO_STATE_FLOWC_OPEN_REPLY;
+		else
+			next_state = CXGB4_EO_STATE_FLOWC_CLOSE_REPLY;
+		skip_eotx_wr = true;
+	} else {
+		hdr_len = eth_get_headlen(dev, skb->data, skb_headlen(skb));
+		data_len = skb->len - hdr_len;
+		flits = ethofld_calc_tx_flits(adap, skb, hdr_len);
+	}
 	ndesc = flits_to_desc(flits);
 	wrlen = flits * 8;
 	wrlen16 = DIV_ROUND_UP(wrlen, 16);
@@ -2191,6 +2206,12 @@ static void ethofld_hard_xmit(struct net_device *dev,
 	if (unlikely(wrlen16 > eosw_txq->cred))
 		goto out_unlock;
 
+	if (unlikely(skip_eotx_wr)) {
+		start = (u64 *)wr;
+		eosw_txq->state = next_state;
+		goto write_wr_headers;
+	}
+
 	cpl = write_eo_wr(adap, eosw_txq, skb, wr, hdr_len, wrlen);
 	cntrl = hwcsum(adap->params.chip, skb);
 	if (skb_vlan_tag_present(skb))
@@ -2205,6 +2226,7 @@ static void ethofld_hard_xmit(struct net_device *dev,
 
 	start = (u64 *)(cpl + 1);
 
+write_wr_headers:
 	sgl = (u64 *)inline_tx_skb_header(skb, &eohw_txq->q, (void *)start,
 					  hdr_len);
 	if (data_len) {
@@ -2250,10 +2272,14 @@ static void ethofld_xmit(struct net_device *dev, struct sge_eosw_txq *eosw_txq)
 
 	switch (eosw_txq->state) {
 	case CXGB4_EO_STATE_ACTIVE:
+	case CXGB4_EO_STATE_FLOWC_OPEN_SEND:
+	case CXGB4_EO_STATE_FLOWC_CLOSE_SEND:
 		pktcount = eosw_txq->pidx - eosw_txq->last_pidx;
 		if (pktcount < 0)
 			pktcount += eosw_txq->ndesc;
 		break;
+	case CXGB4_EO_STATE_FLOWC_OPEN_REPLY:
+	case CXGB4_EO_STATE_FLOWC_CLOSE_REPLY:
 	case CXGB4_EO_STATE_CLOSED:
 	default:
 		return;
@@ -2328,6 +2354,101 @@ netdev_tx_t t4_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return cxgb4_eth_xmit(skb, dev);
 }
 
+/**
+ * cxgb4_ethofld_send_flowc - Send ETHOFLD flowc request to bind eotid to tc.
+ * @dev - netdevice
+ * @eotid - ETHOFLD tid to bind/unbind
+ * @tc - traffic class. If set to FW_SCHED_CLS_NONE, then unbinds the @eotid
+ *
+ * Send a FLOWC work request to bind an ETHOFLD TID to a traffic class.
+ * If @tc is set to FW_SCHED_CLS_NONE, then the @eotid is unbound from
+ * a traffic class.
+ */
+int cxgb4_ethofld_send_flowc(struct net_device *dev, u32 eotid, u32 tc)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	enum sge_eosw_state next_state;
+	struct sge_eosw_txq *eosw_txq;
+	u32 len, len16, nparams = 6;
+	struct fw_flowc_wr *flowc;
+	struct eotid_entry *entry;
+	struct sge_ofld_rxq *rxq;
+	struct sk_buff *skb;
+	int ret = 0;
+
+	len = sizeof(*flowc) + sizeof(struct fw_flowc_mnemval) * nparams;
+	len16 = DIV_ROUND_UP(len, 16);
+
+	entry = cxgb4_lookup_eotid(&adap->tids, eotid);
+	if (!entry)
+		return -ENOMEM;
+
+	eosw_txq = (struct sge_eosw_txq *)entry->data;
+	if (!eosw_txq)
+		return -ENOMEM;
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	spin_lock_bh(&eosw_txq->lock);
+	if (tc != FW_SCHED_CLS_NONE) {
+		if (eosw_txq->state != CXGB4_EO_STATE_CLOSED)
+			goto out_unlock;
+
+		next_state = CXGB4_EO_STATE_FLOWC_OPEN_SEND;
+	} else {
+		if (eosw_txq->state != CXGB4_EO_STATE_ACTIVE)
+			goto out_unlock;
+
+		next_state = CXGB4_EO_STATE_FLOWC_CLOSE_SEND;
+	}
+
+	flowc = __skb_put(skb, len);
+	memset(flowc, 0, len);
+
+	rxq = &adap->sge.eohw_rxq[eosw_txq->hwqid];
+	flowc->flowid_len16 = cpu_to_be32(FW_WR_LEN16_V(len16) |
+					  FW_WR_FLOWID_V(eosw_txq->hwtid));
+	flowc->op_to_nparams = cpu_to_be32(FW_WR_OP_V(FW_FLOWC_WR) |
+					   FW_FLOWC_WR_NPARAMS_V(nparams) |
+					   FW_WR_COMPL_V(1));
+	flowc->mnemval[0].mnemonic = FW_FLOWC_MNEM_PFNVFN;
+	flowc->mnemval[0].val = cpu_to_be32(FW_PFVF_CMD_PFN_V(adap->pf));
+	flowc->mnemval[1].mnemonic = FW_FLOWC_MNEM_CH;
+	flowc->mnemval[1].val = cpu_to_be32(pi->tx_chan);
+	flowc->mnemval[2].mnemonic = FW_FLOWC_MNEM_PORT;
+	flowc->mnemval[2].val = cpu_to_be32(pi->tx_chan);
+	flowc->mnemval[3].mnemonic = FW_FLOWC_MNEM_IQID;
+	flowc->mnemval[3].val = cpu_to_be32(rxq->rspq.abs_id);
+	flowc->mnemval[4].mnemonic = FW_FLOWC_MNEM_SCHEDCLASS;
+	flowc->mnemval[4].val = cpu_to_be32(tc);
+	flowc->mnemval[5].mnemonic = FW_FLOWC_MNEM_EOSTATE;
+	flowc->mnemval[5].val = cpu_to_be32(tc == FW_SCHED_CLS_NONE ?
+					    FW_FLOWC_MNEM_EOSTATE_CLOSING :
+					    FW_FLOWC_MNEM_EOSTATE_ESTABLISHED);
+
+	eosw_txq->cred -= len16;
+	eosw_txq->ncompl++;
+	eosw_txq->last_compl = 0;
+
+	ret = eosw_txq_enqueue(eosw_txq, skb);
+	if (ret) {
+		dev_consume_skb_any(skb);
+		goto out_unlock;
+	}
+
+	eosw_txq->state = next_state;
+	eosw_txq->flowc_idx = eosw_txq->pidx;
+	eosw_txq_advance(eosw_txq, 1);
+	ethofld_xmit(dev, eosw_txq);
+
+out_unlock:
+	spin_unlock_bh(&eosw_txq->lock);
+	return ret;
+}
+
 /**
  *	is_imm - check whether a packet can be sent as immediate data
  *	@skb: the packet
@@ -3684,9 +3805,26 @@ int cxgb4_ethofld_rx_handler(struct sge_rspq *q, const __be64 *rsp,
 			if (!skb)
 				break;
 
-			hdr_len = eth_get_headlen(eosw_txq->netdev, skb->data,
-						  skb_headlen(skb));
-			flits = ethofld_calc_tx_flits(q->adap, skb, hdr_len);
+			if (unlikely((eosw_txq->state ==
+				      CXGB4_EO_STATE_FLOWC_OPEN_REPLY ||
+				      eosw_txq->state ==
+				      CXGB4_EO_STATE_FLOWC_CLOSE_REPLY) &&
+				     eosw_txq->cidx == eosw_txq->flowc_idx)) {
+				hdr_len = skb->len;
+				flits = DIV_ROUND_UP(skb->len, 8);
+				if (eosw_txq->state ==
+				    CXGB4_EO_STATE_FLOWC_OPEN_REPLY)
+					eosw_txq->state = CXGB4_EO_STATE_ACTIVE;
+				else
+					eosw_txq->state = CXGB4_EO_STATE_CLOSED;
+				complete(&eosw_txq->completion);
+			} else {
+				hdr_len = eth_get_headlen(eosw_txq->netdev,
+							  skb->data,
+							  skb_headlen(skb));
+				flits = ethofld_calc_tx_flits(q->adap, skb,
+							      hdr_len);
+			}
 			eosw_txq_advance_index(&eosw_txq->cidx, 1,
 					       eosw_txq->ndesc);
 			wrlen16 = DIV_ROUND_UP(flits * 8, 16);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index ea395b43dbf4..414e5cca293e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -690,6 +690,12 @@ enum fw_flowc_mnem_tcpstate {
 	FW_FLOWC_MNEM_TCPSTATE_TIMEWAIT = 10, /* not expected */
 };
 
+enum fw_flowc_mnem_eostate {
+	FW_FLOWC_MNEM_EOSTATE_ESTABLISHED = 1, /* default */
+	/* graceful close, after sending outstanding payload */
+	FW_FLOWC_MNEM_EOSTATE_CLOSING = 2,
+};
+
 enum fw_flowc_mnem {
 	FW_FLOWC_MNEM_PFNVFN,		/* PFN [15:8] VFN [7:0] */
 	FW_FLOWC_MNEM_CH,
-- 
2.23.0

