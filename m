Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524852B0DEB
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgKLTZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:25:12 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11362 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgKLTY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c120000>; Thu, 12 Nov 2020 11:25:06 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next 10/13] net/mlx5: E-switch, Add eswitch helpers for SF vport
Date:   Thu, 12 Nov 2020 21:24:20 +0200
Message-ID: <20201112192424.2742-11-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112192424.2742-1-parav@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605209106; bh=X7wkyOLBY1v8uaw9RgSYUbc7p4gr/Rh3LJuyyQDy0gc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=CAcvkw6yVqcHbp8CvBdW4kbH1mjF5xY90jKZYFSfguRvTIfcTlYwoeZDD1ys923sy
         iO24Nopdvc8RvHRFfFujq80KQJH8GzvM/r2sWJhQPvXNcvS5xbUEPP2gWkn2j9q+cv
         FfL76fImB4Qqlb3qNpymq3lb979Ezbq8JapqZEJVokZAcU/xZNxcBIkuafgz4+qfVR
         Ue5oOx2zNcfBIYjgvU9qrgYvEEqivdCziIktsWumPvI8IC1TKVr1WLs7zrPMYWk+VY
         J70P6PD5l23bxgE0ChaGYAdCpxy5p0u6vQihqKfmKtesaI0li7cOssQpTU8w3tScjw
         d9P31y/0fZo4Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers to enable/disable eswitch port, register its devlink port and
load its representor.

Signed-off-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 .../mellanox/mlx5/core/esw/devlink_port.c     | 41 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 10 +++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 15 +++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 36 +++++++++++++++-
 4 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 88688b84513b..f361a896c278 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -122,3 +122,44 @@ struct devlink_port *mlx5_esw_offloads_devlink_port(st=
ruct mlx5_eswitch *esw, u1
 	vport =3D mlx5_eswitch_get_vport(esw, vport_num);
 	return IS_ERR(vport) ? ERR_CAST(vport) : vport->dl_port;
 }
+
+int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct dev=
link_port *dl_port,
+				      u16 vport_num, u32 sfnum)
+{
+	struct mlx5_core_dev *dev =3D esw->dev;
+	struct netdev_phys_item_id ppid =3D {};
+	unsigned int dl_port_index;
+	struct mlx5_vport *vport;
+	struct devlink *devlink;
+	u16 pfnum;
+	int err;
+
+	vport =3D mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	pfnum =3D PCI_FUNC(dev->pdev->devfn);
+	mlx5_esw_get_port_parent_id(dev, &ppid);
+	memcpy(dl_port->attrs.switch_id.id, &ppid.id[0], ppid.id_len);
+	dl_port->attrs.switch_id.id_len =3D ppid.id_len;
+	devlink_port_attrs_pci_sf_set(dl_port, 0, pfnum, sfnum, false);
+	devlink =3D priv_to_devlink(dev);
+	dl_port_index =3D mlx5_esw_vport_to_devlink_port_index(dev, vport_num);
+	err =3D devlink_port_register(devlink, dl_port, dl_port_index);
+	if (err)
+		return err;
+
+	vport->dl_port =3D dl_port;
+	return 0;
+}
+
+void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vpo=
rt_num)
+{
+	struct mlx5_vport *vport;
+
+	vport =3D mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return;
+	devlink_port_unregister(vport->dl_port);
+	vport->dl_port =3D NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 5b90f126b7f3..d72766b78bd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1342,6 +1342,16 @@ static void esw_disable_vport(struct mlx5_eswitch *e=
sw, u16 vport_num)
 	mutex_unlock(&esw->state_lock);
 }
=20
+int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return esw_enable_vport(esw, vport_num, MLX5_VPORT_UC_ADDR_CHANGE);
+}
+
+void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	esw_disable_vport(esw, vport_num);
+}
+
 static int eswitch_vport_event(struct notifier_block *nb,
 			       unsigned long type, void *data)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 2165bc065196..3a373f314a6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -711,6 +711,9 @@ esw_get_max_restore_tag(struct mlx5_eswitch *esw);
 int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num);
 void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num);
=20
+int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num);
+void mlx5_esw_offloads_rep_unload(struct mlx5_eswitch *esw, u16 vport_num)=
;
+
 int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 			    enum mlx5_eswitch_vport_event enabled_events);
 void mlx5_eswitch_unload_vport(struct mlx5_eswitch *esw, u16 vport_num);
@@ -722,6 +725,18 @@ void mlx5_eswitch_unload_vf_vports(struct mlx5_eswitch=
 *esw, u16 num_vfs);
 int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 =
vport_num);
 void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u=
16 vport_num);
 struct devlink_port *mlx5_esw_offloads_devlink_port(struct mlx5_eswitch *e=
sw, u16 vport_num);
+
+int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct dev=
link_port *dl_port,
+				      u16 vport_num, u32 sfnum);
+void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vpo=
rt_num);
+
+int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num);
+void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num);
+
+int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct dev=
link_port *dl_port,
+				      u16 vport_num, u32 sfnum);
+void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vpor=
t_num);
+
 #else  /* CONFIG_MLX5_ESWITCH */
 /* eswitch API stubs */
 static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0=
; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 01242afbfcce..14f73c202adf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1834,7 +1834,7 @@ static void __unload_reps_all_vport(struct mlx5_eswit=
ch *esw, u8 rep_type)
 	__esw_offloads_unload_rep(esw, rep, rep_type);
 }
=20
-static int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_=
num)
+int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_eswitch_rep *rep;
 	int rep_type;
@@ -1858,7 +1858,7 @@ static int mlx5_esw_offloads_rep_load(struct mlx5_esw=
itch *esw, u16 vport_num)
 	return err;
 }
=20
-static void mlx5_esw_offloads_rep_unload(struct mlx5_eswitch *esw, u16 vpo=
rt_num)
+void mlx5_esw_offloads_rep_unload(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_eswitch_rep *rep;
 	int rep_type;
@@ -2842,3 +2842,35 @@ u32 mlx5_eswitch_get_vport_metadata_for_match(struct=
 mlx5_eswitch *esw,
 	return vport->metadata << (32 - ESW_SOURCE_PORT_METADATA_BITS);
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_match);
+
+int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct dev=
link_port *dl_port,
+				      u16 vport_num, u32 sfnum)
+{
+	int err;
+
+	err =3D mlx5_esw_vport_enable(esw, vport_num);
+	if (err)
+		return err;
+
+	err =3D mlx5_esw_devlink_sf_port_register(esw, dl_port, vport_num, sfnum)=
;
+	if (err)
+		goto devlink_err;
+
+	err =3D mlx5_esw_offloads_rep_load(esw, vport_num);
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
+void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vpor=
t_num)
+{
+	mlx5_esw_offloads_rep_unload(esw, vport_num);
+	mlx5_esw_devlink_sf_port_unregister(esw, vport_num);
+	mlx5_esw_vport_disable(esw, vport_num);
+}
--=20
2.26.2

