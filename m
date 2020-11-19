Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A192B932E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgKSNJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:09:26 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:34895 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgKSNJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:09:26 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 8A3C1EA0;
        Thu, 19 Nov 2020 08:09:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:09:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=yQK/1UmvX0zeC6IwwUOWjyBL4tFZVj5dX4sa0K/cmZI=; b=mr7wsSCx
        NWa8yTHiZQYGmp8t2dsFkqaMRXqKFqv0X74lP0xi+ObzySllulwroah5tNbe7qGS
        cbKN9IDUS0l6+TkmoJsV2KLzQLZOwPZ6na3tumjf/Kt+Q5oHQi62DQRUtLHQwCR6
        1AXEJcheC7l7RmTxredqaQJ/0NOXxwXhHAgnN/q2yRzf9DFzmSevs468FLQqE1EP
        GjKgrB6itaJdUJp9We9qfZOweLRqoimZbO8S2MfM9/tB6zdK95q7ijBuUUiqThlt
        Z+za4bizhUY9rrSeVmOzmsrtRUq4ASeSLUfJOqQ9TOF24dO+7yEqqn7O+IcD8a65
        gI+xNQAtEKkFHg==
X-ME-Sender: <xms:hG62X9s_FrUeHoSPcBf_AyMnMEzUphmoEX01GNGzIN3O_ctt6x-b1w>
    <xme:hG62X2cOsieJkUbTDULmDi219vQxWNCtFw56s5lXVYyXjC56oZ1IQIzGhd-114dzE
    18Oyowc5EHRHGI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hG62XwwEFXBWxi7mnp5ivOKhWrXOQ0wxY8XU4xkBOCQqKizwLpxawg>
    <xmx:hG62X0PtiALtjwq_zcVsBuKXWK3_JdYpdtncPC3RgzeO9j0_gHHb7g>
    <xmx:hG62X9_7fileYofbYUKpElVkA7A7dYooKvFwDiCfg04fkmkxjfhNZA>
    <xmx:hG62X4b9tOks8GGwz63yOvcOKvm0dhK19blSCtIA7aWdfJGRvQWgnA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E7AA328005A;
        Thu, 19 Nov 2020 08:09:22 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: spectrum_router: Add support for nexthop objects
Date:   Thu, 19 Nov 2020 15:08:41 +0200
Message-Id: <20201119130848.407918-2-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119130848.407918-1-idosch@idosch.org>
References: <20201119130848.407918-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Register a listener to the nexthop notification chain and parse notified
nexthop objects into the existing mlxsw nexthop data structures.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 453 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 +
 2 files changed, 454 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 147dd8fab2af..480d47ef9362 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2873,6 +2873,7 @@ struct mlxsw_sp_nexthop {
 enum mlxsw_sp_nexthop_group_type {
 	MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4,
 	MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6,
+	MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ,
 };
 
 struct mlxsw_sp_nexthop_group_info {
@@ -2894,6 +2895,9 @@ struct mlxsw_sp_nexthop_group {
 		struct {
 			struct fib_info *fi;
 		} ipv4;
+		struct {
+			u32 id;
+		} obj;
 	};
 	struct mlxsw_sp_nexthop_group_info *nhgi;
 	enum mlxsw_sp_nexthop_group_type type;
@@ -3012,6 +3016,7 @@ struct mlxsw_sp_nexthop_group_cmp_arg {
 	union {
 		struct fib_info *fi;
 		struct mlxsw_sp_fib6_entry *fib6_entry;
+		u32 id;
 	};
 };
 
@@ -3074,6 +3079,8 @@ mlxsw_sp_nexthop_group_cmp(struct rhashtable_compare_arg *arg, const void *ptr)
 	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
 		return !mlxsw_sp_nexthop6_group_cmp(nh_grp,
 						    cmp_arg->fib6_entry);
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ:
+		return cmp_arg->id != nh_grp->obj.id;
 	default:
 		WARN_ON(1);
 		return 1;
@@ -3100,6 +3107,8 @@ static u32 mlxsw_sp_nexthop_group_hash_obj(const void *data, u32 len, u32 seed)
 			val ^= jhash(&nh->gw_addr, sizeof(nh->gw_addr), seed);
 		}
 		return jhash(&val, sizeof(val), seed);
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ:
+		return jhash(&nh_grp->obj.id, sizeof(nh_grp->obj.id), seed);
 	default:
 		WARN_ON(1);
 		return 0;
@@ -3134,6 +3143,8 @@ mlxsw_sp_nexthop_group_hash(const void *data, u32 len, u32 seed)
 		return jhash(&cmp_arg->fi, sizeof(cmp_arg->fi), seed);
 	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
 		return mlxsw_sp_nexthop6_group_hash(cmp_arg->fib6_entry, seed);
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ:
+		return jhash(&cmp_arg->id, sizeof(cmp_arg->id), seed);
 	default:
 		WARN_ON(1);
 		return 0;
@@ -3538,6 +3549,25 @@ mlxsw_sp_nexthop6_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
 		__mlxsw_sp_nexthop6_group_offload_refresh(nh_grp, fib6_entry);
 }
 
