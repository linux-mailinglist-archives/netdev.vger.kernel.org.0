Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBA128C4DE
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390408AbgJLWmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:42:22 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9863 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730707AbgJLWmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:42:20 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f84db580001>; Mon, 12 Oct 2020 15:40:24 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 22:42:13 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Huy Nguyen" <huyn@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 3/4] net/mlx5e: IPsec: Add TX steering rule per IPsec state
Date:   Mon, 12 Oct 2020 15:41:51 -0700
Message-ID: <20201012224152.191479-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012224152.191479-1-saeedm@nvidia.com>
References: <20201012224152.191479-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602542424; bh=maEjl6UD31BYk9Qy4dbLf28oF4QSszPzCnC2p5M4N2Q=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=R1zW/Q805KnxfqGc4PAIQxqc6prwpKnMRz7FVn74/GzHO0oYYF6iGPv9DA/5XpQsT
         kmFkBseYqT+NVVJAozlb2xru742B/rLvEFxx+u+fQnsSPdmTAHabbaqdLs1iXhbHTj
         ofMg84orAPOC756cFzQ7OwR84JRN/XOM5vKdtlpufVFea+Ngm3HXqoBgmSp84+6S/m
         2hXPAzURXNUw8vrx9JjJjYqR43hmwuFo2tbawTrte180Av9oZw6OYPIY4NJFJgr3K+
         FXC29d04qWPnOhJHCIK+9mJw9HCpbTnK2jL0u7wt9p+S8Tf+l0s6ssTOoCfQjsmeVh
         g0KDOqPqzFrxA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Add new FTE in TX IPsec FT per IPsec state. It has the
same matching criteria as the RX steering rule.

The IPsec FT is created/destroyed when the first/last rule
is added/deleted respectively.

Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   2 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 178 +++++++++++++++++-
 include/linux/mlx5/qp.h                       |   6 +-
 3 files changed, 181 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/dri=
vers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 0fc8b4d4f4a3..6164c7f59efb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -76,6 +76,7 @@ struct mlx5e_ipsec_stats {
 };
=20
 struct mlx5e_accel_fs_esp;
