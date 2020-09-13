Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A67268176
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 23:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgIMV2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 17:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgIMV2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 17:28:23 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29905C06174A
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 14:28:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b17so4324998pji.1
        for <netdev@vger.kernel.org>; Sun, 13 Sep 2020 14:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=e6oiQG/qBrDfFh8KmaTDfc/zSQ8z7eiV8QJEy7RhCRY=;
        b=yLWo9u/BTX83U3OQ/Tq+J8fjFjw9vwPi82bnffoxCBUFmK9xSm9aalM1RuqaD6zW9b
         lGNq2fwQDhO8TS2xxFBSzE2cx4MOXeIwEcnmfrItTLAZZb9/U3Ea7yq6pqsXeLJJbbl2
         800td45ILNAUmXAer0t15Fn650saHNVvqyOVkmfnTGouXtzLEqBJrlA1Ll5Yt9dKdNwR
         LHNoKtE0DyyoMWK/Labl+JWeP6gccN9vuRInM/KNF+rFkbP0/llmhIE6cc7/LnzPV27p
         +L2/FPq0WTsiEo7BzulImoBskq3DKg5kJFYRAnGA00XD/FVQ+Pp5VMF7aa94j0V5Y6sI
         G7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=e6oiQG/qBrDfFh8KmaTDfc/zSQ8z7eiV8QJEy7RhCRY=;
        b=pNXVH9pcdmaPQwMoaunxHw5O38yWnIOVQmgUvMxVvhIau1pqZovzHpZSoiSX7l6kYX
         HHRE7gLNGlJmttup2QVf7cIP4JoA1sOMJZ/QkofK1WDSA+EHd54kgki+mLAbDAhS7YXl
         RZ68g6BSxx5+neOwHjrOvOXz8pRz/t5Ychb+n5TDjxDA7GBHv07gF5LPQW5mC2iqpGlS
         rXoa7fZFyu4BqDJeORjmcOWK8QQzXykBkkqNxgH4dFvNafbqiyV+UxztiwjxGyoLLcjv
         IzvP/5ZFD2u6gVo5qcdRfzkrwOg8wFpdLzc22AByE2ZTaay4kpMf1dKOE/nGbRhD2JHp
         5OnA==
X-Gm-Message-State: AOAM53169WUYWyxmFBU/QLwdv6YAgLVJP4+c7dqXTXeI0KpyyxrjkKDU
        U1AxJ/a49a2UX2qOnFe8L13k6fPagIdf5g==
X-Google-Smtp-Source: ABdhPJytBo2J7siA0AZjQFpJr5VjTXx53YlEHRv2taI7WVcypzQZwzqXSQ/86lG7IYliE4HRJsY/1w==
X-Received: by 2002:a17:90b:3105:: with SMTP id gc5mr11413213pjb.225.1600032502268;
        Sun, 13 Sep 2020 14:28:22 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id q23sm8175904pfg.143.2020.09.13.14.28.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Sep 2020 14:28:21 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next] ionic: dynamic interrupt moderation
