Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4B2584761
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiG1U56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbiG1U5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D6D7820D
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7411AB82597
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243EDC433D6;
        Thu, 28 Jul 2022 20:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041854;
        bh=0qhnRbqKt+OYv9mYXC23AQVmlFqYp29N8lEdELt3nUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3E6a406TC/fW5DSWVTrHPFWE2Sj3STprLfQvvksk/0of7A58hms2pHdRLzMIcZVA
         ZDLKcMCpsjeSZAf/Wi+vkl2y4foxFhmlP1FSB2uS8EBKrsI8TdOO5nS2MrDqu23vKt
         PENzAXCmTTadVSw36iIoXwyPJcJfbIMwKkzLodODWOyjA1lAxWYglmUuTWYTi+zs8T
         PivGM6TfeWMyQVbY4aKWucBiKtWkYVo3JIH0hr7lRWezoQhiCZece8yZh7tEgS9uO4
         Zq8hbBnQ7+h4i+yp5nw2kkVxJp2cqK0PPC5Qa1+g/jZkyfbtzLgDkuhUKvF/iSPGBv
         4/VwbjjqrYjTw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: Add red and green counters for metering
Date:   Thu, 28 Jul 2022 13:57:17 -0700
Message-Id: <20220728205728.143074-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728205728.143074-1-saeed@kernel.org>
References: <20220728205728.143074-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Add red and green counters per meter instance.
TC police action is implemented as a meter instance.
The meter counters represent the police action
notexceed/exceed counters.
TC rules using the same meter instance will use
the same counters.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c | 22 +++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/meter.h |  3 ++
 .../mellanox/mlx5/core/en/tc/post_meter.c     | 33 ++++++++++++-------
 .../mellanox/mlx5/core/en/tc/post_meter.h     |  4 ++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  3 +-
 5 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index ae621d04abe9..6409e4fa16a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -240,6 +240,7 @@ __mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters)
 	struct mlx5_core_dev *mdev = flow_meters->mdev;
 	struct mlx5e_flow_meter_aso_obj *meters_obj;
 	struct mlx5e_flow_meter_handle *meter;
+	struct mlx5_fc *counter;
 	int err, pos, total;
 	u32 id;
 
@@ -247,6 +248,20 @@ __mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters)
 	if (!meter)
 		return ERR_PTR(-ENOMEM);
 
+	counter = mlx5_fc_create(mdev, true);
+	if (IS_ERR(counter)) {
+		err = PTR_ERR(counter);
+		goto err_red_counter;
+	}
+	meter->red_counter = counter;
+
+	counter = mlx5_fc_create(mdev, true);
+	if (IS_ERR(counter)) {
+		err = PTR_ERR(counter);
+		goto err_green_counter;
+	}
+	meter->green_counter = counter;
+
 	meters_obj = list_first_entry_or_null(&flow_meters->partial_list,
 					      struct mlx5e_flow_meter_aso_obj,
 					      entry);
@@ -292,6 +307,10 @@ __mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters)
 err_mem:
 	mlx5e_flow_meter_destroy_aso_obj(mdev, id);
 err_create:
+	mlx5_fc_destroy(mdev, meter->green_counter);
+err_green_counter:
+	mlx5_fc_destroy(mdev, meter->red_counter);
+err_red_counter:
 	kfree(meter);
 	return ERR_PTR(err);
 }
@@ -304,6 +323,9 @@ __mlx5e_flow_meter_free(struct mlx5e_flow_meter_handle *meter)
 	struct mlx5e_flow_meter_aso_obj *meters_obj;
 	int n, pos;
 
