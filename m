Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E5263CE9E
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbiK3FN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbiK3FMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244BB769D2
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F344619FF
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03B0C433C1;
        Wed, 30 Nov 2022 05:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785134;
        bh=c4IJ5iwadKRp4j4Zes6V726+OygK0jM3KTUGLbQ6U4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Miyx/oj0OCYvPtFLeRqZRkI1+gW506f7XBA8/1SUdIj4WDqvNbwRN6YMqfWXmPe6E
         NpV3CDJS+TCmq+LSw8NM83VmJnG9PAMDvdHOnsUca84OUjQvv7uj8CBwB/DwdF2bgw
         pLQTzAXAkV030jShwXarnmvS2et9PHSWqm6pheI34DMw3+AbhoATuwpxgUohB+ic84
         98dt7ATm2APYswDz7bbSV+rHGVsdVlO+X5JiHRk+O5eNw0lk00Sz6+SPf9z2/a6TY+
         3HdNrrPGtIDmDHzg84+3GZ7KXWkQx4KUVP0Sh2m3/AThRnTkIArUhQQW9if7h0uG7b
         FQOGxwQHj0ORQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: TC, Add offload support for trap with additional actions
Date:   Tue, 29 Nov 2022 21:11:51 -0800
Message-Id: <20221130051152.479480-15-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

TC trap action offload is currently supported only when trap is the sole action
in the flow.

This patch remove this limitation by changing trap action offload to not use
MLX5_ATTR_FLAG_SLOW_PATH flag and instead set the flow destination table
explicitly to be the slow table. This will allow offload of the additional
actions.

TC flow example:
tc filter add dev $REP2 protocol ip prio 2 root \
	flower skip_sw dst_mac $mac0 \
	action mirred egress redirect dev $REP3 \
	action pedit ex munge eth dst set $mac2  pipe \
	action trap

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/trap.c       | 10 ++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  5 +++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 22 +++++++++----------
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
index 53b270f652b9..915ce201aeb2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
@@ -3,6 +3,7 @@
 
 #include "act.h"
 #include "en/tc_priv.h"
+#include "eswitch.h"
 
 static bool
 tc_act_can_offload_trap(struct mlx5e_tc_act_parse_state *parse_state,
@@ -10,13 +11,6 @@ tc_act_can_offload_trap(struct mlx5e_tc_act_parse_state *parse_state,
 			int act_index,
 			struct mlx5_flow_attr *attr)
 {
-	struct netlink_ext_ack *extack = parse_state->extack;
-
-	if (parse_state->flow_action->num_entries != 1) {
-		NL_SET_ERR_MSG_MOD(extack, "action trap is supported as a sole action only");
-		return false;
-	}
-
 	return true;
 }
 
@@ -27,7 +21,7 @@ tc_act_parse_trap(struct mlx5e_tc_act_parse_state *parse_state,
 		  struct mlx5_flow_attr *attr)
 {
 	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
+	attr->dest_ft = mlx5_eswitch_get_slow_fdb(priv->mdev->priv.eswitch);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 3029bc1c0dd0..42d9df417e20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -744,6 +744,11 @@ static inline int mlx5_eswitch_num_vfs(struct mlx5_eswitch *esw)
 	return 0;
 }
 
+static inline struct mlx5_flow_table *
+mlx5_eswitch_get_slow_fdb(struct mlx5_eswitch *esw)
+{
+	return esw->fdb_table.offloads.slow_fdb;
+}
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4b358b87fead..9b6fbb19c22a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -248,7 +248,7 @@ esw_setup_slow_path_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_ac
 	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level))
 		flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest[i].ft = esw->fdb_table.offloads.slow_fdb;
+	dest[i].ft = mlx5_eswitch_get_slow_fdb(esw);
 }
 
 static int
@@ -1049,7 +1049,7 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 	if (rep->vport == MLX5_VPORT_UPLINK)
 		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
 
