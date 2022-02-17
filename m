Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87A34B9A3F
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbiBQH5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:57:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbiBQH4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12DF65B9
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 511D961B44
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666B1C340F1;
        Thu, 17 Feb 2022 07:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084598;
        bh=arBnIb2OFL9ckkFIGFdebuN0bcE5z0Az+LHNHPHkO4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/w2FqD/nLNnvRVPV6htkHWo2DVbpoQvBqNmzZC0w7JkL3iwe5uG5bfJ2o0D51fSh
         QMJd7zh9kZRfCR5cGutSxn85ZIBw6zjwddKWQyu28T/sZ+ux90gpzJBBDpAN0H9H5s
         OVTeiH0I77OT9FGCIuT08l78INfsGNx14jQinzqMtI3FF0u/1OpMFsC0D0+Qig58Sw
         vUbc5/zJuEP1ScufZCnPfSeBsnSwjk7bJLQRJF+EsOJjUOMi4HMfBfdHC4yKOTXKzx
         lXOGeByk1ZFIGytWyoINfWKVOU7kIxRIC1Mm1q9oX87rg3HQkwSnu9r2F9fgOxFJDV
         5f3nTsABDwPew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: TC, Move flow hashtable to be per rep
Date:   Wed, 16 Feb 2022 23:56:25 -0800
Message-Id: <20220217075632.831542-9-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

To allow shared tc block offload between two or more reps of the
same eswitch, move the tc flow hashtable to be per rep, instead
of per eswitch.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 12 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  6 +--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 44 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  9 +++-
 5 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 0991345c4ae5..86fa0bdbee36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -263,14 +263,14 @@ int mlx5e_rep_tc_init(struct mlx5e_rep_priv *rpriv)
 	INIT_LIST_HEAD(&uplink_priv->unready_flows);
 
 	/* init shared tc flow table */
-	err = mlx5e_tc_esw_init(&uplink_priv->tc_ht);
+	err = mlx5e_tc_esw_init(uplink_priv);
 	return err;
 }
 
 void mlx5e_rep_tc_cleanup(struct mlx5e_rep_priv *rpriv)
 {
 	/* delete shared tc flow table */
-	mlx5e_tc_esw_cleanup(&rpriv->uplink_priv.tc_ht);
+	mlx5e_tc_esw_cleanup(&rpriv->uplink_priv);
 	mutex_destroy(&rpriv->uplink_priv.unready_flows_lock);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6070b8a13818..6b7e7ea6ded2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -942,15 +942,21 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 		return err;
 	}
 
+	err = mlx5e_tc_ht_init(&rpriv->tc_ht);
+	if (err)
+		goto err_ht_init;
+
 	if (rpriv->rep->vport == MLX5_VPORT_UPLINK) {
 		err = mlx5e_init_uplink_rep_tx(rpriv);
 		if (err)
-			goto destroy_tises;
+			goto err_init_tx;
 	}
 
 	return 0;
 
-destroy_tises:
+err_init_tx:
+	mlx5e_tc_ht_cleanup(&rpriv->tc_ht);
+err_ht_init:
 	mlx5e_destroy_tises(priv);
 	return err;
 }
@@ -970,6 +976,8 @@ static void mlx5e_cleanup_rep_tx(struct mlx5e_priv *priv)
 
 	if (rpriv->rep->vport == MLX5_VPORT_UPLINK)
 		mlx5e_cleanup_uplink_rep_tx(rpriv);
