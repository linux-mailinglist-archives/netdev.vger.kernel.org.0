Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFAC49EC88
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243306AbiA0UkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:40:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37668 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240140AbiA0UkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EF4A61983
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 20:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5E9C340E6;
        Thu, 27 Jan 2022 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643316011;
        bh=w00+Womgc+gxxQfQLLDKLOWul/7ItB819Ex2GBREH+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaRhu0R74GofDSFyGPy7h7yI/6oZsPwWiwKntbKgGjDucPjZTELhEdPa6EBWar8F9
         fsJl3jULkiM4Qgh26Ls3CErj5BV8so4/oLpcKrTK4JDxRU5nKXMvcgttLPKgcYtsoB
         vbWINHajs1ZDiJ4+Xw+yV3WvgvtmTiafieJTD6vO6D60G8cYkbCrC+rG6sNY1DHJJG
         JpeKLAxM8oIfH8y0Ge22aveDAHWqJzs4YiJtrE1bLyHDFfWAx8TSmRYd46UgNPGcDp
         zUylZlbU6Z9vBYS1infewNxo0mEHT4ITtMFutZxoGzRT/pKWWAZRr0Fu7999osGtlB
         PVlpB4kCC4UpQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next RESEND 02/17] net/mlx5e: Pass attr arg for attaching/detaching encaps
Date:   Thu, 27 Jan 2022 12:39:52 -0800
Message-Id: <20220127204007.146300-3-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127204007.146300-1-saeed@kernel.org>
References: <20220127204007.146300-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

In later commit that we will have multiple attr instances per flow
we would like to pass a specific attr instance to set encaps.

Currently the mlx5_flow object contains a single mlx5_attr instance.
However, multi table actions (e.g. CT) instantiate multiple attr instances.

