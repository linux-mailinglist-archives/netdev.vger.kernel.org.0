Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F9F27F7B0
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 04:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbgJACFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 22:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730269AbgJACF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 22:05:26 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56AB2221EC;
        Thu,  1 Oct 2020 02:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601517925;
        bh=TDe7X+J+79jUrUVD7iVX9oPWFneL1bUwDu03nck1/IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9vyD5/3IPwkVECgoFE2Ge+y5OlDGBuVObZ0Dn3gDFOiVurAE+U3W3bn90SUW85Yy
         OpJbxLlqKzO1gJGIZNhA5EdNA73SZgsltsP1R0wmwxIQhLRO6Mqmmzz1Yov27Sn+Zh
         52Q8302WGDYY9zgsFNCZp4ugrEHxhnNcKazlgHb0=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/15] net/mlx5: poll cmd EQ in case of command timeout
Date:   Wed, 30 Sep 2020 19:05:05 -0700
Message-Id: <20201001020516.41217-5-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001020516.41217-1-saeed@kernel.org>
References: <20201001020516.41217-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Once driver detects a command interface command timeout, it warns the
user and returns timeout error to the caller. In such case, the entry of
the command is not evacuated (because only real event interrupt is allowed
to clear command interface entry). If the HW event interrupt
of this entry will never arrive, this entry will be left unused forever.
Command interface entries are limited and eventually we can end up without
the ability to post a new command.

In addition, if driver will not consume the EQE of the lost interrupt and
rearm the EQ, no new interrupts will arrive for other commands.

Add a resiliency mechanism for manually polling the command EQ in case of
a command timeout. In case resiliency mechanism will find non-handled EQE,
it will consume it, and the command interface will be fully functional
again. Once the resiliency flow finished, wait another 5 seconds for the
command interface to complete for this command entry.

Define mlx5_cmd_eq_recover() to manage the cmd EQ polling resiliency flow.
Add an async EQ spinlock to avoid races between resiliency flows and real
interrupts that might run simultaneously.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 53 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 40 +++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 +
 3 files changed, 86 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 8ad4828e1218..65ae6ef2039e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -853,11 +853,21 @@ static void cb_timeout_handler(struct work_struct *work)
 	struct mlx5_core_dev *dev = container_of(ent->cmd, struct mlx5_core_dev,
 						 cmd);
 
+	mlx5_cmd_eq_recover(dev);
+
+	/* Maybe got handled by eq recover ? */
+	if (!test_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state)) {
+		mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, recovered after timeout\n", ent->idx,
+			       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+		goto out; /* phew, already handled */
+	}
+
 	ent->ret = -ETIMEDOUT;
-	mlx5_core_warn(dev, "%s(0x%x) timeout. Will cause a leak of a command resource\n",
-		       mlx5_command_str(msg_to_opcode(ent->in)),
-		       msg_to_opcode(ent->in));
+	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) Async, timeout. Will cause a leak of a command resource\n",
+		       ent->idx, mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
 	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+
+out:
 	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed work */
 }
 
@@ -997,6 +1007,35 @@ static const char *deliv_status_to_str(u8 status)
 	}
 }
 
+enum {
+	MLX5_CMD_TIMEOUT_RECOVER_MSEC   = 5 * 1000,
+};
+
+static void wait_func_handle_exec_timeout(struct mlx5_core_dev *dev,
+					  struct mlx5_cmd_work_ent *ent)
+{
+	unsigned long timeout = msecs_to_jiffies(MLX5_CMD_TIMEOUT_RECOVER_MSEC);
+
+	mlx5_cmd_eq_recover(dev);
+
+	/* Re-wait on the ent->done after executing the recovery flow. If the
+	 * recovery flow (or any other recovery flow running simultaneously)
+	 * has recovered an EQE, it should cause the entry to be completed by
+	 * the command interface.
+	 */
+	if (wait_for_completion_timeout(&ent->done, timeout)) {
+		mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) recovered after timeout\n", ent->idx,
+			       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+		return;
+	}
+
+	mlx5_core_warn(dev, "cmd[%d]: %s(0x%x) No done completion\n", ent->idx,
+		       mlx5_command_str(msg_to_opcode(ent->in)), msg_to_opcode(ent->in));
+
+	ent->ret = -ETIMEDOUT;
+	mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+}
+
 static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 {
 	unsigned long timeout = msecs_to_jiffies(MLX5_CMD_TIMEOUT_MSEC);
@@ -1008,12 +1047,10 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 		ent->ret = -ECANCELED;
 		goto out_err;
 	}