+struct mlx5e_ipsec_tx;
=20
 struct mlx5e_ipsec {
 	struct mlx5e_priv *en_priv;
@@ -87,6 +88,7 @@ struct mlx5e_ipsec {
 	struct mlx5e_ipsec_stats stats;
 	struct workqueue_struct *wq;
 	struct mlx5e_accel_fs_esp *rx_fs;
+	struct mlx5e_ipsec_tx *tx_fs;
 };
=20
 struct mlx5e_ipsec_esn_state {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index b974f3cd1005..0e45590662a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -34,6 +34,12 @@ struct mlx5e_accel_fs_esp {
 	struct mlx5e_accel_fs_esp_prot fs_prot[ACCEL_FS_ESP_NUM_TYPES];
 };
=20
+struct mlx5e_ipsec_tx {
+	struct mlx5_flow_table *ft;
+	struct mutex mutex; /* Protect IPsec TX steering */
+	u32 refcnt;
+};
+
 /* IPsec RX flow steering */
 static enum mlx5e_traffic_types fs_esp2tt(enum accel_fs_esp_type i)
 {
@@ -323,6 +329,77 @@ static void rx_ft_put(struct mlx5e_priv *priv, enum ac=
cel_fs_esp_type type)
 	mutex_unlock(&fs_prot->prot_mutex);
 }
=20
+/* IPsec TX flow steering */
+static int tx_create(struct mlx5e_priv *priv)
+{
+	struct mlx5_flow_table_attr ft_attr =3D {};
+	struct mlx5e_ipsec *ipsec =3D priv->ipsec;
+	struct mlx5_flow_table *ft;
+	int err;
+
+	priv->fs.egress_ns =3D
+		mlx5_get_flow_namespace(priv->mdev,
+					MLX5_FLOW_NAMESPACE_EGRESS_KERNEL);
+	if (!priv->fs.egress_ns)
+		return -EOPNOTSUPP;
+
+	ft_attr.max_fte =3D NUM_IPSEC_FTE;
+	ft_attr.autogroup.max_num_groups =3D 1;
+	ft =3D mlx5_create_auto_grouped_flow_table(priv->fs.egress_ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err =3D PTR_ERR(ft);
+		netdev_err(priv->netdev, "fail to create ipsec tx ft err=3D%d\n", err);
+		return err;
+	}
+	ipsec->tx_fs->ft =3D ft;
+	return 0;
+}
+
+static void tx_destroy(struct mlx5e_priv *priv)
+{
+	struct mlx5e_ipsec *ipsec =3D priv->ipsec;
+
+	if (IS_ERR_OR_NULL(ipsec->tx_fs->ft))
+		return;
+
+	mlx5_destroy_flow_table(ipsec->tx_fs->ft);
+	ipsec->tx_fs->ft =3D NULL;
+}
+
+static int tx_ft_get(struct mlx5e_priv *priv)
+{
+	struct mlx5e_ipsec_tx *tx_fs =3D priv->ipsec->tx_fs;
+	int err =3D 0;
+
+	mutex_lock(&tx_fs->mutex);
+	if (tx_fs->refcnt++)
+		goto out;
+
+	err =3D tx_create(priv);
+	if (err) {
+		tx_fs->refcnt--;
+		goto out;
+	}
+
+out:
+	mutex_unlock(&tx_fs->mutex);
+	return err;
+}
+
+static void tx_ft_put(struct mlx5e_priv *priv)
+{
+	struct mlx5e_ipsec_tx *tx_fs =3D priv->ipsec->tx_fs;
+
+	mutex_lock(&tx_fs->mutex);
+	if (--tx_fs->refcnt)
+		goto out;
+
+	tx_destroy(priv);
+
+out:
+	mutex_unlock(&tx_fs->mutex);
+}
+
 static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
 			     u32 ipsec_obj_id,
 			     struct mlx5_flow_spec *spec,
@@ -457,6 +534,54 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	return err;
 }
=20
+static int tx_add_rule(struct mlx5e_priv *priv,
+		       struct mlx5_accel_esp_xfrm_attrs *attrs,
+		       u32 ipsec_obj_id,
+		       struct mlx5e_ipsec_rule *ipsec_rule)
+{
+	struct mlx5_flow_act flow_act =3D {};
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	int err =3D 0;
+
+	err =3D tx_ft_get(priv);
+	if (err)
+		return err;
+
+	spec =3D kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec) {
+		err =3D -ENOMEM;
+		goto out;
+	}
+
+	setup_fte_common(attrs, ipsec_obj_id, spec, &flow_act);
+
+	/* Add IPsec indicator in metadata_reg_a */
+	spec->match_criteria_enable |=3D MLX5_MATCH_MISC_PARAMETERS_2;
+	MLX5_SET(fte_match_param, spec->match_criteria, misc_parameters_2.metadat=
a_reg_a,
+		 MLX5_ETH_WQE_FT_META_IPSEC);
+	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_r=
eg_a,
+		 MLX5_ETH_WQE_FT_META_IPSEC);
+
+	flow_act.action =3D MLX5_FLOW_CONTEXT_ACTION_ALLOW |
+			  MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT;
+	rule =3D mlx5_add_flow_rules(priv->ipsec->tx_fs->ft, spec, &flow_act, NUL=
L, 0);
+	if (IS_ERR(rule)) {
+		err =3D PTR_ERR(rule);
+		netdev_err(priv->netdev, "fail to add ipsec rule attrs->action=3D0x%x, e=
rr=3D%d\n",
+			   attrs->action, err);
+		goto out;
+	}
+
+	ipsec_rule->rule =3D rule;
+
+out:
+	kvfree(spec);
+	if (err)
+		tx_ft_put(priv);
+	return err;
+}
+
 static void rx_del_rule(struct mlx5e_priv *priv,
 			struct mlx5_accel_esp_xfrm_attrs *attrs,
 			struct mlx5e_ipsec_rule *ipsec_rule)
