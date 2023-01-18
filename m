Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2575672726
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjARSgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjARSgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37ECE5AA76
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C751D6199F
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CA3C433D2;
        Wed, 18 Jan 2023 18:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066977;
        bh=kDIwhhKwMQyr+J8Oy7B2PB/J/jLyCwreEIXNACLi7B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8qqW9ZmxANjMQ8BabY8Sw/OUT2+3troV2yHUk7jgfJmcoym2EIHUxI0/s6GTrcy+
         n4yH65iQ9RIbT3rNiQDamQQmU+nOpj2Mk5of8HCUSM60y+jP9ztCR7S6NIxkGH/2lw
         gRGoLkz4JgXtgmNJ+52Zht9sdn4Flp1BVYlst58p+ZddjTtsOiqBrHN92o+bmJZQFC
         Kf5jFoCjKZRzZcxVHJyuHWA72zyuJ13qFXaqVwo2QDAAtWkCPWfAN06cj2T+PEPMbT
         iAJszvVkxE/eAGwNXszNI46o8zEE1CKoqRf9dfHBw0NiJowMpezs3W6Hr5b56wBIQu
         /yZj2eN8Xtrow==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: TC, Use common function allocating flow mod hdr or encap mod hdr
Date:   Wed, 18 Jan 2023 10:35:57 -0800
Message-Id: <20230118183602.124323-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

