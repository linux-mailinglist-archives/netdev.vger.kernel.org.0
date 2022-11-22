Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D736633349
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiKVC2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiKVC2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:28:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD17023384
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BF74B8190B
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0ACBC433C1;
        Tue, 22 Nov 2022 02:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084106;
        bh=iFFIGvKuvkMt4hYXA/cMnqJrIPQlnXKczFNB2MvWZwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMSr+61Purj2wVEm1hLK3AbZK9V++/RIHIJqgXaQQgajb8ZVLs175SY9Bhw2Kq0Rh
         5qcasRQmWeeaxN1r7FhTUbVeI7zD5L4WrGmKREAurgnz4ARHr4XKfAp7NulLHioPOB
         IhJdbKHBJLIC56TUROThs2f1S8llgQEOsQsXV+4kyYQeeKa9g1g002aA5VaKORqFp+
         Jv74ZZoPoRdyjqaB8vBSm1Lc9Ah16ri3QFm/20mia2hysg+Zztl9HCmDGgq1jX3Jpc
         McpwgW027l+ll997dVuSCznGlXAowCCdqneCmNFuxQJxi7A4+tMcuE8VvAqGZPLGBL
         t9E6YK2dWqdxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
Subject: [net 04/14] net/mlx5: cmdif, Print info on any firmware cmd failure to tracepoint
Date:   Mon, 21 Nov 2022 18:25:49 -0800
Message-Id: <20221122022559.89459-5-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

While moving to new CMD API (quiet API), some pre-existing flows may call the new API
function that in case of error, returns the error instead of printing it as previously done.
For such flows we bring back the print but to tracepoint this time for sys admins to
have the ability to check for errors especially for commands using the new quiet API.

Tracepoint output example:
         devlink-1333    [001] .....   822.746922: mlx5_cmd: ACCESS_REG(0x805) op_mod(0x0) failed, status bad resource(0x5), syndrome (0xb06e1f), err(-22)

Fixes: f23519e542e5 ("net/mlx5: cmdif, Add new api for command execution")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 41 +++++++++--------
 .../mellanox/mlx5/core/diag/cmd_tracepoint.h  | 45 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 3 files changed, 68 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 2e0d59ca62b5..df3e284ca5c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -45,6 +45,8 @@
 #include "mlx5_core.h"
 #include "lib/eq.h"
 #include "lib/tout.h"
+#define CREATE_TRACE_POINTS
+#include "diag/cmd_tracepoint.h"
 
 enum {
 	CMD_IF_REV = 5,
@@ -785,27 +787,14 @@ EXPORT_SYMBOL(mlx5_cmd_out_err);
 static void cmd_status_print(struct mlx5_core_dev *dev, void *in, void *out)
 {
 	u16 opcode, op_mod;
-	u32 syndrome;
-	u8  status;
 	u16 uid;
-	int err;
-
-	syndrome = MLX5_GET(mbox_out, out, syndrome);
-	status = MLX5_GET(mbox_out, out, status);
 
 	opcode = MLX5_GET(mbox_in, in, opcode);
 	op_mod = MLX5_GET(mbox_in, in, op_mod);
 	uid    = MLX5_GET(mbox_in, in, uid);
 
-	err = cmd_status_to_err(status);
-
 	if (!uid && opcode != MLX5_CMD_OP_DESTROY_MKEY)
 		mlx5_cmd_out_err(dev, opcode, op_mod, out);
-	else
-		mlx5_core_dbg(dev,
-			"%s(0x%x) op_mod(0x%x) uid(%d) failed, status %s(0x%x), syndrome (0x%x), err(%d)\n",
-			mlx5_command_str(opcode), opcode, op_mod, uid,
-			cmd_status_str(status), status, syndrome, err);
 }
 
 int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *out)
@@ -1892,6 +1881,16 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	return err;
 }
 
+static void mlx5_cmd_err_trace(struct mlx5_core_dev *dev, u16 opcode, u16 op_mod, void *out)
+{
+	u32 syndrome = MLX5_GET(mbox_out, out, syndrome);
+	u8 status = MLX5_GET(mbox_out, out, status);
+
+	trace_mlx5_cmd(mlx5_command_str(opcode), opcode, op_mod,
+		       cmd_status_str(status), status, syndrome,
+		       cmd_status_to_err(status));
+}
+
 static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status,
 			   u32 syndrome, int err)
 {
@@ -1914,7 +1913,7 @@ static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status,
 }
 
 /* preserve -EREMOTEIO for outbox.status != OK, otherwise return err as is */
