Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E841F633352
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiKVC3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiKVC3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:29:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBA62E698
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51BEBB818E7
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2174C4347C;
        Tue, 22 Nov 2022 02:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084113;
        bh=l7lMCc7nIduqLlFkD3OnU0L7nz1B45qtdwrfCh5Yn1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keQBwTD2IygGOHyo9ezjKH715U8t1Kti81t50XDCzwmOgZbwkRbfrDp5AkmQNzKeJ
         s76CMgElBAP0t1HErk82U2wyhbp181ZahbaFlvIEFyZSarRnb2IH7xpvl5y0P/Vj8s
         bvVEwqTD/ODft1oDdFr7sChTczIbD/E1kz3nEMhYRqbO7+p6VGussbnajEyTVkxp5E
         PTXVnl/Hw70MavMQ7AqT+WbOwXF4rFA7X3Tw8K3vnHO4eD7l3cCS7X/xA0FKhK/ao0
         N8PSDwWJDfhQmkJSALV7iUlaysoY5KWf1H3XNPB8dSu/Dps1I1zIrTbAGCAxvHsyBu
         3ErZY7H/P5ROQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net 10/14] net/mlx5e: Offload rule only when all encaps are valid
Date:   Mon, 21 Nov 2022 18:25:55 -0800
Message-Id: <20221122022559.89459-11-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
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

From: Chris Mi <cmi@nvidia.com>

The cited commit adds a for loop to support multiple encapsulations.
But it only checks if the last encap is valid.

Fix it by setting slow path flag when one of the encap is invalid.

Fixes: f493f15534ec ("net/mlx5e: Move flow attr reformat action bit to per dest flags")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc_tun_encap.c        |  6 ++----
 .../mellanox/mlx5/core/en/tc_tun_encap.h        |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 17 ++++++-----------
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 5b6a79d2034e..ff73d25bc6eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -764,8 +764,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 		       struct net_device *mirred_dev,
 		       int out_index,
 		       struct netlink_ext_ack *extack,
-		       struct net_device **encap_dev,
-		       bool *encap_valid)
+		       struct net_device **encap_dev)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
@@ -880,9 +879,8 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	if (e->flags & MLX5_ENCAP_ENTRY_VALID) {
 		attr->esw_attr->dests[out_index].pkt_reformat = e->pkt_reformat;
 		attr->esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
-		*encap_valid = true;
 	} else {
-		*encap_valid = false;
+		flow_flag_set(flow, SLOW);
 	}
 	mutex_unlock(&esw->offloads.encap_tbl_lock);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
index d542b8476491..8ad273dde40e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
@@ -17,8 +17,7 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 		       struct net_device *mirred_dev,
 		       int out_index,
 		       struct netlink_ext_ack *extack,
-		       struct net_device **encap_dev,
-		       bool *encap_valid);
+		       struct net_device **encap_dev);
 
 int mlx5e_attach_decap(struct mlx5e_priv *priv,
 		       struct mlx5e_tc_flow *flow,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 5a6aa61ec82a..bd9936af4582 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1634,7 +1634,6 @@ set_encap_dests(struct mlx5e_priv *priv,
 		struct mlx5e_tc_flow *flow,
 		struct mlx5_flow_attr *attr,
 		struct netlink_ext_ack *extack,
-		bool *encap_valid,
 		bool *vf_tun)
 {
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
@@ -1651,7 +1650,6 @@ set_encap_dests(struct mlx5e_priv *priv,
 	parse_attr = attr->parse_attr;
 	esw_attr = attr->esw_attr;
 	*vf_tun = false;
-	*encap_valid = true;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
 		struct net_device *out_dev;
@@ -1668,7 +1666,7 @@ set_encap_dests(struct mlx5e_priv *priv,
 			goto out;
 		}
 		err = mlx5e_attach_encap(priv, flow, attr, out_dev, out_index,
-					 extack, &encap_dev, encap_valid);
+					 extack, &encap_dev);
 		dev_put(out_dev);
 		if (err)
 			goto out;
@@ -1732,8 +1730,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
-	bool vf_tun, encap_valid;
 	u32 max_prio, max_chain;
+	bool vf_tun;
 	int err = 0;
 
 	parse_attr = attr->parse_attr;
@@ -1823,7 +1821,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		esw_attr->int_port = int_port;
 	}
 
-	err = set_encap_dests(priv, flow, attr, extack, &encap_valid, &vf_tun);
+	err = set_encap_dests(priv, flow, attr, extack, &vf_tun);
 	if (err)
 		goto err_out;
 
@@ -1853,7 +1851,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	 * (1) there's no error
 	 * (2) there's an encap action and we don't have valid neigh
 	 */
-	if (!encap_valid || flow_flag_test(flow, SLOW))
+	if (flow_flag_test(flow, SLOW))
 		flow->rule[0] = mlx5e_tc_offload_to_slow_path(esw, flow, &parse_attr->spec);
 	else
 		flow->rule[0] = mlx5e_tc_offload_fdb_rules(esw, flow, &parse_attr->spec, attr);
@@ -3759,7 +3757,7 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 	struct mlx5e_post_act *post_act = get_post_action(flow->priv);
 	struct mlx5_flow_attr *attr, *next_attr = NULL;
 	struct mlx5e_post_act_handle *handle;
-	bool vf_tun, encap_valid = true;
+	bool vf_tun;
 	int err;
 
 	/* This is going in reverse order as needed.
@@ -3781,13 +3779,10 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 		if (list_is_last(&attr->list, &flow->attrs))
 			break;
 
-		err = set_encap_dests(flow->priv, flow, attr, extack, &encap_valid, &vf_tun);
+		err = set_encap_dests(flow->priv, flow, attr, extack, &vf_tun);
 		if (err)
 			goto out_free;
 
-		if (!encap_valid)
-			flow_flag_set(flow, SLOW);
-
 		err = actions_prepare_mod_hdr_actions(flow->priv, flow, attr, extack);
 		if (err)
 			goto out_free;
-- 
2.38.1

