Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBA4273772
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgIVAbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgIVAbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:15 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DAF723AA8;
        Tue, 22 Sep 2020 00:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734674;
        bh=IZjJS/gRptaQdMqMmcmvqvtBT6B9IaaRZerJM5ULIvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdyPdCN9kafGFgQqpgn4cQWVzLY6/6HpYQFTXJp7rb8pVRMYn7G8sA7xR5wZwo6x0
         vYxADkYmw0Nu23iM35cSf/EVY2PjaZyj4pI92BrFW7fp8pfW0t5PXYg9qsqsPGKhA1
         LvG8MEZAiywPlyl8cdff3GUIZi3DVSh+QZmYPnS4=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 06/15] net/mlx5e: Enable adding peer miss rules only if merged eswitch is supported
Date:   Mon, 21 Sep 2020 17:30:52 -0700
Message-Id: <20200922003101.529117-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@mellanox.com>

The cited commit creates peer miss group during switchdev mode
initialization in order to handle miss packets correctly while in VF
LAG mode. This is done regardless of FW support of such groups which
could cause rules setups failure later on.

Fix by adding FW capability check before creating peer groups/rule.

Fixes: ac004b832128 ("net/mlx5e: E-Switch, Add peer miss rules")
Signed-off-by: Maor Dickman <maord@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 52 ++++++++++---------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d2516922d867..1bcf2609dca8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1219,35 +1219,37 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	}
 	esw->fdb_table.offloads.send_to_vport_grp = g;
 
-	/* create peer esw miss group */
-	memset(flow_group_in, 0, inlen);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
+		/* create peer esw miss group */
+		memset(flow_group_in, 0, inlen);
 
-	esw_set_flow_group_source_port(esw, flow_group_in);
+		esw_set_flow_group_source_port(esw, flow_group_in);
 
-	if (!mlx5_eswitch_vport_match_metadata_enabled(esw)) {
-		match_criteria = MLX5_ADDR_OF(create_flow_group_in,
-					      flow_group_in,
-					      match_criteria);
+		if (!mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+			match_criteria = MLX5_ADDR_OF(create_flow_group_in,
+						      flow_group_in,
+						      match_criteria);
 
-		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
-				 misc_parameters.source_eswitch_owner_vhca_id);
+			MLX5_SET_TO_ONES(fte_match_param, match_criteria,
+					 misc_parameters.source_eswitch_owner_vhca_id);
 
-		MLX5_SET(create_flow_group_in, flow_group_in,
-			 source_eswitch_owner_vhca_id_valid, 1);
-	}
+			MLX5_SET(create_flow_group_in, flow_group_in,
+				 source_eswitch_owner_vhca_id_valid, 1);
+		}
 
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
-		 ix + esw->total_vports - 1);
-	ix += esw->total_vports;
+		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
+		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
+			 ix + esw->total_vports - 1);
+		ix += esw->total_vports;
 
-	g = mlx5_create_flow_group(fdb, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "Failed to create peer miss flow group err(%d)\n", err);
-		goto peer_miss_err;
+		g = mlx5_create_flow_group(fdb, flow_group_in);
+		if (IS_ERR(g)) {
+			err = PTR_ERR(g);
+			esw_warn(dev, "Failed to create peer miss flow group err(%d)\n", err);
+			goto peer_miss_err;
+		}
+		esw->fdb_table.offloads.peer_miss_grp = g;
 	}
-	esw->fdb_table.offloads.peer_miss_grp = g;
 
 	/* create miss group */
 	memset(flow_group_in, 0, inlen);
@@ -1281,7 +1283,8 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 miss_rule_err:
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.miss_grp);
 miss_err:
-	mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 peer_miss_err:
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_grp);
 send_vport_err:
@@ -1305,7 +1308,8 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	mlx5_del_flow_rules(esw->fdb_table.offloads.miss_rule_multi);
 	mlx5_del_flow_rules(esw->fdb_table.offloads.miss_rule_uni);
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_grp);
-	mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.miss_grp);
 
 	mlx5_esw_chains_destroy(esw);
-- 
2.26.2

