Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E739D26B630
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgIOX7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbgIOX7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:59:13 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EBCC06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:59:11 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id o20so2864170pfp.11
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=OMCDqYD08cCX3VJVEF97w2555j0bRa3B2n0PmIwBSBk=;
        b=gHzBomnACA0PbqA1WDD6wOdz0FOdgdAljAOFZ1XuwwRWc6kAFqHote+WYdzhZyEyH9
         8LTmZ/RwbcqjkbYJS2cGUP2Whn2PVn5zlAoAm0Nim96dIArkcU7tFuo2AxskqqyKiYCO
         XkVoITJYpUHR4Rymb4xPPsi81frdqLs6kDv6WbGGGEBJLzDkMzZ+pXXyDxUxhi/qEMMd
         XdL9dywj8I1N6FgSt5sNmtiH5ePKJWmugJLTiPZi/sKUGEKecBvY9LLs4Ld8/WZnwKHT
         SR7ZzLLpzlrBXS9QUAxqT6Er5h+wk9yxvQF/+MQLO3jSTm5Uy77B1rEqCwNNTiNbBpJ3
         7ysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OMCDqYD08cCX3VJVEF97w2555j0bRa3B2n0PmIwBSBk=;
        b=nlsEYryRqvp8VmrmhVKYNKakcRn8NMt1ngOG1hQJKSE30DfFtN6MtS1B6rwXHZOjhx
         UGDf3AbiSfDjw+lAbi9hStKKBEcbQ9YvuhHLkv+E+zDpSHkheVGbxnfzVbAort6p/sa9
         Mk/cJtT74n2x0NezelepKc+ITtK0fB6TchyFbWRv2CsfPSA3AnQDNaSnODM0kpea5nG5
         UgnsoETYec+mOBfIKI9wcTZczMcmyhrdxMtzutX8ZjJX2zMq6g5gx9Ztmd6+N5/cSCPR
         qiB59JqpHxL8xGpauBnMVAkIceYZdPW7o/+TaUdxYQF9lDgrGkKVSCeWweOhvNY7hg41
         ms7g==
X-Gm-Message-State: AOAM533BxWGbxoO1HDdlre2+omsiiLV/HzGu52Ta3B9zFgcu11JEb9np
        TOtU5bIRMvYrllTweOxHrxpf48xJtr4BNw==
X-Google-Smtp-Source: ABdhPJxj+bSIFx9v5ISAXUryJTvUTVHrIoGh5IyzQvx/FigrJuQTmNIufO5jA/285JySHa5yItwPVg==
X-Received: by 2002:a63:c304:: with SMTP id c4mr718614pgd.326.1600214349830;
        Tue, 15 Sep 2020 16:59:09 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a24sm557232pju.25.2020.09.15.16.59.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 16:59:09 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next] ionic: dynamic interrupt moderation
Date:   Tue, 15 Sep 2020 16:59:03 -0700
Message-Id: <20200915235903.373-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the dim library to manage dynamic interrupt
moderation in ionic.

v3: rebase
v2: untangled declarations in ionic_dim_work()

Signed-off-by: Shannon Nelson <snelson@pensando.io>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  2 +
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  1 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 71 ++++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 31 +++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  5 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 33 ++++++++-
 6 files changed, 112 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index 683bbbf75115..39f59849720d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -189,6 +189,8 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 				   &intr->index);
 		debugfs_create_u32("vector", 0400, intr_dentry,
 				   &intr->vector);
+		debugfs_create_u32("dim_coal_hw", 0400, intr_dentry,
+				   &intr->dim_coal_hw);
 
 		intr_ctrl_regset = devm_kzalloc(dev, sizeof(*intr_ctrl_regset),
 						GFP_KERNEL);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 4a35174e3ff1..8842dc4a716f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -237,6 +237,7 @@ struct ionic_intr_info {
 	u64 rearm_count;
 	unsigned int cpu;
 	cpumask_t affinity_mask;
+	u32 dim_coal_hw;
 };
 
 struct ionic_cq {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 0d14659fbdfd..ed9808fc743b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -406,6 +406,13 @@ static int ionic_get_coalesce(struct net_device *netdev,
 	coalesce->tx_coalesce_usecs = lif->tx_coalesce_usecs;
 	coalesce->rx_coalesce_usecs = lif->rx_coalesce_usecs;
 
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		coalesce->use_adaptive_tx_coalesce = test_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state);
+	else
+		coalesce->use_adaptive_tx_coalesce = 0;
+
+	coalesce->use_adaptive_rx_coalesce = test_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state);
+
 	return 0;
 }
 
