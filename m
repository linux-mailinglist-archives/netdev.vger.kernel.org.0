Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353356B8DFA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCNI7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjCNI7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1969662E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41D5361662
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C39C433EF;
        Tue, 14 Mar 2023 08:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784362;
        bh=jmm/CjYUVQ6rVSHprGxFgOJsKsOMencMJA80B9QAfuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lg5gXNLv5OxE4F5lGHvhwxN5M9c24WctlSiae2QXdC/QAxzt1VjOwDlKmwVgkdedo
         mBvAAyQIqhlRanFnQCZGrHvo2aySZbVl7nLV4NpDrcxuC6sg8HpE6RrvgxnZvgEBoO
         GC7MtCHjKFyE5FRbHKg43u2RKkXG7SlJw2U5POZ1ngxXuYzJDLzyX6MXNvHlIc3GVX
         RZfh+w2Mg7GzW5Hjr9L0XD4VhW8i2skng1MaOLsRFEPZzSiCLSKCebcNeGhqswGDfM
         MbsVcWByPfw/KkrhGGZYbX87rOw4YuVEc20W3hfIg+7TTiCSsZu5wwLvLNlMekH3JX
         QzZXxoZr4E/hQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Paul Blakey <paulb@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next 3/9] net/mlx5e: Use chains for IPsec policy priority offload
Date:   Tue, 14 Mar 2023 10:58:38 +0200
Message-Id: <9ef3ef88858217932696ad413b1b147b799a11be.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
References: <cover.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Currently, policy priority field is ignored and so order
of matching is unpredictable.

Use chains for RX/TX policy offload to support the
priority field.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  18 +-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   2 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 362 ++++++++++++++----
 .../mlx5/core/en_accel/ipsec_offload.c        |  17 +-
 4 files changed, 315 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7b0d3de0ec6c..83012bece548 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -499,7 +499,8 @@ static void mlx5e_xfrm_update_curlft(struct xfrm_state *x)
 	mlx5e_ipsec_aso_update_curlft(sa_entry, &x->curlft.packets);
 }
 
