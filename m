Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1CE4C0B84
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238196AbiBWFLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237830AbiBWFKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:10:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0286A674C1;
        Tue, 22 Feb 2022 21:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53460B80E5B;
        Wed, 23 Feb 2022 05:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7731AC340EC;
        Wed, 23 Feb 2022 05:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593017;
        bh=Wy6yNI0qTeajjd6+BOEdOn8qpPEx89G1zbcaRBPj/ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvUHhUQee087tu+FZS+ngORqFJ2GGiopb19fk+J40yuMKlMAA38lDrNDp9Q5g0en8
         j6Ifu4AxjctCTIXdy5ZMNqsCECK3XW8neoejX1PhPBwGgA5AqwYqp7ZXYhTDGga37K
         VvQLvDeRHR1/Q0yTaQQeD3O1/w4g8WrGODc03AKrpm83ZdmxfZE14gQMW4207JtpX8
         8ZcOVI9n5N1G+Ra25w8SLUCLjj676QCVf0QaK47kY2kUrFbbv5B3Flcf82//tcGphG
         l8C44CsjmU5W8DlEuWb0sfOa557KK4bS40NLkr/ylCnxe6P73ytUNHFTqTPoYKkIAH
         MTKvw0sTwxMhg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [mlx5-next 11/17] net/mlx5: cmdif, cmd_check refactoring
Date:   Tue, 22 Feb 2022 21:09:26 -0800
Message-Id: <20220223050932.244668-12-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223050932.244668-1-saeed@kernel.org>
References: <20220223050932.244668-1-saeed@kernel.org>
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

Do not mangle the command outbox in the internal low level cmd_exec and
cmd_invoke functions.

Instead return a proper unique error code and move the driver error
checking to be at a higher level in mlx5_cmd_exec().

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 173 ++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/main.c    |   5 +-
 include/linux/mlx5/driver.h                   |   1 -
 3 files changed, 95 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 3c6a533ee0c9..7ff01b901f53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -760,43 +760,61 @@ struct mlx5_ifc_mbox_in_bits {
 	u8         reserved_at_40[0x40];
 };
 
-void mlx5_cmd_mbox_status(void *out, u8 *status, u32 *syndrome)
-{
-	*status = MLX5_GET(mbox_out, out, status);
-	*syndrome = MLX5_GET(mbox_out, out, syndrome);
-}
-
-static int mlx5_cmd_check(struct mlx5_core_dev *dev, void *in, void *out)
+static void cmd_status_print(struct mlx5_core_dev *dev, void *in, void *out)
 {
+	u16 opcode, op_mod;
 	u32 syndrome;
 	u8  status;
-	u16 opcode;
-	u16 op_mod;
 	u16 uid;
+	int err;
 
-	mlx5_cmd_mbox_status(out, &status, &syndrome);
-	if (!status)
-		return 0;
+	syndrome = MLX5_GET(mbox_out, out, syndrome);
+	status = MLX5_GET(mbox_out, out, status);
 
 	opcode = MLX5_GET(mbox_in, in, opcode);
 	op_mod = MLX5_GET(mbox_in, in, op_mod);
 	uid    = MLX5_GET(mbox_in, in, uid);
 
+	err = cmd_status_to_err(status);
+
 	if (!uid && opcode != MLX5_CMD_OP_DESTROY_MKEY)
 		mlx5_core_err_rl(dev,
-			"%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x)\n",
+			"%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x), err(%d)\n",
 			mlx5_command_str(opcode), opcode, op_mod,
-			cmd_status_str(status), status, syndrome);
+			cmd_status_str(status), status, syndrome, err);
 	else
 		mlx5_core_dbg(dev,
-		      "%s(0x%x) op_mod(0x%x) failed, status %s(0x%x), syndrome (0x%x)\n",
-		      mlx5_command_str(opcode),
-		      opcode, op_mod,
-		      cmd_status_str(status),
-		      status,
-		      syndrome);
+			"%s(0x%x) op_mod(0x%x) uid(%d) failed, status %s(0x%x), syndrome (0x%x), err(%d)\n",
+			mlx5_command_str(opcode), opcode, op_mod, uid,
+			cmd_status_str(status), status, syndrome, err);
+}
+
+static int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *out)
+{
+	/* aborted due to PCI error or via reset flow mlx5_cmd_trigger_completions() */
+	if (err == -ENXIO) {
+		u16 opcode = MLX5_GET(mbox_in, in, opcode);
+		u32 syndrome;
+		u8 status;
+
+		/* PCI Error, emulate command return status, for smooth reset */
+		err = mlx5_internal_err_ret_value(dev, opcode, &syndrome, &status);
+		MLX5_SET(mbox_out, out, status, status);
+		MLX5_SET(mbox_out, out, syndrome, syndrome);
+		if (!err)
+			return 0;
+	}
+
+	/* driver or FW delivery error */
+	if (err)
+		return err;
 
-	return cmd_status_to_err(status);
+	/* check outbox status */
+	err = cmd_status_to_err(MLX5_GET(mbox_out, out, status));
+	if (err)
+		cmd_status_print(dev, in, out);
+
+	return err;
 }
 
 static void dump_command(struct mlx5_core_dev *dev,
@@ -980,13 +998,7 @@ static void cmd_work_handler(struct work_struct *work)
 
 	/* Skip sending command to fw if internal error */
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
-		u8 status = 0;
-		u32 drv_synd;
-
-		ent->ret = mlx5_internal_err_ret_value(dev, msg_to_opcode(ent->in), &drv_synd, &status);
-		MLX5_SET(mbox_out, ent->out, status, status);
-		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
-
+		ent->ret = -ENXIO;
 		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
 		return;
 	}
