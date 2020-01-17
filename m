Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 081EE140A64
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgAQNDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:03:38 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:33294 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAQNDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 08:03:38 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 00HD3VR5023788;
        Fri, 17 Jan 2020 05:03:31 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net] cxgb4: fix Tx multi channel port rate limit
Date:   Fri, 17 Jan 2020 18:23:55 +0530
Message-Id: <1579265635-7773-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T6 can support 2 egress traffic management channels per port to
double the total number of traffic classes that can be configured.
In this configuration, if the class belongs to the other channel,
then all the queues must be bound again explicitly to the new class,
for the rate limit parameters on the other channel to take effect.

So, always explicitly bind all queues to the port rate limit traffic
class, regardless of the traffic management channel that it belongs
to. Also, only bind queues to port rate limit traffic class, if all
the queues don't already belong to an existing different traffic
class.

Fixes: 4ec4762d8ec6 ("cxgb4: add TC-MATCHALL classifier egress offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 14 +++-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 67 +++++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/sched.c    | 16 +++++
 drivers/net/ethernet/chelsio/cxgb4/sched.h    |  2 +
 4 files changed, 96 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 12ff69b3ba91..0dedd3e9c31e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3135,9 +3135,9 @@ static int cxgb_set_tx_maxrate(struct net_device *dev, int index, u32 rate)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adap = pi->adapter;
+	struct ch_sched_queue qe = { 0 };
+	struct ch_sched_params p = { 0 };
 	struct sched_class *e;
-	struct ch_sched_params p;
-	struct ch_sched_queue qe;
 	u32 req_rate;
 	int err = 0;
 
@@ -3154,6 +3154,15 @@ static int cxgb_set_tx_maxrate(struct net_device *dev, int index, u32 rate)
 		return -EINVAL;
 	}
 
+	qe.queue = index;
+	e = cxgb4_sched_queue_lookup(dev, &qe);
+	if (e && e->info.u.params.level != SCHED_CLASS_LEVEL_CL_RL) {
+		dev_err(adap->pdev_dev,
+			"Queue %u already bound to class %u of type: %u\n",
+			index, e->idx, e->info.u.params.level);
+		return -EBUSY;
+	}
+
 	/* Convert from Mbps to Kbps */
 	req_rate = rate * 1000;
 
@@ -3183,7 +3192,6 @@ static int cxgb_set_tx_maxrate(struct net_device *dev, int index, u32 rate)
 		return 0;
 
 	/* Fetch any available unused or matching scheduling class */
-	memset(&p, 0, sizeof(p));
 	p.type = SCHED_CLASS_TYPE_PACKET;
 	p.u.params.level    = SCHED_CLASS_LEVEL_CL_RL;
 	p.u.params.mode     = SCHED_CLASS_MODE_CLASS;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 102b370fbd3e..6d485803ddbe 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -15,6 +15,8 @@ static int cxgb4_matchall_egress_validate(struct net_device *dev,
 	struct flow_action *actions = &cls->rule->action;
 	struct port_info *pi = netdev2pinfo(dev);
 	struct flow_action_entry *entry;
+	struct ch_sched_queue qe;
+	struct sched_class *e;
 	u64 max_link_rate;
 	u32 i, speed;
 	int ret;
@@ -60,9 +62,61 @@ static int cxgb4_matchall_egress_validate(struct net_device *dev,
 		}
 	}
 
+	for (i = 0; i < pi->nqsets; i++) {
+		memset(&qe, 0, sizeof(qe));
+		qe.queue = i;
+
+		e = cxgb4_sched_queue_lookup(dev, &qe);
+		if (e && e->info.u.params.level != SCHED_CLASS_LEVEL_CH_RL) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Some queues are already bound to different class");
+			return -EBUSY;
+		}
+	}
+
 	return 0;
 }
 