+static void
+mlxsw_sp_nexthop_obj_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
+					   struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	/* Do not update the flags if the nexthop group is being destroyed
+	 * since:
+	 * 1. The nexthop objects is being deleted, in which case the flags are
+	 * irrelevant.
+	 * 2. The nexthop group was replaced by a newer group, in which case
+	 * the flags of the nexthop object were already updated based on the
+	 * new group.
+	 */
+	if (nh_grp->can_destroy)
+		return;
+
+	nexthop_set_hw_flags(mlxsw_sp_net(mlxsw_sp), nh_grp->obj.id,
+			     nh_grp->nhgi->adj_index_valid, false);
+}
+
 static void
 mlxsw_sp_nexthop_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_nexthop_group *nh_grp)
@@ -3549,6 +3579,9 @@ mlxsw_sp_nexthop_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
 	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
 		mlxsw_sp_nexthop6_group_offload_refresh(mlxsw_sp, nh_grp);
 		break;
+	case MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ:
+		mlxsw_sp_nexthop_obj_group_offload_refresh(mlxsw_sp, nh_grp);
+		break;
 	}
 }
 
@@ -4088,6 +4121,413 @@ static void mlxsw_sp_nexthop_rif_gone_sync(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+static int
+mlxsw_sp_nexthop_obj_single_validate(struct mlxsw_sp *mlxsw_sp,
+				     const struct nh_notifier_single_info *nh,
+				     struct netlink_ext_ack *extack)
+{
+	int err = -EINVAL;
+
+	if (nh->is_reject)
+		NL_SET_ERR_MSG_MOD(extack, "Blackhole nexthops are not supported");
+	else if (nh->is_fdb)
+		NL_SET_ERR_MSG_MOD(extack, "FDB nexthops are not supported");
+	else if (nh->has_encap)
+		NL_SET_ERR_MSG_MOD(extack, "Encapsulating nexthops are not supported");
+	else
+		err = 0;
+
+	return err;
+}
+
+static int
+mlxsw_sp_nexthop_obj_group_validate(struct mlxsw_sp *mlxsw_sp,
+				    const struct nh_notifier_grp_info *nh_grp,
+				    struct netlink_ext_ack *extack)
+{
+	int i;
+
+	if (nh_grp->is_fdb) {
+		NL_SET_ERR_MSG_MOD(extack, "FDB nexthop groups are not supported");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < nh_grp->num_nh; i++) {
+		const struct nh_notifier_single_info *nh;
+		int err;
+
+		nh = &nh_grp->nh_entries[i].nh;
+		err = mlxsw_sp_nexthop_obj_single_validate(mlxsw_sp, nh,
+							   extack);
+		if (err)
+			return err;
+
+		/* Device only nexthops with an IPIP device are programmed as
+		 * encapsulating adjacency entries.
+		 */
+		if (!nh->gw_family &&
+		    !mlxsw_sp_netdev_ipip_type(mlxsw_sp, nh->dev, NULL)) {
+			NL_SET_ERR_MSG_MOD(extack, "Nexthop group entry does not have a gateway");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int mlxsw_sp_nexthop_obj_validate(struct mlxsw_sp *mlxsw_sp,
+					 unsigned long event,
+					 struct nh_notifier_info *info)
+{
+	if (event != NEXTHOP_EVENT_REPLACE)
+		return 0;
+
+	if (!info->is_grp)
+		return mlxsw_sp_nexthop_obj_single_validate(mlxsw_sp, info->nh,
+							    info->extack);
+	return mlxsw_sp_nexthop_obj_group_validate(mlxsw_sp, info->nh_grp,
+						   info->extack);
+}
+
+static bool mlxsw_sp_nexthop_obj_is_gateway(struct mlxsw_sp *mlxsw_sp,
+					    const struct nh_notifier_info *info)
+{
+	const struct net_device *dev;
+
+	if (info->is_grp)
+		/* Already validated earlier. */
+		return true;
+
+	dev = info->nh->dev;
+	return info->nh->gw_family ||
+	       mlxsw_sp_netdev_ipip_type(mlxsw_sp, dev, NULL);
+}
+
+static int
+mlxsw_sp_nexthop_obj_init(struct mlxsw_sp *mlxsw_sp,
+			  struct mlxsw_sp_nexthop_group *nh_grp,
+			  struct mlxsw_sp_nexthop *nh,
+			  struct nh_notifier_single_info *nh_obj, int weight)
+{
+	struct net_device *dev = nh_obj->dev;
+	int err;
+
+	nh->nhgi = nh_grp->nhgi;
+	nh->nh_weight = weight;
+
+	switch (nh_obj->gw_family) {
+	case AF_INET:
+		memcpy(&nh->gw_addr, &nh_obj->ipv4, sizeof(nh_obj->ipv4));
+		nh->neigh_tbl = &arp_tbl;
+		break;
+	case AF_INET6:
+		memcpy(&nh->gw_addr, &nh_obj->ipv6, sizeof(nh_obj->ipv6));
+#if IS_ENABLED(CONFIG_IPV6)
+		nh->neigh_tbl = &nd_tbl;
+#endif
+		break;
+	}
+
+	mlxsw_sp_nexthop_counter_alloc(mlxsw_sp, nh);
+	list_add_tail(&nh->router_list_node, &mlxsw_sp->router->nexthop_list);
+	nh->ifindex = dev->ifindex;
+
+	err = mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, dev);
+	if (err)
+		goto err_type_init;
+
+	return 0;
+
+err_type_init:
+	list_del(&nh->router_list_node);
+	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
+	return err;
+}
+
+static void mlxsw_sp_nexthop_obj_fini(struct mlxsw_sp *mlxsw_sp,
+				      struct mlxsw_sp_nexthop *nh)
+{
+	mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
+	list_del(&nh->router_list_node);
+	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
+}
+
+static int
+mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_sp *mlxsw_sp,
+				     struct mlxsw_sp_nexthop_group *nh_grp,
+				     struct nh_notifier_info *info)
+{
+	unsigned int nhs = info->is_grp ? info->nh_grp->num_nh : 1;
+	struct mlxsw_sp_nexthop_group_info *nhgi;
+	struct mlxsw_sp_nexthop *nh;
+	int err, i;
+
+	nhgi = kzalloc(struct_size(nhgi, nexthops, nhs), GFP_KERNEL);
+	if (!nhgi)
+		return -ENOMEM;
+	nh_grp->nhgi = nhgi;
+	nhgi->nh_grp = nh_grp;
+	nhgi->gateway = mlxsw_sp_nexthop_obj_is_gateway(mlxsw_sp, info);
+	nhgi->count = nhs;
+	for (i = 0; i < nhgi->count; i++) {
+		struct nh_notifier_single_info *nh_obj;
+		int weight;
+
+		nh = &nhgi->nexthops[i];
+		if (info->is_grp) {
+			nh_obj = &info->nh_grp->nh_entries[i].nh;
+			weight = info->nh_grp->nh_entries[i].weight;
+		} else {
+			nh_obj = info->nh;
+			weight = 1;
+		}
+		err = mlxsw_sp_nexthop_obj_init(mlxsw_sp, nh_grp, nh, nh_obj,
+						weight);
+		if (err)
+			goto err_nexthop_obj_init;
+	}
+	err = mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Failed to write adjacency entries to the device");
+		goto err_group_refresh;
+	}
+
+	return 0;
+
+err_group_refresh:
+	i = nhgi->count;
+err_nexthop_obj_init:
+	for (i--; i >= 0; i--) {
+		nh = &nhgi->nexthops[i];
+		mlxsw_sp_nexthop_obj_fini(mlxsw_sp, nh);
+	}
+	kfree(nhgi);
+	return err;
+}
+
+static void
+mlxsw_sp_nexthop_obj_group_info_fini(struct mlxsw_sp *mlxsw_sp,
+				     struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	struct mlxsw_sp_nexthop_group_info *nhgi = nh_grp->nhgi;
+	int i;
+
+	for (i = nhgi->count - 1; i >= 0; i--) {
+		struct mlxsw_sp_nexthop *nh = &nhgi->nexthops[i];
+
+		mlxsw_sp_nexthop_obj_fini(mlxsw_sp, nh);
+	}
+	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
+	WARN_ON_ONCE(nhgi->adj_index_valid);
+	kfree(nhgi);
+}
+
+static struct mlxsw_sp_nexthop_group *
+mlxsw_sp_nexthop_obj_group_create(struct mlxsw_sp *mlxsw_sp,
+				  struct nh_notifier_info *info)
+{
+	struct mlxsw_sp_nexthop_group *nh_grp;
+	int err;
+
+	nh_grp = kzalloc(sizeof(*nh_grp), GFP_KERNEL);
+	if (!nh_grp)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&nh_grp->fib_list);
+	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ;
+	nh_grp->obj.id = info->id;
+
+	err = mlxsw_sp_nexthop_obj_group_info_init(mlxsw_sp, nh_grp, info);
+	if (err)
+		goto err_nexthop_group_info_init;
+
+	nh_grp->can_destroy = false;
+
+	return nh_grp;
+
+err_nexthop_group_info_init:
+	kfree(nh_grp);
+	return ERR_PTR(err);
+}
+
+static void
+mlxsw_sp_nexthop_obj_group_destroy(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	if (!nh_grp->can_destroy)
+		return;
+	mlxsw_sp_nexthop_obj_group_info_fini(mlxsw_sp, nh_grp);
+	WARN_ON_ONCE(!list_empty(&nh_grp->fib_list));
+	kfree(nh_grp);
+}
+
+static struct mlxsw_sp_nexthop_group *
+mlxsw_sp_nexthop_obj_group_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
+{
+	struct mlxsw_sp_nexthop_group_cmp_arg cmp_arg;
+
+	cmp_arg.type = MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ;
+	cmp_arg.id = id;
+	return rhashtable_lookup_fast(&mlxsw_sp->router->nexthop_group_ht,
+				      &cmp_arg,
+				      mlxsw_sp_nexthop_group_ht_params);
+}
+
+static int mlxsw_sp_nexthop_obj_group_add(struct mlxsw_sp *mlxsw_sp,
+					  struct mlxsw_sp_nexthop_group *nh_grp)
+{
+	return mlxsw_sp_nexthop_group_insert(mlxsw_sp, nh_grp);
+}
+
+static int
+mlxsw_sp_nexthop_obj_group_replace(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_nexthop_group *nh_grp,
+				   struct mlxsw_sp_nexthop_group *old_nh_grp,
+				   struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_nexthop_group_info *old_nhgi = old_nh_grp->nhgi;
+	struct mlxsw_sp_nexthop_group_info *new_nhgi = nh_grp->nhgi;
+	int err;
+
+	old_nh_grp->nhgi = new_nhgi;
+	new_nhgi->nh_grp = old_nh_grp;
+	nh_grp->nhgi = old_nhgi;
+	old_nhgi->nh_grp = nh_grp;
+
+	if (old_nhgi->adj_index_valid && new_nhgi->adj_index_valid) {
+		/* Both the old adjacency index and the new one are valid.
+		 * Routes are currently using the old one. Tell the device to
+		 * replace the old adjacency index with the new one.
+		 */
+		err = mlxsw_sp_adj_index_mass_update(mlxsw_sp, old_nh_grp,
+						     old_nhgi->adj_index,
+						     old_nhgi->ecmp_size);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to replace old adjacency index with new one");
+			goto err_out;
+		}
+	} else if (old_nhgi->adj_index_valid && !new_nhgi->adj_index_valid) {
+		/* The old adjacency index is valid, while the new one is not.
+		 * Iterate over all the routes using the group and change them
+		 * to trap packets to the CPU.
+		 */
+		err = mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, old_nh_grp);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to update routes to trap packets");
+			goto err_out;
+		}
+	} else if (!old_nhgi->adj_index_valid && new_nhgi->adj_index_valid) {
+		/* The old adjacency index is invalid, while the new one is.
+		 * Iterate over all the routes using the group and change them
+		 * to forward packets using the new valid index.
+		 */
+		err = mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, old_nh_grp);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to update routes to forward packets");
+			goto err_out;
+		}
+	}
+
+	/* Make sure the flags are set / cleared based on the new nexthop group
+	 * information.
+	 */
+	mlxsw_sp_nexthop_obj_group_offload_refresh(mlxsw_sp, old_nh_grp);
+
+	/* At this point 'nh_grp' is just a shell that is not used by anyone
+	 * and its nexthop group info is the old info that was just replaced
+	 * with the new one. Remove it.
+	 */
+	nh_grp->can_destroy = true;
+	mlxsw_sp_nexthop_obj_group_destroy(mlxsw_sp, nh_grp);
+
+	return 0;
+
+err_out:
+	old_nhgi->nh_grp = old_nh_grp;
+	nh_grp->nhgi = new_nhgi;
+	new_nhgi->nh_grp = nh_grp;
+	old_nh_grp->nhgi = old_nhgi;
+	return err;
+}
+
+static int mlxsw_sp_nexthop_obj_new(struct mlxsw_sp *mlxsw_sp,
+				    struct nh_notifier_info *info)
+{
+	struct mlxsw_sp_nexthop_group *nh_grp, *old_nh_grp;
+	struct netlink_ext_ack *extack = info->extack;
+	int err;
+
+	nh_grp = mlxsw_sp_nexthop_obj_group_create(mlxsw_sp, info);
+	if (IS_ERR(nh_grp))
+		return PTR_ERR(nh_grp);
+
+	old_nh_grp = mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp, info->id);
+	if (!old_nh_grp)
+		err = mlxsw_sp_nexthop_obj_group_add(mlxsw_sp, nh_grp);
+	else
+		err = mlxsw_sp_nexthop_obj_group_replace(mlxsw_sp, nh_grp,
+							 old_nh_grp, extack);
+
+	if (err) {
+		nh_grp->can_destroy = true;
+		mlxsw_sp_nexthop_obj_group_destroy(mlxsw_sp, nh_grp);
+	}
+
+	return err;
+}
+
+static void mlxsw_sp_nexthop_obj_del(struct mlxsw_sp *mlxsw_sp,
+				     struct nh_notifier_info *info)
+{
+	struct mlxsw_sp_nexthop_group *nh_grp;
+
+	nh_grp = mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp, info->id);
+	if (!nh_grp)
+		return;
+
+	nh_grp->can_destroy = true;
+	mlxsw_sp_nexthop_group_remove(mlxsw_sp, nh_grp);
+
+	/* If the group still has routes using it, then defer the delete
+	 * operation until the last route using it is deleted.
+	 */
+	if (!list_empty(&nh_grp->fib_list))
+		return;
+	mlxsw_sp_nexthop_obj_group_destroy(mlxsw_sp, nh_grp);
+}
+
+static int mlxsw_sp_nexthop_obj_event(struct notifier_block *nb,
+				      unsigned long event, void *ptr)
+{
+	struct nh_notifier_info *info = ptr;
+	struct mlxsw_sp_router *router;
+	int err = 0;
+
+	router = container_of(nb, struct mlxsw_sp_router, nexthop_nb);
+	err = mlxsw_sp_nexthop_obj_validate(router->mlxsw_sp, event, info);
+	if (err)
+		goto out;
+
+	mutex_lock(&router->lock);
+
+	ASSERT_RTNL();
+
+	switch (event) {
+	case NEXTHOP_EVENT_REPLACE:
+		err = mlxsw_sp_nexthop_obj_new(router->mlxsw_sp, info);
+		break;
+	case NEXTHOP_EVENT_DEL:
+		mlxsw_sp_nexthop_obj_del(router->mlxsw_sp, info);
+		break;
+	default:
+		break;
+	}
+
+	mutex_unlock(&router->lock);
+
+out:
+	return notifier_from_errno(err);
+}
+
 static bool mlxsw_sp_fi_is_gateway(const struct mlxsw_sp *mlxsw_sp,
 				   struct fib_info *fi)
 {
@@ -8549,6 +8989,14 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_register_netevent_notifier;
 
+	mlxsw_sp->router->nexthop_nb.notifier_call =
+		mlxsw_sp_nexthop_obj_event;
+	err = register_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
+					&mlxsw_sp->router->nexthop_nb,
+					extack);
+	if (err)
+		goto err_register_nexthop_notifier;
+
 	mlxsw_sp->router->fib_nb.notifier_call = mlxsw_sp_router_fib_event;
 	err = register_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				    &mlxsw_sp->router->fib_nb,
@@ -8559,6 +9007,9 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_register_fib_notifier:
+	unregister_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
+				    &mlxsw_sp->router->nexthop_nb);
+err_register_nexthop_notifier:
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 err_register_netevent_notifier:
 	unregister_inet6addr_notifier(&router->inet6addr_nb);
@@ -8598,6 +9049,8 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				&mlxsw_sp->router->fib_nb);
+	unregister_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
+				    &mlxsw_sp->router->nexthop_nb);
 	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
 	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
 	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 8230f6ff02ed..023f70827db0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -58,6 +58,7 @@ struct mlxsw_sp_router {
 	struct list_head nexthop_neighs_list;
 	struct list_head ipip_list;
 	bool aborted;
+	struct notifier_block nexthop_nb;
 	struct notifier_block fib_nb;
 	struct notifier_block netevent_nb;
 	struct notifier_block inetaddr_nb;
-- 
2.28.0

