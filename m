Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717282AD2CF
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbgKJJuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:40 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53537 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730651AbgKJJuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 05E34A0B;
        Tue, 10 Nov 2020 04:50:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=QJ7eR8ErQTlQn7Pz58yDCa9wB7VGd3uJKc/AauxB6tA=; b=UWKDeRWY
        U5uYL0nfvK121ZP2wZsDG3MU3bwPxKkTl2e6w5et+QqpxQ6TxhZ6pJEY/UInv7ef
        RIHtwSx9l69r2zFXU7TxOxn+HMlJvjbbqSKwuVkXTlxnyzyxi90LH5t9RwQnzRqz
        oqV4iQG0YP+RAW7hLCu/Ff04y4flMzyQfGkhJi5oXxg9oQhWG+fECpUxCuYcFVGO
        U664WujsqlqNPvym/qeb5SJGihl8jXIJz3Do9bydY5r9DIp6BgUfQ8I4hJ4LKk8w
        QJ2X6EpLpWAXEfiYhwaLlk2hnHdIkz8TIuvShoWhor6+km5sbto2YRSRBTvkjqDa
        cu94LZMzD+v7fA==
X-ME-Sender: <xms:ZmKqXwPlZ4WSNwyuT85qcRAPGRl5wfHCajnD5pdoWzJBMa9grUQDtA>
    <xme:ZmKqX29QtyV7UxBdLh6ZJl8YIVA69GnC5Rr4UOA1jNbzfhuz9vpUJXrrpbDn89G2I
    E5ZUBSJLM3daZ8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeeknecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZmKqX3RRBSHkNFG26fSRunLWiU47UGFy7VTS6YEaK4zxpVZ3hHjj_w>
    <xmx:ZmKqX4tSRcprFQRthm23BkJqfBvGOMji1Aa05FlWywAmDQOcw6Z9KA>
    <xmx:ZmKqX4fLFEYjxCtTn5IGrAQ6zRFi1ROsAd5CN2voBP7ebOv6vgEjfg>
    <xmx:ZmKqX5oiZfOWhdQZLom8aQYUg2EZZ8GQJQCKHmqruTWZVlwDGnHebw>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D52D328005A;
        Tue, 10 Nov 2020 04:50:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/15] mlxsw: spectrum: Push RALUE packing and writing into low-level router ops
Date:   Tue, 10 Nov 2020 11:48:55 +0200
Message-Id: <20201110094900.1920158-11-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

With follow-up introduction of XM implementation, XMDR register is
going to be optionally used instead of RALUE register. Push the RALUE
packing helpers and write call into low-level router ops.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  27 ++--
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 115 ++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  19 ++-
 4 files changed, 107 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 0f0064392468..3cea9ee5910d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -181,21 +181,21 @@ mlxsw_sp_ipip_fib_entry_op_gre4_rtdp(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int
-mlxsw_sp_ipip_fib_entry_op_gre4_ralue(struct mlxsw_sp *mlxsw_sp,
-				      struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				      u32 dip, u8 prefix_len, u16 ul_vr_id,
-				      enum mlxsw_sp_fib_entry_op op,
-				      u32 tunnel_index)
+mlxsw_sp_ipip_fib_entry_op_gre4_do(struct mlxsw_sp *mlxsw_sp,
+				   const struct mlxsw_sp_router_ll_ops *ll_ops,
+				   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+				   u32 dip, u8 prefix_len, u16 ul_vr_id,
+				   enum mlxsw_sp_fib_entry_op op,
+				   u32 tunnel_index)
 {
-	char *ralue_pl = op_ctx->ralue_pl;
-
-	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, MLXSW_SP_L3_PROTO_IPV4, op,
-				      ul_vr_id, prefix_len, (unsigned char *) &dip);
-	mlxsw_reg_ralue_act_ip2me_tun_pack(ralue_pl, tunnel_index);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
+	ll_ops->fib_entry_pack(op_ctx, MLXSW_SP_L3_PROTO_IPV4, op, ul_vr_id,
+			       prefix_len, (unsigned char *) &dip);
+	ll_ops->fib_entry_act_ip2me_tun_pack(op_ctx, tunnel_index);
+	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
 }
 
 static int mlxsw_sp_ipip_fib_entry_op_gre4(struct mlxsw_sp *mlxsw_sp,
+					   const struct mlxsw_sp_router_ll_ops *ll_ops,
 					   struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 					   struct mlxsw_sp_ipip_entry *ipip_entry,
 					   enum mlxsw_sp_fib_entry_op op, u32 tunnel_index)