-static int cmd_status_err(struct mlx5_core_dev *dev, int err, u16 opcode, void *out)
+static int cmd_status_err(struct mlx5_core_dev *dev, int err, u16 opcode, u16 op_mod, void *out)
 {
 	u32 syndrome = MLX5_GET(mbox_out, out, syndrome);
 	u8 status = MLX5_GET(mbox_out, out, status);
@@ -1922,8 +1921,10 @@ static int cmd_status_err(struct mlx5_core_dev *dev, int err, u16 opcode, void *
 	if (err == -EREMOTEIO) /* -EREMOTEIO is preserved */
 		err = -EIO;
 
-	if (!err && status != MLX5_CMD_STAT_OK)
+	if (!err && status != MLX5_CMD_STAT_OK) {
 		err = -EREMOTEIO;
+		mlx5_cmd_err_trace(dev, opcode, op_mod, out);
+	}
 
 	cmd_status_log(dev, opcode, status, syndrome, err);
 	return err;
@@ -1951,9 +1952,9 @@ int mlx5_cmd_do(struct mlx5_core_dev *dev, void *in, int in_size, void *out, int
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, false);
 	u16 opcode = MLX5_GET(mbox_in, in, opcode);
+	u16 op_mod = MLX5_GET(mbox_in, in, op_mod);
 
-	err = cmd_status_err(dev, err, opcode, out);
-	return err;
+	return cmd_status_err(dev, err, opcode, op_mod, out);
 }
 EXPORT_SYMBOL(mlx5_cmd_do);
 
@@ -1997,8 +1998,9 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, true);
 	u16 opcode = MLX5_GET(mbox_in, in, opcode);
+	u16 op_mod = MLX5_GET(mbox_in, in, op_mod);
 
-	err = cmd_status_err(dev, err, opcode, out);
+	err = cmd_status_err(dev, err, opcode, op_mod, out);
 	return mlx5_cmd_check(dev, err, in, out);
 }
 EXPORT_SYMBOL(mlx5_cmd_exec_polling);
@@ -2034,7 +2036,7 @@ static void mlx5_cmd_exec_cb_handler(int status, void *_work)
 	struct mlx5_async_ctx *ctx;
 
 	ctx = work->ctx;
-	status = cmd_status_err(ctx->dev, status, work->opcode, work->out);
+	status = cmd_status_err(ctx->dev, status, work->opcode, work->op_mod, work->out);
 	work->user_callback(status, work);
 	if (atomic_dec_and_test(&ctx->num_inflight))
 		complete(&ctx->inflight_done);
@@ -2049,6 +2051,7 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 	work->ctx = ctx;
 	work->user_callback = callback;
 	work->opcode = MLX5_GET(mbox_in, in, opcode);
+	work->op_mod = MLX5_GET(mbox_in, in, op_mod);
 	work->out = out;
 	if (WARN_ON(!atomic_inc_not_zero(&ctx->num_inflight)))
 		return -EIO;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h
new file mode 100644
index 000000000000..406ebe17405f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mlx5
+
+#if !defined(_MLX5_CMD_TP_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _MLX5_CMD_TP_H_
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+TRACE_EVENT(mlx5_cmd,
+	    TP_PROTO(const char *command_str, u16 opcode, u16 op_mod,
+		     const char *status_str, u8 status, u32 syndrome, int err),
+	    TP_ARGS(command_str, opcode, op_mod, status_str, status, syndrome, err),
+	    TP_STRUCT__entry(__string(command_str, command_str)
+			     __field(u16, opcode)
+			     __field(u16, op_mod)
+			    __string(status_str, status_str)
+			    __field(u8, status)
+			    __field(u32, syndrome)
+			    __field(int, err)
+			    ),
+	    TP_fast_assign(__assign_str(command_str, command_str);
+			__entry->opcode = opcode;
+			__entry->op_mod = op_mod;
+			__assign_str(status_str, status_str);
+			__entry->status = status;
+			__entry->syndrome = syndrome;
+			__entry->err = err;
+	    ),
+	    TP_printk("%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x), err(%d)",
+		      __get_str(command_str), __entry->opcode, __entry->op_mod,
+		      __get_str(status_str), __entry->status, __entry->syndrome,
+		      __entry->err)
+);
+
+#endif /* _MLX5_CMD_TP_H_ */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ./diag
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE cmd_tracepoint
+#include <trace/define_trace.h>
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index af2ceb4160bc..06cbad166225 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -981,6 +981,7 @@ struct mlx5_async_work {
 	struct mlx5_async_ctx *ctx;
 	mlx5_async_cbk_t user_callback;
 	u16 opcode; /* cmd opcode */
+	u16 op_mod; /* cmd op_mod */
 	void *out; /* pointer to the cmd output buffer */
 };
 
-- 
2.38.1

