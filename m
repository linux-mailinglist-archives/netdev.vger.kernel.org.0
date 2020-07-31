Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10EE233C5E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgGaABa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730811AbgGaAB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 20:01:27 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC58C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:01:27 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t15so6071829pjq.5
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 17:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dbrGQk5+OOKy5ircUxKuyjvq+gN8z/VEf1m73BmaeEo=;
        b=FpClodXM23zf+nHC8gtaTiBomy4NGs5NtjEe4HTGIy6qJXak1w/GQ533M6PBKg+hZh
         ssNkEqZLEj/PMvokBIxsJpQw/hfRq8S12bU3TIadqoOpNXKsXrBfslNxH+RvA40oOkK0
         ycnSiqVNbMfuirDrK5JqaZK7VM8ybbwOY5Kg9nZ8KcHsvIng5Qd8A7556vtRUedDI7bz
         Wfo4aAYjyf1kN2dXRMQb6RfbQhg03iCASF4MQhRexBMqnuwQJUbLqAQqn/1umRmNyIJ9
         jIzaQhO7dFZCQoYGNUS0eW/2Op0LUTxn6MXMtOM69cxzVcPDAa+QNsQBu4AzyYTgKKti
         hQjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dbrGQk5+OOKy5ircUxKuyjvq+gN8z/VEf1m73BmaeEo=;
        b=HnkUnsFGoPC2xLgZ+uq2rlXNbkFOyipdjiG/ZAtorWGjqf5jMVbRLwvU0Cuo5c0mOE
         i+h7rDwFvx0k1mUJ3XGqSNPV6d8V/0icBQFoU/O4b+nJh3ZhJHLwA+68TdTaCWsuQpgL
         Vz9guCUBYewr20hzqR6lqF3MIxsf1hXKekcron2ZnD2+SYHBxG8ck0UaLjaaRFFDq1jw
         TKlz711d2lb6AgRjruie9LUDWqe/SpWFpWhtdATtE0Zd+l1uZTUTNemY78IXv2DTo7qP
         QU0xIxiLd9kBetfCEZWdnJdW/IIR8qYjBRlBG0rPnyfV7qR47OJXSviau8v0RK0YKTmF
         3o2Q==
X-Gm-Message-State: AOAM5326XpKSvfkHAC/zmJzNUbS/jpDM1oa7tMKSfhEI6Ukko6SgxAg0
        Evz5yLgkoY4KUSsSUu17JXBGV/Yk+XA=
X-Google-Smtp-Source: ABdhPJwicK9twfFdE+3Vo23pAvOycdTkcKcUHsZIATPRE3NTBR3Q7hvqLvFZoltzvbDyQqkjHIXJ1A==
X-Received: by 2002:a62:84d5:: with SMTP id k204mr1256267pfd.66.1596153686447;
        Thu, 30 Jul 2020 17:01:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a2sm7592436pgf.53.2020.07.30.17.01.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 17:01:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/3] ionic: tx separate servicing
Date:   Thu, 30 Jul 2020 17:00:57 -0700
Message-Id: <20200731000058.37344-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731000058.37344-1-snelson@pensando.io>
References: <20200731000058.37344-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We give the tx clean path its own budget and service routine in
order to give a little more leeway to be more aggressive, and
in preparation for coming changes.  We've found this gives us
a little better performance in some packet processing scenarios
without hurting other scenarios.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   1 +
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   2 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 106 +++++++++---------
 3 files changed, 53 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 728dd6429d80..b228362363ca 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2063,6 +2063,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->index = index;
 	lif->ntxq_descs = IONIC_DEF_TXRX_DESC;
 	lif->nrxq_descs = IONIC_DEF_TXRX_DESC;
+	lif->tx_budget = IONIC_TX_BUDGET_DEFAULT;
 
 	/* Convert the default coalesce value to actual hw resolution */
 	lif->rx_coalesce_usecs = IONIC_ITR_COAL_USEC_DEFAULT;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index edad17d7aeeb..13f173d83970 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -13,6 +13,7 @@
 #define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
 #define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS + 1)
 #define IONIC_RX_COPYBREAK_DEFAULT	256
+#define IONIC_TX_BUDGET_DEFAULT		256
 
 struct ionic_tx_stats {
 	u64 dma_map_err;
@@ -176,6 +177,7 @@ struct ionic_lif {
 	unsigned int ntxq_descs;
 	unsigned int nrxq_descs;
 	u32 rx_copybreak;
+	u32 tx_budget;
 	unsigned int rx_mode;
 	u64 hw_features;
 	bool mc_overflow;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index e660cd66f9a8..766f4595895c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -15,6 +15,10 @@ static void ionic_rx_clean(struct ionic_queue *q,
 			   struct ionic_cq_info *cq_info,
 			   void *cb_arg);
 
+static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info);
+
+static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info);
+
 static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell,
 				  ionic_desc_cb cb_func, void *cb_arg)
 {
@@ -249,29 +253,13 @@ static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	return true;
 }
 
