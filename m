Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BA730552E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 09:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbhA0ICX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 03:02:23 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8250 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317149AbhAZX0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:26:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4bd0000>; Tue, 26 Jan 2021 15:24:45 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:44 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/14] net/mlx5e: Optimize promiscuous mode
Date:   Tue, 26 Jan 2021 15:24:12 -0800
Message-ID: <20210126232419.175836-8-saeedm@nvidia.com>
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
        t=1611703485; bh=L+bYj6Dqy0YD9Jk5dst/60gsFy7xcGVBxw/2GlZ6f/0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=VIL/e4CfiGl/xND8rWqzhg99RD9gylWaagB97//2LJTDaodj+CTZuwSODSYNLrCOk
         6JJDce0b+oJLDzMr8iCC+kIDMUcaDmLFE5PKw6SMTdJA8rcylcdCa8+f/GXpDWRi+L
         S3WhJtQNaZ4/4vpZ9E6/092hl84vIVGoygt2aojn7iNBHszRJN50Z5mtUbIlQk5dL7
         LI+ycPtwmkqMr/lsBqT6Usn2iU0QneZmKbUwVqAnuiUxe/ZNFYWyVC1vPG2XyNwLyi
         6/YNtKLmED+6MKXC33LGoFMIr1ED1Q7tzCic59D1ZvJiyZ5FXJI8kkqEzpzFwEoLbu
         XG9SAzUwrTtNw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Change steering flow to optimize traffic in promiscuous mode. On demand,
