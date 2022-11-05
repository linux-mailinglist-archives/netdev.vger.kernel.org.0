Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D1761D818
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiKEHKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEHKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:10:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675C22EF14
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 00:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEA9760010
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E95CC433B5;
        Sat,  5 Nov 2022 07:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667632237;
        bh=j9HTvWwvXk241A0Y/CRPm7I0L0kaJfz2NHFM1IpB91M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJJKcDnZtE87zmxwOggvi04PPf6PcJraCOEAD1F3PEILLAHyU8PdGo+4ctbA0keQv
         JcntPScCEBGQvF3YaoQtRhCIPpa1O4M+5YTTPzMS4yqFmym92j0va7bLJISQiUOLsP
         XrwqACES8PhVnKTZDegyJYRvqBr/1YI9LU7LU6Pv+V2HK8d2dEg2krYC4jEJ43mKaa
         iK7/GeyssG8MvyQXXIU4jnA8u2mmbG71vFNSS/9Z+uJ7YPdgT+5WviYKLcq8DN4B28
         qDlweZzRJEVLUhmXpLsSQHLYpuXs0Uu1ClMCeS+FuMFCNA+lOiIQOgfRzcC5fesC2v
         r/0c68c6Df+sg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [V2 net 03/11] net/mlx5: E-switch, Set to legacy mode if failed to change switchdev mode
Date:   Sat,  5 Nov 2022 00:10:20 -0700
Message-Id: <20221105071028.578594-4-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221105071028.578594-1-saeed@kernel.org>
References: <20221105071028.578594-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

No need to rollback to the other mode because probably will fail
again. Just set to legacy mode and clear fdb table created flag.
So that fdb table will not be cleared again.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c  | 14 ++++++++------
 .../mellanox/mlx5/core/eswitch_offloads.c      | 18 +++---------------
 2 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c59107fa9e6d..2169486c4bfb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1387,12 +1387,14 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw)
 		 esw->mode == MLX5_ESWITCH_LEGACY ? "LEGACY" : "OFFLOADS",
 		 esw->esw_funcs.num_vfs, esw->enabled_vports);
 
-	esw->fdb_table.flags &= ~MLX5_ESW_FDB_CREATED;
-	if (esw->mode == MLX5_ESWITCH_OFFLOADS)
-		esw_offloads_disable(esw);
-	else if (esw->mode == MLX5_ESWITCH_LEGACY)
-		esw_legacy_disable(esw);
-	mlx5_esw_acls_ns_cleanup(esw);
+	if (esw->fdb_table.flags & MLX5_ESW_FDB_CREATED) {
+		esw->fdb_table.flags &= ~MLX5_ESW_FDB_CREATED;
+		if (esw->mode == MLX5_ESWITCH_OFFLOADS)
+			esw_offloads_disable(esw);
+		else if (esw->mode == MLX5_ESWITCH_LEGACY)
+			esw_legacy_disable(esw);
+		mlx5_esw_acls_ns_cleanup(esw);
+	}
 
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS)
 		devl_rate_nodes_destroy(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4e50df3139c6..728ca9f2bb9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2310,7 +2310,7 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 static int esw_offloads_start(struct mlx5_eswitch *esw,
 			      struct netlink_ext_ack *extack)
 {
-	int err, err1;
+	int err;
 
 	esw->mode = MLX5_ESWITCH_OFFLOADS;
 	err = mlx5_eswitch_enable_locked(esw, esw->dev->priv.sriov.num_vfs);
@@ -2318,11 +2318,6 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed setting eswitch to offloads");
 		esw->mode = MLX5_ESWITCH_LEGACY;
-		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
-		if (err1) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Failed setting eswitch back to legacy");
-		}
 		mlx5_rescan_drivers(esw->dev);
 	}
 	if (esw->offloads.inline_mode == MLX5_INLINE_MODE_NONE) {
@@ -3389,19 +3384,12 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 static int esw_offloads_stop(struct mlx5_eswitch *esw,
 			     struct netlink_ext_ack *extack)
 {
-	int err, err1;
+	int err;
 
 	esw->mode = MLX5_ESWITCH_LEGACY;
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
-	if (err) {
+	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
-		esw->mode = MLX5_ESWITCH_OFFLOADS;
-		err1 = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
-		if (err1) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Failed setting eswitch back to offloads");
-		}
-	}
 
 	return err;
 }
-- 
2.38.1

