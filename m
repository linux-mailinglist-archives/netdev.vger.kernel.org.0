Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657186CFDA9
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjC3IDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjC3IDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:03:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78B172A5
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:03:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F156DB82623
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415DFC433EF;
        Thu, 30 Mar 2023 08:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163395;
        bh=LHkTwYYAYbCOt75ZIEBv3HfupXZ90RttxDvMaM1P2qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOyywx0SfIA+2F3QkVeNZcfspCa3wXDKL2s6OoF5NrGgEhc09QDRXVrffeuAwR6I2
         Qd6LBWpz0Ld6o8GNj97GOB/cfpQymn8mTu1N/mwIYlEe1864sKaEyHVVMbEUVflSkP
         mgHfElMSM+KAcHRNBQh7repLmAxhlSYeNLplj6Opd01oiaSSPeHKb9lvtQa2HmYdqy
         Q59EVNYxPsj3f1lPVAx0qups8zz4b2TQ0f+wpiCmMasT4rBxo2issx71/DofzC3z6j
         PBPyOwNc/mLHVM+TwmJwm57tgstwqzKBLhiT7y++4HjomD7sykkAXAzVdHrFa1QYVg
         BiY90YSWXPdgA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net-next 09/10] net/mlx5e: Generalize IPsec work structs
Date:   Thu, 30 Mar 2023 11:02:30 +0300
Message-Id: <285a1550242363de181bab3a07a69296f66ad9a8.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680162300.git.leonro@nvidia.com>
References: <cover.1680162300.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

IPsec logic has two work structs which are submitted to same workqueue.
As a preparation to addition of new work which needs to be submitted
too, let's generalize struct mlx5e_ipsec_work.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 84 ++++++++++++-------
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 11 +--
 .../mlx5/core/en_accel/ipsec_offload.c        | 19 ++---
 3 files changed, 66 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index fa66f4f3cba7..89d5802888a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -406,14 +406,16 @@ static int mlx5e_xfrm_validate_state(struct mlx5_core_dev *mdev,
 	return 0;
 }
 
-static void _update_xfrm_state(struct work_struct *work)
+static void mlx5e_ipsec_modify_state(struct work_struct *_work)
 {
-	struct mlx5e_ipsec_modify_state_work *modify_work =
-		container_of(work, struct mlx5e_ipsec_modify_state_work, work);
-	struct mlx5e_ipsec_sa_entry *sa_entry = container_of(
-		modify_work, struct mlx5e_ipsec_sa_entry, modify_work);
+	struct mlx5e_ipsec_work *work =
+		container_of(_work, struct mlx5e_ipsec_work, work);
+	struct mlx5e_ipsec_sa_entry *sa_entry = work->sa_entry;
+	struct mlx5_accel_esp_xfrm_attrs *attrs;
 
-	mlx5_accel_esp_modify_xfrm(sa_entry, &modify_work->attrs);
+	attrs = &((struct mlx5e_ipsec_sa_entry *)work->data)->attrs;
+
+	mlx5_accel_esp_modify_xfrm(sa_entry, attrs);
 }
 
 static void mlx5e_ipsec_set_esn_ops(struct mlx5e_ipsec_sa_entry *sa_entry)
@@ -432,6 +434,36 @@ static void mlx5e_ipsec_set_esn_ops(struct mlx5e_ipsec_sa_entry *sa_entry)
 	sa_entry->set_iv_op = mlx5e_ipsec_set_iv;
 }
 
+static int mlx5_ipsec_create_work(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct xfrm_state *x = sa_entry->x;
+	struct mlx5e_ipsec_work *work;
+
+	switch (x->xso.type) {
+	case XFRM_DEV_OFFLOAD_CRYPTO:
+		if (!(x->props.flags & XFRM_STATE_ESN))
+			return 0;
+		break;
+	default:
+		return 0;
+	}
+
+	work = kzalloc(sizeof(*work), GFP_KERNEL);
+	if (!work)
+		return -ENOMEM;
+
+	work->data = kzalloc(sizeof(*sa_entry), GFP_KERNEL);
+	if (!work->data) {
+		kfree(work);
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&work->work, mlx5e_ipsec_modify_state);
+	work->sa_entry = sa_entry;
+	sa_entry->work = work;
+	return 0;
+}
+
 static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 				struct netlink_ext_ack *extack)
 {
@@ -467,10 +499,15 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 		mlx5e_ipsec_update_esn_state(sa_entry);
 
 	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &sa_entry->attrs);
+
+	err = mlx5_ipsec_create_work(sa_entry);
+	if (err)
+		goto err_xfrm;
+
 	/* create hw context */
 	err = mlx5_ipsec_create_sa_ctx(sa_entry);
 	if (err)
-		goto err_xfrm;
+		goto release_work;
 
 	err = mlx5e_accel_ipsec_fs_add_rule(sa_entry);
 	if (err)
@@ -486,16 +523,6 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 		goto err_add_rule;
 
 	mlx5e_ipsec_set_esn_ops(sa_entry);
-
-	switch (x->xso.type) {
-	case XFRM_DEV_OFFLOAD_CRYPTO:
-		if (x->props.flags & XFRM_STATE_ESN)
-			INIT_WORK(&sa_entry->modify_work.work,
-				  _update_xfrm_state);
-		break;
-	default:
-		break;
-	}
 out:
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	return 0;
@@ -504,6 +531,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 err_hw_ctx:
 	mlx5_ipsec_free_sa_ctx(sa_entry);
