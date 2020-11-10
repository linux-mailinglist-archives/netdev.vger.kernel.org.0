Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA222AD2CE
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbgKJJuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:39 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53537 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730893AbgKJJug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 25AE0DE4;
        Tue, 10 Nov 2020 04:50:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Sj/guht9kisiWqgWo9U+AEbVy5QWsGCVeWipdTxH9zE=; b=FVks8Jl/
        zbPS2srr5XW61/gcMhE9dxjqKz01tWjTB35vevjJwz1R9s29VSCJ/3djNzy9wNQm
        U8//jNdXCM1TrTKd2P9QDoSk5tcA335VCwGP1Jp31greg2p3oDuxsYaU/+8W1ACS
        YhHTvz7XCr2QP0lwG413f2PeGNuNlNYDVOJFLlOYp5l+UfM1d431PAQ3wB4mNf+Y
        YGychOLUlt3WxpHnZiT6xIXKOqpHGwBijH07aaKoPClIbOGvvLdyJ9j3X8cOXB2B
        mxR90SXziosN4Ax/8/5N2MhHqLkKwwVoNMbRhJcCY5F8vcBHMmpiJPyIasdkQu3Y
        03b1k+Zl62DF5g==
X-ME-Sender: <xms:amKqX401kp4r2ZrKg7hJuyDes39RbP0zZGh57rw7BUg72eBYr0n4-Q>
    <xme:amKqXzGXT8zOTtdqiCJaKfOgc-cpG3FI2jLDtPJB67xq5xlfsmCSjYcUbR_K9Vths
    wcLemyVDdu4yWU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:amKqXw6-RVaxursLcATQbfA653Uq6e8SuTIeDLva1v9Kl25vonP52g>
    <xmx:amKqXx3sPQII1weGenhoFsFg8bMfADI5AoHy8Gztal2PHmHCXZYmJA>
    <xmx:amKqX7Faf6NtzaqrmH6jdeKK9wHsIimFMMSSBiMDhIv29-pXqevSpQ>
    <xmx:amKqXwStHvTgKCOypgWHP9EVI3NCUolBv-nx_BnRQWfmyRsKjKJZMQ>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 92EF33280064;
        Tue, 10 Nov 2020 04:50:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/15] mlxsw: spectrum_router: Introduce fib_entry priv for low-level ops
Date:   Tue, 10 Nov 2020 11:48:58 +0200
Message-Id: <20201110094900.1920158-14-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Prepare for the low-level ops that need to store some data alongside
the fib_entry and introduce a per-fib_entry priv for ll ops.
The priv is reference counted as in the follow-up patch it is going
to be saved in pack() function and used later on in commit() even in
case the related fib_entry gets freed in the middle.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  12 +-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 185 ++++++++++++++----
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  20 +-
 4 files changed, 176 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 3cea9ee5910d..ab2e0eb26c1a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -186,19 +186,21 @@ mlxsw_sp_ipip_fib_entry_op_gre4_do(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				   u32 dip, u8 prefix_len, u16 ul_vr_id,
 				   enum mlxsw_sp_fib_entry_op op,
-				   u32 tunnel_index)
+				   u32 tunnel_index,
+				   struct mlxsw_sp_fib_entry_priv *priv)
 {
 	ll_ops->fib_entry_pack(op_ctx, MLXSW_SP_L3_PROTO_IPV4, op, ul_vr_id,
-			       prefix_len, (unsigned char *) &dip);
+			       prefix_len, (unsigned char *) &dip, priv);
 	ll_ops->fib_entry_act_ip2me_tun_pack(op_ctx, tunnel_index);
