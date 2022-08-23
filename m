Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F1A59D0E6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbiHWF42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbiHWF4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:56:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8FE5F220
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66417B81B79
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A70C433C1;
        Tue, 23 Aug 2022 05:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234155;
        bh=EU5vcD0f2fuAVZHJifpyVTq+PTsNwa3iARo3aY2ucwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doNEyq4UgRMYw1QStUx/JgX3oJ+muCpxIwCOhVAKioTi2ytzl/XgdZZNl93wKnhF7
         xMXo0Nu7qTJ+wYG9X2eblMtI5Mkrm0Q+ODSS7Kzjl/i2fNBay8hQ6MEVuT0kz/y3J4
         +hmuOf7tH5E9l/297UpEF8EvUvgnuI6QAeSRx2bL8b7G6HKOfM91VS93xPSCvzRrhr
         hXfqjE1mzbITwbaR1XxcS5V6bsd/oJes2fpIiYL3ovOR/XGDaElS6xEmFwNandHbRq
         zGG167efZv0wglhQITozwtfgwpt43sJP8ekb0JToll0y2XWOOd+zUN0EKDBJ7R4/lo
         jKeGj2JTyuDXg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Gavi Teitz <gavi@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 12/15] net/mlx5: E-Switch, Add default drop rule for unmatched packets
Date:   Mon, 22 Aug 2022 22:55:30 -0700
Message-Id: <20220823055533.334471-13-saeed@kernel.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

The ft_offloads table serves to steer packets, which are from the
eswitch, to the representor associated with the packets' source vport.

Previously, if a packet's source vport or metadata was not associated
with any representor, it was forwarded to the uplink representor. The
representor got packets it shouldn't have as they weren't coming from
the uplink vport.

One such effect of this breakage can be observed if the uplink
representor is attached to a bridge, where such illegal packets will
be broadcast to the remaining ports, flooding the switch with illegal
packets. In the case where IB loopback (e.g, SNAP) is enabled, all
transmitted packets would be looped back, and received by the uplink
representor, and result in an infinite feedback loop.

Therefore, block this hole by adding a default drop rule to the
ft_offloads table, so that all unmatched packets with no associated
representor are dropped.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 95 ++++++++++++++++++-
 2 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 87ce5a208cb5..d7fc665deab2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -244,6 +244,8 @@ struct mlx5_esw_offload {
 
 	struct mlx5_flow_table *ft_offloads;
 	struct mlx5_flow_group *vport_rx_group;
+	struct mlx5_flow_group *vport_rx_drop_group;
+	struct mlx5_flow_handle *vport_rx_drop_rule;
 	struct xarray vport_reps;
 	struct list_head peer_flows;
 	struct mutex peer_mutex;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ed73132129aa..c2b1b2ff6846 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -70,6 +70,8 @@
 #define MLX5_ESW_VPORT_TBL_SIZE 128
 #define MLX5_ESW_VPORT_TBL_NUM_GROUPS  4
 
+#define MLX5_ESW_FT_OFFLOADS_DROP_RULE (1)
+
 static const struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_mirror_ns = {
 	.max_fte = MLX5_ESW_VPORT_TBL_SIZE,
 	.max_num_groups = MLX5_ESW_VPORT_TBL_NUM_GROUPS,
@@ -1930,7 +1932,7 @@ static void esw_destroy_offloads_fdb_tables(struct mlx5_eswitch *esw)
 	atomic64_set(&esw->user_count, 0);
 }
 
-static int esw_get_offloads_ft_size(struct mlx5_eswitch *esw)
+static int esw_get_nr_ft_offloads_steering_src_ports(struct mlx5_eswitch *esw)
 {
 	int nvports;
 
@@ -1955,7 +1957,8 @@ static int esw_create_offloads_table(struct mlx5_eswitch *esw)
 		return -EOPNOTSUPP;
 	}
 
-	ft_attr.max_fte = esw_get_offloads_ft_size(esw);
+	ft_attr.max_fte = esw_get_nr_ft_offloads_steering_src_ports(esw) +
+			  MLX5_ESW_FT_OFFLOADS_DROP_RULE;
 	ft_attr.prio = 1;
 
 	ft_offloads = mlx5_create_flow_table(ns, &ft_attr);
@@ -1984,7 +1987,7 @@ static int esw_create_vport_rx_group(struct mlx5_eswitch *esw)
 	int nvports;
 	int err = 0;
 
-	nvports = esw_get_offloads_ft_size(esw);
+	nvports = esw_get_nr_ft_offloads_steering_src_ports(esw);
 	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
 	if (!flow_group_in)
 		return -ENOMEM;
@@ -2014,6 +2017,52 @@ static void esw_destroy_vport_rx_group(struct mlx5_eswitch *esw)
 	mlx5_destroy_flow_group(esw->offloads.vport_rx_group);
 }
 
