Return-Path: <netdev+bounces-5201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04FEC71036D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF31B280AB0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61B819C;
	Thu, 25 May 2023 03:48:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078A61FB0
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4B0C4339B;
	Thu, 25 May 2023 03:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986531;
	bh=0xm1L54qxznsVzr5+vwMxIlPbtw6i1OitlGv/CKCXEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OL3kVlQD/JciQr6N66Z8ph4Qj9BV18NROEpEVvXa/XYvlbpKHnsmyPBdUhzAQN4Oi
	 BVYfdsyoe6Qef9d2ef8lCZijQIWfX0IKTtAsBUU7uK2tVnv+XvJtn7471pr7TnQozH
	 KZ58qth/IdlSYzQ4tmwwwq6OfFCAZ33UtPhFmi7PHbrdIDpSXGzuwTdbVBiUcfy3pT
	 ynTZ6IqMi6Kgww+u+LAd8cyjtRdQLye4cBS8OgB4AvuazPh59avc5qKAJqeC/RlLVZ
	 slKU3S/T61q2cMJFNZhWXI69W1pMURhAgJABVgFGvvQl+EL/wVqEIL9CCojEFKIsuL
	 xkwglbsYcSozA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Chris Mi <cmi@nvidia.com>
Subject: [net 01/17] net/mlx5e: Extract remaining tunnel encap code to dedicated file
Date: Wed, 24 May 2023 20:48:31 -0700
Message-Id: <20230525034847.99268-2-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

Move set_encap_dests() and clean_encap_dests() to the tunnel encap
dedicated file. And rename them to mlx5e_tc_tun_encap_dests_set()
and mlx5e_tc_tun_encap_dests_unset().

No functional change in this patch. It is needed in the next patch.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 83 +++++++++++++++++
 .../mellanox/mlx5/core/en/tc_tun_encap.h      |  9 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 89 +------------------
 3 files changed, 94 insertions(+), 87 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 6a052c6cfc15..d516227b8fe8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1016,6 +1016,89 @@ int mlx5e_attach_decap(struct mlx5e_priv *priv,
 	return err;
 }
 
+int mlx5e_tc_tun_encap_dests_set(struct mlx5e_priv *priv,
+				 struct mlx5e_tc_flow *flow,
+				 struct mlx5_flow_attr *attr,
+				 struct netlink_ext_ack *extack,
+				 bool *vf_tun)
+{
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5_esw_flow_attr *esw_attr;
+	struct net_device *encap_dev = NULL;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_priv *out_priv;
+	int out_index;
+	int err = 0;
+
+	if (!mlx5e_is_eswitch_flow(flow))
+		return 0;
+
+	parse_attr = attr->parse_attr;
+	esw_attr = attr->esw_attr;
+	*vf_tun = false;
+
+	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
+		struct net_device *out_dev;
+		int mirred_ifindex;
+
+		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
+			continue;
+
+		mirred_ifindex = parse_attr->mirred_ifindex[out_index];
+		out_dev = dev_get_by_index(dev_net(priv->netdev), mirred_ifindex);
+		if (!out_dev) {
+			NL_SET_ERR_MSG_MOD(extack, "Requested mirred device not found");
+			err = -ENODEV;
+			goto out;
+		}
+		err = mlx5e_attach_encap(priv, flow, attr, out_dev, out_index,
+					 extack, &encap_dev);
+		dev_put(out_dev);
+		if (err)
+			goto out;
+
+		if (esw_attr->dests[out_index].flags &
+		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE &&
+		    !esw_attr->dest_int_port)
+			*vf_tun = true;
+
+		out_priv = netdev_priv(encap_dev);
+		rpriv = out_priv->ppriv;
+		esw_attr->dests[out_index].rep = rpriv->rep;
+		esw_attr->dests[out_index].mdev = out_priv->mdev;
+	}
+
+	if (*vf_tun && esw_attr->out_count > 1) {
+		NL_SET_ERR_MSG_MOD(extack, "VF tunnel encap with mirroring is not supported");
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+out:
+	return err;
+}
+
+void mlx5e_tc_tun_encap_dests_unset(struct mlx5e_priv *priv,
+				    struct mlx5e_tc_flow *flow,
+				    struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr;
+	int out_index;
+
+	if (!mlx5e_is_eswitch_flow(flow))
+		return;
+
+	esw_attr = attr->esw_attr;
+
+	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
+		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
+			continue;
+
+		mlx5e_detach_encap(flow->priv, flow, attr, out_index);
+		kfree(attr->parse_attr->tun_info[out_index]);
+	}
+}
+
 static int cmp_route_info(struct mlx5e_route_key *a,
 			  struct mlx5e_route_key *b)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
