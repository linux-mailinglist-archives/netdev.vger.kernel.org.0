Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CDC22D340
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgGYAXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgGYAXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:23:39 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27ECC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:38 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id cv18so6521461pjb.1
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nZnTi0KOsk/oenDmkhqfp9oFlC1mmcwwSJJP5RX3+FA=;
        b=SWVoJnzJtnZC7JbjUecDNWsPiWQH0nKDs4RsUw76CGdL7RsW4KBkCOQNqWxqyQHrpX
         Sr2vZ1cCPBIyw8Mr1Ypkstvn182nuDsouoO+Lo5kcX8Djlxl/q78jB2EaO9tir/FS3GI
         o6C8D1aqr0qfAyvAPgJ6a6iAbxf2U190cKOXd4/GptLdLF137y1aoHgwGibK2yxqZ8VV
         GsF7rAwW0Y0VS+tuN+JuutF1IATW//Vcneh0dqYnUkYzWRnsDqIgoOKp6UJ1/0+TNU+Y
         qUWLlfYozwboFDsD+3Zw6IX4DqRmaEpfeeEXErbbj8aa5oYi16lqMIeZiNgDYJUMZ7oA
         gwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nZnTi0KOsk/oenDmkhqfp9oFlC1mmcwwSJJP5RX3+FA=;
        b=feiLEUqeMJ627dIYHpGfFG8g27auBAWbw1Ht/UIYkGqfAp/MzZMPwja6krwE0WGlwK
         Dgar2OV28QChOovgTAHM14tQP8JskgElYVfLOb7XltWMhcbheFAdxzP/jKrCF5aTf3/D
         QpZuDdxhY5dkdr3BIYXnb0OfdrrNkfBSIqfc0p6ZAp/wDlfRmY4xNJGQYSobXCwISM0y
         ClytZ0oMqsfdYfzXKpEwweXlG25dT5pX36H9mVOS369r8KvpmicybqemZO8cX08K0JAW
         gTbQDDBCmvqbHH0ANbYhfT923E20lxB/ZAKMO++ljwlhy0gKYdTuh9EJ4Olsg0wgYUs5
         Wm3g==
X-Gm-Message-State: AOAM532cZ9Y5SYU7CJ0uCThWRiMPtSLatgo20HQUJkhnmWTW7BMYJTSt
        IimSBr+gP6T2y17UifsjUOjjK4Z7Ym0=
X-Google-Smtp-Source: ABdhPJxM0u1EY5wRZ0/QCi3szmNWS1+X/hWEgdztWP4PdNrLKAYDa1AK2puNEGtZui5AGPXpJgRe5w==
X-Received: by 2002:a17:90a:14a5:: with SMTP id k34mr8166681pja.37.1595636617652;
        Fri, 24 Jul 2020 17:23:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id lr1sm8400368pjb.27.2020.07.24.17.23.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 17:23:36 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/4] ionic: separate interrupt for Tx and Rx
Date:   Fri, 24 Jul 2020 17:23:26 -0700
Message-Id: <20200725002326.41407-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725002326.41407-1-snelson@pensando.io>
References: <20200725002326.41407-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the capability to split the Tx queues onto their own
interrupts with their own napi contexts.  This gives the
opportunity for more direct control of Tx interrupt
handling, such as CPU affinity and interrupt coalescing,
useful for some traffic loads.

To enable, use the ethtool private flag:
	ethtool --set-priv-flag enp20s0 split-q-intr on
To restore defaults
	ethtool --set-priv-flag enp20s0 split-q-intr off

When enabled, the number of queues is cut in half in order
to reuse the interrupts that have already been allocated to
the device.  When disabled, the queue count is restored.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 95 ++++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 41 ++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  3 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 67 +++++++++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |  2 +
 5 files changed, 187 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index b48f0e46584b..025b6ddaef67 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -14,6 +14,8 @@
 static const char ionic_priv_flags_strings[][ETH_GSTRING_LEN] = {
 #define IONIC_PRIV_F_SW_DBG_STATS	BIT(0)
 	"sw-dbg-stats",
+#define IONIC_PRIV_F_SPLIT_INTR		BIT(1)
+	"split-q-intr",
 };
 
 #define IONIC_PRIV_FLAGS_COUNT ARRAY_SIZE(ionic_priv_flags_strings)
