Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851C33347E6
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhCJT1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhCJT1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:27:04 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4F1C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:04 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 16so11279875pfn.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LUw/9S7XVIiz2FEwi+SyGdTLJj7pZWeSBY9aL56mEH8=;
        b=JAFuSv/ObqlnLC3KD8kdYIou0eBxT1088j/a9qsK0X/He2ma3UKKAaemr661gsEOK4
         ah9j7yROqQQPei+CzGZ3Oedms/ri/pfQoRvAnnBEiuRCFLn2vKo8R58blV28yi//PXjF
         jplxkbD9auVQ+EvcmrnKJh2ZYNGDiuGhplF/avHmy2ptlX8gIjplX/2nKIWnFGxsitb3
         egJmaoHTZbxp4OuFF4k2DtpSJSsjvD1iEsnfAO28NQron9gtSlK4DybUFdZRhcioyeZt
         xWosWocuVhmQbnrOYzkQJsYDVvrQuLqoxk35kou+jeIDepzxhdzkYJvXhTMVz47OhF6k
         ltig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LUw/9S7XVIiz2FEwi+SyGdTLJj7pZWeSBY9aL56mEH8=;
        b=QoNWNIAP40z2EATH3v20YdM3iehFxk5XneBHSjNQaH10+lHz/eSWJOq0yZSViCkBIX
         Ng4mBQaaPszIfoeR5ROulmFkCnnCo+JayRaBtITO7RuGC82ccF3kvqPpTOJapPe1roV4
         p7hgiF0XLuM+r7oE1TfAQQwYW7lEnnmaVl27jhXmOkrslNnAgh56OHQMuj0Otj3R/7C3
         6p5X+UHzE62MjoFkzjKKi8OqGDLKnTCr9CLe58hoqEQ5Y3EVZgNL3Clh02XeYme4+Ew2
         o9ECeeU4mQrWBG9r8YcvSPzr5AnfBArxYNqzfN4A7vhLfUBBNUOSbrrRizpSDauAPDVs
         TTiA==
X-Gm-Message-State: AOAM533mNWjZGRibNzbhu09/KW3CTAivJdq2GB30ufoDfPEGn6544PuN
        WornThGkIhH10+jfPneOMdaTKkcjoZF1hg==
X-Google-Smtp-Source: ABdhPJxeMqJA7i6tHiYjQ/04WJ+xnT5y0QUL78F8ZUF+MBDw4dtZkLYnp9KvYCSFvcMIrQ5hZ542XA==
X-Received: by 2002:a65:4b8f:: with SMTP id t15mr4078049pgq.222.1615404423139;
        Wed, 10 Mar 2021 11:27:03 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 12sm306393pgw.18.2021.03.10.11.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 11:27:02 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/6] ionic: optimize fastpath struct usage
