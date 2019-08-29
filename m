Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B7BA2513
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbfH2S2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:28:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37095 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbfH2S16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:27:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id y9so2632966pfl.4
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=/O44iu6OYROP/fj9IfShN8pByPXz2DCthsdfALRNLxo=;
        b=kmiiCTTgovEtDVYoK3vnaiU2QuVxWANX8RpnqXjiddEhUmqCkVFRij/a9eswQ6a8GA
         yD4jze2epQzkkjouG0JSPGPK3KQXaomujY0w/Yqcw7dQquv8hck0pXry2cHe9vp9lwEz
         xggnu4PldC8E8JJR1rHxrT+GwiB7rfFCffRwc2LgcCkf4JPmEKYEVj1wZ4D4ZjpmCb0f
         njJ4RdriMQExAQm/TAfa5WmMxOkhEk4kRk/Ll/QrM+fT0rYMEB9deNPGuTeHRh6VOz1o
         RN3fdNPBTHabZ7uN8WFY3k1FkqcfPAhNYpHLDdLlWcP1JvRD+U5QlR1f/683SsTWkYm2
         NkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=/O44iu6OYROP/fj9IfShN8pByPXz2DCthsdfALRNLxo=;
        b=HbNAHmz132yikmTTqCYbJk8h1LILsIGitnu6/RJ4sYE/bQNkmiX2S+o4a4nBUQfc6n
         gJNkD3s92djso/+FRffCOb/6CNS/W5JxBRd5A8z6pkVFXxnX7iqnfSIzLSCAzNoZNhJY
         jd/kI05hsp2uw3lVZyuB54p852nPFwRdzPVeVD5e1QRL16brzGOpiL1VYnS45Qm/jEwU
         wHbQgBR2AnwHPUWK8fS98/w1TWYvzjKSPShvSJzs8Ov4V8tVpfObU+dMbSPycyNbLkcC
         wQoqBAf76iKsF7jW5ZJNQx0mlsI5OhbyqNU4yltsjTcorZ0I0KBOXVf6/e9M6q6zzg6X
         vA1Q==
X-Gm-Message-State: APjAAAUyPOXgY+u93KhZZigSFzYvCcoUehq906YbP9EbeuRAPFVYdt64
        1P2KkVEQ0eDMsm6QaADvif61Gu+wZww=
X-Google-Smtp-Source: APXvYqwHrhLxCUUFNHolLpdZS9IpoSDE0pO15GzqFU5G4cu5j+fScrOxAPENFIbQCqnBPA2UqGCdHw==
X-Received: by 2002:a17:90a:a4c5:: with SMTP id l5mr11345958pjw.49.1567103277003;
        Thu, 29 Aug 2019 11:27:57 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.27.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:27:56 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v6 net-next 07/19] ionic: Add basic adminq support
Date:   Thu, 29 Aug 2019 11:27:08 -0700
Message-Id: <20190829182720.68419-8-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829182720.68419-1-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the NIC configuration happens through the AdminQ message
queue.  NAPI is used for basic interrupt handling and message
queue management.  These routines are set up to be shared among
different types of queues when used in slow-path handling.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_bus.h   |   1 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |   5 +
 .../ethernet/pensando/ionic/ionic_debugfs.c   | 138 +++++++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   4 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 232 ++++++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 109 ++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 357 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  67 ++++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  26 ++
 10 files changed, 942 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index affd7a88b58b..23d39be54064 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -44,6 +44,9 @@ struct ionic {
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
 };
 
+int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
+	       ionic_cq_done_cb done_cb, void *done_arg);
+
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_wait);
 int ionic_set_dma_mask(struct ionic *ionic);
 int ionic_setup(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus.h b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
index 6b29e94f81d6..2f4d08c64910 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus.h
@@ -4,6 +4,7 @@
 #ifndef _IONIC_BUS_H_
 #define _IONIC_BUS_H_
 
+int ionic_bus_get_irq(struct ionic *ionic, unsigned int num);
 const char *ionic_bus_info(struct ionic *ionic);
 int ionic_bus_alloc_irq_vectors(struct ionic *ionic, unsigned int nintrs);
 void ionic_bus_free_irq_vectors(struct ionic *ionic);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 4f08d915c3d2..7b6190b96a46 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -19,6 +19,11 @@ static const struct pci_device_id ionic_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, ionic_id_table);
 
+int ionic_bus_get_irq(struct ionic *ionic, unsigned int num)
+{
+	return pci_irq_vector(ionic->pdev, num);
+}
+
 const char *ionic_bus_info(struct ionic *ionic)
 {
 	return pci_name(ionic->pdev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index 840b3da5da3e..d02f81a2b466 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -72,6 +72,137 @@ void ionic_debugfs_add_sizes(struct ionic *ionic)
 			   (u32 *)&ionic->ident.lif.eth.config.queue_count[IONIC_QTYPE_RXQ]);
 }
 
