Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E3B253524
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgHZQno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbgHZQmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:35 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C187C061796
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:34 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k18so1260564pfp.7
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5avBMlEduRdsosvyiPhQlDyXGD+4H+ubevkBKjfZsr4=;
        b=phGoGTcp5RaQm++XjZp8D+63O/o4NLEvxJe5kOa6eLZWp5WVQR73ycccAmyNLwkZwq
         N/jT8e+cv9Z5pQ/rAGRnHDApgP7pUSo8UF+JoSHbRsZX7RqVZgn2mUtvIsJ7M5ri1MC1
         wuu0WyBnGcI9/+tEcrqlUb9bsmwj/EWlwlg/e5nHImWKrfSFPNJxHZP0uxugtNW/6zDi
         rZcVWh5Z3dbB4XaAnpCKGmKoTpiLpY4SApF/Dfo/e3Ev3Mz3VKTV0Q+dkOJG/8666Qx0
         7rvmkXCooAzCKCIv/U3wc2Q4WF87kOKT5lQvRdhtzVfbcRskWWbA1gmkkgUXWYsEVeMe
         /6Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5avBMlEduRdsosvyiPhQlDyXGD+4H+ubevkBKjfZsr4=;
        b=ktRlW1y17VnC+f9WgPRKE8DA5i6lq5ZPwOWao6cdHEejADCA6i3OBeO17TYLXqzDPz
         /UAODXBmQpHNIz3djonBzayjByfbu1mSdL8yBlQ4f9D2ttP9A6B2kfHlZeSHETZ+N/mL
         VoyqE+TF18ahKC5IM+IhdLnzhDMT85tiXr9em98BVPxHHxkvKY9QjMbDr2dXIyGw1jG+
         eG0tRQa7bV5xToqfXQhMbS0efaat4ia6aFl4XbycTo56RsP15JUim18abMPx0N7fDj5G
         vg2GHWmXCLD5Azd31TW8BXh3S7s9BCtSM7QCw/gdwg1kRLCn8569ya/W0Voc5aM/WjfE
         biog==
X-Gm-Message-State: AOAM5321H40hIZKnL1l7B9eIhQa1Hd3EqURRRcmIa1jNL1Zo/lAk8N2c
        OmwhEfkgzPfIxQcwrTSzvF3aCnR9K4k+ng==
X-Google-Smtp-Source: ABdhPJwyc37B2lkEZwGxxP1OUYeFyixwm2lHD6LGw6RTr4RaRxKm0NKYnGlYP/E/n7n2X40cCtftdw==
X-Received: by 2002:a62:2704:: with SMTP id n4mr13233386pfn.246.1598460153369;
        Wed, 26 Aug 2020 09:42:33 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:32 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 10/12] ionic: change the descriptor ring length without full reset
Date:   Wed, 26 Aug 2020 09:42:12 -0700
Message-Id: <20200826164214.31792-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original way of changing ring length was to completely
tear down the lif's queue structure and then rebuild it, while
running the risk of allocations that might fail in the middle
and leave us with a broken driver.

Instead, we can set up all the new queue and descriptor
allocations first, then swap them out and delete the old
allocations.  If the new allocations fail, we report the error,
stay with the old setup and continue running.  This gives us
a safer path, and a smaller window of time where we're not
processing traffic.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  35 +++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 161 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  19 ++-
 3 files changed, 201 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 73af0ecc5495..adaefa5fe883 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -493,18 +493,14 @@ static void ionic_get_ringparam(struct net_device *netdev,
 	ring->rx_pending = lif->nrxq_descs;
 }
 
-static void ionic_set_ringsize(struct ionic_lif *lif, void *arg)
-{
-	struct ethtool_ringparam *ring = arg;
-
-	lif->ntxq_descs = ring->tx_pending;
-	lif->nrxq_descs = ring->rx_pending;
-}
-
 static int ionic_set_ringparam(struct net_device *netdev,
 			       struct ethtool_ringparam *ring)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_queue_params qparam;
+	int err;
+
+	ionic_init_queue_params(lif, &qparam);
 
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
 		netdev_info(netdev, "Changing jumbo or mini descriptors not supported\n");
@@ -522,7 +518,28 @@ static int ionic_set_ringparam(struct net_device *netdev,
 	    ring->rx_pending == lif->nrxq_descs)
 		return 0;
 
