Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E337233C5F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbgGaABb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730767AbgGaAB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:01:29 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C9EC061575
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:01:28 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m16so15714919pls.5
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y07yiMNO5wZtZfZUugP+XqPVby6nrYph/e6s74qNWAo=;
        b=QPG7hRk1xN6GRR/intzMybQvN/oxkVARYcINNImrqzeIJuFmxpJ15UIxUQFCqDK3O9
         DZUjZnzaMmUEu1bkVGWR5ATkydj8NWiPViXWREIRcS/53kmm6SNwOxkiy/x8lfjr78ug
         EvSdEe7OhIku1BKrU3YcEaOB3TESEdRahpccvfw2e8XQFPBbSTpGNMkUpTY6lopASp0Q
         PYDerFuLWADa6xbGTR4m6r+IbVkfhpvBbuX1UVJVeib5HQ+9Ul8g2i7FbgiTf5IoLbow
         a0qEKuaZM/JGYeueFloMJ/msynkCwYPX1cNSJ3mwCd5m7ZudEBTGk4hyHkexZlpLiX8a
         ssPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y07yiMNO5wZtZfZUugP+XqPVby6nrYph/e6s74qNWAo=;
        b=EW44Q1EbJfefZu7/fDzhhl0/7n1q9zeoLrXsU2LRotUSQoYG7e3oSutG7EnbQRRFiQ
         NlNhhcuy+F9OnWHeN2opyF4QoDRZWM7fXs6MaQIwigMnpsKA8P/PavGm474IobBi889b
         uuhQMXkdStoavgZXsMngDAAyp/jTiDWV87eHTqg39oaDZ7TpiWWdp6TtwFZYUy2ObcvU
         tRexSl+ZEmUT0Qhf3dW0MVoujBJXA7v1SW13XbWAeynaCkXIE1Ok2VAEonByvezkjgIo
         U6Q7PfKoJtMUW+9lyoTFI4E+Lg/Sg4dtC2SdeP3tam3+xwKFxq38C6Dkj9WCuCqygAnn
         h8cw==
X-Gm-Message-State: AOAM533r/+Q9aQMwssaaaVTATkVBn7oDl/06DuhxkifpIlHuv6hFRJ4w
        K/i5WB73YLbZeMVphNLyY/By++52HKE=
X-Google-Smtp-Source: ABdhPJyje7+o4vvx/FvUR04Ejwsf66KoaIfUP7+TdzJhKCjO68NIV8bFRhbFLkwLeUn4vgs93ZCSzQ==
X-Received: by 2002:a63:5613:: with SMTP id k19mr1275233pgb.424.1596153687831;
        Thu, 30 Jul 2020 17:01:27 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm7592436pgf.53.2020.07.30.17.01.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 17:01:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/3] ionic: separate interrupt for Tx and Rx
Date:   Thu, 30 Jul 2020 17:00:58 -0700
Message-Id: <20200731000058.37344-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731000058.37344-1-snelson@pensando.io>
References: <20200731000058.37344-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the capability to split the Tx queues onto their own
interrupts with their own napi contexts.  This gives the
opportunity for more direct control of Tx interrupt
handling, such as CPU affinity and interrupt coalescing,
useful for some traffic loads.

