Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98506CFDA6
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjC3ID2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjC3IDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:03:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D0F35AD
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 01:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F16661F15
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 08:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A51C4339B;
        Thu, 30 Mar 2023 08:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680163387;
        bh=IT4x4cH3S175DnuhSFV9MI5DGJ/k4B8eukGQ6xePw6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q0KZMAhwpQAAuI/mysAFUfg7N/VwigmTKQUrGZePFy7ncUTTR3AYYg7YQX5BMhzQt
         6UJNWMe1uego7qls4j8i4nikQlNwM15Fv1gw01+9+9WljSr2EVavo1YYxjIF8SzBeB
         vEnxCGTdARW7qj5eHnNaXMtC5xkB4Lw7YkPSBgmSqskbSEzFuNBNNFVbLllcJI2c2v
         h2ttA7F3D5fs+4bPbNEaGl8rvd209C93kFVxR7dIDGRFNjxhtJVLLliIXfv0/qvphe
         0jkhI/L4bpznDCgB9NlWfAgN+3JGt26YXyMcMisDn2MNgFICTMp59OxV3I9wvtluYE
         zL3BliD3kstug==
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
Subject: [PATCH net-next 07/10] net/mlx5e: Set IPsec replay sequence numbers
Date:   Thu, 30 Mar 2023 11:02:28 +0300
Message-Id: <a9b17827eff2b29a4951225efa684a6cd38f74fe.1680162300.git.leonro@nvidia.com>
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

"ip xfrm state ..." command allows users to configure replay sequence
numbers with replay-seq* arguments for RX and replay-oseq* for TX.

Add the needed driver logic to support setting them.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 48 +++++++++++++++----
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 14 ++++--
 .../mlx5/core/en_accel/ipsec_offload.c        | 22 +++++----
 3 files changed, 60 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 067704307851..b8058f89365e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -52,18 +52,46 @@ static struct mlx5e_ipsec_pol_entry *to_ipsec_pol_entry(struct xfrm_policy *x)
 
 static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct xfrm_replay_state_esn *replay_esn;
+	struct xfrm_state *x = sa_entry->x;
 	u32 seq_bottom = 0;
+	u32 esn, esn_msb;
 	u8 overlap;
 
-	replay_esn = sa_entry->x->replay_esn;
-	if (replay_esn->seq >= replay_esn->replay_window)
-		seq_bottom = replay_esn->seq - replay_esn->replay_window + 1;
+	switch (x->xso.type) {
+	case XFRM_DEV_OFFLOAD_PACKET:
+		switch (x->xso.dir) {
+		case XFRM_DEV_OFFLOAD_IN:
+			esn = x->replay_esn->seq;
+			esn_msb = x->replay_esn->seq_hi;
+			break;
+		case XFRM_DEV_OFFLOAD_OUT:
+			esn = x->replay_esn->oseq;
+			esn_msb = x->replay_esn->oseq_hi;
+			break;
+		default:
+			WARN_ON(true);
+			return false;
+		}
+		break;
+	case XFRM_DEV_OFFLOAD_CRYPTO:
+		/* Already parsed by XFRM core */
+		esn = x->replay_esn->seq;
+		break;
+	default:
+		WARN_ON(true);
+		return false;
+	}
 
 	overlap = sa_entry->esn_state.overlap;
 
