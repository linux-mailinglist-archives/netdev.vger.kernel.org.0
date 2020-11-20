Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7ADD2BB99F
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgKTXEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1193 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728606AbgKTXEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0006>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:04:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: [PATCH mlx5-next 14/16] net/mlx5: Rename peer_pf to host_pf
Date:   Fri, 20 Nov 2020 15:03:37 -0800
Message-ID: <20201120230339.651609-15-saeedm@nvidia.com>
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
        t=1605913439; bh=urRcAetAinHa4Qxhvypt/JWuwdjs1jU7lqtjtq1fOi8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=XCJvAIEF4YLLR3c0OJlgvLL9eQBGIMeMsXwg15vq6rdksGaenhTg7t/duP1fjy8jg
         MLuD+WDTPCvVe/gkFEXeldyPcBVlAUpK8WMy9nfUOogFkKnqOFgbIzORZslWRHdQ+4
         KXwVqJfGyq8nnXFiRBraVsBTpNIebRWe8C6nwtYiHyJb0+Im7UiH6ot57wfHsNDM2a
         uRLluV7yG0mx6VWlE2a/mFNIiS2TztQmQIABGmzqVj3Pzz6wUf3hIljK5ZkGJOW13g
         jSdvBG3wHsuP+9hNPV5r7somzZIJ3221vlTYRS5CWUc9/4Khib4q/YxVCzc0nNFrIG
         5kY7KeNGCF6FQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

To match the hardware spec, rename peer_pf to host_pf.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    | 51 ++++++++++++-------
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 12 ++---
 include/linux/mlx5/driver.h                   |  2 +-
 3 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/e=
thernet/mellanox/mlx5/core/ecpf.c
index 3dc9dd3f24dc..68ca0e2b26cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -8,37 +8,52 @@ bool mlx5_read_embedded_cpu(struct mlx5_core_dev *dev)
 	return (ioread32be(&dev->iseg->initializing) >> MLX5_ECPU_BIT_NUM) & 1;
 }
=20
-static int mlx5_peer_pf_init(struct mlx5_core_dev *dev)
+static int mlx5_cmd_host_pf_enable_hca(struct mlx5_core_dev *dev)
 {
-	u32 in[MLX5_ST_SZ_DW(enable_hca_in)] =3D {};
-	int err;
+	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(enable_hca_in)]   =3D {};
=20
 	MLX5_SET(enable_hca_in, in, opcode, MLX5_CMD_OP_ENABLE_HCA);
