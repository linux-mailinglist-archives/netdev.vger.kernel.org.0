Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5BC64196B
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLCWOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiLCWOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:14:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6741E3E0
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C068B807E6
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FF2C433D7;
        Sat,  3 Dec 2022 22:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105634;
        bh=MdIvs+fAePYOiI4XzOzNCM9oE0qtbuVOPSjllSf5/88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IslO50oItaqa/nRUG7jGLxYAsvtO6Qlrx9csmVBc865BNF2Hrvvl9fmC4fXjFPThZ
         bfaLdfwK+1Gneb0hs2R/aBDDUaXfoJ+uRb/Pli26iVpBxUj/3vv4wFyekPLDkePoew
         9zzi/QFffW848mRkTHh04cuqHuXyeLaAm5FArmcKWq6jbDq3f1BHSWilewsh2ewv8j
         QUjUgk10WRgqFjqblKKQYMqc9KizKqquvr2YkF9/kAOGtYRQUiA2MpwpDIbog1LATB
         adbOl83ytJ1mOSMnXI5X5ptph52kabbKKD04YHn8jm+kj2foEQXFm1upk6exxjCLxA
         hD8dUvXu59mkQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: TC, init post meter rules with branching attributes
Date:   Sat,  3 Dec 2022 14:13:32 -0800
Message-Id: <20221203221337.29267-11-saeed@kernel.org>
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

Instantiate the post meter actions with the platform initialized branching
action attributes.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/post_meter.c     | 84 +++++++++++++------
 .../mellanox/mlx5/core/en/tc/post_meter.h     |  6 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 11 +--
 3 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
index 60209205f683..c38211097746 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
@@ -12,7 +12,9 @@ struct mlx5e_post_meter_priv {
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *fg;
 	struct mlx5_flow_handle *green_rule;
+	struct mlx5_flow_attr *green_attr;
 	struct mlx5_flow_handle *red_rule;
+	struct mlx5_flow_attr *red_attr;
 };
 
 struct mlx5_flow_table *
@@ -81,15 +83,48 @@ mlx5e_post_meter_fg_create(struct mlx5e_priv *priv,
 	return err;
 }
 
+static struct mlx5_flow_handle *
+mlx5e_post_meter_add_rule(struct mlx5e_priv *priv,
+			  struct mlx5e_post_meter_priv *post_meter,
+			  struct mlx5_flow_spec *spec,
+			  struct mlx5_flow_attr *attr,
+			  struct mlx5_fc *act_counter,
+			  struct mlx5_fc *drop_counter)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_flow_handle *ret;
+
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_DROP)
+		attr->counter = drop_counter;
+	else
+		attr->counter = act_counter;
+
+	attr->ft = post_meter->ft;
+	attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
+	attr->outer_match_level = MLX5_MATCH_NONE;
+	attr->chain = 0;
+	attr->prio = 0;
+
+	ret = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
+
+	/* We did not create the counter, so we can't delete it.
+	 * Avoid freeing the counter when the attr is deleted in free_branching_attr
+	 */
+	attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_COUNT;
+
+	return ret;
+}
+
 static int
 mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 			      struct mlx5e_post_meter_priv *post_meter,
 			      struct mlx5e_post_act *post_act,
 			      struct mlx5_fc *act_counter,
-			      struct mlx5_fc *drop_counter)
+			      struct mlx5_fc *drop_counter,
+			      struct mlx5_flow_attr *green_attr,
+			      struct mlx5_flow_attr *red_attr)
 {
-	struct mlx5_flow_destination dest[2] = {};
-	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	int err;
@@ -100,36 +135,28 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 
 	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
 				    MLX5_FLOW_METER_COLOR_RED, MLX5_PACKET_COLOR_MASK);
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP |
-			  MLX5_FLOW_CONTEXT_ACTION_COUNT;
-	flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
-	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-	dest[0].counter_id = mlx5_fc_id(drop_counter);
 
-	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, dest, 1);
+	rule = mlx5e_post_meter_add_rule(priv, post_meter, spec, red_attr,
+					 act_counter, drop_counter);
 	if (IS_ERR(rule)) {
-		mlx5_core_warn(priv->mdev, "Failed to create post_meter flow drop rule\n");
+		mlx5_core_warn(priv->mdev, "Failed to create post_meter exceed rule\n");
 		err = PTR_ERR(rule);
 		goto err_red;
 	}
 	post_meter->red_rule = rule;
+	post_meter->red_attr = red_attr;
 
 	mlx5e_tc_match_to_reg_match(spec, PACKET_COLOR_TO_REG,
 				    MLX5_FLOW_METER_COLOR_GREEN, MLX5_PACKET_COLOR_MASK);
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			  MLX5_FLOW_CONTEXT_ACTION_COUNT;
-	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest[0].ft = mlx5e_tc_post_act_get_ft(post_act);
-	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-	dest[1].counter_id = mlx5_fc_id(act_counter);
-
-	rule = mlx5_add_flow_rules(post_meter->ft, spec, &flow_act, dest, 2);
+	rule = mlx5e_post_meter_add_rule(priv, post_meter, spec, green_attr,
+					 act_counter, drop_counter);
 	if (IS_ERR(rule)) {
-		mlx5_core_warn(priv->mdev, "Failed to create post_meter flow fwd rule\n");
+		mlx5_core_warn(priv->mdev, "Failed to create post_meter notexceed rule\n");
 		err = PTR_ERR(rule);
 		goto err_green;
 	}
 	post_meter->green_rule = rule;
