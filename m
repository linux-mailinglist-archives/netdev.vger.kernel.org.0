Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3525964196E
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiLCWOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLCWOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:14:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C0B1E71B
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA84160C42
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16419C433D7;
        Sat,  3 Dec 2022 22:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105636;
        bh=OSnPn6+Ce40wlaqvv4HZPiFGLQIaqK9/6Ht7tSRCVZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPjRsN7WTjZAo70c5DY/gAzpbVvIBqsm0E0pIm0UkRVPkAFK6m8YhDVSrIsfYk3dO
         yJxXVcakkFHK2IjbMhnJb3xNE2+GM9deujmkwcWxuJ5Fk+q5hpfJf4jiPFu7SUewI/
         IZb7xgGMa7/mgiRNTZA38SVLK+bOGJmODmcuxZ9yDshLq2RJyaWLUXZ0nityurSUeF
         JvtoCw/Z5GZmRGBfjQv5i+ZJVfE9tAjKlw7GrlEJCZkNpTrm6xv6pU/vpJPjZLOYN2
         MEF18J5SxLE56gUwIDq4ms0XMYy1ZQi2Sppf//uW+vXR8Hpxi3itTQl+58YZbVDU56
         o1AcPjk3dGdOQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 12/15] net/mlx5: SRIOV, Remove two unused ingress flow group
Date:   Sat,  3 Dec 2022 14:13:34 -0800
Message-Id: <20221203221337.29267-13-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

As in SRIOV ingress ACL table we use only one rule for allowed traffic
and one drop rule, there is no need in four flow groups. Since the
groups can be created dynamically on configuration changes, the group
layout can be changed dynamically as well, instead of creating four
different groups with four different layouts statically.

Set two flow groups according to the needed flow steering rules and
remove the other unused groups. To avoid resetting the flow counter
while recreating the flow table, take the flow counter handling
separately.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 173 +++++++-----------
 .../mellanox/mlx5/core/esw/acl/lgcy.h         |   4 +
 .../ethernet/mellanox/mlx5/core/esw/legacy.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   4 +-
 4 files changed, 72 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index b1a5199260f6..0b37edb9490d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -33,9 +33,12 @@ static int esw_acl_ingress_lgcy_groups_create(struct mlx5_eswitch *esw,
 
 	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
 		 MLX5_MATCH_OUTER_HEADERS);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_16);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_0);
+	if (vport->info.vlan || vport->info.qos)
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
+	if (vport->info.spoofchk) {
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_16);
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_0);
+	}
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
 
@@ -44,47 +47,14 @@ static int esw_acl_ingress_lgcy_groups_create(struct mlx5_eswitch *esw,
 		err = PTR_ERR(g);
 		esw_warn(dev, "vport[%d] ingress create untagged spoofchk flow group, err(%d)\n",
 			 vport->vport, err);
-		goto spoof_err;
+		goto allow_err;
 	}
-	vport->ingress.legacy.allow_untagged_spoofchk_grp = g;
+	vport->ingress.legacy.allow_grp = g;
 
 	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-		 MLX5_MATCH_OUTER_HEADERS);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
 
-	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "vport[%d] ingress create untagged flow group, err(%d)\n",
-			 vport->vport, err);
-		goto untagged_err;
-	}
-	vport->ingress.legacy.allow_untagged_only_grp = g;
-
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-		 MLX5_MATCH_OUTER_HEADERS);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_16);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_15_0);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 2);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 2);
-
-	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
-	if (IS_ERR(g)) {
-		err = PTR_ERR(g);
-		esw_warn(dev, "vport[%d] ingress create spoofchk flow group, err(%d)\n",
-			 vport->vport, err);
-		goto allow_spoof_err;
-	}
-	vport->ingress.legacy.allow_spoofchk_only_grp = g;
-
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 3);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 3);
-
 	g = mlx5_create_flow_group(vport->ingress.acl, flow_group_in);
 	if (IS_ERR(g)) {
 		err = PTR_ERR(g);
@@ -97,38 +67,20 @@ static int esw_acl_ingress_lgcy_groups_create(struct mlx5_eswitch *esw,
 	return 0;
 
 drop_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_spoofchk_only_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
-		vport->ingress.legacy.allow_spoofchk_only_grp = NULL;
+	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_grp)) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_grp);
+		vport->ingress.legacy.allow_grp = NULL;
 	}
