Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1891F6D9E0F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 18:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbjDFQ5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 12:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239006AbjDFQ5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 12:57:22 -0400
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A211559F;
        Thu,  6 Apr 2023 09:57:20 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id j1so856367wrb.0;
        Thu, 06 Apr 2023 09:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680800239; x=1683392239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xpNcgF9Q1qM2erhXuecrKip+ocebAPwCMU69leYZaUE=;
        b=3q2VZLcm/e1cSG/wALzJ7ImRVCB+fF9YHxsy2ZemzygVCJ6qNCDDCOly4jbWbwwzAH
         SwW/oIY/q+lGKbV0sI9IzFpYGYrlip+q5c5bNRpgKuHK12FQK/JZ/enEL9yWELVBhAWJ
         c+2KGdIVf83RtFJQIWYVgB1ay8FNFadPirh20riSPlfstCh2RC2lkGUSWR4ZAAeR1G5I
         HQ+3vgEEP2afQ/QeJ1KuXWPgekQNt8h5c4EFFD4Sfxa1V3f0imqrU2abMh4l8oysND9Z
         OhKgTgjO1HIPfh6CRQbMJ7yRihHen5/TqLElKOBepCi0tg7tvumuJ5wB3KR9oKdFGXVD
         ngFA==
X-Gm-Message-State: AAQBX9f6t25j5FnMF6FNw4Yq2S7Jn5jC7gF8Rm5/mIzSAW3x8lZYTCPh
        TzZXpAvZqhFbeAdKfV9xDZwxVziE7PPL0w==
X-Google-Smtp-Source: AKy350YUkYAYAQbbe890fkdcD0e6oOIEMCbQS8PcsZ//ClmMexrDVEtRnoJzb1mnRfDcUa5eQwCkAQ==
X-Received: by 2002:adf:ea90:0:b0:2d5:39d:514f with SMTP id s16-20020adfea90000000b002d5039d514fmr8087195wrm.65.1680800238735;
        Thu, 06 Apr 2023 09:57:18 -0700 (PDT)
