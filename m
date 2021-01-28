Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E93E307670
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhA1MwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:52:09 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4105 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhA1MvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b3130000>; Thu, 28 Jan 2021 04:50:27 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:24 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 05/12] nexthop: Use enum to encode notification type
Date:   Thu, 28 Jan 2021 13:49:17 +0100
Message-ID: <687076047917503b42f35ef9739208b9aaa5bb15.1611836479.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1611836479.git.petrm@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL111.nvidia.com (172.20.187.18)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611838227; bh=xJgGqpYBI9pT+koFrxfW5EVWwCGR1zyUj89E2sTEH1Y=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=kxiVeb8z/e2OWyiWXABUuRBjnyIXcWY76Kv44HgW75hPFtK7UsqYBYBPbxrBlHH1h
         Ls0gmavxPGW+jWWR+YdLuNdBzQQ/43yYXxtUY6ZlonFbcwnJ9X+9RPIPgLXBdrhl6K
         s2KO588xXUY/FEIDd0x+gKiZ+0Eo9bszu/Z3OIhy1Q4peR9trMrNHgLakEtzlrztsV
         P/F8TsQBbAyN2Dk7xb3dK7d9R5DsNVNx92SC/o9jY5nFaNDoVhwLxEM9WmrxvbfXbJ
         YXkgzqQEI6fSk2qQUn3XYMGnje/Cg8VNNMj90rmhP9wgksFnFKcCjMarerw+W9RF/z
         1NN8SmqBdtQZg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently there are only two types of in-kernel nexthop notification.
The two are distinguished by the 'is_grp' boolean field in 'struct
nh_notifier_info'.

As more notification types are introduced for more next-hop group types, a
boolean is not an easily extensible interface. Instead, convert it to an
enum.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 54 ++++++++++++++-----
 drivers/net/netdevsim/fib.c                   | 23 ++++----
 include/net/nexthop.h                         |  7 ++-
 net/ipv4/nexthop.c                            | 14 ++---
 4 files changed, 69 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/driver=
s/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 41424ee909a0..0ac7014703aa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4309,11 +4309,18 @@ static int mlxsw_sp_nexthop_obj_validate(struct mlx=
sw_sp *mlxsw_sp,
 	if (event !=3D NEXTHOP_EVENT_REPLACE)
 		return 0;
=20
-	if (!info->is_grp)
+	switch (info->type) {
+	case NH_NOTIFIER_INFO_TYPE_SINGLE:
 		return mlxsw_sp_nexthop_obj_single_validate(mlxsw_sp, info->nh,
 							    info->extack);
-	return mlxsw_sp_nexthop_obj_group_validate(mlxsw_sp, info->nh_grp,
-						   info->extack);
+	case NH_NOTIFIER_INFO_TYPE_GRP:
+		return mlxsw_sp_nexthop_obj_group_validate(mlxsw_sp,
+							   info->nh_grp,
+							   info->extack);
+	default:
+		NL_SET_ERR_MSG_MOD(info->extack, "Unsupported nexthop type");
+		return -EOPNOTSUPP;
+	}
 }