-static int mlx5e_xfrm_validate_policy(struct xfrm_policy *x,
+static int mlx5e_xfrm_validate_policy(struct mlx5_core_dev *mdev,
+				      struct xfrm_policy *x,
 				      struct netlink_ext_ack *extack)
 {
 	if (x->type != XFRM_POLICY_TYPE_MAIN) {
@@ -535,6 +536,18 @@ static int mlx5e_xfrm_validate_policy(struct xfrm_policy *x,
 		return -EINVAL;
 	}
 
+	if (x->priority) {
+		if (!(mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_PRIO)) {
+			NL_SET_ERR_MSG_MOD(extack, "Device does not support policy priority");
+			return -EINVAL;
+		}
+
+		if (x->priority == U32_MAX) {
+			NL_SET_ERR_MSG_MOD(extack, "Device does not support requested policy priority");
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -560,6 +573,7 @@ mlx5e_ipsec_build_accel_pol_attrs(struct mlx5e_ipsec_pol_entry *pol_entry,
 	attrs->upspec.sport = ntohs(sel->sport);
 	attrs->upspec.sport_mask = ntohs(sel->sport_mask);
 	attrs->upspec.proto = sel->proto;
+	attrs->prio = x->priority;
 }
 
 static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
@@ -576,7 +590,7 @@ static int mlx5e_xfrm_add_policy(struct xfrm_policy *x,
 		return -EOPNOTSUPP;
 	}
 
-	err = mlx5e_xfrm_validate_policy(x, extack);
+	err = mlx5e_xfrm_validate_policy(priv->mdev, x, extack);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 12f044330639..b36e047396da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -94,6 +94,7 @@ enum mlx5_ipsec_cap {
 	MLX5_IPSEC_CAP_ESN		= 1 << 1,
 	MLX5_IPSEC_CAP_PACKET_OFFLOAD	= 1 << 2,
 	MLX5_IPSEC_CAP_ROCE             = 1 << 3,
+	MLX5_IPSEC_CAP_PRIO             = 1 << 4,
 };
 
 struct mlx5e_priv;
@@ -198,6 +199,7 @@ struct mlx5_accel_pol_xfrm_attrs {
 	u8 type : 2;
 	u8 dir : 2;
 	u32 reqid;
+	u32 prio;
 };
 
 struct mlx5e_ipsec_pol_entry {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 9871ba1b25ff..0c9640d575a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -7,6 +7,7 @@
 #include "ipsec.h"
 #include "fs_core.h"
 #include "lib/ipsec_fs_roce.h"
+#include "lib/fs_chains.h"
 
 #define NUM_IPSEC_FTE BIT(15)
 
@@ -34,6 +35,7 @@ struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_miss sa;
 	struct mlx5e_ipsec_rule status;
 	struct mlx5e_ipsec_fc *fc;
+	struct mlx5_fs_chains *chains;
 };
 
 struct mlx5e_ipsec_tx {
@@ -41,6 +43,7 @@ struct mlx5e_ipsec_tx {
 	struct mlx5e_ipsec_miss pol;
 	struct mlx5_flow_namespace *ns;
 	struct mlx5e_ipsec_fc *fc;
+	struct mlx5_fs_chains *chains;
 };
 
 /* IPsec RX flow steering */
@@ -51,6 +54,67 @@ static enum mlx5_traffic_types family2tt(u32 family)
 	return MLX5_TT_IPV6_IPSEC_ESP;
 }
 
+static struct mlx5e_ipsec_rx *ipsec_rx(struct mlx5e_ipsec *ipsec, u32 family)
+{
+	if (family == AF_INET)
+		return ipsec->rx_ipv4;
+
+	return ipsec->rx_ipv6;
+}
+
+static struct mlx5_fs_chains *
+ipsec_chains_create(struct mlx5_core_dev *mdev, struct mlx5_flow_table *miss_ft,
+		    enum mlx5_flow_namespace_type ns, int base_prio,
+		    int base_level, struct mlx5_flow_table **root_ft)
+{
+	struct mlx5_chains_attr attr = {};
+	struct mlx5_fs_chains *chains;
+	struct mlx5_flow_table *ft;
+	int err;
+
+	attr.flags = MLX5_CHAINS_AND_PRIOS_SUPPORTED |
+		     MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
+	attr.max_grp_num = 2;
+	attr.default_ft = miss_ft;
+	attr.ns = ns;
+	attr.fs_base_prio = base_prio;
+	attr.fs_base_level = base_level;
+	chains = mlx5_chains_create(mdev, &attr);
+	if (IS_ERR(chains))
+		return chains;
+
+	/* Create chain 0, prio 1, level 0 to connect chains to prev in fs_core */
+	ft = mlx5_chains_get_table(chains, 0, 1, 0);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_chains_get;
+	}
+
+	*root_ft = ft;
+	return chains;
+
+err_chains_get:
+	mlx5_chains_destroy(chains);
+	return ERR_PTR(err);
+}
+
+static void ipsec_chains_destroy(struct mlx5_fs_chains *chains)
+{
+	mlx5_chains_put_table(chains, 0, 1, 0);
+	mlx5_chains_destroy(chains);
+}
+
+static struct mlx5_flow_table *
+ipsec_chains_get_table(struct mlx5_fs_chains *chains, u32 prio)
+{
+	return mlx5_chains_get_table(chains, 0, prio + 1, 0);
+}
+
+static void ipsec_chains_put_table(struct mlx5_fs_chains *chains, u32 prio)
+{
+	mlx5_chains_put_table(chains, 0, prio + 1, 0);
+}
+
 static struct mlx5_flow_table *ipsec_ft_create(struct mlx5_flow_namespace *ns,
 					       int level, int prio,
 					       int max_num_groups)
@@ -170,9 +234,18 @@ static int ipsec_miss_create(struct mlx5_core_dev *mdev,
 static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		       struct mlx5e_ipsec_rx *rx, u32 family)
 {
-	mlx5_del_flow_rules(rx->pol.rule);
-	mlx5_destroy_flow_group(rx->pol.group);
-	mlx5_destroy_flow_table(rx->ft.pol);
+	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
+
+	/* disconnect */
+	mlx5_ttc_fwd_default_dest(ttc, family2tt(family));
+
+	if (rx->chains) {
+		ipsec_chains_destroy(rx->chains);
+	} else {
+		mlx5_del_flow_rules(rx->pol.rule);
+		mlx5_destroy_flow_group(rx->pol.group);
+		mlx5_destroy_flow_table(rx->ft.pol);
+	}
 
 	mlx5_del_flow_rules(rx->sa.rule);
 	mlx5_destroy_flow_group(rx->sa.group);
@@ -238,6 +311,20 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (err)
 		goto err_fs;
 
+	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_PRIO) {
+		rx->chains = ipsec_chains_create(mdev, rx->ft.sa,
+						 MLX5_FLOW_NAMESPACE_KERNEL,
+						 MLX5E_NIC_PRIO,
+						 MLX5E_ACCEL_FS_POL_FT_LEVEL,
+						 &rx->ft.pol);
+		if (IS_ERR(rx->chains)) {
+			err = PTR_ERR(rx->chains);
+			goto err_pol_ft;
+		}
+
+		goto connect;
+	}
+
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_POL_FT_LEVEL, MLX5E_NIC_PRIO,
 			     2);
 	if (IS_ERR(ft)) {
@@ -252,6 +339,12 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	if (err)
 		goto err_pol_miss;
 
+connect:
+	/* connect */
+	memset(dest, 0x00, sizeof(*dest));
+	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[0].ft = rx->ft.pol;
+	mlx5_ttc_fwd_dest(ttc, family2tt(family), &dest[0]);
 	return 0;
 
 err_pol_miss:
@@ -271,69 +364,112 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	return err;
 }
 
-static struct mlx5e_ipsec_rx *rx_ft_get(struct mlx5_core_dev *mdev,
-					struct mlx5e_ipsec *ipsec, u32 family)
+static int rx_get(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
+		  struct mlx5e_ipsec_rx *rx, u32 family)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
-	struct mlx5_flow_destination dest = {};
-	struct mlx5e_ipsec_rx *rx;
-	int err = 0;
-
-	if (family == AF_INET)
-		rx = ipsec->rx_ipv4;
-	else
-		rx = ipsec->rx_ipv6;
+	int err;
 
-	mutex_lock(&rx->ft.mutex);
 	if (rx->ft.refcnt)
 		goto skip;
 
-	/* create FT */
 	err = rx_create(mdev, ipsec, rx, family);
 	if (err)
-		goto out;
-
-	/* connect */
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = rx->ft.pol;
-	mlx5_ttc_fwd_dest(ttc, family2tt(family), &dest);
+		return err;
 
 skip:
 	rx->ft.refcnt++;
-out:
+	return 0;
+}
+
+static void rx_put(struct mlx5e_ipsec *ipsec, struct mlx5e_ipsec_rx *rx,
+		   u32 family)
+{
+	if (--rx->ft.refcnt)
+		return;
+
+	rx_destroy(ipsec->mdev, ipsec, rx, family);
+}
+
+static struct mlx5e_ipsec_rx *rx_ft_get(struct mlx5_core_dev *mdev,
+					struct mlx5e_ipsec *ipsec, u32 family)
+{
+	struct mlx5e_ipsec_rx *rx = ipsec_rx(ipsec, family);
+	int err;
+
+	mutex_lock(&rx->ft.mutex);
+	err = rx_get(mdev, ipsec, rx, family);
 	mutex_unlock(&rx->ft.mutex);
 	if (err)
 		return ERR_PTR(err);
+
 	return rx;
 }
 
-static void rx_ft_put(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
-		      u32 family)
+static struct mlx5_flow_table *rx_ft_get_policy(struct mlx5_core_dev *mdev,
+						struct mlx5e_ipsec *ipsec,
+						u32 family, u32 prio)
 {
-	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
-	struct mlx5e_ipsec_rx *rx;
+	struct mlx5e_ipsec_rx *rx = ipsec_rx(ipsec, family);
+	struct mlx5_flow_table *ft;
+	int err;
 
-	if (family == AF_INET)
-		rx = ipsec->rx_ipv4;
-	else
-		rx = ipsec->rx_ipv6;
+	mutex_lock(&rx->ft.mutex);
+	err = rx_get(mdev, ipsec, rx, family);
+	if (err)
+		goto err_get;
+
+	ft = rx->chains ? ipsec_chains_get_table(rx->chains, prio) : rx->ft.pol;
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_get_ft;
+	}
+
+	mutex_unlock(&rx->ft.mutex);
+	return ft;
+
+err_get_ft:
+	rx_put(ipsec, rx, family);
+err_get:
+	mutex_unlock(&rx->ft.mutex);
+	return ERR_PTR(err);
+}
+
+static void rx_ft_put(struct mlx5e_ipsec *ipsec, u32 family)
+{
+	struct mlx5e_ipsec_rx *rx = ipsec_rx(ipsec, family);
 
 	mutex_lock(&rx->ft.mutex);
-	rx->ft.refcnt--;
-	if (rx->ft.refcnt)
-		goto out;
+	rx_put(ipsec, rx, family);
+	mutex_unlock(&rx->ft.mutex);
+}
 
-	/* disconnect */
-	mlx5_ttc_fwd_default_dest(ttc, family2tt(family));
+static void rx_ft_put_policy(struct mlx5e_ipsec *ipsec, u32 family, u32 prio)
+{
+	struct mlx5e_ipsec_rx *rx = ipsec_rx(ipsec, family);
 
-	/* remove FT */
-	rx_destroy(mdev, ipsec, rx, family);
+	mutex_lock(&rx->ft.mutex);
+	if (rx->chains)
+		ipsec_chains_put_table(rx->chains, prio);
 
-out:
+	rx_put(ipsec, rx, family);
 	mutex_unlock(&rx->ft.mutex);
 }
 
 /* IPsec TX flow steering */
+static void tx_destroy(struct mlx5e_ipsec_tx *tx, struct mlx5_ipsec_fs *roce)
+{
+	mlx5_ipsec_fs_roce_tx_destroy(roce);
+	if (tx->chains) {
+		ipsec_chains_destroy(tx->chains);
+	} else {
+		mlx5_del_flow_rules(tx->pol.rule);
+		mlx5_destroy_flow_group(tx->pol.group);
+		mlx5_destroy_flow_table(tx->ft.pol);
+	}
+
+	mlx5_destroy_flow_table(tx->ft.sa);
+}
+
 static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 		     struct mlx5_ipsec_fs *roce)
 {
@@ -347,6 +483,18 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 
 	tx->ft.sa = ft;
 
+	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_PRIO) {
+		tx->chains = ipsec_chains_create(
+			mdev, tx->ft.sa, MLX5_FLOW_NAMESPACE_EGRESS_IPSEC, 0, 0,
+			&tx->ft.pol);
+		if (IS_ERR(tx->chains)) {
+			err = PTR_ERR(tx->chains);
+			goto err_pol_ft;
+		}
+
+		goto connect_roce;
+	}
+
 	ft = ipsec_ft_create(tx->ns, 0, 0, 2);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
