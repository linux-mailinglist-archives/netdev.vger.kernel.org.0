Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0C280817
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733006AbgJATxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732931AbgJATxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:13 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39FF321481;
        Thu,  1 Oct 2020 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581992;
        bh=0iVsqPtabTXBw5vBGqtZzn+YjK6T99y2zgOcjdqTvX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rlbYCHZTEMDjMKTtRRaJoj7Mu9AiS4wWsSrleA/Vg9MV7Tu+VBpjG8rS1VdoNg5W
         7ZXPUpyiK7wjfZViOa+W+qonljMjHea5KZavs9GIjjJO6eppcxOY0DWodjYvZVVUci
         OJKaWWu1ru7IrqycdyEsEUPzdh9Cl5RupeMYKMKQ=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 03/15] net/mlx5: Avoid possible free of command entry while timeout comp handler
Date:   Thu,  1 Oct 2020 12:52:35 -0700
Message-Id: <20201001195247.66636-4-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Upon command completion timeout, driver simulates a forced command
completion. In a rare case where real interrupt for that command arrives
simultaneously, it might release the command entry while the forced
handler might still access it.

Fix that by adding an entry refcount, to track current amount of allowed
handlers. Command entry to be released only when this refcount is
decremented to zero.

Command refcount is always initialized to one. For callback commands,
command completion handler is the symmetric flow to decrement it. For
non-callback commands, it is wait_func().

Before ringing the doorbell, increment the refcount for the real completion
handler. Once the real completion handler is called, it will decrement it.

For callback commands, once the delayed work is scheduled, increment the
refcount. Upon callback command completion handler, we will try to cancel
the timeout callback. In case of success, we need to decrement the callback
refcount as it will never run.

In addition, gather the entry index free and the entry free into a one
flow for all command types release.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 109 ++++++++++++------
 include/linux/mlx5/driver.h                   |   2 +
 2 files changed, 73 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 1d91a0d0ab1d..8ad4828e1218 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -69,12 +69,10 @@ enum {
 	MLX5_CMD_DELIVERY_STAT_CMD_DESCR_ERR		= 0x10,
 };
 
