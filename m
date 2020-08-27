Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA43254C9C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgH0SI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgH0SIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 14:08:01 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D61C061233
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:08:00 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g33so3922093pgb.4
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 11:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ICEJMm8RnuwaRZS+fPePrHy3X75kuNLGJBDtwN6U7bM=;
        b=3P+0vRa9oF7TyaNtg2d539P9VshUQbGgiKFsuTQG5i1Wf/HJhAJ1uMy+9laCFbUSB6
         5v5tX0n6sLO5aS2GbRfROkJOMSUw2Kz76zphLWpuXfSuCOSo7+jb8i3l0fpbLEOdAXzA
         BnT5Y1s1y83bcmpHknwTtqySOgdTzWyZllDSisxazE4HBgd3QeTOqnUYYR5nFm2NIaTv
         X3tdVpTydDEHS5HHmf1Z/sOULH0PZTZ48YGue7+feLxSs8x+AHDAZQK1SJFma0JphwcX
         qCPFXp/YR+i+gTHsfGNXI3kQxkjjdqDLUguxysGOBhKPYQCUjap4Alu1hsqIVQZUI9FI
         yNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ICEJMm8RnuwaRZS+fPePrHy3X75kuNLGJBDtwN6U7bM=;
        b=jppGyZYa4WTKYyqBhQ+2q7qDxtInJu5AycD3n6E44jA18ovVbFsB5N0rtGe5wuC013
         xsr8eNpRCYFM9hwg/aaNnxi8K9bUca6lsB4IDDg4YwyHvs76Rd0kg/SMs/nRA1OkD7uF
         S1NznxAg0s3FlJiApsEfvLyvBPdqcJVO+7Bai/aAJGNJYJJEBgJMXQV4CRsbWNPcVg3s
         ouW2zYLWQY9DDDXWzOUMq45l7qXEuLr3rHOC0BSX2ZjcKFJJXx9thDjFhRkebqwxv2/H
         EfrHDiu9XiLsOG3OOdc9tdWVcHld3CLSLRUVbKfIv2lewn9CAxngCdrBGd1h63kG5hfq
         XNLA==
X-Gm-Message-State: AOAM533GfiY5fUJAWGXmWshE7LeCEZGkoJJGgyf6hs/haFFjOq4YvJpL
        IoLAIICoOUrprr85JiWsobg1YpkonlC/sg==
X-Google-Smtp-Source: ABdhPJwp5bAeq3oL+V9Cyhii2RHOdPwNR8O2EZ+nGXuv2+254E/uMLAJabGMsBAk9wz2wDWTxA69cg==
X-Received: by 2002:a17:902:cb91:: with SMTP id d17mr17096355ply.223.1598551680032;
        Thu, 27 Aug 2020 11:08:00 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n1sm3480249pfu.2.2020.08.27.11.07.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 11:07:59 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 10/12] ionic: change the descriptor ring length without full reset
Date:   Thu, 27 Aug 2020 11:07:33 -0700
Message-Id: <20200827180735.38166-11-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827180735.38166-1-snelson@pensando.io>
References: <20200827180735.38166-1-snelson@pensando.io>
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
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  35 +++--
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 145 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  19 ++-
 3 files changed, 185 insertions(+), 14 deletions(-)

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
index 581eeb822f90..f06842a3164c 100644
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
 
@@ -2047,6 +2051,139 @@ static const struct net_device_ops ionic_netdev_ops = {
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
+	ionic_stop_queues_reconfig(lif);
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
+	err = ionic_start_queues_reconfig(lif);
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

