Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED16254C93
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgH0SH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgH0SHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:07:54 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01CAC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:54 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g33so3921908pgb.4
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=56qZ5Wq9OXMlphdlOFl+mw2DNiM0LiUJYd7fmD7X000=;
        b=HGjYGToDSLZYnrbdYOuvrWUTjQhPaXs0IJYqmktAajjTapqvUKeZGhLTnOvA4FWTJe
         k/suWgOltixtDg6DRyiLdJtpH/XQHNqD4YRIheyEAR4YzSfKSONbkHEh1OjBdZXlc5ny
         HvtDxbGRkSOMODSSaOEhUVjBlvFdJHIE4je1cnkrGQpJ+oscNFFlG34UBuY/EmSPdQfZ
         RIpw+cBmhAXaYNspEhIjEHpZg1QFFXdMKUvV3HESOG5cACLLQtOZFCXQemRYMPJPx5jy
         DHglMyMC+1Kh1EimD0wmdYEKIHAdE2KSk8v6hqUAFICv36Rb0DXkqHyr/uoc/9UEvSrs
         kErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=56qZ5Wq9OXMlphdlOFl+mw2DNiM0LiUJYd7fmD7X000=;
        b=j5UFN+BCy6nr/TXlYEtuqkI6GSo9WAD3y7wBNIAzxL5+KDY7QW3PxLzpWooFJCpynz
         /kKXEhdwyUwxTHv4wVMNEk8Jx4VSvEi7hgYEn1rOaOX+NPxx4TaGFf1/XKMqu5Ryzj/+
         Zi8bN4ig1bzWH64hchnfuleVKNy/1Uyw6HUsNg3mBqsPePl2QosYZZBhUOTKAH/6BF3B
         fD0eD4buiyUQcZo8WcM7P1Erqwwwoi/kIPbgSxwHjPMxsrJg3I1+sHLsgP3du3lTq3GO
         L4n+7Yh5YVcZMPkHMaZ3mPfCiMguJATR9qfa7iK5+OetCzQVtKxIMrnRWUkc74zHVz0c
         8URQ==
X-Gm-Message-State: AOAM530/lor01wZE54Ts/lVmhZMYMBDgoZPi0uqTyv2rMJCrz178zPN7
        Dtqbt6KQjx0dTKPry9zuPPd8ezzzck+uxg==
X-Google-Smtp-Source: ABdhPJxEUP1vKpdppe0dSWBbniimyG4JbUIViJoQAkPkAOLozYCaCkGAaH/dcC52tYaoq5IhU9glig==
X-Received: by 2002:a63:1052:: with SMTP id 18mr15734663pgq.311.1598551673403;
        Thu, 27 Aug 2020 11:07:53 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n1sm3480249pfu.2.2020.08.27.11.07.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 11:07:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 05/12] ionic: rework and simplify handling of the queue stats block
