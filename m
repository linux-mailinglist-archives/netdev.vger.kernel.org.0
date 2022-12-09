Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE85F647A9E
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiLIAPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiLIAO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0A98DFC7
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B76BAB826BB
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F456C433F0;
        Fri,  9 Dec 2022 00:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544883;
        bh=g2ZnxQcxF6VQOfjHwxkTnfB4voBomylurZC/pB3uSgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iONtfCKl5A7xpL8tVteDIiIC9Ug8xOE4mzu57I/4xEKbVAgJEpMSzdh2TH/x5aDZl
         ojfCnjX/3qlOH5Vcmd7rmXsuBqfAJOPfoyRB/iMh0ZwIA/Tig5uRqSWg3QOEtu1Wia
         EPRN8QiDPxHNoi/Wrh8V+NLGjAWcXWxbdh9ENUNZA/zdWJAiNWhVQ5sQ3AH5YeVoSR
         h2y9aSTLep5OxAZG10H4FL6PQDiFShvnExqd466EdyiRGoXVun1zDC7ZaxGMYetAzh
         3rnUza7NLQRw6SKLJqUPqYAM/bmGZILjL3GKWj+86F5OonGn9hMOI7bG2w+NbsgcN3
         bZWC2ito6cXrw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: meter, add mtu post meter tables
Date:   Thu,  8 Dec 2022 16:14:16 -0800
Message-Id: <20221209001420.142794-12-saeed@kernel.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

TC police action may configure the maximum packet size to be handled by
the policer, in addition to byte/packet rate.
MTU check is realized in hardware using the range destination, specifying
a hit ft, if packet len is in the range, or miss ft otherwise.

Instantiate mtu green/red flow tables with a single match-all rule.
Add the green/red actions to the hit/miss table accordingly.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/post_meter.c     | 184 +++++++++++++++++-
 .../mellanox/mlx5/core/en/tc/post_meter.h     |   7 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   1 +
 3 files changed, 185 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
index 7b2387eef34c..ffed3af7d01e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
@@ -17,8 +17,24 @@ struct mlx5e_post_meter_rate_table {
 	struct mlx5_flow_attr *red_attr;
 };
 
+struct mlx5e_post_meter_mtu_table {
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *fg;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_attr *attr;
+};
+
+struct mlx5e_post_meter_mtu_tables {
+	struct mlx5e_post_meter_mtu_table green_table;
+	struct mlx5e_post_meter_mtu_table red_table;
+};
+
 struct mlx5e_post_meter_priv {
-	struct mlx5e_post_meter_rate_table rate_steering_table;
+	enum mlx5e_post_meter_type type;
+	union {
+		struct mlx5e_post_meter_rate_table rate_steering_table;
+		struct mlx5e_post_meter_mtu_tables  mtu_tables;
+	};
 };
 
 struct mlx5_flow_table *
