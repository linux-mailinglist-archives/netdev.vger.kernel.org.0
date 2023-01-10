Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22195663911
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjAJGLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjAJGLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:11:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019451D0CA
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 22:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DB03614DB
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8C8C433EF;
        Tue, 10 Jan 2023 06:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673331100;
        bh=zpzs5PDSA1ThDMf8G4uGYpuJtIvo7yXnGgPHVEySmeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gm2KPv0Fxzy6gLo/o/Zer463S71oco7kOCpVuhrGQMDY1r5rxmN+6dNJQLR5uM8qn
         PMT9YaZ5RiDtlvtseV4b6h5quvQYIznzV5Pdj+MRb3YGPIwuo1G9BlZopUmlWN/g8j
         itTxwLTNn/Qu2ZLWeKCaNiP+pPWEAhHZOLUIgoPAS4iZnI8878uOrGOQG/YXCyvVKC
         rW47Wnizt4w27THsT7eD/7U5ULo705dBU+VofOaKdAUERzzRhIUtEt0gQPUZjmwX30
         JmZg15iiUPyJBqS5up5+mEZ/yIVsgOBmC8gVV/wsILueZSgb0q5WjyIFAdn4bQg45n
         qL2RfKC4fSs9A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: [net 04/16] net/mlx5: Fix command stats access after free
Date:   Mon,  9 Jan 2023 22:11:11 -0800
Message-Id: <20230110061123.338427-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110061123.338427-1-saeed@kernel.org>
References: <20230110061123.338427-1-saeed@kernel.org>
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

Command may fail while driver is reloading and can't accept FW commands
till command interface is reinitialized. Such command failure is being
logged to command stats. This results in NULL pointer access as command
stats structure is being freed and reallocated during mlx5 devlink
reload (see kernel log below).

Fix it by making command stats statically allocated on driver probe.

Kernel log:
[ 2394.808802] BUG: unable to handle kernel paging request at 000000000002a9c0
[ 2394.810610] PGD 0 P4D 0
[ 2394.811811] Oops: 0002 [#1] SMP NOPTI
...
[ 2394.815482] RIP: 0010:native_queued_spin_lock_slowpath+0x183/0x1d0
...
[ 2394.829505] Call Trace:
[ 2394.830667]  _raw_spin_lock_irq+0x23/0x26
[ 2394.831858]  cmd_status_err+0x55/0x110 [mlx5_core]
[ 2394.833020]  mlx5_access_reg+0xe7/0x150 [mlx5_core]
[ 2394.834175]  mlx5_query_port_ptys+0x78/0xa0 [mlx5_core]
[ 2394.835337]  mlx5e_ethtool_get_link_ksettings+0x74/0x590 [mlx5_core]
[ 2394.836454]  ? kmem_cache_alloc_trace+0x140/0x1c0
[ 2394.837562]  __rh_call_get_link_ksettings+0x33/0x100
[ 2394.838663]  ? __rtnl_unlock+0x25/0x50
[ 2394.839755]  __ethtool_get_link_ksettings+0x72/0x150
[ 2394.840862]  duplex_show+0x6e/0xc0
[ 2394.841963]  dev_attr_show+0x1c/0x40
[ 2394.843048]  sysfs_kf_seq_show+0x9b/0x100
[ 2394.844123]  seq_read+0x153/0x410
[ 2394.845187]  vfs_read+0x91/0x140
[ 2394.846226]  ksys_read+0x4f/0xb0
[ 2394.847234]  do_syscall_64+0x5b/0x1a0
[ 2394.848228]  entry_SYSCALL_64_after_hwframe+0x65/0xca

Fixes: 34f46ae0d4b3 ("net/mlx5: Add command failures data to debugfs")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 13 ++-----------
 include/linux/mlx5/driver.h                   |  2 +-
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index d3ca745d107d..c837103a9ee3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -2176,15 +2176,9 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 		return -EINVAL;
 	}
 
-	cmd->stats = kvcalloc(MLX5_CMD_OP_MAX, sizeof(*cmd->stats), GFP_KERNEL);
-	if (!cmd->stats)
-		return -ENOMEM;
-
 	cmd->pool = dma_pool_create("mlx5_cmd", mlx5_core_dma_dev(dev), size, align, 0);
-	if (!cmd->pool) {
-		err = -ENOMEM;
-		goto dma_pool_err;
-	}
+	if (!cmd->pool)
+		return -ENOMEM;
 
 	err = alloc_cmd_page(dev, cmd);
 	if (err)
@@ -2268,8 +2262,6 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 
 err_free_pool:
 	dma_pool_destroy(cmd->pool);
-dma_pool_err:
-	kvfree(cmd->stats);
 	return err;
 }
 
@@ -2282,7 +2274,6 @@ void mlx5_cmd_cleanup(struct mlx5_core_dev *dev)
 	destroy_msg_cache(dev);
 	free_cmd_page(dev, cmd);
 	dma_pool_destroy(cmd->pool);
-	kvfree(cmd->stats);
 }
 
 void mlx5_cmd_set_state(struct mlx5_core_dev *dev,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d476255c9a3f..76ef2e4fde38 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -315,7 +315,7 @@ struct mlx5_cmd {
 	struct mlx5_cmd_debug dbg;
 	struct cmd_msg_cache cache[MLX5_NUM_COMMAND_CACHES];
 	int checksum_disabled;
-	struct mlx5_cmd_stats *stats;
+	struct mlx5_cmd_stats stats[MLX5_CMD_OP_MAX];
 };
 
 struct mlx5_cmd_mailbox {
-- 
2.39.0