Date:   Thu, 27 Aug 2020 11:07:28 -0700
Message-Id: <20200827180735.38166-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827180735.38166-1-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a block of stats structs attached to the lif instead of
little ones attached to each qcq.  This simplifies our memory
management and gets rid of a lot of unnecessary indirection.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   |   4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 135 +++++++-----------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  42 ++----
 .../net/ethernet/pensando/ionic/ionic_stats.c |  48 +++----
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  12 +-
 5 files changed, 92 insertions(+), 149 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 3c57c331729f..73af0ecc5495 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -454,7 +454,7 @@ static int ionic_set_coalesce(struct net_device *netdev,
 
 		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 			for (i = 0; i < lif->nxqs; i++) {
-				qcq = lif->rxqcqs[i].qcq;
+				qcq = lif->rxqcqs[i];
 				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
 						     qcq->intr.index,
 						     lif->rx_coalesce_hw);
@@ -471,7 +471,7 @@ static int ionic_set_coalesce(struct net_device *netdev,
 
 		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 			for (i = 0; i < lif->nxqs; i++) {
-				qcq = lif->txqcqs[i].qcq;
+				qcq = lif->txqcqs[i];
 				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
 						     qcq->intr.index,
 						     lif->tx_coalesce_hw);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index de9da16db3a8..03eee682f872 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -327,7 +327,6 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 static void ionic_qcqs_free(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
-	unsigned int i;
 
 	if (lif->notifyqcq) {
 		ionic_qcq_free(lif, lif->notifyqcq);
@@ -340,17 +339,15 @@ static void ionic_qcqs_free(struct ionic_lif *lif)
 	}
 
 	if (lif->rxqcqs) {
-		for (i = 0; i < lif->nxqs; i++)
-			if (lif->rxqcqs[i].stats)
-				devm_kfree(dev, lif->rxqcqs[i].stats);
+		devm_kfree(dev, lif->rxqstats);
+		lif->rxqstats = NULL;
 		devm_kfree(dev, lif->rxqcqs);
 		lif->rxqcqs = NULL;
 	}
 
 	if (lif->txqcqs) {
-		for (i = 0; i < lif->nxqs; i++)
-			if (lif->txqcqs[i].stats)
-				devm_kfree(dev, lif->txqcqs[i].stats);
+		devm_kfree(dev, lif->txqstats);
+		lif->txqstats = NULL;
 		devm_kfree(dev, lif->txqcqs);
 		lif->txqcqs = NULL;
 	}
@@ -524,7 +521,6 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 	struct device *dev = lif->ionic->dev;
 	unsigned int flags;
 	int err;
-	int i;
 
 	flags = IONIC_QCQ_F_INTR;
 	err = ionic_qcq_alloc(lif, IONIC_QTYPE_ADMINQ, 0, "admin", flags,
@@ -544,7 +540,7 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 				      sizeof(union ionic_notifyq_comp),
 				      0, lif->kern_pid, &lif->notifyqcq);
 		if (err)
-			goto err_out_free_adminqcq;
+			goto err_out;
 		ionic_debugfs_add_qcq(lif, lif->notifyqcq);
 
 		/* Let the notifyq ride on the adminq interrupt */
@@ -553,52 +549,27 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 
 	err = -ENOMEM;
 	lif->txqcqs = devm_kcalloc(dev, lif->ionic->ntxqs_per_lif,
-				   sizeof(*lif->txqcqs), GFP_KERNEL);
+				   sizeof(struct ionic_qcq *), GFP_KERNEL);
 	if (!lif->txqcqs)
-		goto err_out_free_notifyqcq;
-	for (i = 0; i < lif->nxqs; i++) {
-		lif->txqcqs[i].stats = devm_kzalloc(dev,
-						    sizeof(struct ionic_q_stats),
-						    GFP_KERNEL);
-		if (!lif->txqcqs[i].stats)
-			goto err_out_free_tx_stats;
-	}
-
+		goto err_out;
 	lif->rxqcqs = devm_kcalloc(dev, lif->ionic->nrxqs_per_lif,
-				   sizeof(*lif->rxqcqs), GFP_KERNEL);
+				   sizeof(struct ionic_qcq *), GFP_KERNEL);
 	if (!lif->rxqcqs)
-		goto err_out_free_tx_stats;
-	for (i = 0; i < lif->nxqs; i++) {
-		lif->rxqcqs[i].stats = devm_kzalloc(dev,
-						    sizeof(struct ionic_q_stats),
-						    GFP_KERNEL);
-		if (!lif->rxqcqs[i].stats)
-			goto err_out_free_rx_stats;
-	}
+		goto err_out;
 
-	return 0;
+	lif->txqstats = devm_kcalloc(dev, lif->ionic->ntxqs_per_lif,
+				     sizeof(struct ionic_tx_stats), GFP_KERNEL);
+	if (!lif->txqstats)
+		goto err_out;
+	lif->rxqstats = devm_kcalloc(dev, lif->ionic->nrxqs_per_lif,
+				     sizeof(struct ionic_rx_stats), GFP_KERNEL);
+	if (!lif->rxqstats)
+		goto err_out;
 
-err_out_free_rx_stats:
-	for (i = 0; i < lif->nxqs; i++)
-		if (lif->rxqcqs[i].stats)
-			devm_kfree(dev, lif->rxqcqs[i].stats);
-	devm_kfree(dev, lif->rxqcqs);
-	lif->rxqcqs = NULL;
-err_out_free_tx_stats:
-	for (i = 0; i < lif->nxqs; i++)
-		if (lif->txqcqs[i].stats)
-			devm_kfree(dev, lif->txqcqs[i].stats);
-	devm_kfree(dev, lif->txqcqs);
-	lif->txqcqs = NULL;
-err_out_free_notifyqcq:
-	if (lif->notifyqcq) {
-		ionic_qcq_free(lif, lif->notifyqcq);
-		lif->notifyqcq = NULL;
-	}
-err_out_free_adminqcq:
-	ionic_qcq_free(lif, lif->adminqcq);
-	lif->adminqcq = NULL;
+	return 0;
 
+err_out:
+	ionic_qcqs_free(lif);
 	return err;
 }
 
