Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7D5351F51
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbhDATFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239975AbhDATEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:04:02 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174B4C05BD38
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:31 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id ay2so1398444plb.3
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qBvDXrSARyblo1SnPn/nbPMbTtBiYsq3dxV3dTA5QXA=;
        b=UTaC93ZR2+pgoj6Ab401JnOAo7+QfVRYSQN3byp79krQpDuGlFfREwO/Q0ZKV0cfaa
         5LvtUff7Bvkcccpw79MOnvDSEr0/P1fSdpDePQaGBVuWi52TX1PO8bTvR5M4B09q4gF9
         oGowuOapN2GP3jKAgWzNto4hQlEseD7OCh884KngawG742If6j2UQY4/wVwEaHhWajSn
         U2cSnR0oVAANIo3fc/vYP9SxzsOOA1/L9xRUHAIu6JAynwyRAxdZh71ZjwFbc7YyIo2R
         uJFcsykH3dOHQCZtp8q2OwM/4lxxIYi16BMg+q20mxtcACs/+hWfU9foH7j2qt97+xLs
         c03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qBvDXrSARyblo1SnPn/nbPMbTtBiYsq3dxV3dTA5QXA=;
        b=V+G98QHAFUx3221jUQal5YuZFcvcr13Db+cBovuKOFHLrRMMebFo+LJQG5b6HZO4fj
         EI7XBWmaiedafZG47Y4dJvQu0DMLu+DnqjQO3aUgsHWQ65kDUh0TkVC32pSCoYXWmPTk
         xQHygkRzxDVVoPAfDDH2WmSQhjTUu7JK7MQaqjLUiqTgXxZJyfJ+EtlppWb4zBiOjMD8
         awXhT+qMfXjtqSmIe4mOZH5kJmRHCs9x0WxyiaEERmENfTGsrqsBzpVm0BQ/w5A22ds/
         qFuYOmLQ96Kb+2iEkeZwO/57o96ZPGuXeldh7USGlgRgyP16dPqrq3ON8ANOWVST8O69
         IrJA==
X-Gm-Message-State: AOAM530JNSiWckLH6kuGyJNzR2OsdCpiK7TErUmJJCm7qXV4JbMi15Jk
        dhBskheR82zjn2PewryW244hK+O4KBI5CQ==
X-Google-Smtp-Source: ABdhPJw0tieAhdCwF/4ujacdT6g/GIsbugkLm+jE4l9QK3BZD0Y19v//iq9BLJlQtj1XjV++O5dM2w==
X-Received: by 2002:a17:902:c408:b029:e7:3242:5690 with SMTP id k8-20020a170902c408b02900e732425690mr9080894plk.85.1617299790256;
        Thu, 01 Apr 2021 10:56:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 08/12] ionic: set up hw timestamp queues
Date:   Thu,  1 Apr 2021 10:56:06 -0700
Message-Id: <20210401175610.44431-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do hardware timestamping through a separate Tx queue,
and optionally through a separate Rx queue.  These queues
are allocated, freed, and tracked separately from the basic
queue arrays.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 266 +++++++++++++++++-
 1 file changed, 261 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index ced80de4d92a..26c066ed74c4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -684,11 +684,11 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 	if (!lif->rxqcqs)
 		goto err_out;
 