+static int q_tail_show(struct seq_file *seq, void *v)
+{
+	struct ionic_queue *q = seq->private;
+
+	seq_printf(seq, "%d\n", q->tail->index);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(q_tail);
+
+static int q_head_show(struct seq_file *seq, void *v)
+{
+	struct ionic_queue *q = seq->private;
+
+	seq_printf(seq, "%d\n", q->head->index);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(q_head);
+
+static int cq_tail_show(struct seq_file *seq, void *v)
+{
+	struct ionic_cq *cq = seq->private;
+
+	seq_printf(seq, "%d\n", cq->tail->index);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(cq_tail);
+
+static const struct debugfs_reg32 intr_ctrl_regs[] = {
+	{ .name = "coal_init", .offset = 0, },
+	{ .name = "mask", .offset = 4, },
+	{ .name = "credits", .offset = 8, },
+	{ .name = "mask_on_assert", .offset = 12, },
+	{ .name = "coal_timer", .offset = 16, },
+};
+
+void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
+{
+	struct dentry *q_dentry, *cq_dentry, *intr_dentry;
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct debugfs_regset32 *intr_ctrl_regset;
+	struct ionic_intr_info *intr = &qcq->intr;
+	struct debugfs_blob_wrapper *desc_blob;
+	struct device *dev = lif->ionic->dev;
+	struct ionic_queue *q = &qcq->q;
+	struct ionic_cq *cq = &qcq->cq;
+
+	qcq->dentry = debugfs_create_dir(q->name, lif->dentry);
+
+	debugfs_create_x32("total_size", 0400, qcq->dentry, &qcq->total_size);
+	debugfs_create_x64("base_pa", 0400, qcq->dentry, &qcq->base_pa);
+
+	q_dentry = debugfs_create_dir("q", qcq->dentry);
+
+	debugfs_create_u32("index", 0400, q_dentry, &q->index);
+	debugfs_create_x64("base_pa", 0400, q_dentry, &q->base_pa);
+	if (qcq->flags & IONIC_QCQ_F_SG) {
+		debugfs_create_x64("sg_base_pa", 0400, q_dentry,
+				   &q->sg_base_pa);
+		debugfs_create_u32("sg_desc_size", 0400, q_dentry,
+				   &q->sg_desc_size);
+	}
+	debugfs_create_u32("num_descs", 0400, q_dentry, &q->num_descs);
+	debugfs_create_u32("desc_size", 0400, q_dentry, &q->desc_size);
+	debugfs_create_u32("pid", 0400, q_dentry, &q->pid);
+	debugfs_create_u32("qid", 0400, q_dentry, &q->hw_index);
+	debugfs_create_u32("qtype", 0400, q_dentry, &q->hw_type);
+	debugfs_create_u64("drop", 0400, q_dentry, &q->drop);
+	debugfs_create_u64("stop", 0400, q_dentry, &q->stop);
+	debugfs_create_u64("wake", 0400, q_dentry, &q->wake);
+
+	debugfs_create_file("tail", 0400, q_dentry, q, &q_tail_fops);
+	debugfs_create_file("head", 0400, q_dentry, q, &q_head_fops);
+
+	desc_blob = devm_kzalloc(dev, sizeof(*desc_blob), GFP_KERNEL);
+	if (!desc_blob)
+		return;
+	desc_blob->data = q->base;
+	desc_blob->size = (unsigned long)q->num_descs * q->desc_size;
+	debugfs_create_blob("desc_blob", 0400, q_dentry, desc_blob);
+
+	if (qcq->flags & IONIC_QCQ_F_SG) {
+		desc_blob = devm_kzalloc(dev, sizeof(*desc_blob), GFP_KERNEL);
+		if (!desc_blob)
+			return;
+		desc_blob->data = q->sg_base;
+		desc_blob->size = (unsigned long)q->num_descs * q->sg_desc_size;
+		debugfs_create_blob("sg_desc_blob", 0400, q_dentry,
+				    desc_blob);
+	}
+
+	cq_dentry = debugfs_create_dir("cq", qcq->dentry);
+
+	debugfs_create_x64("base_pa", 0400, cq_dentry, &cq->base_pa);
+	debugfs_create_u32("num_descs", 0400, cq_dentry, &cq->num_descs);
+	debugfs_create_u32("desc_size", 0400, cq_dentry, &cq->desc_size);
+	debugfs_create_u8("done_color", 0400, cq_dentry,
+			  (u8 *)&cq->done_color);
+
+	debugfs_create_file("tail", 0400, cq_dentry, cq, &cq_tail_fops);
+
+	desc_blob = devm_kzalloc(dev, sizeof(*desc_blob), GFP_KERNEL);
+	if (!desc_blob)
+		return;
+	desc_blob->data = cq->base;
+	desc_blob->size = (unsigned long)cq->num_descs * cq->desc_size;
+	debugfs_create_blob("desc_blob", 0400, cq_dentry, desc_blob);
+
+	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		intr_dentry = debugfs_create_dir("intr", qcq->dentry);
+
+		debugfs_create_u32("index", 0400, intr_dentry,
+				   &intr->index);
+		debugfs_create_u32("vector", 0400, intr_dentry,
+				   &intr->vector);
+
+		intr_ctrl_regset = devm_kzalloc(dev, sizeof(*intr_ctrl_regset),
+						GFP_KERNEL);
+		if (!intr_ctrl_regset)
+			return;
+		intr_ctrl_regset->regs = intr_ctrl_regs;
+		intr_ctrl_regset->nregs = ARRAY_SIZE(intr_ctrl_regs);
+		intr_ctrl_regset->base = &idev->intr_ctrl[intr->index];
+
+		debugfs_create_regset32("intr_ctrl", 0400, intr_dentry,
+					intr_ctrl_regset);
+	}
+}
+
 static int netdev_show(struct seq_file *seq, void *v)
 {
 	struct net_device *netdev = seq->private;
@@ -94,4 +225,11 @@ void ionic_debugfs_del_lif(struct ionic_lif *lif)
 	debugfs_remove_recursive(lif->dentry);
 	lif->dentry = NULL;
 }
+
+void ionic_debugfs_del_qcq(struct ionic_qcq *qcq)
+{
+	debugfs_remove_recursive(qcq->dentry);
+	qcq->dentry = NULL;
+}
+
 #endif
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
index f742acf56adf..c44ebde170b6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
@@ -15,7 +15,9 @@ void ionic_debugfs_del_dev(struct ionic *ionic);
 void ionic_debugfs_add_ident(struct ionic *ionic);
 void ionic_debugfs_add_sizes(struct ionic *ionic);
 void ionic_debugfs_add_lif(struct ionic_lif *lif);
+void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq);
 void ionic_debugfs_del_lif(struct ionic_lif *lif);
+void ionic_debugfs_del_qcq(struct ionic_qcq *qcq);
 #else
 static inline void ionic_debugfs_create(void) { }
 static inline void ionic_debugfs_destroy(void) { }
@@ -24,7 +26,9 @@ static inline void ionic_debugfs_del_dev(struct ionic *ionic) { }
 static inline void ionic_debugfs_add_ident(struct ionic *ionic) { }
 static inline void ionic_debugfs_add_sizes(struct ionic *ionic) { }
 static inline void ionic_debugfs_add_lif(struct ionic_lif *lif) { }
+static inline void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq) { }
 static inline void ionic_debugfs_del_lif(struct ionic_lif *lif) { }
