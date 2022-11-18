Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26046302AD
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 00:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiKRXNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 18:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiKRXNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 18:13:04 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6D8C688A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:43 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d20so5792113plr.10
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d6klTnzfyic8cyPwgcG3FY8Q05jIGZdGQfUpdP5fTF0=;
        b=2osdHG7Mi/enhDj3uYI4DL8l4pUcnfTNUVSIsYSoVIE1+MpN0gd0SFZBUuBJvDsHwL
         8ZkymQPRgRJxigClK/EfKo2eKLkqOHtgRM1oNEA4aMiTzvJWxmEsmDlne6hGvIoLEP4n
         cCgdRZZQi7+NOKG9AFbCFoSByFp/OVR6Xy64V+PugWl/rcKrg46SOR08FQ++JM0pxF2y
         epyISH8LG0T60F8EkhdM8QzVP+4j8tKXfP1rOivjrcWbEOzLRzYQMcpNiF26vp2FeLEB
         xs0bCgaOodeEjze4fN1oUit340dKJPbUypjNTlt5rhYIk0QVj3W1scxqpH7u/XtAVTUM
         cZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d6klTnzfyic8cyPwgcG3FY8Q05jIGZdGQfUpdP5fTF0=;
        b=Vb6J4rWlALJsXLuqwaFbOg2ZRiLvLNK+292XrhDglnULlSSJjVMNHuEd6kFfXGEaQw
         06BCCSNhe2qCfMuX8CMQ3B3dfb0jZZJjRrN4dxf/fshazuGLiEqnjhrEOOch6qqUj34d
         UVz4WeqSNuDG77QQ9iwOWqcezHJz3uhbiYYcvf1AzjkrWukrlEyoDfasBiIC5Jfd9mId
         nzw5RxuJ7fPR7oaABr3/bzb+PWJKwaMjUU591sWgeT0LIhUnMTfsM/nRYbRPXt/bh4YZ
         gMzvZndaqr1LBcUSYKaH8S/4oFPWIb7QjbZsHBbwvVc3QB6H1tAyASgjNss6Uu4tkG68
         iLHA==
X-Gm-Message-State: ANoB5pm2tE5aJGqEd5qwY1KStwP8y+k/vUZUszvUu6EodQ7Vg9Wch/zM
        x+5orAqx22uPXmmpZMDrCR7A2xODT1qfiw==
X-Google-Smtp-Source: AA0mqf69TcVLQ3F4hFFrQeEkL//lJsLY0lLsjOl7zA1ZcT8tmnZNFKgkPpdeHC6gj66qRtwA2GUrLA==
X-Received: by 2002:a17:902:cad3:b0:188:c63f:4108 with SMTP id y19-20020a170902cad300b00188c63f4108mr1576082pld.67.1668812239067;
        Fri, 18 Nov 2022 14:57:19 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k89-20020a17090a3ee200b002005fcd2cb4sm6004818pjc.2.2022.11.18.14.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:57:18 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [RFC PATCH net-next 05/19] pds_core: Add adminq processing and commands
Date:   Fri, 18 Nov 2022 14:56:42 -0800
Message-Id: <20221118225656.48309-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221118225656.48309-1-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the service routines for submitting and processing
the adminq messages and for handling notifyq events.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/pds_core/Makefile   |   1 +
 .../net/ethernet/pensando/pds_core/adminq.c   | 282 ++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.c |  11 -
 drivers/net/ethernet/pensando/pds_core/core.h |   6 +
 include/linux/pds/pds_adminq.h                |   2 +
 5 files changed, 291 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/pds_core/adminq.c

diff --git a/drivers/net/ethernet/pensando/pds_core/Makefile b/drivers/net/ethernet/pensando/pds_core/Makefile
index 446054206b6a..c7a722f7d9b8 100644
--- a/drivers/net/ethernet/pensando/pds_core/Makefile
+++ b/drivers/net/ethernet/pensando/pds_core/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_PDS_CORE) := pds_core.o
 pds_core-y := main.o \
 	      devlink.o \
 	      dev.o \
