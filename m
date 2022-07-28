Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2E858475D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiG1U5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbiG1U5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D5E7757B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8951AB82594
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BC8C433D7;
        Thu, 28 Jul 2022 20:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041853;
        bh=+Co+YqEYNK4Sg+HaKxiCzKzA/BuVaC4eZcOmMAcGc+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euGnNWwIkTaDZRWU46LekP9hPhZ1nwPtVCMewyYointJj2w6YqrTeNzPt7Dx8hZw3
         a5wo8jU6KSycaloWTzBp+dq7pmogSEQlqjf61Vp4wOjlOIpW21bNdApAnVJaJWNGU+
         FDmLJTPOmIIZ8COLTeF2A+08dcj84Kaw4kUDXqvzFezEKm6CDIsLa5qoiUtIYzBUVs
         k0Q+obp1gOJQnaZvKfMdeaahxBQNe/qFPx+q8UfB1eduREs8+VqipjmJXjihvnMvPZ
         5wdKIOpdL/8eo2pDbLISvWpkvea/yg8QfBbtpTVtL+/J7+UReC9BVRfeFN5/KYTEZV
         rhmNlELsYl5tA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: TC, Allocate post meter ft per rule
Date:   Thu, 28 Jul 2022 13:57:16 -0700
Message-Id: <20220728205728.143074-4-saeed@kernel.org>
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

To support a TC police action notexceed counter and supporting
actions other than drop/pipe there is a need to create separate ft
and rules per rule and not to use a common one created on eswitch init.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/meter.c | 19 +++-----------
 .../ethernet/mellanox/mlx5/core/en/tc/meter.h |  6 +++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 26 +++++++++++++++++--
 3 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
index ca33f673396f..ae621d04abe9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
@@ -6,7 +6,6 @@
 #include "en/tc/post_act.h"
 #include "meter.h"
 #include "en/tc_priv.h"
-#include "post_meter.h"
 
 #define MLX5_START_COLOR_SHIFT 28
 #define MLX5_METER_MODE_SHIFT 24
@@ -47,8 +46,6 @@ struct mlx5e_flow_meters {
 
 	struct mlx5_core_dev *mdev;
 	struct mlx5e_post_act *post_act;
-
-	struct mlx5e_post_meter_priv *post_meter;
 };
 
 static void
@@ -390,10 +387,10 @@ mlx5e_tc_meter_put(struct mlx5e_flow_meter_handle *meter)
 	mutex_unlock(&flow_meters->sync_lock);
 }
 
-struct mlx5_flow_table *
-mlx5e_tc_meter_get_post_meter_ft(struct mlx5e_flow_meters *flow_meters)
+enum mlx5_flow_namespace_type
+mlx5e_tc_meter_get_namespace(struct mlx5e_flow_meters *flow_meters)
 {
-	return mlx5e_post_meter_get_ft(flow_meters->post_meter);
+	return flow_meters->ns_type;
 }
 
 struct mlx5e_flow_meters *
@@ -432,12 +429,6 @@ mlx5e_flow_meters_init(struct mlx5e_priv *priv,
 		goto err_sq;
 	}
 
-	flow_meters->post_meter = mlx5e_post_meter_init(priv, ns_type, post_act);
-	if (IS_ERR(flow_meters->post_meter)) {
-		err = PTR_ERR(flow_meters->post_meter);
-		goto err_post_meter;
-	}
-
 	mutex_init(&flow_meters->sync_lock);
 	INIT_LIST_HEAD(&flow_meters->partial_list);
 	INIT_LIST_HEAD(&flow_meters->full_list);
