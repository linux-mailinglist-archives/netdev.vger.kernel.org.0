Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330C959D0DD
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbiHWFzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240347AbiHWFzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA7B5E554
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8B3B61484
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08A3C433D6;
        Tue, 23 Aug 2022 05:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234145;
        bh=qxxlbRqUxGx3LlaZbof+AxxSHX/KAWLbwnBr0hPgkhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uf/zZL6UjhiBZUJOyyuixpCHs7gWoO6gFKdVSbSrcW5zQuLlFAf/IzigTqgtDbcgi
         eGg79r+t9SwVLKcG2OnB6nbDsTKbEDaz0WvvD7pIdzpt5NKnykfif6INutBXt6UmS+
         kMClGCSmGKCZRXaIcPclHJdIcDGxfBk881h81CeQIvFZFgqfqgtTyvbei5QyzHubfU
         RGpPKUGyduyNDd2lM75DPz7qyrjPvyEw9ZYgdBYK4hs38LWxXEvL+eiWc0jW+AXemD
         NunXqov2LOQlXhUYxVup9a9PKo7paNepnrC+IUHMTSfEsv7ZHsonY096NM/BV11Bi3
         r41SzFOXJbfDg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Introduce flow steering API
Date:   Mon, 22 Aug 2022 22:55:19 -0700
Message-Id: <20220823055533.334471-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220823055533.334471-1-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Move mlx5e_flow_steering struct to fs_en.c to make it private.
Introduce flow_steering API and let other files go through it.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  55 ++++---
 .../mellanox/mlx5/core/en/fs_tt_redirect.c    |  93 ++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   8 +-
 .../mellanox/mlx5/core/en/tc/act/goto.c       |   3 +-
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      |  46 +++---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c |  78 +++++----
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 154 +++++++++++++++++-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |  33 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  19 ++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  17 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  78 +++++----
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   1 +
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |   8 +-
 14 files changed, 415 insertions(+), 193 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 9b8cdf2e68ad..c5ec9e01a6d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -8,6 +8,7 @@
 #include "lib/fs_ttc.h"
 
 struct mlx5e_post_act;
+struct mlx5e_tc_table;
 
 enum {
 	MLX5E_TC_FT_LEVEL = 0,
@@ -83,6 +84,7 @@ enum {
 #endif
 };
 
+struct mlx5e_flow_steering;
 struct mlx5e_priv;
 
 #ifdef CONFIG_MLX5_EN_RXNFC
@@ -142,31 +144,6 @@ struct mlx5e_fs_udp;
 struct mlx5e_fs_any;
 struct mlx5e_ptp_fs;
 
-struct mlx5e_flow_steering {
-	bool				state_destroy;
-	bool				vlan_strip_disable;
-	struct mlx5_core_dev		*mdev;
-	struct mlx5_flow_namespace      *ns;
-#ifdef CONFIG_MLX5_EN_RXNFC
-	struct mlx5e_ethtool_steering   ethtool;
-#endif
-	struct mlx5e_tc_table           *tc;
-	struct mlx5e_promisc_table      promisc;
-	struct mlx5e_vlan_table         *vlan;
-	struct mlx5e_l2_table           l2;
-	struct mlx5_ttc_table           *ttc;
-	struct mlx5_ttc_table           *inner_ttc;
-#ifdef CONFIG_MLX5_EN_ARFS
-	struct mlx5e_arfs_tables       *arfs;
-#endif
-#ifdef CONFIG_MLX5_EN_TLS
-	struct mlx5e_accel_fs_tcp      *accel_tcp;
-#endif
-	struct mlx5e_fs_udp            *udp;
-	struct mlx5e_fs_any            *any;
-	struct mlx5e_ptp_fs            *ptp_fs;
-};
-
 void mlx5e_set_ttc_params(struct mlx5e_priv *priv,
 			  struct ttc_params *ttc_params, bool tunnel);
 
@@ -185,7 +162,35 @@ struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
 					  bool state_destroy);
 void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs);
+struct mlx5e_vlan_table *mlx5e_fs_get_vlan(struct mlx5e_flow_steering *fs);
+void mlx5e_fs_set_tc(struct mlx5e_flow_steering *fs, struct mlx5e_tc_table *tc);
+struct mlx5e_tc_table *mlx5e_fs_get_tc(struct mlx5e_flow_steering *fs);
+struct mlx5e_l2_table *mlx5e_fs_get_l2(struct mlx5e_flow_steering *fs);
+struct mlx5_flow_namespace *mlx5e_fs_get_ns(struct mlx5e_flow_steering *fs, bool egress);
+void mlx5e_fs_set_ns(struct mlx5e_flow_steering *fs, struct mlx5_flow_namespace *ns, bool egress);
+#ifdef CONFIG_MLX5_EN_RXNFC
+struct mlx5e_ethtool_steering *mlx5e_fs_get_ethtool(struct mlx5e_flow_steering *fs);
+#endif
+struct mlx5_ttc_table *mlx5e_fs_get_ttc(struct mlx5e_flow_steering *fs, bool inner);
+void mlx5e_fs_set_ttc(struct mlx5e_flow_steering *fs, struct mlx5_ttc_table *ttc, bool inner);
+#ifdef CONFIG_MLX5_EN_ARFS
+struct mlx5e_arfs_tables *mlx5e_fs_get_arfs(struct mlx5e_flow_steering *fs);
+void mlx5e_fs_set_arfs(struct mlx5e_flow_steering *fs, struct mlx5e_arfs_tables *arfs);
+#endif
+struct mlx5e_ptp_fs *mlx5e_fs_get_ptp(struct mlx5e_flow_steering *fs);
+void mlx5e_fs_set_ptp(struct mlx5e_flow_steering *fs, struct mlx5e_ptp_fs *ptp_fs);
+struct mlx5e_fs_any *mlx5e_fs_get_any(struct mlx5e_flow_steering *fs);
+void mlx5e_fs_set_any(struct mlx5e_flow_steering *fs, struct mlx5e_fs_any *any);
+struct mlx5e_fs_udp *mlx5e_fs_get_udp(struct mlx5e_flow_steering *fs);
+void mlx5e_fs_set_udp(struct mlx5e_flow_steering *fs, struct mlx5e_fs_udp *udp);
+#ifdef CONFIG_MLX5_EN_TLS
+struct mlx5e_accel_fs_tcp *mlx5e_fs_get_accel_tcp(struct mlx5e_flow_steering *fs);
+void mlx5e_fs_set_accel_tcp(struct mlx5e_flow_steering *fs, struct mlx5e_accel_fs_tcp *accel_tcp);
+#endif
+void mlx5e_fs_set_state_destroy(struct mlx5e_flow_steering *fs, bool state_destroy);
+void mlx5e_fs_set_vlan_strip_disable(struct mlx5e_flow_steering *fs, bool vlan_strip_disable);
 
+struct mlx5_core_dev *mlx5e_fs_get_mdev(struct mlx5e_flow_steering *fs);
 int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
 void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv);
 int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
