Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9FB2BB99B
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgKTXEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:16 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11715 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgKTXEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b7b0000>; Fri, 20 Nov 2020 15:04:27 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:04:05 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH mlx5-next 16/16] net/mlx5: Treat host PF vport as other (non eswitch manager) vport
Date:   Fri, 20 Nov 2020 15:03:39 -0800
Message-ID: <20201120230339.651609-17-saeedm@nvidia.com>
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
        t=1605913467; bh=qcChP+urou3WBJOXWLXsm0s8RnO6f09LtzPnBDy4FSA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=OT0BGnJ/jTikIaVXATzUn22uM6jrPTcGie0BpDDHOJq/TUSQIV0hnFWCMHXNZoTCk
         elOcWU/YskJ9wVR/+foPU4YCyLWoetVr2xguBCzT4Izm+NX0spZhrB0TnLZ6bSO4W+
         jONrq4PfvhRJ06p/WHrSugaeNb3bhgpiVxZ848mKyfhdPR3E5fgWdloJMGmqc4z348
         UGZSjxUQ94TBkvuzoUcKqpd0P33semkn8OsnNv6URR3mNDQMR98DRfQMtBk4O/TvXH
         qFHYw3OBUFsaRfhAuCM4WCQSAa1chRHy3pIqJIarEeiAxTRMUXEzif1NFLnG3Xku+Y
         3Tp/X2BE9r5Cg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

When eswitch manager is running on ECPF, host PF should be treated
as non eswitch manager port, similar to other VF vports.
Fail to do so, results in firmware treating PF's vport as ECPF
vport for eswitch ACL tables.
Non zero check to figure out if a given vport is other vport or not
is not sufficient becase PF vport number =3D 0 on ECPF.
Hence, create esw acl tables with an attribute of other vport.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/helper.c       |  5 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 54 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 14 ++---
 include/linux/mlx5/fs.h                       |  5 +-
 4 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
index 22f4c1c28006..4a369669e51e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
@@ -8,6 +8,7 @@
 struct mlx5_flow_table *
 esw_acl_table_create(struct mlx5_eswitch *esw, u16 vport_num, int ns, int =
size)
 {
+	struct mlx5_flow_table_attr ft_attr =3D {};
 	struct mlx5_core_dev *dev =3D esw->dev;
 	struct mlx5_flow_namespace *root_ns;
 	struct mlx5_flow_table *acl;
@@ -33,7 +34,9 @@ esw_acl_table_create(struct mlx5_eswitch *esw, u16 vport_=
num, int ns, int size)
 		return ERR_PTR(-EOPNOTSUPP);
 	}
