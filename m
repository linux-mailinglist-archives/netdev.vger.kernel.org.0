Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395CF253525
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgHZQnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgHZQmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:31 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8CBC061786
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh1so1150399plb.12
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UBkhLW7LLWjhplLSLvn0LAzLdJdw+e5t6cqPLAbVNG0=;
        b=leIjg/hHbM854/I1ngFPMsU1KXe4RfwganY/n91dEkfk+SoPkXxhuGEdstH+NiorQq
         5GOb6dnBq6eRUHRP+jWkhIl3O7FC3rCDUVUuWM+14sLHlU+eFDTZyh2DcAfagTao73Oh
         1iLbswHB6nfvomcYkEkOcRCATQrBQhX/OEL9ZM375d4GnkJvMEW1cQdAALI2r3AgsXk7
         IZ8dJM1hd4MXrhEAU23f4hsswQF3PSnUGQb3w20JACuoH32E509Fw9hL83i3JcNGG9Ah
         vKrG4LISuuzu7phl/JjB8ASkgDNtZ7jwOieO0JfPx83OpspcBibFGJqc7CuY/1QQtIuD
         hWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UBkhLW7LLWjhplLSLvn0LAzLdJdw+e5t6cqPLAbVNG0=;
        b=BPoArdh4KW0L5fCNHVgcklcdaUcG+4HDV6OnOER3FqH8Z9Z/kllGlRbtXcBBALP8FX
         DlRa8roNfFH+KLZh91xZ84h4iORhXGbNOvMKSY1/xeQM3wJRWEozjdAQCtiOF1WHRp6u
         WtY7G/Phlzn2S0GT72f9uNYNwWDjDOMl4hwojubYYM2u7QMk0Q30d4ZLkdNTYRVMWemU
         meqUSXMiaRlOz2DuCwD1DEO57xjkp5ZxR9w0jk5JAiIfApwBl8Jy0xxkUniKG6fsSi+A
         Oj6btwfr54g0C/8W4yxN1b7K/TTmx44gYxjmMxfen2fwhgUJiC36ep1eAOAkI/XuOqvn
         7oJA==
X-Gm-Message-State: AOAM5304ZHAiVEr0qsKzRuY71eRQsCwcZCji1TJcnV1D+TbdkKzglZ6U
        vcfx+QHu/jH9309lABuZ1uld9Rd4dlJLYQ==
X-Google-Smtp-Source: ABdhPJw2L+40WwQbHCw5DPI4LX3J8F2dUD9849wbW9tZqkM+kdbKYAiH5XqGwK7eRvBi9qgjCzOATw==
X-Received: by 2002:a17:90b:1093:: with SMTP id gj19mr6949472pjb.149.1598460149857;
        Wed, 26 Aug 2020 09:42:29 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:29 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 07/12] ionic: reduce contiguous memory allocation requirement
Date:   Wed, 26 Aug 2020 09:42:09 -0700
Message-Id: <20200826164214.31792-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826164214.31792-1-snelson@pensando.io>
References: <20200826164214.31792-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split out the queue descriptor blocks into separate dma
allocations to make for smaller blocks.