v2: use ethtool -L, not a vendor specific priv-flag

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 109 ++++++++++++++----
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  41 +++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  67 +++++++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   2 +
 5 files changed, 195 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 095561924bdc..3901491bc62c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -403,8 +403,7 @@ static int ionic_get_coalesce(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
-	/* Tx uses Rx interrupt */
-	coalesce->tx_coalesce_usecs = lif->rx_coalesce_usecs;
+	coalesce->tx_coalesce_usecs = lif->tx_coalesce_usecs;
 	coalesce->rx_coalesce_usecs = lif->rx_coalesce_usecs;
 
 	return 0;
@@ -417,7 +416,8 @@ static int ionic_set_coalesce(struct net_device *netdev,
 	struct ionic_identity *ident;
 	struct ionic_qcq *qcq;
 	unsigned int i;
-	u32 coal;
+	u32 rx_coal;
+	u32 tx_coal;
 
 	ident = &lif->ionic->ident;
 	if (ident->dev.intr_coal_div == 0) {
@@ -426,26 +426,31 @@ static int ionic_set_coalesce(struct net_device *netdev,
 		return -EIO;
 	}
 
-	/* Tx uses Rx interrupt, so only change Rx */
-	if (coalesce->tx_coalesce_usecs != lif->rx_coalesce_usecs) {
+	/* Tx normally shares Rx interrupt, so only change Rx */
+	if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state) &&
+	    coalesce->tx_coalesce_usecs != lif->rx_coalesce_usecs) {
 		netdev_warn(netdev, "only the rx-usecs can be changed\n");
 		return -EINVAL;
 	}
 
-	/* Convert the usec request to a HW useable value.  If they asked
+	/* Convert the usec request to a HW usable value.  If they asked
 	 * for non-zero and it resolved to zero, bump it up
 	 */
-	coal = ionic_coal_usec_to_hw(lif->ionic, coalesce->rx_coalesce_usecs);
-	if (!coal && coalesce->rx_coalesce_usecs)
-		coal = 1;
-
-	if (coal > IONIC_INTR_CTRL_COAL_MAX)
+	rx_coal = ionic_coal_usec_to_hw(lif->ionic, coalesce->rx_coalesce_usecs);
+	if (!rx_coal && coalesce->rx_coalesce_usecs)
+		rx_coal = 1;
+	tx_coal = ionic_coal_usec_to_hw(lif->ionic, coalesce->tx_coalesce_usecs);
+	if (!tx_coal && coalesce->tx_coalesce_usecs)
+		tx_coal = 1;
+
+	if (rx_coal > IONIC_INTR_CTRL_COAL_MAX ||
+	    tx_coal > IONIC_INTR_CTRL_COAL_MAX)
 		return -ERANGE;
 
-	/* Save the new value */
+	/* Save the new values */
 	lif->rx_coalesce_usecs = coalesce->rx_coalesce_usecs;
-	if (coal != lif->rx_coalesce_hw) {
-		lif->rx_coalesce_hw = coal;
+	if (rx_coal != lif->rx_coalesce_hw) {
+		lif->rx_coalesce_hw = rx_coal;
 
 		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 			for (i = 0; i < lif->nxqs; i++) {
@@ -457,6 +462,23 @@ static int ionic_set_coalesce(struct net_device *netdev,
 		}
 	}
 
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		lif->tx_coalesce_usecs = coalesce->tx_coalesce_usecs;
+	else
+		lif->tx_coalesce_usecs = coalesce->rx_coalesce_usecs;
+	if (tx_coal != lif->tx_coalesce_hw) {
+		lif->tx_coalesce_hw = tx_coal;
+
+		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
+			for (i = 0; i < lif->nxqs; i++) {
+				qcq = lif->txqcqs[i].qcq;
+				ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+						     qcq->intr.index,
+						     lif->tx_coalesce_hw);
+			}
+		}
+	}
+
 	return 0;
 }
 
@@ -510,29 +532,76 @@ static void ionic_get_channels(struct net_device *netdev,
 
 	/* report maximum channels */
 	ch->max_combined = lif->ionic->ntxqs_per_lif;
+	ch->max_rx = lif->ionic->ntxqs_per_lif / 2;
+	ch->max_tx = lif->ionic->ntxqs_per_lif / 2;
 
 	/* report current channels */
-	ch->combined_count = lif->nxqs;
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state)) {
+		ch->rx_count = lif->nxqs;
+		ch->tx_count = lif->nxqs;
+	} else {
+		ch->combined_count = lif->nxqs;
+	}
 }
 
 static void ionic_set_queuecount(struct ionic_lif *lif, void *arg)
 {
 	struct ethtool_channels *ch = arg;
 
-	lif->nxqs = ch->combined_count;
+	if (ch->combined_count) {
+		lif->nxqs = ch->combined_count;
+		if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state)) {
+			clear_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+			lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
+			lif->tx_coalesce_hw = lif->rx_coalesce_hw;
+			netdev_info(lif->netdev, "Sharing queue interrupts\n");
+		}
+	} else {
+		lif->nxqs = ch->rx_count;
+		if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state)) {
+			set_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+			netdev_info(lif->netdev, "Splitting queue interrupts\n");
+		}
+	}
 }
 
 static int ionic_set_channels(struct net_device *netdev,
 			      struct ethtool_channels *ch)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	int max_cnt;
 
-	if (!ch->combined_count || ch->other_count ||
-	    ch->rx_count || ch->tx_count)
+	if (ch->rx_count != ch->tx_count) {
+		netdev_info(netdev, "The rx and tx count must be equal\n");
 		return -EINVAL;
+	}
 
