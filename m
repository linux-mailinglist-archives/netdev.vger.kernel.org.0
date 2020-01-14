Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6EF13A856
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgANLX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:23:58 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41445 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729616AbgANLXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:23:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 46B0B21E1C;
        Tue, 14 Jan 2020 06:23:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Jan 2020 06:23:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=c57qbCE2r26lkTZxna0TtaW9lb0XHb3sxk/iqItL0iE=; b=sDpDv3nY
        4Quxn3luDkwv0PVgQ5Pt26DvXvjEZbSHhHBnSJFZUl1wgAcSNeVf3dEc3o/Ne6Di
        F9/0ITLuSVZnA/bTKNDS34GobRXEJFReM+fwzMr5fRZjGw9xTflDPLCfqu+kP7O6
        ZFU16uw1z5zqIj5iChiJ3j+AKlvVWm/vm+9YTGKKTyzUzDlTJv30Y2nB/QfDJeAa
        L4zgj+2SCbUDYiaLp4+tcwjyUXNaGWytWUWDZJd6fC4eGlAft1B4wOlBmEcet5PA
        +ubZ89X7uFTtJNSejXyScoPMLJF6UMPK10Bp8wqed19bhDG17YLzBfmz0FUZ3Yqt
        N/rM4WD4hEh72w==
X-ME-Sender: <xms:yqQdXjQBHGmkaDh27rbFxJE1rDGZg-YtZGTHiQDUPXAS97AFr9cDgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:yqQdXun_UEpxeOhPyOoFrjBshRjZCE8rPdyGcGadHhaL0Q5qHpUN6A>
    <xmx:yqQdXlbUlW8JVHexEdnHO7Bo4iUilHlkDUQbshGU5w1DWLrhmYNDFQ>
    <xmx:yqQdXgYnIYsEMuIKpyoCXd9MRdZpKqdfu3PqARa4nkPDYzSHrPCjdg>
    <xmx:yqQdXm0t0xPj4TY99WvGjrorw92TmkbYoSi_XvPDpd1JimmKKhWErw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F20780062;
        Tue, 14 Jan 2020 06:23:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 06/10] mlxsw: spectrum_router: Set hardware flags for routes
Date:   Tue, 14 Jan 2020 13:23:14 +0200
Message-Id: <20200114112318.876378-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114112318.876378-1-idosch@idosch.org>
References: <20200114112318.876378-1-idosch@idosch.org>
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

v2:
* Convert to new fib_alias_hw_flags_set() interface

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 154 +++++++++---------
 1 file changed, 77 insertions(+), 77 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index cbc23485f487..a014bd8d504d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4096,131 +4096,128 @@ mlxsw_sp_rt6_nexthop(struct mlxsw_sp_nexthop_group *nh_grp,
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
+	struct fib_rt_info fri;
+	bool should_offload;
 
-		if (nh->offloaded)
-			nh->key.fib_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
-		else
-			nh->key.fib_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
-	}
+	should_offload = mlxsw_sp_fib_entry_should_offload(fib_entry);
+	fib4_entry = container_of(fib_entry, struct mlxsw_sp_fib4_entry,
+				  common);
+	fri.fi = fi;
+	fri.tb_id = fib4_entry->tb_id;
+	fri.dst = cpu_to_be32(*p_dst);
+	fri.dst_len = dst_len;
+	fri.tos = fib4_entry->tos;
+	fri.type = fib4_entry->type;
+	fri.offload = should_offload;
+	fri.trap = !should_offload;
+	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), &fri);
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
+	struct fib_rt_info fri;
 
-		nh->key.fib_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
-	}
+	fib4_entry = container_of(fib_entry, struct mlxsw_sp_fib4_entry,
+				  common);
+	fri.fi = fi;
+	fri.tb_id = fib4_entry->tb_id;
+	fri.dst = cpu_to_be32(*p_dst);
+	fri.dst_len = dst_len;
+	fri.tos = fib4_entry->tos;
+	fri.type = fib4_entry->type;
+	fri.offload = false;
+	fri.trap = false;
+	fib_alias_hw_flags_set(mlxsw_sp_net(mlxsw_sp), &fri);
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
 
@@ -4447,7 +4444,10 @@ static int mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
 {
 	int err = __mlxsw_sp_fib_entry_op(mlxsw_sp, fib_entry, op);
 
-	mlxsw_sp_fib_entry_offload_refresh(fib_entry, op, err);
+	if (err)
+		return err;
+
+	mlxsw_sp_fib_entry_hw_flags_refresh(mlxsw_sp, fib_entry, op);
 
 	return err;
 }
@@ -4883,7 +4883,7 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 	if (!replaced)
 		return 0;
 
-	mlxsw_sp_fib_entry_offload_unset(replaced);
+	mlxsw_sp_fib_entry_hw_flags_clear(mlxsw_sp, replaced);
 	fib4_replaced = container_of(replaced, struct mlxsw_sp_fib4_entry,
 				     common);
 	mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_replaced);
@@ -5451,7 +5451,7 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 	if (!replaced)
 		return 0;
 
-	mlxsw_sp_fib_entry_offload_unset(replaced);
+	mlxsw_sp_fib_entry_hw_flags_clear(mlxsw_sp, replaced);
 	fib6_replaced = container_of(replaced, struct mlxsw_sp_fib6_entry,
 				     common);
 	mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_replaced);
-- 
2.24.1

