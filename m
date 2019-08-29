Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F2EA2517
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfH2S2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:28:10 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39563 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbfH2S2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:28:07 -0400
Received: by mail-pf1-f193.google.com with SMTP id y200so2626061pfb.6
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=aibCWJ+2laZ1YDpM/iropUguavEllsiELv8te8q91Pw=;
        b=ti1wyDAc/po5fO4Wc5PBmtPIqpbmbhM3Rgb+SADnEt2uPyHSqjF/cCM2Lkyblh1nsZ
         d7wysBNTMzRxAZABcMmXms/BsohFGUTVklYbxeOFW+oDyV4g6y7XR2icEi1TbuhDzHn5
         l/oDe8LmdyXqNi0mbEpuoCcxX6xY68AGdAiiQ61663y/piqNcOvr47N4F6K42fyWskDu
         URBtRr0qUlCeCKXAuqmUDxsXGknqWDg4y82dWDj9kSSbby4xSubMwZ42SzLjNlUEj1Fh
         Yh72KApEUi83ZiXaohlqXJGWfvX1Z36m7AkfHJxgVp9FhTyk8rSzsfWZzA5mhE4VE7SD
         Dafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=aibCWJ+2laZ1YDpM/iropUguavEllsiELv8te8q91Pw=;
        b=XIYi5jZxQ26KuAbQE9ZwRB82weJGMvrswhSAKMwNwr8Kx0OFFjhzgl+Fe0SC87IwT7
         NtRYJFn8xsCXeEMdr9DtCacykT+LCfEtfeaGDFZxwiQ1phLWI9/s94JLuPUaDE9RC1aX
         qY0k7YkSq5GbuWrBlBV0LpR0iVYVo1rgsiXkqcQHlT8q0oP0yzUKqi7aqUpxDvffugoa
         zdn8rLA9zxG97jg6RtbLBo7sLDusHW3tBxyLXcUnlT8P7viFRNfGYXaFWGqqDvYGH154
         TM0tKbXocHw1ZCDc2AZzlpJMtuReTVSkC/6ymBxylAUCFklZ9BY1qvEEOSbPxTR7ri4f
         mbag==
X-Gm-Message-State: APjAAAVIddv1ZkNSHNcFzhLlkmoStZrK40OScmtBiaVxaAvdd4oPF1QA
        m4047hITlkM1q49iG1kVo7RRqQ==
X-Google-Smtp-Source: APXvYqylK0zSp2HnjhJ5EIJH2oYT+GNGIaURuFvfy3OyGLUN9xN+kQb1feIHsePIoO8RgvKYrm/ecw==
X-Received: by 2002:a63:2157:: with SMTP id s23mr9852692pgm.167.1567103286029;
        Thu, 29 Aug 2019 11:28:06 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.28.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:28:05 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v6 net-next 15/19] ionic: Add Tx and Rx handling
Date:   Thu, 29 Aug 2019 11:27:16 -0700
Message-Id: <20190829182720.68419-16-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829182720.68419-1-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add both the Tx and Rx queue setup and handling.  The related
stats display comes later.  Instead of using the generic napi
routines used by the slow-path commands, the Tx and Rx paths
are simplified and inlined in one file in order to get better
compiler optimizations.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |   3 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 414 ++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  50 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 914 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |  15 +
 5 files changed, 1395 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index a8b85f11cf3c..1cf8117db443 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -4,4 +4,5 @@
 obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
-	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o
+	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
+	   ionic_txrx.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 25ca7b65cc98..575c571d7b5e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -10,6 +10,7 @@
 #include "ionic.h"
 #include "ionic_bus.h"
 #include "ionic_lif.h"
+#include "ionic_txrx.h"
 #include "ionic_ethtool.h"
 #include "ionic_debugfs.h"
 
@@ -80,11 +81,17 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 		netdev_info(netdev, "Link up - %d Gbps\n",
 			    le32_to_cpu(lif->info->status.link_speed) / 1000);
 
+		if (test_bit(IONIC_LIF_UP, lif->state)) {
+			netif_tx_wake_all_queues(lif->netdev);
+			netif_carrier_on(netdev);
+		}
 	} else {
 		netdev_info(netdev, "Link down\n");
 
 		/* carrier off first to avoid watchdog timeout */
 		netif_carrier_off(netdev);
+		if (test_bit(IONIC_LIF_UP, lif->state))
+			netif_tx_stop_all_queues(netdev);
 	}
 
 link_out:
@@ -163,6 +170,77 @@ static void ionic_intr_free(struct ionic_lif *lif, int index)
 		clear_bit(index, lif->ionic->intrs);
 }
 