-	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
+	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
 }
 
 static int mlxsw_sp_ipip_fib_entry_op_gre4(struct mlxsw_sp *mlxsw_sp,
 					   const struct mlxsw_sp_router_ll_ops *ll_ops,
 					   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					   struct mlxsw_sp_ipip_entry *ipip_entry,
-					   enum mlxsw_sp_fib_entry_op op, u32 tunnel_index)
+					   enum mlxsw_sp_fib_entry_op op, u32 tunnel_index,
+					   struct mlxsw_sp_fib_entry_priv *priv)
 {
 	u16 ul_vr_id = mlxsw_sp_ipip_lb_ul_vr_id(ipip_entry->ol_lb);
 	__be32 dip;
@@ -212,7 +214,7 @@ static int mlxsw_sp_ipip_fib_entry_op_gre4(struct mlxsw_sp *mlxsw_sp,
 	dip = mlxsw_sp_ipip_netdev_saddr(MLXSW_SP_L3_PROTO_IPV4,
 					 ipip_entry->ol_dev).addr4;
 	return mlxsw_sp_ipip_fib_entry_op_gre4_do(mlxsw_sp, ll_ops, op_ctx, be32_to_cpu(dip),
-						  32, ul_vr_id, op, tunnel_index);
+						  32, ul_vr_id, op, tunnel_index, priv);
 }
 
 static bool mlxsw_sp_ipip_tunnel_complete(enum mlxsw_sp_l3proto proto,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index fe9a94362e61..00448cbac639 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -56,7 +56,8 @@ struct mlxsw_sp_ipip_ops {
 			    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 			    struct mlxsw_sp_ipip_entry *ipip_entry,
 			    enum mlxsw_sp_fib_entry_op op,
-			    u32 tunnel_index);
+			    u32 tunnel_index,
+			    struct mlxsw_sp_fib_entry_priv *priv);
 
 	int (*ol_netdev_change)(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_ipip_entry *ipip_entry,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 43a4b6a34940..9d3ead1ef561 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -368,12 +368,65 @@ struct mlxsw_sp_fib_entry_decap {
 	u32 tunnel_index;
 };
 
+static struct mlxsw_sp_fib_entry_priv *
+mlxsw_sp_fib_entry_priv_create(const struct mlxsw_sp_router_ll_ops *ll_ops)
+{
+	struct mlxsw_sp_fib_entry_priv *priv;
+
+	if (!ll_ops->fib_entry_priv_size)
+		/* No need to have priv */
+		return NULL;
+
+	priv = kzalloc(sizeof(*priv) + ll_ops->fib_entry_priv_size, GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+	refcount_set(&priv->refcnt, 1);
+	return priv;
+}
+
+static void
+mlxsw_sp_fib_entry_priv_destroy(struct mlxsw_sp_fib_entry_priv *priv)
+{
+	kfree(priv);
+}
+
+static void mlxsw_sp_fib_entry_priv_hold(struct mlxsw_sp_fib_entry_priv *priv)
+{
+	refcount_inc(&priv->refcnt);
+}
+
+static void mlxsw_sp_fib_entry_priv_put(struct mlxsw_sp_fib_entry_priv *priv)
+{
+	if (!priv || !refcount_dec_and_test(&priv->refcnt))
+		return;
+	mlxsw_sp_fib_entry_priv_destroy(priv);
+}
+
+static void mlxsw_sp_fib_entry_op_ctx_priv_hold(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+						struct mlxsw_sp_fib_entry_priv *priv)
+{
+	if (!priv)
+		return;
+	mlxsw_sp_fib_entry_priv_hold(priv);
+	list_add(&priv->list, &op_ctx->fib_entry_priv_list);
+}
+
+static void mlxsw_sp_fib_entry_op_ctx_priv_put_all(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
+{
+	struct mlxsw_sp_fib_entry_priv *priv, *tmp;
+
+	list_for_each_entry_safe(priv, tmp, &op_ctx->fib_entry_priv_list, list)
+		mlxsw_sp_fib_entry_priv_put(priv);
+	INIT_LIST_HEAD(&op_ctx->fib_entry_priv_list);
+}
+
 struct mlxsw_sp_fib_entry {
 	struct mlxsw_sp_fib_node *fib_node;
 	enum mlxsw_sp_fib_entry_type type;
 	struct list_head nexthop_group_node;
 	struct mlxsw_sp_nexthop_group *nh_group;
 	struct mlxsw_sp_fib_entry_decap decap; /* Valid for decap entries. */
+	struct mlxsw_sp_fib_entry_priv *priv;
 };
 
 struct mlxsw_sp_fib4_entry {
@@ -4316,7 +4369,8 @@ mlxsw_sp_router_ll_basic_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx
 					enum mlxsw_sp_l3proto proto,
 					enum mlxsw_sp_fib_entry_op op,
 					u16 virtual_router, u8 prefix_len,
-					unsigned char *addr)
+					unsigned char *addr,
+					struct mlxsw_sp_fib_entry_priv *priv)
 {
 	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
 	enum mlxsw_reg_ralxx_protocol ralxx_proto;
@@ -4390,7 +4444,8 @@ mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_tun_pack(struct mlxsw_sp_fib_entry_
 
 static int
 mlxsw_sp_router_ll_basic_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
-					  struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
+					  struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					  bool *postponed_for_bulk)
 {
 	struct mlxsw_sp_fib_entry_op_ctx_basic *op_ctx_basic = (void *) op_ctx->ll_priv;
 
@@ -4404,9 +4459,24 @@ static void mlxsw_sp_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 {
 	struct mlxsw_sp_fib *fib = fib_entry->fib_node->fib;
 
+	mlxsw_sp_fib_entry_op_ctx_priv_hold(op_ctx, fib_entry->priv);
 	fib->ll_ops->fib_entry_pack(op_ctx, fib->proto, op, fib->vr->id,
 				    fib_entry->fib_node->key.prefix_len,
-				    fib_entry->fib_node->key.addr);
+				    fib_entry->fib_node->key.addr,
+				    fib_entry->priv);
+}
+
+int mlxsw_sp_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
+			      struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+			      const struct mlxsw_sp_router_ll_ops *ll_ops)
+{
+	bool postponed_for_bulk = false;
+	int err;
+
+	err = ll_ops->fib_entry_commit(mlxsw_sp, op_ctx, &postponed_for_bulk);
+	if (!postponed_for_bulk)
+		mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
+	return err;
 }
 
 static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
@@ -4480,7 +4550,7 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	ll_ops->fib_entry_act_remote_pack(op_ctx, trap_action, trap_id,
 					  adjacency_index, ecmp_size);
-	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
+	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
 }
 
 static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
@@ -4504,7 +4574,7 @@ static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	ll_ops->fib_entry_act_local_pack(op_ctx, trap_action, trap_id, rif_index);
-	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
+	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
 }
 
 static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