@@ -630,7 +601,7 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
 		intr_index = qcq->intr.index;
 	else
-		intr_index = lif->rxqcqs[q->index].qcq->intr.index;
+		intr_index = lif->rxqcqs[q->index]->intr.index;
 	ctx.cmd.q_init.intr_index = cpu_to_le16(intr_index);
 
 	dev_dbg(dev, "txq_init.pid %d\n", ctx.cmd.q_init.pid);
@@ -1483,7 +1454,7 @@ static void ionic_txrx_disable(struct ionic_lif *lif)
 
 	if (lif->txqcqs) {
 		for (i = 0; i < lif->nxqs; i++) {
-			err = ionic_qcq_disable(lif->txqcqs[i].qcq);
+			err = ionic_qcq_disable(lif->txqcqs[i]);
 			if (err == -ETIMEDOUT)
 				break;
 		}
@@ -1491,7 +1462,7 @@ static void ionic_txrx_disable(struct ionic_lif *lif)
 
 	if (lif->rxqcqs) {
 		for (i = 0; i < lif->nxqs; i++) {
-			err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
+			err = ionic_qcq_disable(lif->rxqcqs[i]);
 			if (err == -ETIMEDOUT)
 				break;
 		}
@@ -1504,17 +1475,17 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 
 	if (lif->txqcqs) {
 		for (i = 0; i < lif->nxqs; i++) {
-			ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
-			ionic_tx_flush(&lif->txqcqs[i].qcq->cq);
-			ionic_tx_empty(&lif->txqcqs[i].qcq->q);
+			ionic_lif_qcq_deinit(lif, lif->txqcqs[i]);
+			ionic_tx_flush(&lif->txqcqs[i]->cq);
+			ionic_tx_empty(&lif->txqcqs[i]->q);
 		}
 	}
 
 	if (lif->rxqcqs) {
 		for (i = 0; i < lif->nxqs; i++) {
-			ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
-			ionic_rx_flush(&lif->rxqcqs[i].qcq->cq);
-			ionic_rx_empty(&lif->rxqcqs[i].qcq->q);
+			ionic_lif_qcq_deinit(lif, lif->rxqcqs[i]);
+			ionic_rx_flush(&lif->rxqcqs[i]->cq);
+			ionic_rx_empty(&lif->rxqcqs[i]->q);
 		}
 	}
 	lif->rx_mode = 0;
@@ -1526,15 +1497,15 @@ static void ionic_txrx_free(struct ionic_lif *lif)
 
 	if (lif->txqcqs) {
 		for (i = 0; i < lif->nxqs; i++) {
-			ionic_qcq_free(lif, lif->txqcqs[i].qcq);
-			lif->txqcqs[i].qcq = NULL;
+			ionic_qcq_free(lif, lif->txqcqs[i]);
+			lif->txqcqs[i] = NULL;
 		}
 	}
 
 	if (lif->rxqcqs) {
 		for (i = 0; i < lif->nxqs; i++) {
-			ionic_qcq_free(lif, lif->rxqcqs[i].qcq);
-			lif->rxqcqs[i].qcq = NULL;
+			ionic_qcq_free(lif, lif->rxqcqs[i]);
+			lif->rxqcqs[i] = NULL;
 		}
 	}
 }
@@ -1562,17 +1533,16 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 				      sizeof(struct ionic_txq_desc),
 				      sizeof(struct ionic_txq_comp),
 				      sg_desc_sz,
-				      lif->kern_pid, &lif->txqcqs[i].qcq);
+				      lif->kern_pid, &lif->txqcqs[i]);
 		if (err)
 			goto err_out;
 
 		if (flags & IONIC_QCQ_F_INTR)
 			ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-					     lif->txqcqs[i].qcq->intr.index,
