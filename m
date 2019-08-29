Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3182BA2512
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbfH2S2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:28:04 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42172 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729604AbfH2S17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:27:59 -0400
Received: by mail-pg1-f195.google.com with SMTP id p3so2015059pgb.9
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=hOltOjRrijCXZXzgrkTL8iQHlxTB5r41GVWEK0BZ0Rw=;
        b=lygn/O/Atp+cs5LR4ls5Y8W6RFgB0CrtXGnCp7ycQGYquKk64+mW+PbV5YA7VNJDjY
         AvTsY1OFeptaTE4Wvo0FIfWMFzjYDOU3P6zt4m0jdlZY1WNhZsuR6/2f8u/vr796pT6b
         mkhz9FBZqP3/EfCKSaot9yfCW9M+0IgVMyCCcQypX3h8CM7yKd5z5H+Nasc/OtRsGF53
         MCeV3shSEjlVUsXvGeSsukct9x86uiMa9Y5TWc78tSDp9PJO+9JXjOaFRw95EMNu3Mmw
         1MpsXYDKsad97kiwgCX1AiZbTOd0TxP0sbrp7ZPPU8W5l32+iWx4MlRvxsrcLaixV6h+
         Fs2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=hOltOjRrijCXZXzgrkTL8iQHlxTB5r41GVWEK0BZ0Rw=;
        b=bW0NIJTP2SAVyT/IsCMoIp9G5z8ibcG89Tv2pZdiSA3mmvFdb81uVx3eM5z60BwCVv
         +cNT3G2WeNFXoOhAouF27bI2iOiBtH1HO+SeCNytU/T+8JvhT85BWCqk3HeJRuod5yqy
         sYE8naDpPSqOOMedEh8RMN7f/Db4eoy2kB07eHRgT3nXpXpwVYj8yZ335ZpAzgG5Mfe9
         S81I+XsPXh5aJ1vRXrWYiqB2a59idvKb9PD4S1mbm2EiBr0qBrMS1W5z5N+J7F0HvzTF
         HRy0MCegWt6MVVpY+hhpfa4P6W+ho0yW2pSzmH9x62Dl2Z1rlHQ5ZU8q/Oc7+DT+5S/r
         0Tww==
X-Gm-Message-State: APjAAAU9S8eoX09+9CXACOIszrnA1mWlhSyB6TFnZk+8Gc2hLrkdpGAW
        hgN5fH9yhGIq3zPGPcOxr/oIFoZV7+w=
X-Google-Smtp-Source: APXvYqzlOG1WG9wovEYiNmcVc+i6dPfK/ipXalLxqYJQrIc5U7DqD047CgTaP3Q8hjchNDYQBanQEQ==
X-Received: by 2002:a17:90a:b303:: with SMTP id d3mr11794322pjr.28.1567103278984;
        Thu, 29 Aug 2019 11:27:58 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.27.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:27:58 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v6 net-next 09/19] ionic: Add notifyq support
Date:   Thu, 29 Aug 2019 11:27:10 -0700
Message-Id: <20190829182720.68419-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829182720.68419-1-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
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
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  15 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 169 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   4 +
 3 files changed, 186 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index d02f81a2b466..7afc4a365b75 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -112,7 +112,7 @@ static const struct debugfs_reg32 intr_ctrl_regs[] = {
 
 void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
-	struct dentry *q_dentry, *cq_dentry, *intr_dentry;
+	struct dentry *q_dentry, *cq_dentry, *intr_dentry, *stats_dentry;
 	struct ionic_dev *idev = &lif->ionic->idev;
 	struct debugfs_regset32 *intr_ctrl_regset;
 	struct ionic_intr_info *intr = &qcq->intr;
@@ -201,6 +201,19 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		debugfs_create_regset32("intr_ctrl", 0400, intr_dentry,
 					intr_ctrl_regset);
 	}
+
+	if (qcq->flags & IONIC_QCQ_F_NOTIFYQ) {
+		stats_dentry = debugfs_create_dir("notifyblock", qcq->dentry);
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
 }
 
 static int netdev_show(struct seq_file *seq, void *v)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 9628722dea87..ee5f8376dbb9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -111,12 +111,29 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 
 static void ionic_qcqs_free(struct ionic_lif *lif)
 {
+	if (lif->notifyqcq) {
+		ionic_qcq_free(lif, lif->notifyqcq);
+		lif->notifyqcq = NULL;
+	}
+
 	if (lif->adminqcq) {
 		ionic_qcq_free(lif, lif->adminqcq);
 		lif->adminqcq = NULL;
 	}
 }
 
+static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
+				      struct ionic_qcq *n_qcq)
+{
+	if (WARN_ON(n_qcq->flags & IONIC_QCQ_F_INTR)) {
+		ionic_intr_free(n_qcq->cq.lif, n_qcq->intr.index);
+		n_qcq->flags &= ~IONIC_QCQ_F_INTR;
+	}
+
+	n_qcq->intr.vector = src_qcq->intr.vector;
+	n_qcq->intr.index = src_qcq->intr.index;
+}
+
 static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 			   unsigned int index,
 			   const char *name, unsigned int flags,
@@ -270,7 +287,91 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 	if (err)
 		return err;
 