@@ -400,8 +402,7 @@ static int ionic_get_coalesce(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 
-	/* Tx uses Rx interrupt */
-	coalesce->tx_coalesce_usecs = lif->rx_coalesce_usecs;
+	coalesce->tx_coalesce_usecs = lif->tx_coalesce_usecs;
 	coalesce->rx_coalesce_usecs = lif->rx_coalesce_usecs;
 
 	return 0;
@@ -414,7 +415,8 @@ static int ionic_set_coalesce(struct net_device *netdev,
 	struct ionic_identity *ident;
 	struct ionic_qcq *qcq;
 	unsigned int i;
-	u32 coal;
+	u32 rx_coal;
+	u32 tx_coal;
 
 	ident = &lif->ionic->ident;
 	if (ident->dev.intr_coal_div == 0) {
@@ -423,26 +425,31 @@ static int ionic_set_coalesce(struct net_device *netdev,
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
@@ -454,6 +461,23 @@ static int ionic_set_coalesce(struct net_device *netdev,
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
 
@@ -544,11 +568,19 @@ static int ionic_set_channels(struct net_device *netdev,
 			      struct ethtool_channels *ch)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	int max_cnt;
 
 	if (!ch->combined_count || ch->other_count ||
 	    ch->rx_count || ch->tx_count)
 		return -EINVAL;
 
+	max_cnt = lif->ionic->ntxqs_per_lif;
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		max_cnt /= 2;
+
+	if (ch->combined_count > max_cnt)
+		return -EINVAL;
+
 	if (ch->combined_count == lif->nxqs)
 		return 0;
 
@@ -563,17 +595,52 @@ static u32 ionic_get_priv_flags(struct net_device *netdev)
 	if (test_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state))
 		priv_flags |= IONIC_PRIV_F_SW_DBG_STATS;
 
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		priv_flags |= IONIC_PRIV_F_SPLIT_INTR;
+
 	return priv_flags;
 }
 
+static void ionic_set_split_intr(struct ionic_lif *lif, void *arg)
+{
+	int old_nxqs = lif->nxqs;
+	int new_sqintr = !!arg;
+
+	if (new_sqintr) {
+		/* split the queues across the interrupts */
+		lif->nxqs /= 2;
+		set_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+	} else {
+		/* combine Tx and Rx queues on the interrupts */
+		lif->nxqs *= 2;
+		clear_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+		lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
+		lif->tx_coalesce_hw = lif->rx_coalesce_hw;
+	}
+
+	netdev_info(lif->netdev, "%s queue interrupts and changing queue count from %d to %d\n",
+		    new_sqintr ? "Splitting" : "Sharing", old_nxqs, lif->nxqs);
+}
+
 static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	int sqintr, new_sqintr;
 
 	clear_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state);
 	if (priv_flags & IONIC_PRIV_F_SW_DBG_STATS)
 		set_bit(IONIC_LIF_F_SW_DEBUG_STATS, lif->state);
 
+	sqintr = test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+	new_sqintr = !!(priv_flags & IONIC_PRIV_F_SPLIT_INTR);
+	if (sqintr != new_sqintr) {
+		void *arg = 0;
+
+		if (new_sqintr)
+			arg = (void *)1;
+		ionic_reset_queues(lif, ionic_set_split_intr, arg);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 99b4e3dac245..723dd2394b18 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -611,7 +611,6 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 			.index = cpu_to_le32(q->index),
 			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
 					     IONIC_QINIT_F_SG),
-			.intr_index = cpu_to_le16(lif->rxqcqs[q->index].qcq->intr.index),
 			.pid = cpu_to_le16(q->pid),
 			.ring_size = ilog2(q->num_descs),
 			.ring_base = cpu_to_le64(q->base_pa),
@@ -619,14 +618,22 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
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
@@ -643,6 +650,10 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq->hw_type %d\n", q->hw_type);
 	dev_dbg(dev, "txq->hw_index %d\n", q->hw_index);
 
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		netif_napi_add(lif->netdev, &qcq->napi, ionic_tx_napi,
+			       NAPI_POLL_WEIGHT);
+
 	qcq->flags |= IONIC_QCQ_F_INITED;
 
 	return 0;
@@ -679,6 +690,7 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
 	dev_dbg(dev, "rxq_init.flags 0x%x\n", ctx.cmd.q_init.flags);
 	dev_dbg(dev, "rxq_init.ver %d\n", ctx.cmd.q_init.ver);
+	dev_dbg(dev, "rxq_init.intr_index %d\n", ctx.cmd.q_init.intr_index);
 
 	q->tail = q->info;
 	q->head = q->tail;
@@ -695,8 +707,12 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
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
 
@@ -1535,6 +1551,8 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
 
 	flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
+	if (test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state))
+		flags |= IONIC_QCQ_F_INTR;
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
 				      lif->ntxq_descs,
@@ -1545,6 +1563,11 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
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
@@ -1560,13 +1583,15 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
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
 
@@ -2071,6 +2096,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->rx_coalesce_usecs = IONIC_ITR_COAL_USEC_DEFAULT;
 	lif->rx_coalesce_hw = ionic_coal_usec_to_hw(lif->ionic,
 						    lif->rx_coalesce_usecs);
+	lif->tx_coalesce_usecs = lif->rx_coalesce_usecs;
+	lif->tx_coalesce_hw = lif->rx_coalesce_hw;
 
 	snprintf(lif->name, sizeof(lif->name), "lif%u", index);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 7a89a38161f6..52be61b7e49a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -138,6 +138,7 @@ enum ionic_lif_state_flags {
 	IONIC_LIF_F_LINK_CHECK_REQUESTED,
 	IONIC_LIF_F_QUEUE_RESET,
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
index 76b17b493639..f32efc7a530c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -425,7 +425,74 @@ void ionic_rx_empty(struct ionic_queue *q)
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

