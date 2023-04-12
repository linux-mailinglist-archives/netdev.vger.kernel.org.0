Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D316DEA2F
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjDLEIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDLEIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D714696
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4BBA62DA5
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D64C4339B;
        Wed, 12 Apr 2023 04:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272489;
        bh=RNVh7v1CPtfo+tEEk56vxjRRrlZquvkdT0kmb1NPMwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjAsqEbzqgLqtmdpJsGxq6DpyJEKvxfNFY44DcOy0gP314aUZnFBWOb9Dedr6y+aC
         wc6bddZ9xKK2na7YB7Uf0ZY64hP2xifzyBkdb0NusxOLDbHGzAXpDDU6R7kY7PAnhj
         lIgWEah5pQG5gXYuC28bTJcpDgm3CXB+e0C7II52LZD3TWtSSjFlC+s9UZip96V3OX
         1d7gwfV47fG7xJz8aVgmdr0DTTTW3j/WyWmjSUbWRdw43JZS+ScFcpv+DGsEEcdIIH
         B8vs/0dfqfP9Zatw2jUvhEFtxIFjEII8cNHpQ2SQ4n34YpVEA/PhmR4ZQ+RR1mWUf/
         dTB/vlcjiV1FA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@mellanox.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Create a new profile for SFs
Date:   Tue, 11 Apr 2023 21:07:47 -0700
Message-Id: <20230412040752.14220-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
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

From: Parav Pandit <parav@mellanox.com>

Create a new profile for SFs in order to disable the command cache.
Each function command cache consumes ~500KB of memory, when using a
large number of SFs this savings is notable on memory constarined
systems.

Use a new profile to provide for future differences between SFs and PFs.

The mr_cache not used for non-PF functions, so it is excluded from the
new profile.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c           | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c          | 9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h     | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c | 2 +-
 include/linux/mlx5/driver.h                             | 1 +
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index b00e33ed05e9..d53de39539a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1802,7 +1802,7 @@ static struct mlx5_cmd_msg *alloc_msg(struct mlx5_core_dev *dev, int in_size,
 	if (in_size <= 16)
 		goto cache_miss;
 
-	for (i = 0; i < MLX5_NUM_COMMAND_CACHES; i++) {
+	for (i = 0; i < dev->profile.num_cmd_caches; i++) {
 		ch = &cmd->cache[i];
 		if (in_size > ch->max_inbox_size)
 			continue;
@@ -2097,7 +2097,7 @@ static void destroy_msg_cache(struct mlx5_core_dev *dev)
 	struct mlx5_cmd_msg *n;
 	int i;
 
-	for (i = 0; i < MLX5_NUM_COMMAND_CACHES; i++) {
+	for (i = 0; i < dev->profile.num_cmd_caches; i++) {
 		ch = &dev->cmd.cache[i];
 		list_for_each_entry_safe(msg, n, &ch->head, list) {
 			list_del(&msg->list);
@@ -2127,7 +2127,7 @@ static void create_msg_cache(struct mlx5_core_dev *dev)
 	int k;
 
 	/* Initialize and fill the caches with initial entries */
-	for (k = 0; k < MLX5_NUM_COMMAND_CACHES; k++) {
+	for (k = 0; k < dev->profile.num_cmd_caches; k++) {
 		ch = &cmd->cache[k];
 		spin_lock_init(&ch->lock);
 		INIT_LIST_HEAD(&ch->head);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f95df73d1089..a95d1218def9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -100,15 +100,19 @@ enum {
 static struct mlx5_profile profile[] = {
 	[0] = {
 		.mask           = 0,
+		.num_cmd_caches = MLX5_NUM_COMMAND_CACHES,
 	},
 	[1] = {
 		.mask		= MLX5_PROF_MASK_QP_SIZE,
 		.log_max_qp	= 12,
+		.num_cmd_caches = MLX5_NUM_COMMAND_CACHES,
+
 	},
 	[2] = {
 		.mask		= MLX5_PROF_MASK_QP_SIZE |
 				  MLX5_PROF_MASK_MR_CACHE,
 		.log_max_qp	= LOG_MAX_SUPPORTED_QPS,
+		.num_cmd_caches = MLX5_NUM_COMMAND_CACHES,
 		.mr_cache[0]	= {
 			.size	= 500,
 			.limit	= 250
@@ -174,6 +178,11 @@ static struct mlx5_profile profile[] = {
 			.limit	= 4
 		},
 	},
+	[3] = {
+		.mask		= MLX5_PROF_MASK_QP_SIZE,
+		.log_max_qp	= LOG_MAX_SUPPORTED_QPS,
+		.num_cmd_caches = 0,
+	},
 };
 
 static int wait_fw_init(struct mlx5_core_dev *dev, u32 max_wait_mili,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index be0785f83083..5eaab99678ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -142,6 +142,7 @@ enum mlx5_semaphore_space_address {
 };
 
 #define MLX5_DEFAULT_PROF       2
+#define MLX5_SF_PROF		3
 
 static inline int mlx5_flexible_inlen(struct mlx5_core_dev *dev, size_t fixed,
 				      size_t item_size, size_t num_items,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index a7377619ba6f..e2f26d0bc615 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -28,7 +28,7 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 	mdev->priv.adev_idx = adev->id;
 	sf_dev->mdev = mdev;
 
-	err = mlx5_mdev_init(mdev, MLX5_DEFAULT_PROF);
+	err = mlx5_mdev_init(mdev, MLX5_SF_PROF);
 	if (err) {
 		mlx5_core_warn(mdev, "mlx5_mdev_init on err=%d\n", err);
 		goto mdev_err;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f243bd10a5e1..135a3c8d8237 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -751,6 +751,7 @@ enum {
 struct mlx5_profile {
 	u64	mask;
 	u8	log_max_qp;
+	u8	num_cmd_caches;
 	struct {
 		int	size;
 		int	limit;
-- 
2.39.2

