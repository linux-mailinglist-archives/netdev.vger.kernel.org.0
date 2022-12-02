Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578FE640EF9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiLBUPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLBUPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE836D7FC
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E24DB82277
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76170C433C1;
        Fri,  2 Dec 2022 20:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012114;
        bh=fsxK3h460igFT20AFb1Yd4kbatTXjEdNtjXqX6l+rfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZchEniFk+YMPQlC0oseW6WaddyXshJpuwLWX78NCDsM1qQXY0z6jQiBdEqXmdgFrs
         eVApKnFe4Wi5rbCmNY6gI/NUqf9jwVqcFTdmFI15lRLNlINfhWGKBfhXIPoAX8ry5V
         dbKMAMyCahG/UBa/jb5tbHL3Y0s7FY1MlHYgaWVDjLGCiJk5f5HL+RP5n/MsXyy+Gh
         hXXU30PUBjM4qwjIj4+JFywfydnwJQQSl/l76/fwEb3QXtsGZP4gySFLLWVrtjHh+o
         qq739WjAZefMKNVPrnWdUon2pCXrSua7X2rSC6FuwGZBBZZEZKE3MZ1dkgtlNLqiya
         VMsaI7dtfoBLw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 02/13] net/mlx5e: Add XFRM policy offload logic
Date:   Fri,  2 Dec 2022 22:14:46 +0200
Message-Id: <4544a98c853c83af0d30d836441f888d9ba3bd34.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Implement mlx5 flow steering logic and mlx5 IPsec code support
XFRM policy offload.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 118 +++++++++++++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  32 ++++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 146 ++++++++++++++++++
 3 files changed, 295 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index c5bccc0df60d..b22a31e178cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -45,6 +45,11 @@ static struct mlx5e_ipsec_sa_entry *to_ipsec_sa_entry(struct xfrm_state *x)
 	return (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
 }
 
+static struct mlx5e_ipsec_pol_entry *to_ipsec_pol_entry(struct xfrm_policy *x)
+{
+	return (struct mlx5e_ipsec_pol_entry *)x->xdo.offload_handle;
+}
+
 struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *ipsec,
 					      unsigned int handle)
 {
@@ -446,6 +451,101 @@ static void mlx5e_xfrm_advance_esn_state(struct xfrm_state *x)
 	queue_work(sa_entry->ipsec->wq, &modify_work->work);
 }
 