+static int ionic_qcq_enable(struct ionic_qcq *qcq)
+{
+	struct ionic_queue *q = &qcq->q;
+	struct ionic_lif *lif = q->lif;
+	struct ionic_dev *idev;
+	struct device *dev;
+
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.q_control = {
+			.opcode = IONIC_CMD_Q_CONTROL,
+			.lif_index = cpu_to_le16(lif->index),
+			.type = q->type,
+			.index = cpu_to_le32(q->index),
+			.oper = IONIC_Q_ENABLE,
+		},
+	};
+
+	idev = &lif->ionic->idev;
+	dev = lif->ionic->dev;
+
+	dev_dbg(dev, "q_enable.index %d q_enable.qtype %d\n",
+		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
+
+	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		irq_set_affinity_hint(qcq->intr.vector,
+				      &qcq->intr.affinity_mask);
+		napi_enable(&qcq->napi);
+		ionic_intr_clean(idev->intr_ctrl, qcq->intr.index);
+		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
+				IONIC_INTR_MASK_CLEAR);
+	}
+
+	return ionic_adminq_post_wait(lif, &ctx);
+}
+
+static int ionic_qcq_disable(struct ionic_qcq *qcq)
+{
+	struct ionic_queue *q = &qcq->q;
+	struct ionic_lif *lif = q->lif;
+	struct ionic_dev *idev;
+	struct device *dev;
+
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.q_control = {
+			.opcode = IONIC_CMD_Q_CONTROL,
+			.lif_index = cpu_to_le16(lif->index),
+			.type = q->type,
+			.index = cpu_to_le32(q->index),
+			.oper = IONIC_Q_DISABLE,
+		},
+	};
+
+	idev = &lif->ionic->idev;
+	dev = lif->ionic->dev;
+
+	dev_dbg(dev, "q_disable.index %d q_disable.qtype %d\n",
+		ctx.cmd.q_control.index, ctx.cmd.q_control.type);
+
+	if (qcq->flags & IONIC_QCQ_F_INTR) {
+		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
+				IONIC_INTR_MASK_SET);
+		synchronize_irq(qcq->intr.vector);
+		irq_set_affinity_hint(qcq->intr.vector, NULL);
+		napi_disable(&qcq->napi);
+	}
+
+	return ionic_adminq_post_wait(lif, &ctx);
+}
+
 static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
 {
 	struct ionic_dev *idev = &lif->ionic->idev;
@@ -210,6 +288,9 @@ static void ionic_qcq_free(struct ionic_lif *lif, struct ionic_qcq *qcq)
 
 static void ionic_qcqs_free(struct ionic_lif *lif)
 {
+	struct device *dev = lif->ionic->dev;
+	unsigned int i;
+
 	if (lif->notifyqcq) {
 		ionic_qcq_free(lif, lif->notifyqcq);
 		lif->notifyqcq = NULL;
@@ -219,6 +300,20 @@ static void ionic_qcqs_free(struct ionic_lif *lif)
 		ionic_qcq_free(lif, lif->adminqcq);
 		lif->adminqcq = NULL;
 	}
+
+	for (i = 0; i < lif->nxqs; i++)
+		if (lif->rxqcqs[i].stats)
+			devm_kfree(dev, lif->rxqcqs[i].stats);
+
+	devm_kfree(dev, lif->rxqcqs);
+	lif->rxqcqs = NULL;
+
+	for (i = 0; i < lif->nxqs; i++)
+		if (lif->txqcqs[i].stats)
+			devm_kfree(dev, lif->txqcqs[i].stats);
+
+	devm_kfree(dev, lif->txqcqs);
+	lif->txqcqs = NULL;
 }
 
 static void ionic_link_qcq_interrupts(struct ionic_qcq *src_qcq,
@@ -374,8 +469,11 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 
 static int ionic_qcqs_alloc(struct ionic_lif *lif)
 {
+	struct device *dev = lif->ionic->dev;
+	unsigned int q_list_size;
 	unsigned int flags;
 	int err;
+	int i;
 
 	flags = IONIC_QCQ_F_INTR;
 	err = ionic_qcq_alloc(lif, IONIC_QTYPE_ADMINQ, 0, "admin", flags,
@@ -400,8 +498,49 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 		ionic_link_qcq_interrupts(lif->adminqcq, lif->notifyqcq);
 	}
 
+	q_list_size = sizeof(*lif->txqcqs) * lif->nxqs;
+	err = -ENOMEM;
+	lif->txqcqs = devm_kzalloc(dev, q_list_size, GFP_KERNEL);
+	if (!lif->txqcqs)
+		goto err_out_free_notifyqcq;
+	for (i = 0; i < lif->nxqs; i++) {
+		lif->txqcqs[i].stats = devm_kzalloc(dev,
+						    sizeof(struct ionic_q_stats),
+						    GFP_KERNEL);
+		if (!lif->txqcqs[i].stats)
+			goto err_out_free_tx_stats;
+	}
+
+	lif->rxqcqs = devm_kzalloc(dev, q_list_size, GFP_KERNEL);
+	if (!lif->rxqcqs)
+		goto err_out_free_tx_stats;
+	for (i = 0; i < lif->nxqs; i++) {
+		lif->rxqcqs[i].stats = devm_kzalloc(dev,
+						    sizeof(struct ionic_q_stats),
+						    GFP_KERNEL);
+		if (!lif->rxqcqs[i].stats)
+			goto err_out_free_rx_stats;
+	}
+
 	return 0;
 
+err_out_free_rx_stats:
+	for (i = 0; i < lif->nxqs; i++)
+		if (lif->rxqcqs[i].stats)
+			devm_kfree(dev, lif->rxqcqs[i].stats);
+	devm_kfree(dev, lif->rxqcqs);
+	lif->rxqcqs = NULL;
+err_out_free_tx_stats:
+	for (i = 0; i < lif->nxqs; i++)
+		if (lif->txqcqs[i].stats)
+			devm_kfree(dev, lif->txqcqs[i].stats);
+	devm_kfree(dev, lif->txqcqs);
+	lif->txqcqs = NULL;
+err_out_free_notifyqcq:
+	if (lif->notifyqcq) {
+		ionic_qcq_free(lif, lif->notifyqcq);
+		lif->notifyqcq = NULL;
+	}
 err_out_free_adminqcq:
 	ionic_qcq_free(lif, lif->adminqcq);
 	lif->adminqcq = NULL;
@@ -409,6 +548,107 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 	return err;
 }
 
+static int ionic_lif_txq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
+{
+	struct device *dev = lif->ionic->dev;
+	struct ionic_queue *q = &qcq->q;
+	struct ionic_cq *cq = &qcq->cq;
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.q_init = {
+			.opcode = IONIC_CMD_Q_INIT,
+			.lif_index = cpu_to_le16(lif->index),
+			.type = q->type,
+			.index = cpu_to_le32(q->index),
+			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ |
+					     IONIC_QINIT_F_SG),
+			.intr_index = cpu_to_le16(lif->rxqcqs[q->index].qcq->intr.index),
+			.pid = cpu_to_le16(q->pid),
+			.ring_size = ilog2(q->num_descs),
+			.ring_base = cpu_to_le64(q->base_pa),
+			.cq_ring_base = cpu_to_le64(cq->base_pa),
+			.sg_ring_base = cpu_to_le64(q->sg_base_pa),
+		},
+	};
+	int err;
+
+	dev_dbg(dev, "txq_init.pid %d\n", ctx.cmd.q_init.pid);
+	dev_dbg(dev, "txq_init.index %d\n", ctx.cmd.q_init.index);
+	dev_dbg(dev, "txq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
+	dev_dbg(dev, "txq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	q->hw_type = ctx.comp.q_init.hw_type;
+	q->hw_index = le32_to_cpu(ctx.comp.q_init.hw_index);
+	q->dbval = IONIC_DBELL_QID(q->hw_index);
+
+	dev_dbg(dev, "txq->hw_type %d\n", q->hw_type);
+	dev_dbg(dev, "txq->hw_index %d\n", q->hw_index);
+
+	qcq->flags |= IONIC_QCQ_F_INITED;
+
+	ionic_debugfs_add_qcq(lif, qcq);
+
+	return 0;
+}
+
+static int ionic_lif_rxq_init(struct ionic_lif *lif, struct ionic_qcq *qcq)
+{
+	struct device *dev = lif->ionic->dev;
+	struct ionic_queue *q = &qcq->q;
+	struct ionic_cq *cq = &qcq->cq;
+	struct ionic_admin_ctx ctx = {
+		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
+		.cmd.q_init = {
+			.opcode = IONIC_CMD_Q_INIT,
+			.lif_index = cpu_to_le16(lif->index),
+			.type = q->type,
+			.index = cpu_to_le32(q->index),
+			.flags = cpu_to_le16(IONIC_QINIT_F_IRQ),
+			.intr_index = cpu_to_le16(cq->bound_intr->index),
+			.pid = cpu_to_le16(q->pid),
+			.ring_size = ilog2(q->num_descs),
+			.ring_base = cpu_to_le64(q->base_pa),
+			.cq_ring_base = cpu_to_le64(cq->base_pa),
+		},
+	};
+	int err;
+
+	dev_dbg(dev, "rxq_init.pid %d\n", ctx.cmd.q_init.pid);
+	dev_dbg(dev, "rxq_init.index %d\n", ctx.cmd.q_init.index);
+	dev_dbg(dev, "rxq_init.ring_base 0x%llx\n", ctx.cmd.q_init.ring_base);
+	dev_dbg(dev, "rxq_init.ring_size %d\n", ctx.cmd.q_init.ring_size);
+
+	err = ionic_adminq_post_wait(lif, &ctx);
+	if (err)
+		return err;
+
+	q->hw_type = ctx.comp.q_init.hw_type;
+	q->hw_index = le32_to_cpu(ctx.comp.q_init.hw_index);
+	q->dbval = IONIC_DBELL_QID(q->hw_index);
+
+	dev_dbg(dev, "rxq->hw_type %d\n", q->hw_type);
+	dev_dbg(dev, "rxq->hw_index %d\n", q->hw_index);
+
+	netif_napi_add(lif->netdev, &qcq->napi, ionic_rx_napi,
+		       NAPI_POLL_WEIGHT);
+
+	err = ionic_request_irq(lif, qcq);
+	if (err) {
+		netif_napi_del(&qcq->napi);
+		return err;
+	}
+
+	qcq->flags |= IONIC_QCQ_F_INITED;
+
+	ionic_debugfs_add_qcq(lif, qcq);
+
+	return 0;
+}
+
 static bool ionic_notifyq_service(struct ionic_cq *cq,
 				  struct ionic_cq_info *cq_info)
 {
@@ -1074,17 +1314,180 @@ static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
 	return ionic_adminq_post_wait(lif, &ctx);
 }
 
+static void ionic_txrx_disable(struct ionic_lif *lif)
+{
+	unsigned int i;
+
+	for (i = 0; i < lif->nxqs; i++) {
+		ionic_qcq_disable(lif->txqcqs[i].qcq);
+		ionic_qcq_disable(lif->rxqcqs[i].qcq);
+	}
+}
+
+static void ionic_txrx_deinit(struct ionic_lif *lif)
+{
+	unsigned int i;
+
+	for (i = 0; i < lif->nxqs; i++) {
+		ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
+		ionic_tx_flush(&lif->txqcqs[i].qcq->cq);
+
+		ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
+		ionic_rx_flush(&lif->rxqcqs[i].qcq->cq);
+		ionic_rx_empty(&lif->rxqcqs[i].qcq->q);
+	}
+}
+
+static void ionic_txrx_free(struct ionic_lif *lif)
+{
+	unsigned int i;
+
+	for (i = 0; i < lif->nxqs; i++) {
+		ionic_qcq_free(lif, lif->txqcqs[i].qcq);
+		lif->txqcqs[i].qcq = NULL;
+
+		ionic_qcq_free(lif, lif->rxqcqs[i].qcq);
+		lif->rxqcqs[i].qcq = NULL;
+	}
+}
+
+static int ionic_txrx_alloc(struct ionic_lif *lif)
+{
+	unsigned int flags;
+	unsigned int i;
+	int err = 0;
+
+	flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
+	for (i = 0; i < lif->nxqs; i++) {
+		err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
+				      lif->ntxq_descs,
+				      sizeof(struct ionic_txq_desc),
+				      sizeof(struct ionic_txq_comp),
+				      sizeof(struct ionic_txq_sg_desc),
+				      lif->kern_pid, &lif->txqcqs[i].qcq);
+		if (err)
+			goto err_out;
+
+		lif->txqcqs[i].qcq->stats = lif->txqcqs[i].stats;
+	}
+
+	flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_INTR;
+	for (i = 0; i < lif->nxqs; i++) {
+		err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
+				      lif->nrxq_descs,
+				      sizeof(struct ionic_rxq_desc),
+				      sizeof(struct ionic_rxq_comp),
+				      0, lif->kern_pid, &lif->rxqcqs[i].qcq);
+		if (err)
+			goto err_out;
+
+		lif->rxqcqs[i].qcq->stats = lif->rxqcqs[i].stats;
+
+		ionic_link_qcq_interrupts(lif->rxqcqs[i].qcq,
+					  lif->txqcqs[i].qcq);
+	}
+
+	return 0;
+
+err_out:
+	ionic_txrx_free(lif);
+
+	return err;
+}
+
+static int ionic_txrx_init(struct ionic_lif *lif)
+{
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < lif->nxqs; i++) {
+		err = ionic_lif_txq_init(lif, lif->txqcqs[i].qcq);
+		if (err)
+			goto err_out;
+
+		err = ionic_lif_rxq_init(lif, lif->rxqcqs[i].qcq);
+		if (err) {
+			ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
+			goto err_out;
+		}
+	}
+
+	ionic_set_rx_mode(lif->netdev);
+
+	return 0;
+
+err_out:
+	while (i--) {
+		ionic_lif_qcq_deinit(lif, lif->txqcqs[i].qcq);
+		ionic_lif_qcq_deinit(lif, lif->rxqcqs[i].qcq);
+	}
+
+	return err;
+}
+
+static int ionic_txrx_enable(struct ionic_lif *lif)
+{
+	int i, err;
+
+	for (i = 0; i < lif->nxqs; i++) {
+		err = ionic_qcq_enable(lif->txqcqs[i].qcq);
+		if (err)
+			goto err_out;
+
+		ionic_rx_fill(&lif->rxqcqs[i].qcq->q);
+		err = ionic_qcq_enable(lif->rxqcqs[i].qcq);
+		if (err) {
+			ionic_qcq_disable(lif->txqcqs[i].qcq);
+			goto err_out;
+		}
+	}
+
+	return 0;
+
+err_out:
+	while (i--) {
+		ionic_qcq_disable(lif->rxqcqs[i].qcq);
+		ionic_qcq_disable(lif->txqcqs[i].qcq);
+	}
+
+	return err;
+}
+
 int ionic_open(struct net_device *netdev)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	int err;
 
 	netif_carrier_off(netdev);
 
