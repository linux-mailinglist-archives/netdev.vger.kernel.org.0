Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE042B1F8A
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgKMQGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:42 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50015 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726863AbgKMQGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:40 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 86E585C0156;
        Fri, 13 Nov 2020 11:06:39 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=JsoqJkMur+0USpuhGgupDNDfrosQJbKG1lIXHhIjQuU=; b=f9GZFsxx
        YxAIIzE17ThHMlEUtTyCIs5RLg2twLLT2KQ4mhdm2ZIJpIJzCfKnwIfzkG+/DN0T
        2AGnD01Jh+S0boX3L/5CYfMtrhvZjcJXCRFkPad7gKhy5JSWEe/0s0Z9/pvGxJ/G
        r0xWWWis3cKt8bfO54hmI6dEw9+Cq2cDwvq0LHotsF55D+zqDFSj9fMEDoiEqNaH
        Jn0aEE19Hkae0sofaGh2C8Q+J7UVKCoiSLfBQctJ55ED5DAb8Cb8oWzKZogc4V3D
        51fIbkwk/hNvI53qdD/ILuDu6MDZkX7jLPf1o/WrXzr9CWFxoa8hJXy2GryozcI4
        XeJIvkAGRZodiQ==
X-ME-Sender: <xms:D6-uX_V5ghEbWO6o5uQy-ta2HNxNtuh1eRVxlF0BKLi4I8ejDZpSqg>
    <xme:D6-uX3kn8tnqgtdu6NcpMtoRrCgcqNjdX2xsT-TLTzrlwQU95EC09TyvhoJEZNhDY
    KP_hAVP_GqKNyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:D6-uX7bcfaQ0fNMB4eGXhNrsPXVsV2YOpVZOlCIQyi0shjDHd0uT0g>
    <xmx:D6-uX6Xpja7WME5EFm2vqu6LFYFFKQ0OcJQuP0zUgdJVo7Jesj8LVg>
    <xmx:D6-uX5l9toiWwHYPF0IiYJo0mz2_qRV-i0iTYYpiMH5NHRMBrcx0Iw>
    <xmx:D6-uX_hpSIhwYpe8sFrrkQ5cHAmRGTHIdoTdRIoBEmMDCK16iU4-sA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8CFC93280059;
        Fri, 13 Nov 2020 11:06:37 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/15] mlxsw: spectrum_router: Associate neighbour table with nexthop instead of group
Date:   Fri, 13 Nov 2020 18:05:48 +0200
Message-Id: <20201113160559.22148-5-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

As explained in the previous patch, nexthop objects can have both IPv4
and IPv6 nexthops in the same group. Therefore, move the neighbour table
to be a property of the nexthop instead of the nexthop group.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 5affe7f79a9a..462ddab11c07 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2835,6 +2835,7 @@ struct mlxsw_sp_nexthop {
 						* this belongs to
 						*/
 	struct rhash_head ht_node;
+	struct neigh_table *neigh_tbl;
 	struct mlxsw_sp_nexthop_key key;
 	unsigned char gw_addr[sizeof(struct in6_addr)];
 	int ifindex;
@@ -2869,7 +2870,6 @@ struct mlxsw_sp_nexthop_group {
 	void *priv;
 	struct rhash_head ht_node;
 	struct list_head fib_list; /* list of fib entries that use this group */
-	struct neigh_table *neigh_tbl;
 	enum mlxsw_sp_nexthop_group_type type;
 	u8 adj_index_valid:1,
 	   gateway:1; /* routes using the group use a gateway */
@@ -3674,10 +3674,9 @@ mlxsw_sp_nexthop_dead_neigh_replace(struct mlxsw_sp *mlxsw_sp,
 	nh = list_first_entry(&neigh_entry->nexthop_list,
 			      struct mlxsw_sp_nexthop, neigh_list_node);
 
-	n = neigh_lookup(nh->nh_grp->neigh_tbl, &nh->gw_addr, nh->rif->dev);
+	n = neigh_lookup(nh->neigh_tbl, &nh->gw_addr, nh->rif->dev);
 	if (!n) {
-		n = neigh_create(nh->nh_grp->neigh_tbl, &nh->gw_addr,
-				 nh->rif->dev);
+		n = neigh_create(nh->neigh_tbl, &nh->gw_addr, nh->rif->dev);
 		if (IS_ERR(n))
 			return PTR_ERR(n);
 		neigh_event_send(n, NULL);
@@ -3776,10 +3775,9 @@ static int mlxsw_sp_nexthop_neigh_init(struct mlxsw_sp *mlxsw_sp,
 	 * The reference is taken either in neigh_lookup() or
 	 * in neigh_create() in case n is not found.
 	 */
-	n = neigh_lookup(nh->nh_grp->neigh_tbl, &nh->gw_addr, nh->rif->dev);
+	n = neigh_lookup(nh->neigh_tbl, &nh->gw_addr, nh->rif->dev);
 	if (!n) {
-		n = neigh_create(nh->nh_grp->neigh_tbl, &nh->gw_addr,
-				 nh->rif->dev);
+		n = neigh_create(nh->neigh_tbl, &nh->gw_addr, nh->rif->dev);
 		if (IS_ERR(n))
 			return PTR_ERR(n);
 		neigh_event_send(n, NULL);
@@ -3968,6 +3966,7 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 	nh->nh_weight = 1;
 #endif
 	memcpy(&nh->gw_addr, &fib_nh->fib_nh_gw4, sizeof(fib_nh->fib_nh_gw4));
+	nh->neigh_tbl = &arp_tbl;
 	err = mlxsw_sp_nexthop_insert(mlxsw_sp, nh);
 	if (err)
 		return err;
@@ -4104,7 +4103,6 @@ mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 		return ERR_PTR(-ENOMEM);
 	nh_grp->priv = fi;
 	INIT_LIST_HEAD(&nh_grp->fib_list);
-	nh_grp->neigh_tbl = &arp_tbl;
 	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4;
 
 	nh_grp->gateway = mlxsw_sp_fi_is_gateway(mlxsw_sp, fi);
@@ -5373,6 +5371,9 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 	nh->nh_grp = nh_grp;
 	nh->nh_weight = rt->fib6_nh->fib_nh_weight;
 	memcpy(&nh->gw_addr, &rt->fib6_nh->fib_nh_gw6, sizeof(nh->gw_addr));
+#if IS_ENABLED(CONFIG_IPV6)
+	nh->neigh_tbl = &nd_tbl;
+#endif
 	mlxsw_sp_nexthop_counter_alloc(mlxsw_sp, nh);
 
 	list_add_tail(&nh->router_list_node, &mlxsw_sp->router->nexthop_list);
@@ -5414,9 +5415,6 @@ mlxsw_sp_nexthop6_group_create(struct mlxsw_sp *mlxsw_sp,
 	if (!nh_grp)
 		return ERR_PTR(-ENOMEM);
 	INIT_LIST_HEAD(&nh_grp->fib_list);
-#if IS_ENABLED(CONFIG_IPV6)
-	nh_grp->neigh_tbl = &nd_tbl;
-#endif
 	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6;
 	mlxsw_sp_rt6 = list_first_entry(&fib6_entry->rt6_list,
 					struct mlxsw_sp_rt6, list);
-- 
2.28.0