+static int mlx5e_xfrm_validate_policy(struct xfrm_policy *x)
+{
+	struct net_device *netdev = x->xdo.real_dev;
+
+	if (x->type != XFRM_POLICY_TYPE_MAIN) {
+		netdev_info(netdev, "Cannot offload non-main policy types\n");
+		return -EINVAL;
+	}
+
+	/* Please pay attention that we support only one template */
+	if (x->xfrm_nr > 1) {
+		netdev_info(netdev, "Cannot offload more than one template\n");
+		return -EINVAL;
+	}
+
+	if (x->xdo.dir != XFRM_DEV_OFFLOAD_IN &&
+	    x->xdo.dir != XFRM_DEV_OFFLOAD_OUT) {
+		netdev_info(netdev, "Cannot offload forward policy\n");
+		return -EINVAL;
+	}
+
+	if (!x->xfrm_vec[0].reqid) {
+		netdev_info(netdev, "Cannot offload policy without reqid\n");
+		return -EINVAL;
+	}
+
+	if (x->xdo.type != XFRM_DEV_OFFLOAD_PACKET) {
+		netdev_info(netdev, "Unsupported xfrm offload type\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void
+mlx5e_ipsec_build_accel_pol_attrs(struct mlx5e_ipsec_pol_entry *pol_entry,
+				  struct mlx5_accel_pol_xfrm_attrs *attrs)
+{
+	struct xfrm_policy *x = pol_entry->x;
+	struct xfrm_selector *sel;
+
+	sel = &x->selector;
+	memset(attrs, 0, sizeof(*attrs));
+
+	memcpy(&attrs->saddr, sel->saddr.a6, sizeof(attrs->saddr));
+	memcpy(&attrs->daddr, sel->daddr.a6, sizeof(attrs->daddr));
+	attrs->family = sel->family;
+	attrs->dir = x->xdo.dir;
+	attrs->action = x->action;
+	attrs->type = XFRM_DEV_OFFLOAD_PACKET;
+}
+
+static int mlx5e_xfrm_add_policy(struct xfrm_policy *x)
+{
+	struct net_device *netdev = x->xdo.real_dev;
+	struct mlx5e_ipsec_pol_entry *pol_entry;
+	struct mlx5e_priv *priv;
+	int err;
+
+	priv = netdev_priv(netdev);
+	if (!priv->ipsec)
+		return -EOPNOTSUPP;
+
+	err = mlx5e_xfrm_validate_policy(x);
+	if (err)
+		return err;
+
+	pol_entry = kzalloc(sizeof(*pol_entry), GFP_KERNEL);
+	if (!pol_entry)
+		return -ENOMEM;
+
+	pol_entry->x = x;
+	pol_entry->ipsec = priv->ipsec;
+
+	mlx5e_ipsec_build_accel_pol_attrs(pol_entry, &pol_entry->attrs);
+	err = mlx5e_accel_ipsec_fs_add_pol(pol_entry);
+	if (err)
+		goto err_fs;
+
+	x->xdo.offload_handle = (unsigned long)pol_entry;
+	return 0;
+
+err_fs:
+	kfree(pol_entry);
+	return err;
+}
+
+static void mlx5e_xfrm_free_policy(struct xfrm_policy *x)
+{
+	struct mlx5e_ipsec_pol_entry *pol_entry = to_ipsec_pol_entry(x);
+
+	mlx5e_accel_ipsec_fs_del_pol(pol_entry);
+	kfree(pol_entry);
+}
+
 static const struct xfrmdev_ops mlx5e_ipsec_xfrmdev_ops = {
 	.xdo_dev_state_add	= mlx5e_xfrm_add_state,
 	.xdo_dev_state_delete	= mlx5e_xfrm_del_state,
@@ -454,6 +554,17 @@ static const struct xfrmdev_ops mlx5e_ipsec_xfrmdev_ops = {
 	.xdo_dev_state_advance_esn = mlx5e_xfrm_advance_esn_state,
 };
 
+static const struct xfrmdev_ops mlx5e_ipsec_packet_xfrmdev_ops = {
+	.xdo_dev_state_add	= mlx5e_xfrm_add_state,
+	.xdo_dev_state_delete	= mlx5e_xfrm_del_state,
+	.xdo_dev_state_free	= mlx5e_xfrm_free_state,
+	.xdo_dev_offload_ok	= mlx5e_ipsec_offload_ok,
+	.xdo_dev_state_advance_esn = mlx5e_xfrm_advance_esn_state,
+
+	.xdo_dev_policy_add = mlx5e_xfrm_add_policy,
+	.xdo_dev_policy_free = mlx5e_xfrm_free_policy,
+};
+
 void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -463,7 +574,12 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 		return;
 
 	mlx5_core_info(mdev, "mlx5e: IPSec ESP acceleration enabled\n");
-	netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
+
+	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_PACKET_OFFLOAD)
+		netdev->xfrmdev_ops = &mlx5e_ipsec_packet_xfrmdev_ops;
+	else
+		netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
+
 	netdev->features |= NETIF_F_HW_ESP;
 	netdev->hw_enc_features |= NETIF_F_HW_ESP;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 990378d52fd4..8d1a0d053eb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -149,6 +149,30 @@ struct mlx5e_ipsec_sa_entry {
 	struct mlx5e_ipsec_modify_state_work modify_work;
 };
 
+struct mlx5_accel_pol_xfrm_attrs {
+	union {
+		__be32 a4;
+		__be32 a6[4];
+	} saddr;
+
+	union {
+		__be32 a4;
+		__be32 a6[4];
+	} daddr;
+
+	u8 family;
+	u8 action;
+	u8 type : 2;
+	u8 dir : 2;
+};
+
+struct mlx5e_ipsec_pol_entry {
+	struct xfrm_policy *x;
+	struct mlx5e_ipsec *ipsec;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_accel_pol_xfrm_attrs attrs;
+};
+
 void mlx5e_ipsec_init(struct mlx5e_priv *priv);
 void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv);
 void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv);
@@ -160,6 +184,8 @@ void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
 int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
+int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
+void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
@@ -177,6 +203,12 @@ mlx5e_ipsec_sa2dev(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	return sa_entry->ipsec->mdev;
 }
+
+static inline struct mlx5_core_dev *
+mlx5e_ipsec_pol2dev(struct mlx5e_ipsec_pol_entry *pol_entry)
+{
+	return pol_entry->ipsec->mdev;
+}
 #else
 static inline void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index a3c7d0f142c0..27f866a158de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -597,6 +597,130 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	return err;
 }
 
