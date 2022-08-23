Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8186959D0DB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbiHWF4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240420AbiHWF4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:56:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6262B5F21F
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E402861482
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA43C433D6;
        Tue, 23 Aug 2022 05:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234156;
        bh=BVgYPv3e+cprL0RV94SqG39TFFrlSoFmwU9vHLW4JeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sr778LBTBqTdZOVujoJNg+nDLj/bi+iAtDGSybS5/C7HignMven6Wy9DKXmNMURT5
         y1lYXyRb1W4ztZkPmgYZ/yB1jafiPGTZVxJRPAei+PXqnc+GB/OIkUuzBBNG02iBEo
         MQq9cVSWEk1TxCA1UNkLfCXNc2b4CXypm2rgrGeUkaih/JpntAAkzXwM9Wv6KNssNF
         shS6KRHoMEYnkMCR0qHVPhDDj+aywcAbywk9LVL993qlac5fEH6zSvGEuxzdHSooOg
         QfqKs2UnyL/XIItIo7TeRVRdef8bslKHMnJ2LPc4XKqgk7xwJUQiLHU8Pe4ljVziMU
         TyGkMngDXyCHQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: [net-next 13/15] net/mlx5: E-Switch, Split creating fdb tables into smaller chunks
Date:   Mon, 22 Aug 2022 22:55:31 -0700
Message-Id: <20220823055533.334471-14-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220823055533.334471-1-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Split esw_create_offloads_fdb_tables() into smaller functions.
This will help maintenance.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 330 +++++++++++-------
 1 file changed, 206 insertions(+), 124 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c2b1b2ff6846..4a0acb9dc290 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1669,18 +1669,209 @@ esw_chains_destroy(struct mlx5_eswitch *esw, struct mlx5_fs_chains *chains)
 
 #endif
 