@@ -98,7 +114,6 @@ mlx5e_post_meter_add_rule(struct mlx5e_priv *priv,
 	else
 		attr->counter = act_counter;
 
-	attr->ft = post_meter->rate_steering_table.ft;
 	attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
 	attr->outer_match_level = MLX5_MATCH_NONE;
 	attr->chain = 0;
@@ -134,7 +149,7 @@ mlx5e_post_meter_rate_rules_create(struct mlx5e_priv *priv,
 
 	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
 				    MLX5_FLOW_METER_COLOR_RED, MLX5_PACKET_COLOR_MASK);
-
+	red_attr->ft = post_meter->rate_steering_table.ft;
 	rule = mlx5e_post_meter_add_rule(priv, post_meter, spec, red_attr,
 					 act_counter, drop_counter);
 	if (IS_ERR(rule)) {
@@ -147,6 +162,7 @@ mlx5e_post_meter_rate_rules_create(struct mlx5e_priv *priv,
 
 	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
 				    MLX5_FLOW_METER_COLOR_GREEN, MLX5_PACKET_COLOR_MASK);
+	green_attr->ft = post_meter->rate_steering_table.ft;
 	rule = mlx5e_post_meter_add_rule(priv, post_meter, spec, green_attr,
 					 act_counter, drop_counter);
 	if (IS_ERR(rule)) {
@@ -189,6 +205,33 @@ mlx5e_post_meter_rate_table_destroy(struct mlx5e_post_meter_priv *post_meter)
 	mlx5_destroy_flow_table(post_meter->rate_steering_table.ft);
 }
 
+static void
+mlx5e_post_meter_mtu_rules_destroy(struct mlx5e_post_meter_priv *post_meter)
+{
+	struct mlx5e_post_meter_mtu_tables *mtu_tables = &post_meter->mtu_tables;
+
+	mlx5_del_flow_rules(mtu_tables->green_table.rule);
+	mlx5_del_flow_rules(mtu_tables->red_table.rule);
+}
+
+static void
+mlx5e_post_meter_mtu_fg_destroy(struct mlx5e_post_meter_priv *post_meter)
+{
+	struct mlx5e_post_meter_mtu_tables *mtu_tables = &post_meter->mtu_tables;
+
+	mlx5_destroy_flow_group(mtu_tables->green_table.fg);
+	mlx5_destroy_flow_group(mtu_tables->red_table.fg);
+}
+
+static void
+mlx5e_post_meter_mtu_table_destroy(struct mlx5e_post_meter_priv *post_meter)
+{
+	struct mlx5e_post_meter_mtu_tables *mtu_tables = &post_meter->mtu_tables;
+
+	mlx5_destroy_flow_table(mtu_tables->green_table.ft);
+	mlx5_destroy_flow_table(mtu_tables->red_table.ft);
+}
+
 static int
 mlx5e_post_meter_rate_create(struct mlx5e_priv *priv,
 			     enum mlx5_flow_namespace_type ns_type,
@@ -202,6 +245,8 @@ mlx5e_post_meter_rate_create(struct mlx5e_priv *priv,
 	struct mlx5_flow_table *ft;
 	int err;
 
+	post_meter->type = MLX5E_POST_METER_RATE;
+
 	ft = mlx5e_post_meter_table_create(priv, ns_type);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
@@ -231,10 +276,111 @@ mlx5e_post_meter_rate_create(struct mlx5e_priv *priv,
 	return err;
 }
 
+static int
+mlx5e_post_meter_create_mtu_table(struct mlx5e_priv *priv,
+				  enum mlx5_flow_namespace_type ns_type,
+				  struct mlx5e_post_meter_mtu_table *table)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *flow_group_in;
+	int err;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		return -ENOMEM;
+
+	table->ft = mlx5e_post_meter_table_create(priv, ns_type);
+	if (IS_ERR(table->ft)) {
+		err = PTR_ERR(table->ft);
+		goto err_ft;
+	}
+
+	/* create miss group */
+	memset(flow_group_in, 0, inlen);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
+	fg = mlx5_create_flow_group(table->ft, flow_group_in);
+	if (IS_ERR(fg)) {
+		err = PTR_ERR(fg);
+		goto err_miss_grp;
+	}
+	table->fg = fg;
+
+	kvfree(flow_group_in);
+	return 0;
+
+err_miss_grp:
+	mlx5_destroy_flow_table(table->ft);
+err_ft:
+	kvfree(flow_group_in);
+	return err;
+}
+
+static int
+mlx5e_post_meter_mtu_create(struct mlx5e_priv *priv,
+			    enum mlx5_flow_namespace_type ns_type,
+			    struct mlx5e_post_act *post_act,
+			    struct mlx5_fc *act_counter,
+			    struct mlx5_fc *drop_counter,
+			    struct mlx5e_post_meter_priv *post_meter,
+			    struct mlx5_flow_attr *green_attr,
+			    struct mlx5_flow_attr *red_attr)
+{
+	struct mlx5e_post_meter_mtu_tables *mtu_tables = &post_meter->mtu_tables;
+	static struct mlx5_flow_spec zero_spec = {};
+	struct mlx5_flow_handle *rule;
+	int err;
+
+	post_meter->type = MLX5E_POST_METER_MTU;
+
+	err = mlx5e_post_meter_create_mtu_table(priv, ns_type, &mtu_tables->green_table);
+	if (err)
+		goto err_green_ft;
+
+	green_attr->ft = mtu_tables->green_table.ft;
+	rule = mlx5e_post_meter_add_rule(priv, post_meter, &zero_spec, green_attr,
+					 act_counter, drop_counter);
+	if (IS_ERR(rule)) {
+		mlx5_core_warn(priv->mdev, "Failed to create post_meter conform rule\n");
+		err = PTR_ERR(rule);
+		goto err_green_rule;
+	}
+	mtu_tables->green_table.rule = rule;
+	mtu_tables->green_table.attr = green_attr;
+
+	err = mlx5e_post_meter_create_mtu_table(priv, ns_type, &mtu_tables->red_table);
+	if (err)
+		goto err_red_ft;
+
+	red_attr->ft = mtu_tables->red_table.ft;
+	rule = mlx5e_post_meter_add_rule(priv, post_meter, &zero_spec, red_attr,
+					 act_counter, drop_counter);
+	if (IS_ERR(rule)) {
+		mlx5_core_warn(priv->mdev, "Failed to create post_meter exceed rule\n");
+		err = PTR_ERR(rule);
+		goto err_red_rule;
+	}
+	mtu_tables->red_table.rule = rule;
+	mtu_tables->red_table.attr = red_attr;
+
+	return 0;
+
+err_red_rule:
+	mlx5_destroy_flow_table(mtu_tables->red_table.ft);
+err_red_ft:
+	mlx5_del_flow_rules(mtu_tables->green_table.rule);
+err_green_rule:
+	mlx5_destroy_flow_table(mtu_tables->green_table.ft);
+err_green_ft:
+	return err;
+}
+
 struct mlx5e_post_meter_priv *
 mlx5e_post_meter_init(struct mlx5e_priv *priv,
 		      enum mlx5_flow_namespace_type ns_type,
 		      struct mlx5e_post_act *post_act,
+		      enum mlx5e_post_meter_type type,
 		      struct mlx5_fc *act_counter,
 		      struct mlx5_fc *drop_counter,
 		      struct mlx5_flow_attr *branch_true,
@@ -247,9 +393,21 @@ mlx5e_post_meter_init(struct mlx5e_priv *priv,
 	if (!post_meter)
 		return ERR_PTR(-ENOMEM);
 
-	err = mlx5e_post_meter_rate_create(priv, ns_type, post_act,
-					   act_counter, drop_counter, post_meter,
-					   branch_true, branch_false);
+	switch (type) {
+	case MLX5E_POST_METER_MTU:
+		err = mlx5e_post_meter_mtu_create(priv, ns_type, post_act,
+						  act_counter, drop_counter, post_meter,
+						  branch_true, branch_false);
+		break;
+	case MLX5E_POST_METER_RATE:
+		err = mlx5e_post_meter_rate_create(priv, ns_type, post_act,
+						   act_counter, drop_counter, post_meter,
+						   branch_true, branch_false);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
 	if (err)
 		goto err;
 
@@ -268,10 +426,22 @@ mlx5e_post_meter_rate_destroy(struct mlx5_eswitch *esw, struct mlx5e_post_meter_
 	mlx5e_post_meter_rate_table_destroy(post_meter);
 }
 
+static void
+mlx5e_post_meter_mtu_destroy(struct mlx5e_post_meter_priv *post_meter)
+{
+	mlx5e_post_meter_mtu_rules_destroy(post_meter);
+	mlx5e_post_meter_mtu_fg_destroy(post_meter);
+	mlx5e_post_meter_mtu_table_destroy(post_meter);
+}
+
 void
 mlx5e_post_meter_cleanup(struct mlx5_eswitch *esw, struct mlx5e_post_meter_priv *post_meter)
 {
-	mlx5e_post_meter_rate_destroy(esw, post_meter);
+	if (post_meter->type == MLX5E_POST_METER_RATE)
+		mlx5e_post_meter_rate_destroy(esw, post_meter);
+	else
+		mlx5e_post_meter_mtu_destroy(post_meter);
+
 	kfree(post_meter);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
index a4075d33fde2..0a3dbf5ed86d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
@@ -14,6 +14,11 @@
 
 struct mlx5e_post_meter_priv;
 
+enum mlx5e_post_meter_type {
+	MLX5E_POST_METER_RATE = 0,
+	MLX5E_POST_METER_MTU
+};
+
 struct mlx5_flow_table *
 mlx5e_post_meter_get_ft(struct mlx5e_post_meter_priv *post_meter);
 
@@ -21,10 +26,12 @@ struct mlx5e_post_meter_priv *
 mlx5e_post_meter_init(struct mlx5e_priv *priv,
 		      enum mlx5_flow_namespace_type ns_type,
 		      struct mlx5e_post_act *post_act,
+		      enum mlx5e_post_meter_type type,
 		      struct mlx5_fc *act_counter,
 		      struct mlx5_fc *drop_counter,
 		      struct mlx5_flow_attr *branch_true,
 		      struct mlx5_flow_attr *branch_false);
+
 void
 mlx5e_post_meter_cleanup(struct mlx5_eswitch *esw, struct mlx5e_post_meter_priv *post_meter);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 227fa6ef9e41..f66a2546003e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -423,6 +423,7 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 
 	ns_type = mlx5e_tc_meter_get_namespace(meter->flow_meters);
 	post_meter = mlx5e_post_meter_init(priv, ns_type, post_act,
+					   MLX5E_POST_METER_RATE,
 					   meter->act_counter, meter->drop_counter,
 					   attr->branch_true, attr->branch_false);
 	if (IS_ERR(post_meter)) {
-- 
2.38.1