-	if (cmd->mode == CMD_MODE_POLLING || ent->polling) {
+	if (cmd->mode == CMD_MODE_POLLING || ent->polling)
 		wait_for_completion(&ent->done);
-	} else if (!wait_for_completion_timeout(&ent->done, timeout)) {
-		ent->ret = -ETIMEDOUT;
-		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
-	}
+	else if (!wait_for_completion_timeout(&ent->done, timeout))
+		wait_func_handle_exec_timeout(dev, ent);
 
 out_err:
 	err = ent->ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 1318d774b18f..22a19d391e17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -189,6 +189,29 @@ u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq)
 	return count_eqe;
 }
 
+static void mlx5_eq_async_int_lock(struct mlx5_eq_async *eq, unsigned long *flags)
+	__acquires(&eq->lock)
+{
+	if (in_irq())
+		spin_lock(&eq->lock);
+	else
+		spin_lock_irqsave(&eq->lock, *flags);
+}
+
+static void mlx5_eq_async_int_unlock(struct mlx5_eq_async *eq, unsigned long *flags)
+	__releases(&eq->lock)
+{
+	if (in_irq())
+		spin_unlock(&eq->lock);
+	else
+		spin_unlock_irqrestore(&eq->lock, *flags);
+}
+
+enum async_eq_nb_action {
+	ASYNC_EQ_IRQ_HANDLER = 0,
+	ASYNC_EQ_RECOVER = 1,
+};
+
 static int mlx5_eq_async_int(struct notifier_block *nb,
 			     unsigned long action, void *data)
 {
@@ -198,11 +221,14 @@ static int mlx5_eq_async_int(struct notifier_block *nb,
 	struct mlx5_eq_table *eqt;
 	struct mlx5_core_dev *dev;
 	struct mlx5_eqe *eqe;
+	unsigned long flags;
 	int num_eqes = 0;
 
 	dev = eq->dev;
 	eqt = dev->priv.eq_table;
 
+	mlx5_eq_async_int_lock(eq_async, &flags);
+
 	eqe = next_eqe_sw(eq);
 	if (!eqe)
 		goto out;
@@ -223,8 +249,19 @@ static int mlx5_eq_async_int(struct notifier_block *nb,
 
 out:
 	eq_update_ci(eq, 1);
+	mlx5_eq_async_int_unlock(eq_async, &flags);
 
-	return 0;
+	return unlikely(action == ASYNC_EQ_RECOVER) ? num_eqes : 0;
+}
+
+void mlx5_cmd_eq_recover(struct mlx5_core_dev *dev)
+{
+	struct mlx5_eq_async *eq = &dev->priv.eq_table->cmd_eq;
+	int eqes;
+
+	eqes = mlx5_eq_async_int(&eq->irq_nb, ASYNC_EQ_RECOVER, NULL);
+	if (eqes)
+		mlx5_core_warn(dev, "Recovered %d EQEs on cmd_eq\n", eqes);
 }
 
 static void init_eq_buf(struct mlx5_eq *eq)
@@ -569,6 +606,7 @@ setup_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq_async *eq,
 	int err;
 
 	eq->irq_nb.notifier_call = mlx5_eq_async_int;
+	spin_lock_init(&eq->lock);
 
 	err = create_async_eq(dev, &eq->core, param);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 4aaca7400fb2..5c681e31983b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -37,6 +37,7 @@ struct mlx5_eq {
 struct mlx5_eq_async {
 	struct mlx5_eq          core;
 	struct notifier_block   irq_nb;
+	spinlock_t              lock; /* To avoid irq EQ handle races with resiliency flows */
 };
 
 struct mlx5_eq_comp {
@@ -81,6 +82,7 @@ void mlx5_cq_tasklet_cb(unsigned long data);
 struct cpumask *mlx5_eq_comp_cpumask(struct mlx5_core_dev *dev, int ix);
 
 u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq);
+void mlx5_cmd_eq_recover(struct mlx5_core_dev *dev);
 void mlx5_eq_synchronize_async_irq(struct mlx5_core_dev *dev);
 void mlx5_eq_synchronize_cmd_irq(struct mlx5_core_dev *dev);
 
-- 
2.26.2