Date:   Wed, 10 Mar 2021 11:26:28 -0800
Message-Id: <20210310192631.20022-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210310192631.20022-1-snelson@pensando.io>
References: <20210310192631.20022-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up a couple of struct uses to make for better fast path
access.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  4 +--
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  7 ++--
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  3 +-
 .../net/ethernet/pensando/ionic/ionic_lif.h   | 22 ++++++-------
 .../net/ethernet/pensando/ionic/ionic_main.c  |  4 +--
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 33 +++++++++----------
 6 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index fb2b5bf179d7..b951bf5bbdc4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -585,9 +585,9 @@ void ionic_q_sg_map(struct ionic_queue *q, void *base, dma_addr_t base_pa)
 void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
 		  void *cb_arg)
 {
-	struct device *dev = q->lif->ionic->dev;
 	struct ionic_desc_info *desc_info;
 	struct ionic_lif *lif = q->lif;
+	struct device *dev = q->dev;
 
 	desc_info = &q->info[q->head_idx];
 	desc_info->cb = cb;
@@ -629,7 +629,7 @@ void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
 
 	/* stop index must be for a descriptor that is not yet completed */
 	if (unlikely(!ionic_q_is_posted(q, stop_index)))
-		dev_err(q->lif->ionic->dev,
+		dev_err(q->dev,
 			"ionic stop is not posted %s stop %u tail %u head %u\n",
 			q->name, stop_index, q->tail_idx, q->head_idx);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 0f877c86eba6..339824cfd618 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -205,10 +205,12 @@ struct ionic_queue {
 	struct device *dev;
 	struct ionic_lif *lif;
 	struct ionic_desc_info *info;
+	u64 dbval;
 	u16 head_idx;
 	u16 tail_idx;
 	unsigned int index;
 	unsigned int num_descs;
+	unsigned int max_sg_elems;
 	u64 dbell_count;
 	u64 stop;
 	u64 wake;
@@ -217,7 +219,6 @@ struct ionic_queue {
 	unsigned int type;
 	unsigned int hw_index;
 	unsigned int hw_type;
-	u64 dbval;
 	union {
 		void *base;
 		struct ionic_txq_desc *txq;
@@ -235,7 +236,7 @@ struct ionic_queue {
 	unsigned int sg_desc_size;
 	unsigned int pid;
 	char name[IONIC_QUEUE_NAME_MAX_SZ];
-};
+} ____cacheline_aligned_in_smp;
 
 #define IONIC_INTR_INDEX_NOT_ASSIGNED	-1
 #define IONIC_INTR_NAME_MAX_SZ		32
@@ -262,7 +263,7 @@ struct ionic_cq {
 	u64 compl_count;
 	void *base;
 	dma_addr_t base_pa;
-};
+} ____cacheline_aligned_in_smp;
 
 struct ionic;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 11140915c2da..6f8a5daaadfa 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -495,6 +495,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		goto err_out;
 	}
 
+	new->q.dev = dev;
 	new->flags = flags;
 
 	new->q.info = devm_kcalloc(dev, num_descs, sizeof(*new->q.info),
@@ -506,6 +507,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	}
 
 	new->q.type = type;
+	new->q.max_sg_elems = lif->qtype_info[type].max_sg_elems;
 
 	err = ionic_q_init(lif, idev, &new->q, index, name, num_descs,
 			   desc_size, sg_desc_size, pid);
@@ -2450,7 +2452,6 @@ int ionic_lif_alloc(struct ionic *ionic)
 	lif->index = 0;
 	lif->ntxq_descs = IONIC_DEF_TXRX_DESC;
 	lif->nrxq_descs = IONIC_DEF_TXRX_DESC;
-	lif->tx_budget = IONIC_TX_BUDGET_DEFAULT;
 
 	/* Convert the default coalesce value to actual hw resolution */
 	lif->rx_coalesce_usecs = IONIC_ITR_COAL_USEC_DEFAULT;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 563dba384a53..8ffda32a0a7d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -159,16 +159,11 @@ struct ionic_qtype_info {
 
 #define IONIC_LIF_NAME_MAX_SZ		32
 struct ionic_lif {
-	char name[IONIC_LIF_NAME_MAX_SZ];
-	struct list_head list;
 	struct net_device *netdev;
 	DECLARE_BITMAP(state, IONIC_LIF_F_STATE_SIZE);
 	struct ionic *ionic;
-	bool registered;
 	unsigned int index;
 	unsigned int hw_index;
-	unsigned int kern_pid;
-	u64 __iomem *kern_dbpage;
 	struct mutex queue_lock;	/* lock for queue structures */
 	spinlock_t adminq_lock;		/* lock for AdminQ operations */
 	struct ionic_qcq *adminqcq;
@@ -177,20 +172,25 @@ struct ionic_lif {
 	struct ionic_tx_stats *txqstats;
 	struct ionic_qcq **rxqcqs;
 	struct ionic_rx_stats *rxqstats;
+	struct ionic_deferred deferred;
+	struct work_struct tx_timeout_work;
 	u64 last_eid;
+	unsigned int kern_pid;
+	u64 __iomem *kern_dbpage;
 	unsigned int neqs;
 	unsigned int nxqs;
 	unsigned int ntxq_descs;
 	unsigned int nrxq_descs;
 	u32 rx_copybreak;
-	u32 tx_budget;
 	unsigned int rx_mode;
 	u64 hw_features;
+	bool registered;
 	bool mc_overflow;
-	unsigned int nmcast;
 	bool uc_overflow;
 	u16 lif_type;
+	unsigned int nmcast;
 	unsigned int nucast;
+	char name[IONIC_LIF_NAME_MAX_SZ];
 
 	union ionic_lif_identity *identity;
 	struct ionic_lif_info *info;
@@ -205,16 +205,14 @@ struct ionic_lif {
 	u32 rss_ind_tbl_sz;
 
 	struct ionic_rx_filters rx_filters;
-	struct ionic_deferred deferred;
-	unsigned long *dbid_inuse;
-	unsigned int dbid_count;
-	struct dentry *dentry;
 	u32 rx_coalesce_usecs;		/* what the user asked for */
 	u32 rx_coalesce_hw;		/* what the hw is using */
 	u32 tx_coalesce_usecs;		/* what the user asked for */
 	u32 tx_coalesce_hw;		/* what the hw is using */
+	unsigned long *dbid_inuse;
+	unsigned int dbid_count;
 
-	struct work_struct tx_timeout_work;
+	struct dentry *dentry;
 };
 
 struct ionic_queue_params {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index fbc57de6683e..14ece909a451 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -234,17 +234,15 @@ static void ionic_adminq_cb(struct ionic_queue *q,
 {
 	struct ionic_admin_ctx *ctx = cb_arg;
 	struct ionic_admin_comp *comp;
-	struct device *dev;
 
 	if (!ctx)
 		return;
 
 	comp = cq_info->cq_desc;
-	dev = &q->lif->netdev->dev;
 
 	memcpy(&ctx->comp, comp, sizeof(*comp));
 
-	dev_dbg(dev, "comp admin queue command:\n");
+	dev_dbg(q->dev, "comp admin queue command:\n");
 	dynamic_hex_dump("comp ", DUMP_PREFIX_OFFSET, 16, 1,
 			 &ctx->comp, sizeof(ctx->comp), true);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 3e13cfee9ecd..c472c14b3a80 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -82,7 +82,7 @@ static int ionic_rx_page_alloc(struct ionic_queue *q,
 	struct device *dev;
 
 	netdev = lif->netdev;
-	dev = lif->ionic->dev;
+	dev = q->dev;
 	stats = q_to_rx_stats(q);
 
 	if (unlikely(!buf_info)) {
@@ -118,7 +118,7 @@ static void ionic_rx_page_free(struct ionic_queue *q,
 			       struct ionic_buf_info *buf_info)
 {
 	struct net_device *netdev = q->lif->netdev;
-	struct device *dev = q->lif->ionic->dev;
+	struct device *dev = q->dev;
 
 	if (unlikely(!buf_info)) {
 		net_err_ratelimited("%s: %s invalid buf_info in free\n",
@@ -162,8 +162,8 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 				      struct ionic_cq_info *cq_info)
 {
 	struct ionic_rxq_comp *comp = cq_info->cq_desc;
-	struct device *dev = q->lif->ionic->dev;
 	struct ionic_buf_info *buf_info;
+	struct device *dev = q->dev;
 	struct sk_buff *skb;
 	unsigned int i;
 	u16 frag_len;
@@ -218,8 +218,8 @@ static struct sk_buff *ionic_rx_copybreak(struct ionic_queue *q,
 					  struct ionic_cq_info *cq_info)
 {
 	struct ionic_rxq_comp *comp = cq_info->cq_desc;
-	struct device *dev = q->lif->ionic->dev;
 	struct ionic_buf_info *buf_info;
+	struct device *dev = q->dev;
 	struct sk_buff *skb;
 	u16 len;
 
@@ -362,7 +362,6 @@ void ionic_rx_fill(struct ionic_queue *q)
 	struct ionic_rxq_sg_elem *sg_elem;
 	struct ionic_buf_info *buf_info;
 	struct ionic_rxq_desc *desc;
-	unsigned int max_sg_elems;
 	unsigned int remain_len;
 	unsigned int frag_len;
 	unsigned int nfrags;
@@ -370,7 +369,6 @@ void ionic_rx_fill(struct ionic_queue *q)
 	unsigned int len;
 
 	len = netdev->mtu + ETH_HLEN + VLAN_HLEN;
-	max_sg_elems = q->lif->qtype_info[IONIC_QTYPE_RXQ].max_sg_elems;
 
 	for (i = ionic_q_space_avail(q); i; i--) {
 		nfrags = 0;
@@ -397,7 +395,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 
 		/* fill sg descriptors - buf[1..n] */
 		sg_desc = desc_info->sg_desc;
-		for (j = 0; remain_len > 0 && j < max_sg_elems; j++) {
+		for (j = 0; remain_len > 0 && j < q->max_sg_elems; j++) {
 			sg_elem = &sg_desc->elems[j];
 			if (!buf_info->page) { /* alloc a new sg buffer? */
 				if (unlikely(ionic_rx_page_alloc(q, buf_info))) {
@@ -416,7 +414,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 		}
 
 		/* clear end sg element as a sentinel */
-		if (j < max_sg_elems) {
+		if (j < q->max_sg_elems) {
 			sg_elem = &sg_desc->elems[j];
 			memset(sg_elem, 0, sizeof(*sg_elem));
 		}
@@ -568,7 +566,7 @@ int ionic_txrx_napi(struct napi_struct *napi, int budget)
 	idev = &lif->ionic->idev;
 	txcq = &lif->txqcqs[qi]->cq;
 
-	tx_work_done = ionic_cq_service(txcq, lif->tx_budget,
+	tx_work_done = ionic_cq_service(txcq, IONIC_TX_BUDGET_DEFAULT,
 					ionic_tx_service, NULL, NULL);
 
 	rx_work_done = ionic_cq_service(rxcq, budget,
@@ -601,7 +599,7 @@ static dma_addr_t ionic_tx_map_single(struct ionic_queue *q,
 				      void *data, size_t len)
 {
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct device *dev = q->lif->ionic->dev;
+	struct device *dev = q->dev;
 	dma_addr_t dma_addr;
 
 	dma_addr = dma_map_single(dev, data, len, DMA_TO_DEVICE);
@@ -619,7 +617,7 @@ static dma_addr_t ionic_tx_map_frag(struct ionic_queue *q,
 				    size_t offset, size_t len)
 {
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct device *dev = q->lif->ionic->dev;
+	struct device *dev = q->dev;
 	dma_addr_t dma_addr;
 
 	dma_addr = skb_frag_dma_map(dev, frag, offset, len, DMA_TO_DEVICE);
@@ -640,7 +638,7 @@ static void ionic_tx_clean(struct ionic_queue *q,
 	struct ionic_txq_sg_elem *elem = sg_desc->elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
 	struct ionic_txq_desc *desc = desc_info->desc;
-	struct device *dev = q->lif->ionic->dev;
+	struct device *dev = q->dev;
 	u8 opcode, flags, nsge;
 	u16 queue_index;
 	unsigned int i;
@@ -822,8 +820,8 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 {
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
 	struct ionic_desc_info *rewind_desc_info;
-	struct device *dev = q->lif->ionic->dev;
 	struct ionic_txq_sg_elem *elem;
+	struct device *dev = q->dev;
 	struct ionic_txq_desc *desc;
 	unsigned int frag_left = 0;
 	unsigned int offset = 0;
@@ -994,7 +992,7 @@ static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
 {
 	struct ionic_txq_desc *desc = q->info[q->head_idx].txq_desc;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct device *dev = q->lif->ionic->dev;
+	struct device *dev = q->dev;
 	dma_addr_t dma_addr;
 	bool has_vlan;
 	u8 flags = 0;
@@ -1034,7 +1032,7 @@ static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb)
 {
 	struct ionic_txq_desc *desc = q->info[q->head_idx].txq_desc;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct device *dev = q->lif->ionic->dev;
+	struct device *dev = q->dev;
 	dma_addr_t dma_addr;
 	bool has_vlan;
 	u8 flags = 0;
@@ -1071,7 +1069,7 @@ static int ionic_tx_skb_frags(struct ionic_queue *q, struct sk_buff *skb)
 	unsigned int len_left = skb->len - skb_headlen(skb);
 	struct ionic_txq_sg_elem *elem = sg_desc->elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct device *dev = q->lif->ionic->dev;
+	struct device *dev = q->dev;
 	dma_addr_t dma_addr;
 	skb_frag_t *frag;
 	u16 len;
@@ -1120,7 +1118,6 @@ static int ionic_tx(struct ionic_queue *q, struct sk_buff *skb)
 
 static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
 {
-	int sg_elems = q->lif->qtype_info[IONIC_QTYPE_TXQ].max_sg_elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
 	int err;
 
@@ -1129,7 +1126,7 @@ static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
 		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
 
 	/* If non-TSO, just need 1 desc and nr_frags sg elems */
-	if (skb_shinfo(skb)->nr_frags <= sg_elems)
+	if (skb_shinfo(skb)->nr_frags <= q->max_sg_elems)
 		return 1;
 
 	/* Too many frags, so linearize */
-- 
2.17.1

