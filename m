Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417454D3C2E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbiCIVjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236769AbiCIVjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263816C953
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8AB66CE212C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC6EC340F6;
        Wed,  9 Mar 2022 21:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861885;
        bh=cEdKgnTqVuk+Qx9TRW1w+w2eU+15TpMCdiXqQGgSUN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lfz8+n8Fu/dipkVQS67D+6I8t98SRQQxtxXw5+5RNs40bI7Z5jb4syC6ExGD9C7bT
         1LF278pWqvoWsIbOTKgI/qGseGOkyWq2Urav2ueH7YwznOt9UqyIvOLdZjHKVoWzhB
         zwEpnaMbQGGOFJltFOWd28lxdKKVORrOr4MupVCtp+4C4urk1hwIDL+AjqKJO75ud2
         eU87/m23EgdqkSSPcJOXNk8W1HMq6+ri0jOQpgRqxzEBX4qTPxsJUig+nXUvPHigAB
         6i4Xs7Lov3CYFxa+kTLvpHleKABmqMwyukvDjYigAFjG/zaUhrfSKRw5YDSXMqp/lo
         VdArnz5gSu9sQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/16] net/mlx5: Add command failures data to debugfs
Date:   Wed,  9 Mar 2022 13:37:41 -0800
Message-Id: <20220309213755.610202-3-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Add new counters to command interface debugfs to count command failures.
The following counters added:
total_failed - number of times command failed (any kind of failure).
failed_mbox_status - number of times command failed on bad status
returned by FW.

In addition, add data about last command failure to command interface
debugfs:
last_failed_errno - last command failed returned errno.
last_failed_mbox_status - last bad status returned by FW.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 44 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |  7 +++
 include/linux/mlx5/driver.h                   |  9 ++++
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 823d5808d5a0..8933c00067e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1877,16 +1877,38 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	return err;
 }
 
+static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status, int err)
+{
+	struct mlx5_cmd_stats *stats;
+
+	if (!err)
+		return;
+
+	stats = &dev->cmd.stats[opcode];
+	spin_lock_irq(&stats->lock);
+	stats->failed++;
+	if (err < 0)
+		stats->last_failed_errno = -err;
+	if (err == -EREMOTEIO) {
+		stats->failed_mbox_status++;
+		stats->last_failed_mbox_status = status;
+	}
+	spin_unlock_irq(&stats->lock);
+}
+
 /* preserve -EREMOTEIO for outbox.status != OK, otherwise return err as is */
-static int cmd_status_err(int err, void *out)
+static int cmd_status_err(struct mlx5_core_dev *dev, int err, u16 opcode, void *out)
 {
-	if (err) /* -EREMOTEIO is preserved */
-		return err == -EREMOTEIO ? -EIO : err;
+	u8 status = MLX5_GET(mbox_out, out, status);
 
-	if (MLX5_GET(mbox_out, out, status) != MLX5_CMD_STAT_OK)
-		return -EREMOTEIO;
+	if (err == -EREMOTEIO) /* -EREMOTEIO is preserved */
+		err = -EIO;
 
-	return 0;
+	if (!err && status != MLX5_CMD_STAT_OK)
+		err = -EREMOTEIO;
+
+	cmd_status_log(dev, opcode, status, err);
+	return err;
 }
 
 /**
@@ -1910,8 +1932,10 @@ static int cmd_status_err(int err, void *out)
 int mlx5_cmd_do(struct mlx5_core_dev *dev, void *in, int in_size, void *out, int out_size)
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, false);
+	u16 opcode = MLX5_GET(mbox_in, in, opcode);
 
-	return cmd_status_err(err, out);
+	err = cmd_status_err(dev, err, opcode, out);
+	return err;
 }
 EXPORT_SYMBOL(mlx5_cmd_do);
 
@@ -1954,8 +1978,9 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size)
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, true);
+	u16 opcode = MLX5_GET(mbox_in, in, opcode);
 
-	err = cmd_status_err(err, out);
+	err = cmd_status_err(dev, err, opcode, out);
 	return mlx5_cmd_check(dev, err, in, out);
 }
 EXPORT_SYMBOL(mlx5_cmd_exec_polling);
@@ -1991,7 +2016,7 @@ static void mlx5_cmd_exec_cb_handler(int status, void *_work)
 	struct mlx5_async_ctx *ctx;
 
 	ctx = work->ctx;
-	status = cmd_status_err(status, work->out);
+	status = cmd_status_err(ctx->dev, status, work->opcode, work->out);
 	work->user_callback(status, work);
 	if (atomic_dec_and_test(&ctx->num_inflight))
 		wake_up(&ctx->wait);
@@ -2005,6 +2030,7 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 
 	work->ctx = ctx;
 	work->user_callback = callback;
+	work->opcode = MLX5_GET(mbox_in, in, opcode);
 	work->out = out;
 	if (WARN_ON(!atomic_inc_not_zero(&ctx->num_inflight)))
 		return -EIO;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 10d195042ab5..18b04e977bb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -180,6 +180,13 @@ void mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev)
 			debugfs_create_file("average", 0400, stats->root, stats,
 					    &stats_fops);
 			debugfs_create_u64("n", 0400, stats->root, &stats->n);
+			debugfs_create_u64("failed", 0400, stats->root, &stats->failed);
+			debugfs_create_u64("failed_mbox_status", 0400, stats->root,
+					   &stats->failed_mbox_status);
+			debugfs_create_u32("last_failed_errno", 0400, stats->root,
+					   &stats->last_failed_errno);
+			debugfs_create_u8("last_failed_mbox_status", 0400, stats->root,
+					  &stats->last_failed_mbox_status);
 		}
 	}
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d3b1a6a1f8d2..f18c1e15a12c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -264,6 +264,14 @@ enum {
 struct mlx5_cmd_stats {
 	u64		sum;
 	u64		n;
+	/* number of times command failed */
+	u64		failed;
+	/* number of times command failed on bad status returned by FW */
+	u64		failed_mbox_status;
+	/* last command failed returned errno */
+	u32		last_failed_errno;
+	/* last bad status returned by FW */
+	u8		last_failed_mbox_status;
 	struct dentry  *root;
 	/* protect command average calculations */
 	spinlock_t	lock;
@@ -955,6 +963,7 @@ typedef void (*mlx5_async_cbk_t)(int status, struct mlx5_async_work *context);
 struct mlx5_async_work {
 	struct mlx5_async_ctx *ctx;
 	mlx5_async_cbk_t user_callback;
+	u16 opcode; /* cmd opcode */
 	void *out; /* pointer to the cmd output buffer */
 };
 
-- 
2.35.1

