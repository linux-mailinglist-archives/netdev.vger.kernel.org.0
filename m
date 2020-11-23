Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F6A2C0083
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgKWHOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:14 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57861 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgKWHOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 66307F52;
        Mon, 23 Nov 2020 02:14:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=8KDMqliO8AQ5vqNhAOV0ZzQiQ+6xymap9O2bDbQNH1Y=; b=ruEDtcyl
        NREx5LUtlRz2uvEBMEjTp2Dc3sngdS0nPX6/k7O2+ELOYp7xU9/P5fCxH25B778L
        eRK4TPurBgIDsCHZiFVl0tro4KhLfGBKWr1owP8l7TnKesrP67AkLlks0N96vl+D
        VR64kXMSO2S99hzigVxAcKKu3VtzZjgyY/Sbhx1z6A3iEmvFgN8VxoUVM4ML0GOt
        W2CbG2nT9NvogvOS1xkoYujzHyiuFEgIGDYFliWPxG8btvcsRgj5JuKVWSlYSC05
        dmxPLD6VXtmdInOCMZzP5ewi/BQdREgtDu9QKc4+bf8g7aC3TRluHdLZOE7diKWI
        GQCRLUtn8BJ11w==
X-ME-Sender: <xms:RGG7X6lNAotbCJVZJk0qoMjWbfGyqcNOC0u3ydAXlSu5_iAbU6ZPOQ>
    <xme:RGG7Xx0Dg68EjD1E49YjhqGOrvVmFt6dpbkYDgzMqOB6vNef8bzdA9cd5VR1gvcdG
    PY5HhuM3OZWdIk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RGG7X4q5sGsXGhfKvzXnI1SILkN1-iaN_5mgPs2c5rdP_P_-QWPWyg>
    <xmx:RGG7X-lnDJ3-bYrJt1YCynia1XqfzS47ZbA54jcCpOUmsDMnH8YKsw>
    <xmx:RGG7X41Ysxi800BkhoohDzdYRLUH0JJkVkEBrFIH4llBb5YBw6F6Eg>
    <xmx:RWG7X1y0VwcexpDnEK6mJxPAbgmLXSmmQSEik-IS_pkI-f02sY5mpQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id A016A3280063;
        Mon, 23 Nov 2020 02:14:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum_router: Add support for blackhole nexthops
Date:   Mon, 23 Nov 2020 09:12:25 +0200
Message-Id: <20201123071230.676469-6-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add support for blackhole nexthops by programming them to the adjacency
table with a discard action.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  9 ++--
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 48 ++++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  1 +
 3 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index daf029931b5f..ed81d4fa48ac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -913,7 +913,8 @@ static u64 mlxsw_sp_dpipe_table_adj_size(struct mlxsw_sp *mlxsw_sp)
 
 	mlxsw_sp_nexthop_for_each(nh, mlxsw_sp->router)
 		if (mlxsw_sp_nexthop_offload(nh) &&
-		    !mlxsw_sp_nexthop_group_has_ipip(nh))
+		    !mlxsw_sp_nexthop_group_has_ipip(nh) &&
+		    !mlxsw_sp_nexthop_is_discard(nh))
 			size++;
 	return size;
 }
