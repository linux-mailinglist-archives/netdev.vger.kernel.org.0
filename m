Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E475160722
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 00:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgBPXMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 18:12:19 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35057 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgBPXMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 18:12:16 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so5957936plt.2
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 15:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uNP6tVmksh29VdZsaTJiWXEUhBcQyhdiRnF/vrsswA8=;
        b=YeKrlwR1AmLKbJelnbqeiBoEns94Zn6pp2iCJtNpmOQYe7REaVaHTCCoG35Nk1ltSR
         V5oDlSCQzr3in5fPUaLHcxUO8cCFrozCE7KCKqPIjPaE/G8LwL7pXdZT4FMQTN+5hYFs
         f9qZeU6yGI67KfDv6yE8VOYO4ZfqBKPI/xKXmhAJYwftFn/dHz+MicouC/4h86mNVLnZ
         6Jl+sVwzNuNzNEisqCx00hbjFvP4EUwEB8n6jHntQB5ltFZkwP9JnSH0PMhR+7r8MZoM
         DJ7x4f0qqKsFxkiLeFNPjwDen3DSDquHB+QFWU7BgdjtTKKdggx+O9HKVo9ZFXMd09zt
         lVpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uNP6tVmksh29VdZsaTJiWXEUhBcQyhdiRnF/vrsswA8=;
        b=cvg8t7P1AXrHeSftKvnNjbxpNEKVRH0yxv7PVg/t+UyzdjAEpsMDrGW9I2W4X+SN4a
         QsDZkPL4lbE3MGjaPo4bj3EJ2Rg1gkU8/YkeKoN3VYVMMNJCyEg60qPhrTIMXY2FjSDQ
         uTpDFBdm+CA7QQHwC6N+xVRpS8LkZmM0qqM3fsIDg5Cuwo044PUBcAwjpDkqVb5pWY62
         uWxwIvjakeIA5mxdDYi30yvWRKTz2vbf0OdjQaBahdK24ipCURxkEPwRBDhoA/57bkcH
         +BJMerzUByHTPKiisb/aRA6QufI3V6VM3c6uniiiUPTFfeg2mW2kjZ4+vVkALWyjj1bw
         AESA==
X-Gm-Message-State: APjAAAWnuEfLv4TktfDZQJ8rZckkE/jtefl15D89O4lbSLR62aRTQMF9
        1IOpCxKRHxKFdbCrPiZPvWKeQA==
X-Google-Smtp-Source: APXvYqzj4dpjuTt0AG0eRwiteD7LkURso0JPBBSWs1vFXbBb4C7qiRepcKaZ3zaE8+40mCGDPUcAaQ==
X-Received: by 2002:a17:90a:ead8:: with SMTP id ev24mr16427297pjb.91.1581894735208;
        Sun, 16 Feb 2020 15:12:15 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 70sm14074573pgd.28.2020.02.16.15.12.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:12:14 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 8/9] ionic: add basic eq support
Date:   Sun, 16 Feb 2020 15:11:57 -0800
Message-Id: <20200216231158.5678-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link the Event Queues into the driver setup and use them if
the NIC configuration has defined them.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 175 +++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   1 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  63 +++++--
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   1 +
 4 files changed, 184 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 9150cca06b77..85dfd76ff0c6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -189,6 +189,7 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 			.oper = IONIC_Q_ENABLE,
 		},
 	};
+	int ret;
 
 	idev = &lif->ionic->idev;
 	dev = lif->ionic->dev;