@@ -4516,7 +4586,7 @@ static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	ll_ops->fib_entry_act_ip2me_pack(op_ctx);
-	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
+	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
 }
 
 static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
@@ -4530,7 +4600,7 @@ static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
 	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_DISCARD_ERROR;
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	ll_ops->fib_entry_act_local_pack(op_ctx, trap_action, 0, 0);
-	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
+	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
 }
 
 static int
@@ -4548,7 +4618,7 @@ mlxsw_sp_fib_entry_op_unreachable(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	ll_ops->fib_entry_act_local_pack(op_ctx, trap_action, trap_id, 0);
-	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
+	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
 }
 
 static int
@@ -4566,7 +4636,7 @@ mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
 
 	ipip_ops = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt];
 	return ipip_ops->fib_entry_op(mlxsw_sp, ll_ops, op_ctx, ipip_entry, op,
-				      fib_entry->decap.tunnel_index);
+				      fib_entry->decap.tunnel_index, fib_entry->priv);
 }
 
 static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
@@ -4579,7 +4649,7 @@ static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
 	ll_ops->fib_entry_act_ip2me_tun_pack(op_ctx,
 					     fib_entry->decap.tunnel_index);
-	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
+	return mlxsw_sp_fib_entry_commit(mlxsw_sp, op_ctx, ll_ops);
 }
 
 static int __mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
@@ -4731,6 +4801,12 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 		return ERR_PTR(-ENOMEM);
 	fib_entry = &fib4_entry->common;
 
