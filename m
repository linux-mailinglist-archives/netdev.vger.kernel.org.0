Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B98B59D0E1
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbiHWF40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240423AbiHWF4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB225F226
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A8086144E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77659C43141;
        Tue, 23 Aug 2022 05:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234157;
        bh=YuuvM3Q3v7jHPCOJ+WIV4B83JH1v73XM/Nq3+tK24l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSlS3n4sTyhkET/dq5OJUrDre3pU6xIJI8Lf6FZkoa5mgHKyXs7Jnu2yiOipu2BoR
         uIv1dxZSyxrMfVsW+AO+Pw+YTxuyCIWZ2kNVHGhBw9bcVYDwOaI7U0PVgc24bbCPTH
         yvPOdEZ97vkEbtAf6kdHbT6bic4XKTCjBgxWJReFePy7mosxn7fJGG1AwntPMAld3E
         e92RehASQrbmlj8UCLFfaFVqLo51ltX6pBiMWq7SZoXMfzjr4PI5MFp1FskKcqHevL
         OGiB61H8L5s4iuq35V8hW0kwYAXI3k49aQxQOxhzSO6xZjFQt/ZD5+TVXbhHzT1mpp
         eh3yXuSIk5ghA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: [net-next 14/15] net/mlx5: E-Switch, Move send to vport meta rule creation
Date:   Mon, 22 Aug 2022 22:55:32 -0700
Message-Id: <20220823055533.334471-15-saeed@kernel.org>
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

Move the creation of the rules from offloads fdb table init to
per rep vport init.
This way the driver will creating the send to vport meta rule
on any representor, e.g. SF representors.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  53 ++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   9 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   1 -
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 112 +++++-------------
 6 files changed, 90 insertions(+), 94 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8426614092fd..640518d0e716 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2738,7 +2738,7 @@ void mlx5e_activate_priv_channels(struct mlx5e_priv *priv)
 	netif_tx_start_all_queues(priv->netdev);
 
 	if (mlx5e_is_vport_rep(priv))
-		mlx5e_add_sqs_fwd_rules(priv);
+		mlx5e_rep_activate_channels(priv);
 
 	mlx5e_wait_channels_min_rx_wqes(&priv->channels);
 
@@ -2752,7 +2752,7 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 		mlx5e_rx_res_channels_deactivate(priv->rx_res);
 
 	if (mlx5e_is_vport_rep(priv))
-		mlx5e_remove_sqs_fwd_rules(priv);
+		mlx5e_rep_deactivate_channels(priv);
 
 	/* The results of ndo_select_queue are unreliable, while netdev config
 	 * is being changed (real_num_tx_queues, num_tc). Stop all queues to
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c85fd0223449..c8617a62e542 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -398,7 +398,8 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
 	return err;
 }
 
-int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
+static int
+mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 {
 	int sqs_per_channel = mlx5e_get_dcb_num_tc(&priv->channels.params);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
@@ -452,7 +453,8 @@ int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv)
 	return err;
 }
 
-void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
+static void
+mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
@@ -461,6 +463,53 @@ void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
 	mlx5e_sqs2vport_stop(esw, rep);
 }
 
+static int
+mlx5e_rep_add_meta_tunnel_rule(struct mlx5e_priv *priv)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct mlx5_flow_handle *flow_rule;
+	struct mlx5_flow_group *g;
+	int err;
+
+	g = esw->fdb_table.offloads.send_to_vport_meta_grp;
+	if (!g)
+		return 0;
+
+	flow_rule = mlx5_eswitch_add_send_to_vport_meta_rule(esw, rep->vport);
+	if (IS_ERR(flow_rule)) {
+		err = PTR_ERR(flow_rule);
+		goto out;
+	}
+
+	rpriv->send_to_vport_meta_rule = flow_rule;
+
+out:
+	return err;
+}
+
+static void
+mlx5e_rep_del_meta_tunnel_rule(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	if (rpriv->send_to_vport_meta_rule)
+		mlx5_eswitch_del_send_to_vport_meta_rule(rpriv->send_to_vport_meta_rule);
+}
+
+void mlx5e_rep_activate_channels(struct mlx5e_priv *priv)
+{
+	mlx5e_add_sqs_fwd_rules(priv);
+	mlx5e_rep_add_meta_tunnel_rule(priv);
+}
+
+void mlx5e_rep_deactivate_channels(struct mlx5e_priv *priv)
+{
+	mlx5e_rep_del_meta_tunnel_rule(priv);
+	mlx5e_remove_sqs_fwd_rules(priv);
+}
+
 static int mlx5e_rep_open(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index dec183ccd4ac..b4e691760da9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -111,6 +111,7 @@ struct mlx5e_rep_priv {
 	struct list_head       vport_sqs_list;
 	struct mlx5_rep_uplink_priv uplink_priv; /* valid for uplink rep */
 	struct rtnl_link_stats64 prev_vf_vport_stats;