+release_work:
+	kfree(sa_entry->work);
 err_xfrm:
 	kfree(sa_entry);
 	NL_SET_ERR_MSG_MOD(extack, "Device failed to offload this policy");
@@ -530,17 +559,12 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
 		goto sa_entry_free;
 
-	switch (x->xso.type) {
-	case XFRM_DEV_OFFLOAD_CRYPTO:
-		if (x->props.flags & XFRM_STATE_ESN)
-			cancel_work_sync(&sa_entry->modify_work.work);
-		break;
-	default:
-		break;
-	}
+	if (sa_entry->work)
+		cancel_work_sync(&sa_entry->work->work);
 
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 	mlx5_ipsec_free_sa_ctx(sa_entry);
+	kfree(sa_entry->work);
 sa_entry_free:
 	kfree(sa_entry);
 }
@@ -626,16 +650,18 @@ static bool mlx5e_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 static void mlx5e_xfrm_advance_esn_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
-	struct mlx5e_ipsec_modify_state_work *modify_work =
-		&sa_entry->modify_work;
+	struct mlx5e_ipsec_work *work = sa_entry->work;
+	struct mlx5e_ipsec_sa_entry *sa_entry_shadow;
 	bool need_update;
 
 	need_update = mlx5e_ipsec_update_esn_state(sa_entry);
 	if (!need_update)
 		return;
 
-	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &modify_work->attrs);
-	queue_work(sa_entry->ipsec->wq, &modify_work->work);
+	sa_entry_shadow = work->data;
+	memset(sa_entry_shadow, 0x00, sizeof(*sa_entry_shadow));
+	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &sa_entry_shadow->attrs);
+	queue_work(sa_entry->ipsec->wq, &work->work);
 }
 
 static void mlx5e_xfrm_update_curlft(struct xfrm_state *x)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 8d5ce65def9f..ab48fb9b4698 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -136,8 +136,8 @@ struct mlx5e_ipsec_tx;
 
 struct mlx5e_ipsec_work {
 	struct work_struct work;
-	struct mlx5e_ipsec *ipsec;
-	u32 id;
+	struct mlx5e_ipsec_sa_entry *sa_entry;
+	void *data;
 };
 
 struct mlx5e_ipsec_aso {
@@ -176,11 +176,6 @@ struct mlx5e_ipsec_rule {
 	struct mlx5_fc *fc;
 };
 
-struct mlx5e_ipsec_modify_state_work {
-	struct work_struct		work;
-	struct mlx5_accel_esp_xfrm_attrs attrs;
-};
-
 struct mlx5e_ipsec_limits {
 	u64 round;
 	u8 soft_limit_hit : 1;
@@ -197,7 +192,7 @@ struct mlx5e_ipsec_sa_entry {
 	u32 ipsec_obj_id;
 	u32 enc_key_id;
 	struct mlx5e_ipsec_rule ipsec_rule;
-	struct mlx5e_ipsec_modify_state_work modify_work;
+	struct mlx5e_ipsec_work *work;
 	struct mlx5e_ipsec_limits limits;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index c974c6153d89..5fddb86bb35e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -417,18 +417,12 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 {
 	struct mlx5e_ipsec_work *work =
 		container_of(_work, struct mlx5e_ipsec_work, work);
+	struct mlx5e_ipsec_sa_entry *sa_entry = work->data;
 	struct mlx5_accel_esp_xfrm_attrs *attrs;
-	struct mlx5e_ipsec_sa_entry *sa_entry;
 	struct mlx5e_ipsec_aso *aso;
-	struct mlx5e_ipsec *ipsec;
 	int ret;
 
-	sa_entry = xa_load(&work->ipsec->sadb, work->id);
-	if (!sa_entry)
-		goto out;
-
-	ipsec = sa_entry->ipsec;
-	aso = ipsec->aso;
+	aso = sa_entry->ipsec->aso;
 	attrs = &sa_entry->attrs;
 
 	spin_lock(&sa_entry->x->lock);
@@ -448,7 +442,6 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 
 unlock:
 	spin_unlock(&sa_entry->x->lock);
-out:
 	kfree(work);
 }
 
@@ -456,6 +449,7 @@ static int mlx5e_ipsec_event(struct notifier_block *nb, unsigned long event,
 			     void *data)
 {
 	struct mlx5e_ipsec *ipsec = container_of(nb, struct mlx5e_ipsec, nb);
+	struct mlx5e_ipsec_sa_entry *sa_entry;
 	struct mlx5_eqe_obj_change *object;
 	struct mlx5e_ipsec_work *work;
 	struct mlx5_eqe *eqe = data;
@@ -470,13 +464,16 @@ static int mlx5e_ipsec_event(struct notifier_block *nb, unsigned long event,
 	if (type != MLX5_GENERAL_OBJECT_TYPES_IPSEC)
 		return NOTIFY_DONE;
 
+	sa_entry = xa_load(&ipsec->sadb, be32_to_cpu(object->obj_id));
+	if (!sa_entry)
+		return NOTIFY_DONE;
+
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (!work)
 		return NOTIFY_DONE;
 
 	INIT_WORK(&work->work, mlx5e_ipsec_handle_event);
-	work->ipsec = ipsec;
-	work->id = be32_to_cpu(object->obj_id);
+	work->data = sa_entry;
 
 	queue_work(ipsec->wq, &work->work);
 	return NOTIFY_OK;
-- 
2.39.2

