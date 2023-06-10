Return-Path: <netdev+bounces-9762-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2883872A79F
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:43:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 805051C211EE
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14ED41877;
	Sat, 10 Jun 2023 01:43:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B3A15A4
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C23C433EF;
	Sat, 10 Jun 2023 01:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361386;
	bh=k3sKRy6h1DOPtjQO/qwJVwP9jLHtv7wlg1+6TjErY7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIIqyrEV7s/brc4AobwKrArqOPcTyZ4UU7CVXW18TUeI9OV6o4vY7oCXnjlTceM2j
	 ILmjPfvDgeHtDT9SBJ8zqPcMDpYYFkn2kvTHhIh22EO2kgvtB/0ZEPjlL+nFlTQMZY
	 O9VhyKi6ZZto+gAqdgLIJ8N5JUixeJbD/WsZ/Opf7p7EH1ypDWukdmz6uIeIH7zN0I
	 bGEC6tSNkZPaWABNrkfDiqXLAFFJSisH4YM1KjBA4du4sCQwb9sqjVl7kwuU+Aa3Q1
	 FJitDWS0Kn8tji0YPrEimbbgBgFBo/VnlzaoXcmcIEpGA2In2dc+V/phX5ilnvM/i9
	 1TJ2bdesP4sJA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>,
	Parav Pandit <parav@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Simplify unload all rep code
Date: Fri,  9 Jun 2023 18:42:40 -0700
Message-Id: <20230610014254.343576-2-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

Instead of using type specific iterators which are only used in one place
just traverse the xarray. It will provide suitable ordering based on the
vport numbers. This will also eliminate the need for changes here when
new types are added.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 48 +------------------
 1 file changed, 1 insertion(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index eafb098db6b0..625982454575 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -55,13 +55,6 @@
 #define mlx5_esw_for_each_rep(esw, i, rep) \
 	xa_for_each(&((esw)->offloads.vport_reps), i, rep)
 
-#define mlx5_esw_for_each_sf_rep(esw, i, rep) \
-	xa_for_each_marked(&((esw)->offloads.vport_reps), i, rep, MLX5_ESW_VPT_SF)
-
-#define mlx5_esw_for_each_vf_rep(esw, index, rep)	\
-	mlx5_esw_for_each_entry_marked(&((esw)->offloads.vport_reps), index, \
-				       rep, (esw)->esw_funcs.num_vfs, MLX5_ESW_VPT_VF)
-
 /* There are two match-all miss flows, one for unicast dst mac and
  * one for multicast.
  */
@@ -2191,18 +2184,6 @@ static int esw_offloads_start(struct mlx5_eswitch *esw,
 	return 0;
 }
 
-static void mlx5_esw_offloads_rep_mark_set(struct mlx5_eswitch *esw,
-					   struct mlx5_eswitch_rep *rep,
-					   xa_mark_t mark)
-{
-	bool mark_set;
-
-	/* Copy the mark from vport to its rep */
-	mark_set = xa_get_mark(&esw->vports, rep->vport, mark);
-	if (mark_set)
-		xa_set_mark(&esw->offloads.vport_reps, rep->vport, mark);
-}
-
 static int mlx5_esw_offloads_rep_init(struct mlx5_eswitch *esw, const struct mlx5_vport *vport)
 {
 	struct mlx5_eswitch_rep *rep;
@@ -2222,9 +2203,6 @@ static int mlx5_esw_offloads_rep_init(struct mlx5_eswitch *esw, const struct mlx
 	if (err)
 		goto insert_err;
 
-	mlx5_esw_offloads_rep_mark_set(esw, rep, MLX5_ESW_VPT_HOST_FN);
-	mlx5_esw_offloads_rep_mark_set(esw, rep, MLX5_ESW_VPT_VF);
-	mlx5_esw_offloads_rep_mark_set(esw, rep, MLX5_ESW_VPT_SF);
 	return 0;
 
 insert_err:
@@ -2365,37 +2343,13 @@ static void __esw_offloads_unload_rep(struct mlx5_eswitch *esw,
 		esw->offloads.rep_ops[rep_type]->unload(rep);
 }
 
-static void __unload_reps_sf_vport(struct mlx5_eswitch *esw, u8 rep_type)
-{
-	struct mlx5_eswitch_rep *rep;
-	unsigned long i;
-
-	mlx5_esw_for_each_sf_rep(esw, i, rep)
-		__esw_offloads_unload_rep(esw, rep, rep_type);
-}
-
 static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
 {
 	struct mlx5_eswitch_rep *rep;
 	unsigned long i;
 
-	__unload_reps_sf_vport(esw, rep_type);
-
-	mlx5_esw_for_each_vf_rep(esw, i, rep)
-		__esw_offloads_unload_rep(esw, rep, rep_type);
-
-	if (mlx5_ecpf_vport_exists(esw->dev)) {
-		rep = mlx5_eswitch_get_rep(esw, MLX5_VPORT_ECPF);
-		__esw_offloads_unload_rep(esw, rep, rep_type);
-	}
-
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
-		rep = mlx5_eswitch_get_rep(esw, MLX5_VPORT_PF);
+	mlx5_esw_for_each_rep(esw, i, rep)
 		__esw_offloads_unload_rep(esw, rep, rep_type);
-	}
-
-	rep = mlx5_eswitch_get_rep(esw, MLX5_VPORT_UPLINK);
-	__esw_offloads_unload_rep(esw, rep, rep_type);
 }
 
 int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num)
-- 
2.40.1


