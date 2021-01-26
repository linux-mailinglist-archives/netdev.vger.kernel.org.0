Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E17B30552D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbhA0ICD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 03:02:03 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8256 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S315192AbhAZX1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:27:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4c20000>; Tue, 26 Jan 2021 15:24:50 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:50 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/14] net/mlx5e: Enable traps according to link state
Date:   Tue, 26 Jan 2021 15:24:19 -0800
Message-ID: <20210126232419.175836-15-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126232419.175836-1-saeedm@nvidia.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611703490; bh=7TYcSXniewij/fdB+CeNhZrOtYIYRWqf4/a3CGJbmD0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Jl9gBeNG8JdCu2gotjHDfUrerbt2nH98eUtAWL4d5Iphor89Qd0JGS8wIH2TFtBzt
         owZS0AG1GOLjLKHX2jFwQM9Iakb65UondIyNIX/aD/dGKa9XAz6tdo72Vz6GzYxX7S
         f2Uhobbq/ylO3Ot9MKOsy2TXlIKgPFy4GKFUa3NonXNXpA+SnRH19iAUsuaALbVM+f
         r4BTZFXCL6c+1NmPDQNLr35snt57PmQJ9Hp1vpMhLoM+FPEy4m6qGvKkhiyPOnPRfD
         J8yrbW+hR1lHnEQDQ88+6I08kcgS/tip+umkAfGm8+fsxrjuWYid2lBmFrwF9WgaLT
         PcSX/pa3qp/BA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Avoid trapping packets when the interface is down, and revive them when
interface is back up. Add API to mlx5 core retrieving the action by trap
id. Use it to apply traps when interface is up, and disable then when
interface is down.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 16 ++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h |  2 +
 .../net/ethernet/mellanox/mlx5/core/en/trap.c | 40 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/trap.h |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +
 5 files changed, 62 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index c47291467cb0..b23b54814356 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -308,6 +308,22 @@ int mlx5_devlink_trap_get_num_active(struct mlx5_core_=
dev *dev)
 	return count;
 }
=20
+int mlx5_devlink_traps_get_action(struct mlx5_core_dev *dev, int trap_id,
+				  enum devlink_trap_action *action)
+{
+	struct mlx5_devlink_trap *dl_trap;
+
+	dl_trap =3D mlx5_find_trap_by_id(dev, trap_id);
+	if (!dl_trap) {
+		mlx5_core_err(dev, "Devlink trap: Get action on invalid trap id 0x%x",
+			      trap_id);
+		return -EINVAL;
+	}
+
+	*action =3D dl_trap->trap.action;
+	return 0;
+}
+
 struct devlink *mlx5_devlink_alloc(void)
 {
 	return devlink_alloc(&mlx5_devlink_ops, sizeof(struct mlx5_core_dev));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.h
index a9829006fa78..eff107dad922 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -27,6 +27,8 @@ struct mlx5_core_dev;
 void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, stru=
ct sk_buff *skb,
 			      struct devlink_port *dl_port);
 int mlx5_devlink_trap_get_num_active(struct mlx5_core_dev *dev);
+int mlx5_devlink_traps_get_action(struct mlx5_core_dev *dev, int trap_id,
+				  enum devlink_trap_action *action);
=20
 struct devlink *mlx5_devlink_alloc(void);
 void mlx5_devlink_free(struct devlink *devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/trap.c
index d078281dbd1d..37fc1d77ded7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -401,6 +401,14 @@ int mlx5e_handle_trap_event(struct mlx5e_priv *priv, s=
truct mlx5_trap_ctx *trap_
 {
 	int err =3D 0;
=20
+	/* Traps are unarmed when interface is down, no need to update
+	 * them. The configuration is saved in the core driver,
+	 * queried and applied upon interface up operation in
+	 * mlx5e_open_locked().
+	 */
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		return 0;
+
 	switch (trap_ctx->action) {
 	case DEVLINK_TRAP_ACTION_TRAP:
 		err =3D mlx5e_handle_action_trap(priv, trap_ctx->id);
@@ -415,3 +423,35 @@ int mlx5e_handle_trap_event(struct mlx5e_priv *priv, s=
truct mlx5_trap_ctx *trap_
 	}
 	return err;
 }
+
+static int mlx5e_apply_trap(struct mlx5e_priv *priv, int trap_id, bool ena=
ble)
+{
+	enum devlink_trap_action action;
+	int err;
+
+	err =3D mlx5_devlink_traps_get_action(priv->mdev, trap_id, &action);
+	if (err)
+		return err;
+	if (action =3D=3D DEVLINK_TRAP_ACTION_TRAP)
+		err =3D enable ? mlx5e_handle_action_trap(priv, trap_id) :
+			       mlx5e_handle_action_drop(priv, trap_id);
+	return err;
+}
+
+static const int mlx5e_traps_arr[] =3D {
+	DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER,
+	DEVLINK_TRAP_GENERIC_ID_DMAC_FILTER,
+};
+
+int mlx5e_apply_traps(struct mlx5e_priv *priv, bool enable)
+{
+	int err;
+	int i;
+
+	for (i =3D 0; i < ARRAY_SIZE(mlx5e_traps_arr); i++) {
+		err =3D mlx5e_apply_trap(priv, mlx5e_traps_arr[i], enable);
+		if (err)
+			return err;
+	}
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/trap.h
index cc1fa9f12c45..aa3f17658c6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.h
@@ -32,4 +32,6 @@ struct mlx5e_trap {
 void mlx5e_close_trap(struct mlx5e_trap *trap);
 void mlx5e_deactivate_trap(struct mlx5e_priv *priv);
 int mlx5e_handle_trap_event(struct mlx5e_priv *priv, struct mlx5_trap_ctx =
*trap_ctx);
+int mlx5e_apply_traps(struct mlx5e_priv *priv, bool enable);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 3252919ec7bf..f8619d381345 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3247,6 +3247,7 @@ int mlx5e_open_locked(struct net_device *netdev)
=20
 	priv->profile->update_rx(priv);
 	mlx5e_activate_priv_channels(priv);
+	mlx5e_apply_traps(priv, true);
 	if (priv->profile->update_carrier)
 		priv->profile->update_carrier(priv);
=20
@@ -3282,6 +3283,7 @@ int mlx5e_close_locked(struct net_device *netdev)
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
 		return 0;
=20
+	mlx5e_apply_traps(priv, false);
 	clear_bit(MLX5E_STATE_OPENED, &priv->state);
=20
 	netif_carrier_off(priv->netdev);
--=20
2.29.2