+static int cxgb4_matchall_tc_bind_queues(struct net_device *dev, u32 tc)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct ch_sched_queue qe;
+	int ret;
+	u32 i;
+
+	for (i = 0; i < pi->nqsets; i++) {
+		qe.queue = i;
+		qe.class = tc;
+		ret = cxgb4_sched_class_bind(dev, &qe, SCHED_QUEUE);
+		if (ret)
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	while (i--) {
+		qe.queue = i;
+		qe.class = SCHED_CLS_NONE;
+		cxgb4_sched_class_unbind(dev, &qe, SCHED_QUEUE);
+	}
+
+	return ret;
+}
+
+static void cxgb4_matchall_tc_unbind_queues(struct net_device *dev)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct ch_sched_queue qe;
+	u32 i;
+
+	for (i = 0; i < pi->nqsets; i++) {
+		qe.queue = i;
+		qe.class = SCHED_CLS_NONE;
+		cxgb4_sched_class_unbind(dev, &qe, SCHED_QUEUE);
+	}
+}
+
 static int cxgb4_matchall_alloc_tc(struct net_device *dev,
 				   struct tc_cls_matchall_offload *cls)
 {
@@ -83,6 +137,7 @@ static int cxgb4_matchall_alloc_tc(struct net_device *dev,
 	struct adapter *adap = netdev2adap(dev);
 	struct flow_action_entry *entry;
 	struct sched_class *e;
+	int ret;
 	u32 i;
 
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
@@ -101,10 +156,21 @@ static int cxgb4_matchall_alloc_tc(struct net_device *dev,
 		return -ENOMEM;
 	}
 
+	ret = cxgb4_matchall_tc_bind_queues(dev, e->idx);
+	if (ret) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Could not bind queues to traffic class");
+		goto out_free;
+	}
+
 	tc_port_matchall->egress.hwtc = e->idx;
 	tc_port_matchall->egress.cookie = cls->cookie;
 	tc_port_matchall->egress.state = CXGB4_MATCHALL_STATE_ENABLED;
 	return 0;
+
+out_free:
+	cxgb4_sched_class_free(dev, e->idx);
+	return ret;
 }
 
 static void cxgb4_matchall_free_tc(struct net_device *dev)
@@ -114,6 +180,7 @@ static void cxgb4_matchall_free_tc(struct net_device *dev)
 	struct adapter *adap = netdev2adap(dev);
 
 	tc_port_matchall = &adap->tc_matchall->port_matchall[pi->port_id];
+	cxgb4_matchall_tc_unbind_queues(dev);
 	cxgb4_sched_class_free(dev, tc_port_matchall->egress.hwtc);
 
 	tc_port_matchall->egress.hwtc = SCHED_CLS_NONE;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.c b/drivers/net/ethernet/chelsio/cxgb4/sched.c
index 3e61bd5d0c29..cebe1412d960 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.c
@@ -165,6 +165,22 @@ static void *t4_sched_entry_lookup(struct port_info *pi,
 	return found;
 }
 
+struct sched_class *cxgb4_sched_queue_lookup(struct net_device *dev,
+					     struct ch_sched_queue *p)
+{
+	struct port_info *pi = netdev2pinfo(dev);
+	struct sched_queue_entry *qe = NULL;
+	struct adapter *adap = pi->adapter;
+	struct sge_eth_txq *txq;
+
+	if (p->queue < 0 || p->queue >= pi->nqsets)
+		return NULL;
+
+	txq = &adap->sge.ethtxq[pi->first_qset + p->queue];
+	qe = t4_sched_entry_lookup(pi, SCHED_QUEUE, txq->q.cntxt_id);
+	return qe ? &pi->sched_tbl->tab[qe->param.class] : NULL;
+}
+
 static int t4_sched_queue_unbind(struct port_info *pi, struct ch_sched_queue *p)
 {
 	struct sched_queue_entry *qe = NULL;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sched.h b/drivers/net/ethernet/chelsio/cxgb4/sched.h
index e92ff68bdd0a..5cc74a5a1774 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sched.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/sched.h
@@ -103,6 +103,8 @@ static inline bool valid_class_id(struct net_device *dev, u8 class_id)
 	return true;
 }
 
+struct sched_class *cxgb4_sched_queue_lookup(struct net_device *dev,
+					     struct ch_sched_queue *p);
 int cxgb4_sched_class_bind(struct net_device *dev, void *arg,
 			   enum sched_bind_type type);
 int cxgb4_sched_class_unbind(struct net_device *dev, void *arg,
-- 
2.24.0

