Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2868EF342B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389229AbfKGQIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:08:54 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53437 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730429AbfKGQIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:08:53 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 18:08:49 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA7G8d4C007213;
        Thu, 7 Nov 2019 18:08:43 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, kwankhede@nvidia.com, leon@kernel.org,
        cohuck@redhat.com, jiri@mellanox.com, linux-rdma@vger.kernel.org,
        Vu Pham <vuhuong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 02/19] net/mlx5: E-Switch, Add SF vport, vport-rep support
Date:   Thu,  7 Nov 2019 10:08:17 -0600
Message-Id: <20191107160834.21087-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191107160834.21087-1-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

mlx5 Sub Function(SF) shares large amount functionalities and
capabilities as that of its parent PCI device.
Similar to SR-IOV VFs, each SF at present has one eswitch vport.

Assign a dedicated placeholder for SFs vports and their representors.
They are placed after VFs vports and before ECPF vports as below:
[PF,VF0,...,VFn,SF0,...SFm,ECPF,UPLINK].

Change functions to map SF's vport numbers to indices when
accessing the vports or representors arrays, and vice versa.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   | 11 +++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  6 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 70 +++++++++++++++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 19 ++++-
 .../ethernet/mellanox/mlx5/core/meddev/sf.h   | 17 +++++
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  4 +-
 6 files changed, 123 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index a1f20b205299..a088b5fd339d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -161,3 +161,14 @@ config MLX5_SW_STEERING
 	default y
 	help
 	Build support for software-managed steering in the NIC.
+
+config MLX5_MDEV
+	bool "Mellanox Technologies Mediated device support"
+	depends on MLX5_CORE
+	depends on VFIO_MDEV
+	depends on MLX5_ESWITCH
+	default n
+	help
+	  Build support for mediated devices. Mediated devices allow creating
+	  multiple virtual ports, netdev and/or rdma device(s) on
+	  single PCI function.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 7baade9e62b7..87273be44dae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1883,9 +1883,15 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_esw_functions_out);
 	u32 in[MLX5_ST_SZ_DW(query_esw_functions_in)] = {};
+	u16 max_sfs;
 	u32 *out;
 	int err;
 
+	max_sfs = mlx5_eswitch_max_sfs(dev);
+	/* Device interface is array of 64-bits */
+	if (max_sfs)
+		outlen += DIV_ROUND_UP(max_sfs, BITS_PER_TYPE(__be64)) * sizeof(__be64);
+
 	out = kvzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index e27d372e1c07..21592ef6d05d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -42,6 +42,8 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include "lib/mpfs.h"
+#include "mlx5_core.h"
+#include "meddev/sf.h"
 
 #ifdef CONFIG_MLX5_ESWITCH
 
@@ -506,6 +508,44 @@ static inline int mlx5_eswitch_ecpf_idx(struct mlx5_eswitch *esw)
 	return esw->total_vports - 2;
 }
 
+/* SF vport numbers in device range from the esw_sf_base_id and log_max_esw_sf.
+ * Below helpers perform conversion from SF vport index in software array
+ * to vport number and vice versa.
+ */
+static inline u16 mlx5_eswitch_sf_vport_base_id(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_ESW(dev, esw_sf_base_id);
+}
+
+static inline u16 mlx5_eswitch_max_sfs(const struct mlx5_core_dev *dev)
+{
+	return mlx5_core_is_sf_supported(dev) ?
+			1 << MLX5_CAP_ESW(dev, log_max_esw_sf) : 0;
+}
+
+static inline int
+mlx5_eswitch_sf_index(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return vport_num - mlx5_eswitch_sf_vport_base_id(esw->dev) +
+		MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev);
+}
+
+static inline u16
+mlx5_eswitch_sf_vport_num(const struct mlx5_eswitch *esw, int idx)
+{
+	return mlx5_eswitch_sf_vport_base_id(esw->dev) + idx -
+		(MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev));
+}
+
+static inline bool
+mlx5_eswitch_is_sf_vport(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return mlx5_core_is_sf_supported(esw->dev) &&
+		vport_num >= mlx5_eswitch_sf_vport_base_id(esw->dev) &&
+		vport_num < (mlx5_eswitch_sf_vport_base_id(esw->dev) +
+			     mlx5_eswitch_max_sfs(esw->dev));
+}
+
 static inline int mlx5_eswitch_vport_num_to_index(struct mlx5_eswitch *esw,
 						  u16 vport_num)
 {
@@ -518,6 +558,10 @@ static inline int mlx5_eswitch_vport_num_to_index(struct mlx5_eswitch *esw,
 	if (vport_num == MLX5_VPORT_UPLINK)
 		return mlx5_eswitch_uplink_idx(esw);
 
+	if (mlx5_eswitch_is_sf_vport(esw, vport_num))
+		return mlx5_eswitch_sf_index(esw, vport_num);
+
+	/* PF and VF vports start from 0 to max_vfs */
 	return vport_num;
 }
 
@@ -531,6 +575,12 @@ static inline u16 mlx5_eswitch_index_to_vport_num(struct mlx5_eswitch *esw,
 	if (index == mlx5_eswitch_uplink_idx(esw))
 		return MLX5_VPORT_UPLINK;
 
+	/* SF vports indices are after VFs and before ECPF */
+	if (mlx5_core_is_sf_supported(esw->dev) &&
+	    index > mlx5_core_max_vfs(esw->dev))
+		return mlx5_eswitch_sf_vport_num(esw, index);
+
+	/* PF and VF vports start from 0 to max_vfs */
 	return index;
 }
 
@@ -573,6 +623,21 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 	     (rep) = &(esw)->offloads.vport_reps[i],		\
 	     (i) <= (nvfs); (i)++)
 
