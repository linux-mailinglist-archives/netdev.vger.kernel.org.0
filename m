Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459FA483C05
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 07:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiADGrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 01:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiADGrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 01:47:04 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72DAC061784
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 22:47:03 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v16so30604321pjn.1
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 22:47:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UYN9fnOUIhZUxwrjrGGK6hUAohHYvZdFlMlHE0i38Hk=;
        b=lhSLkeWkKR6OtQOu3cmJvznWZu0dPKiGwhUZ0b2TZbaFctFUIV+eb1Jvq50lejYRae
         rDBDrbC+PZ8rpiU7MAHTXWLsTGCVch/AwFZgqw+klhfrXdaRcJ0d68Z38cqS4jNBAT7G
         STMbUXdByFB3tZO89XZ3f6tywQjuec4h4s6iw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UYN9fnOUIhZUxwrjrGGK6hUAohHYvZdFlMlHE0i38Hk=;
        b=49FnF0R4yJx0aG/becChe3HTkaG7BYhlHJXaTKSphmnRy2iv9/Sjs2ZozyZ4ZWr2dV
         Gym/AZmNmS3Ugf4O/9yR+nl80jdbmQBTSu0g2QI8idJixBabnWyW5Q6eo1Y7Y0RHDM2t
         beYRKX0ETkzeR/fUcc2+iubOYPZuLRslDBzDKXmCpcYwva5TFwkZQyz/+0vfzkA3ZaTs
         /VG6Z+w5AI0ppDakS2ZLJwlv4iFjONWZ9njVWuQ2dYwpIzvjE6wjewvOHdVsXnLajbRv
         NDKR6cCcKxN4tD14lvciuxlacxl8FZUrVfEAYUN5zPla1eRqeEn+hcm4x2/y06Fojsrb
         CrWg==
X-Gm-Message-State: AOAM5339JdXQqqhFW4L0G0PnCX8AacZKJXt1MHFij/emVuAtDrZa0TKz
        9kCScTvOHWblLg0sSUElzf71eA==
X-Google-Smtp-Source: ABdhPJwVNwBh8uDgOv8ZRoAjQMA+ruLqjompNwwyRI7MCIgg0ciUG4Gs0y+7OYW8cYX+RR7jJ7ChKw==
X-Received: by 2002:a17:90a:8b08:: with SMTP id y8mr58962737pjn.41.1641278822609;
        Mon, 03 Jan 2022 22:47:02 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id 93sm40424090pjo.26.2022.01.03.22.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 22:47:01 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, d.michailidis@fungible.com
Subject: [PATCH net-next v4 2/8] net/fungible: Add service module for Fungible drivers
Date:   Mon,  3 Jan 2022 22:46:51 -0800
Message-Id: <20220104064657.2095041-3-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104064657.2095041-1-dmichail@fungible.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fungible cards have a number of different PCI functions and thus
different drivers, all of which use a common method to initialize and
interact with the device. This commit adds a library module that
collects these common mechanisms. They mainly deal with device
initialization, setting up and destroying queues, and operating an admin
queue. A subset of the FW interface is also included here.

Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 .../net/ethernet/fungible/funcore/Makefile    |    5 +
 .../net/ethernet/fungible/funcore/fun_dev.c   |  845 ++++++++++++
 .../net/ethernet/fungible/funcore/fun_dev.h   |  151 +++
 .../net/ethernet/fungible/funcore/fun_hci.h   | 1187 +++++++++++++++++
 .../net/ethernet/fungible/funcore/fun_queue.c |  620 +++++++++
 .../net/ethernet/fungible/funcore/fun_queue.h |  178 +++
 6 files changed, 2986 insertions(+)
 create mode 100644 drivers/net/ethernet/fungible/funcore/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_dev.c
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_dev.h
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_hci.h
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_queue.c
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_queue.h

