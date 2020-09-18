Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629EB270355
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIRR26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbgIRR2y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:54 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D37A32311B;
        Fri, 18 Sep 2020 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450133;
        bh=IZjJS/gRptaQdMqMmcmvqvtBT6B9IaaRZerJM5ULIvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NzysxiRCZKLJUA6L+ujuXflt6T/MAVGTgSSBa0zogqhQvrYMsVxv7M/vFE7SAMMcx
         wWuUtuhER6okcEgnr9f/Fu9CpFn6TQxsHl1UDN7B8DYJvoAEx88QgmjEb15wv5eTxy
         p7b/sCTk+Bq6jhTZR1Z16/TiYnq6Zv/Gu1asYXpM=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Maor Dickman <maord@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/15] net/mlx5e: Enable adding peer miss rules only if merged eswitch is supported
Date:   Fri, 18 Sep 2020 10:28:30 -0700
Message-Id: <20200918172839.310037-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
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

