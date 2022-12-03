Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6BB64196D
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiLCWOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiLCWOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:14:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE88140C2
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 338F560C70
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8F4C433B5;
        Sat,  3 Dec 2022 22:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105638;
        bh=wTYPYFASAw/0/K5bVsjjlyOkOVC50uYpw2ZB7Z1Ostg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un/ev+yUHZR/YlLrR200qNGQgZshlE4yWqipL3mE6zbAAWnSXk0QA/YVxOe69JXOx
         WOq5HLLZFy4j08m39ZUBKgdyNmpKncWX/8KFZ/pDVwmb6Q4eWgTUCbGagyfwxyLu8d
         msthZxWSfrKhqAsfGca4EtZi7yF/pV5mpBVz6fdoPrTTPvhGb9BOBgeej1JPSJ5my3
         /J4XWY3GjUgL9hAOq6QT0QwpSRnSWaYKeHm8tLK9822qUWdEmpFyDPge/AInzQYpu4
         wKVoQSWmp+paPsGZ+E92VIkvTtzvuANNQdHlKwwNbRfno11UqM7Rv1oHokP2jI6tog
         dOSknFPeZqfNw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 14/15] net/mlx5: SRIOV, Add 802.1ad VST support
Date:   Sat,  3 Dec 2022 14:13:36 -0800
Message-Id: <20221203221337.29267-15-saeed@kernel.org>
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

Implement 802.1ad VST when device supports push vlan and pop vlan
steering actions on vport ACLs. In case device doesn't support these
steering actions, fall back to setting eswitch vport context, which
supports only 802.1q.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  5 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c  | 11 +++--
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  |  5 +-
 .../mellanox/mlx5/core/esw/acl/helper.c       | 20 ++++++--
 .../mellanox/mlx5/core/esw/acl/helper.h       |  5 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c | 47 ++++++++++++++-----
 .../ethernet/mellanox/mlx5/core/esw/legacy.c  |  6 +--
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 28 ++++++++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 21 +++++++--
 .../mellanox/mlx5/core/eswitch_offloads.c     | 10 ++--
 10 files changed, 113 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8d36e2de53a9..7911edefc622 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4440,11 +4440,8 @@ static int mlx5e_set_vf_vlan(struct net_device *dev, int vf, u16 vlan, u8 qos,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (vlan_proto != htons(ETH_P_8021Q))
-		return -EPROTONOSUPPORT;
-
 	return mlx5_eswitch_set_vport_vlan(mdev->priv.eswitch, vf + 1,
-					   vlan, qos);
+					   vlan, qos, ntohs(vlan_proto));
 }
 
 static int mlx5e_set_vf_spoofchk(struct net_device *dev, int vf, bool setting)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index 83ecad5ea80b..e9f8b2619b46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -24,7 +24,7 @@ static int esw_acl_egress_lgcy_groups_create(struct mlx5_eswitch *esw,
 	u32 *flow_group_in;
 	int err = 0;
 
-	err = esw_acl_egress_vlan_grp_create(esw, vport);
+	err = esw_acl_egress_vlan_grp_create(esw, vport, vport->info.vlan_proto);
 	if (err)
 		return err;
 
@@ -67,6 +67,7 @@ static void esw_acl_egress_lgcy_groups_destroy(struct mlx5_vport *vport)
 int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 			      struct mlx5_vport *vport)
 {
+	enum esw_vst_mode vst_mode = esw_get_vst_mode(esw);
 	struct mlx5_flow_destination drop_ctr_dst = {};
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_flow_act flow_act = {};
@@ -77,6 +78,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	 */
 	int table_size = 2;
 	int dest_num = 0;
+	int actions_flag;
 	int err = 0;
 
 	esw_acl_egress_lgcy_cleanup(esw, vport);
@@ -101,8 +103,11 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 		  vport->vport, vport->info.vlan, vport->info.qos);
 
 	/* Allowed vlan rule */