-	flow_rule = mlx5_add_flow_rules(on_esw->fdb_table.offloads.slow_fdb,
+	flow_rule = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(on_esw),
 					spec, &flow_act, &dest, 1);
 	if (IS_ERR(flow_rule))
 		esw_warn(on_esw->dev, "FDB: Failed to add send to vport rule err %ld\n",
@@ -1098,7 +1098,7 @@ mlx5_eswitch_add_send_to_vport_meta_rule(struct mlx5_eswitch *esw, u16 vport_num
 		 mlx5_eswitch_get_vport_metadata_for_match(esw, vport_num));
 	dest.vport.num = vport_num;
 
-	flow_rule = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+	flow_rule = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
 					spec, &flow_act, &dest, 1);
 	if (IS_ERR(flow_rule))
 		esw_warn(esw->dev, "FDB: Failed to add send to vport meta rule vport %d, err %ld\n",
@@ -1251,7 +1251,7 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 		esw_set_peer_miss_rule_source_port(esw, peer_dev->priv.eswitch,
 						   spec, MLX5_VPORT_PF);
 
-		flow = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+		flow = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
 					   spec, &flow_act, &dest, 1);
 		if (IS_ERR(flow)) {
 			err = PTR_ERR(flow);
@@ -1263,7 +1263,7 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
 		MLX5_SET(fte_match_set_misc, misc, source_port, MLX5_VPORT_ECPF);
-		flow = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+		flow = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
 					   spec, &flow_act, &dest, 1);
 		if (IS_ERR(flow)) {
 			err = PTR_ERR(flow);
@@ -1277,7 +1277,7 @@ static int esw_add_fdb_peer_miss_rules(struct mlx5_eswitch *esw,
 						   peer_dev->priv.eswitch,
 						   spec, vport->vport);
 
-		flow = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+		flow = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
 					   spec, &flow_act, &dest, 1);
 		if (IS_ERR(flow)) {
 			err = PTR_ERR(flow);
@@ -1366,7 +1366,7 @@ static int esw_add_fdb_miss_rule(struct mlx5_eswitch *esw)
 	dest.vport.num = esw->manager_vport;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
-	flow_rule = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+	flow_rule = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
 					spec, &flow_act, &dest, 1);
 	if (IS_ERR(flow_rule)) {
 		err = PTR_ERR(flow_rule);
@@ -1381,7 +1381,7 @@ static int esw_add_fdb_miss_rule(struct mlx5_eswitch *esw)
 	dmac_v = MLX5_ADDR_OF(fte_match_param, headers_v,
 			      outer_headers.dmac_47_16);
 	dmac_v[0] = 0x01;
-	flow_rule = mlx5_add_flow_rules(esw->fdb_table.offloads.slow_fdb,
+	flow_rule = mlx5_add_flow_rules(mlx5_eswitch_get_slow_fdb(esw),
 					spec, &flow_act, &dest, 1);
 	if (IS_ERR(flow_rule)) {
 		err = PTR_ERR(flow_rule);
@@ -1930,7 +1930,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 fdb_chains_err:
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.tc_miss_table);
 tc_miss_table_err:
-	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
+	mlx5_destroy_flow_table(mlx5_eswitch_get_slow_fdb(esw));
 slow_fdb_err:
 	/* Holds true only as long as DMFS is the default */
 	mlx5_flow_namespace_set_mode(root_ns, MLX5_FLOW_STEERING_MODE_DMFS);
@@ -1941,7 +1941,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 
 static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 {
-	if (!esw->fdb_table.offloads.slow_fdb)
+	if (!mlx5_eswitch_get_slow_fdb(esw))
 		return;
 
 	esw_debug(esw->dev, "Destroy offloads FDB Tables\n");
@@ -1957,7 +1957,7 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	esw_chains_destroy(esw, esw_chains(esw));
 
 	mlx5_destroy_flow_table(esw->fdb_table.offloads.tc_miss_table);
-	mlx5_destroy_flow_table(esw->fdb_table.offloads.slow_fdb);
+	mlx5_destroy_flow_table(mlx5_eswitch_get_slow_fdb(esw));
 	/* Holds true only as long as DMFS is the default */
 	mlx5_flow_namespace_set_mode(esw->fdb_table.offloads.ns,
 				     MLX5_FLOW_STEERING_MODE_DMFS);
-- 
2.38.1