-	return ionic_reset_queues(lif, ionic_set_ringsize, ring);
+	if (ring->tx_pending != lif->ntxq_descs)
+		netdev_info(netdev, "Changing Tx ring size from %d to %d\n",
+			    lif->ntxq_descs, ring->tx_pending);
+
+	if (ring->rx_pending != lif->nrxq_descs)
+		netdev_info(netdev, "Changing Rx ring size from %d to %d\n",
+			    lif->nrxq_descs, ring->rx_pending);
+
+	/* if we're not running, just set the values and return */
+	if (!netif_running(lif->netdev)) {
+		lif->ntxq_descs = ring->tx_pending;
+		lif->nrxq_descs = ring->rx_pending;
+		return 0;
+	}
+
+	qparam.ntxq_descs = ring->tx_pending;
+	qparam.nrxq_descs = ring->rx_pending;
+	err = ionic_reconfigure_queues(lif, &qparam);
+	if (err)
+		netdev_info(netdev, "Ring reconfiguration failed, changes canceled: %d\n", err);
+
+	return err;
 }
 
 static void ionic_get_channels(struct net_device *netdev,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index d82ae717bc6c..40e249ca1ea3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -333,10 +333,14 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		ionic_intr_free(lif->ionic, qcq->intr.index);
 	}
 
-	devm_kfree(dev, qcq->cq.info);
-	qcq->cq.info = NULL;
-	devm_kfree(dev, qcq->q.info);
-	qcq->q.info = NULL;
+	if (qcq->cq.info) {
+		devm_kfree(dev, qcq->cq.info);
+		qcq->cq.info = NULL;
+	}
+	if (qcq->q.info) {
+		devm_kfree(dev, qcq->q.info);
+		qcq->q.info = NULL;
+	}
 	devm_kfree(dev, qcq);
 }
 
@@ -2037,6 +2041,155 @@ static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_get_vf_stats       = ionic_get_vf_stats,
 };
 
