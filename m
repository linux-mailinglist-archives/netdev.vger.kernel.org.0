Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E003B6653D6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbjAKFjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjAKFiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071B5FE4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:31:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89DD1B81A6B
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2052AC433EF;
        Wed, 11 Jan 2023 05:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415059;
        bh=j1dCUzUUSFHqzdBuT0q65boGuXb8VSSrQX08Z7yDjoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQdiWo0K3My66qGmS8y6QYwU/2S5+ZVGzNhUleZRzJai2+0ZYlzxQ8fOooUTcWZR/
         ndy8/oc3frIrbX0Qtz9xqJEgyX9M38X1Rf8DxVpvEne8jb6j0BLaeBcXuGEbligTKR
         G9bvLldYNbkXP0pEA6a5xNygSjaiXzktEoyljZ1F1Jek+Cz59keweitq2Yfv9qL9X2
         axJ2sbPuxzcckjvAaW78EHr5oy2hinBYrXcDr26N/H6iJlRKV4NLAbmnKr1D6l7isC
         R1z9UY0xxv10e6SJlE3+WcXYCDfsoNcrl7vdiAypDV4JMBN0ZioD9tqbvjJvD831yb
         lJVoH1f5XGVTQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Introduce and use opcode getter in command interface
Date:   Tue, 10 Jan 2023 21:30:40 -0800
Message-Id: <20230111053045.413133-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
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

From: Tariq Toukan <tariqt@nvidia.com>

Introduce an opcode getter in the FW command interface, and use it.
Initialize the entry's opcode field early in cmd_alloc_ent() and use it
when possible.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 88 +++++++++----------
 1 file changed, 42 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index d3ca745d107d..541eecfdd598 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -47,6 +47,25 @@
 #define CREATE_TRACE_POINTS
 #include "diag/cmd_tracepoint.h"
 
+struct mlx5_ifc_mbox_out_bits {
+	u8         status[0x8];
+	u8         reserved_at_8[0x18];
+
+	u8         syndrome[0x20];
+
+	u8         reserved_at_40[0x40];
+};
+
+struct mlx5_ifc_mbox_in_bits {
+	u8         opcode[0x10];
+	u8         uid[0x10];
+
+	u8         reserved_at_20[0x10];
+	u8         op_mod[0x10];
+
+	u8         reserved_at_40[0x40];
+};
+
 enum {
 	CMD_IF_REV = 5,
 };
@@ -70,6 +89,11 @@ enum {
 	MLX5_CMD_DELIVERY_STAT_CMD_DESCR_ERR		= 0x10,
 };
 
+static u16 in_to_opcode(void *in)
+{
+	return MLX5_GET(mbox_in, in, opcode);
+}
+
 static struct mlx5_cmd_work_ent *
 cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
 	      struct mlx5_cmd_msg *out, void *uout, int uout_size,
@@ -91,6 +115,7 @@ cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
 	ent->context	= context;
 	ent->cmd	= cmd;
 	ent->page_queue = page_queue;
+	ent->op         = in_to_opcode(in->first.data);
 	refcount_set(&ent->refcnt, 1);
 
 	return ent;
@@ -752,25 +777,6 @@ static int cmd_status_to_err(u8 status)
 	}
 }
 
-struct mlx5_ifc_mbox_out_bits {
-	u8         status[0x8];
-	u8         reserved_at_8[0x18];
-
-	u8         syndrome[0x20];
-
-	u8         reserved_at_40[0x40];
-};
-
-struct mlx5_ifc_mbox_in_bits {
-	u8         opcode[0x10];
-	u8         uid[0x10];
-
-	u8         reserved_at_20[0x10];
-	u8         op_mod[0x10];
-
-	u8         reserved_at_40[0x40];
-};
-
 void mlx5_cmd_out_err(struct mlx5_core_dev *dev, u16 opcode, u16 op_mod, void *out)
 {
 	u32 syndrome = MLX5_GET(mbox_out, out, syndrome);
@@ -788,7 +794,7 @@ static void cmd_status_print(struct mlx5_core_dev *dev, void *in, void *out)
 	u16 opcode, op_mod;
 	u16 uid;
 
-	opcode = MLX5_GET(mbox_in, in, opcode);
+	opcode = in_to_opcode(in);
 	op_mod = MLX5_GET(mbox_in, in, op_mod);
 	uid    = MLX5_GET(mbox_in, in, uid);
 
@@ -800,7 +806,7 @@ int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *out)
 {
 	/* aborted due to PCI error or via reset flow mlx5_cmd_trigger_completions() */
 	if (err == -ENXIO) {
-		u16 opcode = MLX5_GET(mbox_in, in, opcode);
+		u16 opcode = in_to_opcode(in);
 		u32 syndrome;
 		u8 status;
 
@@ -829,9 +835,9 @@ static void dump_command(struct mlx5_core_dev *dev,
 			 struct mlx5_cmd_work_ent *ent, int input)
 {
 	struct mlx5_cmd_msg *msg = input ? ent->in : ent->out;
-	u16 op = MLX5_GET(mbox_in, ent->lay->in, opcode);
 	struct mlx5_cmd_mailbox *next = msg->next;
 	int n = mlx5_calc_cmd_blocks(msg);
+	u16 op = ent->op;
 	int data_only;
 	u32 offset = 0;
 	int dump_len;
@@ -883,11 +889,6 @@ static void dump_command(struct mlx5_core_dev *dev,
 	mlx5_core_dbg(dev, "cmd[%d]: end dump\n", ent->idx);
 }
 
-static u16 msg_to_opcode(struct mlx5_cmd_msg *in)
-{
-	return MLX5_GET(mbox_in, in->first.data, opcode);
-}
-
 static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool forced);
 
 static void cb_timeout_handler(struct work_struct *work)
@@ -905,13 +906,13 @@ static void cb_timeout_handler(struct work_struct *work)
 	/* Maybe got handled by eq recover ? */
 	if (!test_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state)) {
 		mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, recovered after timeout\n", ent->idx,
-			       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+			       mlx5_command_str(ent->op), ent->op);
 		goto out; /* phew, already handled */
 	}
 
 	ent->ret = -ETIMEDOUT;
 	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, timeout. Will cause a leak of a command resource\n",