-allow_spoof_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_only_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
-		vport->ingress.legacy.allow_untagged_only_grp = NULL;
-	}
-untagged_err:
-	if (!IS_ERR_OR_NULL(vport->ingress.legacy.allow_untagged_spoofchk_grp)) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_grp);
-		vport->ingress.legacy.allow_untagged_spoofchk_grp = NULL;
-	}
-spoof_err:
+allow_err:
 	kvfree(flow_group_in);
 	return err;
 }
 
 static void esw_acl_ingress_lgcy_groups_destroy(struct mlx5_vport *vport)
 {
-	if (vport->ingress.legacy.allow_spoofchk_only_grp) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_spoofchk_only_grp);
-		vport->ingress.legacy.allow_spoofchk_only_grp = NULL;
-	}
-	if (vport->ingress.legacy.allow_untagged_only_grp) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_only_grp);
-		vport->ingress.legacy.allow_untagged_only_grp = NULL;
-	}
-	if (vport->ingress.legacy.allow_untagged_spoofchk_grp) {
-		mlx5_destroy_flow_group(vport->ingress.legacy.allow_untagged_spoofchk_grp);
-		vport->ingress.legacy.allow_untagged_spoofchk_grp = NULL;
+	if (vport->ingress.legacy.allow_grp) {
+		mlx5_destroy_flow_group(vport->ingress.legacy.allow_grp);
+		vport->ingress.legacy.allow_grp = NULL;
 	}
 	if (vport->ingress.legacy.drop_grp) {
 		mlx5_destroy_flow_group(vport->ingress.legacy.drop_grp);
@@ -143,56 +95,33 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_spec *spec = NULL;
-	struct mlx5_fc *counter = NULL;
-	/* The ingress acl table contains 4 groups
-	 * (2 active rules at the same time -
-	 *      1 allow rule from one of the first 3 groups.
-	 *      1 drop rule from the last group):
-	 * 1)Allow untagged traffic with smac=original mac.
-	 * 2)Allow untagged traffic.
-	 * 3)Allow traffic with smac=original mac.
-	 * 4)Drop all other traffic.
+	struct mlx5_fc *counter;
+	/* The ingress acl table contains 2 groups
+	 * 1)Allowed traffic according to tagging and spoofcheck settings
+	 * 2)Drop all other traffic.
 	 */
-	int table_size = 4;
+	int table_size = 2;
 	int dest_num = 0;
 	int err = 0;
 	u8 *smac_v;
 
-	esw_acl_ingress_lgcy_rules_destroy(vport);
-
-	if (vport->ingress.legacy.drop_counter) {
-		counter = vport->ingress.legacy.drop_counter;
-	} else if (MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter)) {
-		counter = mlx5_fc_create(esw->dev, false);
-		if (IS_ERR(counter)) {
-			esw_warn(esw->dev,
-				 "vport[%d] configure ingress drop rule counter failed\n",
-				 vport->vport);
-			counter = NULL;
-		}
-		vport->ingress.legacy.drop_counter = counter;
-	}
-
-	if (!vport->info.vlan && !vport->info.qos && !vport->info.spoofchk) {
-		esw_acl_ingress_lgcy_cleanup(esw, vport);
+	esw_acl_ingress_lgcy_cleanup(esw, vport);
+	if (!vport->info.vlan && !vport->info.qos && !vport->info.spoofchk)
 		return 0;
-	}
 
-	if (!vport->ingress.acl) {
-		vport->ingress.acl = esw_acl_table_create(esw, vport,
-							  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
-							  table_size);
-		if (IS_ERR(vport->ingress.acl)) {
-			err = PTR_ERR(vport->ingress.acl);
-			vport->ingress.acl = NULL;
-			return err;
-		}
-
-		err = esw_acl_ingress_lgcy_groups_create(esw, vport);
-		if (err)
-			goto out;
+	vport->ingress.acl = esw_acl_table_create(esw, vport,
+						  MLX5_FLOW_NAMESPACE_ESW_INGRESS,
+						  table_size);
+	if (IS_ERR(vport->ingress.acl)) {
+		err = PTR_ERR(vport->ingress.acl);
+		vport->ingress.acl = NULL;
+		return err;
 	}
 
+	err = esw_acl_ingress_lgcy_groups_create(esw, vport);
+	if (err)
+		goto out;
+
 	esw_debug(esw->dev,
 		  "vport[%d] configure ingress rules, vlan(%d) qos(%d)\n",
 		  vport->vport, vport->info.vlan, vport->info.qos);
@@ -235,6 +164,7 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 	memset(&flow_act, 0, sizeof(flow_act));
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 	/* Attach drop flow counter */
+	counter = vport->ingress.legacy.drop_counter;
 	if (counter) {
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
 		drop_ctr_dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
@@ -266,17 +196,42 @@ void esw_acl_ingress_lgcy_cleanup(struct mlx5_eswitch *esw,
 				  struct mlx5_vport *vport)
 {
 	if (IS_ERR_OR_NULL(vport->ingress.acl))
-		goto clean_drop_counter;
+		return;
 
 	esw_debug(esw->dev, "Destroy vport[%d] E-Switch ingress ACL\n", vport->vport);
 
 	esw_acl_ingress_lgcy_rules_destroy(vport);
 	esw_acl_ingress_lgcy_groups_destroy(vport);
 	esw_acl_ingress_table_destroy(vport);
+}
+
+void esw_acl_ingress_lgcy_create_counter(struct mlx5_eswitch *esw,
+					 struct mlx5_vport *vport)
+{
+	struct mlx5_fc *counter;
 
-clean_drop_counter:
-	if (vport->ingress.legacy.drop_counter) {
-		mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
-		vport->ingress.legacy.drop_counter = NULL;
+	vport->ingress.legacy.drop_counter = NULL;
+
+	if (!MLX5_CAP_ESW_INGRESS_ACL(esw->dev, flow_counter))
+		return;
+
+	counter = mlx5_fc_create(esw->dev, false);
+	if (IS_ERR(counter)) {
+		esw_warn(esw->dev,
+			 "vport[%d] configure ingress drop rule counter failed\n",
+			 vport->vport);
+		return;
 	}
+
+	vport->ingress.legacy.drop_counter = counter;
+}
+
+void esw_acl_ingress_lgcy_destroy_counter(struct mlx5_eswitch *esw,
+					  struct mlx5_vport *vport)
+{
+	if (!vport->ingress.legacy.drop_counter)
+		return;
+
+	mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
+	vport->ingress.legacy.drop_counter = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
index 44c152da3d83..c4a624ffca43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
@@ -13,5 +13,9 @@ void esw_acl_egress_lgcy_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vp
 /* Eswitch acl ingress external APIs */
 int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 void esw_acl_ingress_lgcy_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+void esw_acl_ingress_lgcy_create_counter(struct mlx5_eswitch *esw,
+					 struct mlx5_vport *vport);
+void esw_acl_ingress_lgcy_destroy_counter(struct mlx5_eswitch *esw,
+					  struct mlx5_vport *vport);
 
 #endif /* __MLX5_ESWITCH_ACL_LGCY_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index fabe49a35a5c..97a104668723 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -356,6 +356,7 @@ int esw_legacy_vport_acl_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vpor
 	if (mlx5_esw_is_manager_vport(esw, vport->vport))
 		return 0;
 
+	esw_acl_ingress_lgcy_create_counter(esw, vport);
 	ret = esw_acl_ingress_lgcy_setup(esw, vport);
 	if (ret)
 		goto ingress_err;
@@ -369,6 +370,7 @@ int esw_legacy_vport_acl_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vpor
 egress_err:
 	esw_acl_ingress_lgcy_cleanup(esw, vport);
 ingress_err:
+	esw_acl_ingress_lgcy_destroy_counter(esw, vport);
 	return ret;
 }
 
@@ -379,6 +381,7 @@ void esw_legacy_vport_acl_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *v
 
 	esw_acl_egress_lgcy_cleanup(esw, vport);
 	esw_acl_ingress_lgcy_cleanup(esw, vport);
+	esw_acl_ingress_lgcy_destroy_counter(esw, vport);
 }
 
 int mlx5_esw_query_vport_drop_stats(struct mlx5_core_dev *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 42d9df417e20..b7779826e725 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -97,9 +97,7 @@ struct vport_ingress {
 	struct mlx5_flow_table *acl;
 	struct mlx5_flow_handle *allow_rule;
 	struct {
-		struct mlx5_flow_group *allow_spoofchk_only_grp;
-		struct mlx5_flow_group *allow_untagged_spoofchk_grp;
-		struct mlx5_flow_group *allow_untagged_only_grp;
+		struct mlx5_flow_group *allow_grp;
 		struct mlx5_flow_group *drop_grp;
 		struct mlx5_flow_handle *drop_rule;
 		struct mlx5_fc *drop_counter;
-- 
2.38.1

