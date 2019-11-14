Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1D9FC31A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfKNJyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:54:41 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46157 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726369AbfKNJyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:54:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F2F1C2106A;
        Thu, 14 Nov 2019 04:54:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 14 Nov 2019 04:54:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FW7MMtDHyqGF0VhAY
        IYeOt/3K4bP0QXFxGa+1k5HxEI=; b=JyxsZIIN2icCpHKzBl3Bf/HVT8frtCZ6+
        fbJeONcJi/E5hS3Gqdq6Md3A/svHQNac37yIu9dXaZZNgI8bjhry2BSTdWRlOzU1
        akSjygn/ayQ1biKsYmWbDuLwiIS4qYvDxzGLkCP05lVY0edOb8i38w19Eh66ArDH
        blYE4LVty3qeONvvDVr6CcO6Og54jYcS/572RCFES/VWwbq1VENPkjMqljXkz9VC
        oVrSo4RB0JdiFOjWaQ5VCfoKSc0gEQqK4oloZ95nb+O+JNOHDFKjkDq/+wMxZxGw
        NQqNhUuJFsbuY18MMPPzgIm942ZcGD5IsCL0vzvvVpNLUamPVxA+Q==
X-ME-Sender: <xms:XyTNXUv_YfN2lD_pVjkBX3jxXlkDBKlCkVZo6IC8voO2iOQR_81cdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeffedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:XyTNXf4wK9v46-RlekDbOVu5wlajadABTfso1RQeS1I_F_tUhaYJ2A>
    <xmx:XyTNXdKDCstzORtu49K6qydMCbEHvE1QZmG5LZYHTpmpFjkDywqSwg>
    <xmx:XyTNXaZRIT1odwbTuoG39xLab7NHu8lDTnGzYl47ttYCZ8J3w0CVog>
    <xmx:XyTNXRn6vVhlAVG2xAK11RcJWFvrn72q-bTK9K4eNd7tBG16seoO3Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B10FF8005B;
        Thu, 14 Nov 2019 04:54:37 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] mlxsw: spectrum_router: Allocate discard adjacency entry when needed
Date:   Thu, 14 Nov 2019 11:54:19 +0200
Message-Id: <20191114095419.27762-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Commit 0c3cbbf96def ("mlxsw: Add specific trap for packets routed via
invalid nexthops") allocated an adjacency entry during driver
initialization whose purpose is to discard packets hitting the route
pointing to it.

These adjacency entries are allocated from a resource called KVD linear
(KVDL). There are situations in which the user can decide to set the
size of this resource (via devlink-resource) to 0, in which case the
driver will not be able to load.

Therefore, instead of pre-allocating this adjacency entry, simply
allocate it only when needed. A variable indicating the validity of the
entry is added and is used to ensure it is only allocated and written
once and that it is freed after all the routes were flushed.

Fixes: 0c3cbbf96def ("mlxsw: Add specific trap for packets routed via invalid nexthops")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 43 ++++++++++++++-----
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1aa436054490..517cb8b14b1d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -78,6 +78,7 @@ struct mlxsw_sp_router {
 	const struct mlxsw_sp_rif_ops **rif_ops_arr;
 	const struct mlxsw_sp_ipip_ops **ipip_ops_arr;
 	u32 adj_discard_index;
+	bool adj_discard_index_valid;
 };
 
 struct mlxsw_sp_rif {
@@ -4203,13 +4204,33 @@ static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
 	u32 adj_discard_index = mlxsw_sp->router->adj_discard_index;
 	enum mlxsw_reg_ratr_trap_action trap_action;
 	char ratr_pl[MLXSW_REG_RATR_LEN];
+	int err;
+
+	if (mlxsw_sp->router->adj_discard_index_valid)
+		return 0;
+
+	err = mlxsw_sp_kvdl_alloc(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+				  &mlxsw_sp->router->adj_discard_index);
+	if (err)
+		return err;
 
 	trap_action = MLXSW_REG_RATR_TRAP_ACTION_DISCARD_ERRORS;
 	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY, true,
 			    MLXSW_REG_RATR_TYPE_ETHERNET, adj_discard_index,
 			    rif_index);
 	mlxsw_reg_ratr_trap_action_set(ratr_pl, trap_action);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
+	if (err)
+		goto err_ratr_write;
+
+	mlxsw_sp->router->adj_discard_index_valid = true;
+
+	return 0;
+
+err_ratr_write:
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+			   mlxsw_sp->router->adj_discard_index);
+	return err;
 }
 
 static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
@@ -5956,6 +5977,16 @@ static void mlxsw_sp_router_fib_flush(struct mlxsw_sp *mlxsw_sp)
 			continue;
 		mlxsw_sp_vr_fib_flush(mlxsw_sp, vr, MLXSW_SP_L3_PROTO_IPV6);
 	}
+
+	/* After flushing all the routes, it is not possible anyone is still
+	 * using the adjacency index that is discarding packets, so free it in
+	 * case it was allocated.
+	 */
+	if (!mlxsw_sp->router->adj_discard_index_valid)
+		return;
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+			   mlxsw_sp->router->adj_discard_index);
+	mlxsw_sp->router->adj_discard_index_valid = false;
 }
 
 static void mlxsw_sp_router_fib_abort(struct mlxsw_sp *mlxsw_sp)
@@ -8170,11 +8201,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_neigh_init;
 
-	err = mlxsw_sp_kvdl_alloc(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
-				  &router->adj_discard_index);
-	if (err)
-		goto err_adj_discard_index_alloc;
-
 	mlxsw_sp->router->netevent_nb.notifier_call =
 		mlxsw_sp_router_netevent_event;
 	err = register_netevent_notifier(&mlxsw_sp->router->netevent_nb);
@@ -8203,9 +8229,6 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_mp_hash_init:
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 err_register_netevent_notifier:
-	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
-			   router->adj_discard_index);
-err_adj_discard_index_alloc:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 err_neigh_init:
 	mlxsw_sp_vrs_fini(mlxsw_sp);
@@ -8237,8 +8260,6 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				&mlxsw_sp->router->fib_nb);
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
-	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
-			   mlxsw_sp->router->adj_discard_index);
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
 	mlxsw_sp_mr_fini(mlxsw_sp);
-- 
2.21.0