=20
 static bool mlxsw_sp_nexthop_obj_is_gateway(struct mlxsw_sp *mlxsw_sp,
@@ -4321,13 +4328,17 @@ static bool mlxsw_sp_nexthop_obj_is_gateway(struct =
mlxsw_sp *mlxsw_sp,
 {
 	const struct net_device *dev;
=20
-	if (info->is_grp)
+	switch (info->type) {
+	case NH_NOTIFIER_INFO_TYPE_SINGLE:
+		dev =3D info->nh->dev;
+		return info->nh->gw_family || info->nh->is_reject ||
+		       mlxsw_sp_netdev_ipip_type(mlxsw_sp, dev, NULL);
+	case NH_NOTIFIER_INFO_TYPE_GRP:
 		/* Already validated earlier. */
 		return true;
-
-	dev =3D info->nh->dev;
-	return info->nh->gw_family || info->nh->is_reject ||
-	       mlxsw_sp_netdev_ipip_type(mlxsw_sp, dev, NULL);
+	default:
+		return false;
+	}
 }
=20
 static void mlxsw_sp_nexthop_obj_blackhole_init(struct mlxsw_sp *mlxsw_sp,
@@ -4410,11 +4421,22 @@ mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_s=
p *mlxsw_sp,
 				     struct mlxsw_sp_nexthop_group *nh_grp,
 				     struct nh_notifier_info *info)
 {
-	unsigned int nhs =3D info->is_grp ? info->nh_grp->num_nh : 1;
 	struct mlxsw_sp_nexthop_group_info *nhgi;
 	struct mlxsw_sp_nexthop *nh;
+	unsigned int nhs;
 	int err, i;
=20
+	switch (info->type) {
+	case NH_NOTIFIER_INFO_TYPE_SINGLE:
+		nhs =3D 1;
+		break;
+	case NH_NOTIFIER_INFO_TYPE_GRP:
+		nhs =3D info->nh_grp->num_nh;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	nhgi =3D kzalloc(struct_size(nhgi, nexthops, nhs), GFP_KERNEL);
 	if (!nhgi)
 		return -ENOMEM;
@@ -4427,12 +4449,18 @@ mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_s=
p *mlxsw_sp,
 		int weight;
=20
 		nh =3D &nhgi->nexthops[i];
-		if (info->is_grp) {
-			nh_obj =3D &info->nh_grp->nh_entries[i].nh;
-			weight =3D info->nh_grp->nh_entries[i].weight;
-		} else {
+		switch (info->type) {
+		case NH_NOTIFIER_INFO_TYPE_SINGLE:
 			nh_obj =3D info->nh;
 			weight =3D 1;
+			break;
+		case NH_NOTIFIER_INFO_TYPE_GRP:
+			nh_obj =3D &info->nh_grp->nh_entries[i].nh;
+			weight =3D info->nh_grp->nh_entries[i].weight;
+			break;
+		default:
+			err =3D -EINVAL;
+			goto err_nexthop_obj_init;
 		}
 		err =3D mlxsw_sp_nexthop_obj_init(mlxsw_sp, nh_grp, nh, nh_obj,
 						weight);
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 45d8a7790bd5..f140bbca98c5 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -860,7 +860,7 @@ static struct nsim_nexthop *nsim_nexthop_create(struct =
nsim_fib_data *data,
=20
 	nexthop =3D kzalloc(sizeof(*nexthop), GFP_KERNEL);
 	if (!nexthop)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
=20
 	nexthop->id =3D info->id;
=20
@@ -868,15 +868,20 @@ static struct nsim_nexthop *nsim_nexthop_create(struc=
t nsim_fib_data *data,
 	 * occupy.
 	 */
=20
-	if (!info->is_grp) {
+	switch (info->type) {
+	case NH_NOTIFIER_INFO_TYPE_SINGLE:
 		occ =3D 1;
-		goto out;
+		break;
+	case NH_NOTIFIER_INFO_TYPE_GRP:
+		for (i =3D 0; i < info->nh_grp->num_nh; i++)
+			occ +=3D info->nh_grp->nh_entries[i].weight;
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(info->extack, "Unsupported nexthop type");
+		kfree(nexthop);
+		return ERR_PTR(-EOPNOTSUPP);
 	}
=20
-	for (i =3D 0; i < info->nh_grp->num_nh; i++)
-		occ +=3D info->nh_grp->nh_entries[i].weight;
-
-out:
 	nexthop->occ =3D occ;
 	return nexthop;
 }
@@ -972,8 +977,8 @@ static int nsim_nexthop_insert(struct nsim_fib_data *da=
ta,
 	int err;
=20
 	nexthop =3D nsim_nexthop_create(data, info);
-	if (!nexthop)
-		return -ENOMEM;
+	if (IS_ERR(nexthop))
+		return PTR_ERR(nexthop);
=20
 	nexthop_old =3D rhashtable_lookup_fast(&data->nexthop_ht, &info->id,
 					     nsim_nexthop_ht_params);
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index d0e245b0635d..7bc057aee40b 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -114,6 +114,11 @@ enum nexthop_event_type {
 	NEXTHOP_EVENT_REPLACE,
 };
=20
+enum nh_notifier_info_type {
+	NH_NOTIFIER_INFO_TYPE_SINGLE,
+	NH_NOTIFIER_INFO_TYPE_GRP,
+};
+
 struct nh_notifier_single_info {
 	struct net_device *dev;
 	u8 gw_family;
@@ -142,7 +147,7 @@ struct nh_notifier_info {
 	struct net *net;
 	struct netlink_ext_ack *extack;
 	u32 id;
-	bool is_grp;
+	enum nh_notifier_info_type type;
 	union {
 		struct nh_notifier_single_info *nh;
 		struct nh_notifier_grp_info *nh_grp;
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index c09b8231f56a..12f812b9538d 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -71,6 +71,7 @@ __nh_notifier_single_info_init(struct nh_notifier_single_=
info *nh_info,
 static int nh_notifier_single_info_init(struct nh_notifier_info *info,
 					const struct nexthop *nh)
 {
+	info->type =3D NH_NOTIFIER_INFO_TYPE_SINGLE;
 	info->nh =3D kzalloc(sizeof(*info->nh), GFP_KERNEL);
 	if (!info->nh)
 		return -ENOMEM;
@@ -92,6 +93,7 @@ static int nh_notifier_grp_info_init(struct nh_notifier_i=
nfo *info,
 	u16 num_nh =3D nhg->num_nh;
 	int i;
=20
+	info->type =3D NH_NOTIFIER_INFO_TYPE_GRP;
 	info->nh_grp =3D kzalloc(struct_size(info->nh_grp, nh_entries, num_nh),
 			       GFP_KERNEL);
 	if (!info->nh_grp)
@@ -121,17 +123,17 @@ static int nh_notifier_info_init(struct nh_notifier_i=
nfo *info,
 				 const struct nexthop *nh)
 {
 	info->id =3D nh->id;
-	info->is_grp =3D nh->is_group;
=20
-	if (info->is_grp)
+	if (nh->is_group)
 		return nh_notifier_grp_info_init(info, nh);
 	else
 		return nh_notifier_single_info_init(info, nh);
 }
=20
-static void nh_notifier_info_fini(struct nh_notifier_info *info)
+static void nh_notifier_info_fini(struct nh_notifier_info *info,
+				  const struct nexthop *nh)
 {
-	if (info->is_grp)
+	if (nh->is_group)
 		nh_notifier_grp_info_fini(info);
 	else
 		nh_notifier_single_info_fini(info);
@@ -161,7 +163,7 @@ static int call_nexthop_notifiers(struct net *net,
=20
 	err =3D blocking_notifier_call_chain(&net->nexthop.notifier_chain,
 					   event_type, &info);
-	nh_notifier_info_fini(&info);
+	nh_notifier_info_fini(&info, nh);
=20
 	return notifier_to_errno(err);
 }
@@ -182,7 +184,7 @@ static int call_nexthop_notifier(struct notifier_block =
*nb, struct net *net,
 		return err;
=20
 	err =3D nb->notifier_call(nb, event_type, &info);
-	nh_notifier_info_fini(&info);
+	nh_notifier_info_fini(&info, nh);
=20
 	return notifier_to_errno(err);
 }
--=20
2.26.2

