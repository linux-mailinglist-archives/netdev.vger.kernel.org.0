Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E148F305528
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhA0IA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 03:00:57 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2472 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S316406AbhAZX1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:27:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4c10000>; Tue, 26 Jan 2021 15:24:49 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:48 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/14] net/mlx5e: Add listener to trap event
Date:   Tue, 26 Jan 2021 15:24:17 -0800
Message-ID: <20210126232419.175836-13-saeedm@nvidia.com>
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
        t=1611703489; bh=r48xrHG0Z51k93jiFKzml8O58k28OfY5ATRts5NBgpM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=HhqkJlKfrzK1aN7PL/+OgCqbnvFY2oxcaFGobq9tzGai5qDPmH3vCSJKMwiECdJks
         4UWOM5RAgwARrYZX4OBdPcguLt3luYzEr9EhNh2d8ltMJPuvUY8nD+iKE551Y86rRs
         1wZUtI4NrrOUuIAZxs0638ENTbAQsyZid5nkaS/g5hXjatq0ExtQGwyUjixjpGvnhC
         viFa6dLJ3JYmacL+70x7lWuTp3EqYOoSE17SEfP9Z9ivxOKQoFHEVcEZ1aTGC2gia3
         w+YGDispgNFC/EHMg/cUOrnqucue2pmzSyuDR3QG0sx9xWizkbX2Pf9vZJT+EkBjeO
         Cg+RLgJ8+ncsw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add support for listening to blocking events in the ETH driver. Listen
on trap event. If received, call mlx5e_handle_trap_event() which:
1) Verifies if driver needs open/close trap-RQ with respect to the
active traps count.
2) Inspects trap id and its action (trap/drop) and add/remove the flow
steering rule accordingly.
Otherwise, return an error.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 35 +++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index f439a977ad61..39f389cc40fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -859,6 +859,7 @@ struct mlx5e_priv {
 	u16                        q_counter;
 	u16                        drop_rq_q_counter;
 	struct notifier_block      events_nb;
+	struct notifier_block      blocking_events_nb;
 	int                        num_tc_x_num_ch;
=20
 	struct udp_tunnel_nic_info nic_info;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index ec5bb48cb54a..3252919ec7bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -66,6 +66,7 @@
 #include "lib/mlx5.h"
 #include "en/ptp.h"
 #include "qos.h"
+#include "en/trap.h"
=20
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -212,6 +213,33 @@ static void mlx5e_disable_async_events(struct mlx5e_pr=
iv *priv)
 	mlx5_notifier_unregister(priv->mdev, &priv->events_nb);
 }
=20
+static int blocking_event(struct notifier_block *nb, unsigned long event, =
void *data)
+{
+	struct mlx5e_priv *priv =3D container_of(nb, struct mlx5e_priv, blocking_=
events_nb);
+	int err;
+
+	switch (event) {
+	case MLX5_DRIVER_EVENT_TYPE_TRAP:
+		err =3D mlx5e_handle_trap_event(priv, data);
+		break;
+	default:
+		netdev_warn(priv->netdev, "Sync event: Unknouwn event %ld\n", event);
+		err =3D -EINVAL;
+	}
+	return err;
+}
+
+static void mlx5e_enable_blocking_events(struct mlx5e_priv *priv)
+{
+	priv->blocking_events_nb.notifier_call =3D blocking_event;
+	mlx5_blocking_notifier_register(priv->mdev, &priv->blocking_events_nb);
+}
+
+static void mlx5e_disable_blocking_events(struct mlx5e_priv *priv)
+{
+	mlx5_blocking_notifier_unregister(priv->mdev, &priv->blocking_events_nb);
+}
+
 static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
 				       struct mlx5e_icosq *sq,
 				       struct mlx5e_umr_wqe *wqe)
@@ -5341,6 +5369,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	mlx5_lag_add(mdev, netdev);
=20
 	mlx5e_enable_async_events(priv);
+	mlx5e_enable_blocking_events(priv);
 	if (mlx5e_monitor_counter_supported(priv))
 		mlx5e_monitor_counter_init(priv);
=20
@@ -5378,6 +5407,12 @@ static void mlx5e_nic_disable(struct mlx5e_priv *pri=
v)
 	if (mlx5e_monitor_counter_supported(priv))
 		mlx5e_monitor_counter_cleanup(priv);
=20
+	mlx5e_disable_blocking_events(priv);
+	if (priv->en_trap) {
+		mlx5e_deactivate_trap(priv);
+		mlx5e_close_trap(priv->en_trap);
+		priv->en_trap =3D NULL;
+	}
 	mlx5e_disable_async_events(priv);
 	mlx5_lag_remove(mdev);
 	mlx5_vxlan_reset_to_default(mdev->vxlan);
--=20
2.29.2

