Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38264FACB8
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbiDJIbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbiDJIbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B00DFD0F;
        Sun, 10 Apr 2022 01:29:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D42E8B80B7F;
        Sun, 10 Apr 2022 08:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDEEC385A4;
        Sun, 10 Apr 2022 08:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579341;
        bh=3QrLZeDXFgkjH2LZa8w30s5So6Y0+klxHNfQJdT0fsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkwUX5tcmpiLoqv4mt+BNd5OvsXO2Jp2akjvsj1YRgv0P6ZcBCWafWmwcgwj3klv2
         OBQi02ooKl8NXcaq/wXqatVi/IeC0bEqeiW4IP5T42eFmcRzv1VnDazs5r6nGtno58
         ugisbd3LLPWy44oPF+y+yFTXcMbSQuCAiGBUiotpqMI/eMllDJdtaNK8VjjGKsUGM2
         V2C8y6hasrmC37G8XOQ1x8MaJZOjhyjFqSel+XoMQl4qO5+I7sacC9G98i4eN+dx4F
         cPH6mATIg2Kvb8s5rDbKOwSNCo6YsbFrMKW/WAuyeIQPa0ceIJm5vxUEKlTI2wmGnN
         xBWqBf694e2RQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 05/17] net/mlx5: Store IPsec ESN update work in XFRM state
Date:   Sun, 10 Apr 2022 11:28:23 +0300
Message-Id: <1d965d2697dda0bd2c34fc1ccbbb45efaf03b0de.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

mlx5 IPsec code updated ESN through workqueue with allocation calls
in the data path, which can be saved easily if the work is created
during XFRM state initialization routine.

The locking used later in the work didn't protect from anything because
change of HW context is possible during XFRM state add or delete only,
which can cancel work and make sure that it is not running.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 49 ++++++-------------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  7 ++-
 .../mlx5/core/en_accel/ipsec_offload.c        | 39 +++------------
 include/linux/mlx5/accel.h                    | 10 ++--
 4 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7f8aad4cad18..142a2e8313f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -271,6 +271,16 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 	return 0;
 }
 
+static void _update_xfrm_state(struct work_struct *work)
+{
+	struct mlx5e_ipsec_modify_state_work *modify_work =
+		container_of(work, struct mlx5e_ipsec_modify_state_work, work);
+	struct mlx5e_ipsec_sa_entry *sa_entry = container_of(
+		modify_work, struct mlx5e_ipsec_sa_entry, modify_work);
+
+	mlx5_accel_esp_modify_xfrm(sa_entry->xfrm, &modify_work->attrs);
+}
+
 static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
@@ -334,6 +344,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 				mlx5e_ipsec_set_iv_esn : mlx5e_ipsec_set_iv;
 	}
 
+	INIT_WORK(&sa_entry->modify_work.work, _update_xfrm_state);
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	goto out;
 
@@ -365,7 +376,7 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
 
 	if (sa_entry->hw_context) {
-		flush_workqueue(sa_entry->ipsec->wq);
+		cancel_work_sync(&sa_entry->modify_work.work);
 		mlx5e_ipsec_fs_del_rule(priv, &sa_entry->xfrm->attrs,
 					&sa_entry->ipsec_rule);
 		mlx5_accel_esp_free_hw_context(sa_entry->xfrm->mdev, sa_entry->hw_context);
@@ -392,7 +403,6 @@ int mlx5e_ipsec_init(struct mlx5e_priv *priv)
 	hash_init(ipsec->sadb_rx);
 	spin_lock_init(&ipsec->sadb_rx_lock);
 	ipsec->mdev = priv->mdev;
-	ipsec->en_priv = priv;
 	ipsec->wq = alloc_ordered_workqueue("mlx5e_ipsec: %s", 0,
 					    priv->netdev->name);
 	if (!ipsec->wq) {
@@ -424,7 +434,6 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 
 	mlx5e_ipsec_fs_cleanup(ipsec);
 	destroy_workqueue(ipsec->wq);
-
 	kfree(ipsec);
 	priv->ipsec = NULL;
 }
@@ -444,47 +453,19 @@ static bool mlx5e_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 	return true;
 }
 