+	fib_entry->priv = mlxsw_sp_fib_entry_priv_create(fib_node->fib->ll_ops);
+	if (IS_ERR(fib_entry->priv)) {
+		err = PTR_ERR(fib_entry->priv);
+		goto err_fib_entry_priv_create;
+	}
+
 	err = mlxsw_sp_fib4_entry_type_set(mlxsw_sp, fen_info, fib_entry);
 	if (err)
 		goto err_fib4_entry_type_set;
@@ -4751,6 +4827,8 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 err_nexthop4_group_get:
 	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, fib_entry);
 err_fib4_entry_type_set:
+	mlxsw_sp_fib_entry_priv_put(fib_entry->priv);
+err_fib_entry_priv_create:
 	kfree(fib4_entry);
 	return ERR_PTR(err);
 }
@@ -4760,6 +4838,7 @@ static void mlxsw_sp_fib4_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 {
 	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
 	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, &fib4_entry->common);
+	mlxsw_sp_fib_entry_priv_put(fib4_entry->common.priv);
 	kfree(fib4_entry);
 }
 
@@ -5017,14 +5096,16 @@ static int mlxsw_sp_fib_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static void __mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
-					     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-					     struct mlxsw_sp_fib_entry *fib_entry)
+static int __mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
+					    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					    struct mlxsw_sp_fib_entry *fib_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
+	int err;
 
-	mlxsw_sp_fib_entry_del(mlxsw_sp, op_ctx, fib_entry);
+	err = mlxsw_sp_fib_entry_del(mlxsw_sp, op_ctx, fib_entry);
 	fib_node->fib_entry = NULL;
+	return err;
 }
 
 static void mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
@@ -5114,24 +5195,26 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static void mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
-				     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				     struct fib_entry_notifier_info *fen_info)
+static int mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+				    struct fib_entry_notifier_info *fen_info)
 {
 	struct mlxsw_sp_fib4_entry *fib4_entry;
 	struct mlxsw_sp_fib_node *fib_node;
+	int err;
 
 	if (mlxsw_sp->router->aborted)
-		return;
+		return 0;
 
 	fib4_entry = mlxsw_sp_fib4_entry_lookup(mlxsw_sp, fen_info);
 	if (!fib4_entry)
-		return;
+		return 0;
 	fib_node = fib4_entry->common.fib_node;
 
-	__mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, &fib4_entry->common);
+	err = __mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, &fib4_entry->common);
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
+	return err;
 }
 
 static bool mlxsw_sp_fib6_rt_should_ignore(const struct fib6_info *rt)
@@ -5546,6 +5629,12 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 		return ERR_PTR(-ENOMEM);
 	fib_entry = &fib6_entry->common;
 
+	fib_entry->priv = mlxsw_sp_fib_entry_priv_create(fib_node->fib->ll_ops);
+	if (IS_ERR(fib_entry->priv)) {
+		err = PTR_ERR(fib_entry->priv);
+		goto err_fib_entry_priv_create;
+	}
+
 	INIT_LIST_HEAD(&fib6_entry->rt6_list);
 
 	for (i = 0; i < nrt6; i++) {
@@ -5578,6 +5667,8 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 		list_del(&mlxsw_sp_rt6->list);
 		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
 	}
+	mlxsw_sp_fib_entry_priv_put(fib_entry->priv);
+err_fib_entry_priv_create:
 	kfree(fib6_entry);
 	return ERR_PTR(err);
 }
@@ -5588,6 +5679,7 @@ static void mlxsw_sp_fib6_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, &fib6_entry->common);
 	mlxsw_sp_fib6_entry_rt_destroy_all(fib6_entry);
 	WARN_ON(fib6_entry->nrt6);
+	mlxsw_sp_fib_entry_priv_put(fib6_entry->common.priv);
 	kfree(fib6_entry);
 }
 
@@ -5752,19 +5844,20 @@ static int mlxsw_sp_router_fib6_append(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
-				     struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				     struct fib6_info **rt_arr, unsigned int nrt6)
+static int mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+				    struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
 	struct fib6_info *rt = rt_arr[0];
