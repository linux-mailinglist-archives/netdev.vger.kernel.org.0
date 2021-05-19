Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7BB388750
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243577AbhESGH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239446AbhESGHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5825961355;
        Wed, 19 May 2021 06:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404371;
        bh=Ry3Ixi+Q9fB5MaLpq5NERAyc9RSYcQoHK8md2BR12Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0sgH2onwi0k1Ier232Y7kgFn6ncOFEbQ+g//Ht82PvZcCbt7GNv1DcW96/qhHDnu
         3cKI8V4S/kCpuVrWDoHRHd/05Z3vSijwNPUfsM10VxWg62X8tSEdbyWLE3I1/GnLMx
         isi3sWmkDsiEKB6Qy9A+rKJCIRnUVpWS0g/UWLBcDS4aT7Ua3l6CsQR0cschFoyBtI
         pNtyOvJZ/llDLodaXQlyN7Ex95AAa7V0NGDyIx2+PqXYk/nDkLN3p0COv2czvas8a8
         0VixdXs2FGJsWm8MheuhI6shgW+K3ouT4ydahmV60ao+juqHiWGPV9WPR1pf4TJ3zy
         BRSe9ZuFx1HSQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 13/16] {net,vdpa}/mlx5: Configure interface MAC into mpfs L2 table
Date:   Tue, 18 May 2021 23:05:20 -0700
Message-Id: <20210519060523.17875-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

net/mlx5: Expose MPFS configuration API

MPFS is the multi physical function switch that bridges traffic between
the physical port and any physical functions associated with it. The
driver is required to add or remove MAC entries to properly forward
incoming traffic to the correct physical function.

We export the API to control MPFS so that other drivers, such as
mlx5_vdpa are able to add MAC addresses of their network interfaces.

The MAC address of the vdpa interface must be configured into the MPFS L2
address. Failing to do so could cause, in some NIC configurations, failure
to forward packets to the vdpa network device instance.

Fix this by adding calls to update the MPFS table.

CC: <mst@redhat.com>
CC: <jasowang@redhat.com>
CC: <virtualization@lists.linux-foundation.org>
Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  1 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  1 +
 .../ethernet/mellanox/mlx5/core/lib/mpfs.c    |  3 +++
 .../ethernet/mellanox/mlx5/core/lib/mpfs.h    |  5 +----
 drivers/vdpa/mlx5/net/mlx5_vnet.c             | 19 ++++++++++++++++++-
 include/linux/mlx5/mpfs.h                     | 18 ++++++++++++++++++
 6 files changed, 42 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/mlx5/mpfs.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 0d571a0c76d9..0b75fab41ae8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -35,6 +35,7 @@
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/mpfs.h>
 #include "en.h"
 #include "en_rep.h"
 #include "lib/mpfs.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 570f2280823c..b88705a3a1a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -35,6 +35,7 @@
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/mpfs.h>
 #include "esw/acl/lgcy.h"
 #include "esw/legacy.h"
 #include "mlx5_core.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
index fd8449ff9e17..839a01da110f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
@@ -33,6 +33,7 @@
 #include <linux/etherdevice.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/mlx5_ifc.h>
+#include <linux/mlx5/mpfs.h>
 #include <linux/mlx5/eswitch.h>
 #include "mlx5_core.h"
 #include "lib/mpfs.h"
@@ -175,6 +176,7 @@ int mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac)
 	mutex_unlock(&mpfs->lock);
 	return err;
 }
+EXPORT_SYMBOL(mlx5_mpfs_add_mac);
 
 int mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac)
 {
@@ -206,3 +208,4 @@ int mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac)
 	mutex_unlock(&mpfs->lock);
 	return err;
 }
+EXPORT_SYMBOL(mlx5_mpfs_del_mac);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h
index 4a7b2c3203a7..4a293542a7aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h
@@ -84,12 +84,9 @@ struct l2addr_node {
 #ifdef CONFIG_MLX5_MPFS
 int  mlx5_mpfs_init(struct mlx5_core_dev *dev);
 void mlx5_mpfs_cleanup(struct mlx5_core_dev *dev);
-int  mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac);
-int  mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac);
 #else /* #ifndef CONFIG_MLX5_MPFS */
 static inline int  mlx5_mpfs_init(struct mlx5_core_dev *dev) { return 0; }
 static inline void mlx5_mpfs_cleanup(struct mlx5_core_dev *dev) {}
-static inline int  mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac) { return 0; }
-static inline int  mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac) { return 0; }
 #endif
+
 #endif
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 189e4385df40..dda5dc6f7737 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -15,6 +15,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/mlx5_ifc_vdpa.h>
+#include <linux/mlx5/mpfs.h>
 #include "mlx5_vdpa.h"
 
 MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
@@ -1859,11 +1860,16 @@ static int mlx5_vdpa_set_map(struct vdpa_device *vdev, struct vhost_iotlb *iotlb
 static void mlx5_vdpa_free(struct vdpa_device *vdev)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	struct mlx5_core_dev *pfmdev;
 	struct mlx5_vdpa_net *ndev;
 
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 
 	free_resources(ndev);
+	if (!is_zero_ether_addr(ndev->config.mac)) {
+		pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
+		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
+	}
 	mlx5_vdpa_free_resources(&ndev->mvdev);
 	mutex_destroy(&ndev->reslock);
 }
@@ -1990,6 +1996,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 {
 	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
 	struct virtio_net_config *config;
+	struct mlx5_core_dev *pfmdev;
 	struct mlx5_vdpa_dev *mvdev;
 	struct mlx5_vdpa_net *ndev;
 	struct mlx5_core_dev *mdev;
@@ -2023,10 +2030,17 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 	if (err)
 		goto err_mtu;
 
+	if (!is_zero_ether_addr(config->mac)) {
+		pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
+		err = mlx5_mpfs_add_mac(pfmdev, config->mac);
+		if (err)
+			goto err_mtu;
+	}
+
 	mvdev->vdev.dma_dev = mdev->device;
 	err = mlx5_vdpa_alloc_resources(&ndev->mvdev);
 	if (err)
-		goto err_mtu;
+		goto err_mpfs;
 
 	err = alloc_resources(ndev);
 	if (err)
@@ -2044,6 +2058,9 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 	free_resources(ndev);
 err_res:
 	mlx5_vdpa_free_resources(&ndev->mvdev);
+err_mpfs:
+	if (!is_zero_ether_addr(config->mac))
+		mlx5_mpfs_del_mac(pfmdev, config->mac);
 err_mtu:
 	mutex_destroy(&ndev->reslock);
 	put_device(&mvdev->vdev.dev);
diff --git a/include/linux/mlx5/mpfs.h b/include/linux/mlx5/mpfs.h
new file mode 100644
index 000000000000..bf700c8d5516
--- /dev/null
+++ b/include/linux/mlx5/mpfs.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ * Copyright (c) 2021 Mellanox Technologies Ltd.
+ */
+
+#ifndef _MLX5_MPFS_
+#define _MLX5_MPFS_
+
+struct mlx5_core_dev;
+
+#ifdef CONFIG_MLX5_MPFS
+int  mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac);
+int  mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac);
+#else /* #ifndef CONFIG_MLX5_MPFS */
+static inline int  mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac) { return 0; }
+static inline int  mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac) { return 0; }
+#endif
+
+#endif
-- 
2.31.1