-struct mlx5e_ipsec_modify_state_work {
-	struct work_struct		work;
-	struct mlx5_accel_esp_xfrm_attrs attrs;
-	struct mlx5e_ipsec_sa_entry	*sa_entry;
-};
-
-static void _update_xfrm_state(struct work_struct *work)
-{
-	int ret;
-	struct mlx5e_ipsec_modify_state_work *modify_work =
-		container_of(work, struct mlx5e_ipsec_modify_state_work, work);
-	struct mlx5e_ipsec_sa_entry *sa_entry = modify_work->sa_entry;
-
-	ret = mlx5_accel_esp_modify_xfrm(sa_entry->xfrm,
-					 &modify_work->attrs);
-	if (ret)
-		netdev_warn(sa_entry->ipsec->en_priv->netdev,
-			    "Not an IPSec offload device\n");
-
-	kfree(modify_work);
-}
-
 static void mlx5e_xfrm_advance_esn_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
-	struct mlx5e_ipsec_modify_state_work *modify_work;
+	struct mlx5e_ipsec_modify_state_work *modify_work =
+		&sa_entry->modify_work;
 	bool need_update;
 
 	need_update = mlx5e_ipsec_update_esn_state(sa_entry);
 	if (!need_update)
 		return;
 
-	modify_work = kzalloc(sizeof(*modify_work), GFP_ATOMIC);
-	if (!modify_work)
-		return;
-
 	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &modify_work->attrs);
-	modify_work->sa_entry = sa_entry;
-
-	INIT_WORK(&modify_work->work, _update_xfrm_state);
-	WARN_ON(!queue_work(sa_entry->ipsec->wq, &modify_work->work));
+	queue_work(sa_entry->ipsec->wq, &modify_work->work);
 }
 
 static const struct xfrmdev_ops mlx5e_ipsec_xfrmdev_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index bbf48d4616f9..35a751faeb33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -62,7 +62,6 @@ struct mlx5e_ipsec_tx;
 
 struct mlx5e_ipsec {
 	struct mlx5_core_dev *mdev;
-	struct mlx5e_priv *en_priv;
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
 	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
 	struct mlx5e_ipsec_sw_stats sw_stats;
@@ -82,6 +81,11 @@ struct mlx5e_ipsec_rule {
 	struct mlx5_modify_hdr *set_modify_hdr;
 };
 
+struct mlx5e_ipsec_modify_state_work {
+	struct work_struct		work;
+	struct mlx5_accel_esp_xfrm_attrs attrs;
+};
+
 struct mlx5e_ipsec_sa_entry {
 	struct hlist_node hlist; /* Item in SADB_RX hashtable */
 	struct mlx5e_ipsec_esn_state esn_state;
@@ -94,6 +98,7 @@ struct mlx5e_ipsec_sa_entry {
 			  struct xfrm_offload *xo);
 	u32 ipsec_obj_id;
 	struct mlx5e_ipsec_rule ipsec_rule;
+	struct mlx5e_ipsec_modify_state_work modify_work;
 };
 
 int mlx5e_ipsec_init(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 37c9880719cf..bbfb6643ed80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -18,7 +18,6 @@ struct mlx5_ipsec_sa_ctx {
 struct mlx5_ipsec_esp_xfrm {
 	/* reference counter of SA ctx */
 	struct mlx5_ipsec_sa_ctx *sa_ctx;
-	struct mutex lock; /* protects mlx5_ipsec_esp_xfrm */
 	struct mlx5_accel_esp_xfrm accel_xfrm;
 };
 
@@ -117,7 +116,6 @@ mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
 	if (!mxfrm)
 		return ERR_PTR(-ENOMEM);
 
-	mutex_init(&mxfrm->lock);
 	memcpy(&mxfrm->accel_xfrm.attrs, attrs,
 	       sizeof(mxfrm->accel_xfrm.attrs));
 
@@ -129,8 +127,6 @@ static void mlx5_ipsec_offload_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm
 	struct mlx5_ipsec_esp_xfrm *mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm,
 							 accel_xfrm);
 
-	/* assuming no sa_ctx are connected to this xfrm_ctx */
-	WARN_ON(mxfrm->sa_ctx);
 	kfree(mxfrm);
 }
 
@@ -232,7 +228,6 @@ static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
 	sa_ctx->dev = mdev;
 
 	mxfrm = container_of(accel_xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
-	mutex_lock(&mxfrm->lock);
 	sa_ctx->mxfrm = mxfrm;
 
 	/* key */
@@ -258,14 +253,12 @@ static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
 
 	*hw_handle = sa_ctx->ipsec_obj_id;
 	mxfrm->sa_ctx = sa_ctx;
-	mutex_unlock(&mxfrm->lock);
 
 	return sa_ctx;
 
 err_enc_key:
 	mlx5_destroy_encryption_key(mdev, sa_ctx->enc_key_id);
 err_sa_ctx:
-	mutex_unlock(&mxfrm->lock);
 	kfree(sa_ctx);
 	return ERR_PTR(err);
 }
@@ -273,14 +266,10 @@ static void *mlx5_ipsec_offload_create_sa_ctx(struct mlx5_core_dev *mdev,
 static void mlx5_ipsec_offload_delete_sa_ctx(void *context)
 {
 	struct mlx5_ipsec_sa_ctx *sa_ctx = (struct mlx5_ipsec_sa_ctx *)context;
-	struct mlx5_ipsec_esp_xfrm *mxfrm = sa_ctx->mxfrm;
 
-	mutex_lock(&mxfrm->lock);
 	mlx5_destroy_ipsec_obj(sa_ctx->dev, sa_ctx->ipsec_obj_id);
 	mlx5_destroy_encryption_key(sa_ctx->dev, sa_ctx->enc_key_id);
 	kfree(sa_ctx);
-	mxfrm->sa_ctx = NULL;
-	mutex_unlock(&mxfrm->lock);
 }
 
 static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
@@ -331,29 +320,17 @@ static int mlx5_modify_ipsec_obj(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 }
 
-static int mlx5_ipsec_offload_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-					      const struct mlx5_accel_esp_xfrm_attrs *attrs)
+static void mlx5_ipsec_offload_esp_modify_xfrm(
+	struct mlx5_accel_esp_xfrm *xfrm,
+	const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_obj_attrs ipsec_attrs = {};
 	struct mlx5_core_dev *mdev = xfrm->mdev;
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
-
 	int err = 0;
 
-	if (!memcmp(&xfrm->attrs, attrs, sizeof(xfrm->attrs)))
-		return 0;
-
-	if (mlx5_ipsec_offload_esp_validate_xfrm_attrs(mdev, attrs))
-		return -EOPNOTSUPP;
-
 	mxfrm = container_of(xfrm, struct mlx5_ipsec_esp_xfrm, accel_xfrm);
 
-	mutex_lock(&mxfrm->lock);
-
-	if (!mxfrm->sa_ctx)
-		/* Not bound xfrm, change only sw attrs */
-		goto change_sw_xfrm_attrs;
-
 	/* need to add find and replace in ipsec_rhash_sa the sa_ctx */
 	/* modify device with new hw_sa */
 	ipsec_attrs.accel_flags = attrs->flags;
@@ -362,12 +339,8 @@ static int mlx5_ipsec_offload_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 				    &ipsec_attrs,
 				    mxfrm->sa_ctx->ipsec_obj_id);
 
-change_sw_xfrm_attrs:
 	if (!err)
 		memcpy(&xfrm->attrs, attrs, sizeof(xfrm->attrs));
-
-	mutex_unlock(&mxfrm->lock);
-	return err;
 }
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
@@ -413,8 +386,8 @@ void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm)
 	mlx5_ipsec_offload_esp_destroy_xfrm(xfrm);
 }
 
