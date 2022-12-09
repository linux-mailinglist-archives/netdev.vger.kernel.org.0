Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37828647A97
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLIAOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiLIAOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D518D182
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CD25B826B9
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9C9C433D2;
        Fri,  9 Dec 2022 00:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544874;
        bh=+NrOD0kF6/GsTDzdSAzgHJr0uG9U3qnA2pafSbDRVRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+pise6daEvbIqcAu64HA8CaHfylYlygoDjP7nmrFFd9eqdP7Ye1TqYQfiC2fh1I5
         hzTWNoah8pSly8JdjVLQ1xvYMXhQ+wIr6MtKdlHzStgO4P1yqsl3iT3a+wNyVquulg
         5aXNRwFUkT203GaZzj5rEdR9dAMaMi9hFhQjJwbgX29ylG/irZqrJeWTuvSIMPX88N
         Hxy0fotib1SfrTHnazfQLnZgJbnd5n1cJi+AEc+sSgs+TxBWZvJmzfcp7t0bZgBSPA
         HoaJYNh23eyHARQN8k4UOtQy06NLZpOE9vL2PG2u/Tx5XkJh5VcOMg2VtVTLOo39wt
         Raem62CGspj6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 04/15] net/mlx5: DR, Rework is_fw_table function
Date:   Thu,  8 Dec 2022 16:14:09 -0800
Message-Id: <20221209001420.142794-5-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

This patch handles the following two changes w.r.t. is_fw_table function:

1. When SW steering is asked to create/destroy FW table, we allow for
creation/destruction of only termination tables. Rename mlx5_dr_is_fw_table
both to comply with the static function naming and to reflect that we're
actually checking for FW termination table.

2. When the action 'go to flow table' is created, the destination flow
table can be any FW table, not only termination table. Adding function
to check if the dest table is FW table. This function will also be used
by the later creation of range match action, so putting it the header file.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_types.h    |  6 +++++
 .../mellanox/mlx5/core/steering/fs_dr.c       | 23 ++++++++++---------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 772ee747511f..804268b487d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1492,4 +1492,10 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    u32 flow_source);
 void mlx5dr_fw_destroy_md_tbl(struct mlx5dr_domain *dmn, u32 tbl_id,
 			      u32 group_id);
+
+static inline bool mlx5dr_is_fw_table(struct mlx5_flow_table *ft)
+{
+	return !ft->fs_dr_table.dr_table;
+}
+
 #endif  /* _DR_TYPES_H_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 13b6d4721e17..c78fb016c245 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -7,10 +7,11 @@
 #include "fs_cmd.h"
 #include "mlx5dr.h"
 #include "fs_dr.h"
+#include "dr_types.h"
 
-static bool mlx5_dr_is_fw_table(u32 flags)
+static bool dr_is_fw_term_table(struct mlx5_flow_table *ft)
 {
-	if (flags & MLX5_FLOW_TABLE_TERMINATION)
+	if (ft->flags & MLX5_FLOW_TABLE_TERMINATION)
 		return true;
 
 	return false;
@@ -69,7 +70,7 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow_root_namespace *ns,
 	u32 flags;
 	int err;
 
-	if (mlx5_dr_is_fw_table(ft->flags))
+	if (dr_is_fw_term_table(ft))
 		return mlx5_fs_cmd_get_fw_cmds()->create_flow_table(ns, ft,
 								    ft_attr,
 								    next_ft);
@@ -109,7 +110,7 @@ static int mlx5_cmd_dr_destroy_flow_table(struct mlx5_flow_root_namespace *ns,
 	struct mlx5dr_action *action = ft->fs_dr_table.miss_action;
 	int err;
 
-	if (mlx5_dr_is_fw_table(ft->flags))
+	if (dr_is_fw_term_table(ft))
 		return mlx5_fs_cmd_get_fw_cmds()->destroy_flow_table(ns, ft);
 
 	err = mlx5dr_table_destroy(ft->fs_dr_table.dr_table);
@@ -134,7 +135,7 @@ static int mlx5_cmd_dr_modify_flow_table(struct mlx5_flow_root_namespace *ns,
 					 struct mlx5_flow_table *ft,
 					 struct mlx5_flow_table *next_ft)
 {
-	if (mlx5_dr_is_fw_table(ft->flags))
+	if (dr_is_fw_term_table(ft))
 		return mlx5_fs_cmd_get_fw_cmds()->modify_flow_table(ns, ft, next_ft);
 
 	return set_miss_action(ns, ft, next_ft);
@@ -153,7 +154,7 @@ static int mlx5_cmd_dr_create_flow_group(struct mlx5_flow_root_namespace *ns,
 					    match_criteria_enable);
 	struct mlx5dr_match_parameters mask;
 
-	if (mlx5_dr_is_fw_table(ft->flags))
+	if (dr_is_fw_term_table(ft))
 		return mlx5_fs_cmd_get_fw_cmds()->create_flow_group(ns, ft, in,
 								    fg);
 
@@ -178,7 +179,7 @@ static int mlx5_cmd_dr_destroy_flow_group(struct mlx5_flow_root_namespace *ns,
 					  struct mlx5_flow_table *ft,
 					  struct mlx5_flow_group *fg)
 {
-	if (mlx5_dr_is_fw_table(ft->flags))
+	if (dr_is_fw_term_table(ft))
 		return mlx5_fs_cmd_get_fw_cmds()->destroy_flow_group(ns, ft, fg);
 
 	return mlx5dr_matcher_destroy(fg->fs_dr_matcher.dr_matcher);
@@ -209,7 +210,7 @@ static struct mlx5dr_action *create_ft_action(struct mlx5dr_domain *domain,
 {
 	struct mlx5_flow_table *dest_ft = dst->dest_attr.ft;
 
-	if (mlx5_dr_is_fw_table(dest_ft->flags))
+	if (mlx5dr_is_fw_table(dest_ft))
 		return mlx5dr_action_create_dest_flow_fw_table(domain, dest_ft);
 	return mlx5dr_action_create_dest_table(dest_ft->fs_dr_table.dr_table);
 }
@@ -260,7 +261,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	int err = 0;
 	int i;
 
-	if (mlx5_dr_is_fw_table(ft->flags))
+	if (dr_is_fw_term_table(ft))
 		return mlx5_fs_cmd_get_fw_cmds()->create_fte(ns, ft, group, fte);
 
 	actions = kcalloc(MLX5_FLOW_CONTEXT_ACTION_MAX, sizeof(*actions),
@@ -702,7 +703,7 @@ static int mlx5_cmd_dr_delete_fte(struct mlx5_flow_root_namespace *ns,
 	int err;
 	int i;
 
-	if (mlx5_dr_is_fw_table(ft->flags))
+	if (dr_is_fw_term_table(ft))
 		return mlx5_fs_cmd_get_fw_cmds()->delete_fte(ns, ft, fte);
 
 	err = mlx5dr_rule_destroy(rule->dr_rule);
@@ -727,7 +728,7 @@ static int mlx5_cmd_dr_update_fte(struct mlx5_flow_root_namespace *ns,
 	struct fs_fte fte_tmp = {};
 	int ret;
 
-	if (mlx5_dr_is_fw_table(ft->flags))
+	if (dr_is_fw_term_table(ft))
 		return mlx5_fs_cmd_get_fw_cmds()->update_fte(ns, ft, group, modify_mask, fte);
 
 	/* Backup current dr rule details */
-- 
2.38.1

