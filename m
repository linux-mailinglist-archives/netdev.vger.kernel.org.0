Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E7B3050D0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbhA0E1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:27:47 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2362 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388690AbhAZXZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:25:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4be0000>; Tue, 26 Jan 2021 15:24:46 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:45 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/14] net/mlx5e: Add flow steering VLAN trap rule
Date:   Tue, 26 Jan 2021 15:24:13 -0800
Message-ID: <20210126232419.175836-9-saeedm@nvidia.com>
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
        t=1611703486; bh=mMo+NaZT75a6wXHtqn4tWC13qZe8iJXoeYsIiXTlOOw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=UvXmQEX0jNXwftQ41ane9XLNYsx6SY7xOg19YiGLRdFCD06t2lwydrqkWqeFS2+MT
         Aqn8EFjvcVkRq2TIZ3bdOleTYdsg8YS/foSYQvlCtdo7mPIGLCeEWI49v2zy94WYQa
         aOiDCi+eE9+SFC5calvfigGXfp/XFpYS2iPy+DFcqAlNTwOA+nUcX18YDHV558Z6Cl
         OOrYE8AiRg64eHJJt+OdbpP7rmAAay058JK+vwqTcB97fxnvN/g4I9S0deW/6Xm7qV
         ZiBWhngoV9yJw32sbdt2fgNkXEtzLCNCYUWT2kWaC+haAxqfywvEWKDzOiibfbu5QF
         Y2TJ9lD5otoSQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add flow group to the VLAN table to hold the catch-all VLAN rule. Add
API which adds/removes VLAN trap rule. This rule catches packets that
were destined to be dropped due to no-match with previous VLAN rules.
The trap rule steer these packets to the trap tir related to the
trap-RQ.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  3 +
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 64 ++++++++++++++++++-
 2 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index abe57f032b2d..688183a03e23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -58,6 +58,7 @@ struct mlx5e_vlan_table {
 	struct mlx5_flow_handle	*untagged_rule;
 	struct mlx5_flow_handle	*any_cvlan_rule;
 	struct mlx5_flow_handle	*any_svlan_rule;
+	struct mlx5_flow_handle	*trap_rule;
 	bool			cvlan_filter_disabled;
 };
=20
@@ -294,6 +295,8 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)=
;
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv);
=20
 u8 mlx5e_get_proto_by_tunnel_type(enum mlx5e_tunnel_types tt);
+int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num=
);
+void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv);
=20
 #endif /* __MLX5E_FLOW_STEER_H__ */
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_fs.c
index a2db550c982e..b7637a2ffd12 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -305,6 +305,53 @@ static int mlx5e_add_any_vid_rules(struct mlx5e_priv *=
priv)
 	return mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_ANY_STAG_VID, 0);
 }
=20
+static struct mlx5_flow_handle *
+mlx5e_add_trap_rule(struct mlx5_flow_table *ft, int trap_id, int tir_num)
+{
+	struct mlx5_flow_destination dest =3D {};
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+
+	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return ERR_PTR(-ENOMEM);
+	spec->flow_context.flags |=3D FLOW_CONTEXT_HAS_TAG;
+	spec->flow_context.flow_tag =3D trap_id;
+	dest.type =3D MLX5_FLOW_DESTINATION_TYPE_TIR;
+	dest.tir_num =3D tir_num;
+
+	rule =3D mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
+	kvfree(spec);
+	return rule;
+}
+
+int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
+{
+	struct mlx5_flow_table *ft =3D priv->fs.vlan.ft.t;
+	struct mlx5_flow_handle *rule;
+	int err;
+
+	rule =3D mlx5e_add_trap_rule(ft, trap_id, tir_num);
+	if (IS_ERR(rule)) {
+		err =3D PTR_ERR(rule);
+		priv->fs.vlan.trap_rule =3D NULL;
+		netdev_err(priv->netdev, "%s: add VLAN trap rule failed, err %d\n",
+			   __func__, err);
+		return err;
+	}
+	priv->fs.vlan.trap_rule =3D rule;
+	return 0;
+}
+
+void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv)
+{
+	if (priv->fs.vlan.trap_rule) {
+		mlx5_del_flow_rules(priv->fs.vlan.trap_rule);
+		priv->fs.vlan.trap_rule =3D NULL;
+	}
+}
+
 void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv)
 {
 	if (!priv->fs.vlan.cvlan_filter_disabled)
@@ -418,6 +465,8 @@ static void mlx5e_del_vlan_rules(struct mlx5e_priv *pri=
v)
=20
 	WARN_ON_ONCE(!(test_bit(MLX5E_STATE_DESTROYING, &priv->state)));
=20
+	mlx5e_remove_vlan_trap(priv);
+
 	/* must be called after DESTROY bit is set and
 	 * set_rx_mode is called and flushed
 	 */
@@ -1495,15 +1544,17 @@ static int mlx5e_create_l2_table(struct mlx5e_priv =
*priv)
 	return err;
 }
=20
-#define MLX5E_NUM_VLAN_GROUPS	4
+#define MLX5E_NUM_VLAN_GROUPS	5
 #define MLX5E_VLAN_GROUP0_SIZE	BIT(12)
 #define MLX5E_VLAN_GROUP1_SIZE	BIT(12)
 #define MLX5E_VLAN_GROUP2_SIZE	BIT(1)
 #define MLX5E_VLAN_GROUP3_SIZE	BIT(0)
+#define MLX5E_VLAN_GROUP_TRAP_SIZE BIT(0) /* must be last */
 #define MLX5E_VLAN_TABLE_SIZE	(MLX5E_VLAN_GROUP0_SIZE +\
 				 MLX5E_VLAN_GROUP1_SIZE +\
 				 MLX5E_VLAN_GROUP2_SIZE +\
-				 MLX5E_VLAN_GROUP3_SIZE)
+				 MLX5E_VLAN_GROUP3_SIZE +\
+				 MLX5E_VLAN_GROUP_TRAP_SIZE)
=20
 static int __mlx5e_create_vlan_table_groups(struct mlx5e_flow_table *ft, u=
32 *in,
 					    int inlen)
@@ -1558,6 +1609,15 @@ static int __mlx5e_create_vlan_table_groups(struct m=
lx5e_flow_table *ft, u32 *in
 		goto err_destroy_groups;
 	ft->num_groups++;
=20
+	memset(in, 0, inlen);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix +=3D MLX5E_VLAN_GROUP_TRAP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] =3D mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err_destroy_groups;
+	ft->num_groups++;
+
 	return 0;
=20
 err_destroy_groups:
--=20
2.29.2