-	err = esw_egress_acl_vlan_create(esw, vport, NULL, vport->info.vlan,
-					 MLX5_FLOW_CONTEXT_ACTION_ALLOW);
+	actions_flag = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	if (vst_mode == ESW_VST_MODE_STEERING)
+		actions_flag |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
+	err = esw_egress_acl_vlan_create(esw, vport, NULL, vport->info.vlan_proto,
+					 vport->info.vlan, actions_flag);
 	if (err)
 		goto out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index 2e504c7461c6..848edd9b9af8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -73,7 +73,8 @@ static int esw_acl_egress_ofld_rules_create(struct mlx5_eswitch *esw,
 			  MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 
 		/* prio tag vlan rule - pop it so vport receives untagged packets */
-		err = esw_egress_acl_vlan_create(esw, vport, fwd_dest, 0, action);
+		err = esw_egress_acl_vlan_create(esw, vport, fwd_dest,
+						 ETH_P_8021Q, 0, action);
 		if (err)
 			goto prio_err;
 	}
@@ -109,7 +110,7 @@ static int esw_acl_egress_ofld_groups_create(struct mlx5_eswitch *esw,
 	int ret = 0;
 
 	if (MLX5_CAP_GEN(esw->dev, prio_tag_required)) {
-		ret = esw_acl_egress_vlan_grp_create(esw, vport);
+		ret = esw_acl_egress_vlan_grp_create(esw, vport, ETH_P_8021Q);
 		if (ret)
 			return ret;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
index 45b839116212..69ee780a7a1b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
@@ -48,7 +48,7 @@ esw_acl_table_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport, int ns,
 int esw_egress_acl_vlan_create(struct mlx5_eswitch *esw,
 			       struct mlx5_vport *vport,
 			       struct mlx5_flow_destination *fwd_dest,
-			       u16 vlan_id, u32 flow_action)
+			       u16 vlan_proto, u16 vlan_id, u32 flow_action)
 {
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_spec *spec;
@@ -61,8 +61,14 @@ int esw_egress_acl_vlan_create(struct mlx5_eswitch *esw,
 	if (!spec)
 		return -ENOMEM;
 
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvlan_tag);
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.cvlan_tag);
+	if (vlan_proto == ETH_P_8021AD) {
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.svlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.svlan_tag);
+	} else {
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvlan_tag);
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.cvlan_tag);
+	}
+	/* Both outer_headers.cvlan_tag and outer_headers.svlan_tag match only first vlan */
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.first_vid);
 	MLX5_SET(fte_match_param, spec->match_value, outer_headers.first_vid, vlan_id);
 
@@ -91,7 +97,8 @@ void esw_acl_egress_vlan_destroy(struct mlx5_vport *vport)
 	}
 }
 
-int esw_acl_egress_vlan_grp_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+int esw_acl_egress_vlan_grp_create(struct mlx5_eswitch *esw,
+				   struct mlx5_vport *vport, u16 vlan_proto)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *vlan_grp;
@@ -107,7 +114,10 @@ int esw_acl_egress_vlan_grp_create(struct mlx5_eswitch *esw, struct mlx5_vport *
 		 match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
 	match_criteria = MLX5_ADDR_OF(create_flow_group_in,
 				      flow_group_in, match_criteria);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
+	if (vlan_proto == ETH_P_8021AD)
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.svlan_tag);
+	else
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
 	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.first_vid);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
index a47063fab57e..f41af663251e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
@@ -14,9 +14,10 @@ esw_acl_table_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport, int ns,
 void esw_acl_egress_table_destroy(struct mlx5_vport *vport);
 int esw_egress_acl_vlan_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 			       struct mlx5_flow_destination *fwd_dest,
-			       u16 vlan_id, u32 flow_action);
+			       u16 vlan_proto, u16 vlan_id, u32 flow_action);
 void esw_acl_egress_vlan_destroy(struct mlx5_vport *vport);