-static u32 ionic_rx_walk_cq(struct ionic_cq *rxcq, u32 limit)
-{
-	u32 work_done = 0;
-
-	while (ionic_rx_service(rxcq, rxcq->tail)) {
-		if (rxcq->tail->last)
-			rxcq->done_color = !rxcq->done_color;
-		rxcq->tail = rxcq->tail->next;
-		DEBUG_STATS_CQE_CNT(rxcq);
-
-		if (++work_done >= limit)
-			break;
-	}
-
-	return work_done;
-}
-
 void ionic_rx_flush(struct ionic_cq *cq)
 {
 	struct ionic_dev *idev = &cq->lif->ionic->idev;
 	u32 work_done;
 
-	work_done = ionic_rx_walk_cq(cq, cq->num_descs);
+	work_done = ionic_cq_service(cq, cq->num_descs,
+				     ionic_rx_service, NULL, NULL);
 
 	if (work_done)
 		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
@@ -439,32 +427,42 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
 	struct ionic_dev *idev;
 	struct ionic_lif *lif;
 	struct ionic_cq *txcq;
+	u32 rx_work_done = 0;
+	u32 tx_work_done = 0;
 	u32 work_done = 0;
 	u32 flags = 0;
+	bool unmask;
 
 	lif = rxcq->bound_q->lif;
 	idev = &lif->ionic->idev;
 	txcq = &lif->txqcqs[qi].qcq->cq;
 
-	ionic_tx_flush(txcq);
-
-	work_done = ionic_rx_walk_cq(rxcq, budget);
+	tx_work_done = ionic_cq_service(txcq, lif->tx_budget,
+					ionic_tx_service, NULL, NULL);
 
-	if (work_done)
+	rx_work_done = ionic_cq_service(rxcq, budget,
+					ionic_rx_service, NULL, NULL);
+	if (rx_work_done)
 		ionic_rx_fill_cb(rxcq->bound_q);
 
-	if (work_done < budget && napi_complete_done(napi, work_done)) {
+	unmask = (rx_work_done < budget) && (tx_work_done < lif->tx_budget);
+
+	if (unmask && napi_complete_done(napi, rx_work_done)) {
 		flags |= IONIC_INTR_CRED_UNMASK;
 		DEBUG_STATS_INTR_REARM(rxcq->bound_intr);
+		work_done = rx_work_done;
+	} else {
+		work_done = budget;
 	}
 
 	if (work_done || flags) {
 		flags |= IONIC_INTR_CRED_RESET_COALESCE;
 		ionic_intr_credits(idev->intr_ctrl, rxcq->bound_intr->index,
-				   work_done, flags);
+				   tx_work_done + rx_work_done, flags);
 	}
 
-	DEBUG_STATS_NAPI_POLL(qcq, work_done);
+	DEBUG_STATS_NAPI_POLL(qcq, rx_work_done);
+	DEBUG_STATS_NAPI_POLL(qcq, tx_work_done);
 
 	return work_done;
 }
@@ -552,43 +550,39 @@ static void ionic_tx_clean(struct ionic_queue *q,
 	}
 }
 
-void ionic_tx_flush(struct ionic_cq *cq)
+static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 {
-	struct ionic_txq_comp *comp = cq->tail->cq_desc;
-	struct ionic_dev *idev = &cq->lif->ionic->idev;
+	struct ionic_txq_comp *comp = cq_info->cq_desc;
 	struct ionic_queue *q = cq->bound_q;
 	struct ionic_desc_info *desc_info;
-	unsigned int work_done = 0;
-
-	/* walk the completed cq entries */
-	while (work_done < cq->num_descs &&
-	       color_match(comp->color, cq->done_color)) {
-
-		/* clean the related q entries, there could be
-		 * several q entries completed for each cq completion
-		 */
-		do {
-			desc_info = q->tail;
-			q->tail = desc_info->next;
-			ionic_tx_clean(q, desc_info, cq->tail,
-				       desc_info->cb_arg);
-			desc_info->cb = NULL;
-			desc_info->cb_arg = NULL;
-		} while (desc_info->index != le16_to_cpu(comp->comp_index));
-
-		if (cq->tail->last)
-			cq->done_color = !cq->done_color;
-
-		cq->tail = cq->tail->next;
-		comp = cq->tail->cq_desc;
-		DEBUG_STATS_CQE_CNT(cq);
-
-		work_done++;
-	}
 
+	if (!color_match(comp->color, cq->done_color))
+		return false;
+
+	/* clean the related q entries, there could be
+	 * several q entries completed for each cq completion
+	 */
+	do {
+		desc_info = q->tail;
+		q->tail = desc_info->next;
+		ionic_tx_clean(q, desc_info, cq->tail, desc_info->cb_arg);
+		desc_info->cb = NULL;
+		desc_info->cb_arg = NULL;
+	} while (desc_info->index != le16_to_cpu(comp->comp_index));
+
+	return true;
+}
+
+void ionic_tx_flush(struct ionic_cq *cq)
+{
+	struct ionic_dev *idev = &cq->lif->ionic->idev;
+	u32 work_done;
+
+	work_done = ionic_cq_service(cq, cq->num_descs,
+				     ionic_tx_service, NULL, NULL);
 	if (work_done)
 		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
-				   work_done, 0);
+				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
 }
 
 void ionic_tx_empty(struct ionic_queue *q)
-- 
2.17.1

