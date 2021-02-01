Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD1730AE7E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhBARxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:53:19 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3845 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbhBARxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:53:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60183fe30000>; Mon, 01 Feb 2021 09:52:35 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 17:52:34 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Feb 2021 17:52:32 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <parav@nvidia.com>, <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH net-next 2/2] net/mlx5: E-Switch, Implement devlink port function cmds to control roce
Date:   Mon, 1 Feb 2021 19:51:52 +0200
Message-ID: <20210201175152.11280-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210201175152.11280-1-yishaih@nvidia.com>
References: <20210201175152.11280-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612201955; bh=x9xB3jMbhJCyXhHe4EhSaxFM8rLICFH/zbu0dH4wXww=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        b=NlYRYBAaKSyYZSPrHvCJAKlxH812wac6G2KtegTcd39Pwc3v2wGbz/YajoKLSJ1NA
         hg6UYg4c15MeJd5qd19aBlGApozceHm7q9F//Up/sf/LLNXS7qwKj84kMtiQSe++cQ
         isfiDbXpNC+jRASmajOqxb9AXAv0KOCYetZh+QkCyjJF3JjNkr0fOaJcVUOn/FQlIy
         c0WPdByNvHhwUVPmyhRMXD0FbmewD8GiWSztbsBx0Iurcsk9cMP8bl/pMY3aGwiWq8
         x80QUOCfkKy8lS64bOgnhgYYwwgTV5SMfQQADxlOV/VNH5BKEiCepBGJRb6MR0CFXE
         J9VpwoRwOXOZg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement devlink port function commands to enable / disable roce.
This is used to control the roce device capabilities.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |  32 ++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   3 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 138 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  10 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  35 +++++
 6 files changed, 217 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5=
.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index a1b32fcd0d76..3245b6a6dd39 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -322,6 +322,38 @@ device created for the PCI VF/SF.
       function:
         hw_addr 00:00:00:00:88:88
=20
+RoCE capability setup
+---------------------
+Not all mlx5 PCI VFs/SFs require RoCE capability.
+
+When RoCE capability is disabled, it saves 1 Mbytes worth of system memory=
 per
+PCI VF/SF.
+
+mlx5 driver provides mechanism to setup RoCE capability.
+
+When user disables RoCE capability for a VF/SF, user application cannot se=
nd or
+receive any RoCE packets through this VF/SF and RoCE GID table for this PC=
I
+will be empty.
+
+When RoCE capability is disabled in the device using port function attribu=
te,
+VF/SF driver cannot override it.
+
+- Get RoCE capability of the VF device::
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0=
 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 roce on
+
+- Set RoCE capability of the VF device::
+
+    $ devlink port function set pci/0000:06:00.0/2 roce off
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0=
 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 roce off
+
 SF state setup
 --------------
 To use the SF, the user must active the SF using the SF function state
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index aa76a6e0dae8..b8b6e8a1a436 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -276,6 +276,9 @@ static const struct devlink_ops mlx5_devlink_ops =3D {
 	.eswitch_encap_mode_get =3D mlx5_devlink_eswitch_encap_mode_get,
 	.port_function_hw_addr_get =3D mlx5_devlink_port_function_hw_addr_get,
 	.port_function_hw_addr_set =3D mlx5_devlink_port_function_hw_addr_set,
+	.port_fn_roce_get =3D mlx5_devlink_port_function_roce_get,
+	.port_fn_roce_set =3D mlx5_devlink_port_function_roce_set,
+
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new =3D mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 820305b1664e..349a6fd21ff2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1220,6 +1220,32 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitc=
h *esw,
 		esw_vport_destroy_offloads_acl_tables(esw, vport);
 }
=20
+static int mlx5_esw_vport_roce_cap_get(struct mlx5_eswitch *esw, struct ml=
x5_vport *vport)
+{
+	int query_out_sz =3D MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *query_ctx;
+	void *hca_caps;
+	int err;
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return 0;
+
+	query_ctx =3D kzalloc(query_out_sz, GFP_KERNEL);
+	if (!query_ctx)
+		return -ENOMEM;
+
+	err =3D mlx5_vport_get_other_func_cap(esw->dev, vport->vport, query_ctx);
+	if (err)
+		goto out_free;
+
+	hca_caps =3D MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	vport->info.roce_enabled =3D MLX5_GET(cmd_hca_cap, hca_caps, roce);
+
+out_free:
+	kfree(query_ctx);
+	return err;
+}
+
 static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vp=
ort)
 {
 	u16 vport_num =3D vport->vport;
@@ -1236,6 +1262,10 @@ static int esw_vport_setup(struct mlx5_eswitch *esw,=
 struct mlx5_vport *vport)
 	if (mlx5_esw_is_manager_vport(esw, vport_num))
 		return 0;
=20
+	err =3D mlx5_esw_vport_roce_cap_get(esw, vport);
+	if (err)
+		goto err_roce;
+
 	mlx5_modify_vport_admin_state(esw->dev,
 				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 				      vport_num, 1,
@@ -1255,6 +1285,11 @@ static int esw_vport_setup(struct mlx5_eswitch *esw,=
 struct mlx5_vport *vport)
 			       vport->info.qos, flags);
=20
 	return 0;
+
+err_roce:
+	esw_vport_disable_qos(esw, vport);
+	esw_vport_cleanup_acl(esw, vport);
+	return err;
 }
