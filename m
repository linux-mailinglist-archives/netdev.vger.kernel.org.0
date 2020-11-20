Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305BA2BB9A0
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgKTXEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:24 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1190 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728560AbgKTXEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0003>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:04:04 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: [PATCH mlx5-next 15/16] net/mlx5: Enable host PF HCA after eswitch is initialized
Date:   Fri, 20 Nov 2020 15:03:38 -0800
Message-ID: <20201120230339.651609-16-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913439; bh=4VadNy66xrFWwc+wr0Xn7UBS99RUJQ7bULCD/xlEfKc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Vt4TPty2QkeQ7AQrt5hPNbhrpkjNpqhfEIyqEGMixUXOokhwy1i9lfNFTGvuXNMZK
         wWvxwp1HeKR5Ek4IBO3C9D0DFuAb3iQGz6eL2ppDxaxQLufCE73yZ5ZbQ7evA6NzF0
         0pcHDz+Itt9Ub7VRjAEpZZdkoKrzLLFLZP5bNBWIgyqioWlS2nLxUU1C4BL6x6g8XS
         jY6tbzr9217EqpBFWqXPZA0rwJulGuq+I6toJYr3PB7iepSPBhhBdmH0eNiSn55Zvq
         tdRcBICE6M9YdQJ0lUIb2V3XlVSfwAAxK4FPg7dxbhDySvpAKQE73b7eCujBC0SS9a
         ILZ4JsGCdMbbw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Currently ECPF enables external host PF too early in the initialization
sequence for Ethernet links when ECPF is eswitch manager.

Due to this, when external host PF driver is loaded, host PF's HCA CAP has
inner_ip_version supported by NIC RX flow table.
This capability is later updated by firmware after ECPF driver enables
ENCAP/DECAP as eswitch manager.

This results into a timing race condition, where CREATE_TIR command
fails with a below syndrome on host PF.

mlx5_cmd_check:775:(pid 510): CREATE_TIR(0x900) op_mod(0x0) failed,
status bad parameter(0x3), syndrome (0x562b00)

Hence, enable the external host PF after necessary eswitch and per vport
initialization is completed.
Continue to enable host PF when eswitch manager capability is off for a
ECPF.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    | 35 ++++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/ecpf.h    |  3 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 29 ++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 18 +++++-----
 4 files changed, 66 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/e=
thernet/mellanox/mlx5/core/ecpf.c
index 68ca0e2b26cd..464eb3a18450 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -8,7 +8,16 @@ bool mlx5_read_embedded_cpu(struct mlx5_core_dev *dev)
 	return (ioread32be(&dev->iseg->initializing) >> MLX5_ECPU_BIT_NUM) & 1;
 }
=20
-static int mlx5_cmd_host_pf_enable_hca(struct mlx5_core_dev *dev)
+static bool mlx5_ecpf_esw_admins_host_pf(const struct mlx5_core_dev *dev)
+{
+	/* In separate host mode, PF enables itself.
+	 * When ECPF is eswitch manager, eswitch enables host PF after
+	 * eswitch is setup.
+	 */
+	return mlx5_core_is_ecpf_esw_manager(dev);
+}
+
+int mlx5_cmd_host_pf_enable_hca(struct mlx5_core_dev *dev)
 {
 	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(enable_hca_in)]   =3D {};
@@ -19,7 +28,7 @@ static int mlx5_cmd_host_pf_enable_hca(struct mlx5_core_d=
ev *dev)
 	return mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
 }