+static int esw_create_vport_rx_drop_rule_index(struct mlx5_eswitch *esw)
+{
+	/* ft_offloads table is enlarged by MLX5_ESW_FT_OFFLOADS_DROP_RULE (1)
+	 * for the drop rule, which is placed at the end of the table.
+	 * So return the total of vport and int_port as rule index.
+	 */
+	return esw_get_nr_ft_offloads_steering_src_ports(esw);
+}
+
+static int esw_create_vport_rx_drop_group(struct mlx5_eswitch *esw)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *g;
+	u32 *flow_group_in;
+	int flow_index;
+	int err = 0;
+
+	flow_index = esw_create_vport_rx_drop_rule_index(esw);
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		return -ENOMEM;
+
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, flow_index);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, flow_index);
+
+	g = mlx5_create_flow_group(esw->offloads.ft_offloads, flow_group_in);
+
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		mlx5_core_warn(esw->dev, "Failed to create vport rx drop group err %d\n", err);
+		goto out;
+	}
+
+	esw->offloads.vport_rx_drop_group = g;
+out:
+	kvfree(flow_group_in);
+	return err;
+}
+
+static void esw_destroy_vport_rx_drop_group(struct mlx5_eswitch *esw)
+{
+	if (esw->offloads.vport_rx_drop_group)
+		mlx5_destroy_flow_group(esw->offloads.vport_rx_drop_group);
+}
+
 struct mlx5_flow_handle *
 mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
 				  struct mlx5_flow_destination *dest)
@@ -2062,6 +2111,32 @@ mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
 	return flow_rule;
 }
 
+static int esw_create_vport_rx_drop_rule(struct mlx5_eswitch *esw)
+{
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_handle *flow_rule;
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
+	flow_rule = mlx5_add_flow_rules(esw->offloads.ft_offloads, NULL,
+					&flow_act, NULL, 0);
+	if (IS_ERR(flow_rule)) {
+		esw_warn(esw->dev,
+			 "fs offloads: Failed to add vport rx drop rule err %ld\n",
+			 PTR_ERR(flow_rule));
+		return PTR_ERR(flow_rule);
+	}
+
+	esw->offloads.vport_rx_drop_rule = flow_rule;
+
+	return 0;
+}
+
+static void esw_destroy_vport_rx_drop_rule(struct mlx5_eswitch *esw)
+{
+	if (esw->offloads.vport_rx_drop_rule)
+		mlx5_del_flow_rules(esw->offloads.vport_rx_drop_rule);
+}
+
 static int mlx5_eswitch_inline_mode_get(struct mlx5_eswitch *esw, u8 *mode)
 {
 	u8 prev_mlx5_mode, mlx5_mode = MLX5_INLINE_MODE_L2;
@@ -3062,8 +3137,20 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	if (err)
 		goto create_fg_err;
 
+	err = esw_create_vport_rx_drop_group(esw);
+	if (err)
+		goto create_rx_drop_fg_err;
+
+	err = esw_create_vport_rx_drop_rule(esw);
+	if (err)
+		goto create_rx_drop_rule_err;
+
 	return 0;
 
+create_rx_drop_rule_err:
+	esw_destroy_vport_rx_drop_group(esw);
+create_rx_drop_fg_err:
+	esw_destroy_vport_rx_group(esw);
 create_fg_err:
 	esw_destroy_offloads_fdb_tables(esw);
 create_fdb_err:
@@ -3081,6 +3168,8 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 
 static void esw_offloads_steering_cleanup(struct mlx5_eswitch *esw)
 {
+	esw_destroy_vport_rx_drop_rule(esw);
+	esw_destroy_vport_rx_drop_group(esw);
 	esw_destroy_vport_rx_group(esw);
 	esw_destroy_offloads_fdb_tables(esw);
 	esw_destroy_restore_table(esw);
-- 
2.37.1

