Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169C22B0DE4
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgKLTZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:25:02 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14174 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgKLTY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:24:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad8c0d0000>; Thu, 12 Nov 2020 11:25:01 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 19:24:55 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
CC:     <jiri@nvidia.com>, <jgg@nvidia.com>, <dledford@redhat.com>,
        <leonro@nvidia.com>, <saeedm@nvidia.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, Vu Pham <vuhuong@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next 09/13] net/mlx5: E-switch, Prepare eswitch to handle SF vport
Date:   Thu, 12 Nov 2020 21:24:19 +0200
Message-ID: <20201112192424.2742-10-parav@nvidia.com>
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
        t=1605209101; bh=+QdD0DnoAEwckFSr4hAwtfSNQ5UmKtgLH+sUbnwKqEA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lKVKPeiQ968zLaPe/y3n5OomvB01RDErZg/Ygneo0cV3YKQaUSdxrjSm0Xu7YTj3u
         f91nHz1o+kZaI8VzeLkK9V8Wfxr7IwVJQdmGYUgjEWY9ja711owLOdVNbdEEdcdMcf
         lsWdrR/pd0oBY5pQF9oEBP2IIRn/UwydbKDI1i7LtTOknn37cHKBn21cBBIVeCz8pV
         L+1SeCQi8RNQbv8PRsYT0WSPozSQVYMolJevxK6ydu1/qQQ2z4fNLKx7OFOEObncur
         VpbXV2ZvLJMqgS/e1vqJwtsE30zpE2Cg9KSXVnnbjH5tUHiuuW9E7W4sygNdDLF4/6
         Nkjes6P9G0yxA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@nvidia.com>

Prepare eswitch to handle SF vport during
(a) querying eswitch functions
(b) egress ACL creation
(c) account for SF vports in total vports calculation

Assign a dedicated placeholder for SFs vports and their representors.
They are placed after VFs vports and before ECPF vports as below:
[PF,VF0,...,VFn,SF0,...SFm,ECPF,UPLINK].

Change functions to map SF's vport numbers to indices when
accessing the vports or representors arrays, and vice versa.

Signed-off-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   | 10 ++++
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 +++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 55 +++++++++++++++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 11 ++++
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   | 35 ++++++++++++
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  3 +-
 7 files changed, 123 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/=
ethernet/mellanox/mlx5/core/Kconfig
index 10dfaf671c90..11d5e0e99bd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -211,3 +211,13 @@ config MLX5_SF
 	Build support for subfuction device in the NIC. A Mellanox subfunction
 	device can support RDMA, netdevice and vdpa device.
 	It is similar to a SRIOV VF but it doesn't require SRIOV support.
+
+config MLX5_SF_MANAGER
+	bool
+	depends on MLX5_SF && MLX5_ESWITCH
+	default y
+	help
+	Build support for subfuction port in the NIC. A Mellanox subfunction
+	port is managed through devlink.  A subfunction supports RDMA, netdevice
+	and vdpa device. It is similar to a SRIOV VF but it doesn't require
+	SRIOV support.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c =
b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index c3faae67e4d6..45758ff3c14e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -150,7 +150,7 @@ static void esw_acl_egress_ofld_groups_destroy(struct m=
lx5_vport *vport)
=20
 static bool esw_acl_egress_needed(const struct mlx5_eswitch *esw, u16 vpor=
t_num)
 {
-	return mlx5_eswitch_is_vf_vport(esw, vport_num);
+	return mlx5_eswitch_is_vf_vport(esw, vport_num) || mlx5_esw_is_sf_vport(e=
sw, vport_num);
 }
=20
 int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport =
*vport)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index b44f28fb5518..5b90f126b7f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1369,9 +1369,15 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core=
_dev *dev)
 {
 	int outlen =3D MLX5_ST_SZ_BYTES(query_esw_functions_out);
 	u32 in[MLX5_ST_SZ_DW(query_esw_functions_in)] =3D {};
+	u16 max_sf_vports;
 	u32 *out;
 	int err;
=20
+	max_sf_vports =3D mlx5_sf_max_ports(dev);
+	/* Device interface is array of 64-bits */
+	if (max_sf_vports)
+		outlen +=3D DIV_ROUND_UP(max_sf_vports, BITS_PER_TYPE(__be64)) * sizeof(=
__be64);
+
 	out =3D kvzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return ERR_PTR(-ENOMEM);
@@ -1379,7 +1385,7 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_=
dev *dev)
 	MLX5_SET(query_esw_functions_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_ESW_FUNCTIONS);
=20
-	err =3D mlx5_cmd_exec_inout(dev, query_esw_functions, in, out);
+	err =3D mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
 	if (!err)
 		return out;
=20
@@ -1874,7 +1880,8 @@ static bool
 is_port_function_supported(const struct mlx5_eswitch *esw, u16 vport_num)
 {
 	return vport_num =3D=3D MLX5_VPORT_PF ||
-	       mlx5_eswitch_is_vf_vport(esw, vport_num);
+	       mlx5_eswitch_is_vf_vport(esw, vport_num) ||
+	       mlx5_esw_is_sf_vport(esw, vport_num);
 }
=20
 int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index cf87de94418f..2165bc065196 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -43,6 +43,7 @@
 #include <linux/mlx5/fs.h>
 #include "lib/mpfs.h"
 #include "lib/fs_chains.h"
+#include "sf/sf.h"
 #include "en/tc_ct.h"
=20
 #ifdef CONFIG_MLX5_ESWITCH
@@ -499,6 +500,45 @@ static inline u16 mlx5_eswitch_first_host_vport_num(st=
ruct mlx5_core_dev *dev)
 		MLX5_VPORT_PF : MLX5_VPORT_FIRST_VF;
 }
=20
+static inline u16 mlx5_esw_sf_start_vport_num(const struct mlx5_core_dev *=
dev)
+{
+	return MLX5_CAP_GEN(dev, sf_base_id);
+}
+
+static inline int mlx5_esw_sf_start_idx(const struct mlx5_eswitch *esw)
+{
+	/* PF and VF vports indices start from 0 to max_vfs */
+	return MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev);
+}
+
+static inline int mlx5_esw_sf_end_idx(const struct mlx5_eswitch *esw)
+{
+	return mlx5_esw_sf_start_idx(esw) + mlx5_sf_max_ports(esw->dev);
+}
+
+static inline int
+mlx5_esw_sf_vport_num_to_index(const struct mlx5_eswitch *esw, u16 vport_n=
um)
+{
+	return vport_num - mlx5_esw_sf_start_vport_num(esw->dev) +
+	       MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev);
+}
+
+static inline u16
+mlx5_esw_sf_vport_index_to_num(const struct mlx5_eswitch *esw, int idx)
+{
+	return mlx5_esw_sf_start_vport_num(esw->dev) + idx -
+	       (MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev));
+}
+
+static inline bool
+mlx5_esw_is_sf_vport(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return mlx5_sf_supported(esw->dev) &&
+	       vport_num >=3D mlx5_esw_sf_start_vport_num(esw->dev) &&
+	       (vport_num < (mlx5_esw_sf_start_vport_num(esw->dev) +
+			     mlx5_sf_max_ports(esw->dev)));
+}
+
 static inline bool mlx5_eswitch_is_funcs_handler(const struct mlx5_core_de=
v *dev)
 {
 	return mlx5_core_is_ecpf_esw_manager(dev);
@@ -527,6 +567,10 @@ static inline int mlx5_eswitch_vport_num_to_index(stru=
ct mlx5_eswitch *esw,
 	if (vport_num =3D=3D MLX5_VPORT_UPLINK)
 		return mlx5_eswitch_uplink_idx(esw);
=20
+	if (mlx5_esw_is_sf_vport(esw, vport_num))
+		return mlx5_esw_sf_vport_num_to_index(esw, vport_num);
+
+	/* PF and VF vports start from 0 to max_vfs */
 	return vport_num;
 }
=20
@@ -540,6 +584,12 @@ static inline u16 mlx5_eswitch_index_to_vport_num(stru=
ct mlx5_eswitch *esw,
 	if (index =3D=3D mlx5_eswitch_uplink_idx(esw))
 		return MLX5_VPORT_UPLINK;
=20
+	/* SF vports indices are after VFs and before ECPF */
+	if (mlx5_sf_supported(esw->dev) &&
+	    index > mlx5_core_max_vfs(esw->dev))
+		return mlx5_esw_sf_vport_index_to_num(esw, index);
+
+	/* PF and VF vports start from 0 to max_vfs */
 	return index;
 }
=20
@@ -625,6 +675,11 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch=
 *esw);
 	for ((vport) =3D (nvfs);						\
 	     (vport) >=3D (esw)->first_host_vport; (vport)--)
