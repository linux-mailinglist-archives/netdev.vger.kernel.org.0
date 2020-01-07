Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3B16132A54
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgAGPqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:46:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53623 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728399AbgAGPp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:45:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1AEE021FAE;
        Tue,  7 Jan 2020 10:45:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Jan 2020 10:45:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=by5hNwTWcHigb/L41SLkcv0vFrPG+/uQK2ZeoSO1Ke4=; b=biCDgT65
        etukPCsvlzUSedlrPu1EDIKApU187DeWhvFk8LvgjzAHQGsPGk8rE5g8oED/HZ6L
        VitWrY70FUc4ars5zoEzKdPndfHLbdho3cysXnaN9Q8k7W20Y6uwT01pJjqLmw4u
        B4LHwzXZ9q/+Qr1lgYlpz7/SB2g+No1T76BWAAMVgXB4Uoa65iQxx2FT+7AGIV5P
        nHUH8dJBnAZ+cStlLhDS42frQJvB/2TpItiHgHhACmIhUcrCzoBKDkGFpBn8k0WZ
        m3YcIPfP4lWshVvGcoZPQBKqRERwWxgVHukinMzpxNYSQoiXeSfrlinB0uFFhAU9
        LYaLacv0aPLr6w==
X-ME-Sender: <xms:tKcUXi7N4eWSrMvNt8IoC6ggMYCb235JC-gGLDepNq1SwmMK4Loi4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeeh
X-ME-Proxy: <xmx:tacUXrHLrplLPJaKDFS_mV76K1fghq1U4uwAyZiLw4vn6YduX5L0XA>
    <xmx:tacUXkIry3yxl6LmMMRJjgGjPapYXKSwkLQ2jeyk3U1w5pQY6JdKaQ>
    <xmx:tacUXojwh5CvCpPeaz74438tJQuP26Yaz1l3WS7Nk9K-v8hyaB8CnA>
    <xmx:tacUXsPt_hy3FnKm_u6Cwo46CwF1OI21O2TYw828sXfSauE-KXnDnA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8020880064;
        Tue,  7 Jan 2020 10:45:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/10] mlxsw: spectrum_router: Set hardware flags for routes
Date:   Tue,  7 Jan 2020 17:45:13 +0200
Message-Id: <20200107154517.239665-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107154517.239665-1-idosch@idosch.org>
References: <20200107154517.239665-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Previous patches added support for two hardware flags for IPv4 and IPv6
routes: 'RTM_F_OFFLOAD' and 'RTM_F_TRAP'. Both indicate the presence of
the route in hardware. The first indicates that traffic is actually
offloaded from the kernel, whereas the second indicates that packets
hitting such routes are trapped to the kernel for processing (e.g., host
routes).

Use these two flags in mlxsw. The flags are modified in two places.
Firstly, whenever a route is updated in the device's table. This
includes the addition, deletion or update of a route. For example, when
a host route is promoted to perform NVE decapsulation, its action in the
device is updated, the 'RTM_F_OFFLOAD' flag set and the 'RTM_F_TRAP'
flag cleared.

Secondly, when a route is replaced and overwritten by another route, its
flags are cleared.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 141 ++++++++----------
 1 file changed, 64 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index cbc23485f487..7c0e247ab7b6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4096,131 +4096,115 @@ mlxsw_sp_rt6_nexthop(struct mlxsw_sp_nexthop_group *nh_grp,
 }
 
 static void