index 8ad273dde40e..5d7d67687cbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
@@ -30,6 +30,15 @@ int mlx5e_attach_decap_route(struct mlx5e_priv *priv,
 void mlx5e_detach_decap_route(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow);
 
+int mlx5e_tc_tun_encap_dests_set(struct mlx5e_priv *priv,
+				 struct mlx5e_tc_flow *flow,
+				 struct mlx5_flow_attr *attr,
+				 struct netlink_ext_ack *extack,
+				 bool *vf_tun);
+void mlx5e_tc_tun_encap_dests_unset(struct mlx5e_priv *priv,
+				    struct mlx5e_tc_flow *flow,
+				    struct mlx5_flow_attr *attr);
+
 struct ip_tunnel_info *mlx5e_dup_tun_info(const struct ip_tunnel_info *tun_info);
 
 int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e95414ef1f04..8935156f8f4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1699,91 +1699,6 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 	return mlx5_eswitch_vhca_id_to_vport(esw, vhca_id, vport);
 }
 
-static int
-set_encap_dests(struct mlx5e_priv *priv,
-		struct mlx5e_tc_flow *flow,
-		struct mlx5_flow_attr *attr,
-		struct netlink_ext_ack *extack,
-		bool *vf_tun)
-{
-	struct mlx5e_tc_flow_parse_attr *parse_attr;
-	struct mlx5_esw_flow_attr *esw_attr;
-	struct net_device *encap_dev = NULL;
-	struct mlx5e_rep_priv *rpriv;
-	struct mlx5e_priv *out_priv;
-	int out_index;
-	int err = 0;
-
-	if (!mlx5e_is_eswitch_flow(flow))
-		return 0;
-
-	parse_attr = attr->parse_attr;
-	esw_attr = attr->esw_attr;
-	*vf_tun = false;
-
-	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
-		struct net_device *out_dev;
-		int mirred_ifindex;
-
-		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
-			continue;
-
-		mirred_ifindex = parse_attr->mirred_ifindex[out_index];
-		out_dev = dev_get_by_index(dev_net(priv->netdev), mirred_ifindex);
-		if (!out_dev) {
-			NL_SET_ERR_MSG_MOD(extack, "Requested mirred device not found");
-			err = -ENODEV;
-			goto out;
-		}
-		err = mlx5e_attach_encap(priv, flow, attr, out_dev, out_index,
-					 extack, &encap_dev);
-		dev_put(out_dev);
-		if (err)
-			goto out;
-
-		if (esw_attr->dests[out_index].flags &
-		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE &&
-		    !esw_attr->dest_int_port)
-			*vf_tun = true;
-
-		out_priv = netdev_priv(encap_dev);
-		rpriv = out_priv->ppriv;
-		esw_attr->dests[out_index].rep = rpriv->rep;
-		esw_attr->dests[out_index].mdev = out_priv->mdev;
-	}
-
-	if (*vf_tun && esw_attr->out_count > 1) {
-		NL_SET_ERR_MSG_MOD(extack, "VF tunnel encap with mirroring is not supported");
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-out:
-	return err;
-}
-
-static void
-clean_encap_dests(struct mlx5e_priv *priv,
-		  struct mlx5e_tc_flow *flow,
-		  struct mlx5_flow_attr *attr)
-{
-	struct mlx5_esw_flow_attr *esw_attr;
-	int out_index;
-
-	if (!mlx5e_is_eswitch_flow(flow))
-		return;
-
-	esw_attr = attr->esw_attr;
-
-	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
-		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
-			continue;
-
-		mlx5e_detach_encap(priv, flow, attr, out_index);
-		kfree(attr->parse_attr->tun_info[out_index]);
-	}
-}
-
 static int
 verify_attr_actions(u32 actions, struct netlink_ext_ack *extack)
 {
@@ -1820,7 +1735,7 @@ post_process_attr(struct mlx5e_tc_flow *flow,
 	if (err)
 		goto err_out;
 
-	err = set_encap_dests(flow->priv, flow, attr, extack, &vf_tun);
+	err = mlx5e_tc_tun_encap_dests_set(flow->priv, flow, attr, extack, &vf_tun);
 	if (err)
 		goto err_out;
 
@@ -4324,7 +4239,7 @@ mlx5_free_flow_attr_actions(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *a
 	if (attr->post_act_handle)
 		mlx5e_tc_post_act_del(get_post_action(flow->priv), attr->post_act_handle);
 
-	clean_encap_dests(flow->priv, flow, attr);
+	mlx5e_tc_tun_encap_dests_unset(flow->priv, flow, attr);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(counter_dev, attr->counter);
-- 
2.40.1


