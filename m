Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762D430518D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbhA0E0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:26:06 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8208 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388675AbhAZXZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:25:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4ba0000>; Tue, 26 Jan 2021 15:24:42 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:41 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/14] net/mlx5: Register to devlink ingress VLAN filter trap
Date:   Tue, 26 Jan 2021 15:24:08 -0800
Message-ID: <20210126232419.175836-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126232419.175836-1-saeedm@nvidia.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611703482; bh=cO0kuiN6SXqMCgVrVGtKqMy/UUGmkBPBunUOPfKY7zQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=BX+XScYhdldohYAnkJXXKwtQ58YPNz/mMA0jrcSUF0kgaHchjFNdqRDuF0Pa3lGyf
         ePf61z/6xQdQSfQ4LT1bNL3yYXR5VuTrDuSDf9e4q4XHGIbTR13z5NPdr1B6OmmPgU
         K2lc0MRg0Kr+wQK5C6Bcynse6HrcOQlKlcvWdS7n7icQ9nNMFa6FwuSI4LkxpTttOx
         Ag4OtOs8L5zqR8UhdEZC5dbfCXGsjVnuZOo9dv85L2obj7ki7AK52oomRyvtFwoDCj
         uHVgOQNhWQanc3QDMpvYVd1Z7FBLLF50nj0e8wmBNNXA8lnaC9YANPWOYaYx4mC4Lz
         GN/9ZwrXGYoRA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add traps registration to mlx5_core devlink register/unregister flow.
This patch registers INGRESS_VLAN_FILTER trap.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index f04afaf785cb..8c2f886ac78e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -442,6 +442,48 @@ static void mlx5_devlink_set_params_init_values(struct=
 devlink *devlink)
 #endif
 }
=20
+#define MLX5_TRAP_DROP(_id, _group_id)					\
+	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
+			     DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT)
+
+static const struct devlink_trap mlx5_traps_arr[] =3D {
+	MLX5_TRAP_DROP(INGRESS_VLAN_FILTER, L2_DROPS),
+};
+
+static const struct devlink_trap_group mlx5_trap_groups_arr[] =3D {
+	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
+};
+
+static int mlx5_devlink_traps_register(struct devlink *devlink)
+{
+	struct mlx5_core_dev *core_dev =3D devlink_priv(devlink);
+	int err;
+
+	err =3D devlink_trap_groups_register(devlink, mlx5_trap_groups_arr,
+					   ARRAY_SIZE(mlx5_trap_groups_arr));
+	if (err)
+		return err;
+
+	err =3D devlink_traps_register(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_t=
raps_arr),
+				     &core_dev->priv);
+	if (err)
+		goto err_trap_group;
+	return 0;
+
+err_trap_group:
+	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
+				       ARRAY_SIZE(mlx5_trap_groups_arr));
+	return err;
+}
+
+static void mlx5_devlink_traps_unregister(struct devlink *devlink)
+{
+	devlink_traps_unregister(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_a=
rr));
+	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
+				       ARRAY_SIZE(mlx5_trap_groups_arr));
+}
+
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
 {
 	int err;
@@ -456,8 +498,16 @@ int mlx5_devlink_register(struct devlink *devlink, str=
uct device *dev)
 		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 	devlink_params_publish(devlink);
+
+	err =3D mlx5_devlink_traps_register(devlink);
+	if (err)
+		goto traps_reg_err;
+
 	return 0;
=20
+traps_reg_err:
+	devlink_params_unregister(devlink, mlx5_devlink_params,
+				  ARRAY_SIZE(mlx5_devlink_params));
 params_reg_err:
 	devlink_unregister(devlink);
 	return err;
@@ -465,6 +515,7 @@ int mlx5_devlink_register(struct devlink *devlink, stru=
ct device *dev)
=20
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	mlx5_devlink_traps_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
--=20
2.29.2