Currently mlx5e_attach/detach_encap() reads the first attr instance
from the flow instance. Modify the functions to receive the attr
instance as a parameter which is set by the calling function.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 15 +++++++++------
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.h |  6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c   | 12 ++++++------
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 9918ed8c059b..c8cb173f1ffb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -488,12 +488,14 @@ static void mlx5e_detach_encap_route(struct mlx5e_priv *priv,
 				     int out_index);
 
 void mlx5e_detach_encap(struct mlx5e_priv *priv,
-			struct mlx5e_tc_flow *flow, int out_index)
+			struct mlx5e_tc_flow *flow,
+			struct mlx5_flow_attr *attr,
+			int out_index)
 {
 	struct mlx5e_encap_entry *e = flow->encaps[out_index].e;
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
-	if (flow->attr->esw_attr->dests[out_index].flags &
+	if (attr->esw_attr->dests[out_index].flags &
 	    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
 		mlx5e_detach_encap_route(priv, flow, out_index);
 
@@ -733,6 +735,7 @@ static unsigned int mlx5e_route_tbl_get_last_update(struct mlx5e_priv *priv)
 
 static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
+				    struct mlx5_flow_attr *attr,
 				    struct mlx5e_encap_entry *e,
 				    bool new_encap_entry,
 				    unsigned long tbl_time_before,
@@ -740,6 +743,7 @@ static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
 
 int mlx5e_attach_encap(struct mlx5e_priv *priv,
 		       struct mlx5e_tc_flow *flow,
+		       struct mlx5_flow_attr *attr,
 		       struct net_device *mirred_dev,
 		       int out_index,
 		       struct netlink_ext_ack *extack,
@@ -748,7 +752,6 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
-	struct mlx5_flow_attr *attr = flow->attr;
 	const struct ip_tunnel_info *tun_info;
 	unsigned long tbl_time_before = 0;
 	struct mlx5e_encap_entry *e;
@@ -834,8 +837,8 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	e->compl_result = 1;
 
 attach_flow:
-	err = mlx5e_attach_encap_route(priv, flow, e, entry_created, tbl_time_before,
-				       out_index);
+	err = mlx5e_attach_encap_route(priv, flow, attr, e, entry_created,
+				       tbl_time_before, out_index);
 	if (err)
 		goto out_err;
 
@@ -1198,6 +1201,7 @@ int mlx5e_attach_decap_route(struct mlx5e_priv *priv,
 
 static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
+				    struct mlx5_flow_attr *attr,
 				    struct mlx5e_encap_entry *e,
 				    bool new_encap_entry,
 				    unsigned long tbl_time_before,
@@ -1206,7 +1210,6 @@ static int mlx5e_attach_encap_route(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	unsigned long tbl_time_after = tbl_time_before;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
-	struct mlx5_flow_attr *attr = flow->attr;
 	const struct ip_tunnel_info *tun_info;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5e_route_entry *r;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
index 3391504d9a08..d542b8476491 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
@@ -7,15 +7,19 @@
 #include "tc_priv.h"
 
 void mlx5e_detach_encap(struct mlx5e_priv *priv,
-			struct mlx5e_tc_flow *flow, int out_index);
+			struct mlx5e_tc_flow *flow,
+			struct mlx5_flow_attr *attr,
+			int out_index);
 
 int mlx5e_attach_encap(struct mlx5e_priv *priv,
 		       struct mlx5e_tc_flow *flow,
+		       struct mlx5_flow_attr *attr,
 		       struct net_device *mirred_dev,
 		       int out_index,
 		       struct netlink_ext_ack *extack,
 		       struct net_device **encap_dev,
 		       bool *encap_valid);
+
 int mlx5e_attach_decap(struct mlx5e_priv *priv,
 		       struct mlx5e_tc_flow *flow,
 		       struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4fa9dbe26fcc..6f34eda35430 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1370,12 +1370,12 @@ int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
 static int
 set_encap_dests(struct mlx5e_priv *priv,
 		struct mlx5e_tc_flow *flow,
+		struct mlx5_flow_attr *attr,
 		struct netlink_ext_ack *extack,
 		bool *encap_valid,
 		bool *vf_tun)
 {
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
-	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct net_device *encap_dev = NULL;
 	struct mlx5e_rep_priv *rpriv;
@@ -1402,7 +1402,7 @@ set_encap_dests(struct mlx5e_priv *priv,
 			err = -ENODEV;
 			goto out;
 		}
-		err = mlx5e_attach_encap(priv, flow, out_dev, out_index,
+		err = mlx5e_attach_encap(priv, flow, attr, out_dev, out_index,
 					 extack, &encap_dev, encap_valid);
 		dev_put(out_dev);
 		if (err)
@@ -1432,9 +1432,9 @@ set_encap_dests(struct mlx5e_priv *priv,
 static void
 clean_encap_dests(struct mlx5e_priv *priv,
 		  struct mlx5e_tc_flow *flow,
+		  struct mlx5_flow_attr *attr,
 		  bool *vf_tun)
 {
-	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
 	int out_index;
 
@@ -1450,7 +1450,7 @@ clean_encap_dests(struct mlx5e_priv *priv,
 		    !esw_attr->dest_int_port)
 			*vf_tun = true;
 
-		mlx5e_detach_encap(priv, flow, out_index);
+		mlx5e_detach_encap(priv, flow, attr, out_index);
 		kfree(attr->parse_attr->tun_info[out_index]);
 	}
 }
@@ -1555,7 +1555,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		esw_attr->int_port = int_port;
 	}
 
-	err = set_encap_dests(priv, flow, extack, &encap_valid, &vf_tun);
+	err = set_encap_dests(priv, flow, attr, extack, &encap_valid, &vf_tun);
 	if (err)
 		goto err_out;
 
@@ -1651,7 +1651,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow->decap_route)
 		mlx5e_detach_decap_route(priv, flow);
 
-	clean_encap_dests(priv, flow, &vf_tun);
+	clean_encap_dests(priv, flow, attr, &vf_tun);
 
 	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
-- 
2.34.1