@@ -414,10 +421,9 @@ static int ionic_set_coalesce(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_identity *ident;
-	struct ionic_qcq *qcq;
+	u32 rx_coal, rx_dim;
+	u32 tx_coal, tx_dim;
 	unsigned int i;
-	u32 rx_coal;
-	u32 tx_coal;
 
 	ident = &lif->ionic->ident;
 	if (ident->dev.intr_coal_div == 0) {
@@ -426,10 +432,11 @@ static int ionic_set_coalesce(struct net_device *netdev,
 		return -EIO;
 	}
 
-	/* Tx normally shares Rx interrupt, so only change Rx */
+	/* Tx normally shares Rx interrupt, so only change Rx if not split */
 	if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state) &&
-	    coalesce->tx_coalesce_usecs != lif->rx_coalesce_usecs) {
-		netdev_warn(netdev, "only the rx-usecs can be changed\n");
+	    (coalesce->tx_coalesce_usecs != lif->rx_coalesce_usecs ||
+	     coalesce->use_adaptive_tx_coalesce)) {
+		netdev_warn(netdev, "only rx parameters can be changed\n");
 		return -EINVAL;
 	}
 
@@ -449,32 +456,44 @@ static int ionic_set_coalesce(struct net_device *netdev,
 
 	/* Save the new values */
 	lif->rx_coalesce_usecs = coalesce->rx_coalesce_usecs;
-	if (rx_coal != lif->rx_coalesce_hw) {
-		lif->rx_coalesce_hw = rx_coal;
-
-		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
-			for (i = 0; i < lif->nxqs; i++) {
-				qcq = lif->rxqcqs[i];
-				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-						     qcq->intr.index,
-						     lif->rx_coalesce_hw);
-			}
-		}
-	}
+	lif->rx_coalesce_hw = rx_coal;
 
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 		lif->tx_coalesce_usecs = coalesce->tx_coalesce_usecs;
 	else
 		lif->tx_coalesce_usecs = coalesce->rx_coalesce_usecs;
-	if (tx_coal != lif->tx_coalesce_hw) {
-		lif->tx_coalesce_hw = tx_coal;
+	lif->tx_coalesce_hw = tx_coal;
+
+	if (coalesce->use_adaptive_rx_coalesce) {
+		set_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state);
+		rx_dim = rx_coal;
+	} else {
+		clear_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state);
+		rx_dim = 0;
+	}
+
+	if (coalesce->use_adaptive_tx_coalesce) {
+		set_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state);
+		tx_dim = tx_coal;
+	} else {
+		clear_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state);
+		tx_dim = 0;
+	}
+
+	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
+		for (i = 0; i < lif->nxqs; i++) {
+			if (lif->rxqcqs[i]->flags & IONIC_QCQ_F_INTR) {
+				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+						     lif->rxqcqs[i]->intr.index,
+						     lif->rx_coalesce_hw);
+				lif->rxqcqs[i]->intr.dim_coal_hw = rx_dim;
+			}
 
-		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
-			for (i = 0; i < lif->nxqs; i++) {
-				qcq = lif->txqcqs[i];
+			if (lif->txqcqs[i]->flags & IONIC_QCQ_F_INTR) {
 				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-						     qcq->intr.index,
+						     lif->txqcqs[i]->intr.index,
 						     lif->tx_coalesce_hw);
+				lif->txqcqs[i]->intr.dim_coal_hw = tx_dim;
 			}
 		}
 	}
@@ -850,7 +869,9 @@ static int ionic_nway_reset(struct net_device *netdev)
 }
 
 static const struct ethtool_ops ionic_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_TX,
 	.get_drvinfo		= ionic_get_drvinfo,
 	.get_regs_len		= ionic_get_regs_len,
 	.get_regs		= ionic_get_regs,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index b9816d161142..eb6fe37c0df6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -42,6 +42,20 @@ static int ionic_start_queues(struct ionic_lif *lif);
 static void ionic_stop_queues(struct ionic_lif *lif);
 static void ionic_lif_queue_identify(struct ionic_lif *lif);
 
+static void ionic_dim_work(struct work_struct *work)
+{
+	struct dim *dim = container_of(work, struct dim, work);
+	struct dim_cq_moder cur_moder;
+	struct ionic_qcq *qcq;
+	u32 new_coal;
+
+	cur_moder = net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
+	qcq = container_of(dim, struct ionic_qcq, dim);
+	new_coal = ionic_coal_usec_to_hw(qcq->q.lif->ionic, cur_moder.usec);
+	qcq->intr.dim_coal_hw = new_coal ? new_coal : 1;
+	dim->state = DIM_START_MEASURE;
+}
+
 static void ionic_lif_deferred_work(struct work_struct *work)
 {
 	struct ionic_lif *lif = container_of(work, struct ionic_lif, deferred.work);
@@ -270,6 +284,7 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
 		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
 
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		cancel_work_sync(&qcq->dim.work);
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
 		synchronize_irq(qcq->intr.vector);
@@ -542,6 +557,9 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		ionic_q_sg_map(&new->q, sg_base, sg_base_pa);
 	}
 
+	INIT_WORK(&new->dim.work, ionic_dim_work);
+	new->dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+
 	*qcq = new;
 
 	return 0;
@@ -834,7 +852,7 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	work_done = max(n_work, a_work);
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(intr);
+		lif->adminqcq->cq.bound_intr->rearm_count++;
 	}
 
 	if (work_done || flags) {
@@ -1639,10 +1657,13 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		if (err)
 			goto err_out;
 
-		if (flags & IONIC_QCQ_F_INTR)
+		if (flags & IONIC_QCQ_F_INTR) {
 			ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
 					     lif->txqcqs[i]->intr.index,
 					     lif->tx_coalesce_hw);
+			if (test_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state))
+				lif->txqcqs[i]->intr.dim_coal_hw = lif->tx_coalesce_hw;
+		}
 
 		ionic_debugfs_add_qcq(lif, lif->txqcqs[i]);
 	}
