Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70594641968
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiLCWOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiLCWOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:14:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6561E3E4
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6129D60B9B
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10DAC433D7;
        Sat,  3 Dec 2022 22:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105632;
        bh=i2Gy5V7jREmDnB/f7KQrkYOk2kSzefvvO0e4jrhHz40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fb6BcDfalC1sDc1alhVQrsclljnYvUnDLpsLsLAkhFDJwjfbhg/Qu5MFvKhoJXzXH
         uBV79LaaigXj52CpW1Q54BWVRz4h9Er4eKBxI9C4DB8y/y2+IYVU2ILxmL+8NextpZ
         YKu2fsg8U3QqYxGkbNDhoB1ti7pVloySsQdwoMtOMM9u78c+xio22Wr4BJv68awT1t
         4K799Mmd0tJqAnRM3eDjLWHjjOIOakaFrlzKzWohKR5KMlm3yv/cHtLni2WLV0CXYg
         n31XBJbiwkXIaBcx6d3h1A23TbOaV6IdUaaMGyKzrMAoJlq4WmUalpEWK4Aj+s0Phk
         H0hjfJ6GwyRow==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: TC, rename post_meter actions
Date:   Sat,  3 Dec 2022 14:13:31 -0800
Message-Id: <20221203221337.29267-10-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203221337.29267-1-saeed@kernel.org>
References: <20221203221337.29267-1-saeed@kernel.org>
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

Currently post meter supports only the pipe/drop conform-exceed policy.
This assumption is reflected in several variable names.
Rename the following variables as a pre-step for using the generalized
branching action platform.

Rename fwd_green_rule/drop_red_rule to green_rule/red_rule respectively.
Repurpose red_counter/green_counter to act_counter/drop_counter to allow
police conform-exceed configurations that do not drop.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c | 24 +++++++--------
 .../ethernet/mellanox/mlx5/core/en/tc/meter.h |  4 +--
 .../mellanox/mlx5/core/en/tc/post_meter.c     | 30 +++++++++----------
 .../mellanox/mlx5/core/en/tc/post_meter.h     |  4 +--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 +--
 5 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index be74e1403328..4e5f4aa44724 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -257,16 +257,16 @@ __mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters)
 	counter = mlx5_fc_create(mdev, true);
 	if (IS_ERR(counter)) {
 		err = PTR_ERR(counter);
-		goto err_red_counter;
+		goto err_drop_counter;
 	}
-	meter->red_counter = counter;
+	meter->drop_counter = counter;
 
 	counter = mlx5_fc_create(mdev, true);
 	if (IS_ERR(counter)) {
 		err = PTR_ERR(counter);
-		goto err_green_counter;
+		goto err_act_counter;
 	}
-	meter->green_counter = counter;
+	meter->act_counter = counter;
 
 	meters_obj = list_first_entry_or_null(&flow_meters->partial_list,
 					      struct mlx5e_flow_meter_aso_obj,
@@ -313,10 +313,10 @@ __mlx5e_flow_meter_alloc(struct mlx5e_flow_meters *flow_meters)
 err_mem:
 	mlx5e_flow_meter_destroy_aso_obj(mdev, id);
 err_create:
-	mlx5_fc_destroy(mdev, meter->green_counter);
-err_green_counter:
-	mlx5_fc_destroy(mdev, meter->red_counter);
-err_red_counter:
+	mlx5_fc_destroy(mdev, meter->act_counter);
+err_act_counter:
+	mlx5_fc_destroy(mdev, meter->drop_counter);
+err_drop_counter:
 	kfree(meter);
 	return ERR_PTR(err);
 }
@@ -329,8 +329,8 @@ __mlx5e_flow_meter_free(struct mlx5e_flow_meter_handle *meter)
 	struct mlx5e_flow_meter_aso_obj *meters_obj;
 	int n, pos;
 
-	mlx5_fc_destroy(mdev, meter->green_counter);
-	mlx5_fc_destroy(mdev, meter->red_counter);
+	mlx5_fc_destroy(mdev, meter->act_counter);
+	mlx5_fc_destroy(mdev, meter->drop_counter);
 
 	meters_obj = meter->meters_obj;
 	pos = (meter->obj_id - meters_obj->base_id) * 2 + meter->idx;