+	if (lif->ionic->nnqs_per_lif) {
+		flags = IONIC_QCQ_F_NOTIFYQ;
+		err = ionic_qcq_alloc(lif, IONIC_QTYPE_NOTIFYQ, 0, "notifyq",
+				      flags, IONIC_NOTIFYQ_LENGTH,
+				      sizeof(struct ionic_notifyq_cmd),
+				      sizeof(union ionic_notifyq_comp),
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
+}
+
+static bool ionic_notifyq_service(struct ionic_cq *cq,
+				  struct ionic_cq_info *cq_info)
+{
+	union ionic_notifyq_comp *comp = cq_info->cq_desc;
+	struct net_device *netdev;
+	struct ionic_queue *q;
+	struct ionic_lif *lif;
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
+	case IONIC_EVENT_LINK_CHANGE:
+		netdev_info(netdev, "Notifyq IONIC_EVENT_LINK_CHANGE eid=%lld\n",
+			    eid);
+		netdev_info(netdev,
+			    "  link_status=%d link_speed=%d\n",
+			    le16_to_cpu(comp->link_change.link_status),
+			    le32_to_cpu(comp->link_change.link_speed));
+		break;
+	case IONIC_EVENT_RESET:
+		netdev_info(netdev, "Notifyq IONIC_EVENT_RESET eid=%lld\n",
+			    eid);
+		netdev_info(netdev, "  reset_code=%d state=%d\n",
+			    comp->reset.reset_code,
+			    comp->reset.state);
+		break;
+	default:
+		netdev_warn(netdev, "Notifyq unknown event ecode=%d eid=%lld\n",
+			    comp->event.ecode, eid);
+		break;
+	}
+
+	return true;
+}
+
+static int ionic_notifyq_clean(struct ionic_lif *lif, int budget)
+{
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct ionic_cq *cq = &lif->notifyqcq->cq;
+	u32 work_done;
+
+	work_done = ionic_cq_service(cq, budget, ionic_notifyq_service,
+				     NULL, NULL);
+	if (work_done)
+		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
+				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
+
+	return work_done;
 }
 
 static bool ionic_adminq_service(struct ionic_cq *cq,
@@ -288,7 +389,15 @@ static bool ionic_adminq_service(struct ionic_cq *cq,
 
 static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 {
-	return ionic_napi(napi, budget, ionic_adminq_service, NULL, NULL);
+	struct ionic_lif *lif = napi_to_cq(napi)->lif;
+	int n_work = 0;
+	int a_work = 0;
+
+	if (likely(lif->notifyqcq && lif->notifyqcq->flags & IONIC_QCQ_F_INITED))
+		n_work = ionic_notifyq_clean(lif, budget);
+	a_work = ionic_napi(napi, budget, ionic_adminq_service, NULL, NULL);
+
+	return max(n_work, a_work);
 }
 
 static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
@@ -418,6 +527,7 @@ static void ionic_lif_deinit(struct ionic_lif *lif)
 	clear_bit(IONIC_LIF_INITED, lif->state);
 
 	napi_disable(&lif->adminqcq->napi);
+	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 
 	ionic_lif_reset(lif);
@@ -487,6 +597,55 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 	return 0;
 }
 
+static int ionic_lif_notifyq_init(struct ionic_lif *lif)
+{
+	struct ionic_qcq *qcq = lif->notifyqcq;
+	struct device *dev = lif->ionic->dev;
+	struct ionic_queue *q = &qcq->q;
+	int err;
+
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.q_init = {
+			.opcode = IONIC_CMD_Q_INIT,
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
@@ -536,10 +695,18 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	if (err)
 		goto err_out_adminq_deinit;
 
+	if (lif->ionic->nnqs_per_lif) {
+		err = ionic_lif_notifyq_init(lif);
+		if (err)
+			goto err_out_notifyq_deinit;
+	}
+
 	set_bit(IONIC_LIF_INITED, lif->state);
 
 	return 0;
 
+err_out_notifyq_deinit:
+	ionic_lif_qcq_deinit(lif, lif->notifyqcq);
 err_out_adminq_deinit:
 	ionic_lif_qcq_deinit(lif, lif->adminqcq);
 	ionic_lif_reset(lif);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index d897048ae77f..7bbe818893b7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 
 #define IONIC_ADMINQ_LENGTH	16	/* must be a power of two */
+#define IONIC_NOTIFYQ_LENGTH	64	/* must be a power of two */
 
 #define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
 #define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS + 1)
@@ -24,6 +25,7 @@ struct ionic_rx_stats {
 #define IONIC_QCQ_F_INITED		BIT(0)
 #define IONIC_QCQ_F_SG			BIT(1)
 #define IONIC_QCQ_F_INTR		BIT(2)
+#define IONIC_QCQ_F_NOTIFYQ		BIT(5)
 
 struct ionic_napi_stats {
 	u64 poll_count;
@@ -76,6 +78,8 @@ struct ionic_lif {
 	u64 __iomem *kern_dbpage;
 	spinlock_t adminq_lock;		/* lock for AdminQ operations */
 	struct ionic_qcq *adminqcq;
+	struct ionic_qcq *notifyqcq;
+	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
 
-- 
2.17.1

