Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B9D640F08
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbiLBUQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiLBUQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:16:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971F5F233B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FBF5B821A2
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547F8C433C1;
        Fri,  2 Dec 2022 20:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012162;
        bh=Vv26uo8juTQPCIxGRc87fEyl0wV+pPMFicNCakD4H08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWcPOA0AcZEyP9ZHHgDeoPKsDkGa2AGVdP8Fdy9c22v1Dbf9yw5RbruMb/iuvrY2n
         hOvyUAr2VsDveWF/mWoY2JA0fFPBiB/96JHO5kwIxSMT18+3gnGv84rSZrgVedJA3l
         kSw7wXAXa94gsEqpR/tr/CpTz/gcqm4eh61yLELMfI+Za3TZ0zdvPw7pFhsBmNDrvU
         7T9PHrsfs6R10OXaughGIACfdt08I5F+xHROCEC9Y5ycgPKbuP+ZrycpvOJk941bZD
         FkIgFW/HENH2fXWxv0+9Y5ZgFjav6MrCzusWMqdBFPVuw7+/ZnqV2+Xb/nAjfXAiTl
         fH5lUHdBF3/LQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 12/13] net/mlx5e: Handle ESN update events
Date:   Fri,  2 Dec 2022 22:14:56 +0200
Message-Id: <908e318c7d3ed3ff602c8dd9a6b793f4cb9d32d0.1670011885.git.leonro@nvidia.com>
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

Extend event logic to update ESN state (esn_msb, esn_overlap)
for an IPsec Offload context.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  5 +--
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +
 .../mlx5/core/en_accel/ipsec_offload.c        | 44 +++++++++++++++++++
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 4f176bd8395a..f5f930ea3f0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -108,9 +108,8 @@ static void mlx5e_ipsec_init_limits(struct mlx5e_ipsec_sa_entry *sa_entry,
 		x->lft.hard_packet_limit - x->lft.soft_packet_limit;
 }
 
-static void
-mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
-				   struct mlx5_accel_esp_xfrm_attrs *attrs)
+void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
+					struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct xfrm_state *x = sa_entry->x;
 	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index e7f21e449268..a92e19c4c499 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -230,6 +230,8 @@ void mlx5e_ipsec_aso_update_curlft(struct mlx5e_ipsec_sa_entry *sa_entry,
 void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv,
 				     void *ipsec_stats);
 
+void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
+					struct mlx5_accel_esp_xfrm_attrs *attrs);
 static inline struct mlx5_core_dev *
 mlx5e_ipsec_sa2dev(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 1b5014ffa257..8e3614218fc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -6,6 +6,10 @@
 #include "ipsec.h"
 #include "lib/mlx5.h"
 
+enum {
+	MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET,
+};
+
 u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 {
 	u32 caps = 0;
@@ -260,6 +264,39 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 	memcpy(&sa_entry->attrs, attrs, sizeof(sa_entry->attrs));
 }
 
+static void
+mlx5e_ipsec_aso_update_esn(struct mlx5e_ipsec_sa_entry *sa_entry,
+			   const struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+	struct mlx5_wqe_aso_ctrl_seg data = {};
+
+	data.data_mask_mode = MLX5_ASO_DATA_MASK_MODE_BITWISE_64BIT << 6;
+	data.condition_1_0_operand = MLX5_ASO_ALWAYS_TRUE | MLX5_ASO_ALWAYS_TRUE
+								    << 4;
+	data.data_offset_condition_operand = MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET;
+	data.bitwise_data = cpu_to_be64(BIT_ULL(54));
+	data.data_mask = data.bitwise_data;
+
+	mlx5e_ipsec_aso_query(sa_entry, &data);
+}
+
+static void mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry,
+					 u32 mode_param)
+{
+	struct mlx5_accel_esp_xfrm_attrs attrs = {};
+
+	if (mode_param < MLX5E_IPSEC_ESN_SCOPE_MID) {
+		sa_entry->esn_state.esn++;
+		sa_entry->esn_state.overlap = 0;
+	} else {
+		sa_entry->esn_state.overlap = 1;
+	}
+
+	mlx5e_ipsec_build_accel_xfrm_attrs(sa_entry, &attrs);
+	mlx5_accel_esp_modify_xfrm(sa_entry, &attrs);
+	mlx5e_ipsec_aso_update_esn(sa_entry, &attrs);
+}
+
 static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 {
 	struct mlx5e_ipsec_work *work =
@@ -284,6 +321,13 @@ static void mlx5e_ipsec_handle_event(struct work_struct *_work)
 		goto unlock;
 
 	aso->use_cache = true;
+	if (attrs->esn_trigger &&
+	    !MLX5_GET(ipsec_aso, aso->ctx, esn_event_arm)) {
+		u32 mode_param = MLX5_GET(ipsec_aso, aso->ctx, mode_parameter);
+
+		mlx5e_ipsec_update_esn_state(sa_entry, mode_param);
+	}
+
 	if (attrs->soft_packet_limit != XFRM_INF)
 		if (!MLX5_GET(ipsec_aso, aso->ctx, soft_lft_arm) ||
 		    !MLX5_GET(ipsec_aso, aso->ctx, hard_lft_arm) ||
-- 
2.38.1

