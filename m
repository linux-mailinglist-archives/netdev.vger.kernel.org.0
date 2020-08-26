Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEC7253521
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgHZQn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgHZQmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:33 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985A4C061757
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:32 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 2so1135973pjx.5
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=brxLTNsq6wnRqiuajreeSZQweUUAvKWfB6WIjFURm98=;
        b=i5oo7zv4OsITHWtCvvxAPJoCK/wMmFh82YBefdN0kiufJtq6n7n+osW+d44X4iBLVz
         QN2EWom7B9XhJEPk7xSzCpVjN1vT/1OlGw3CZtDkkZNwu0EnDs2+vpn5U/LLrDN40OTY
         6KDQzAFv5cNgEXSoj5Udjs1tKTyKPb5XJc3IR8aw7YY3ME44c9MZV6iOUZ9aI/+hh+52
         g562NZjI8mE9kjHpaf8YPVTXYwHAoXGopuEGEzvhcegnpRl5d7mtISpY7FZHi4OwEJr6
         svUDwsU8aVvPK3P5FVLnx2/0mILMaAdRuKWKSkFMVdSAbihhUqmUPEgRfp0wjTUCamvQ
         tNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=brxLTNsq6wnRqiuajreeSZQweUUAvKWfB6WIjFURm98=;
        b=YuRYfVDOqSfe4pdABAnF0BeDvbr8XQK3iLBform+hCKEerG3g3Ienqzsg4vF5BwXCQ
         xTGcg1/Qa2M5vQI5A3Rb4sFIaREXkoEkHuwjzTvk92ChDfRHBYPMSpvLuUP5x9FOGqYC
         zApwb16Lf1kOFlyaVHqreP1oiU1q9hBzMlUBpKLenuHptx7s7VT5jf6TCV7vXpf6ZVT+
         F5QK89lpXsH3tNAHHjfIMTlb4y62LFWrS9cYIwO3zL++7YA6W/Af4SaxO3ltk5xyCKwk
         81iJEeBISs+dX/o8w1ZvdevAaE9ig+dG8lAzvPBSKgDc9Eg9TKQKv9XnlFgtOrDWleBy
         cpZQ==
X-Gm-Message-State: AOAM533rgogRjkqPyu4JWHqtw1C/OWzOALG+5rpmtnTylwLSMWE3XkjC
        mJrVg5mBclaG+OSm2RvaM3Dj6iocQZGOew==
X-Google-Smtp-Source: ABdhPJxsaSojfIN/K1TRoL1zheZNqziRam81ewGpwvccHGyDCgFmcYX+WTgkzaIpc1SWxXJhqRvwAA==
X-Received: by 2002:a17:90a:9203:: with SMTP id m3mr6813936pjo.148.1598460151193;
        Wed, 26 Aug 2020 09:42:31 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 08/12] ionic: use index not pointer for queue tracking
Date:   Wed, 26 Aug 2020 09:42:10 -0700
Message-Id: <20200826164214.31792-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use index counters rather than pointers for tracking head
and tail in the queues to save a little memory and to perhaps
slightly faster queue processing.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  6 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 40 ++++++-----
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 49 +++++++++----
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 12 ++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   | 12 ++--
 .../net/ethernet/pensando/ionic/ionic_main.c  | 26 ++++---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 72 ++++++++++---------
 7 files changed, 129 insertions(+), 88 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index e12dbe4ea73d..683bbbf75115 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -76,7 +76,7 @@ static int q_tail_show(struct seq_file *seq, void *v)
 {
 	struct ionic_queue *q = seq->private;
 
-	seq_printf(seq, "%d\n", q->tail->index);
+	seq_printf(seq, "%d\n", q->tail_idx);
 
 	return 0;
 }
@@ -86,7 +86,7 @@ static int q_head_show(struct seq_file *seq, void *v)
 {
 	struct ionic_queue *q = seq->private;
 
-	seq_printf(seq, "%d\n", q->head->index);
+	seq_printf(seq, "%d\n", q->head_idx);
 
 	return 0;
 }