@@ -196,16 +197,29 @@ static int ionic_qcq_enable(struct ionic_qcq *qcq)
 	dev_dbg(dev, "q_enable.index %d q_enable.qtype %d\n",
 		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
 
-	if (qcq->flags & IONIC_QCQ_F_INTR) {
+	ret = ionic_adminq_post_wait(lif, &ctx);
+	if (ret)
+		return ret;
+
+	if (qcq->napi.poll)
+		napi_enable(&qcq->napi);
+
+	if (lif->ionic->neth_eqs) {
+		qcq->armed = true;
+		ionic_dbell_ring(lif->kern_dbpage,
+				 qcq->q.hw_type,
+				 IONIC_DBELL_RING_1 |
+				 IONIC_DBELL_QID(qcq->q.hw_index) |
+				 qcq->cq.tail->index);
+	} else if (qcq->flags & IONIC_QCQ_F_INTR) {
 		irq_set_affinity_hint(qcq->intr.vector,
 				      &qcq->intr.affinity_mask);
-		napi_enable(&qcq->napi);
 		ionic_intr_clean(idev->intr_ctrl, qcq->intr.index);
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_CLEAR);
 	}
 
-	return ionic_adminq_post_wait(lif, &ctx);
+	return 0;
 }
 
 static int ionic_qcq_disable(struct ionic_qcq *qcq)
@@ -232,12 +246,14 @@ static int ionic_qcq_disable(struct ionic_qcq *qcq)
 	dev_dbg(dev, "q_disable.index %d q_disable.qtype %d\n",
 		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
 
+	if (qcq->napi.poll)
+		napi_disable(&qcq->napi);
+
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
 		synchronize_irq(qcq->intr.vector);
 		irq_set_affinity_hint(qcq->intr.vector, NULL);
-		napi_disable(&qcq->napi);
 	}
 
 	return ionic_adminq_post_wait(lif, &ctx);
@@ -275,7 +291,6 @@ static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
 				IONIC_INTR_MASK_SET);
 		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
-		netif_napi_del(&qcq->napi);
 	}
 
 	qcq->flags &= ~IONIC_QCQ_F_INITED;
@@ -564,6 +579,11 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 	return err;
 }
 
+static inline int ionic_choose_eq(struct ionic_lif *lif, int q_index)
+{
+	return q_index % lif->ionic->neth_eqs;
+}
+
 static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct device *dev = lif->ionic->dev;
@@ -576,9 +596,6 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.lif_index = cpu_to_le16(lif->index),
 			.type = q->type,
 			.index = cpu_to_le32(q->index),
-			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
-					     IONIC_QINIT_F_SG),
-			.intr_index = cpu_to_le16(lif->rxqcqs[q->index].qcq->intr.index),
 			.pid = cpu_to_le16(q->pid),
 			.ring_size = ilog2(q->num_descs),
 			.ring_base = cpu_to_le64(q->base_pa),
@@ -588,6 +605,20 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	};
 	int err;
 
+	if (lif->ionic->neth_eqs) {
+		unsigned int eq_index = ionic_choose_eq(lif, q->index);
+
+		ctx.cmd.q_init.flags = cpu_to_le16(IONIC_QINIT_F_EQ |
+						   IONIC_QINIT_F_SG);
+		ctx.cmd.q_init.intr_index = cpu_to_le16(eq_index);
+	} else {
+		unsigned int intr_index = lif->rxqcqs[q->index].qcq->intr.index;
+
+		ctx.cmd.q_init.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
+						   IONIC_QINIT_F_SG);
+		ctx.cmd.q_init.intr_index = cpu_to_le16(intr_index);
+	}
+
 	dev_dbg(dev, "txq_init.pid %d\n", ctx.cmd.q_init.pid);
 	dev_dbg(dev, "txq_init.index %d\n", ctx.cmd.q_init.index);
 	dev_dbg(dev, "txq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
@@ -623,9 +654,6 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.lif_index = cpu_to_le16(lif->index),
 			.type = q->type,
 			.index = cpu_to_le32(q->index),
-			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
-					     IONIC_QINIT_F_SG),
-			.intr_index = cpu_to_le16(cq->bound_intr->index),
 			.pid = cpu_to_le16(q->pid),
 			.ring_size = ilog2(q->num_descs),
 			.ring_base = cpu_to_le64(q->base_pa),
@@ -635,6 +663,18 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	};
 	int err;
 
