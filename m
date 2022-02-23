Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C9D4C1FFC
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245022AbiBWXkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244975AbiBWXkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B4C5AEEC;
        Wed, 23 Feb 2022 15:39:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35A0BB81878;
        Wed, 23 Feb 2022 23:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E26FC340F0;
        Wed, 23 Feb 2022 23:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659583;
        bh=B6rlk1rtjI2P39ex0T5rmDlTvyxeV3kbIgFoVuLN3+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deb7LbxmldhjDT7JP10EAH0cjtF9ye3Xk9soVUT6HqB1Ifpep3lA9DleWkAkUbeW2
         dPfDobfg7GdwWTOEmUAgVEEVsyzusEipSRORscMJ96yDsdVuy7cyp5h/0Evy3uVm/t
         dgbUN95+MiJd40e87hxVZeaNAMq65IbQnKrUu8wqR0yFQ9QMhtov4XaMxP3bJREjFK
         7oz3s1sWebkySwFBdH7pZThuFci2Vmyw/MY6u0AVWfNtDqJh+0sQLzab9Css4vk9H7
         QRF8GaBmwivvH9xHJDa4BhBRYi2FeQ9XSyGTHrXy+vrENlnO7XnRmlBupp9o+4t7TN
         GmQ8Tf1MzkY1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 10/17] net/mlx5: cmdif, Return value improvements
Date:   Wed, 23 Feb 2022 15:39:23 -0800
Message-Id: <20220223233930.319301-11-saeed@kernel.org>
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

Make sure that the two basic command interface functions cmd_exec and
cmd_invoke will return well defined return values:

return < 0 : Command execution couldn't be submitted by driver
return > 0 : Command execution couldn't be performed by firmware
return = 0 : Command was executed by FW, Caller must check FW
outbox status.

These statuses are valid for the blocking call of cmd_exec() e.g. when
callback == NULL, in a downstream patch, will refactor the code to
provide the same return value semantics to the callback.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 77 +++++++++++--------
 1 file changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 17fe05809653..3c6a533ee0c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -190,10 +190,10 @@ static int verify_block_sig(struct mlx5_cmd_prot_block *block)
 	int xor_len = sizeof(*block) - sizeof(block->data) - 1;
 
 	if (xor8_buf(block, rsvd0_off, xor_len) != 0xff)
-		return -EINVAL;
+		return -EHWPOISON;
 
 	if (xor8_buf(block, 0, sizeof(*block)) != 0xff)
-		return -EINVAL;
+		return -EHWPOISON;
 
 	return 0;
 }
@@ -259,12 +259,12 @@ static int verify_signature(struct mlx5_cmd_work_ent *ent)
 
 	sig = xor8_buf(ent->lay, 0, sizeof(*ent->lay));
 	if (sig != 0xff)
-		return -EINVAL;
+		return -EHWPOISON;
 
 	for (i = 0; i < n && next; i++) {
 		err = verify_block_sig(next->buf);
 		if (err)
-			return err;
+			return -EHWPOISON;
 
 		next = next->next;
 	}
@@ -479,7 +479,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core_dev *dev, u16 op,
 	case MLX5_CMD_OP_ALLOC_SF:
 		*status = MLX5_DRIVER_STATUS_ABORTED;
 		*synd = MLX5_DRIVER_SYND;
-		return -EIO;
+		return -ENOLINK;
 	default:
 		mlx5_core_err(dev, "Unknown FW command (%d)\n", op);
 		return -EINVAL;
@@ -1101,16 +1101,27 @@ static int wait_func(struct mlx5_core_dev *dev, struct mlx5_cmd_work_ent *ent)
 /*  Notes:
  *    1. Callback functions may not sleep
  *    2. page queue commands do not support asynchrous completion
+ *
+ * return value in case (!callback):
+ *	ret < 0 : Command execution couldn't be submitted by driver
+ *	ret > 0 : Command execution couldn't be performed by firmware
+ *	ret == 0: Command was executed by FW, Caller must check FW outbox status.
+ *
+ * return value in case (callback):
+ *	ret < 0 : Command execution couldn't be submitted by driver
+ *	ret == 0: Command will be submitted to FW for execution
+ *		  and the callback will be called for further status updates
  */
 static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 			   struct mlx5_cmd_msg *out, void *uout, int uout_size,
 			   mlx5_cmd_cbk_t callback,