@@ -96,7 +96,7 @@ static int cq_tail_show(struct seq_file *seq, void *v)
 {
 	struct ionic_cq *cq = seq->private;
 
-	seq_printf(seq, "%d\n", cq->tail->index);
+	seq_printf(seq, "%d\n", cq->tail_idx);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 25cf376f3b40..3645673b4b18 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -482,7 +482,7 @@ int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
 	cq->bound_intr = intr;
 	cq->num_descs = num_descs;
 	cq->desc_size = desc_size;
-	cq->tail = cq->info;
+	cq->tail_idx = 0;
 	cq->done_color = 1;
 
 	cur = cq->info;
@@ -522,15 +522,18 @@ unsigned int ionic_cq_service(struct ionic_cq *cq, unsigned int work_to_do,
 			      ionic_cq_cb cb, ionic_cq_done_cb done_cb,
 			      void *done_arg)
 {
+	struct ionic_cq_info *cq_info;
 	unsigned int work_done = 0;
 
 	if (work_to_do == 0)
 		return 0;
 
-	while (cb(cq, cq->tail)) {
-		if (cq->tail->last)
+	cq_info = &cq->info[cq->tail_idx];
+	while (cb(cq, cq_info)) {
+		if (cq->tail_idx == cq->num_descs - 1)
 			cq->done_color = !cq->done_color;
-		cq->tail = cq->tail->next;
+		cq->tail_idx = (cq->tail_idx + 1) & (cq->num_descs - 1);
+		cq_info = &cq->info[cq->tail_idx];
 		DEBUG_STATS_CQE_CNT(cq);
 
 		if (++work_done >= work_to_do)
@@ -565,8 +568,8 @@ int ionic_q_init(struct ionic_lif *lif, struct ionic_dev *idev,
 	q->num_descs = num_descs;
 	q->desc_size = desc_size;
 	q->sg_desc_size = sg_desc_size;
-	q->tail = q->info;
-	q->head = q->tail;
+	q->tail_idx = 0;
+	q->head_idx = 0;
 	q->pid = pid;
 
 	snprintf(q->name, sizeof(q->name), "L%d-%s%u", lif->index, name, index);
@@ -614,19 +617,22 @@ void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
 		  void *cb_arg)
 {
 	struct device *dev = q->lif->ionic->dev;
+	struct ionic_desc_info *desc_info;
 	struct ionic_lif *lif = q->lif;
 
-	q->head->cb = cb;
-	q->head->cb_arg = cb_arg;
-	q->head = q->head->next;
+	desc_info = &q->info[q->head_idx];
+	desc_info->cb = cb;
+	desc_info->cb_arg = cb_arg;
+
+	q->head_idx = (q->head_idx + 1) & (q->num_descs - 1);
 
 	dev_dbg(dev, "lif=%d qname=%s qid=%d qtype=%d p_index=%d ringdb=%d\n",
 		q->lif->index, q->name, q->hw_type, q->hw_index,
-		q->head->index, ring_doorbell);
+		q->head_idx, ring_doorbell);
 
 	if (ring_doorbell)
 		ionic_dbell_ring(lif->kern_dbpage, q->hw_type,
-				 q->dbval | q->head->index);
+				 q->dbval | q->head_idx);
 }
 
 static bool ionic_q_is_posted(struct ionic_queue *q, unsigned int pos)
@@ -634,8 +640,8 @@ static bool ionic_q_is_posted(struct ionic_queue *q, unsigned int pos)
 	unsigned int mask, tail, head;
 
 	mask = q->num_descs - 1;
-	tail = q->tail->index;
-	head = q->head->index;
+	tail = q->tail_idx;
+	head = q->head_idx;
 
 	return ((pos - tail) & mask) < ((head - tail) & mask);
 }
@@ -648,18 +654,18 @@ void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 	void *cb_arg;
 
 	/* check for empty queue */
-	if (q->tail->index == q->head->index)
+	if (q->tail_idx == q->head_idx)
 		return;
 
 	/* stop index must be for a descriptor that is not yet completed */
 	if (unlikely(!ionic_q_is_posted(q, stop_index)))
 		dev_err(q->lif->ionic->dev,
 			"ionic stop is not posted %s stop %u tail %u head %u\n",
-			q->name, stop_index, q->tail->index, q->head->index);
+			q->name, stop_index, q->tail_idx, q->head_idx);
 
 	do {
-		desc_info = q->tail;
-		q->tail = desc_info->next;
+		desc_info = &q->info[q->tail_idx];
+		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 
 		cb = desc_info->cb;
 		cb_arg = desc_info->cb_arg;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index d5cba502abca..9e2ac2b8a082 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -149,7 +149,13 @@ struct ionic_dev {
 };
 
 struct ionic_cq_info {
-	void *cq_desc;
+	union {
+		void *cq_desc;
+		struct ionic_txq_comp *txcq;
+		struct ionic_rxq_comp *rxcq;
+		struct ionic_admin_comp *admincq;
+		struct ionic_notifyq_event *notifyq;
+	};
 	struct ionic_cq_info *next;
 	unsigned int index;
 	bool last;
@@ -169,8 +175,17 @@ struct ionic_page_info {
 };
 
 struct ionic_desc_info {
-	void *desc;
-	void *sg_desc;
+	union {
+		void *desc;
+		struct ionic_txq_desc *txq_desc;
+		struct ionic_rxq_desc *rxq_desc;
+		struct ionic_admin_cmd *adminq_desc;
+	};
+	union {
+		void *sg_desc;
+		struct ionic_txq_sg_desc *txq_sg_desc;
+		struct ionic_rxq_sg_desc *rxq_sgl_desc;
+	};
 	struct ionic_desc_info *next;
 	unsigned int index;
 	unsigned int left;
@@ -183,22 +198,32 @@ struct ionic_desc_info {
 #define IONIC_QUEUE_NAME_MAX_SZ		32
 
 struct ionic_queue {
+	struct device *dev;
 	u64 dbell_count;
 	u64 drop;
 	u64 stop;
 	u64 wake;
 	struct ionic_lif *lif;
 	struct ionic_desc_info *info;
-	struct ionic_desc_info *tail;
-	struct ionic_desc_info *head;
 	struct ionic_dev *idev;
+	u16 head_idx;
+	u16 tail_idx;
 	unsigned int index;
 	unsigned int type;
 	unsigned int hw_index;
 	unsigned int hw_type;
 	u64 dbval;
-	void *base;
-	void *sg_base;
+	union {
+		void *base;
+		struct ionic_txq_desc *txq;
+		struct ionic_rxq_desc *rxq;
+		struct ionic_admin_cmd *adminq;
+	};
+	union {
+		void *sg_base;
+		struct ionic_txq_sg_desc *txq_sgl;
+		struct ionic_rxq_sg_desc *rxq_sgl;
+	};
 	dma_addr_t base_pa;
 	dma_addr_t sg_base_pa;
 	unsigned int num_descs;
@@ -225,9 +250,9 @@ struct ionic_cq {
 	dma_addr_t base_pa;
 	struct ionic_lif *lif;
 	struct ionic_cq_info *info;
-	struct ionic_cq_info *tail;
 	struct ionic_queue *bound_q;
 	struct ionic_intr_info *bound_intr;
+	u16 tail_idx;
 	bool done_color;
 	unsigned int num_descs;
 	u64 compl_count;
@@ -246,12 +271,12 @@ static inline void ionic_intr_init(struct ionic_dev *idev,
 
 static inline unsigned int ionic_q_space_avail(struct ionic_queue *q)
 {
-	unsigned int avail = q->tail->index;
+	unsigned int avail = q->tail_idx;
 
-	if (q->head->index >= avail)
-		avail += q->head->left - 1;
+	if (q->head_idx >= avail)
+		avail += q->num_descs - q->head_idx - 1;
 	else
-		avail -= q->head->index + 1;
+		avail -= q->head_idx + 1;
 
 	return avail;
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 016d55ad1f6a..b77827e9355c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -632,9 +632,9 @@ static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "txq_init.ver %d\n", ctx.cmd.q_init.ver);
 	dev_dbg(dev, "txq_init.intr_index %d\n", ctx.cmd.q_init.intr_index);
 
-	q->tail = q->info;
-	q->head = q->tail;
-	cq->tail = cq->info;
+	q->tail_idx = 0;
+	q->head_idx = 0;
+	cq->tail_idx = 0;
 
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
@@ -689,9 +689,9 @@ static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	dev_dbg(dev, "rxq_init.ver %d\n", ctx.cmd.q_init.ver);
 	dev_dbg(dev, "rxq_init.intr_index %d\n", ctx.cmd.q_init.intr_index);
 
-	q->tail = q->info;
-	q->head = q->tail;
-	cq->tail = cq->info;
+	q->tail_idx = 0;
+	q->head_idx = 0;
+	cq->tail_idx = 0;
 
 	err = ionic_adminq_post_wait(lif, &ctx);
 	if (err)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index aa7c1a8cbefc..b8f774b1db3a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -244,14 +244,15 @@ int ionic_lif_rss_config(struct ionic_lif *lif, u16 types,
 
 int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg);
 
-static inline void debug_stats_txq_post(struct ionic_queue *q,
-					struct ionic_txq_desc *desc, bool dbell)
+static inline void debug_stats_txq_post(struct ionic_queue *q, bool dbell)
 {
-	u8 num_sg_elems = ((le64_to_cpu(desc->cmd) >> IONIC_TXQ_DESC_NSGE_SHIFT)
-						& IONIC_TXQ_DESC_NSGE_MASK);
+	struct ionic_txq_desc *desc = &q->txq[q->head_idx];
+	u8 num_sg_elems;
 
 	q->dbell_count += dbell;
 
+	num_sg_elems = ((le64_to_cpu(desc->cmd) >> IONIC_TXQ_DESC_NSGE_SHIFT)
+						& IONIC_TXQ_DESC_NSGE_MASK);
 	if (num_sg_elems > (IONIC_MAX_NUM_SG_CNTR - 1))
 		num_sg_elems = IONIC_MAX_NUM_SG_CNTR - 1;
 
@@ -272,8 +273,7 @@ static inline void debug_stats_napi_poll(struct ionic_qcq *qcq,
 #define DEBUG_STATS_CQE_CNT(cq)		((cq)->compl_count++)
 #define DEBUG_STATS_RX_BUFF_CNT(q)	((q)->lif->rxqstats[q->index].buffers_posted++)
 #define DEBUG_STATS_INTR_REARM(intr)	((intr)->rearm_count++)
-#define DEBUG_STATS_TXQ_POST(q, txdesc, dbell) \
-	debug_stats_txq_post(q, txdesc, dbell)
+#define DEBUG_STATS_TXQ_POST(q, dbell)  debug_stats_txq_post(q, dbell)
 #define DEBUG_STATS_NAPI_POLL(qcq, work_done) \
 	debug_stats_napi_poll(qcq, work_done)
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index df5b9bcc3aba..2b72a51be1d0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -181,15 +181,17 @@ static const char *ionic_opcode_to_str(enum ionic_cmd_opcode opcode)
 
 static void ionic_adminq_flush(struct ionic_lif *lif)
 {
-	struct ionic_queue *adminq = &lif->adminqcq->q;
+	struct ionic_queue *q = &lif->adminqcq->q;
+	struct ionic_desc_info *desc_info;
 
 	spin_lock(&lif->adminq_lock);
 
-	while (adminq->tail != adminq->head) {
-		memset(adminq->tail->desc, 0, sizeof(union ionic_adminq_cmd));
-		adminq->tail->cb = NULL;
-		adminq->tail->cb_arg = NULL;
-		adminq->tail = adminq->tail->next;
+	while (q->tail_idx != q->head_idx) {
+		desc_info = &q->info[q->tail_idx];
+		memset(desc_info->desc, 0, sizeof(union ionic_adminq_cmd));
+		desc_info->cb = NULL;
+		desc_info->cb_arg = NULL;
+		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 	}
 	spin_unlock(&lif->adminq_lock);
 }
@@ -245,7 +247,8 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 
 static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 {
-	struct ionic_queue *adminq;
+	struct ionic_desc_info *desc_info;
+	struct ionic_queue *q;
 	int err = 0;
 
 	WARN_ON(in_interrupt());
@@ -253,10 +256,10 @@ static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 	if (!lif->adminqcq)
 		return -EIO;
 
-	adminq = &lif->adminqcq->q;
+	q = &lif->adminqcq->q;
 
 	spin_lock(&lif->adminq_lock);
-	if (!ionic_q_has_space(adminq, 1)) {
+	if (!ionic_q_has_space(q, 1)) {
 		err = -ENOSPC;
 		goto err_out;
 	}
@@ -265,13 +268,14 @@ static int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 	if (err)
 		goto err_out;
 
-	memcpy(adminq->head->desc, &ctx->cmd, sizeof(ctx->cmd));
+	desc_info = &q->info[q->head_idx];
+	memcpy(desc_info->desc, &ctx->cmd, sizeof(ctx->cmd));
 
 	dev_dbg(&lif->netdev->dev, "post admin queue command:\n");
 	dynamic_hex_dump("cmd ", DUMP_PREFIX_OFFSET, 16, 1,
 			 &ctx->cmd, sizeof(ctx->cmd), true);
 
-	ionic_q_post(adminq, true, ionic_adminq_cb, ctx);
+	ionic_q_post(q, true, ionic_adminq_cb, ctx);
 
 err_out:
 	spin_unlock(&lif->adminq_lock);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 220e132164e2..c3291decd4c3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -22,7 +22,7 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell,
 				  ionic_desc_cb cb_func, void *cb_arg)
 {
-	DEBUG_STATS_TXQ_POST(q, q->head->desc, ring_dbell);
+	DEBUG_STATS_TXQ_POST(q, ring_dbell);
 
 	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
 }
@@ -235,14 +235,14 @@ static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 		return false;
 
 	/* check for empty queue */
-	if (q->tail->index == q->head->index)
+	if (q->tail_idx == q->head_idx)
 		return false;
 
-	desc_info = q->tail;
+	desc_info = &q->info[q->tail_idx];
 	if (desc_info->index != le16_to_cpu(comp->comp_index))
 		return false;
 
-	q->tail = desc_info->next;
+	q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 
 	/* clean the related q entry, only one per qc completion */
 	ionic_rx_clean(q, desc_info, cq_info, desc_info->cb_arg);
@@ -338,7 +338,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 
 	for (i = ionic_q_space_avail(q); i; i--) {
 		remain_len = len;
-		desc_info = q->head;
+		desc_info = &q->info[q->head_idx];
 		desc = desc_info->desc;
 		sg_desc = desc_info->sg_desc;
 		page_info = &desc_info->pages[0];
@@ -387,7 +387,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 	}
 
 	ionic_dbell_ring(q->lif->kern_dbpage, q->hw_type,
-			 q->dbval | q->head->index);
+			 q->dbval | q->head_idx);
 }
 
 static void ionic_rx_fill_cb(void *arg)
@@ -397,25 +397,29 @@ static void ionic_rx_fill_cb(void *arg)
 
 void ionic_rx_empty(struct ionic_queue *q)
 {
-	struct ionic_desc_info *cur;
+	struct ionic_desc_info *desc_info;
 	struct ionic_rxq_desc *desc;
 	unsigned int i;
+	u16 idx;
 
-	for (cur = q->tail; cur != q->head; cur = cur->next) {
-		desc = cur->desc;
+	idx = q->tail_idx;
+	while (idx != q->head_idx) {
+		desc_info = &q->info[idx];
+		desc = desc_info->desc;
 		desc->addr = 0;
 		desc->len = 0;
 
-		for (i = 0; i < cur->npages; i++) {
-			if (likely(cur->pages[i].page)) {
-				ionic_rx_page_free(q, cur->pages[i].page,
-						   cur->pages[i].dma_addr);
-				cur->pages[i].page = NULL;
-				cur->pages[i].dma_addr = 0;
+		for (i = 0; i < desc_info->npages; i++) {
+			if (likely(desc_info->pages[i].page)) {
+				ionic_rx_page_free(q, desc_info->pages[i].page,
+						   desc_info->pages[i].dma_addr);
+				desc_info->pages[i].page = NULL;
+				desc_info->pages[i].dma_addr = 0;
 			}
 		}
 
-		cur->cb_arg = NULL;
+		desc_info->cb_arg = NULL;
+		idx = (idx + 1) & (q->num_descs - 1);
 	}
 }
 
@@ -630,9 +634,9 @@ static bool ionic_tx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
 	 * several q entries completed for each cq completion
 	 */
 	do {
-		desc_info = q->tail;
-		q->tail = desc_info->next;
-		ionic_tx_clean(q, desc_info, cq->tail, desc_info->cb_arg);
+		desc_info = &q->info[q->tail_idx];
+		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
+		ionic_tx_clean(q, desc_info, cq_info, desc_info->cb_arg);
 		desc_info->cb = NULL;
 		desc_info->cb_arg = NULL;
 	} while (desc_info->index != le16_to_cpu(comp->comp_index));
@@ -658,9 +662,9 @@ void ionic_tx_empty(struct ionic_queue *q)
 	int done = 0;
 
 	/* walk the not completed tx entries, if any */
-	while (q->head != q->tail) {
-		desc_info = q->tail;
-		q->tail = desc_info->next;
+	while (q->head_idx != q->tail_idx) {
+		desc_info = &q->info[q->tail_idx];
+		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 		ionic_tx_clean(q, desc_info, NULL, desc_info->cb_arg);
 		desc_info->cb = NULL;
 		desc_info->cb_arg = NULL;
@@ -748,8 +752,8 @@ static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc
 static struct ionic_txq_desc *ionic_tx_tso_next(struct ionic_queue *q,
 						struct ionic_txq_sg_elem **elem)
 {
-	struct ionic_txq_sg_desc *sg_desc = q->head->sg_desc;
-	struct ionic_txq_desc *desc = q->head->desc;
+	struct ionic_txq_sg_desc *sg_desc = q->info[q->head_idx].txq_sg_desc;
+	struct ionic_txq_desc *desc = q->info[q->head_idx].txq_desc;
 
 	*elem = sg_desc->elems;
 	return desc;
@@ -758,13 +762,13 @@ static struct ionic_txq_desc *ionic_tx_tso_next(struct ionic_queue *q,
 static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 {
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct ionic_desc_info *abort = q->head;
+	struct ionic_desc_info *rewind_desc_info;
 	struct device *dev = q->lif->ionic->dev;
-	struct ionic_desc_info *rewind = abort;
 	struct ionic_txq_sg_elem *elem;
 	struct ionic_txq_desc *desc;
 	unsigned int frag_left = 0;
 	unsigned int offset = 0;
+	u16 abort = q->head_idx;
 	unsigned int len_left;
 	dma_addr_t desc_addr;
 	unsigned int hdrlen;
@@ -772,6 +776,7 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 	unsigned int seglen;
 	u64 total_bytes = 0;
 	u64 total_pkts = 0;
+	u16 rewind = abort;
 	unsigned int left;
 	unsigned int len;
 	unsigned int mss;
@@ -916,19 +921,20 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 	return 0;
 
 err_out_abort:
-	while (rewind->desc != q->head->desc) {
-		ionic_tx_clean(q, rewind, NULL, NULL);
-		rewind = rewind->next;
+	while (rewind != q->head_idx) {
+		rewind_desc_info = &q->info[rewind];
+		ionic_tx_clean(q, rewind_desc_info, NULL, NULL);
+		rewind = (rewind + 1) & (q->num_descs - 1);
 	}
-	q->head = abort;
+	q->head_idx = abort;
 
 	return -ENOMEM;
 }
 
 static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
 {
+	struct ionic_txq_desc *desc = q->info[q->head_idx].txq_desc;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct ionic_txq_desc *desc = q->head->desc;
 	struct device *dev = q->lif->ionic->dev;
 	dma_addr_t dma_addr;
 	bool has_vlan;
@@ -967,8 +973,8 @@ static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
 
 static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb)
 {
+	struct ionic_txq_desc *desc = q->info[q->head_idx].txq_desc;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct ionic_txq_desc *desc = q->head->desc;
 	struct device *dev = q->lif->ionic->dev;
 	dma_addr_t dma_addr;
 	bool has_vlan;
@@ -1002,7 +1008,7 @@ static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb)
 
 static int ionic_tx_skb_frags(struct ionic_queue *q, struct sk_buff *skb)
 {
-	struct ionic_txq_sg_desc *sg_desc = q->head->sg_desc;
+	struct ionic_txq_sg_desc *sg_desc = q->info[q->head_idx].txq_sg_desc;
 	unsigned int len_left = skb->len - skb_headlen(skb);
 	struct ionic_txq_sg_elem *elem = sg_desc->elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-- 
2.17.1

