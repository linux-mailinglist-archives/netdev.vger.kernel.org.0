Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B7DF3422
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388989AbfKGQHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:07:35 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:63910 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKGQHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:07:35 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA7G7U2s024022;
        Thu, 7 Nov 2019 08:07:31 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 3/6] cxgb4: parse and configure TC-MQPRIO offload
Date:   Thu,  7 Nov 2019 21:29:06 +0530
Message-Id: <cf92863c3e97c43e63dc617d1c5bad561d370b27.1573140612.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add logic for validation and configuration of TC-MQPRIO Qdisc
offload. Also, add support to manage EOSW_TXQ, which have 1-to-1
mapping with EOTIDs, and expose them to network stack.

Move common skb validation in Tx path to a separate function and
add minimal Tx path for ETHOFLD. Update Tx queue selection to return
normal NIC Txq to send traffic pattern that can't go through ETHOFLD
Tx path.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/Makefile   |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  40 ++
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  38 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  | 346 ++++++++++++++++++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |  30 ++
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  29 ++
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 162 +++++---
 7 files changed, 597 insertions(+), 50 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h

diff --git a/drivers/net/ethernet/chelsio/cxgb4/Makefile b/drivers/net/ethernet/chelsio/cxgb4/Makefile
index 20390f6afbb4..49a19308073b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/Makefile
+++ b/drivers/net/ethernet/chelsio/cxgb4/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_CHELSIO_T4) += cxgb4.o
 cxgb4-objs := cxgb4_main.o l2t.o smt.o t4_hw.o sge.o clip_tbl.o cxgb4_ethtool.o \
 	      cxgb4_uld.o srq.o sched.o cxgb4_filter.o cxgb4_tc_u32.o \
 	      cxgb4_ptp.o cxgb4_tc_flower.o cxgb4_cudbg.o cxgb4_mps.o \
-	      cudbg_common.o cudbg_lib.o cudbg_zlib.o
+	      cudbg_common.o cudbg_lib.o cudbg_zlib.o cxgb4_tc_mqprio.o
 cxgb4-$(CONFIG_CHELSIO_T4_DCB) +=  cxgb4_dcb.o
 cxgb4-$(CONFIG_CHELSIO_T4_FCOE) +=  cxgb4_fcoe.o
 cxgb4-$(CONFIG_DEBUG_FS) += cxgb4_debugfs.o
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index dbfde3fbfce4..04a81276e9c8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -803,6 +803,38 @@ struct sge_uld_txq_info {
 	u16 ntxq;		/* # of egress uld queues */
 };
 