=20
-static int mlx5_cmd_host_pf_disable_hca(struct mlx5_core_dev *dev)
+int mlx5_cmd_host_pf_disable_hca(struct mlx5_core_dev *dev)
 {
 	u32 out[MLX5_ST_SZ_DW(disable_hca_out)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(disable_hca_in)]   =3D {};
@@ -34,6 +43,12 @@ static int mlx5_host_pf_init(struct mlx5_core_dev *dev)
 {
 	int err;
=20
+	if (mlx5_ecpf_esw_admins_host_pf(dev))
+		return 0;
+
+	/* ECPF shall enable HCA for host PF in the same way a PF
+	 * does this for its VFs when ECPF is not a eswitch manager.
+	 */
 	err =3D mlx5_cmd_host_pf_enable_hca(dev);
 	if (err)
 		mlx5_core_err(dev, "Failed to enable external host PF HCA err(%d)\n", er=
r);
@@ -45,15 +60,14 @@ static void mlx5_host_pf_cleanup(struct mlx5_core_dev *=
dev)
 {
 	int err;
=20
+	if (mlx5_ecpf_esw_admins_host_pf(dev))
+		return;
+
 	err =3D mlx5_cmd_host_pf_disable_hca(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to disable external host PF HCA err(%d)\n", e=
rr);
 		return;
 	}
-
-	err =3D mlx5_wait_for_pages(dev, &dev->priv.host_pf_pages);
-	if (err)
-		mlx5_core_warn(dev, "Timeout reclaiming external host PF pages err(%d)\n=
", err);
 }
=20
 int mlx5_ec_init(struct mlx5_core_dev *dev)
@@ -61,16 +75,19 @@ int mlx5_ec_init(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_ecpf(dev))
 		return 0;
=20
-	/* ECPF shall enable HCA for host PF in the same way a PF
-	 * does this for its VFs.
-	 */
 	return mlx5_host_pf_init(dev);
 }
=20
 void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 {
+	int err;
+
 	if (!mlx5_core_is_ecpf(dev))
 		return;
=20
 	mlx5_host_pf_cleanup(dev);
+
+	err =3D mlx5_wait_for_pages(dev, &dev->priv.host_pf_pages);
+	if (err)
+		mlx5_core_warn(dev, "Timeout reclaiming external host PF pages err(%d)\n=
", err);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h b/drivers/net/e=
thernet/mellanox/mlx5/core/ecpf.h
index d3d7a00a02ac..40b6ad76dca6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.h
@@ -17,6 +17,9 @@ bool mlx5_read_embedded_cpu(struct mlx5_core_dev *dev);
 int mlx5_ec_init(struct mlx5_core_dev *dev);
 void mlx5_ec_cleanup(struct mlx5_core_dev *dev);
=20
+int mlx5_cmd_host_pf_enable_hca(struct mlx5_core_dev *dev);
+int mlx5_cmd_host_pf_disable_hca(struct mlx5_core_dev *dev);
+
 #else  /* CONFIG_MLX5_ESWITCH */
=20
 static inline bool
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 6e6a9a563992..dcd8946a843c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1469,6 +1469,26 @@ int mlx5_eswitch_load_vf_vports(struct mlx5_eswitch =
*esw, u16 num_vfs,
 	return err;
 }
=20
+static int host_pf_enable_hca(struct mlx5_core_dev *dev)
+{
+	if (!mlx5_core_is_ecpf(dev))
+		return 0;
+
+	/* Once vport and representor are ready, take out the external host PF
+	 * out of initializing state. Enabling HCA clears the iser->initializing
+	 * bit and host PF driver loading can progress.
+	 */
+	return mlx5_cmd_host_pf_enable_hca(dev);
+}
+
+static void host_pf_disable_hca(struct mlx5_core_dev *dev)
+{
+	if (!mlx5_core_is_ecpf(dev))
+		return;
+
+	mlx5_cmd_host_pf_disable_hca(dev);
+}
+
 /* mlx5_eswitch_enable_pf_vf_vports() enables vports of PF, ECPF and VFs
  * whichever are present on the eswitch.
  */
@@ -1483,6 +1503,11 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch=
 *esw,
 	if (ret)
 		return ret;
=20
+	/* Enable external host PF HCA */
+	ret =3D host_pf_enable_hca(esw->dev);
+	if (ret)
+		goto pf_hca_err;
+
 	/* Enable ECPF vport */
 	if (mlx5_ecpf_vport_exists(esw->dev)) {
 		ret =3D mlx5_eswitch_load_vport(esw, MLX5_VPORT_ECPF, enabled_events);
@@ -1500,8 +1525,9 @@ mlx5_eswitch_enable_pf_vf_vports(struct mlx5_eswitch =
*esw,
 vf_err:
 	if (mlx5_ecpf_vport_exists(esw->dev))
 		mlx5_eswitch_unload_vport(esw, MLX5_VPORT_ECPF);
-
 ecpf_err:
+	host_pf_disable_hca(esw->dev);
+pf_hca_err:
 	mlx5_eswitch_unload_vport(esw, MLX5_VPORT_PF);
 	return ret;
 }
@@ -1516,6 +1542,7 @@ void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_es=
witch *esw)
 	if (mlx5_ecpf_vport_exists(esw->dev))
 		mlx5_eswitch_unload_vport(esw, MLX5_VPORT_ECPF);
=20
+	host_pf_disable_hca(esw->dev);
 	mlx5_eswitch_unload_vport(esw, MLX5_VPORT_PF);
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index a9757ccb9d16..d86f06f14cd3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1126,23 +1126,23 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_sriov;
 	}
=20
-	err =3D mlx5_sriov_attach(dev);
-	if (err) {
-		mlx5_core_err(dev, "sriov init failed %d\n", err);
-		goto err_sriov;
-	}
-
 	err =3D mlx5_ec_init(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed to init embedded CPU\n");
 		goto err_ec;
 	}
=20
+	err =3D mlx5_sriov_attach(dev);
+	if (err) {
+		mlx5_core_err(dev, "sriov init failed %d\n", err);
+		goto err_sriov;
+	}
+
 	return 0;
=20
-err_ec:
-	mlx5_sriov_detach(dev);
 err_sriov:
+	mlx5_ec_cleanup(dev);
+err_ec:
 	mlx5_cleanup_fs(dev);
 err_fs:
 	mlx5_accel_tls_cleanup(dev);
@@ -1168,8 +1168,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
=20
 static void mlx5_unload(struct mlx5_core_dev *dev)
 {
-	mlx5_ec_cleanup(dev);
 	mlx5_sriov_detach(dev);
+	mlx5_ec_cleanup(dev);
 	mlx5_cleanup_fs(dev);
 	mlx5_accel_ipsec_cleanup(dev);
 	mlx5_accel_tls_cleanup(dev);
--=20
2.26.2

