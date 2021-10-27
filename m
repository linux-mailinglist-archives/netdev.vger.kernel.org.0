Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2885343BFF5
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhJ0ChM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238344AbhJ0ChH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55395610CB;
        Wed, 27 Oct 2021 02:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302082;
        bh=uPxvntKy3LTnxcOW0xYnc4GOuTRkIa2+1pNZhEMChGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0Xl5u5AvRhGj46XVMzTN5/O9TzeqHhu+gNhCBa+NBLc0SLURr5WzkYQX4d+NTpkJ
         6VBXagJHe8O92sf9r/ux1YnpQnVAwxjGUd8YZdHUE9zs8lBBerRvqSBwu8+ZIN0Sod
         iXogdJ7WOYfzZX9hRr+Fb5O7jp3Jj2C1KBaTz7xDBZSx6G5XgaHvZJvjoB8jIecs0X
         YjIza3yheTuynUHUrJuYlfi5ZZWel+o3kS4oCRcQtQwDCrVAnRK7God8OfFPaemSYs
         Rzf2QrC02b117aR9cZQqsZw8UV1UZ402inqkKSlRLrc36Vjo/LE+r1r3uKdTEOpgV+
         9DZSuaue5ENdw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/14] net/mlx5e: Rename lro_timeout to packet_merge_timeout
Date:   Tue, 26 Oct 2021 19:33:36 -0700
Message-Id: <20211027023347.699076-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

TIR stands for transport interface receive, the TIR object is
responsible for performing all transport related operations on
the receive side like packet processing, demultiplexing the packets
to different RQ's, etc.
lro_timeout is a field in the TIR that is used to set the timeout for lro
session, this series introduces new packet merge type, therefore rename
lro_timeout to packet_merge_timeout for all packet merge types.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c    | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 2 +-
 include/linux/mlx5/mlx5_ifc.h                       | 6 +++---
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3a4fece0cac..26e3f413386a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -265,7 +265,7 @@ struct mlx5e_params {
 	bool scatter_fcs_en;
 	bool rx_dim_enabled;
 	bool tx_dim_enabled;
-	u32 lro_timeout;
+	u32 packet_merge_timeout;
 	u32 pflags;
 	struct bpf_prog *xdp_prog;
 	struct mlx5e_xsk *xsk;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 3cbb596821e8..2b2b3c5cdbd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -173,7 +173,7 @@ struct mlx5e_lro_param mlx5e_get_lro_param(struct mlx5e_params *params)
 
 	lro_param = (struct mlx5e_lro_param) {
 		.enabled = params->lro_en,
-		.timeout = params->lro_timeout,
+		.timeout = params->packet_merge_timeout,
 	};
 
 	return lro_param;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
index de936dc4bc48..857ea0979159 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
@@ -82,9 +82,9 @@ void mlx5e_tir_builder_build_lro(struct mlx5e_tir_builder *builder,
 	if (!lro_param->enabled)
 		return;
 
-	MLX5_SET(tirc, tirc, lro_enable_mask,
-		 MLX5_TIRC_LRO_ENABLE_MASK_IPV4_LRO |
-		 MLX5_TIRC_LRO_ENABLE_MASK_IPV6_LRO);
+	MLX5_SET(tirc, tirc, packet_merge_mask,
+		 MLX5_TIRC_PACKET_MERGE_MASK_IPV4_LRO |
+		 MLX5_TIRC_PACKET_MERGE_MASK_IPV6_LRO);
 	MLX5_SET(tirc, tirc, lro_max_ip_payload_size,
 		 (MLX5E_PARAMS_DEFAULT_LRO_WQE_SZ - rough_max_l2_l3_hdr_sz) >> 8);
 	MLX5_SET(tirc, tirc, lro_timeout_period_usecs, lro_param->timeout);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f3dec58026d9..0e7a8afeb9bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4404,7 +4404,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 		if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, NULL))
 			params->lro_en = !slow_pci_heuristic(mdev);
 	}
-	params->lro_timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
+	params->packet_merge_timeout = mlx5e_choose_lro_timeout(mdev, MLX5E_DEFAULT_LRO_TIMEOUT);
 
 	/* CQ moderation params */
 	rx_cq_period_mode = MLX5_CAP_GEN(mdev, cq_period_start_from_cqe) ?
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 746381eccccf..21c0fd478afa 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3361,8 +3361,8 @@ enum {
 };
 
 enum {
-	MLX5_TIRC_LRO_ENABLE_MASK_IPV4_LRO  = 0x1,
-	MLX5_TIRC_LRO_ENABLE_MASK_IPV6_LRO  = 0x2,
+	MLX5_TIRC_PACKET_MERGE_MASK_IPV4_LRO  = BIT(0),
+	MLX5_TIRC_PACKET_MERGE_MASK_IPV6_LRO  = BIT(1),
 };
 
 enum {
@@ -3387,7 +3387,7 @@ struct mlx5_ifc_tirc_bits {
 
 	u8         reserved_at_80[0x4];
 	u8         lro_timeout_period_usecs[0x10];
-	u8         lro_enable_mask[0x4];
+	u8         packet_merge_mask[0x4];
 	u8         lro_max_ip_payload_size[0x8];
 
 	u8         reserved_at_a0[0x40];
-- 
2.31.1

