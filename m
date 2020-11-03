Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256F32A4FF3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgKCTT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:28 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4548 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729579AbgKCTTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad2d0000>; Tue, 03 Nov 2020 11:19:09 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:19:04 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Aya Levin" <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 8/9] net/mlx5e: Fix VXLAN synchronization after function reload
Date:   Tue, 3 Nov 2020 11:18:29 -0800
Message-ID: <20201103191830.60151-9-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103191830.60151-1-saeedm@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604431149; bh=Auh3Ysfify5QN+Z2eyQjtB8NZS24ss3BI1Hv439pJC0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=MMD/zMdOEef05+L1ZDMIpRBksVE+q1UwSWmi5/gtYPgtBeQfAEaLpnjG8Or2yq1jn
         zv6ZNsFNc9pOD1F3lZdAVQ+7h6VKZLl3zb/zqyAeRpCiPJrDPSq7zZb9c3P4ob9ZTi
         u75vBVOzTlimLBbb5/jEorfDRaN+Y0krBOmbmoCKT0ziP2zB5AUDpKouU5C8oVBSbl
         gva7FHgyrx517wVpTptAM9U/CzPuCc2ofktoUuNkFwHaCsdElqbRoPNjtyf3mL/24f
         PGSnACGN9go21bo4I0GNf0IMSAAsGzMCm0sBbg6oQ/U97KvSGCSN+mTDo4fNQZU6wl
         e7bcQHZTAEoeg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

During driver reload, perform firmware tear-down which results in
firmware losing the configured VXLAN ports. These ports are still
available in the driver's database. Fix this by cleaning up driver's
VXLAN database in the nic unload flow, before firmware tear-down. With
that, minimize mlx5_vxlan_destroy() to remove only what was added in
mlx5_vxlan_create() and warn on leftover UDP ports.

Fixes: 18a2b7f969c9 ("net/mlx5: convert to new udp_tunnel infrastructure")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   | 23 ++++++++++++++-----
 .../ethernet/mellanox/mlx5/core/lib/vxlan.h   |  2 ++
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index b3f02aac7f26..ebce97921e03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5253,6 +5253,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv=
)
=20
 	mlx5e_disable_async_events(priv);
 	mlx5_lag_remove(mdev);
+	mlx5_vxlan_reset_to_default(mdev->vxlan);
 }
=20
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index 3315afe2f8dc..38084400ee8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -167,6 +167,17 @@ struct mlx5_vxlan *mlx5_vxlan_create(struct mlx5_core_=
dev *mdev)
 }
=20
 void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan)
+{
+	if (!mlx5_vxlan_allowed(vxlan))
+		return;
+
+	mlx5_vxlan_del_port(vxlan, IANA_VXLAN_UDP_PORT);
+	WARN_ON(!hash_empty(vxlan->htable));
+
+	kfree(vxlan);
+}
+
+void mlx5_vxlan_reset_to_default(struct mlx5_vxlan *vxlan)
 {
 	struct mlx5_vxlan_port *vxlanp;
 	struct hlist_node *tmp;
@@ -175,12 +186,12 @@ void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan)
 	if (!mlx5_vxlan_allowed(vxlan))
 		return;
=20
-	/* Lockless since we are the only hash table consumers*/
 	hash_for_each_safe(vxlan->htable, bkt, tmp, vxlanp, hlist) {
-		hash_del(&vxlanp->hlist);
-		mlx5_vxlan_core_del_port_cmd(vxlan->mdev, vxlanp->udp_port);
-		kfree(vxlanp);
+		/* Don't delete default UDP port added by the HW.
+		 * Remove only user configured ports
+		 */
+		if (vxlanp->udp_port =3D=3D IANA_VXLAN_UDP_PORT)
+			continue;
+		mlx5_vxlan_del_port(vxlan, vxlanp->udp_port);
 	}
-
-	kfree(vxlan);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h b/drivers/=
net/ethernet/mellanox/mlx5/core/lib/vxlan.h
index ec766529f49b..34ef662da35e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
@@ -56,6 +56,7 @@ void mlx5_vxlan_destroy(struct mlx5_vxlan *vxlan);
 int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port);
 int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port);
 bool mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 port);
+void mlx5_vxlan_reset_to_default(struct mlx5_vxlan *vxlan);
 #else
 static inline struct mlx5_vxlan*
 mlx5_vxlan_create(struct mlx5_core_dev *mdev) { return ERR_PTR(-EOPNOTSUPP=
); }
@@ -63,6 +64,7 @@ static inline void mlx5_vxlan_destroy(struct mlx5_vxlan *=
vxlan) { return; }
 static inline int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port) =
{ return -EOPNOTSUPP; }
 static inline int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port) =
{ return -EOPNOTSUPP; }
 static inline bool mlx5_vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 po=
rt) { return false; }
+static inline void mlx5_vxlan_reset_to_default(struct mlx5_vxlan *vxlan) {=
 return; }
 #endif
=20
 #endif /* __MLX5_VXLAN_H__ */
--=20
2.26.2