+static int
+esw_create_send_to_vport_group(struct mlx5_eswitch *esw,
+			       struct mlx5_flow_table *fdb,
+			       u32 *flow_group_in,
+			       int *ix)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *g;
+	void *match_criteria;
+	int count, err = 0;
+
+	memset(flow_group_in, 0, inlen);
+
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_MISC_PARAMETERS);
+
+	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
+
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_sqn);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_port);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
+				 misc_parameters.source_eswitch_owner_vhca_id);
+		MLX5_SET(create_flow_group_in, flow_group_in,
+			 source_eswitch_owner_vhca_id_valid, 1);
+	}
+
+	/* See comment at table_size calculation */
+	count = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, *ix + count - 1);
+	*ix += count;
+
+	g = mlx5_create_flow_group(fdb, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		esw_warn(esw->dev, "Failed to create send-to-vport flow group err(%d)\n", err);
+		goto out;
+	}
+	esw->fdb_table.offloads.send_to_vport_grp = g;
+
+out:
+	return err;
+}
+
+static int
+esw_create_meta_send_to_vport_group(struct mlx5_eswitch *esw,
+				    struct mlx5_flow_table *fdb,
+				    u32 *flow_group_in,
+				    int *ix)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	int num_vfs = esw->esw_funcs.num_vfs;
+	struct mlx5_flow_group *g;
+	void *match_criteria;
+	int err = 0;
+
+	if (!esw_src_port_rewrite_supported(esw))
+		return 0;
+
+	memset(flow_group_in, 0, inlen);
+
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_MISC_PARAMETERS_2);
+
+	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
+
+	MLX5_SET(fte_match_param, match_criteria,
+		 misc_parameters_2.metadata_reg_c_0,
+		 mlx5_eswitch_get_vport_metadata_mask());
+	MLX5_SET(fte_match_param, match_criteria,
+		 misc_parameters_2.metadata_reg_c_1, ESW_TUN_MASK);
+
+	if (num_vfs) {
+		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, *ix);
+		MLX5_SET(create_flow_group_in, flow_group_in,
+			 end_flow_index, *ix + num_vfs - 1);
+		*ix += num_vfs;
+
+		g = mlx5_create_flow_group(fdb, flow_group_in);
+		if (IS_ERR(g)) {
+			err = PTR_ERR(g);
+			esw_warn(esw->dev,
+				 "Failed to create send-to-vport meta flow group err(%d)\n", err);
+			goto send_vport_meta_err;
+		}
+		esw->fdb_table.offloads.send_to_vport_meta_grp = g;
+
+		err = mlx5_eswitch_add_send_to_vport_meta_rules(esw);
+		if (err)
+			goto meta_rule_err;
+	}
+
+	return 0;
+
+meta_rule_err:
+	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_meta_grp);
+send_vport_meta_err:
+	return err;
+}
+
+static int
+esw_create_peer_esw_miss_group(struct mlx5_eswitch *esw,
+			       struct mlx5_flow_table *fdb,
+			       u32 *flow_group_in,
+			       int *ix)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *g;
+	void *match_criteria;
+	int err = 0;
+
+	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		return 0;
+
+	memset(flow_group_in, 0, inlen);
+
+	esw_set_flow_group_source_port(esw, flow_group_in);
+
+	if (!mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+		match_criteria = MLX5_ADDR_OF(create_flow_group_in,
+					      flow_group_in,
+					      match_criteria);
+
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
+				 misc_parameters.source_eswitch_owner_vhca_id);
+
+		MLX5_SET(create_flow_group_in, flow_group_in,
+			 source_eswitch_owner_vhca_id_valid, 1);
+	}
+
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, *ix);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
+		 *ix + esw->total_vports - 1);
+	*ix += esw->total_vports;
+
+	g = mlx5_create_flow_group(fdb, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		esw_warn(esw->dev, "Failed to create peer miss flow group err(%d)\n", err);
+		goto out;
+	}
+	esw->fdb_table.offloads.peer_miss_grp = g;
+
+out:
+	return err;
+}
+
+static int
+esw_create_miss_group(struct mlx5_eswitch *esw,
+		      struct mlx5_flow_table *fdb,
+		      u32 *flow_group_in,
+		      int *ix)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *g;
+	void *match_criteria;
+	int err = 0;
+	u8 *dmac;
+
+	memset(flow_group_in, 0, inlen);
+
+	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+		 MLX5_MATCH_OUTER_HEADERS);
+	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
+				      match_criteria);
+	dmac = MLX5_ADDR_OF(fte_match_param, match_criteria,
+			    outer_headers.dmac_47_16);
+	dmac[0] = 0x01;
+
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, *ix);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
+		 *ix + MLX5_ESW_MISS_FLOWS);
+
+	g = mlx5_create_flow_group(fdb, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		esw_warn(esw->dev, "Failed to create miss flow group err(%d)\n", err);
+		goto miss_err;
+	}
+	esw->fdb_table.offloads.miss_grp = g;
+
+	err = esw_add_fdb_miss_rule(esw);
+	if (err)
+		goto miss_rule_err;
+
+	return 0;
+
+miss_rule_err:
+	mlx5_destroy_flow_group(esw->fdb_table.offloads.miss_grp);
+miss_err:
+	return err;
+}
+
 static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table_attr ft_attr = {};
-	int num_vfs, table_size, ix, err = 0;
 	struct mlx5_core_dev *dev = esw->dev;
 	struct mlx5_flow_namespace *root_ns;
 	struct mlx5_flow_table *fdb = NULL;
+	int table_size, ix = 0, err = 0;
 	u32 flags = 0, *flow_group_in;
-	struct mlx5_flow_group *g;
-	void *match_criteria;
-	u8 *dmac;
 
 	esw_debug(esw->dev, "Create offloads FDB Tables\n");
 
@@ -1714,7 +1905,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	 * total vports of the peer (currently is also uses esw->total_vports).
 	 */
 	table_size = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ) +
-		MLX5_ESW_MISS_FLOWS + esw->total_vports + esw->esw_funcs.num_vfs;
+		     MLX5_ESW_MISS_FLOWS + esw->total_vports + esw->esw_funcs.num_vfs;
 
 	/* create the slow path fdb with encap set, so further table instances
 	 * can be created at run time while VFs are probed if the FW allows that.
@@ -1755,139 +1946,30 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 		goto fdb_chains_err;
 	}
 
-	/* create send-to-vport group */
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-		 MLX5_MATCH_MISC_PARAMETERS);
-
-	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
-
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_sqn);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_port);
-	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
-		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
-				 misc_parameters.source_eswitch_owner_vhca_id);
-		MLX5_SET(create_flow_group_in, flow_group_in,
-			 source_eswitch_owner_vhca_id_valid, 1);
-	}
-
-	/* See comment above table_size calculation */
-	ix = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ix - 1);
-
-	g = mlx5_create_flow_group(fdb, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "Failed to create send-to-vport flow group err(%d)\n", err);
+	err = esw_create_send_to_vport_group(esw, fdb, flow_group_in, &ix);
+	if (err)
 		goto send_vport_err;
