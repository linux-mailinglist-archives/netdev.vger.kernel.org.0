Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE285351F52
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbhDATFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240101AbhDATEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:04:04 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1373EC03D206
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id w10so444912pgh.5
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RG+YsVMefZG9UwwvHfq/wsqec5yWZmtkSR+yTOFOemw=;
        b=ojVZyl2ym+mPE1Mcjq0YXJm/x3aw9do2sUiSbhk0M51vh9tyxInlmP0KmJsu9HHpaN
         7DM29ETHdo1ERq7wJxan8iTBOatPzzraC8LfthpB/vJNHAFGw2mzMT5P+MmMd+h3NFKh
         2BDVj9Ickyl/8t783LoBLgRph32hqltG/Qq59l1jEeVoxXBtRbhbVzLjTriRBPLrA0m/
         uoPunfabBsVtShKmUFgwtnp7Im1x9u54pVQQQHyhI+LRMKn5KGFkMgIpVYdPdrYDC5n9
         z8X9QrgeNmn0IxsxruXfYbl+SumQyNE3I5q+h7FCoOeMSJDxlWS8rZ+7BbnilMAMTgcH
         cC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RG+YsVMefZG9UwwvHfq/wsqec5yWZmtkSR+yTOFOemw=;
        b=TQxuxyhXLllPXKrRnco7nCxk+mp9nK2UBVUCZRD+qgWAcV2br1cAs5+8nuhjyBWCwD
         6HrWUeIc1n6h8GFJa+Q7LSLlldiC3z5w8ngq0v19vsb+jUqlG69NqmZpiBNHjQ9zUo3h
         TthmAPm9Vtd2dQ9SbcQFIBxOjjw9IGVvRjUCjNR1wyXR5xcUcgCcb04thFH+z4WKBfaS
         I5i3ev3A44GD4n7XsBkgmWgZ1uixdT/p6tRWNYZBDlwVsOjmmjcwXuaTMxvIFxti2RXn
         MEuCKkzmbiSGhdUs5VzIzF0ieqO9uFbKIawiOR+6Gevr+heH5jpbsERb3hIX26s/as20
         cGbA==
X-Gm-Message-State: AOAM532RSo6ONLKH3dpwZjtPDeGAK07riSl5cukdULhtOTrRSXCALbN0
        +RIgquzsaLF7m1Xntazl4qAsPGGkTarRYw==
X-Google-Smtp-Source: ABdhPJzp5LvCvxJeNgbSWJE88I4JDW4/CEpnKWunoJZiuwW2bZkwMELjlfTNwAsUcwXjlEapakh/MA==
X-Received: by 2002:a63:f959:: with SMTP id q25mr8707049pgk.104.1617299791197;
        Thu, 01 Apr 2021 10:56:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 09/12] ionic: add and enable tx and rx timestamp handling
