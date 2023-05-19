Return-Path: <netdev+bounces-3990-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFFB6709F14
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A0671C21358
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199DE6FD2;
	Fri, 19 May 2023 18:31:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0A413AC1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 18:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7436BC433D2;
	Fri, 19 May 2023 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684521078;
	bh=uDEJBCqOYNn6+X+w3DqPIXQNhgojrKxe+PJUv6yrTPg=;
	h=From:To:Cc:Subject:Date:From;
	b=LBrDwIfURDlERUeotgoo/HBV1Zs8OTevaqtHRICnV+9D1A8VY53qkVxyca6LwQl9X
	 ikaOEYu+hQ2vzKoKMKqNJt9w4W3S2BezdmjROrMZf89nSG02Ikzh4xyN8qENqc/KX3
	 EHhN4dZm2tKvrGSd+0rMVdJpbhPpmLV/WGd3xBDwFXxmXX8h5KRz7oJVAejp6reJ7O
	 xnllWoQeXUmqWxkUB0xQV18zBMTMCpYIZ5PjMkwiLJnntuOfEfZ/mgn5yyfGci3av8
	 6zuMJYE+vNIJdrdJ0xlMgIQ8FJlKSV2UpRhwq4Usgd7jm7mR+eBBAX/WZVC2A28r5L
	 /gmx4f2ks6z0Q==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next] net/mlx5: Introduce SF direction
Date: Fri, 19 May 2023 11:30:44 -0700
Message-Id: <20230519183044.19065-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

Whenever multiple Virtual Network functions (VNFs) are used by Service
Function Chaining (SFC), each packet is passing through all the VNFs,
and each VNF is performing hairpin in order to pass the packet to the
next function in the chain.

In case one mlx5 NIC is servicing multiple VNFs of the SFC, mlx5 need
user input in order to optimize this hairpin to a simple forward rule.

The optimization is performed by binding two PCI SFs to each VNF, as
can be seen bellow:

             -----------          -----------
             |   VNF1  |          |   VNF2  |
             -----------          -----------
                |  |                 |  |
       (Net) SF1|  |SF2     (Net) SF3|  |SF4
                |  |                 |  |
             -------------------------------
             | /   \________________/    \ |
    uplink---|/                           \|----host
             |                NIC(SFC)     |
             |                             |
             -------------------------------

Define SF1 and SF3 as SFs with network direction tell the driver to
configure the E-switch in a way that the packet arriving from SF1 will
do forward to SF2 instead of hairpin.

This marking is done via sfnum command line argument, where bit 16
marks the SF as facing the Network, and bit 17 marks the SF as
facing the Host.

For example:
- Network SF creation:
$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 0x10000
- Host SF creation:
$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 0x20000

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/switchdev.rst      | 11 ++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 15 +++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  9 +++++
 .../mellanox/mlx5/core/eswitch_offloads.c     | 28 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 39 ++++++++++++++++---
 include/linux/mlx5/mlx5_ifc.h                 |  6 ++-
 include/linux/mlx5/vport.h                    |  2 +
 7 files changed, 98 insertions(+), 12 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
index 01deedb71597..ca27043586a2 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
@@ -132,6 +132,17 @@ Subfunction is created using devlink port interface.
 
     $ devlink port del pci/0000:06:00.0/32768
 
+Subfunction Direction
+---------------------
+
+In some use cases, it is preferred that the user will set the direction of the
+subfunction. e.g.: user will decide whether the SF faces the Network or faces
+the host.
+mlx5 driver is using the top 16 bits of SF num as vendor specific flags.
+Host range numbering: 0x10000 - 0x1ffff, bit 16
+Networking range numbering: 0x20000 - 0x2ffff, bit 17
+bit 18-31, reserved.
+
 Function attributes
 ===================
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 901c53751b0a..af8de1bfdbf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -103,6 +103,15 @@ mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num)
 	return vport;
 }
 