+	      adminq.o \
 	      core.o
 
 pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/pensando/pds_core/adminq.c b/drivers/net/ethernet/pensando/pds_core/adminq.c
new file mode 100644
index 000000000000..ba9e84a7ca92
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/adminq.c
@@ -0,0 +1,282 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+
+#include "core.h"
+
+#include <linux/pds/pds_adminq.h>
+
+struct pdsc_wait_context {
+	struct pdsc_qcq *qcq;
+	struct completion wait_completion;
+};
+
+static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
+{
+	union pds_core_notifyq_comp *comp;
+	struct pdsc *pdsc = qcq->pdsc;
+	struct pdsc_cq *cq = &qcq->cq;
+	struct pdsc_cq_info *cq_info;
+	int nq_work = 0;
+	u64 eid;
+
+	cq_info = &cq->info[cq->tail_idx];
+	comp = cq_info->comp;
+	eid = le64_to_cpu(comp->event.eid);
+	while (eid > pdsc->last_eid) {
+		u16 ecode = le16_to_cpu(comp->event.ecode);
+
+		switch (ecode) {
+		case PDS_EVENT_LINK_CHANGE:
+			dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
+				 ecode, eid);
+			break;
+
+		case PDS_EVENT_RESET:
+			dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
+				 ecode, eid);
+			break;
+
+		case PDS_EVENT_XCVR:
+			dev_info(pdsc->dev, "NotifyQ XCVR ecode %d eid %lld\n",
+				 ecode, eid);
+			break;
+
+		default:
+			dev_info(pdsc->dev, "NotifyQ ecode %d eid %lld\n",
+				 ecode, eid);
+			break;
+		}
+
+		pdsc->last_eid = eid;
+		cq->tail_idx = (cq->tail_idx + 1) & (cq->num_descs - 1);
+		cq_info = &cq->info[cq->tail_idx];
+		comp = cq_info->comp;
+		eid = le64_to_cpu(comp->event.eid);
+
+		nq_work++;
+	}
+
+	qcq->accum_work += nq_work;
+
+	return nq_work;
+}
+
+void pdsc_process_adminq(struct pdsc_qcq *qcq)
+{
+	union pds_core_adminq_comp *comp;
+	struct pdsc_queue *q = &qcq->q;
+	struct pdsc *pdsc = qcq->pdsc;
+	struct pdsc_cq *cq = &qcq->cq;
+	struct pdsc_q_info *q_info;
+	unsigned long irqflags;
+	int nq_work = 0;
+	int aq_work = 0;
+	int credits;
+	u32 index;
+
+	/* Check for NotifyQ event */
+	nq_work = pdsc_process_notifyq(&pdsc->notifyqcq);
+
+	/* Check for empty queue, which can happen if the interrupt was
+	 * for a NotifyQ event and there are no new AdminQ completions.
+	 */
+	if (q->tail_idx == q->head_idx)
+		goto credits;
+
+	/* Find the first completion to clean,
+	 * run the callback in the related q_info,
+	 * and continue while we still match done color
+	 */
+	spin_lock_irqsave(&pdsc->adminq_lock, irqflags);
+	comp = cq->info[cq->tail_idx].comp;
+	while (pdsc_color_match(comp->color, cq->done_color)) {
+		q_info = &q->info[q->tail_idx];
+		index = q->tail_idx;
+		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
+
+		/* Copy out the completion data */
+		memcpy(q_info->dest, comp, sizeof(*comp));
+
+		complete_all(&q_info->wc->wait_completion);
+
+		if (cq->tail_idx == cq->num_descs - 1)
+			cq->done_color = !cq->done_color;
+		cq->tail_idx = (cq->tail_idx + 1) & (cq->num_descs - 1);
+		comp = cq->info[cq->tail_idx].comp;
+
+		aq_work++;
+	}
+	spin_unlock_irqrestore(&pdsc->adminq_lock, irqflags);
+
+	qcq->accum_work += aq_work;
+
+credits:
+	/* Return the interrupt credits, one for each completion */
+	credits = nq_work + aq_work;
+	if (credits)
+		pds_core_intr_credits(&pdsc->intr_ctrl[qcq->intx],
+				      credits,
+				      PDS_CORE_INTR_CRED_REARM);
+}
+
+void pdsc_work_thread(struct work_struct *work)
+{
+	struct pdsc_qcq *qcq = container_of(work, struct pdsc_qcq, work);
+
+	pdsc_process_adminq(qcq);
+}
+
+irqreturn_t pdsc_adminq_isr(int irq, void *data)
+{
+	struct pdsc_qcq *qcq = data;
+	struct pdsc *pdsc = qcq->pdsc;
+
+	/* Don't process AdminQ when shutting down */
+	if (pdsc->state & BIT_ULL(PDSC_S_STOPPING_DRIVER)) {
+		pr_err("%s: called while PDSC_S_STOPPING_DRIVER\n", __func__);
+		return IRQ_HANDLED;
+	}
+
+	queue_work(pdsc->wq, &qcq->work);
+	pds_core_intr_mask(&pdsc->intr_ctrl[irq], PDS_CORE_INTR_MASK_CLEAR);
+
+	return IRQ_HANDLED;
+}
+
+static int __pdsc_adminq_post(struct pdsc *pdsc,
+			      struct pdsc_qcq *qcq,
+			      union pds_core_adminq_cmd *cmd,
+			      union pds_core_adminq_comp *comp,
+			      struct pdsc_wait_context *wc)
+{
+	struct pdsc_queue *q = &qcq->q;
+	struct pdsc_q_info *q_info;
+	unsigned long irqflags;
+	unsigned int avail;
+	int ret = 0;
+	int index;
+
+	spin_lock_irqsave(&pdsc->adminq_lock, irqflags);
+
+	/* Check for space in the queue */
+	avail = q->tail_idx;
+	if (q->head_idx >= avail)
+		avail += q->num_descs - q->head_idx - 1;
+	else
+		avail -= q->head_idx + 1;
+	if (!avail) {
+		ret = -ENOSPC;
+		goto err_out;
+	}
+
+	/* Check that the FW is running */
+	if (!pdsc_is_fw_running(pdsc)) {
+		u8 fw_status = ioread8(&pdsc->info_regs->fw_status);
+
+		dev_info(pdsc->dev, "%s: post failed - fw not running %#02x:\n",
+			 __func__, fw_status);
+		ret = -ENXIO;
+
+		goto err_out;
+	}
+
+	/* Post the request */
+	index = q->head_idx;
+	q_info = &q->info[index];
+	q_info->wc = wc;
+	q_info->dest = comp;
+	memcpy(q_info->desc, cmd, sizeof(*cmd));
+
+	dev_dbg(pdsc->dev, "head_idx %d tail_idx %d\n", q->head_idx, q->tail_idx);
+	dev_dbg(pdsc->dev, "post admin queue command:\n");
+	dynamic_hex_dump("cmd ", DUMP_PREFIX_OFFSET, 16, 1,
+			 cmd, sizeof(*cmd), true);
+
+	q->head_idx = (q->head_idx + 1) & (q->num_descs - 1);
+
+	pds_core_dbell_ring(pdsc->kern_dbpage, q->hw_type, q->dbval | q->head_idx);
+	ret = index;
+
+err_out:
+	spin_unlock_irqrestore(&pdsc->adminq_lock, irqflags);
+	return ret;
+}
+
+int pdsc_adminq_post(struct pdsc *pdsc,
+		     struct pdsc_qcq *qcq,
+		     union pds_core_adminq_cmd *cmd,
+		     union pds_core_adminq_comp *comp,
+		     bool fast_poll)
+{
+	struct pdsc_wait_context wc = {
+		.wait_completion = COMPLETION_INITIALIZER_ONSTACK(wc.wait_completion),
+		.qcq = qcq,
+	};
+	unsigned long poll_interval = 1;
+	unsigned long time_limit;
+	unsigned long time_start;
+	unsigned long time_done;
+	unsigned long remaining;
+	int err = 0;
+	int index;
+
+	index = __pdsc_adminq_post(pdsc, qcq, cmd, comp, &wc);
+	if (index < 0) {
+		err = index;
+		goto out;
+	}
+
+	time_start = jiffies;
+	time_limit = time_start + HZ * pdsc->devcmd_timeout;
+	do {
+		/* Timeslice the actual wait to catch IO errors etc early */
+		remaining = wait_for_completion_timeout(&wc.wait_completion,
+							msecs_to_jiffies(poll_interval));
+		if (remaining)
+			break;
+
+		if (!pdsc_is_fw_running(pdsc)) {
+			u8 fw_status = ioread8(&pdsc->info_regs->fw_status);
+
+			dev_dbg(pdsc->dev, "%s: post wait failed - fw not running %#02x:\n",
+				__func__, fw_status);
+			err = -ENXIO;
+			break;
+		}
+
+		/* When fast_poll is not requested, prevent aggressive polling
+		 * on failures due to timeouts by doing exponential back off.
+		 */
+		if (!fast_poll && poll_interval < PDSC_ADMINQ_MAX_POLL_INTERVAL)
+			poll_interval <<= 1;
+	} while (time_before(jiffies, time_limit));
+	time_done = jiffies;
+	dev_dbg(pdsc->dev, "%s: elapsed %d msecs\n",
+		__func__, jiffies_to_msecs(time_done - time_start));
+
+	/* Check the results */
+	if (time_after_eq(time_done, time_limit))
+		err = -ETIMEDOUT;
+
+	dev_dbg(pdsc->dev, "read admin queue completion idx %d:\n", index);
+	dynamic_hex_dump("comp ", DUMP_PREFIX_OFFSET, 16, 1,
+			 comp, sizeof(*comp), true);
+
+	if (remaining && comp->status)
+		err = pdsc_err_to_errno(comp->status);
+
+out:
+	if (err) {
+		dev_dbg(pdsc->dev, "%s: opcode %d status %d err %pe\n",
+			__func__, cmd->opcode, comp->status, ERR_PTR(err));
+		if (err == -ENXIO || err == -ETIMEDOUT)
+			pdsc_queue_health_check(pdsc);
+	}
+
+	return err;
+}
diff --git a/drivers/net/ethernet/pensando/pds_core/core.c b/drivers/net/ethernet/pensando/pds_core/core.c
index 507f718bc8ab..e2017cee8284 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.c
+++ b/drivers/net/ethernet/pensando/pds_core/core.c
@@ -12,17 +12,6 @@
 
 #include <linux/pds/pds_adminq.h>
 
