Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5CC69FF30
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 00:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbjBVXDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 18:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbjBVXCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 18:02:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B12474FE
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 15:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81C36615B0
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 23:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CFBC4339C;
        Wed, 22 Feb 2023 23:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677106931;
        bh=tQMzmgKWqBOKkMmN/ZjTQpvvHbuk4gKR+DaY/pKs7MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkB786vVsrsEP4GztQ6fg0P27bXsMI3qL33aPs7cR8ny8/M2ZU5zf/GiY2tHDcR7E
         GbbL3wpFMkho3RFiOZTE8Y1Lc5JxUdTCmKjnt6Qi2yGEdUmvtVZHLsguB1oivmkBEk
         LPxV8ZRDhYHeY/EuMdTgMx0NsyagVDkXpyGtzZ1maSOCjpGnB+rGVrZy5sR6ddpgYK
         X+dlvIiBHcYoVqswjA23cHf2BZmYZnuATfFxm6Aiv1+LZcsbN9oUkXhz7Tsn2Sx1JP
         IhBVYkSR/5nRsfAa0fwZawrxlcuLiu3D3jYB7P7Gry9hAS8KJtqPy0aut+Gj/oEEdn
         uY7m2BeM7W9JA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next V2 1/4] net/mlx5e: Remove hairpin write debugfs files
Date:   Wed, 22 Feb 2023 15:01:59 -0800
Message-Id: <20230222230202.523667-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230222230202.523667-1-saeed@kernel.org>
References: <20230222230202.523667-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Per the discussion in [1], hairpin parameters will be exposed using
devlink, remove the debugfs files.

[1] https://lore.kernel.org/all/20230111194608.7f15b9a1@kernel.org/

Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 59 -------------------
 1 file changed, 59 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e34d9b5fb504..70b8d2dfa751 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1048,61 +1048,6 @@ static int mlx5e_hairpin_get_prio(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static int debugfs_hairpin_queues_set(void *data, u64 val)
-{
-	struct mlx5e_hairpin_params *hp = data;
-
-	if (!val) {
-		mlx5_core_err(hp->mdev,
-			      "Number of hairpin queues must be > 0\n");
-		return -EINVAL;
-	}
-
-	hp->num_queues = val;
-
-	return 0;
-}
-
-static int debugfs_hairpin_queues_get(void *data, u64 *val)
-{
-	struct mlx5e_hairpin_params *hp = data;
-
-	*val = hp->num_queues;
-
-	return 0;
-}
-DEFINE_DEBUGFS_ATTRIBUTE(fops_hairpin_queues, debugfs_hairpin_queues_get,
-			 debugfs_hairpin_queues_set, "%llu\n");
-
-static int debugfs_hairpin_queue_size_set(void *data, u64 val)
-{
-	struct mlx5e_hairpin_params *hp = data;
-
-	if (val > BIT(MLX5_CAP_GEN(hp->mdev, log_max_hairpin_num_packets))) {
-		mlx5_core_err(hp->mdev,
-			      "Invalid hairpin queue size, must be <= %lu\n",
-			      BIT(MLX5_CAP_GEN(hp->mdev,
-					       log_max_hairpin_num_packets)));
-		return -EINVAL;
-	}
-
-	hp->queue_size = roundup_pow_of_two(val);
-
-	return 0;
-}
-
-static int debugfs_hairpin_queue_size_get(void *data, u64 *val)
-{
-	struct mlx5e_hairpin_params *hp = data;
-
-	*val = hp->queue_size;
-
-	return 0;
-}
-DEFINE_DEBUGFS_ATTRIBUTE(fops_hairpin_queue_size,
-			 debugfs_hairpin_queue_size_get,
-			 debugfs_hairpin_queue_size_set, "%llu\n");
-
 static int debugfs_hairpin_num_active_get(void *data, u64 *val)
 {
 	struct mlx5e_tc_table *tc = data;
@@ -1148,10 +1093,6 @@ static void mlx5e_tc_debugfs_init(struct mlx5e_tc_table *tc,
 
 	tc->dfs_root = debugfs_create_dir("tc", dfs_root);
 
-	debugfs_create_file("hairpin_num_queues", 0644, tc->dfs_root,
-			    &tc->hairpin_params, &fops_hairpin_queues);
-	debugfs_create_file("hairpin_queue_size", 0644, tc->dfs_root,
-			    &tc->hairpin_params, &fops_hairpin_queue_size);
 	debugfs_create_file("hairpin_num_active", 0444, tc->dfs_root, tc,
 			    &fops_hairpin_num_active);
 	debugfs_create_file("hairpin_table_dump", 0444, tc->dfs_root, tc,
-- 
2.39.1