+					     lif->txqcqs[i]->intr.index,
 					     lif->tx_coalesce_hw);
 
-		lif->txqcqs[i].qcq->stats = lif->txqcqs[i].stats;
-		ionic_debugfs_add_qcq(lif, lif->txqcqs[i].qcq);
+		ionic_debugfs_add_qcq(lif, lif->txqcqs[i]);
 	}
 
 	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG | IONIC_QCQ_F_INTR;
@@ -1582,20 +1552,19 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 				      sizeof(struct ionic_rxq_desc),
 				      sizeof(struct ionic_rxq_comp),
 				      sizeof(struct ionic_rxq_sg_desc),
-				      lif->kern_pid, &lif->rxqcqs[i].qcq);
+				      lif->kern_pid, &lif->rxqcqs[i]);
 		if (err)
 			goto err_out;
 
 		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-				     lif->rxqcqs[i].qcq->intr.index,
+				     lif->rxqcqs[i]->intr.index,
 				     lif->rx_coalesce_hw);
 
 		if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
-			ionic_link_qcq_interrupts(lif->rxqcqs[i].qcq,
-						  lif->txqcqs[i].qcq);
+			ionic_link_qcq_interrupts(lif->rxqcqs[i],
+						  lif->txqcqs[i]);
 
-		lif->rxqcqs[i].qcq->stats = lif->rxqcqs[i].stats;
-		ionic_debugfs_add_qcq(lif, lif->rxqcqs[i].qcq);
+		ionic_debugfs_add_qcq(lif, lif->rxqcqs[i]);
 	}
 
 	return 0;
@@ -1612,13 +1581,13 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 	int err;
 
 	for (i = 0; i < lif->nxqs; i++) {
-		err = ionic_lif_txq_init(lif, lif->txqcqs[i].qcq);
+		err = ionic_lif_txq_init(lif, lif->txqcqs[i]);
 		if (err)
 			goto err_out;
 
-		err = ionic_lif_rxq_init(lif, lif->rxqcqs[i].qcq);
+		err = ionic_lif_rxq_init(lif, lif->rxqcqs[i]);
 		if (err) {
-			ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
+			ionic_lif_qcq_deinit(lif, lif->txqcqs[i]);
 			goto err_out;
 		}
 	}
@@ -1632,8 +1601,8 @@ static int ionic_txrx_init(struct ionic_lif *lif)
 
 err_out:
 	while (i--) {
-		ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
-		ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
+		ionic_lif_qcq_deinit(lif, lif->txqcqs[i]);
+		ionic_lif_qcq_deinit(lif, lif->rxqcqs[i]);
 	}
 
 	return err;