+	if (lif->ionic->neth_eqs) {
+		unsigned int eq_index = ionic_choose_eq(lif, q->index);
+
+		ctx.cmd.q_init.flags = cpu_to_le16(IONIC_QINIT_F_EQ |
+						   IONIC_QINIT_F_SG);
+		ctx.cmd.q_init.intr_index = cpu_to_le16(eq_index);
+	} else {
+		ctx.cmd.q_init.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
+						   IONIC_QINIT_F_SG);
+		ctx.cmd.q_init.intr_index = cpu_to_le16(cq->bound_intr->index);
+	}
+
 	dev_dbg(dev, "rxq_init.pid %d\n", ctx.cmd.q_init.pid);
 	dev_dbg(dev, "rxq_init.index %d\n", ctx.cmd.q_init.index);
 	dev_dbg(dev, "rxq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
@@ -654,10 +694,12 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi,
 		       NAPI_POLL_WEIGHT);
 
-	err = ionic_request_napi_irq(lif, qcq);
-	if (err) {
-		netif_napi_del(&qcq->napi);
-		return err;
+	if (!lif->ionic->neth_eqs) {
+		err = ionic_request_napi_irq(lif, qcq);
+		if (err) {
+			netif_napi_del(&qcq->napi);
+			return err;
+		}
 	}
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
@@ -1426,7 +1468,9 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 	for (i = 0; i < lif->nxqs; i++) {
 		ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
 		ionic_tx_flush(&lif->txqcqs[i].qcq->cq);
+		ionic_tx_empty(&lif->txqcqs[i].qcq->q);
 
+		netif_napi_del(&lif->rxqcqs[i].qcq->napi);
 		ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
 		ionic_rx_flush(&lif->rxqcqs[i].qcq->cq);
 		ionic_rx_empty(&lif->rxqcqs[i].qcq->q);
@@ -1466,7 +1510,10 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		lif->txqcqs[i].qcq->stats = lif->txqcqs[i].stats;
 	}
 
-	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG | IONIC_QCQ_F_INTR;
+	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG;
+	if (!lif->ionic->neth_eqs)
+		flags |= IONIC_QCQ_F_INTR;
+
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
 				      lif->nrxq_descs,
@@ -1479,11 +1526,13 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 
 		lif->rxqcqs[i].qcq->stats = lif->rxqcqs[i].stats;
 
-		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-				     lif->rxqcqs[i].qcq->intr.index,
-				     lif->rx_coalesce_hw);
-		ionic_link_qcq_interrupts(lif->rxqcqs[i].qcq,
-					  lif->txqcqs[i].qcq);
+		if (!lif->ionic->neth_eqs) {
+			ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+					     lif->rxqcqs[i].qcq->intr.index,
+					     lif->rx_coalesce_hw);
+			ionic_link_qcq_interrupts(lif->rxqcqs[i].qcq,
+						  lif->txqcqs[i].qcq);
+		}
 	}
 
 	return 0;
@@ -1521,6 +1570,8 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 err_out:
 	while (i--) {
 		ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
+
+		netif_napi_del(&lif->rxqcqs[i].qcq->napi);
 		ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
 	}
 
@@ -2042,6 +2093,7 @@ static void ionic_lif_free(struct ionic_lif *lif)
 	/* free netdev & lif */
 	ionic_debugfs_del_lif(lif);
 	xa_erase(&ionic->lifs, lif->index);
+	lif->ionic->master_lif = NULL;
 	free_netdev(lif->netdev);
 }
 
@@ -2062,9 +2114,17 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	clear_bit(IONIC_LIF_INITED, lif->state);
 
 	ionic_rx_filters_deinit(lif);
-	ionic_lif_rss_deinit(lif);
+
+	if (is_master_lif(lif)) {
+		if (lif->netdev->features & NETIF_F_RXHASH)
+			ionic_lif_rss_deinit(lif);
+
+		ionic_eqs_deinit(lif->ionic);
+		ionic_eqs_free(lif->ionic);
+	}
 
 	napi_disable(&lif->adminqcq->napi);