add a high priority table containing a catch-all rule. All incoming
packets are caught by this rule and steered directly to the TTC table.
Prior to this change, packets in promiscuous mode may suffer from up to
4 steering hops before reaching TTC table.
In addition, this patch will allow us adding a catch-all rule at the end
of MAC table to serve MAC trap, with no impact on promiscuous mode
performance.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 120 +++++++++++++-----
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   4 +-
 3 files changed, 100 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index 5749557749b0..abe57f032b2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -44,6 +44,11 @@ struct mlx5e_l2_rule {
=20
 #define MLX5E_L2_ADDR_HASH_SIZE BIT(BITS_PER_BYTE)
=20
+struct mlx5e_promisc_table {
+	struct mlx5e_flow_table	ft;
+	struct mlx5_flow_handle	*rule;
+};
+
 struct mlx5e_vlan_table {
 	struct mlx5e_flow_table		ft;
 	DECLARE_BITMAP(active_cvlans, VLAN_N_VID);
@@ -62,7 +67,6 @@ struct mlx5e_l2_table {
 	struct hlist_head          netdev_mc[MLX5E_L2_ADDR_HASH_SIZE];
 	struct mlx5e_l2_rule	   broadcast;
 	struct mlx5e_l2_rule	   allmulti;
-	struct mlx5e_l2_rule	   promisc;
 	bool                       broadcast_enabled;
 	bool                       allmulti_enabled;
 	bool                       promisc_enabled;
@@ -126,7 +130,8 @@ struct mlx5e_ttc_table {
=20
 /* NIC prio FTS */
 enum {
-	MLX5E_VLAN_FT_LEVEL =3D 0,
+	MLX5E_PROMISC_FT_LEVEL,
+	MLX5E_VLAN_FT_LEVEL,
 	MLX5E_L2_FT_LEVEL,
 	MLX5E_TTC_FT_LEVEL,
 	MLX5E_INNER_TTC_FT_LEVEL,
@@ -241,6 +246,7 @@ struct mlx5e_flow_steering {
 	struct mlx5e_ethtool_steering   ethtool;
 #endif
 	struct mlx5e_tc_table           tc;
+	struct mlx5e_promisc_table      promisc;
 	struct mlx5e_vlan_table         vlan;
 	struct mlx5e_l2_table           l2;
 	struct mlx5e_ttc_table          ttc;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_fs.c
index e02e5895703d..a2db550c982e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -46,7 +46,6 @@ static void mlx5e_del_l2_flow_rule(struct mlx5e_priv *pri=
v,
 enum {
 	MLX5E_FULLMATCH =3D 0,
 	MLX5E_ALLMULTI  =3D 1,
-	MLX5E_PROMISC   =3D 2,
 };
=20
 enum {
@@ -596,6 +595,83 @@ static void mlx5e_handle_netdev_addr(struct mlx5e_priv=
 *priv)
 	mlx5e_apply_netdev_addr(priv);
 }
=20
+#define MLX5E_PROMISC_GROUP0_SIZE BIT(0)
+#define MLX5E_PROMISC_TABLE_SIZE MLX5E_PROMISC_GROUP0_SIZE
+
+static int mlx5e_add_promisc_rule(struct mlx5e_priv *priv)
+{
+	struct mlx5_flow_table *ft =3D priv->fs.promisc.ft.t;
+	struct mlx5_flow_destination dest =3D {};
+	struct mlx5_flow_handle **rule_p;
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_spec *spec;
+	int err =3D 0;
+
+	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+	dest.type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft =3D priv->fs.ttc.ft.t;
+
+	rule_p =3D &priv->fs.promisc.rule;
+	*rule_p =3D mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
+	if (IS_ERR(*rule_p)) {
+		err =3D PTR_ERR(*rule_p);
+		*rule_p =3D NULL;
+		netdev_err(priv->netdev, "%s: add promiscuous rule failed\n", __func__);
+	}
+	kvfree(spec);
+	return err;
+}
+
+static int mlx5e_create_promisc_table(struct mlx5e_priv *priv)
+{
+	struct mlx5e_flow_table *ft =3D &priv->fs.promisc.ft;
+	struct mlx5_flow_table_attr ft_attr =3D {};
+	int err;
+
+	ft_attr.max_fte =3D MLX5E_PROMISC_TABLE_SIZE;
+	ft_attr.autogroup.max_num_groups =3D 1;
+	ft_attr.level =3D MLX5E_PROMISC_FT_LEVEL;
+	ft_attr.prio =3D MLX5E_NIC_PRIO;
+
+	ft->t =3D mlx5_create_auto_grouped_flow_table(priv->fs.ns, &ft_attr);
+	if (IS_ERR(ft->t)) {
+		err =3D PTR_ERR(ft->t);
+		netdev_err(priv->netdev, "fail to create promisc table err=3D%d\n", err)=
;
+		return err;
+	}
+
+	err =3D mlx5e_add_promisc_rule(priv);
+	if (err)
+		goto err_destroy_promisc_table;
+
+	return 0;
+
+err_destroy_promisc_table:
+	mlx5_destroy_flow_table(ft->t);
+	ft->t =3D NULL;
+
+	return err;
+}
+
+static void mlx5e_del_promisc_rule(struct mlx5e_priv *priv)
+{
+	if (WARN(!priv->fs.promisc.rule, "Trying to remove non-existing promiscuo=
us rule"))
+		return;
+	mlx5_del_flow_rules(priv->fs.promisc.rule);
+	priv->fs.promisc.rule =3D NULL;
+}
+
+static void mlx5e_destroy_promisc_table(struct mlx5e_priv *priv)
+{
+	if (WARN(!priv->fs.promisc.ft.t, "Trying to remove non-existing promiscuo=
us table"))
+		return;
+	mlx5e_del_promisc_rule(priv);
+	mlx5_destroy_flow_table(priv->fs.promisc.ft.t);
+	priv->fs.promisc.ft.t =3D NULL;
+}
+
 void mlx5e_set_rx_mode_work(struct work_struct *work)
 {
 	struct mlx5e_priv *priv =3D container_of(work, struct mlx5e_priv,
@@ -615,14 +691,15 @@ void mlx5e_set_rx_mode_work(struct work_struct *work)
 	bool disable_allmulti  =3D  ea->allmulti_enabled  && !allmulti_enabled;
 	bool enable_broadcast  =3D !ea->broadcast_enabled &&  broadcast_enabled;
 	bool disable_broadcast =3D  ea->broadcast_enabled && !broadcast_enabled;
+	int err;
=20
 	if (enable_promisc) {
-		if (!priv->channels.params.vlan_strip_disable)
+		err =3D mlx5e_create_promisc_table(priv);
+		if (err)
+			enable_promisc =3D false;
+		if (!priv->channels.params.vlan_strip_disable && !err)
 			netdev_warn_once(ndev,
 					 "S-tagged traffic will be dropped while C-tag vlan stripping is enab=
led\n");
-		mlx5e_add_l2_flow_rule(priv, &ea->promisc, MLX5E_PROMISC);
-		if (!priv->fs.vlan.cvlan_filter_disabled)
-			mlx5e_add_any_vid_rules(priv);
 	}
 	if (enable_allmulti)
 		mlx5e_add_l2_flow_rule(priv, &ea->allmulti, MLX5E_ALLMULTI);
@@ -635,11 +712,8 @@ void mlx5e_set_rx_mode_work(struct work_struct *work)
 		mlx5e_del_l2_flow_rule(priv, &ea->broadcast);
 	if (disable_allmulti)
 		mlx5e_del_l2_flow_rule(priv, &ea->allmulti);
-	if (disable_promisc) {
-		if (!priv->fs.vlan.cvlan_filter_disabled)
-			mlx5e_del_any_vid_rules(priv);
-		mlx5e_del_l2_flow_rule(priv, &ea->promisc);
-	}
+	if (disable_promisc)
+		mlx5e_destroy_promisc_table(priv);
=20
 	ea->promisc_enabled   =3D promisc_enabled;
 	ea->allmulti_enabled  =3D allmulti_enabled;
@@ -1306,9 +1380,6 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *=
priv,
 		mc_dmac[0] =3D 0x01;
 		mv_dmac[0] =3D 0x01;
 		break;
-
-	case MLX5E_PROMISC:
-		break;
 	}
=20
 	ai->rule =3D mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
@@ -1324,13 +1395,11 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_priv=
 *priv,
 	return err;
 }
=20
-#define MLX5E_NUM_L2_GROUPS	   3
-#define MLX5E_L2_GROUP1_SIZE	   BIT(0)
-#define MLX5E_L2_GROUP2_SIZE	   BIT(15)
-#define MLX5E_L2_GROUP3_SIZE	   BIT(0)
+#define MLX5E_NUM_L2_GROUPS	   2
+#define MLX5E_L2_GROUP1_SIZE	   BIT(15)
+#define MLX5E_L2_GROUP2_SIZE	   BIT(0)
 #define MLX5E_L2_TABLE_SIZE	   (MLX5E_L2_GROUP1_SIZE +\
-				    MLX5E_L2_GROUP2_SIZE +\
-				    MLX5E_L2_GROUP3_SIZE)
+				    MLX5E_L2_GROUP2_SIZE)
 static int mlx5e_create_l2_table_groups(struct mlx5e_l2_table *l2_table)
 {
 	int inlen =3D MLX5_ST_SZ_BYTES(create_flow_group_in);
@@ -1353,20 +1422,11 @@ static int mlx5e_create_l2_table_groups(struct mlx5=
e_l2_table *l2_table)
 	mc =3D MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
 	mc_dmac =3D MLX5_ADDR_OF(fte_match_param, mc,
 			       outer_headers.dmac_47_16);
-	/* Flow Group for promiscuous */
-	MLX5_SET_CFG(in, start_flow_index, ix);
-	ix +=3D MLX5E_L2_GROUP1_SIZE;
-	MLX5_SET_CFG(in, end_flow_index, ix - 1);
-	ft->g[ft->num_groups] =3D mlx5_create_flow_group(ft->t, in);
-	if (IS_ERR(ft->g[ft->num_groups]))
-		goto err_destroy_groups;
-	ft->num_groups++;
-
 	/* Flow Group for full match */
 	eth_broadcast_addr(mc_dmac);
 	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
 	MLX5_SET_CFG(in, start_flow_index, ix);
-	ix +=3D MLX5E_L2_GROUP2_SIZE;
+	ix +=3D MLX5E_L2_GROUP1_SIZE;
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
 	ft->g[ft->num_groups] =3D mlx5_create_flow_group(ft->t, in);
 	if (IS_ERR(ft->g[ft->num_groups]))
@@ -1377,7 +1437,7 @@ static int mlx5e_create_l2_table_groups(struct mlx5e_=
l2_table *l2_table)
 	eth_zero_addr(mc_dmac);
 	mc_dmac[0] =3D 0x01;
 	MLX5_SET_CFG(in, start_flow_index, ix);
-	ix +=3D MLX5E_L2_GROUP3_SIZE;
+	ix +=3D MLX5E_L2_GROUP2_SIZE;
 	MLX5_SET_CFG(in, end_flow_index, ix - 1);
 	ft->g[ft->num_groups] =3D mlx5_create_flow_group(ft->t, in);
 	if (IS_ERR(ft->g[ft->num_groups]))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index b899539a0786..3dbd63b9845d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -105,8 +105,8 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Vlan, mac, ttc, inner ttc, {aRFS/accel and esp/esp_err} */
-#define KERNEL_NIC_PRIO_NUM_LEVELS 6
+/* Promiscuous, Vlan, mac, ttc, inner ttc, {aRFS/accel and esp/esp_err} */
+#define KERNEL_NIC_PRIO_NUM_LEVELS 7
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
--=20
2.29.2

