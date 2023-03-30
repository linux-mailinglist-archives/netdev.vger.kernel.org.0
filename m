Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE0B6CFDA4
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjC3IDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjC3IDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:03:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCFA1FCC
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88D6161F15
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71808C433D2;
        Thu, 30 Mar 2023 08:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163384;
        bh=ktYe6rR6xZ2Usc7ufMAoj0pSuhQyaJmMvqM3s7bzrpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YErY/IlGcQ6Yz77L1UR/tkCRXx5aBYZ1IkiiMKDbtqOw+LHFMRy/UYm7CduRaMGmy
         ggPap7pLR+wS29XTCrpXiVU5AofeL4tsouivyxi2c4ob9BgxcudGcjAnb5R7HF/xzZ
         Cuf1A/DOLMT1VK4W+giMwYwqSFiz96Z1LSeH2Edvbjs0uuAxoO8EYXtXPvfh6owQCq
         y0K6OhMA/qfcVN77oJn+cVT16m5O2SVO02I79wxmeq0fpQcNbJRJVgfDUAvXYBfzaN
         uSyG8tCJEFSUTtncFhimdH6FpfUYK3ZH9uCtSCBeLrn0J9GOJsRjgK64SlncQNICk0
         s1yT0OnQLoC4g==
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
Subject: [PATCH net-next 06/10] net/mlx5e: Remove ESN callbacks if it is not supported
Date:   Thu, 30 Mar 2023 11:02:27 +0300
Message-Id: <2fc9fade32e31f03b100d6086a82ad36269349dc.1680162300.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680162300.git.leonro@nvidia.com>
References: <cover.1680162300.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in implementation of .xdo_dev_state_advance_esn() and
setting work as it will never be called in packet offload mode.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 51 ++++++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  1 -
 .../mlx5/core/en_accel/ipsec_offload.c        |  3 --
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 3612cdd37b5a..067704307851 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -56,11 +56,6 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	u32 seq_bottom = 0;
 	u8 overlap;
 
-	if (!(sa_entry->x->props.flags & XFRM_STATE_ESN)) {
-		sa_entry->esn_state.trigger = 0;
-		return false;
-	}
-
 	replay_esn = sa_entry->x->replay_esn;
 	if (replay_esn->seq >= replay_esn->replay_window)
 		seq_bottom = replay_esn->seq - replay_esn->replay_window + 1;
@@ -70,7 +65,6 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	sa_entry->esn_state.esn = xfrm_replay_seqhi(sa_entry->x,
 						    htonl(seq_bottom));
 
-	sa_entry->esn_state.trigger = 1;
 	if (unlikely(overlap && seq_bottom < MLX5E_IPSEC_ESN_SCOPE_MID)) {
 		sa_entry->esn_state.overlap = 0;
 		return true;
@@ -229,7 +223,7 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	aes_gcm->icv_len = x->aead->alg_icv_len;
 
 	/* esn */
-	if (sa_entry->esn_state.trigger) {
+	if (x->props.flags & XFRM_STATE_ESN) {
 		attrs->esn_trigger = true;
 		attrs->esn = sa_entry->esn_state.esn;
 		attrs->esn_overlap = sa_entry->esn_state.overlap;
@@ -394,6 +388,22 @@ static void _update_xfrm_state(struct work_struct *work)
 	mlx5_accel_esp_modify_xfrm(sa_entry, &modify_work->attrs);
 }
 
+static void mlx5e_ipsec_set_esn_ops(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct xfrm_state *x = sa_entry->x;
+
+	if (x->xso.type != XFRM_DEV_OFFLOAD_CRYPTO ||
+	    x->xso.dir != XFRM_DEV_OFFLOAD_OUT)
+		return;
+
+	if (x->props.flags & XFRM_STATE_ESN) {
+		sa_entry->set_iv_op = mlx5e_ipsec_set_iv_esn;
+		return;
+	}
+
+	sa_entry->set_iv_op = mlx5e_ipsec_set_iv;
+}
+
 static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 				struct netlink_ext_ack *extack)
 {
@@ -425,7 +435,8 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 		goto err_xfrm;
 
 	/* check esn */
-	mlx5e_ipsec_update_esn_state(sa_entry);
+	if (x->props.flags & XFRM_STATE_ESN)
+		mlx5e_ipsec_update_esn_state(sa_entry);
 
 	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &sa_entry->attrs);
 	/* create hw context */
@@ -446,11 +457,17 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	if (err)
 		goto err_add_rule;
 
-	if (x->xso.dir == XFRM_DEV_OFFLOAD_OUT)
-		sa_entry->set_iv_op = (x->props.flags & XFRM_STATE_ESN) ?
-				mlx5e_ipsec_set_iv_esn : mlx5e_ipsec_set_iv;
+	mlx5e_ipsec_set_esn_ops(sa_entry);
 
-	INIT_WORK(&sa_entry->modify_work.work, _update_xfrm_state);
+	switch (x->xso.type) {
+	case XFRM_DEV_OFFLOAD_CRYPTO:
+		if (x->props.flags & XFRM_STATE_ESN)
+			INIT_WORK(&sa_entry->modify_work.work,
+				  _update_xfrm_state);
+		break;
+	default:
+		break;
+	}
 out:
 	x->xso.offload_handle = (unsigned long)sa_entry;
 	return 0;
@@ -485,7 +502,15 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
 	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
 		goto sa_entry_free;
 
-	cancel_work_sync(&sa_entry->modify_work.work);
+	switch (x->xso.type) {
+	case XFRM_DEV_OFFLOAD_CRYPTO:
+		if (x->props.flags & XFRM_STATE_ESN)
+			cancel_work_sync(&sa_entry->modify_work.work);
+		break;
+	default:
+		break;
+	}
+
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 	mlx5_ipsec_free_sa_ctx(sa_entry);
 sa_entry_free:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 0c58c3583b0f..e4a606364a45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -160,7 +160,6 @@ struct mlx5e_ipsec {
 
 struct mlx5e_ipsec_esn_state {
 	u32 esn;
-	u8 trigger: 1;
 	u8 overlap: 1;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 6971e5e36820..a2e9af5e51e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -225,9 +225,6 @@ static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
 	void *obj;
 	int err;
 
-	if (!attrs->esn_trigger)
-		return 0;
-
 	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
 	if (!(general_obj_types & MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC))
 		return -EINVAL;
-- 
2.39.2