Use mlx5e_tc_attach_mod_hdr() when allocating encap mod hdr and
remove mlx5e_tc_add_flow_mod_hdr() which is not being used now.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc_tun_encap.c      |  5 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 61 +++++--------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   | 10 ++-
 3 files changed, 25 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 2aaf8ab857b8..780224fd67a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1349,7 +1349,8 @@ static void mlx5e_invalidate_encap(struct mlx5e_priv *priv,
 			mlx5e_tc_unoffload_from_slow_path(esw, flow);
 		else
 			mlx5e_tc_unoffload_fdb_rules(esw, flow, flow->attr);
-		mlx5_modify_header_dealloc(priv->mdev, attr->modify_hdr);
+
+		mlx5e_tc_detach_mod_hdr(priv, flow, attr);
 		attr->modify_hdr = NULL;
 
 		esw_attr->dests[flow->tmp_entry_index].flags &=
@@ -1405,7 +1406,7 @@ static void mlx5e_reoffload_encap(struct mlx5e_priv *priv,
 			continue;
 		}
 
-		err = mlx5e_tc_add_flow_mod_hdr(priv, flow, attr);
+		err = mlx5e_tc_attach_mod_hdr(priv, flow, attr);
 		if (err) {
 			mlx5_core_warn(priv->mdev, "Failed to update flow mod_hdr err=%d",
 				       err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6a15d3e1741e..c978f4b12131 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -646,9 +646,9 @@ get_mod_hdr_table(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
 		&tc->mod_hdr;
 }
 
-static int mlx5e_tc_attach_mod_hdr(struct mlx5e_priv *priv,
-				   struct mlx5e_tc_flow *flow,
-				   struct mlx5_flow_attr *attr)
+int mlx5e_tc_attach_mod_hdr(struct mlx5e_priv *priv,
+			    struct mlx5e_tc_flow *flow,
+			    struct mlx5_flow_attr *attr)
 {
 	struct mlx5e_mod_hdr_handle *mh;
 
@@ -665,9 +665,9 @@ static int mlx5e_tc_attach_mod_hdr(struct mlx5e_priv *priv,
 	return 0;
 }
 
-static void mlx5e_tc_detach_mod_hdr(struct mlx5e_priv *priv,
-				    struct mlx5e_tc_flow *flow,
-				    struct mlx5_flow_attr *attr)
+void mlx5e_tc_detach_mod_hdr(struct mlx5e_priv *priv,
+			     struct mlx5e_tc_flow *flow,
+			     struct mlx5_flow_attr *attr)
 {
 	/* flow wasn't fully initialized */
 	if (!attr->mh)
@@ -1762,26 +1762,6 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 	return err;
 }
 
-int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow *flow,
-			      struct mlx5_flow_attr *attr)
-{
-	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
-	struct mlx5_modify_hdr *mod_hdr;
-
-	mod_hdr = mlx5_modify_header_alloc(priv->mdev,
-					   mlx5e_get_flow_namespace(flow),
-					   mod_hdr_acts->num_actions,
-					   mod_hdr_acts->actions);
-	if (IS_ERR(mod_hdr))
-		return PTR_ERR(mod_hdr);
-
-	WARN_ON(attr->modify_hdr);
-	attr->modify_hdr = mod_hdr;
-
-	return 0;
-}
-
 static int
 set_encap_dests(struct mlx5e_priv *priv,
 		struct mlx5e_tc_flow *flow,
@@ -1901,7 +1881,6 @@ verify_attr_actions(u32 actions, struct netlink_ext_ack *extack)
 static int
 post_process_attr(struct mlx5e_tc_flow *flow,
 		  struct mlx5_flow_attr *attr,
-		  bool is_post_act_attr,
 		  struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw = flow->priv->mdev->priv.eswitch;
@@ -1923,27 +1902,21 @@ post_process_attr(struct mlx5e_tc_flow *flow,
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		if (vf_tun || is_post_act_attr) {
-			err = mlx5e_tc_add_flow_mod_hdr(flow->priv, flow, attr);
-			if (err)
-				goto err_out;
-		} else {
-			err = mlx5e_tc_attach_mod_hdr(flow->priv, flow, attr);
-			if (err)
-				goto err_out;
-		}
+		err = mlx5e_tc_attach_mod_hdr(flow->priv, flow, attr);
+		if (err)
+			goto err_out;
 	}
 
 	if (attr->branch_true &&
 	    attr->branch_true->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		err = mlx5e_tc_add_flow_mod_hdr(flow->priv, flow, attr->branch_true);
+		err = mlx5e_tc_attach_mod_hdr(flow->priv, flow, attr->branch_true);
 		if (err)
 			goto err_out;
 	}
 
 	if (attr->branch_false &&
 	    attr->branch_false->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		err = mlx5e_tc_add_flow_mod_hdr(flow->priv, flow, attr->branch_false);
+		err = mlx5e_tc_attach_mod_hdr(flow->priv, flow, attr->branch_false);
 		if (err)
 			goto err_out;
 	}
@@ -2057,7 +2030,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		esw_attr->int_port = int_port;
 	}
 
-	err = post_process_attr(flow, attr, false, extack);
+	err = post_process_attr(flow, attr, extack);
 	if (err)
 		goto err_out;
 
@@ -2142,10 +2115,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
-		if (vf_tun && attr->modify_hdr)
-			mlx5_modify_header_dealloc(priv->mdev, attr->modify_hdr);
-		else
-			mlx5e_tc_detach_mod_hdr(priv, flow, attr);
+		mlx5e_tc_detach_mod_hdr(priv, flow, attr);
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
@@ -3964,7 +3934,7 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 		if (err)
 			goto out_free;
 
-		err = post_process_attr(flow, attr, true, extack);
+		err = post_process_attr(flow, attr, extack);
 		if (err)
 			goto out_free;
 
@@ -4531,8 +4501,7 @@ mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
-		if (attr->modify_hdr)
-			mlx5_modify_header_dealloc(flow->priv->mdev, attr->modify_hdr);
+		mlx5e_tc_detach_mod_hdr(flow->priv, flow, attr);
 	}
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 01d76ff67315..66e8d9d89082 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -287,9 +287,13 @@ int mlx5e_tc_match_to_reg_set_and_get_id(struct mlx5_core_dev *mdev,
 					 enum mlx5e_tc_attr_to_reg type,
 					 u32 data);
 
-int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow *flow,
-			      struct mlx5_flow_attr *attr);
+int mlx5e_tc_attach_mod_hdr(struct mlx5e_priv *priv,
+			    struct mlx5e_tc_flow *flow,
+			    struct mlx5_flow_attr *attr);
+
+void mlx5e_tc_detach_mod_hdr(struct mlx5e_priv *priv,
+			     struct mlx5e_tc_flow *flow,
+			     struct mlx5_flow_attr *attr);
 
 void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
 			    struct flow_match_basic *match, bool outer,
-- 
2.39.0