-void pdsc_work_thread(struct work_struct *work)
-{
-	/* stub */
-}
-
-irqreturn_t pdsc_adminq_isr(int irq, void *data)
-{
-	/* stub */
-	return IRQ_HANDLED;
-}
-
 void pdsc_intr_free(struct pdsc *pdsc, int index)
 {
 	struct pdsc_intr_info *intr_info;
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index 6b816b7fb193..87b221aa7b44 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -263,6 +263,12 @@ int pds_devcmd_vf_start(struct pdsc *pdsc);
 int pdsc_dev_reinit(struct pdsc *pdsc);
 int pdsc_dev_init(struct pdsc *pdsc);
 
+int pdsc_adminq_post(struct pdsc *pdsc,
+		     struct pdsc_qcq *qcq,
+		     union pds_core_adminq_cmd *cmd,
+		     union pds_core_adminq_comp *comp,
+		     bool fast_poll);
+
 int pdsc_intr_alloc(struct pdsc *pdsc, char *name,
 		    irq_handler_t handler, void *data);
 void pdsc_intr_free(struct pdsc *pdsc, int index);
diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
index b06d28d0f906..19070099eb35 100644
--- a/include/linux/pds/pds_adminq.h
+++ b/include/linux/pds/pds_adminq.h
@@ -4,6 +4,8 @@
 #ifndef _PDS_CORE_ADMINQ_H_
 #define _PDS_CORE_ADMINQ_H_
 
+#define PDSC_ADMINQ_MAX_POLL_INTERVAL	256
+
 enum pds_core_adminq_flags {
 	PDS_AQ_FLAG_FASTPOLL	= BIT(1),	/* poll for completion at 1ms intervals */
 };
-- 
2.17.1