+static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
+{
+	/* only swapping the queues, not the napi, flags, or other stuff */
+	swap(a->q.num_descs,  b->q.num_descs);
+	swap(a->q.base,       b->q.base);
+	swap(a->q.base_pa,    b->q.base_pa);
+	swap(a->q.info,       b->q.info);
+	swap(a->q_base,       b->q_base);
+	swap(a->q_base_pa,    b->q_base_pa);
+	swap(a->q_size,       b->q_size);
+
+	swap(a->q.sg_base,    b->q.sg_base);
+	swap(a->q.sg_base_pa, b->q.sg_base_pa);
+	swap(a->sg_base,      b->sg_base);
+	swap(a->sg_base_pa,   b->sg_base_pa);
+	swap(a->sg_size,      b->sg_size);
+
+	swap(a->cq.num_descs, b->cq.num_descs);
+	swap(a->cq.base,      b->cq.base);
+	swap(a->cq.base_pa,   b->cq.base_pa);
+	swap(a->cq.info,      b->cq.info);
+	swap(a->cq_base,      b->cq_base);
+	swap(a->cq_base_pa,   b->cq_base_pa);
+	swap(a->cq_size,      b->cq_size);
+}
+
+int ionic_reconfigure_queues(struct ionic_lif *lif,
+			     struct ionic_queue_params *qparam)
+{
+	struct ionic_qcq **tx_qcqs = NULL;
+	struct ionic_qcq **rx_qcqs = NULL;
+	unsigned int sg_desc_sz;
+	unsigned int flags;
+	int err = -ENOMEM;
+	unsigned int i;
+
+	/* allocate temporary qcq arrays to hold new queue structs */
+	if (qparam->ntxq_descs != lif->ntxq_descs) {
+		tx_qcqs = devm_kcalloc(lif->ionic->dev, lif->nxqs,
+				       sizeof(struct ionic_qcq *), GFP_KERNEL);
+		if (!tx_qcqs)
+			goto err_out;
+	}
+	if (qparam->nrxq_descs != lif->nrxq_descs) {
+		rx_qcqs = devm_kcalloc(lif->ionic->dev, lif->nxqs,
+				       sizeof(struct ionic_qcq *), GFP_KERNEL);
+		if (!rx_qcqs)
+			goto err_out;
+	}
+
+	/* allocate new desc_info and rings with no interrupt flag */
+	if (lif->qtype_info[IONIC_QTYPE_TXQ].version >= 1 &&
+	    lif->qtype_info[IONIC_QTYPE_TXQ].sg_desc_sz ==
+					  sizeof(struct ionic_txq_sg_desc_v1))
+		sg_desc_sz = sizeof(struct ionic_txq_sg_desc_v1);
+	else
+		sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
+
+	if (tx_qcqs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			flags = lif->txqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
+			err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
+					      qparam->ntxq_descs,
+					      sizeof(struct ionic_txq_desc),
+					      sizeof(struct ionic_txq_comp),
+					      sg_desc_sz,
+					      lif->kern_pid, &tx_qcqs[i]);
+			if (err)
+				goto err_out;
+		}
+	}
+
+	if (rx_qcqs) {
+		for (i = 0; i < lif->nxqs; i++) {
+			flags = lif->rxqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
+			err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
+					      qparam->nrxq_descs,
+					      sizeof(struct ionic_rxq_desc),
+					      sizeof(struct ionic_rxq_comp),
+					      sizeof(struct ionic_rxq_sg_desc),
+					      lif->kern_pid, &rx_qcqs[i]);
+			if (err)
+				goto err_out;
+		}
+	}
+
+	/* stop and clean the queues */
+	mutex_lock(&lif->queue_lock);
+	netif_device_detach(lif->netdev);
+	ionic_stop_queues(lif);
+	ionic_txrx_deinit(lif);
+
+	/* swap new desc_info and rings, keeping existing interrupt config */
+	if (tx_qcqs) {
+		lif->ntxq_descs = qparam->ntxq_descs;
+		for (i = 0; i < lif->nxqs; i++)
+			ionic_swap_queues(lif->txqcqs[i], tx_qcqs[i]);
+	}
+
+	if (rx_qcqs) {
+		lif->nrxq_descs = qparam->nrxq_descs;
+		for (i = 0; i < lif->nxqs; i++)
+			ionic_swap_queues(lif->rxqcqs[i], rx_qcqs[i]);
+	}
+
+	/* re-init the queues */
+	err = ionic_txrx_init(lif);
+	if (err)
+		goto err_out_attach_unlock;
+
+	/* don't start the queues unless we have link */
+	if (netif_carrier_ok(lif->netdev)) {
+		err = ionic_start_queues(lif);
+		if (err)
+			goto err_out_attach_unlock;
+	}
+
+err_out_attach_unlock:
+	netif_device_attach(lif->netdev);
+	mutex_unlock(&lif->queue_lock);
+
+err_out:
+	/* free old allocs without cleaning intr */
+	for (i = 0; i < lif->nxqs; i++) {
+		if (tx_qcqs && tx_qcqs[i]) {
+			tx_qcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, tx_qcqs[i]);
+			tx_qcqs[i] = NULL;
+		}
+		if (rx_qcqs && rx_qcqs[i]) {
+			rx_qcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, rx_qcqs[i]);
+			rx_qcqs[i] = NULL;
+		}
+	}
+
+	/* free q array */
+	if (rx_qcqs) {
+		devm_kfree(lif->ionic->dev, rx_qcqs);
+		rx_qcqs = NULL;
+	}
+	if (tx_qcqs) {
+		devm_kfree(lif->ionic->dev, tx_qcqs);
+		tx_qcqs = NULL;
+	}
+
+	return err;
+}
+
 int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 {
 	bool running;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index b8f774b1db3a..1df3e1e4107b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -207,6 +207,22 @@ struct ionic_lif {
 	struct work_struct tx_timeout_work;
 };
 
+struct ionic_queue_params {
+	unsigned int nxqs;
+	unsigned int ntxq_descs;
+	unsigned int nrxq_descs;
+	unsigned int intr_split;
+};
+
+static inline void ionic_init_queue_params(struct ionic_lif *lif,
+					   struct ionic_queue_params *qparam)
+{
+	qparam->nxqs = lif->nxqs;
+	qparam->ntxq_descs = lif->ntxq_descs;
+	qparam->nrxq_descs = lif->nrxq_descs;
+	qparam->intr_split = test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+}
+
 static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
 {
 	u32 mult = le32_to_cpu(ionic->ident.dev.intr_coal_mult);
@@ -241,7 +257,8 @@ int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 int ionic_lif_size(struct ionic *ionic);
 int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 			 const u8 *key, const u32 *indir);
-
+int ionic_reconfigure_queues(struct ionic_lif *lif,
+			     struct ionic_queue_params *qparam);
 int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg);
 
 static inline void debug_stats_txq_post(struct ionic_queue *q, bool dbell)
-- 
2.17.1