@@ -356,44 +504,96 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = tx->ft.sa;
 	err = ipsec_miss_create(mdev, tx->ft.pol, &tx->pol, &dest);
-	if (err)
-		goto err_pol_miss;
+	if (err) {
+		mlx5_destroy_flow_table(tx->ft.pol);
+		goto err_pol_ft;
+	}
 
+connect_roce:
 	err = mlx5_ipsec_fs_roce_tx_create(mdev, roce, tx->ft.pol);
 	if (err)
 		goto err_roce;
 	return 0;
 
 err_roce:
-	mlx5_del_flow_rules(tx->pol.rule);
-	mlx5_destroy_flow_group(tx->pol.group);
-err_pol_miss:
-	mlx5_destroy_flow_table(tx->ft.pol);
+	if (tx->chains) {
+		ipsec_chains_destroy(tx->chains);
+	} else {
+		mlx5_del_flow_rules(tx->pol.rule);
+		mlx5_destroy_flow_group(tx->pol.group);
+		mlx5_destroy_flow_table(tx->ft.pol);
+	}
 err_pol_ft:
 	mlx5_destroy_flow_table(tx->ft.sa);
 	return err;
 }
 
-static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5_core_dev *mdev,
-					struct mlx5e_ipsec *ipsec)
+static int tx_get(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
+		  struct mlx5e_ipsec_tx *tx)
 {
-	struct mlx5e_ipsec_tx *tx = ipsec->tx;
-	int err = 0;
+	int err;
 
-	mutex_lock(&tx->ft.mutex);
 	if (tx->ft.refcnt)
 		goto skip;
 
 	err = tx_create(mdev, tx, ipsec->roce);
 	if (err)
-		goto out;
+		return err;
 
 skip:
 	tx->ft.refcnt++;
-out:
+	return 0;
+}
+
+static void tx_put(struct mlx5e_ipsec *ipsec, struct mlx5e_ipsec_tx *tx)
+{
+	if (--tx->ft.refcnt)
+		return;
+
+	tx_destroy(tx, ipsec->roce);
+}
+
+static struct mlx5_flow_table *tx_ft_get_policy(struct mlx5_core_dev *mdev,
+						struct mlx5e_ipsec *ipsec,
+						u32 prio)
+{
+	struct mlx5e_ipsec_tx *tx = ipsec->tx;
+	struct mlx5_flow_table *ft;
+	int err;
+
+	mutex_lock(&tx->ft.mutex);
+	err = tx_get(mdev, ipsec, tx);
+	if (err)
+		goto err_get;
+
+	ft = tx->chains ? ipsec_chains_get_table(tx->chains, prio) : tx->ft.pol;
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_get_ft;
+	}
+
+	mutex_unlock(&tx->ft.mutex);
+	return ft;
+
+err_get_ft:
+	tx_put(ipsec, tx);
+err_get:
+	mutex_unlock(&tx->ft.mutex);
+	return ERR_PTR(err);
+}
+
+static struct mlx5e_ipsec_tx *tx_ft_get(struct mlx5_core_dev *mdev,
+					struct mlx5e_ipsec *ipsec)
+{
+	struct mlx5e_ipsec_tx *tx = ipsec->tx;
+	int err;
+
+	mutex_lock(&tx->ft.mutex);
+	err = tx_get(mdev, ipsec, tx);
 	mutex_unlock(&tx->ft.mutex);
 	if (err)
 		return ERR_PTR(err);
+
 	return tx;
 }
 
