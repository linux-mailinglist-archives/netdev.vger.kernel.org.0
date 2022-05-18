Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8350752B26B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiERGes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiERGer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:34:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A65E7323
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77FBE617C0
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8457C385A9;
        Wed, 18 May 2022 06:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652855680;
        bh=SDZynVjj1s6pBvZZ/4QzXeC8Y19kveOQkCaOp+NmCLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjZ5e1miisdPFX+LSc6gas/DOR5Z0Ce7PF9vZlM5cO1zUlOczNyX6R7REzsww0bSJ
         9D8WNiqCK+EKPMouZmVo3Hc7zaVJacJj/uto2Yn4jVcVfTqtFTjRAdNy7XV6ZYrLk1
         sYDIG7QkOtB+Ja3qXnVhtJNBds6Tn1bwjODrL40Pz9YDtjHRFaKjFCg7fCYK8W4mRG
         qXIE5bAZlQAEVLB8ieJ/o4kMlW+ZhwGF27/s4BaHy8zoValdzWUXa/Q4rmPB4OlECp
         hLashd6YcjFkdsOhbyyZO+3Grll8LWYPGku122L6ih50zInZjXDdGwCyHEqH2BN7jh
         78UVGaInQOuWQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/11] net/mlx5: DR, Fix missing flow_source when creating multi-destination FW table
Date:   Tue, 17 May 2022 23:34:17 -0700
Message-Id: <20220518063427.123758-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518063427.123758-1-saeed@kernel.org>
References: <20220518063427.123758-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

In order to support multiple destination FTEs with SW steering
FW table is created with single FTE with multiple actions and
SW steering rule forward to it. When creating this table, flow
source isn't set according to the original FTE.

Fix this by passing the original FTE flow source to the created
FW table.

Fixes: 34583beea4b7 ("net/mlx5: DR, Create multi-destination table for SW-steering use")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c    | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c    | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c    | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h   | 3 ++-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 850937cd8bf9..b52b539c8d2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -842,7 +842,8 @@ struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
 				   u32 num_of_dests,
-				   bool ignore_flow_level)
+				   bool ignore_flow_level,
+				   u32 flow_source)
 {
 	struct mlx5dr_cmd_flow_destination_hw_info *hw_dests;
 	struct mlx5dr_action **ref_actions;
@@ -914,7 +915,8 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				      reformat_req,
 				      &action->dest_tbl->fw_tbl.id,
 				      &action->dest_tbl->fw_tbl.group_id,
-				      ignore_flow_level);
+				      ignore_flow_level,
+				      flow_source);
 	if (ret)
 		goto free_action;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 68a4c32d5f34..f05ef0cd54ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -104,7 +104,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    bool reformat_req,
 			    u32 *tbl_id,
 			    u32 *group_id,
-			    bool ignore_flow_level)
+			    bool ignore_flow_level,
+			    u32 flow_source)
 {
 	struct mlx5dr_cmd_create_flow_table_attr ft_attr = {};
 	struct mlx5dr_cmd_fte_info fte_info = {};
@@ -139,6 +140,7 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 	fte_info.val = val;
 	fte_info.dest_arr = dest;
 	fte_info.ignore_flow_level = ignore_flow_level;
+	fte_info.flow_context.flow_source = flow_source;
 
 	ret = mlx5dr_cmd_set_fte(dmn->mdev, 0, 0, &ft_info, *group_id, &fte_info);
 	if (ret) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 46866a5fc5ca..98320e3945ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1461,7 +1461,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    bool reformat_req,
 			    u32 *tbl_id,
 			    u32 *group_id,
-			    bool ignore_flow_level);
+			    bool ignore_flow_level,
+			    u32 flow_source);
 void mlx5dr_fw_destroy_md_tbl(struct mlx5dr_domain *dmn, u32 tbl_id,
 			      u32 group_id);
 #endif  /* _DR_TYPES_H_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 045b0cf90063..728f81882589 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -520,6 +520,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	} else if (num_term_actions > 1) {
 		bool ignore_flow_level =
 			!!(fte->action.flags & FLOW_ACT_IGNORE_FLOW_LEVEL);
+		u32 flow_source = fte->flow_context.flow_source;
 
 		if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
 		    fs_dr_num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX) {
@@ -529,7 +530,8 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 		tmp_action = mlx5dr_action_create_mult_dest_tbl(domain,
 								term_actions,
 								num_term_actions,
-								ignore_flow_level);
+								ignore_flow_level,
+								flow_source);
 		if (!tmp_action) {
 			err = -EOPNOTSUPP;
 			goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index ec5cbec0d455..7626c85643b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -99,7 +99,8 @@ struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
 				   u32 num_of_dests,
-				   bool ignore_flow_level);
+				   bool ignore_flow_level,
+				   u32 flow_source);
 
 struct mlx5dr_action *mlx5dr_action_create_drop(void);
 
-- 
2.36.1