@@ -1005,6 +1017,31 @@ static void cmd_work_handler(struct work_struct *work)
 	}
 }
 
+static int deliv_status_to_err(u8 status)
+{
+	switch (status) {
+	case MLX5_CMD_DELIVERY_STAT_OK:
+	case MLX5_DRIVER_STATUS_ABORTED:
+		return 0;
+	case MLX5_CMD_DELIVERY_STAT_SIGNAT_ERR:
+	case MLX5_CMD_DELIVERY_STAT_TOK_ERR:
+		return -EBADR;
+	case MLX5_CMD_DELIVERY_STAT_BAD_BLK_NUM_ERR:
+	case MLX5_CMD_DELIVERY_STAT_OUT_PTR_ALIGN_ERR:
+	case MLX5_CMD_DELIVERY_STAT_IN_PTR_ALIGN_ERR:
+		return -EFAULT; /* Bad address */
+	case MLX5_CMD_DELIVERY_STAT_IN_LENGTH_ERR:
+	case MLX5_CMD_DELIVERY_STAT_OUT_LENGTH_ERR:
+	case MLX5_CMD_DELIVERY_STAT_CMD_DESCR_ERR:
+	case MLX5_CMD_DELIVERY_STAT_RES_FLD_NOT_CLR_ERR:
+		return -ENOMSG;
+	case MLX5_CMD_DELIVERY_STAT_FW_ERR:
+		return -EIO;
+	default:
+		return -EINVAL;
+	}
+}
+
 static const char *deliv_status_to_str(u8 status)
 {
 	switch (status) {
@@ -1622,15 +1659,15 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 			ent->ts2 = ktime_get_ns();
 			memcpy(ent->out->first.data, ent->lay->out, sizeof(ent->lay->out));
 			dump_command(dev, ent, 0);
-			if (!ent->ret) {
+
+			if (vec & MLX5_TRIGGERED_CMD_COMP)
+				ent->ret = -ENXIO;
+
+			if (!ent->ret) { /* Command completed by FW */
 				if (!cmd->checksum_disabled)
 					ent->ret = verify_signature(ent);
-				else
-					ent->ret = 0;
-				if (vec & MLX5_TRIGGERED_CMD_COMP)
-					ent->status = MLX5_DRIVER_STATUS_ABORTED;
-				else
-					ent->status = ent->lay->status_own >> 1;
+
+				ent->status = ent->lay->status_own >> 1;
 
 				mlx5_core_dbg(dev, "command completed. ret 0x%x, delivery status %s(0x%x)\n",
 					      ent->ret, deliv_status_to_str(ent->status), ent->status);
@@ -1649,14 +1686,13 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				callback = ent->callback;
 				context = ent->context;
 				err = ent->ret;
-				if (!err) {
+				if (!err && !ent->status) {
 					err = mlx5_copy_from_msg(ent->uout,
 								 ent->out,
 								 ent->uout_size);
 
-					err = err ? err : mlx5_cmd_check(dev,
-									ent->in->first.data,
-									ent->uout);
+					err = mlx5_cmd_check(dev, err, ent->in->first.data,
+							     ent->uout);
 				}
 
 				mlx5_free_cmd_msg(dev, ent->out);
@@ -1729,31 +1765,6 @@ void mlx5_cmd_flush(struct mlx5_core_dev *dev)
 		up(&cmd->sem);
 }
 
-static int deliv_status_to_err(u8 status)
-{
-	switch (status) {
-	case MLX5_CMD_DELIVERY_STAT_OK:
-	case MLX5_DRIVER_STATUS_ABORTED:
-		return 0;
-	case MLX5_CMD_DELIVERY_STAT_SIGNAT_ERR:
-	case MLX5_CMD_DELIVERY_STAT_TOK_ERR:
-		return -EBADR;
-	case MLX5_CMD_DELIVERY_STAT_BAD_BLK_NUM_ERR:
-	case MLX5_CMD_DELIVERY_STAT_OUT_PTR_ALIGN_ERR:
-	case MLX5_CMD_DELIVERY_STAT_IN_PTR_ALIGN_ERR:
-		return -EFAULT; /* Bad address */
-	case MLX5_CMD_DELIVERY_STAT_IN_LENGTH_ERR:
-	case MLX5_CMD_DELIVERY_STAT_OUT_LENGTH_ERR:
-	case MLX5_CMD_DELIVERY_STAT_CMD_DESCR_ERR:
-	case MLX5_CMD_DELIVERY_STAT_RES_FLD_NOT_CLR_ERR:
-		return -ENOMSG;
-	case MLX5_CMD_DELIVERY_STAT_FW_ERR:
-		return -EIO;
-	default:
-		return -EINVAL;
-	}
-}
-
 static struct mlx5_cmd_msg *alloc_msg(struct mlx5_core_dev *dev, int in_size,
 				      gfp_t gfp)
 {
@@ -1812,15 +1823,8 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	u8 token;
 	int err;
 
-	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, opcode)) {
-		u32 drv_synd;
-		u8 status;
-
-		err = mlx5_internal_err_ret_value(dev, opcode, &drv_synd, &status);
-		MLX5_SET(mbox_out, out, status, status);
-		MLX5_SET(mbox_out, out, syndrome, drv_synd);
-		return err;
-	}
+	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, opcode))
+		return -ENXIO;
 
 	pages_queue = is_manage_pages(in);
 	gfp = callback ? GFP_ATOMIC : GFP_KERNEL;
@@ -1865,13 +1869,24 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	return err;
 }
 
