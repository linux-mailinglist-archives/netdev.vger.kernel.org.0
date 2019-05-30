Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9534C2EAF9
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 05:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfE3DIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 23:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfE3DIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 23:08:04 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56EB124452;
        Thu, 30 May 2019 03:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185682;
        bh=MERhFEKwxtNytBJtsOjWn1J3VqCwPBz+Wg9wrOj23pM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBpj+QCt3ior65yAAJ/LFeWgnuoVHGipiUJQGFvvrK+yfVo9c9dV6UCcHSkeXL21Y
         X8W9MOqWMdxzJVoDVvPShpI1Ao6XnRYqCOLzVZPRf1OGB0ijaDxNuzzq8/m9ItzW1l
         37jnyBAZHYDUczn5UBaJoj/PikpG3VpuN9ary/v4=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 1/7] ipv4: Use accessors for fib_info nexthop data
Date:   Wed, 29 May 2019 20:07:54 -0700
Message-Id: <20190530030800.1683-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190530030800.1683-1-dsahern@kernel.org>
References: <20190530030800.1683-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Use helpers to access fib_nh and fib_nhs fields of a fib_info. Drop the
fib_dev macro which is an alias for the first nexthop. Replacements:

  fib_dev        --> fib_info_nh(fi, 0)->fib_nh_dev
  fi->fib_nh     --> fib_info_nh(fi, 0)
  fi->fib_nh[i]  --> fib_info_nh(fi, i)
  fi->fib_nhs    --> fib_info_num_path(fi)

Move the existing fib_info_nhc to nexthop.h and define the new ones
there. A later patch adds a check if a fib_info uses a nexthop object,
and defining the helpers in nexthop.h avoid circular header
dependencies.

After this all remaining open coded references to fi->fib_nhs and
fi->fib_nh are in:
- fib_create_info and helpers used to lookup an existing fib_info
  entry, and
- the netdev event functions fib_sync_down_dev and fib_sync_up.

The latter two will not be reused for nexthops, and the fib_create_info
will be updated to handle a nexthop in a fib_info.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   | 29 ++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 19 ++++---
 drivers/net/ethernet/rocker/rocker_ofdpa.c         | 25 +++++---
 include/net/ip_fib.h                               |  6 --
 include/net/nexthop.h                              | 15 +++++
 net/core/filter.c                                  |  3 +-
 net/ipv4/fib_frontend.c                            | 11 ++--
 net/ipv4/fib_lookup.h                              |  1 +
 net/ipv4/fib_rules.c                               |  8 ++-
 net/ipv4/fib_semantics.c                           | 66 ++++++++++++----------
 net/ipv4/fib_trie.c                                | 26 +++++----
 net/ipv4/route.c                                   |  3 +-
 12 files changed, 132 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 8212bfd05733..2cbfaa8da7fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #include <linux/netdevice.h>
+#include <net/nexthop.h>
 #include "lag.h"
 #include "lag_mp.h"
 #include "mlx5_core.h"