+u8 mlx5_eswitch_get_vport_direction(struct mlx5_core_dev *dev, u16 vport_num)
+{
+	struct mlx5_vport *vport = mlx5_eswitch_get_vport(dev->priv.eswitch, vport_num);
+
+	if (IS_ERR(vport))
+		return 0;
+	return vport->info.direction;
+}
+
 static int arm_vport_context_events_cmd(struct mlx5_core_dev *dev, u16 vport,
 					u32 events_mask)
 {
@@ -831,10 +840,8 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 	if (err)
 		goto err_caps;
 
-	mlx5_modify_vport_admin_state(esw->dev,
-				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
-				      vport_num, 1,
-				      vport->info.link_state);
+	mlx5_modify_vport_state(esw->dev, MLX5_VPORT_STATE_OP_MOD_ESW_VPORT, vport_num,
+				1, vport->info.link_state, vport->info.direction);
 
 	/* Host PF has its own mac/guid. */
 	if (vport_num) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 1a042c981713..3df2b31aaa7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -147,6 +147,11 @@ struct mlx5_vport_drop_stats {
 	u64 tx_dropped;
 };
 
+enum mlx5_vport_direction {
+	MLX5_VPORT_DIRECTION_NETWORK = 1,
+	MLX5_VPORT_DIRECTION_HOST = 2,
+};
+
 struct mlx5_vport_info {
 	u8                      mac[ETH_ALEN];
 	u16                     vlan;
@@ -157,6 +162,7 @@ struct mlx5_vport_info {
 	u8                      trusted: 1;
 	u8                      roce_enabled: 1;
 	u8                      mig_enabled: 1;
+	u8			direction: 2;
 };
 
 /* Vport context events */
@@ -640,6 +646,7 @@ void mlx5e_tc_clean_fdb_peer_flows(struct mlx5_eswitch *esw);
 struct mlx5_eswitch *mlx5_devlink_eswitch_get(struct devlink *devlink);
 struct mlx5_vport *__must_check
 mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num);
+u8 mlx5_eswitch_get_vport_direction(struct mlx5_core_dev *dev, u16 vport_num);
 
 bool mlx5_eswitch_is_vf_vport(struct mlx5_eswitch *esw, u16 vport_num);
 bool mlx5_esw_is_sf_vport(struct mlx5_eswitch *esw, u16 vport_num);
@@ -770,6 +777,8 @@ static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw) {}
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev) { return false; }
 static inline
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw, u16 vport, int link_state) { return 0; }
+static inline
+u8 mlx5_eswitch_get_vport_direction(struct mlx5_core_dev *dev, u16 vport_num) {return 0; }
 static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
 	return ERR_PTR(-EOPNOTSUPP);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 69215ffb9999..9afae14331d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -71,6 +71,9 @@
 #define MLX5_ESW_VPORT_TBL_SIZE 128
 #define MLX5_ESW_VPORT_TBL_NUM_GROUPS  4
 
+#define MLX5_ESW_SF_VPORT_NETWORK BIT(16)
+#define MLX5_ESW_SF_VPORT_HOST BIT(17)
+
 #define MLX5_ESW_FT_OFFLOADS_DROP_RULE (1)
 
 static struct esw_vport_tbl_namespace mlx5_esw_vport_tbl_mirror_ns = {
@@ -3791,11 +3794,36 @@ u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_match);
 
+static int mlx5_esw_offloads_sf_vport_set_direction(struct mlx5_eswitch *esw,
+						    u16 vport_num, u32 sfnum)
+{
+	struct mlx5_vport *vport;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport))
+		return PTR_ERR(vport);
+
+	if (hweight16(upper_16_bits(sfnum)) > 1)
+		return -EINVAL;
+
+	if (sfnum & MLX5_ESW_SF_VPORT_NETWORK)
+		vport->info.direction = MLX5_VPORT_DIRECTION_NETWORK;
+	else if (sfnum & MLX5_ESW_SF_VPORT_HOST)
+		vport->info.direction = MLX5_VPORT_DIRECTION_HOST;
+	else if (upper_16_bits(sfnum))
+		return -EINVAL;
+	return 0;
+}
+
 int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
 				      u16 vport_num, u32 controller, u32 sfnum)
 {
 	int err;
 
+	err = mlx5_esw_offloads_sf_vport_set_direction(esw, vport_num, sfnum);
+	if (err)
+		return err;
+
 	err = mlx5_esw_vport_enable(esw, vport_num, MLX5_VPORT_UC_ADDR_CHANGE);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index ba7e3df22413..b1c8b9762839 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -36,16 +36,16 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/eswitch.h>
 #include "mlx5_core.h"
+#include "eswitch.h"
 #include "sf/sf.h"
 
 /* Mutex to hold while enabling or disabling RoCE */
 static DEFINE_MUTEX(mlx5_roce_en_lock);
 
-u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
+static int _mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod,
+				  u16 vport, u32 *out)
 {
-	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vport_state_in)] = {};
-	int err;
 
 	MLX5_SET(query_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_VPORT_STATE);