+/**
+ * mlx5_cmd_exec - Executes a fw command, wait for completion
+ *
+ * @dev: mlx5 core device
+ * @in: inbox mlx5_ifc command buffer
+ * @in_size: inbox buffer size
+ * @out: outbox mlx5_ifc buffer
+ * @out_size: outbox size
+ *
+ * @return: 0 if no error, FW command execution was successful,
+ *          and outbox status is ok.
+ */
 int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 		  int out_size)
 {
-	int err;
+	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, false);
 
-	err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, false);
-	return err ? : mlx5_cmd_check(dev, in, out);
+	return mlx5_cmd_check(dev, err, in, out);
 }
 EXPORT_SYMBOL(mlx5_cmd_exec);
 
@@ -1932,11 +1947,9 @@ EXPORT_SYMBOL(mlx5_cmd_exec_cb);
 int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size)
 {
-	int err;
-
-	err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, true);
+	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, true);
 
-	return err ? : mlx5_cmd_check(dev, in, out);
+	return mlx5_cmd_check(dev, err, in, out);
 }
 EXPORT_SYMBOL(mlx5_cmd_exec_polling);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2c774f367199..cea1a8ac196e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -736,10 +736,9 @@ static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 	MLX5_SET(query_issi_in, query_in, opcode, MLX5_CMD_OP_QUERY_ISSI);
 	err = mlx5_cmd_exec_inout(dev, query_issi, query_in, query_out);
 	if (err) {
-		u32 syndrome;
-		u8 status;
+		u32 syndrome = MLX5_GET(query_issi_out, query_out, syndrome);
+		u8 status = MLX5_GET(query_issi_out, query_out, status);
 
-		mlx5_cmd_mbox_status(query_out, &status, &syndrome);
 		if (!status || syndrome == MLX5_DRIVER_SYND) {
 			mlx5_core_err(dev, "Failed to query ISSI err(%d) status(%d) synd(%d)\n",
 				      err, status, syndrome);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 1b398c9e17b9..8a8408708e6c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -981,7 +981,6 @@ int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 
 int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size);
-void mlx5_cmd_mbox_status(void *out, u8 *status, u32 *syndrome);
 bool mlx5_cmd_is_down(struct mlx5_core_dev *dev);
 
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
-- 
2.35.1