+	struct mlx5_flow_handle *send_to_vport_meta_rule;
 	struct rhashtable tc_ht;
 };
 
@@ -241,8 +242,8 @@ int mlx5e_rep_get_offload_stats(int attr_id, const struct net_device *dev,
 				void *sp);
 
 bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv);
-int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv);
-void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv);
+void mlx5e_rep_activate_channels(struct mlx5e_priv *priv);
+void mlx5e_rep_deactivate_channels(struct mlx5e_priv *priv);
 
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
@@ -256,8 +257,8 @@ static inline bool mlx5e_eswitch_rep(const struct net_device *netdev)
 
 #else /* CONFIG_MLX5_ESWITCH */
 static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
-static inline int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv) { return 0; }
-static inline void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv) {}
+static inline void mlx5e_rep_activate_channels(struct mlx5e_priv *priv) {}
+static inline void mlx5e_rep_deactivate_channels(struct mlx5e_priv *priv) {}
 static inline int mlx5e_rep_init(void) { return 0; };
 static inline void mlx5e_rep_cleanup(void) {};
 static inline bool mlx5e_rep_has_offload_stats(const struct net_device *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6aa58044b949..c59107fa9e6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1360,7 +1360,6 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS) {
 		struct devlink *devlink = priv_to_devlink(esw->dev);
 
-		esw_offloads_del_send_to_vport_meta_rules(esw);
 		devl_rate_nodes_destroy(devlink);
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index d7fc665deab2..f68dc2d0dbe6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -346,7 +346,10 @@ void esw_offloads_disable(struct mlx5_eswitch *esw);
 int esw_offloads_enable(struct mlx5_eswitch *esw);
 void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw);
 int esw_offloads_init_reps(struct mlx5_eswitch *esw);
-void esw_offloads_del_send_to_vport_meta_rules(struct mlx5_eswitch *esw);
+
+struct mlx5_flow_handle *
+mlx5_eswitch_add_send_to_vport_meta_rule(struct mlx5_eswitch *esw, u16 vport_num);
+void mlx5_eswitch_del_send_to_vport_meta_rule(struct mlx5_flow_handle *rule);
 
 bool mlx5_esw_vport_match_metadata_supported(const struct mlx5_eswitch *esw);
 int mlx5_esw_offloads_vport_metadata_set(struct mlx5_eswitch *esw, bool enable);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4a0acb9dc290..287689beb79c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1059,52 +1059,23 @@ void mlx5_eswitch_del_send_to_vport_rule(struct mlx5_flow_handle *rule)
 	mlx5_del_flow_rules(rule);
 }
 
-static void mlx5_eswitch_del_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
+void mlx5_eswitch_del_send_to_vport_meta_rule(struct mlx5_flow_handle *rule)
 {
-	struct mlx5_flow_handle **flows = esw->fdb_table.offloads.send_to_vport_meta_rules;
-	int i = 0, num_vfs = esw->esw_funcs.num_vfs;
-
-	if (!num_vfs || !flows)
-		return;
-
-	for (i = 0; i < num_vfs; i++)
-		mlx5_del_flow_rules(flows[i]);
-
-	kvfree(flows);
-	/* If changing eswitch mode from switchdev to legacy, but num_vfs is not 0,
-	 * meta rules could be freed again. So set it to NULL.
-	 */
-	esw->fdb_table.offloads.send_to_vport_meta_rules = NULL;
+	if (rule)
+		mlx5_del_flow_rules(rule);
 }
 
-void esw_offloads_del_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
-{
-	mlx5_eswitch_del_send_to_vport_meta_rules(esw);
-}
-
-static int
-mlx5_eswitch_add_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
+struct mlx5_flow_handle *
+mlx5_eswitch_add_send_to_vport_meta_rule(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {0};
-	int num_vfs, rule_idx = 0, err = 0;
 	struct mlx5_flow_handle *flow_rule;
-	struct mlx5_flow_handle **flows;
 	struct mlx5_flow_spec *spec;
-	struct mlx5_vport *vport;
-	unsigned long i;
-	u16 vport_num;
-
-	num_vfs = esw->esw_funcs.num_vfs;
-	flows = kvcalloc(num_vfs, sizeof(*flows), GFP_KERNEL);
-	if (!flows)
-		return -ENOMEM;
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec) {
-		err = -ENOMEM;
-		goto alloc_err;
-	}
+	if (!spec)
+		return ERR_PTR(-ENOMEM);
 
 	MLX5_SET(fte_match_param, spec->match_criteria,
 		 misc_parameters_2.metadata_reg_c_0, mlx5_eswitch_get_vport_metadata_mask());