-	if (ch->combined_count == lif->nxqs)
-		return 0;
+	if (ch->combined_count && ch->rx_count) {
+		netdev_info(netdev, "Use either combined_count or rx/tx_count, not both\n");
+		return -EINVAL;
+	}
+
+	max_cnt = lif->ionic->ntxqs_per_lif;
+	if (ch->combined_count) {
+		if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state) &&
+		    (ch->combined_count == lif->nxqs)) {
+			netdev_info(netdev, "No change a\n");
+			return 0;
+		}
+
+		netdev_info(netdev, "Changing queue count from %d to %d\n",
+			    lif->nxqs, ch->combined_count);
+	} else {
+		max_cnt /= 2;
+		if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state) &&
+		    (ch->rx_count == lif->nxqs)) {
+			netdev_info(netdev, "No change b\n");
+			return 0;
+		}
+
+		netdev_info(netdev, "Changing queue count from %d to %d\n",
+			    lif->nxqs, ch->rx_count);
+	}
 
 	return ionic_reset_queues(lif, ionic_set_queuecount, ch);
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index b228362363ca..28868d343540 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -616,7 +616,6 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.index = cpu_to_le32(q->index),
 			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
 					     IONIC_QINIT_F_SG),
-			.intr_index = cpu_to_le16(lif->rxqcqs[q->index].qcq->intr.index),
 			.pid = cpu_to_le16(q->pid),
 			.ring_size = ilog2(q->num_descs),
 			.ring_base = cpu_to_le64(q->base_pa),
@@ -624,14 +623,22 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.sg_ring_base = cpu_to_le64(q->sg_base_pa),
 		},
 	};
+	unsigned int intr_index;
 	int err;
 
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		intr_index = qcq->intr.index;
+	else
+		intr_index = lif->rxqcqs[q->index].qcq->intr.index;
+	ctx.cmd.q_init.intr_index = cpu_to_le16(intr_index);
+
 	dev_dbg(dev, "txq_init.pid %d\n", ctx.cmd.q_init.pid);
 	dev_dbg(dev, "txq_init.index %d\n", ctx.cmd.q_init.index);
 	dev_dbg(dev, "txq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
 	dev_dbg(dev, "txq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
 	dev_dbg(dev, "txq_init.flags 0x%x\n", ctx.cmd.q_init.flags);
 	dev_dbg(dev, "txq_init.ver %d\n", ctx.cmd.q_init.ver);
+	dev_dbg(dev, "txq_init.intr_index %d\n", ctx.cmd.q_init.intr_index);
 
 	q->tail = q->info;
 	q->head = q->tail;
@@ -648,6 +655,10 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "txq->hw_index %d\n", q->hw_index);
 
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		netif_napi_add(lif->netdev, &qcq->napi, ionic_tx_napi,
+			       NAPI_POLL_WEIGHT);
+
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
 	return 0;
@@ -684,6 +695,7 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
 	dev_dbg(dev, "rxq_init.flags 0x%x\n", ctx.cmd.q_init.flags);
 	dev_dbg(dev, "rxq_init.ver %d\n", ctx.cmd.q_init.ver);
+	dev_dbg(dev, "rxq_init.intr_index %d\n", ctx.cmd.q_init.intr_index);
 
 	q->tail = q->info;
 	q->head = q->tail;
@@ -700,8 +712,12 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "rxq->hw_index %d\n", q->hw_index);
 
-	netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi,
-		       NAPI_POLL_WEIGHT);
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi,
+			       NAPI_POLL_WEIGHT);
+	else
+		netif_napi_add(lif->netdev, &qcq->napi, ionic_txrx_napi,
+			       NAPI_POLL_WEIGHT);
 
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
@@ -1537,6 +1553,8 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
 
 	flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		flags |= IONIC_QCQ_F_INTR;
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
 				      lif->ntxq_descs,
@@ -1547,6 +1565,11 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		if (err)
 			goto err_out;
 
+		if (flags & IONIC_QCQ_F_INTR)
+			ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
+					     lif->txqcqs[i].qcq->intr.index,
+					     lif->tx_coalesce_hw);
+
 		lif->txqcqs[i].qcq->stats = lif->txqcqs[i].stats;
 		ionic_debugfs_add_qcq(lif, lif->txqcqs[i].qcq);
 	}
@@ -1562,13 +1585,15 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		if (err)
 			goto err_out;
 
-		lif->rxqcqs[i].qcq->stats = lif->rxqcqs[i].stats;
-
 		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
 				     lif->rxqcqs[i].qcq->intr.index,
 				     lif->rx_coalesce_hw);
-		ionic_link_qcq_interrupts(lif->rxqcqs[i].qcq,
-					  lif->txqcqs[i].qcq);
+
+		if (!test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+			ionic_link_qcq_interrupts(lif->rxqcqs[i].qcq,
+						  lif->txqcqs[i].qcq);
+
+		lif->rxqcqs[i].qcq->stats = lif->rxqcqs[i].stats;
 		ionic_debugfs_add_qcq(lif, lif->rxqcqs[i].qcq);
 	}
 