diff --git a/drivers/net/ethernet/fungible/funcore/Makefile b/drivers/net/ethernet/fungible/funcore/Makefile
new file mode 100644
index 000000000000..bc16b264b53e
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funcore/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+obj-$(CONFIG_FUN_CORE) += funcore.o
+
+funcore-y := fun_dev.o fun_queue.o
diff --git a/drivers/net/ethernet/fungible/funcore/fun_dev.c b/drivers/net/ethernet/fungible/funcore/fun_dev.c
new file mode 100644
index 000000000000..f20d24ec7036
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funcore/fun_dev.c
@@ -0,0 +1,845 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+#include <linux/aer.h>
+#include <linux/bitmap.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/nvme.h>
+#include <linux/pci.h>
+#include <linux/wait.h>
+#include <linux/sched/signal.h>
+
+#include "fun_queue.h"
+#include "fun_dev.h"
+
+#define FUN_ADMIN_CMD_TO_MS 3000
+
+enum {
+	AQA_ASQS_SHIFT = 0,
+	AQA_ACQS_SHIFT = 16,
+	AQA_MIN_QUEUE_SIZE = 2,
+	AQA_MAX_QUEUE_SIZE = 4096
+};
+
+/* context for admin commands */
+struct fun_cmd_ctx {
+	fun_admin_callback_t cb;  /* callback to invoke on completion */
+	void *cb_data;            /* user data provided to callback */
+	int cpu;                  /* CPU where the cmd's tag was allocated */
+};
+
+/* Context for synchronous admin commands. */
+struct fun_sync_cmd_ctx {
+	struct completion compl;
+	u8 *rsp_buf;              /* caller provided response buffer */
+	unsigned int rsp_len;     /* response buffer size */
+	u8 rsp_status;            /* command response status */
+};
+
+/* Wait for the CSTS.RDY bit to match @enabled. */
+static int fun_wait_ready(struct fun_dev *fdev, bool enabled)
+{
+	unsigned int cap_to = NVME_CAP_TIMEOUT(fdev->cap_reg);
+	u32 bit = enabled ? NVME_CSTS_RDY : 0;
+	unsigned long deadline;
+
+	deadline = ((cap_to + 1) * HZ / 2) + jiffies; /* CAP.TO is in 500ms */
+
+	for (;;) {
+		u32 csts = readl(fdev->bar + NVME_REG_CSTS);
+
+		if (csts == ~0) {
+			dev_err(fdev->dev, "CSTS register read %#x\n", csts);
+			return -EIO;
+		}
+
+		if ((csts & NVME_CSTS_RDY) == bit)
+			return 0;
+
+		if (time_is_before_jiffies(deadline))
+			break;
+
+		msleep(100);
+	}
+
+	dev_err(fdev->dev,
+		"Timed out waiting for device to indicate RDY %u; aborting %s\n",
+		enabled, enabled ? "initialization" : "reset");
+	return -ETIMEDOUT;
+}
+
+/* Check CSTS and return an error if it is unreadable or has unexpected
+ * RDY value.
+ */
+static int fun_check_csts_rdy(struct fun_dev *fdev, unsigned int expected_rdy)
+{
+	u32 csts = readl(fdev->bar + NVME_REG_CSTS);
+	u32 actual_rdy = csts & NVME_CSTS_RDY;
+
+	if (csts == ~0) {
+		dev_err(fdev->dev, "CSTS register read %#x\n", csts);
+		return -EIO;
+	}
+	if (actual_rdy != expected_rdy) {
+		dev_err(fdev->dev, "Unexpected CSTS RDY %u\n", actual_rdy);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Check that CSTS RDY has the expected value. Then write a new value to the CC
+ * register and wait for CSTS RDY to match the new CC ENABLE state.
+ */
+static int fun_update_cc_enable(struct fun_dev *fdev, unsigned int initial_rdy)
+{
+	int rc = fun_check_csts_rdy(fdev, initial_rdy);
+
+	if (rc)
+		return rc;
+	writel(fdev->cc_reg, fdev->bar + NVME_REG_CC);
+	return fun_wait_ready(fdev, !!(fdev->cc_reg & NVME_CC_ENABLE));
+}
+
+static int fun_disable_ctrl(struct fun_dev *fdev)
+{
+	fdev->cc_reg &= ~(NVME_CC_SHN_MASK | NVME_CC_ENABLE);
+	return fun_update_cc_enable(fdev, 1);
+}
+
+static int fun_enable_ctrl(struct fun_dev *fdev, u32 admin_cqesz_log2,
+			   u32 admin_sqesz_log2)
+{
+	fdev->cc_reg = (admin_cqesz_log2 << NVME_CC_IOCQES_SHIFT) |
+		       (admin_sqesz_log2 << NVME_CC_IOSQES_SHIFT) |
+		       ((PAGE_SHIFT - 12) << NVME_CC_MPS_SHIFT) |
+		       NVME_CC_ENABLE;
+
+	return fun_update_cc_enable(fdev, 0);
+}
+
+static int fun_map_bars(struct fun_dev *fdev, const char *name)
+{
+	struct pci_dev *pdev = to_pci_dev(fdev->dev);
+	int err;
+
+	err = pci_request_mem_regions(pdev, name);
+	if (err) {
+		dev_err(&pdev->dev,
+			"Couldn't get PCI memory resources, err %d\n", err);
+		return err;
+	}
+
+	fdev->bar = pci_ioremap_bar(pdev, 0);
+	if (!fdev->bar) {
+		dev_err(&pdev->dev, "Couldn't map BAR 0\n");
+		pci_release_mem_regions(pdev);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void fun_unmap_bars(struct fun_dev *fdev)
+{
+	struct pci_dev *pdev = to_pci_dev(fdev->dev);
+
+	if (fdev->bar) {
+		iounmap(fdev->bar);
+		fdev->bar = NULL;
+		pci_release_mem_regions(pdev);
+	}
+}
+
+static int fun_set_dma_masks(struct device *dev)
+{
+	int err;
+
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+	if (err)
+		dev_err(dev, "DMA mask configuration failed, err %d\n", err);
+	return err;
+}
+
+static irqreturn_t fun_admin_irq(int irq, void *data)
+{
+	struct fun_queue *funq = data;
+
+	return fun_process_cq(funq, 0) ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static void fun_complete_admin_cmd(struct fun_queue *funq, void *data,
+				   void *entry, const struct fun_cqe_info *info)
+{
+	const struct fun_admin_rsp_common *rsp_common = entry;
+	struct fun_dev *fdev = funq->fdev;
+	struct fun_cmd_ctx *cmd_ctx;
+	int cpu;
+	u16 cid;
+
+	if (info->sqhd == cpu_to_be16(0xffff)) {
+		dev_dbg(fdev->dev, "adminq event");
+		if (fdev->adminq_cb)
+			fdev->adminq_cb(fdev, entry);
+		return;
+	}
+
+	cid = be16_to_cpu(rsp_common->cid);
+	dev_dbg(fdev->dev, "admin CQE cid %u, op %u, ret %u\n", cid,
+		rsp_common->op, rsp_common->ret);
+
+	cmd_ctx = &fdev->cmd_ctx[cid];
+	if (cmd_ctx->cpu < 0) {
+		dev_err(fdev->dev,
+			"admin CQE with CID=%u, op=%u does not match a pending command\n",
+			cid, rsp_common->op);
+		return;
+	}
+
+	if (cmd_ctx->cb)
+		cmd_ctx->cb(fdev, entry, xchg(&cmd_ctx->cb_data, NULL));
+
+	cpu = cmd_ctx->cpu;
+	cmd_ctx->cpu = -1;
+	sbitmap_queue_clear(&fdev->admin_sbq, cid, cpu);
+}
+
+static int fun_init_cmd_ctx(struct fun_dev *fdev, unsigned int ntags)
+{
+	unsigned int i;
+
+	fdev->cmd_ctx = kvcalloc(ntags, sizeof(*fdev->cmd_ctx), GFP_KERNEL);
+	if (!fdev->cmd_ctx)
+		return -ENOMEM;
+
+	for (i = 0; i < ntags; i++)
+		fdev->cmd_ctx[i].cpu = -1;
+
+	return 0;
+}
+
+/* Allocate and enable an admin queue and assign it the first IRQ vector. */
+static int fun_enable_admin_queue(struct fun_dev *fdev,
+				  const struct fun_dev_params *areq)
+{
+	struct fun_queue_alloc_req qreq = {
+		.cqe_size_log2 = areq->cqe_size_log2,
+		.sqe_size_log2 = areq->sqe_size_log2,
+
+		.cq_depth = areq->cq_depth,
+		.sq_depth = areq->sq_depth,
+		.rq_depth = areq->rq_depth,
+	};
+	unsigned int ntags = areq->sq_depth - 1;
+	struct fun_queue *funq;
+	int rc;
+
+	if (fdev->admin_q)
+		return -EEXIST;
+
+	if (areq->sq_depth < AQA_MIN_QUEUE_SIZE ||
+	    areq->sq_depth > AQA_MAX_QUEUE_SIZE ||
+	    areq->cq_depth < AQA_MIN_QUEUE_SIZE ||
+	    areq->cq_depth > AQA_MAX_QUEUE_SIZE)
+		return -EINVAL;
+
+	fdev->admin_q = fun_alloc_queue(fdev, 0, &qreq);
+	if (!fdev->admin_q)
+		return -ENOMEM;
+
+	rc = fun_init_cmd_ctx(fdev, ntags);
+	if (rc)
+		goto free_q;
+
+	rc = sbitmap_queue_init_node(&fdev->admin_sbq, ntags, -1, false,
+				     GFP_KERNEL, dev_to_node(fdev->dev));
+	if (rc)
+		goto free_cmd_ctx;
+
+	funq = fdev->admin_q;
+	funq->cq_vector = 0;
+	rc = fun_request_irq(funq, dev_name(fdev->dev), fun_admin_irq, funq);
+	if (rc)
+		goto free_sbq;
+
+	fun_set_cq_callback(funq, fun_complete_admin_cmd, NULL);
+	fdev->adminq_cb = areq->event_cb;
+
+	writel((funq->sq_depth - 1) << AQA_ASQS_SHIFT |
+	       (funq->cq_depth - 1) << AQA_ACQS_SHIFT,
+	       fdev->bar + NVME_REG_AQA);
+
+	writeq(funq->sq_dma_addr, fdev->bar + NVME_REG_ASQ);
+	writeq(funq->cq_dma_addr, fdev->bar + NVME_REG_ACQ);
+
+	rc = fun_enable_ctrl(fdev, areq->cqe_size_log2, areq->sqe_size_log2);
+	if (rc)
+		goto free_irq;
+
+	if (areq->rq_depth) {
+		rc = fun_create_rq(funq);
+		if (rc)
+			goto disable_ctrl;
+
+		funq_rq_post(funq);
+	}
+
+	return 0;
+
+disable_ctrl:
+	fun_disable_ctrl(fdev);
+free_irq:
+	fun_free_irq(funq);
+free_sbq:
+	sbitmap_queue_free(&fdev->admin_sbq);
+free_cmd_ctx:
+	kvfree(fdev->cmd_ctx);
+	fdev->cmd_ctx = NULL;
+free_q:
+	fun_free_queue(fdev->admin_q);
+	fdev->admin_q = NULL;
+	return rc;
+}
+
+static void fun_disable_admin_queue(struct fun_dev *fdev)
+{
+	struct fun_queue *admq = fdev->admin_q;
+
+	if (!admq)
+		return;
+
+	fun_disable_ctrl(fdev);
+
+	fun_free_irq(admq);
+	__fun_process_cq(admq, 0);
+
+	sbitmap_queue_free(&fdev->admin_sbq);
+
+	kvfree(fdev->cmd_ctx);
+	fdev->cmd_ctx = NULL;
+
+	fun_free_queue(admq);
+	fdev->admin_q = NULL;
+}
+
+/* Return %true if the admin queue has stopped servicing commands as can be
+ * detected through registers. This isn't exhaustive and may provide false
+ * negatives.
+ */
+static bool fun_adminq_stopped(struct fun_dev *fdev)
+{
+	u32 csts = readl(fdev->bar + NVME_REG_CSTS);
+
+	return (csts & (NVME_CSTS_CFS | NVME_CSTS_RDY)) != NVME_CSTS_RDY;
+}
+
+static int fun_wait_for_tag(struct fun_dev *fdev, int *cpup)
+{
+	struct sbitmap_queue *sbq = &fdev->admin_sbq;
+	struct sbq_wait_state *ws = &sbq->ws[0];
+	DEFINE_SBQ_WAIT(wait);
+	int tag;
+
+	for (;;) {
+		sbitmap_prepare_to_wait(sbq, ws, &wait, TASK_UNINTERRUPTIBLE);
+		if (fdev->suppress_cmds) {
+			tag = -ESHUTDOWN;
+			break;
+		}
+		tag = sbitmap_queue_get(sbq, cpup);
+		if (tag >= 0)
+			break;
+		schedule();
+	}
+
+	sbitmap_finish_wait(sbq, ws, &wait);
+	return tag;
+}
+
+/* Submit an asynchronous admin command. Caller is responsible for implementing
+ * any waiting or timeout. Upon command completion the callback @cb is called.
+ */
+int fun_submit_admin_cmd(struct fun_dev *fdev, struct fun_admin_req_common *cmd,
+			 fun_admin_callback_t cb, void *cb_data, bool wait_ok)
+{
+	struct fun_queue *funq = fdev->admin_q;
+	unsigned int cmdsize = cmd->len8 * 8;
+	struct fun_cmd_ctx *cmd_ctx;
+	int tag, cpu, rc = 0;
+
+	if (WARN_ON(cmdsize > (1 << funq->sqe_size_log2)))
+		return -EMSGSIZE;
+
+	tag = sbitmap_queue_get(&fdev->admin_sbq, &cpu);
+	if (tag < 0) {
+		if (!wait_ok)
+			return -EAGAIN;
+		tag = fun_wait_for_tag(fdev, &cpu);
+		if (tag < 0)
+			return tag;
+	}
+
+	cmd->cid = cpu_to_be16(tag);
+
+	cmd_ctx = &fdev->cmd_ctx[tag];
+	cmd_ctx->cb = cb;
+	cmd_ctx->cb_data = cb_data;
+
+	spin_lock(&funq->sq_lock);
+
+	if (unlikely(fdev->suppress_cmds)) {
+		rc = -ESHUTDOWN;
+		sbitmap_queue_clear(&fdev->admin_sbq, tag, cpu);
+	} else {
+		cmd_ctx->cpu = cpu;
+		memcpy(fun_sqe_at(funq, funq->sq_tail), cmd, cmdsize);
+
+		dev_dbg(fdev->dev, "admin cmd @ %u: %8ph\n", funq->sq_tail,
+			cmd);
+
+		if (++funq->sq_tail == funq->sq_depth)
+			funq->sq_tail = 0;
+		writel(funq->sq_tail, funq->sq_db);
+	}
+	spin_unlock(&funq->sq_lock);
+	return rc;
+}
+
+/* Abandon a pending admin command by clearing the issuer's callback data.
+ * Failure indicates that the command either has already completed or its
+ * completion is racing with this call.
+ */
+static bool fun_abandon_admin_cmd(struct fun_dev *fd,
+				  const struct fun_admin_req_common *cmd,
+				  void *cb_data)
+{
+	u16 cid = be16_to_cpu(cmd->cid);
+	struct fun_cmd_ctx *cmd_ctx = &fd->cmd_ctx[cid];
+
+	return cmpxchg(&cmd_ctx->cb_data, cb_data, NULL) == cb_data;
+}
+
+/* Stop submission of new admin commands and wake up any processes waiting for
+ * tags. Already submitted commands are left to complete or time out.
+ */
+static void fun_admin_stop(struct fun_dev *fdev)
+{
+	spin_lock(&fdev->admin_q->sq_lock);
+	fdev->suppress_cmds = true;
+	spin_unlock(&fdev->admin_q->sq_lock);
+	sbitmap_queue_wake_all(&fdev->admin_sbq);
+}
+
+/* The callback for synchronous execution of admin commands. It copies the
+ * command response to the caller's buffer and signals completion.
+ */
+static void fun_admin_cmd_sync_cb(struct fun_dev *fd, void *rsp, void *cb_data)
+{
+	const struct fun_admin_rsp_common *rsp_common = rsp;
+	struct fun_sync_cmd_ctx *ctx = cb_data;
+
+	if (!ctx)
+		return;         /* command issuer timed out and left */
+	if (ctx->rsp_buf) {
+		unsigned int rsp_len = rsp_common->len8 * 8;
+
+		if (unlikely(rsp_len > ctx->rsp_len)) {
+			dev_err(fd->dev,
+				"response for op %u is %uB > response buffer %uB\n",
+				rsp_common->op, rsp_len, ctx->rsp_len);
+			rsp_len = ctx->rsp_len;
+		}
+		memcpy(ctx->rsp_buf, rsp, rsp_len);
+	}
+	ctx->rsp_status = rsp_common->ret;
+	complete(&ctx->compl);
+}
+
+/* Submit a synchronous admin command. */
+int fun_submit_admin_sync_cmd(struct fun_dev *fdev,
+			      struct fun_admin_req_common *cmd, void *rsp,
+			      size_t rspsize, unsigned int timeout)
+{
+	struct fun_sync_cmd_ctx ctx = {
+		.compl = COMPLETION_INITIALIZER_ONSTACK(ctx.compl),
+		.rsp_buf = rsp,
+		.rsp_len = rspsize,
+	};
+	unsigned int cmdlen = cmd->len8 * 8;
+	unsigned long jiffies_left;
+	int ret;
+
+	ret = fun_submit_admin_cmd(fdev, cmd, fun_admin_cmd_sync_cb, &ctx,
+				   true);
+	if (ret)
+		return ret;
+
+	if (!timeout)
+		timeout = FUN_ADMIN_CMD_TO_MS;
+
+	jiffies_left = wait_for_completion_timeout(&ctx.compl,
+						   msecs_to_jiffies(timeout));
+	if (!jiffies_left) {
+		/* The command timed out. Attempt to cancel it so we can return.
+		 * But if the command is in the process of completing we'll
+		 * wait for it.
+		 */
+		if (fun_abandon_admin_cmd(fdev, cmd, &ctx)) {
+			dev_err(fdev->dev, "admin command timed out: %*ph\n",
+				cmdlen, cmd);
+			fun_admin_stop(fdev);
+			/* see if the timeout was due to a queue failure */
+			if (fun_adminq_stopped(fdev))
+				dev_err(fdev->dev,
+					"device does not accept admin commands\n");
+
+			return -ETIMEDOUT;
+		}
+		wait_for_completion(&ctx.compl);
+	}
+
+	if (ctx.rsp_status) {
+		dev_err(fdev->dev, "admin command failed, err %d: %*ph\n",
+			ctx.rsp_status, cmdlen, cmd);
+	}
+
+	return -ctx.rsp_status;
+}
+EXPORT_SYMBOL_GPL(fun_submit_admin_sync_cmd);
+
+/* Return the number of device resources of the requested type. */
+int fun_get_res_count(struct fun_dev *fdev, enum fun_admin_op res)
+{
+	union {
+		struct fun_admin_res_count_req req;
+		struct fun_admin_res_count_rsp rsp;
+	} cmd;
+	int rc;
+
+	cmd.req.common = FUN_ADMIN_REQ_COMMON_INIT2(res, sizeof(cmd.req));
+	cmd.req.count = FUN_ADMIN_SIMPLE_SUBOP_INIT(FUN_ADMIN_SUBOP_RES_COUNT,
+						    0, 0);
+
+	rc = fun_submit_admin_sync_cmd(fdev, &cmd.req.common, &cmd.rsp,
+				       sizeof(cmd), 0);
+	return rc ? rc : be32_to_cpu(cmd.rsp.count.data);
+}
+EXPORT_SYMBOL_GPL(fun_get_res_count);
+
+/* Request that the instance of resource @res with the given id be deleted. */
+int fun_res_destroy(struct fun_dev *fdev, enum fun_admin_op res,
+		    unsigned int flags, u32 id)
+{
+	struct fun_admin_generic_destroy_req req = {
+		.common = FUN_ADMIN_REQ_COMMON_INIT2(res, sizeof(req)),
+		.destroy = FUN_ADMIN_SIMPLE_SUBOP_INIT(FUN_ADMIN_SUBOP_DESTROY,
+						       flags, id)
+	};
+
+	return fun_submit_admin_sync_cmd(fdev, &req.common, NULL, 0, 0);
+}
+EXPORT_SYMBOL_GPL(fun_res_destroy);
+
+/* Bind two entities of the given types and IDs. */
+int fun_bind(struct fun_dev *fdev, enum fun_admin_bind_type type0,
+	     unsigned int id0, enum fun_admin_bind_type type1,
+	     unsigned int id1)
+{
+	struct {
+		struct fun_admin_bind_req req;
+		struct fun_admin_bind_entry entry[2];
+	} cmd = {
+		.req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_BIND,
+							 sizeof(cmd)),
+		.entry[0] = FUN_ADMIN_BIND_ENTRY_INIT(type0, id0),
+		.entry[1] = FUN_ADMIN_BIND_ENTRY_INIT(type1, id1),
+	};
+
+	return fun_submit_admin_sync_cmd(fdev, &cmd.req.common, NULL, 0, 0);
+}
+EXPORT_SYMBOL_GPL(fun_bind);
+
+static int fun_get_dev_limits(struct fun_dev *fdev)
+{
+	struct pci_dev *pdev = to_pci_dev(fdev->dev);
+	unsigned int cq_count, sq_count, num_dbs;
+	int rc;
+
+	rc = fun_get_res_count(fdev, FUN_ADMIN_OP_EPCQ);
+	if (rc < 0)
+		return rc;
+	cq_count = rc;
+
+	rc = fun_get_res_count(fdev, FUN_ADMIN_OP_EPSQ);
+	if (rc < 0)
+		return rc;
+	sq_count = rc;
+
+	/* The admin queue consumes 1 CQ and at least 1 SQ. To be usable the
+	 * device must provide additional queues.
+	 */
+	if (cq_count < 2 || sq_count < 2 + (fdev->admin_q->rq_depth > 0))
+		return -EINVAL;
+
+	/* Calculate the max QID based on SQ/CQ/doorbell counts.
+	 * SQ/CQ doorbells alternate.
+	 */
+	num_dbs = (pci_resource_len(pdev, 0) - NVME_REG_DBS) /
+		  (fdev->db_stride * 4);
+	fdev->max_qid = min3(cq_count, sq_count, num_dbs / 2) - 1;
+	fdev->kern_end_qid = fdev->max_qid + 1;
+	return 0;
+}
+
+/* Allocate all MSI-X vectors available on a function and at least @min_vecs. */
+static int fun_alloc_irqs(struct pci_dev *pdev, unsigned int min_vecs)
+{
+	int vecs, num_msix = pci_msix_vec_count(pdev);
+
+	if (num_msix < 0)
+		return num_msix;
+	if (min_vecs > num_msix)
+		return -ERANGE;
+
+	vecs = pci_alloc_irq_vectors(pdev, min_vecs, num_msix, PCI_IRQ_MSIX);
+	if (vecs > 0) {
+		dev_info(&pdev->dev,
+			 "Allocated %d IRQ vectors of %d requested\n",
+			 vecs, num_msix);
+	} else {
+		dev_err(&pdev->dev,
+			"Unable to allocate at least %u IRQ vectors\n",
+			min_vecs);
+	}
+	return vecs;
+}
+
+/* Allocate and initialize the IRQ manager state. */
+static int fun_alloc_irq_mgr(struct fun_dev *fdev)
+{
+	fdev->irq_map = bitmap_zalloc(fdev->num_irqs, GFP_KERNEL);
+	if (!fdev->irq_map)
+		return -ENOMEM;
+
+	spin_lock_init(&fdev->irqmgr_lock);
+	/* mark IRQ 0 allocated, it is used by the admin queue */
+	__set_bit(0, fdev->irq_map);
+	fdev->irqs_avail = fdev->num_irqs - 1;
+	return 0;
+}
+
+/* Reserve @nirqs of the currently available IRQs and return their indices. */
+int fun_reserve_irqs(struct fun_dev *fdev, unsigned int nirqs, u16 *irq_indices)
+{
+	unsigned int b, n = 0;
+	int err = -ENOSPC;
+
+	if (!nirqs)
+		return 0;
+
+	spin_lock(&fdev->irqmgr_lock);
+	if (nirqs > fdev->irqs_avail)
+		goto unlock;
+
+	for_each_clear_bit(b, fdev->irq_map, fdev->num_irqs) {
+		__set_bit(b, fdev->irq_map);
+		irq_indices[n++] = b;
+		if (n >= nirqs)
+			break;
+	}
+
+	WARN_ON(n < nirqs);
+	fdev->irqs_avail -= n;
+	err = n;
+unlock:
+	spin_unlock(&fdev->irqmgr_lock);
+	return err;
+}
+EXPORT_SYMBOL(fun_reserve_irqs);
+
+/* Release @nirqs previously allocated IRQS with the supplied indices. */
+void fun_release_irqs(struct fun_dev *fdev, unsigned int nirqs,
+		      u16 *irq_indices)
+{
+	unsigned int i;
+
+	spin_lock(&fdev->irqmgr_lock);
+	for (i = 0; i < nirqs; i++)
+		__clear_bit(irq_indices[i], fdev->irq_map);
+	fdev->irqs_avail += nirqs;
+	spin_unlock(&fdev->irqmgr_lock);
+}
+EXPORT_SYMBOL(fun_release_irqs);
+
+static void fun_serv_handler(struct work_struct *work)
+{
+	struct fun_dev *fd = container_of(work, struct fun_dev, service_task);
+
+	if (test_bit(FUN_SERV_DISABLED, &fd->service_flags))
+		return;
+	if (fd->serv_cb)
+		fd->serv_cb(fd);
+}
+
+void fun_serv_stop(struct fun_dev *fd)
+{
+	set_bit(FUN_SERV_DISABLED, &fd->service_flags);
+	cancel_work_sync(&fd->service_task);
+}
+EXPORT_SYMBOL_GPL(fun_serv_stop);
+
+void fun_serv_restart(struct fun_dev *fd)
+{
+	clear_bit(FUN_SERV_DISABLED, &fd->service_flags);
+	if (fd->service_flags)
+		schedule_work(&fd->service_task);
+}
+EXPORT_SYMBOL_GPL(fun_serv_restart);
+
+void fun_serv_sched(struct fun_dev *fd)
+{
+	if (!test_bit(FUN_SERV_DISABLED, &fd->service_flags))
+		schedule_work(&fd->service_task);
+}
+EXPORT_SYMBOL_GPL(fun_serv_sched);
+
+/* Check and try to get the device into a proper state for initialization,
+ * i.e., CSTS.RDY = CC.EN = 0.
+ */
+static int sanitize_dev(struct fun_dev *fdev)
+{
+	int rc;
+
+	fdev->cap_reg = readq(fdev->bar + NVME_REG_CAP);
+	fdev->cc_reg = readl(fdev->bar + NVME_REG_CC);
+
+	/* First get RDY to agree with the current EN. Give RDY the opportunity
+	 * to complete a potential recent EN change.
+	 */
+	rc = fun_wait_ready(fdev, fdev->cc_reg & NVME_CC_ENABLE);
+	if (rc)
+		return rc;
+
+	/* Next, reset the device if EN is currently 1. */
+	if (fdev->cc_reg & NVME_CC_ENABLE)
+		rc = fun_disable_ctrl(fdev);
+
+	return rc;
+}
+
+/* Undo the device initialization of fun_dev_enable(). */
+void fun_dev_disable(struct fun_dev *fdev)
+{
+	struct pci_dev *pdev = to_pci_dev(fdev->dev);
+
+	pci_set_drvdata(pdev, NULL);
+
+	if (fdev->fw_handle != FUN_HCI_ID_INVALID) {
+		fun_res_destroy(fdev, FUN_ADMIN_OP_SWUPGRADE, 0,
+				fdev->fw_handle);
+		fdev->fw_handle = FUN_HCI_ID_INVALID;
+	}
+
+	fun_disable_admin_queue(fdev);
+
+	bitmap_free(fdev->irq_map);
+	pci_free_irq_vectors(pdev);
+
+	pci_clear_master(pdev);
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
+
+	fun_unmap_bars(fdev);
+}
+EXPORT_SYMBOL(fun_dev_disable);
+
+/* Perform basic initialization of a device, including
+ * - PCI config space setup and BAR0 mapping
+ * - interrupt management initialization
+ * - 1 admin queue setup
+ * - determination of some device limits, such as number of queues.
+ */
+int fun_dev_enable(struct fun_dev *fdev, struct pci_dev *pdev,
+		   const struct fun_dev_params *areq, const char *name)
+{
+	int rc;
+
+	fdev->dev = &pdev->dev;
+	rc = fun_map_bars(fdev, name);
+	if (rc)
+		return rc;
+
+	rc = fun_set_dma_masks(fdev->dev);
+	if (rc)
+		goto unmap;
+
+	rc = pci_enable_device_mem(pdev);
+	if (rc) {
+		dev_err(&pdev->dev, "Couldn't enable device, err %d\n", rc);
+		goto unmap;
+	}
+
+	pci_enable_pcie_error_reporting(pdev);
+
+	rc = sanitize_dev(fdev);
+	if (rc)
+		goto disable_dev;
+
+	fdev->fw_handle = FUN_HCI_ID_INVALID;
+	fdev->cmd_to_ms = (NVME_CAP_TIMEOUT(fdev->cap_reg) + 1) * 500;
+	fdev->q_depth = NVME_CAP_MQES(fdev->cap_reg) + 1;
+	fdev->db_stride = 1 << NVME_CAP_STRIDE(fdev->cap_reg);
+	fdev->dbs = fdev->bar + NVME_REG_DBS;
+
+	INIT_WORK(&fdev->service_task, fun_serv_handler);
+	fdev->service_flags = FUN_SERV_DISABLED;
+	fdev->serv_cb = areq->serv_cb;
+
+	rc = fun_alloc_irqs(pdev, areq->min_msix + 1); /* +1 for admin CQ */
+	if (rc < 0)
+		goto disable_dev;
+	fdev->num_irqs = rc;
+
+	rc = fun_alloc_irq_mgr(fdev);
+	if (rc)
+		goto free_irqs;
+
+	pci_set_master(pdev);
+	rc = fun_enable_admin_queue(fdev, areq);
+	if (rc)
+		goto free_irq_mgr;
+
+	rc = fun_get_dev_limits(fdev);
+	if (rc < 0)
+		goto disable_admin;
+
+	pci_save_state(pdev);
+	pci_set_drvdata(pdev, fdev);
+	pcie_print_link_status(pdev);
+	dev_dbg(fdev->dev, "q_depth %u, db_stride %u, max qid %d kern_end_qid %d\n",
+		fdev->q_depth, fdev->db_stride, fdev->max_qid,
+		fdev->kern_end_qid);
+	return 0;
+
+disable_admin:
+	fun_disable_admin_queue(fdev);
+free_irq_mgr:
+	pci_clear_master(pdev);
+	bitmap_free(fdev->irq_map);
+free_irqs:
+	pci_free_irq_vectors(pdev);
+disable_dev:
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
+unmap:
+	fun_unmap_bars(fdev);
+	return rc;
+}
+EXPORT_SYMBOL(fun_dev_enable);
+
+MODULE_AUTHOR("Dimitris Michailidis <dmichail@fungible.com>");
+MODULE_DESCRIPTION("Core services driver for Fungible devices");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/ethernet/fungible/funcore/fun_dev.h b/drivers/net/ethernet/fungible/funcore/fun_dev.h
new file mode 100644
index 000000000000..fa4a1461a3d8
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funcore/fun_dev.h
@@ -0,0 +1,151 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#ifndef _FUNDEV_H
+#define _FUNDEV_H
+
+#include <linux/sbitmap.h>
+#include <linux/spinlock_types.h>
+#include <linux/workqueue.h>
+#include "fun_hci.h"
+
+struct pci_dev;
+struct fun_dev;
+struct fun_queue;
+struct fun_cmd_ctx;
+struct fun_queue_alloc_req;
+
+/* doorbell fields */
+enum {
+	FUN_DB_QIDX_S = 0,
+	FUN_DB_INTCOAL_ENTRIES_S = 16,
+	FUN_DB_INTCOAL_ENTRIES_M = 0x7f,
+	FUN_DB_INTCOAL_USEC_S = 23,
+	FUN_DB_INTCOAL_USEC_M = 0x7f,
+	FUN_DB_IRQ_S = 30,
+	FUN_DB_IRQ_F = 1 << FUN_DB_IRQ_S,
+	FUN_DB_IRQ_ARM_S = 31,
+	FUN_DB_IRQ_ARM_F = 1U << FUN_DB_IRQ_ARM_S
+};
+
+/* Callback for asynchronous admin commands.
+ * Invoked on reception of command response.
+ */
+typedef void (*fun_admin_callback_t)(struct fun_dev *fdev, void *rsp,
+				     void *cb_data);
+
+/* Callback for events/notifications received by an admin queue. */
+typedef void (*fun_admin_event_cb)(struct fun_dev *fdev, void *cqe);
+
+/* Callback for pending work handled by the service task. */
+typedef void (*fun_serv_cb)(struct fun_dev *fd);
+
+/* service task flags */
+enum {
+	FUN_SERV_DISABLED,    /* service task is disabled */
+	FUN_SERV_FIRST_AVAIL
+};
+
+/* Driver state associated with a PCI function. */
+struct fun_dev {
+	struct device *dev;
+
+	void __iomem *bar;            /* start of BAR0 mapping */
+	u32 __iomem *dbs;             /* start of doorbells in BAR0 mapping */
+
+	/* admin queue */
+	struct fun_queue *admin_q;
+	struct sbitmap_queue admin_sbq;
+	struct fun_cmd_ctx *cmd_ctx;
+	fun_admin_event_cb adminq_cb;
+	bool suppress_cmds;           /* if set don't write commands to SQ */
+	unsigned int cmd_to_ms;       /* command timeout in ms */
+
+	/* address increment between consecutive doorbells, in 4B units */
+	unsigned int db_stride;
+
+	/* SW versions of device registers */
+	u32 cc_reg;         /* CC register */
+	u64 cap_reg;        /* CAPability register */
+
+	unsigned int q_depth;    /* max queue depth supported by device */
+	unsigned int max_qid;    /* = #queues - 1, separately for SQs and CQs */
+	unsigned int kern_end_qid; /* last qid in the kernel range + 1 */
+
+	unsigned int fw_handle;
+
+	/* IRQ manager */
+	unsigned int num_irqs;
+	unsigned int irqs_avail;
+	spinlock_t irqmgr_lock;
+	unsigned long *irq_map;
+
+	/* The service task handles work that needs a process context */
+	struct work_struct service_task;
+	unsigned long service_flags;
+	fun_serv_cb serv_cb;
+};
+
+struct fun_dev_params {
+	u8  cqe_size_log2; /* admin q CQE size */
+	u8  sqe_size_log2; /* admin q SQE size */
+
+	/* admin q depths */
+	u16 cq_depth;
+	u16 sq_depth;
+	u16 rq_depth;
+
+	u16 min_msix; /* min vectors needed by requesting driver */
+
+	fun_admin_event_cb event_cb;
+	fun_serv_cb serv_cb;
+};
+
+/* Return the BAR address of a doorbell. */
+static inline u32 __iomem *fun_db_addr(const struct fun_dev *fdev,
+				       unsigned int db_index)
+{
+	return &fdev->dbs[db_index * fdev->db_stride];
+}
+
+/* Return the BAR address of an SQ doorbell. SQ and CQ DBs alternate,
+ * SQs have even DB indices.
+ */
+static inline u32 __iomem *fun_sq_db_addr(const struct fun_dev *fdev,
+					  unsigned int sqid)
+{
+	return fun_db_addr(fdev, sqid * 2);
+}
+
+static inline u32 __iomem *fun_cq_db_addr(const struct fun_dev *fdev,
+					  unsigned int cqid)
+{
+	return fun_db_addr(fdev, cqid * 2 + 1);
+}
+
+int fun_get_res_count(struct fun_dev *fdev, enum fun_admin_op res);
+int fun_res_destroy(struct fun_dev *fdev, enum fun_admin_op res,
+		    unsigned int flags, u32 id);
+int fun_bind(struct fun_dev *fdev, enum fun_admin_bind_type type0,
+	     unsigned int id0, enum fun_admin_bind_type type1,
+	     unsigned int id1);
+
+int fun_submit_admin_cmd(struct fun_dev *fdev, struct fun_admin_req_common *cmd,
+			 fun_admin_callback_t cb, void *cb_data, bool wait_ok);
+int fun_submit_admin_sync_cmd(struct fun_dev *fdev,
+			      struct fun_admin_req_common *cmd, void *rsp,
+			      size_t rspsize, unsigned int timeout);
+
+int fun_dev_enable(struct fun_dev *fdev, struct pci_dev *pdev,
+		   const struct fun_dev_params *areq, const char *name);
+void fun_dev_disable(struct fun_dev *fdev);
+
+int fun_reserve_irqs(struct fun_dev *fdev, unsigned int nirqs,
+		     u16 *irq_indices);
+void fun_release_irqs(struct fun_dev *fdev, unsigned int nirqs,
+		      u16 *irq_indices);
+
+void fun_serv_stop(struct fun_dev *fd);
+void fun_serv_restart(struct fun_dev *fd);
+void fun_serv_sched(struct fun_dev *fd);
+
+#endif /* _FUNDEV_H */
diff --git a/drivers/net/ethernet/fungible/funcore/fun_hci.h b/drivers/net/ethernet/fungible/funcore/fun_hci.h
new file mode 100644
index 000000000000..c45b87fd1b40
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funcore/fun_hci.h
@@ -0,0 +1,1187 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#ifndef __FUN_HCI_H
+#define __FUN_HCI_H
+
+enum {
+	FUN_HCI_ID_INVALID = 0xffffffff,
+};
+
+enum fun_admin_op {
+	FUN_ADMIN_OP_BIND = 0x1,
+	FUN_ADMIN_OP_EPCQ = 0x11,
+	FUN_ADMIN_OP_EPSQ = 0x12,
+	FUN_ADMIN_OP_PORT = 0x13,
+	FUN_ADMIN_OP_ETH = 0x14,
+	FUN_ADMIN_OP_VI = 0x15,
+	FUN_ADMIN_OP_SWUPGRADE = 0x1f,
+	FUN_ADMIN_OP_RSS = 0x21,
+	FUN_ADMIN_OP_ADI = 0x25,
+	FUN_ADMIN_OP_KTLS = 0x26,
+};
+
+enum {
+	FUN_REQ_COMMON_FLAG_RSP = 0x1,
+	FUN_REQ_COMMON_FLAG_HEAD_WB = 0x2,
+	FUN_REQ_COMMON_FLAG_INT = 0x4,
+	FUN_REQ_COMMON_FLAG_CQE_IN_RQBUF = 0x8,
+};
+
+struct fun_admin_req_common {
+	__u8 op;
+	__u8 len8;
+	__be16 flags;
+	__u8 suboff8;
+	__u8 rsvd0;
+	__be16 cid;
+};
+
+#define FUN_ADMIN_REQ_COMMON_INIT(_op, _len8, _flags, _suboff8, _cid)       \
+	(struct fun_admin_req_common) {                                     \
+		.op = (_op), .len8 = (_len8), .flags = cpu_to_be16(_flags), \
+		.suboff8 = (_suboff8), .cid = cpu_to_be16(_cid),            \
+	}
+
+#define FUN_ADMIN_REQ_COMMON_INIT2(_op, _len)    \
+	(struct fun_admin_req_common) {          \
+		.op = (_op), .len8 = (_len) / 8, \
+	}
+
+struct fun_admin_rsp_common {
+	__u8 op;
+	__u8 len8;
+	__be16 flags;
+	__u8 suboff8;
+	__u8 ret;
+	__be16 cid;
+};
+
+struct fun_admin_write48_req {
+	__be64 key_to_data;
+};
+
+#define FUN_ADMIN_WRITE48_REQ_KEY_S 56U
+#define FUN_ADMIN_WRITE48_REQ_KEY_M 0xff
+#define FUN_ADMIN_WRITE48_REQ_KEY_P_NOSWAP(x) \
+	(((__u64)x) << FUN_ADMIN_WRITE48_REQ_KEY_S)
+
+#define FUN_ADMIN_WRITE48_REQ_DATA_S 0U
+#define FUN_ADMIN_WRITE48_REQ_DATA_M 0xffffffffffff
+#define FUN_ADMIN_WRITE48_REQ_DATA_P_NOSWAP(x) \
+	(((__u64)x) << FUN_ADMIN_WRITE48_REQ_DATA_S)
+
+#define FUN_ADMIN_WRITE48_REQ_INIT(key, data)                       \
+	(struct fun_admin_write48_req) {                            \
+		.key_to_data = cpu_to_be64(                         \
+			FUN_ADMIN_WRITE48_REQ_KEY_P_NOSWAP(key) |   \
+			FUN_ADMIN_WRITE48_REQ_DATA_P_NOSWAP(data)), \
+	}
+
+struct fun_admin_write48_rsp {
+	__be64 key_to_data;
+};
+
+struct fun_admin_read48_req {
+	__be64 key_pack;
+};
+
+#define FUN_ADMIN_READ48_REQ_KEY_S 56U
+#define FUN_ADMIN_READ48_REQ_KEY_M 0xff
+#define FUN_ADMIN_READ48_REQ_KEY_P_NOSWAP(x) \
+	(((__u64)x) << FUN_ADMIN_READ48_REQ_KEY_S)
+
+#define FUN_ADMIN_READ48_REQ_INIT(key)                                       \
+	(struct fun_admin_read48_req) {                                      \
+		.key_pack =                                                  \
+			cpu_to_be64(FUN_ADMIN_READ48_REQ_KEY_P_NOSWAP(key)), \
+	}
+
+struct fun_admin_read48_rsp {
+	__be64 key_to_data;
+};
+
+#define FUN_ADMIN_READ48_RSP_KEY_S 56U
+#define FUN_ADMIN_READ48_RSP_KEY_M 0xff
+#define FUN_ADMIN_READ48_RSP_KEY_G(x)                     \
+	((be64_to_cpu(x) >> FUN_ADMIN_READ48_RSP_KEY_S) & \
+	 FUN_ADMIN_READ48_RSP_KEY_M)
+
+#define FUN_ADMIN_READ48_RSP_RET_S 48U
+#define FUN_ADMIN_READ48_RSP_RET_M 0xff
+#define FUN_ADMIN_READ48_RSP_RET_G(x)                     \
+	((be64_to_cpu(x) >> FUN_ADMIN_READ48_RSP_RET_S) & \
+	 FUN_ADMIN_READ48_RSP_RET_M)
+
+#define FUN_ADMIN_READ48_RSP_DATA_S 0U
+#define FUN_ADMIN_READ48_RSP_DATA_M 0xffffffffffff
+#define FUN_ADMIN_READ48_RSP_DATA_G(x)                     \
+	((be64_to_cpu(x) >> FUN_ADMIN_READ48_RSP_DATA_S) & \
+	 FUN_ADMIN_READ48_RSP_DATA_M)
+
+enum fun_admin_bind_type {
+	FUN_ADMIN_BIND_TYPE_EPCQ = 0x1,
+	FUN_ADMIN_BIND_TYPE_EPSQ = 0x2,
+	FUN_ADMIN_BIND_TYPE_PORT = 0x3,
+	FUN_ADMIN_BIND_TYPE_RSS = 0x4,
+	FUN_ADMIN_BIND_TYPE_VI = 0x5,
+	FUN_ADMIN_BIND_TYPE_ETH = 0x6,
+};
+
+struct fun_admin_bind_entry {
+	__u8 type;
+	__u8 rsvd0[3];
+	__be32 id;
+};
+
+#define FUN_ADMIN_BIND_ENTRY_INIT(_type, _id)            \
+	(struct fun_admin_bind_entry) {                  \
+		.type = (_type), .id = cpu_to_be32(_id), \
+	}
+
+struct fun_admin_bind_req {
+	struct fun_admin_req_common common;
+	struct fun_admin_bind_entry entry[];
+};
+
+struct fun_admin_bind_rsp {
+	struct fun_admin_rsp_common bind_rsp_common;
+};
+
+struct fun_admin_simple_subop {
+	__u8 subop;
+	__u8 rsvd0;
+	__be16 flags;
+	__be32 data;
+};
+
+#define FUN_ADMIN_SIMPLE_SUBOP_INIT(_subop, _flags, _data)       \
+	(struct fun_admin_simple_subop) {                        \
+		.subop = (_subop), .flags = cpu_to_be16(_flags), \
+		.data = cpu_to_be32(_data),                      \
+	}
+
+enum fun_admin_subop {
+	FUN_ADMIN_SUBOP_CREATE = 0x10,
+	FUN_ADMIN_SUBOP_DESTROY = 0x11,
+	FUN_ADMIN_SUBOP_MODIFY = 0x12,
+	FUN_ADMIN_SUBOP_RES_COUNT = 0x14,
+	FUN_ADMIN_SUBOP_READ = 0x15,
+	FUN_ADMIN_SUBOP_WRITE = 0x16,
+	FUN_ADMIN_SUBOP_NOTIFY = 0x17,
+};
+
+enum {
+	FUN_ADMIN_RES_CREATE_FLAG_ALLOCATOR = 0x1,
+};
+
+struct fun_admin_generic_destroy_req {
+	struct fun_admin_req_common common;
+	struct fun_admin_simple_subop destroy;
+};
+
+struct fun_admin_generic_create_rsp {
+	struct fun_admin_rsp_common common;
+
+	__u8 subop;
+	__u8 rsvd0;
+	__be16 flags;
+	__be32 id;
+};
+
+struct fun_admin_res_count_req {
+	struct fun_admin_req_common common;
+	struct fun_admin_simple_subop count;
+};
+
+struct fun_admin_res_count_rsp {
+	struct fun_admin_rsp_common common;
+	struct fun_admin_simple_subop count;
+};
+
+enum {
+	FUN_ADMIN_EPCQ_CREATE_FLAG_INT_EPCQ = 0x2,
+	FUN_ADMIN_EPCQ_CREATE_FLAG_ENTRY_WR_TPH = 0x4,
+	FUN_ADMIN_EPCQ_CREATE_FLAG_SL_WR_TPH = 0x8,
+	FUN_ADMIN_EPCQ_CREATE_FLAG_RQ = 0x80,
+	FUN_ADMIN_EPCQ_CREATE_FLAG_INT_IQ = 0x100,
+	FUN_ADMIN_EPCQ_CREATE_FLAG_INT_NOARM = 0x200,
+	FUN_ADMIN_EPCQ_CREATE_FLAG_DROP_ON_OVERFLOW = 0x400,
+};
+
+struct fun_admin_epcq_req {
+	struct fun_admin_req_common common;
+
+	union epcq_req_subop {
+		struct fun_admin_epcq_create_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+
+			__be32 epsqid;
+			__u8 rsvd1;
+			__u8 entry_size_log2;
+			__be16 nentries;
+
+			__be64 address; /* DMA address of epcq */
+
+			__be16 tailroom; /* per packet tailroom in bytes */
+			__u8 headroom; /* per packet headroom in 2B units */
+			__u8 intcoal_kbytes;
+			__u8 intcoal_holdoff_nentries;
+			__u8 intcoal_holdoff_usecs;
+			__be16 intid;
+
+			__be32 scan_start_id;
+			__be32 scan_end_id;
+
+			__be16 tph_cpuid;
+			__u8 rsvd3[6];
+		} create;
+	} u;
+};
+
+#define FUN_ADMIN_EPCQ_CREATE_REQ_INIT(                                      \
+	_subop, _flags, _id, _epsqid, _entry_size_log2, _nentries, _address, \
+	_tailroom, _headroom, _intcoal_kbytes, _intcoal_holdoff_nentries,    \
+	_intcoal_holdoff_usecs, _intid, _scan_start_id, _scan_end_id,        \
+	_tph_cpuid)                                                          \
+	(struct fun_admin_epcq_create_req) {                                 \
+		.subop = (_subop), .flags = cpu_to_be16(_flags),             \
+		.id = cpu_to_be32(_id), .epsqid = cpu_to_be32(_epsqid),      \
+		.entry_size_log2 = _entry_size_log2,                         \
+		.nentries = cpu_to_be16(_nentries),                          \
+		.address = cpu_to_be64(_address),                            \
+		.tailroom = cpu_to_be16(_tailroom), .headroom = _headroom,   \
+		.intcoal_kbytes = _intcoal_kbytes,                           \
+		.intcoal_holdoff_nentries = _intcoal_holdoff_nentries,       \
+		.intcoal_holdoff_usecs = _intcoal_holdoff_usecs,             \
+		.intid = cpu_to_be16(_intid),                                \
+		.scan_start_id = cpu_to_be32(_scan_start_id),                \
+		.scan_end_id = cpu_to_be32(_scan_end_id),                    \
+		.tph_cpuid = cpu_to_be16(_tph_cpuid),                        \
+	}
+
+enum {
+	FUN_ADMIN_EPSQ_CREATE_FLAG_INT_EPSQ = 0x2,
+	FUN_ADMIN_EPSQ_CREATE_FLAG_ENTRY_RD_TPH = 0x4,
+	FUN_ADMIN_EPSQ_CREATE_FLAG_GL_RD_TPH = 0x8,
+	FUN_ADMIN_EPSQ_CREATE_FLAG_HEAD_WB_ADDRESS = 0x10,
+	FUN_ADMIN_EPSQ_CREATE_FLAG_HEAD_WB_ADDRESS_TPH = 0x20,
+	FUN_ADMIN_EPSQ_CREATE_FLAG_HEAD_WB_EPCQ = 0x40,
+	FUN_ADMIN_EPSQ_CREATE_FLAG_RQ = 0x80,
+	FUN_ADMIN_EPSQ_CREATE_FLAG_INT_IQ = 0x100,
+	FUN_ADMIN_EPSQ_CREATE_FLAG_NO_CMPL = 0x200,
+};
+
+struct fun_admin_epsq_req {
+	struct fun_admin_req_common common;
+
+	union epsq_req_subop {
+		struct fun_admin_epsq_create_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+
+			__be32 epcqid;
+			__u8 rsvd1;
+			__u8 entry_size_log2;
+			__be16 nentries;
+
+			__be64 address; /* DMA address of epsq */
+
+			__u8 rsvd2[3];
+			__u8 intcoal_kbytes;
+			__u8 intcoal_holdoff_nentries;
+			__u8 intcoal_holdoff_usecs;
+			__be16 intid;
+
+			__be32 scan_start_id;
+			__be32 scan_end_id;
+
+			__u8 rsvd3[4];
+			__be16 tph_cpuid;
+			__u8 buf_size_log2; /* log2 of RQ buffer size */
+			__u8 head_wb_size_log2; /* log2 of head write back size */
+
+			__be64 head_wb_address; /* DMA address for head writeback */
+		} create;
+	} u;
+};
+
+#define FUN_ADMIN_EPSQ_CREATE_REQ_INIT(                                      \
+	_subop, _flags, _id, _epcqid, _entry_size_log2, _nentries, _address, \
+	_intcoal_kbytes, _intcoal_holdoff_nentries, _intcoal_holdoff_usecs,  \
+	_intid, _scan_start_id, _scan_end_id, _tph_cpuid, _buf_size_log2,    \
+	_head_wb_size_log2, _head_wb_address)                                \
+	(struct fun_admin_epsq_create_req) {                                 \
+		.subop = (_subop), .flags = cpu_to_be16(_flags),             \
+		.id = cpu_to_be32(_id), .epcqid = cpu_to_be32(_epcqid),      \
+		.entry_size_log2 = _entry_size_log2,                         \
+		.nentries = cpu_to_be16(_nentries),                          \
+		.address = cpu_to_be64(_address),                            \
+		.intcoal_kbytes = _intcoal_kbytes,                           \
+		.intcoal_holdoff_nentries = _intcoal_holdoff_nentries,       \
+		.intcoal_holdoff_usecs = _intcoal_holdoff_usecs,             \
+		.intid = cpu_to_be16(_intid),                                \
+		.scan_start_id = cpu_to_be32(_scan_start_id),                \
+		.scan_end_id = cpu_to_be32(_scan_end_id),                    \
+		.tph_cpuid = cpu_to_be16(_tph_cpuid),                        \
+		.buf_size_log2 = _buf_size_log2,                             \
+		.head_wb_size_log2 = _head_wb_size_log2,                     \
+		.head_wb_address = cpu_to_be64(_head_wb_address),            \
+	}
+
+enum {
+	FUN_PORT_CAP_OFFLOADS = 0x1,
+	FUN_PORT_CAP_STATS = 0x2,
+	FUN_PORT_CAP_LOOPBACK = 0x4,
+	FUN_PORT_CAP_VPORT = 0x8,
+	FUN_PORT_CAP_TX_PAUSE = 0x10,
+	FUN_PORT_CAP_RX_PAUSE = 0x20,
+	FUN_PORT_CAP_AUTONEG = 0x40,
+	FUN_PORT_CAP_RSS = 0x80,
+	FUN_PORT_CAP_VLAN_OFFLOADS = 0x100,
+	FUN_PORT_CAP_ENCAP_OFFLOADS = 0x200,
+	FUN_PORT_CAP_1000_X = 0x1000,
+	FUN_PORT_CAP_10G_R = 0x2000,
+	FUN_PORT_CAP_40G_R4 = 0x4000,
+	FUN_PORT_CAP_25G_R = 0x8000,
+	FUN_PORT_CAP_50G_R2 = 0x10000,
+	FUN_PORT_CAP_50G_R = 0x20000,
+	FUN_PORT_CAP_100G_R4 = 0x40000,
+	FUN_PORT_CAP_100G_R2 = 0x80000,
+	FUN_PORT_CAP_200G_R4 = 0x100000,
+	FUN_PORT_CAP_FEC_NONE = 0x10000000,
+	FUN_PORT_CAP_FEC_FC = 0x20000000,
+	FUN_PORT_CAP_FEC_RS = 0x40000000,
+};
+
+enum fun_port_brkout_mode {
+	FUN_PORT_BRKMODE_NA = 0x0,
+	FUN_PORT_BRKMODE_NONE = 0x1,
+	FUN_PORT_BRKMODE_2X = 0x2,
+	FUN_PORT_BRKMODE_4X = 0x3,
+};
+
+enum {
+	FUN_PORT_SPEED_AUTO = 0x0,
+	FUN_PORT_SPEED_10M = 0x1,
+	FUN_PORT_SPEED_100M = 0x2,
+	FUN_PORT_SPEED_1G = 0x4,
+	FUN_PORT_SPEED_10G = 0x8,
+	FUN_PORT_SPEED_25G = 0x10,
+	FUN_PORT_SPEED_40G = 0x20,
+	FUN_PORT_SPEED_50G = 0x40,
+	FUN_PORT_SPEED_100G = 0x80,
+	FUN_PORT_SPEED_200G = 0x100,
+};
+
+enum fun_port_duplex_mode {
+	FUN_PORT_FULL_DUPLEX = 0x0,
+	FUN_PORT_HALF_DUPLEX = 0x1,
+};
+
+enum {
+	FUN_PORT_FEC_NA = 0x0,
+	FUN_PORT_FEC_OFF = 0x1,
+	FUN_PORT_FEC_RS = 0x2,
+	FUN_PORT_FEC_FC = 0x4,
+	FUN_PORT_FEC_AUTO = 0x8,
+};
+
+enum fun_port_link_status {
+	FUN_PORT_LINK_UP = 0x0,
+	FUN_PORT_LINK_UP_WITH_ERR = 0x1,
+	FUN_PORT_LINK_DOWN = 0x2,
+};
+
+enum fun_port_led_type {
+	FUN_PORT_LED_OFF = 0x0,
+	FUN_PORT_LED_AMBER = 0x1,
+	FUN_PORT_LED_GREEN = 0x2,
+	FUN_PORT_LED_BEACON_ON = 0x3,
+	FUN_PORT_LED_BEACON_OFF = 0x4,
+};
+
+enum {
+	FUN_PORT_FLAG_MAC_DOWN = 0x1,
+	FUN_PORT_FLAG_MAC_UP = 0x2,
+	FUN_PORT_FLAG_NH_DOWN = 0x4,
+	FUN_PORT_FLAG_NH_UP = 0x8,
+};
+
+enum {
+	FUN_PORT_FLAG_ENABLE_NOTIFY = 0x1,
+};
+
+enum fun_port_lane_attr {
+	FUN_PORT_LANE_1 = 0x1,
+	FUN_PORT_LANE_2 = 0x2,
+	FUN_PORT_LANE_4 = 0x4,
+	FUN_PORT_LANE_SPEED_10G = 0x100,
+	FUN_PORT_LANE_SPEED_25G = 0x200,
+	FUN_PORT_LANE_SPEED_50G = 0x400,
+	FUN_PORT_LANE_SPLIT = 0x8000,
+};
+
+enum fun_admin_port_subop {
+	FUN_ADMIN_PORT_SUBOP_INETADDR_EVENT = 0x24,
+};
+
+enum fun_admin_port_key {
+	FUN_ADMIN_PORT_KEY_ILLEGAL = 0x0,
+	FUN_ADMIN_PORT_KEY_MTU = 0x1,
+	FUN_ADMIN_PORT_KEY_FEC = 0x2,
+	FUN_ADMIN_PORT_KEY_SPEED = 0x3,
+	FUN_ADMIN_PORT_KEY_DEBOUNCE = 0x4,
+	FUN_ADMIN_PORT_KEY_DUPLEX = 0x5,
+	FUN_ADMIN_PORT_KEY_MACADDR = 0x6,
+	FUN_ADMIN_PORT_KEY_LINKMODE = 0x7,
+	FUN_ADMIN_PORT_KEY_BREAKOUT = 0x8,
+	FUN_ADMIN_PORT_KEY_ENABLE = 0x9,
+	FUN_ADMIN_PORT_KEY_DISABLE = 0xa,
+	FUN_ADMIN_PORT_KEY_ERR_DISABLE = 0xb,
+	FUN_ADMIN_PORT_KEY_CAPABILITIES = 0xc,
+	FUN_ADMIN_PORT_KEY_LP_CAPABILITIES = 0xd,
+	FUN_ADMIN_PORT_KEY_STATS_DMA_LOW = 0xe,
+	FUN_ADMIN_PORT_KEY_STATS_DMA_HIGH = 0xf,
+	FUN_ADMIN_PORT_KEY_LANE_ATTRS = 0x10,
+	FUN_ADMIN_PORT_KEY_LED = 0x11,
+	FUN_ADMIN_PORT_KEY_ADVERT = 0x12,
+};
+
+struct fun_subop_imm {
+	__u8 subop; /* see fun_data_subop enum */
+	__u8 flags;
+	__u8 nsgl;
+	__u8 rsvd0;
+	__be32 len;
+
+	__u8 data[];
+};
+
+enum fun_subop_sgl_flags {
+	FUN_SUBOP_SGL_USE_OFF8 = 0x1,
+	FUN_SUBOP_FLAG_FREE_BUF = 0x2,
+	FUN_SUBOP_FLAG_IS_REFBUF = 0x4,
+	FUN_SUBOP_SGL_FLAG_LOCAL = 0x8,
+};
+
+enum fun_data_op {
+	FUN_DATAOP_INVALID = 0x0,
+	FUN_DATAOP_SL = 0x1, /* scatter */
+	FUN_DATAOP_GL = 0x2, /* gather */
+	FUN_DATAOP_SGL = 0x3, /* scatter-gather */
+	FUN_DATAOP_IMM = 0x4, /* immediate data */
+	FUN_DATAOP_RQBUF = 0x8, /* rq buffer */
+};
+
+struct fun_dataop_gl {
+	__u8 subop;
+	__u8 flags;
+	__be16 sgl_off;
+	__be32 sgl_len;
+
+	__be64 sgl_data;
+};
+
+static inline void fun_dataop_gl_init(struct fun_dataop_gl *s, u8 flags,
+				      u16 sgl_off, u32 sgl_len, u64 sgl_data)
+{
+	s->subop = FUN_DATAOP_GL;
+	s->flags = flags;
+	s->sgl_off = cpu_to_be16(sgl_off);
+	s->sgl_len = cpu_to_be32(sgl_len);
+	s->sgl_data = cpu_to_be64(sgl_data);
+}
+
+struct fun_dataop_imm {
+	__u8 subop;
+	__u8 flags;
+	__be16 rsvd0;
+	__be32 sgl_len;
+};
+
+struct fun_subop_sgl {
+	__u8 subop;
+	__u8 flags;
+	__u8 nsgl;
+	__u8 rsvd0;
+	__be32 sgl_len;
+
+	__be64 sgl_data;
+};
+
+#define FUN_SUBOP_SGL_INIT(_subop, _flags, _nsgl, _sgl_len, _sgl_data) \
+	(struct fun_subop_sgl) {                                       \
+		.subop = (_subop), .flags = (_flags), .nsgl = (_nsgl), \
+		.sgl_len = cpu_to_be32(_sgl_len),                      \
+		.sgl_data = cpu_to_be64(_sgl_data),                    \
+	}
+
+struct fun_dataop_rqbuf {
+	__u8 subop;
+	__u8 rsvd0;
+	__be16 cid;
+	__be32 bufoff;
+};
+
+struct fun_dataop_hdr {
+	__u8 nsgl;
+	__u8 flags;
+	__u8 ngather;
+	__u8 nscatter;
+	__be32 total_len;
+
+	struct fun_dataop_imm imm[];
+};
+
+#define FUN_DATAOP_HDR_INIT(_nsgl, _flags, _ngather, _nscatter, _total_len)  \
+	(struct fun_dataop_hdr) {                                            \
+		.nsgl = _nsgl, .flags = _flags, .ngather = _ngather,         \
+		.nscatter = _nscatter, .total_len = cpu_to_be32(_total_len), \
+	}
+
+enum fun_port_inetaddr_event_type {
+	FUN_PORT_INETADDR_ADD = 0x1,
+	FUN_PORT_INETADDR_DEL = 0x2,
+};
+
+enum fun_port_inetaddr_addr_family {
+	FUN_PORT_INETADDR_IPV4 = 0x1,
+	FUN_PORT_INETADDR_IPV6 = 0x2,
+};
+
+struct fun_admin_port_req {
+	struct fun_admin_req_common common;
+
+	union port_req_subop {
+		struct fun_admin_port_create_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+		} create;
+		struct fun_admin_port_write_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id; /* portid */
+
+			struct fun_admin_write48_req write48[];
+		} write;
+		struct fun_admin_port_read_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id; /* portid */
+
+			struct fun_admin_read48_req read48[];
+		} read;
+		struct fun_admin_port_inetaddr_event_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__u8 event_type;
+			__u8 addr_family;
+			__be32 id;
+
+			__u8 addr[];
+		} inetaddr_event;
+	} u;
+};
+
+#define FUN_ADMIN_PORT_CREATE_REQ_INIT(_subop, _flags, _id)      \
+	(struct fun_admin_port_create_req) {                     \
+		.subop = (_subop), .flags = cpu_to_be16(_flags), \
+		.id = cpu_to_be32(_id),                          \
+	}
+
+#define FUN_ADMIN_PORT_WRITE_REQ_INIT(_subop, _flags, _id)       \
+	(struct fun_admin_port_write_req) {                      \
+		.subop = (_subop), .flags = cpu_to_be16(_flags), \
+		.id = cpu_to_be32(_id),                          \
+	}
+
+#define FUN_ADMIN_PORT_READ_REQ_INIT(_subop, _flags, _id)        \
+	(struct fun_admin_port_read_req) {                       \
+		.subop = (_subop), .flags = cpu_to_be16(_flags), \
+		.id = cpu_to_be32(_id),                          \
+	}
+
+struct fun_admin_port_rsp {
+	struct fun_admin_rsp_common common;
+
+	union port_rsp_subop {
+		struct fun_admin_port_create_rsp {
+			__u8 subop;
+			__u8 rsvd0[3];
+			__be32 id;
+
+			__be16 lport;
+			__u8 rsvd1[6];
+		} create;
+		struct fun_admin_port_write_rsp {
+			__u8 subop;
+			__u8 rsvd0[3];
+			__be32 id; /* portid */
+
+			struct fun_admin_write48_rsp write48[];
+		} write;
+		struct fun_admin_port_read_rsp {
+			__u8 subop;
+			__u8 rsvd0[3];
+			__be32 id; /* portid */
+
+			struct fun_admin_read48_rsp read48[];
+		} read;
+		struct fun_admin_port_inetaddr_event_rsp {
+			__u8 subop;
+			__u8 rsvd0[3];
+			__be32 id; /* portid */
+		} inetaddr_event;
+	} u;
+};
+
+enum fun_xcvr_type {
+	FUN_XCVR_BASET = 0x0,
+	FUN_XCVR_CU = 0x1,
+	FUN_XCVR_SMF = 0x2,
+	FUN_XCVR_MMF = 0x3,
+	FUN_XCVR_AOC = 0x4,
+	FUN_XCVR_SFPP = 0x10, /* SFP+ or later */
+	FUN_XCVR_QSFPP = 0x11, /* QSFP+ or later */
+	FUN_XCVR_QSFPDD = 0x12, /* QSFP-DD */
+};
+
+struct fun_admin_port_notif {
+	struct fun_admin_rsp_common common;
+
+	__u8 subop;
+	__u8 rsvd0;
+	__be16 id;
+	__be32 speed; /* in 10 Mbps units */
+
+	__u8 link_state;
+	__u8 missed_events;
+	__u8 link_down_reason;
+	__u8 xcvr_type;
+	__u8 flow_ctrl;
+	__u8 fec;
+	__u8 active_lanes;
+	__u8 rsvd1;
+
+	__be64 advertising;
+
+	__be64 lp_advertising;
+};
+
+enum fun_eth_rss_const {
+	FUN_ETH_RSS_MAX_KEY_SIZE = 0x28,
+	FUN_ETH_RSS_MAX_INDIR_ENT = 0x40,
+};
+
+enum fun_eth_hash_alg {
+	FUN_ETH_RSS_ALG_INVALID = 0x0,
+	FUN_ETH_RSS_ALG_TOEPLITZ = 0x1,
+	FUN_ETH_RSS_ALG_CRC32 = 0x2,
+};
+
+struct fun_admin_rss_req {
+	struct fun_admin_req_common common;
+
+	union rss_req_subop {
+		struct fun_admin_rss_create_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+
+			__be32 rsvd1;
+			__be32 viid; /* VI flow id */
+
+			__be64 metadata[1];
+
+			__u8 alg;
+			__u8 keylen;
+			__u8 indir_nent;
+			__u8 rsvd2;
+			__be16 key_off;
+			__be16 indir_off;
+
+			struct fun_dataop_hdr dataop;
+		} create;
+	} u;
+};
+
+#define FUN_ADMIN_RSS_CREATE_REQ_INIT(_subop, _flags, _id, _viid, _alg,    \
+				      _keylen, _indir_nent, _key_off,      \
+				      _indir_off)                          \
+	(struct fun_admin_rss_create_req) {                                \
+		.subop = (_subop), .flags = cpu_to_be16(_flags),           \
+		.id = cpu_to_be32(_id), .viid = cpu_to_be32(_viid),        \
+		.alg = _alg, .keylen = _keylen, .indir_nent = _indir_nent, \
+		.key_off = cpu_to_be16(_key_off),                          \
+		.indir_off = cpu_to_be16(_indir_off),                      \
+	}
+
+struct fun_admin_vi_req {
+	struct fun_admin_req_common common;
+
+	union vi_req_subop {
+		struct fun_admin_vi_create_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+
+			__be32 rsvd1;
+			__be32 portid; /* port flow id */
+		} create;
+	} u;
+};
+
+#define FUN_ADMIN_VI_CREATE_REQ_INIT(_subop, _flags, _id, _portid)      \
+	(struct fun_admin_vi_create_req) {                              \
+		.subop = (_subop), .flags = cpu_to_be16(_flags),        \
+		.id = cpu_to_be32(_id), .portid = cpu_to_be32(_portid), \
+	}
+
+struct fun_admin_eth_req {
+	struct fun_admin_req_common common;
+
+	union eth_req_subop {
+		struct fun_admin_eth_create_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+
+			__be32 rsvd1;
+			__be32 portid; /* port flow id */
+		} create;
+	} u;
+};
+
+#define FUN_ADMIN_ETH_CREATE_REQ_INIT(_subop, _flags, _id, _portid)     \
+	(struct fun_admin_eth_create_req) {                             \
+		.subop = (_subop), .flags = cpu_to_be16(_flags),        \
+		.id = cpu_to_be32(_id), .portid = cpu_to_be32(_portid), \
+	}
+
+enum {
+	FUN_ADMIN_SWU_UPGRADE_FLAG_INIT = 0x10,
+	FUN_ADMIN_SWU_UPGRADE_FLAG_COMPLETE = 0x20,
+	FUN_ADMIN_SWU_UPGRADE_FLAG_DOWNGRADE = 0x40,
+	FUN_ADMIN_SWU_UPGRADE_FLAG_ACTIVE_IMAGE = 0x80,
+	FUN_ADMIN_SWU_UPGRADE_FLAG_ASYNC = 0x1,
+};
+
+enum fun_admin_swu_subop {
+	FUN_ADMIN_SWU_SUBOP_GET_VERSION = 0x20,
+	FUN_ADMIN_SWU_SUBOP_UPGRADE = 0x21,
+	FUN_ADMIN_SWU_SUBOP_UPGRADE_DATA = 0x22,
+	FUN_ADMIN_SWU_SUBOP_GET_ALL_VERSIONS = 0x23,
+};
+
+struct fun_admin_swu_req {
+	struct fun_admin_req_common common;
+
+	union swu_req_subop {
+		struct fun_admin_swu_create_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+		} create;
+		struct fun_admin_swu_upgrade_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+
+			__be32 fourcc;
+			__be32 rsvd1;
+
+			__be64 image_size; /* upgrade image length */
+		} upgrade;
+		struct fun_admin_swu_upgrade_data_req {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+
+			__be32 offset; /* offset of data in this command */
+			__be32 size; /* total size of data in this command */
+		} upgrade_data;
+	} u;
+
+	struct fun_subop_sgl sgl[]; /* in, out buffers through sgl */
+};
+
+#define FUN_ADMIN_SWU_CREATE_REQ_INIT(_subop, _flags, _id)       \
+	(struct fun_admin_swu_create_req) {                      \
+		.subop = (_subop), .flags = cpu_to_be16(_flags), \
+		.id = cpu_to_be32(_id),                          \
+	}
+
+#define FUN_ADMIN_SWU_UPGRADE_REQ_INIT(_subop, _flags, _id, _fourcc,    \
+				       _image_size)                     \
+	(struct fun_admin_swu_upgrade_req) {                            \
+		.subop = (_subop), .flags = cpu_to_be16(_flags),        \
+		.id = cpu_to_be32(_id), .fourcc = cpu_to_be32(_fourcc), \
+		.image_size = cpu_to_be64(_image_size),                 \
+	}
+
+#define FUN_ADMIN_SWU_UPGRADE_DATA_REQ_INIT(_subop, _flags, _id, _offset, \
+					    _size)                        \
+	(struct fun_admin_swu_upgrade_data_req) {                         \
+		.subop = (_subop), .flags = cpu_to_be16(_flags),          \
+		.id = cpu_to_be32(_id), .offset = cpu_to_be32(_offset),   \
+		.size = cpu_to_be32(_size),                               \
+	}
+
+struct fun_admin_swu_rsp {
+	struct fun_admin_rsp_common common;
+
+	union swu_rsp_subop {
+		struct fun_admin_swu_create_rsp {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+		} create;
+		struct fun_admin_swu_upgrade_rsp {
+			__u8 subop;
+			__u8 rsvd0[3];
+			__be32 id;
+
+			__be32 fourcc;
+			__be32 status;
+
+			__be32 progress;
+			__be32 unused;
+		} upgrade;
+		struct fun_admin_swu_upgrade_data_rsp {
+			__u8 subop;
+			__u8 rsvd0;
+			__be16 flags;
+			__be32 id;
+
+			__be32 offset;
+			__be32 size;
+		} upgrade_data;
+	} u;
+};
+
+enum fun_ktls_version {
+	FUN_KTLS_TLSV2 = 0x20,
+	FUN_KTLS_TLSV3 = 0x30,
+};
+
+enum fun_ktls_cipher {
+	FUN_KTLS_CIPHER_AES_GCM_128 = 0x33,
+	FUN_KTLS_CIPHER_AES_GCM_256 = 0x34,
+	FUN_KTLS_CIPHER_AES_CCM_128 = 0x35,
+	FUN_KTLS_CIPHER_CHACHA20_POLY1305 = 0x36,
+};
+
+enum fun_ktls_modify_flags {
+	FUN_KTLS_MODIFY_REMOVE = 0x1,
+};
+
+struct fun_admin_ktls_create_req {
+	struct fun_admin_req_common common;
+
+	__u8 subop;
+	__u8 rsvd0;
+	__be16 flags;
+	__be32 id;
+};
+
+#define FUN_ADMIN_KTLS_CREATE_REQ_INIT(_subop, _flags, _id)      \
+	(struct fun_admin_ktls_create_req) {                     \
+		.subop = (_subop), .flags = cpu_to_be16(_flags), \
+		.id = cpu_to_be32(_id),                          \
+	}
+
+struct fun_admin_ktls_create_rsp {
+	struct fun_admin_rsp_common common;
+
+	__u8 subop;
+	__u8 rsvd0[3];
+	__be32 id;
+};
+
+struct fun_admin_ktls_modify_req {
+	struct fun_admin_req_common common;
+
+	__u8 subop;
+	__u8 rsvd0;
+	__be16 flags;
+	__be32 id;
+
+	__be64 tlsid;
+
+	__be32 tcp_seq;
+	__u8 version;
+	__u8 cipher;
+	__u8 rsvd1[2];
+
+	__u8 record_seq[8];
+
+	__u8 key[32];
+
+	__u8 iv[16];
+
+	__u8 salt[8];
+};
+
+#define FUN_ADMIN_KTLS_MODIFY_REQ_INIT(_subop, _flags, _id, _tlsid, _tcp_seq, \
+				       _version, _cipher)                     \
+	(struct fun_admin_ktls_modify_req) {                                  \
+		.subop = (_subop), .flags = cpu_to_be16(_flags),              \
+		.id = cpu_to_be32(_id), .tlsid = cpu_to_be64(_tlsid),         \
+		.tcp_seq = cpu_to_be32(_tcp_seq), .version = _version,        \
+		.cipher = _cipher,                                            \
+	}
+
+struct fun_admin_ktls_modify_rsp {
+	struct fun_admin_rsp_common common;
+
+	__u8 subop;
+	__u8 rsvd0[3];
+	__be32 id;
+
+	__be64 tlsid;
+};
+
+struct fun_req_common {
+	__u8 op;
+	__u8 len8;
+	__be16 flags;
+	__u8 suboff8;
+	__u8 rsvd0;
+	__be16 cid;
+};
+
+struct fun_rsp_common {
+	__u8 op;
+	__u8 len8;
+	__be16 flags;
+	__u8 suboff8;
+	__u8 ret;
+	__be16 cid;
+};
+
+struct fun_cqe_info {
+	__be16 sqhd;
+	__be16 sqid;
+	__be16 cid;
+	__be16 sf_p;
+};
+
+enum fun_eprq_def {
+	FUN_EPRQ_PKT_ALIGN = 0x80,
+};
+
+struct fun_eprq_rqbuf {
+	__be64 bufaddr;
+};
+
+#define FUN_EPRQ_RQBUF_INIT(_bufaddr)             \
+	(struct fun_eprq_rqbuf) {                 \
+		.bufaddr = cpu_to_be64(_bufaddr), \
+	}
+
+enum fun_eth_op {
+	FUN_ETH_OP_TX = 0x1,
+	FUN_ETH_OP_RX = 0x2,
+};
+
+enum {
+	FUN_ETH_OFFLOAD_EN = 0x8000,
+	FUN_ETH_OUTER_EN = 0x4000,
+	FUN_ETH_INNER_LSO = 0x2000,
+	FUN_ETH_INNER_TSO = 0x1000,
+	FUN_ETH_OUTER_IPV6 = 0x800,
+	FUN_ETH_OUTER_UDP = 0x400,
+	FUN_ETH_INNER_IPV6 = 0x200,
+	FUN_ETH_INNER_UDP = 0x100,
+	FUN_ETH_UPDATE_OUTER_L3_LEN = 0x80,
+	FUN_ETH_UPDATE_OUTER_L3_CKSUM = 0x40,
+	FUN_ETH_UPDATE_OUTER_L4_LEN = 0x20,
+	FUN_ETH_UPDATE_OUTER_L4_CKSUM = 0x10,
+	FUN_ETH_UPDATE_INNER_L3_LEN = 0x8,
+	FUN_ETH_UPDATE_INNER_L3_CKSUM = 0x4,
+	FUN_ETH_UPDATE_INNER_L4_LEN = 0x2,
+	FUN_ETH_UPDATE_INNER_L4_CKSUM = 0x1,
+};
+
+struct fun_eth_offload {
+	__be16 flags; /* combination of above flags */
+	__be16 mss; /* TSO max seg size */
+	__be16 tcp_doff_flags; /* TCP data offset + flags 16b word */
+	__be16 vlan;
+
+	__be16 inner_l3_off; /* Inner L3 header offset */
+	__be16 inner_l4_off; /* Inner L4 header offset */
+	__be16 outer_l3_off; /* Outer L3 header offset */
+	__be16 outer_l4_off; /* Outer L4 header offset */
+};
+
+static inline void fun_eth_offload_init(struct fun_eth_offload *s, u16 flags,
+					u16 mss, __be16 tcp_doff_flags,
+					__be16 vlan, u16 inner_l3_off,
+					u16 inner_l4_off, u16 outer_l3_off,
+					u16 outer_l4_off)
+{
+	s->flags = cpu_to_be16(flags);
+	s->mss = cpu_to_be16(mss);
+	s->tcp_doff_flags = tcp_doff_flags;
+	s->vlan = vlan;
+	s->inner_l3_off = cpu_to_be16(inner_l3_off);
+	s->inner_l4_off = cpu_to_be16(inner_l4_off);
+	s->outer_l3_off = cpu_to_be16(outer_l3_off);
+	s->outer_l4_off = cpu_to_be16(outer_l4_off);
+}
+
+struct fun_eth_tls {
+	__be64 tlsid;
+};
+
+enum {
+	FUN_ETH_TX_TLS = 0x8000,
+};
+
+struct fun_eth_tx_req {
+	__u8 op;
+	__u8 len8;
+	__be16 flags;
+	__u8 suboff8;
+	__u8 repr_idn;
+	__be16 encap_proto;
+
+	struct fun_eth_offload offload;
+
+	struct fun_dataop_hdr dataop;
+};
+
+struct fun_eth_rx_cv {
+	__be16 il4_prot_to_l2_type;
+};
+
+#define FUN_ETH_RX_CV_IL4_PROT_S 13U
+#define FUN_ETH_RX_CV_IL4_PROT_M 0x3
+
+#define FUN_ETH_RX_CV_IL3_PROT_S 11U
+#define FUN_ETH_RX_CV_IL3_PROT_M 0x3
+
+#define FUN_ETH_RX_CV_OL4_PROT_S 8U
+#define FUN_ETH_RX_CV_OL4_PROT_M 0x7
+
+#define FUN_ETH_RX_CV_ENCAP_TYPE_S 6U
+#define FUN_ETH_RX_CV_ENCAP_TYPE_M 0x3
+
+#define FUN_ETH_RX_CV_OL3_PROT_S 4U
+#define FUN_ETH_RX_CV_OL3_PROT_M 0x3
+
+#define FUN_ETH_RX_CV_VLAN_TYPE_S 3U
+#define FUN_ETH_RX_CV_VLAN_TYPE_M 0x1
+
+#define FUN_ETH_RX_CV_L2_TYPE_S 2U
+#define FUN_ETH_RX_CV_L2_TYPE_M 0x1
+
+enum fun_rx_cv {
+	FUN_RX_CV_NONE = 0x0,
+	FUN_RX_CV_IP = 0x2,
+	FUN_RX_CV_IP6 = 0x3,
+	FUN_RX_CV_TCP = 0x2,
+	FUN_RX_CV_UDP = 0x3,
+	FUN_RX_CV_VXLAN = 0x2,
+	FUN_RX_CV_MPLS = 0x3,
+};
+
+struct fun_eth_cqe {
+	__u8 op;
+	__u8 len8;
+	__u8 nsgl;
+	__u8 repr_idn;
+	__be32 pkt_len;
+
+	__be64 timestamp;
+
+	__be16 pkt_cv;
+	__be16 rsvd0;
+	__be32 hash;
+
+	__be16 encap_proto;
+	__be16 vlan;
+	__be32 rsvd1;
+
+	__be32 buf_offset;
+	__be16 headroom;
+	__be16 csum;
+};
+
+enum fun_admin_adi_attr {
+	FUN_ADMIN_ADI_ATTR_MACADDR = 0x1,
+	FUN_ADMIN_ADI_ATTR_VLAN = 0x2,
+	FUN_ADMIN_ADI_ATTR_RATE = 0x3,
+};
+
+struct fun_adi_param {
+	union adi_param {
+		struct fun_adi_mac {
+			__be64 addr;
+		} mac;
+		struct fun_adi_vlan {
+			__be32 rsvd;
+			__be16 eth_type;
+			__be16 tci;
+		} vlan;
+		struct fun_adi_rate {
+			__be32 rsvd;
+			__be32 tx_mbps;
+		} rate;
+	} u;
+};
+
+#define FUN_ADI_MAC_INIT(_addr)             \
+	(struct fun_adi_mac) {              \
+		.addr = cpu_to_be64(_addr), \
+	}
+
+#define FUN_ADI_VLAN_INIT(_eth_type, _tci)                                    \
+	(struct fun_adi_vlan) {                                               \
+		.eth_type = cpu_to_be16(_eth_type), .tci = cpu_to_be16(_tci), \
+	}
+
+#define FUN_ADI_RATE_INIT(_tx_mbps)               \
+	(struct fun_adi_rate) {                   \
+		.tx_mbps = cpu_to_be32(_tx_mbps), \
+	}
+
+struct fun_admin_adi_req {
+	struct fun_admin_req_common common;
+
+	union adi_req_subop {
+		struct fun_admin_adi_write_req {
+			__u8 subop;
+			__u8 attribute;
+			__be16 rsvd;
+			__be32 id;
+
+			struct fun_adi_param param;
+		} write;
+	} u;
+};
+
+#define FUN_ADMIN_ADI_WRITE_REQ_INIT(_subop, _attribute, _id) \
+	(struct fun_admin_adi_write_req) {                    \
+		.subop = (_subop), .attribute = (_attribute), \
+		.id = cpu_to_be32(_id),                       \
+	}
+
+#endif /* __FUN_HCI_H */
diff --git a/drivers/net/ethernet/fungible/funcore/fun_queue.c b/drivers/net/ethernet/fungible/funcore/fun_queue.c
new file mode 100644
index 000000000000..391ad4c7ef8d
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funcore/fun_queue.c
@@ -0,0 +1,620 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
+
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/log2.h>
+#include <linux/mm.h>
+#include <linux/netdevice.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+
+#include "fun_dev.h"
+#include "fun_queue.h"
+
+/* Allocate memory for a queue. This includes the memory for the HW descriptor
+ * ring, an optional 64b HW write-back area, and an optional SW state ring.
+ * Returns the virtual and DMA addresses of the HW ring, the VA of the SW ring,
+ * and the VA of the write-back area.
+ */
+void *fun_alloc_ring_mem(struct device *dma_dev, size_t depth,
+			 size_t hw_desc_sz, size_t sw_desc_sz, bool wb,
+			 int numa_node, dma_addr_t *dma_addr, void **sw_va,
+			 volatile __be64 **wb_va)
+{
+	int dev_node = dev_to_node(dma_dev);
+	size_t dma_sz;
+	void *va;
+
+	if (numa_node == NUMA_NO_NODE)
+		numa_node = dev_node;
+
+	/* Place optional write-back area at end of descriptor ring. */
+	dma_sz = hw_desc_sz * depth;
+	if (wb)
+		dma_sz += sizeof(u64);
+
+	set_dev_node(dma_dev, numa_node);
+	va = dma_alloc_coherent(dma_dev, dma_sz, dma_addr, GFP_KERNEL);
+	set_dev_node(dma_dev, dev_node);
+	if (!va)
+		return NULL;
+
+	if (sw_desc_sz) {
+		*sw_va = kvzalloc_node(sw_desc_sz * depth, GFP_KERNEL,
+				       numa_node);
+		if (!*sw_va) {
+			dma_free_coherent(dma_dev, dma_sz, va, *dma_addr);
+			return NULL;
+		}
+	}
+
+	if (wb)
+		*wb_va = va + dma_sz - sizeof(u64);
+	return va;
+}
+EXPORT_SYMBOL_GPL(fun_alloc_ring_mem);
+
+void fun_free_ring_mem(struct device *dma_dev, size_t depth, size_t hw_desc_sz,
+		       bool wb, void *hw_va, dma_addr_t dma_addr, void *sw_va)
+{
+	if (hw_va) {
+		size_t sz = depth * hw_desc_sz;
+
+		if (wb)
+			sz += sizeof(u64);
+		dma_free_coherent(dma_dev, sz, hw_va, dma_addr);
+	}
+	kvfree(sw_va);
+}
+EXPORT_SYMBOL_GPL(fun_free_ring_mem);
+
+/* Prepare and issue an admin command to create an SQ on the device with the
+ * provided parameters. If the queue ID is auto-allocated by the device it is
+ * returned in *sqidp.
+ */
+int fun_sq_create(struct fun_dev *fdev, u16 flags, u32 sqid, u32 cqid,
+		  u8 sqe_size_log2, u32 sq_depth, dma_addr_t dma_addr,
+		  u8 coal_nentries, u8 coal_usec, u32 irq_num,
+		  u32 scan_start_id, u32 scan_end_id,
+		  u32 rq_buf_size_log2, u32 *sqidp, u32 __iomem **dbp)
+{
+	union {
+		struct fun_admin_epsq_req req;
+		struct fun_admin_generic_create_rsp rsp;
+	} cmd;
+	dma_addr_t wb_addr;
+	u32 hw_qid;
+	int rc;
+
+	if (sq_depth > fdev->q_depth)
+		return -EINVAL;
+	if (flags & FUN_ADMIN_EPSQ_CREATE_FLAG_RQ)
+		sqe_size_log2 = ilog2(sizeof(struct fun_eprq_rqbuf));
+
+	wb_addr = dma_addr + (sq_depth << sqe_size_log2);
+
+	cmd.req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_EPSQ,
+						    sizeof(cmd.req));
+	cmd.req.u.create =
+		FUN_ADMIN_EPSQ_CREATE_REQ_INIT(FUN_ADMIN_SUBOP_CREATE, flags,
+					       sqid, cqid, sqe_size_log2,
+					       sq_depth - 1, dma_addr, 0,
+					       coal_nentries, coal_usec,
+					       irq_num, scan_start_id,
+					       scan_end_id, 0,
+					       rq_buf_size_log2,
+					       ilog2(sizeof(u64)), wb_addr);
+
+	rc = fun_submit_admin_sync_cmd(fdev, &cmd.req.common,
+				       &cmd.rsp, sizeof(cmd.rsp), 0);
+	if (rc)
+		return rc;
+
+	hw_qid = be32_to_cpu(cmd.rsp.id);
+	*dbp = fun_sq_db_addr(fdev, hw_qid);
+	if (flags & FUN_ADMIN_RES_CREATE_FLAG_ALLOCATOR)
+		*sqidp = hw_qid;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(fun_sq_create);
+
+/* Prepare and issue an admin command to create a CQ on the device with the
+ * provided parameters. If the queue ID is auto-allocated by the device it is
+ * returned in *cqidp.
+ */
+int fun_cq_create(struct fun_dev *fdev, u16 flags, u32 cqid, u32 rqid,
+		  u8 cqe_size_log2, u32 cq_depth, dma_addr_t dma_addr,
+		  u16 headroom, u16 tailroom, u8 coal_nentries, u8 coal_usec,
+		  u32 irq_num, u32 scan_start_id, u32 scan_end_id, u32 *cqidp,
+		  u32 __iomem **dbp)
+{
+	union {
+		struct fun_admin_epcq_req req;
+		struct fun_admin_generic_create_rsp rsp;
+	} cmd;
+	u32 hw_qid;
+	int rc;
+
+	if (cq_depth > fdev->q_depth)
+		return -EINVAL;
+
+	cmd.req.common = FUN_ADMIN_REQ_COMMON_INIT2(FUN_ADMIN_OP_EPCQ,
+						    sizeof(cmd.req));
+	cmd.req.u.create =
+		FUN_ADMIN_EPCQ_CREATE_REQ_INIT(FUN_ADMIN_SUBOP_CREATE, flags,
+					       cqid, rqid, cqe_size_log2,
+					       cq_depth - 1, dma_addr, tailroom,
+					       headroom / 2, 0, coal_nentries,
+					       coal_usec, irq_num,
+					       scan_start_id, scan_end_id, 0);
+
+	rc = fun_submit_admin_sync_cmd(fdev, &cmd.req.common,
+				       &cmd.rsp, sizeof(cmd.rsp), 0);
+	if (rc)
+		return rc;
+
+	hw_qid = be32_to_cpu(cmd.rsp.id);
+	*dbp = fun_cq_db_addr(fdev, hw_qid);
+	if (flags & FUN_ADMIN_RES_CREATE_FLAG_ALLOCATOR)
+		*cqidp = hw_qid;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(fun_cq_create);
+
+static bool fun_sq_is_head_wb(const struct fun_queue *funq)
+{
+	return funq->sq_flags & FUN_ADMIN_EPSQ_CREATE_FLAG_HEAD_WB_ADDRESS;
+}
+
+static void fun_clean_rq(struct fun_queue *funq)
+{
+	struct fun_dev *fdev = funq->fdev;
+	struct fun_rq_info *rqinfo;
+	unsigned int i;
+
+	for (i = 0; i < funq->rq_depth; i++) {
+		rqinfo = &funq->rq_info[i];
+		if (rqinfo->page) {
+			dma_unmap_page(fdev->dev, rqinfo->dma, PAGE_SIZE,
+				       DMA_FROM_DEVICE);
+			put_page(rqinfo->page);
+			rqinfo->page = NULL;
+		}
+	}
+}
+
+static int fun_fill_rq(struct fun_queue *funq)
+{
+	struct device *dev = funq->fdev->dev;
+	int i, node = dev_to_node(dev);
+	struct fun_rq_info *rqinfo;
+
+	for (i = 0; i < funq->rq_depth; i++) {
+		rqinfo = &funq->rq_info[i];
+		rqinfo->page = alloc_pages_node(node, GFP_KERNEL, 0);
+		if (unlikely(!rqinfo->page))
+			return -ENOMEM;
+
+		rqinfo->dma = dma_map_page(dev, rqinfo->page, 0,
+					   PAGE_SIZE, DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(dev, rqinfo->dma))) {
+			put_page(rqinfo->page);
+			rqinfo->page = NULL;
+			return -ENOMEM;
+		}
+
+		funq->rqes[i] = FUN_EPRQ_RQBUF_INIT(rqinfo->dma);
+	}
+
+	funq->rq_tail = funq->rq_depth - 1;
+	return 0;
+}
+
+static void fun_rq_update_pos(struct fun_queue *funq, int buf_offset)
+{
+	if (buf_offset <= funq->rq_buf_offset) {
+		struct fun_rq_info *rqinfo = &funq->rq_info[funq->rq_buf_idx];
+		struct device *dev = funq->fdev->dev;
+
+		dma_sync_single_for_device(dev, rqinfo->dma, PAGE_SIZE,
+					   DMA_FROM_DEVICE);
+		funq->num_rqe_to_fill++;
+		if (++funq->rq_buf_idx == funq->rq_depth)
+			funq->rq_buf_idx = 0;
+	}
+	funq->rq_buf_offset = buf_offset;
+}
+
+/* Given a command response with data scattered across >= 1 RQ buffers return
+ * a pointer to a contiguous buffer containing all the data. If the data is in
+ * one RQ buffer the start address within that buffer is returned, otherwise a
+ * new buffer is allocated and the data is gathered into it.
+ */
+void *fun_data_from_rq(struct fun_queue *funq, const struct fun_rsp_common *rsp,
+		       bool *need_free)
+{
+	u32 bufoff, total_len, remaining, fragsize, dataoff;
+	struct device *dma_dev = funq->fdev->dev;
+	const struct fun_dataop_rqbuf *databuf;
+	const struct fun_dataop_hdr *dataop;
+	const struct fun_rq_info *rqinfo;
+	void *data;
+
+	dataop = (void *)rsp + rsp->suboff8 * 8;
+	total_len = be32_to_cpu(dataop->total_len);
+
+	if (likely(dataop->nsgl == 1)) {
+		databuf = (struct fun_dataop_rqbuf *)dataop->imm;
+		bufoff = be32_to_cpu(databuf->bufoff);
+		fun_rq_update_pos(funq, bufoff);
+		rqinfo = &funq->rq_info[funq->rq_buf_idx];
+		dma_sync_single_for_cpu(dma_dev, rqinfo->dma + bufoff,
+					total_len, DMA_FROM_DEVICE);
+		*need_free = false;
+		return page_address(rqinfo->page) + bufoff;
+	}
+
+	/* For scattered completions gather the fragments into one buffer. */
+
+	data = kmalloc(total_len, GFP_ATOMIC);
+	/* NULL is OK here. In case of failure we still need to consume the data
+	 * for proper buffer accounting but indicate an error in the response.
+	 */
+	if (likely(data))
+		*need_free = true;
+
+	dataoff = 0;
+	for (remaining = total_len; remaining; remaining -= fragsize) {
+		fun_rq_update_pos(funq, 0);
+		fragsize = min_t(unsigned int, PAGE_SIZE, remaining);
+		if (data) {
+			rqinfo = &funq->rq_info[funq->rq_buf_idx];
+			dma_sync_single_for_cpu(dma_dev, rqinfo->dma, fragsize,
+						DMA_FROM_DEVICE);
+			memcpy(data + dataoff, page_address(rqinfo->page),
+			       fragsize);
+			dataoff += fragsize;
+		}
+	}
+	return data;
+}
+
+unsigned int __fun_process_cq(struct fun_queue *funq, unsigned int max)
+{
+	const struct fun_cqe_info *info;
+	struct fun_rsp_common *rsp;
+	unsigned int new_cqes;
+	u16 sf_p, flags;
+	bool need_free;
+	void *cqe;
+
+	if (!max)
+		max = funq->cq_depth - 1;
+
+	for (new_cqes = 0; new_cqes < max; new_cqes++) {
+		cqe = funq->cqes + (funq->cq_head << funq->cqe_size_log2);
+		info = funq_cqe_info(funq, cqe);
+		sf_p = be16_to_cpu(info->sf_p);
+
+		if ((sf_p & 1) != funq->cq_phase)
+			break;
+
+		/* ensure the phase tag is read before other CQE fields */
+		dma_rmb();
+
+		if (++funq->cq_head == funq->cq_depth) {
+			funq->cq_head = 0;
+			funq->cq_phase = !funq->cq_phase;
+		}
+
+		rsp = cqe;
+		flags = be16_to_cpu(rsp->flags);
+
+		need_free = false;
+		if (unlikely(flags & FUN_REQ_COMMON_FLAG_CQE_IN_RQBUF)) {
+			rsp = fun_data_from_rq(funq, rsp, &need_free);
+			if (!rsp) {
+				rsp = cqe;
+				rsp->len8 = 1;
+				if (rsp->ret == 0)
+					rsp->ret = ENOMEM;
+			}
+		}
+
+		if (funq->cq_cb)
+			funq->cq_cb(funq, funq->cb_data, rsp, info);
+		if (need_free)
+			kfree(rsp);
+	}
+
+	dev_dbg(funq->fdev->dev, "CQ %u, new CQEs %u/%u, head %u, phase %u\n",
+		funq->cqid, new_cqes, max, funq->cq_head, funq->cq_phase);
+	return new_cqes;
+}
+
+unsigned int fun_process_cq(struct fun_queue *funq, unsigned int max)
+{
+	unsigned int processed;
+	u32 db;
+
+	processed = __fun_process_cq(funq, max);
+
+	if (funq->num_rqe_to_fill) {
+		funq->rq_tail = (funq->rq_tail + funq->num_rqe_to_fill) %
+				funq->rq_depth;
+		funq->num_rqe_to_fill = 0;
+		writel(funq->rq_tail, funq->rq_db);
+	}
+
+	db = funq->cq_head | FUN_DB_IRQ_ARM_F;
+	writel(db, funq->cq_db);
+	return processed;
+}
+
+static int fun_alloc_sqes(struct fun_queue *funq)
+{
+	funq->sq_cmds = fun_alloc_ring_mem(funq->fdev->dev, funq->sq_depth,
+					   1 << funq->sqe_size_log2, 0,
+					   fun_sq_is_head_wb(funq),
+					   NUMA_NO_NODE, &funq->sq_dma_addr,
+					   NULL, &funq->sq_head);
+	return funq->sq_cmds ? 0 : -ENOMEM;
+}
+
+static int fun_alloc_cqes(struct fun_queue *funq)
+{
+	funq->cqes = fun_alloc_ring_mem(funq->fdev->dev, funq->cq_depth,
+					1 << funq->cqe_size_log2, 0, false,
+					NUMA_NO_NODE, &funq->cq_dma_addr, NULL,
+					NULL);
+	return funq->cqes ? 0 : -ENOMEM;
+}
+
+static int fun_alloc_rqes(struct fun_queue *funq)
+{
+	funq->rqes = fun_alloc_ring_mem(funq->fdev->dev, funq->rq_depth,
+					sizeof(*funq->rqes),
+					sizeof(*funq->rq_info), false,
+					NUMA_NO_NODE, &funq->rq_dma_addr,
+					(void **)&funq->rq_info, NULL);
+	return funq->rqes ? 0 : -ENOMEM;
+}
+
+/* Free a queue's structures. */
+void fun_free_queue(struct fun_queue *funq)
+{
+	struct device *dev = funq->fdev->dev;
+
+	fun_free_ring_mem(dev, funq->cq_depth, 1 << funq->cqe_size_log2, false,
+			  funq->cqes, funq->cq_dma_addr, NULL);
+	fun_free_ring_mem(dev, funq->sq_depth, 1 << funq->sqe_size_log2,
+			  fun_sq_is_head_wb(funq), funq->sq_cmds,
+			  funq->sq_dma_addr, NULL);
+
+	if (funq->rqes) {
+		fun_clean_rq(funq);
+		fun_free_ring_mem(dev, funq->rq_depth, sizeof(*funq->rqes),
+				  false, funq->rqes, funq->rq_dma_addr,
+				  funq->rq_info);
+	}
+
+	kfree(funq);
+}
+
+/* Allocate and initialize a funq's structures. */
+struct fun_queue *fun_alloc_queue(struct fun_dev *fdev, int qid,
+				  const struct fun_queue_alloc_req *req)
+{
+	struct fun_queue *funq = kzalloc(sizeof(*funq), GFP_KERNEL);
+
+	if (!funq)
+		return NULL;
+
+	funq->fdev = fdev;
+	spin_lock_init(&funq->sq_lock);
+
+	funq->qid = qid;
+
+	/* Initial CQ/SQ/RQ ids */
+	if (req->rq_depth) {
+		funq->cqid = 2 * qid;
+		if (funq->qid) {
+			/* I/O Q: use rqid = cqid, sqid = +1 */
+			funq->rqid = funq->cqid;
+			funq->sqid = funq->rqid + 1;
+		} else {
+			/* Admin Q: sqid is always 0, use ID 1 for RQ */
+			funq->sqid = 0;
+			funq->rqid = 1;
+		}
+	} else {
+		funq->cqid = qid;
+		funq->sqid = qid;
+	}
+
+	funq->cq_flags = req->cq_flags;
+	funq->sq_flags = req->sq_flags;
+
+	funq->cqe_size_log2 = req->cqe_size_log2;
+	funq->sqe_size_log2 = req->sqe_size_log2;
+
+	funq->cq_depth = req->cq_depth;
+	funq->sq_depth = req->sq_depth;
+
+	funq->cq_intcoal_nentries = req->cq_intcoal_nentries;
+	funq->cq_intcoal_usec = req->cq_intcoal_usec;
+
+	funq->sq_intcoal_nentries = req->sq_intcoal_nentries;
+	funq->sq_intcoal_usec = req->sq_intcoal_usec;
+
+	if (fun_alloc_cqes(funq))
+		goto free_funq;
+
+	funq->cq_phase = 1;
+
+	if (fun_alloc_sqes(funq))
+		goto free_funq;
+
+	if (req->rq_depth) {
+		funq->rq_flags = req->rq_flags | FUN_ADMIN_EPSQ_CREATE_FLAG_RQ;
+		funq->rq_depth = req->rq_depth;
+		funq->rq_buf_offset = -1;
+
+		if (fun_alloc_rqes(funq) || fun_fill_rq(funq))
+			goto free_funq;
+	}
+
+	funq->cq_vector = -1;
+	funq->cqe_info_offset = (1 << funq->cqe_size_log2) - sizeof(struct fun_cqe_info);
+
+	/* SQ/CQ 0 are implicitly created, assign their doorbells now.
+	 * Other queues are assigned doorbells at their explicit creation.
+	 */
+	if (funq->sqid == 0)
+		funq->sq_db = fun_sq_db_addr(fdev, 0);
+	if (funq->cqid == 0)
+		funq->cq_db = fun_cq_db_addr(fdev, 0);
+
+	return funq;
+
+free_funq:
+	fun_free_queue(funq);
+	return NULL;
+}
+
+/* Create a funq's CQ on the device. */
+static int fun_create_cq(struct fun_queue *funq)
+{
+	struct fun_dev *fdev = funq->fdev;
+	unsigned int rqid;
+	int rc;
+
+	rqid = funq->cq_flags & FUN_ADMIN_EPCQ_CREATE_FLAG_RQ ?
+		funq->rqid : FUN_HCI_ID_INVALID;
+	rc = fun_cq_create(fdev, funq->cq_flags, funq->cqid, rqid,
+			   funq->cqe_size_log2, funq->cq_depth,
+			   funq->cq_dma_addr, 0, 0, funq->cq_intcoal_nentries,
+			   funq->cq_intcoal_usec, funq->cq_vector, 0, 0,
+			   &funq->cqid, &funq->cq_db);
+	if (!rc)
+		dev_dbg(fdev->dev, "created CQ %u\n", funq->cqid);
+
+	return rc;
+}
+
+/* Create a funq's SQ on the device. */
+static int fun_create_sq(struct fun_queue *funq)
+{
+	struct fun_dev *fdev = funq->fdev;
+	int rc;
+
+	rc = fun_sq_create(fdev, funq->sq_flags, funq->sqid, funq->cqid,
+			   funq->sqe_size_log2, funq->sq_depth,
+			   funq->sq_dma_addr, funq->sq_intcoal_nentries,
+			   funq->sq_intcoal_usec, funq->cq_vector, 0, 0,
+			   0, &funq->sqid, &funq->sq_db);
+	if (!rc)
+		dev_dbg(fdev->dev, "created SQ %u\n", funq->sqid);
+
+	return rc;
+}
+
+/* Create a funq's RQ on the device. */
+int fun_create_rq(struct fun_queue *funq)
+{
+	struct fun_dev *fdev = funq->fdev;
+	int rc;
+
+	rc = fun_sq_create(fdev, funq->rq_flags, funq->rqid, funq->cqid, 0,
+			   funq->rq_depth, funq->rq_dma_addr, 0, 0,
+			   funq->cq_vector, 0, 0, PAGE_SHIFT, &funq->rqid,
+			   &funq->rq_db);
+	if (!rc)
+		dev_dbg(fdev->dev, "created RQ %u\n", funq->rqid);
+
+	return rc;
+}
+
+static unsigned int funq_irq(struct fun_queue *funq)
+{
+	return pci_irq_vector(to_pci_dev(funq->fdev->dev), funq->cq_vector);
+}
+
+int fun_request_irq(struct fun_queue *funq, const char *devname,
+		    irq_handler_t handler, void *data)
+{
+	int rc;
+
+	if (funq->cq_vector < 0)
+		return -EINVAL;
+
+	funq->irq_handler = handler;
+	funq->irq_data = data;
+
+	snprintf(funq->irqname, sizeof(funq->irqname),
+		 funq->qid ? "%s-q[%d]" : "%s-adminq", devname, funq->qid);
+
+	rc = request_irq(funq_irq(funq), handler, 0, funq->irqname, data);
+	if (rc)
+		funq->irq_handler = NULL;
+
+	return rc;
+}
+
+/* Create all component queues of a funq  on the device. */
+int fun_create_queue(struct fun_queue *funq)
+{
+	int rc;
+
+	rc = fun_create_cq(funq);
+	if (rc)
+		return rc;
+
+	if (funq->rq_depth) {
+		rc = fun_create_rq(funq);
+		if (rc)
+			goto release_cq;
+	}
+
+	rc = fun_create_sq(funq);
+	if (rc)
+		goto release_rq;
+
+	return 0;
+
+release_rq:
+	fun_destroy_sq(funq->fdev, funq->rqid);
+release_cq:
+	fun_destroy_cq(funq->fdev, funq->cqid);
+	return rc;
+}
+
+/* Destroy a funq's component queues on the device. */
+int fun_destroy_queue(struct fun_queue *funq)
+{
+	struct fun_dev *fdev = funq->fdev;
+	int rc1, rc2 = 0, rc3;
+
+	rc1 = fun_destroy_sq(fdev, funq->sqid);
+	if (funq->rq_depth)
+		rc2 = fun_destroy_sq(fdev, funq->rqid);
+	rc3 = fun_destroy_cq(fdev, funq->cqid);
+
+	fun_free_irq(funq);
+
+	if (rc1)
+		return rc1;
+	return rc2 ? rc2 : rc3;
+}
+
+void fun_free_irq(struct fun_queue *funq)
+{
+	if (funq->irq_handler) {
+		unsigned int vector = funq_irq(funq);
+
+		synchronize_irq(vector);
+		free_irq(vector, funq->irq_data);
+		funq->irq_handler = NULL;
+		funq->irq_data = NULL;
+	}
+}
diff --git a/drivers/net/ethernet/fungible/funcore/fun_queue.h b/drivers/net/ethernet/fungible/funcore/fun_queue.h
new file mode 100644
index 000000000000..2b0679290eaa
--- /dev/null
+++ b/drivers/net/ethernet/fungible/funcore/fun_queue.h
@@ -0,0 +1,178 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause) */
+
+#ifndef _FUN_QEUEUE_H
+#define _FUN_QEUEUE_H
+
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+struct device;
+struct fun_dev;
+struct fun_queue;
+struct fun_cqe_info;
+struct fun_rsp_common;
+
+typedef void (*cq_callback_t)(struct fun_queue *funq, void *data, void *msg,
+			      const struct fun_cqe_info *info);
+
+struct fun_rq_info {
+	dma_addr_t dma;
+	struct page *page;
+};
+
+/* A queue group consisting of an SQ, a CQ, and an optional RQ. */
+struct fun_queue {
+	struct fun_dev *fdev;
+	spinlock_t sq_lock;
+
+	dma_addr_t cq_dma_addr;
+	dma_addr_t sq_dma_addr;
+	dma_addr_t rq_dma_addr;
+
+	u32 __iomem *cq_db;
+	u32 __iomem *sq_db;
+	u32 __iomem *rq_db;
+
+	void *cqes;
+	void *sq_cmds;
+	struct fun_eprq_rqbuf *rqes;
+	struct fun_rq_info *rq_info;
+
+	u32 cqid;
+	u32 sqid;
+	u32 rqid;
+
+	u32 cq_depth;
+	u32 sq_depth;
+	u32 rq_depth;
+
+	u16 cq_head;
+	u16 sq_tail;
+	u16 rq_tail;
+
+	u8 cqe_size_log2;
+	u8 sqe_size_log2;
+
+	u16 cqe_info_offset;
+
+	u16 rq_buf_idx;
+	int rq_buf_offset;
+	u16 num_rqe_to_fill;
+
+	u8 cq_intcoal_usec;
+	u8 cq_intcoal_nentries;
+	u8 sq_intcoal_usec;
+	u8 sq_intcoal_nentries;
+
+	u16 cq_flags;
+	u16 sq_flags;
+	u16 rq_flags;
+
+	/* SQ head writeback */
+	u16 sq_comp;
+
+	volatile __be64 *sq_head;
+
+	cq_callback_t cq_cb;
+	void *cb_data;
+
+	irq_handler_t irq_handler;
+	void *irq_data;
+	s16 cq_vector;
+	u8 cq_phase;
+
+	/* I/O q index */
+	u16 qid;
+
+	char irqname[24];
+};
+
+static inline void *fun_sqe_at(const struct fun_queue *funq, unsigned int pos)
+{
+	return funq->sq_cmds + (pos << funq->sqe_size_log2);
+}
+
+static inline void funq_sq_post_tail(struct fun_queue *funq, u16 tail)
+{
+	if (++tail == funq->sq_depth)
+		tail = 0;
+	funq->sq_tail = tail;
+	writel(tail, funq->sq_db);
+}
+
+static inline struct fun_cqe_info *funq_cqe_info(const struct fun_queue *funq,
+						 void *cqe)
+{
+	return cqe + funq->cqe_info_offset;
+}
+
+static inline void funq_rq_post(struct fun_queue *funq)
+{
+	writel(funq->rq_tail, funq->rq_db);
+}
+
+struct fun_queue_alloc_req {
+	u8  cqe_size_log2;
+	u8  sqe_size_log2;
+
+	u16 cq_flags;
+	u16 sq_flags;
+	u16 rq_flags;
+
+	u32 cq_depth;
+	u32 sq_depth;
+	u32 rq_depth;
+
+	u8 cq_intcoal_usec;
+	u8 cq_intcoal_nentries;
+	u8 sq_intcoal_usec;
+	u8 sq_intcoal_nentries;
+};
+
+int fun_sq_create(struct fun_dev *fdev, u16 flags, u32 sqid, u32 cqid,
+		  u8 sqe_size_log2, u32 sq_depth, dma_addr_t dma_addr,
+		  u8 coal_nentries, u8 coal_usec, u32 irq_num,
+		  u32 scan_start_id, u32 scan_end_id,
+		  u32 rq_buf_size_log2, u32 *sqidp, u32 __iomem **dbp);
+int fun_cq_create(struct fun_dev *fdev, u16 flags, u32 cqid, u32 rqid,
+		  u8 cqe_size_log2, u32 cq_depth, dma_addr_t dma_addr,
+		  u16 headroom, u16 tailroom, u8 coal_nentries, u8 coal_usec,
+		  u32 irq_num, u32 scan_start_id, u32 scan_end_id,
+		  u32 *cqidp, u32 __iomem **dbp);
+void *fun_alloc_ring_mem(struct device *dma_dev, size_t depth,
+			 size_t hw_desc_sz, size_t sw_desc_size, bool wb,
+			 int numa_node, dma_addr_t *dma_addr, void **sw_va,
+			 volatile __be64 **wb_va);
+void fun_free_ring_mem(struct device *dma_dev, size_t depth, size_t hw_desc_sz,
+		       bool wb, void *hw_va, dma_addr_t dma_addr, void *sw_va);
+
+#define fun_destroy_sq(fdev, sqid) \
+	fun_res_destroy((fdev), FUN_ADMIN_OP_EPSQ, 0, (sqid))
+#define fun_destroy_cq(fdev, cqid) \
+	fun_res_destroy((fdev), FUN_ADMIN_OP_EPCQ, 0, (cqid))
+
+struct fun_queue *fun_alloc_queue(struct fun_dev *fdev, int qid,
+				  const struct fun_queue_alloc_req *req);
+void fun_free_queue(struct fun_queue *funq);
+
+static inline void fun_set_cq_callback(struct fun_queue *funq, cq_callback_t cb,
+				       void *cb_data)
+{
+	funq->cq_cb = cb;
+	funq->cb_data = cb_data;
+}
+
+int fun_create_rq(struct fun_queue *funq);
+int fun_create_queue(struct fun_queue *funq);
+int fun_destroy_queue(struct fun_queue *funq);
+
+void fun_free_irq(struct fun_queue *funq);
+int fun_request_irq(struct fun_queue *funq, const char *devname,
+		    irq_handler_t handler, void *data);
+
+unsigned int __fun_process_cq(struct fun_queue *funq, unsigned int max);
+unsigned int fun_process_cq(struct fun_queue *funq, unsigned int max);
+void *fun_data_from_rq(struct fun_queue *funq, const struct fun_rsp_common *rsp,
+		       bool *need_free);
+
+#endif /* _FUN_QEUEUE_H */
-- 
2.25.1