-	lif->txqstats = devm_kcalloc(dev, lif->ionic->ntxqs_per_lif,
+	lif->txqstats = devm_kcalloc(dev, lif->ionic->ntxqs_per_lif + 1,
 				     sizeof(*lif->txqstats), GFP_KERNEL);
 	if (!lif->txqstats)
 		goto err_out;
-	lif->rxqstats = devm_kcalloc(dev, lif->ionic->nrxqs_per_lif,
+	lif->rxqstats = devm_kcalloc(dev, lif->ionic->nrxqs_per_lif + 1,
 				     sizeof(*lif->rxqstats), GFP_KERNEL);
 	if (!lif->rxqstats)
 		goto err_out;
@@ -832,27 +832,250 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 
 int ionic_lif_create_hwstamp_txq(struct ionic_lif *lif)
 {
+	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
+	unsigned int txq_i, flags;
+	struct ionic_qcq *txq;
+	u64 features;
+	int err;
+
+	mutex_lock(&lif->queue_lock);
+
+	if (lif->hwstamp_txq)
+		goto out;
+
+	features = IONIC_Q_F_2X_CQ_DESC | IONIC_TXQ_F_HWSTAMP;
+
+	num_desc = IONIC_MIN_TXRX_DESC;
+	desc_sz = sizeof(struct ionic_txq_desc);
+	comp_sz = 2 * sizeof(struct ionic_txq_comp);
+
+	if (lif->qtype_info[IONIC_QTYPE_TXQ].version >= 1 &&
+	    lif->qtype_info[IONIC_QTYPE_TXQ].sg_desc_sz == sizeof(struct ionic_txq_sg_desc_v1))
+		sg_desc_sz = sizeof(struct ionic_txq_sg_desc_v1);
+	else
+		sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
+
+	txq_i = lif->ionic->ntxqs_per_lif;
+	flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
+
+	err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, txq_i, "hwstamp_tx", flags,
+			      num_desc, desc_sz, comp_sz, sg_desc_sz,
+			      lif->kern_pid, &txq);
+	if (err)
+		goto err_qcq_alloc;
+
+	txq->q.features = features;
+
+	ionic_link_qcq_interrupts(lif->adminqcq, txq);
+	ionic_debugfs_add_qcq(lif, txq);
+
+	lif->hwstamp_txq = txq;
+
+	if (netif_running(lif->netdev)) {
+		err = ionic_lif_txq_init(lif, txq);
+		if (err)
+			goto err_qcq_init;
+
+		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
+			err = ionic_qcq_enable(txq);
+			if (err)
+				goto err_qcq_enable;
+		}
+	}
+
+out:
+	mutex_unlock(&lif->queue_lock);
+
 	return 0;
+
+err_qcq_enable:
+	ionic_lif_qcq_deinit(lif, txq);
+err_qcq_init:
+	lif->hwstamp_txq = NULL;
+	ionic_debugfs_del_qcq(txq);
+	ionic_qcq_free(lif, txq);
+	devm_kfree(lif->ionic->dev, txq);
+err_qcq_alloc:
+	mutex_unlock(&lif->queue_lock);
+	return err;
 }
 
 int ionic_lif_create_hwstamp_rxq(struct ionic_lif *lif)
 {
+	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
+	unsigned int rxq_i, flags;
+	struct ionic_qcq *rxq;
+	u64 features;
+	int err;
+
+	mutex_lock(&lif->queue_lock);
+
+	if (lif->hwstamp_rxq)
+		goto out;
+
+	features = IONIC_Q_F_2X_CQ_DESC | IONIC_RXQ_F_HWSTAMP;
+
+	num_desc = IONIC_MIN_TXRX_DESC;
+	desc_sz = sizeof(struct ionic_rxq_desc);
+	comp_sz = 2 * sizeof(struct ionic_rxq_comp);
+	sg_desc_sz = sizeof(struct ionic_rxq_sg_desc);
+
+	rxq_i = lif->ionic->nrxqs_per_lif;
+	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG;
+
+	err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, rxq_i, "hwstamp_rx", flags,
+			      num_desc, desc_sz, comp_sz, sg_desc_sz,
+			      lif->kern_pid, &rxq);
+	if (err)
+		goto err_qcq_alloc;
+
+	rxq->q.features = features;
+
+	ionic_link_qcq_interrupts(lif->adminqcq, rxq);
+	ionic_debugfs_add_qcq(lif, rxq);
+
+	lif->hwstamp_rxq = rxq;
+
+	if (netif_running(lif->netdev)) {
+		err = ionic_lif_rxq_init(lif, rxq);
+		if (err)
+			goto err_qcq_init;
+
+		if (test_bit(IONIC_LIF_F_UP, lif->state)) {
+			ionic_rx_fill(&rxq->q);
+			err = ionic_qcq_enable(rxq);
+			if (err)
+				goto err_qcq_enable;
+		}
+	}
+
+out:
+	mutex_unlock(&lif->queue_lock);
+
 	return 0;