-			   void *context, int page_queue, u8 *status,
+			   void *context, int page_queue,
 			   u8 token, bool force_polling)
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
 	struct mlx5_cmd_work_ent *ent;
 	struct mlx5_cmd_stats *stats;
+	u8 status = 0;
 	int err = 0;
 	s64 ds;
 	u16 op;
@@ -1141,12 +1152,12 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 		cmd_work_handler(&ent->work);
 	} else if (!queue_work(cmd->wq, &ent->work)) {
 		mlx5_core_warn(dev, "failed to queue work\n");
-		err = -ENOMEM;
+		err = -EALREADY;
 		goto out_free;
 	}
 
 	if (callback)
-		goto out; /* mlx5_cmd_comp_handler() will put(ent) */
+		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
 
 	err = wait_func(dev, ent);
 	if (err == -ETIMEDOUT || err == -ECANCELED)
@@ -1164,12 +1175,11 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
 	mlx5_core_dbg_mask(dev, 1 << MLX5_CMD_TIME,
 			   "fw exec time for %s is %lld nsec\n",
 			   mlx5_command_str(op), ds);
-	*status = ent->status;
 
 out_free:
+	status = ent->status;
 	cmd_ent_put(ent);
-out:
-	return err;
+	return err ? : status;
 }
 
 static ssize_t dbg_write(struct file *filp, const char __user *buf,
@@ -1719,7 +1729,7 @@ void mlx5_cmd_flush(struct mlx5_core_dev *dev)
 		up(&cmd->sem);
 }
 
-static int status_to_err(u8 status)
+static int deliv_status_to_err(u8 status)
 {
 	switch (status) {
 	case MLX5_CMD_DELIVERY_STAT_OK:
@@ -1787,22 +1797,25 @@ static int is_manage_pages(void *in)
 	return MLX5_GET(mbox_in, in, opcode) == MLX5_CMD_OP_MANAGE_PAGES;
 }
 
+/*  Notes:
+ *    1. Callback functions may not sleep
+ *    2. Page queue commands do not support asynchrous completion
+ */
 static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 		    int out_size, mlx5_cmd_cbk_t callback, void *context,
 		    bool force_polling)
 {
-	struct mlx5_cmd_msg *inb;
-	struct mlx5_cmd_msg *outb;
+	u16 opcode = MLX5_GET(mbox_in, in, opcode);
+	struct mlx5_cmd_msg *inb, *outb;
 	int pages_queue;
 	gfp_t gfp;
-	int err;
-	u8 status = 0;
-	u32 drv_synd;
-	u16 opcode;
 	u8 token;
+	int err;
 
-	opcode = MLX5_GET(mbox_in, in, opcode);
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, opcode)) {
+		u32 drv_synd;
+		u8 status;
+
 		err = mlx5_internal_err_ret_value(dev, opcode, &drv_synd, &status);
 		MLX5_SET(mbox_out, out, status, status);
 		MLX5_SET(mbox_out, out, syndrome, drv_synd);
@@ -1833,26 +1846,22 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	}
 
 	err = mlx5_cmd_invoke(dev, inb, outb, out, out_size, callback, context,
-			      pages_queue, &status, token, force_polling);
-	if (err)
-		goto out_out;
+			      pages_queue, token, force_polling);
+	if (callback)
+		return err;
 
-	mlx5_core_dbg(dev, "err %d, status %d\n", err, status);
-	if (status) {
-		err = status_to_err(status);
-		goto out_out;
-	}
+	if (err > 0) /* Failed in FW, command didn't execute */
+		err = deliv_status_to_err(err);
 
-	if (!callback)
-		err = mlx5_copy_from_msg(out, outb, out_size);
+	if (err)
+		goto out_out;
 
+	/* command completed by FW */
+	err = mlx5_copy_from_msg(out, outb, out_size);
 out_out:
-	if (!callback)
-		mlx5_free_cmd_msg(dev, outb);
-
+	mlx5_free_cmd_msg(dev, outb);
 out_in:
-	if (!callback)
-		free_msg(dev, inb);
+	free_msg(dev, inb);
 	return err;
 }
 
-- 
2.35.1