@@ -1644,15 +1613,15 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 	int i, err;
 
 	for (i = 0; i < lif->nxqs; i++) {
-		ionic_rx_fill(&lif->rxqcqs[i].qcq->q);
-		err = ionic_qcq_enable(lif->rxqcqs[i].qcq);
+		ionic_rx_fill(&lif->rxqcqs[i]->q);
+		err = ionic_qcq_enable(lif->rxqcqs[i]);
 		if (err)
 			goto err_out;
 
-		err = ionic_qcq_enable(lif->txqcqs[i].qcq);
+		err = ionic_qcq_enable(lif->txqcqs[i]);
 		if (err) {
 			if (err != -ETIMEDOUT)
-				ionic_qcq_disable(lif->rxqcqs[i].qcq);
+				ionic_qcq_disable(lif->rxqcqs[i]);
 			goto err_out;
 		}
 	}
@@ -1661,10 +1630,10 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 
 err_out:
 	while (i--) {
-		err = ionic_qcq_disable(lif->txqcqs[i].qcq);
+		err = ionic_qcq_disable(lif->txqcqs[i]);
 		if (err == -ETIMEDOUT)
 			break;
-		err = ionic_qcq_disable(lif->rxqcqs[i].qcq);
+		err = ionic_qcq_disable(lif->rxqcqs[i]);
 		if (err == -ETIMEDOUT)
 			break;
 	}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 95d85502c18d..aa1cba74ba9b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -56,13 +56,6 @@ struct ionic_napi_stats {
 	u64 work_done_cntr[IONIC_MAX_NUM_NAPI_CNTR];
 };
 
