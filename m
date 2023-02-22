Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A925069FC4A
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjBVTgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBVTgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:36:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C772F79F
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:36:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54D4BB81696
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 19:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7146C433EF;
        Wed, 22 Feb 2023 19:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677094564;
        bh=ewCTDuBG2w8GtlK2ufhvx84dYhLBZmt2S/TTGtuVF90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COSoq5AWyns2MtumrUMW8NBkW/hQ/69iDz3KzoKaZWH2Rr6wk+suVLgZroEiTM8MN
         eAYCnQ3G4FLwpcFT6xqJ6auuy/Qb88VlqMCyg8aGBI7NHgx1ZKgZ15A73PzFwSloLm
         uTSliscivNvz0uuiYYGBJkMXLdBLoILhdOfEPtMYsr6p9tHzQqMvl6rkTMtLbN0PUB
         FyYdde3CBy7zDTg0iEBLcqA1VrGjrxpLh2hHbZlrqb5EQL91pkCe7CYqPBrhHWdQ28
         mJ5bAU3D4xfYm/SIGanWoS9rJ8m79P7DWsAxPDhNsL/BIZJP0NZ4QLvaTVAMfbVA/f
         R3fm3Ujsv+5Hg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net-next 1/4] net/mlx5e: Remove hairpin write debugfs files
Date:   Wed, 22 Feb 2023 11:35:45 -0800
Message-Id: <20230222193548.502031-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230222193548.502031-1-saeed@kernel.org>
References: <20230222193548.502031-1-saeed@kernel.org>
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

Issue: 3222646
Signed-off-by: Gal Pressman <gal@nvidia.com>
Change-Id: I7643b86b6353ffa915e04e547cb705c9527353e2
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

