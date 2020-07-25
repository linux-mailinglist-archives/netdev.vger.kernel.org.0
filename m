Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F6222D33E
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgGYAXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgGYAXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:23:37 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E57C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:37 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u185so6166509pfu.1
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kT2tMkoXYTrjcw9nlG2Do9BKjvXyvN7Ecl4OQDBPUi8=;
        b=f350XflqoTkpGZ2XCS5NsgcsWZIUcrQHzzKuWWmzGtMmRiwFI0spCGL7Yu0pQktLdu
         uaHRSPAe4M8zDyFTTSoXDQ9rB3zYyAZFOrnObdJrh4tt6LUljNUQWJdShz3+LdmcxVp+
         BvEs21KdkYcQLNuMvRsSoXqgzLEyRcC0tJqFnGjDx6ndJIQIwex0SMblhWZXxUYdHqBL
         14XiRtqGjrcnh1pkXbz7YbRMX2FFSid0qGNcIivQ8XALyRLnu6bthnSoFmc4r57BFIx0
         2rZz09YQOHZ577+Ebj2koSpM+R9vs6GIF487ARELQ3tNmTLjh/b5Gcf4VSgxeO6+cdJF
         prsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kT2tMkoXYTrjcw9nlG2Do9BKjvXyvN7Ecl4OQDBPUi8=;
        b=YM19TrXs5LJpgjIA0hQpkwOWKZktL5S2aIoZh2aI8UBP4sUbfG5hcYg7CGWUIrhSAZ
         fLNGH//S+7PziCoi+RrOE3yVK3YdFsxW2dSJgt5AubNrhGXSdHXOwPCPO9atOk/kCqsk
         m5UuRNxVoUHw0MczsBdS94G9wI6Vd1+OdRjU6BiaMjxrsAvY1cn+mmnwLeT491bJvX+J
         OltotjfCTXaxxG3v8QqXp5fvTPQhuWwxiqeW3lpR+mB0iGts6UscXZfbl/SykvwgOXng
         qCoJYIt60T4zbhGTI1nSeSoov4+etrGys6+BRfvgAkTh7c5zBgAbJINpEK+XQ8Qnyhdw
         Fx2w==
X-Gm-Message-State: AOAM532NfsDSQxtMwYAO/faGwNaNzNmLBS6mKQ7JM5a0Bo4h0MAKSoJE
        X1o4pN4jQFCS/vJUr7SStfEU80mY1T4=
X-Google-Smtp-Source: ABdhPJwzxkR5nyMmFeon2X1C/QaBo1Xq3eFIYCSp5qCKVChy/noC1VXd+6SODJtE/2Tjg+bffKlGZQ==
X-Received: by 2002:a63:4f1b:: with SMTP id d27mr10352759pgb.389.1595636616199;
        Fri, 24 Jul 2020 17:23:36 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id lr1sm8400368pjb.27.2020.07.24.17.23.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 17:23:35 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/4] ionic: tx separate servicing
Date:   Fri, 24 Jul 2020 17:23:25 -0700
Message-Id: <20200725002326.41407-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725002326.41407-1-snelson@pensando.io>
References: <20200725002326.41407-1-snelson@pensando.io>
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
index db60c5405a58..99b4e3dac245 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2065,6 +2065,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->index = index;
 	lif->ntxq_descs = IONIC_DEF_TXRX_DESC;
 	lif->nrxq_descs = IONIC_DEF_TXRX_DESC;
+	lif->tx_budget = IONIC_TX_BUDGET_DEFAULT;
 
 	/* Convert the default coalesce value to actual hw resolution */
 	lif->rx_coalesce_usecs = IONIC_ITR_COAL_USEC_DEFAULT;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index f1e7d3ef1c58..7a89a38161f6 100644
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
index cbca749d1b7f..76b17b493639 100644
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
@@ -255,29 +259,13 @@ static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
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
@@ -445,32 +433,42 @@ int ionic_rx_napi(struct napi_struct *napi, int budget)
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
@@ -558,43 +556,39 @@ static void ionic_tx_clean(struct ionic_queue *q,
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

