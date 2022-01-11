Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2168848A533
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344452AbiAKBnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344366AbiAKBnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19429C061748
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 17:43:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A427461495
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACA8C36AED;
        Tue, 11 Jan 2022 01:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865426;
        bh=FFxvrlg7nO58X0M/2GyvTpjkXR/2ZrDK8HzBxBKTxZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQOYpCYRytW84gKx/gLARhqxuwwsh3J4JGfjh7rSKsFB8+ehS9tDsy17dW8bQ8cyY
         nSX5RA4fsMTB45zqImDMYH0odRxBg92PdoOYlWp6ZQTn4hIYMxIRmjE1We+C5LELph
         w6qTzwP5eiJvp1T3E2vanRDZPM0vmfk+MKz2iGfx9IihITwlgSE6Tl9zDc/DRTKxyL
         hC6KgPY+hlUEbjBt0LK7mu3XEaVkOuW74WLyMu4G/AsF0GMzvLC2pAZp1ss+jfayDV
         FB2aOoHi6vd2z0f5Q/1V949eVPY5ARaUpAkV3EXDqLElI4jaS847NHYa54DNqmOHFY
         mZBMJKH1WMznw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/17] net/mlx5e: Move code chunk setting encap dests into its own function
Date:   Mon, 10 Jan 2022 17:43:20 -0800
Message-Id: <20220111014335.178121-3-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Split setting encap dests code chunk out of mlx5e_tc_add_fdb_flow()
to make the function smaller for maintainability and reuse.
For symmetry do the same for mlx5e_tc_del_fdb_flow().
While at it refactor cleanup to first check for encap flag like
done when setting encap dests.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 144 +++++++++++-------
 1 file changed, 93 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3d908a7e1406..4fa9dbe26fcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1367,6 +1367,94 @@ int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static int
+set_encap_dests(struct mlx5e_priv *priv,
+		struct mlx5e_tc_flow *flow,
+		struct netlink_ext_ack *extack,
+		bool *encap_valid,
+		bool *vf_tun)
+{
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
+	struct mlx5_esw_flow_attr *esw_attr;
+	struct net_device *encap_dev = NULL;
+	struct mlx5e_rep_priv *rpriv;
+	struct mlx5e_priv *out_priv;
+	int out_index;
+	int err = 0;
+
+	parse_attr = attr->parse_attr;
+	esw_attr = attr->esw_attr;
+	*vf_tun = false;
+	*encap_valid = true;
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
+		err = mlx5e_attach_encap(priv, flow, out_dev, out_index,
+					 extack, &encap_dev, encap_valid);
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
+static void
+clean_encap_dests(struct mlx5e_priv *priv,
+		  struct mlx5e_tc_flow *flow,
+		  bool *vf_tun)
+{
+	struct mlx5_flow_attr *attr = flow->attr;
+	struct mlx5_esw_flow_attr *esw_attr;
+	int out_index;
+
+	esw_attr = attr->esw_attr;
+	*vf_tun = false;
+
+	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
+		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
+			continue;
+
+		if (esw_attr->dests[out_index].flags &
+		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE &&
+		    !esw_attr->dest_int_port)
+			*vf_tun = true;
+
+		mlx5e_detach_encap(priv, flow, out_index);
+		kfree(attr->parse_attr->tun_info[out_index]);
+	}
+}
+
 static int
 mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		      struct mlx5e_tc_flow *flow,
@@ -1375,15 +1463,11 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
-	bool vf_tun = false, encap_valid = true;
-	struct net_device *encap_dev = NULL;
 	struct mlx5_esw_flow_attr *esw_attr;
-	struct mlx5e_rep_priv *rpriv;
-	struct mlx5e_priv *out_priv;
+	bool vf_tun, encap_valid;
 	struct mlx5_fc *counter;
 	u32 max_prio, max_chain;
 	int err = 0;
-	int out_index;
 
 	parse_attr = attr->parse_attr;
 	esw_attr = attr->esw_attr;
@@ -1471,41 +1555,9 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		esw_attr->int_port = int_port;
 	}
 
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
-			goto err_out;
-		}
-		err = mlx5e_attach_encap(priv, flow, out_dev, out_index,
-					 extack, &encap_dev, &encap_valid);
-		dev_put(out_dev);
-		if (err)
-			goto err_out;
-
-		if (esw_attr->dests[out_index].flags &
-		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE &&
-		    !esw_attr->dest_int_port)
-			vf_tun = true;
-		out_priv = netdev_priv(encap_dev);
-		rpriv = out_priv->ppriv;
-		esw_attr->dests[out_index].rep = rpriv->rep;
-		esw_attr->dests[out_index].mdev = out_priv->mdev;
-	}
-
-	if (vf_tun && esw_attr->out_count > 1) {
-		NL_SET_ERR_MSG_MOD(extack, "VF tunnel encap with mirroring is not supported");
-		err = -EOPNOTSUPP;
+	err = set_encap_dests(priv, flow, extack, &encap_valid, &vf_tun);
+	if (err)
 		goto err_out;
-	}
 
 	err = mlx5_eswitch_add_vlan_action(esw, attr);
 	if (err)
@@ -1575,8 +1627,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
-	bool vf_tun = false;
-	int out_index;
+	bool vf_tun;
 
 	esw_attr = attr->esw_attr;
 	mlx5e_put_flow_tunnel_id(flow);
@@ -1600,16 +1651,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow->decap_route)
 		mlx5e_detach_decap_route(priv, flow);
 
-	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
-		if (esw_attr->dests[out_index].flags &
-		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE &&
-		    !esw_attr->dest_int_port)
-			vf_tun = true;
-		if (esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP) {
-			mlx5e_detach_encap(priv, flow, out_index);
-			kfree(attr->parse_attr->tun_info[out_index]);
-		}
-	}
+	clean_encap_dests(priv, flow, &vf_tun);
 
 	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
-- 
2.34.1