@@ -54,15 +54,34 @@ u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
 	if (vport)
 		MLX5_SET(query_vport_state_in, in, other_vport, 1);
 
-	err = mlx5_cmd_exec_inout(mdev, query_vport_state, in, out);
+	return mlx5_cmd_exec_inout(mdev, query_vport_state, in, out);
+}
+
+u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
+{
+	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {};
+	int err;
+
+	err = _mlx5_query_vport_state(mdev, opmod, vport, out);
 	if (err)
 		return 0;
 
 	return MLX5_GET(query_vport_state_out, out, state);
 }
 
-int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
-				  u16 vport, u8 other_vport, u8 state)
+static u8 mlx5_query_vport_direction(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
+{
+	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {};
+	int err;
+
+	err = _mlx5_query_vport_state(mdev, opmod, vport, out);
+	if (err)
+		return 0;
+	return MLX5_GET(query_vport_state_out, out, direction);
+}
+
+int mlx5_modify_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport,
+			    u8 other_vport, u8 state, u8 direction)
 {
 	u32 in[MLX5_ST_SZ_DW(modify_vport_state_in)] = {};
 
@@ -71,11 +90,19 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 	MLX5_SET(modify_vport_state_in, in, op_mod, opmod);
 	MLX5_SET(modify_vport_state_in, in, vport_number, vport);
 	MLX5_SET(modify_vport_state_in, in, other_vport, other_vport);
+	MLX5_SET(modify_vport_state_in, in, direction, direction);
 	MLX5_SET(modify_vport_state_in, in, admin_state, state);
 
 	return mlx5_cmd_exec_in(mdev, modify_vport_state, in);
 }
 
+int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
+				  u16 vport, u8 other_vport, u8 state)
+{
+	return mlx5_modify_vport_state(mdev, opmod, vport, other_vport, state,
+				       mlx5_query_vport_direction(mdev, opmod, vport));
+}
+
 static int mlx5_query_nic_vport_context(struct mlx5_core_dev *mdev, u16 vport,
 					u32 *out)
 {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index dc5e2cb302a5..17a111298584 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5010,7 +5010,8 @@ struct mlx5_ifc_query_vport_state_out_bits {
 
 	u8         reserved_at_40[0x20];
 
-	u8         reserved_at_60[0x18];
+	u8         reserved_at_60[0x15];
+	u8         direction[0x3];
 	u8         admin_state[0x4];
 	u8         state[0x4];
 };
@@ -7122,7 +7123,8 @@ struct mlx5_ifc_modify_vport_state_in_bits {
 	u8         reserved_at_41[0xf];
 	u8         vport_number[0x10];
 
-	u8         reserved_at_60[0x18];
+	u8         reserved_at_60[0x15];
+	u8         direction[0x3];
 	u8         admin_state[0x4];
 	u8         reserved_at_7c[0x4];
 };
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 7f31432f44c2..f41b68c12b8e 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -58,6 +58,8 @@ enum {
 u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport);
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 other_vport, u8 state);
+int mlx5_modify_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport,
+			    u8 other_vport, u8 state, u8 direction);
 int mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev,
 				     u16 vport, bool other, u8 *addr);
 int mlx5_query_mac_address(struct mlx5_core_dev *mdev, u8 *addr);
-- 
2.40.1