+	netif_napi_del(&lif->adminqcq->napi);
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
@@ -2228,12 +2288,11 @@ static int ionic_lif_init(struct ionic_lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
 	struct device *dev = lif->ionic->dev;
+	struct ionic *ionic = lif->ionic;
 	struct ionic_lif_init_comp comp;
 	int dbpage_num;
 	int err;
 
-	ionic_debugfs_add_lif(lif);
-
 	mutex_lock(&lif->ionic->dev_cmd_lock);
 	ionic_dev_cmd_lif_init(idev, lif->index, lif->info_pa);
 	err = ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
@@ -2269,6 +2328,23 @@ static int ionic_lif_init(struct ionic_lif *lif)
 		goto err_out_free_dbid;
 	}
 
+	if (is_master_lif(lif) && ionic->neth_eqs) {
+		err = ionic_eqs_alloc(ionic);
+		if (err) {
+			dev_err(dev, "Cannot allocate EQs: %d\n", err);
+			ionic->neth_eqs = 0;
+		} else {
+			err = ionic_eqs_init(ionic);
+			if (err) {
+				dev_err(dev, "Cannot init EQs: %d\n", err);
+				ionic_eqs_free(ionic);
+				ionic->neth_eqs = 0;
+			}
+		}
+	}
+
+	ionic_debugfs_add_lif(lif);
+
 	err = ionic_lif_adminq_init(lif);
 	if (err)
 		goto err_out_adminq_deinit;
@@ -2292,9 +2368,7 @@ static int ionic_lif_init(struct ionic_lif *lif)
 		goto err_out_notifyq_deinit;
 
 	lif->rx_copybreak = IONIC_RX_COPYBREAK_DEFAULT;
-
 	set_bit(IONIC_LIF_INITED, lif->state);
-
 	INIT_WORK(&lif->tx_timeout_work, ionic_tx_timeout_work);
 
 	return 0;
@@ -2303,9 +2377,8 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 err_out_adminq_deinit:
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
-	ionic_lif_reset(lif);
-	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
-	lif->kern_dbpage = NULL;
+	ionic_eqs_deinit(lif->ionic);
+	ionic_eqs_free(lif->ionic);
 err_out_free_dbid:
 	kfree(lif->dbid_inuse);
 	lif->dbid_inuse = NULL;
@@ -2469,54 +2542,64 @@ int ionic_lifs_size(struct ionic *ionic)
 	unsigned int ntxqs_per_lif;
 	unsigned int nrxqs_per_lif;
 	unsigned int nnqs_per_lif;
+	unsigned int dev_neth_eqs;
 	unsigned int dev_nintrs;
-	unsigned int min_intrs;
 	unsigned int nrdma_eqs;
+	unsigned int neth_eqs;
 	unsigned int nintrs;
 	unsigned int nxqs;
 	int err;
 
 	lc = &ident->lif.eth.config;
 	dev_nintrs = le32_to_cpu(ident->dev.nintrs);
+	dev_neth_eqs = le32_to_cpu(ident->dev.eq_count);
+	if (dev_neth_eqs > IONIC_MAX_ETH_EQS)
+		dev_neth_eqs = 0; /* fix bogus value from old FW */
 	nrdma_eqs_per_lif = le32_to_cpu(ident->lif.rdma.eq_qtype.qid_count);
 	nnqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_NOTIFYQ]);
 	ntxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_TXQ]);
 	nrxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_RXQ]);
 
+	/* limit TxRx queuepairs and RDMA event queues to num cpu */
 	nxqs = min(ntxqs_per_lif, nrxqs_per_lif);
 	nxqs = min(nxqs, num_online_cpus());
 	nrdma_eqs = min(nrdma_eqs_per_lif, num_online_cpus());
 
-try_again:
-	/* interrupt usage:
-	 *    1 for master lif adminq/notifyq
-	 *    1 for each CPU for master lif TxRx queue pairs
-	 *    whatever's left is for RDMA queues
+	neth_eqs = min(dev_neth_eqs, num_online_cpus());
+
+	/* EventQueue interrupt usage: (if eq_count != 0)
+	 *    1 aq intr + n EQs + m RDMA
+	 *
+	 * Default interrupt usage:
+	 *    1 aq intr + n TxRx intrs + m RDMA
 	 */