+
+err_qcq_enable:
+	ionic_lif_qcq_deinit(lif, rxq);
+err_qcq_init:
+	lif->hwstamp_rxq = NULL;
+	ionic_debugfs_del_qcq(rxq);
+	ionic_qcq_free(lif, rxq);
+	devm_kfree(lif->ionic->dev, rxq);
+err_qcq_alloc:
+	mutex_unlock(&lif->queue_lock);
+	return err;
 }
 
 int ionic_lif_config_hwstamp_rxq_all(struct ionic_lif *lif, bool rx_all)
 {
-	return 0;
+	struct ionic_queue_params qparam;
+
+	ionic_init_queue_params(lif, &qparam);
+
+	if (rx_all)
+		qparam.rxq_features = IONIC_Q_F_2X_CQ_DESC | IONIC_RXQ_F_HWSTAMP;
+	else
+		qparam.rxq_features = 0;
+
+	/* if we're not running, just set the values and return */
+	if (!netif_running(lif->netdev)) {
+		lif->rxq_features = qparam.rxq_features;
+		return 0;
+	}
+
+	return ionic_reconfigure_queues(lif, &qparam);
 }
 
 int ionic_lif_set_hwstamp_txmode(struct ionic_lif *lif, u16 txstamp_mode)
 {
-	return 0;
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.lif_setattr = {
+			.opcode = IONIC_CMD_LIF_SETATTR,
+			.index = cpu_to_le16(lif->index),
+			.attr = IONIC_LIF_ATTR_TXSTAMP,
+			.txstamp_mode = cpu_to_le16(txstamp_mode),
+		},
+	};
+
+	return ionic_adminq_post_wait(lif, &ctx);
+}
+
+static void ionic_lif_del_hwstamp_rxfilt(struct ionic_lif *lif)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_del = {
+			.opcode = IONIC_CMD_RX_FILTER_DEL,
+			.lif_index = cpu_to_le16(lif->index),
+		},
+	};
+	struct ionic_rx_filter *f;
+	u32 filter_id;
+	int err;
+
+	spin_lock_bh(&lif->rx_filters.lock);
+
+	f = ionic_rx_filter_rxsteer(lif);
+	if (!f) {
+		spin_unlock_bh(&lif->rx_filters.lock);
+		return;
+	}
+
+	filter_id = f->filter_id;
+	ionic_rx_filter_free(lif, f);
+
+	spin_unlock_bh(&lif->rx_filters.lock);
+
+	netdev_dbg(lif->netdev, "rx_filter del RXSTEER (id %d)\n", filter_id);
+
+	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(filter_id);
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err && err != -EEXIST)
+		netdev_dbg(lif->netdev, "failed to delete rx_filter RXSTEER (id %d)\n", filter_id);
+}
+
+static int ionic_lif_add_hwstamp_rxfilt(struct ionic_lif *lif, u64 pkt_class)
+{
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.rx_filter_add = {
+			.opcode = IONIC_CMD_RX_FILTER_ADD,
+			.lif_index = cpu_to_le16(lif->index),
+			.match = cpu_to_le16(IONIC_RX_FILTER_STEER_PKTCLASS),
+			.pkt_class = cpu_to_le64(pkt_class),
+		},
+	};
+	u8 qtype;
+	u32 qid;
+	int err;
+
+	if (!lif->hwstamp_rxq)
+		return -EINVAL;
+
+	qtype = lif->hwstamp_rxq->q.type;
+	ctx.cmd.rx_filter_add.qtype = qtype;
+
+	qid = lif->hwstamp_rxq->q.index;
+	ctx.cmd.rx_filter_add.qid = cpu_to_le32(qid);
+
+	netdev_dbg(lif->netdev, "rx_filter add RXSTEER\n");
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err && err != -EEXIST)
+		return err;
+
+	return ionic_rx_filter_save(lif, 0, qid, 0, &ctx);
 }
 
 int ionic_lif_set_hwstamp_rxfilt(struct ionic_lif *lif, u64 pkt_class)
 {
-	return 0;
+	ionic_lif_del_hwstamp_rxfilt(lif);
+
+	if (!pkt_class)
+		return 0;
+
+	return ionic_lif_add_hwstamp_rxfilt(lif, pkt_class);
 }
 
 static bool ionic_notifyq_service(struct ionic_cq *cq,
@@ -1695,11 +1918,17 @@ static void ionic_txrx_disable(struct ionic_lif *lif)
 			err = ionic_qcq_disable(lif->txqcqs[i], (err != -ETIMEDOUT));
 	}
 