-	err =3D mlx5_cmd_exec_in(dev, enable_hca, in);
+	MLX5_SET(enable_hca_in, in, function_id, 0);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function, 0);
+	return mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+}
+
+static int mlx5_cmd_host_pf_disable_hca(struct mlx5_core_dev *dev)
+{
+	u32 out[MLX5_ST_SZ_DW(disable_hca_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(disable_hca_in)]   =3D {};
+
+	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
+	MLX5_SET(disable_hca_in, in, function_id, 0);
+	MLX5_SET(disable_hca_in, in, embedded_cpu_function, 0);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+static int mlx5_host_pf_init(struct mlx5_core_dev *dev)
+{
+	int err;
+
+	err =3D mlx5_cmd_host_pf_enable_hca(dev);
 	if (err)
-		mlx5_core_err(dev, "Failed to enable peer PF HCA err(%d)\n",
-			      err);
+		mlx5_core_err(dev, "Failed to enable external host PF HCA err(%d)\n", er=
r);
=20
 	return err;
 }
=20
-static void mlx5_peer_pf_cleanup(struct mlx5_core_dev *dev)
+static void mlx5_host_pf_cleanup(struct mlx5_core_dev *dev)
 {
-	u32 in[MLX5_ST_SZ_DW(disable_hca_in)] =3D {};
 	int err;
=20
-	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
-	err =3D mlx5_cmd_exec_in(dev, disable_hca, in);
+	err =3D mlx5_cmd_host_pf_disable_hca(dev);
 	if (err) {
-		mlx5_core_err(dev, "Failed to disable peer PF HCA err(%d)\n",
-			      err);
+		mlx5_core_err(dev, "Failed to disable external host PF HCA err(%d)\n", e=
rr);
 		return;
 	}
=20
-	err =3D mlx5_wait_for_pages(dev, &dev->priv.peer_pf_pages);
+	err =3D mlx5_wait_for_pages(dev, &dev->priv.host_pf_pages);
 	if (err)
-		mlx5_core_warn(dev, "Timeout reclaiming peer PF pages err(%d)\n",
-			       err);
+		mlx5_core_warn(dev, "Timeout reclaiming external host PF pages err(%d)\n=
", err);
 }
=20
 int mlx5_ec_init(struct mlx5_core_dev *dev)
@@ -46,10 +61,10 @@ int mlx5_ec_init(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_ecpf(dev))
 		return 0;
=20
-	/* ECPF shall enable HCA for peer PF in the same way a PF
+	/* ECPF shall enable HCA for host PF in the same way a PF
 	 * does this for its VFs.
 	 */
-	return mlx5_peer_pf_init(dev);
+	return mlx5_host_pf_init(dev);
 }
=20
 void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
@@ -57,5 +72,5 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_ecpf(dev))
 		return;
=20
-	mlx5_peer_pf_cleanup(dev);
+	mlx5_host_pf_cleanup(dev);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/=
net/ethernet/mellanox/mlx5/core/pagealloc.c
index 150638814517..539baea358bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -374,7 +374,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 fu=
nc_id, int npages,
 	if (func_id)
 		dev->priv.vfs_pages +=3D npages;
 	else if (mlx5_core_is_ecpf(dev) && !ec_function)
-		dev->priv.peer_pf_pages +=3D npages;
+		dev->priv.host_pf_pages +=3D npages;
=20
 	mlx5_core_dbg(dev, "npages %d, ec_function %d, func_id 0x%x, err %d\n",
 		      npages, ec_function, func_id, err);
@@ -416,7 +416,7 @@ static void release_all_pages(struct mlx5_core_dev *dev=
, u32 func_id,
 	if (func_id)
 		dev->priv.vfs_pages -=3D npages;
 	else if (mlx5_core_is_ecpf(dev) && !ec_function)
-		dev->priv.peer_pf_pages -=3D npages;
+		dev->priv.host_pf_pages -=3D npages;
=20
 	mlx5_core_dbg(dev, "npages %d, ec_function %d, func_id 0x%x\n",
 		      npages, ec_function, func_id);
@@ -506,7 +506,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32=
 func_id, int npages,
 	if (func_id)
 		dev->priv.vfs_pages -=3D num_claimed;
 	else if (mlx5_core_is_ecpf(dev) && !ec_function)
-		dev->priv.peer_pf_pages -=3D num_claimed;
+		dev->priv.host_pf_pages -=3D num_claimed;
=20
 out_free:
 	kvfree(out);
@@ -661,9 +661,9 @@ int mlx5_reclaim_startup_pages(struct mlx5_core_dev *de=
v)
 	WARN(dev->priv.vfs_pages,
 	     "VFs FW pages counter is %d after reclaiming all pages\n",
 	     dev->priv.vfs_pages);
-	WARN(dev->priv.peer_pf_pages,
-	     "Peer PF FW pages counter is %d after reclaiming all pages\n",
-	     dev->priv.peer_pf_pages);
+	WARN(dev->priv.host_pf_pages,
+	     "External host PF FW pages counter is %d after reclaiming all pages\=
n",
+	     dev->priv.host_pf_pages);
=20
 	return 0;
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d6ef3068d7d3..8e9bcb3bfd77 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -547,7 +547,7 @@ struct mlx5_priv {
 	atomic_t		reg_pages;
 	struct list_head	free_list;
 	int			vfs_pages;
-	int			peer_pf_pages;
+	int			host_pf_pages;
=20
 	struct mlx5_core_health health;
=20
--=20
2.26.2

