Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BCA43BFFC
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbhJ0ChO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238424AbhJ0ChI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E060C60F92;
        Wed, 27 Oct 2021 02:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302084;
        bh=n57fnboODMeUHzwxrj21X2HxDWi6IcA5VcnepuhmxY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQ4oXljWnBUSem6KMuUthKO7trzoCvA0xF7qT9Edws4n6pbGAjIkrBqdi0Gq4Mp1K
         66Z0k3RQToB5K5WrC/v+8uingRC6TxJlY4heCxRdol7VpohL7DGAKffLo+pZAsZt/7
         g76V82HiU5+H8crvrIYYXPtCm4Tz7HvjpzH8/YqSh7aNEeDc3gtknyd5TaFtodSlVe
         GF43begxlY2c8TpiPwnN85sN46QhoNtGFuZwmHhi237eDMdJxWVJgoZcyfsxi7pHzE
         42H2xlBjqMHnLb+gVa2vjkpwyRiNW6ghBnyvZDmRvj7njiRBbJ//AYZa3acJ/R64mi
         aXqmQ20qJMD7A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/14] net/mlx5e: Add support to klm_umr_wqe
Date:   Tue, 26 Oct 2021 19:33:39 -0700
Message-Id: <20211027023347.699076-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

This commit adds the needed definitions for using the klm_umr_wqe.
UMR stands for user-mode memory registration, is a mechanism to alter
address translation properties of MKEY by posting WorkQueueElement
aka WQE on send queue.
MKEY stands for memory key, MKEY are used to describe a region in memory that
can be later used by HW.
KLM stands for {Key, Length, MemVa}, KLM_MKEY is indirect MKEY that enables
to map multiple memory spaces with different sizes in unified MKEY.
klm_umr_wqe is a UMR that use to update a KLM_MKEY.
SHAMPO feature uses KLM_MKEY for memory registration of his header buffer.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 24 +++++++++++++++++++-
 include/linux/mlx5/device.h                  |  1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8c3e7464b30f..98b56d8bddb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -152,6 +152,25 @@ struct page_pool;
 #define MLX5E_UMR_WQEBBS \
 	(DIV_ROUND_UP(MLX5E_UMR_WQE_INLINE_SZ, MLX5_SEND_WQE_BB))
 
+#define MLX5E_KLM_UMR_WQE_SZ(sgl_len)\
+	(sizeof(struct mlx5e_umr_wqe) +\
+	(sizeof(struct mlx5_klm) * (sgl_len)))
+
+#define MLX5E_KLM_UMR_WQEBBS(klm_entries) \
+	(DIV_ROUND_UP(MLX5E_KLM_UMR_WQE_SZ(klm_entries), MLX5_SEND_WQE_BB))
+
+#define MLX5E_KLM_UMR_DS_CNT(klm_entries)\
+	(DIV_ROUND_UP(MLX5E_KLM_UMR_WQE_SZ(klm_entries), MLX5_SEND_WQE_DS))
+
+#define MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size)\
+	(((wqe_size) - sizeof(struct mlx5e_umr_wqe)) / sizeof(struct mlx5_klm))
+
+#define MLX5E_KLM_ENTRIES_PER_WQE(wqe_size)\
+	ALIGN_DOWN(MLX5E_KLM_MAX_ENTRIES_PER_WQE(wqe_size), MLX5_UMR_KLM_ALIGNMENT)
+
+#define MLX5E_MAX_KLM_PER_WQE(mdev) \
+	MLX5E_KLM_ENTRIES_PER_WQE(MLX5E_TX_MPW_MAX_NUM_DS << MLX5_MKEY_BSF_OCTO_SIZE)
+
 #define MLX5E_MSG_LEVEL			NETIF_MSG_LINK
 
 #define mlx5e_dbg(mlevel, priv, format, ...)                    \
@@ -217,7 +236,10 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	struct mlx5_mtt                inline_mtts[0];
+	union {
+		struct mlx5_mtt inline_mtts[0];
+		struct mlx5_klm inline_klms[0];
+	};
 };
 
 enum mlx5e_priv_flag {
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 0d30a6184e1d..c920e5932368 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -290,6 +290,7 @@ enum {
 	MLX5_UMR_INLINE			= (1 << 7),
 };
 
+#define MLX5_UMR_KLM_ALIGNMENT 4
 #define MLX5_UMR_MTT_ALIGNMENT 0x40
 #define MLX5_UMR_MTT_MASK      (MLX5_UMR_MTT_ALIGNMENT - 1)
 #define MLX5_UMR_MTT_MIN_CHUNK_SIZE MLX5_UMR_MTT_ALIGNMENT
-- 
2.31.1

