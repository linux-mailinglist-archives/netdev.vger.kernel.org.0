Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1098B4DB2C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 22:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfFTUYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 16:24:40 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43291 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfFTUYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 16:24:38 -0400
Received: by mail-pl1-f195.google.com with SMTP id cl9so1822296plb.10
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 13:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=npUjZ6j2WdJedZLCGkIXGyJ6QFHbM86oSVsxa7VHxlE=;
        b=AKmy0PTeXB6LRzifgkUFEWeAdGppanFHn9a1X9dA7vqZnbfjtnsqQYT4y9ZYbx2iWe
         tpbQejJmasy5/vPUDcEmHBLhd1Pz12YeTeUH/Rr1XvkLq0Z5IVLMpeO5DXiaFX7lFRud
         6TZ6elweGRLTD5LvxnlvQleHLOTaK3b9oZ5ZagdZw35I7ge7iCIWw9SrviYUcmILuojQ
         jo5VKlrzy9pOY7Ly10zw7xSfAYwFJhcNSXuf7uZVvjOUziRT34v2lsComWuNh2H8mTX2
         5/qAaB5jkVtQ5zaPn3hRm0HUGPMf+t324rNvFaXBSNB+IsPqIf+kXNM4Jz8Lt3FIyygK
         y6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=npUjZ6j2WdJedZLCGkIXGyJ6QFHbM86oSVsxa7VHxlE=;
        b=XOs5wR2V1GljlMZhy2sXp7gDZzkN+oeI7rWL1K2elr76QR339ReB2aZxb6eXtkcOzL
         PEiz5aCwria6+85jMyyBXDCDM1zh++DxezOlmOp6L3j7eTp2vI2Vo+s4sYoYT+OfQNMb
         LPAz3gObrxm97b5jWWjKxkRvfzW/YFHlv2EhJSP2tckAoEr71iF+0ZgEdCczLiytQTM8
         IgUp1d4X7pft/V6MQBZUYSD400WIDSu4ydZCcq+77XQq7DAadzo4rVmQc0kJRMOh5aqA
         iFwDUcGtjhGxzEqzz597RBT3Xgf3+wonECwszAUSKqhrbZ/2YdUIzZ8jlflzE8hXzz/I
         Noqg==
X-Gm-Message-State: APjAAAX+6kP762BpI1txUVJAg6hwrChUYQi4Bjr3h78NmRF4Z4JL5sZl
        gGUhtYlgAWtNbXLt00riJm0k/pd6iKs=
X-Google-Smtp-Source: APXvYqy4ZyA+RLdvyDAE0d3iqVrw/DcQGD1hVi4k3Xc74AvNsKOOVmaC1YvtN+YxNxYmxHI4Fki/Hg==
X-Received: by 2002:a17:902:2983:: with SMTP id h3mr83225372plb.45.1561062277635;
        Thu, 20 Jun 2019 13:24:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h26sm340537pfq.64.2019.06.20.13.24.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 13:24:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH net-next 08/18] ionic: Add notifyq support
Date:   Thu, 20 Jun 2019 13:24:14 -0700
Message-Id: <20190620202424.23215-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AdminQ is fine for sending messages and requests to the NIC,
but we also need to have events published from the NIC to the
driver.  The NotifyQ handles this for us, using the same interrupt
as AdminQ.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  16 ++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 187 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   4 +
 3 files changed, 206 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index e01126f3f6bd..5ebfaa320edf 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -298,6 +298,7 @@ int ionic_debugfs_add_qcq(struct lif *lif, struct qcq *qcq)
 	struct debugfs_blob_wrapper *desc_blob;
 	struct device *dev = lif->ionic->dev;
 	struct intr *intr = &qcq->intr;
+	struct dentry *stats_dentry;
 	struct queue *q = &qcq->q;
 	struct cq *cq = &qcq->cq;
 
@@ -391,6 +392,21 @@ int ionic_debugfs_add_qcq(struct lif *lif, struct qcq *qcq)
 					intr_ctrl_regset);
 	}
 