Date:   Thu,  1 Apr 2021 10:56:07 -0700
Message-Id: <20210401175610.44431-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Tx and Rx timestamped packets are handled through separate
queues.  Here we set them up, service them, and tear them down
along with the normal Tx and Rx queues.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  51 ++++++-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 126 +++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   3 +
 4 files changed, 157 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 28994e01fa0a..c25cf9b744c5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -220,11 +220,11 @@ struct ionic_queue {
 	unsigned int index;
 	unsigned int num_descs;
 	unsigned int max_sg_elems;
+	u64 features;
 	u64 dbell_count;
 	u64 stop;
 	u64 wake;
 	u64 drop;
-	u64 features;
 	struct ionic_dev *idev;
 	unsigned int type;
 	unsigned int hw_index;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 26c066ed74c4..e14c93fbbd68 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1145,9 +1145,12 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev = &lif->ionic->idev;
 	unsigned long irqflags;
 	unsigned int flags = 0;
+	int rx_work = 0;
+	int tx_work = 0;
 	int n_work = 0;
 	int a_work = 0;
 	int work_done;
+	int credits;
 
 	if (lif->notifyqcq && lif->notifyqcq->flags & IONIC_QCQ_F_INITED)
 		n_work = ionic_cq_service(&lif->notifyqcq->cq, budget,
@@ -1159,7 +1162,15 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 					  ionic_adminq_service, NULL, NULL);
 	spin_unlock_irqrestore(&lif->adminq_lock, irqflags);
 
-	work_done = max(n_work, a_work);
+	if (lif->hwstamp_rxq)
+		rx_work = ionic_cq_service(&lif->hwstamp_rxq->cq, budget,
+					   ionic_rx_service, NULL, NULL);
+
+	if (lif->hwstamp_txq)
+		tx_work = ionic_cq_service(&lif->hwstamp_txq->cq, budget,
+					   ionic_tx_service, NULL, NULL);
+
+	work_done = max(max(n_work, a_work), max(rx_work, tx_work));
 	if (work_done < budget && napi_complete_done(napi, work_done)) {
 		flags |= IONIC_INTR_CRED_UNMASK;
 		intr->rearm_count++;
@@ -1167,9 +1178,8 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 
 	if (work_done || flags) {
 		flags |= IONIC_INTR_CRED_RESET_COALESCE;
-		ionic_intr_credits(idev->intr_ctrl,
-				   intr->index,
-				   n_work + a_work, flags);
+		credits = n_work + a_work + rx_work + tx_work;
+		ionic_intr_credits(idev->intr_ctrl, intr->index, credits, flags);
 	}
 
 	return work_done;
@@ -1529,6 +1539,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 	int err;
 
 	ctx.cmd.lif_setattr.features = ionic_netdev_features_to_nic(features);
+
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
 		return err;
@@ -1951,6 +1962,17 @@ static void ionic_txrx_deinit(struct ionic_lif *lif)
 		}
 	}
 	lif->rx_mode = 0;
+
+	if (lif->hwstamp_txq) {
+		ionic_lif_qcq_deinit(lif, lif->hwstamp_txq);
+		ionic_tx_flush(&lif->hwstamp_txq->cq);
+		ionic_tx_empty(&lif->hwstamp_txq->q);
+	}
+
+	if (lif->hwstamp_rxq) {
+		ionic_lif_qcq_deinit(lif, lif->hwstamp_rxq);
+		ionic_rx_empty(&lif->hwstamp_rxq->q);
+	}
 }
 
 static void ionic_txrx_free(struct ionic_lif *lif)
@@ -2122,8 +2144,26 @@ static int ionic_txrx_enable(struct ionic_lif *lif)
 		}
 	}
 
+	if (lif->hwstamp_rxq) {
+		ionic_rx_fill(&lif->hwstamp_rxq->q);
+		err = ionic_qcq_enable(lif->hwstamp_rxq);
+		if (err)
+			goto err_out_hwstamp_rx;
+	}
+
+	if (lif->hwstamp_txq) {
+		err = ionic_qcq_enable(lif->hwstamp_txq);
+		if (err)
+			goto err_out_hwstamp_tx;
+	}
+
 	return 0;
 
+err_out_hwstamp_tx:
+	if (lif->hwstamp_rxq)
+		derr = ionic_qcq_disable(lif->hwstamp_rxq, (derr != -ETIMEDOUT));
+err_out_hwstamp_rx:
+	i = lif->nxqs;
 err_out:
 	while (i--) {
 		derr = ionic_qcq_disable(lif->txqcqs[i], (derr != -ETIMEDOUT));
@@ -2929,6 +2969,9 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 			goto err_txrx_free;
 	}
 