-static struct mlx5_cmd_work_ent *alloc_cmd(struct mlx5_cmd *cmd,
-					   struct mlx5_cmd_msg *in,
-					   struct mlx5_cmd_msg *out,
-					   void *uout, int uout_size,
-					   mlx5_cmd_cbk_t cbk,
-					   void *context, int page_queue)
+static struct mlx5_cmd_work_ent *
+cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
+	      struct mlx5_cmd_msg *out, void *uout, int uout_size,
+	      mlx5_cmd_cbk_t cbk, void *context, int page_queue)
 {
 	gfp_t alloc_flags = cbk ? GFP_ATOMIC : GFP_KERNEL;
 	struct mlx5_cmd_work_ent *ent;
@@ -83,6 +81,7 @@ static struct mlx5_cmd_work_ent *alloc_cmd(struct mlx5_cmd *cmd,
 	if (!ent)
 		return ERR_PTR(-ENOMEM);
 
+	ent->idx	= -EINVAL;
 	ent->in		= in;
 	ent->out	= out;
 	ent->uout	= uout;
@@ -91,10 +90,16 @@ static struct mlx5_cmd_work_ent *alloc_cmd(struct mlx5_cmd *cmd,
 	ent->context	= context;
 	ent->cmd	= cmd;
 	ent->page_queue = page_queue;
+	refcount_set(&ent->refcnt, 1);
 
 	return ent;
 }
 
+static void cmd_free_ent(struct mlx5_cmd_work_ent *ent)
+{
+	kfree(ent);
+}
+
 static u8 alloc_token(struct mlx5_cmd *cmd)
 {
 	u8 token;
@@ -109,7 +114,7 @@ static u8 alloc_token(struct mlx5_cmd *cmd)
 	return token;
 }
 
-static int alloc_ent(struct mlx5_cmd *cmd)
+static int cmd_alloc_index(struct mlx5_cmd *cmd)
 {
 	unsigned long flags;
 	int ret;
@@ -123,7 +128,7 @@ static int alloc_ent(struct mlx5_cmd *cmd)
 	return ret < cmd->max_reg_cmds ? ret : -ENOMEM;
 }
 
-static void free_ent(struct mlx5_cmd *cmd, int idx)
+static void cmd_free_index(struct mlx5_cmd *cmd, int idx)
 {
 	unsigned long flags;
 
@@ -132,6 +137,22 @@ static void free_ent(struct mlx5_cmd *cmd, int idx)
 	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
 }
 
+static void cmd_ent_get(struct mlx5_cmd_work_ent *ent)
+{
+	refcount_inc(&ent->refcnt);
+}
+
+static void cmd_ent_put(struct mlx5_cmd_work_ent *ent)
+{
+	if (!refcount_dec_and_test(&ent->refcnt))
+		return;
+
+	if (ent->idx >= 0)
+		cmd_free_index(ent->cmd, ent->idx);
+
+	cmd_free_ent(ent);
+}
+
 static struct mlx5_cmd_layout *get_inst(struct mlx5_cmd *cmd, int idx)
 {
 	return cmd->cmd_buf + (idx << cmd->log_stride);
@@ -219,11 +240,6 @@ static void poll_timeout(struct mlx5_cmd_work_ent *ent)
 	ent->ret = -ETIMEDOUT;
 }
 
-static void free_cmd(struct mlx5_cmd_work_ent *ent)
-{
-	kfree(ent);
-}
-
 static int verify_signature(struct mlx5_cmd_work_ent *ent)
 {
 	struct mlx5_cmd_mailbox *next = ent->out->next;
@@ -842,6 +858,7 @@ static void cb_timeout_handler(struct work_struct *work)
 		       mlx5_command_str(msg_to_opcode(ent->in)),
 		       msg_to_opcode(ent->in));
 	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
 }
 
 static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
@@ -873,14 +890,14 @@ static void cmd_work_handler(struct work_struct *work)
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
-		alloc_ret = alloc_ent(cmd);
+		alloc_ret = cmd_alloc_index(cmd);
 		if (alloc_ret < 0) {
 			mlx5_core_err_rl(dev, "failed to allocate command entry\n");
 			if (ent->callback) {
 				ent->callback(-EAGAIN, ent->context);
 				mlx5_free_cmd_msg(dev, ent->out);
 				free_msg(dev, ent->in);
-				free_cmd(ent);
+				cmd_ent_put(ent);
 			} else {
 				ent->ret = -EAGAIN;
 				complete(&ent->done);
@@ -916,8 +933,8 @@ static void cmd_work_handler(struct work_struct *work)
 	ent->ts1 = ktime_get_ns();
 	cmd_mode = cmd->mode;
 
-	if (ent->callback)
-		schedule_delayed_work(&ent->cb_timeout_work, cb_timeout);
+	if (ent->callback && schedule_delayed_work(&ent->cb_timeout_work, cb_timeout))
+		cmd_ent_get(ent);
 	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
 	/* Skip sending command to fw if internal error */
@@ -933,13 +950,10 @@ static void cmd_work_handler(struct work_struct *work)
 		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
 
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
-		/* no doorbell, no need to keep the entry */
-		free_ent(cmd, ent->idx);
-		if (ent->callback)
-			free_cmd(ent);
 		return;
 	}
 
+	cmd_ent_get(ent); /* for the _real_ FW event on completion */
 	/* ring doorbell after the descriptor is valid */
 	mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 << ent->idx);
 	wmb();
@@ -1039,11 +1053,16 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	if (callback && page_queue)
 		return -EINVAL;
 
-	ent = alloc_cmd(cmd, in, out, uout, uout_size, callback, context,
-			page_queue);
+	ent = cmd_alloc_ent(cmd, in, out, uout, uout_size,
+			    callback, context, page_queue);
 	if (IS_ERR(ent))
 		return PTR_ERR(ent);
 
+	/* put for this ent is when consumed, depending on the use case
+	 * 1) (!callback) blocking flow: by caller after wait_func completes
+	 * 2) (callback) flow: by mlx5_cmd_comp_handler() when ent is handled
+	 */
+
 	ent->token = token;
 	ent->polling = force_polling;
 
@@ -1062,12 +1081,10 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	}
 
 	if (callback)
