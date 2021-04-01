Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BCF351F4A
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbhDATFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbhDATDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:03:22 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA3DC0F26EF
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:23 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id i6so2053057pgs.1
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cV+IZf/qzzoH/1wa7RdrTV/1nCPbdKJoKHkRYIkn4tA=;
        b=EjbnIghL5RM+q/Bypa/XqOw+ZausUKOMqtckGPbApOhzKtvzL61ElTv5onDyrzoplb
         oXKq+AGSnha1vZOnP6OTlcS+bZA208u/OMmsEythbd9SzqqFow6FvFb8cfKiw7qYMkxJ
         grEopZgwXw24EewmVuF+h+YMNATbuEJ5A6jm8ePWabEW0XvucgIijlT5DFIxw4jtoBUN
         mpZl+HJZGMFFInc6240aF2vZ9f3xUKwXI3Z5Ne/7UkfRX1dDjEtBDRfoBa9s5aYY2wcs
         BFdHxfv8bTT463SxuJR8oyUFQv8xQErs0bdTd6SlFEMw9AOHQCdwoqr8mpg6eb6TtzKT
         aGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cV+IZf/qzzoH/1wa7RdrTV/1nCPbdKJoKHkRYIkn4tA=;
        b=l/coVOO0Kwvg4GRnjIJLxhd95nsJNvaJgbIYM33eCiUTJqcysEkEYBFbSlKEeaNp4K
         rItCNDGIP7p4r1W1pQ/vp6Z458/uEFlV3HKl2nZCzy94+0NzS9ad+4JUgwAfXoX57A3m
         Df/bOdihX4kEYDYDkjH9vDTAqjMsBQDblD9ZyNJEeSythAbOroi9B8ogRo3uF83eEGQu
         PHL+VDlv24QnY2h2/qkNsWZvm6e6rY+bncGJsohbongB8kvtGLwhcnJIzcHKbzoL74EH
         Db06m0KICRIfp7QQVJv2+k9BZQkn+3JSc5gxyvFDs5Qlv3y/1z0/LqVmzhh89IAtyXFP
         75/A==
X-Gm-Message-State: AOAM531MJhr8zdX/tKFG6RkSgLwrfxd1vjQn1Cr1hNLm/CMQPjV5/9Z0
        KmgTOuiSP/1omg6NctXK0vr3izP006q7Sg==
X-Google-Smtp-Source: ABdhPJx1LZyPcqj6pH9mY0b9+th3e4XHs0MFpM8JHBCdbwcsjyAFUtgyYXgOmPE290u+qSqPk30pvQ==
X-Received: by 2002:a63:e63:: with SMTP id 35mr8333657pgo.27.1617299782970;
        Thu, 01 Apr 2021 10:56:22 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:22 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 02/12] ionic: add handling of larger descriptors
Date:   Thu,  1 Apr 2021 10:56:00 -0700
Message-Id: <20210401175610.44431-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparating for hardware timestamping, we need to support
large Tx and Rx completion descriptors.  Here we add the new
queue feature ids and handling for the completion descriptor
sizes.

