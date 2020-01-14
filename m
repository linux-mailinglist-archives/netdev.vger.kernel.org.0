Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91F413A854
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgANLXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:23:54 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60767 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgANLXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:23:53 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8790521F18;
        Tue, 14 Jan 2020 06:23:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Jan 2020 06:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=VhD0PZayJ3xJRZYzXxS8cB3S19qXZTSNrU5Hdd/uP8o=; b=oh+YrSMj
        n4kcYPl8uMvOXaMKGLJYSK38G8mVuxnHJCqXHpZjG6NGo40hVx5Svb1/ODG6T3Dh
        yz0htHckrQeP06aHJ/s4DhmzAj1t2HDfEYNYd+EG849Y3krVOFjfTeCjvRCk0sBT
        1N1w7wjvSHKfgLh8V6dfWxNc+8AAWfKWgUDirrR1vzeCSB+qAqS3LW4nVXNSaZI0
        Rtw4SKkrH+ajAZ+uZibf+YLTu45qAmv1p+GH8ZkiMkMFEg7onELtlFb13KJVlnrv
        FSx4f7CBIRchdudncBxBlPb3VL6LzlVyX9TjJsvUYelWmmsJE0gGVXLT3wNilY4h
        sn+L2hATWb5xnQ==
X-ME-Sender: <xms:yKQdXlJo0qa2giRm4OhoFeTW5abm90Vv4Lq7Jx9zdN6Hm9N-Miv1DA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepfe
X-ME-Proxy: <xmx:yKQdXknzbOmpNz8eM04HA8YIiNi06ISti4OW5v1jQgyKtwK1mrznGw>
    <xmx:yKQdXqdF3iY3LaeoSd_bRKmALoFHShOsezqEiUTBlqeGGanKfSpt2A>
    <xmx:yKQdXpyfabtUeZ0IpjId3DY0FkL2pNy14TpMGw5xfeP_UaJjBiqUpQ>
    <xmx:yKQdXgbUWwmkWx5b9f7zrIrWxmpH-9IqRzH15uKkXiAIIHkVTBKhzQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1DD580063;
        Tue, 14 Jan 2020 06:23:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 05/10] mlxsw: spectrum_router: Separate nexthop offload indication from route
Date:   Tue, 14 Jan 2020 13:23:13 +0200
Message-Id: <20200114112318.876378-6-idosch@idosch.org>
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

The driver currently uses the 'RTNH_F_OFFLOAD' flag for both routes and
nexthops, which is cumbersome and unnecessary now that we have separate
flag for the route itself.

Separate the offload indication for nexthops from routes and call it
whenever the offload state within the nexthop group changes.