index e153d6119e02..4ed1bc32c967 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
@@ -78,13 +78,13 @@ mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_priv *priv,
 				  enum mlx5_traffic_types ttc_type,
 				  u32 tir_num, u16 d_port)
 {
+	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(priv->fs);
 	enum fs_udp_type type = tt2fs_udp(ttc_type);
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_table *ft = NULL;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
-	struct mlx5e_fs_udp *fs_udp;
 	int err;
 
 	if (type == FS_UDP_NUM_TYPES)
@@ -94,7 +94,6 @@ mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_priv *priv,
 	if (!spec)
 		return ERR_PTR(-ENOMEM);
 
-	fs_udp = priv->fs->udp;
 	ft = fs_udp->tables[type].t;
 
 	fs_udp_set_dport_flow(spec, type, d_port);
@@ -114,17 +113,17 @@ mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_priv *priv,
 
 static int fs_udp_add_default_rule(struct mlx5e_priv *priv, enum fs_udp_type type)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(priv->fs);
 	struct mlx5e_flow_table *fs_udp_t;
 	struct mlx5_flow_destination dest;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_handle *rule;
-	struct mlx5e_fs_udp *fs_udp;
 	int err;
 
-	fs_udp = priv->fs->udp;
 	fs_udp_t = &fs_udp->tables[type];
 
-	dest = mlx5_ttc_get_default_dest(priv->fs->ttc, fs_udp2tt(type));
+	dest = mlx5_ttc_get_default_dest(ttc, fs_udp2tt(type));
 	rule = mlx5_add_flow_rules(fs_udp_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -208,7 +207,9 @@ static int fs_udp_create_groups(struct mlx5e_flow_table *ft, enum fs_udp_type ty
 
 static int fs_udp_create_table(struct mlx5e_priv *priv, enum fs_udp_type type)
 {
-	struct mlx5e_flow_table *ft = &priv->fs->udp->tables[type];
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
+	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(priv->fs);
+	struct mlx5e_flow_table *ft = &fs_udp->tables[type];
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
 
@@ -218,7 +219,7 @@ static int fs_udp_create_table(struct mlx5e_priv *priv, enum fs_udp_type type)
 	ft_attr.level = MLX5E_FS_TT_UDP_FT_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
 
-	ft->t = mlx5_create_flow_table(priv->fs->ns, &ft_attr);
+	ft->t = mlx5_create_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
 		ft->t = NULL;
@@ -255,11 +256,12 @@ static void fs_udp_destroy_table(struct mlx5e_fs_udp *fs_udp, int i)
 
 static int fs_udp_disable(struct mlx5e_priv *priv)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	int err, i;
 
 	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
 		/* Modify ttc rules destination to point back to the indir TIRs */
-		err = mlx5_ttc_fwd_default_dest(priv->fs->ttc, fs_udp2tt(i));
+		err = mlx5_ttc_fwd_default_dest(ttc, fs_udp2tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -273,15 +275,17 @@ static int fs_udp_disable(struct mlx5e_priv *priv)
 
 static int fs_udp_enable(struct mlx5e_priv *priv)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5e_fs_udp *udp = mlx5e_fs_get_udp(priv->fs);
 	struct mlx5_flow_destination dest = {};
 	int err, i;
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
-		dest.ft = priv->fs->udp->tables[i].t;
+		dest.ft = udp->tables[i].t;
 
 		/* Modify ttc rules destination to point on the accel_fs FTs */
-		err = mlx5_ttc_fwd_dest(priv->fs->ttc, fs_udp2tt(i), &dest);
+		err = mlx5_ttc_fwd_dest(ttc, fs_udp2tt(i), &dest);
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
@@ -294,7 +298,7 @@ static int fs_udp_enable(struct mlx5e_priv *priv)
 
 void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_priv *priv)
 {
-	struct mlx5e_fs_udp *fs_udp = priv->fs->udp;
+	struct mlx5e_fs_udp *fs_udp = mlx5e_fs_get_udp(priv->fs);
 	int i;
 
 	if (!fs_udp)
@@ -309,21 +313,23 @@ void mlx5e_fs_tt_redirect_udp_destroy(struct mlx5e_priv *priv)
 		fs_udp_destroy_table(fs_udp, i);
 
 	kfree(fs_udp);
-	priv->fs->udp = NULL;
+	mlx5e_fs_set_udp(priv->fs, NULL);
 }
 
 int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv)
 {
+	struct mlx5e_fs_udp *udp = mlx5e_fs_get_udp(priv->fs);
 	int i, err;
 
-	if (priv->fs->udp) {
-		priv->fs->udp->ref_cnt++;
+	if (udp) {
+		udp->ref_cnt++;
 		return 0;
 	}
 
-	priv->fs->udp = kzalloc(sizeof(*priv->fs->udp), GFP_KERNEL);
-	if (!priv->fs->udp)
+	udp = kzalloc(sizeof(*udp), GFP_KERNEL);
+	if (!udp)
 		return -ENOMEM;
+	mlx5e_fs_set_udp(priv->fs, udp);
 
 	for (i = 0; i < FS_UDP_NUM_TYPES; i++) {
 		err = fs_udp_create_table(priv, i);
@@ -335,16 +341,16 @@ int mlx5e_fs_tt_redirect_udp_create(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_tables;
 
-	priv->fs->udp->ref_cnt = 1;
+	udp->ref_cnt = 1;
 
 	return 0;
 
 err_destroy_tables:
 	while (--i >= 0)
-		fs_udp_destroy_table(priv->fs->udp, i);
+		fs_udp_destroy_table(udp, i);
 
-	kfree(priv->fs->udp);
-	priv->fs->udp = NULL;
+	kfree(udp);
+	mlx5e_fs_set_udp(priv->fs, NULL);
 	return err;
 }
 
@@ -359,19 +365,18 @@ struct mlx5_flow_handle *
 mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_priv *priv,
 				  u32 tir_num, u16 ether_type)
 {
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_table *ft = NULL;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
-	struct mlx5e_fs_any *fs_any;
 	int err;
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
 		return ERR_PTR(-ENOMEM);
 
-	fs_any = priv->fs->any;
 	ft = fs_any->table.t;
 
 	fs_any_set_ethertype_flow(spec, ether_type);
@@ -391,17 +396,16 @@ mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_priv *priv,
 
 static int fs_any_add_default_rule(struct mlx5e_priv *priv)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
 	struct mlx5e_flow_table *fs_any_t;
 	struct mlx5_flow_destination dest;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_handle *rule;
-	struct mlx5e_fs_any *fs_any;
 	int err;
 
-	fs_any = priv->fs->any;
 	fs_any_t = &fs_any->table;
-
-	dest = mlx5_ttc_get_default_dest(priv->fs->ttc, MLX5_TT_ANY);
+	dest = mlx5_ttc_get_default_dest(ttc, MLX5_TT_ANY);
 	rule = mlx5_add_flow_rules(fs_any_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -474,7 +478,9 @@ static int fs_any_create_groups(struct mlx5e_flow_table *ft)
 
 static int fs_any_create_table(struct mlx5e_priv *priv)
 {
-	struct mlx5e_flow_table *ft = &priv->fs->any->table;
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
+	struct mlx5e_flow_table *ft = &fs_any->table;
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
 
@@ -484,7 +490,7 @@ static int fs_any_create_table(struct mlx5e_priv *priv)
 	ft_attr.level = MLX5E_FS_TT_ANY_FT_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
 
-	ft->t = mlx5_create_flow_table(priv->fs->ns, &ft_attr);
+	ft->t = mlx5_create_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
 		ft->t = NULL;
@@ -511,10 +517,11 @@ static int fs_any_create_table(struct mlx5e_priv *priv)
 
 static int fs_any_disable(struct mlx5e_priv *priv)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	int err;
 
 	/* Modify ttc rules destination to point back to the indir TIRs */
-	err = mlx5_ttc_fwd_default_dest(priv->fs->ttc, MLX5_TT_ANY);
+	err = mlx5_ttc_fwd_default_dest(ttc, MLX5_TT_ANY);
 	if (err) {
 		netdev_err(priv->netdev,
 			   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -526,14 +533,16 @@ static int fs_any_disable(struct mlx5e_priv *priv)
 
 static int fs_any_enable(struct mlx5e_priv *priv)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5e_fs_any *any = mlx5e_fs_get_any(priv->fs);
 	struct mlx5_flow_destination dest = {};
 	int err;
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = priv->fs->any->table.t;
+	dest.ft = any->table.t;
 
 	/* Modify ttc rules destination to point on the accel_fs FTs */
-	err = mlx5_ttc_fwd_dest(priv->fs->ttc, MLX5_TT_ANY, &dest);
+	err = mlx5_ttc_fwd_dest(ttc, MLX5_TT_ANY, &dest);
 	if (err) {
 		netdev_err(priv->netdev,
 			   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
@@ -555,7 +564,7 @@ static void fs_any_destroy_table(struct mlx5e_fs_any *fs_any)
 
 void mlx5e_fs_tt_redirect_any_destroy(struct mlx5e_priv *priv)
 {
-	struct mlx5e_fs_any *fs_any = priv->fs->any;
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
 
 	if (!fs_any)
 		return;
@@ -568,21 +577,23 @@ void mlx5e_fs_tt_redirect_any_destroy(struct mlx5e_priv *priv)
 	fs_any_destroy_table(fs_any);
 
 	kfree(fs_any);
-	priv->fs->any = NULL;
+	mlx5e_fs_set_any(priv->fs, NULL);
 }
 
 int mlx5e_fs_tt_redirect_any_create(struct mlx5e_priv *priv)
 {
+	struct mlx5e_fs_any *fs_any = mlx5e_fs_get_any(priv->fs);
 	int err;
 
-	if (priv->fs->any) {
-		priv->fs->any->ref_cnt++;
+	if (fs_any) {
+		fs_any->ref_cnt++;
 		return 0;
 	}
 
-	priv->fs->any = kzalloc(sizeof(*priv->fs->any), GFP_KERNEL);
-	if (!priv->fs->any)
+	fs_any = kzalloc(sizeof(*fs_any), GFP_KERNEL);
+	if (!fs_any)
 		return -ENOMEM;
+	mlx5e_fs_set_any(priv->fs, fs_any);
 
 	err = fs_any_create_table(priv);
 	if (err)
@@ -592,14 +603,14 @@ int mlx5e_fs_tt_redirect_any_create(struct mlx5e_priv *priv)
 	if (err)
 		goto err_destroy_table;
 
-	priv->fs->any->ref_cnt = 1;
+	fs_any->ref_cnt = 1;
 
 	return 0;
 
 err_destroy_table:
-	fs_any_destroy_table(priv->fs->any);
+	fs_any_destroy_table(fs_any);
 
-	kfree(priv->fs->any);
-	priv->fs->any = NULL;
+	kfree(fs_any);
+	mlx5e_fs_set_any(priv->fs, NULL);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 903de88bab53..23f4ddc8ef88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -624,7 +624,7 @@ static int mlx5e_ptp_set_state(struct mlx5e_ptp *c, struct mlx5e_params *params)
 
 static void mlx5e_ptp_rx_unset_fs(struct mlx5e_priv *priv)
 {
-	struct mlx5e_ptp_fs *ptp_fs = priv->fs->ptp_fs;
+	struct mlx5e_ptp_fs *ptp_fs = mlx5e_fs_get_ptp(priv->fs);
 
 	if (!ptp_fs->valid)
 		return;
@@ -640,8 +640,8 @@ static void mlx5e_ptp_rx_unset_fs(struct mlx5e_priv *priv)
 
 static int mlx5e_ptp_rx_set_fs(struct mlx5e_priv *priv)
 {
+	struct mlx5e_ptp_fs *ptp_fs = mlx5e_fs_get_ptp(priv->fs);
 	u32 tirn = mlx5e_rx_res_get_tirn_ptp(priv->rx_res);
-	struct mlx5e_ptp_fs *ptp_fs = priv->fs->ptp_fs;
 	struct mlx5_flow_handle *rule;
 	int err;
 
@@ -807,14 +807,14 @@ int mlx5e_ptp_alloc_rx_fs(struct mlx5e_priv *priv)
 	ptp_fs = kzalloc(sizeof(*ptp_fs), GFP_KERNEL);
 	if (!ptp_fs)
 		return -ENOMEM;
+	mlx5e_fs_set_ptp(priv->fs, ptp_fs);
 
-	priv->fs->ptp_fs = ptp_fs;
 	return 0;
 }
 
 void mlx5e_ptp_free_rx_fs(struct mlx5e_priv *priv)
 {
-	struct mlx5e_ptp_fs *ptp_fs = priv->fs->ptp_fs;
+	struct mlx5e_ptp_fs *ptp_fs = mlx5e_fs_get_ptp(priv->fs);
 
 	if (!mlx5e_profile_feature_cap(priv->profile, PTP_RX))
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
index 69949ab830b6..25174f68613e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
@@ -12,6 +12,7 @@ validate_goto_chain(struct mlx5e_priv *priv,
 		    const struct flow_action_entry *act,
 		    struct netlink_ext_ack *extack)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	bool is_esw = mlx5e_is_eswitch_flow(flow);
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	u32 dest_chain = act->chain_index;
@@ -21,7 +22,7 @@ validate_goto_chain(struct mlx5e_priv *priv,
 	u32 max_chain;
 
 	esw = priv->mdev->priv.eswitch;
-	chains = is_esw ? esw_chains(esw) : mlx5e_nic_chains(priv->fs->tc);
+	chains = is_esw ? esw_chains(esw) : mlx5e_nic_chains(tc);
 	max_chain = mlx5_chains_get_chain_range(chains);
 	reformat_and_fwd = is_esw ?
 			   MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev, reformat_and_fwd_to_table) :
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 20a4f1e585af..a86ae0752760 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -75,9 +75,9 @@ struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
 					       struct sock *sk, u32 tirn,
 					       uint32_t flow_tag)
 {
+	struct mlx5e_accel_fs_tcp *fs_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
 	struct mlx5_flow_destination dest = {};
 	struct mlx5e_flow_table *ft = NULL;
-	struct mlx5e_accel_fs_tcp *fs_tcp;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_handle *flow;
 	struct mlx5_flow_spec *spec;
@@ -86,8 +86,6 @@ struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
 	if (!spec)
 		return ERR_PTR(-ENOMEM);
 
-	fs_tcp = priv->fs->accel_tcp;
-
 	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 
 	switch (sk->sk_family) {
@@ -151,17 +149,17 @@ struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
 static int accel_fs_tcp_add_default_rule(struct mlx5e_priv *priv,
 					 enum accel_fs_tcp_type type)
 {
+	struct mlx5e_accel_fs_tcp *fs_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	struct mlx5e_flow_table *accel_fs_t;
 	struct mlx5_flow_destination dest;
-	struct mlx5e_accel_fs_tcp *fs_tcp;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	struct mlx5_flow_handle *rule;
 	int err = 0;
 
-	fs_tcp = priv->fs->accel_tcp;
 	accel_fs_t = &fs_tcp->tables[type];
 
-	dest = mlx5_ttc_get_default_dest(priv->fs->ttc, fs_accel2tt(type));
+	dest = mlx5_ttc_get_default_dest(ttc, fs_accel2tt(type));
 	rule = mlx5_add_flow_rules(accel_fs_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
@@ -267,7 +265,9 @@ static int accel_fs_tcp_create_groups(struct mlx5e_flow_table *ft,
 
 static int accel_fs_tcp_create_table(struct mlx5e_priv *priv, enum accel_fs_tcp_type type)
 {
-	struct mlx5e_flow_table *ft = &priv->fs->accel_tcp->tables[type];
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
+	struct mlx5e_flow_table *ft = &accel_tcp->tables[type];
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
 
@@ -277,7 +277,7 @@ static int accel_fs_tcp_create_table(struct mlx5e_priv *priv, enum accel_fs_tcp_
 	ft_attr.level = MLX5E_ACCEL_FS_TCP_FT_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
 
-	ft->t = mlx5_create_flow_table(priv->fs->ns, &ft_attr);
+	ft->t = mlx5_create_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
 		ft->t = NULL;
@@ -303,11 +303,12 @@ static int accel_fs_tcp_create_table(struct mlx5e_priv *priv, enum accel_fs_tcp_
 
 static int accel_fs_tcp_disable(struct mlx5e_priv *priv)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	int err, i;
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
 		/* Modify ttc rules destination to point back to the indir TIRs */
-		err = mlx5_ttc_fwd_default_dest(priv->fs->ttc, fs_accel2tt(i));
+		err = mlx5_ttc_fwd_default_dest(ttc, fs_accel2tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -321,15 +322,17 @@ static int accel_fs_tcp_disable(struct mlx5e_priv *priv)
 
 static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
 {
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	struct mlx5_flow_destination dest = {};
 	int err, i;
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
-		dest.ft = priv->fs->accel_tcp->tables[i].t;
+		dest.ft = accel_tcp->tables[i].t;
 
 		/* Modify ttc rules destination to point on the accel_fs FTs */
-		err = mlx5_ttc_fwd_dest(priv->fs->ttc, fs_accel2tt(i), &dest);
+		err = mlx5_ttc_fwd_dest(ttc, fs_accel2tt(i), &dest);
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
@@ -342,9 +345,8 @@ static int accel_fs_tcp_enable(struct mlx5e_priv *priv)
 
 static void accel_fs_tcp_destroy_table(struct mlx5e_priv *priv, int i)
 {
-	struct mlx5e_accel_fs_tcp *fs_tcp;
+	struct mlx5e_accel_fs_tcp *fs_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
 
-	fs_tcp = priv->fs->accel_tcp;
 	if (IS_ERR_OR_NULL(fs_tcp->tables[i].t))
 		return;
 
@@ -355,9 +357,10 @@ static void accel_fs_tcp_destroy_table(struct mlx5e_priv *priv, int i)
 
 void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv)
 {
+	struct mlx5e_accel_fs_tcp *accel_tcp = mlx5e_fs_get_accel_tcp(priv->fs);
 	int i;
 
-	if (!priv->fs->accel_tcp)
+	if (!accel_tcp)
 		return;
 
 	accel_fs_tcp_disable(priv);
@@ -365,20 +368,22 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv)
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
 		accel_fs_tcp_destroy_table(priv, i);
 
-	kfree(priv->fs->accel_tcp);
-	priv->fs->accel_tcp = NULL;
+	kfree(accel_tcp);
+	mlx5e_fs_set_accel_tcp(priv->fs, NULL);
 }
 
 int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv)
 {
+	struct mlx5e_accel_fs_tcp *accel_tcp;
 	int i, err;
 
 	if (!MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ft_field_support.outer_ip_version))
 		return -EOPNOTSUPP;
 
-	priv->fs->accel_tcp = kzalloc(sizeof(*priv->fs->accel_tcp), GFP_KERNEL);
-	if (!priv->fs->accel_tcp)
+	accel_tcp = kvzalloc(sizeof(*accel_tcp), GFP_KERNEL);
+	if (!accel_tcp)
 		return -ENOMEM;
+	mlx5e_fs_set_accel_tcp(priv->fs, accel_tcp);
 
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++) {
 		err = accel_fs_tcp_create_table(priv, i);
@@ -395,8 +400,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv)
 err_destroy_tables:
 	while (--i >= 0)
 		accel_fs_tcp_destroy_table(priv, i);
-
-	kfree(priv->fs->accel_tcp);
-	priv->fs->accel_tcp = NULL;
+	kfree(accel_tcp);
+	mlx5e_fs_set_accel_tcp(priv->fs, NULL);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index f8113fd23265..e776b9f2da06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -174,6 +174,8 @@ static void rx_destroy(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 
 static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 {
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
@@ -182,15 +184,14 @@ static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 
 	accel_esp = priv->ipsec->rx_fs;
 	fs_prot = &accel_esp->fs_prot[type];
-
 	fs_prot->default_dest =
-		mlx5_ttc_get_default_dest(priv->fs->ttc, fs_esp2tt(type));
+		mlx5_ttc_get_default_dest(ttc, fs_esp2tt(type));
 
 	ft_attr.max_fte = 1;
 	ft_attr.autogroup.max_num_groups = 1;
 	ft_attr.level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs->ns, &ft_attr);
+	ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft))
 		return PTR_ERR(ft);
 
@@ -205,7 +206,7 @@ static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	ft_attr.prio = MLX5E_NIC_PRIO;
 	ft_attr.autogroup.num_reserved_entries = 1;
 	ft_attr.autogroup.max_num_groups = 1;
-	ft = mlx5_create_auto_grouped_flow_table(priv->fs->ns, &ft_attr);
+	ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		goto err_fs_ft;
@@ -230,6 +231,7 @@ static int rx_create(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 
 static int rx_ft_get(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5e_accel_fs_esp *accel_esp;
@@ -249,7 +251,7 @@ static int rx_ft_get(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 	/* connect */
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = fs_prot->ft;
-	mlx5_ttc_fwd_dest(priv->fs->ttc, fs_esp2tt(type), &dest);
+	mlx5_ttc_fwd_dest(ttc, fs_esp2tt(type), &dest);
 
 skip:
 	fs_prot->refcnt++;
@@ -260,6 +262,7 @@ static int rx_ft_get(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 
 static void rx_ft_put(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	struct mlx5e_accel_fs_esp_prot *fs_prot;
 	struct mlx5e_accel_fs_esp *accel_esp;
 
@@ -271,7 +274,7 @@ static void rx_ft_put(struct mlx5e_priv *priv, enum accel_fs_esp_type type)
 		goto out;
 
 	/* disconnect */
-	mlx5_ttc_fwd_default_dest(priv->fs->ttc, fs_esp2tt(type));
+	mlx5_ttc_fwd_default_dest(ttc, fs_esp2tt(type));
 
 	/* remove FT */
 	rx_destroy(priv, type);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index cd7f245dcf14..bf233cf3f6f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -116,11 +116,12 @@ static enum mlx5_traffic_types arfs_get_tt(enum arfs_type type)
 
 static int arfs_disable(struct mlx5e_priv *priv)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	int err, i;
 
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		/* Modify ttc rules destination back to their default */
-		err = mlx5_ttc_fwd_default_dest(priv->fs->ttc, arfs_get_tt(i));
+		err = mlx5_ttc_fwd_default_dest(ttc, arfs_get_tt(i));
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] default destination failed, err(%d)\n",
@@ -142,14 +143,16 @@ int mlx5e_arfs_disable(struct mlx5e_priv *priv)
 
 int mlx5e_arfs_enable(struct mlx5e_priv *priv)
 {
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(priv->fs, false);
+	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(priv->fs);
 	struct mlx5_flow_destination dest = {};
 	int err, i;
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
-		dest.ft = priv->fs->arfs->arfs_tables[i].ft.t;
+		dest.ft = arfs->arfs_tables[i].ft.t;
 		/* Modify ttc rules destination to point on the aRFS FTs */
-		err = mlx5_ttc_fwd_dest(priv->fs->ttc, arfs_get_tt(i), &dest);
+		err = mlx5_ttc_fwd_dest(ttc, arfs_get_tt(i), &dest);
 		if (err) {
 			netdev_err(priv->netdev,
 				   "%s: modify ttc[%d] dest to arfs, failed err(%d)\n",
@@ -169,29 +172,33 @@ static void arfs_destroy_table(struct arfs_table *arfs_t)
 
 static void _mlx5e_cleanup_tables(struct mlx5e_priv *priv)
 {
+	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(priv->fs);
 	int i;
 
 	arfs_del_rules(priv);
-	destroy_workqueue(priv->fs->arfs->wq);
+	destroy_workqueue(arfs->wq);
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
-		if (!IS_ERR_OR_NULL(priv->fs->arfs->arfs_tables[i].ft.t))
-			arfs_destroy_table(&priv->fs->arfs->arfs_tables[i]);
+		if (!IS_ERR_OR_NULL(arfs->arfs_tables[i].ft.t))
+			arfs_destroy_table(&arfs->arfs_tables[i]);
 	}
 }
 
 void mlx5e_arfs_destroy_tables(struct mlx5e_priv *priv)
 {
+	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(priv->fs);
 	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
 		return;
 
 	_mlx5e_cleanup_tables(priv);
-	kvfree(priv->fs->arfs);
+	mlx5e_fs_set_arfs(priv->fs, NULL);
+	kvfree(arfs);
 }
 
 static int arfs_add_default_rule(struct mlx5e_priv *priv,
 				 enum arfs_type type)
 {
-	struct arfs_table *arfs_t = &priv->fs->arfs->arfs_tables[type];
+	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(priv->fs);
+	struct arfs_table *arfs_t = &arfs->arfs_tables[type];
 	struct mlx5_flow_destination dest = {};
 	MLX5_DECLARE_FLOW_ACT(flow_act);
 	enum mlx5_traffic_types tt;
@@ -321,7 +328,8 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
 static int arfs_create_table(struct mlx5e_priv *priv,
 			     enum arfs_type type)
 {
-	struct mlx5e_arfs_tables *arfs = priv->fs->arfs;
+	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(priv->fs, false);
+	struct mlx5e_arfs_tables *arfs = mlx5e_fs_get_arfs(priv->fs);
 	struct mlx5e_flow_table *ft = &arfs->arfs_tables[type].ft;
 	struct mlx5_flow_table_attr ft_attr = {};
 	int err;
@@ -332,7 +340,7 @@ static int arfs_create_table(struct mlx5e_priv *priv,
 	ft_attr.level = MLX5E_ARFS_FT_LEVEL;
 	ft_attr.prio = MLX5E_NIC_PRIO;
 
-	ft->t = mlx5_create_flow_table(priv->fs->ns, &ft_attr);
+	ft->t = mlx5_create_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
 		ft->t = NULL;
@@ -355,22 +363,25 @@ static int arfs_create_table(struct mlx5e_priv *priv,
 
 int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
 {
+	struct mlx5e_arfs_tables *arfs;
 	int err = -ENOMEM;
 	int i;
 
 	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
 		return 0;
 
-	priv->fs->arfs = kvzalloc(sizeof(*priv->fs->arfs), GFP_KERNEL);
-	if (!priv->fs->arfs)
+	arfs = kvzalloc(sizeof(*arfs), GFP_KERNEL);
+	if (!arfs)
 		return -ENOMEM;
 
-	spin_lock_init(&priv->fs->arfs->arfs_lock);
-	INIT_LIST_HEAD(&priv->fs->arfs->rules);
-	priv->fs->arfs->wq = create_singlethread_workqueue("mlx5e_arfs");
-	if (!priv->fs->arfs->wq)
+	spin_lock_init(&arfs->arfs_lock);
+	INIT_LIST_HEAD(&arfs->rules);
+	arfs->wq = create_singlethread_workqueue("mlx5e_arfs");
+	if (!arfs->wq)
 		goto err;
 
+	mlx5e_fs_set_arfs(priv->fs, arfs);
+
 	for (i = 0; i < ARFS_NUM_TYPES; i++) {
 		err = arfs_create_table(priv, i);
 		if (err)
@@ -381,7 +392,8 @@ int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
 err_des:
 	_mlx5e_cleanup_tables(priv);
 err:
-	kvfree(priv->fs->arfs);
+	mlx5e_fs_set_arfs(priv->fs, NULL);
+	kvfree(arfs);
 	return err;
 }
 
@@ -389,6 +401,7 @@ int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
 
 static void arfs_may_expire_flow(struct mlx5e_priv *priv)
 {
+	struct mlx5e_arfs_tables *arfs = mlx5e_fs_get_arfs(priv->fs);
 	struct arfs_rule *arfs_rule;
 	struct hlist_node *htmp;
 	HLIST_HEAD(del_list);
@@ -396,8 +409,8 @@ static void arfs_may_expire_flow(struct mlx5e_priv *priv)
 	int i;
 	int j;
 
-	spin_lock_bh(&priv->fs->arfs->arfs_lock);
-	mlx5e_for_each_arfs_rule(arfs_rule, htmp, priv->fs->arfs->arfs_tables, i, j) {
+	spin_lock_bh(&arfs->arfs_lock);
+	mlx5e_for_each_arfs_rule(arfs_rule, htmp, arfs->arfs_tables, i, j) {
 		if (!work_pending(&arfs_rule->arfs_work) &&
 		    rps_may_expire_flow(priv->netdev,
 					arfs_rule->rxq, arfs_rule->flow_id,
@@ -408,7 +421,7 @@ static void arfs_may_expire_flow(struct mlx5e_priv *priv)
 				break;
 		}
 	}
-	spin_unlock_bh(&priv->fs->arfs->arfs_lock);
+	spin_unlock_bh(&arfs->arfs_lock);
 	hlist_for_each_entry_safe(arfs_rule, htmp, &del_list, hlist) {
 		if (arfs_rule->rule)
 			mlx5_del_flow_rules(arfs_rule->rule);
@@ -419,18 +432,19 @@ static void arfs_may_expire_flow(struct mlx5e_priv *priv)
 
 static void arfs_del_rules(struct mlx5e_priv *priv)
 {
+	struct mlx5e_arfs_tables *arfs = mlx5e_fs_get_arfs(priv->fs);
 	struct hlist_node *htmp;
 	struct arfs_rule *rule;
 	HLIST_HEAD(del_list);
 	int i;
 	int j;
 
-	spin_lock_bh(&priv->fs->arfs->arfs_lock);
-	mlx5e_for_each_arfs_rule(rule, htmp, priv->fs->arfs->arfs_tables, i, j) {
+	spin_lock_bh(&arfs->arfs_lock);
+	mlx5e_for_each_arfs_rule(rule, htmp, arfs->arfs_tables, i, j) {
 		hlist_del_init(&rule->hlist);
 		hlist_add_head(&rule->hlist, &del_list);
 	}
-	spin_unlock_bh(&priv->fs->arfs->arfs_lock);
+	spin_unlock_bh(&arfs->arfs_lock);
 
 	hlist_for_each_entry_safe(rule, htmp, &del_list, hlist) {
 		cancel_work_sync(&rule->arfs_work);
@@ -474,7 +488,7 @@ static struct arfs_table *arfs_get_table(struct mlx5e_arfs_tables *arfs,
 static struct mlx5_flow_handle *arfs_add_rule(struct mlx5e_priv *priv,
 					      struct arfs_rule *arfs_rule)
 {
-	struct mlx5e_arfs_tables *arfs = priv->fs->arfs;
+	struct mlx5e_arfs_tables *arfs = mlx5e_fs_get_arfs(priv->fs);
 	struct arfs_tuple *tuple = &arfs_rule->tuple;
 	struct mlx5_flow_handle *rule = NULL;
 	struct mlx5_flow_destination dest = {};
@@ -588,13 +602,15 @@ static void arfs_handle_work(struct work_struct *work)
 						   struct arfs_rule,
 						   arfs_work);
 	struct mlx5e_priv *priv = arfs_rule->priv;
+	struct mlx5e_arfs_tables *arfs;
 	struct mlx5_flow_handle *rule;
 
+	arfs = mlx5e_fs_get_arfs(priv->fs);
 	mutex_lock(&priv->state_lock);
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
-		spin_lock_bh(&priv->fs->arfs->arfs_lock);
+		spin_lock_bh(&arfs->arfs_lock);
 		hlist_del(&arfs_rule->hlist);
-		spin_unlock_bh(&priv->fs->arfs->arfs_lock);
+		spin_unlock_bh(&arfs->arfs_lock);
 
 		mutex_unlock(&priv->state_lock);
 		kfree(arfs_rule);
@@ -620,6 +636,7 @@ static struct arfs_rule *arfs_alloc_rule(struct mlx5e_priv *priv,
 					 const struct flow_keys *fk,
 					 u16 rxq, u32 flow_id)
 {
+	struct mlx5e_arfs_tables *arfs =  mlx5e_fs_get_arfs(priv->fs);
 	struct arfs_rule *rule;
 	struct arfs_tuple *tuple;
 
@@ -647,7 +664,7 @@ static struct arfs_rule *arfs_alloc_rule(struct mlx5e_priv *priv,
 	tuple->dst_port = fk->ports.dst;
 
 	rule->flow_id = flow_id;
-	rule->filter_id = priv->fs->arfs->last_filter_id++ % RPS_NO_FILTER;
+	rule->filter_id = arfs->last_filter_id++ % RPS_NO_FILTER;
 
 	hlist_add_head(&rule->hlist,
 		       arfs_hash_bucket(arfs_t, tuple->src_port,
@@ -691,11 +708,12 @@ int mlx5e_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 			u16 rxq_index, u32 flow_id)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct mlx5e_arfs_tables *arfs = priv->fs->arfs;
-	struct arfs_table *arfs_t;
+	struct mlx5e_arfs_tables *arfs;
 	struct arfs_rule *arfs_rule;
+	struct arfs_table *arfs_t;
 	struct flow_keys fk;
 
+	arfs =  mlx5e_fs_get_arfs(priv->fs);
 	if (!skb_flow_dissect_flow_keys(skb, &fk, 0))
 		return -EPROTONOSUPPORT;
 
@@ -725,7 +743,7 @@ int mlx5e_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 			return -ENOMEM;
 		}
 	}
-	queue_work(priv->fs->arfs->wq, &arfs_rule->arfs_work);
+	queue_work(arfs->wq, &arfs_rule->arfs_work);
 	spin_unlock_bh(&arfs->arfs_lock);
 	return arfs_rule->filter_id;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index e2a9b9be5c1f..ffcc9a94fc7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -41,6 +41,34 @@
 #include "lib/mpfs.h"
 #include "en/ptp.h"
 
+struct mlx5e_flow_steering {
+	struct work_struct		set_rx_mode_work;
+	bool				state_destroy;
+	bool				vlan_strip_disable;
+	struct mlx5_core_dev		*mdev;
+	struct net_device		*netdev;
+	struct mlx5_flow_namespace      *ns;
+	struct mlx5_flow_namespace      *egress_ns;
+#ifdef CONFIG_MLX5_EN_RXNFC
+	struct mlx5e_ethtool_steering   ethtool;
+#endif
+	struct mlx5e_tc_table           *tc;
+	struct mlx5e_promisc_table      promisc;
+	struct mlx5e_vlan_table         *vlan;
+	struct mlx5e_l2_table           l2;
+	struct mlx5_ttc_table           *ttc;
+	struct mlx5_ttc_table           *inner_ttc;
+#ifdef CONFIG_MLX5_EN_ARFS
+	struct mlx5e_arfs_tables       *arfs;
+#endif
+#ifdef CONFIG_MLX5_EN_TLS
+	struct mlx5e_accel_fs_tcp      *accel_tcp;
+#endif
+	struct mlx5e_fs_udp            *udp;
+	struct mlx5e_fs_any            *any;
+	struct mlx5e_ptp_fs            *ptp_fs;
+};
+
 static int mlx5e_add_l2_flow_rule(struct mlx5e_flow_steering *fs,
 				  struct mlx5e_l2_rule *ai, int type);
 static void mlx5e_del_l2_flow_rule(struct mlx5e_flow_steering *fs,
@@ -1267,14 +1295,14 @@ int mlx5e_create_ttc_table(struct mlx5e_priv *priv)
 
 int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 {
+	struct mlx5_flow_namespace *ns = mlx5_get_flow_namespace(priv->fs->mdev,
+								 MLX5_FLOW_NAMESPACE_KERNEL);
 	int err;
 
-	priv->fs->ns = mlx5_get_flow_namespace(priv->fs->mdev,
-					       MLX5_FLOW_NAMESPACE_KERNEL);
-
-	if (!priv->fs->ns)
+	if (!ns)
 		return -EOPNOTSUPP;
 
+	mlx5e_fs_set_ns(priv->fs, ns, false);
 	err = mlx5e_arfs_create_tables(priv);
 	if (err) {
 		mlx5_core_err(priv->fs->mdev, "Failed to create arfs tables, err=%d\n",
@@ -1356,6 +1384,11 @@ static void mlx5e_fs_vlan_free(struct mlx5e_flow_steering *fs)
 	kvfree(fs->vlan);
 }
 
+struct mlx5e_vlan_table *mlx5e_fs_get_vlan(struct mlx5e_flow_steering *fs)
+{
+	return fs->vlan;
+}
+
 static int mlx5e_fs_tc_alloc(struct mlx5e_flow_steering *fs)
 {
 	fs->tc = mlx5e_tc_table_alloc();
@@ -1369,6 +1402,11 @@ static void mlx5e_fs_tc_free(struct mlx5e_flow_steering *fs)
 	mlx5e_tc_table_free(fs->tc);
 }
 
+struct mlx5e_tc_table *mlx5e_fs_get_tc(struct mlx5e_flow_steering *fs)
+{
+	return fs->tc;
+}
+
 struct mlx5e_flow_steering *mlx5e_fs_init(const struct mlx5e_profile *profile,
 					  struct mlx5_core_dev *mdev,
 					  bool state_destroy)
@@ -1409,3 +1447,111 @@ void mlx5e_fs_cleanup(struct mlx5e_flow_steering *fs)
 	mlx5e_fs_vlan_free(fs);
 	kvfree(fs);
 }
+
+struct mlx5e_l2_table *mlx5e_fs_get_l2(struct mlx5e_flow_steering *fs)
+{
+	return &fs->l2;
+}
+
+struct mlx5_flow_namespace *mlx5e_fs_get_ns(struct mlx5e_flow_steering *fs, bool egress)
+{
+	return  egress ? fs->egress_ns : fs->ns;
+}
+
+void mlx5e_fs_set_ns(struct mlx5e_flow_steering *fs, struct mlx5_flow_namespace *ns, bool egress)
+{
+	if (!egress)
+		fs->ns = ns;
+	else
+		fs->egress_ns = ns;
+}
+
+#ifdef CONFIG_MLX5_EN_RXNFC
+struct mlx5e_ethtool_steering *mlx5e_fs_get_ethtool(struct mlx5e_flow_steering *fs)
+{
+	return &fs->ethtool;
+}
+#endif
+
+struct mlx5_ttc_table *mlx5e_fs_get_ttc(struct mlx5e_flow_steering *fs, bool inner)
+{
+	return inner ? fs->inner_ttc : fs->ttc;
+}
+
+void mlx5e_fs_set_ttc(struct mlx5e_flow_steering *fs, struct mlx5_ttc_table *ttc, bool inner)
+{
+	if (!inner)
+		fs->ttc = ttc;
+	else
+		fs->inner_ttc = ttc;
+}
+
+#ifdef CONFIG_MLX5_EN_ARFS
+struct mlx5e_arfs_tables *mlx5e_fs_get_arfs(struct mlx5e_flow_steering *fs)
+{
+	return fs->arfs;
+}
+
+void mlx5e_fs_set_arfs(struct mlx5e_flow_steering *fs, struct mlx5e_arfs_tables *arfs)
+{
+	fs->arfs = arfs;
+}
+#endif
+
+struct mlx5e_ptp_fs *mlx5e_fs_get_ptp(struct mlx5e_flow_steering *fs)
+{
+	return fs->ptp_fs;
+}
+
+void mlx5e_fs_set_ptp(struct mlx5e_flow_steering *fs, struct mlx5e_ptp_fs *ptp_fs)
+{
+	fs->ptp_fs = ptp_fs;
+}
+
+struct mlx5e_fs_any *mlx5e_fs_get_any(struct mlx5e_flow_steering *fs)
+{
+	return fs->any;
+}
+
+void mlx5e_fs_set_any(struct mlx5e_flow_steering *fs, struct mlx5e_fs_any *any)
+{
+	fs->any = any;
+}
+
+#ifdef CONFIG_MLX5_EN_TLS
+struct mlx5e_accel_fs_tcp *mlx5e_fs_get_accel_tcp(struct mlx5e_flow_steering *fs)
+{
+	return fs->accel_tcp;
+}
+
+void mlx5e_fs_set_accel_tcp(struct mlx5e_flow_steering *fs, struct mlx5e_accel_fs_tcp *accel_tcp)
+{
+	fs->accel_tcp = accel_tcp;
+}
+#endif
+
+void mlx5e_fs_set_state_destroy(struct mlx5e_flow_steering *fs, bool state_destroy)
+{
+	fs->state_destroy = state_destroy;
+}
+
+void mlx5e_fs_set_vlan_strip_disable(struct mlx5e_flow_steering *fs,
+				     bool vlan_strip_disable)
+{
+	fs->vlan_strip_disable = vlan_strip_disable;
+}
+
+struct mlx5e_fs_udp *mlx5e_fs_get_udp(struct mlx5e_flow_steering *fs)
+{
+	return fs->udp;
+}
+
+void mlx5e_fs_set_udp(struct mlx5e_flow_steering *fs, struct mlx5e_fs_udp *udp)
+{
+	fs->udp = udp;
+}
+
+struct mlx5_core_dev *mlx5e_fs_get_mdev(struct mlx5e_flow_steering *fs)
+{
+	return fs->mdev;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 3e4bc7836ef4..82c8262341bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -66,6 +66,7 @@ static struct mlx5e_ethtool_table *get_flow_table(struct mlx5e_priv *priv,
 						  struct ethtool_rx_flow_spec *fs,
 						  int num_tuples)
 {
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5e_ethtool_table *eth_ft;
 	struct mlx5_flow_namespace *ns;
@@ -81,18 +82,18 @@ static struct mlx5e_ethtool_table *get_flow_table(struct mlx5e_priv *priv,
 	case UDP_V6_FLOW:
 		max_tuples = ETHTOOL_NUM_L3_L4_FTS;
 		prio = MLX5E_ETHTOOL_L3_L4_PRIO + (max_tuples - num_tuples);
-		eth_ft = &priv->fs->ethtool.l3_l4_ft[prio];
+		eth_ft = &ethtool->l3_l4_ft[prio];
 		break;
 	case IP_USER_FLOW:
 	case IPV6_USER_FLOW:
 		max_tuples = ETHTOOL_NUM_L3_L4_FTS;
 		prio = MLX5E_ETHTOOL_L3_L4_PRIO + (max_tuples - num_tuples);
-		eth_ft = &priv->fs->ethtool.l3_l4_ft[prio];
+		eth_ft = &ethtool->l3_l4_ft[prio];
 		break;
 	case ETHER_FLOW:
 		max_tuples = ETHTOOL_NUM_L2_FTS;
 		prio = max_tuples - num_tuples;
-		eth_ft = &priv->fs->ethtool.l2_ft[prio];
+		eth_ft = &ethtool->l2_ft[prio];
 		prio += MLX5E_ETHTOOL_L2_PRIO;
 		break;
 	default:
@@ -382,15 +383,16 @@ static int set_flow_attrs(u32 *match_c, u32 *match_v,
 static void add_rule_to_list(struct mlx5e_priv *priv,
 			     struct mlx5e_ethtool_rule *rule)
 {
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
+	struct list_head *head = &ethtool->rules;
 	struct mlx5e_ethtool_rule *iter;
-	struct list_head *head = &priv->fs->ethtool.rules;
 
-	list_for_each_entry(iter, &priv->fs->ethtool.rules, list) {
+	list_for_each_entry(iter, &ethtool->rules, list) {
 		if (iter->flow_spec.location > rule->flow_spec.location)
 			break;
 		head = &iter->list;
 	}
-	priv->fs->ethtool.tot_num_rules++;
+	ethtool->tot_num_rules++;
 	list_add(&rule->list, head);
 }
 
@@ -502,12 +504,13 @@ add_ethtool_flow_rule(struct mlx5e_priv *priv,
 static void del_ethtool_rule(struct mlx5e_priv *priv,
 			     struct mlx5e_ethtool_rule *eth_rule)
 {
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
 	if (eth_rule->rule)
 		mlx5_del_flow_rules(eth_rule->rule);
 	if (eth_rule->rss)
 		mlx5e_rss_refcnt_dec(eth_rule->rss);
 	list_del(&eth_rule->list);
-	priv->fs->ethtool.tot_num_rules--;
+	ethtool->tot_num_rules--;
 	put_flow_table(eth_rule->eth_ft);
 	kfree(eth_rule);
 }
@@ -515,9 +518,10 @@ static void del_ethtool_rule(struct mlx5e_priv *priv,
 static struct mlx5e_ethtool_rule *find_ethtool_rule(struct mlx5e_priv *priv,
 						    int location)
 {
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
 	struct mlx5e_ethtool_rule *iter;
 
-	list_for_each_entry(iter, &priv->fs->ethtool.rules, list) {
+	list_for_each_entry(iter, &ethtool->rules, list) {
 		if (iter->flow_spec.location == location)
 			return iter;
 	}
@@ -783,12 +787,13 @@ static int
 mlx5e_ethtool_get_flow(struct mlx5e_priv *priv,
 		       struct ethtool_rxnfc *info, int location)
 {
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
 	struct mlx5e_ethtool_rule *eth_rule;
 
 	if (location < 0 || location >= MAX_NUM_OF_ETHTOOL_RULES)
 		return -EINVAL;
 
-	list_for_each_entry(eth_rule, &priv->fs->ethtool.rules, list) {
+	list_for_each_entry(eth_rule, &ethtool->rules, list) {
 		int index;
 
 		if (eth_rule->flow_spec.location != location)
@@ -828,16 +833,19 @@ mlx5e_ethtool_get_all_flows(struct mlx5e_priv *priv,
 
 void mlx5e_ethtool_cleanup_steering(struct mlx5e_priv *priv)
 {
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
 	struct mlx5e_ethtool_rule *iter;
 	struct mlx5e_ethtool_rule *temp;
 
-	list_for_each_entry_safe(iter, temp, &priv->fs->ethtool.rules, list)
+	list_for_each_entry_safe(iter, temp, &ethtool->rules, list)
 		del_ethtool_rule(priv, iter);
 }
 
 void mlx5e_ethtool_init_steering(struct mlx5e_priv *priv)
 {
-	INIT_LIST_HEAD(&priv->fs->ethtool.rules);
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
+
+	INIT_LIST_HEAD(&ethtool->rules);
 }
 
 static int flow_type_to_traffic_type(u32 flow_type)
@@ -959,11 +967,12 @@ int mlx5e_ethtool_set_rxnfc(struct mlx5e_priv *priv, struct ethtool_rxnfc *cmd)
 int mlx5e_ethtool_get_rxnfc(struct mlx5e_priv *priv,
 			    struct ethtool_rxnfc *info, u32 *rule_locs)
 {
+	struct mlx5e_ethtool_steering *ethtool = mlx5e_fs_get_ethtool(priv->fs);
 	int err = 0;
 
 	switch (info->cmd) {
 	case ETHTOOL_GRXCLSRLCNT:
-		info->rule_cnt = priv->fs->ethtool.tot_num_rules;
+		info->rule_cnt = ethtool->tot_num_rules;
 		break;
 	case ETHTOOL_GRXCLSRULE:
 		err = mlx5e_ethtool_get_flow(priv, info, info->fs.location);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d858667736a3..0c1ead96f591 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3778,7 +3778,7 @@ static int set_feature_rx_vlan(struct net_device *netdev, bool enable)
 
 	mutex_lock(&priv->state_lock);
 
-	priv->fs->vlan_strip_disable = !enable;
+	mlx5e_fs_set_vlan_strip_disable(priv->fs, !enable);
 	priv->channels.params.vlan_strip_disable = !enable;
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
@@ -3786,7 +3786,7 @@ static int set_feature_rx_vlan(struct net_device *netdev, bool enable)
 
 	err = mlx5e_modify_channels_vsd(&priv->channels, !enable);
 	if (err) {
-		priv->fs->vlan_strip_disable = enable;
+		mlx5e_fs_set_vlan_strip_disable(priv->fs, enable);
 		priv->channels.params.vlan_strip_disable = enable;
 	}
 unlock:
@@ -3910,12 +3910,14 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 					    netdev_features_t features)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_vlan_table *vlan;
 	struct mlx5e_params *params;
 
+	vlan = mlx5e_fs_get_vlan(priv->fs);
 	mutex_lock(&priv->state_lock);
 	params = &priv->channels.params;
-	if (!priv->fs->vlan ||
-	    !bitmap_empty(mlx5e_vlan_get_active_svlans(priv->fs->vlan), VLAN_N_VID)) {
+	if (!vlan ||
+	    !bitmap_empty(mlx5e_vlan_get_active_svlans(vlan), VLAN_N_VID)) {
 		/* HW strips the outer C-tag header, this is a problem
 		 * for S-tag traffic.
 		 */
@@ -5518,7 +5520,8 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 
 	clear_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		priv->fs->state_destroy = !test_bit(MLX5E_STATE_DESTROYING, &priv->state);
+		mlx5e_fs_set_state_destroy(priv->fs,
+					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
 
 	/* max number of channels may have changed */
 	max_nch = mlx5e_calc_max_nch(priv->mdev, priv->netdev, profile);
@@ -5579,7 +5582,8 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	mlx5e_reset_channels(priv->netdev);
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		priv->fs->state_destroy = !test_bit(MLX5E_STATE_DESTROYING, &priv->state);
+		mlx5e_fs_set_state_destroy(priv->fs,
+					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
 	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
@@ -5590,7 +5594,8 @@ void mlx5e_detach_netdev(struct mlx5e_priv *priv)
 
 	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
 	if (priv->fs)
-		priv->fs->state_destroy = !test_bit(MLX5E_STATE_DESTROYING, &priv->state);
+		mlx5e_fs_set_state_destroy(priv->fs,
+					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
 
 	if (profile->disable)
 		profile->disable(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 0c66774a1720..8ef4ad0a6ce9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -745,8 +745,9 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 	struct ttc_params ttc_params = {};
 	int err;
 
-	priv->fs->ns = mlx5_get_flow_namespace(priv->mdev,
-					       MLX5_FLOW_NAMESPACE_KERNEL);
+	mlx5e_fs_set_ns(priv->fs,
+			mlx5_get_flow_namespace(priv->mdev,
+						MLX5_FLOW_NAMESPACE_KERNEL), false);
 
 	/* The inner_ttc in the ttc params is intentionally not set */
 	mlx5e_set_ttc_params(priv, &ttc_params, false);
@@ -755,9 +756,9 @@ static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
 		/* To give uplik rep TTC a lower level for chaining from root ft */
 		ttc_params.ft_attr.level = MLX5E_TTC_FT_LEVEL + 1;
 
-	priv->fs->ttc = mlx5_create_ttc_table(priv->mdev, &ttc_params);
-	if (IS_ERR(priv->fs->ttc)) {
-		err = PTR_ERR(priv->fs->ttc);
+	mlx5e_fs_set_ttc(priv->fs, mlx5_create_ttc_table(priv->mdev, &ttc_params), false);
+	if (IS_ERR(mlx5e_fs_get_ttc(priv->fs, false))) {
+		err = PTR_ERR(mlx5e_fs_get_ttc(priv->fs, false));
 		netdev_err(priv->netdev, "Failed to create rep ttc table, err=%d\n",
 			   err);
 		return err;
@@ -777,7 +778,7 @@ static int mlx5e_create_rep_root_ft(struct mlx5e_priv *priv)
 		/* non uplik reps will skip any bypass tables and go directly to
 		 * their own ttc
 		 */
-		rpriv->root_ft = mlx5_get_ttc_flow_table(priv->fs->ttc);
+		rpriv->root_ft = mlx5_get_ttc_flow_table(mlx5e_fs_get_ttc(priv->fs, false));
 		return 0;
 	}
 
@@ -892,7 +893,7 @@ static int mlx5e_init_rep_rx(struct mlx5e_priv *priv)
 err_destroy_root_ft:
 	mlx5e_destroy_rep_root_ft(priv);
 err_destroy_ttc_table:
-	mlx5_destroy_ttc_table(priv->fs->ttc);
+	mlx5_destroy_ttc_table(mlx5e_fs_get_ttc(priv->fs, false));
 err_destroy_rx_res:
 	mlx5e_rx_res_destroy(priv->rx_res);
 err_close_drop_rq:
@@ -909,7 +910,7 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 	mlx5e_ethtool_cleanup_steering(priv);
 	rep_vport_rx_rule_destroy(priv);
 	mlx5e_destroy_rep_root_ft(priv);
-	mlx5_destroy_ttc_table(priv->fs->ttc);
+	mlx5_destroy_ttc_table(mlx5e_fs_get_ttc(priv->fs, false));
 	mlx5e_rx_res_destroy(priv->rx_res);
 	mlx5e_close_drop_rq(&priv->drop_rq);
 	mlx5e_rx_res_free(priv->rx_res);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f154bda668ad..0b98e117cc0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -311,6 +311,7 @@ mlx5e_get_flow_meters(struct mlx5_core_dev *dev)
 static struct mlx5_tc_ct_priv *
 get_ct_priv(struct mlx5e_priv *priv)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *uplink_rpriv;
@@ -322,7 +323,7 @@ get_ct_priv(struct mlx5e_priv *priv)
 		return uplink_priv->ct_priv;
 	}
 
-	return priv->fs->tc->ct;
+	return tc->ct;
 }
 
 static struct mlx5e_tc_psample *
@@ -345,6 +346,7 @@ get_sample_priv(struct mlx5e_priv *priv)
 static struct mlx5e_post_act *
 get_post_action(struct mlx5e_priv *priv)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *uplink_rpriv;
@@ -356,7 +358,7 @@ get_post_action(struct mlx5e_priv *priv)
 		return uplink_priv->post_act;
 	}
 
-	return priv->fs->tc->post_act;
+	return tc->post_act;
 }
 
 struct mlx5_flow_handle *
@@ -607,11 +609,12 @@ int mlx5e_get_flow_namespace(struct mlx5e_tc_flow *flow)
 static struct mod_hdr_tbl *
 get_mod_hdr_table(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 
 	return mlx5e_get_flow_namespace(flow) == MLX5_FLOW_NAMESPACE_FDB ?
 		&esw->offloads.mod_hdr :
-		&priv->fs->tc->mod_hdr;
+		&tc->mod_hdr;
 }
 
 static int mlx5e_attach_mod_hdr(struct mlx5e_priv *priv,
@@ -810,6 +813,7 @@ static int mlx5e_hairpin_rss_init(struct mlx5e_hairpin *hp)
 {
 	struct mlx5e_priv *priv = hp->func_priv;
 	struct ttc_params ttc_params;
+	struct mlx5_ttc_table *ttc;
 	int err;
 
 	err = mlx5e_hairpin_create_indirect_rqt(hp);
@@ -827,9 +831,10 @@ static int mlx5e_hairpin_rss_init(struct mlx5e_hairpin *hp)
 		goto err_create_ttc_table;
 	}
 
+	ttc = mlx5e_fs_get_ttc(priv->fs, false);
 	netdev_dbg(priv->netdev, "add hairpin: using %d channels rss ttc table id %x\n",
 		   hp->num_channels,
-		   mlx5_get_ttc_flow_table(priv->fs->ttc)->id);
+		   mlx5_get_ttc_flow_table(ttc)->id);
 
 	return 0;
 
@@ -916,10 +921,11 @@ static inline u32 hash_hairpin_info(u16 peer_vhca_id, u8 prio)
 static struct mlx5e_hairpin_entry *mlx5e_hairpin_get(struct mlx5e_priv *priv,
 						     u16 peer_vhca_id, u8 prio)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	struct mlx5e_hairpin_entry *hpe;
 	u32 hash_key = hash_hairpin_info(peer_vhca_id, prio);
 
-	hash_for_each_possible(priv->fs->tc->hairpin_tbl, hpe,
+	hash_for_each_possible(tc->hairpin_tbl, hpe,
 			       hairpin_hlist, hash_key) {
 		if (hpe->peer_vhca_id == peer_vhca_id && hpe->prio == prio) {
 			refcount_inc(&hpe->refcnt);
@@ -933,11 +939,12 @@ static struct mlx5e_hairpin_entry *mlx5e_hairpin_get(struct mlx5e_priv *priv,
 static void mlx5e_hairpin_put(struct mlx5e_priv *priv,
 			      struct mlx5e_hairpin_entry *hpe)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	/* no more hairpin flows for us, release the hairpin pair */
-	if (!refcount_dec_and_mutex_lock(&hpe->refcnt, &priv->fs->tc->hairpin_tbl_lock))
+	if (!refcount_dec_and_mutex_lock(&hpe->refcnt, &tc->hairpin_tbl_lock))
 		return;
 	hash_del(&hpe->hairpin_hlist);
-	mutex_unlock(&priv->fs->tc->hairpin_tbl_lock);
+	mutex_unlock(&tc->hairpin_tbl_lock);
 
 	if (!IS_ERR_OR_NULL(hpe->hp)) {
 		netdev_dbg(priv->netdev, "del hairpin: peer %s\n",
@@ -993,6 +1000,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow_parse_attr *parse_attr,
 				  struct netlink_ext_ack *extack)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	int peer_ifindex = parse_attr->mirred_ifindex[0];
 	struct mlx5_hairpin_params params;
 	struct mlx5_core_dev *peer_mdev;
@@ -1021,10 +1029,10 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	mutex_lock(&priv->fs->tc->hairpin_tbl_lock);
+	mutex_lock(&tc->hairpin_tbl_lock);
 	hpe = mlx5e_hairpin_get(priv, peer_id, match_prio);
 	if (hpe) {
-		mutex_unlock(&priv->fs->tc->hairpin_tbl_lock);
+		mutex_unlock(&tc->hairpin_tbl_lock);
 		wait_for_completion(&hpe->res_ready);
 
 		if (IS_ERR(hpe->hp)) {
@@ -1036,7 +1044,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 
 	hpe = kzalloc(sizeof(*hpe), GFP_KERNEL);
 	if (!hpe) {
-		mutex_unlock(&priv->fs->tc->hairpin_tbl_lock);
+		mutex_unlock(&tc->hairpin_tbl_lock);
 		return -ENOMEM;
 	}
 
@@ -1048,9 +1056,9 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 	refcount_set(&hpe->refcnt, 1);
 	init_completion(&hpe->res_ready);
 
-	hash_add(priv->fs->tc->hairpin_tbl, &hpe->hairpin_hlist,
+	hash_add(tc->hairpin_tbl, &hpe->hairpin_hlist,
 		 hash_hairpin_info(peer_id, match_prio));
-	mutex_unlock(&priv->fs->tc->hairpin_tbl_lock);
+	mutex_unlock(&tc->hairpin_tbl_lock);
 
 	params.log_data_size = 16;
 	params.log_data_size = min_t(u8, params.log_data_size,
@@ -1126,8 +1134,9 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			     struct mlx5_flow_attr *attr)
 {
 	struct mlx5_flow_context *flow_context = &spec->flow_context;
+	struct mlx5e_vlan_table *vlan = mlx5e_fs_get_vlan(priv->fs);
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	struct mlx5_nic_flow_attr *nic_attr = attr->nic_attr;
-	struct mlx5e_tc_table *tc = priv->fs->tc;
 	struct mlx5_flow_destination dest[2] = {};
 	struct mlx5_fs_chains *nic_chains;
 	struct mlx5_flow_act flow_act = {
@@ -1163,7 +1172,7 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			if (IS_ERR(dest[dest_ix].ft))
 				return ERR_CAST(dest[dest_ix].ft);
 		} else {
-			dest[dest_ix].ft = mlx5e_vlan_get_flowtable(priv->fs->vlan);
+			dest[dest_ix].ft = mlx5e_vlan_get_flowtable(vlan);
 		}
 		dest_ix++;
 	}
@@ -1191,7 +1200,7 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 			mutex_unlock(&tc->t_lock);
 			netdev_err(priv->netdev,
 				   "Failed to create tc offload table\n");
-			rule = ERR_CAST(priv->fs->tc->t);
+			rule = ERR_CAST(tc->t);
 			goto err_ft_get;
 		}
 	}
@@ -1293,8 +1302,10 @@ void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
 				  struct mlx5_flow_handle *rule,
 				  struct mlx5_flow_attr *attr)
 {
-	struct mlx5_fs_chains *nic_chains = mlx5e_nic_chains(priv->fs->tc);
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
+	struct mlx5_fs_chains *nic_chains;
 
+	nic_chains = mlx5e_nic_chains(tc);
 	mlx5_del_flow_rules(rule);
 
 	if (attr->chain || attr->prio)
@@ -1309,8 +1320,8 @@ void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	struct mlx5_flow_attr *attr = flow->attr;
-	struct mlx5e_tc_table *tc = priv->fs->tc;
 
 	flow_flag_clear(flow, OFFLOADED);
 
@@ -1322,13 +1333,13 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	/* Remove root table if no rules are left to avoid
 	 * extra steering hops.
 	 */
-	mutex_lock(&priv->fs->tc->t_lock);
+	mutex_lock(&tc->t_lock);
 	if (!mlx5e_tc_num_filters(priv, MLX5_TC_FLAG(NIC_OFFLOAD)) &&
 	    !IS_ERR_OR_NULL(tc->t)) {
 		mlx5_chains_put_table(mlx5e_nic_chains(tc), 0, 1, MLX5E_TC_FT_LEVEL);
-		priv->fs->tc->t = NULL;
+		tc->t = NULL;
 	}
-	mutex_unlock(&priv->fs->tc->t_lock);
+	mutex_unlock(&tc->t_lock);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_detach_mod_hdr(priv, flow);
@@ -4058,13 +4069,14 @@ static const struct rhashtable_params tc_ht_params = {
 static struct rhashtable *get_tc_ht(struct mlx5e_priv *priv,
 				    unsigned long flags)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	struct mlx5e_rep_priv *rpriv;
 
 	if (flags & MLX5_TC_FLAG(ESW_OFFLOAD)) {
 		rpriv = priv->ppriv;
 		return &rpriv->tc_ht;
 	} else /* NIC offload */
-		return &priv->fs->tc->ht;
+		return &tc->ht;
 }
 
 static bool is_peer_flow_needed(struct mlx5e_tc_flow *flow)
@@ -4772,6 +4784,7 @@ void mlx5e_tc_stats_matchall(struct mlx5e_priv *priv,
 static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
 					      struct mlx5e_priv *peer_priv)
 {
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	struct mlx5_core_dev *peer_mdev = peer_priv->mdev;
 	struct mlx5e_hairpin_entry *hpe, *tmp;
 	LIST_HEAD(init_wait_list);
@@ -4783,11 +4796,11 @@ static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
 
 	peer_vhca_id = MLX5_CAP_GEN(peer_mdev, vhca_id);
 
-	mutex_lock(&priv->fs->tc->hairpin_tbl_lock);
-	hash_for_each(priv->fs->tc->hairpin_tbl, bkt, hpe, hairpin_hlist)
+	mutex_lock(&tc->hairpin_tbl_lock);
+	hash_for_each(tc->hairpin_tbl, bkt, hpe, hairpin_hlist)
 		if (refcount_inc_not_zero(&hpe->refcnt))
 			list_add(&hpe->dead_peer_wait_list, &init_wait_list);
-	mutex_unlock(&priv->fs->tc->hairpin_tbl_lock);
+	mutex_unlock(&tc->hairpin_tbl_lock);
 
 	list_for_each_entry_safe(hpe, tmp, &init_wait_list, dead_peer_wait_list) {
 		wait_for_completion(&hpe->res_ready);
@@ -4841,7 +4854,8 @@ static int mlx5e_tc_nic_get_ft_size(struct mlx5_core_dev *dev)
 
 static int mlx5e_tc_nic_create_miss_table(struct mlx5e_priv *priv)
 {
-	struct mlx5_flow_table **ft = &priv->fs->tc->miss_t;
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
+	struct mlx5_flow_table **ft = &tc->miss_t;
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_namespace *ns;
 	int err = 0;
@@ -4863,12 +4877,14 @@ static int mlx5e_tc_nic_create_miss_table(struct mlx5e_priv *priv)
 
 static void mlx5e_tc_nic_destroy_miss_table(struct mlx5e_priv *priv)
 {
-	mlx5_destroy_flow_table(priv->fs->tc->miss_t);
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
+
+	mlx5_destroy_flow_table(tc->miss_t);
 }
 
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 {
-	struct mlx5e_tc_table *tc = priv->fs->tc;
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 	struct mlx5_core_dev *dev = priv->mdev;
 	struct mapping_ctx *chains_mapping;
 	struct mlx5_chains_attr attr = {};
@@ -4909,7 +4925,7 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
 	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
 	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
-	attr.default_ft = priv->fs->tc->miss_t;
+	attr.default_ft = tc->miss_t;
 	attr.mapping = chains_mapping;
 
 	tc->chains = mlx5_chains_create(dev, &attr);
@@ -4958,7 +4974,7 @@ static void _mlx5e_tc_del_flow(void *ptr, void *arg)
 
 void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 {
-	struct mlx5e_tc_table *tc = priv->fs->tc;
+	struct mlx5e_tc_table *tc = mlx5e_fs_get_tc(priv->fs);
 
 	if (tc->netdevice_nb.notifier_call)
 		unregister_netdevice_notifier_dev_net(priv->netdev,
@@ -5163,13 +5179,13 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
-	struct mlx5e_tc_table *tc = priv->fs->tc;
 	struct mlx5_mapped_obj mapped_obj;
 	struct tc_skb_ext *tc_skb_ext;
+	struct mlx5e_tc_table *tc;
 	int err;
 
 	reg_b = be32_to_cpu(cqe->ft_metadata);
-
+	tc = mlx5e_fs_get_tc(priv->fs);
 	chain_tag = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
 
 	err = mapping_find(tc->mapping, chain_tag, &mapped_obj);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 6ce1ab6b86b7..48241317a535 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -54,6 +54,7 @@
 			    ESW_FLOW_ATTR_SZ :\
 			    NIC_FLOW_ATTR_SZ)
 
+struct mlx5_fs_chains *mlx5e_nic_chains(struct mlx5e_tc_table *tc);
 int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
 
 struct mlx5e_tc_update_priv {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index c02b7b08fb4c..039a7be1eb0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -320,14 +320,16 @@ static void mlx5i_cleanup_tx(struct mlx5e_priv *priv)
 
 static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 {
+	struct mlx5_flow_namespace *ns =
+		mlx5_get_flow_namespace(priv->mdev, MLX5_FLOW_NAMESPACE_KERNEL);
 	int err;
 
-	priv->fs->ns = mlx5_get_flow_namespace(priv->mdev,
-					       MLX5_FLOW_NAMESPACE_KERNEL);
 
-	if (!priv->fs->ns)
+	if (!ns)
 		return -EINVAL;
 
+	mlx5e_fs_set_ns(priv->fs, ns, false);
+
 	err = mlx5e_arfs_create_tables(priv);
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create arfs tables, err=%d\n",
-- 
2.37.1

