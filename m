Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FCF292225
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 07:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgJSF1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 01:27:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgJSF1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 01:27:43 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 702D12223C;
        Mon, 19 Oct 2020 05:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603085262;
        bh=h9z88xQxsjjhv2T1XsSCt0UIaZrHKx3S8kfXoaSlPyM=;
        h=From:To:Cc:Subject:Date:From;
        b=EQyT7Qcix2oVtJai5By0EXIFjYj0udmEQFYYgYa+EirzLop03aG6ooGp2wVB5sn0u
         9wiCfSe1JbUzqL9FITdOjSHqg8LApQ/99bKBSa8Fd80/vE4+LaGcWfObJWnILn4tVV
         9e4p4Tz4MkSrz9LZUnUCFOYVzdlSgQROaABWPO6o=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace deletion
Date:   Mon, 19 Oct 2020 08:27:36 +0300
Message-Id: <20201019052736.628909-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

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
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c                  | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h | 5 -----
 include/linux/mlx5/driver.h                        | 5 +++++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 944bb7691913..b1b3e563c15e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3323,7 +3323,8 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 	int err;

 	dev->port[port_num].roce.nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier(&dev->port[port_num].roce.nb);
+	err = register_netdevice_notifier_net(mlx5_core_net(dev->mdev),
+					      &dev->port[port_num].roce.nb);
 	if (err) {
 		dev->port[port_num].roce.nb.notifier_call = NULL;
 		return err;
@@ -3335,7 +3336,8 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	if (dev->port[port_num].roce.nb.notifier_call) {
-		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
+		unregister_netdevice_notifier_net(mlx5_core_net(dev->mdev),
+						  &dev->port[port_num].roce.nb);
 		dev->port[port_num].roce.nb.notifier_call = NULL;
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index d046db7bb047..3a9fa629503f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -90,9 +90,4 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 			       u32 key_type, u32 *p_key_id);
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);

-static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
-{
-	return devlink_net(priv_to_devlink(dev));
-}
-
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c484805d8a22..1c810911d367 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1210,4 +1210,9 @@ static inline bool mlx5_is_roce_enabled(struct mlx5_core_dev *dev)
 	return val.vbool;
 }

+static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
+{
+	return devlink_net(priv_to_devlink(dev));
+}
+
 #endif /* MLX5_DRIVER_H */
--
2.26.2

