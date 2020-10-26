Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AEE298E3F
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780375AbgJZNjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:39:13 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12122 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1780360AbgJZNjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 09:39:08 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f96d1830000>; Mon, 26 Oct 2020 06:39:15 -0700
Received: from c-235-2-1-007.mtl.labs.mlnx (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 26 Oct 2020 13:38:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dledford@redhat.com>, <jgg@nvidia.com>
CC:     <jiri@mellanox.com>, <linux-rdma@vger.kernel.org>,
        <michaelgur@mellanox.com>, <netdev@vger.kernel.org>,
        <saeedm@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace deletion
Date:   Mon, 26 Oct 2020 15:38:35 +0200
Message-ID: <20201026133835.22202-1-parav@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201019052736.628909-1-leon@kernel.org>
References: <20201019052736.628909-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603719555; bh=zVQqQ/WZYWQ3fkc3gsO1UJeFFHvTxBV7ttQ79WTEFD8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=JbrqMKBTYiT9411ONdyMoc7iq1PwrcU7yA+6r2PvcILdpoEPmS6F+PUZNU98lI+Ji
         gUlirvqhYBeDFF/HV+pQI3qQd8da3DXnLRkB/fuE+frY242q0n/7VQxnyM3gmVN8Np
         PCU3hB+rwlRMdQy6h2U09eSpk9L8ZCneoCWnj9n2TaiMSYjKQlHnHwBlmjemhUuZ4W
         Hvk8OBALVL7ndQqb2A8ECtCXB+9rG9dUp4W9Lf5NWd0YBbH9XBrv23MJG5i9XOIwgv
         wc+5pPJB7mxkKkVgQPu0+osF4HUVt9mqooBSRjNrtqOwl3apq82bAzRyBg6lEz8CUb
         0xQCUwNBtmWcg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a mlx5 core devlink instance is reloaded in different net
namespace, its associated IB device is deleted and recreated.

Example sequence is:
$ ip netns add foo
$ devlink dev reload pci/0000:00:08.0 netns foo
$ ip netns del foo

mlx5 IB device needs to attach and detach the netdevice to it
through the netdev notifier chain during load and unload sequence.
A below call graph of the unload flow.

cleanup_net()
   down_read(&pernet_ops_rwsem); <- first sem acquired
     ops_pre_exit_list()
       pre_exit()
         devlink_pernet_pre_exit()
           devlink_reload()
             mlx5_devlink_reload_down()
               mlx5_unload_one()
               [...]
                 mlx5_ib_remove()
                   mlx5_ib_unbind_slave_port()
                     mlx5_remove_netdev_notifier()
                       unregister_netdevice_notifier()
                         down_write(&pernet_ops_rwsem);<- recurrsive lock

Hence, when net namespace is deleted, mlx5 reload results in deadlock.

When deadlock occurs, devlink mutex is also held. This not only deadlocks
the mlx5 device under reload, but all the processes which attempt to access
unrelated devlink devices are deadlocked.

Hence, fix this by mlx5 ib driver to register for per net netdev
notifier instead of global one, which operats on the net namespace
without holding the pernet_ops_rwsem.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
Changelog:
v0->v1:
 - updated comment for mlx5_core_net API to be used by multiple mlx5
   drivers
---
 drivers/infiniband/hw/mlx5/main.c              |  6 ++++--
 .../net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  5 -----
 include/linux/mlx5/driver.h                    | 18 ++++++++++++++++++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5=
/main.c
index 89e04ca62ae0..246e3cbe0b2c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3305,7 +3305,8 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_de=
v *dev, u8 port_num)
 	int err;
=20
 	dev->port[port_num].roce.nb.notifier_call =3D mlx5_netdev_event;
-	err =3D register_netdevice_notifier(&dev->port[port_num].roce.nb);
+	err =3D register_netdevice_notifier_net(mlx5_core_net(dev->mdev),
+					      &dev->port[port_num].roce.nb);
 	if (err) {
 		dev->port[port_num].roce.nb.notifier_call =3D NULL;
 		return err;
@@ -3317,7 +3318,8 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_de=
v *dev, u8 port_num)
 static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_n=
um)
 {
 	if (dev->port[port_num].roce.nb.notifier_call) {
-		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
+		unregister_netdevice_notifier_net(mlx5_core_net(dev->mdev),
+						  &dev->port[port_num].roce.nb);
 		dev->port[port_num].roce.nb.notifier_call =3D NULL;
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/lib/mlx5.h
index d046db7bb047..3a9fa629503f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -90,9 +90,4 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev=
,
 			       u32 key_type, u32 *p_key_id);
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
=20
-static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
-{
-	return devlink_net(priv_to_devlink(dev));
-}
-
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c145de0473bc..3382855b7ef1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1209,4 +1209,22 @@ static inline bool mlx5_is_roce_enabled(struct mlx5_=
core_dev *dev)
 	return val.vbool;
 }
=20
+/**
+ * mlx5_core_net - Provide net namespace of the mlx5_core_dev
+ * @dev: mlx5 core device
+ *
+ * mlx5_core_net() returns the net namespace of mlx5 core device.
+ * This can be called only in below described limited context.
+ * (a) When a devlink instance for mlx5_core is registered and
+ *     when devlink reload operation is disabled.
+ *     or
+ * (b) during devlink reload reload_down() and reload_up callbacks
+ *     where it is ensured that devlink instance's net namespace is
+ *     stable.
+ */
+static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
+{
+	return devlink_net(priv_to_devlink(dev));
+}
+
 #endif /* MLX5_DRIVER_H */
--=20
2.25.4