+	if (qcq->flags & QCQ_F_NOTIFYQ) {
+		stats_dentry = debugfs_create_dir("notifyblock", qcq_dentry);
+		if (IS_ERR_OR_NULL(stats_dentry))
+			return PTR_ERR(stats_dentry);
+
+		debugfs_create_u64("eid", 0400, stats_dentry,
+				   (u64 *)&lif->info->status.eid);
+		debugfs_create_u16("link_status", 0400, stats_dentry,
+				   (u16 *)&lif->info->status.link_status);
+		debugfs_create_u32("link_speed", 0400, stats_dentry,
+				   (u32 *)&lif->info->status.link_speed);
+		debugfs_create_u16("link_down_count", 0400, stats_dentry,
+				   (u16 *)&lif->info->status.link_down_count);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1cfc571dc13e..2a5c2383e2f3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -12,6 +12,8 @@
 #include "ionic_lif.h"
 #include "ionic_debugfs.h"
 
+static int ionic_notifyq_clean(struct lif *lif, int budget);
+
 static bool ionic_adminq_service(struct cq *cq, struct cq_info *cq_info)
 {
 	struct admin_comp *comp = cq_info->cq_desc;
@@ -26,7 +28,94 @@ static bool ionic_adminq_service(struct cq *cq, struct cq_info *cq_info)
 
 static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 {
-	return ionic_napi(napi, budget, ionic_adminq_service, NULL, NULL);
+	struct lif *lif = napi_to_cq(napi)->lif;
+	int n_work = 0;
+	int a_work = 0;
+
+	if (likely(lif->notifyqcq && lif->notifyqcq->flags & QCQ_F_INITED))
+		n_work = ionic_notifyq_clean(lif, budget);
+	a_work = ionic_napi(napi, budget, ionic_adminq_service, NULL, NULL);
+
+	return max(n_work, a_work);
+}
+
+static bool ionic_notifyq_service(struct cq *cq, struct cq_info *cq_info)
+{
+	union notifyq_comp *comp = cq_info->cq_desc;
+	struct net_device *netdev;
+	struct queue *q;
+	struct lif *lif;
+	u64 eid;
+
+	q = cq->bound_q;
+	lif = q->info[0].cb_arg;
+	netdev = lif->netdev;
+	eid = le64_to_cpu(comp->event.eid);
+
+	/* Have we run out of new completions to process? */
+	if (eid <= lif->last_eid)
+		return false;
+
+	lif->last_eid = eid;
+
+	dev_dbg(lif->ionic->dev, "notifyq event:\n");
+	dynamic_hex_dump("event ", DUMP_PREFIX_OFFSET, 16, 1,
+			 comp, sizeof(*comp), true);
+
+	switch (le16_to_cpu(comp->event.ecode)) {
+	case EVENT_OPCODE_LINK_CHANGE:
+		netdev_info(netdev, "Notifyq EVENT_OPCODE_LINK_CHANGE eid=%lld\n",
+			    eid);
+		netdev_info(netdev,
+			    "  link_status=%d link_speed=%d\n",
+			    le16_to_cpu(comp->link_change.link_status),
+			    le32_to_cpu(comp->link_change.link_speed));
+		break;
+	case EVENT_OPCODE_RESET:
+		netdev_info(netdev, "Notifyq EVENT_OPCODE_RESET eid=%lld\n",
+			    eid);
+		netdev_info(netdev, "  reset_code=%d state=%d\n",
+			    comp->reset.reset_code,
+			    comp->reset.state);
+		break;
+	case EVENT_OPCODE_HEARTBEAT:
+		netdev_info(netdev, "Notifyq EVENT_OPCODE_HEARTBEAT eid=%lld\n",
+			    eid);
+		break;
+	case EVENT_OPCODE_LOG:
+		netdev_info(netdev, "Notifyq EVENT_OPCODE_LOG eid=%lld\n", eid);
+		print_hex_dump(KERN_INFO, "notifyq ", DUMP_PREFIX_OFFSET, 16, 1,
+			       comp->log.data, sizeof(comp->log.data), true);
+		break;
+	default:
+		netdev_warn(netdev, "Notifyq bad event ecode=%d eid=%lld\n",
+			    comp->event.ecode, eid);
+		break;
+	}
+
+	return true;
+}
+
+static int ionic_notifyq_clean(struct lif *lif, int budget)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct cq *cq = &lif->notifyqcq->cq;
+	u32 work_done;
+
+	work_done = ionic_cq_service(cq, budget, ionic_notifyq_service,
+				     NULL, NULL);
+	if (work_done)
+		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
+				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
+
+	/* If we ran out of budget, there are more events
+	 * to process and napi will reschedule us soon
+	 */
+	if (work_done == budget)
+		goto return_to_napi;
+
+return_to_napi:
+	return work_done;
 }
 
 static irqreturn_t ionic_isr(int irq, void *data)
@@ -62,6 +151,17 @@ static void ionic_intr_free(struct lif *lif, int index)
 		clear_bit(index, lif->ionic->intrs);
 }
 