-	nintrs = 1 + nxqs + nrdma_eqs;
-	min_intrs = 2;  /* adminq + 1 TxRx queue pair */
+try_again:
+	if (neth_eqs)
+		nintrs = 1 + neth_eqs + nrdma_eqs;
+	else
+		nintrs = 1 + nxqs + nrdma_eqs;
 
 	if (nintrs > dev_nintrs)
 		goto try_fewer;
 
 	err = ionic_bus_alloc_irq_vectors(ionic, nintrs);
-	if (err < 0 && err != -ENOSPC) {
+	if (err == -ENOSPC) {
+		goto try_fewer;
+	} else if (err < 0) {
 		dev_err(ionic->dev, "Can't get intrs from OS: %d\n", err);
 		return err;
-	}
-	if (err == -ENOSPC)
-		goto try_fewer;
-
-	if (err != nintrs) {
+	} else if (err != nintrs) {
 		ionic_bus_free_irq_vectors(ionic);
 		goto try_fewer;
 	}
 
+	/* At this point we have the interrupts we need */
 	ionic->nnqs_per_lif = nnqs_per_lif;
 	ionic->nrdma_eqs_per_lif = nrdma_eqs;
 	ionic->ntxqs_per_lif = nxqs;
 	ionic->nrxqs_per_lif = nxqs;
 	ionic->nintrs = nintrs;
+	ionic->neth_eqs = neth_eqs;
 
 	ionic_debugfs_add_sizes(ionic);
 
@@ -2531,10 +2614,14 @@ int ionic_lifs_size(struct ionic *ionic)
 		nrdma_eqs >>= 1;
 		goto try_again;
 	}
+	if (neth_eqs > 1) {
+		neth_eqs >>= 1;
+		goto try_again;
+	}
 	if (nxqs > 1) {
 		nxqs >>= 1;
 		goto try_again;
 	}
-	dev_err(ionic->dev, "Can't get minimum %d intrs from OS\n", min_intrs);
+	dev_err(ionic->dev, "Can't get minimum intrs from OS\n");
 	return -ENOSPC;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index bb9202a10ac1..25423332f028 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -189,6 +189,7 @@ struct ionic_lif {
 #define lif_to_rxstats(lif, i)	((lif)->rxqcqs[i].stats->rx)
 #define lif_to_txq(lif, i)	(&lif_to_txqcq((lif), i)->q)
 #define lif_to_rxq(lif, i)	(&lif_to_txqcq((lif), i)->q)
+#define is_master_lif(lif)	((lif)->index == 0)
 
 /* return 0 if successfully set the bit, else non-zero */
 static inline int ionic_wait_for_bit(struct ionic_lif *lif, int bitname)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index e452f4242ba0..e860fb199ef3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -274,7 +274,7 @@ void ionic_rx_flush(struct ionic_cq *cq)
 
 	work_done = ionic_rx_walk_cq(cq, cq->num_descs);
 
-	if (work_done)
+	if (work_done && !cq->lif->ionic->neth_eqs)
 		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
 				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
 }