-int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			       const struct mlx5_accel_esp_xfrm_attrs *attrs)
+void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	return mlx5_ipsec_offload_esp_modify_xfrm(xfrm, attrs);
+	mlx5_ipsec_offload_esp_modify_xfrm(xfrm, attrs);
 }
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index 0f2596297f6a..a2720ebbb9fd 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -127,8 +127,8 @@ struct mlx5_accel_esp_xfrm *
 mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
 			   const struct mlx5_accel_esp_xfrm_attrs *attrs);
 void mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm);
-int mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			       const struct mlx5_accel_esp_xfrm_attrs *attrs);
+void mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
+				const struct mlx5_accel_esp_xfrm_attrs *attrs);
 
 #else
 
@@ -145,9 +145,11 @@ mlx5_accel_esp_create_xfrm(struct mlx5_core_dev *mdev,
 }
 static inline void
 mlx5_accel_esp_destroy_xfrm(struct mlx5_accel_esp_xfrm *xfrm) {}
-static inline int
+static inline void
 mlx5_accel_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
-			   const struct mlx5_accel_esp_xfrm_attrs *attrs) { return -EOPNOTSUPP; }
+			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+}
 
 #endif /* CONFIG_MLX5_EN_IPSEC */
 #endif /* __MLX5_ACCEL_H__ */
-- 
2.35.1

