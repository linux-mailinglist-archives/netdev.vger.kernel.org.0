Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A60B3F91BC
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244227AbhH0BAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243969AbhH0A73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B18E7610C7;
        Fri, 27 Aug 2021 00:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025902;
        bh=cFjPN43ElEZRXzaplp6yHa0v6eOYMXVbMuWESa07arQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HM9OdSLmCK1Yjuy747BGyz5Q492L/y4vr1JPD92d5oYDst3OTaB676m9sddatORO3
         eLSaUCxc1oUUsM/u4cWqY5l27rP0jS5dQMkM3La50iNtXbvx3l5QAK5Bb00T81i4gT
         PdEKYJdJO3wR2VfHF7lLJQEfK4iQGxnOYxXzRun3SyigIP3XbcEgSWuMtEEi6kgj8E
         5znra2qds/jr1ncw3E6fVTjKHVA7oqvJr3uGmAbdZutCBi3nRZn6H+/ni8OBRyJqHT
         bJbEy60QI4fosHEuGrcz5xsMssUbtdBEfMrgxqP6gafZbRZUNtI1xcMttO+LrjR62F
         AqXv/cFCM4yOw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/17] net/mlx5: DR, Add ignore_flow_level support for multi-dest flow tables
Date:   Thu, 26 Aug 2021 17:57:56 -0700
Message-Id: <20210827005802.236119-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When creating an FTE, we might need to create multi-destination flow table,
which is eventually created by FW. In such case, this FW table should
include all the FTE properties as requested by the upper layer, including
the ability to point to another flow table with level lower or equal to
the current table - indicated by the "ignore_flow_level" property.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c    | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c    | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c    | 6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h   | 3 ++-
 6 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index dcaf0bb94d2a..f3327eecddfa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -845,7 +845,8 @@ mlx5dr_action_create_dest_table(struct mlx5dr_table *tbl)
 struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
-				   u32 num_of_dests)
+				   u32 num_of_dests,
+				   bool ignore_flow_level)
 {
 	struct mlx5dr_cmd_flow_destination_hw_info *hw_dests;
 	struct mlx5dr_action **ref_actions;
@@ -912,7 +913,8 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				      num_of_dests,
 				      reformat_req,
 				      &action->dest_tbl->fw_tbl.id,
-				      &action->dest_tbl->fw_tbl.group_id);
+				      &action->dest_tbl->fw_tbl.group_id,
+				      ignore_flow_level);
 	if (ret)
 		goto free_action;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 54e1f5438bbe..56307283bf9b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -655,6 +655,7 @@ int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
 	MLX5_SET(set_fte_in, in, table_type, ft->type);
 	MLX5_SET(set_fte_in, in, table_id, ft->id);
 	MLX5_SET(set_fte_in, in, flow_index, fte->index);
+	MLX5_SET(set_fte_in, in, ignore_flow_level, fte->ignore_flow_level);
 	if (ft->vport) {
 		MLX5_SET(set_fte_in, in, vport_number, ft->vport);
 		MLX5_SET(set_fte_in, in, other_vport, 1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
index 7ccfd40586ce..0d6f86eb248b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_fw.c
@@ -103,7 +103,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    int num_dest,
 			    bool reformat_req,
 			    u32 *tbl_id,
-			    u32 *group_id)
+			    u32 *group_id,
+			    bool ignore_flow_level)
 {
 	struct mlx5dr_cmd_create_flow_table_attr ft_attr = {};
 	struct mlx5dr_cmd_fte_info fte_info = {};
@@ -137,6 +138,7 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 	fte_info.dests_size = num_dest;
 	fte_info.val = val;
 	fte_info.dest_arr = dest;
+	fte_info.ignore_flow_level = ignore_flow_level;
 
 	ret = mlx5dr_cmd_set_fte(dmn->mdev, 0, 0, &ft_info, *group_id, &fte_info);
 	if (ret) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 4fd14e9b7e1c..e45fbd6cc13c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1337,6 +1337,7 @@ struct mlx5dr_cmd_fte_info {
 	u32 *val;
 	struct mlx5_flow_act action;
 	struct mlx5dr_cmd_flow_destination_hw_info *dest_arr;
+	bool ignore_flow_level;
 };
 
 int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
@@ -1366,7 +1367,8 @@ int mlx5dr_fw_create_md_tbl(struct mlx5dr_domain *dmn,
 			    int num_dest,
 			    bool reformat_req,
 			    u32 *tbl_id,
-			    u32 *group_id);
+			    u32 *group_id,
+			    bool ignore_flow_level);
 void mlx5dr_fw_destroy_md_tbl(struct mlx5dr_domain *dmn, u32 tbl_id,
 			      u32 group_id);
 #endif  /* _DR_TYPES_H_ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 6ea4a0988062..633c9ec4c84e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -490,9 +490,13 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 
 		actions[num_actions++] = term_actions->dest;
 	} else if (num_term_actions > 1) {
+		bool ignore_flow_level =
+			!!(fte->action.flags & FLOW_ACT_IGNORE_FLOW_LEVEL);
+
 		tmp_action = mlx5dr_action_create_mult_dest_tbl(domain,
 								term_actions,
-								num_term_actions);
+								num_term_actions,
+								ignore_flow_level);
 		if (!tmp_action) {
 			err = -EOPNOTSUPP;
 			goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index fee37fa01368..c5a8b1601999 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -95,7 +95,8 @@ mlx5dr_action_create_dest_vport(struct mlx5dr_domain *domain,
 struct mlx5dr_action *
 mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 				   struct mlx5dr_action_dest *dests,
-				   u32 num_of_dests);
+				   u32 num_of_dests,
+				   bool ignore_flow_level);
 
 struct mlx5dr_action *mlx5dr_action_create_drop(void);
 
-- 
2.31.1

