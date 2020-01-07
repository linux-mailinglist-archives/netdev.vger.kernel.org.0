Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301C7132A53
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgAGPp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:45:58 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59807 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727974AbgAGPp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:45:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 846EB2223A;
        Tue,  7 Jan 2020 10:45:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Jan 2020 10:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=VhD0PZayJ3xJRZYzXxS8cB3S19qXZTSNrU5Hdd/uP8o=; b=dbONFBNi
        WosGfEkjwdHIMUWLnETO6Dot+yjRCQq2oYZ3t2EK/aUGrfqVo4q8RL5BdzHVCZRh
        Q6EfVAkpdj7Jimc/iCqNynIS4LMsMTOcw05B933y//PpG7IXLMUHITCZkIFCq9Zt
        tNrNqncj7G4Gor17gd2Ge841Bi3cvDocOK6EUmHUd6VyJSj2ZfDiaDQE3zCeIlQw
        uIK72zhc4wm67HvAcJDlkCdSSsyxRPFYZXVj4zFsha1jN9InSXcjo/BwqO0Xpq9/
        55j9UROJun7NvsNfRN/JMUHNu9bsJ6m8nGnt1HrWCrNGd/ZStjdaw74tRfQAlRuw
        OUsFFAvbhT1u7w==
X-ME-Sender: <xms:s6cUXp6uMFKtxd5uP8fD0nOd0jHUENdgk1eEjcn-YVCcgvse2JRnlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehgedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:s6cUXrJCaVqq1T8rhnwZR71SyeQlkZ4KqSs4v45ruOeLPmlCEt5WIw>
    <xmx:s6cUXrc-gKqugBRFIbgZwZAZtw2Jk0i8icKRaO8H-IPv7HZkTLHY1g>
    <xmx:s6cUXmcnpmI6GPxpVXBvrGXilR1II2HGjFmtFDgWrxHMAUTxXxUqzA>
    <xmx:s6cUXiCYgAZR2d_T1LVzFseGDjaQ-Gz-wGfaarYn4s22HmEZNg2UpQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E28578005C;
        Tue,  7 Jan 2020 10:45:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum_router: Separate nexthop offload indication from route
Date:   Tue,  7 Jan 2020 17:45:12 +0200
Message-Id: <20200107154517.239665-6-idosch@idosch.org>
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