=20
 /* Don't cleanup vport->info, it's needed to restore vport configuration *=
/
@@ -1995,6 +2030,109 @@ int mlx5_devlink_port_function_hw_addr_set(struct d=
evlink *devlink,
 	return err;
 }
=20
+int mlx5_devlink_port_function_roce_get(struct devlink *devlink, struct de=
vlink_port *port,
+					bool *is_enabled, struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err =3D -EOPNOTSUPP;
+	u16 vport_num;
+
+	esw =3D mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return -EOPNOTSUPP;
+
+	vport_num =3D mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num))
+		return -EOPNOTSUPP;
+
+	vport =3D mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	if (vport->enabled) {
+		*is_enabled =3D vport->info.roce_enabled;
+		err =3D 0;
+	}
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
+int mlx5_devlink_port_function_roce_set(struct devlink *devlink, struct de=
vlink_port *port,
+					bool enable, struct netlink_ext_ack *extack)
+{
+	int query_out_sz =3D MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err =3D -EOPNOTSUPP;
+	void *query_ctx;
+	void *hca_caps;
+	u16 vport_num;
+
+	esw =3D mlx5_devlink_eswitch_get(devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return -EOPNOTSUPP;
+
+	vport_num =3D mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num))
+		return -EOPNOTSUPP;
+
+	vport =3D mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	if (!vport->enabled) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
+		goto out;
+	}
+
+	if (vport->info.roce_enabled =3D=3D enable) {
+		err =3D 0;
+		goto out;
+	}
+
+	query_ctx =3D kzalloc(query_out_sz, GFP_KERNEL);
+	if (!query_ctx) {
+		err =3D -ENOMEM;
+		goto out;
+	}
+
+	err =3D mlx5_vport_get_other_func_cap(esw->dev, vport_num, query_ctx);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed getting HCA caps");
+		goto out_free;
+	}
+
+	hca_caps =3D MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	MLX5_SET(cmd_hca_cap, hca_caps, roce, enable);
+
+	err =3D mlx5_vport_set_other_func_cap(esw->dev, hca_caps, vport_num);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed setting HCA roce cap");
+		goto out_free;
+	}
+
+	vport->info.roce_enabled =3D enable;
+
+out_free:
+	kfree(query_ctx);
+out:
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index 479d2ac2cd85..0e7ad84e7b45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -122,8 +122,9 @@ struct mlx5_vport_info {
 	int                     link_state;
 	u32                     min_rate;
 	u32                     max_rate;
-	bool                    spoofchk;
-	bool                    trusted;
+	u8                      spoofchk: 1;
+	u8                      trusted: 1;
+	u8                      roce_enabled: 1;
 };
=20
 /* Vport context events */
@@ -436,7 +437,10 @@ int mlx5_devlink_port_function_hw_addr_set(struct devl=
ink *devlink,
 					   struct devlink_port *port,
 					   const u8 *hw_addr, int hw_addr_len,
 					   struct netlink_ext_ack *extack);
-
+int mlx5_devlink_port_function_roce_get(struct devlink *devlink, struct de=
vlink_port *port,
+					bool *is_enabled, struct netlink_ext_ack *extack);
+int mlx5_devlink_port_function_roce_set(struct devlink *devlink, struct de=
vlink_port *port,
+					bool enable, struct netlink_ext_ack *extack);
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
=20
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/=
net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 3754ef98554f..de45a4b54934 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -259,6 +259,8 @@ enum {
=20
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev);
 void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_=
id, void *out);
+int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *h=
ca_cap, u16 function_id);
=20
 static inline bool mlx5_core_is_sf(const struct mlx5_core_dev *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/=
ethernet/mellanox/mlx5/core/vport.c
index ba78e0660523..a822a25b18af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1164,3 +1164,38 @@ u16 mlx5_eswitch_get_total_vports(const struct mlx5_=
core_dev *dev)
 	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev) + mlx5_sf_max_fu=
nctions(dev);
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_get_total_vports);
+
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_=
id, void *out)
+{
+	u16 opmod =3D (MLX5_CAP_GENERAL << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
+	u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)] =3D {};
+
+	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
+	MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
+	MLX5_SET(query_hca_cap_in, in, function_id, function_id);
+	MLX5_SET(query_hca_cap_in, in, other_function, true);
+	return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
+}
+
+int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *h=
ca_cap, u16 function_id)
+{
+	int set_sz =3D MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	void *set_hca_cap;
+	void *set_ctx;
+	int ret;
+
+	set_ctx =3D kzalloc(set_sz, GFP_KERNEL);
+	if (!set_ctx)
+		return -ENOMEM;
+
+	MLX5_SET(set_hca_cap_in, set_ctx, opcode, MLX5_CMD_OP_SET_HCA_CAP);
+	MLX5_SET(set_hca_cap_in, set_ctx, op_mod, MLX5_SET_HCA_CAP_OP_MOD_GENERAL=
_DEVICE << 1);
+	set_hca_cap =3D MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
+	memcpy(set_hca_cap, hca_cap, MLX5_ST_SZ_BYTES(cmd_hca_cap));
+	MLX5_SET(set_hca_cap_in, set_ctx, function_id, function_id);
+	MLX5_SET(set_hca_cap_in, set_ctx, other_function, true);
+	ret =3D mlx5_cmd_exec_in(dev, set_hca_cap, set_ctx);
+
+	kfree(set_ctx);
+	return ret;
+}
--=20
2.18.1