@@ -575,8 +575,8 @@ mlx5e_tc_meter_get_stats(struct mlx5e_flow_meter_handle *meter,
 	u64 bytes1, packets1, lastuse1;
 	u64 bytes2, packets2, lastuse2;
 
-	mlx5_fc_query_cached(meter->green_counter, &bytes1, &packets1, &lastuse1);
-	mlx5_fc_query_cached(meter->red_counter, &bytes2, &packets2, &lastuse2);
+	mlx5_fc_query_cached(meter->act_counter, &bytes1, &packets1, &lastuse1);
+	mlx5_fc_query_cached(meter->drop_counter, &bytes2, &packets2, &lastuse2);
 
 	*bytes = bytes1 + bytes2;
 	*packets = packets1 + packets2;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
index 6de6e8a16327..f16abf33bb51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
@@ -32,8 +32,8 @@ struct mlx5e_flow_meter_handle {
 	struct hlist_node hlist;
 	struct mlx5e_flow_meter_params params;
 
-	struct mlx5_fc *green_counter;
-	struct mlx5_fc *red_counter;
+	struct mlx5_fc *act_counter;
+	struct mlx5_fc *drop_counter;
 };
 
 struct mlx5e_meter_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
index 8b77e822810e..60209205f683 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
@@ -11,8 +11,8 @@
 struct mlx5e_post_meter_priv {
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *fg;
-	struct mlx5_flow_handle *fwd_green_rule;
-	struct mlx5_flow_handle *drop_red_rule;
+	struct mlx5_flow_handle *green_rule;
+	struct mlx5_flow_handle *red_rule;
 };
 
 struct mlx5_flow_table *
@@ -85,8 +85,8 @@ static int
 mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 			      struct mlx5e_post_meter_priv *post_meter,
 			      struct mlx5e_post_act *post_act,
-			      struct mlx5_fc *green_counter,
-			      struct mlx5_fc *red_counter)
+			      struct mlx5_fc *act_counter,
+			      struct mlx5_fc *drop_counter)
 {
 	struct mlx5_flow_destination dest[2] = {};
 	struct mlx5_flow_act flow_act = {};
@@ -104,7 +104,7 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 			  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 	flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-	dest[0].counter_id = mlx5_fc_id(red_counter);
+	dest[0].counter_id = mlx5_fc_id(drop_counter);
 
 	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, dest, 1);
 	if (IS_ERR(rule)) {
@@ -112,7 +112,7 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 		err = PTR_ERR(rule);
 		goto err_red;
 	}
-	post_meter->drop_red_rule = rule;
+	post_meter->red_rule = rule;
 
 	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
 				    MLX5_FLOW_METER_COLOR_GREEN, MLX5_PACKET_COLOR_MASK);
@@ -121,7 +121,7 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[0].ft = mlx5e_tc_post_act_get_ft(post_act);
 	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-	dest[1].counter_id = mlx5_fc_id(green_counter);
+	dest[1].counter_id = mlx5_fc_id(act_counter);
 
 	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, dest, 2);
 	if (IS_ERR(rule)) {
@@ -129,13 +129,13 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 		err = PTR_ERR(rule);
 		goto err_green;
 	}
-	post_meter->fwd_green_rule = rule;
+	post_meter->green_rule = rule;
 
 	kvfree(spec);
 	return 0;
 
 err_green:
-	mlx5_del_flow_rules(post_meter->drop_red_rule);
+	mlx5_del_flow_rules(post_meter->red_rule);
 err_red:
 	kvfree(spec);
 	return err;
@@ -144,8 +144,8 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 static void
 mlx5e_post_meter_rules_destroy(struct mlx5e_post_meter_priv *post_meter)
 {
-	mlx5_del_flow_rules(post_meter->drop_red_rule);
-	mlx5_del_flow_rules(post_meter->fwd_green_rule);
+	mlx5_del_flow_rules(post_meter->red_rule);
+	mlx5_del_flow_rules(post_meter->green_rule);
 }
 
 static void
@@ -164,8 +164,8 @@ struct mlx5e_post_meter_priv *
 mlx5e_post_meter_init(struct mlx5e_priv *priv,
 		      enum mlx5_flow_namespace_type ns_type,
 		      struct mlx5e_post_act *post_act,
-		      struct mlx5_fc *green_counter,
-		      struct mlx5_fc *red_counter)
+		      struct mlx5_fc *act_counter,
+		      struct mlx5_fc *drop_counter)
 {
 	struct mlx5e_post_meter_priv *post_meter;
 	int err;
@@ -182,8 +182,8 @@ mlx5e_post_meter_init(struct mlx5e_priv *priv,
 	if (err)
 		goto err_fg;
 
-	err = mlx5e_post_meter_rules_create(priv, post_meter, post_act, green_counter,
-					    red_counter);
+	err = mlx5e_post_meter_rules_create(priv, post_meter, post_act,
+					    act_counter, drop_counter);
 	if (err)
 		goto err_rules;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
index 34d0e4b9fc7a..37c74e7bfb6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
@@ -21,8 +21,8 @@ struct mlx5e_post_meter_priv *
 mlx5e_post_meter_init(struct mlx5e_priv *priv,
 		      enum mlx5_flow_namespace_type ns_type,
 		      struct mlx5e_post_act *post_act,
-		      struct mlx5_fc *green_counter,
-		      struct mlx5_fc *red_counter);
+		      struct mlx5_fc *act_counter,
+		      struct mlx5_fc *drop_counter);
 void
 mlx5e_post_meter_cleanup(struct mlx5e_post_meter_priv *post_meter);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d52f8601fef4..ce449fa4f36e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -422,8 +422,8 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 	}
 
 	ns_type = mlx5e_tc_meter_get_namespace(meter->flow_meters);
-	post_meter = mlx5e_post_meter_init(priv, ns_type, post_act, meter->green_counter,
-					   meter->red_counter);
+	post_meter = mlx5e_post_meter_init(priv, ns_type, post_act, meter->act_counter,
+					   meter->drop_counter);
 	if (IS_ERR(post_meter)) {
 		mlx5_core_err(priv->mdev, "Failed to init post meter\n");
 		goto err_meter_init;
-- 
2.38.1