@@ -1661,6 +1682,8 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
 				     lif->rxqcqs[i]->intr.index,
 				     lif->rx_coalesce_hw);
+		if (test_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state))
+			lif->rxqcqs[i]->intr.dim_coal_hw = lif->rx_coalesce_hw;
 
 		if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 			ionic_link_qcq_interrupts(lif->rxqcqs[i],
@@ -2234,6 +2257,8 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
 						     lif->txqcqs[i]->intr.index,
 						     lif->tx_coalesce_hw);
+				if (test_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state))
+					lif->txqcqs[i]->intr.dim_coal_hw = lif->tx_coalesce_hw;
 			} else {
 				lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
 				ionic_link_qcq_interrupts(lif->rxqcqs[i], lif->txqcqs[i]);
@@ -2361,6 +2386,8 @@ int ionic_lif_alloc(struct ionic *ionic)
 						    lif->rx_coalesce_usecs);
 	lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
 	lif->tx_coalesce_hw = lif->rx_coalesce_hw;
+	set_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state);
+	set_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state);
 
 	snprintf(lif->name, sizeof(lif->name), "lif%u", lif->index);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 11ea9e0c6a4a..c65a5e6c26f4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -4,6 +4,7 @@
 #ifndef _IONIC_LIF_H_
 #define _IONIC_LIF_H_
 
+#include <linux/dim.h>
 #include <linux/pci.h>
 #include "ionic_rx_filter.h"
 
@@ -66,6 +67,7 @@ struct ionic_qcq {
 	void *sg_base;
 	dma_addr_t sg_base_pa;
 	u32 sg_size;
+	struct dim dim;
 	struct ionic_queue q;
 	struct ionic_cq cq;
 	struct ionic_intr_info intr;
@@ -131,6 +133,8 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_FW_RESET,
 	IONIC_LIF_F_SPLIT_INTR,
+	IONIC_LIF_F_TX_DIM_INTR,
+	IONIC_LIF_F_RX_DIM_INTR,
 
 	/* leave this as last */
 	IONIC_LIF_F_STATE_SIZE
@@ -288,7 +292,6 @@ static inline void debug_stats_napi_poll(struct ionic_qcq *qcq,
 
 #define DEBUG_STATS_CQE_CNT(cq)		((cq)->compl_count++)
 #define DEBUG_STATS_RX_BUFF_CNT(q)	((q)->lif->rxqstats[q->index].buffers_posted++)
-#define DEBUG_STATS_INTR_REARM(intr)	((intr)->rearm_count++)
 #define DEBUG_STATS_TXQ_POST(q, dbell)  debug_stats_txq_post(q, dbell)
 #define DEBUG_STATS_NAPI_POLL(qcq, work_done) \
 	debug_stats_napi_poll(qcq, work_done)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 7225251c5563..169ac4f54640 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -432,6 +432,30 @@ void ionic_rx_empty(struct ionic_queue *q)
 	}
 }
 
+static void ionic_dim_update(struct ionic_qcq *qcq)
+{
+	struct dim_sample dim_sample;
+	struct ionic_lif *lif;
+	unsigned int qi;
+
+	if (!qcq->intr.dim_coal_hw)
+		return;
+
+	lif = qcq->q.lif;
+	qi = qcq->cq.bound_q->index;
+
+	ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+			     lif->rxqcqs[qi]->intr.index,
+			     qcq->intr.dim_coal_hw);
+
+	dim_update_sample(qcq->cq.bound_intr->rearm_count,
+			  lif->txqstats[qi].pkts,
+			  lif->txqstats[qi].bytes,
+			  &dim_sample);
+
+	net_dim(&qcq->dim, dim_sample);
+}
+
 int ionic_tx_napi(struct napi_struct *napi, int budget)
 {
 	struct ionic_qcq *qcq = napi_to_qcq(napi);
@@ -448,8 +472,9 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 				     ionic_tx_service, NULL, NULL);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		ionic_dim_update(qcq);
 		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(cq->bound_intr);
+		cq->bound_intr->rearm_count++;
 	}
 
 	if (work_done || flags) {
@@ -483,8 +508,9 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 		ionic_rx_fill(cq->bound_q);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		ionic_dim_update(qcq);
 		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(cq->bound_intr);
+		cq->bound_intr->rearm_count++;
 	}
 
 	if (work_done || flags) {
@@ -524,8 +550,9 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 		ionic_rx_fill_cb(rxcq->bound_q);
 
 	if (rx_work_done < budget && napi_complete_done(napi, rx_work_done)) {
+		ionic_dim_update(qcq);
 		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(rxcq->bound_intr);
+		rxcq->bound_intr->rearm_count++;
 	}
 
 	if (rx_work_done || flags) {
-- 
2.17.1