+	if (lif->hwstamp_txq)
+		err = ionic_qcq_disable(lif->hwstamp_txq, (err != -ETIMEDOUT));
+
 	if (lif->rxqcqs) {
 		for (i = 0; i < lif->nxqs; i++)
 			err = ionic_qcq_disable(lif->rxqcqs[i], (err != -ETIMEDOUT));
 	}
 
+	if (lif->hwstamp_rxq)
+		err = ionic_qcq_disable(lif->hwstamp_rxq, (err != -ETIMEDOUT));
+
 	ionic_lif_quiesce(lif);
 }
 
@@ -1743,6 +1972,18 @@ static void ionic_txrx_free(struct ionic_lif *lif)
 			lif->rxqcqs[i] = NULL;
 		}
 	}
+
+	if (lif->hwstamp_txq) {
+		ionic_qcq_free(lif, lif->hwstamp_txq);
+		devm_kfree(lif->ionic->dev, lif->hwstamp_txq);
+		lif->hwstamp_txq = NULL;
+	}
+
+	if (lif->hwstamp_rxq) {
+		ionic_qcq_free(lif, lif->hwstamp_rxq);
+		devm_kfree(lif->ionic->dev, lif->hwstamp_rxq);
+		lif->hwstamp_rxq = NULL;
+	}
 }
 
 static int ionic_txrx_alloc(struct ionic_lif *lif)
@@ -2587,6 +2828,8 @@ int ionic_lif_alloc(struct ionic *ionic)
 	}
 	netdev_rss_key_fill(lif->rss_hash_key, IONIC_RSS_HASH_KEY_SIZE);
 
+	ionic_lif_alloc_phc(lif);
+
 	return 0;
 
 err_out_free_qcqs:
@@ -2707,6 +2950,8 @@ void ionic_lif_free(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
 
+	ionic_lif_free_phc(lif);
+
 	/* free rss indirection table */
 	dma_free_coherent(dev, lif->rss_ind_tbl_sz, lif->rss_ind_tbl,
 			  lif->rss_ind_tbl_pa);
@@ -3075,6 +3320,7 @@ void ionic_lif_unregister(struct ionic_lif *lif)
 
 	if (lif->netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(lif->netdev);
+
 	lif->registered = false;
 }
 
@@ -3214,6 +3460,16 @@ int ionic_lif_size(struct ionic *ionic)
 	ntxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_TXQ]);
 	nrxqs_per_lif = le32_to_cpu(lc->queue_count[IONIC_QTYPE_RXQ]);
 
+	/* reserve last queue id for hardware timestamping */
+	if (lc->features & cpu_to_le64(IONIC_ETH_HW_TIMESTAMP)) {
+		if (ntxqs_per_lif <= 1 || nrxqs_per_lif <= 1) {
+			lc->features &= cpu_to_le64(~IONIC_ETH_HW_TIMESTAMP);
+		} else {
+			ntxqs_per_lif -= 1;
+			nrxqs_per_lif -= 1;
+		}
+	}
+
 	nxqs = min(ntxqs_per_lif, nrxqs_per_lif);
 	nxqs = min(nxqs, num_online_cpus());
 	neqs = min(neqs_per_lif, num_online_cpus());
-- 
2.17.1