+	/* restore the hardware timestamping queues */
+	ionic_lif_hwstamp_set(lif, NULL);
+
 	clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
 	ionic_link_status_check_request(lif, CAN_SLEEP);
 	netif_device_attach(lif->netdev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 4859120eec72..3478b0f2495f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -11,8 +11,6 @@
 #include "ionic_txrx.h"
 
 
-static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info);
-
 static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell,
 				  ionic_desc_cb cb_func, void *cb_arg)
 {
@@ -298,13 +296,33 @@ static void ionic_rx_clean(struct ionic_queue *q,
 		stats->vlan_stripped++;
 	}
 
+	if (unlikely(q->features & IONIC_RXQ_F_HWSTAMP)) {
+		__le64 *cq_desc_hwstamp;
+		u64 hwstamp;
+
+		cq_desc_hwstamp =
+			cq_info->cq_desc +
+			qcq->cq.desc_size -
+			sizeof(struct ionic_rxq_comp) -
+			IONIC_HWSTAMP_CQ_NEGOFFSET;
+
+		hwstamp = le64_to_cpu(*cq_desc_hwstamp);
+
+		if (hwstamp != IONIC_HWSTAMP_INVALID) {
+			skb_hwtstamps(skb)->hwtstamp = ionic_lif_phc_ktime(q->lif, hwstamp);
+			stats->hwstamp_valid++;
+		} else {
+			stats->hwstamp_invalid++;
+		}
+	}
+
 	if (le16_to_cpu(comp->len) <= q->lif->rx_copybreak)
 		napi_gro_receive(&qcq->napi, skb);
 	else
 		napi_gro_frags(&qcq->napi);
 }
 
