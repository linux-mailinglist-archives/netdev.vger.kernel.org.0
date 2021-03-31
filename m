Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC6E350805
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhCaURI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:17:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236470AbhCaUQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE47D610A0;
        Wed, 31 Mar 2021 20:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221799;
        bh=Fc9P0/NhrJCRq3AaZlBF/4uS3Zt0W3xejOhimKmYYyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZZ1Fwdc4LIArACGx79HznVw0dXidE4ZZYZX92PCiW4DviUN0TEby/meffQmaj/pa
         QVATbCE31F2vrVXjh5RVcFX3YsJmUPBGmFxH14uDGvs2O1HS+9UFcoZZPeQjoFYcZk
         bYbjX1ugwhItCG6E2Ik39/H3/OUY/8VwT2ChKyvCQ+8vc7wh2SGvp3EalLctt8x6hM
         9xjpRcQuYDAGLCmFBs0+/NY42BWYZ44NDV1X+NPV89l245oWuhOebY//slBrC4Iuzr
         WrgjzoXwXEEkTw5kJqhBDKGX/+UGMdD86+RnzstoOOqKS0qju2EUJJW+c+G/hn/1Wr
         m27JgSdqkr1vw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/9] net/mlx5: E-switch, Create vport miss group only if src rewrite is supported
Date:   Wed, 31 Mar 2021 13:14:19 -0700
Message-Id: <20210331201424.331095-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201424.331095-1-saeed@kernel.org>
References: <20210331201424.331095-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Create send to vport miss group was added in order to support traffic
recirculation to root table with metadata source rewrite.
This group is created also in case source rewrite isn't supported.

Fixed by creating send to vport miss group only if source rewrite is
supported by FW.

Fixes: 8e404fefa58b ("net/mlx5e: Match recirculated packet miss in slow table using reg_c1")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 68 +++++++++++--------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8694b83968b4..d4a2f8d1ee9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -537,6 +537,14 @@ esw_setup_vport_dests(struct mlx5_flow_destination *dest, struct mlx5_flow_act *
 	return i;
 }
 
+static bool
+esw_src_port_rewrite_supported(struct mlx5_eswitch *esw)
+{
+	return MLX5_CAP_GEN(esw->dev, reg_c_preserve) &&
+	       mlx5_eswitch_vport_match_metadata_enabled(esw) &&
+	       MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level);
+}
+
 static int
 esw_setup_dests(struct mlx5_flow_destination *dest,
 		struct mlx5_flow_act *flow_act,
@@ -550,9 +558,7 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 	int err = 0;
 
 	if (!mlx5_eswitch_termtbl_required(esw, attr, flow_act, spec) &&
-	    MLX5_CAP_GEN(esw_attr->in_mdev, reg_c_preserve) &&
-	    mlx5_eswitch_vport_match_metadata_enabled(esw) &&
-	    MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level))
+	    esw_src_port_rewrite_supported(esw))
 		attr->flags |= MLX5_ESW_ATTR_FLAG_SRC_REWRITE;
 
 	if (attr->dest_ft) {
@@ -1716,36 +1722,40 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	}
 	esw->fdb_table.offloads.send_to_vport_grp = g;
 
-	/* meta send to vport */
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-		 MLX5_MATCH_MISC_PARAMETERS_2);
-
-	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
+	if (esw_src_port_rewrite_supported(esw)) {
+		/* meta send to vport */
+		memset(flow_group_in, 0, inlen);
+		MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+			 MLX5_MATCH_MISC_PARAMETERS_2);
 
-	MLX5_SET(fte_match_param, match_criteria,
-		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
-	MLX5_SET(fte_match_param, match_criteria,
-		 misc_parameters_2.metadata_reg_c_1, ESW_TUN_MASK);
+		match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
 
-	num_vfs = esw->esw_funcs.num_vfs;
-	if (num_vfs) {
-		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
-		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ix + num_vfs - 1);
-		ix += num_vfs;
+		MLX5_SET(fte_match_param, match_criteria,
+			 misc_parameters_2.metadata_reg_c_0,
+			 mlx5_eswitch_get_vport_metadata_mask());
+		MLX5_SET(fte_match_param, match_criteria,
+			 misc_parameters_2.metadata_reg_c_1, ESW_TUN_MASK);
 
-		g = mlx5_create_flow_group(fdb, flow_group_in);
-		if (IS_ERR(g)) {
-			err = PTR_ERR(g);
-			esw_warn(dev, "Failed to create send-to-vport meta flow group err(%d)\n",
-				 err);
-			goto send_vport_meta_err;
+		num_vfs = esw->esw_funcs.num_vfs;
+		if (num_vfs) {
+			MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
+			MLX5_SET(create_flow_group_in, flow_group_in,
+				 end_flow_index, ix + num_vfs - 1);
+			ix += num_vfs;
+
+			g = mlx5_create_flow_group(fdb, flow_group_in);
+			if (IS_ERR(g)) {
+				err = PTR_ERR(g);
+				esw_warn(dev, "Failed to create send-to-vport meta flow group err(%d)\n",
+					 err);
+				goto send_vport_meta_err;
+			}
+			esw->fdb_table.offloads.send_to_vport_meta_grp = g;
+
+			err = mlx5_eswitch_add_send_to_vport_meta_rules(esw);
+			if (err)
+				goto meta_rule_err;
 		}
-		esw->fdb_table.offloads.send_to_vport_meta_grp = g;
-
-		err = mlx5_eswitch_add_send_to_vport_meta_rules(esw);
-		if (err)
-			goto meta_rule_err;
 	}
 
 	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
-- 
2.30.2