@@ -2069,6 +2094,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->rx_coalesce_usecs = IONIC_ITR_COAL_USEC_DEFAULT;
 	lif->rx_coalesce_hw = ionic_coal_usec_to_hw(lif->ionic,
 						    lif->rx_coalesce_usecs);
+	lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
+	lif->tx_coalesce_hw = lif->rx_coalesce_hw;
 
 	snprintf(lif->name, sizeof(lif->name), "lif%u", index);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 13f173d83970..1ee3b14c8d50 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -137,6 +137,7 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_UP,
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_FW_RESET,
+	IONIC_LIF_F_SPLIT_INTR,
 
 	/* leave this as last */
 	IONIC_LIF_F_STATE_SIZE
@@ -205,6 +206,8 @@ struct ionic_lif {
 	struct dentry *dentry;
 	u32 rx_coalesce_usecs;		/* what the user asked for */
 	u32 rx_coalesce_hw;		/* what the hw is using */
+	u32 tx_coalesce_usecs;		/* what the user asked for */
+	u32 tx_coalesce_hw;		/* what the hw is using */
 
 	struct work_struct tx_timeout_work;
 };
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 766f4595895c..8107d32c2767 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -419,7 +419,74 @@ void ionic_rx_empty(struct ionic_queue *q)
 	}
 }
 
+int ionic_tx_napi(struct napi_struct *napi, int budget)
+{
+	struct ionic_qcq *qcq = napi_to_qcq(napi);
+	struct ionic_cq *cq = napi_to_cq(napi);
+	struct ionic_dev *idev;
+	struct ionic_lif *lif;
+	u32 work_done = 0;
+	u32 flags = 0;
+
+	lif = cq->bound_q->lif;
+	idev = &lif->ionic->idev;
+
+	work_done = ionic_cq_service(cq, budget,
+				     ionic_tx_service, NULL, NULL);
+
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		flags |= IONIC_INTR_CRED_UNMASK;
+		DEBUG_STATS_INTR_REARM(cq->bound_intr);
+	}
+
+	if (work_done || flags) {
+		flags |= IONIC_INTR_CRED_RESET_COALESCE;
+		ionic_intr_credits(idev->intr_ctrl,
+				   cq->bound_intr->index,
+				   work_done, flags);
+	}
+
+	DEBUG_STATS_NAPI_POLL(qcq, work_done);
+
+	return work_done;
+}
+
 int ionic_rx_napi(struct napi_struct *napi, int budget)
+{
+	struct ionic_qcq *qcq = napi_to_qcq(napi);
+	struct ionic_cq *cq = napi_to_cq(napi);
+	struct ionic_dev *idev;
+	struct ionic_lif *lif;
+	u32 work_done = 0;
+	u32 flags = 0;
+
+	lif = cq->bound_q->lif;
+	idev = &lif->ionic->idev;
+
+	work_done = ionic_cq_service(cq, budget,
+				     ionic_rx_service, NULL, NULL);
+
+	if (work_done)
+		ionic_rx_fill(cq->bound_q);
+
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		flags |= IONIC_INTR_CRED_UNMASK;
+		DEBUG_STATS_INTR_REARM(cq->bound_intr);
+	}
+
+	if (work_done || flags) {
+		flags |= IONIC_INTR_CRED_RESET_COALESCE;
+		ionic_intr_credits(idev->intr_ctrl,
+				   cq->bound_intr->index,
+				   work_done, flags);
+	}
+
+	DEBUG_STATS_NAPI_POLL(qcq, work_done);
+
+	return work_done;
+}
+
+int ionic_txrx_napi(struct napi_struct *napi, int budget)
 {
 	struct ionic_qcq *qcq = napi_to_qcq(napi);
 	struct ionic_cq *rxcq = napi_to_cq(napi);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
index 71973e3c35a6..a5883be0413f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
@@ -11,6 +11,8 @@ void ionic_rx_fill(struct ionic_queue *q);
 void ionic_rx_empty(struct ionic_queue *q);
 void ionic_tx_empty(struct ionic_queue *q);
 int ionic_rx_napi(struct napi_struct *napi, int budget);
+int ionic_tx_napi(struct napi_struct *napi, int budget);
+int ionic_txrx_napi(struct napi_struct *napi, int budget);
 netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev);
 
 #endif /* _IONIC_TXRX_H_ */
-- 
2.17.1