@@ -470,15 +595,27 @@ static void rx_del_rule(struct mlx5e_priv *priv,
 	rx_ft_put(priv, attrs->is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
 }
=20
+static void tx_del_rule(struct mlx5e_priv *priv,
+			struct mlx5e_ipsec_rule *ipsec_rule)
+{
+	mlx5_del_flow_rules(ipsec_rule->rule);
+	ipsec_rule->rule =3D NULL;
+
+	tx_ft_put(priv);
+}
+
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 				  struct mlx5_accel_esp_xfrm_attrs *attrs,
 				  u32 ipsec_obj_id,
 				  struct mlx5e_ipsec_rule *ipsec_rule)
 {
-	if (!priv->ipsec->rx_fs || attrs->action !=3D MLX5_ACCEL_ESP_ACTION_DECRY=
PT)
+	if (!priv->ipsec->rx_fs)
 		return -EOPNOTSUPP;
=20
-	return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
+	if (attrs->action =3D=3D MLX5_ACCEL_ESP_ACTION_DECRYPT)
+		return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
+	else
+		return tx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
 }
=20
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
@@ -488,7 +625,18 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *=
priv,
 	if (!priv->ipsec->rx_fs)
 		return;
=20
-	rx_del_rule(priv, attrs, ipsec_rule);
+	if (attrs->action =3D=3D MLX5_ACCEL_ESP_ACTION_DECRYPT)
+		rx_del_rule(priv, attrs, ipsec_rule);
+	else
+		tx_del_rule(priv, ipsec_rule);
+}
+
+static void fs_cleanup_tx(struct mlx5e_priv *priv)
+{
+	mutex_destroy(&priv->ipsec->tx_fs->mutex);
+	WARN_ON(priv->ipsec->tx_fs->refcnt);
+	kfree(priv->ipsec->tx_fs);
+	priv->ipsec->tx_fs =3D NULL;
 }
=20
 static void fs_cleanup_rx(struct mlx5e_priv *priv)
@@ -507,6 +655,17 @@ static void fs_cleanup_rx(struct mlx5e_priv *priv)
 	priv->ipsec->rx_fs =3D NULL;
 }
=20
+static int fs_init_tx(struct mlx5e_priv *priv)
+{
+	priv->ipsec->tx_fs =3D
+		kzalloc(sizeof(struct mlx5e_ipsec_tx), GFP_KERNEL);
+	if (!priv->ipsec->tx_fs)
+		return -ENOMEM;
+
+	mutex_init(&priv->ipsec->tx_fs->mutex);
+	return 0;
+}
+
 static int fs_init_rx(struct mlx5e_priv *priv)
 {
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
@@ -532,13 +691,24 @@ void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_priv *=
priv)
 	if (!priv->ipsec->rx_fs)
 		return;
=20
+	fs_cleanup_tx(priv);
 	fs_cleanup_rx(priv);
 }
=20
 int mlx5e_accel_ipsec_fs_init(struct mlx5e_priv *priv)
 {
+	int err;
+
 	if (!mlx5_is_ipsec_device(priv->mdev) || !priv->ipsec)
 		return -EOPNOTSUPP;
=20
-	return fs_init_rx(priv);
+	err =3D fs_init_tx(priv);
+	if (err)
+		return err;
+
+	err =3D fs_init_rx(priv);
+	if (err)
+		fs_cleanup_tx(priv);
+
+	return err;
 }
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 36492a1342cf..d75ef8aa8fac 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -245,6 +245,10 @@ enum {
 	MLX5_ETH_WQE_SWP_OUTER_L4_UDP   =3D 1 << 5,
 };
=20
+enum {
+	MLX5_ETH_WQE_FT_META_IPSEC =3D BIT(0),
+};
+
 struct mlx5_wqe_eth_seg {
 	u8              swp_outer_l4_offset;
 	u8              swp_outer_l3_offset;
@@ -253,7 +257,7 @@ struct mlx5_wqe_eth_seg {
 	u8              cs_flags;
 	u8              swp_flags;
 	__be16          mss;
-	__be32          rsvd2;
+	__be32          flow_table_metadata;
 	union {
 		struct {
 			__be16 sz;
--=20
2.26.2