-	sa_entry->esn_state.esn = xfrm_replay_seqhi(sa_entry->x,
-						    htonl(seq_bottom));
+	if (esn >= x->replay_esn->replay_window)
+		seq_bottom = esn - x->replay_esn->replay_window + 1;
+
+	if (x->xso.type == XFRM_DEV_OFFLOAD_CRYPTO)
+		esn_msb = xfrm_replay_seqhi(x, htonl(seq_bottom));
+
+	sa_entry->esn_state.esn = esn;
+	sa_entry->esn_state.esn_msb = esn_msb;
 
 	if (unlikely(overlap && seq_bottom < MLX5E_IPSEC_ESN_SCOPE_MID)) {
 		sa_entry->esn_state.overlap = 0;
@@ -224,10 +252,10 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 
 	/* esn */
 	if (x->props.flags & XFRM_STATE_ESN) {
-		attrs->esn_trigger = true;
-		attrs->esn = sa_entry->esn_state.esn;
-		attrs->esn_overlap = sa_entry->esn_state.overlap;
-		attrs->replay_window = x->replay_esn->replay_window;
+		attrs->replay_esn.trigger = true;
+		attrs->replay_esn.esn = sa_entry->esn_state.esn;
+		attrs->replay_esn.esn_msb = sa_entry->esn_state.esn_msb;
+		attrs->replay_esn.overlap = sa_entry->esn_state.overlap;
 	}
 
 	attrs->dir = x->xso.dir;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index e4a606364a45..8d5ce65def9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -67,8 +67,15 @@ struct mlx5_ipsec_lft {
 	u64 numb_rounds_soft;
 };
 
+struct mlx5_replay_esn {
+	u32 replay_window;
+	u32 esn;
+	u32 esn_msb;
+	u8 overlap : 1;
+	u8 trigger : 1;
+};
+
 struct mlx5_accel_esp_xfrm_attrs {
-	u32   esn;
 	u32   spi;
 	u32   flags;
 	struct aes_gcm_keymat aes_gcm;
@@ -85,11 +92,9 @@ struct mlx5_accel_esp_xfrm_attrs {
 
 	struct upspec upspec;
 	u8 dir : 2;
-	u8 esn_overlap : 1;
-	u8 esn_trigger : 1;
 	u8 type : 2;
 	u8 family;
-	u32 replay_window;
+	struct mlx5_replay_esn replay_esn;
 	u32 authsize;
 	u32 reqid;
 	struct mlx5_ipsec_lft lft;
@@ -160,6 +165,7 @@ struct mlx5e_ipsec {
 
 struct mlx5e_ipsec_esn_state {
 	u32 esn;
+	u32 esn_msb;
 	u8 overlap: 1;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index a2e9af5e51e1..c974c6153d89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -76,15 +76,17 @@ static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
 	void *aso_ctx;
 
 	aso_ctx = MLX5_ADDR_OF(ipsec_obj, obj, ipsec_aso);
-	if (attrs->esn_trigger) {
+	if (attrs->replay_esn.trigger) {
 		MLX5_SET(ipsec_aso, aso_ctx, esn_event_arm, 1);
 
 		if (attrs->dir == XFRM_DEV_OFFLOAD_IN) {
 			MLX5_SET(ipsec_aso, aso_ctx, window_sz,
-				 attrs->replay_window / 64);
+				 attrs->replay_esn.replay_window / 64);
 			MLX5_SET(ipsec_aso, aso_ctx, mode,
 				 MLX5_IPSEC_ASO_REPLAY_PROTECTION);
-			}
+		}
+		MLX5_SET(ipsec_aso, aso_ctx, mode_parameter,
+			 attrs->replay_esn.esn);
 	}
 
 	/* ASO context */
@@ -136,10 +138,10 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 	salt_iv_p = MLX5_ADDR_OF(ipsec_obj, obj, implicit_iv);
 	memcpy(salt_iv_p, &aes_gcm->seq_iv, sizeof(aes_gcm->seq_iv));
 	/* esn */
-	if (attrs->esn_trigger) {
+	if (attrs->replay_esn.trigger) {
 		MLX5_SET(ipsec_obj, obj, esn_en, 1);
-		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
-		MLX5_SET(ipsec_obj, obj, esn_overlap, attrs->esn_overlap);
+		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->replay_esn.esn_msb);
+		MLX5_SET(ipsec_obj, obj, esn_overlap, attrs->replay_esn.overlap);
 	}
 
 	MLX5_SET(ipsec_obj, obj, dekn, sa_entry->enc_key_id);
@@ -252,8 +254,8 @@ static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
 	MLX5_SET64(ipsec_obj, obj, modify_field_select,
 		   MLX5_MODIFY_IPSEC_BITMASK_ESN_OVERLAP |
 			   MLX5_MODIFY_IPSEC_BITMASK_ESN_MSB);
-	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
-	MLX5_SET(ipsec_obj, obj, esn_overlap, attrs->esn_overlap);
+	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->replay_esn.esn_msb);
+	MLX5_SET(ipsec_obj, obj, esn_overlap, attrs->replay_esn.overlap);
 
 	/* general object fields set */
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_MODIFY_GENERAL_OBJECT);
@@ -290,7 +292,7 @@ static void mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry,
 	struct mlx5_wqe_aso_ctrl_seg data = {};
 
 	if (mode_param < MLX5E_IPSEC_ESN_SCOPE_MID) {
-		sa_entry->esn_state.esn++;
+		sa_entry->esn_state.esn_msb++;
 		sa_entry->esn_state.overlap = 0;
 	} else {
 		sa_entry->esn_state.overlap = 1;
@@ -434,7 +436,7 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 	if (ret)
 		goto unlock;
 
-	if (attrs->esn_trigger &&
+	if (attrs->replay_esn.trigger &&
 	    !MLX5_GET(ipsec_aso, aso->ctx, esn_event_arm)) {
 		u32 mode_param = MLX5_GET(ipsec_aso, aso->ctx, mode_parameter);
 
-- 
2.39.2

