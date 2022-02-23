Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1704C0B83
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbiBWFLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238096AbiBWFKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:10:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64321674EF;
        Tue, 22 Feb 2022 21:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDB9EB81E7D;
        Wed, 23 Feb 2022 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EDFC340EB;
        Wed, 23 Feb 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645593017;
        bh=PO80qgQcTLyPqyPNhiMGCAqlSRzIkHT/vuwmukjzn20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3AlY6HZSd7aa0Ywbw+DbQxfUWDCeSB16ouTMfUgw6powb69m/PnhyQ1x4sDkTqld
         MjinfE9vqyFDzATCG/b9PJymVSfFqv6V5KvBzxs0w0ZxOZ221LM4WcLrOXbd3YgcUc
         kdSldxYaeX4QeW6ZE+Rv4tn/IrwUjulE2yefSLzFvxaf1BvfmtekhDl4MZ4+ZFwMB7
         WkQ26MzggjJgC2sZEg9a4y99+1J7n8nbCHl/JGTFn3L9tk4r0YF5+9UGGBAcmY2MJU
         9manYuJiQPb/R4+TyGSq03G2SVILFOPnX2BEeNoAhP+iJu/znME/qMqYB6Nob04Ko6
         hJZF5U4GC+GhQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [mlx5-next 12/17] net/mlx5: cmdif, Add new api for command execution
Date:   Tue, 22 Feb 2022 21:09:27 -0800
Message-Id: <20220223050932.244668-13-saeed@kernel.org>
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

Add mlx5_cmd_do. Unlike mlx5_cmd_exec, this function will not modify
or translate outbox.status.

The function will return:

return = 0: Command was executed, outbox.status == MLX5_CMD_STAT_OK.

return = -EREMOTEIO: Executed, outbox.status != MLX5_CMD_STAT_OK.

return < 0: Command execution couldn't be performed by FW or driver.

And document other mlx5_cmd_exec functions.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 79 ++++++++++++++++---
 include/linux/mlx5/driver.h                   |  2 +
 2 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 7ff01b901f53..a2f87a686a18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -789,7 +789,7 @@ static void cmd_status_print(struct mlx5_core_dev *dev, void *in, void *out)
 			cmd_status_str(status), status, syndrome, err);
 }
 
-static int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *out)
+int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *out)
 {
 	/* aborted due to PCI error or via reset flow mlx5_cmd_trigger_completions() */
 	if (err == -ENXIO) {
@@ -806,7 +806,7 @@ static int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *ou
 	}
 
 	/* driver or FW delivery error */
-	if (err)
+	if (err != -EREMOTEIO && err)
 		return err;
 
 	/* check outbox status */
@@ -816,6 +816,7 @@ static int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *ou
 
 	return err;
 }
+EXPORT_SYMBOL(mlx5_cmd_check);
 
 static void dump_command(struct mlx5_core_dev *dev,
 			 struct mlx5_cmd_work_ent *ent, int input)
@@ -1869,6 +1870,38 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	return err;
 }
 
+/**
+ * mlx5_cmd_do - Executes a fw command, wait for completion.
+ * Unlike mlx5_cmd_exec, this function will not translate or intercept
+ * outbox.status and will return -EREMOTEIO when
+ * outbox.status != MLX5_CMD_STAT_OK
+ *
+ * @dev: mlx5 core device
+ * @in: inbox mlx5_ifc command buffer
+ * @in_size: inbox buffer size
+ * @out: outbox mlx5_ifc buffer
+ * @out_size: outbox size
+ *
+ * @return:
+ * -EREMOTEIO : Command executed by FW, outbox.status != MLX5_CMD_STAT_OK.
+ *              Caller must check FW outbox status.
+ *   0 : Command execution successful, outbox.status == MLX5_CMD_STAT_OK.
+ * < 0 : Command execution couldn't be performed by firmware or driver
+ */
+int mlx5_cmd_do(struct mlx5_core_dev *dev, void *in, int in_size, void *out, int out_size)
+{
+	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, false);
+
+	if (err) /* -EREMOTEIO is preserved */
+		return err == -EREMOTEIO ? -EIO : err;
+
+	if (MLX5_GET(mbox_out, out, status) != MLX5_CMD_STAT_OK)
+		return -EREMOTEIO;
+
+	return 0;
+}
+EXPORT_SYMBOL(mlx5_cmd_do);
+
 /**
  * mlx5_cmd_exec - Executes a fw command, wait for completion
  *
@@ -1878,18 +1911,47 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
  * @out: outbox mlx5_ifc buffer
  * @out_size: outbox size
  *
- * @return: 0 if no error, FW command execution was successful,
+ * @return: 0 if no error, FW command execution was successful
  *          and outbox status is ok.
  */
 int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 		  int out_size)
 {
-	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, false);
+	int err = mlx5_cmd_do(dev, in, in_size, out, out_size);
 
 	return mlx5_cmd_check(dev, err, in, out);
 }
 EXPORT_SYMBOL(mlx5_cmd_exec);
 
+/**
+ * mlx5_cmd_exec_polling - Executes a fw command, poll for completion
+ *	Needed for driver force teardown, when command completion EQ
+ *	will not be available to complete the command
+ *
+ * @dev: mlx5 core device
+ * @in: inbox mlx5_ifc command buffer
+ * @in_size: inbox buffer size
+ * @out: outbox mlx5_ifc buffer
+ * @out_size: outbox size
+ *
+ * @return: 0 if no error, FW command execution was successful
+ *          and outbox status is ok.
+ */
+int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
+			  void *out, int out_size)
+{
+	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, true);
+
+	if (err) /* -EREMOTEIO is preserved */
+		return err == -EREMOTEIO ? -EIO : err;
+
+	if (MLX5_GET(mbox_out, out, status) != MLX5_CMD_STAT_OK)
+		err = -EREMOTEIO;
+
+	return mlx5_cmd_check(dev, err, in, out);
+}
+EXPORT_SYMBOL(mlx5_cmd_exec_polling);
+
 void mlx5_cmd_init_async_ctx(struct mlx5_core_dev *dev,
 			     struct mlx5_async_ctx *ctx)
 {
@@ -1944,15 +2006,6 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 }
 EXPORT_SYMBOL(mlx5_cmd_exec_cb);
 
-int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
-			  void *out, int out_size)
-{
-	int err = cmd_exec(dev, in, in_size, out, out_size, NULL, NULL, true);
-
-	return mlx5_cmd_check(dev, err, in, out);
-}
-EXPORT_SYMBOL(mlx5_cmd_exec_polling);
-
 static void destroy_msg_cache(struct mlx5_core_dev *dev)
 {
 	struct cmd_msg_cache *ch;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 8a8408708e6c..1b9bec8fa870 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -964,6 +964,8 @@ int mlx5_cmd_exec_cb(struct mlx5_async_ctx *ctx, void *in, int in_size,
 		     void *out, int out_size, mlx5_async_cbk_t callback,
 		     struct mlx5_async_work *work);
 
+int mlx5_cmd_do(struct mlx5_core_dev *dev, void *in, int in_size, void *out, int out_size);
+int mlx5_cmd_check(struct mlx5_core_dev *dev, int err, void *in, void *out);
 int mlx5_cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 		  int out_size);
 
-- 
2.35.1

