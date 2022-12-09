Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12E6647A9B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLIAPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLIAOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F64E8D182
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61AD0B826B7
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C95C433D2;
        Fri,  9 Dec 2022 00:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544882;
        bh=1T229Y+DR8dJDv2lophy74dJ2ZmrdqIzt4JMA1lSAo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DodsrzRGQpUaQi1qX6wWT1BkW1VeOdDisDiUp1Y1S2mRzS6YDEIAoRqRQPjg5GCtN
         pZ0n0Mt8NlcQVuF4iKgVM7NSMI7dshkr5cIki/ObRUcOHrI54uZovG5JDYg6/qVlCd
         LphCrGb8OdPkNX4mbiHfbOurUr4iXxFkCJzm6Iwu+RmmDPhWJN2RIrmOjAIjBa+ph8
         TaAhfemFgQk6O+omkQHRrLW/pba5H2wPkcogU0w/NCoS+kz1wpx5LqMM6r+cE/2IiM
         JmAq2ELRvkbZCzu4mb25LUFLntREZY12AWCqpNtAsMU76sV8PNA3MBikhZsz/eu2nN
         JdQME+LxvsVlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: meter, refactor to allow multiple post meter tables
Date:   Thu,  8 Dec 2022 16:14:15 -0800
Message-Id: <20221209001420.142794-11-saeed@kernel.org>
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
Currently the post meter table steers the packet according to the meter
aso output.

Refactor the code to allow both metering and range post actions as a
pre-step for adding police mtu offload support.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/post_meter.c     | 154 +++++++++++-------
 1 file changed, 96 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
index c38211097746..7b2387eef34c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
@@ -8,7 +8,7 @@
 #define MLX5_PACKET_COLOR_BITS MLX5_REG_MAPPING_MBITS(PACKET_COLOR_TO_REG)
 #define MLX5_PACKET_COLOR_MASK MLX5_REG_MAPPING_MASK(PACKET_COLOR_TO_REG)
 
