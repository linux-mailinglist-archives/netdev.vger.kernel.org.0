Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430EB4C1FF3
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245024AbiBWXko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244984AbiBWXk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E345C875;
        Wed, 23 Feb 2022 15:39:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 584D7CE1CEC;
        Wed, 23 Feb 2022 23:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1974BC340F3;
        Wed, 23 Feb 2022 23:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659586;
        bh=0Gg7pQShoekXL9aMv8rYa3c3b7cFK7gk0kHmhFu+mIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUSR6kUljVGw205Rl9TV9nBi3/b6Q1GUHUVSWJTpCqjkcwv4Tap8YTWqlq7ZcWvYG
         h6fVcvT+tVELoItSw8pRXlW3JVXRhPNIrIS8CgwLHZiL2mm65n0fqz5IYQPX0ui6HO
         fOW46ahgrbJe9lbRkpPtVA9ZkQULkdTaUwbkJlwIQMJJRrebu/Irj9X/cMJ7eocqyH
         Zffqa+216nTdeglkT8ngio7yI+s5lFTY40Ol/zY1wFGSZh2/pf2JMnkSCCjcsM6t7e
         H0eLsrJAoD5E6+CGo7jAmkPiDX8678jn/u8ppE17rqD6HL91eQllbh3No5LOHUeSGt
         6IerI1m+NqQPg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 14/17] net/mlx5: cmdif, Refactor error handling and reporting of async commands
Date:   Wed, 23 Feb 2022 15:39:27 -0800
Message-Id: <20220223233930.319301-15-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

Same as the new mlx5_cmd_do API, report all information to callers and
let them handle the error values and outbox parsing.

The user callback status "work->user_callback(status)" is now similar to
the error rc code returned from the blocking mlx5_cmd_do() version,
and now is defined as follows:

 -EREMOTEIO : Command executed by FW, outbox.status != MLX5_CMD_STAT_OK.
              Caller must check FW outbox status.
 0 : Command execution successful,  outbox.status == MLX5_CMD_STAT_OK.
 < 0 : Command couldn't execute, FW or driver induced error.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c               | 15 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 61 +++++++++++--------
 include/linux/mlx5/driver.h                   |  3 +-
 3 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 157d862fb864..06e4b8cea6bd 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -140,6 +140,19 @@ static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	return mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
 }
 
