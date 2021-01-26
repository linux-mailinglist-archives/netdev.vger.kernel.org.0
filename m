Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333E9305527
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhA0IAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 03:00:21 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2460 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317153AbhAZX1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:27:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4be0001>; Tue, 26 Jan 2021 15:24:46 -0800
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
Subject: [net-next 09/14] net/mlx5e: Add flow steering DMAC trap rule
Date:   Tue, 26 Jan 2021 15:24:14 -0800
Message-ID: <20210126232419.175836-10-saeedm@nvidia.com>
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
        t=1611703486; bh=afSovO6ngo6FDTRQ6vNlacjcVrDihpV02exteGms4Zk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=gMfwuBgj5kTqqaiOzkSma1XWrHW0b1h/NfknxJ8feOLLe+CuThz7EXTvOHyq1j4X+
         47VsQImEu457QjZN9g/eyj4Qvim38hUaFXo0aB0Jhm91KybEiAkwDoWBFx9hTeU7IX
         q1/0OmPHbTzkH3k9D1vfBZyUVReGpTSFrdxzllHLTEBF6GmIM6jpNgve+z8gHdSocB
         UGqXLHzKEC704uHf8kfKaMT10zzATo1M4LNekpC5UqtAj4TEpzsspGk1mPyWnrDHil
         +KskcDIM+cPy00JUeuYUbjLn5/FQBa3fAwAdQStWPIkijVfhRqBf3+DlmQH+4jiMXV
         k9UZKC2wzZVUw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add flow group to the L2 table to hold the catch-all DMAC rule. Add API
which adds/removes DMAC trap rule. This rule catches packets that were
destined to be dropped due to no-match with previous DMAC rules. The
trap rule steer these packets to the trap tir related to the trap-RQ.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  3 ++
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 42 ++++++++++++++++++-
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index 688183a03e23..a16297e7e2ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -68,6 +68,7 @@ struct mlx5e_l2_table {
 	struct hlist_head          netdev_mc[MLX5E_L2_ADDR_HASH_SIZE];
 	struct mlx5e_l2_rule	   broadcast;
 	struct mlx5e_l2_rule	   allmulti;
+	struct mlx5_flow_handle    *trap_rule;
 	bool                       broadcast_enabled;
 	bool                       allmulti_enabled;
 	bool                       promisc_enabled;
@@ -297,6 +298,8 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *pri=
v);
 u8 mlx5e_get_proto_by_tunnel_type(enum mlx5e_tunnel_types tt);
 int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num=
);
 void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv);
+int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num)=
;
+void mlx5e_remove_mac_trap(struct mlx5e_priv *priv);
=20
 #endif /* __MLX5E_FLOW_STEER_H__ */
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_fs.c
index b7637a2ffd12..16ce7756ac43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -352,6 +352,32 @@ void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv)
 	}
 }
=20
+int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
+{
+	struct mlx5_flow_table *ft =3D priv->fs.l2.ft.t;
+	struct mlx5_flow_handle *rule;
+	int err;
+
+	rule =3D mlx5e_add_trap_rule(ft, trap_id, tir_num);
+	if (IS_ERR(rule)) {
+		err =3D PTR_ERR(rule);
+		priv->fs.l2.trap_rule =3D NULL;
+		netdev_err(priv->netdev, "%s: add MAC trap rule failed, err %d\n",
+			   __func__, err);
+		return err;
+	}
+	priv->fs.l2.trap_rule =3D rule;
+	return 0;
+}
+
+void mlx5e_remove_mac_trap(struct mlx5e_priv *priv)
+{
+	if (priv->fs.l2.trap_rule) {
+		mlx5_del_flow_rules(priv->fs.l2.trap_rule);
+		priv->fs.l2.trap_rule =3D NULL;
+	}
+}
+
 void mlx5e_enable_cvlan_filter(struct mlx5e_priv *priv)
 {
 	if (!priv->fs.vlan.cvlan_filter_disabled)
@@ -1444,11 +1470,13 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_priv=
 *priv,
 	return err;
 }
=20
-#define MLX5E_NUM_L2_GROUPS	   2
+#define MLX5E_NUM_L2_GROUPS	   3
 #define MLX5E_L2_GROUP1_SIZE	   BIT(15)
 #define MLX5E_L2_GROUP2_SIZE	   BIT(0)
+#define MLX5E_L2_GROUP_TRAP_SIZE   BIT(0) /* must be last */
 #define MLX5E_L2_TABLE_SIZE	   (MLX5E_L2_GROUP1_SIZE +\
-				    MLX5E_L2_GROUP2_SIZE)
+				    MLX5E_L2_GROUP2_SIZE +\
+				    MLX5E_L2_GROUP_TRAP_SIZE)
 static int mlx5e_create_l2_table_groups(struct mlx5e_l2_table *l2_table)
 {
 	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
@@ -1493,6 +1521,16 @@ static int mlx5e_create_l2_table_groups(struct mlx5e=
_l2_table *l2_table)
 		goto err_destroy_groups;
 	ft->num_groups++;
=20
+	/* Flow Group for l2 traps */
+	memset(in, 0, inlen);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix +=3D MLX5E_L2_GROUP_TRAP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	ft->g[ft->num_groups] =3D mlx5_create_flow_group(ft->t, in);
+	if (IS_ERR(ft->g[ft->num_groups]))
+		goto err_destroy_groups;
+	ft->num_groups++;
+
 	kvfree(in);
 	return 0;
=20
--=20
2.29.2