@@ -211,9 +211,8 @@ static int mlxsw_sp_ipip_fib_entry_op_gre4(struct mlxsw_sp *mlxsw_sp,
 
 	dip = mlxsw_sp_ipip_netdev_saddr(MLXSW_SP_L3_PROTO_IPV4,
 					 ipip_entry->ol_dev).addr4;
-	return mlxsw_sp_ipip_fib_entry_op_gre4_ralue(mlxsw_sp, op_ctx, be32_to_cpu(dip),
-						     32, ul_vr_id, op,
-						     tunnel_index);
+	return mlxsw_sp_ipip_fib_entry_op_gre4_do(mlxsw_sp, ll_ops, op_ctx, be32_to_cpu(dip),
+						  32, ul_vr_id, op, tunnel_index);
 }
 
 static bool mlxsw_sp_ipip_tunnel_complete(enum mlxsw_sp_l3proto proto,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index dd53b1c207b3..fe9a94362e61 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -52,6 +52,7 @@ struct mlxsw_sp_ipip_ops {
 			      const struct net_device *ol_dev);
 
 	int (*fib_entry_op)(struct mlxsw_sp *mlxsw_sp,
+			    const struct mlxsw_sp_router_ll_ops *ll_ops,
 			    struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 			    struct mlxsw_sp_ipip_entry *ipip_entry,
 			    enum mlxsw_sp_fib_entry_op op,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index b0758c5c3490..ede67a28f278 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4307,12 +4307,15 @@ mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
-void
-mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl, enum mlxsw_sp_l3proto proto,
-			      enum mlxsw_sp_fib_entry_op op, u16 virtual_router,
-			      u8 prefix_len, unsigned char *addr)
+static void
+mlxsw_sp_router_ll_basic_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					enum mlxsw_sp_l3proto proto,
+					enum mlxsw_sp_fib_entry_op op,
+					u16 virtual_router, u8 prefix_len,
+					unsigned char *addr)
 {
 	enum mlxsw_reg_ralxx_protocol ralxx_proto;
+	char *ralue_pl = op_ctx->ralue_pl;
 	enum mlxsw_reg_ralue_op ralue_op;
 
 	ralxx_proto = (enum mlxsw_reg_ralxx_protocol) proto;
@@ -4341,16 +4344,52 @@ mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl, enum mlxsw_sp_l3proto proto,
 	}
 }
 
+static void
+mlxsw_sp_router_ll_basic_fib_entry_act_remote_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+						   enum mlxsw_reg_ralue_trap_action trap_action,
+						   u16 trap_id, u32 adjacency_index, u16 ecmp_size)
+{
+	mlxsw_reg_ralue_act_remote_pack(op_ctx->ralue_pl, trap_action, trap_id,
+					adjacency_index, ecmp_size);
+}
+
+static void
+mlxsw_sp_router_ll_basic_fib_entry_act_local_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+						  enum mlxsw_reg_ralue_trap_action trap_action,
+						  u16 trap_id, u16 local_erif)
+{
+	mlxsw_reg_ralue_act_local_pack(op_ctx->ralue_pl, trap_action, trap_id, local_erif);
+}
+
+static void
+mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
+{
+	mlxsw_reg_ralue_act_ip2me_pack(op_ctx->ralue_pl);
+}
+
+static void
+mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_tun_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+						      u32 tunnel_ptr)
+{
+	mlxsw_reg_ralue_act_ip2me_tun_pack(op_ctx->ralue_pl, tunnel_ptr);
+}
+
+static int
+mlxsw_sp_router_ll_basic_fib_entry_commit(struct mlxsw_sp *mlxsw_sp,
+					  struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
+{
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), op_ctx->ralue_pl);
+}
+
 static void mlxsw_sp_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
 				    struct mlxsw_sp_fib_entry *fib_entry,
 				    enum mlxsw_sp_fib_entry_op op)
 {
 	struct mlxsw_sp_fib *fib = fib_entry->fib_node->fib;
 
-	mlxsw_sp_fib_entry_ralue_pack(op_ctx->ralue_pl, fib->proto, op,
-				      fib->vr->id,
-				      fib_entry->fib_node->key.prefix_len,
-				      fib_entry->fib_node->key.addr);
+	fib->ll_ops->fib_entry_pack(op_ctx, fib->proto, op, fib->vr->id,
+				    fib_entry->fib_node->key.prefix_len,
+				    fib_entry->fib_node->key.addr);
 }
 
 static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