-static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
+bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 {
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
@@ -665,9 +683,11 @@ static void ionic_tx_clean(struct ionic_queue *q,
 {
 	struct ionic_buf_info *buf_info = desc_info->bufs;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	struct ionic_qcq *qcq = q_to_qcq(q);
+	struct sk_buff *skb = cb_arg;
 	struct device *dev = q->dev;
-	u16 queue_index;
 	unsigned int i;
+	u16 qi;
 
 	if (desc_info->nbufs) {
 		dma_unmap_single(dev, (dma_addr_t)buf_info->dma_addr,
@@ -678,24 +698,49 @@ static void ionic_tx_clean(struct ionic_queue *q,
 				       buf_info->len, DMA_TO_DEVICE);
 	}
 
-	if (cb_arg) {
-		struct sk_buff *skb = cb_arg;
+	if (!skb)
+		return;
 
-		queue_index = skb_get_queue_mapping(skb);
-		if (unlikely(__netif_subqueue_stopped(q->lif->netdev,
-						      queue_index))) {
-			netif_wake_subqueue(q->lif->netdev, queue_index);
-			q->wake++;
-		}
+	qi = skb_get_queue_mapping(skb);
+
+	if (unlikely(q->features & IONIC_TXQ_F_HWSTAMP)) {
+		if (cq_info) {
+			struct skb_shared_hwtstamps hwts = {};
+			__le64 *cq_desc_hwstamp;
+			u64 hwstamp;
+
+			cq_desc_hwstamp =
+				cq_info->cq_desc +
+				qcq->cq.desc_size -
+				sizeof(struct ionic_txq_comp) -
+				IONIC_HWSTAMP_CQ_NEGOFFSET;
+
+			hwstamp = le64_to_cpu(*cq_desc_hwstamp);
 
-		desc_info->bytes = skb->len;
-		stats->clean++;
+			if (hwstamp != IONIC_HWSTAMP_INVALID) {
+				hwts.hwtstamp = ionic_lif_phc_ktime(q->lif, hwstamp);
 
-		dev_consume_skb_any(skb);
+				skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+				skb_tstamp_tx(skb, &hwts);
+
+				stats->hwstamp_valid++;
+			} else {
+				stats->hwstamp_invalid++;
+			}
+		}
+
+	} else if (unlikely(__netif_subqueue_stopped(q->lif->netdev, qi))) {
+		netif_wake_subqueue(q->lif->netdev, qi);
+		q->wake++;
 	}
+
+	desc_info->bytes = skb->len;
+	stats->clean++;
+
+	dev_consume_skb_any(skb);
 }
 
-static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
+bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 {
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
@@ -726,7 +771,7 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 		desc_info->cb_arg = NULL;
 	} while (index != le16_to_cpu(comp->comp_index));
 
-	if (pkts && bytes)
+	if (pkts && bytes && !unlikely(q->features & IONIC_TXQ_F_HWSTAMP))
 		netdev_tx_completed_queue(q_to_ndq(q), pkts, bytes);
 
 	return true;
@@ -764,7 +809,7 @@ void ionic_tx_empty(struct ionic_queue *q)
 		desc_info->cb_arg = NULL;
 	}
 
-	if (pkts && bytes)
+	if (pkts && bytes && !unlikely(q->features & IONIC_TXQ_F_HWSTAMP))
 		netdev_tx_completed_queue(q_to_ndq(q), pkts, bytes);
 }
 
@@ -838,7 +883,8 @@ static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc
 
 	if (start) {
 		skb_tx_timestamp(skb);
-		netdev_tx_sent_queue(q_to_ndq(q), skb->len);
+		if (!unlikely(q->features & IONIC_TXQ_F_HWSTAMP))
+			netdev_tx_sent_queue(q_to_ndq(q), skb->len);
 		ionic_txq_post(q, false, ionic_tx_clean, skb);
 	} else {
 		ionic_txq_post(q, done, NULL, NULL);
@@ -1085,7 +1131,8 @@ static int ionic_tx(struct ionic_queue *q, struct sk_buff *skb)
 	stats->pkts++;
 	stats->bytes += skb->len;
 
-	netdev_tx_sent_queue(q_to_ndq(q), skb->len);
+	if (!unlikely(q->features & IONIC_TXQ_F_HWSTAMP))
+		netdev_tx_sent_queue(q_to_ndq(q), skb->len);
 	ionic_txq_post(q, !netdev_xmit_more(), ionic_tx_clean, skb);
 
 	return 0;
@@ -1137,6 +1184,41 @@ static int ionic_maybe_stop_tx(struct ionic_queue *q, int ndescs)
 	return stopped;
 }
 
+static netdev_tx_t ionic_start_hwstamp_xmit(struct sk_buff *skb,
+					    struct net_device *netdev)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_queue *q = &lif->hwstamp_txq->q;
+	int err, ndescs;
+
+	/* Does not stop/start txq, because we post to a separate tx queue
+	 * for timestamping, and if a packet can't be posted immediately to
+	 * the timestamping queue, it is dropped.
+	 */
+
+	ndescs = ionic_tx_descs_needed(q, skb);
+	if (unlikely(ndescs < 0))
+		goto err_out_drop;
+
+	if (unlikely(!ionic_q_has_space(q, ndescs)))
+		goto err_out_drop;
+
+	if (skb_is_gso(skb))
+		err = ionic_tx_tso(q, skb);
+	else
+		err = ionic_tx(q, skb);
+
+	if (err)
+		goto err_out_drop;
+
+	return NETDEV_TX_OK;
+
+err_out_drop:
+	q->drop++;
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
+}
+
 netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	u16 queue_index = skb_get_queue_mapping(skb);
@@ -1150,6 +1232,10 @@ netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_OK;
 	}
 
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		if (lif->hwstamp_txq)
+			return ionic_start_hwstamp_xmit(skb, netdev);
+
 	if (unlikely(queue_index >= lif->nxqs))
 		queue_index = 0;
 	q = &lif->txqcqs[queue_index]->q;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
index 7667b72232b8..d7cbaad8a6fb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
@@ -14,4 +14,7 @@ int ionic_tx_napi(struct napi_struct *napi, int budget);
 int ionic_txrx_napi(struct napi_struct *napi, int budget);
 netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev);
 
+bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info);
+bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info);
+
 #endif /* _IONIC_TXRX_H_ */
-- 
2.17.1