-mlxsw_sp_fib4_entry_offload_set(struct mlxsw_sp_fib_entry *fib_entry)
+mlxsw_sp_fib4_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_fib_entry *fib_entry)
 {
-	struct mlxsw_sp_nexthop_group *nh_grp = fib_entry->nh_group;
-	int i;
-
-	if (fib_entry->type == MLXSW_SP_FIB_ENTRY_TYPE_LOCAL ||
-	    fib_entry->type == MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE ||
-	    fib_entry->type == MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP ||
-	    fib_entry->type == MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP) {
-		nh_grp->nexthops->key.fib_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
-		return;
-	}
-
-	for (i = 0; i < nh_grp->count; i++) {
-		struct mlxsw_sp_nexthop *nh = &nh_grp->nexthops[i];
+	struct fib_info *fi = mlxsw_sp_nexthop4_group_fi(fib_entry->nh_group);
+	u32 *p_dst = (u32 *) fib_entry->fib_node->key.addr;
+	int dst_len = fib_entry->fib_node->key.prefix_len;
+	struct mlxsw_sp_fib4_entry *fib4_entry;
+	bool should_offload;
 
-		if (nh->offloaded)
-			nh->key.fib_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
-		else
-			nh->key.fib_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
-	}
+	should_offload = mlxsw_sp_fib_entry_should_offload(fib_entry);
+	fib4_entry = container_of(fib_entry, struct mlxsw_sp_fib4_entry,
+				  common);
+	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), *p_dst, dst_len,
+			       fi, fib4_entry->tos, fib4_entry->type,
+			       fib4_entry->tb_id, should_offload,
+			       !should_offload);
 }
 
 static void
-mlxsw_sp_fib4_entry_offload_unset(struct mlxsw_sp_fib_entry *fib_entry)
+mlxsw_sp_fib4_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_fib_entry *fib_entry)
 {
-	struct mlxsw_sp_nexthop_group *nh_grp = fib_entry->nh_group;
-	int i;
-
-	if (!list_is_singular(&nh_grp->fib_list))
-		return;
-
-	for (i = 0; i < nh_grp->count; i++) {
-		struct mlxsw_sp_nexthop *nh = &nh_grp->nexthops[i];
+	struct fib_info *fi = mlxsw_sp_nexthop4_group_fi(fib_entry->nh_group);
+	u32 *p_dst = (u32 *) fib_entry->fib_node->key.addr;
+	int dst_len = fib_entry->fib_node->key.prefix_len;
+	struct mlxsw_sp_fib4_entry *fib4_entry;
 
-		nh->key.fib_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
-	}
+	fib4_entry = container_of(fib_entry, struct mlxsw_sp_fib4_entry,
+				  common);
+	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), *p_dst, dst_len,
+			       fi, fib4_entry->tos, fib4_entry->type,
+			       fib4_entry->tb_id, false, false);
 }
 
 static void
-mlxsw_sp_fib6_entry_offload_set(struct mlxsw_sp_fib_entry *fib_entry)
+mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_fib_entry *fib_entry)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
+	bool should_offload;
+
+	should_offload = mlxsw_sp_fib_entry_should_offload(fib_entry);
 
+	/* In IPv6 a multipath route is represented using multiple routes, so
+	 * we need to set the flags on all of them.
+	 */
 	fib6_entry = container_of(fib_entry, struct mlxsw_sp_fib6_entry,
 				  common);
-
-	if (fib_entry->type == MLXSW_SP_FIB_ENTRY_TYPE_LOCAL ||
-	    fib_entry->type == MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE) {
-		list_first_entry(&fib6_entry->rt6_list, struct mlxsw_sp_rt6,
-				 list)->rt->fib6_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
-		return;
-	}
-
-	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
-		struct mlxsw_sp_nexthop_group *nh_grp = fib_entry->nh_group;
-		struct fib6_nh *fib6_nh = mlxsw_sp_rt6->rt->fib6_nh;
-		struct mlxsw_sp_nexthop *nh;
-
-		nh = mlxsw_sp_rt6_nexthop(nh_grp, mlxsw_sp_rt6);
-		if (nh && nh->offloaded)
-			fib6_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
-		else
-			fib6_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
-	}
+	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list)
+		fib6_info_hw_flags_set(mlxsw_sp_rt6->rt, should_offload,
+				       !should_offload);
 }
 
 static void
-mlxsw_sp_fib6_entry_offload_unset(struct mlxsw_sp_fib_entry *fib_entry)
+mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_fib_entry *fib_entry)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
 
 	fib6_entry = container_of(fib_entry, struct mlxsw_sp_fib6_entry,
 				  common);