@@ -439,9 +439,10 @@ void ionic_rx_empty(struct ionic_queue *q)
 
 int ionic_rx_napi(struct napi_struct *napi, int budget)
 {
-	struct ionic_qcq *qcq = napi_to_qcq(napi);
+	struct ionic_qcq *rxqcq = napi_to_qcq(napi);
 	struct ionic_cq *rxcq = napi_to_cq(napi);
 	unsigned int qi = rxcq->bound_q->index;
+	struct ionic_qcq *txqcq;
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
@@ -450,12 +451,12 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 
 	lif = rxcq->bound_q->lif;
 	idev = &lif->ionic->idev;
+	txqcq = lif->txqcqs[qi].qcq;
 	txcq = &lif->txqcqs[qi].qcq->cq;
 
 	ionic_tx_flush(txcq);
 
 	work_done = ionic_rx_walk_cq(rxcq, budget);
-
 	if (work_done)
 		ionic_rx_fill_cb(rxcq->bound_q);
 
@@ -466,11 +467,33 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 
 	if (work_done || flags) {
 		flags |= IONIC_INTR_CRED_RESET_COALESCE;
-		ionic_intr_credits(idev->intr_ctrl, rxcq->bound_intr->index,
-				   work_done, flags);
+		if (!lif->ionic->neth_eqs) {
+			ionic_intr_credits(idev->intr_ctrl,
+					   rxcq->bound_intr->index,
+					   work_done, flags);
+		} else {
+			u64 dbr;
+
+			if (!rxqcq->armed) {
+				rxqcq->armed = true;
+				dbr = IONIC_DBELL_RING_1 |
+				      IONIC_DBELL_QID(rxqcq->q.hw_index);
+				ionic_dbell_ring(lif->kern_dbpage,
+						 rxqcq->q.hw_type,
+						 dbr | rxqcq->cq.tail->index);
+			}
+			if (!txqcq->armed) {
+				txqcq->armed = true;
+				dbr = IONIC_DBELL_RING_1 |
+				      IONIC_DBELL_QID(txqcq->q.hw_index);
+				ionic_dbell_ring(lif->kern_dbpage,
+						 txqcq->q.hw_type,
+						 dbr | txqcq->cq.tail->index);
+			}
+		}
 	}
 
-	DEBUG_STATS_NAPI_POLL(qcq, work_done);
+	DEBUG_STATS_NAPI_POLL(rxqcq, work_done);
 
 	return work_done;
 }
@@ -516,7 +539,6 @@ static void ionic_tx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_i
 	struct ionic_txq_desc *desc = desc_info->desc;
 	struct device *dev = q->lif->ionic->dev;
 	u8 opcode, flags, nsge;
-	u16 queue_index;
 	unsigned int i;
 	u64 addr;
 
@@ -541,11 +563,12 @@ static void ionic_tx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_i
 	if (cb_arg) {
 		struct sk_buff *skb = cb_arg;
 		u32 len = skb->len;
+		u16 qi;
 
-		queue_index = skb_get_queue_mapping(skb);
-		if (unlikely(__netif_subqueue_stopped(q->lif->netdev,
-						      queue_index))) {
-			netif_wake_subqueue(q->lif->netdev, queue_index);
+		qi = skb_get_queue_mapping(skb);
+		if (unlikely(__netif_subqueue_stopped(q->lif->netdev, qi) &&
+			     cq_info)) {
+			netif_wake_subqueue(q->lif->netdev, qi);
 			q->wake++;
 		}
 		dev_kfree_skb_any(skb);
@@ -588,11 +611,27 @@ void ionic_tx_flush(struct ionic_cq *cq)
 		work_done++;
 	}
 
-	if (work_done)
+	if (work_done && !cq->lif->ionic->neth_eqs)
 		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
 				   work_done, 0);
 }
 
+void ionic_tx_empty(struct ionic_queue *q)
+{
+	struct ionic_desc_info *desc_info;
+	int done = 0;
+
+	/* walk the not completed tx entries, if any */
+	while (q->head != q->tail) {
+		desc_info = q->tail;
+		q->tail = desc_info->next;
+		ionic_tx_clean(q, desc_info, NULL, desc_info->cb_arg);
+		desc_info->cb = NULL;
+		desc_info->cb_arg = NULL;
+		done++;
+	}
+}
+
 static int ionic_tx_tcp_inner_pseudo_csum(struct sk_buff *skb)
 {
 	int err;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
index 53775c62c85a..71973e3c35a6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
@@ -9,6 +9,7 @@ void ionic_tx_flush(struct ionic_cq *cq);
 
 void ionic_rx_fill(struct ionic_queue *q);
 void ionic_rx_empty(struct ionic_queue *q);
+void ionic_tx_empty(struct ionic_queue *q);
 int ionic_rx_napi(struct napi_struct *napi, int budget);
 netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev);
 
-- 
2.17.1