-int esw_acl_egress_vlan_grp_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+int esw_acl_egress_vlan_grp_create(struct mlx5_eswitch *esw,
+				   struct mlx5_vport *vport, u16 vlan_proto);
 void esw_acl_egress_vlan_grp_destroy(struct mlx5_vport *vport);
 
 /* Ingress acl helper functions */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index 0b37edb9490d..eb68d6e6d5aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -18,10 +18,12 @@ static void esw_acl_ingress_lgcy_rules_destroy(struct mlx5_vport *vport)
 static int esw_acl_ingress_lgcy_groups_create(struct mlx5_eswitch *esw,
 					      struct mlx5_vport *vport)
 {
+	enum esw_vst_mode vst_mode = esw_get_vst_mode(esw);
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_core_dev *dev = esw->dev;
 	struct mlx5_flow_group *g;
 	void *match_criteria;
+	bool push_on_any_pkt;
 	u32 *flow_group_in;
 	int err;
 
@@ -31,9 +33,11 @@ static int esw_acl_ingress_lgcy_groups_create(struct mlx5_eswitch *esw,
 
 	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
 
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
-		 MLX5_MATCH_OUTER_HEADERS);
-	if (vport->info.vlan || vport->info.qos)
+	push_on_any_pkt = (vst_mode == ESW_VST_MODE_STEERING && !vport->info.spoofchk);
+	if (!push_on_any_pkt)
+		MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
+			 MLX5_MATCH_OUTER_HEADERS);
+	if (vst_mode == ESW_VST_MODE_BASIC && (vport->info.vlan || vport->info.qos))
 		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
 	if (vport->info.spoofchk) {
 		MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.smac_47_16);
@@ -50,6 +54,8 @@ static int esw_acl_ingress_lgcy_groups_create(struct mlx5_eswitch *esw,
 		goto allow_err;
 	}
 	vport->ingress.legacy.allow_grp = g;
+	if (push_on_any_pkt)
+		goto out;
 
 	memset(flow_group_in, 0, inlen);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
@@ -63,6 +69,7 @@ static int esw_acl_ingress_lgcy_groups_create(struct mlx5_eswitch *esw,
 		goto drop_err;
 	}
 	vport->ingress.legacy.drop_grp = g;
+out:
 	kvfree(flow_group_in);
 	return 0;
 
@@ -91,6 +98,7 @@ static void esw_acl_ingress_lgcy_groups_destroy(struct mlx5_vport *vport)
 int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 			       struct mlx5_vport *vport)
 {
+	enum esw_vst_mode vst_mode = esw_get_vst_mode(esw);
 	struct mlx5_flow_destination drop_ctr_dst = {};
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_flow_act flow_act = {};
@@ -100,6 +108,7 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 	 * 1)Allowed traffic according to tagging and spoofcheck settings
 	 * 2)Drop all other traffic.
 	 */
+	bool push_on_any_pkt;
 	int table_size = 2;
 	int dest_num = 0;
 	int err = 0;
@@ -123,8 +132,8 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		goto out;
 
 	esw_debug(esw->dev,
-		  "vport[%d] configure ingress rules, vlan(%d) qos(%d)\n",
-		  vport->vport, vport->info.vlan, vport->info.qos);
+		  "vport[%d] configure ingress rules, vlan(%d) qos(%d) vst_mode (%d)\n",
+		  vport->vport, vport->info.vlan, vport->info.qos, vst_mode);
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
@@ -132,9 +141,21 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		goto out;
 	}
 
-	if (vport->info.vlan || vport->info.qos)
-		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
-				 outer_headers.cvlan_tag);
+	push_on_any_pkt = (vst_mode == ESW_VST_MODE_STEERING && !vport->info.spoofchk);
+	if (!push_on_any_pkt)
+		spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+
+	/* Create ingress allow rule */
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	if (vst_mode == ESW_VST_MODE_STEERING && (vport->info.vlan || vport->info.qos)) {
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
+		flow_act.vlan[0].prio = vport->info.qos;
+		flow_act.vlan[0].vid = vport->info.vlan;
+		flow_act.vlan[0].ethtype = vport->info.vlan_proto;
+	}
+
+	if (vst_mode == ESW_VST_MODE_BASIC && (vport->info.vlan || vport->info.qos))
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvlan_tag);
 
 	if (vport->info.spoofchk) {
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
@@ -147,9 +168,6 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		ether_addr_copy(smac_v, vport->info.mac);
 	}
 
