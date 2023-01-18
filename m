Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52683672724
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjARSga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjARSgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440295AB55
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFDBE619A2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270F9C433D2;
        Wed, 18 Jan 2023 18:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066975;
        bh=qKaf9DQSorUq/kI2bCQi4CHkWf88Dh1yWDi9j7CboTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKVslZZUrSraGvIYf5/g1/EWSfxkFNo6oLo/yivX1JbrQeGzg/OLFyHwZpm4R6EDD
         MVVVI5seaGuJcR+clM9CwKTF7WxM434W1e03I2e9PkwQwfjqie0DEm+JyPxLl9o6rl
         v4bsMrre72CkTlzrgWad3zeFQn1B5d1QwygZFKoBrgXasmluMsJ3hnbXFKyxj4Yn1k
         6Mky/C3XoGuOdQMzgANCdf70pchES39Zub2AYQUhxCrrZsGz4AAfe0+AEvwBk5oKpw
         y3upGpx/tWLhfvOqLWJXUfHZW/ezgWQP7KIWTDJtd5xu6nDwj3zznW93XMEpR7cPel
         T4BhWfghBpzxA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: TC, Pass flow attr to attach/detach mod hdr functions
Date:   Wed, 18 Jan 2023 10:35:55 -0800
Message-Id: <20230118183602.124323-9-saeed@kernel.org>
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

In preparation to remove duplicate functions handling mod hdr allocation
and the fact that modify hdr should be per flow attr and not flow
pass flow attr to the attach and detach mod hdr funcs.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  2 -
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 41 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  2 +
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 2b7fd1c0e643..f575646d2f50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -95,8 +95,6 @@ struct mlx5e_tc_flow {
 	 */
 	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5e_tc_flow *peer_flow;
-	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
-	struct mlx5e_mod_hdr_handle *slow_mh; /* attached mod header instance for slow path */
 	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
 	struct list_head hairpin; /* flows sharing the same hairpin */
 	struct list_head peer;    /* flows with peer flow */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0c04a5e7c274..455c178f4115 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -648,34 +648,34 @@ get_mod_hdr_table(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
 
 static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
 				struct mlx5e_tc_flow *flow,
-				struct mlx5e_tc_flow_parse_attr *parse_attr)
+				struct mlx5_flow_attr *attr)
 {
-	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5e_mod_hdr_handle *mh;
 
 	mh = mlx5e_mod_hdr_attach(priv->mdev, get_mod_hdr_table(priv, flow),
 				  mlx5e_get_flow_namespace(flow),
-				  &parse_attr->mod_hdr_acts);
+				  &attr->parse_attr->mod_hdr_acts);
 	if (IS_ERR(mh))
 		return PTR_ERR(mh);
 
-	modify_hdr = mlx5e_mod_hdr_get(mh);
-	flow->attr->modify_hdr = modify_hdr;
-	flow->mh = mh;
+	WARN_ON(attr->modify_hdr);
+	attr->modify_hdr = mlx5e_mod_hdr_get(mh);
+	attr->mh = mh;
 
 	return 0;
 }
 
 static void mlx5e_detach_mod_hdr(struct mlx5e_priv *priv,
-				 struct mlx5e_tc_flow *flow)
+				 struct mlx5e_tc_flow *flow,
+				 struct mlx5_flow_attr *attr)
 {
 	/* flow wasn't fully initialized */
-	if (!flow->mh)
+	if (!attr->mh)
 		return;
 
 	mlx5e_mod_hdr_detach(priv->mdev, get_mod_hdr_table(priv, flow),
-			     flow->mh);
-	flow->mh = NULL;
+			     attr->mh);
+	attr->mh = NULL;
 }
 
 static
@@ -1433,7 +1433,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
+		err = mlx5e_attach_mod_hdr(priv, flow, attr);
 		if (err)
 			return err;
 	}
@@ -1493,7 +1493,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
 		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
-		mlx5e_detach_mod_hdr(priv, flow);
+		mlx5e_detach_mod_hdr(priv, flow, attr);
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
@@ -1604,7 +1604,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 		goto err_offload;
 	}
 
-	flow->slow_mh = mh;
+	flow->attr->slow_mh = mh;
 	flow->chain_mapping = chain_mapping;
 	flow_flag_set(flow, SLOW);
 
@@ -1629,6 +1629,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 void mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 				       struct mlx5e_tc_flow *flow)
 {
+	struct mlx5e_mod_hdr_handle *slow_mh = flow->attr->slow_mh;
 	struct mlx5_flow_attr *slow_attr;
 
 	slow_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
@@ -1641,16 +1642,16 @@ void mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	slow_attr->esw_attr->split_count = 0;
 	slow_attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
-	if (flow->slow_mh) {
+	if (slow_mh) {
 		slow_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-		slow_attr->modify_hdr = mlx5e_mod_hdr_get(flow->slow_mh);
+		slow_attr->modify_hdr = mlx5e_mod_hdr_get(slow_mh);
 	}
 	mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
-	if (flow->slow_mh) {
-		mlx5e_mod_hdr_detach(esw->dev, get_mod_hdr_table(flow->priv, flow), flow->slow_mh);
+	if (slow_mh) {
+		mlx5e_mod_hdr_detach(esw->dev, get_mod_hdr_table(flow->priv, flow), slow_mh);
 		mlx5_chains_put_chain_mapping(esw_chains(esw), flow->chain_mapping);
 		flow->chain_mapping = 0;
-		flow->slow_mh = NULL;
+		flow->attr->slow_mh = NULL;
 	}
 	flow_flag_clear(flow, SLOW);
 	kfree(slow_attr);
@@ -1927,7 +1928,7 @@ post_process_attr(struct mlx5e_tc_flow *flow,
 			if (err)
 				goto err_out;
 		} else {
-			err = mlx5e_attach_mod_hdr(flow->priv, flow, attr->parse_attr);
+			err = mlx5e_attach_mod_hdr(flow->priv, flow, attr);
 			if (err)
 				goto err_out;
 		}
@@ -2144,7 +2145,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 		if (vf_tun && attr->modify_hdr)
 			mlx5_modify_header_dealloc(priv->mdev, attr->modify_hdr);
 		else
-			mlx5e_detach_mod_hdr(priv, flow);
+			mlx5e_detach_mod_hdr(priv, flow, attr);
 	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 50af70ef22f3..01d76ff67315 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -71,6 +71,8 @@ struct mlx5_flow_attr {
 	u32 action;
 	struct mlx5_fc *counter;
 	struct mlx5_modify_hdr *modify_hdr;
+	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
+	struct mlx5e_mod_hdr_handle *slow_mh; /* attached mod header instance for slow path */
 	struct mlx5_ct_attr ct_attr;
 	struct mlx5e_sample_attr sample_attr;
 	struct mlx5e_meter_attr meter_attr;
-- 
2.39.0