+	post_meter->green_attr = green_attr;
 
 	kvfree(spec);
 	return 0;
@@ -142,10 +169,11 @@ mlx5e_post_meter_rules_create(struct mlx5e_priv *priv,
 }
 
 static void
-mlx5e_post_meter_rules_destroy(struct mlx5e_post_meter_priv *post_meter)
+mlx5e_post_meter_rules_destroy(struct mlx5_eswitch *esw,
+			       struct mlx5e_post_meter_priv *post_meter)
 {
-	mlx5_del_flow_rules(post_meter->red_rule);
-	mlx5_del_flow_rules(post_meter->green_rule);
+	mlx5_eswitch_del_offloaded_rule(esw, post_meter->red_rule, post_meter->red_attr);
+	mlx5_eswitch_del_offloaded_rule(esw, post_meter->green_rule, post_meter->green_attr);
 }
 
 static void
@@ -165,7 +193,9 @@ mlx5e_post_meter_init(struct mlx5e_priv *priv,
 		      enum mlx5_flow_namespace_type ns_type,
 		      struct mlx5e_post_act *post_act,
 		      struct mlx5_fc *act_counter,
-		      struct mlx5_fc *drop_counter)
+		      struct mlx5_fc *drop_counter,
+		      struct mlx5_flow_attr *branch_true,
+		      struct mlx5_flow_attr *branch_false)
 {
 	struct mlx5e_post_meter_priv *post_meter;
 	int err;
@@ -182,8 +212,8 @@ mlx5e_post_meter_init(struct mlx5e_priv *priv,
 	if (err)
 		goto err_fg;
 
-	err = mlx5e_post_meter_rules_create(priv, post_meter, post_act,
-					    act_counter, drop_counter);
+	err = mlx5e_post_meter_rules_create(priv, post_meter, post_act, act_counter,
+					    drop_counter, branch_true, branch_false);
 	if (err)
 		goto err_rules;
 
@@ -199,9 +229,9 @@ mlx5e_post_meter_init(struct mlx5e_priv *priv,
 }
 
 void
-mlx5e_post_meter_cleanup(struct mlx5e_post_meter_priv *post_meter)
+mlx5e_post_meter_cleanup(struct mlx5_eswitch *esw, struct mlx5e_post_meter_priv *post_meter)
 {
-	mlx5e_post_meter_rules_destroy(post_meter);
+	mlx5e_post_meter_rules_destroy(esw, post_meter);
 	mlx5e_post_meter_fg_destroy(post_meter);
 	mlx5e_post_meter_table_destroy(post_meter);
 	kfree(post_meter);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
index 37c74e7bfb6a..a4075d33fde2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
@@ -22,8 +22,10 @@ mlx5e_post_meter_init(struct mlx5e_priv *priv,
 		      enum mlx5_flow_namespace_type ns_type,
 		      struct mlx5e_post_act *post_act,
 		      struct mlx5_fc *act_counter,
-		      struct mlx5_fc *drop_counter);
+		      struct mlx5_fc *drop_counter,
+		      struct mlx5_flow_attr *branch_true,
+		      struct mlx5_flow_attr *branch_false);
 void
-mlx5e_post_meter_cleanup(struct mlx5e_post_meter_priv *post_meter);
+mlx5e_post_meter_cleanup(struct mlx5_eswitch *esw, struct mlx5e_post_meter_priv *post_meter);
 
 #endif /* __MLX5_EN_POST_METER_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ce449fa4f36e..338e0b21d0b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -422,8 +422,9 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 	}
 
 	ns_type = mlx5e_tc_meter_get_namespace(meter->flow_meters);
-	post_meter = mlx5e_post_meter_init(priv, ns_type, post_act, meter->act_counter,
-					   meter->drop_counter);
+	post_meter = mlx5e_post_meter_init(priv, ns_type, post_act,
+					   meter->act_counter, meter->drop_counter,
+					   attr->branch_true, attr->branch_false);
 	if (IS_ERR(post_meter)) {
 		mlx5_core_err(priv->mdev, "Failed to init post meter\n");
 		goto err_meter_init;
@@ -442,9 +443,9 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 }
 
 static void
-mlx5e_tc_del_flow_meter(struct mlx5_flow_attr *attr)
+mlx5e_tc_del_flow_meter(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr)
 {
-	mlx5e_post_meter_cleanup(attr->meter_attr.post_meter);
+	mlx5e_post_meter_cleanup(esw, attr->meter_attr.post_meter);
 	mlx5e_tc_meter_put(attr->meter_attr.meter);
 }
 
@@ -505,7 +506,7 @@ mlx5e_tc_rule_unoffload(struct mlx5e_priv *priv,
 	mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
 
 	if (attr->meter_attr.meter)
-		mlx5e_tc_del_flow_meter(attr);
+		mlx5e_tc_del_flow_meter(esw, attr);
 }
 
 int
-- 
2.38.1