+	err = ionic_txrx_alloc(lif);
+	if (err)
+		return err;
+
+	err = ionic_txrx_init(lif);
+	if (err)
+		goto err_txrx_free;
+
+	err = ionic_txrx_enable(lif);
+	if (err)
+		goto err_txrx_deinit;
+
+	netif_set_real_num_tx_queues(netdev, lif->nxqs);
+	netif_set_real_num_rx_queues(netdev, lif->nxqs);
+
 	set_bit(IONIC_LIF_UP, lif->state);
 
 	ionic_link_status_check_request(lif);
+	if (netif_carrier_ok(netdev))
+		netif_tx_wake_all_queues(netdev);
 
 	return 0;
+
+err_txrx_deinit:
+	ionic_txrx_deinit(lif);
+err_txrx_free:
+	ionic_txrx_free(lif);
+	return err;
 }
 
 int ionic_stop(struct net_device *netdev)
@@ -1102,6 +1505,12 @@ int ionic_stop(struct net_device *netdev)
 
 	/* carrier off before disabling queues to avoid watchdog timeout */
 	netif_carrier_off(netdev);
+	netif_tx_stop_all_queues(netdev);
+	netif_tx_disable(netdev);
+
+	ionic_txrx_disable(lif);
+	ionic_txrx_deinit(lif);
+	ionic_txrx_free(lif);
 
 	return err;
 }
@@ -1109,6 +1518,7 @@ int ionic_stop(struct net_device *netdev)
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
+	.ndo_start_xmit		= ionic_start_xmit,
 	.ndo_get_stats64	= ionic_get_stats64,
 	.ndo_set_rx_mode	= ionic_set_rx_mode,
 	.ndo_set_features	= ionic_set_features,
@@ -1173,6 +1583,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 
 	lif->ionic = ionic;
 	lif->index = index;
+	lif->ntxq_descs = IONIC_DEF_TXRX_DESC;
+	lif->nrxq_descs = IONIC_DEF_TXRX_DESC;
 
 	snprintf(lif->name, sizeof(lif->name), "lif%u", index);
 
@@ -1499,6 +1911,8 @@ static int ionic_lif_init(struct ionic_lif *lif)
 	if (err)
 		goto err_out_notifyq_deinit;
 
+	lif->rx_copybreak = IONIC_RX_COPYBREAK_DEFAULT;
+
 	set_bit(IONIC_LIF_INITED, lif->state);
 
 	return 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 5e6c64a73b86..db6d5e016607 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -12,20 +12,38 @@
 
 #define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
 #define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS + 1)