@@ -402,16 +602,19 @@ static void tx_ft_put(struct mlx5e_ipsec *ipsec)
 	struct mlx5e_ipsec_tx *tx = ipsec->tx;
 
 	mutex_lock(&tx->ft.mutex);
-	tx->ft.refcnt--;
-	if (tx->ft.refcnt)
-		goto out;
+	tx_put(ipsec, tx);
+	mutex_unlock(&tx->ft.mutex);
+}
 
-	mlx5_ipsec_fs_roce_tx_destroy(ipsec->roce);
-	mlx5_del_flow_rules(tx->pol.rule);
-	mlx5_destroy_flow_group(tx->pol.group);
-	mlx5_destroy_flow_table(tx->ft.pol);
-	mlx5_destroy_flow_table(tx->ft.sa);
-out:
+static void tx_ft_put_policy(struct mlx5e_ipsec *ipsec, u32 prio)
+{
+	struct mlx5e_ipsec_tx *tx = ipsec->tx;
+
+	mutex_lock(&tx->ft.mutex);
+	if (tx->chains)
+		ipsec_chains_put_table(tx->chains, prio);
+
+	tx_put(ipsec, tx);
 	mutex_unlock(&tx->ft.mutex);
 }
 
@@ -676,7 +879,7 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 err_mod_header:
 	kvfree(spec);
 err_alloc:
-	rx_ft_put(mdev, ipsec, attrs->family);
+	rx_ft_put(ipsec, attrs->family);
 	return err;
 }
 
@@ -690,7 +893,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_ipsec_tx *tx;
-	int err = 0;
+	int err;
 
 	tx = tx_ft_get(mdev, ipsec);
 	if (IS_ERR(tx))
@@ -760,16 +963,17 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 {
 	struct mlx5_accel_pol_xfrm_attrs *attrs = &pol_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_pol2dev(pol_entry);
+	struct mlx5e_ipsec_tx *tx = pol_entry->ipsec->tx;
 	struct mlx5_flow_destination dest[2] = {};
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
-	struct mlx5e_ipsec_tx *tx;
+	struct mlx5_flow_table *ft;
 	int err, dstn = 0;
 
-	tx = tx_ft_get(mdev, pol_entry->ipsec);
-	if (IS_ERR(tx))
-		return PTR_ERR(tx);
+	ft = tx_ft_get_policy(mdev, pol_entry->ipsec, attrs->prio);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
@@ -811,7 +1015,7 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	dest[dstn].ft = tx->ft.sa;
 	dest[dstn].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dstn++;
-	rule = mlx5_add_flow_rules(tx->ft.pol, spec, &flow_act, dest, dstn);
+	rule = mlx5_add_flow_rules(ft, spec, &flow_act, dest, dstn);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "fail to add TX ipsec rule err=%d\n", err);
@@ -828,7 +1032,7 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 err_mod_header:
 	kvfree(spec);
 err_alloc:
