Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CC6641961
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiLCWN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiLCWNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:13:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14181140C2
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 86DD8CE093C
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29F3C433C1;
        Sat,  3 Dec 2022 22:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105625;
        bh=fjKU3AW0EZymAbS2IlpPqXuf2Mz0yJ8SaBSmq6wl1hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDoPcev22DqZgjzpazHYbd0i57CCQvfrcm3h+HmH10g/Ru0uXJd0S8ZxqTMTA7Ugm
         /37qoCFV372w6mFuVF0j/NVi2PSfFs8NUMyoPM7Rf6wj6HHfZdu2L2jzHdr/3b+Xge
         fRw2amJxgV/8FVuGeMuDGOyafnpL4kD/i9z8cyecrhZDFO/QjkGJXU22ihXOO6THJk
         xly3XoAYmLMdP7IbSeoXXrwKcH1DbpPLn7qUlU2Q+EUBmlVSy8St/VQTjIfvhKXYit
         yLaGqmiJx87dvEBgAJVlujFsP3LOtnMLSkpy+uL04KySYWvDDKLSbGTK2OsEj5ydGn
         d0X/3Ii1gQizQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: TC, reuse flow attribute post parser processing
Date:   Sat,  3 Dec 2022 14:13:25 -0800
Message-Id: <20221203221337.29267-4-saeed@kernel.org>
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

After the tc action parsing phase the flow attribute is initialized with
relevant eswitch offload objects such as tunnel, vlan, header modify and
counter attributes. The post processing is done both for fdb and post-action
attributes.

Reuse the flow attribute post parsing logic by both fdb and post-action
offloads.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 96 ++++++++++---------
 1 file changed, 51 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 10d1609ece58..46222541e435 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -606,6 +606,12 @@ int mlx5e_get_flow_namespace(struct mlx5e_tc_flow *flow)
 		MLX5_FLOW_NAMESPACE_FDB : MLX5_FLOW_NAMESPACE_KERNEL;
 }
 
+static struct mlx5_core_dev *
+get_flow_counter_dev(struct mlx5e_tc_flow *flow)
+{
+	return mlx5e_is_eswitch_flow(flow) ? flow->attr->esw_attr->counter_dev : flow->priv->mdev;
+}
+
 static struct mod_hdr_tbl *
 get_mod_hdr_table(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
 {
@@ -1718,6 +1724,48 @@ clean_encap_dests(struct mlx5e_priv *priv,
 	}
 }
 
+static int
+post_process_attr(struct mlx5e_tc_flow *flow,
+		  struct mlx5_flow_attr *attr,
+		  bool is_post_act_attr,
+		  struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw = flow->priv->mdev->priv.eswitch;
+	bool vf_tun;
+	int err = 0;
+
+	err = set_encap_dests(flow->priv, flow, attr, extack, &vf_tun);
+	if (err)
+		goto err_out;
+
+	if (mlx5e_is_eswitch_flow(flow)) {
+		err = mlx5_eswitch_add_vlan_action(esw, attr);
+		if (err)
+			goto err_out;
+	}
+
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
+		if (vf_tun || is_post_act_attr) {
+			err = mlx5e_tc_add_flow_mod_hdr(flow->priv, flow, attr);
+			if (err)
+				goto err_out;
+		} else {
+			err = mlx5e_attach_mod_hdr(flow->priv, flow, attr->parse_attr);
+			if (err)
+				goto err_out;
+		}
+	}
+
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
+		err = alloc_flow_attr_counter(get_flow_counter_dev(flow), attr);
+		if (err)
+			goto err_out;
+	}
+
+err_out:
+	return err;
+}
+
 static int
 mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		      struct mlx5e_tc_flow *flow,
@@ -1728,7 +1776,6 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
 	u32 max_prio, max_chain;
-	bool vf_tun;
 	int err = 0;
 
 	parse_attr = attr->parse_attr;
@@ -1818,32 +1865,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		esw_attr->int_port = int_port;
 	}
 
-	err = set_encap_dests(priv, flow, attr, extack, &vf_tun);
-	if (err)
-		goto err_out;
-
-	err = mlx5_eswitch_add_vlan_action(esw, attr);
+	err = post_process_attr(flow, attr, false, extack);
 	if (err)
 		goto err_out;
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		if (vf_tun) {
-			err = mlx5e_tc_add_flow_mod_hdr(priv, flow, attr);
-			if (err)
-				goto err_out;
-		} else {
-			err = mlx5e_attach_mod_hdr(priv, flow, parse_attr);
-			if (err)
-				goto err_out;
-		}
-	}
-
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
-		err = alloc_flow_attr_counter(esw_attr->counter_dev, attr);
-		if (err)
-			goto err_out;
-	}
-
 	/* we get here if one of the following takes place:
 	 * (1) there's no error
 	 * (2) there's an encap action and we don't have valid neigh
@@ -3639,12 +3664,6 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	return attr2;
 }
 
-static struct mlx5_core_dev *
-get_flow_counter_dev(struct mlx5e_tc_flow *flow)
-{
-	return mlx5e_is_eswitch_flow(flow) ? flow->attr->esw_attr->counter_dev : flow->priv->mdev;
-}
-
 struct mlx5_flow_attr *
 mlx5e_tc_get_encap_attr(struct mlx5e_tc_flow *flow)
 {
@@ -3754,7 +3773,6 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 	struct mlx5e_post_act *post_act = get_post_action(flow->priv);
 	struct mlx5_flow_attr *attr, *next_attr = NULL;
 	struct mlx5e_post_act_handle *handle;
-	bool vf_tun;
 	int err;
 
 	/* This is going in reverse order as needed.
@@ -3776,26 +3794,14 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 		if (list_is_last(&attr->list, &flow->attrs))
 			break;
 
-		err = set_encap_dests(flow->priv, flow, attr, extack, &vf_tun);
+		err = actions_prepare_mod_hdr_actions(flow->priv, flow, attr, extack);
 		if (err)
 			goto out_free;
 
-		err = actions_prepare_mod_hdr_actions(flow->priv, flow, attr, extack);
+		err = post_process_attr(flow, attr, true, extack);
 		if (err)
 			goto out_free;
 
-		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-			err = mlx5e_tc_add_flow_mod_hdr(flow->priv, flow, attr);
-			if (err)
-				goto out_free;
-		}
-
-		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT) {
-			err = alloc_flow_attr_counter(get_flow_counter_dev(flow), attr);
-			if (err)
-				goto out_free;
-		}
-
 		handle = mlx5e_tc_post_act_add(post_act, attr);
 		if (IS_ERR(handle)) {
 			err = PTR_ERR(handle);
-- 
2.38.1