@@ -110,6 +111,8 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 				     struct fib_info *fi)
 {
 	struct lag_mp *mp = &ldev->lag_mp;
+	struct fib_nh *fib_nh0, *fib_nh1;
+	unsigned int nhs;
 
 	/* Handle delete event */
 	if (event == FIB_EVENT_ENTRY_DEL) {
@@ -120,9 +123,11 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 	}
 
 	/* Handle add/replace event */
-	if (fi->fib_nhs == 1) {
+	nhs = fib_info_num_path(fi);
+	if (nhs == 1) {
 		if (__mlx5_lag_is_active(ldev)) {
-			struct net_device *nh_dev = fi->fib_nh[0].fib_nh_dev;
+			struct fib_nh *nh = fib_info_nh(fi, 0);
+			struct net_device *nh_dev = nh->fib_nh_dev;
 			int i = mlx5_lag_dev_get_netdev_idx(ldev, nh_dev);
 
 			mlx5_lag_set_port_affinity(ldev, ++i);
@@ -130,14 +135,16 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 		return;
 	}
 
-	if (fi->fib_nhs != 2)
+	if (nhs != 2)
 		return;
 
 	/* Verify next hops are ports of the same hca */
-	if (!(fi->fib_nh[0].fib_nh_dev == ldev->pf[0].netdev &&
-	      fi->fib_nh[1].fib_nh_dev == ldev->pf[1].netdev) &&
-	    !(fi->fib_nh[0].fib_nh_dev == ldev->pf[1].netdev &&
-	      fi->fib_nh[1].fib_nh_dev == ldev->pf[0].netdev)) {
+	fib_nh0 = fib_info_nh(fi, 0);
+	fib_nh1 = fib_info_nh(fi, 1);
+	if (!(fib_nh0->fib_nh_dev == ldev->pf[0].netdev &&
+	      fib_nh1->fib_nh_dev == ldev->pf[1].netdev) &&
+	    !(fib_nh0->fib_nh_dev == ldev->pf[1].netdev &&
+	      fib_nh1->fib_nh_dev == ldev->pf[0].netdev)) {
 		mlx5_core_warn(ldev->pf[0].dev, "Multipath offload require two ports of the same HCA\n");
 		return;
 	}
@@ -174,7 +181,7 @@ static void mlx5_lag_fib_nexthop_event(struct mlx5_lag *ldev,
 			mlx5_lag_set_port_affinity(ldev, i);
 		}
 	} else if (event == FIB_EVENT_NH_ADD &&
-		   fi->fib_nhs == 2) {
+		   fib_info_num_path(fi) == 2) {
 		mlx5_lag_set_port_affinity(ldev, 0);
 	}
 }
@@ -238,6 +245,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 	struct mlx5_fib_event_work *fib_work;
 	struct fib_entry_notifier_info *fen_info;
 	struct fib_nh_notifier_info *fnh_info;
+	struct net_device *fib_dev;
 	struct fib_info *fi;
 
 	if (info->family != AF_INET)
@@ -254,8 +262,9 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
 		fi = fen_info->fi;
-		if (fi->fib_dev != ldev->pf[0].netdev &&
-		    fi->fib_dev != ldev->pf[1].netdev) {
+		fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
+		if (fib_dev != ldev->pf[0].netdev &&
+		    fib_dev != ldev->pf[1].netdev) {
 			return NOTIFY_DONE;
 		}
 		fib_work = mlx5_lag_init_fib_work(ldev, event);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0ec52be7cc33..4f781358aef1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -21,6 +21,7 @@
 #include <net/arp.h>
 #include <net/ip_fib.h>
 #include <net/ip6_fib.h>
+#include <net/nexthop.h>
 #include <net/fib_rules.h>
 #include <net/ip_tunnels.h>
 #include <net/l3mdev.h>
@@ -3816,23 +3817,25 @@ static void mlxsw_sp_nexthop_rif_gone_sync(struct mlxsw_sp *mlxsw_sp,
 }
 
 static bool mlxsw_sp_fi_is_gateway(const struct mlxsw_sp *mlxsw_sp,
-				   const struct fib_info *fi)
+				   struct fib_info *fi)
 {
-	return fi->fib_nh->fib_nh_scope == RT_SCOPE_LINK ||
-	       mlxsw_sp_nexthop4_ipip_type(mlxsw_sp, fi->fib_nh, NULL);
+	const struct fib_nh *nh = fib_info_nh(fi, 0);
+
+	return nh->fib_nh_scope == RT_SCOPE_LINK ||
+	       mlxsw_sp_nexthop4_ipip_type(mlxsw_sp, nh, NULL);
 }
 
 static struct mlxsw_sp_nexthop_group *
 mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 {
+	unsigned int nhs = fib_info_num_path(fi);
 	struct mlxsw_sp_nexthop_group *nh_grp;
 	struct mlxsw_sp_nexthop *nh;
 	struct fib_nh *fib_nh;
 	int i;
 	int err;
 
-	nh_grp = kzalloc(struct_size(nh_grp, nexthops, fi->fib_nhs),
-			 GFP_KERNEL);
+	nh_grp = kzalloc(struct_size(nh_grp, nexthops, nhs), GFP_KERNEL);
 	if (!nh_grp)
 		return ERR_PTR(-ENOMEM);
 	nh_grp->priv = fi;
@@ -3840,11 +3843,11 @@ mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 	nh_grp->neigh_tbl = &arp_tbl;
 
 	nh_grp->gateway = mlxsw_sp_fi_is_gateway(mlxsw_sp, fi);
-	nh_grp->count = fi->fib_nhs;
+	nh_grp->count = nhs;
 	fib_info_hold(fi);
 	for (i = 0; i < nh_grp->count; i++) {
 		nh = &nh_grp->nexthops[i];
-		fib_nh = &fi->fib_nh[i];
+		fib_nh = fib_info_nh(fi, i);
 		err = mlxsw_sp_nexthop4_init(mlxsw_sp, nh_grp, nh, fib_nh);
 		if (err)
 			goto err_nexthop4_init;
@@ -4282,9 +4285,9 @@ mlxsw_sp_fib4_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 			     const struct fib_entry_notifier_info *fen_info,
 			     struct mlxsw_sp_fib_entry *fib_entry)
 {
+	struct net_device *dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
 	union mlxsw_sp_l3addr dip = { .addr4 = htonl(fen_info->dst) };
 	u32 tb_id = mlxsw_sp_fix_tb_id(fen_info->tb_id);
-	struct net_device *dev = fen_info->fi->fib_dev;
 	struct mlxsw_sp_ipip_entry *ipip_entry;
 	struct fib_info *fi = fen_info->fi;
 
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 30a49802fb51..47ed9d41047f 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -22,6 +22,7 @@
 #include <net/neighbour.h>
 #include <net/switchdev.h>
 #include <net/ip_fib.h>
+#include <net/nexthop.h>
 #include <net/arp.h>
 
 #include "rocker.h"
@@ -2286,8 +2287,8 @@ static int ofdpa_port_fib_ipv4(struct ofdpa_port *ofdpa_port,  __be32 dst,
 
 	/* XXX support ECMP */
 
-	nh = fi->fib_nh;
-	nh_on_port = (fi->fib_dev == ofdpa_port->dev);
+	nh = fib_info_nh(fi, 0);
+	nh_on_port = (nh->fib_nh_dev == ofdpa_port->dev);
 	has_gw = !!nh->fib_nh_gw4;
 
 	if (has_gw && nh_on_port) {
@@ -2737,11 +2738,13 @@ static int ofdpa_fib4_add(struct rocker *rocker,
 {
 	struct ofdpa *ofdpa = rocker->wpriv;
 	struct ofdpa_port *ofdpa_port;
+	struct fib_nh *nh;
 	int err;
 
 	if (ofdpa->fib_aborted)
 		return 0;
-	ofdpa_port = ofdpa_port_dev_lower_find(fen_info->fi->fib_dev, rocker);
+	nh = fib_info_nh(fen_info->fi, 0);
+	ofdpa_port = ofdpa_port_dev_lower_find(nh->fib_nh_dev, rocker);
 	if (!ofdpa_port)
 		return 0;
 	err = ofdpa_port_fib_ipv4(ofdpa_port, htonl(fen_info->dst),
@@ -2749,7 +2752,7 @@ static int ofdpa_fib4_add(struct rocker *rocker,
 				  fen_info->tb_id, 0);
 	if (err)
 		return err;
-	fen_info->fi->fib_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
+	nh->fib_nh_flags |= RTNH_F_OFFLOAD;
 	return 0;
 }
 
@@ -2758,13 +2761,15 @@ static int ofdpa_fib4_del(struct rocker *rocker,
 {
 	struct ofdpa *ofdpa = rocker->wpriv;
 	struct ofdpa_port *ofdpa_port;
+	struct fib_nh *nh;
 
 	if (ofdpa->fib_aborted)
 		return 0;
-	ofdpa_port = ofdpa_port_dev_lower_find(fen_info->fi->fib_dev, rocker);
+	nh = fib_info_nh(fen_info->fi, 0);
+	ofdpa_port = ofdpa_port_dev_lower_find(nh->fib_nh_dev, rocker);
 	if (!ofdpa_port)
 		return 0;
-	fen_info->fi->fib_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
+	nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
 	return ofdpa_port_fib_ipv4(ofdpa_port, htonl(fen_info->dst),
 				   fen_info->dst_len, fen_info->fi,
 				   fen_info->tb_id, OFDPA_OP_FLAG_REMOVE);
@@ -2784,14 +2789,16 @@ static void ofdpa_fib4_abort(struct rocker *rocker)
 
 	spin_lock_irqsave(&ofdpa->flow_tbl_lock, flags);
 	hash_for_each_safe(ofdpa->flow_tbl, bkt, tmp, flow_entry, entry) {
+		struct fib_nh *nh;
+
 		if (flow_entry->key.tbl_id !=
 		    ROCKER_OF_DPA_TABLE_ID_UNICAST_ROUTING)
 			continue;
-		ofdpa_port = ofdpa_port_dev_lower_find(flow_entry->fi->fib_dev,
-						       rocker);
+		nh = fib_info_nh(flow_entry->fi, 0);
+		ofdpa_port = ofdpa_port_dev_lower_find(nh->fib_nh_dev, rocker);
 		if (!ofdpa_port)
 			continue;
-		flow_entry->fi->fib_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
+		nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
 		ofdpa_flow_tbl_del(ofdpa_port, OFDPA_OP_FLAG_REMOVE,
 				   flow_entry);
 	}
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 70ba0302c8c9..42b1a806f6f5 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -153,7 +153,6 @@ struct fib_info {
 	bool			nh_updated;
 	struct rcu_head		rcu;
 	struct fib_nh		fib_nh[0];
-#define fib_dev		fib_nh[0].fib_nh_dev
 };
 
 
@@ -190,11 +189,6 @@ struct fib_result_nl {
 	int             err;
 };
 
-static inline struct fib_nh_common *fib_info_nhc(struct fib_info *fi, int nhsel)
-{
-	return &fi->fib_nh[nhsel].nh_common;
-}
-
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 #define FIB_TABLE_HASHSZ 256
 #else
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 6e1b8f53624c..e501d77b82c8 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -192,4 +192,19 @@ static inline bool nexthop_is_blackhole(const struct nexthop *nh)
 	nhi = rcu_dereference_rtnl(nh->nh_info);
 	return nhi->reject_nh;
 }
+
+static inline unsigned int fib_info_num_path(const struct fib_info *fi)
+{
+	return fi->fib_nhs;
+}
+
+static inline struct fib_nh_common *fib_info_nhc(struct fib_info *fi, int nhsel)
+{
+	return &fi->fib_nh[nhsel].nh_common;
+}
+
+static inline struct fib_nh *fib_info_nh(struct fib_info *fi, int nhsel)
+{
+	return &fi->fib_nh[nhsel];
+}
 #endif
diff --git a/net/core/filter.c b/net/core/filter.c
index 55bfc941d17a..2ae72bbfa6d2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -66,6 +66,7 @@
 #include <net/inet_hashtables.h>
 #include <net/inet6_hashtables.h>
 #include <net/ip_fib.h>
+#include <net/nexthop.h>
 #include <net/flow.h>
 #include <net/arp.h>
 #include <net/ipv6.h>
@@ -4674,7 +4675,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	if (res.type != RTN_UNICAST)
 		return BPF_FIB_LKUP_RET_NOT_FWDED;
 
-	if (res.fi->fib_nhs > 1)
+	if (fib_info_num_path(res.fi) > 1)
 		fib_select_path(net, &res, &fl4, NULL);
 
 	if (check_mtu) {
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 76055c66326a..ab369959ce0b 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -43,6 +43,7 @@
 #include <net/sock.h>
 #include <net/arp.h>
 #include <net/ip_fib.h>
+#include <net/nexthop.h>
 #include <net/rtnetlink.h>
 #include <net/xfrm.h>
 #include <net/l3mdev.h>
@@ -234,7 +235,9 @@ static inline unsigned int __inet_dev_addr_type(struct net *net,
 	if (table) {
 		ret = RTN_UNICAST;
 		if (!fib_table_lookup(table, &fl4, &res, FIB_LOOKUP_NOREF)) {
-			if (!dev || dev == res.fi->fib_dev)
+			struct fib_nh *nh = fib_info_nh(res.fi, 0);
+
+			if (!dev || dev == nh->fib_nh_dev)
 				ret = res.type;
 		}
 	}
@@ -321,8 +324,8 @@ bool fib_info_nh_uses_dev(struct fib_info *fi, const struct net_device *dev)
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 	int ret;
 
-	for (ret = 0; ret < fi->fib_nhs; ret++) {
-		struct fib_nh *nh = &fi->fib_nh[ret];
+	for (ret = 0; ret < fib_info_num_path(fi); ret++) {
+		const struct fib_nh *nh = fib_info_nh(fi, ret);
 
 		if (nh->fib_nh_dev == dev) {
 			dev_match = true;
@@ -333,7 +336,7 @@ bool fib_info_nh_uses_dev(struct fib_info *fi, const struct net_device *dev)
 		}
 	}
 #else
-	if (fi->fib_nh[0].fib_nh_dev == dev)
+	if (fib_info_nh(fi, 0)->fib_nh_dev == dev)
 		dev_match = true;
 #endif
 
diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index 7945f0534db7..a68b5e21ec51 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <net/ip_fib.h>
+#include <net/nexthop.h>
 
 struct fib_alias {
 	struct hlist_node	fa_list;
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index cfec3af54c8d..ab06fd73b343 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -31,6 +31,7 @@
 #include <net/route.h>
 #include <net/tcp.h>
 #include <net/ip_fib.h>
+#include <net/nexthop.h>
 #include <net/fib_rules.h>
 
 struct fib4_rule {
@@ -145,8 +146,11 @@ static bool fib4_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
 	struct fib_result *result = (struct fib_result *) arg->result;
 	struct net_device *dev = NULL;
 
-	if (result->fi)
-		dev = result->fi->fib_dev;
+	if (result->fi) {
+		struct fib_nh *nh = fib_info_nh(result->fi, 0);
+
+		dev = nh->fib_nh_dev;
+	}
 
 	/* do not accept result if the route does
 	 * not meet the required prefix length
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 78648072783e..a37ff07718a8 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -42,6 +42,7 @@
 #include <net/sock.h>
 #include <net/ip_fib.h>
 #include <net/ip6_fib.h>
+#include <net/nexthop.h>
 #include <net/netlink.h>
 #include <net/rtnh.h>
 #include <net/lwtunnel.h>
@@ -65,13 +66,13 @@ static struct hlist_head fib_info_devhash[DEVINDEX_HASHSIZE];
 #define for_nexthops(fi) {						\
 	int nhsel; const struct fib_nh *nh;				\
 	for (nhsel = 0, nh = (fi)->fib_nh;				\
-	     nhsel < (fi)->fib_nhs;					\
+	     nhsel < fib_info_num_path((fi));				\
 	     nh++, nhsel++)
 
 #define change_nexthops(fi) {						\
 	int nhsel; struct fib_nh *nexthop_nh;				\
 	for (nhsel = 0,	nexthop_nh = (struct fib_nh *)((fi)->fib_nh);	\
-	     nhsel < (fi)->fib_nhs;					\
+	     nhsel < fib_info_num_path((fi));				\
 	     nexthop_nh++, nhsel++)
 
 #else /* CONFIG_IP_ROUTE_MULTIPATH */
@@ -271,11 +272,13 @@ void fib_release_info(struct fib_info *fi)
 	spin_unlock_bh(&fib_info_lock);
 }
 
-static inline int nh_comp(const struct fib_info *fi, const struct fib_info *ofi)
+static inline int nh_comp(struct fib_info *fi, struct fib_info *ofi)
 {
-	const struct fib_nh *onh = ofi->fib_nh;
+	const struct fib_nh *onh;
 
 	for_nexthops(fi) {
+		onh = fib_info_nh(ofi, nhsel);
+
 		if (nh->fib_nh_oif != onh->fib_nh_oif ||
 		    nh->fib_nh_gw_family != onh->fib_nh_gw_family ||
 		    nh->fib_nh_scope != onh->fib_nh_scope ||
@@ -296,8 +299,6 @@ static inline int nh_comp(const struct fib_info *fi, const struct fib_info *ofi)
 		if (nh->fib_nh_gw_family == AF_INET6 &&
 		    ipv6_addr_cmp(&nh->fib_nh_gw6, &onh->fib_nh_gw6))
 			return -1;
-
-		onh++;
 	} endfor_nexthops(fi);
 	return 0;
 }
@@ -326,7 +327,7 @@ static inline unsigned int fib_info_hashfn(const struct fib_info *fi)
 	return (val ^ (val >> 7) ^ (val >> 12)) & mask;
 }
 
-static struct fib_info *fib_find_info(const struct fib_info *nfi)
+static struct fib_info *fib_find_info(struct fib_info *nfi)
 {
 	struct hlist_head *head;
 	struct fib_info *fi;
@@ -390,13 +391,14 @@ static inline size_t fib_nlmsg_size(struct fib_info *fi)
 			 + nla_total_size(4) /* RTA_PRIORITY */
 			 + nla_total_size(4) /* RTA_PREFSRC */
 			 + nla_total_size(TCP_CA_NAME_MAX); /* RTAX_CC_ALGO */
+	unsigned int nhs = fib_info_num_path(fi);
 
 	/* space for nested metrics */
 	payload += nla_total_size((RTAX_MAX * nla_total_size(4)));
 
-	if (fi->fib_nhs) {
+	if (nhs) {
 		size_t nh_encapsize = 0;
-		/* Also handles the special case fib_nhs == 1 */
+		/* Also handles the special case nhs == 1 */
 
 		/* each nexthop is packed in an attribute */
 		size_t nhsize = nla_total_size(sizeof(struct rtnexthop));
@@ -416,8 +418,7 @@ static inline size_t fib_nlmsg_size(struct fib_info *fi)
 		} endfor_nexthops(fi);
 
 		/* all nexthops are packed in a nested attribute */
-		payload += nla_total_size((fi->fib_nhs * nhsize) +
-					  nh_encapsize);
+		payload += nla_total_size((nhs * nhsize) + nh_encapsize);
 
 	}
 
@@ -584,6 +585,7 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 {
 	struct net *net = fi->fib_net;
 	struct fib_config fib_cfg;
+	struct fib_nh *nh;
 	int ret;
 
 	change_nexthops(fi) {
@@ -646,24 +648,25 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 	} endfor_nexthops(fi);
 
 	ret = -EINVAL;
-	if (cfg->fc_oif && fi->fib_nh->fib_nh_oif != cfg->fc_oif) {
+	nh = fib_info_nh(fi, 0);
+	if (cfg->fc_oif && nh->fib_nh_oif != cfg->fc_oif) {
 		NL_SET_ERR_MSG(extack,
 			       "Nexthop device index does not match RTA_OIF");
 		goto errout;
 	}
 	if (cfg->fc_gw_family) {
-		if (cfg->fc_gw_family != fi->fib_nh->fib_nh_gw_family ||
+		if (cfg->fc_gw_family != nh->fib_nh_gw_family ||
 		    (cfg->fc_gw_family == AF_INET &&
-		     fi->fib_nh->fib_nh_gw4 != cfg->fc_gw4) ||
+		     nh->fib_nh_gw4 != cfg->fc_gw4) ||
 		    (cfg->fc_gw_family == AF_INET6 &&
-		     ipv6_addr_cmp(&fi->fib_nh->fib_nh_gw6, &cfg->fc_gw6))) {
+		     ipv6_addr_cmp(&nh->fib_nh_gw6, &cfg->fc_gw6))) {
 			NL_SET_ERR_MSG(extack,
 				       "Nexthop gateway does not match RTA_GATEWAY or RTA_VIA");
 			goto errout;
 		}
 	}
 #ifdef CONFIG_IP_ROUTE_CLASSID
-	if (cfg->fc_flow && fi->fib_nh->nh_tclassid != cfg->fc_flow) {
+	if (cfg->fc_flow && nh->nh_tclassid != cfg->fc_flow) {
 		NL_SET_ERR_MSG(extack,
 			       "Nexthop class id does not match RTA_FLOW");
 		goto errout;
@@ -679,7 +682,7 @@ static void fib_rebalance(struct fib_info *fi)
 	int total;
 	int w;
 
-	if (fi->fib_nhs < 2)
+	if (fib_info_num_path(fi) < 2)
 		return;
 
 	total = 0;
@@ -761,27 +764,29 @@ int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 
 	if (cfg->fc_oif || cfg->fc_gw_family) {
+		struct fib_nh *nh = fib_info_nh(fi, 0);
+
 		if (cfg->fc_encap) {
 			if (fib_encap_match(cfg->fc_encap_type, cfg->fc_encap,
-					    fi->fib_nh, cfg, extack))
+					    nh, cfg, extack))
 				return 1;
 		}
 #ifdef CONFIG_IP_ROUTE_CLASSID
 		if (cfg->fc_flow &&
-		    cfg->fc_flow != fi->fib_nh->nh_tclassid)
+		    cfg->fc_flow != nh->nh_tclassid)
 			return 1;
 #endif
-		if ((cfg->fc_oif && cfg->fc_oif != fi->fib_nh->fib_nh_oif) ||
+		if ((cfg->fc_oif && cfg->fc_oif != nh->fib_nh_oif) ||
 		    (cfg->fc_gw_family &&
-		     cfg->fc_gw_family != fi->fib_nh->fib_nh_gw_family))
+		     cfg->fc_gw_family != nh->fib_nh_gw_family))
 			return 1;
 
 		if (cfg->fc_gw_family == AF_INET &&
-		    cfg->fc_gw4 != fi->fib_nh->fib_nh_gw4)
+		    cfg->fc_gw4 != nh->fib_nh_gw4)
 			return 1;
 
 		if (cfg->fc_gw_family == AF_INET6 &&
-		    ipv6_addr_cmp(&cfg->fc_gw6, &fi->fib_nh->fib_nh_gw6))
+		    ipv6_addr_cmp(&cfg->fc_gw6, &nh->fib_nh_gw6))
 			return 1;
 
 		return 0;
@@ -1366,7 +1371,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 			goto err_inval;
 		}
 		nh->fib_nh_scope = RT_SCOPE_NOWHERE;
-		nh->fib_nh_dev = dev_get_by_index(net, fi->fib_nh->fib_nh_oif);
+		nh->fib_nh_dev = dev_get_by_index(net, nh->fib_nh_oif);
 		err = -ENODEV;
 		if (!nh->fib_nh_dev)
 			goto failure;
@@ -1583,6 +1588,7 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		  u32 tb_id, u8 type, __be32 dst, int dst_len, u8 tos,
 		  struct fib_info *fi, unsigned int flags)
 {
+	unsigned int nhs = fib_info_num_path(fi);
 	struct nlmsghdr *nlh;
 	struct rtmsg *rtm;
 
@@ -1618,8 +1624,8 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 	if (fi->fib_prefsrc &&
 	    nla_put_in_addr(skb, RTA_PREFSRC, fi->fib_prefsrc))
 		goto nla_put_failure;
-	if (fi->fib_nhs == 1) {
-		struct fib_nh *nh = &fi->fib_nh[0];
+	if (nhs == 1) {
+		const struct fib_nh *nh = fib_info_nh(fi, 0);
 		unsigned char flags = 0;
 
 		if (fib_nexthop_info(skb, &nh->nh_common, &flags, false) < 0)
@@ -1838,6 +1844,7 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 
 	hlist_for_each_entry_rcu(fa, fa_head, fa_list) {
 		struct fib_info *next_fi = fa->fa_info;
+		struct fib_nh *nh;
 
 		if (fa->fa_slen != slen)
 			continue;
@@ -1859,8 +1866,9 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 		if (next_fi->fib_scope != res->scope ||
 		    fa->fa_type != RTN_UNICAST)
 			continue;
-		if (!next_fi->fib_nh[0].fib_nh_gw4 ||
-		    next_fi->fib_nh[0].fib_nh_scope != RT_SCOPE_LINK)
+
+		nh = fib_info_nh(next_fi, 0);
+		if (!nh->fib_nh_gw4 || nh->fib_nh_scope != RT_SCOPE_LINK)
 			continue;
 
 		fib_alias_accessed(fa);
@@ -2024,7 +2032,7 @@ void fib_select_path(struct net *net, struct fib_result *res,
 		goto check_saddr;
 
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
-	if (res->fi->fib_nhs > 1) {
+	if (fib_info_num_path(res->fi) > 1) {
 		int h = fib_multipath_hash(net, fl4, skb, NULL);
 
 		fib_select_multipath(res, h);
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index b53ecef89d59..5c8a4d21b8e0 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1469,7 +1469,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 		}
 		if (fi->fib_flags & RTNH_F_DEAD)
 			continue;
-		for (nhsel = 0; nhsel < fi->fib_nhs; nhsel++) {
+		for (nhsel = 0; nhsel < fib_info_num_path(fi); nhsel++) {
 			struct fib_nh_common *nhc = fib_info_nhc(fi, nhsel);
 
 			if (nhc->nhc_flags & RTNH_F_DEAD)
@@ -2717,14 +2717,18 @@ static void fib_route_seq_stop(struct seq_file *seq, void *v)
 	rcu_read_unlock();
 }
 
-static unsigned int fib_flag_trans(int type, __be32 mask, const struct fib_info *fi)
+static unsigned int fib_flag_trans(int type, __be32 mask, struct fib_info *fi)
 {
 	unsigned int flags = 0;
 
 	if (type == RTN_UNREACHABLE || type == RTN_PROHIBIT)
 		flags = RTF_REJECT;
-	if (fi && fi->fib_nh->fib_nh_gw4)
-		flags |= RTF_GATEWAY;
+	if (fi) {
+		const struct fib_nh *nh = fib_info_nh(fi, 0);
+
+		if (nh->fib_nh_gw4)
+			flags |= RTF_GATEWAY;
+	}
 	if (mask == htonl(0xFFFFFFFF))
 		flags |= RTF_HOST;
 	flags |= RTF_UP;
@@ -2755,7 +2759,7 @@ static int fib_route_seq_show(struct seq_file *seq, void *v)
 	prefix = htonl(l->key);
 
 	hlist_for_each_entry_rcu(fa, &l->leaf, fa_list) {
-		const struct fib_info *fi = fa->fa_info;
+		struct fib_info *fi = fa->fa_info;
 		__be32 mask = inet_make_mask(KEYLENGTH - fa->fa_slen);
 		unsigned int flags = fib_flag_trans(fa->fa_type, mask, fi);
 
@@ -2768,26 +2772,28 @@ static int fib_route_seq_show(struct seq_file *seq, void *v)
 
 		seq_setwidth(seq, 127);
 
-		if (fi)
+		if (fi) {
+			struct fib_nh *nh = fib_info_nh(fi, 0);
+
 			seq_printf(seq,
 				   "%s\t%08X\t%08X\t%04X\t%d\t%u\t"
 				   "%d\t%08X\t%d\t%u\t%u",
-				   fi->fib_dev ? fi->fib_dev->name : "*",
+				   nh->fib_nh_dev ? nh->fib_nh_dev->name : "*",
 				   prefix,
-				   fi->fib_nh->fib_nh_gw4, flags, 0, 0,
+				   nh->fib_nh_gw4, flags, 0, 0,
 				   fi->fib_priority,
 				   mask,
 				   (fi->fib_advmss ?
 				    fi->fib_advmss + 40 : 0),
 				   fi->fib_window,
 				   fi->fib_rtt >> 3);
-		else
+		} else {
 			seq_printf(seq,
 				   "*\t%08X\t%08X\t%04X\t%d\t%u\t"
 				   "%d\t%08X\t%d\t%u\t%u",
 				   prefix, 0, flags, 0, 0, 0,
 				   mask, 0, 0, 0);
-
+		}
 		seq_pad(seq, '\n');
 	}
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 11ddc276776e..05a6a8ecb574 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -99,6 +99,7 @@
 #include <net/inetpeer.h>
 #include <net/sock.h>
 #include <net/ip_fib.h>
+#include <net/nexthop.h>
 #include <net/arp.h>
 #include <net/tcp.h>
 #include <net/icmp.h>
@@ -1950,7 +1951,7 @@ static int ip_mkroute_input(struct sk_buff *skb,
 			    struct flow_keys *hkeys)
 {
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
-	if (res->fi && res->fi->fib_nhs > 1) {
+	if (res->fi && fib_info_num_path(res->fi) > 1) {
 		int h = fib_multipath_hash(res->fi->fib_net, NULL, skb, hkeys);
 
 		fib_select_multipath(res, h);
-- 
2.11.0

