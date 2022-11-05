Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3351361D81D
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiKEHKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKEHKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:10:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B745D2EF3C
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 00:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27C9A60A26
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44880C433D7;
        Sat,  5 Nov 2022 07:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667632240;
        bh=YcAd1DH8ENEwm6OlT2xHaN0wYK0NtFKH1ydOH308+s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utp2iRigh2SHkPWjgEzJNWXBqERKNh5v7wmAokfrCzRCwyoyj5PkOuYShRZiv7AOr
         onbdUXjAt8Y007vUyMeTLAOzkHXto2Tf933YcAIk63cibj3MAs8netdjkG/3L1FsPc
         Ib1ozPMhM6ZfC+Tztw14M2B+lWe14xFQrQy8j/+IBQlJexra8pmm22Tgo+KbwOmmmj
         NAVEj03ZAFPOTlm2k/xCP/og6C85oknkO0h0QQWSVUpjMFpWuSblmuyfD3sGXWZ0JF
         Vs0v7fTPqiJ1W5DvIiDfSfePNiOtSWEAGQPV0Hr3N5vs2RArUYrnoJJpiY3SzL1NAK
         +ULKgzgacTkGA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [V2 net 06/11] net/mlx5e: Add missing sanity checks for max TX WQE size
Date:   Sat,  5 Nov 2022 00:10:23 -0700
Message-Id: <20221105071028.578594-7-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221105071028.578594-1-saeed@kernel.org>
References: <20221105071028.578594-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The commit cited below started using the firmware capability for the
maximum TX WQE size. This commit adds an important check to verify that
the driver doesn't attempt to exceed this capability, and also restores
another check mistakenly removed in the cited commit (a WQE must not
exceed the page size).

Fixes: c27bd1718c06 ("net/mlx5e: Read max WQEBBs on the SQ from firmware")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 24 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 ++++++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  5 ++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index cb164b62f543..853f312cd757 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -11,6 +11,27 @@
 
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
+/* IPSEC inline data includes:
+ * 1. ESP trailer: up to 255 bytes of padding, 1 byte for pad length, 1 byte for
+ *    next header.
+ * 2. ESP authentication data: 16 bytes for ICV.
+ */
+#define MLX5E_MAX_TX_IPSEC_DS DIV_ROUND_UP(sizeof(struct mlx5_wqe_inline_seg) + \
+					   255 + 1 + 1 + 16, MLX5_SEND_WQE_DS)
+
+/* 366 should be big enough to cover all L2, L3 and L4 headers with possible
+ * encapsulations.
+ */
+#define MLX5E_MAX_TX_INLINE_DS DIV_ROUND_UP(366 - INL_HDR_START_SZ + VLAN_HLEN, \
+					    MLX5_SEND_WQE_DS)
+
+/* Sync the calculation with mlx5e_sq_calc_wqe_attr. */
+#define MLX5E_MAX_TX_WQEBBS DIV_ROUND_UP(MLX5E_TX_WQE_EMPTY_DS_COUNT + \
+					 MLX5E_MAX_TX_INLINE_DS + \
+					 MLX5E_MAX_TX_IPSEC_DS + \
+					 MAX_SKB_FRAGS + 1, \
+					 MLX5_SEND_WQEBB_NUM_DS)
+
 #define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)
 
 static inline
@@ -424,6 +445,8 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 
 static inline u16 mlx5e_stop_room_for_wqe(struct mlx5_core_dev *mdev, u16 wqe_size)
 {
+	WARN_ON_ONCE(PAGE_SIZE / MLX5_SEND_WQE_BB < mlx5e_get_max_sq_wqebbs(mdev));
+
 	/* A WQE must not cross the page boundary, hence two conditions:
 	 * 1. Its size must not exceed the page size.
 	 * 2. If the WQE size is X, and the space remaining in a page is less
@@ -436,7 +459,6 @@ static inline u16 mlx5e_stop_room_for_wqe(struct mlx5_core_dev *mdev, u16 wqe_si
 		  "wqe_size %u is greater than max SQ WQEBBs %u",
 		  wqe_size, mlx5e_get_max_sq_wqebbs(mdev));
 
-
 	return MLX5E_STOP_ROOM(wqe_size);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 09296f1ae448..76861279fbda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5696,6 +5696,13 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 		mlx5e_fs_set_state_destroy(priv->fs,
 					   !test_bit(MLX5E_STATE_DESTROYING, &priv->state));
 
+	/* Validate the max_wqe_size_sq capability. */
+	if (WARN_ON_ONCE(mlx5e_get_max_sq_wqebbs(priv->mdev) < MLX5E_MAX_TX_WQEBBS)) {
+		mlx5_core_warn(priv->mdev, "MLX5E: Max SQ WQEBBs firmware capability: %u, needed %lu\n",
+			       mlx5e_get_max_sq_wqebbs(priv->mdev), MLX5E_MAX_TX_WQEBBS);
+		return -EIO;
+	}
+
 	/* max number of channels may have changed */
 	max_nch = mlx5e_calc_max_nch(priv->mdev, priv->netdev, profile);
 	if (priv->channels.params.num_channels > max_nch) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 6adca01fbdc9..f7897ddb29c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -305,6 +305,8 @@ static void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb, const struct mlx5e_tx_at
 	u16 ds_cnt_inl = 0;
 	u16 ds_cnt_ids = 0;
 
+	/* Sync the calculation with MLX5E_MAX_TX_WQEBBS. */
+
 	if (attr->insz)
 		ds_cnt_ids = DIV_ROUND_UP(sizeof(struct mlx5_wqe_inline_seg) + attr->insz,
 					  MLX5_SEND_WQE_DS);
@@ -317,6 +319,9 @@ static void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb, const struct mlx5e_tx_at
 			inl += VLAN_HLEN;
 
 		ds_cnt_inl = DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
+		if (WARN_ON_ONCE(ds_cnt_inl > MLX5E_MAX_TX_INLINE_DS))
+			netdev_warn(skb->dev, "ds_cnt_inl = %u > max %u\n", ds_cnt_inl,
+				    (u16)MLX5E_MAX_TX_INLINE_DS);
 		ds_cnt += ds_cnt_inl;
 	}
 
-- 
2.38.1