+static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
+{
+	struct mlx5_accel_pol_xfrm_attrs *attrs = &pol_entry->attrs;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_pol2dev(pol_entry);
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	struct mlx5e_ipsec_tx *tx;
+	int err;
+
+	tx = tx_ft_get(mdev, pol_entry->ipsec);
+	if (IS_ERR(tx))
+		return PTR_ERR(tx);
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+
+	if (attrs->family == AF_INET)
+		setup_fte_addr4(spec, &attrs->saddr.a4, &attrs->daddr.a4);
+	else
+		setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
+
+	setup_fte_no_frags(spec);
+
+	switch (attrs->action) {
+	case XFRM_POLICY_ALLOW:
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		break;
+	case XFRM_POLICY_BLOCK:
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
+		break;
+	default:
+		WARN_ON(true);
+		err = -EINVAL;
+		goto err_action;
+	}
+
+	flow_act.flags |= FLOW_ACT_NO_APPEND;
+	dest.ft = tx->ft.sa;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	rule = mlx5_add_flow_rules(tx->ft.pol, spec, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		mlx5_core_err(mdev, "fail to add TX ipsec rule err=%d\n", err);
+		goto err_action;
+	}
+
+	kvfree(spec);
+	pol_entry->rule = rule;
+	return 0;
+
+err_action:
+	kvfree(spec);
+err_alloc:
+	tx_ft_put(pol_entry->ipsec);
+	return err;
+}
+
+static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
+{
+	struct mlx5_accel_pol_xfrm_attrs *attrs = &pol_entry->attrs;
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_pol2dev(pol_entry);
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	struct mlx5e_ipsec_rx *rx;
+	int err;
+
+	rx = rx_ft_get(mdev, pol_entry->ipsec, attrs->family);
+	if (IS_ERR(rx))
+		return PTR_ERR(rx);
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+
+	if (attrs->family == AF_INET)
+		setup_fte_addr4(spec, &attrs->saddr.a4, &attrs->daddr.a4);
+	else
+		setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
+
+	setup_fte_no_frags(spec);
+
+	switch (attrs->action) {
+	case XFRM_POLICY_ALLOW:
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		break;
+	case XFRM_POLICY_BLOCK:
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
+		break;
+	default:
+		WARN_ON(true);
+		err = -EINVAL;
+		goto err_action;
+	}
+
+	flow_act.flags |= FLOW_ACT_NO_APPEND;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = rx->ft.sa;
+	rule = mlx5_add_flow_rules(rx->ft.pol, spec, &flow_act, &dest, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		mlx5_core_err(mdev, "Fail to add RX IPsec policy rule err=%d\n", err);
+		goto err_action;
+	}
+
+	kvfree(spec);
+	pol_entry->rule = rule;
+	return 0;
+
+err_action:
+	kvfree(spec);
+err_alloc:
+	rx_ft_put(mdev, pol_entry->ipsec, attrs->family);
+	return err;
+}
+
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT)
@@ -621,6 +745,28 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	rx_ft_put(mdev, sa_entry->ipsec, sa_entry->attrs.family);
 }
 
+int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
+{
+	if (pol_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT)
+		return tx_add_policy(pol_entry);
+
+	return rx_add_policy(pol_entry);
+}
+
+void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
+{
+	struct mlx5_core_dev *mdev = mlx5e_ipsec_pol2dev(pol_entry);
+
+	mlx5_del_flow_rules(pol_entry->rule);
+
+	if (pol_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
+		tx_ft_put(pol_entry->ipsec);
+		return;
+	}
+
+	rx_ft_put(mdev, pol_entry->ipsec, pol_entry->attrs.family);
+}
+
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
 {
 	if (!ipsec->tx)
-- 
2.38.1