+static inline void ionic_debugfs_del_qcq(struct ionic_qcq *qcq) { }
 #endif
 
 #endif /* _IONIC_DEBUGFS_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index dbdde548848e..d168a6435322 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -262,7 +262,239 @@ void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index)
 	ionic_dev_cmd_go(idev, &cmd);
 }
 
+void ionic_dev_cmd_adminq_init(struct ionic_dev *idev, struct ionic_qcq *qcq,
+			       u16 lif_index, u16 intr_index)
+{
+	struct ionic_queue *q = &qcq->q;
+	struct ionic_cq *cq = &qcq->cq;
+
+	union ionic_dev_cmd cmd = {
+		.q_init.opcode = IONIC_CMD_Q_INIT,
+		.q_init.lif_index = cpu_to_le16(lif_index),
+		.q_init.type = q->type,
+		.q_init.index = cpu_to_le32(q->index),
+		.q_init.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
+					    IONIC_QINIT_F_ENA),
+		.q_init.pid = cpu_to_le16(q->pid),
+		.q_init.intr_index = cpu_to_le16(intr_index),
+		.q_init.ring_size = ilog2(q->num_descs),
+		.q_init.ring_base = cpu_to_le64(q->base_pa),
+		.q_init.cq_ring_base = cpu_to_le64(cq->base_pa),
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
 int ionic_db_page_num(struct ionic_lif *lif, int pid)
 {
 	return (lif->hw_index * lif->dbid_count) + pid;
 }
+
+int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
+		  struct ionic_intr_info *intr,
+		  unsigned int num_descs, size_t desc_size)
+{
+	struct ionic_cq_info *cur;
+	unsigned int ring_size;
+	unsigned int i;
+
+	if (desc_size == 0 || !is_power_of_2(num_descs))
+		return -EINVAL;
+
+	ring_size = ilog2(num_descs);
+	if (ring_size < 2 || ring_size > 16)
+		return -EINVAL;
+
+	cq->lif = lif;
+	cq->bound_intr = intr;
+	cq->num_descs = num_descs;
+	cq->desc_size = desc_size;
+	cq->tail = cq->info;
+	cq->done_color = 1;
+
+	cur = cq->info;
+
+	for (i = 0; i < num_descs; i++) {
+		if (i + 1 == num_descs) {
+			cur->next = cq->info;
+			cur->last = true;
+		} else {
+			cur->next = cur + 1;
+		}
+		cur->index = i;
+		cur++;
+	}
+
+	return 0;
+}
+
+void ionic_cq_map(struct ionic_cq *cq, void *base, dma_addr_t base_pa)
+{
+	struct ionic_cq_info *cur;
+	unsigned int i;
+
+	cq->base = base;
+	cq->base_pa = base_pa;
+
+	for (i = 0, cur = cq->info; i < cq->num_descs; i++, cur++)
+		cur->cq_desc = base + (i * cq->desc_size);
+}
+
+void ionic_cq_bind(struct ionic_cq *cq, struct ionic_queue *q)
+{
+	cq->bound_q = q;
+}
+
+unsigned int ionic_cq_service(struct ionic_cq *cq, unsigned int work_to_do,
+			      ionic_cq_cb cb, ionic_cq_done_cb done_cb,
+			      void *done_arg)
+{
+	unsigned int work_done = 0;
+
+	if (work_to_do == 0)
+		return 0;
+
+	while (cb(cq, cq->tail)) {
+		if (cq->tail->last)
+			cq->done_color = !cq->done_color;
+		cq->tail = cq->tail->next;
+		DEBUG_STATS_CQE_CNT(cq);
+
+		if (++work_done >= work_to_do)
+			break;
+	}
+
+	if (work_done && done_cb)
+		done_cb(done_arg);
+
+	return work_done;
+}
+
+int ionic_q_init(struct ionic_lif *lif, struct ionic_dev *idev,
+		 struct ionic_queue *q, unsigned int index, const char *name,
+		 unsigned int num_descs, size_t desc_size,
+		 size_t sg_desc_size, unsigned int pid)
+{
+	struct ionic_desc_info *cur;
+	unsigned int ring_size;
+	unsigned int i;
+
+	if (desc_size == 0 || !is_power_of_2(num_descs))
+		return -EINVAL;
+
+	ring_size = ilog2(num_descs);
+	if (ring_size < 2 || ring_size > 16)
+		return -EINVAL;
+
+	q->lif = lif;
+	q->idev = idev;
+	q->index = index;
+	q->num_descs = num_descs;
+	q->desc_size = desc_size;
+	q->sg_desc_size = sg_desc_size;
+	q->tail = q->info;
+	q->head = q->tail;
+	q->pid = pid;
+
+	snprintf(q->name, sizeof(q->name), "L%d-%s%u", lif->index, name, index);
+
+	cur = q->info;
+
+	for (i = 0; i < num_descs; i++) {
+		if (i + 1 == num_descs)
+			cur->next = q->info;
+		else
+			cur->next = cur + 1;
+		cur->index = i;
+		cur->left = num_descs - i;
+		cur++;
+	}
+
+	return 0;
+}
+
+void ionic_q_map(struct ionic_queue *q, void *base, dma_addr_t base_pa)
+{
+	struct ionic_desc_info *cur;
+	unsigned int i;
+
+	q->base = base;
+	q->base_pa = base_pa;
+
+	for (i = 0, cur = q->info; i < q->num_descs; i++, cur++)
+		cur->desc = base + (i * q->desc_size);
+}
+
+void ionic_q_sg_map(struct ionic_queue *q, void *base, dma_addr_t base_pa)
+{
+	struct ionic_desc_info *cur;
+	unsigned int i;
+
+	q->sg_base = base;
+	q->sg_base_pa = base_pa;
+
+	for (i = 0, cur = q->info; i < q->num_descs; i++, cur++)
+		cur->sg_desc = base + (i * q->sg_desc_size);
+}
+
+void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
+		  void *cb_arg)
+{
+	struct device *dev = q->lif->ionic->dev;
+	struct ionic_lif *lif = q->lif;
+
+	q->head->cb = cb;
+	q->head->cb_arg = cb_arg;
+	q->head = q->head->next;
+
+	dev_dbg(dev, "lif=%d qname=%s qid=%d qtype=%d p_index=%d ringdb=%d\n",
+		q->lif->index, q->name, q->hw_type, q->hw_index,
+		q->head->index, ring_doorbell);
+
+	if (ring_doorbell)
+		ionic_dbell_ring(lif->kern_dbpage, q->hw_type,
+				 q->dbval | q->head->index);
+}
+
+static bool ionic_q_is_posted(struct ionic_queue *q, unsigned int pos)
+{
+	unsigned int mask, tail, head;
+
+	mask = q->num_descs - 1;
+	tail = q->tail->index;
+	head = q->head->index;
+
+	return ((pos - tail) & mask) < ((head - tail) & mask);
+}
+
+void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
+		     unsigned int stop_index)
+{
+	struct ionic_desc_info *desc_info;
+	ionic_desc_cb cb;
+	void *cb_arg;
+
+	/* check for empty queue */
+	if (q->tail->index == q->head->index)
+		return;
+
+	/* stop index must be for a descriptor that is not yet completed */
+	if (unlikely(!ionic_q_is_posted(q, stop_index)))
+		dev_err(q->lif->ionic->dev,
+			"ionic stop is not posted %s stop %u tail %u head %u\n",
+			q->name, stop_index, q->tail->index, q->head->index);
+
+	do {
+		desc_info = q->tail;
+		q->tail = desc_info->next;
+
+		cb = desc_info->cb;
+		cb_arg = desc_info->cb_arg;
+
+		desc_info->cb = NULL;
+		desc_info->cb_arg = NULL;
+
+		if (cb)
+			cb(q, desc_info, cq_info, cb_arg);
+	} while (desc_info->index != stop_index);
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 2252fa9ad0e3..86922dd26b72 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -126,6 +126,59 @@ struct ionic_dev {
 	struct ionic_devinfo dev_info;
 };
 
+struct ionic_cq_info {
+	void *cq_desc;
+	struct ionic_cq_info *next;
+	unsigned int index;
+	bool last;
+};
+
+struct ionic_queue;
+struct ionic_qcq;
+struct ionic_desc_info;
+
+typedef void (*ionic_desc_cb)(struct ionic_queue *q,
+			      struct ionic_desc_info *desc_info,
+			      struct ionic_cq_info *cq_info, void *cb_arg);
+
+struct ionic_desc_info {
+	void *desc;
+	void *sg_desc;
+	struct ionic_desc_info *next;
+	unsigned int index;
+	unsigned int left;
+	ionic_desc_cb cb;
+	void *cb_arg;
+};
+
+#define QUEUE_NAME_MAX_SZ		32
+
+struct ionic_queue {
+	u64 dbell_count;
+	u64 drop;
+	u64 stop;
+	u64 wake;
+	struct ionic_lif *lif;
+	struct ionic_desc_info *info;
+	struct ionic_desc_info *tail;
+	struct ionic_desc_info *head;
+	struct ionic_dev *idev;
+	unsigned int index;
+	unsigned int type;
+	unsigned int hw_index;
+	unsigned int hw_type;
+	u64 dbval;
+	void *base;
+	void *sg_base;
+	dma_addr_t base_pa;
+	dma_addr_t sg_base_pa;
+	unsigned int num_descs;
+	unsigned int desc_size;
+	unsigned int sg_desc_size;
+	unsigned int pid;
+	char name[QUEUE_NAME_MAX_SZ];
+};
+
 #define INTR_INDEX_NOT_ASSIGNED		-1
 #define INTR_NAME_MAX_SZ		32
 
@@ -138,6 +191,20 @@ struct ionic_intr_info {
 	cpumask_t affinity_mask;
 };
 
+struct ionic_cq {
+	void *base;
+	dma_addr_t base_pa;
+	struct ionic_lif *lif;
+	struct ionic_cq_info *info;
+	struct ionic_cq_info *tail;
+	struct ionic_queue *bound_q;
+	struct ionic_intr_info *bound_intr;
+	bool done_color;
+	unsigned int num_descs;
+	u64 compl_count;
+	unsigned int desc_size;
+};
+
 struct ionic;
 
 static inline void ionic_intr_init(struct ionic_dev *idev,
@@ -148,6 +215,23 @@ static inline void ionic_intr_init(struct ionic_dev *idev,
 	intr->index = index;
 }
 
+static inline unsigned int ionic_q_space_avail(struct ionic_queue *q)
+{
+	unsigned int avail = q->tail->index;
+
+	if (q->head->index >= avail)
+		avail += q->head->left - 1;
+	else
+		avail -= q->head->index + 1;
+
+	return avail;
+}
+
+static inline bool ionic_q_has_space(struct ionic_queue *q, unsigned int want)
+{
+	return ionic_q_space_avail(q) >= want;
+}
+
 void ionic_init_devinfo(struct ionic *ionic);
 int ionic_dev_setup(struct ionic *ionic);
 void ionic_dev_teardown(struct ionic *ionic);
@@ -174,7 +258,32 @@ void ionic_dev_cmd_lif_identify(struct ionic_dev *idev, u8 type, u8 ver);
 void ionic_dev_cmd_lif_init(struct ionic_dev *idev, u16 lif_index,
 			    dma_addr_t addr);
 void ionic_dev_cmd_lif_reset(struct ionic_dev *idev, u16 lif_index);
+void ionic_dev_cmd_adminq_init(struct ionic_dev *idev, struct ionic_qcq *qcq,
+			       u16 lif_index, u16 intr_index);
 
 int ionic_db_page_num(struct ionic_lif *lif, int pid);
 
+int ionic_cq_init(struct ionic_lif *lif, struct ionic_cq *cq,
+		  struct ionic_intr_info *intr,
+		  unsigned int num_descs, size_t desc_size);
+void ionic_cq_map(struct ionic_cq *cq, void *base, dma_addr_t base_pa);
+void ionic_cq_bind(struct ionic_cq *cq, struct ionic_queue *q);
+typedef bool (*ionic_cq_cb)(struct ionic_cq *cq, struct ionic_cq_info *cq_info);
+typedef void (*ionic_cq_done_cb)(void *done_arg);
+unsigned int ionic_cq_service(struct ionic_cq *cq, unsigned int work_to_do,
+			      ionic_cq_cb cb, ionic_cq_done_cb done_cb,
+			      void *done_arg);
+
+int ionic_q_init(struct ionic_lif *lif, struct ionic_dev *idev,
+		 struct ionic_queue *q, unsigned int index, const char *name,
+		 unsigned int num_descs, size_t desc_size,
+		 size_t sg_desc_size, unsigned int pid);
+void ionic_q_map(struct ionic_queue *q, void *base, dma_addr_t base_pa);
+void ionic_q_sg_map(struct ionic_queue *q, void *base, dma_addr_t base_pa);
+void ionic_q_post(struct ionic_queue *q, bool ring_doorbell, ionic_desc_cb cb,
+		  void *cb_arg);
+void ionic_q_rewind(struct ionic_queue *q, struct ionic_desc_info *start);
+void ionic_q_service(struct ionic_queue *q, struct ionic_cq_info *cq_info,
+		     unsigned int stop_index);
+
 #endif /* _IONIC_DEV_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e9dc97b968b5..9628722dea87 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -12,6 +12,285 @@
 #include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
+static irqreturn_t ionic_isr(int irq, void *data)
+{
+	struct napi_struct *napi = data;
+
+	napi_schedule_irqoff(napi);
+
+	return IRQ_HANDLED;
+}
+
+static int ionic_request_irq(struct ionic_lif *lif, struct ionic_qcq *qcq)
+{
+	struct ionic_intr_info *intr = &qcq->intr;
+	struct device *dev = lif->ionic->dev;
+	struct ionic_queue *q = &qcq->q;
+	const char *name;
+
+	if (lif->registered)
+		name = lif->netdev->name;
+	else
+		name = dev_name(dev);
+
+	snprintf(intr->name, sizeof(intr->name),
+		 "%s-%s-%s", IONIC_DRV_NAME, name, q->name);
+
+	return devm_request_irq(dev, intr->vector, ionic_isr,
+				0, intr->name, &qcq->napi);
+}
+
+static int ionic_intr_alloc(struct ionic_lif *lif, struct ionic_intr_info *intr)
+{
+	struct ionic *ionic = lif->ionic;
+	int index;
+
+	index = find_first_zero_bit(ionic->intrs, ionic->nintrs);
+	if (index == ionic->nintrs) {
+		netdev_warn(lif->netdev, "%s: no intr, index=%d nintrs=%d\n",
+			    __func__, index, ionic->nintrs);
+		return -ENOSPC;
+	}
+
+	set_bit(index, ionic->intrs);
+	ionic_intr_init(&ionic->idev, intr, index);
+
+	return 0;
+}
+
+static void ionic_intr_free(struct ionic_lif *lif, int index)
+{
+	if (index != INTR_INDEX_NOT_ASSIGNED && index < lif->ionic->nintrs)
+		clear_bit(index, lif->ionic->intrs);
+}
+
+static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct device *dev = lif->ionic->dev;
+
+	if (!qcq)
+		return;
+
+	ionic_debugfs_del_qcq(qcq);
+
+	if (!(qcq->flags & IONIC_QCQ_F_INITED))
+		return;
+
+	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
+				IONIC_INTR_MASK_SET);
+		synchronize_irq(qcq->intr.vector);
+		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);
+		netif_napi_del(&qcq->napi);
+	}
+
+	qcq->flags &= ~IONIC_QCQ_F_INITED;
+}
+
+static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
+{
+	struct device *dev = lif->ionic->dev;
+
+	if (!qcq)
+		return;
+
+	dma_free_coherent(dev, qcq->total_size, qcq->base, qcq->base_pa);
+	qcq->base = NULL;
+	qcq->base_pa = 0;
+
+	if (qcq->flags & IONIC_QCQ_F_INTR)
+		ionic_intr_free(lif, qcq->intr.index);
+
+	devm_kfree(dev, qcq->cq.info);
+	qcq->cq.info = NULL;
+	devm_kfree(dev, qcq->q.info);
+	qcq->q.info = NULL;
+	devm_kfree(dev, qcq);
+}
+
+static void ionic_qcqs_free(struct ionic_lif *lif)
+{
+	if (lif->adminqcq) {
+		ionic_qcq_free(lif, lif->adminqcq);
+		lif->adminqcq = NULL;
+	}
+}
+
+static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
+			   unsigned int index,
+			   const char *name, unsigned int flags,
+			   unsigned int num_descs, unsigned int desc_size,
+			   unsigned int cq_desc_size,
+			   unsigned int sg_desc_size,
+			   unsigned int pid, struct ionic_qcq **qcq)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+	u32 q_size, cq_size, sg_size, total_size;
+	struct device *dev = lif->ionic->dev;
+	void *q_base, *cq_base, *sg_base;
+	dma_addr_t cq_base_pa = 0;
+	dma_addr_t sg_base_pa = 0;
+	dma_addr_t q_base_pa = 0;
+	struct ionic_qcq *new;
+	int err;
+
+	*qcq = NULL;
+
+	q_size  = num_descs * desc_size;
+	cq_size = num_descs * cq_desc_size;
+	sg_size = num_descs * sg_desc_size;
+
+	total_size = ALIGN(q_size, PAGE_SIZE) + ALIGN(cq_size, PAGE_SIZE);
+	/* Note: aligning q_size/cq_size is not enough due to cq_base
+	 * address aligning as q_base could be not aligned to the page.
+	 * Adding PAGE_SIZE.
+	 */
+	total_size += PAGE_SIZE;
+	if (flags & IONIC_QCQ_F_SG) {
+		total_size += ALIGN(sg_size, PAGE_SIZE);
+		total_size += PAGE_SIZE;
+	}
+
+	new = devm_kzalloc(dev, sizeof(*new), GFP_KERNEL);
+	if (!new) {
+		netdev_err(lif->netdev, "Cannot allocate queue structure\n");
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	new->flags = flags;
+
+	new->q.info = devm_kzalloc(dev, sizeof(*new->q.info) * num_descs,
+				   GFP_KERNEL);
+	if (!new->q.info) {
+		netdev_err(lif->netdev, "Cannot allocate queue info\n");
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	new->q.type = type;
+
+	err = ionic_q_init(lif, idev, &new->q, index, name, num_descs,
+			   desc_size, sg_desc_size, pid);
+	if (err) {
+		netdev_err(lif->netdev, "Cannot initialize queue\n");
+		goto err_out;
+	}
+
+	if (flags & IONIC_QCQ_F_INTR) {
+		err = ionic_intr_alloc(lif, &new->intr);
+		if (err) {
+			netdev_warn(lif->netdev, "no intr for %s: %d\n",
+				    name, err);
+			goto err_out;
+		}
+
+		err = ionic_bus_get_irq(lif->ionic, new->intr.index);
+		if (err < 0) {
+			netdev_warn(lif->netdev, "no vector for %s: %d\n",
+				    name, err);
+			goto err_out_free_intr;
+		}
+		new->intr.vector = err;
+		ionic_intr_mask_assert(idev->intr_ctrl, new->intr.index,
+				       IONIC_INTR_MASK_SET);
+
+		new->intr.cpu = new->intr.index % num_online_cpus();
+		if (cpu_online(new->intr.cpu))
+			cpumask_set_cpu(new->intr.cpu,
+					&new->intr.affinity_mask);
+	} else {
+		new->intr.index = INTR_INDEX_NOT_ASSIGNED;
+	}
+
+	new->cq.info = devm_kzalloc(dev, sizeof(*new->cq.info) * num_descs,
+				    GFP_KERNEL);
+	if (!new->cq.info) {
+		netdev_err(lif->netdev, "Cannot allocate completion queue info\n");
+		err = -ENOMEM;
+		goto err_out_free_intr;
+	}
+
+	err = ionic_cq_init(lif, &new->cq, &new->intr, num_descs, cq_desc_size);
+	if (err) {
+		netdev_err(lif->netdev, "Cannot initialize completion queue\n");
+		goto err_out_free_intr;
+	}
+
+	new->base = dma_alloc_coherent(dev, total_size, &new->base_pa,
+				       GFP_KERNEL);
+	if (!new->base) {
+		netdev_err(lif->netdev, "Cannot allocate queue DMA memory\n");
+		err = -ENOMEM;
+		goto err_out_free_intr;
+	}
+
+	new->total_size = total_size;
+
+	q_base = new->base;
+	q_base_pa = new->base_pa;
+
+	cq_base = (void *)ALIGN((uintptr_t)q_base + q_size, PAGE_SIZE);
+	cq_base_pa = ALIGN(q_base_pa + q_size, PAGE_SIZE);
+
+	if (flags & IONIC_QCQ_F_SG) {
+		sg_base = (void *)ALIGN((uintptr_t)cq_base + cq_size,
+					PAGE_SIZE);
+		sg_base_pa = ALIGN(cq_base_pa + cq_size, PAGE_SIZE);
+		ionic_q_sg_map(&new->q, sg_base, sg_base_pa);
+	}
+
+	ionic_q_map(&new->q, q_base, q_base_pa);
+	ionic_cq_map(&new->cq, cq_base, cq_base_pa);
+	ionic_cq_bind(&new->cq, &new->q);
+
+	*qcq = new;
+
+	return 0;
+
+err_out_free_intr:
+	ionic_intr_free(lif, new->intr.index);
+err_out:
+	dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
+	return err;
+}
+
+static int ionic_qcqs_alloc(struct ionic_lif *lif)
+{
+	unsigned int flags;
+	int err;
+
+	flags = IONIC_QCQ_F_INTR;
+	err = ionic_qcq_alloc(lif, IONIC_QTYPE_ADMINQ, 0, "admin", flags,
+			      IONIC_ADMINQ_LENGTH,
+			      sizeof(struct ionic_admin_cmd),
+			      sizeof(struct ionic_admin_comp),
+			      0, lif->kern_pid, &lif->adminqcq);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static bool ionic_adminq_service(struct ionic_cq *cq,
+				 struct ionic_cq_info *cq_info)
+{
+	struct ionic_admin_comp *comp = cq_info->cq_desc;
+
+	if (!color_match(comp->color, cq->done_color))
+		return false;
+
+	ionic_q_service(cq->bound_q, cq_info, le16_to_cpu(comp->comp_index));
+
+	return true;
+}
+
+static int ionic_adminq_napi(struct napi_struct *napi, int budget)
+{
+	return ionic_napi(napi, budget, ionic_adminq_service, NULL, NULL);
+}
+
 static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
 {
 	struct device *dev = ionic->dev;
@@ -39,6 +318,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 
 	snprintf(lif->name, sizeof(lif->name), "lif%u", index);
 
+	spin_lock_init(&lif->adminq_lock);
+
 	/* allocate lif info */
 	lif->info_sz = ALIGN(sizeof(*lif->info), PAGE_SIZE);
 	lif->info = dma_alloc_coherent(dev, lif->info_sz,
@@ -49,10 +330,19 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 		goto err_out_free_netdev;
 	}
 
+	/* allocate queues */
+	err = ionic_qcqs_alloc(lif);
+	if (err)
+		goto err_out_free_lif_info;
+
 	list_add_tail(&lif->list, &ionic->lifs);
 
 	return lif;
 
+err_out_free_lif_info:
+	dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
+	lif->info = NULL;
+	lif->info_pa = 0;
 err_out_free_netdev:
 	free_netdev(lif->netdev);
 	lif = NULL;
@@ -87,6 +377,8 @@ static void ionic_lif_free(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
 
+	/* free queues */
+	ionic_qcqs_free(lif);
 	ionic_lif_reset(lif);
 
 	/* free lif info */
@@ -125,6 +417,9 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 
 	clear_bit(IONIC_LIF_INITED, lif->state);
 
+	napi_disable(&lif->adminqcq->napi);
+	ionic_lif_qcq_deinit(lif, lif->adminqcq);
+
 	ionic_lif_reset(lif);
 }
 
@@ -139,6 +434,59 @@ void ionic_lifs_deinit(struct ionic *ionic)
 	}
 }
 
+static int ionic_lif_adminq_init(struct ionic_lif *lif)
+{
+	struct device *dev = lif->ionic->dev;
+	struct ionic_q_init_comp comp;
+	struct ionic_dev *idev;
+	struct ionic_qcq *qcq;
+	struct ionic_queue *q;
+	int err;
+
+	idev = &lif->ionic->idev;
+	qcq = lif->adminqcq;
+	q = &qcq->q;
+
+	mutex_lock(&lif->ionic->dev_cmd_lock);
+	ionic_dev_cmd_adminq_init(idev, qcq, lif->index, qcq->intr.index);
+	err = ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
+	ionic_dev_cmd_comp(idev, (union ionic_dev_cmd_comp *)&comp);
+	mutex_unlock(&lif->ionic->dev_cmd_lock);
+	if (err) {
+		netdev_err(lif->netdev, "adminq init failed %d\n", err);
+		return err;
+	}
+
+	q->hw_type = comp.hw_type;
+	q->hw_index = le32_to_cpu(comp.hw_index);
+	q->dbval = IONIC_DBELL_QID(q->hw_index);
+
+	dev_dbg(dev, "adminq->hw_type %d\n", q->hw_type);
+	dev_dbg(dev, "adminq->hw_index %d\n", q->hw_index);
+
+	netif_napi_add(lif->netdev, &qcq->napi, ionic_adminq_napi,
+		       NAPI_POLL_WEIGHT);
+
+	err = ionic_request_irq(lif, qcq);
+	if (err) {
+		netdev_warn(lif->netdev, "adminq irq request failed %d\n", err);
+		netif_napi_del(&qcq->napi);
+		return err;
+	}
+
+	napi_enable(&qcq->napi);
+
+	if (qcq->flags & IONIC_QCQ_F_INTR)
+		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
+				IONIC_INTR_MASK_CLEAR);
+
+	qcq->flags |= IONIC_QCQ_F_INITED;
+
+	ionic_debugfs_add_qcq(lif, qcq);
+
+	return 0;
+}
+
 static int ionic_lif_init(struct ionic_lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -184,10 +532,19 @@ static int ionic_lif_init(struct ionic_lif *lif)
 		goto err_out_free_dbid;
 	}
 
