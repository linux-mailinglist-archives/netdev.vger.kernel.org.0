Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48246653D2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbjAKFjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjAKFiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:38:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38169F29
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:31:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD46D614D4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28352C433F0;
        Wed, 11 Jan 2023 05:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415060;
        bh=LONfnzYZCWwi9kOU5eaVEEgCHXOGX9PBzJr2piiSACc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkZGVCz7nE5tzCygN+OJDkSk+ilA8gI77LVo5HcfsbiQ6YpuTwyM7I5m8AbtR1g4n
         gS8IF5bGlarouIIRPK5VtrnEhtuzgRXQ+8KbUijNo/Sfr27VxlbEQm1Hnd3xlg6T+U
         2/UpXFHQLNvIkUMWzR9vJFpgVJnqUMqOtAhqHQoFpxn4gCc0h9tWtAYVw/onVJfaxv
         ikltJYdgwkH/oiy3hvuazcnmAHNlsEdfcWSAA+JvXI0wUF6kQUEKoTP73PL04Oe9DM
         jwu1Xukz6tr2rjD4z59kfs39x77Dx5P88gI+2xRuMZnETqOMO4p2JFF1H/fABmWYZX
         6SI0DtMwiDlxA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 11/15] net/mlx5: Prevent high-rate FW commands from populating all slots
Date:   Tue, 10 Jan 2023 21:30:41 -0800
Message-Id: <20230111053045.413133-12-saeed@kernel.org>
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

Certain connection-based device-offload protocols (like TLS) use
per-connection HW objects to track the state, maintain the context, and
perform the offload properly. Some of these objects are created,
modified, and destroyed via FW commands. Under high connection rate,
this type of FW commands might continuously populate all slots of the FW
command interface and throttle it, while starving other critical control
FW commands.

Limit these throttle commands to using only up to a portion (half) of
the FW command interface slots. FW commands maximal rate is not hit, and
the same high rate is still reached when applying this limitation.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 30 ++++++++++++++++++-
 include/linux/mlx5/driver.h                   |  1 +
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 541eecfdd598..24da9c5e63e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -94,6 +94,21 @@ static u16 in_to_opcode(void *in)
 	return MLX5_GET(mbox_in, in, opcode);
 }
 
+/* Returns true for opcodes that might be triggered very frequently and throttle
+ * the command interface. Limit their command slots usage.
+ */
+static bool mlx5_cmd_is_throttle_opcode(u16 op)
+{
+	switch (op) {
+	case MLX5_CMD_OP_CREATE_GENERAL_OBJECT:
+	case MLX5_CMD_OP_DESTROY_GENERAL_OBJECT:
+	case MLX5_CMD_OP_MODIFY_GENERAL_OBJECT:
+	case MLX5_CMD_OP_QUERY_GENERAL_OBJECT:
+		return true;
+	}
+	return false;
+}
+
 static struct mlx5_cmd_work_ent *
 cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
 	      struct mlx5_cmd_msg *out, void *uout, int uout_size,
@@ -1825,6 +1840,7 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 {
 	struct mlx5_cmd_msg *inb, *outb;
 	u16 opcode = in_to_opcode(in);
+	bool throttle_op;
 	int pages_queue;
 	gfp_t gfp;
 	u8 token;
@@ -1833,13 +1849,21 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, opcode))
 		return -ENXIO;
 
+	throttle_op = mlx5_cmd_is_throttle_opcode(opcode);
+	if (throttle_op) {
+		/* atomic context may not sleep */
+		if (callback)
+			return -EINVAL;
+		down(&dev->cmd.throttle_sem);
+	}
+
 	pages_queue = is_manage_pages(in);
 	gfp = callback ? GFP_ATOMIC : GFP_KERNEL;
 
 	inb = alloc_msg(dev, in_size, gfp);
 	if (IS_ERR(inb)) {
 		err = PTR_ERR(inb);
-		return err;
+		goto out_up;
 	}
 
 	token = alloc_token(&dev->cmd);
@@ -1873,6 +1897,9 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 	mlx5_free_cmd_msg(dev, outb);
 out_in:
 	free_msg(dev, inb);
+out_up:
+	if (throttle_op)
+		up(&dev->cmd.throttle_sem);
 	return err;
 }
 
@@ -2222,6 +2249,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 
 	sema_init(&cmd->sem, cmd->max_reg_cmds);
 	sema_init(&cmd->pages_sem, 1);
+	sema_init(&cmd->throttle_sem, DIV_ROUND_UP(cmd->max_reg_cmds, 2));
 
 	cmd_h = (u32)((u64)(cmd->dma) >> 32);
 	cmd_l = (u32)(cmd->dma);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 50a5780367fa..7c393da396b1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -310,6 +310,7 @@ struct mlx5_cmd {
 	struct workqueue_struct *wq;
 	struct semaphore sem;
 	struct semaphore pages_sem;
+	struct semaphore throttle_sem;
 	int	mode;
 	u16     allowed_opcode;
 	struct mlx5_cmd_work_ent *ent_arr[MLX5_MAX_COMMANDS];
-- 
2.39.0