Received: from localhost (fwdproxy-cln-006.fbsv.net. [2a03:2880:31ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id d7-20020adfef87000000b002daeb108304sm2207024wro.33.2023.04.06.09.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 09:57:17 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     leitao@debian.org
Cc:     asml.silence@gmail.com, axboe@kernel.dk, davem@davemloft.net,
        dccp@vger.kernel.org, dsahern@kernel.org, edumazet@google.com,
        io-uring@vger.kernel.org, kuba@kernel.org, leit@fb.com,
        linux-kernel@vger.kernel.org, marcelo.leitner@gmail.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        netdev@vger.kernel.org, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCH RFC] io_uring: Pass whole sqe to commands
Date:   Thu,  6 Apr 2023 09:57:05 -0700
Message-Id: <20230406165705.3161734-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230406144330.1932798-1-leitao@debian.org>
References: <20230406144330.1932798-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently uring CMD operation relies on having large SQEs, but future
operations might want to use normal SQE.

The io_uring_cmd currently only saves the payload (cmd) part of the SQE,
but, for commands that use normal SQE size, it might be necessary to
access the initial SQE fields outside of the payload/cmd block.  So,
saves the whole SQE other than just the pdu.

This changes slighlty how the io_uring_cmd works, since the cmd
structures and callbacks are not opaque to io_uring anymore. I.e, the
callbacks can look at the SQE entries, not only, in the cmd structure.

The main advantage is that we don't need to create custom structures for
simple commands.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/block/ublk_drv.c  | 24 ++++++++++++------------
 drivers/nvme/host/ioctl.c |  2 +-
 include/linux/io_uring.h  |  2 +-
 io_uring/opdef.c          |  2 +-
 io_uring/uring_cmd.c      | 11 ++++++-----
 5 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index d1d1c8d606c8..0e35d82eb070 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1258,7 +1258,7 @@ static void ublk_handle_need_get_data(struct ublk_device *ub, int q_id,
 
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
-	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
+	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->sqe->cmd;
 	struct ublk_device *ub = cmd->file->private_data;
 	struct ublk_queue *ubq;
 	struct ublk_io *io;
@@ -1562,7 +1562,7 @@ static struct ublk_device *ublk_get_device_from_id(int idx)
 
 static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	int ublksrv_pid = (int)header->data[0];
 	struct gendisk *disk;
 	int ret = -EINVAL;
@@ -1624,7 +1624,7 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 static int ublk_ctrl_get_queue_affinity(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	cpumask_var_t cpumask;
 	unsigned long queue;
@@ -1675,7 +1675,7 @@ static inline void ublk_dump_dev_info(struct ublksrv_ctrl_dev_info *info)
 
 static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	struct ublksrv_ctrl_dev_info info;
 	struct ublk_device *ub;
@@ -1838,7 +1838,7 @@ static int ublk_ctrl_del_dev(struct ublk_device **p_ub)
 
 static inline void ublk_ctrl_cmd_dump(struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 
 	pr_devel("%s: cmd_op %x, dev id %d qid %d data %llx buf %llx len %u\n",
 			__func__, cmd->cmd_op, header->dev_id, header->queue_id,
@@ -1857,7 +1857,7 @@ static int ublk_ctrl_stop_dev(struct ublk_device *ub)
 static int ublk_ctrl_get_dev_info(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 
 	if (header->len < sizeof(struct ublksrv_ctrl_dev_info) || !header->addr)
@@ -1888,7 +1888,7 @@ static void ublk_ctrl_fill_params_devt(struct ublk_device *ub)
 static int ublk_ctrl_get_params(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	struct ublk_params_header ph;
 	int ret;
@@ -1919,7 +1919,7 @@ static int ublk_ctrl_get_params(struct ublk_device *ub,
 static int ublk_ctrl_set_params(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	struct ublk_params_header ph;
 	int ret = -EFAULT;
@@ -1977,7 +1977,7 @@ static void ublk_queue_reinit(struct ublk_device *ub, struct ublk_queue *ubq)
 static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	int ret = -EINVAL;
 	int i;
 
@@ -2019,7 +2019,7 @@ static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	int ublksrv_pid = (int)header->data[0];
 	int ret = -EINVAL;
 
@@ -2086,7 +2086,7 @@ static int ublk_char_dev_permission(struct ublk_device *ub,
 static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 		struct io_uring_cmd *cmd)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	bool unprivileged = ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DEV;
 	void __user *argp = (void __user *)(unsigned long)header->addr;
 	char *dev_path = NULL;
@@ -2165,7 +2165,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
-	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
+	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->sqe->cmd;
 	struct ublk_device *ub = NULL;
 	int ret = -EINVAL;
 
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 723e7d5b778f..304da8f3200b 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -550,7 +550,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
-	const struct nvme_uring_cmd *cmd = ioucmd->cmd;
+	const struct nvme_uring_cmd *cmd = (struct nvme_uring_cmd *)ioucmd->sqe->cmd;
 	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
 	struct nvme_uring_data d;
 	struct nvme_command c;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 934e5dd4ccc0..650e6f12cc18 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -24,7 +24,7 @@ enum io_uring_cmd_flags {
 
 struct io_uring_cmd {
 	struct file	*file;
-	const void	*cmd;
+	const struct io_uring_sqe *sqe;
 	union {
 		/* callback to defer completions to task context */
 		void (*task_work_cb)(struct io_uring_cmd *cmd);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index cca7c5b55208..3b9c6489b8b6 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -627,7 +627,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_URING_CMD] = {
 		.name			= "URING_CMD",
-		.async_size		= uring_cmd_pdu_size(1),
+		.async_size		= 2 * sizeof(struct io_uring_sqe),
 		.prep_async		= io_uring_cmd_prep_async,
 	},
 	[IORING_OP_SEND_ZC] = {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 2e4c483075d3..9648134ccae1 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -63,14 +63,15 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 int io_uring_cmd_prep_async(struct io_kiocb *req)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	size_t cmd_size;
+	size_t size = sizeof(struct io_uring_sqe);
 
 	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
 	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
 
-	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
+	if (req->ctx->flags & IORING_SETUP_SQE128)
+		size <<= 1;
 
-	memcpy(req->async_data, ioucmd->cmd, cmd_size);
+	memcpy(req->async_data, ioucmd->sqe, size);
 	return 0;
 }
 
@@ -96,7 +97,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->imu = ctx->user_bufs[index];
 		io_req_set_rsrc_node(req, ctx, 0);
 	}
-	ioucmd->cmd = sqe->cmd;
+	ioucmd->sqe = sqe;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	return 0;
 }
@@ -128,7 +129,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (req_has_async_data(req))
-		ioucmd->cmd = req->async_data;
+		ioucmd->sqe = req->async_data;
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
 	if (ret == -EAGAIN) {
-- 
2.34.1