We only are adding support for the Rx 2x sized completion
descriptors in the general Rx queues for now as we will be
using it for PTP Rx support, and we don't have an immediate
use for the large descriptors in the general Tx queues yet;
it will be used in a special Tx queues added in one of the
next few patches.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_if.h    | 12 +++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 75 ++++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  3 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 12 ++-
 4 files changed, 73 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 23043ce0a5d8..1299630fcde8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -354,12 +354,24 @@ enum ionic_logical_qtype {
  * @IONIC_QIDENT_F_SG:      Queue has scatter/gather ring
  * @IONIC_QIDENT_F_EQ:      Queue can use event queue
  * @IONIC_QIDENT_F_CMB:     Queue is in cmb bar
+ * @IONIC_Q_F_2X_DESC:      Double main descriptor size
+ * @IONIC_Q_F_2X_CQ_DESC:   Double cq descriptor size
+ * @IONIC_Q_F_2X_SG_DESC:   Double sg descriptor size
+ * @IONIC_Q_F_4X_DESC:      Quadruple main descriptor size
+ * @IONIC_Q_F_4X_CQ_DESC:   Quadruple cq descriptor size
+ * @IONIC_Q_F_4X_SG_DESC:   Quadruple sg descriptor size
  */
 enum ionic_q_feature {
 	IONIC_QIDENT_F_CQ		= BIT_ULL(0),
 	IONIC_QIDENT_F_SG		= BIT_ULL(1),
 	IONIC_QIDENT_F_EQ		= BIT_ULL(2),
 	IONIC_QIDENT_F_CMB		= BIT_ULL(3),
+	IONIC_Q_F_2X_DESC		= BIT_ULL(4),
+	IONIC_Q_F_2X_CQ_DESC		= BIT_ULL(5),
+	IONIC_Q_F_2X_SG_DESC		= BIT_ULL(6),
+	IONIC_Q_F_4X_DESC		= BIT_ULL(7),
+	IONIC_Q_F_4X_CQ_DESC		= BIT_ULL(8),
+	IONIC_Q_F_4X_SG_DESC		= BIT_ULL(9),
 };
 
 /**
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1b89549b243b..9a61b2bbb652 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1722,11 +1722,15 @@ static void ionic_txrx_free(struct ionic_lif *lif)
 
 static int ionic_txrx_alloc(struct ionic_lif *lif)
 {
-	unsigned int sg_desc_sz;
+	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
 	unsigned int flags;
 	unsigned int i;
 	int err = 0;
 
+	num_desc = lif->ntxq_descs;
+	desc_sz = sizeof(struct ionic_txq_desc);
+	comp_sz = sizeof(struct ionic_txq_comp);
+
 	if (lif->qtype_info[IONIC_QTYPE_TXQ].version >= 1 &&
 	    lif->qtype_info[IONIC_QTYPE_TXQ].sg_desc_sz ==
 					  sizeof(struct ionic_txq_sg_desc_v1))
@@ -1739,10 +1743,7 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 		flags |= IONIC_QCQ_F_INTR;
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
-				      lif->ntxq_descs,
-				      sizeof(struct ionic_txq_desc),
-				      sizeof(struct ionic_txq_comp),
-				      sg_desc_sz,
+				      num_desc, desc_sz, comp_sz, sg_desc_sz,
 				      lif->kern_pid, &lif->txqcqs[i]);
 		if (err)
 			goto err_out;
@@ -1759,16 +1760,24 @@ static int ionic_txrx_alloc(struct ionic_lif *lif)
 	}
 
 	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG | IONIC_QCQ_F_INTR;
+
+	num_desc = lif->nrxq_descs;
+	desc_sz = sizeof(struct ionic_rxq_desc);
+	comp_sz = sizeof(struct ionic_rxq_comp);
+	sg_desc_sz = sizeof(struct ionic_rxq_sg_desc);
+
+	if (lif->rxq_features & IONIC_Q_F_2X_CQ_DESC)
+		comp_sz *= 2;
+
 	for (i = 0; i < lif->nxqs; i++) {
 		err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
-				      lif->nrxq_descs,
-				      sizeof(struct ionic_rxq_desc),
-				      sizeof(struct ionic_rxq_comp),
-				      sizeof(struct ionic_rxq_sg_desc),
+				      num_desc, desc_sz, comp_sz, sg_desc_sz,
 				      lif->kern_pid, &lif->rxqcqs[i]);
 		if (err)
 			goto err_out;
 
+		lif->rxqcqs[i]->q.features = lif->rxq_features;
+
 		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
 				     lif->rxqcqs[i]->intr.index,
 				     lif->rx_coalesce_hw);
@@ -2218,6 +2227,7 @@ static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
 	/* only swapping the queues, not the napi, flags, or other stuff */
 	swap(a->q.features,   b->q.features);
 	swap(a->q.num_descs,  b->q.num_descs);
+	swap(a->q.desc_size,  b->q.desc_size);
 	swap(a->q.base,       b->q.base);
 	swap(a->q.base_pa,    b->q.base_pa);
 	swap(a->q.info,       b->q.info);
@@ -2225,6 +2235,7 @@ static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
 	swap(a->q_base_pa,    b->q_base_pa);
 	swap(a->q_size,       b->q_size);
 
+	swap(a->q.sg_desc_size, b->q.sg_desc_size);
 	swap(a->q.sg_base,    b->q.sg_base);
 	swap(a->q.sg_base_pa, b->q.sg_base_pa);
 	swap(a->sg_base,      b->sg_base);
@@ -2232,6 +2243,7 @@ static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
 	swap(a->sg_size,      b->sg_size);
 
 	swap(a->cq.num_descs, b->cq.num_descs);
+	swap(a->cq.desc_size, b->cq.desc_size);
 	swap(a->cq.base,      b->cq.base);
 	swap(a->cq.base_pa,   b->cq.base_pa);
 	swap(a->cq.info,      b->cq.info);
@@ -2246,9 +2258,9 @@ static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
 int ionic_reconfigure_queues(struct ionic_lif *lif,
 			     struct ionic_queue_params *qparam)
 {
+	unsigned int num_desc, desc_sz, comp_sz, sg_desc_sz;
 	struct ionic_qcq **tx_qcqs = NULL;
 	struct ionic_qcq **rx_qcqs = NULL;
-	unsigned int sg_desc_sz;
 	unsigned int flags;
 	int err = -ENOMEM;
 	unsigned int i;
@@ -2260,7 +2272,9 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 		if (!tx_qcqs)
 			goto err_out;
 	}
-	if (qparam->nxqs != lif->nxqs || qparam->nrxq_descs != lif->nrxq_descs) {
+	if (qparam->nxqs != lif->nxqs ||
+	    qparam->nrxq_descs != lif->nrxq_descs ||
+	    qparam->rxq_features != lif->rxq_features) {
 		rx_qcqs = devm_kcalloc(lif->ionic->dev, lif->ionic->nrxqs_per_lif,
 				       sizeof(struct ionic_qcq *), GFP_KERNEL);
 		if (!rx_qcqs)
@@ -2270,21 +2284,22 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	/* allocate new desc_info and rings, but leave the interrupt setup
 	 * until later so as to not mess with the still-running queues
 	 */
-	if (lif->qtype_info[IONIC_QTYPE_TXQ].version >= 1 &&
-	    lif->qtype_info[IONIC_QTYPE_TXQ].sg_desc_sz ==
-					  sizeof(struct ionic_txq_sg_desc_v1))
-		sg_desc_sz = sizeof(struct ionic_txq_sg_desc_v1);
-	else
-		sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
-
 	if (tx_qcqs) {
+		num_desc = qparam->ntxq_descs;
+		desc_sz = sizeof(struct ionic_txq_desc);
+		comp_sz = sizeof(struct ionic_txq_comp);
+
+		if (lif->qtype_info[IONIC_QTYPE_TXQ].version >= 1 &&
+		    lif->qtype_info[IONIC_QTYPE_TXQ].sg_desc_sz ==
+		    sizeof(struct ionic_txq_sg_desc_v1))
+			sg_desc_sz = sizeof(struct ionic_txq_sg_desc_v1);
+		else
+			sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
+
 		for (i = 0; i < qparam->nxqs; i++) {
 			flags = lif->txqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
-					      qparam->ntxq_descs,
-					      sizeof(struct ionic_txq_desc),
-					      sizeof(struct ionic_txq_comp),
-					      sg_desc_sz,
+					      num_desc, desc_sz, comp_sz, sg_desc_sz,
 					      lif->kern_pid, &tx_qcqs[i]);
 			if (err)
 				goto err_out;
@@ -2292,16 +2307,23 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	}
 
 	if (rx_qcqs) {
+		num_desc = qparam->nrxq_descs;
+		desc_sz = sizeof(struct ionic_rxq_desc);
+		comp_sz = sizeof(struct ionic_rxq_comp);
+		sg_desc_sz = sizeof(struct ionic_rxq_sg_desc);
+
+		if (qparam->rxq_features & IONIC_Q_F_2X_CQ_DESC)
+			comp_sz *= 2;
+
 		for (i = 0; i < qparam->nxqs; i++) {
 			flags = lif->rxqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
-					      qparam->nrxq_descs,
-					      sizeof(struct ionic_rxq_desc),
-					      sizeof(struct ionic_rxq_comp),
-					      sizeof(struct ionic_rxq_sg_desc),
+					      num_desc, desc_sz, comp_sz, sg_desc_sz,
 					      lif->kern_pid, &rx_qcqs[i]);
 			if (err)
 				goto err_out;
+
+			rx_qcqs[i]->q.features = qparam->rxq_features;
 		}
 	}
 
@@ -2388,6 +2410,7 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	}
 
 	swap(lif->nxqs, qparam->nxqs);
+	swap(lif->rxq_features, qparam->rxq_features);
 
 err_out_reinit_unlock:
 	/* re-init the queues, but don't lose an error code */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index be5cc89b2bd9..93d3058aed77 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -183,6 +183,7 @@ struct ionic_lif {
 	unsigned int ntxq_descs;
 	unsigned int nrxq_descs;
 	u32 rx_copybreak;
+	u64 rxq_features;
 	unsigned int rx_mode;
 	u64 hw_features;
 	bool registered;
@@ -221,6 +222,7 @@ struct ionic_queue_params {
 	unsigned int ntxq_descs;
 	unsigned int nrxq_descs;
 	unsigned int intr_split;
+	u64 rxq_features;
 };
 
 static inline void ionic_init_queue_params(struct ionic_lif *lif,
@@ -230,6 +232,7 @@ static inline void ionic_init_queue_params(struct ionic_lif *lif,
 	qparam->ntxq_descs = lif->ntxq_descs;
 	qparam->nrxq_descs = lif->nrxq_descs;
 	qparam->intr_split = test_bit(IONIC_LIF_F_SPLIT_INTR, lif->state);
+	qparam->rxq_features = lif->rxq_features;
 }
 
 static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 42d29cd2ca47..4859120eec72 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -229,12 +229,14 @@ static void ionic_rx_clean(struct ionic_queue *q,
 			   struct ionic_cq_info *cq_info,
 			   void *cb_arg)
 {
-	struct ionic_rxq_comp *comp = cq_info->rxcq;
 	struct net_device *netdev = q->lif->netdev;
 	struct ionic_qcq *qcq = q_to_qcq(q);
 	struct ionic_rx_stats *stats;
+	struct ionic_rxq_comp *comp;
 	struct sk_buff *skb;
 
+	comp = cq_info->cq_desc + qcq->cq.desc_size - sizeof(*comp);
+
 	stats = q_to_rx_stats(q);
 
 	if (comp->status) {
@@ -304,9 +306,11 @@ static void ionic_rx_clean(struct ionic_queue *q,
 
 static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 {
-	struct ionic_rxq_comp *comp = cq_info->rxcq;
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
+	struct ionic_rxq_comp *comp;
+
+	comp = cq_info->cq_desc + cq->desc_size - sizeof(*comp);
 
 	if (!color_match(comp->pkt_type_color, cq->done_color))
 		return false;
@@ -693,13 +697,15 @@ static void ionic_tx_clean(struct ionic_queue *q,
 
 static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 {
-	struct ionic_txq_comp *comp = cq_info->txcq;
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
+	struct ionic_txq_comp *comp;
 	int bytes = 0;
 	int pkts = 0;
 	u16 index;
 
+	comp = cq_info->cq_desc + cq->desc_size - sizeof(*comp);
+
 	if (!color_match(comp->color, cq->done_color))
 		return false;
 
-- 
2.17.1