+	int err;
 
 	if (mlxsw_sp->router->aborted)
-		return;
+		return 0;
 
 	if (mlxsw_sp_fib6_rt_should_ignore(rt))
-		return;
+		return 0;
 
 	/* Multipath routes are first added to the FIB trie and only then
 	 * notified. If we vetoed the addition, we will get a delete
@@ -5773,21 +5866,22 @@ static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 	 */
 	fib6_entry = mlxsw_sp_fib6_entry_lookup(mlxsw_sp, rt);
 	if (!fib6_entry)
-		return;
+		return 0;
 
 	/* If not all the nexthops are deleted, then only reduce the nexthop
 	 * group.
 	 */
 	if (nrt6 != fib6_entry->nrt6) {
 		mlxsw_sp_fib6_entry_nexthop_del(mlxsw_sp, op_ctx, fib6_entry, rt_arr, nrt6);
-		return;
+		return 0;
 	}
 
 	fib_node = fib6_entry->common.fib_node;
 
-	__mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, &fib6_entry->common);
+	err = __mlxsw_sp_fib_node_entry_unlink(mlxsw_sp, op_ctx, &fib6_entry->common);
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
 	mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
+	return err;
 }
 
 static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
@@ -5797,6 +5891,7 @@ static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
 	const struct mlxsw_sp_router_ll_ops *ll_ops = mlxsw_sp->router->proto_ll_ops[proto];
 	enum mlxsw_reg_ralxx_protocol ralxx_proto =
 				(enum mlxsw_reg_ralxx_protocol) proto;
+	struct mlxsw_sp_fib_entry_priv *priv;
 	char xralta_pl[MLXSW_REG_XRALTA_LEN];
 	char xralst_pl[MLXSW_REG_XRALST_LEN];
 	int i, err;
@@ -5822,10 +5917,15 @@ static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
 		if (err)
 			return err;
 
+		priv = mlxsw_sp_fib_entry_priv_create(ll_ops);
+		if (IS_ERR(priv))
+			return PTR_ERR(priv);
+
 		ll_ops->fib_entry_pack(op_ctx, proto, MLXSW_SP_FIB_ENTRY_OP_WRITE,
-				       vr->id, 0, NULL);
+				       vr->id, 0, NULL, priv);
 		ll_ops->fib_entry_act_ip2me_pack(op_ctx);
-		err = ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
+		err = ll_ops->fib_entry_commit(mlxsw_sp, op_ctx, NULL);
+		mlxsw_sp_fib_entry_priv_put(priv);
 		if (err)
 			return err;
 	}
@@ -6117,12 +6217,16 @@ static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
 	switch (fib_event->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 		err = mlxsw_sp_router_fib4_replace(mlxsw_sp, op_ctx, &fib_event->fen_info);
-		if (err)
+		if (err) {
+			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
+		}
 		fib_info_put(fib_event->fen_info.fi);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		mlxsw_sp_router_fib4_del(mlxsw_sp, op_ctx, &fib_event->fen_info);
+		err = mlxsw_sp_router_fib4_del(mlxsw_sp, op_ctx, &fib_event->fen_info);
+		if (err)
+			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 		fib_info_put(fib_event->fen_info.fi);
 		break;
 	case FIB_EVENT_NH_ADD:
@@ -6145,20 +6249,26 @@ static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
 	case FIB_EVENT_ENTRY_REPLACE:
 		err = mlxsw_sp_router_fib6_replace(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
 						   fib_event->fib6_event.nrt6);
-		if (err)
+		if (err) {
+			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
+		}
 		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	case FIB_EVENT_ENTRY_APPEND:
 		err = mlxsw_sp_router_fib6_append(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
 						  fib_event->fib6_event.nrt6);
-		if (err)
+		if (err) {
+			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
+		}
 		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		mlxsw_sp_router_fib6_del(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
-					 fib_event->fib6_event.nrt6);
+		err = mlxsw_sp_router_fib6_del(mlxsw_sp, op_ctx, fib_event->fib6_event.rt_arr,
+					       fib_event->fib6_event.nrt6);
+		if (err)
+			mlxsw_sp_fib_entry_op_ctx_priv_put_all(op_ctx);
 		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	}