+#define IONIC_RX_COPYBREAK_DEFAULT		256
 
 struct ionic_tx_stats {
+	u64 dma_map_err;
 	u64 pkts;
 	u64 bytes;
+	u64 clean;
+	u64 linearize;
+	u64 no_csum;
+	u64 csum;
+	u64 crc32_csum;
+	u64 tso;
+	u64 frags;
+	u64 sg_cntr[IONIC_MAX_NUM_SG_CNTR];
 };
 
 struct ionic_rx_stats {
+	u64 dma_map_err;
+	u64 alloc_err;
 	u64 pkts;
 	u64 bytes;
+	u64 csum_none;
+	u64 csum_complete;
+	u64 csum_error;
+	u64 buffers_posted;
 };
 
 #define IONIC_QCQ_F_INITED		BIT(0)
 #define IONIC_QCQ_F_SG			BIT(1)
 #define IONIC_QCQ_F_INTR		BIT(2)
+#define IONIC_QCQ_F_TX_STATS		BIT(3)
+#define IONIC_QCQ_F_RX_STATS		BIT(4)
 #define IONIC_QCQ_F_NOTIFYQ		BIT(5)
 
 struct ionic_napi_stats {
@@ -54,7 +72,14 @@ struct ionic_qcq {
 	struct dentry *dentry;
 };
 
+struct ionic_qcqst {
+	struct ionic_qcq *qcq;
+	struct ionic_q_stats *stats;
+};
+
 #define q_to_qcq(q)		container_of(q, struct ionic_qcq, q)
+#define q_to_tx_stats(q)	(&q_to_qcq(q)->stats->tx)
+#define q_to_rx_stats(q)	(&q_to_qcq(q)->stats->rx)
 #define napi_to_qcq(napi)	container_of(napi, struct ionic_qcq, napi)
 #define napi_to_cq(napi)	(&napi_to_qcq(napi)->cq)
 
@@ -106,11 +131,14 @@ struct ionic_lif {
 	spinlock_t adminq_lock;		/* lock for AdminQ operations */
 	struct ionic_qcq *adminqcq;
 	struct ionic_qcq *notifyqcq;
+	struct ionic_qcqst *txqcqs;
+	struct ionic_qcqst *rxqcqs;
 	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
 	unsigned int ntxq_descs;
 	unsigned int nrxq_descs;
+	u32 rx_copybreak;
 	unsigned int rx_mode;
 	u64 hw_features;
 	bool mc_overflow;
@@ -131,6 +159,11 @@ struct ionic_lif {
 	u32 flags;
 };
 
+#define lif_to_txqcq(lif, i)	((lif)->txqcqs[i].qcq)
+#define lif_to_rxqcq(lif, i)	((lif)->rxqcqs[i].qcq)
+#define lif_to_txq(lif, i)	(&lif_to_txqcq((lif), i)->q)
+#define lif_to_rxq(lif, i)	(&lif_to_txqcq((lif), i)->q)
+
 static inline int ionic_wait_for_bit(struct ionic_lif *lif, int bitname)
 {
 	unsigned long tlimit = jiffies + HZ;
@@ -156,6 +189,20 @@ int ionic_open(struct net_device *netdev);
 int ionic_stop(struct net_device *netdev);
 int ionic_reset_queues(struct ionic_lif *lif);
 
+static inline void debug_stats_txq_post(struct ionic_qcq *qcq,
+					struct ionic_txq_desc *desc, bool dbell)
+{
+	u8 num_sg_elems = ((le64_to_cpu(desc->cmd) >> IONIC_TXQ_DESC_NSGE_SHIFT)
+						& IONIC_TXQ_DESC_NSGE_MASK);
+
+	qcq->q.dbell_count += dbell;
+
+	if (num_sg_elems > (IONIC_MAX_NUM_SG_CNTR - 1))
+		num_sg_elems = IONIC_MAX_NUM_SG_CNTR - 1;
+
+	qcq->stats->tx.sg_cntr[num_sg_elems]++;
+}
+
 static inline void debug_stats_napi_poll(struct ionic_qcq *qcq,
 					 unsigned int work_done)
 {
@@ -168,7 +215,10 @@ static inline void debug_stats_napi_poll(struct ionic_qcq *qcq,
 }
 
 #define DEBUG_STATS_CQE_CNT(cq)		((cq)->compl_count++)
+#define DEBUG_STATS_RX_BUFF_CNT(qcq)	((qcq)->stats->rx.buffers_posted++)
 #define DEBUG_STATS_INTR_REARM(intr)	((intr)->rearm_count++)
+#define DEBUG_STATS_TXQ_POST(qcq, txdesc, dbell) \
+	debug_stats_txq_post(qcq, txdesc, dbell)
 #define DEBUG_STATS_NAPI_POLL(qcq, work_done) \
 	debug_stats_napi_poll(qcq, work_done)
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
new file mode 100644
index 000000000000..246a53786fda
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -0,0 +1,914 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/if_vlan.h>
+#include <net/ip6_checksum.h>
+
+#include "ionic.h"
+#include "ionic_lif.h"
+#include "ionic_txrx.h"
+
+static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_info,
+			   struct ionic_cq_info *cq_info, void *cb_arg);
+
+static inline void ionic_txq_post(struct ionic_queue *q, bool ring_dbell,
+				  ionic_desc_cb cb_func, void *cb_arg)
+{
+	DEBUG_STATS_TXQ_POST(q_to_qcq(q), q->head->desc, ring_dbell);
+
+	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
+}
+
+static inline void ionic_rxq_post(struct ionic_queue *q, bool ring_dbell,
+				  ionic_desc_cb cb_func, void *cb_arg)
+{
+	ionic_q_post(q, ring_dbell, cb_func, cb_arg);
+
+	DEBUG_STATS_RX_BUFF_CNT(q_to_qcq(q));
+}
+
+static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
+{
+	return netdev_get_tx_queue(q->lif->netdev, q->index);
+}
+
+static void ionic_rx_recycle(struct ionic_queue *q, struct ionic_desc_info *desc_info,
+			     struct sk_buff *skb)
+{
+	struct ionic_rxq_desc *old = desc_info->desc;
+	struct ionic_rxq_desc *new = q->head->desc;
+
+	new->addr = old->addr;
+	new->len = old->len;
+
+	ionic_rxq_post(q, true, ionic_rx_clean, skb);
+}
+
+static bool ionic_rx_copybreak(struct ionic_queue *q, struct ionic_desc_info *desc_info,
+			       struct ionic_cq_info *cq_info, struct sk_buff **skb)
+{
+	struct ionic_rxq_comp *comp = cq_info->cq_desc;
+	struct ionic_rxq_desc *desc = desc_info->desc;
+	struct net_device *netdev = q->lif->netdev;
+	struct device *dev = q->lif->ionic->dev;
+	struct sk_buff *new_skb;
+	u16 clen, dlen;
+
+	clen = le16_to_cpu(comp->len);
+	dlen = le16_to_cpu(desc->len);
+	if (clen > q->lif->rx_copybreak) {
+		dma_unmap_single(dev, (dma_addr_t)le64_to_cpu(desc->addr),
+				 dlen, DMA_FROM_DEVICE);
+		return false;
+	}
+
+	new_skb = netdev_alloc_skb_ip_align(netdev, clen);
+	if (!new_skb) {
+		dma_unmap_single(dev, (dma_addr_t)le64_to_cpu(desc->addr),
+				 dlen, DMA_FROM_DEVICE);
+		return false;
+	}
+
+	dma_sync_single_for_cpu(dev, (dma_addr_t)le64_to_cpu(desc->addr),
+				clen, DMA_FROM_DEVICE);
+
+	memcpy(new_skb->data, (*skb)->data, clen);
+
+	ionic_rx_recycle(q, desc_info, *skb);
+	*skb = new_skb;
+
+	return true;
+}
+
+static void ionic_rx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_info,
+			   struct ionic_cq_info *cq_info, void *cb_arg)
+{
+	struct ionic_rxq_comp *comp = cq_info->cq_desc;
+	struct ionic_qcq *qcq = q_to_qcq(q);
+	struct sk_buff *skb = cb_arg;
+	struct ionic_rx_stats *stats;
+	struct net_device *netdev;
+
+	stats = q_to_rx_stats(q);
+	netdev = q->lif->netdev;
+
+	if (comp->status) {
+		ionic_rx_recycle(q, desc_info, skb);
+		return;
+	}
+
+	if (unlikely(test_bit(IONIC_LIF_QUEUE_RESET, q->lif->state))) {
+		/* no packet processing while resetting */
+		ionic_rx_recycle(q, desc_info, skb);
+		return;
+	}
+
+	stats->pkts++;
+	stats->bytes += le16_to_cpu(comp->len);
+
+	ionic_rx_copybreak(q, desc_info, cq_info, &skb);
+
+	skb_put(skb, le16_to_cpu(comp->len));
+	skb->protocol = eth_type_trans(skb, netdev);
+
+	skb_record_rx_queue(skb, q->index);
+
+	if (netdev->features & NETIF_F_RXHASH) {
+		switch (comp->pkt_type_color & IONIC_RXQ_COMP_PKT_TYPE_MASK) {
+		case IONIC_PKT_TYPE_IPV4:
+		case IONIC_PKT_TYPE_IPV6:
+			skb_set_hash(skb, le32_to_cpu(comp->rss_hash),
+				     PKT_HASH_TYPE_L3);
+			break;
+		case IONIC_PKT_TYPE_IPV4_TCP:
+		case IONIC_PKT_TYPE_IPV6_TCP:
+		case IONIC_PKT_TYPE_IPV4_UDP:
+		case IONIC_PKT_TYPE_IPV6_UDP:
+			skb_set_hash(skb, le32_to_cpu(comp->rss_hash),
+				     PKT_HASH_TYPE_L4);
+			break;
+		}
+	}
+
+	if (netdev->features & NETIF_F_RXCSUM) {
+		if (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_CALC) {
+			skb->ip_summed = CHECKSUM_COMPLETE;
+			skb->csum = (__wsum)le16_to_cpu(comp->csum);
+			stats->csum_complete++;
+		}
+	} else {
+		stats->csum_none++;
+	}
+
+	if ((comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_TCP_BAD) ||
+	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_UDP_BAD) ||
+	    (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_IP_BAD))
+		stats->csum_error++;
+
+	if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
+		if (comp->csum_flags & IONIC_RXQ_COMP_CSUM_F_VLAN)
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+					       le16_to_cpu(comp->vlan_tci));
+	}
+
+	napi_gro_receive(&qcq->napi, skb);
+}
+
+static bool ionic_rx_service(struct ionic_cq *cq, struct ionic_cq_info *cq_info)
+{
+	struct ionic_rxq_comp *comp = cq_info->cq_desc;
+	struct ionic_queue *q = cq->bound_q;
+	struct ionic_desc_info *desc_info;
+
+	if (!color_match(comp->pkt_type_color, cq->done_color))
+		return false;
+
+	/* check for empty queue */
+	if (q->tail->index == q->head->index)
+		return false;
+
+	desc_info = q->tail;
+	if (desc_info->index != le16_to_cpu(comp->comp_index))
+		return false;
+
+	q->tail = desc_info->next;
+
+	/* clean the related q entry, only one per qc completion */
+	ionic_rx_clean(q, desc_info, cq_info, desc_info->cb_arg);
+
+	desc_info->cb = NULL;
+	desc_info->cb_arg = NULL;
+
+	return true;
+}
+
+static u32 ionic_rx_walk_cq(struct ionic_cq *rxcq, u32 limit)
+{
+	u32 work_done = 0;
+
+	while (ionic_rx_service(rxcq, rxcq->tail)) {
+		if (rxcq->tail->last)
+			rxcq->done_color = !rxcq->done_color;
+		rxcq->tail = rxcq->tail->next;
+		DEBUG_STATS_CQE_CNT(rxcq);
+
+		if (++work_done >= limit)
+			break;
+	}
+
+	return work_done;
+}
+
+void ionic_rx_flush(struct ionic_cq *cq)
+{
+	struct ionic_dev *idev = &cq->lif->ionic->idev;
+	u32 work_done;
+
+	work_done = ionic_rx_walk_cq(cq, cq->num_descs);
+
+	if (work_done)
+		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
+				   work_done, IONIC_INTR_CRED_RESET_COALESCE);
+}
+
+static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q, unsigned int len,
+					  dma_addr_t *dma_addr)
+{
+	struct ionic_lif *lif = q->lif;
+	struct ionic_rx_stats *stats;
+	struct net_device *netdev;
+	struct sk_buff *skb;
+	struct device *dev;
+
+	netdev = lif->netdev;
+	dev = lif->ionic->dev;
+	stats = q_to_rx_stats(q);
+	skb = netdev_alloc_skb_ip_align(netdev, len);
+	if (!skb) {
+		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
+				     netdev->name, q->name);
+		stats->alloc_err++;
+		return NULL;
+	}
+
+	*dma_addr = dma_map_single(dev, skb->data, len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, *dma_addr)) {
+		dev_kfree_skb(skb);
+		net_warn_ratelimited("%s: DMA single map failed on %s!\n",
+				     netdev->name, q->name);
+		stats->dma_map_err++;
+		return NULL;
+	}
+
+	return skb;
+}
+
+#define IONIC_RX_RING_DOORBELL_STRIDE		((1 << 2) - 1)
+
+void ionic_rx_fill(struct ionic_queue *q)
+{
+	struct net_device *netdev = q->lif->netdev;
+	struct ionic_rxq_desc *desc;
+	struct sk_buff *skb;
+	dma_addr_t dma_addr;
+	bool ring_doorbell;
+	unsigned int len;
+	unsigned int i;
+
+	len = netdev->mtu + ETH_HLEN;
+
+	for (i = ionic_q_space_avail(q); i; i--) {
+		skb = ionic_rx_skb_alloc(q, len, &dma_addr);
+		if (!skb)
+			return;
+
+		desc = q->head->desc;
+		desc->addr = cpu_to_le64(dma_addr);
+		desc->len = cpu_to_le16(len);
+		desc->opcode = IONIC_RXQ_DESC_OPCODE_SIMPLE;
+
+		ring_doorbell = ((q->head->index + 1) &
+				IONIC_RX_RING_DOORBELL_STRIDE) == 0;
+
+		ionic_rxq_post(q, ring_doorbell, ionic_rx_clean, skb);
+	}
+}
+
+static void ionic_rx_fill_cb(void *arg)
+{
+	ionic_rx_fill(arg);
+}
+
+void ionic_rx_empty(struct ionic_queue *q)
+{
+	struct device *dev = q->lif->ionic->dev;
+	struct ionic_desc_info *cur;
+	struct ionic_rxq_desc *desc;
+
+	for (cur = q->tail; cur != q->head; cur = cur->next) {
+		desc = cur->desc;
+
+		dma_unmap_single(dev, le64_to_cpu(desc->addr),
+				 le16_to_cpu(desc->len), DMA_FROM_DEVICE);
+		dev_kfree_skb(cur->cb_arg);
+
+		cur->cb_arg = NULL;
+	}
+}
+
+int ionic_rx_napi(struct napi_struct *napi, int budget)
+{
+	struct ionic_qcq *qcq = napi_to_qcq(napi);
+	struct ionic_cq *rxcq = napi_to_cq(napi);
+	unsigned int qi = rxcq->bound_q->index;
+	struct ionic_dev *idev;
+	struct ionic_lif *lif;
+	struct ionic_cq *txcq;
+	u32 work_done = 0;
+	u32 flags = 0;
+
+	lif = rxcq->bound_q->lif;
+	idev = &lif->ionic->idev;
+	txcq = &lif->txqcqs[qi].qcq->cq;
+
+	ionic_tx_flush(txcq);
+
+	work_done = ionic_rx_walk_cq(rxcq, budget);
+
+	if (work_done)
+		ionic_rx_fill_cb(rxcq->bound_q);
+
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		flags |= IONIC_INTR_CRED_UNMASK;
+		DEBUG_STATS_INTR_REARM(rxcq->bound_intr);
+	}
+
+	if (work_done || flags) {
+		flags |= IONIC_INTR_CRED_RESET_COALESCE;
+		ionic_intr_credits(idev->intr_ctrl, rxcq->bound_intr->index,
+				   work_done, flags);
+	}
+
+	DEBUG_STATS_NAPI_POLL(qcq, work_done);
+
+	return work_done;
+}
+
+static dma_addr_t ionic_tx_map_single(struct ionic_queue *q, void *data, size_t len)
+{
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	struct device *dev = q->lif->ionic->dev;
+	dma_addr_t dma_addr;
+
+	dma_addr = dma_map_single(dev, data, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, dma_addr)) {
+		net_warn_ratelimited("%s: DMA single map failed on %s!\n",
+				     q->lif->netdev->name, q->name);
+		stats->dma_map_err++;
+		return 0;
+	}
+	return dma_addr;
+}
+
+static dma_addr_t ionic_tx_map_frag(struct ionic_queue *q, const skb_frag_t *frag,
+				    size_t offset, size_t len)
+{
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	struct device *dev = q->lif->ionic->dev;
+	dma_addr_t dma_addr;
+
+	dma_addr = skb_frag_dma_map(dev, frag, offset, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, dma_addr)) {
+		net_warn_ratelimited("%s: DMA frag map failed on %s!\n",
+				     q->lif->netdev->name, q->name);
+		stats->dma_map_err++;
+	}
+	return dma_addr;
+}
+
+static void ionic_tx_clean(struct ionic_queue *q, struct ionic_desc_info *desc_info,
+			   struct ionic_cq_info *cq_info, void *cb_arg)
+{
+	struct ionic_txq_sg_desc *sg_desc = desc_info->sg_desc;
+	struct ionic_txq_sg_elem *elem = sg_desc->elems;
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	struct ionic_txq_desc *desc = desc_info->desc;
+	struct device *dev = q->lif->ionic->dev;
+	u8 opcode, flags, nsge;
+	u16 queue_index;
+	unsigned int i;
+	u64 addr;
+
+	decode_txq_desc_cmd(le64_to_cpu(desc->cmd),
+			    &opcode, &flags, &nsge, &addr);
+
+	/* use unmap_single only if either this is not TSO,
+	 * or this is first descriptor of a TSO
+	 */
+	if (opcode != IONIC_TXQ_DESC_OPCODE_TSO ||
+	    flags & IONIC_TXQ_DESC_FLAG_TSO_SOT)
+		dma_unmap_single(dev, (dma_addr_t)addr,
+				 le16_to_cpu(desc->len), DMA_TO_DEVICE);
+	else
+		dma_unmap_page(dev, (dma_addr_t)addr,
+			       le16_to_cpu(desc->len), DMA_TO_DEVICE);
+
+	for (i = 0; i < nsge; i++, elem++)
+		dma_unmap_page(dev, (dma_addr_t)le64_to_cpu(elem->addr),
+			       le16_to_cpu(elem->len), DMA_TO_DEVICE);
+
+	if (cb_arg) {
+		struct sk_buff *skb = cb_arg;
+		u32 len = skb->len;
+
+		queue_index = skb_get_queue_mapping(skb);
+		if (unlikely(__netif_subqueue_stopped(q->lif->netdev,
+						      queue_index))) {
+			netif_wake_subqueue(q->lif->netdev, queue_index);
+			q->wake++;
+		}
+		dev_kfree_skb_any(skb);
+		stats->clean++;
+		netdev_tx_completed_queue(q_to_ndq(q), 1, len);
+	}
+}
+
+void ionic_tx_flush(struct ionic_cq *cq)
+{
+	struct ionic_txq_comp *comp = cq->tail->cq_desc;
+	struct ionic_dev *idev = &cq->lif->ionic->idev;
+	struct ionic_queue *q = cq->bound_q;
+	struct ionic_desc_info *desc_info;
+	unsigned int work_done = 0;
+
+	/* walk the completed cq entries */
+	while (work_done < cq->num_descs &&
+	       color_match(comp->color, cq->done_color)) {
+
+		/* clean the related q entries, there could be
+		 * several q entries completed for each cq completion
+		 */
+		do {
+			desc_info = q->tail;
+			q->tail = desc_info->next;
+			ionic_tx_clean(q, desc_info, cq->tail,
+				       desc_info->cb_arg);
+			desc_info->cb = NULL;
+			desc_info->cb_arg = NULL;
+		} while (desc_info->index != le16_to_cpu(comp->comp_index));
+
+		if (cq->tail->last)
+			cq->done_color = !cq->done_color;
+
+		cq->tail = cq->tail->next;
+		comp = cq->tail->cq_desc;
+		DEBUG_STATS_CQE_CNT(cq);
+
+		work_done++;
+	}
+
+	if (work_done)
+		ionic_intr_credits(idev->intr_ctrl, cq->bound_intr->index,
+				   work_done, 0);
+}
+
+static int ionic_tx_tcp_inner_pseudo_csum(struct sk_buff *skb)
+{
+	int err;
+
+	err = skb_cow_head(skb, 0);
+	if (err)
+		return err;
+
+	if (skb->protocol == cpu_to_be16(ETH_P_IP)) {
+		inner_ip_hdr(skb)->check = 0;
+		inner_tcp_hdr(skb)->check =
+			~csum_tcpudp_magic(inner_ip_hdr(skb)->saddr,
+					   inner_ip_hdr(skb)->daddr,
+					   0, IPPROTO_TCP, 0);
+	} else if (skb->protocol == cpu_to_be16(ETH_P_IPV6)) {
+		inner_tcp_hdr(skb)->check =
+			~csum_ipv6_magic(&inner_ipv6_hdr(skb)->saddr,
+					 &inner_ipv6_hdr(skb)->daddr,
+					 0, IPPROTO_TCP, 0);
+	}
+
+	return 0;
+}
+
+static int ionic_tx_tcp_pseudo_csum(struct sk_buff *skb)
+{
+	int err;
+
+	err = skb_cow_head(skb, 0);
+	if (err)
+		return err;
+
+	if (skb->protocol == cpu_to_be16(ETH_P_IP)) {
+		ip_hdr(skb)->check = 0;
+		tcp_hdr(skb)->check =
+			~csum_tcpudp_magic(ip_hdr(skb)->saddr,
+					   ip_hdr(skb)->daddr,
+					   0, IPPROTO_TCP, 0);
+	} else if (skb->protocol == cpu_to_be16(ETH_P_IPV6)) {
+		tcp_hdr(skb)->check =
+			~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+					 &ipv6_hdr(skb)->daddr,
+					 0, IPPROTO_TCP, 0);
+	}
+
+	return 0;
+}
+
+static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc,
+			      struct sk_buff *skb,
+			      dma_addr_t addr, u8 nsge, u16 len,
+			      unsigned int hdrlen, unsigned int mss,
+			      bool outer_csum,
+			      u16 vlan_tci, bool has_vlan,
+			      bool start, bool done)
+{
+	u8 flags = 0;
+	u64 cmd;
+
+	flags |= has_vlan ? IONIC_TXQ_DESC_FLAG_VLAN : 0;
+	flags |= outer_csum ? IONIC_TXQ_DESC_FLAG_ENCAP : 0;
+	flags |= start ? IONIC_TXQ_DESC_FLAG_TSO_SOT : 0;
+	flags |= done ? IONIC_TXQ_DESC_FLAG_TSO_EOT : 0;
+
+	cmd = encode_txq_desc_cmd(IONIC_TXQ_DESC_OPCODE_TSO, flags, nsge, addr);
+	desc->cmd = cpu_to_le64(cmd);
+	desc->len = cpu_to_le16(len);
+	desc->vlan_tci = cpu_to_le16(vlan_tci);
+	desc->hdr_len = cpu_to_le16(hdrlen);
+	desc->mss = cpu_to_le16(mss);
+
+	if (done) {
+		skb_tx_timestamp(skb);
+		netdev_tx_sent_queue(q_to_ndq(q), skb->len);
+		ionic_txq_post(q, !netdev_xmit_more(), ionic_tx_clean, skb);
+	} else {
+		ionic_txq_post(q, false, ionic_tx_clean, NULL);
+	}
+}
+
+static struct ionic_txq_desc *ionic_tx_tso_next(struct ionic_queue *q,
+						struct ionic_txq_sg_elem **elem)
+{
+	struct ionic_txq_sg_desc *sg_desc = q->head->sg_desc;
+	struct ionic_txq_desc *desc = q->head->desc;
+
+	*elem = sg_desc->elems;
+	return desc;
+}
+
+static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
+{
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	struct ionic_desc_info *abort = q->head;
+	struct device *dev = q->lif->ionic->dev;
+	struct ionic_desc_info *rewind = abort;
+	struct ionic_txq_sg_elem *elem;
+	struct ionic_txq_desc *desc;
+	unsigned int frag_left = 0;
+	unsigned int offset = 0;
+	unsigned int len_left;
+	dma_addr_t desc_addr;
+	unsigned int hdrlen;
+	unsigned int nfrags;
+	unsigned int seglen;
+	u64 total_bytes = 0;
+	u64 total_pkts = 0;
+	unsigned int left;
+	unsigned int len;
+	unsigned int mss;
+	skb_frag_t *frag;
+	bool start, done;
+	bool outer_csum;
+	bool has_vlan;
+	u16 desc_len;
+	u8 desc_nsge;
+	u16 vlan_tci;
+	bool encap;
+	int err;
+
+	mss = skb_shinfo(skb)->gso_size;
+	nfrags = skb_shinfo(skb)->nr_frags;
+	len_left = skb->len - skb_headlen(skb);
+	outer_csum = (skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM) ||
+		     (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM);
+	has_vlan = !!skb_vlan_tag_present(skb);
+	vlan_tci = skb_vlan_tag_get(skb);
+	encap = skb->encapsulation;
+
+	/* Preload inner-most TCP csum field with IP pseudo hdr
+	 * calculated with IP length set to zero.  HW will later
+	 * add in length to each TCP segment resulting from the TSO.
+	 */
+
+	if (encap)
+		err = ionic_tx_tcp_inner_pseudo_csum(skb);
+	else
+		err = ionic_tx_tcp_pseudo_csum(skb);
+	if (err)
+		return err;
+
+	if (encap)
+		hdrlen = skb_inner_transport_header(skb) - skb->data +
+			 inner_tcp_hdrlen(skb);
+	else
+		hdrlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
+
+	seglen = hdrlen + mss;
+	left = skb_headlen(skb);
+
+	desc = ionic_tx_tso_next(q, &elem);
+	start = true;
+
+	/* Chop skb->data up into desc segments */
+
+	while (left > 0) {
+		len = min(seglen, left);
+		frag_left = seglen - len;
+		desc_addr = ionic_tx_map_single(q, skb->data + offset, len);
+		if (dma_mapping_error(dev, desc_addr))
+			goto err_out_abort;
+		desc_len = len;
+		desc_nsge = 0;
+		left -= len;
+		offset += len;
+		if (nfrags > 0 && frag_left > 0)
+			continue;
+		done = (nfrags == 0 && left == 0);
+		ionic_tx_tso_post(q, desc, skb,
+				  desc_addr, desc_nsge, desc_len,
+				  hdrlen, mss,
+				  outer_csum,
+				  vlan_tci, has_vlan,
+				  start, done);
+		total_pkts++;
+		total_bytes += start ? len : len + hdrlen;
+		desc = ionic_tx_tso_next(q, &elem);
+		start = false;
+		seglen = mss;
+	}
+
+	/* Chop skb frags into desc segments */
+
+	for (frag = skb_shinfo(skb)->frags; len_left; frag++) {
+		offset = 0;
+		left = skb_frag_size(frag);
+		len_left -= left;
+		nfrags--;
+		stats->frags++;
+
+		while (left > 0) {
+			if (frag_left > 0) {
+				len = min(frag_left, left);
+				frag_left -= len;
+				elem->addr =
+				    cpu_to_le64(ionic_tx_map_frag(q, frag,
+								  offset, len));
+				if (dma_mapping_error(dev, elem->addr))
+					goto err_out_abort;
+				elem->len = cpu_to_le16(len);
+				elem++;
+				desc_nsge++;
+				left -= len;
+				offset += len;
+				if (nfrags > 0 && frag_left > 0)
+					continue;
+				done = (nfrags == 0 && left == 0);
+				ionic_tx_tso_post(q, desc, skb, desc_addr,
+						  desc_nsge, desc_len,
+						  hdrlen, mss, outer_csum,
+						  vlan_tci, has_vlan,
+						  start, done);
+				total_pkts++;
+				total_bytes += start ? len : len + hdrlen;
+				desc = ionic_tx_tso_next(q, &elem);
+				start = false;
+			} else {
+				len = min(mss, left);
+				frag_left = mss - len;
+				desc_addr = ionic_tx_map_frag(q, frag,
+							      offset, len);
+				if (dma_mapping_error(dev, desc_addr))
+					goto err_out_abort;
+				desc_len = len;
+				desc_nsge = 0;
+				left -= len;
+				offset += len;
+				if (nfrags > 0 && frag_left > 0)
+					continue;
+				done = (nfrags == 0 && left == 0);
+				ionic_tx_tso_post(q, desc, skb, desc_addr,
+						  desc_nsge, desc_len,
+						  hdrlen, mss, outer_csum,
+						  vlan_tci, has_vlan,
+						  start, done);
+				total_pkts++;
+				total_bytes += start ? len : len + hdrlen;
+				desc = ionic_tx_tso_next(q, &elem);
+				start = false;
+			}
+		}
+	}
+
+	stats->pkts += total_pkts;
+	stats->bytes += total_bytes;
+	stats->tso++;
+
+	return 0;
+
+err_out_abort:
+	while (rewind->desc != q->head->desc) {
+		ionic_tx_clean(q, rewind, NULL, NULL);
+		rewind = rewind->next;
+	}
+	q->head = abort;
+
+	return -ENOMEM;
+}
+
+static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
+{
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	struct ionic_txq_desc *desc = q->head->desc;
+	struct device *dev = q->lif->ionic->dev;
+	dma_addr_t dma_addr;
+	bool has_vlan;
+	u8 flags = 0;
+	bool encap;
+	u64 cmd;
+
+	has_vlan = !!skb_vlan_tag_present(skb);
+	encap = skb->encapsulation;
+
+	dma_addr = ionic_tx_map_single(q, skb->data, skb_headlen(skb));
+	if (dma_mapping_error(dev, dma_addr))
+		return -ENOMEM;
+
+	flags |= has_vlan ? IONIC_TXQ_DESC_FLAG_VLAN : 0;
+	flags |= encap ? IONIC_TXQ_DESC_FLAG_ENCAP : 0;
+
+	cmd = encode_txq_desc_cmd(IONIC_TXQ_DESC_OPCODE_CSUM_PARTIAL,
+				  flags, skb_shinfo(skb)->nr_frags, dma_addr);
+	desc->cmd = cpu_to_le64(cmd);
+	desc->len = cpu_to_le16(skb_headlen(skb));
+	desc->vlan_tci = cpu_to_le16(skb_vlan_tag_get(skb));
+	desc->csum_start = cpu_to_le16(skb_checksum_start_offset(skb));
+	desc->csum_offset = cpu_to_le16(skb->csum_offset);
+
+	if (skb->csum_not_inet)
+		stats->crc32_csum++;
+	else
+		stats->csum++;
+
+	return 0;
+}
+
+static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb)
+{
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	struct ionic_txq_desc *desc = q->head->desc;
+	struct device *dev = q->lif->ionic->dev;
+	dma_addr_t dma_addr;
+	bool has_vlan;
+	u8 flags = 0;
+	bool encap;
+	u64 cmd;
+
+	has_vlan = !!skb_vlan_tag_present(skb);
+	encap = skb->encapsulation;
+
+	dma_addr = ionic_tx_map_single(q, skb->data, skb_headlen(skb));
+	if (dma_mapping_error(dev, dma_addr))
+		return -ENOMEM;
+
+	flags |= has_vlan ? IONIC_TXQ_DESC_FLAG_VLAN : 0;
+	flags |= encap ? IONIC_TXQ_DESC_FLAG_ENCAP : 0;
+
+	cmd = encode_txq_desc_cmd(IONIC_TXQ_DESC_OPCODE_CSUM_NONE,
+				  flags, skb_shinfo(skb)->nr_frags, dma_addr);
+	desc->cmd = cpu_to_le64(cmd);
+	desc->len = cpu_to_le16(skb_headlen(skb));
+	desc->vlan_tci = cpu_to_le16(skb_vlan_tag_get(skb));
+
+	stats->no_csum++;
+
+	return 0;
+}
+
+static int ionic_tx_skb_frags(struct ionic_queue *q, struct sk_buff *skb)
+{
+	struct ionic_txq_sg_desc *sg_desc = q->head->sg_desc;
+	unsigned int len_left = skb->len - skb_headlen(skb);
+	struct ionic_txq_sg_elem *elem = sg_desc->elems;
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	struct device *dev = q->lif->ionic->dev;
+	dma_addr_t dma_addr;
+	skb_frag_t *frag;
+	u16 len;
+
+	for (frag = skb_shinfo(skb)->frags; len_left; frag++, elem++) {
+		len = skb_frag_size(frag);
+		elem->len = cpu_to_le16(len);
+		dma_addr = ionic_tx_map_frag(q, frag, 0, len);
+		if (dma_mapping_error(dev, dma_addr))
+			return -ENOMEM;
+		elem->addr = cpu_to_le64(dma_addr);
+		len_left -= len;
+		stats->frags++;
+	}
+
+	return 0;
+}
+
+static int ionic_tx(struct ionic_queue *q, struct sk_buff *skb)
+{
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	int err;
+
+	/* set up the initial descriptor */
+	if (skb->ip_summed == CHECKSUM_PARTIAL)
+		err = ionic_tx_calc_csum(q, skb);
+	else
+		err = ionic_tx_calc_no_csum(q, skb);
+	if (err)
+		return err;
+
+	/* add frags */
+	err = ionic_tx_skb_frags(q, skb);
+	if (err)
+		return err;
+
+	skb_tx_timestamp(skb);
+	stats->pkts++;
+	stats->bytes += skb->len;
+
+	netdev_tx_sent_queue(q_to_ndq(q), skb->len);
+	ionic_txq_post(q, !netdev_xmit_more(), ionic_tx_clean, skb);
+
+	return 0;
+}
+
+static int ionic_tx_descs_needed(struct ionic_queue *q, struct sk_buff *skb)
+{
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	int err;
+
+	/* If TSO, need roundup(skb->len/mss) descs */
+	if (skb_is_gso(skb))
+		return (skb->len / skb_shinfo(skb)->gso_size) + 1;
+
+	/* If non-TSO, just need 1 desc and nr_frags sg elems */
+	if (skb_shinfo(skb)->nr_frags <= IONIC_TX_MAX_SG_ELEMS)
+		return 1;
+
+	/* Too many frags, so linearize */
+	err = skb_linearize(skb);
+	if (err)
+		return err;
+
+	stats->linearize++;
+
+	/* Need 1 desc and zero sg elems */
+	return 1;
+}
+
+netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	u16 queue_index = skb_get_queue_mapping(skb);
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_queue *q;
+	int ndescs;
+	int err;
+
+	if (unlikely(!test_bit(IONIC_LIF_UP, lif->state))) {
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	if (likely(lif_to_txqcq(lif, queue_index)))
+		q = lif_to_txq(lif, queue_index);
+	else
+		q = lif_to_txq(lif, 0);
+
+	ndescs = ionic_tx_descs_needed(q, skb);
+	if (ndescs < 0)
+		goto err_out_drop;
+
+	if (!ionic_q_has_space(q, ndescs)) {
+		netif_stop_subqueue(netdev, queue_index);
+		q->stop++;
+
+		/* Might race with ionic_tx_clean, check again */
+		smp_rmb();
+		if (ionic_q_has_space(q, ndescs)) {
+			netif_wake_subqueue(netdev, queue_index);
+			q->wake++;
+		} else {
+			return NETDEV_TX_BUSY;
+		}
+	}
+
+	if (skb_is_gso(skb))
+		err = ionic_tx_tso(q, skb);
+	else
+		err = ionic_tx(q, skb);
+
+	if (err)
+		goto err_out_drop;
+
+	return NETDEV_TX_OK;
+
+err_out_drop:
+	netif_stop_subqueue(netdev, queue_index);
+	q->stop++;
+	q->drop++;
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.h b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
new file mode 100644
index 000000000000..53775c62c85a
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_TXRX_H_
+#define _IONIC_TXRX_H_
+
+void ionic_rx_flush(struct ionic_cq *cq);
+void ionic_tx_flush(struct ionic_cq *cq);
+
+void ionic_rx_fill(struct ionic_queue *q);
+void ionic_rx_empty(struct ionic_queue *q);
+int ionic_rx_napi(struct napi_struct *napi, int budget);
+netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev);
+
+#endif /* _IONIC_TXRX_H_ */
-- 
2.17.1