Date:   Sun, 13 Sep 2020 14:28:13 -0700
Message-Id: <20200913212813.46736-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the dim library to manage dynamic interrupt
moderation in ionic.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  2 +
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  1 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 71 ++++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 28 +++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  5 +-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  2 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 33 ++++++++-
 7 files changed, 111 insertions(+), 31 deletions(-)

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
index 9e2ac2b8a082..32f28e0203e9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -243,6 +243,7 @@ struct ionic_intr_info {
 	u64 rearm_count;
 	unsigned int cpu;
 	cpumask_t affinity_mask;
+	u32 dim_coal_hw;
 };
 
 struct ionic_cq {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 00aad7168915..a454f060a01a 100644
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
index 895e2113bd6b..f1c8ab439080 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -42,6 +42,19 @@ static int ionic_start_queues(struct ionic_lif *lif);
 static void ionic_stop_queues(struct ionic_lif *lif);
 static void ionic_lif_queue_identify(struct ionic_lif *lif);
 
+static void ionic_dim_work(struct work_struct *work)
+{
+	struct dim *dim = container_of(work, struct dim, work);
+	struct dim_cq_moder cur_moder =
+		net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
+	struct ionic_qcq *qcq = container_of(dim, struct ionic_qcq, dim);
+	u32 new_coal;
+
+	new_coal = ionic_coal_usec_to_hw(qcq->q.lif->ionic, cur_moder.usec);
+	qcq->intr.dim_coal_hw = new_coal ? new_coal : 1;
+	dim->state = DIM_START_MEASURE;
+}
+
 static void ionic_lif_deferred_work(struct work_struct *work)
 {
 	struct ionic_lif *lif = container_of(work, struct ionic_lif, deferred.work);
@@ -270,6 +283,7 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
 		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
 
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		cancel_work_sync(&qcq->dim.work);
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
 		synchronize_irq(qcq->intr.vector);
@@ -542,6 +556,9 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		ionic_q_sg_map(&new->q, sg_base, sg_base_pa);
 	}
 
+	INIT_WORK(&new->dim.work, ionic_dim_work);
+	new->dim.mode = DIM_CQ_PERIOD_MODE_START_FROM_EQE;
+
 	*qcq = new;
 
 	return 0;
@@ -1633,10 +1650,13 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
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
@@ -1655,6 +1675,8 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
 				     lif->rxqcqs[i]->intr.index,
 				     lif->rx_coalesce_hw);
+		if (test_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state))
+			lif->rxqcqs[i]->intr.dim_coal_hw = lif->rx_coalesce_hw;
 
 		if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 			ionic_link_qcq_interrupts(lif->rxqcqs[i],
@@ -2228,6 +2250,8 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
 						     lif->txqcqs[i]->intr.index,
 						     lif->tx_coalesce_hw);
+				if (test_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state))
+					lif->txqcqs[i]->intr.dim_coal_hw = lif->tx_coalesce_hw;
 			} else {
 				lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
 				ionic_link_qcq_interrupts(lif->rxqcqs[i], lif->txqcqs[i]);
@@ -2355,6 +2379,8 @@ int ionic_lif_alloc(struct ionic *ionic)
 						    lif->rx_coalesce_usecs);
 	lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
 	lif->tx_coalesce_hw = lif->rx_coalesce_hw;
+	set_bit(IONIC_LIF_F_RX_DIM_INTR, lif->state);
+	set_bit(IONIC_LIF_F_TX_DIM_INTR, lif->state);
 
 	snprintf(lif->name, sizeof(lif->name), "lif%u", lif->index);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index e1e6ff1a0918..95894a8ab830 100644
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
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 2b72a51be1d0..b9ba801d150b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -316,7 +316,7 @@ int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(cq->bound_intr);
+		cq->bound_intr->rearm_count++;
 	}
 
 	if (work_done || flags) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index c3291decd4c3..c22452ad6366 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -423,6 +423,30 @@ void ionic_rx_empty(struct ionic_queue *q)
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
@@ -439,8 +463,9 @@ int ionic_tx_napi(struct napi_struct *napi, int budget)
 				     ionic_tx_service, NULL, NULL);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		ionic_dim_update(qcq);
 		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(cq->bound_intr);
+		cq->bound_intr->rearm_count++;
 	}
 
 	if (work_done || flags) {
@@ -474,8 +499,9 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 		ionic_rx_fill(cq->bound_q);
 
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		ionic_dim_update(qcq);
 		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(cq->bound_intr);
+		cq->bound_intr->rearm_count++;
 	}
 
 	if (work_done || flags) {
@@ -519,8 +545,9 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	unmask = (rx_work_done < budget) && (tx_work_done < lif->tx_budget);
 
 	if (unmask && napi_complete_done(napi, rx_work_done)) {
+		ionic_dim_update(qcq);
 		flags |= IONIC_INTR_CRED_UNMASK;
-		DEBUG_STATS_INTR_REARM(rxcq->bound_intr);
+		rxcq->bound_intr->rearm_count++;
 		work_done = rx_work_done;
 	} else {
 		work_done = budget;
-- 
2.17.1

