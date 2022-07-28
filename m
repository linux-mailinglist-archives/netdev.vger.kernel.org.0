Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFA658473A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiG1UrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232260AbiG1UrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:47:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8376B248
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:46:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62F31B82591
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0510C433D6;
        Thu, 28 Jul 2022 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041216;
        bh=6eY1vbDgRb2g26T1tYsG4sk8g4qr6dAIs5unUAEQ5t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMnopwYNB+LWOu0I3r2nt0Za7HP/LVa9uRBAnS+e4bX99rMVKCirG3waTbVzbz/4Z
         KlDOMsnf4nrcbR2Pf8iagan+lvuFdKl/xbxdI9M3aQEdGrRgfEtLGHmtreymKcvAO6
         itaP9yurCB0gSWdaLWuI2hiwl6237fxgiFOoQiodjjUHQeW3DqKAcTwS3dEnN1/aMR
         STY815LpSsxB/TkkmcW/yz80Slql5wg9z3dsDKZM/GXw7XUZbcM+lhPKyUuXJLsyvv
         5XneKQRHUS37hAv65ZCxAJVq85iGjlmyx5C0brrbLeK2ujc9GoqBK5uVPzv3e8ORQo
         C3np/JCm4uSNQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net 5/9] net/mlx5e: Fix calculations related to max MPWQE size
Date:   Thu, 28 Jul 2022 13:46:36 -0700
Message-Id: <20220728204640.139990-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728204640.139990-1-saeed@kernel.org>
References: <20220728204640.139990-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Before commit 76c31e5f7585 ("net/mlx5e: Use FW limitation for max MPW
WQEBBs"), the maximum size of MPWQE in WQEBBs was hardcoded as a driver
constant. That commit started using the firmware capability that can
further limit the size, however, it unintentionally changed a few
things:

1. The calculation of MLX5E_MAX_KLM_PER_WQE used the size in DS, which
was replaced by the size in WQEBBs, making the resulting value 4 times
smaller.

2. MLX5E_TX_MPW_MAX_WQEBBS used to be aligned to the cache line size
(either 64 or 128 bytes, i.e. 1 or 2 WQEBBs), but it's no longer the
case if the firmware capability is smaller than the driver maximum.

Fix both issues by using the correct units for MLX5E_MAX_KLM_PER_WQE and
by aligning mlx5e_get_sw_max_sq_mpw_wqebbs after taking the minimum.

Besides fixing the arithmetics in calculation of MLX5E_MAX_KLM_PER_WQE,
also use appropriate constants: `size of BSF * num of DS per WQEBB *
number of WQEBBs` (the calculation before the blamed commit) doesn't
make much sense to calculate the WQE size in bytes, so just use `size of
WQEBB * number of WQEBBs`.

While at it, replace the types that hold the number of WQEBBs by u8.
These values don't exceed 16, and it allows to fill holes in two
structs.

Fixes: 76c31e5f7585 ("net/mlx5e: Use FW limitation for max MPW WQEBBs")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f794ffaf1e04..29b10ef787b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -174,8 +174,8 @@ struct page_pool;
 	ALIGN_DOWN(MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size), MLX5_UMR_KLM_ALIGNMENT)
 
 #define MLX5E_MAX_KLM_PER_WQE(mdev) \
-	MLX5E_KLM_ENTRIES_PER_WQE(mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev)) \
-				   << MLX5_MKEY_BSF_OCTO_SIZE)
+	MLX5E_KLM_ENTRIES_PER_WQE(MLX5_SEND_WQE_BB * \
+		mlx5e_get_sw_max_sq_mpw_wqebbs(mlx5e_get_max_sq_wqebbs(mdev)))
 
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
 
@@ -233,7 +233,7 @@ static inline u16 mlx5e_get_max_sq_wqebbs(struct mlx5_core_dev *mdev)
 		     MLX5_CAP_GEN(mdev, max_wqe_sz_sq) / MLX5_SEND_WQE_BB);
 }
 
-static inline u16 mlx5e_get_sw_max_sq_mpw_wqebbs(u16 max_sq_wqebbs)
+static inline u8 mlx5e_get_sw_max_sq_mpw_wqebbs(u8 max_sq_wqebbs)
 {
 /* The return value will be multiplied by MLX5_SEND_WQEBB_NUM_DS.
  * Since max_sq_wqebbs may be up to MLX5_SEND_WQE_MAX_WQEBBS == 16,
@@ -242,11 +242,12 @@ static inline u16 mlx5e_get_sw_max_sq_mpw_wqebbs(u16 max_sq_wqebbs)
  * than MLX5_SEND_WQE_MAX_WQEBBS to let a full-session WQE be
  * cache-aligned.
  */
-#if L1_CACHE_BYTES < 128
-	return min_t(u16, max_sq_wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 1);
-#else
-	return min_t(u16, max_sq_wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 2);
+	u8 wqebbs = min_t(u8, max_sq_wqebbs, MLX5_SEND_WQE_MAX_WQEBBS - 1);
+
+#if L1_CACHE_BYTES >= 128
+	wqebbs = ALIGN_DOWN(wqebbs, 2);
 #endif
+	return wqebbs;
 }
 
 struct mlx5e_tx_wqe {
@@ -455,7 +456,7 @@ struct mlx5e_txqsq {
 	struct netdev_queue       *txq;
 	u32                        sqn;
 	u16                        stop_room;
-	u16                        max_sq_mpw_wqebbs;
+	u8                         max_sq_mpw_wqebbs;
 	u8                         min_inline_mode;
 	struct device             *pdev;
 	__be32                     mkey_be;
@@ -570,7 +571,7 @@ struct mlx5e_xdpsq {
 	struct device             *pdev;
 	__be32                     mkey_be;
 	u16                        stop_room;
-	u16                        max_sq_mpw_wqebbs;
+	u8                         max_sq_mpw_wqebbs;
 	u8                         min_inline_mode;
 	unsigned long              state;
 	unsigned int               hw_mtu;
-- 
2.37.1