@@ -451,8 +442,6 @@ mlx5e_flow_meters_init(struct mlx5e_priv *priv,
 
 	return flow_meters;
 
-err_post_meter:
-	mlx5_aso_destroy(flow_meters->aso);
 err_sq:
 	mlx5_core_dealloc_pd(mdev, flow_meters->pdn);
 err_out:
@@ -466,9 +455,7 @@ mlx5e_flow_meters_cleanup(struct mlx5e_flow_meters *flow_meters)
 	if (IS_ERR_OR_NULL(flow_meters))
 		return;
 
-	mlx5e_post_meter_cleanup(flow_meters->post_meter);
 	mlx5_aso_destroy(flow_meters->aso);
 	mlx5_core_dealloc_pd(flow_meters->mdev, flow_meters->pdn);
-
 	kfree(flow_meters);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
index 78885db5dc7d..bf47ff660445 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
@@ -4,6 +4,7 @@
 #ifndef __MLX5_EN_FLOW_METER_H__
 #define __MLX5_EN_FLOW_METER_H__
 
+struct mlx5e_post_meter_priv;
 struct mlx5e_flow_meter_aso_obj;
 struct mlx5e_flow_meters;
 struct mlx5_flow_attr;
@@ -35,6 +36,7 @@ struct mlx5e_flow_meter_handle {
 struct mlx5e_meter_attr {
 	struct mlx5e_flow_meter_params params;
 	struct mlx5e_flow_meter_handle *meter;
+	struct mlx5e_post_meter_priv *post_meter;
 };
 
 int
@@ -47,8 +49,8 @@ mlx5e_tc_meter_get(struct mlx5_core_dev *mdev, struct mlx5e_flow_meter_params *p
 void
 mlx5e_tc_meter_put(struct mlx5e_flow_meter_handle *meter);
 
-struct mlx5_flow_table *
-mlx5e_tc_meter_get_post_meter_ft(struct mlx5e_flow_meters *flow_meters);
+enum mlx5_flow_namespace_type
+mlx5e_tc_meter_get_namespace(struct mlx5e_flow_meters *flow_meters);
 
 struct mlx5e_flow_meters *
 mlx5e_flow_meters_init(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2e12280a936f..63c1791d4fac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -356,6 +356,9 @@ static int
 mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 			struct mlx5_flow_attr *attr)
 {
+	struct mlx5e_post_act *post_act = get_post_action(priv);
+	struct mlx5e_post_meter_priv *post_meter;
+	enum mlx5_flow_namespace_type ns_type;
 	struct mlx5e_flow_meter_handle *meter;
 
 	meter = mlx5e_tc_meter_get(priv->mdev, &attr->meter_attr.params);
@@ -364,11 +367,30 @@ mlx5e_tc_add_flow_meter(struct mlx5e_priv *priv,
 		return PTR_ERR(meter);
 	}
 
+	ns_type = mlx5e_tc_meter_get_namespace(meter->flow_meters);
+	post_meter = mlx5e_post_meter_init(priv, ns_type, post_act);
+	if (IS_ERR(post_meter)) {
+		mlx5_core_err(priv->mdev, "Failed to init post meter\n");
+		goto err_meter_init;
+	}
+
 	attr->meter_attr.meter = meter;
-	attr->dest_ft = mlx5e_tc_meter_get_post_meter_ft(meter->flow_meters);
+	attr->meter_attr.post_meter = post_meter;
+	attr->dest_ft = mlx5e_post_meter_get_ft(post_meter);
 	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
 	return 0;
+
+err_meter_init:
+	mlx5e_tc_meter_put(meter);
+	return PTR_ERR(post_meter);
+}
+
+static void
+mlx5e_tc_del_flow_meter(struct mlx5_flow_attr *attr)
+{
+	mlx5e_post_meter_cleanup(attr->meter_attr.post_meter);
+	mlx5e_tc_meter_put(attr->meter_attr.meter);
 }
 
 struct mlx5_flow_handle *
@@ -428,7 +450,7 @@ mlx5e_tc_rule_unoffload(struct mlx5e_priv *priv,
 	mlx5_eswitch_del_offloaded_rule(esw, rule, attr);
 
 	if (attr->meter_attr.meter)
-		mlx5e_tc_meter_put(attr->meter_attr.meter);
+		mlx5e_tc_del_flow_meter(attr);
 }
 
 int
-- 
2.37.1