-struct mlx5e_post_meter_priv {
+struct mlx5e_post_meter_rate_table {
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *fg;
 	struct mlx5_flow_handle *green_rule;
@@ -17,16 +17,19 @@ struct mlx5e_post_meter_priv {
 	struct mlx5_flow_attr *red_attr;
 };
 
+struct mlx5e_post_meter_priv {
+	struct mlx5e_post_meter_rate_table rate_steering_table;
+};
+
 struct mlx5_flow_table *
 mlx5e_post_meter_get_ft(struct mlx5e_post_meter_priv *post_meter)
 {
-	return post_meter->ft;
+	return post_meter->rate_steering_table.ft;
 }
 
-static int
+static struct mlx5_flow_table *
 mlx5e_post_meter_table_create(struct mlx5e_priv *priv,
-			      enum mlx5_flow_namespace_type ns_type,
-			      struct mlx5e_post_meter_priv *post_meter)
+			      enum mlx5_flow_namespace_type ns_type)
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_namespace *root_ns;
@@ -34,7 +37,7 @@ mlx5e_post_meter_table_create(struct mlx5e_priv *priv,
 	root_ns = mlx5_get_flow_namespace(priv->mdev, ns_type);
 	if (!root_ns) {
 		mlx5_core_warn(priv->mdev, "Failed to get namespace for flow meter\n");
-		return -EOPNOTSUPP;
+		return ERR_PTR(-EOPNOTSUPP);
 	}
 
 	ft_attr.flags = MLX5_FLOW_TABLE_UNMANAGED;
@@ -42,19 +45,14 @@ mlx5e_post_meter_table_create(struct mlx5e_priv *priv,
 	ft_attr.max_fte = 2;
 	ft_attr.level = 1;
 
-	post_meter->ft = mlx5_create_flow_table(root_ns, &ft_attr);
-	if (IS_ERR(post_meter->ft)) {
-		mlx5_core_warn(priv->mdev, "Failed to create post_meter table\n");
-		return PTR_ERR(post_meter->ft);
-	}
-
-	return 0;
+	return mlx5_create_flow_table(root_ns, &ft_attr);
 }
 
 static int
-mlx5e_post_meter_fg_create(struct mlx5e_priv *priv,
-			   struct mlx5e_post_meter_priv *post_meter)
+mlx5e_post_meter_rate_fg_create(struct mlx5e_priv *priv,
+				struct mlx5e_post_meter_priv *post_meter)
 {
+	struct mlx5e_post_meter_rate_table *table = &post_meter->rate_steering_table;
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	void *misc2, *match_criteria;
 	u32 *flow_group_in;
@@ -73,10 +71,10 @@ mlx5e_post_meter_fg_create(struct mlx5e_priv *priv,
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
 
-	post_meter->fg = mlx5_create_flow_group(post_meter->ft, flow_group_in);
-	if (IS_ERR(post_meter->fg)) {
+	table->fg = mlx5_create_flow_group(table->ft, flow_group_in);
+	if (IS_ERR(table->fg)) {
 		mlx5_core_warn(priv->mdev, "Failed to create post_meter flow group\n");
-		err = PTR_ERR(post_meter->fg);
+		err = PTR_ERR(table->fg);
 	}
 
 	kvfree(flow_group_in);
@@ -100,7 +98,7 @@ mlx5e_post_meter_add_rule(struct mlx5e_priv *priv,
 	else
 		attr->counter = act_counter;
 
-	attr->ft = post_meter->ft;
+	attr->ft = post_meter->rate_steering_table.ft;
 	attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
 	attr->outer_match_level = MLX5_MATCH_NONE;
 	attr->chain = 0;
@@ -117,14 +115,15 @@ mlx5e_post_meter_add_rule(struct mlx5e_priv *priv,
 }
 
 static int
-mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
-			      struct mlx5e_post_meter_priv *post_meter,
-			      struct mlx5e_post_act *post_act,
-			      struct mlx5_fc *act_counter,
-			      struct mlx5_fc *drop_counter,
-			      struct mlx5_flow_attr *green_attr,
-			      struct mlx5_flow_attr *red_attr)
+mlx5e_post_meter_rate_rules_create(struct mlx5e_priv *priv,
+				   struct mlx5e_post_meter_priv *post_meter,
+				   struct mlx5e_post_act *post_act,
+				   struct mlx5_fc *act_counter,
+				   struct mlx5_fc *drop_counter,
+				   struct mlx5_flow_attr *green_attr,
+				   struct mlx5_flow_attr *red_attr)
 {
+	struct mlx5e_post_meter_rate_table *table = &post_meter->rate_steering_table;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	int err;
@@ -143,8 +142,8 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 		err = PTR_ERR(rule);
 		goto err_red;
 	}
-	post_meter->red_rule = rule;
-	post_meter->red_attr = red_attr;
+	table->red_rule = rule;
+	table->red_attr = red_attr;
 
 	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
 				    MLX5_FLOW_METER_COLOR_GREEN, MLX5_PACKET_COLOR_MASK);
@@ -155,37 +154,81 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 		err = PTR_ERR(rule);
 		goto err_green;
 	}
-	post_meter->green_rule = rule;
-	post_meter->green_attr = green_attr;
+	table->green_rule = rule;
+	table->green_attr = green_attr;
 
 	kvfree(spec);
 	return 0;
 
 err_green:
-	mlx5_del_flow_rules(post_meter->red_rule);
+	mlx5_del_flow_rules(table->red_rule);
 err_red:
 	kvfree(spec);
 	return err;
 }
 
 static void
-mlx5e_post_meter_rules_destroy(struct mlx5_eswitch *esw,
-			       struct mlx5e_post_meter_priv *post_meter)
+mlx5e_post_meter_rate_rules_destroy(struct mlx5_eswitch *esw,
+				    struct mlx5e_post_meter_priv *post_meter)
 {
-	mlx5_eswitch_del_offloaded_rule(esw, post_meter->red_rule, post_meter->red_attr);
-	mlx5_eswitch_del_offloaded_rule(esw, post_meter->green_rule, post_meter->green_attr);
+	struct mlx5e_post_meter_rate_table *rate_table = &post_meter->rate_steering_table;
+
+	mlx5_eswitch_del_offloaded_rule(esw, rate_table->red_rule, rate_table->red_attr);
+	mlx5_eswitch_del_offloaded_rule(esw, rate_table->green_rule, rate_table->green_attr);
 }
 
 static void
-mlx5e_post_meter_fg_destroy(struct mlx5e_post_meter_priv *post_meter)
+mlx5e_post_meter_rate_fg_destroy(struct mlx5e_post_meter_priv *post_meter)
 {
-	mlx5_destroy_flow_group(post_meter->fg);
+	mlx5_destroy_flow_group(post_meter->rate_steering_table.fg);
 }
 
 static void
-mlx5e_post_meter_table_destroy(struct mlx5e_post_meter_priv *post_meter)
+mlx5e_post_meter_rate_table_destroy(struct mlx5e_post_meter_priv *post_meter)
+{
+	mlx5_destroy_flow_table(post_meter->rate_steering_table.ft);
+}
+
+static int
+mlx5e_post_meter_rate_create(struct mlx5e_priv *priv,
+			     enum mlx5_flow_namespace_type ns_type,
+			     struct mlx5e_post_act *post_act,
+			     struct mlx5_fc *act_counter,
+			     struct mlx5_fc *drop_counter,
+			     struct mlx5e_post_meter_priv *post_meter,
+			     struct mlx5_flow_attr *green_attr,
+			     struct mlx5_flow_attr *red_attr)
 {
-	mlx5_destroy_flow_table(post_meter->ft);
+	struct mlx5_flow_table *ft;
+	int err;
+
+	ft = mlx5e_post_meter_table_create(priv, ns_type);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		mlx5_core_warn(priv->mdev, "Failed to create post_meter table\n");
+		goto err_ft;
+	}
+
+	post_meter->rate_steering_table.ft = ft;
+
+	err = mlx5e_post_meter_rate_fg_create(priv, post_meter);
+	if (err)
+		goto err_fg;
+
+	err = mlx5e_post_meter_rate_rules_create(priv, post_meter, post_act,
+						 act_counter, drop_counter,
+						 green_attr, red_attr);
+	if (err)
+		goto err_rules;
+
+	return 0;
+
+err_rules:
+	mlx5e_post_meter_rate_fg_destroy(post_meter);
+err_fg:
+	mlx5e_post_meter_rate_table_destroy(post_meter);
+err_ft:
+	return err;
 }
 
 struct mlx5e_post_meter_priv *
@@ -204,36 +247,31 @@ mlx5e_post_meter_init(struct mlx5e_priv *priv,
 	if (!post_meter)
 		return ERR_PTR(-ENOMEM);
 
-	err = mlx5e_post_meter_table_create(priv, ns_type, post_meter);
-	if (err)
-		goto err_ft;
-
-	err = mlx5e_post_meter_fg_create(priv, post_meter);
-	if (err)
-		goto err_fg;
-
-	err = mlx5e_post_meter_rules_create(priv, post_meter, post_act, act_counter,
-					    drop_counter, branch_true, branch_false);
+	err = mlx5e_post_meter_rate_create(priv, ns_type, post_act,
+					   act_counter, drop_counter, post_meter,
+					   branch_true, branch_false);
 	if (err)
-		goto err_rules;
+		goto err;
 
 	return post_meter;
 
-err_rules:
-	mlx5e_post_meter_fg_destroy(post_meter);
-err_fg:
-	mlx5e_post_meter_table_destroy(post_meter);
-err_ft:
+err:
 	kfree(post_meter);
 	return ERR_PTR(err);
 }
 
+static void
+mlx5e_post_meter_rate_destroy(struct mlx5_eswitch *esw, struct mlx5e_post_meter_priv *post_meter)
+{
+	mlx5e_post_meter_rate_rules_destroy(esw, post_meter);
+	mlx5e_post_meter_rate_fg_destroy(post_meter);
+	mlx5e_post_meter_rate_table_destroy(post_meter);
+}
+
 void
 mlx5e_post_meter_cleanup(struct mlx5_eswitch *esw, struct mlx5e_post_meter_priv *post_meter)
 {
-	mlx5e_post_meter_rules_destroy(esw, post_meter);
-	mlx5e_post_meter_fg_destroy(post_meter);
-	mlx5e_post_meter_table_destroy(post_meter);
+	mlx5e_post_meter_rate_destroy(esw, post_meter);
 	kfree(post_meter);
 }
 
-- 
2.38.1