=20
+#define mlx5_esw_for_each_sf_rep(esw, i, rep)		\
+	for ((i) =3D mlx5_esw_sf_start_idx(esw);		\
+	     (rep) =3D &(esw)->offloads.vport_reps[(i)],	\
+	     (i) < mlx5_esw_sf_end_idx(esw); (i++))
+
 struct mlx5_eswitch *mlx5_devlink_eswitch_get(struct devlink *devlink);
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 429dc613530b..01242afbfcce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1801,11 +1801,22 @@ static void __esw_offloads_unload_rep(struct mlx5_e=
switch *esw,
 		esw->offloads.rep_ops[rep_type]->unload(rep);
 }
=20
+static void __unload_reps_sf_vport(struct mlx5_eswitch *esw, u8 rep_type)
+{
+	struct mlx5_eswitch_rep *rep;
+	int i;
+
+	mlx5_esw_for_each_sf_rep(esw, i, rep)
+		__esw_offloads_unload_rep(esw, rep, rep_type);
+}
+
 static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
 {
 	struct mlx5_eswitch_rep *rep;
 	int i;
=20
+	__unload_reps_sf_vport(esw, rep_type);
+
 	mlx5_esw_for_each_vf_rep_reverse(esw, i, rep, esw->esw_funcs.num_vfs)
 		__esw_offloads_unload_rep(esw, rep, rep_type);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/=
ethernet/mellanox/mlx5/core/sf/sf.h
new file mode 100644
index 000000000000..7b9071a865ce
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Ltd */
+
+#ifndef __MLX5_SF_H__
+#define __MLX5_SF_H__
+
+#include <linux/mlx5/driver.h>
+
+#ifdef CONFIG_MLX5_SF_MANAGER
+
+static inline bool mlx5_sf_supported(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, sf);
+}
+
+static inline u16 mlx5_sf_max_ports(const struct mlx5_core_dev *dev)
+{
+	return mlx5_sf_supported(dev) ? 1 << MLX5_CAP_GEN(dev, log_max_sf) : 0;
+}
+
+#else
+
+static inline bool mlx5_sf_supported(const struct mlx5_core_dev *dev)
+{
+	return false;
+}
+
+static inline u16 mlx5_sf_max_ports(const struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+#endif
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/=
ethernet/mellanox/mlx5/core/vport.c
index bdafc85fd874..233aa8242916 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -36,6 +36,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/eswitch.h>
 #include "mlx5_core.h"
+#include "sf/sf.h"
=20
 /* Mutex to hold while enabling or disabling RoCE */
 static DEFINE_MUTEX(mlx5_roce_en_lock);
@@ -1160,6 +1161,6 @@ EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
  */
 u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
 {
-	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev);
+	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) + mlx5_sf_max_po=
rts(dev);
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_get_total_vports);
--=20
2.26.2