-		       ent->idx, mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+		       ent->idx, mlx5_command_str(ent->op), ent->op);
 	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 
 out:
@@ -985,7 +986,6 @@ static void cmd_work_handler(struct work_struct *work)
 	ent->lay = lay;
 	memset(lay, 0, sizeof(*lay));
 	memcpy(lay->in, ent->in->first.data, sizeof(lay->in));
-	ent->op = be32_to_cpu(lay->in[0]) >> 16;
 	if (ent->in->next)
 		lay->in_ptr = cpu_to_be64(ent->in->next->dma);
 	lay->inlen = cpu_to_be32(ent->in->len);
@@ -1098,12 +1098,12 @@ static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
 	 */
 	if (wait_for_completion_timeout(&ent->done, timeout)) {
 		mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) recovered after timeout\n", ent->idx,
-			       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+			       mlx5_command_str(ent->op), ent->op);
 		return;
 	}
 
 	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) No done completion\n", ent->idx,
-		       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+		       mlx5_command_str(ent->op), ent->op);
 
 	ent->ret = -ETIMEDOUT;
 	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
@@ -1130,12 +1130,10 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 
 	if (err == -ETIMEDOUT) {
 		mlx5_core_warn(dev, "%s(0x%x) timeout. Will cause a leak of a command resource\n",
-			       mlx5_command_str(msg_to_opcode(ent->in)),
-			       msg_to_opcode(ent->in));
+			       mlx5_command_str(ent->op), ent->op);
 	} else if (err == -ECANCELED) {
 		mlx5_core_warn(dev, "%s(0x%x) canceled on out of queue timeout.\n",
-			       mlx5_command_str(msg_to_opcode(ent->in)),
-			       msg_to_opcode(ent->in));
+			       mlx5_command_str(ent->op), ent->op);
 	}
 	mlx5_core_dbg(dev, "err %d, delivery status %s(%d)\n",
 		      err, deliv_status_to_str(ent->status), ent->status);
@@ -1169,7 +1167,6 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	u8 status = 0;
 	int err = 0;
 	s64 ds;
-	u16 op;
 
 	if (callback && page_queue)
 		return -EINVAL;
@@ -1209,9 +1206,8 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
-	op = MLX5_GET(mbox_in, in->first.data, opcode);
-	if (op < MLX5_CMD_OP_MAX) {
-		stats = &cmd->stats[op];
+	if (ent->op < MLX5_CMD_OP_MAX) {
+		stats = &cmd->stats[ent->op];
 		spin_lock_irq(&stats->lock);
 		stats->sum += ds;
 		++stats->n;
@@ -1219,7 +1215,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	}
 	mlx5_core_dbg_mask(dev, 1 << MLX5_CMD_TIME,
 			   "fw exec time for %s is %lld nsec\n",
-			   mlx5_command_str(op), ds);
+			   mlx5_command_str(ent->op), ds);
 
 out_free:
 	status = ent->status;
@@ -1816,7 +1812,7 @@ static struct mlx5_cmd_msg *alloc_msg(struct mlx5_core_dev *dev, int in_size,
 
 static int is_manage_pages(void *in)
 {
-	return MLX5_GET(mbox_in, in, opcode) == MLX5_CMD_OP_MANAGE_PAGES;
+	return in_to_opcode(in) == MLX5_CMD_OP_MANAGE_PAGES;
 }
 
 /*  Notes:
@@ -1827,8 +1823,8 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 		    int out_size, mlx5_cmd_cbk_t callback, void *context,
 		    bool force_polling)
 {
-	u16 opcode = MLX5_GET(mbox_in, in, opcode);
 	struct mlx5_cmd_msg *inb, *outb;
+	u16 opcode = in_to_opcode(in);
 	int pages_queue;
 	gfp_t gfp;
 	u8 token;
@@ -1950,8 +1946,8 @@ static int cmd_status_err(struct mlx5_core_dev *dev, int err, u16 opcode, u16 op
 int mlx5_cmd_do(struct mlx5_core_dev *dev, void *in, int in_size, void *out, int out_size)
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, false);
-	u16 opcode = MLX5_GET(mbox_in, in, opcode);
 	u16 op_mod = MLX5_GET(mbox_in, in, op_mod);
+	u16 opcode = in_to_opcode(in);
 
 	return cmd_status_err(dev, err, opcode, op_mod, out);
 }
@@ -1996,8 +1992,8 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size)
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, true);
-	u16 opcode = MLX5_GET(mbox_in, in, opcode);
 	u16 op_mod = MLX5_GET(mbox_in, in, op_mod);
+	u16 opcode = in_to_opcode(in);
 
 	err = cmd_status_err(dev, err, opcode, op_mod, out);
 	return mlx5_cmd_check(dev, err, in, out);
@@ -2049,7 +2045,7 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 
 	work->ctx = ctx;
 	work->user_callback = callback;
-	work->opcode = MLX5_GET(mbox_in, in, opcode);
+	work->opcode = in_to_opcode(in);
 	work->op_mod = MLX5_GET(mbox_in, in, op_mod);
 	work->out = out;
 	if (WARN_ON(!atomic_inc_not_zero(&ctx->num_inflight)))
-- 
2.39.0