@@ -6268,6 +6378,7 @@ static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
 		kfree(fib_event);
 		cond_resched();
 	}
+	WARN_ON_ONCE(!list_empty(&router->ll_op_ctx->fib_entry_priv_list));
 	mutex_unlock(&router->lock);
 }
 
@@ -8276,11 +8387,13 @@ static int mlxsw_sp_router_ll_op_ctx_init(struct mlxsw_sp_router *router)
 				    GFP_KERNEL);
 	if (!router->ll_op_ctx)
 		return -ENOMEM;
+	INIT_LIST_HEAD(&router->ll_op_ctx->fib_entry_priv_list);
 	return 0;
 }
 
 static void mlxsw_sp_router_ll_op_ctx_fini(struct mlxsw_sp_router *router)
 {
+	WARN_ON(!list_empty(&router->ll_op_ctx->fib_entry_priv_list));
 	kfree(router->ll_op_ctx);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 9db1e3da0e0c..4dacbeee3142 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -23,13 +23,16 @@ struct mlxsw_sp_fib_entry_op_ctx {
 	   initialized:1; /* Bit that the low-level op sets in case
 			   * the context priv is initialized.
 			   */
+	struct list_head fib_entry_priv_list;
 	unsigned long ll_priv[];
 };
 
 static inline void
 mlxsw_sp_fib_entry_op_ctx_clear(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
 {
+	WARN_ON_ONCE(!list_empty(&op_ctx->fib_entry_priv_list));
 	memset(op_ctx, 0, sizeof(*op_ctx));
+	INIT_LIST_HEAD(&op_ctx->fib_entry_priv_list);
 }
 
 struct mlxsw_sp_router {
@@ -73,6 +76,12 @@ struct mlxsw_sp_router {
 	struct mlxsw_sp_fib_entry_op_ctx *ll_op_ctx;
 };
 
+struct mlxsw_sp_fib_entry_priv {
+	refcount_t refcnt;
+	struct list_head list; /* Member in op_ctx->fib_entry_priv_list */
+	unsigned long priv[];
+};
+
 enum mlxsw_sp_fib_entry_op {
 	MLXSW_SP_FIB_ENTRY_OP_WRITE,
 	MLXSW_SP_FIB_ENTRY_OP_DELETE,
@@ -86,9 +95,11 @@ struct mlxsw_sp_router_ll_ops {
 	int (*ralst_write)(struct mlxsw_sp *mlxsw_sp, char *xralst_pl);
 	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
 	size_t fib_entry_op_ctx_size;
+	size_t fib_entry_priv_size;
 	void (*fib_entry_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 			       enum mlxsw_sp_l3proto proto, enum mlxsw_sp_fib_entry_op op,
-			       u16 virtual_router, u8 prefix_len, unsigned char *addr);
+			       u16 virtual_router, u8 prefix_len, unsigned char *addr,
+			       struct mlxsw_sp_fib_entry_priv *priv);
 	void (*fib_entry_act_remote_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					  enum mlxsw_reg_ralue_trap_action trap_action,
 					  u16 trap_id, u32 adjacency_index, u16 ecmp_size);
@@ -99,9 +110,14 @@ struct mlxsw_sp_router_ll_ops {
 	void (*fib_entry_act_ip2me_tun_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					     u32 tunnel_ptr);
 	int (*fib_entry_commit)(struct mlxsw_sp *mlxsw_sp,
-				struct mlxsw_sp_fib_entry_op_ctx *op_ctx);
+				struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+				bool *postponed_for_bulk);
 };
 
+int mlxsw_sp_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
+			      struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+			      const struct mlxsw_sp_router_ll_ops *ll_ops);
+
 struct mlxsw_sp_rif_ipip_lb;
 struct mlxsw_sp_rif_ipip_lb_config {
 	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
-- 
2.26.2