-	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
-		struct fib6_info *rt = mlxsw_sp_rt6->rt;
-
-		rt->fib6_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
-	}
+	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list)
+		fib6_info_hw_flags_set(mlxsw_sp_rt6->rt, false, false);
 }
 
-static void mlxsw_sp_fib_entry_offload_set(struct mlxsw_sp_fib_entry *fib_entry)
+static void
+mlxsw_sp_fib_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_fib_entry *fib_entry)
 {
 	switch (fib_entry->fib_node->fib->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
-		mlxsw_sp_fib4_entry_offload_set(fib_entry);
+		mlxsw_sp_fib4_entry_hw_flags_set(mlxsw_sp, fib_entry);
 		break;
 	case MLXSW_SP_L3_PROTO_IPV6:
-		mlxsw_sp_fib6_entry_offload_set(fib_entry);
+		mlxsw_sp_fib6_entry_hw_flags_set(mlxsw_sp, fib_entry);
 		break;
 	}
 }
 
 static void
-mlxsw_sp_fib_entry_offload_unset(struct mlxsw_sp_fib_entry *fib_entry)
+mlxsw_sp_fib_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
+				  struct mlxsw_sp_fib_entry *fib_entry)
 {
 	switch (fib_entry->fib_node->fib->proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
-		mlxsw_sp_fib4_entry_offload_unset(fib_entry);
+		mlxsw_sp_fib4_entry_hw_flags_clear(mlxsw_sp, fib_entry);
 		break;
 	case MLXSW_SP_L3_PROTO_IPV6:
-		mlxsw_sp_fib6_entry_offload_unset(fib_entry);
+		mlxsw_sp_fib6_entry_hw_flags_clear(mlxsw_sp, fib_entry);
 		break;
 	}
 }
 
 static void
-mlxsw_sp_fib_entry_offload_refresh(struct mlxsw_sp_fib_entry *fib_entry,
-				   enum mlxsw_reg_ralue_op op, int err)
+mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_fib_entry *fib_entry,
+				    enum mlxsw_reg_ralue_op op)
 {
 	switch (op) {
-	case MLXSW_REG_RALUE_OP_WRITE_DELETE:
-		return mlxsw_sp_fib_entry_offload_unset(fib_entry);
 	case MLXSW_REG_RALUE_OP_WRITE_WRITE:
-		if (err)
-			return;
-		if (mlxsw_sp_fib_entry_should_offload(fib_entry))
-			mlxsw_sp_fib_entry_offload_set(fib_entry);
-		else
-			mlxsw_sp_fib_entry_offload_unset(fib_entry);
-		return;
+		mlxsw_sp_fib_entry_hw_flags_set(mlxsw_sp, fib_entry);
+		break;
+	case MLXSW_REG_RALUE_OP_WRITE_DELETE:
+		mlxsw_sp_fib_entry_hw_flags_clear(mlxsw_sp, fib_entry);
+		break;
 	default:
-		return;
+		break;
 	}
 }
 
@@ -4447,7 +4431,10 @@ static int mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
 {
 	int err = __mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry, op);
 
-	mlxsw_sp_fib_entry_offload_refresh(fib_entry, op, err);
+	if (err)
+		return err;
+
+	mlxsw_sp_fib_entry_hw_flags_refresh(mlxsw_sp, fib_entry, op);
 
 	return err;
 }
@@ -4883,7 +4870,7 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 	if (!replaced)
 		return 0;
 
-	mlxsw_sp_fib_entry_offload_unset(replaced);
+	mlxsw_sp_fib_entry_hw_flags_clear(mlxsw_sp, replaced);
 	fib4_replaced = container_of(replaced, struct mlxsw_sp_fib4_entry,
 				     common);
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_replaced);
@@ -5451,7 +5438,7 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 	if (!replaced)
 		return 0;
 
-	mlxsw_sp_fib_entry_offload_unset(replaced);
+	mlxsw_sp_fib_entry_hw_flags_clear(mlxsw_sp, replaced);
 	fib6_replaced = container_of(replaced, struct mlxsw_sp_fib6_entry,
 				     common);
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_replaced);
-- 
2.24.1

