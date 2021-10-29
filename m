Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22531440485
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhJ2U7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231614AbhJ2U7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADCD860F57;
        Fri, 29 Oct 2021 20:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541010;
        bh=anoOUU5JQ3+zs57SvL+uVax00T4jAkCQ1aRrnhnd4Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/BGcNaWrN8A96wr3CV7YydTWriN6PYZ14FQYo3sZcSG49ZuzIHi6cIGm75txGFa1
         DaQjrSLtriG+VN5i65bP/C1XU3/xjOzcc59WEneCW9MLD1lc71BUMYkw2DEl3jBTaM
         cDkCD+Vsf0B+h6VkDXr+C3T225mAA5mmuocX9Op8N8EThcR2uxkLA4ZrLcGS6xHrQp
         d1yytyzV53cDGZuTa+0LaeTKWdlbpABMifO2TqHTfXQtSlYrkW/3KmpT/b94+a/vCC
         zKNHvsu7kNZ5MdNo/1v3mMirdext4j8OhR80zVZ3X6Gr0wl3dTgYLDyaPFbcsZHkoA
         holf+j+SPKtRQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/14] net/mlx5: Support internal port as decap route device
Date:   Fri, 29 Oct 2021 13:56:32 -0700
Message-Id: <20211029205632.390403-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

When performing route device lookup for decap action, support
the case of ovs internal port as the lookup result.

In such case, an internal port struct is mapped and attached
to the flow attributes so that the source port matching of the
rule will match on the internal port's metadata value.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 29 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 24 +++++++++++++--
 2 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index c57180d030c7..a5e450973225 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -711,6 +711,7 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 			      struct mlx5_flow_attr *flow_attr)
 {
 	struct mlx5_esw_flow_attr *esw_attr = flow_attr->esw_attr;
+	struct mlx5e_tc_int_port *int_port;
 	TC_TUN_ROUTE_ATTR_INIT(attr);
 	u16 vport_num;
 	int err = 0;
@@ -735,17 +736,25 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	if (attr.route_dev->netdev_ops != &mlx5e_netdev_ops ||
-	    !mlx5e_tc_is_vf_tunnel(attr.out_dev, attr.route_dev))
-		goto out;
-
-	err = mlx5e_tc_query_route_vport(attr.out_dev, attr.route_dev, &vport_num);
-	if (err)
-		goto out;
+	if (attr.route_dev->netdev_ops == &mlx5e_netdev_ops &&
+	    mlx5e_tc_is_vf_tunnel(attr.out_dev, attr.route_dev)) {
+		err = mlx5e_tc_query_route_vport(attr.out_dev, attr.route_dev, &vport_num);
+		if (err)
+			goto out;
 
-	esw_attr->rx_tun_attr->vni = MLX5_GET(fte_match_param, spec->match_value,
-					      misc_parameters.vxlan_vni);
-	esw_attr->rx_tun_attr->decap_vport = vport_num;
+		esw_attr->rx_tun_attr->vni = MLX5_GET(fte_match_param, spec->match_value,
+						      misc_parameters.vxlan_vni);
+		esw_attr->rx_tun_attr->decap_vport = vport_num;
+	} else if (netif_is_ovs_master(attr.route_dev)) {
+		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
+						 attr.route_dev->ifindex,
+						 MLX5E_TC_INT_PORT_INGRESS);
+		if (IS_ERR(int_port)) {
+			err = PTR_ERR(int_port);
+			goto out;
+		}
+		esw_attr->int_port = int_port;
+	}
 
 out:
 	if (flow_attr->tun_ip_version == 4)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e11a906d70c7..835caa1c7b74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1401,6 +1401,9 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	int err = 0;
 	int out_index;
 
+	parse_attr = attr->parse_attr;
+	esw_attr = attr->esw_attr;
+
 	/* We check chain range only for tc flows.
 	 * For ft flows, we checked attr->chain was originally 0 and set it to
 	 * FDB_FT_CHAIN which is outside tc range.
@@ -1426,6 +1429,24 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		err = mlx5e_attach_decap_route(priv, flow);
 		if (err)
 			goto err_out;
+
+		if (!attr->chain && esw_attr->int_port) {
+			/* If decap route device is internal port, change the
+			 * source vport value in reg_c0 back to uplink just in
+			 * case the rule performs goto chain > 0. If we have a miss
+			 * on chain > 0 we want the metadata regs to hold the
+			 * chain id so SW will resume handling of this packet
+			 * from the proper chain.
+			 */
+			u32 metadata = mlx5_eswitch_get_vport_metadata_for_set(esw,
+									esw_attr->in_rep->vport);
+
+			err = mlx5e_tc_match_to_reg_set(priv->mdev, &parse_attr->mod_hdr_acts,
+							MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG,
+							metadata);
+			if (err)
+				return err;
+		}
 	}
 
 	if (flow_flag_test(flow, L3_TO_L2_DECAP)) {
@@ -1434,9 +1455,6 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 			goto err_out;
 	}
 
-	parse_attr = attr->parse_attr;
-	esw_attr = attr->esw_attr;
-
 	if (netif_is_ovs_master(parse_attr->filter_dev)) {
 		struct mlx5e_tc_int_port *int_port;
 
-- 
2.31.1

