Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548892F5356
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 20:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbhAMT3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 14:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728759AbhAMT3P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 14:29:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66D602337F;
        Wed, 13 Jan 2021 19:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610566075;
        bh=xP+QyZ2e6vXqiUZLbufJEsuRmx8Y9KGV3aRGxpuEYdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idq9akrvkBYHr4/ubJ6Vfa0ZIYdfzJGBa+zEavofYDqK6oYXSYQAVAIWm1K7go3Cu
         tsi+AKpJMZXRJQ4wV5zm8idSFsUQspO2E4VGmBHnAWApOKFl6+PYCFUXoZwFi8U4wg
         OJ6DC3a1PqfXp4M8TYgZHRW5sNCY4H77p6uRaM6uflr2GLzD+iHj3tW3djkowoE4iX
         QolnWdlt06pQqLNIF7glKFr9hibj/sjMzTEylTf5GB5pDIeKDqWTJjYnWWv0hJNQdm
         NSNFiNfizUihC7AL/NC6LYOkIec6L/J875gyQlAIHB7jLhj/E6enk9LGDPmgbcci2H
         SbQwNiGwCq0Tg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V6 09/14] net/mlx5: E-switch, Add eswitch helpers for SF vport
Date:   Wed, 13 Jan 2021 11:27:25 -0800
Message-Id: <20210113192730.280656-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113192730.280656-1-saeed@kernel.org>
References: <20210113192730.280656-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add helpers to enable/disable eswitch port, register its devlink port and
load its representor.

Signed-off-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/devlink_port.c     | 41 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 12 +++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 16 ++++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 36 +++++++++++++++-
 4 files changed, 97 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index ffff11baa3d0..cb1e181f4c6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -122,3 +122,44 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u1
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
 	return vport->dl_port;
 }
+
+int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
+				      u16 vport_num, u32 sfnum)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct netdev_phys_item_id ppid = {};
+	unsigned int dl_port_index;
+	struct mlx5_vport *vport;
+	struct devlink *devlink;
+	u16 pfnum;
+	int err;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	pfnum = PCI_FUNC(dev->pdev->devfn);
+	mlx5_esw_get_port_parent_id(dev, &ppid);
+	memcpy(dl_port->attrs.switch_id.id, &ppid.id[0], ppid.id_len);
+	dl_port->attrs.switch_id.id_len = ppid.id_len;
+	devlink_port_attrs_pci_sf_set(dl_port, 0, pfnum, sfnum);
+	devlink = priv_to_devlink(dev);
+	dl_port_index = mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
+	err = devlink_port_register(devlink, dl_port, dl_port_index);
+	if (err)
+		return err;
+
+	vport->dl_port = dl_port;
+	return 0;
+}
+
+void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	struct mlx5_vport *vport;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return;
+	devlink_port_unregister(vport->dl_port);
+	vport->dl_port = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d75247a8ce55..d06e7a5f15de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1273,8 +1273,8 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	esw_vport_cleanup_acl(esw, vport);
 }
 
-static int esw_enable_vport(struct mlx5_eswitch *esw, u16 vport_num,
-			    enum mlx5_eswitch_vport_event enabled_events)
+int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
+			  enum mlx5_eswitch_vport_event enabled_events)
 {
 	struct mlx5_vport *vport;
 	int ret;
@@ -1310,7 +1310,7 @@ static int esw_enable_vport(struct mlx5_eswitch *esw, u16 vport_num,
 	return ret;
 }
 
-static void esw_disable_vport(struct mlx5_eswitch *esw, u16 vport_num)
+void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_vport *vport;
 
@@ -1432,7 +1432,7 @@ int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 {
 	int err;
 
-	err = esw_enable_vport(esw, vport_num, enabled_events);
+	err = mlx5_esw_vport_enable(esw, vport_num, enabled_events);
 	if (err)
 		return err;
 
@@ -1443,14 +1443,14 @@ int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 	return err;
 
 err_rep:
-	esw_disable_vport(esw, vport_num);
+	mlx5_esw_vport_disable(esw, vport_num);
 	return err;
 }
 
 void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	esw_offloads_unload_rep(esw, vport_num);
-	esw_disable_vport(esw, vport_num);
+	mlx5_esw_vport_disable(esw, vport_num);
 }
 
 void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 4e3ed878ff03..54514b04808d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -688,6 +688,10 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch *esw,
 				 enum mlx5_eswitch_vport_event enabled_events);
 void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw);
 
+int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
+			  enum mlx5_eswitch_vport_event enabled_events);
+void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num);
+
 int
 esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 				     struct mlx5_vport *vport);
@@ -706,6 +710,9 @@ esw_get_max_restore_tag(struct mlx5_eswitch *esw);
 int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num);
 void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num);
 
+int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num);
+void mlx5_esw_offloads_rep_unload(struct mlx5_eswitch *esw, u16 vport_num);
+
 int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 			    enum mlx5_eswitch_vport_event enabled_events);
 void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num);
@@ -717,6 +724,15 @@ void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch *esw, u16 num_vfs);
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_num);
 void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vport_num);
 struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *esw, u16 vport_num);
+
+int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
+				      u16 vport_num, u32 sfnum);
+void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num);
+
+int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
+				      u16 vport_num, u32 sfnum);
+void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vport_num);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 2d241f7351b5..7f09f2bbf7c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1833,7 +1833,7 @@ static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
 	__esw_offloads_unload_rep(esw, rep, rep_type);
 }
 
-static int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num)
+int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_eswitch_rep *rep;
 	int rep_type;
@@ -1857,7 +1857,7 @@ static int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num)
 	return err;
 }
 
-static void mlx5_esw_offloads_rep_unload(struct mlx5_eswitch *esw, u16 vport_num)
+void mlx5_esw_offloads_rep_unload(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_eswitch_rep *rep;
 	int rep_type;
@@ -2835,3 +2835,35 @@ u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 	return vport->metadata << (32 - ESW_SOURCE_PORT_METADATA_BITS);
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_match);
+
+int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
+				      u16 vport_num, u32 sfnum)
+{
+	int err;
+
+	err = mlx5_esw_vport_enable(esw, vport_num, MLX5_VPORT_UC_ADDR_CHANGE);
+	if (err)
+		return err;
+
+	err = mlx5_esw_devlink_sf_port_register(esw, dl_port, vport_num, sfnum);
+	if (err)
+		goto devlink_err;
+
+	err = mlx5_esw_offloads_rep_load(esw, vport_num);
+	if (err)
+		goto rep_err;
+	return 0;
+
+rep_err:
+	mlx5_esw_devlink_sf_port_unregister(esw, vport_num);
+devlink_err:
+	mlx5_esw_vport_disable(esw, vport_num);
+	return err;
+}
+
+void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	mlx5_esw_offloads_rep_unload(esw, vport_num);
+	mlx5_esw_devlink_sf_port_unregister(esw, vport_num);
+	mlx5_esw_vport_disable(esw, vport_num);
+}
-- 
2.26.2

