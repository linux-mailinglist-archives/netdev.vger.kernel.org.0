Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EAC234C0B
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgGaUPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgGaUPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 16:15:48 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1E7C061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 13:15:48 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k13so10117583plk.13
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 13:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dbrGQk5+OOKy5ircUxKuyjvq+gN8z/VEf1m73BmaeEo=;
        b=turqaxdcKMxT5f+Km7GEpEU4HEyAs0hDFTp3vcotErrRGk/PqVIH5eZt8HyhXME+U6
         UIkh1OkXIya9uVCTP2SVV6gGAwA85xArB1Qi0AaPg/ibkRX0gHNW6zrN4LTGmUsL68FN
         WdZooHU57k4voyDtcpyiVlc1SvspAgM3cy596Bmj3HmL5pNSK4CB/lvjz1rBy/7Xi8lw
         Je0bIf7lD3VNiysPgpm7fmUcbW4j0+99ypxaUla+7i8d+nE8ACkjE/Ed3NxWJrmLJQIG
         nHB45Yr2GgbpLRh3mHYEIgS6Q7EUmFbtHEiVUgsg1g6q1zcignwLgLFFA11FHvUsXM4o
         jHpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dbrGQk5+OOKy5ircUxKuyjvq+gN8z/VEf1m73BmaeEo=;
        b=VPHL/rcmmtKSwetXcMs2nvLTmytD5tgzTvLm3UxHQ9gCZYpHEFcp2+rauvE8YowM05
         l87KZrztiWRZL9tHtg5j4qG+OTsG+IXh8DbOFiTzEQUJ8QcrMkULr7n+UNFMMx8qkD5Z
         mW7xt6lo0vlb5jyTYhGVXSPYAEjLxB6gAHsJ1ZVfXAkD1H5TModj7vKNL8OatzvuCqoX
         jzYbeecFXOmDTZcRv0T+bV5+UiDD9I/fa+961Ah+b00EPDOEwnJb+VEcJAxN7vMv7FNN
         jPstxLkUANR9mxJ5+ftfDcMzTNnSWZi/WottMJ8vh+IRlz+esYDt9AcW7IHvQCOqNuuk
         mMww==
X-Gm-Message-State: AOAM533RKd6OZ1slnZX5E04BZwilJcwG4L2/jt8pglq3dFd0lpddVGLH
        PN4c6+5Fdl0s8SIZJfUnT+fNN0mPjvI=
X-Google-Smtp-Source: ABdhPJz9XJyBFngHalda97Bah9GINfdqXoTMvds4WpG8BwRao8/EssIlq5QuckJt7wxtgY2js/Awfg==
X-Received: by 2002:a17:90a:498b:: with SMTP id d11mr5527014pjh.179.1596226547190;
        Fri, 31 Jul 2020 13:15:47 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h1sm11470513pgn.41.2020.07.31.13.15.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2020 13:15:46 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 2/3] ionic: tx separate servicing
Date:   Fri, 31 Jul 2020 13:15:35 -0700
Message-Id: <20200731201536.18246-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731201536.18246-1-snelson@pensando.io>
References: <20200731201536.18246-1-snelson@pensando.io>
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