Authored-by: Neel Patel <neel@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  23 ++--
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 100 +++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  12 ++-
 3 files changed, 81 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index 11621ccc1faf..e12dbe4ea73d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -112,7 +112,8 @@ static const struct debugfs_reg32 intr_ctrl_regs[] = {
 
 void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
-	struct dentry *q_dentry, *cq_dentry, *intr_dentry, *stats_dentry;
+	struct dentry *qcq_dentry, *q_dentry, *cq_dentry;
+	struct dentry *intr_dentry, *stats_dentry;
 	struct ionic_dev *idev = &lif->ionic->idev;
 	struct debugfs_regset32 *intr_ctrl_regset;
 	struct ionic_intr_info *intr = &qcq->intr;
@@ -121,21 +122,21 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	struct ionic_queue *q = &qcq->q;
 	struct ionic_cq *cq = &qcq->cq;
 
-	qcq->dentry = debugfs_create_dir(q->name, lif->dentry);
+	qcq_dentry = debugfs_create_dir(q->name, lif->dentry);
+	if (IS_ERR_OR_NULL(qcq_dentry))
+		return;
+	qcq->dentry = qcq_dentry;
 
-	debugfs_create_x32("total_size", 0400, qcq->dentry, &qcq->total_size);
-	debugfs_create_x64("base_pa", 0400, qcq->dentry, &qcq->base_pa);
+	debugfs_create_x64("q_base_pa", 0400, qcq_dentry, &qcq->q_base_pa);
+	debugfs_create_x32("q_size", 0400, qcq_dentry, &qcq->q_size);
+	debugfs_create_x64("cq_base_pa", 0400, qcq_dentry, &qcq->cq_base_pa);
+	debugfs_create_x32("cq_size", 0400, qcq_dentry, &qcq->cq_size);
+	debugfs_create_x64("sg_base_pa", 0400, qcq_dentry, &qcq->sg_base_pa);
+	debugfs_create_x32("sg_size", 0400, qcq_dentry, &qcq->sg_size);
 
 	q_dentry = debugfs_create_dir("q", qcq->dentry);
 
 	debugfs_create_u32("index", 0400, q_dentry, &q->index);
-	debugfs_create_x64("base_pa", 0400, q_dentry, &q->base_pa);
-	if (qcq->flags & IONIC_QCQ_F_SG) {
-		debugfs_create_x64("sg_base_pa", 0400, q_dentry,
-				   &q->sg_base_pa);
-		debugfs_create_u32("sg_desc_size", 0400, q_dentry,
-				   &q->sg_desc_size);
-	}
 	debugfs_create_u32("num_descs", 0400, q_dentry, &q->num_descs);
 	debugfs_create_u32("desc_size", 0400, q_dentry, &q->desc_size);
 	debugfs_create_u32("pid", 0400, q_dentry, &q->pid);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 6a50bb6f090c..016d55ad1f6a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -306,9 +306,23 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 
 	ionic_debugfs_del_qcq(qcq);
 
-	dma_free_coherent(dev, qcq->total_size, qcq->base, qcq->base_pa);
-	qcq->base = NULL;
-	qcq->base_pa = 0;
+	if (qcq->q_base) {
+		dma_free_coherent(dev, qcq->q_size, qcq->q_base, qcq->q_base_pa);
+		qcq->q_base = NULL;
+		qcq->q_base_pa = 0;
+	}
+
+	if (qcq->cq_base) {
+		dma_free_coherent(dev, qcq->cq_size, qcq->cq_base, qcq->cq_base_pa);
+		qcq->cq_base = NULL;
+		qcq->cq_base_pa = 0;
+	}
+
+	if (qcq->sg_base) {
+		dma_free_coherent(dev, qcq->sg_size, qcq->sg_base, qcq->sg_base_pa);
+		qcq->sg_base = NULL;
+		qcq->sg_base_pa = 0;
+	}
 
 	if (qcq->flags & IONIC_QCQ_F_INTR) {
 		irq_set_affinity_hint(qcq->intr.vector, NULL);
@@ -374,7 +388,6 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 			   unsigned int pid, struct ionic_qcq **qcq)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
-	u32 q_size, cq_size, sg_size, total_size;
 	struct device *dev = lif->ionic->dev;
 	void *q_base, *cq_base, *sg_base;
 	dma_addr_t cq_base_pa = 0;
@@ -385,21 +398,6 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 
 	*qcq = NULL;
 
-	q_size  = num_descs * desc_size;
-	cq_size = num_descs * cq_desc_size;
-	sg_size = num_descs * sg_desc_size;
-
-	total_size = ALIGN(q_size, PAGE_SIZE) + ALIGN(cq_size, PAGE_SIZE);
-	/* Note: aligning q_size/cq_size is not enough due to cq_base
-	 * address aligning as q_base could be not aligned to the page.
-	 * Adding PAGE_SIZE.
-	 */
-	total_size += PAGE_SIZE;
-	if (flags & IONIC_QCQ_F_SG) {
-		total_size += ALIGN(sg_size, PAGE_SIZE);
-		total_size += PAGE_SIZE;
-	}
-
 	new = devm_kzalloc(dev, sizeof(*new), GFP_KERNEL);
 	if (!new) {
 		netdev_err(lif->netdev, "Cannot allocate queue structure\n");
@@ -414,7 +412,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	if (!new->q.info) {
 		netdev_err(lif->netdev, "Cannot allocate queue info\n");
 		err = -ENOMEM;
-		goto err_out;
+		goto err_out_free_qcq;
 	}
 
 	new->q.type = type;
@@ -423,7 +421,7 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 			   desc_size, sg_desc_size, pid);
 	if (err) {
 		netdev_err(lif->netdev, "Cannot initialize queue\n");
-		goto err_out;
+		goto err_out_free_q_info;
 	}
 
 	if (flags & IONIC_QCQ_F_INTR) {
@@ -471,46 +469,68 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 	err = ionic_cq_init(lif, &new->cq, &new->intr, num_descs, cq_desc_size);
 	if (err) {
 		netdev_err(lif->netdev, "Cannot initialize completion queue\n");
-		goto err_out_free_irq;
+		goto err_out_free_cq_info;
 	}
 
-	new->base = dma_alloc_coherent(dev, total_size, &new->base_pa,
-				       GFP_KERNEL);
-	if (!new->base) {
+	new->q_size = PAGE_SIZE + (num_descs * desc_size);
+	new->q_base = dma_alloc_coherent(dev, new->q_size, &new->q_base_pa,
+					 GFP_KERNEL);
+	if (!new->q_base) {
 		netdev_err(lif->netdev, "Cannot allocate queue DMA memory\n");
 		err = -ENOMEM;
-		goto err_out_free_irq;
+		goto err_out_free_cq_info;
 	}
+	q_base = (void *)ALIGN((uintptr_t)new->q_base, PAGE_SIZE);
+	q_base_pa = ALIGN(new->q_base_pa, PAGE_SIZE);
+	ionic_q_map(&new->q, q_base, q_base_pa);
 
-	new->total_size = total_size;
-
-	q_base = new->base;
-	q_base_pa = new->base_pa;
-
-	cq_base = (void *)ALIGN((uintptr_t)q_base + q_size, PAGE_SIZE);
-	cq_base_pa = ALIGN(q_base_pa + q_size, PAGE_SIZE);
+	new->cq_size = PAGE_SIZE + (num_descs * cq_desc_size);
+	new->cq_base = dma_alloc_coherent(dev, new->cq_size, &new->cq_base_pa,
+					  GFP_KERNEL);
+	if (!new->cq_base) {
+		netdev_err(lif->netdev, "Cannot allocate cq DMA memory\n");
+		err = -ENOMEM;
+		goto err_out_free_q;
+	}
+	cq_base = (void *)ALIGN((uintptr_t)new->cq_base, PAGE_SIZE);
+	cq_base_pa = ALIGN(new->cq_base_pa, PAGE_SIZE);
+	ionic_cq_map(&new->cq, cq_base, cq_base_pa);
+	ionic_cq_bind(&new->cq, &new->q);
 
 	if (flags & IONIC_QCQ_F_SG) {
-		sg_base = (void *)ALIGN((uintptr_t)cq_base + cq_size,
-					PAGE_SIZE);
-		sg_base_pa = ALIGN(cq_base_pa + cq_size, PAGE_SIZE);
+		new->sg_size = PAGE_SIZE + (num_descs * sg_desc_size);
+		new->sg_base = dma_alloc_coherent(dev, new->sg_size, &new->sg_base_pa,
+						  GFP_KERNEL);
+		if (!new->sg_base) {
+			netdev_err(lif->netdev, "Cannot allocate sg DMA memory\n");
+			err = -ENOMEM;
+			goto err_out_free_cq;
+		}
+		sg_base = (void *)ALIGN((uintptr_t)new->sg_base, PAGE_SIZE);
+		sg_base_pa = ALIGN(new->sg_base_pa, PAGE_SIZE);
 		ionic_q_sg_map(&new->q, sg_base, sg_base_pa);
 	}
 
-	ionic_q_map(&new->q, q_base, q_base_pa);
-	ionic_cq_map(&new->cq, cq_base, cq_base_pa);
-	ionic_cq_bind(&new->cq, &new->q);
-
 	*qcq = new;
 
 	return 0;
 
+err_out_free_cq:
+	dma_free_coherent(dev, new->cq_size, new->cq_base, new->cq_base_pa);
+err_out_free_q:
+	dma_free_coherent(dev, new->q_size, new->q_base, new->q_base_pa);
+err_out_free_cq_info:
+	devm_kfree(dev, new->cq.info);
 err_out_free_irq:
 	if (flags & IONIC_QCQ_F_INTR)
 		devm_free_irq(dev, new->intr.vector, &new->napi);
 err_out_free_intr:
 	if (flags & IONIC_QCQ_F_INTR)
 		ionic_intr_free(lif->ionic, new->intr.index);
+err_out_free_q_info:
+	devm_kfree(dev, new->q.info);
+err_out_free_qcq:
+	devm_kfree(dev, new);
 err_out:
 	dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
 	return err;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 517b51190d18..aa7c1a8cbefc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -57,9 +57,15 @@ struct ionic_napi_stats {
 };
 
 struct ionic_qcq {
-	void *base;
-	dma_addr_t base_pa;
-	unsigned int total_size;
+	void *q_base;
+	dma_addr_t q_base_pa;
+	u32 q_size;
+	void *cq_base;
+	dma_addr_t cq_base_pa;
+	u32 cq_size;
+	void *sg_base;
+	dma_addr_t sg_base_pa;
+	u32 sg_size;
 	struct ionic_queue q;
 	struct ionic_cq cq;
 	struct ionic_intr_info intr;
-- 
2.17.1

