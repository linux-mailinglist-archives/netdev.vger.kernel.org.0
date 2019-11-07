Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C59F3421
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388901AbfKGQHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:07:31 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:56853 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388761AbfKGQHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:07:31 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA7G7QA2024019;
        Thu, 7 Nov 2019 08:07:27 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 2/6] cxgb4: rework queue config and MSI-X allocation
Date:   Thu,  7 Nov 2019 21:29:05 +0530
Message-Id: <d67d31f4341147da852cb08bc5a5bdd3b7121525.1573140612.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
References: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify queue configuration and MSI-X allocation logic. Use a single
MSI-X information table for both NIC and ULDs. Remove hard-coded
MSI-X indices for firmware event queue and non data interrupts.
Instead, use the MSI-X bitmap to obtain a free MSI-X index
dynamically. Save each Rxq's index into the MSI-X information table,
within the Rxq structures themselves, for easier cleanup.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  24 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 437 +++++++++++-------
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    |  95 +---
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  13 +-
 4 files changed, 323 insertions(+), 246 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index f2f643be7905..dbfde3fbfce4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -712,6 +712,7 @@ struct sge_eth_rxq {                /* SW Ethernet Rx queue */
 	struct sge_rspq rspq;
 	struct sge_fl fl;
 	struct sge_eth_stats stats;
+	struct msix_info *msix;
 } ____cacheline_aligned_in_smp;
 
 struct sge_ofld_stats {             /* offload queue statistics */
@@ -725,6 +726,7 @@ struct sge_ofld_rxq {               /* SW offload Rx queue */
 	struct sge_rspq rspq;
 	struct sge_fl fl;
 	struct sge_ofld_stats stats;
+	struct msix_info *msix;
 } ____cacheline_aligned_in_smp;
 
 struct tx_desc {
@@ -789,7 +791,6 @@ struct sge_ctrl_txq {               /* state for an SGE control Tx queue */
 struct sge_uld_rxq_info {
 	char name[IFNAMSIZ];	/* name of ULD driver */
 	struct sge_ofld_rxq *uldrxq; /* Rxq's for ULD */
-	u16 *msix_tbl;		/* msix_tbl for uld */
 	u16 *rspq_id;		/* response queue id's of rxq */
 	u16 nrxq;		/* # of ingress uld queues */
 	u16 nciq;		/* # of completion queues */
@@ -842,6 +843,9 @@ struct sge {
 	unsigned long *blocked_fl;
 	struct timer_list rx_timer; /* refills starving FLs */
 	struct timer_list tx_timer; /* checks Tx queues */
+
+	int fwevtq_msix_idx; /* Index to firmware event queue MSI-X info */
+	int nd_msix_idx; /* Index to non-data interrupts MSI-X info */
 };
 
 #define for_each_ethrxq(sge, i) for (i = 0; i < (sge)->ethqsets; i++)
@@ -871,13 +875,13 @@ struct hash_mac_addr {
 	unsigned int iface_mac;
 };
 
-struct uld_msix_bmap {
+struct msix_bmap {
 	unsigned long *msix_bmap;
 	unsigned int mapsize;
 	spinlock_t lock; /* lock for acquiring bitmap */
 };
 
-struct uld_msix_info {
+struct msix_info {
 	unsigned short vec;
 	char desc[IFNAMSIZ + 10];
 	unsigned int idx;
@@ -946,14 +950,9 @@ struct adapter {
 	struct cxgb4_virt_res vres;
 	unsigned int swintr;
 
-	struct msix_info {
-		unsigned short vec;
-		char desc[IFNAMSIZ + 10];
-		cpumask_var_t aff_mask;
-	} msix_info[MAX_INGQ + 1];
-	struct uld_msix_info *msix_info_ulds; /* msix info for uld's */
-	struct uld_msix_bmap msix_bmap_ulds; /* msix bitmap for all uld */
-	int msi_idx;
+	/* MSI-X Info for NIC and OFLD queues */
+	struct msix_info *msix_info;
+	struct msix_bmap msix_bmap;
 
 	struct doorbell_stats db_stats;
 	struct sge sge;
@@ -1954,5 +1953,6 @@ int cxgb4_alloc_raw_mac_filt(struct adapter *adap,
 int cxgb4_update_mac_filt(struct port_info *pi, unsigned int viid,
 			  int *tcam_idx, const u8 *addr,
 			  bool persistent, u8 *smt_idx);
-
+int cxgb4_get_msix_idx_from_bmap(struct adapter *adap);
+void cxgb4_free_msix_idx_in_bmap(struct adapter *adap, u32 msix_idx);
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 20d1687adea2..d8a1bd80b293 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -685,31 +685,6 @@ static irqreturn_t t4_nondata_intr(int irq, void *cookie)
 	return IRQ_HANDLED;
 }
 
-/*
- * Name the MSI-X interrupts.
- */
-static void name_msix_vecs(struct adapter *adap)
-{
-	int i, j, msi_idx = 2, n = sizeof(adap->msix_info[0].desc);
-
-	/* non-data interrupts */
-	snprintf(adap->msix_info[0].desc, n, "%s", adap->port[0]->name);
-
-	/* FW events */
-	snprintf(adap->msix_info[1].desc, n, "%s-FWeventq",
-		 adap->port[0]->name);
-
-	/* Ethernet queues */
-	for_each_port(adap, j) {
-		struct net_device *d = adap->port[j];
-		const struct port_info *pi = netdev_priv(d);
-
-		for (i = 0; i < pi->nqsets; i++, msi_idx++)
-			snprintf(adap->msix_info[msi_idx].desc, n, "%s-Rx%d",
-				 d->name, i);
-	}
-}
-
 int cxgb4_set_msix_aff(struct adapter *adap, unsigned short vec,
 		       cpumask_var_t *aff_mask, int idx)
 {
@@ -743,15 +718,19 @@ static int request_msix_queue_irqs(struct adapter *adap)
 	struct sge *s = &adap->sge;
 	struct msix_info *minfo;
 	int err, ethqidx;
-	int msi_index = 2;
 
-	err = request_irq(adap->msix_info[1].vec, t4_sge_intr_msix, 0,
-			  adap->msix_info[1].desc, &s->fw_evtq);
+	if (s->fwevtq_msix_idx < 0)
+		return -ENOMEM;
+
+	err = request_irq(adap->msix_info[s->fwevtq_msix_idx].vec,
+			  t4_sge_intr_msix, 0,
+			  adap->msix_info[s->fwevtq_msix_idx].desc,
+			  &s->fw_evtq);
 	if (err)
 		return err;
 
 	for_each_ethrxq(s, ethqidx) {
-		minfo = &adap->msix_info[msi_index];
+		minfo = s->ethrxq[ethqidx].msix;
 		err = request_irq(minfo->vec,
 				  t4_sge_intr_msix, 0,
 				  minfo->desc,
@@ -761,18 +740,16 @@ static int request_msix_queue_irqs(struct adapter *adap)
 
 		cxgb4_set_msix_aff(adap, minfo->vec,
 				   &minfo->aff_mask, ethqidx);
-		msi_index++;
 	}
 	return 0;
 
 unwind:
 	while (--ethqidx >= 0) {
-		msi_index--;
-		minfo = &adap->msix_info[msi_index];
+		minfo = s->ethrxq[ethqidx].msix;
 		cxgb4_clear_msix_aff(minfo->vec, minfo->aff_mask);
 		free_irq(minfo->vec, &s->ethrxq[ethqidx].rspq);
 	}
-	free_irq(adap->msix_info[1].vec, &s->fw_evtq);
+	free_irq(adap->msix_info[s->fwevtq_msix_idx].vec, &s->fw_evtq);
 	return err;
 }
 
@@ -780,11 +757,11 @@ static void free_msix_queue_irqs(struct adapter *adap)
 {
 	struct sge *s = &adap->sge;
 	struct msix_info *minfo;
-	int i, msi_index = 2;
+	int i;
 
-	free_irq(adap->msix_info[1].vec, &s->fw_evtq);
+	free_irq(adap->msix_info[s->fwevtq_msix_idx].vec, &s->fw_evtq);
 	for_each_ethrxq(s, i) {
-		minfo = &adap->msix_info[msi_index++];
+		minfo = s->ethrxq[i].msix;
 		cxgb4_clear_msix_aff(minfo->vec, minfo->aff_mask);
 		free_irq(minfo->vec, &s->ethrxq[i].rspq);
 	}
@@ -919,11 +896,14 @@ static void quiesce_rx(struct adapter *adap)
 /* Disable interrupt and napi handler */
 static void disable_interrupts(struct adapter *adap)
 {
+	struct sge *s = &adap->sge;
+
 	if (adap->flags & CXGB4_FULL_INIT_DONE) {
 		t4_intr_disable(adap);
 		if (adap->flags & CXGB4_USING_MSIX) {
 			free_msix_queue_irqs(adap);
-			free_irq(adap->msix_info[0].vec, adap);
+			free_irq(adap->msix_info[s->nd_msix_idx].vec,
+				 adap);
 		} else {
 			free_irq(adap->pdev->irq, adap);
 		}
@@ -953,27 +933,58 @@ static void enable_rx(struct adapter *adap)
 	}
 }
 
+static int setup_non_data_intr(struct adapter *adap)
+{
+	int msix;
+
+	adap->sge.nd_msix_idx = -1;
+	if (!(adap->flags & CXGB4_USING_MSIX))
+		return 0;
+
+	/* Request MSI-X vector for non-data interrupt */
+	msix = cxgb4_get_msix_idx_from_bmap(adap);
+	if (msix < 0)
+		return -ENOMEM;
+
+	snprintf(adap->msix_info[msix].desc,
+		 sizeof(adap->msix_info[msix].desc),
+		 "%s", adap->port[0]->name);
+
+	adap->sge.nd_msix_idx = msix;
+	return 0;
+}
 
 static int setup_fw_sge_queues(struct adapter *adap)
 {
 	struct sge *s = &adap->sge;
-	int err = 0;
+	int msix, err = 0;
 
 	bitmap_zero(s->starving_fl, s->egr_sz);
 	bitmap_zero(s->txq_maperr, s->egr_sz);
 
-	if (adap->flags & CXGB4_USING_MSIX)
-		adap->msi_idx = 1;         /* vector 0 is for non-queue interrupts */
-	else {
+	if (adap->flags & CXGB4_USING_MSIX) {
+		s->fwevtq_msix_idx = -1;
+		msix = cxgb4_get_msix_idx_from_bmap(adap);
+		if (msix < 0)
+			return -ENOMEM;
+
+		snprintf(adap->msix_info[msix].desc,
+			 sizeof(adap->msix_info[msix].desc),
+			 "%s-FWeventq", adap->port[0]->name);
+	} else {
 		err = t4_sge_alloc_rxq(adap, &s->intrq, false, adap->port[0], 0,
 				       NULL, NULL, NULL, -1);
 		if (err)
 			return err;
-		adap->msi_idx = -((int)s->intrq.abs_id + 1);
+		msix = -((int)s->intrq.abs_id + 1);
 	}
 
 	err = t4_sge_alloc_rxq(adap, &s->fw_evtq, true, adap->port[0],
-			       adap->msi_idx, NULL, fwevtq_handler, NULL, -1);
+			       msix, NULL, fwevtq_handler, NULL, -1);
+	if (err && msix >= 0)
+		cxgb4_free_msix_idx_in_bmap(adap, msix);
+
+	s->fwevtq_msix_idx = msix;
 	return err;
 }
 
@@ -987,14 +998,17 @@ static int setup_fw_sge_queues(struct adapter *adap)
  */
 static int setup_sge_queues(struct adapter *adap)
 {
-	int err, i, j;
-	struct sge *s = &adap->sge;
 	struct sge_uld_rxq_info *rxq_info = NULL;
+	struct sge *s = &adap->sge;
 	unsigned int cmplqid = 0;
+	int err, i, j, msix = 0;
 
 	if (is_uld(adap))
 		rxq_info = s->uld_rxq_info[CXGB4_ULD_RDMA];
 
+	if (!(adap->flags & CXGB4_USING_MSIX))
+		msix = -((int)s->intrq.abs_id + 1);
+
 	for_each_port(adap, i) {
 		struct net_device *dev = adap->port[i];
 		struct port_info *pi = netdev_priv(dev);
@@ -1002,10 +1016,21 @@ static int setup_sge_queues(struct adapter *adap)
 		struct sge_eth_txq *t = &s->ethtxq[pi->first_qset];
 
 		for (j = 0; j < pi->nqsets; j++, q++) {
-			if (adap->msi_idx > 0)
-				adap->msi_idx++;
+			if (msix >= 0) {
+				msix = cxgb4_get_msix_idx_from_bmap(adap);
+				if (msix < 0) {
+					err = msix;
+					goto freeout;
+				}
+
+				snprintf(adap->msix_info[msix].desc,
+					 sizeof(adap->msix_info[msix].desc),
+					 "%s-Rx%d", dev->name, j);
+				q->msix = &adap->msix_info[msix];
+			}
+
 			err = t4_sge_alloc_rxq(adap, &q->rspq, false, dev,
-					       adap->msi_idx, &q->fl,
+					       msix, &q->fl,
 					       t4_ethrx_handler,
 					       NULL,
 					       t4_get_tp_ch_map(adap,
@@ -2372,6 +2397,7 @@ static void update_clip(const struct adapter *adap)
  */
 static int cxgb_up(struct adapter *adap)
 {
+	struct sge *s = &adap->sge;
 	int err;
 
 	mutex_lock(&uld_mutex);
@@ -2383,16 +2409,20 @@ static int cxgb_up(struct adapter *adap)
 		goto freeq;
 
 	if (adap->flags & CXGB4_USING_MSIX) {
-		name_msix_vecs(adap);
-		err = request_irq(adap->msix_info[0].vec, t4_nondata_intr, 0,
-				  adap->msix_info[0].desc, adap);
+		if (s->nd_msix_idx < 0) {
+			err = -ENOMEM;
+			goto irq_err;
+		}
+
+		err = request_irq(adap->msix_info[s->nd_msix_idx].vec,
+				  t4_nondata_intr, 0,
+				  adap->msix_info[s->nd_msix_idx].desc, adap);
 		if (err)
 			goto irq_err;
+
 		err = request_msix_queue_irqs(adap);
-		if (err) {
-			free_irq(adap->msix_info[0].vec, adap);
-			goto irq_err;
-		}
+		if (err)
+			goto irq_err_free_nd_msix;
 	} else {
 		err = request_irq(adap->pdev->irq, t4_intr_handler(adap),
 				  (adap->flags & CXGB4_USING_MSI) ? 0
@@ -2414,11 +2444,13 @@ static int cxgb_up(struct adapter *adap)
 #endif
 	return err;
 
- irq_err:
+irq_err_free_nd_msix:
+	free_irq(adap->msix_info[s->nd_msix_idx].vec, adap);
+irq_err:
 	dev_err(adap->pdev_dev, "request_irq failed, err %d\n", err);
- freeq:
+freeq:
 	t4_free_sge_resources(adap);
- rel_lock:
+rel_lock:
 	mutex_unlock(&uld_mutex);
 	return err;
 }
@@ -5187,26 +5219,25 @@ static inline bool is_x_10g_port(const struct link_config *lc)
 	return high_speeds != 0;
 }
 
-/*
- * Perform default configuration of DMA queues depending on the number and type
+/* Perform default configuration of DMA queues depending on the number and type
  * of ports we found and the number of available CPUs.  Most settings can be
  * modified by the admin prior to actual use.
  */
 static int cfg_queues(struct adapter *adap)
 {
+	u32 avail_qsets, avail_eth_qsets, avail_uld_qsets;
+	u32 niqflint, neq, num_ulds;
 	struct sge *s = &adap->sge;
-	int i, n10g = 0, qidx = 0;
-	int niqflint, neq, avail_eth_qsets;
-	int max_eth_qsets = 32;
+	u32 i, n10g = 0, qidx = 0;
 #ifndef CONFIG_CHELSIO_T4_DCB
 	int q10g = 0;
 #endif
 
-	/* Reduce memory usage in kdump environment, disable all offload.
-	 */
+	/* Reduce memory usage in kdump environment, disable all offload. */
 	if (is_kdump_kernel() || (is_uld(adap) && t4_uld_mem_alloc(adap))) {
 		adap->params.offload = 0;
 		adap->params.crypto = 0;
+		adap->params.ethofld = 0;
 	}
 
 	/* Calculate the number of Ethernet Queue Sets available based on
@@ -5225,14 +5256,11 @@ static int cfg_queues(struct adapter *adap)
 	if (!(adap->flags & CXGB4_USING_MSIX))
 		niqflint--;
 	neq = adap->params.pfres.neq / 2;
-	avail_eth_qsets = min(niqflint, neq);
+	avail_qsets = min(niqflint, neq);
 
-	if (avail_eth_qsets > max_eth_qsets)
-		avail_eth_qsets = max_eth_qsets;
-
-	if (avail_eth_qsets < adap->params.nports) {
+	if (avail_qsets < adap->params.nports) {
 		dev_err(adap->pdev_dev, "avail_eth_qsets=%d < nports=%d\n",
-			avail_eth_qsets, adap->params.nports);
+			avail_qsets, adap->params.nports);
 		return -ENOMEM;
 	}
 
@@ -5240,6 +5268,7 @@ static int cfg_queues(struct adapter *adap)
 	for_each_port(adap, i)
 		n10g += is_x_10g_port(&adap2pinfo(adap, i)->link_cfg);
 
+	avail_eth_qsets = min_t(u32, avail_qsets, MAX_ETH_QSETS);
 #ifdef CONFIG_CHELSIO_T4_DCB
 	/* For Data Center Bridging support we need to be able to support up
 	 * to 8 Traffic Priorities; each of which will be assigned to its
@@ -5259,8 +5288,7 @@ static int cfg_queues(struct adapter *adap)
 		qidx += pi->nqsets;
 	}
 #else /* !CONFIG_CHELSIO_T4_DCB */
-	/*
-	 * We default to 1 queue per non-10G port and up to # of cores queues
+	/* We default to 1 queue per non-10G port and up to # of cores queues
 	 * per 10G port.
 	 */
 	if (n10g)
@@ -5282,19 +5310,27 @@ static int cfg_queues(struct adapter *adap)
 
 	s->ethqsets = qidx;
 	s->max_ethqsets = qidx;   /* MSI-X may lower it later */
+	avail_qsets -= qidx;
 
 	if (is_uld(adap)) {
-		/*
-		 * For offload we use 1 queue/channel if all ports are up to 1G,
+		/* For offload we use 1 queue/channel if all ports are up to 1G,
 		 * otherwise we divide all available queues amongst the channels
 		 * capped by the number of available cores.
 		 */
-		if (n10g) {
-			i = min_t(int, MAX_OFLD_QSETS, num_online_cpus());
-			s->ofldqsets = roundup(i, adap->params.nports);
-		} else {
+		num_ulds = adap->num_uld + adap->num_ofld_uld;
+		i = min_t(u32, MAX_OFLD_QSETS, num_online_cpus());
+		avail_uld_qsets = roundup(i, adap->params.nports);
+		if (avail_qsets < num_ulds * adap->params.nports) {
+			adap->params.offload = 0;
+			adap->params.crypto = 0;
+			s->ofldqsets = 0;
+		} else if (avail_qsets < num_ulds * avail_uld_qsets || !n10g) {
 			s->ofldqsets = adap->params.nports;
+		} else {
+			s->ofldqsets = avail_uld_qsets;
 		}
+
+		avail_qsets -= num_ulds * s->ofldqsets;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(s->ethrxq); i++) {
@@ -5347,42 +5383,62 @@ static void reduce_ethqs(struct adapter *adap, int n)
 	}
 }
 
-static int get_msix_info(struct adapter *adap)
+static int alloc_msix_info(struct adapter *adap, u32 num_vec)
 {
-	struct uld_msix_info *msix_info;
-	unsigned int max_ingq = 0;
-
-	if (is_offload(adap))
-		max_ingq += MAX_OFLD_QSETS * adap->num_ofld_uld;
-	if (is_pci_uld(adap))
-		max_ingq += MAX_OFLD_QSETS * adap->num_uld;
-
-	if (!max_ingq)
-		goto out;
+	struct msix_info *msix_info;
 
-	msix_info = kcalloc(max_ingq, sizeof(*msix_info), GFP_KERNEL);
+	msix_info = kcalloc(num_vec, sizeof(*msix_info), GFP_KERNEL);
 	if (!msix_info)
 		return -ENOMEM;
 
-	adap->msix_bmap_ulds.msix_bmap = kcalloc(BITS_TO_LONGS(max_ingq),
-						 sizeof(long), GFP_KERNEL);
-	if (!adap->msix_bmap_ulds.msix_bmap) {
+	adap->msix_bmap.msix_bmap = kcalloc(BITS_TO_LONGS(num_vec),
+					    sizeof(long), GFP_KERNEL);
+	if (!adap->msix_bmap.msix_bmap) {
 		kfree(msix_info);
 		return -ENOMEM;
 	}
-	spin_lock_init(&adap->msix_bmap_ulds.lock);
-	adap->msix_info_ulds = msix_info;
-out:
+
+	spin_lock_init(&adap->msix_bmap.lock);
+	adap->msix_bmap.mapsize = num_vec;
+
+	adap->msix_info = msix_info;
 	return 0;
 }
 
 static void free_msix_info(struct adapter *adap)
 {
-	if (!(adap->num_uld && adap->num_ofld_uld))
-		return;
+	kfree(adap->msix_bmap.msix_bmap);
+	kfree(adap->msix_info);
+}
+
+int cxgb4_get_msix_idx_from_bmap(struct adapter *adap)
+{
+	struct msix_bmap *bmap = &adap->msix_bmap;
+	unsigned int msix_idx;
+	unsigned long flags;
 
-	kfree(adap->msix_info_ulds);
-	kfree(adap->msix_bmap_ulds.msix_bmap);
+	spin_lock_irqsave(&bmap->lock, flags);
+	msix_idx = find_first_zero_bit(bmap->msix_bmap, bmap->mapsize);
+	if (msix_idx < bmap->mapsize) {
+		__set_bit(msix_idx, bmap->msix_bmap);
+	} else {
+		spin_unlock_irqrestore(&bmap->lock, flags);
+		return -ENOSPC;
+	}
+
+	spin_unlock_irqrestore(&bmap->lock, flags);
+	return msix_idx;
+}
+
+void cxgb4_free_msix_idx_in_bmap(struct adapter *adap,
+				 unsigned int msix_idx)
+{
+	struct msix_bmap *bmap = &adap->msix_bmap;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bmap->lock, flags);
+	__clear_bit(msix_idx, bmap->msix_bmap);
+	spin_unlock_irqrestore(&bmap->lock, flags);
 }
 
 /* 2 MSI-X vectors needed for the FW queue and non-data interrupts */
@@ -5390,88 +5446,142 @@ static void free_msix_info(struct adapter *adap)
 
 static int enable_msix(struct adapter *adap)
 {
-	int ofld_need = 0, uld_need = 0;
-	int i, j, want, need, allocated;
+	u8 num_uld = 0, nchan = adap->params.nports;
+	u32 ethqsets = 0, ofldqsets = 0;
+	u32 eth_need, uld_need = 0;
+	u32 i, want, need, num_vec;
 	struct sge *s = &adap->sge;
-	unsigned int nchan = adap->params.nports;
 	struct msix_entry *entries;
-	int max_ingq = MAX_INGQ;
-
-	if (is_pci_uld(adap))
-		max_ingq += (MAX_OFLD_QSETS * adap->num_uld);
-	if (is_offload(adap))
-		max_ingq += (MAX_OFLD_QSETS * adap->num_ofld_uld);
-	entries = kmalloc_array(max_ingq + 1, sizeof(*entries),
-				GFP_KERNEL);
-	if (!entries)
-		return -ENOMEM;
-
-	/* map for msix */
-	if (get_msix_info(adap)) {
-		adap->params.offload = 0;
-		adap->params.crypto = 0;
-	}
-
-	for (i = 0; i < max_ingq + 1; ++i)
-		entries[i].entry = i;
+	struct port_info *pi;
+	int allocated, ret;
 
-	want = s->max_ethqsets + EXTRA_VECS;
-	if (is_offload(adap)) {
-		want += adap->num_ofld_uld * s->ofldqsets;
-		ofld_need = adap->num_ofld_uld * nchan;
-	}
-	if (is_pci_uld(adap)) {
-		want += adap->num_uld * s->ofldqsets;
-		uld_need = adap->num_uld * nchan;
-	}
+	want = s->max_ethqsets;
 #ifdef CONFIG_CHELSIO_T4_DCB
 	/* For Data Center Bridging we need 8 Ethernet TX Priority Queues for
 	 * each port.
 	 */
-	need = 8 * adap->params.nports + EXTRA_VECS + ofld_need + uld_need;
+	need = 8 * nchan;
 #else
-	need = adap->params.nports + EXTRA_VECS + ofld_need + uld_need;
+	need = nchan;
 #endif
+	eth_need = need;
+	if (is_uld(adap)) {
+		num_uld = adap->num_ofld_uld + adap->num_uld;
+		want += num_uld * s->ofldqsets;
+		uld_need = num_uld * nchan;
+		need += uld_need;
+	}
+
+	want += EXTRA_VECS;
+	need += EXTRA_VECS;
+
+	entries = kmalloc_array(want, sizeof(*entries), GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	for (i = 0; i < want; i++)
+		entries[i].entry = i;
+
 	allocated = pci_enable_msix_range(adap->pdev, entries, need, want);
 	if (allocated < 0) {
-		dev_info(adap->pdev_dev, "not enough MSI-X vectors left,"
-			 " not using MSI-X\n");
-		kfree(entries);
-		return allocated;
+		/* Disable offload and attempt to get vectors for NIC
+		 * only mode.
+		 */
+		want = s->max_ethqsets + EXTRA_VECS;
+		need = eth_need + EXTRA_VECS;
+		allocated = pci_enable_msix_range(adap->pdev, entries,
+						  need, want);
+		if (allocated < 0) {
+			dev_info(adap->pdev_dev,
+				 "Disabling MSI-X due to insufficient MSI-X vectors\n");
+			ret = allocated;
+			goto out_free;
+		}
+
+		dev_info(adap->pdev_dev,
+			 "Disabling offload due to insufficient MSI-X vectors\n");
+		adap->params.offload = 0;
+		adap->params.crypto = 0;
+		adap->params.ethofld = 0;
+		s->ofldqsets = 0;
+		uld_need = 0;
 	}
 
-	/* Distribute available vectors to the various queue groups.
-	 * Every group gets its minimum requirement and NIC gets top
-	 * priority for leftovers.
-	 */
-	i = allocated - EXTRA_VECS - ofld_need - uld_need;
-	if (i < s->max_ethqsets) {
-		s->max_ethqsets = i;
-		if (i < s->ethqsets)
-			reduce_ethqs(adap, i);
+	num_vec = allocated;
+	if (num_vec < want) {
+		/* Distribute available vectors to the various queue groups.
+		 * Every group gets its minimum requirement and NIC gets top
+		 * priority for leftovers.
+		 */
+		ethqsets = eth_need;
+		if (is_uld(adap))
+			ofldqsets = nchan;
+
+		num_vec -= need;
+		while (num_vec) {
+			if (num_vec < eth_need ||
+			    ethqsets > s->max_ethqsets)
+				break;
+
+			for_each_port(adap, i) {
+				pi = adap2pinfo(adap, i);
+				if (pi->nqsets < 2)
+					continue;
+
+				ethqsets++;
+				num_vec--;
+			}
+		}
+
+		if (is_uld(adap)) {
+			while (num_vec) {
+				if (num_vec < uld_need ||
+				    ofldqsets > s->ofldqsets)
+					break;
+
+				ofldqsets++;
+				num_vec -= uld_need;
+			}
+		}
+	} else {
+		ethqsets = s->max_ethqsets;
+		if (is_uld(adap))
+			ofldqsets = s->ofldqsets;
+	}
+
+	if (ethqsets < s->max_ethqsets) {
+		s->max_ethqsets = ethqsets;
+		reduce_ethqs(adap, ethqsets);
 	}
+
 	if (is_uld(adap)) {
-		if (allocated < want)
-			s->nqs_per_uld = nchan;
-		else
-			s->nqs_per_uld = s->ofldqsets;
+		s->ofldqsets = ofldqsets;
+		s->nqs_per_uld = s->ofldqsets;
 	}
 
-	for (i = 0; i < (s->max_ethqsets + EXTRA_VECS); ++i)
+	/* map for msix */
+	ret = alloc_msix_info(adap, allocated);
+	if (ret)
+		goto out_disable_msix;
+
+	for (i = 0; i < allocated; i++) {
 		adap->msix_info[i].vec = entries[i].vector;
-	if (is_uld(adap)) {
-		for (j = 0 ; i < allocated; ++i, j++) {
-			adap->msix_info_ulds[j].vec = entries[i].vector;
-			adap->msix_info_ulds[j].idx = i;
-		}
-		adap->msix_bmap_ulds.mapsize = j;
+		adap->msix_info[i].idx = i;
 	}
-	dev_info(adap->pdev_dev, "%d MSI-X vectors allocated, "
-		 "nic %d per uld %d\n",
+
+	dev_info(adap->pdev_dev,
+		 "%d MSI-X vectors allocated, nic %d per uld %d\n",
 		 allocated, s->max_ethqsets, s->nqs_per_uld);
 
 	kfree(entries);
 	return 0;
+
+out_disable_msix:
+	pci_disable_msix(adap->pdev);
+
+out_free:
+	kfree(entries);
+	return ret;
 }
 
 #undef EXTRA_VECS
@@ -6163,6 +6273,13 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto out_free_dev;
 
+	err = setup_non_data_intr(adapter);
+	if (err) {
+		dev_err(adapter->pdev_dev,
+			"Non Data interrupt allocation failed, err: %d\n", err);
+		goto out_free_dev;
+	}
+
 	err = setup_fw_sge_queues(adapter);
 	if (err) {
 		dev_err(adapter->pdev_dev,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 86b528d8364c..3d9401354af2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -53,35 +53,6 @@
 
 #define for_each_uldrxq(m, i) for (i = 0; i < ((m)->nrxq + (m)->nciq); i++)
 
-static int get_msix_idx_from_bmap(struct adapter *adap)
-{
-	struct uld_msix_bmap *bmap = &adap->msix_bmap_ulds;
-	unsigned long flags;
-	unsigned int msix_idx;
-
-	spin_lock_irqsave(&bmap->lock, flags);
-	msix_idx = find_first_zero_bit(bmap->msix_bmap, bmap->mapsize);
-	if (msix_idx < bmap->mapsize) {
-		__set_bit(msix_idx, bmap->msix_bmap);
-	} else {
-		spin_unlock_irqrestore(&bmap->lock, flags);
-		return -ENOSPC;
-	}
-
-	spin_unlock_irqrestore(&bmap->lock, flags);
-	return msix_idx;
-}
-
-static void free_msix_idx_in_bmap(struct adapter *adap, unsigned int msix_idx)
-{
-	struct uld_msix_bmap *bmap = &adap->msix_bmap_ulds;
-	unsigned long flags;
-
-	spin_lock_irqsave(&bmap->lock, flags);
-	__clear_bit(msix_idx, bmap->msix_bmap);
-	spin_unlock_irqrestore(&bmap->lock, flags);
-}
-
 /* Flush the aggregated lro sessions */
 static void uldrx_flush_handler(struct sge_rspq *q)
 {
@@ -138,9 +109,9 @@ static int alloc_uld_rxqs(struct adapter *adap,
 			  struct sge_uld_rxq_info *rxq_info, bool lro)
 {
 	unsigned int nq = rxq_info->nrxq + rxq_info->nciq;
-	int i, err, msi_idx, que_idx = 0, bmap_idx = 0;
 	struct sge_ofld_rxq *q = rxq_info->uldrxq;
 	unsigned short *ids = rxq_info->rspq_id;
+	int i, err, msi_idx, que_idx = 0;
 	struct sge *s = &adap->sge;
 	unsigned int per_chan;
 
@@ -159,12 +130,18 @@ static int alloc_uld_rxqs(struct adapter *adap,
 		}
 
 		if (msi_idx >= 0) {
-			bmap_idx = get_msix_idx_from_bmap(adap);
-			if (bmap_idx < 0) {
+			msi_idx = cxgb4_get_msix_idx_from_bmap(adap);
+			if (msi_idx < 0) {
 				err = -ENOSPC;
 				goto freeout;
 			}
-			msi_idx = adap->msix_info_ulds[bmap_idx].idx;
+
+			snprintf(adap->msix_info[msi_idx].desc,
+				 sizeof(adap->msix_info[msi_idx].desc),
+				 "%s-%s%d",
+				 adap->port[0]->name, rxq_info->name, i);
+
+			q->msix = &adap->msix_info[msi_idx];
 		}
 		err = t4_sge_alloc_rxq(adap, &q->rspq, false,
 				       adap->port[que_idx++ / per_chan],
@@ -175,8 +152,7 @@ static int alloc_uld_rxqs(struct adapter *adap,
 				       0);
 		if (err)
 			goto freeout;
-		if (msi_idx >= 0)
-			rxq_info->msix_tbl[i] = bmap_idx;
+
 		memset(&q->stats, 0, sizeof(q->stats));
 		if (ids)
 			ids[i] = q->rspq.abs_id;
@@ -188,6 +164,8 @@ static int alloc_uld_rxqs(struct adapter *adap,
 		if (q->rspq.desc)
 			free_rspq_fl(adap, &q->rspq,
 				     q->fl.size ? &q->fl : NULL);
+		if (q->msix)
+			cxgb4_free_msix_idx_in_bmap(adap, q->msix->idx);
 	}
 	return err;
 }
@@ -198,14 +176,6 @@ setup_sge_queues_uld(struct adapter *adap, unsigned int uld_type, bool lro)
 	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
 	int i, ret = 0;
 
-	if (adap->flags & CXGB4_USING_MSIX) {
-		rxq_info->msix_tbl = kcalloc((rxq_info->nrxq + rxq_info->nciq),
-					     sizeof(unsigned short),
-					     GFP_KERNEL);
-		if (!rxq_info->msix_tbl)
-			return -ENOMEM;
-	}
-
 	ret = !(!alloc_uld_rxqs(adap, rxq_info, lro));
 
 	/* Tell uP to route control queue completions to rdma rspq */
@@ -261,8 +231,6 @@ static void free_sge_queues_uld(struct adapter *adap, unsigned int uld_type)
 		t4_free_uld_rxqs(adap, rxq_info->nciq,
 				 rxq_info->uldrxq + rxq_info->nrxq);
 	t4_free_uld_rxqs(adap, rxq_info->nrxq, rxq_info->uldrxq);
-	if (adap->flags & CXGB4_USING_MSIX)
-		kfree(rxq_info->msix_tbl);
 }
 
 static int cfg_queues_uld(struct adapter *adap, unsigned int uld_type,
@@ -355,13 +323,12 @@ static int
 request_msix_queue_irqs_uld(struct adapter *adap, unsigned int uld_type)
 {
 	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
-	struct uld_msix_info *minfo;
+	struct msix_info *minfo;
+	unsigned int idx;
 	int err = 0;
-	unsigned int idx, bmap_idx;
 
 	for_each_uldrxq(rxq_info, idx) {
-		bmap_idx = rxq_info->msix_tbl[idx];
-		minfo = &adap->msix_info_ulds[bmap_idx];
+		minfo = rxq_info->uldrxq[idx].msix;
 		err = request_irq(minfo->vec,
 				  t4_sge_intr_msix, 0,
 				  minfo->desc,
@@ -376,10 +343,9 @@ request_msix_queue_irqs_uld(struct adapter *adap, unsigned int uld_type)
 
 unwind:
 	while (idx-- > 0) {
-		bmap_idx = rxq_info->msix_tbl[idx];
-		minfo = &adap->msix_info_ulds[bmap_idx];
+		minfo = rxq_info->uldrxq[idx].msix;
 		cxgb4_clear_msix_aff(minfo->vec, minfo->aff_mask);
-		free_msix_idx_in_bmap(adap, bmap_idx);
+		cxgb4_free_msix_idx_in_bmap(adap, minfo->idx);
 		free_irq(minfo->vec, &rxq_info->uldrxq[idx].rspq);
 	}
 	return err;
@@ -389,33 +355,17 @@ static void
 free_msix_queue_irqs_uld(struct adapter *adap, unsigned int uld_type)
 {
 	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
-	struct uld_msix_info *minfo;
-	unsigned int idx, bmap_idx;
+	struct msix_info *minfo;
+	unsigned int idx;
 
 	for_each_uldrxq(rxq_info, idx) {
-		bmap_idx = rxq_info->msix_tbl[idx];
-		minfo = &adap->msix_info_ulds[bmap_idx];
-
+		minfo = rxq_info->uldrxq[idx].msix;
 		cxgb4_clear_msix_aff(minfo->vec, minfo->aff_mask);
-		free_msix_idx_in_bmap(adap, bmap_idx);
+		cxgb4_free_msix_idx_in_bmap(adap, minfo->idx);
 		free_irq(minfo->vec, &rxq_info->uldrxq[idx].rspq);
 	}
 }
 
-static void name_msix_vecs_uld(struct adapter *adap, unsigned int uld_type)
-{
-	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
-	int n = sizeof(adap->msix_info_ulds[0].desc);
-	unsigned int idx, bmap_idx;
-
-	for_each_uldrxq(rxq_info, idx) {
-		bmap_idx = rxq_info->msix_tbl[idx];
-
-		snprintf(adap->msix_info_ulds[bmap_idx].desc, n, "%s-%s%d",
-			 adap->port[0]->name, rxq_info->name, idx);
-	}
-}
-
 static void enable_rx(struct adapter *adap, struct sge_rspq *q)
 {
 	if (!q)
@@ -750,7 +700,6 @@ void cxgb4_register_uld(enum cxgb4_uld type,
 		if (ret)
 			goto free_queues;
 		if (adap->flags & CXGB4_USING_MSIX) {
-			name_msix_vecs_uld(adap, type);
 			ret = request_msix_queue_irqs_uld(adap, type);
 			if (ret)
 				goto free_rxq;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 928bfea5457b..82d8e13fc7d2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -4060,6 +4060,10 @@ void t4_free_sge_resources(struct adapter *adap)
 		if (eq->rspq.desc)
 			free_rspq_fl(adap, &eq->rspq,
 				     eq->fl.size ? &eq->fl : NULL);
+		if (eq->msix) {
+			cxgb4_free_msix_idx_in_bmap(adap, eq->msix->idx);
+			eq->msix = NULL;
+		}
 
 		etq = &adap->sge.ethtxq[i];
 		if (etq->q.desc) {
@@ -4086,8 +4090,15 @@ void t4_free_sge_resources(struct adapter *adap)
 		}
 	}
 
-	if (adap->sge.fw_evtq.desc)
+	if (adap->sge.fw_evtq.desc) {
 		free_rspq_fl(adap, &adap->sge.fw_evtq, NULL);
+		if (adap->sge.fwevtq_msix_idx >= 0)
+			cxgb4_free_msix_idx_in_bmap(adap,
+						    adap->sge.fwevtq_msix_idx);
+	}
+
+	if (adap->sge.nd_msix_idx >= 0)
+		cxgb4_free_msix_idx_in_bmap(adap, adap->sge.nd_msix_idx);
 
 	if (adap->sge.intrq.desc)
 		free_rspq_fl(adap, &adap->sge.intrq, NULL);
-- 
2.23.0

