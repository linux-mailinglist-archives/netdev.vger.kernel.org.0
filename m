Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5E92DA2BA
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbgLNVqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:46:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:46218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441159AbgLNVpb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 16:45:31 -0500
From:   Saeed Mahameed <saeed@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Vu Pham <vuhuong@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v4 09/15] net/mlx5: E-switch, Prepare eswitch to handle SF vport
Date:   Mon, 14 Dec 2020 13:43:46 -0800
Message-Id: <20201214214352.198172-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214214352.198172-1-saeed@kernel.org>
References: <20201214214352.198172-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   | 10 ++++
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 +++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 50 +++++++++++++++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 11 ++++
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  3 +-
 6 files changed, 83 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index d6c48582e7a8..ad45d20f9d44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -212,3 +212,13 @@ config MLX5_SF
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index 4c74e2690d57..26b37a0f8762 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -150,7 +150,7 @@ static void esw_acl_egress_ofld_groups_destroy(struct mlx5_vport *vport)
 
 static bool esw_acl_egress_needed(const struct mlx5_eswitch *esw, u16 vport_num)
 {
-	return mlx5_eswitch_is_vf_vport(esw, vport_num);
+	return mlx5_eswitch_is_vf_vport(esw, vport_num) || mlx5_esw_is_sf_vport(esw, vport_num);
 }
 
 int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index da901e364656..d75247a8ce55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1366,9 +1366,15 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_esw_functions_out);
 	u32 in[MLX5_ST_SZ_DW(query_esw_functions_in)] = {};
+	u16 max_sf_vports;
 	u32 *out;
 	int err;
 
+	max_sf_vports = mlx5_sf_max_functions(dev);
+	/* Device interface is array of 64-bits */
+	if (max_sf_vports)
+		outlen += DIV_ROUND_UP(max_sf_vports, BITS_PER_TYPE(__be64)) * sizeof(__be64);
+
 	out = kvzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return ERR_PTR(-ENOMEM);
@@ -1376,7 +1382,7 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 	MLX5_SET(query_esw_functions_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_ESW_FUNCTIONS);
 
-	err = mlx5_cmd_exec_inout(dev, query_esw_functions, in, out);
+	err = mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
 	if (!err)
 		return out;
 
@@ -1899,7 +1905,8 @@ static bool
 is_port_function_supported(const struct mlx5_eswitch *esw, u16 vport_num)
 {
 	return vport_num == MLX5_VPORT_PF ||
-	       mlx5_eswitch_is_vf_vport(esw, vport_num);
+	       mlx5_eswitch_is_vf_vport(esw, vport_num) ||
+	       mlx5_esw_is_sf_vport(esw, vport_num);
 }
 
 int mlx5_devlink_port_function_hw_addr_get(struct devlink *devlink,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index cf87de94418f..4e3ed878ff03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -43,6 +43,7 @@
 #include <linux/mlx5/fs.h>
 #include "lib/mpfs.h"
 #include "lib/fs_chains.h"
+#include "sf/sf.h"
 #include "en/tc_ct.h"
 
 #ifdef CONFIG_MLX5_ESWITCH
@@ -499,6 +500,40 @@ static inline u16 mlx5_eswitch_first_host_vport_num(struct mlx5_core_dev *dev)
 		MLX5_VPORT_PF : MLX5_VPORT_FIRST_VF;
 }
 
+static inline int mlx5_esw_sf_start_idx(const struct mlx5_eswitch *esw)
+{
+	/* PF and VF vports indices start from 0 to max_vfs */
+	return MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev);
+}
+
+static inline int mlx5_esw_sf_end_idx(const struct mlx5_eswitch *esw)
+{
+	return mlx5_esw_sf_start_idx(esw) + mlx5_sf_max_functions(esw->dev);
+}
+
+static inline int
+mlx5_esw_sf_vport_num_to_index(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return vport_num - mlx5_sf_start_function_id(esw->dev) +
+	       MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev);
+}
+
+static inline u16
+mlx5_esw_sf_vport_index_to_num(const struct mlx5_eswitch *esw, int idx)
+{
+	return mlx5_sf_start_function_id(esw->dev) + idx -
+	       (MLX5_VPORT_PF_PLACEHOLDER + mlx5_core_max_vfs(esw->dev));
+}
+
+static inline bool
+mlx5_esw_is_sf_vport(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return mlx5_sf_supported(esw->dev) &&
+	       vport_num >= mlx5_sf_start_function_id(esw->dev) &&
+	       (vport_num < (mlx5_sf_start_function_id(esw->dev) +
+			     mlx5_sf_max_functions(esw->dev)));
+}
+
 static inline bool mlx5_eswitch_is_funcs_handler(const struct mlx5_core_dev *dev)
 {
 	return mlx5_core_is_ecpf_esw_manager(dev);
@@ -527,6 +562,10 @@ static inline int mlx5_eswitch_vport_num_to_index(struct mlx5_eswitch *esw,
 	if (vport_num == MLX5_VPORT_UPLINK)
 		return mlx5_eswitch_uplink_idx(esw);
 
+	if (mlx5_esw_is_sf_vport(esw, vport_num))
+		return mlx5_esw_sf_vport_num_to_index(esw, vport_num);
+
+	/* PF and VF vports start from 0 to max_vfs */
 	return vport_num;
 }
 
@@ -540,6 +579,12 @@ static inline u16 mlx5_eswitch_index_to_vport_num(struct mlx5_eswitch *esw,
 	if (index == mlx5_eswitch_uplink_idx(esw))
 		return MLX5_VPORT_UPLINK;
 
+	/* SF vports indices are after VFs and before ECPF */
+	if (mlx5_sf_supported(esw->dev) &&
+	    index > mlx5_core_max_vfs(esw->dev))
+		return mlx5_esw_sf_vport_index_to_num(esw, index);
+
+	/* PF and VF vports start from 0 to max_vfs */
 	return index;
 }
 
@@ -625,6 +670,11 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 	for ((vport) = (nvfs);						\
 	     (vport) >= (esw)->first_host_vport; (vport)--)
 
+#define mlx5_esw_for_each_sf_rep(esw, i, rep)		\
+	for ((i) = mlx5_esw_sf_start_idx(esw);		\
+	     (rep) = &(esw)->offloads.vport_reps[(i)],	\
+	     (i) < mlx5_esw_sf_end_idx(esw); (i++))
+
 struct mlx5_eswitch *mlx5_devlink_eswitch_get(struct devlink *devlink);
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 2f6a0ae20650..2d241f7351b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1800,11 +1800,22 @@ static void __esw_offloads_unload_rep(struct mlx5_eswitch *esw,
 		esw->offloads.rep_ops[rep_type]->unload(rep);
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
 	struct mlx5_eswitch_rep *rep;
 	int i;
 
+	__unload_reps_sf_vport(esw, rep_type);
+
 	mlx5_esw_for_each_vf_rep_reverse(esw, i, rep, esw->esw_funcs.num_vfs)
 		__esw_offloads_unload_rep(esw, rep, rep_type);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index bdafc85fd874..ba78e0660523 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -36,6 +36,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/eswitch.h>
 #include "mlx5_core.h"
+#include "sf/sf.h"
 
 /* Mutex to hold while enabling or disabling RoCE */
 static DEFINE_MUTEX(mlx5_roce_en_lock);
@@ -1160,6 +1161,6 @@ EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
  */
 u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
 {
-	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev);
+	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) + mlx5_sf_max_functions(dev);
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_get_total_vports);
-- 
2.26.2