-	}
-	esw->fdb_table.offloads.send_to_vport_grp = g;
-
-	if (esw_src_port_rewrite_supported(esw)) {
-		/* meta send to vport */
-		memset(flow_group_in, 0, inlen);
-		MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-			 MLX5_MATCH_MISC_PARAMETERS_2);
-
-		match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
-
-		MLX5_SET(fte_match_param, match_criteria,
-			 misc_parameters_2.metadata_reg_c_0,
-			 mlx5_eswitch_get_vport_metadata_mask());
-		MLX5_SET(fte_match_param, match_criteria,
-			 misc_parameters_2.metadata_reg_c_1, ESW_TUN_MASK);
-
-		num_vfs = esw->esw_funcs.num_vfs;
-		if (num_vfs) {
-			MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
-			MLX5_SET(create_flow_group_in, flow_group_in,
-				 end_flow_index, ix + num_vfs - 1);
-			ix += num_vfs;
-
-			g = mlx5_create_flow_group(fdb, flow_group_in);
-			if (IS_ERR(g)) {
-				err = PTR_ERR(g);
-				esw_warn(dev, "Failed to create send-to-vport meta flow group err(%d)\n",
-					 err);
-				goto send_vport_meta_err;
-			}
-			esw->fdb_table.offloads.send_to_vport_meta_grp = g;
-
-			err = mlx5_eswitch_add_send_to_vport_meta_rules(esw);
-			if (err)
-				goto meta_rule_err;
-		}
-	}
-
-	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
-		/* create peer esw miss group */
-		memset(flow_group_in, 0, inlen);
-
-		esw_set_flow_group_source_port(esw, flow_group_in);
-
-		if (!mlx5_eswitch_vport_match_metadata_enabled(esw)) {
-			match_criteria = MLX5_ADDR_OF(create_flow_group_in,
-						      flow_group_in,
-						      match_criteria);
-
-			MLX5_SET_TO_ONES(fte_match_param, match_criteria,
-					 misc_parameters.source_eswitch_owner_vhca_id);
-
-			MLX5_SET(create_flow_group_in, flow_group_in,
-				 source_eswitch_owner_vhca_id_valid, 1);
-		}
-
-		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
-		MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
-			 ix + esw->total_vports - 1);
-		ix += esw->total_vports;
-
-		g = mlx5_create_flow_group(fdb, flow_group_in);
-		if (IS_ERR(g)) {
-			err = PTR_ERR(g);
-			esw_warn(dev, "Failed to create peer miss flow group err(%d)\n", err);
-			goto peer_miss_err;
-		}
-		esw->fdb_table.offloads.peer_miss_grp = g;
-	}
-
-	/* create miss group */
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-		 MLX5_MATCH_OUTER_HEADERS);
-	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
-				      match_criteria);
-	dmac = MLX5_ADDR_OF(fte_match_param, match_criteria,
-			    outer_headers.dmac_47_16);
-	dmac[0] = 0x01;
 
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, ix);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
-		 ix + MLX5_ESW_MISS_FLOWS);
+	err = esw_create_meta_send_to_vport_group(esw, fdb, flow_group_in, &ix);
+	if (err)
+		goto send_vport_meta_err;
 
-	g = mlx5_create_flow_group(fdb, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "Failed to create miss flow group err(%d)\n", err);
-		goto miss_err;
-	}
-	esw->fdb_table.offloads.miss_grp = g;
+	err = esw_create_peer_esw_miss_group(esw, fdb, flow_group_in, &ix);
+	if (err)
+		goto peer_miss_err;
 
-	err = esw_add_fdb_miss_rule(esw);
+	err = esw_create_miss_group(esw, fdb, flow_group_in, &ix);
 	if (err)
-		goto miss_rule_err;
+		goto miss_err;
 
 	kvfree(flow_group_in);
 	return 0;
 
-miss_rule_err:
-	mlx5_destroy_flow_group(esw->fdb_table.offloads.miss_grp);
 miss_err:
 	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 peer_miss_err:
 	mlx5_eswitch_del_send_to_vport_meta_rules(esw);
-meta_rule_err:
 	if (esw->fdb_table.offloads.send_to_vport_meta_grp)
 		mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_meta_grp);
 send_vport_meta_err:
-- 
2.37.1