@@ -4391,9 +4430,9 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib_entry *fib_entry,
 					enum mlxsw_sp_fib_entry_op op)
 {
+	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	struct mlxsw_sp_nexthop_group *nh_group = fib_entry->nh_group;
 	enum mlxsw_reg_ralue_trap_action trap_action;
-	char *ralue_pl = op_ctx->ralue_pl;
 	u16 trap_id = 0;
 	u32 adjacency_index = 0;
 	u16 ecmp_size = 0;
@@ -4422,9 +4461,9 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	mlxsw_reg_ralue_act_remote_pack(ralue_pl, trap_action, trap_id,
-					adjacency_index, ecmp_size);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
+	ll_ops->fib_entry_act_remote_pack(op_ctx, trap_action, trap_id,
+					  adjacency_index, ecmp_size);
+	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
 }
 
 static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
@@ -4432,9 +4471,9 @@ static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_fib_entry *fib_entry,
 				       enum mlxsw_sp_fib_entry_op op)
 {
+	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	struct mlxsw_sp_rif *rif = fib_entry->nh_group->nh_rif;
 	enum mlxsw_reg_ralue_trap_action trap_action;
-	char *ralue_pl = op_ctx->ralue_pl;
 	u16 trap_id = 0;
 	u16 rif_index = 0;
 
@@ -4447,9 +4486,8 @@ static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, trap_id,
-				       rif_index);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
+	ll_ops->fib_entry_act_local_pack(op_ctx, trap_action, trap_id, rif_index);
+	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
 }
 
 static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
@@ -4457,11 +4495,11 @@ static int mlxsw_sp_fib_entry_op_trap(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_fib_entry *fib_entry,
 				      enum mlxsw_sp_fib_entry_op op)
 {
-	char *ralue_pl = op_ctx->ralue_pl;
+	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	mlxsw_reg_ralue_act_ip2me_pack(ralue_pl);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
+	ll_ops->fib_entry_act_ip2me_pack(op_ctx);
+	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
 }
 
 static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
@@ -4469,13 +4507,13 @@ static int mlxsw_sp_fib_entry_op_blackhole(struct mlxsw_sp *mlxsw_sp,
 					   struct mlxsw_sp_fib_entry *fib_entry,
 					   enum mlxsw_sp_fib_entry_op op)
 {
+	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	enum mlxsw_reg_ralue_trap_action trap_action;
-	char *ralue_pl = op_ctx->ralue_pl;
 
 	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_DISCARD_ERROR;
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, 0, 0);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
+	ll_ops->fib_entry_act_local_pack(op_ctx, trap_action, 0, 0);
+	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
 }
 
 static int
@@ -4484,16 +4522,16 @@ mlxsw_sp_fib_entry_op_unreachable(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_fib_entry *fib_entry,
 				  enum mlxsw_sp_fib_entry_op op)
 {
+	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	enum mlxsw_reg_ralue_trap_action trap_action;
-	char *ralue_pl = op_ctx->ralue_pl;
 	u16 trap_id;
 
 	trap_action = MLXSW_REG_RALUE_TRAP_ACTION_TRAP;
 	trap_id = MLXSW_TRAP_ID_RTR_INGRESS1;
 
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	mlxsw_reg_ralue_act_local_pack(ralue_pl, trap_action, trap_id, 0);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
+	ll_ops->fib_entry_act_local_pack(op_ctx, trap_action, trap_id, 0);
+	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
 }
 
 static int