+	mlx5_fc_destroy(mdev, meter->green_counter);
+	mlx5_fc_destroy(mdev, meter->red_counter);
+
 	meters_obj = meter->meters_obj;
 	pos = (meter->obj_id - meters_obj->base_id) * 2 + meter->idx;
 	bitmap_clear(meters_obj->meters_map, pos, 1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
index bf47ff660445..a73ebf94ad17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
@@ -31,6 +31,9 @@ struct mlx5e_flow_meter_handle {
 	int refcnt;
 	struct hlist_node hlist;
 	struct mlx5e_flow_meter_params params;
+
+	struct mlx5_fc *green_counter;
+	struct mlx5_fc *red_counter;
 };
 
 struct mlx5e_meter_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
index efa20356764e..8b77e822810e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
@@ -84,9 +84,11 @@ mlx5e_post_meter_fg_create(struct mlx5e_priv *priv,
 static int
 mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 			      struct mlx5e_post_meter_priv *post_meter,
-			      struct mlx5e_post_act *post_act)
+			      struct mlx5e_post_act *post_act,
+			      struct mlx5_fc *green_counter,
+			      struct mlx5_fc *red_counter)
 {
-	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_destination dest[2] = {};
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
@@ -98,10 +100,13 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 
 	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
 				    MLX5_FLOW_METER_COLOR_RED, MLX5_PACKET_COLOR_MASK);
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP |
+			  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 	flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dest[0].counter_id = mlx5_fc_id(red_counter);
 
-	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, NULL, 0);
+	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, dest, 1);
 	if (IS_ERR(rule)) {
 		mlx5_core_warn(priv->mdev, "Failed to create post_meter flow drop rule\n");
 		err = PTR_ERR(rule);
@@ -111,11 +116,14 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 
 	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
 				    MLX5_FLOW_METER_COLOR_GREEN, MLX5_PACKET_COLOR_MASK);
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = mlx5e_tc_post_act_get_ft(post_act);
-
-	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, &dest, 1);
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			  MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[0].ft = mlx5e_tc_post_act_get_ft(post_act);
+	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dest[1].counter_id = mlx5_fc_id(green_counter);
+
+	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, dest, 2);
 	if (IS_ERR(rule)) {
 		mlx5_core_warn(priv->mdev, "Failed to create post_meter flow fwd rule\n");
 		err = PTR_ERR(rule);
@@ -155,7 +163,9 @@ mlx5e_post_meter_table_destroy(struct mlx5e_post_meter_priv *post_meter)
 struct mlx5e_post_meter_priv *
 mlx5e_post_meter_init(struct mlx5e_priv *priv,
 		      enum mlx5_flow_namespace_type ns_type,
-		      struct mlx5e_post_act *post_act)
+		      struct mlx5e_post_act *post_act,
+		      struct mlx5_fc *green_counter,
+		      struct mlx5_fc *red_counter)
 {
 	struct mlx5e_post_meter_priv *post_meter;
 	int err;
@@ -172,7 +182,8 @@ mlx5e_post_meter_init(struct mlx5e_priv *priv,
 	if (err)
 		goto err_fg;
 
-	err = mlx5e_post_meter_rules_create(priv, post_meter, post_act);
+	err = mlx5e_post_meter_rules_create(priv, post_meter, post_act, green_counter,
+					    red_counter);
 	if (err)
 		goto err_rules;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
index c74f3cbd810d..34d0e4b9fc7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
@@ -20,7 +20,9 @@ mlx5e_post_meter_get_ft(struct mlx5e_post_meter_priv *post_meter);
 struct mlx5e_post_meter_priv *
 mlx5e_post_meter_init(struct mlx5e_priv *priv,
 		      enum mlx5_flow_namespace_type ns_type,
-		      struct mlx5e_post_act *post_act);
+		      struct mlx5e_post_act *post_act,
+		      struct mlx5_fc *green_counter,
+		      struct mlx5_fc *red_counter);
 void
 mlx5e_post_meter_cleanup(struct mlx5e_post_meter_priv *post_meter);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 63c1791d4fac..a38e1505bace 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -368,7 +368,8 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 	}
 
 	ns_type = mlx5e_tc_meter_get_namespace(meter->flow_meters);
-	post_meter = mlx5e_post_meter_init(priv, ns_type, post_act);
+	post_meter = mlx5e_post_meter_init(priv, ns_type, post_act, meter->green_counter,
+					   meter->red_counter);
 	if (IS_ERR(post_meter)) {
 		mlx5_core_err(priv->mdev, "Failed to init post meter\n");
 		goto err_meter_init;
-- 
2.37.1