-	/* Create ingress allow rule */
-	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	vport->ingress.allow_rule = mlx5_add_flow_rules(vport->ingress.acl, spec,
 							&flow_act, NULL, 0);
 	if (IS_ERR(vport->ingress.allow_rule)) {
@@ -161,6 +179,10 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		goto out;
 	}
 
+	if (push_on_any_pkt)
+		goto out;
+
+	memset(spec, 0, sizeof(*spec));
 	memset(&flow_act, 0, sizeof(flow_act));
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 	/* Attach drop flow counter */
@@ -187,7 +209,8 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 	return 0;
 
 out:
-	esw_acl_ingress_lgcy_cleanup(esw, vport);
+	if (err)
+		esw_acl_ingress_lgcy_cleanup(esw, vport);
 	kvfree(spec);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index bddf1086d771..6650ac72c801 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -431,8 +431,8 @@ int mlx5_esw_query_vport_drop_stats(struct mlx5_core_dev *dev,
 	return err;
 }
 
-int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
-				u16 vport, u16 vlan, u8 qos)
+int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw, u16 vport, u16 vlan,
+				u8 qos, u16 vlan_proto)
 {
 	u8 set_flags = 0;
 	int err = 0;
@@ -452,7 +452,7 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 		goto unlock;
 	}
 
-	err = __mlx5_eswitch_set_vport_vlan(esw, vport, vlan, qos, set_flags);
+	err = __mlx5_eswitch_set_vport_vlan(esw, vport, vlan, qos, vlan_proto, set_flags);
 
 unlock:
 	mutex_unlock(&esw->state_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 374e3fbdc2cf..9d4599a1b8a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -774,6 +774,7 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
 
 static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
+	enum esw_vst_mode vst_mode = esw_get_vst_mode(esw);
 	u16 vport_num = vport->vport;
 	int flags;
 	int err;
@@ -800,8 +801,9 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 
 	flags = (vport->info.vlan || vport->info.qos) ?
 		SET_VLAN_STRIP | SET_VLAN_INSERT : 0;
-	modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan,
-			       vport->info.qos, flags);
+	if (vst_mode == ESW_VST_MODE_BASIC)
+		modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan,
+				       vport->info.qos, flags);
 
 	return 0;
 }
@@ -990,6 +992,7 @@ static void mlx5_eswitch_clear_vf_vports_info(struct mlx5_eswitch *esw)
 		memset(&vport->qos, 0, sizeof(vport->qos));
 		memset(&vport->info, 0, sizeof(vport->info));
 		vport->info.link_state = MLX5_VPORT_ADMIN_STATE_AUTO;
+		vport->info.vlan_proto = ETH_P_8021Q;
 	}
 }
 
@@ -1790,6 +1793,7 @@ int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
 	ivi->linkstate = evport->info.link_state;
 	ivi->vlan = evport->info.vlan;
 	ivi->qos = evport->info.qos;
+	ivi->vlan_proto = htons(evport->info.vlan_proto);
 	ivi->spoofchk = evport->info.spoofchk;
 	ivi->trusted = evport->info.trusted;
 	if (evport->qos.enabled) {
@@ -1801,23 +1805,33 @@ int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
 	return 0;
 }
 
-int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
-				  u16 vport, u16 vlan, u8 qos, u8 set_flags)
+int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw, u16 vport, u16 vlan,
+				  u8 qos, u16 proto, u8 set_flags)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	enum esw_vst_mode vst_mode;
 	int err = 0;
 
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
 	if (vlan > 4095 || qos > 7)
 		return -EINVAL;
+	if (proto != ETH_P_8021Q && proto != ETH_P_8021AD)
+		return -EINVAL;
 