@@ -1105,7 +1106,8 @@ mlxsw_sp_dpipe_table_adj_entries_get(struct mlxsw_sp *mlxsw_sp,
 	nh_count = 0;
 	mlxsw_sp_nexthop_for_each(nh, mlxsw_sp->router) {
 		if (!mlxsw_sp_nexthop_offload(nh) ||
-		    mlxsw_sp_nexthop_group_has_ipip(nh))
+		    mlxsw_sp_nexthop_group_has_ipip(nh) ||
+		    mlxsw_sp_nexthop_is_discard(nh))
 			continue;
 
 		if (nh_count < nh_skip)
@@ -1186,7 +1188,8 @@ static int mlxsw_sp_dpipe_table_adj_counters_update(void *priv, bool enable)
 
 	mlxsw_sp_nexthop_for_each(nh, mlxsw_sp->router) {
 		if (!mlxsw_sp_nexthop_offload(nh) ||
-		    mlxsw_sp_nexthop_group_has_ipip(nh))
+		    mlxsw_sp_nexthop_group_has_ipip(nh) ||
+		    mlxsw_sp_nexthop_is_discard(nh))
 			continue;
 
 		mlxsw_sp_nexthop_indexes(nh, &adj_index, &adj_size,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ef0e4e452f47..d551e9bc373c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2858,9 +2858,10 @@ struct mlxsw_sp_nexthop {
 	   offloaded:1, /* set in case the neigh is actually put into
 			 * KVD linear area of this group.
 			 */
-	   update:1; /* set indicates that MAC of this neigh should be
+	   update:1, /* set indicates that MAC of this neigh should be
 		      * updated in HW
 		      */
+	   discard:1; /* nexthop is programmed to discard packets */
 	enum mlxsw_sp_nexthop_type type;
 	union {
 		struct mlxsw_sp_neigh_entry *neigh_entry;
@@ -3011,6 +3012,11 @@ bool mlxsw_sp_nexthop_group_has_ipip(struct mlxsw_sp_nexthop *nh)
 	return false;
 }
 
+bool mlxsw_sp_nexthop_is_discard(const struct mlxsw_sp_nexthop *nh)
+{
+	return nh->discard;
+}
+
 struct mlxsw_sp_nexthop_group_cmp_arg {
 	enum mlxsw_sp_nexthop_group_type type;
 	union {
@@ -3285,7 +3291,11 @@ static int __mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY,
 			    true, MLXSW_REG_RATR_TYPE_ETHERNET,
 			    adj_index, nh->rif->rif_index);
-	mlxsw_reg_ratr_eth_entry_pack(ratr_pl, neigh_entry->ha);
+	if (nh->discard)
+		mlxsw_reg_ratr_trap_action_set(ratr_pl,
+					       MLXSW_REG_RATR_TRAP_ACTION_DISCARD_ERRORS);
+	else
+		mlxsw_reg_ratr_eth_entry_pack(ratr_pl, neigh_entry->ha);
 	if (nh->counter_valid)
 		mlxsw_reg_ratr_counter_pack(ratr_pl, nh->counter_index, true);
 	else
@@ -4128,9 +4138,7 @@ mlxsw_sp_nexthop_obj_single_validate(struct mlxsw_sp *mlxsw_sp,
 {
 	int err = -EINVAL;
 
-	if (nh->is_reject)
-		NL_SET_ERR_MSG_MOD(extack, "Blackhole nexthops are not supported");
-	else if (nh->is_fdb)
+	if (nh->is_fdb)
 		NL_SET_ERR_MSG_MOD(extack, "FDB nexthops are not supported");
 	else if (nh->has_encap)
 		NL_SET_ERR_MSG_MOD(extack, "Encapsulating nexthops are not supported");
@@ -4165,7 +4173,7 @@ mlxsw_sp_nexthop_obj_group_validate(struct mlxsw_sp *mlxsw_sp,
 		/* Device only nexthops with an IPIP device are programmed as
 		 * encapsulating adjacency entries.
 		 */
-		if (!nh->gw_family &&
+		if (!nh->gw_family && !nh->is_reject &&
 		    !mlxsw_sp_netdev_ipip_type(mlxsw_sp, nh->dev, NULL)) {
 			NL_SET_ERR_MSG_MOD(extack, "Nexthop group entry does not have a gateway");
 			return -EINVAL;
@@ -4199,10 +4207,31 @@ static bool mlxsw_sp_nexthop_obj_is_gateway(struct mlxsw_sp *mlxsw_sp,
 		return true;
 
 	dev = info->nh->dev;
-	return info->nh->gw_family ||
+	return info->nh->gw_family || info->nh->is_reject ||
 	       mlxsw_sp_netdev_ipip_type(mlxsw_sp, dev, NULL);
 }
 
+static void mlxsw_sp_nexthop_obj_blackhole_init(struct mlxsw_sp *mlxsw_sp,
+						struct mlxsw_sp_nexthop *nh)
+{
+	u16 lb_rif_index = mlxsw_sp->router->lb_rif_index;
+
+	nh->discard = 1;
+	nh->should_offload = 1;
+	/* While nexthops that discard packets do not forward packets
+	 * via an egress RIF, they still need to be programmed using a
+	 * valid RIF, so use the loopback RIF created during init.
+	 */
+	nh->rif = mlxsw_sp->router->rifs[lb_rif_index];
+}
+
+static void mlxsw_sp_nexthop_obj_blackhole_fini(struct mlxsw_sp *mlxsw_sp,
+						struct mlxsw_sp_nexthop *nh)
+{
+	nh->rif = NULL;
+	nh->should_offload = 0;
+}
+
 static int
 mlxsw_sp_nexthop_obj_init(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_nexthop_group *nh_grp,
@@ -4236,6 +4265,9 @@ mlxsw_sp_nexthop_obj_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_type_init;
 
+	if (nh_obj->is_reject)
+		mlxsw_sp_nexthop_obj_blackhole_init(mlxsw_sp, nh);
+
 	return 0;
 
 err_type_init:
@@ -4247,6 +4279,8 @@ mlxsw_sp_nexthop_obj_init(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_nexthop_obj_fini(struct mlxsw_sp *mlxsw_sp,
 				      struct mlxsw_sp_nexthop *nh)
 {
+	if (nh->discard)
+		mlxsw_sp_nexthop_obj_blackhole_fini(mlxsw_sp, nh);
 	mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
 	list_del(&nh->router_list_node);
 	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index f9a59d454e28..96d8bf7a9a67 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -201,6 +201,7 @@ int mlxsw_sp_nexthop_indexes(struct mlxsw_sp_nexthop *nh, u32 *p_adj_index,
 			     u32 *p_adj_size, u32 *p_adj_hash_index);
 struct mlxsw_sp_rif *mlxsw_sp_nexthop_rif(struct mlxsw_sp_nexthop *nh);
 bool mlxsw_sp_nexthop_group_has_ipip(struct mlxsw_sp_nexthop *nh);
+bool mlxsw_sp_nexthop_is_discard(const struct mlxsw_sp_nexthop *nh);
 #define mlxsw_sp_nexthop_for_each(nh, router)				\
 	for (nh = mlxsw_sp_nexthop_next(router, NULL); nh;		\
 	     nh = mlxsw_sp_nexthop_next(router, nh))
-- 
2.28.0

