Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D944D2B0DEA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgKLTZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:25:11 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11890 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgKLTY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c050000>; Thu, 12 Nov 2020 11:24:53 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:58 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Vu Pham <vuhuong@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 11/13] net/mlx5: SF, Add SF configuration hardware commands
Date:   Thu, 12 Nov 2020 21:24:21 +0200
Message-ID: <20201112192424.2742-12-parav@nvidia.com>
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
        t=1605209093; bh=5i1PQZ1/8jjIYq9/gILm63zgTWgNxBLAtrpxiC4y5bQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=bx/iCrUn6h+eWSj6AdY0eOX5CC7KOXUAxU62W4DLGjdTBCvPHo5ynkIqLIMlYK/Wx
         D2NFnEZkzpm5mp5r1pDOU2yQAdPH3j6m3D3BskLyZfvXuxASw/XM2FB0vVIholsVxJ
         yoSEM8RDdlkUY5IIceg+L5zfflFOun5y77zZfToJ3x4PdJJ9SP4mQ5niNSWrk6DOO9
         /IELPr5UyWEjfW438Tt3JqEZW1HPhDcf9KkPZBoqkCmrgK2ywiVG79qTZ62cMchmzm
         faBgHYw67x/jGBmFwgClN6pcIR6DTDd7qgSxXYK2YMhI1nsaZE8wO/nGTs0n9rN+Nf
         xZHbVQU/wBFFA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@nvidia.com>

Add command helpers to access SF port and function in device.

Enable SF HCA port capability when such configuration is enabled
and supported in a device.

Use them in subsequent patches.

Signed-off-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  4 ++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  5 ++
 .../net/ethernet/mellanox/mlx5/core/sf/cmd.c  | 48 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h | 14 ++++++
 5 files changed, 76 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 7dd5be49fb9e..911e7bb43b23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -89,3 +89,8 @@ mlx5_core-$(CONFIG_MLX5_SW_STEERING) +=3D steering/dr_dom=
ain.o steering/dr_table.o
 # SF device
 #
 mlx5_core-$(CONFIG_MLX5_SF) +=3D sf/dev/dev.o sf/dev/driver.o
+
+#
+# SF manager
+#
+mlx5_core-$(CONFIG_MLX5_SF_MANAGER) +=3D sf/cmd.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/et=
hernet/mellanox/mlx5/core/cmd.c
index e49387dbef98..7de8139bc167 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -333,6 +333,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core=
_dev *dev, u16 op,
 	case MLX5_CMD_OP_DEALLOC_MEMIC:
 	case MLX5_CMD_OP_PAGE_FAULT_RESUME:
 	case MLX5_CMD_OP_QUERY_ESW_FUNCTIONS:
+	case MLX5_CMD_OP_DEALLOC_SF:
 		return MLX5_CMD_STAT_OK;
=20
 	case MLX5_CMD_OP_QUERY_HCA_CAP:
@@ -464,6 +465,7 @@ static int mlx5_internal_err_ret_value(struct mlx5_core=
_dev *dev, u16 op,
 	case MLX5_CMD_OP_ALLOC_MEMIC:
 	case MLX5_CMD_OP_MODIFY_XRQ:
 	case MLX5_CMD_OP_RELEASE_XRQ_ERROR:
+	case MLX5_CMD_OP_ALLOC_SF:
 		*status =3D MLX5_DRIVER_STATUS_ABORTED;
 		*synd =3D MLX5_DRIVER_SYND;
 		return -EIO;
@@ -657,6 +659,8 @@ const char *mlx5_command_str(int command)
 	MLX5_COMMAND_STR_CASE(DESTROY_UMEM);
 	MLX5_COMMAND_STR_CASE(RELEASE_XRQ_ERROR);
 	MLX5_COMMAND_STR_CASE(MODIFY_XRQ);
+	MLX5_COMMAND_STR_CASE(ALLOC_SF);
+	MLX5_COMMAND_STR_CASE(DEALLOC_SF);
 	default: return "unknown command opcode";
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index adfa21de938e..bd414d93f70e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -567,6 +567,11 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, v=
oid *set_ctx)
 	if (MLX5_CAP_GEN_MAX(dev, mkey_by_name))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, mkey_by_name, 1);
=20
+#ifdef CONFIG_MLX5_SF_MANAGER
+	if (MLX5_CAP_GEN_MAX(dev, sf) && MLX5_ESWITCH_MANAGER(dev))
+		MLX5_SET(cmd_hca_cap, set_hca_cap, sf, 1);
+#endif
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/sf/cmd.c
new file mode 100644
index 000000000000..8dd44a2b2467
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/cmd.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#include <linux/mlx5/driver.h>
+
+int mlx5_cmd_alloc_sf(struct mlx5_core_dev *dev, u16 function_id)
+{
+	u32 out[MLX5_ST_SZ_DW(alloc_sf_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(alloc_sf_in)] =3D {};
+
+	MLX5_SET(alloc_sf_in, in, opcode, MLX5_CMD_OP_ALLOC_SF);
+	MLX5_SET(alloc_sf_in, in, function_id, function_id);
+
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5_cmd_dealloc_sf(struct mlx5_core_dev *dev, u16 function_id)
+{
+	u32 out[MLX5_ST_SZ_DW(dealloc_sf_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(dealloc_sf_in)] =3D {};
+
+	MLX5_SET(dealloc_sf_in, in, opcode, MLX5_CMD_OP_DEALLOC_SF);
+	MLX5_SET(dealloc_sf_in, in, function_id, function_id);
+
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
+
+int mlx5_cmd_sf_enable_hca(struct mlx5_core_dev *dev, u16 func_id)
+{
+	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(enable_hca_in)] =3D {};
+
+	MLX5_SET(enable_hca_in, in, opcode, MLX5_CMD_OP_ENABLE_HCA);
+	MLX5_SET(enable_hca_in, in, function_id, func_id);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function, 0);
+	return mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+}
+
+int mlx5_cmd_sf_disable_hca(struct mlx5_core_dev *dev, u16 func_id)
+{
+	u32 out[MLX5_ST_SZ_DW(disable_hca_out)] =3D {};
+	u32 in[MLX5_ST_SZ_DW(disable_hca_in)] =3D {};
+
+	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
+	MLX5_SET(disable_hca_in, in, function_id, func_id);
+	MLX5_SET(enable_hca_in, in, embedded_cpu_function, 0);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/sf/priv.h
new file mode 100644
index 000000000000..0e39df9f297e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#ifndef __MLX5_SF_PRIV_H__
+#define __MLX5_SF_PRIV_H__
+
+#include <linux/mlx5/driver.h>
+
+int mlx5_cmd_alloc_sf(struct mlx5_core_dev *dev, u16 function_id);
+int mlx5_cmd_dealloc_sf(struct mlx5_core_dev *dev, u16 function_id);
+int mlx5_cmd_sf_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
+int mlx5_cmd_sf_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
+
+#endif
--=20
2.26.2