-	err = modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags);
-	if (err)
-		return err;
+	vst_mode = esw_get_vst_mode(esw);
+	if (proto == ETH_P_8021AD && vst_mode != ESW_VST_MODE_STEERING)
+		return -EPROTONOSUPPORT;
+
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS || vst_mode == ESW_VST_MODE_BASIC) {
+		err = modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags);
+		if (err)
+			return err;
+	}
 
 	evport->info.vlan = vlan;
 	evport->info.qos = qos;
+	evport->info.vlan_proto = proto;
 	if (evport->enabled && esw->mode == MLX5_ESWITCH_LEGACY) {
 		err = esw_acl_ingress_lgcy_setup(esw, evport);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index b7779826e725..6f368c0442bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -149,6 +149,7 @@ struct mlx5_vport_info {
 	u64                     node_guid;
 	int                     link_state;
 	u8                      qos;
+	u16			vlan_proto;
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
 };
@@ -371,7 +372,7 @@ int mlx5_eswitch_set_vport_mac(struct mlx5_eswitch *esw,
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state);
 int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
-				u16 vport, u16 vlan, u8 qos);
+				u16 vport, u16 vlan, u8 qos, u16 vlan_proto);
 int mlx5_eswitch_set_vport_spoofchk(struct mlx5_eswitch *esw,
 				    u16 vport, bool spoofchk);
 int mlx5_eswitch_set_vport_trust(struct mlx5_eswitch *esw,
@@ -513,8 +514,22 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 				 struct mlx5_flow_attr *attr);
 int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 				 struct mlx5_flow_attr *attr);
-int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
-				  u16 vport, u16 vlan, u8 qos, u8 set_flags);
+int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw, u16 vport, u16 vlan,
+				  u8 qos, u16 proto, u8 set_flags);
+
+enum esw_vst_mode {
+	ESW_VST_MODE_BASIC,
+	ESW_VST_MODE_STEERING,
+};
+
+static inline enum esw_vst_mode esw_get_vst_mode(struct mlx5_eswitch *esw)
+{
+	if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, pop_vlan) &&
+	    MLX5_CAP_ESW_INGRESS_ACL(esw->dev, push_vlan))
+		return ESW_VST_MODE_STEERING;
+
+	return ESW_VST_MODE_BASIC;
+}
 
 static inline bool mlx5_eswitch_vlan_actions_supported(struct mlx5_core_dev *dev,
 						       u8 vlan_depth)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index db1e282900aa..ab8465e75c39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -824,7 +824,8 @@ static int esw_set_global_vlan_pop(struct mlx5_eswitch *esw, u8 val)
 		if (atomic_read(&rep->rep_data[REP_ETH].state) != REP_LOADED)
 			continue;
 
-		err = __mlx5_eswitch_set_vport_vlan(esw, rep->vport, 0, 0, val);
+		err = __mlx5_eswitch_set_vport_vlan(esw, rep->vport, 0, 0,
+						    ETH_P_8021Q, val);
 		if (err)
 			goto out;
 	}
@@ -939,7 +940,8 @@ int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
 			goto skip_set_push;
 
 		err = __mlx5_eswitch_set_vport_vlan(esw, vport->vport, esw_attr->vlan_vid[0],
-						    0, SET_VLAN_INSERT | SET_VLAN_STRIP);
+						    0, ETH_P_8021Q,
+						    SET_VLAN_INSERT | SET_VLAN_STRIP);
 		if (err)
 			goto out;
 		vport->vlan = esw_attr->vlan_vid[0];
@@ -992,8 +994,8 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 			goto skip_unset_push;
 
 		vport->vlan = 0;
-		err = __mlx5_eswitch_set_vport_vlan(esw, vport->vport,
-						    0, 0, SET_VLAN_STRIP);
+		err = __mlx5_eswitch_set_vport_vlan(esw, vport->vport, 0, 0,
+						    ETH_P_8021Q, SET_VLAN_STRIP);
 		if (err)
 			goto out;
 	}
-- 
2.38.1