+static void create_mkey_warn(struct mlx5_ib_dev *dev, int status, void *out)
+{
+	if (status == -ENXIO) /* core driver is not available */
+		return;
+
+	mlx5_ib_warn(dev, "async reg mr failed. status %d\n", status);
+	if (status != -EREMOTEIO) /* driver specific failure */
+		return;
+
+	/* Failed in FW, print cmd out failure details */
+	mlx5_cmd_out_err(dev->mdev, MLX5_CMD_OP_CREATE_MKEY, 0, out);
+}
+
 static void create_mkey_callback(int status, struct mlx5_async_work *context)
 {
 	struct mlx5_ib_mr *mr =
@@ -149,7 +162,7 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 	unsigned long flags;
 
 	if (status) {
-		mlx5_ib_warn(dev, "async reg mr failed. status %d\n", status);
+		create_mkey_warn(dev, status, mr->out);
 		kfree(mr);
 		spin_lock_irqsave(&ent->lock, flags);
 		ent->pending--;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index a2f87a686a18..823d5808d5a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -760,6 +760,18 @@ struct mlx5_ifc_mbox_in_bits {
 	u8         reserved_at_40[0x40];
 };
 
+void mlx5_cmd_out_err(struct mlx5_core_dev *dev, u16 opcode, u16 op_mod, void *out)
+{
+	u32 syndrome = MLX5_GET(mbox_out, out, syndrome);
+	u8 status = MLX5_GET(mbox_out, out, status);
+
+	mlx5_core_err_rl(dev,
+			 "%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x), err(%d)\n",
+			 mlx5_command_str(opcode), opcode, op_mod,
+			 cmd_status_str(status), status, syndrome, cmd_status_to_err(status));
+}
+EXPORT_SYMBOL(mlx5_cmd_out_err);
+
 static void cmd_status_print(struct mlx5_core_dev *dev, void *in, void *out)
 {
 	u16 opcode, op_mod;
@@ -778,10 +790,7 @@ static void cmd_status_print(struct mlx5_core_dev *dev, void *in, void *out)
 	err = cmd_status_to_err(status);
 
 	if (!uid && opcode != MLX5_CMD_OP_DESTROY_MKEY)
-		mlx5_core_err_rl(dev,
-			"%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x), err(%d)\n",
-			mlx5_command_str(opcode), opcode, op_mod,
-			cmd_status_str(status), status, syndrome, err);
+		mlx5_cmd_out_err(dev, opcode, op_mod, out);
 	else
 		mlx5_core_dbg(dev,
 			"%s(0x%x) op_mod(0x%x) uid(%d) failed, status %s(0x%x), syndrome (0x%x), err(%d)\n",
@@ -1686,20 +1695,18 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 
 				callback = ent->callback;
 				context = ent->context;
-				err = ent->ret;
-				if (!err && !ent->status) {
+				err = ent->ret ? : ent->status;
+				if (err > 0) /* Failed in FW, command didn't execute */
+					err = deliv_status_to_err(err);
+
+				if (!err)
 					err = mlx5_copy_from_msg(ent->uout,
 								 ent->out,
 								 ent->uout_size);
 
-					err = mlx5_cmd_check(dev, err, ent->in->first.data,
-							     ent->uout);
-				}
-
 				mlx5_free_cmd_msg(dev, ent->out);
 				free_msg(dev, ent->in);
 
-				err = err ? err : ent->status;
 				/* final consumer is done, release ent */
 				cmd_ent_put(ent);
 				callback(err, context);
@@ -1870,6 +1877,18 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	return err;
 }
 
+/* preserve -EREMOTEIO for outbox.status != OK, otherwise return err as is */
+static int cmd_status_err(int err, void *out)
+{
+	if (err) /* -EREMOTEIO is preserved */
+		return err == -EREMOTEIO ? -EIO : err;
+
+	if (MLX5_GET(mbox_out, out, status) != MLX5_CMD_STAT_OK)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
 /**
  * mlx5_cmd_do - Executes a fw command, wait for completion.
  * Unlike mlx5_cmd_exec, this function will not translate or intercept
@@ -1892,13 +1911,7 @@ int mlx5_cmd_do(struct mlx5_core_dev *dev, void *in, int in_size, void *out, int
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, false);
 
-	if (err) /* -EREMOTEIO is preserved */
-		return err == -EREMOTEIO ? -EIO : err;
-
-	if (MLX5_GET(mbox_out, out, status) != MLX5_CMD_STAT_OK)
-		return -EREMOTEIO;
-
-	return 0;
+	return cmd_status_err(err, out);
 }
 EXPORT_SYMBOL(mlx5_cmd_do);
 
@@ -1942,12 +1955,7 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 {
 	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, true);
 
-	if (err) /* -EREMOTEIO is preserved */
-		return err == -EREMOTEIO ? -EIO : err;
-
-	if (MLX5_GET(mbox_out, out, status) != MLX5_CMD_STAT_OK)
-		err = -EREMOTEIO;
-
+	err = cmd_status_err(err, out);
 	return mlx5_cmd_check(dev, err, in, out);
 }
 EXPORT_SYMBOL(mlx5_cmd_exec_polling);
@@ -1980,8 +1988,10 @@ EXPORT_SYMBOL(mlx5_cmd_cleanup_async_ctx);
 static void mlx5_cmd_exec_cb_handler(int status, void *_work)
 {
 	struct mlx5_async_work *work = _work;
-	struct mlx5_async_ctx *ctx = work->ctx;
+	struct mlx5_async_ctx *ctx;
 
+	ctx = work->ctx;
+	status = cmd_status_err(status, work->out);
 	work->user_callback(status, work);
 	if (atomic_dec_and_test(&ctx->num_inflight))
 		wake_up(&ctx->wait);
@@ -1995,6 +2005,7 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 
 	work->ctx = ctx;
 	work->user_callback = callback;
+	work->out = out;
 	if (WARN_ON(!atomic_inc_not_zero(&ctx->num_inflight)))
 		return -EIO;
 	ret = cmd_exec(ctx->dev, in, in_size, out, out_size,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1b9bec8fa870..432151d7d0bf 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -955,6 +955,7 @@ typedef void (*mlx5_async_cbk_t)(int status, struct mlx5_async_work *context);
 struct mlx5_async_work {
 	struct mlx5_async_ctx *ctx;
 	mlx5_async_cbk_t user_callback;
+	void *out; /* pointer to the cmd output buffer */
 };
 
 void mlx5_cmd_init_async_ctx(struct mlx5_core_dev *dev,
@@ -963,7 +964,7 @@ void mlx5_cmd_cleanup_async_ctx(struct mlx5_async_ctx *ctx);
 int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 		     void *out, int out_size, mlx5_async_cbk_t callback,
 		     struct mlx5_async_work *work);
-
+void mlx5_cmd_out_err(struct mlx5_core_dev *dev, u16 opcode, u16 op_mod, void *out);
 int mlx5_cmd_do(struct mlx5_core_dev *dev, void *in, int in_size, void *out, int out_size);
 int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *out);
 int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
-- 
2.35.1