+static inline int mlx5_eswitch_sf_start_idx(const struct mlx5_eswitch *esw)
+{
+	return MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev);
+}
+
+static inline int mlx5_eswitch_sf_end(const struct mlx5_eswitch *esw)
+{
+	return mlx5_eswitch_sf_start_idx(esw) + mlx5_eswitch_max_sfs(esw->dev);
+}
+
+#define mlx5_esw_for_each_sf_rep(esw, i, rep)			\
+	for ((i) = mlx5_eswitch_sf_start_idx(esw);		\
+	     (rep) = &(esw)->offloads.vport_reps[(i)],		\
+	     (i) < mlx5_eswitch_sf_end(esw); (i++))		\
+
 #define mlx5_esw_for_each_vf_rep_reverse(esw, i, rep, nvfs)	\
 	for ((i) = (nvfs);					\
 	     (rep) = &(esw)->offloads.vport_reps[i],		\
@@ -642,6 +707,11 @@ static inline void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, cons
 #define FDB_SLOW_PATH_CHAIN (FDB_MAX_CHAIN + 1)
 #define FDB_MAX_PRIO 1
 
+static inline u16 mlx5_eswitch_max_sfs(const struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif /* __MLX5_ESWITCH_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9924f06f0c2d..ff084499d681 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1467,8 +1467,18 @@ static void esw_offloads_unload_vf_reps(struct mlx5_eswitch *esw, int nvports)
 		__unload_reps_vf_vport(esw, nvports, rep_type);
 }
 
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
+	__unload_reps_sf_vport(esw, rep_type);
 	__unload_reps_vf_vport(esw, esw->esw_funcs.num_vfs, rep_type);
 
 	/* Special vports must be the last to unload. */
@@ -1928,7 +1938,8 @@ static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 	}
 
 	if (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
-	    mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
+	    (mlx5_eswitch_is_vf_vport(esw, vport->vport) ||
+	     mlx5_eswitch_is_sf_vport(esw, vport->vport))) {
 		err = esw_vport_ingress_prio_tag_config(esw, vport);
 		if (err)
 			goto prio_tag_err;
@@ -2006,7 +2017,8 @@ esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 	if (err)
 		return err;
 
-	if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
+	if (mlx5_eswitch_is_vf_vport(esw, vport->vport) ||
+	    mlx5_eswitch_is_sf_vport(esw, vport->vport)) {
 		err = esw_vport_egress_config(esw, vport);
 		if (err) {
 			esw_vport_del_ingress_acl_modify_metadata(esw, vport);
@@ -2061,7 +2073,8 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	if (mlx5_core_is_ecpf_esw_manager(esw->dev))
 		total_vports = esw->total_vports;
 	else
-		total_vports = num_vfs + MLX5_SPECIAL_VPORTS(esw->dev);
+		total_vports = num_vfs + MLX5_SPECIAL_VPORTS(esw->dev) +
+						mlx5_eswitch_max_sfs(esw->dev);
 
 	memset(&esw->fdb_table.offloads, 0, sizeof(struct offloads_fdb));
 	mutex_init(&esw->fdb_table.offloads.fdb_prio_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
new file mode 100644
index 000000000000..0cd28506e339
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/meddev/sf.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies */
+
+#ifndef __MLX5_SF_H__
+#define __MLX5_SF_H__
+
+#include <linux/mlx5/driver.h>
+#include <linux/mlx5/eswitch.h>
+
+static inline bool mlx5_core_is_sf_supported(const struct mlx5_core_dev *dev)
+{
+	return MLX5_ESWITCH_MANAGER(dev) &&
+	       MLX5_CAP_GEN(dev, max_num_sf_partitions) &&
+	       MLX5_CAP_GEN(dev, sf);
+}
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 30f7848a6f88..ffcaa04700bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -36,6 +36,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/eswitch.h>
 #include "mlx5_core.h"
+#include "eswitch.h"
 
 /* Mutex to hold while enabling or disabling RoCE */
 static DEFINE_MUTEX(mlx5_roce_en_lock);
@@ -1178,6 +1179,7 @@ EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
  */
 u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
 {
-	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev);
+	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) +
+		mlx5_eswitch_max_sfs(dev);
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_total_vports);
-- 
2.19.2