+
+	mlx5e_tc_ht_cleanup(&rpriv->tc_ht);
 }
 
 static void mlx5e_rep_enable(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index b01dacb6f527..0b619c7846d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -64,11 +64,6 @@ struct mlx5e_tc_tun_encap;
 struct mlx5e_post_act;
 
 struct mlx5_rep_uplink_priv {
-	/* Filters DB - instantiated by the uplink representor and shared by
-	 * the uplink's VFs
-	 */
-	struct rhashtable  tc_ht;
-
 	/* indirect block callbacks are invoked on bind/unbind events
 	 * on registered higher level devices (e.g. tunnel devices)
 	 *
@@ -113,6 +108,7 @@ struct mlx5e_rep_priv {
 	struct list_head       vport_sqs_list;
 	struct mlx5_rep_uplink_priv uplink_priv; /* valid for uplink rep */
 	struct rtnl_link_stats64 prev_vf_vport_stats;
+	struct rhashtable tc_ht;
 };
 
 static inline
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 099d4ce16049..342ab0688f13 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3609,12 +3609,11 @@ static const struct rhashtable_params tc_ht_params = {
 static struct rhashtable *get_tc_ht(struct mlx5e_priv *priv,
 				    unsigned long flags)
 {
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5e_rep_priv *uplink_rpriv;
+	struct mlx5e_rep_priv *rpriv;
 
 	if (flags & MLX5_TC_FLAG(ESW_OFFLOAD)) {
-		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-		return &uplink_rpriv->uplink_priv.tc_ht;
+		rpriv = priv->ppriv;
+		return &rpriv->tc_ht;
 	} else /* NIC offload */
 		return &priv->fs.tc.ht;
 }
@@ -4447,10 +4446,27 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5_chains_destroy(tc->chains);
 }
 
-int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
+int mlx5e_tc_ht_init(struct rhashtable *tc_ht)
+{
+	int err;
+
+	err = rhashtable_init(tc_ht, &tc_ht_params);
+	if (err)
+		return err;
+
+	lockdep_set_class(&tc_ht->mutex, &tc_ht_lock_key);
+
+	return 0;
+}
+
+void mlx5e_tc_ht_cleanup(struct rhashtable *tc_ht)
+{
+	rhashtable_free_and_destroy(tc_ht, _mlx5e_tc_del_flow, NULL);
+}
+
+int mlx5e_tc_esw_init(struct mlx5_rep_uplink_priv *uplink_priv)
 {
 	const size_t sz_enc_opts = sizeof(struct tunnel_match_enc_opts);
-	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *rpriv;
 	struct mapping_ctx *mapping;
 	struct mlx5_eswitch *esw;
@@ -4458,7 +4474,6 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	u64 mapping_id;
 	int err = 0;
 
-	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
 	rpriv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
 	priv = netdev_priv(rpriv->netdev);
 	esw = priv->mdev->priv.eswitch;
@@ -4498,12 +4513,6 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	}
 	uplink_priv->tunnel_enc_opts_mapping = mapping;
 
-	err = rhashtable_init(tc_ht, &tc_ht_params);
-	if (err)
-		goto err_ht_init;
-
-	lockdep_set_class(&tc_ht->mutex, &tc_ht_lock_key);
-
 	uplink_priv->encap = mlx5e_tc_tun_init(priv);
 	if (IS_ERR(uplink_priv->encap)) {
 		err = PTR_ERR(uplink_priv->encap);
@@ -4513,8 +4522,6 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	return 0;
 
 err_register_fib_notifier:
-	rhashtable_destroy(tc_ht);
-err_ht_init:
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
 err_enc_opts_mapping:
 	mapping_destroy(uplink_priv->tunnel_mapping);
@@ -4528,13 +4535,8 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	return err;
 }
 
-void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
+void mlx5e_tc_esw_cleanup(struct mlx5_rep_uplink_priv *uplink_priv)
 {
-	struct mlx5_rep_uplink_priv *uplink_priv;
-
-	uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
-
-	rhashtable_free_and_destroy(tc_ht, _mlx5e_tc_del_flow, NULL);
 	mlx5e_tc_tun_cleanup(uplink_priv->encap);
 
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index c6221728b767..533c897bd517 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -167,8 +167,11 @@ enum {
 
 #define MLX5_TC_FLAG(flag) BIT(MLX5E_TC_FLAG_##flag##_BIT)
 
-int mlx5e_tc_esw_init(struct rhashtable *tc_ht);
-void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht);
+int mlx5e_tc_esw_init(struct mlx5_rep_uplink_priv *uplink_priv);
+void mlx5e_tc_esw_cleanup(struct mlx5_rep_uplink_priv *uplink_priv);
+
+int mlx5e_tc_ht_init(struct rhashtable *tc_ht);
+void mlx5e_tc_ht_cleanup(struct rhashtable *tc_ht);
 
 int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 			   struct flow_cls_offload *f, unsigned long flags);
@@ -304,6 +307,8 @@ int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
 #else /* CONFIG_MLX5_CLS_ACT */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
+static inline int mlx5e_tc_ht_init(struct rhashtable *tc_ht) { return 0; }
+static inline void mlx5e_tc_ht_cleanup(struct rhashtable *tc_ht) {}
 static inline int
 mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 { return -EOPNOTSUPP; }
-- 
2.34.1