@@ -1117,34 +1088,18 @@ mlx5_eswitch_add_send_to_vport_meta_rules(struct mlx5_eswitch *esw)
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
-	mlx5_esw_for_each_vf_vport(esw, i, vport, num_vfs) {
-		vport_num = vport->vport;
-		MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_c_0,
-			 mlx5_eswitch_get_vport_metadata_for_match(esw, vport_num));
-		dest.vport.num = vport_num;
-
-		flow_rule = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
-						spec, &flow_act, &dest, 1);
-		if (IS_ERR(flow_rule)) {
-			err = PTR_ERR(flow_rule);
-			esw_warn(esw->dev, "FDB: Failed to add send to vport meta rule idx %d, err %ld\n",
-				 rule_idx, PTR_ERR(flow_rule));
-			goto rule_err;
-		}
-		flows[rule_idx++] = flow_rule;
-	}
+	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_c_0,
+		 mlx5_eswitch_get_vport_metadata_for_match(esw, vport_num));
+	dest.vport.num = vport_num;
 
-	esw->fdb_table.offloads.send_to_vport_meta_rules = flows;
-	kvfree(spec);
-	return 0;
+	flow_rule = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+					spec, &flow_act, &dest, 1);
+	if (IS_ERR(flow_rule))
+		esw_warn(esw->dev, "FDB: Failed to add send to vport meta rule vport %d, err %ld\n",
+			 vport_num, PTR_ERR(flow_rule));
 
-rule_err:
-	while (--rule_idx >= 0)
-		mlx5_del_flow_rules(flows[rule_idx]);
 	kvfree(spec);
-alloc_err:
-	kvfree(flows);
-	return err;
+	return flow_rule;
 }
 
 static bool mlx5_eswitch_reg_c1_loopback_supported(struct mlx5_eswitch *esw)
@@ -1721,7 +1676,6 @@ esw_create_meta_send_to_vport_group(struct mlx5_eswitch *esw,
 				    int *ix)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	int num_vfs = esw->esw_funcs.num_vfs;
 	struct mlx5_flow_group *g;
 	void *match_criteria;
 	int err = 0;
@@ -1742,30 +1696,22 @@ esw_create_meta_send_to_vport_group(struct mlx5_eswitch *esw,
 	MLX5_SET(fte_match_param, match_criteria,
 		 misc_parameters_2.metadata_reg_c_1, ESW_TUN_MASK);
 
-	if (num_vfs) {
-		MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, *ix);
-		MLX5_SET(create_flow_group_in, flow_group_in,
-			 end_flow_index, *ix + num_vfs - 1);
-		*ix += num_vfs;
-
-		g = mlx5_create_flow_group(fdb, flow_group_in);
-		if (IS_ERR(g)) {
-			err = PTR_ERR(g);
-			esw_warn(esw->dev,
-				 "Failed to create send-to-vport meta flow group err(%d)\n", err);
-			goto send_vport_meta_err;
-		}
-		esw->fdb_table.offloads.send_to_vport_meta_grp = g;
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, *ix);
+	MLX5_SET(create_flow_group_in, flow_group_in,
+		 end_flow_index, *ix + esw->total_vports - 1);
+	*ix += esw->total_vports;
 
-		err = mlx5_eswitch_add_send_to_vport_meta_rules(esw);
-		if (err)
-			goto meta_rule_err;
+	g = mlx5_create_flow_group(fdb, flow_group_in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		esw_warn(esw->dev,
+			 "Failed to create send-to-vport meta flow group err(%d)\n", err);
+		goto send_vport_meta_err;
 	}
+	esw->fdb_table.offloads.send_to_vport_meta_grp = g;
 
 	return 0;
 
-meta_rule_err:
-	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_meta_grp);
 send_vport_meta_err:
 	return err;
 }
@@ -1905,7 +1851,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	 * total vports of the peer (currently is also uses esw->total_vports).
 	 */
 	table_size = MLX5_MAX_PORTS * (esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ) +
-		     MLX5_ESW_MISS_FLOWS + esw->total_vports + esw->esw_funcs.num_vfs;
+		     esw->total_vports * 2 + MLX5_ESW_MISS_FLOWS;
 
 	/* create the slow path fdb with encap set, so further table instances
 	 * can be created at run time while VFs are probed if the FW allows that.
@@ -1969,7 +1915,6 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		mlx5_destroy_flow_group(esw->fdb_table.offloads.peer_miss_grp);
 peer_miss_err:
-	mlx5_eswitch_del_send_to_vport_meta_rules(esw);
 	if (esw->fdb_table.offloads.send_to_vport_meta_grp)
 		mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_meta_grp);
 send_vport_meta_err:
@@ -1996,7 +1941,6 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	esw_debug(esw->dev, "Destroy offloads FDB Tables\n");
 	mlx5_del_flow_rules(esw->fdb_table.offloads.miss_rule_multi);
 	mlx5_del_flow_rules(esw->fdb_table.offloads.miss_rule_uni);
-	mlx5_eswitch_del_send_to_vport_meta_rules(esw);
 	mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_grp);
 	if (esw->fdb_table.offloads.send_to_vport_meta_grp)
 		mlx5_destroy_flow_group(esw->fdb_table.offloads.send_to_vport_meta_grp);
-- 
2.37.1