-	tx_ft_put(pol_entry->ipsec);
+	tx_ft_put_policy(pol_entry->ipsec, attrs->prio);
 	return err;
 }
 
@@ -840,12 +1044,15 @@ static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
+	struct mlx5_flow_table *ft;
 	struct mlx5e_ipsec_rx *rx;
 	int err, dstn = 0;
 
-	rx = rx_ft_get(mdev, pol_entry->ipsec, attrs->family);
-	if (IS_ERR(rx))
-		return PTR_ERR(rx);
+	ft = rx_ft_get_policy(mdev, pol_entry->ipsec, attrs->family, attrs->prio);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
+
+	rx = ipsec_rx(pol_entry->ipsec, attrs->family);
 
 	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec) {
@@ -880,7 +1087,7 @@ static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	dest[dstn].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[dstn].ft = rx->ft.sa;
 	dstn++;
-	rule = mlx5_add_flow_rules(rx->ft.pol, spec, &flow_act, dest, dstn);
+	rule = mlx5_add_flow_rules(ft, spec, &flow_act, dest, dstn);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "Fail to add RX IPsec policy rule err=%d\n", err);
@@ -894,7 +1101,7 @@ static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 err_action:
 	kvfree(spec);
 err_alloc:
-	rx_ft_put(mdev, pol_entry->ipsec, attrs->family);
+	rx_ft_put_policy(pol_entry->ipsec, attrs->family, attrs->prio);
 	return err;
 }
 
@@ -1032,7 +1239,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	}
 
 	mlx5_modify_header_dealloc(mdev, ipsec_rule->modify_hdr);
-	rx_ft_put(mdev, sa_entry->ipsec, sa_entry->attrs.family);
+	rx_ft_put(sa_entry->ipsec, sa_entry->attrs.family);
 }
 
 int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
@@ -1051,12 +1258,13 @@ void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
 	mlx5_del_flow_rules(ipsec_rule->rule);
 
 	if (pol_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN) {
-		rx_ft_put(mdev, pol_entry->ipsec, pol_entry->attrs.family);
+		rx_ft_put_policy(pol_entry->ipsec, pol_entry->attrs.family,
+				 pol_entry->attrs.prio);
 		return;
 	}
 
 	mlx5_modify_header_dealloc(mdev, ipsec_rule->modify_hdr);
-	tx_ft_put(pol_entry->ipsec);
+	tx_ft_put_policy(pol_entry->ipsec, pol_entry->attrs.prio);
 }
 
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 5fa7a4c40429..67be8d36bb76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -36,11 +36,18 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 	    MLX5_CAP_ETH(mdev, insert_trailer) && MLX5_CAP_ETH(mdev, swp))
 		caps |= MLX5_IPSEC_CAP_CRYPTO;
 
-	if (MLX5_CAP_IPSEC(mdev, ipsec_full_offload) &&
-	    MLX5_CAP_FLOWTABLE_NIC_TX(mdev, reformat_add_esp_trasport) &&
-	    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, reformat_del_esp_trasport) &&
-	    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, decap))
-		caps |= MLX5_IPSEC_CAP_PACKET_OFFLOAD;
+	if (MLX5_CAP_IPSEC(mdev, ipsec_full_offload)) {
+		if (MLX5_CAP_FLOWTABLE_NIC_TX(mdev,
+					      reformat_add_esp_trasport) &&
+		    MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
+					      reformat_del_esp_trasport) &&
+		    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, decap))
+			caps |= MLX5_IPSEC_CAP_PACKET_OFFLOAD;
+
+		if (MLX5_CAP_FLOWTABLE_NIC_TX(mdev, ignore_flow_level) &&
+		    MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ignore_flow_level))
+			caps |= MLX5_IPSEC_CAP_PRIO;
+	}
 
 	if (mlx5_get_roce_state(mdev) &&
 	    MLX5_CAP_GEN_2(mdev, flow_table_type_2_type) & MLX5_FT_NIC_RX_2_NIC_RX_RDMA &&
-- 
2.39.2