-		goto out;
+		goto out; /* mlx5_cmd_comp_handler() will put(ent) */
 
 	err = wait_func(dev, ent);
-	if (err == -ETIMEDOUT)
-		goto out;
-	if (err == -ECANCELED)
+	if (err == -ETIMEDOUT || err == -ECANCELED)
 		goto out_free;
 
 	ds = ent->ts2 - ent->ts1;
@@ -1085,7 +1102,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	*status = ent->status;
 
 out_free:
-	free_cmd(ent);
+	cmd_ent_put(ent);
 out:
 	return err;
 }
@@ -1516,14 +1533,19 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				if (!forced) {
 					mlx5_core_err(dev, "Command completion arrived after timeout (entry idx = %d).\n",
 						      ent->idx);
-					free_ent(cmd, ent->idx);
-					free_cmd(ent);
+					cmd_ent_put(ent);
 				}
 				continue;
 			}
 
-			if (ent->callback)
-				cancel_delayed_work(&ent->cb_timeout_work);
+			if (ent->callback && cancel_delayed_work(&ent->cb_timeout_work))
+				cmd_ent_put(ent); /* timeout work was canceled */
+
+			if (!forced || /* Real FW completion */
+			    pci_channel_offline(dev->pdev) || /* FW is inaccessible */
+			    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+				cmd_ent_put(ent);
+
 			if (ent->page_queue)
 				sem = &cmd->pages_sem;
 			else
@@ -1545,10 +1567,6 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 					      ent->ret, deliv_status_to_str(ent->status), ent->status);
 			}
 
-			/* only real completion will free the entry slot */
-			if (!forced)
-				free_ent(cmd, ent->idx);
-
 			if (ent->callback) {
 				ds = ent->ts2 - ent->ts1;
 				if (ent->op < MLX5_CMD_OP_MAX) {
@@ -1576,10 +1594,13 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				free_msg(dev, ent->in);
 
 				err = err ? err : ent->status;
-				if (!forced)
-					free_cmd(ent);
+				/* final consumer is done, release and call the user callback */
+				cmd_ent_put(ent);
 				callback(err, context);
 			} else {
+				/* release wait_func() so mlx5_cmd_invoke()
+				 * can make the final ent_put()
+				 */
 				complete(&ent->done);
 			}
 			up(sem);
@@ -1589,8 +1610,11 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 
 void mlx5_cmd_trigger_completions(struct mlx5_core_dev *dev)
 {
+	struct mlx5_cmd *cmd = &dev->cmd;
+	unsigned long bitmask;
 	unsigned long flags;
 	u64 vector;
+	int i;
 
 	/* wait for pending handlers to complete */
 	mlx5_eq_synchronize_cmd_irq(dev);
@@ -1599,11 +1623,20 @@ void mlx5_cmd_trigger_completions(struct mlx5_core_dev *dev)
 	if (!vector)
 		goto no_trig;
 
+	bitmask = vector;
+	/* we must increment the allocated entries refcount before triggering the completions
+	 * to guarantee pending commands will not get freed in the meanwhile.
+	 * For that reason, it also has to be done inside the alloc_lock.
+	 */
+	for_each_set_bit(i, &bitmask, (1 << cmd->log_sz))
+		cmd_ent_get(cmd->ent_arr[i]);
 	vector |= MLX5_TRIGGERED_CMD_COMP;
 	spin_unlock_irqrestore(&dev->cmd.alloc_lock, flags);
 
 	mlx5_core_dbg(dev, "vector 0x%llx\n", vector);
 	mlx5_cmd_comp_handler(dev, vector, true);
+	for_each_set_bit(i, &bitmask, (1 << cmd->log_sz))
+		cmd_ent_put(cmd->ent_arr[i]);
 	return;
 
 no_trig:
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 223aaaaaf8a6..2437e8721b36 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -768,6 +768,8 @@ struct mlx5_cmd_work_ent {
 	u64			ts2;
 	u16			op;
 	bool			polling;
+	/* Track the max comp handlers */
+	refcount_t              refcnt;
 };
 
 struct mlx5_pas {
-- 
2.26.2