Note that IPv6 (unlike IPv4) does not share the same nexthop group
between different routes, whereas mlxsw does. Therefore, whenever the
offload indication within an IPv6 nexthop group changes, all the linked
routes need to be updated.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 92 +++++++++++++++----
 1 file changed, 75 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7f70aa799064..cbc23485f487 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3235,20 +3235,6 @@ mlxsw_sp_nexthop_fib_entries_update(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
-static void
-mlxsw_sp_fib_entry_offload_refresh(struct mlxsw_sp_fib_entry *fib_entry,
-				   enum mlxsw_reg_ralue_op op, int err);
-
-static void
-mlxsw_sp_nexthop_fib_entries_refresh(struct mlxsw_sp_nexthop_group *nh_grp)
-{
-	enum mlxsw_reg_ralue_op op = MLXSW_REG_RALUE_OP_WRITE_WRITE;
-	struct mlxsw_sp_fib_entry *fib_entry;
-
-	list_for_each_entry(fib_entry, &nh_grp->fib_list, nexthop_group_node)
-		mlxsw_sp_fib_entry_offload_refresh(fib_entry, op, 0);
-}
-
 static void mlxsw_sp_adj_grp_size_round_up(u16 *p_adj_grp_size)
 {
 	/* Valid sizes for an adjacency group are:
@@ -3352,6 +3338,73 @@ mlxsw_sp_nexthop_group_rebalance(struct mlxsw_sp_nexthop_group *nh_grp)
 	}
 }
 
+static struct mlxsw_sp_nexthop *
+mlxsw_sp_rt6_nexthop(struct mlxsw_sp_nexthop_group *nh_grp,
+		     const struct mlxsw_sp_rt6 *mlxsw_sp_rt6);
+
+static void
+mlxsw_sp_nexthop4_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	int i;
+
+	for (i = 0; i < nh_grp->count; i++) {
+		struct mlxsw_sp_nexthop *nh = &nh_grp->nexthops[i];
+
+		if (nh->offloaded)
+			nh->key.fib_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
+		else
+			nh->key.fib_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
+	}
+}
+
+static void
+__mlxsw_sp_nexthop6_group_offload_refresh(struct mlxsw_sp_nexthop_group *nh_grp,
+					  struct mlxsw_sp_fib6_entry *fib6_entry)
+{
+	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
+
+	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
+		struct fib6_nh *fib6_nh = mlxsw_sp_rt6->rt->fib6_nh;
+		struct mlxsw_sp_nexthop *nh;
+
+		nh = mlxsw_sp_rt6_nexthop(nh_grp, mlxsw_sp_rt6);
+		if (nh && nh->offloaded)
+			fib6_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
+		else
+			fib6_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
+	}
+}
+
+static void
+mlxsw_sp_nexthop6_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	struct mlxsw_sp_fib6_entry *fib6_entry;
+
+	/* Unfortunately, in IPv6 the route and the nexthop are described by
+	 * the same struct, so we need to iterate over all the routes using the
+	 * nexthop group and set / clear the offload indication for them.
+	 */
+	list_for_each_entry(fib6_entry, &nh_grp->fib_list,
+			    common.nexthop_group_node)
+		__mlxsw_sp_nexthop6_group_offload_refresh(nh_grp, fib6_entry);
+}
+
+static void
+mlxsw_sp_nexthop_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
+				       struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	switch (mlxsw_sp_nexthop_group_type(nh_grp)) {
+	case AF_INET:
+		mlxsw_sp_nexthop4_group_offload_refresh(mlxsw_sp, nh_grp);
+		break;
+	case AF_INET6:
+		mlxsw_sp_nexthop6_group_offload_refresh(mlxsw_sp, nh_grp);
+		break;
+	}
+}
+
 static void
 mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_nexthop_group *nh_grp)
@@ -3425,6 +3478,8 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 		goto set_trap;
 	}
 
+	mlxsw_sp_nexthop_group_offload_refresh(mlxsw_sp, nh_grp);
+
 	if (!old_adj_index_valid) {
 		/* The trap was set for fib entries, so we have to call
 		 * fib entry update to unset it and use adjacency index.
@@ -3446,9 +3501,6 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 		goto set_trap;
 	}
 
-	/* Offload state within the group changed, so update the flags. */
-	mlxsw_sp_nexthop_fib_entries_refresh(nh_grp);
-
 	return;
 
 set_trap:
@@ -3461,6 +3513,7 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 	err = mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, nh_grp);
 	if (err)
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to set traps for fib entries.\n");
+	mlxsw_sp_nexthop_group_offload_refresh(mlxsw_sp, nh_grp);
 	if (old_adj_index_valid)
 		mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ,
 				   nh_grp->ecmp_size, nh_grp->adj_index);
@@ -5113,6 +5166,11 @@ static int mlxsw_sp_nexthop6_group_get(struct mlxsw_sp *mlxsw_sp,
 		      &nh_grp->fib_list);
 	fib6_entry->common.nh_group = nh_grp;
 
+	/* The route and the nexthop are described by the same struct, so we
+	 * need to the update the nexthop offload indication for the new route.
+	 */
+	__mlxsw_sp_nexthop6_group_offload_refresh(nh_grp, fib6_entry);
+
 	return 0;
 }
 
-- 
2.24.1