+static void ionic_link_qcq_interrupts(struct qcq *src_qcq, struct qcq *n_qcq)
+{
+	if (WARN_ON(n_qcq->flags & QCQ_F_INTR)) {
+		ionic_intr_free(n_qcq->cq.lif, n_qcq->intr.index);
+		n_qcq->flags &= ~QCQ_F_INTR;
+	}
+
+	n_qcq->intr.vector = src_qcq->intr.vector;
+	n_qcq->intr.index = src_qcq->intr.index;
+}
+
 static int ionic_qcq_alloc(struct lif *lif, unsigned int type,
 			   unsigned int index,
 			   const char *name, unsigned int flags,
@@ -236,11 +336,36 @@ static int ionic_qcqs_alloc(struct lif *lif)
 	if (err)
 		return err;
 
+	if (lif->ionic->nnqs_per_lif) {
+		flags = QCQ_F_NOTIFYQ;
+		err = ionic_qcq_alloc(lif, IONIC_QTYPE_NOTIFYQ, 0, "notifyq",
+				      flags, IONIC_NOTIFYQ_LENGTH,
+				      sizeof(struct notifyq_cmd),
+				      sizeof(union notifyq_comp),
+				      0, lif->kern_pid, &lif->notifyqcq);
+		if (err)
+			goto err_out_free_adminqcq;
+
+		/* Let the notifyq ride on the adminq interrupt */
+		ionic_link_qcq_interrupts(lif->adminqcq, lif->notifyqcq);
+	}
+
 	return 0;
+
+err_out_free_adminqcq:
+	ionic_qcq_free(lif, lif->adminqcq);
+	lif->adminqcq = NULL;
+
+	return err;
 }
 
 static void ionic_qcqs_free(struct lif *lif)
 {
+	if (lif->notifyqcq) {
+		ionic_qcq_free(lif, lif->notifyqcq);
+		lif->notifyqcq = NULL;
+	}
+
 	if (lif->adminqcq) {
 		ionic_qcq_free(lif, lif->adminqcq);
 		lif->adminqcq = NULL;
@@ -402,6 +527,7 @@ static void ionic_lif_deinit(struct lif *lif)
 	clear_bit(LIF_INITED, lif->state);
 
 	napi_disable(&lif->adminqcq->napi);
+	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
 	ionic_lif_reset(lif);
@@ -489,6 +615,57 @@ static int ionic_lif_adminq_init(struct lif *lif)
 	return 0;
 }
 
+static int ionic_lif_notifyq_init(struct lif *lif)
+{
+	struct device *dev = lif->ionic->dev;
+	struct qcq *qcq = lif->notifyqcq;
+	struct queue *q = &qcq->q;
+	int err;
+
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.q_init = {
+			.opcode = CMD_OPCODE_Q_INIT,
+			.lif_index = cpu_to_le16(lif->index),
+			.type = q->type,
+			.index = cpu_to_le32(q->index),
+			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
+					     IONIC_QINIT_F_ENA),
+			.intr_index = cpu_to_le16(lif->adminqcq->intr.index),
+			.pid = cpu_to_le16(q->pid),
+			.ring_size = ilog2(q->num_descs),
+			.ring_base = cpu_to_le64(q->base_pa),
+		}
+	};
+
+	dev_dbg(dev, "notifyq_init.pid %d\n", ctx.cmd.q_init.pid);
+	dev_dbg(dev, "notifyq_init.index %d\n", ctx.cmd.q_init.index);
+	dev_dbg(dev, "notifyq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
+	dev_dbg(dev, "notifyq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	q->hw_type = ctx.comp.q_init.hw_type;
+	q->hw_index = le32_to_cpu(ctx.comp.q_init.hw_index);
+	q->dbval = IONIC_DBELL_QID(q->hw_index);
+
+	dev_dbg(dev, "notifyq->hw_type %d\n", q->hw_type);
+	dev_dbg(dev, "notifyq->hw_index %d\n", q->hw_index);
+
+	/* preset the callback info */
+	q->info[0].cb_arg = lif;
+
+	qcq->flags |= QCQ_F_INITED;
+
+	err = ionic_debugfs_add_qcq(lif, qcq);
+	if (err)
+		dev_warn(dev, "debugfs add for notifyq failed %d\n", err);
+
+	return 0;
+}
+
 static int ionic_lif_init(struct lif *lif)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -543,10 +720,18 @@ static int ionic_lif_init(struct lif *lif)
 	if (err)
 		goto err_out_adminq_deinit;
 
+	if (lif->ionic->nnqs_per_lif) {
+		err = ionic_lif_notifyq_init(lif);
+		if (err)
+			goto err_out_notifyq_deinit;
+	}
+
 	set_bit(LIF_INITED, lif->state);
 
 	return 0;
 
+err_out_notifyq_deinit:
+	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 err_out_adminq_deinit:
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 	ionic_lif_reset(lif);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index b9e2dd799a05..0a88a7df6c2b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 
 #define IONIC_ADMINQ_LENGTH	16	/* must be a power of two */
+#define IONIC_NOTIFYQ_LENGTH	64	/* must be a power of two */
 
 #define GET_NAPI_CNTR_IDX(work_done)	(work_done)
 #define MAX_NUM_NAPI_CNTR	(NAPI_POLL_WEIGHT + 1)
@@ -26,6 +27,7 @@ struct rx_stats {
 #define QCQ_F_INITED		BIT(0)
 #define QCQ_F_SG		BIT(1)
 #define QCQ_F_INTR		BIT(2)
+#define QCQ_F_NOTIFYQ		BIT(5)
 
 struct napi_stats {
 	u64 poll_count;
@@ -78,6 +80,8 @@ struct lif {
 	u64 __iomem *kern_dbpage;
 	spinlock_t adminq_lock;		/* lock for AdminQ operations */
 	struct qcq *adminqcq;
+	struct qcq *notifyqcq;
+	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
 
-- 
2.17.1

