Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BDA9D883
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfHZVeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:34:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42155 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728968AbfHZVd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:33:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id p3so11346691pgb.9
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=9IrgzPeWz4i7r+LTjDZ21UKM0sKwmzSNWRlbj6ipHzc=;
        b=Pz9WxaUFqudplqd51VLVb1uNAtxs3trae09x4dalrJikC6RZSLDGbIX/Dsk6CKDIZX
         ZLyP+Mw0OXcpxxproZYDy823bYJeEFk7N8JYrs3qY7mATAkG9ljsAM3tmQnYSQnuNplZ
         7HOY1pK2Wq+UdorkRUhFNUFNwuojszf0YEbNVGiYAta/SyGbPsu1BCKklC+W7qPIIsmv
         1BjyXtr3wCdTIhMopDrm4s/g4Yl6drGDmKf5Lg+qgIm72e0HRLFejgV0XyTsW4+eXnZb
         As/dMMpG/OL9wLmVjDGR8M4cV0pi2ywmngiVxnm0mQFzABTvQ09CrmmTuFmW8vUVcyHN
         BRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=9IrgzPeWz4i7r+LTjDZ21UKM0sKwmzSNWRlbj6ipHzc=;
        b=NLfoXVy2XrQvREIGoBOLmyq7czQ0wDiIKIlZ+6wKT1JtmelhAng6t9rNNNK7aDXjoM
         GK9VbnzExuxqO8MbYYadYQKEozvs4DCOSpumP4lhwYz+iTixhrH9VeAaxnAmBloO0Uer
         23MzF9fKYXRVlvWIaomH4AtbpnCY8PiHjFMXD6JbqLQHumEl7CkMQ8AX6TQ5iu4y3oyF
         6l6cvmkCxzxT0GPValSGSaTN0OmtmklKYwZJUuubcdOMZ+lJzm/JoxxDzhNUwKEY7cgC
         NKC+7FvDznODoIYTvD/Sp7PX1jUDmZIT5H9/OUqczsnVzGC6z69myeGq1YR5vwhl8BcV
         me2Q==
X-Gm-Message-State: APjAAAUJYR5OzIwUqppB9QSxIkmCcXjDS0XSKVHVUDLg5b/TBWDm6sJz
        UhXJambIXEOsNSs64DRCPG8Z5w==
X-Google-Smtp-Source: APXvYqwvFe1qX4/W5bc2jMvJouhj64fz6ntHfNXBQDoE0s3WEt/llgS2k3Dl2cDYCWR170jWAEJ8yQ==
X-Received: by 2002:a62:2603:: with SMTP id m3mr23208263pfm.163.1566855238138;
        Mon, 26 Aug 2019 14:33:58 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.33.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:33:57 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 08/18] ionic: Add notifyq support
Date:   Mon, 26 Aug 2019 14:33:29 -0700
Message-Id: <20190826213339.56909-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
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
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 169 +++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   4 +
 3 files changed, 188 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index f925b473ca45..d7ee60f0b19c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -126,6 +126,7 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	struct device *dev = lif->ionic->dev;
 	struct ionic_queue *q = &qcq->q;
 	struct ionic_cq *cq = &qcq->cq;
+	struct dentry *stats_dentry;
 
 	qcq_dentry = debugfs_create_dir(q->name, lif->dentry);
 	if (IS_ERR_OR_NULL(qcq_dentry))
@@ -216,6 +217,21 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 		debugfs_create_regset32("intr_ctrl", 0400, intr_dentry,
 					intr_ctrl_regset);
 	}
+
+	if (qcq->flags & IONIC_QCQ_F_NOTIFYQ) {
+		stats_dentry = debugfs_create_dir("notifyblock", qcq_dentry);
+		if (IS_ERR_OR_NULL(stats_dentry))
+			return;
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
index c55d9039f86d..56831fb7b3e3 100644
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
index f751274bb1b1..397a4d388df1 100644
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