+	err = ionic_lif_adminq_init(lif);
+	if (err)
+		goto err_out_adminq_deinit;
+
 	set_bit(IONIC_LIF_INITED, lif->state);
 
 	return 0;
 
+err_out_adminq_deinit:
+	ionic_lif_qcq_deinit(lif, lif->adminqcq);
+	ionic_lif_reset(lif);
+	ionic_bus_unmap_dbpage(lif->ionic, lif->kern_dbpage);
+	lif->kern_dbpage = NULL;
 err_out_free_dbid:
 	kfree(lif->dbid_inuse);
 	lif->dbid_inuse = NULL;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index ec8d06ad4192..d897048ae77f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -6,6 +6,55 @@
 
 #include <linux/pci.h>
 
+#define IONIC_ADMINQ_LENGTH	16	/* must be a power of two */
+
+#define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
+#define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS + 1)
+
+struct ionic_tx_stats {
+	u64 pkts;
+	u64 bytes;
+};
+
+struct ionic_rx_stats {
+	u64 pkts;
+	u64 bytes;
+};
+
+#define IONIC_QCQ_F_INITED		BIT(0)
+#define IONIC_QCQ_F_SG			BIT(1)
+#define IONIC_QCQ_F_INTR		BIT(2)
+
+struct ionic_napi_stats {
+	u64 poll_count;
+	u64 work_done_cntr[IONIC_MAX_NUM_NAPI_CNTR];
+};
+
+struct ionic_q_stats {
+	union {
+		struct ionic_tx_stats tx;
+		struct ionic_rx_stats rx;
+	};
+};
+
+struct ionic_qcq {
+	void *base;
+	dma_addr_t base_pa;
+	unsigned int total_size;
+	struct ionic_queue q;
+	struct ionic_cq cq;
+	struct ionic_intr_info intr;
+	struct napi_struct napi;
+	struct ionic_napi_stats napi_stats;
+	struct ionic_q_stats *stats;
+	unsigned int flags;
+	struct dentry *dentry;
+};
+
+#define q_to_qcq(q)		container_of(q, struct ionic_qcq, q)
+#define napi_to_qcq(napi)	container_of(napi, struct ionic_qcq, napi)
+#define napi_to_cq(napi)	(&napi_to_qcq(napi)->cq)
+
 enum ionic_lif_state_flags {
 	IONIC_LIF_INITED,
 
@@ -25,6 +74,8 @@ struct ionic_lif {
 	unsigned int hw_index;
 	unsigned int kern_pid;
 	u64 __iomem *kern_dbpage;
+	spinlock_t adminq_lock;		/* lock for AdminQ operations */
+	struct ionic_qcq *adminqcq;
 	unsigned int neqs;
 	unsigned int nxqs;
 
@@ -46,4 +97,20 @@ int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union ionic_lif_identity *lif_ident);
 int ionic_lifs_size(struct ionic *ionic);
 
+static inline void debug_stats_napi_poll(struct ionic_qcq *qcq,
+					 unsigned int work_done)
+{
+	qcq->napi_stats.poll_count++;
+
+	if (work_done > (IONIC_MAX_NUM_NAPI_CNTR - 1))
+		work_done = IONIC_MAX_NUM_NAPI_CNTR - 1;
+
+	qcq->napi_stats.work_done_cntr[work_done]++;
+}
+
+#define DEBUG_STATS_CQE_CNT(cq)		((cq)->compl_count++)
+#define DEBUG_STATS_INTR_REARM(intr)	((intr)->rearm_count++)
+#define DEBUG_STATS_NAPI_POLL(qcq, work_done) \
+	debug_stats_napi_poll(qcq, work_done)
+
 #endif /* _IONIC_LIF_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 276d36139e93..647f4c3b8b49 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -169,6 +169,32 @@ static const char *ionic_opcode_to_str(enum ionic_cmd_opcode opcode)
 	}
 }
 
+int ionic_napi(struct napi_struct *napi, int budget, ionic_cq_cb cb,
+	       ionic_cq_done_cb done_cb, void *done_arg)
+{
+	struct ionic_qcq *qcq = napi_to_qcq(napi);
+	struct ionic_cq *cq = &qcq->cq;
+	u32 work_done, flags = 0;
+
+	work_done = ionic_cq_service(cq, budget, cb, done_cb, done_arg);
+
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		flags |= IONIC_INTR_CRED_UNMASK;
+		DEBUG_STATS_INTR_REARM(cq->bound_intr);
+	}
+
+	if (work_done || flags) {
+		flags |= IONIC_INTR_CRED_RESET_COALESCE;
+		ionic_intr_credits(cq->lif->ionic->idev.intr_ctrl,
+				   cq->bound_intr->index,
+				   work_done, flags);
+	}
+
+	DEBUG_STATS_NAPI_POLL(qcq, work_done);
+
+	return work_done;
+}
+
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
 {
 	struct ionic_dev *idev = &ionic->idev;
-- 
2.17.1