=20
-	acl =3D mlx5_create_vport_flow_table(root_ns, 0, size, 0, vport_num);
+	ft_attr.max_fte =3D size;
+	ft_attr.flags =3D MLX5_FLOW_TABLE_OTHER_VPORT;
+	acl =3D mlx5_create_vport_flow_table(root_ns, &ft_attr, vport_num);
 	if (IS_ERR(acl)) {
 		err =3D PTR_ERR(acl);
 		esw_warn(dev, "vport[%d] create %s ACL table, err(%d)\n", vport_num,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.c
index c2fed9c3d75c..8e06731d3cb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -172,10 +172,9 @@ static int mlx5_cmd_update_root_ft(struct mlx5_flow_ro=
ot_namespace *ns,
 		MLX5_SET(set_flow_table_root_in, in, table_id, ft->id);
=20
 	MLX5_SET(set_flow_table_root_in, in, underlay_qpn, underlay_qpn);
-	if (ft->vport) {
-		MLX5_SET(set_flow_table_root_in, in, vport_number, ft->vport);
-		MLX5_SET(set_flow_table_root_in, in, other_vport, 1);
-	}
+	MLX5_SET(set_flow_table_root_in, in, vport_number, ft->vport);
+	MLX5_SET(set_flow_table_root_in, in, other_vport,
+		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
=20
 	return mlx5_cmd_exec_in(dev, set_flow_table_root, in);
 }
@@ -199,10 +198,9 @@ static int mlx5_cmd_create_flow_table(struct mlx5_flow=
_root_namespace *ns,
 	MLX5_SET(create_flow_table_in, in, table_type, ft->type);
 	MLX5_SET(create_flow_table_in, in, flow_table_context.level, ft->level);
 	MLX5_SET(create_flow_table_in, in, flow_table_context.log_size, log_size)=
;
-	if (ft->vport) {
-		MLX5_SET(create_flow_table_in, in, vport_number, ft->vport);
-		MLX5_SET(create_flow_table_in, in, other_vport, 1);
-	}
+	MLX5_SET(create_flow_table_in, in, vport_number, ft->vport);
+	MLX5_SET(create_flow_table_in, in, other_vport,
+		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
=20
 	MLX5_SET(create_flow_table_in, in, flow_table_context.decap_en,
 		 en_decap);
@@ -252,10 +250,9 @@ static int mlx5_cmd_destroy_flow_table(struct mlx5_flo=
w_root_namespace *ns,
 		 MLX5_CMD_OP_DESTROY_FLOW_TABLE);
 	MLX5_SET(destroy_flow_table_in, in, table_type, ft->type);
 	MLX5_SET(destroy_flow_table_in, in, table_id, ft->id);
-	if (ft->vport) {
-		MLX5_SET(destroy_flow_table_in, in, vport_number, ft->vport);
-		MLX5_SET(destroy_flow_table_in, in, other_vport, 1);
-	}
+	MLX5_SET(destroy_flow_table_in, in, vport_number, ft->vport);
+	MLX5_SET(destroy_flow_table_in, in, other_vport,
+		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
=20
 	return mlx5_cmd_exec_in(dev, destroy_flow_table, in);
 }
@@ -283,11 +280,9 @@ static int mlx5_cmd_modify_flow_table(struct mlx5_flow=
_root_namespace *ns,
 				 flow_table_context.lag_master_next_table_id, 0);
 		}
 	} else {
-		if (ft->vport) {
-			MLX5_SET(modify_flow_table_in, in, vport_number,
-				 ft->vport);
-			MLX5_SET(modify_flow_table_in, in, other_vport, 1);
-		}
+		MLX5_SET(modify_flow_table_in, in, vport_number, ft->vport);
+		MLX5_SET(modify_flow_table_in, in, other_vport,
+			 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
 		MLX5_SET(modify_flow_table_in, in, modify_field_select,
 			 MLX5_MODIFY_FLOW_TABLE_MISS_TABLE_ID);
 		if (next_ft) {
@@ -325,6 +320,9 @@ static int mlx5_cmd_create_flow_group(struct mlx5_flow_=
root_namespace *ns,
 		MLX5_SET(create_flow_group_in, in, other_vport, 1);
 	}
=20
+	MLX5_SET(create_flow_group_in, in, vport_number, ft->vport);
+	MLX5_SET(create_flow_group_in, in, other_vport,
+		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
 	err =3D mlx5_cmd_exec_inout(dev, create_flow_group, in, out);
 	if (!err)
 		fg->id =3D MLX5_GET(create_flow_group_out, out,
@@ -344,11 +342,9 @@ static int mlx5_cmd_destroy_flow_group(struct mlx5_flo=
w_root_namespace *ns,
 	MLX5_SET(destroy_flow_group_in, in, table_type, ft->type);
 	MLX5_SET(destroy_flow_group_in, in, table_id, ft->id);
 	MLX5_SET(destroy_flow_group_in, in, group_id, fg->id);
-	if (ft->vport) {
-		MLX5_SET(destroy_flow_group_in, in, vport_number, ft->vport);
-		MLX5_SET(destroy_flow_group_in, in, other_vport, 1);
-	}
-
+	MLX5_SET(destroy_flow_group_in, in, vport_number, ft->vport);
+	MLX5_SET(destroy_flow_group_in, in, other_vport,
+		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
 	return mlx5_cmd_exec_in(dev, destroy_flow_group, in);
 }
=20
@@ -427,10 +423,9 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 	MLX5_SET(set_fte_in, in, ignore_flow_level,
 		 !!(fte->action.flags & FLOW_ACT_IGNORE_FLOW_LEVEL));
=20
-	if (ft->vport) {
-		MLX5_SET(set_fte_in, in, vport_number, ft->vport);
-		MLX5_SET(set_fte_in, in, other_vport, 1);
-	}
+	MLX5_SET(set_fte_in, in, vport_number, ft->vport);
+	MLX5_SET(set_fte_in, in, other_vport,
+		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
=20
 	in_flow_context =3D MLX5_ADDR_OF(set_fte_in, in, flow_context);
 	MLX5_SET(flow_context, in_flow_context, group_id, group_id);
@@ -604,10 +599,9 @@ static int mlx5_cmd_delete_fte(struct mlx5_flow_root_n=
amespace *ns,
 	MLX5_SET(delete_fte_in, in, table_type, ft->type);
 	MLX5_SET(delete_fte_in, in, table_id, ft->id);
 	MLX5_SET(delete_fte_in, in, flow_index, fte->index);
-	if (ft->vport) {
-		MLX5_SET(delete_fte_in, in, vport_number, ft->vport);
-		MLX5_SET(delete_fte_in, in, other_vport, 1);
-	}
+	MLX5_SET(delete_fte_in, in, vport_number, ft->vport);
+	MLX5_SET(delete_fte_in, in, other_vport,
+		 !!(ft->flags & MLX5_FLOW_TABLE_OTHER_VPORT));
=20
 	return mlx5_cmd_exec_in(dev, delete_fte, in);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 9feab81ab919..761581232139 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1155,17 +1155,11 @@ struct mlx5_flow_table *mlx5_create_flow_table(stru=
ct mlx5_flow_namespace *ns,
 }
 EXPORT_SYMBOL(mlx5_create_flow_table);
=20
-struct mlx5_flow_table *mlx5_create_vport_flow_table(struct mlx5_flow_name=
space *ns,
-						     int prio, int max_fte,
-						     u32 level, u16 vport)
+struct mlx5_flow_table *
+mlx5_create_vport_flow_table(struct mlx5_flow_namespace *ns,
+			     struct mlx5_flow_table_attr *ft_attr, u16 vport)
 {
-	struct mlx5_flow_table_attr ft_attr =3D {};
-
-	ft_attr.max_fte =3D max_fte;
-	ft_attr.level   =3D level;
-	ft_attr.prio    =3D prio;
-
-	return __mlx5_create_flow_table(ns, &ft_attr, FS_FT_OP_MOD_NORMAL, vport)=
;
+	return __mlx5_create_flow_table(ns, ft_attr, FS_FT_OP_MOD_NORMAL, vport);
 }
=20
 struct mlx5_flow_table*
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 97176d623d74..12d84e99ff63 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -50,6 +50,7 @@ enum {
 	MLX5_FLOW_TABLE_TUNNEL_EN_DECAP =3D BIT(1),
 	MLX5_FLOW_TABLE_TERMINATION =3D BIT(2),
 	MLX5_FLOW_TABLE_UNMANAGED =3D BIT(3),
+	MLX5_FLOW_TABLE_OTHER_VPORT =3D BIT(4),
 };
=20
 #define LEFTOVERS_RULE_NUM	 2
@@ -175,9 +176,7 @@ mlx5_create_auto_grouped_flow_table(struct mlx5_flow_na=
mespace *ns,
=20
 struct mlx5_flow_table *
 mlx5_create_vport_flow_table(struct mlx5_flow_namespace *ns,
-			     int prio,
-			     int num_flow_table_entries,
-			     u32 level, u16 vport);
+			     struct mlx5_flow_table_attr *ft_attr, u16 vport);
 struct mlx5_flow_table *mlx5_create_lag_demux_flow_table(
 					       struct mlx5_flow_namespace *ns,
 					       int prio, u32 level);
--=20
2.26.2