+enum sge_eosw_state {
+	CXGB4_EO_STATE_CLOSED = 0, /* Not ready to accept traffic */
+};
+
+struct sge_eosw_desc {
+	struct sk_buff *skb; /* SKB to free after getting completion */
+	dma_addr_t addr[MAX_SKB_FRAGS + 1]; /* DMA mapped addresses */
+};
+
+struct sge_eosw_txq {
+	spinlock_t lock; /* Per queue lock to synchronize completions */
+	enum sge_eosw_state state; /* Current ETHOFLD State */
+	struct sge_eosw_desc *desc; /* Descriptor ring to hold packets */
+	u32 ndesc; /* Number of descriptors */
+	u32 pidx; /* Current Producer Index */
+	u32 last_pidx; /* Last successfully transmitted Producer Index */
+	u32 cidx; /* Current Consumer Index */
+	u32 last_cidx; /* Last successfully reclaimed Consumer Index */
+	u32 inuse; /* Number of packets held in ring */
+
+	u32 cred; /* Current available credits */
+	u32 ncompl; /* # of completions posted */
+	u32 last_compl; /* # of credits consumed since last completion req */
+
+	u32 eotid; /* Index into EOTID table in software */
+	u32 hwtid; /* Hardware EOTID index */
+
+	u32 hwqid; /* Underlying hardware queue index */
+	struct net_device *netdev; /* Pointer to netdevice */
+	struct tasklet_struct qresume_tsk; /* Restarts the queue */
+};
+
 struct sge {
 	struct sge_eth_txq ethtxq[MAX_ETH_QSETS];
 	struct sge_eth_txq ptptxq;
@@ -1044,6 +1076,9 @@ struct adapter {
 #if IS_ENABLED(CONFIG_THERMAL)
 	struct ch_thermal ch_thermal;
 #endif
+
+	/* TC MQPRIO offload */
+	struct cxgb4_tc_mqprio *tc_mqprio;
 };
 
 /* Support for "sched-class" command to allow a TX Scheduling Class to be
@@ -1895,6 +1930,9 @@ int t4_i2c_rd(struct adapter *adap, unsigned int mbox, int port,
 void free_rspq_fl(struct adapter *adap, struct sge_rspq *rq, struct sge_fl *fl);
 void free_tx_desc(struct adapter *adap, struct sge_txq *q,
 		  unsigned int n, bool unmap);
+void cxgb4_eosw_txq_free_desc(struct adapter *adap, struct sge_eosw_txq *txq,
+			      u32 ndesc);
+void cxgb4_ethofld_restart(unsigned long data);
 void free_txq(struct adapter *adap, struct sge_txq *q);
 void cxgb4_reclaim_completed_tx(struct adapter *adap,
 				struct sge_txq *q, bool unmap);
@@ -1955,4 +1993,6 @@ int cxgb4_update_mac_filt(struct port_info *pi, unsigned int viid,
 			  bool persistent, u8 *smt_idx);
 int cxgb4_get_msix_idx_from_bmap(struct adapter *adap);
 void cxgb4_free_msix_idx_in_bmap(struct adapter *adap, u32 msix_idx);
+int cxgb_open(struct net_device *dev);
+int cxgb_close(struct net_device *dev);
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index d8a1bd80b293..fe3ea60843c3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -65,6 +65,7 @@
 #include <linux/uaccess.h>
 #include <linux/crash_dump.h>
 #include <net/udp_tunnel.h>
+#include <net/xfrm.h>
 
 #include "cxgb4.h"
 #include "cxgb4_filter.h"
@@ -82,6 +83,7 @@
 #include "sched.h"
 #include "cxgb4_tc_u32.h"
 #include "cxgb4_tc_flower.h"
+#include "cxgb4_tc_mqprio.h"
 #include "cxgb4_ptp.h"
 #include "cxgb4_cudbg.h"
 
@@ -1117,6 +1119,18 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
 	}
 #endif /* CONFIG_CHELSIO_T4_DCB */
 
+	if (dev->num_tc) {
+		struct port_info *pi = netdev2pinfo(dev);
+
+		/* Send unsupported traffic pattern to normal NIC queues. */
+		txq = netdev_pick_tx(dev, skb, sb_dev);
+		if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
+		    ip_hdr(skb)->protocol != IPPROTO_TCP)
+			txq = txq % pi->nqsets;
+
+		return txq;
+	}
+
 	if (select_queue) {
 		txq = (skb_rx_queue_recorded(skb)
 			? skb_get_rx_queue(skb)
@@ -2472,11 +2486,11 @@ static void cxgb_down(struct adapter *adapter)
 /*
  * net_device operations
  */
-static int cxgb_open(struct net_device *dev)
+int cxgb_open(struct net_device *dev)
 {
-	int err;
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
+	int err;
 
 	netif_carrier_off(dev);
 
@@ -2499,7 +2513,7 @@ static int cxgb_open(struct net_device *dev)
 	return err;
 }
 
-static int cxgb_close(struct net_device *dev)
+int cxgb_close(struct net_device *dev)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
@@ -3233,6 +3247,17 @@ static int cxgb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+static int cxgb_setup_tc_mqprio(struct net_device *dev,
+				struct tc_mqprio_qopt_offload *mqprio)
+{
+	struct adapter *adap = netdev2adap(dev);
+
+	if (!is_ethofld(adap) || !adap->tc_mqprio)
+		return -ENOMEM;
+
+	return cxgb4_setup_tc_mqprio(dev, mqprio);
+}
+
 static LIST_HEAD(cxgb_block_cb_list);
 
 static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
@@ -3241,6 +3266,8 @@ static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	struct port_info *pi = netdev2pinfo(dev);
 
 	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return cxgb_setup_tc_mqprio(dev, type_data);
 	case TC_SETUP_BLOCK:
 		return flow_block_cb_setup_simple(type_data,
 						  &cxgb_block_cb_list,
@@ -5668,6 +5695,7 @@ static void free_some_resources(struct adapter *adapter)
 	kvfree(adapter->srq);
 	t4_cleanup_sched(adapter);
 	kvfree(adapter->tids.tid_tab);
+	cxgb4_cleanup_tc_mqprio(adapter);
 	cxgb4_cleanup_tc_flower(adapter);
 	cxgb4_cleanup_tc_u32(adapter);
 	kfree(adapter->sge.egr_map);
@@ -6237,6 +6265,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (cxgb4_init_tc_flower(adapter))
 			dev_warn(&pdev->dev,
 				 "could not offload tc flower, continuing\n");
+
+		if (cxgb4_init_tc_mqprio(adapter))
+			dev_warn(&pdev->dev,
+				 "could not offload tc mqprio, continuing\n");
 	}
 
 	if (is_offload(adapter) || is_hashfilter(adapter)) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
new file mode 100644
index 000000000000..8cdf3dc1da16
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -0,0 +1,346 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2019 Chelsio Communications.  All rights reserved. */
+
+#include "cxgb4.h"
+#include "cxgb4_tc_mqprio.h"
+
+static int cxgb4_mqprio_validate(struct net_device *dev,
+				 struct tc_mqprio_qopt_offload *mqprio)
+{
+	u64 min_rate = 0, max_rate = 0, max_link_rate;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	u32 qcount = 0, qoffset = 0;
+	u32 link_ok, speed, mtu;
+	int ret;
+	u8 i;
+
+	if (!mqprio->qopt.num_tc)
+		return 0;
+
+	if (mqprio->qopt.hw != TC_MQPRIO_HW_OFFLOAD_TCS) {
+		netdev_err(dev, "Only full TC hardware offload is supported\n");
+		return -EINVAL;
+	} else if (mqprio->mode != TC_MQPRIO_MODE_CHANNEL) {
+		netdev_err(dev, "Only channel mode offload is supported\n");
+		return -EINVAL;
+	} else if (mqprio->shaper != TC_MQPRIO_SHAPER_BW_RATE) {
+		netdev_err(dev,	"Only bandwidth rate shaper supported\n");
+		return -EINVAL;
+	} else if (mqprio->qopt.num_tc > adap->params.nsched_cls) {
+		netdev_err(dev,
+			   "Only %u traffic classes supported by hardware\n",
+			   adap->params.nsched_cls);
+		return -ERANGE;
+	}
+
+	ret = t4_get_link_params(pi, &link_ok, &speed, &mtu);
+	if (ret) {
+		netdev_err(dev, "Failed to get link speed, ret: %d\n", ret);
+		return -EINVAL;
+	}
+
+	/* Convert from Mbps to bps */
+	max_link_rate = (u64)speed * 1000 * 1000;
+
+	for (i = 0; i < mqprio->qopt.num_tc; i++) {
+		qoffset = max_t(u16, mqprio->qopt.offset[i], qoffset);
+		qcount += mqprio->qopt.count[i];
+
+		/* Convert byte per second to bits per second */
+		min_rate += (mqprio->min_rate[i] * 8);
+		max_rate += (mqprio->max_rate[i] * 8);
+	}
+
+	if (qoffset >= adap->tids.neotids || qcount > adap->tids.neotids)
+		return -ENOMEM;
+
+	if (min_rate > max_link_rate || max_rate > max_link_rate) {
+		netdev_err(dev,
+			   "Total Min/Max (%llu/%llu) Rate > supported (%llu)\n",
+			   min_rate, max_rate, max_link_rate);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int cxgb4_init_eosw_txq(struct net_device *dev,
+			       struct sge_eosw_txq *eosw_txq,
+			       u32 eotid, u32 hwqid)
+{
+	struct adapter *adap = netdev2adap(dev);
+	struct sge_eosw_desc *ring;
+
+	memset(eosw_txq, 0, sizeof(*eosw_txq));
+
+	ring = kcalloc(CXGB4_EOSW_TXQ_DEFAULT_DESC_NUM,
+		       sizeof(*ring), GFP_KERNEL);
+	if (!ring)
+		return -ENOMEM;
+
+	eosw_txq->desc = ring;
+	eosw_txq->ndesc = CXGB4_EOSW_TXQ_DEFAULT_DESC_NUM;
+	spin_lock_init(&eosw_txq->lock);
+	eosw_txq->state = CXGB4_EO_STATE_CLOSED;
+	eosw_txq->eotid = eotid;
+	eosw_txq->hwtid = adap->tids.eotid_base + eosw_txq->eotid;
+	eosw_txq->cred = adap->params.ofldq_wr_cred;
+	eosw_txq->hwqid = hwqid;
+	eosw_txq->netdev = dev;
+	tasklet_init(&eosw_txq->qresume_tsk, cxgb4_ethofld_restart,
+		     (unsigned long)eosw_txq);
+	return 0;
+}
+
+static void cxgb4_clean_eosw_txq(struct net_device *dev,
+				 struct sge_eosw_txq *eosw_txq)
+{
+	struct adapter *adap = netdev2adap(dev);
+
+	cxgb4_eosw_txq_free_desc(adap, eosw_txq, eosw_txq->ndesc);
+	eosw_txq->pidx = 0;
+	eosw_txq->last_pidx = 0;
+	eosw_txq->cidx = 0;
+	eosw_txq->last_cidx = 0;
+	eosw_txq->inuse = 0;
+	eosw_txq->cred = adap->params.ofldq_wr_cred;
+	eosw_txq->ncompl = 0;
+	eosw_txq->last_compl = 0;
+	eosw_txq->state = CXGB4_EO_STATE_CLOSED;
+}
+
+static void cxgb4_free_eosw_txq(struct net_device *dev,
+				struct sge_eosw_txq *eosw_txq)
+{
+	spin_lock_bh(&eosw_txq->lock);
+	cxgb4_clean_eosw_txq(dev, eosw_txq);
+	kfree(eosw_txq->desc);
+	spin_unlock_bh(&eosw_txq->lock);
+	tasklet_kill(&eosw_txq->qresume_tsk);
+}
+
+static int cxgb4_mqprio_enable_offload(struct net_device *dev,
+				       struct tc_mqprio_qopt_offload *mqprio)
+{
+	struct cxgb4_tc_port_mqprio *tc_port_mqprio;
+	u32 qoffset, qcount, tot_qcount, qid, hwqid;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct sge_eosw_txq *eosw_txq;
+	int eotid, ret;
+	u16 i, j;
+
+	tc_port_mqprio = &adap->tc_mqprio->port_mqprio[pi->port_id];
+	for (i = 0; i < mqprio->qopt.num_tc; i++) {
+		qoffset = mqprio->qopt.offset[i];
+		qcount = mqprio->qopt.count[i];
+		for (j = 0; j < qcount; j++) {
+			eotid = cxgb4_get_free_eotid(&adap->tids);
+			if (eotid < 0) {
+				ret = -ENOMEM;
+				goto out_free_eotids;
+			}
+
+			qid = qoffset + j;
+			hwqid = pi->first_qset + (eotid % pi->nqsets);
+			eosw_txq = &tc_port_mqprio->eosw_txq[qid];
+			ret = cxgb4_init_eosw_txq(dev, eosw_txq,
+						  eotid, hwqid);
+			if (ret)
+				goto out_free_eotids;
+
+			cxgb4_alloc_eotid(&adap->tids, eotid, eosw_txq);
+		}
+	}
+
+	memcpy(&tc_port_mqprio->mqprio, mqprio,
+	       sizeof(struct tc_mqprio_qopt_offload));
+
+	/* Inform the stack about the configured tc params.
+	 *
+	 * Set the correct queue map. If no queue count has been
+	 * specified, then send the traffic through default NIC
+	 * queues; instead of ETHOFLD queues.
+	 */
+	ret = netdev_set_num_tc(dev, mqprio->qopt.num_tc);
+	if (ret)
+		goto out_free_eotids;
+
+	tot_qcount = pi->nqsets;
+	for (i = 0; i < mqprio->qopt.num_tc; i++) {
+		qcount = mqprio->qopt.count[i];
+		if (qcount) {
+			qoffset = mqprio->qopt.offset[i] + pi->nqsets;
+		} else {
+			qcount = pi->nqsets;
+			qoffset = 0;
+		}
+
+		ret = netdev_set_tc_queue(dev, i, qcount, qoffset);
+		if (ret)
+			goto out_reset_tc;
+
+		tot_qcount += mqprio->qopt.count[i];
+	}
+
+	ret = netif_set_real_num_tx_queues(dev, tot_qcount);
+	if (ret)
+		goto out_reset_tc;
+
+	tc_port_mqprio->state = CXGB4_MQPRIO_STATE_ACTIVE;
+	return 0;
+
+out_reset_tc:
+	netdev_reset_tc(dev);
+	i = mqprio->qopt.num_tc;
+
+out_free_eotids:
+	while (i-- > 0) {
+		qoffset = mqprio->qopt.offset[i];
+		qcount = mqprio->qopt.count[i];
+		for (j = 0; j < qcount; j++) {
+			eosw_txq = &tc_port_mqprio->eosw_txq[qoffset + j];
+			cxgb4_free_eotid(&adap->tids, eosw_txq->eotid);
+			cxgb4_free_eosw_txq(dev, eosw_txq);
+		}
+	}
+
+	return ret;
+}
+
+static void cxgb4_mqprio_disable_offload(struct net_device *dev)
+{
+	struct cxgb4_tc_port_mqprio *tc_port_mqprio;
+	struct port_info *pi = netdev2pinfo(dev);
+	struct adapter *adap = netdev2adap(dev);
+	struct sge_eosw_txq *eosw_txq;
+	u32 qoffset, qcount;
+	u16 i, j;
+
+	tc_port_mqprio = &adap->tc_mqprio->port_mqprio[pi->port_id];
+	if (tc_port_mqprio->state != CXGB4_MQPRIO_STATE_ACTIVE)
+		return;
+
+	netdev_reset_tc(dev);
+	netif_set_real_num_tx_queues(dev, pi->nqsets);
+
+	for (i = 0; i < tc_port_mqprio->mqprio.qopt.num_tc; i++) {
+		qoffset = tc_port_mqprio->mqprio.qopt.offset[i];
+		qcount = tc_port_mqprio->mqprio.qopt.count[i];
+		for (j = 0; j < qcount; j++) {
+			eosw_txq = &tc_port_mqprio->eosw_txq[qoffset + j];
+			cxgb4_free_eotid(&adap->tids, eosw_txq->eotid);
+			cxgb4_free_eosw_txq(dev, eosw_txq);
+		}
+	}
+
+	memset(&tc_port_mqprio->mqprio, 0,
+	       sizeof(struct tc_mqprio_qopt_offload));
+
+	tc_port_mqprio->state = CXGB4_MQPRIO_STATE_DISABLED;
+}
+
+int cxgb4_setup_tc_mqprio(struct net_device *dev,
+			  struct tc_mqprio_qopt_offload *mqprio)
+{
+	bool needs_bring_up = false;
+	int ret;
+
+	ret = cxgb4_mqprio_validate(dev, mqprio);
+	if (ret)
+		return ret;
+
+	/* To configure tc params, the current allocated EOTIDs must
+	 * be freed up. However, they can't be freed up if there's
+	 * traffic running on the interface. So, ensure interface is
+	 * down before configuring tc params.
+	 */
+	if (netif_running(dev)) {
+		cxgb_close(dev);
+		needs_bring_up = true;
+	}
+
+	cxgb4_mqprio_disable_offload(dev);
+
+	/* If requested for clear, then just return since resources are
+	 * already freed up by now.
+	 */
+	if (!mqprio->qopt.num_tc)
+		goto out;
+
+	ret = cxgb4_mqprio_enable_offload(dev, mqprio);
+
+out:
+	if (needs_bring_up)
+		cxgb_open(dev);
+
+	return ret;
+}
+
+int cxgb4_init_tc_mqprio(struct adapter *adap)
+{
+	struct cxgb4_tc_port_mqprio *tc_port_mqprio, *port_mqprio;
+	struct cxgb4_tc_mqprio *tc_mqprio;
+	struct sge_eosw_txq *eosw_txq;
+	int ret = 0;
+	u8 i;
+
+	tc_mqprio = kzalloc(sizeof(*tc_mqprio), GFP_KERNEL);
+	if (!tc_mqprio)
+		return -ENOMEM;
+
+	tc_port_mqprio = kcalloc(adap->params.nports, sizeof(*tc_port_mqprio),
+				 GFP_KERNEL);
+	if (!tc_port_mqprio) {
+		ret = -ENOMEM;
+		goto out_free_mqprio;
+	}
+
+	tc_mqprio->port_mqprio = tc_port_mqprio;
+	for (i = 0; i < adap->params.nports; i++) {
+		port_mqprio = &tc_mqprio->port_mqprio[i];
+		eosw_txq = kcalloc(adap->tids.neotids, sizeof(*eosw_txq),
+				   GFP_KERNEL);
+		if (!eosw_txq) {
+			ret = -ENOMEM;
+			goto out_free_ports;
+		}
+		port_mqprio->eosw_txq = eosw_txq;
+	}
+
+	adap->tc_mqprio = tc_mqprio;
+	return 0;
+
+out_free_ports:
+	for (i = 0; i < adap->params.nports; i++) {
+		port_mqprio = &tc_mqprio->port_mqprio[i];
+		kfree(port_mqprio->eosw_txq);
+	}
+	kfree(tc_port_mqprio);
+
+out_free_mqprio:
+	kfree(tc_mqprio);
+	return ret;
+}
+
+void cxgb4_cleanup_tc_mqprio(struct adapter *adap)
+{
+	struct cxgb4_tc_port_mqprio *port_mqprio;
+	u8 i;
+
+	if (adap->tc_mqprio) {
+		if (adap->tc_mqprio->port_mqprio) {
+			for (i = 0; i < adap->params.nports; i++) {
+				struct net_device *dev = adap->port[i];
+
+				if (dev)
+					cxgb4_mqprio_disable_offload(dev);
+				port_mqprio = &adap->tc_mqprio->port_mqprio[i];
+				kfree(port_mqprio->eosw_txq);
+			}
+			kfree(adap->tc_mqprio->port_mqprio);
+		}
+		kfree(adap->tc_mqprio);
+	}
+}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
new file mode 100644
index 000000000000..125664b82236
--- /dev/null
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2019 Chelsio Communications.  All rights reserved. */
+
+#ifndef __CXGB4_TC_MQPRIO_H__
+#define __CXGB4_TC_MQPRIO_H__
+
+#include <net/pkt_cls.h>
+
+#define CXGB4_EOSW_TXQ_DEFAULT_DESC_NUM 128
+
+enum cxgb4_mqprio_state {
+	CXGB4_MQPRIO_STATE_DISABLED = 0,
+	CXGB4_MQPRIO_STATE_ACTIVE,
+};
+
+struct cxgb4_tc_port_mqprio {
+	enum cxgb4_mqprio_state state; /* Current MQPRIO offload state */
+	struct tc_mqprio_qopt_offload mqprio; /* MQPRIO offload params */
+	struct sge_eosw_txq *eosw_txq; /* Netdev SW Tx queue array */
+};
+
+struct cxgb4_tc_mqprio {
+	struct cxgb4_tc_port_mqprio *port_mqprio; /* Per port MQPRIO info */
+};
+
+int cxgb4_setup_tc_mqprio(struct net_device *dev,
+			  struct tc_mqprio_qopt_offload *mqprio);
+int cxgb4_init_tc_mqprio(struct adapter *adap);
+void cxgb4_cleanup_tc_mqprio(struct adapter *adap);
+#endif /* __CXGB4_TC_MQPRIO_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index b78feef23dc4..861b25d28ed6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -186,6 +186,35 @@ static inline void cxgb4_insert_tid(struct tid_info *t, void *data,
 	atomic_inc(&t->conns_in_use);
 }
 
+static inline struct eotid_entry *cxgb4_lookup_eotid(struct tid_info *t,
+						     u32 eotid)
+{
+	return eotid < t->neotids ? &t->eotid_tab[eotid] : NULL;
+}
+
+static inline int cxgb4_get_free_eotid(struct tid_info *t)
+{
+	int eotid;
+
+	eotid = find_first_zero_bit(t->eotid_bmap, t->neotids);
+	if (eotid >= t->neotids)
+		eotid = -1;
+
+	return eotid;
+}
+
+static inline void cxgb4_alloc_eotid(struct tid_info *t, u32 eotid, void *data)
+{
+	set_bit(eotid, t->eotid_bmap);
+	t->eotid_tab[eotid].data = data;
+}
+
+static inline void cxgb4_free_eotid(struct tid_info *t, u32 eotid)
+{
+	clear_bit(eotid, t->eotid_bmap);
+	t->eotid_tab[eotid].data = NULL;
+}
+
 int cxgb4_alloc_atid(struct tid_info *t, void *data);
 int cxgb4_alloc_stid(struct tid_info *t, int family, void *data);
 int cxgb4_alloc_sftid(struct tid_info *t, int family, void *data);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 82d8e13fc7d2..ed1418d2364f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -269,7 +269,6 @@ int cxgb4_map_skb(struct device *dev, const struct sk_buff *skb,
 }
 EXPORT_SYMBOL(cxgb4_map_skb);
 
-#ifdef CONFIG_NEED_DMA_MAP_STATE
 static void unmap_skb(struct device *dev, const struct sk_buff *skb,
 		      const dma_addr_t *addr)
 {
@@ -284,6 +283,7 @@ static void unmap_skb(struct device *dev, const struct sk_buff *skb,
 		dma_unmap_page(dev, *addr++, skb_frag_size(fp), DMA_TO_DEVICE);
 }
 
+#ifdef CONFIG_NEED_DMA_MAP_STATE
 /**
  *	deferred_unmap_destructor - unmap a packet when it is freed
  *	@skb: the packet
@@ -1347,6 +1347,31 @@ int t4_sge_eth_txq_egress_update(struct adapter *adap, struct sge_eth_txq *eq,
 	return reclaimed;
 }
 
+static inline int cxgb4_validate_skb(struct sk_buff *skb,
+				     struct net_device *dev,
+				     u32 min_pkt_len)
+{
+	u32 max_pkt_len;
+
+	/* The chip min packet length is 10 octets but some firmware
+	 * commands have a minimum packet length requirement. So, play
+	 * safe and reject anything shorter than @min_pkt_len.
+	 */
+	if (unlikely(skb->len < min_pkt_len))
+		return -EINVAL;
+
+	/* Discard the packet if the length is greater than mtu */
+	max_pkt_len = ETH_HLEN + dev->mtu;
+
+	if (skb_vlan_tagged(skb))
+		max_pkt_len += VLAN_HLEN;
+
+	if (!skb_shinfo(skb)->gso_size && (unlikely(skb->len > max_pkt_len)))
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  *	cxgb4_eth_xmit - add a packet to an Ethernet Tx queue
  *	@skb: the packet
@@ -1356,41 +1381,24 @@ int t4_sge_eth_txq_egress_update(struct adapter *adap, struct sge_eth_txq *eq,
  */
 static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	u32 wr_mid, ctrl0, op;
-	u64 cntrl, *end, *sgl;
-	int qidx, credits;
-	unsigned int flits, ndesc;
-	struct adapter *adap;
-	struct sge_eth_txq *q;
-	const struct port_info *pi;
+	enum cpl_tx_tnl_lso_type tnl_type = TX_TNL_TYPE_OPAQUE;
+	bool ptp_enabled = is_ptp_enabled(skb, dev);
+	dma_addr_t addr[MAX_SKB_FRAGS + 1];
+	const struct skb_shared_info *ssi;
 	struct fw_eth_tx_pkt_wr *wr;
 	struct cpl_tx_pkt_core *cpl;
-	const struct skb_shared_info *ssi;
-	dma_addr_t addr[MAX_SKB_FRAGS + 1];
+	int len, qidx, credits, ret;
+	const struct port_info *pi;
+	unsigned int flits, ndesc;
 	bool immediate = false;
-	int len, max_pkt_len;
-	bool ptp_enabled = is_ptp_enabled(skb, dev);
+	u32 wr_mid, ctrl0, op;
+	u64 cntrl, *end, *sgl;
+	struct sge_eth_txq *q;
 	unsigned int chip_ver;
-	enum cpl_tx_tnl_lso_type tnl_type = TX_TNL_TYPE_OPAQUE;
-
-#ifdef CONFIG_CHELSIO_T4_FCOE
-	int err;
-#endif /* CONFIG_CHELSIO_T4_FCOE */
-
-	/*
-	 * The chip min packet length is 10 octets but play safe and reject
-	 * anything shorter than an Ethernet header.
-	 */
-	if (unlikely(skb->len < ETH_HLEN)) {
-out_free:	dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
-	}
+	struct adapter *adap;
 
-	/* Discard the packet if the length is greater than mtu */
-	max_pkt_len = ETH_HLEN + dev->mtu;
-	if (skb_vlan_tagged(skb))
-		max_pkt_len += VLAN_HLEN;
-	if (!skb_shinfo(skb)->gso_size && (unlikely(skb->len > max_pkt_len)))
+	ret = cxgb4_validate_skb(skb, dev, ETH_HLEN);
+	if (ret)
 		goto out_free;
 
 	pi = netdev_priv(dev);
@@ -1421,8 +1429,8 @@ out_free:	dev_kfree_skb_any(skb);
 	cntrl = TXPKT_L4CSUM_DIS_F | TXPKT_IPCSUM_DIS_F;
 
 #ifdef CONFIG_CHELSIO_T4_FCOE
-	err = cxgb_fcoe_offload(skb, adap, pi, &cntrl);
-	if (unlikely(err == -ENOTSUPP)) {
+	ret = cxgb_fcoe_offload(skb, adap, pi, &cntrl);
+	if (unlikely(ret == -ENOTSUPP)) {
 		if (ptp_enabled)
 			spin_unlock(&adap->ptp_lock);
 		goto out_free;
@@ -1622,6 +1630,10 @@ out_free:	dev_kfree_skb_any(skb);
 	if (ptp_enabled)
 		spin_unlock(&adap->ptp_lock);
 	return NETDEV_TX_OK;
+
+out_free:
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
 }
 
 /* Constants ... */
@@ -1710,32 +1722,25 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 	dma_addr_t addr[MAX_SKB_FRAGS + 1];
 	const struct skb_shared_info *ssi;
 	struct fw_eth_tx_pkt_vm_wr *wr;
-	int qidx, credits, max_pkt_len;
 	struct cpl_tx_pkt_core *cpl;
 	const struct port_info *pi;
 	unsigned int flits, ndesc;
 	struct sge_eth_txq *txq;
 	struct adapter *adapter;
+	int qidx, credits, ret;
+	size_t fw_hdr_copy_len;
 	u64 cntrl, *end;
 	u32 wr_mid;
-	const size_t fw_hdr_copy_len = sizeof(wr->ethmacdst) +
-				       sizeof(wr->ethmacsrc) +
-				       sizeof(wr->ethtype) +
-				       sizeof(wr->vlantci);
 
 	/* The chip minimum packet length is 10 octets but the firmware
 	 * command that we are using requires that we copy the Ethernet header
 	 * (including the VLAN tag) into the header so we reject anything
 	 * smaller than that ...
 	 */
-	if (unlikely(skb->len < fw_hdr_copy_len))
-		goto out_free;
-
-	/* Discard the packet if the length is greater than mtu */
-	max_pkt_len = ETH_HLEN + dev->mtu;
-	if (skb_vlan_tag_present(skb))
-		max_pkt_len += VLAN_HLEN;
-	if (!skb_shinfo(skb)->gso_size && (unlikely(skb->len > max_pkt_len)))
+	fw_hdr_copy_len = sizeof(wr->ethmacdst) + sizeof(wr->ethmacsrc) +
+			  sizeof(wr->ethtype) + sizeof(wr->vlantci);
+	ret = cxgb4_validate_skb(skb, dev, fw_hdr_copy_len);
+	if (ret)
 		goto out_free;
 
 	/* Figure out which TX Queue we're going to use. */
@@ -1991,13 +1996,62 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static inline void eosw_txq_advance_index(u32 *idx, u32 n, u32 max)
+{
+	u32 val = *idx + n;
+
+	if (val >= max)
+		val -= max;
+
+	*idx = val;
+}
+
+void cxgb4_eosw_txq_free_desc(struct adapter *adap,
+			      struct sge_eosw_txq *eosw_txq, u32 ndesc)
+{
+	struct sge_eosw_desc *d;
+
+	d = &eosw_txq->desc[eosw_txq->last_cidx];
+	while (ndesc--) {
+		if (d->skb) {
+			if (d->addr[0]) {
+				unmap_skb(adap->pdev_dev, d->skb, d->addr);
+				memset(d->addr, 0, sizeof(d->addr));
+			}
+			dev_consume_skb_any(d->skb);
+			d->skb = NULL;
+		}
+		eosw_txq_advance_index(&eosw_txq->last_cidx, 1,
+				       eosw_txq->ndesc);
+		d = &eosw_txq->desc[eosw_txq->last_cidx];
+	}
+}
+
+static netdev_tx_t cxgb4_ethofld_xmit(struct sk_buff *skb,
+				      struct net_device *dev)
+{
+	int ret;
+
+	ret = cxgb4_validate_skb(skb, dev, ETH_HLEN);
+	if (ret)
+		goto out_free;
+
+out_free:
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+}
+
 netdev_tx_t t4_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct port_info *pi = netdev_priv(dev);
+	u16 qid = skb_get_queue_mapping(skb);
 
 	if (unlikely(pi->eth_flags & PRIV_FLAG_PORT_TX_VM))
 		return cxgb4_vf_eth_xmit(skb, dev);
 
+	if (unlikely(qid >= pi->nqsets))
+		return cxgb4_ethofld_xmit(skb, dev);
+
 	return cxgb4_eth_xmit(skb, dev);
 }
 
@@ -3311,6 +3365,22 @@ static int napi_rx_handler(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
+void cxgb4_ethofld_restart(unsigned long data)
+{
+	struct sge_eosw_txq *eosw_txq = (struct sge_eosw_txq *)data;
+	int pktcount;
+
+	spin_lock(&eosw_txq->lock);
+	pktcount = eosw_txq->cidx - eosw_txq->last_cidx;
+	if (pktcount < 0)
+		pktcount += eosw_txq->ndesc;
+
+	if (pktcount)
+		cxgb4_eosw_txq_free_desc(netdev2adap(eosw_txq->netdev),
+					 eosw_txq, pktcount);
+	spin_unlock(&eosw_txq->lock);
+}
+
 /*
  * The MSI-X interrupt handler for an SGE response queue.
  */
-- 
2.23.0