@@ -4502,6 +4540,7 @@ mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_fib_entry *fib_entry,
 				 enum mlxsw_sp_fib_entry_op op)
 {
+	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 	struct mlxsw_sp_ipip_entry *ipip_entry = fib_entry->decap.ipip_entry;
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
 
@@ -4509,7 +4548,7 @@ mlxsw_sp_fib_entry_op_ipip_decap(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 
 	ipip_ops = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt];
-	return ipip_ops->fib_entry_op(mlxsw_sp, op_ctx, ipip_entry, op,
+	return ipip_ops->fib_entry_op(mlxsw_sp, ll_ops, op_ctx, ipip_entry, op,
 				      fib_entry->decap.tunnel_index);
 }
 
@@ -4518,12 +4557,12 @@ static int mlxsw_sp_fib_entry_op_nve_decap(struct mlxsw_sp *mlxsw_sp,
 					   struct mlxsw_sp_fib_entry *fib_entry,
 					   enum mlxsw_sp_fib_entry_op op)
 {
-	char *ralue_pl = op_ctx->ralue_pl;
+	const struct mlxsw_sp_router_ll_ops *ll_ops = fib_entry->fib_node->fib->ll_ops;
 
 	mlxsw_sp_fib_entry_pack(op_ctx, fib_entry, op);
-	mlxsw_reg_ralue_act_ip2me_tun_pack(ralue_pl,
-					   fib_entry->decap.tunnel_index);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
+	ll_ops->fib_entry_act_ip2me_tun_pack(op_ctx,
+					     fib_entry->decap.tunnel_index);
+	return ll_ops->fib_entry_commit(mlxsw_sp, op_ctx);
 }
 
 static int __mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
@@ -5757,18 +5796,16 @@ static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
 		struct mlxsw_sp_vr *vr = &mlxsw_sp->router->vrs[i];
 		struct mlxsw_sp_fib_entry_op_ctx op_ctx = {};
 		char xraltb_pl[MLXSW_REG_XRALTB_LEN];
-		char *ralue_pl = op_ctx.ralue_pl;
 
 		mlxsw_reg_xraltb_pack(xraltb_pl, vr->id, ralxx_proto, tree_id);
 		err = ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
 		if (err)
 			return err;
 
-		mlxsw_sp_fib_entry_ralue_pack(ralue_pl, proto,
-					      MLXSW_SP_FIB_ENTRY_OP_WRITE, vr->id, 0, NULL);
-		mlxsw_reg_ralue_act_ip2me_pack(ralue_pl);
-		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue),
-				      ralue_pl);
+		ll_ops->fib_entry_pack(&op_ctx, proto, MLXSW_SP_FIB_ENTRY_OP_WRITE,
+				       vr->id, 0, NULL);
+		ll_ops->fib_entry_act_ip2me_pack(&op_ctx);
+		err = ll_ops->fib_entry_commit(mlxsw_sp, &op_ctx);
 		if (err)
 			return err;
 	}
@@ -8165,6 +8202,12 @@ static const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_basic_ops = {
 	.ralta_write = mlxsw_sp_router_ll_basic_ralta_write,
 	.ralst_write = mlxsw_sp_router_ll_basic_ralst_write,
 	.raltb_write = mlxsw_sp_router_ll_basic_raltb_write,
+	.fib_entry_pack = mlxsw_sp_router_ll_basic_fib_entry_pack,
+	.fib_entry_act_remote_pack = mlxsw_sp_router_ll_basic_fib_entry_act_remote_pack,
+	.fib_entry_act_local_pack = mlxsw_sp_router_ll_basic_fib_entry_act_local_pack,
+	.fib_entry_act_ip2me_pack = mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_pack,
+	.fib_entry_act_ip2me_tun_pack = mlxsw_sp_router_ll_basic_fib_entry_act_ip2me_tun_pack,
+	.fib_entry_commit = mlxsw_sp_router_ll_basic_fib_entry_commit,
 };
 
 int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 1b071f872a3b..2f700ad74385 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -71,6 +71,20 @@ struct mlxsw_sp_router_ll_ops {
 	int (*ralta_write)(struct mlxsw_sp *mlxsw_sp, char *xralta_pl);
 	int (*ralst_write)(struct mlxsw_sp *mlxsw_sp, char *xralst_pl);
 	int (*raltb_write)(struct mlxsw_sp *mlxsw_sp, char *xraltb_pl);
+	void (*fib_entry_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+			       enum mlxsw_sp_l3proto proto, enum mlxsw_sp_fib_entry_op op,
+			       u16 virtual_router, u8 prefix_len, unsigned char *addr);
+	void (*fib_entry_act_remote_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					  enum mlxsw_reg_ralue_trap_action trap_action,
+					  u16 trap_id, u32 adjacency_index, u16 ecmp_size);
+	void (*fib_entry_act_local_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					 enum mlxsw_reg_ralue_trap_action trap_action,
+					 u16 trap_id, u16 local_erif);
+	void (*fib_entry_act_ip2me_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx);
+	void (*fib_entry_act_ip2me_tun_pack)(struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
+					     u32 tunnel_ptr);
+	int (*fib_entry_commit)(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_fib_entry_op_ctx *op_ctx);
 };
 
 struct mlxsw_sp_rif_ipip_lb;
@@ -173,9 +187,4 @@ static inline bool mlxsw_sp_l3addr_eq(const union mlxsw_sp_l3addr *addr1,
 int mlxsw_sp_ipip_ecn_encap_init(struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp);
 
-void
-mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl, enum mlxsw_sp_l3proto proto,
-			      enum mlxsw_sp_fib_entry_op op, u16 virtual_router,
-			      u8 prefix_len, unsigned char *addr);
-
 #endif /* _MLXSW_ROUTER_H_*/
-- 
2.26.2