-struct ionic_q_stats {
-	union {
-		struct ionic_tx_stats tx;
-		struct ionic_rx_stats rx;
-	};
-};
-
 struct ionic_qcq {
 	void *base;
 	dma_addr_t base_pa;
@@ -72,19 +65,13 @@ struct ionic_qcq {
 	struct ionic_intr_info intr;
 	struct napi_struct napi;
 	struct ionic_napi_stats napi_stats;
-	struct ionic_q_stats *stats;
 	unsigned int flags;
 	struct dentry *dentry;
 };
 
-struct ionic_qcqst {
-	struct ionic_qcq *qcq;
-	struct ionic_q_stats *stats;
-};
-
 #define q_to_qcq(q)		container_of(q, struct ionic_qcq, q)
-#define q_to_tx_stats(q)	(&q_to_qcq(q)->stats->tx)
-#define q_to_rx_stats(q)	(&q_to_qcq(q)->stats->rx)
+#define q_to_tx_stats(q)	(&(q)->lif->txqstats[(q)->index])
+#define q_to_rx_stats(q)	(&(q)->lif->rxqstats[(q)->index])
 #define napi_to_qcq(napi)	container_of(napi, struct ionic_qcq, napi)
 #define napi_to_cq(napi)	(&napi_to_qcq(napi)->cq)
 
@@ -170,8 +157,10 @@ struct ionic_lif {
 	spinlock_t adminq_lock;		/* lock for AdminQ operations */
 	struct ionic_qcq *adminqcq;
 	struct ionic_qcq *notifyqcq;
-	struct ionic_qcqst *txqcqs;
-	struct ionic_qcqst *rxqcqs;
+	struct ionic_qcq **txqcqs;
+	struct ionic_tx_stats *txqstats;
+	struct ionic_qcq **rxqcqs;
+	struct ionic_rx_stats *rxqstats;
 	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
@@ -212,13 +201,6 @@ struct ionic_lif {
 	struct work_struct tx_timeout_work;
 };
 
-#define lif_to_txqcq(lif, i)	((lif)->txqcqs[i].qcq)
-#define lif_to_rxqcq(lif, i)	((lif)->rxqcqs[i].qcq)
-#define lif_to_txstats(lif, i)	((lif)->txqcqs[i].stats->tx)
-#define lif_to_rxstats(lif, i)	((lif)->rxqcqs[i].stats->rx)
-#define lif_to_txq(lif, i)	(&lif_to_txqcq((lif), i)->q)
-#define lif_to_rxq(lif, i)	(&lif_to_txqcq((lif), i)->q)
-
 static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
 {
 	u32 mult = le32_to_cpu(ionic->ident.dev.intr_coal_mult);
@@ -258,18 +240,18 @@ int ionic_open(struct net_device *netdev);
 int ionic_stop(struct net_device *netdev);
 int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg);
 
-static inline void debug_stats_txq_post(struct ionic_qcq *qcq,
+static inline void debug_stats_txq_post(struct ionic_queue *q,
 					struct ionic_txq_desc *desc, bool dbell)
 {
 	u8 num_sg_elems = ((le64_to_cpu(desc->cmd) >> IONIC_TXQ_DESC_NSGE_SHIFT)
 						& IONIC_TXQ_DESC_NSGE_MASK);
 
-	qcq->q.dbell_count += dbell;
+	q->dbell_count += dbell;
 
 	if (num_sg_elems > (IONIC_MAX_NUM_SG_CNTR - 1))
 		num_sg_elems = IONIC_MAX_NUM_SG_CNTR - 1;
 
-	qcq->stats->tx.sg_cntr[num_sg_elems]++;
+	q->lif->txqstats[q->index].sg_cntr[num_sg_elems]++;
 }
 
 static inline void debug_stats_napi_poll(struct ionic_qcq *qcq,
@@ -284,10 +266,10 @@ static inline void debug_stats_napi_poll(struct ionic_qcq *qcq,
 }
 
 #define DEBUG_STATS_CQE_CNT(cq)		((cq)->compl_count++)
-#define DEBUG_STATS_RX_BUFF_CNT(qcq)	((qcq)->stats->rx.buffers_posted++)
+#define DEBUG_STATS_RX_BUFF_CNT(q)	((q)->lif->rxqstats[q->index].buffers_posted++)
 #define DEBUG_STATS_INTR_REARM(intr)	((intr)->rearm_count++)
-#define DEBUG_STATS_TXQ_POST(qcq, txdesc, dbell) \
-	debug_stats_txq_post(qcq, txdesc, dbell)
+#define DEBUG_STATS_TXQ_POST(q, txdesc, dbell) \
+	debug_stats_txq_post(q, txdesc, dbell)
 #define DEBUG_STATS_NAPI_POLL(qcq, work_done) \
 	debug_stats_napi_poll(qcq, work_done)
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
index 2a1885da58a6..ff20a2ac4c2f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_stats.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -179,36 +179,28 @@ static const struct ionic_stat_desc ionic_dbg_napi_stats_desc[] = {
 static void ionic_get_lif_stats(struct ionic_lif *lif,
 				struct ionic_lif_sw_stats *stats)
 {
-	struct ionic_tx_stats *tstats;
-	struct ionic_rx_stats *rstats;
+	struct ionic_tx_stats *txstats;
+	struct ionic_rx_stats *rxstats;
 	struct rtnl_link_stats64 ns;
-	struct ionic_qcq *txqcq;
-	struct ionic_qcq *rxqcq;
 	int q_num;
 
 	memset(stats, 0, sizeof(*stats));
 
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		txqcq = lif_to_txqcq(lif, q_num);
-		if (txqcq && txqcq->stats) {
-			tstats = &txqcq->stats->tx;
-			stats->tx_packets += tstats->pkts;
-			stats->tx_bytes += tstats->bytes;
-			stats->tx_tso += tstats->tso;
-			stats->tx_tso_bytes += tstats->tso_bytes;
-			stats->tx_csum_none += tstats->csum_none;
-			stats->tx_csum += tstats->csum;
-		}
-
-		rxqcq = lif_to_rxqcq(lif, q_num);
-		if (rxqcq && rxqcq->stats) {
-			rstats = &rxqcq->stats->rx;
-			stats->rx_packets += rstats->pkts;
-			stats->rx_bytes += rstats->bytes;
-			stats->rx_csum_none += rstats->csum_none;
-			stats->rx_csum_complete += rstats->csum_complete;
-			stats->rx_csum_error += rstats->csum_error;
-		}
+		txstats = &lif->txqstats[q_num];
+		stats->tx_packets += txstats->pkts;
+		stats->tx_bytes += txstats->bytes;
+		stats->tx_tso += txstats->tso;
+		stats->tx_tso_bytes += txstats->tso_bytes;
+		stats->tx_csum_none += txstats->csum_none;
+		stats->tx_csum += txstats->csum;
+
+		rxstats = &lif->rxqstats[q_num];
+		stats->rx_packets += rxstats->pkts;
+		stats->rx_bytes += rxstats->bytes;
+		stats->rx_csum_none += rxstats->csum_none;
+		stats->rx_csum_complete += rxstats->csum_complete;
+		stats->rx_csum_error += rxstats->csum_error;
 	}
 
 	ionic_get_stats64(lif->netdev, &ns);
@@ -371,7 +363,7 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 	}
 
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		txstats = &lif_to_txstats(lif, q_num);
+		txstats = &lif->txqstats[q_num];
 
 		for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
 			**buf = IONIC_READ_STAT64(txstats,
@@ -381,7 +373,7 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 
 		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
 		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
-			txqcq = lif_to_txqcq(lif, q_num);
+			txqcq = lif->txqcqs[q_num];
 			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
 				**buf = IONIC_READ_STAT64(&txqcq->q,
 						      &ionic_txq_stats_desc[i]);
@@ -405,7 +397,7 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 	}
 
 	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
-		rxstats = &lif_to_rxstats(lif, q_num);
+		rxstats = &lif->rxqstats[q_num];
 
 		for (i = 0; i < IONIC_NUM_RX_STATS; i++) {
 			**buf = IONIC_READ_STAT64(rxstats,
@@ -415,7 +407,7 @@ static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
 
 		if (test_bit(IONIC_LIF_F_UP, lif->state) &&
 		    test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state)) {
-			rxqcq = lif_to_rxqcq(lif, q_num);
+			rxqcq = lif->rxqcqs[q_num];
 			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
 				**buf = IONIC_READ_STAT64(&rxqcq->cq,
 						   &ionic_dbg_cq_stats_desc[i]);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 8107d32c2767..220e132164e2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -22,7 +22,7 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell,
 				  ionic_desc_cb cb_func, void *cb_arg)
 {
-	DEBUG_STATS_TXQ_POST(q_to_qcq(q), q->head->desc, ring_dbell);
+	DEBUG_STATS_TXQ_POST(q, q->head->desc, ring_dbell);
 
 	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
 }
@@ -32,7 +32,7 @@ static inline void ionic_rxq_post(struct ionic_queue *q, bool ring_dbell,
 {
 	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
 
-	DEBUG_STATS_RX_BUFF_CNT(q_to_qcq(q));
+	DEBUG_STATS_RX_BUFF_CNT(q);
 }
 
 static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
@@ -49,7 +49,7 @@ static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q,
 	struct sk_buff *skb;
 
 	netdev = lif->netdev;
-	stats = q_to_rx_stats(q);
+	stats = &q->lif->rxqstats[q->index];
 
 	if (frags)
 		skb = napi_get_frags(&q_to_qcq(q)->napi);
@@ -502,7 +502,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 
 	lif = rxcq->bound_q->lif;
 	idev = &lif->ionic->idev;
-	txcq = &lif->txqcqs[qi].qcq->cq;
+	txcq = &lif->txqcqs[qi]->cq;
 
 	tx_work_done = ionic_cq_service(txcq, lif->tx_budget,
 					ionic_tx_service, NULL, NULL);
@@ -1111,9 +1111,9 @@ netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_OK;
 	}
 
-	if (unlikely(!lif_to_txqcq(lif, queue_index)))
+	if (unlikely(queue_index >= lif->nxqs))
 		queue_index = 0;
-	q = lif_to_txq(lif, queue_index);
+	q = &lif->txqcqs[queue_index]->q;
 
 	ndescs = ionic_tx_descs_needed(q, skb);
 	if (ndescs < 0)
-- 
2.17.1

