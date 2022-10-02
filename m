Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCE35F2160
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiJBFOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJBFOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D037351413
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08D7A60DF3
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E55C433C1;
        Sun,  2 Oct 2022 05:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687641;
        bh=TFMj1IbBKROezWY260tWLS8LECNhXm4lptmmhspvN8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbUt/3cm7uIMdD1UC88sKie/Vrtkzcqio0g7E2Mv2dQUdp5zi1CgRu4Nx+QUxf1CC
         E7hTLWDVHhwMiLBx/6mTUqfxDPpLhJgtm8bLqmmCCtt1KJLUmRZZWelk0VjLi8ctZf
         QLKBP/6cbwxdzLtKnWT3tdcfzzdGXXuNHEa/FYevvomxX/ylyFL9QoSGeSe9vFizE0
         UQ/pzyengQ1ovp/b0qBp9CYCeQpxkcyH/upg166ViN7lQOBtrvrRExRFn1oQkV6Z8l
         BiQPp2bCVUDqnRuC3gqn47T1plFqymCvIAaTW7WCaowLV0rNO0bsSfdHP+c9SKEM4v
         9/GBk6KdaCGBg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 06/15] net/mlx5e: Improve MTT/KSM alignment
Date:   Sat,  1 Oct 2022 21:56:23 -0700
Message-Id: <20221002045632.291612-7-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221002045632.291612-1-saeed@kernel.org>
References: <20221002045632.291612-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Make mlx5e_mpwrq_mtts_per_wqe take into account that KSM requires
smaller alignment than MTT.

Ensure that there is always an even amount of MTTs in a UMR WQE, so that
complete octwords are formed, and no garbage is mapped.

Drop extra alignment in MLX5_MTT_OCTW that may cause setting too big
ucseg->xlt_octowords, also leading to mapping garbage.

Generalize some calculations by introducing the MLX5_OCTWORD constant.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        |  6 +-----
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 10 +++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 13 +++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     |  2 +-
 5 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a2d09f30acd1..93607db1dea4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -109,12 +109,8 @@ struct page_pool;
 #define MLX5_MPWRQ_MAX_PAGES_PER_WQE \
 	rounddown_pow_of_two(MLX5_UMR_MAX_MTT_SPACE / sizeof(struct mlx5_mtt))
 
-#define MLX5_ALIGN_MTTS(mtts)		(ALIGN(mtts, 8))
-#define MLX5_ALIGNED_MTTS_OCTW(mtts)	((mtts) / 2)
-#define MLX5_MTT_OCTW(mtts)		(MLX5_ALIGNED_MTTS_OCTW(MLX5_ALIGN_MTTS(mtts)))
-#define MLX5_KSM_OCTW(ksms)             (ksms)
 #define MLX5E_MAX_RQ_NUM_MTTS	\
-	(ALIGN_DOWN(U16_MAX, 4) * 2) /* So that MLX5_MTT_OCTW(num_mtts) fits into u16 */
+	(ALIGN_DOWN(U16_MAX, 4) * 2) /* Fits into u16 and aligned by WQEBB. */
 #define MLX5E_MAX_RQ_NUM_KSMS (U16_MAX - 1) /* So that num_ksms fits into u16. */
 #define MLX5E_ORDER2_MAX_PACKET_MTU (order_base_2(10 * 1024))
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index b57855bf7629..e8c3b8abf941 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -91,6 +91,13 @@ u8 mlx5e_mpwrq_pages_per_wqe(struct mlx5_core_dev *mdev, u8 page_shift,
 
 	pages_per_wqe = log_wqe_sz > page_shift ? (1 << (log_wqe_sz - page_shift)) : 1;
 
+	/* Two MTTs are needed to form an octword. The number of MTTs is encoded
+	 * in octwords in a UMR WQE, so we need at least two to avoid mapping
+	 * garbage addresses.
+	 */
+	if (WARN_ON_ONCE(pages_per_wqe < 2 && umr_mode == MLX5E_MPWRQ_UMR_MODE_ALIGNED))
+		pages_per_wqe = 2;
+
 	/* Sanity check for further calculations to succeed. */
 	BUILD_BUG_ON(MLX5_MPWRQ_MAX_PAGES_PER_WQE > 64);
 	if (WARN_ON_ONCE(pages_per_wqe > MLX5_MPWRQ_MAX_PAGES_PER_WQE))
@@ -131,7 +138,8 @@ u8 mlx5e_mpwrq_mtts_per_wqe(struct mlx5_core_dev *mdev, u8 page_shift,
 	 * MTU. These oversize packets are dropped by the driver at a later
 	 * stage.
 	 */
-	return MLX5_ALIGN_MTTS(pages_per_wqe + 1);
+	return ALIGN(pages_per_wqe + 1,
+		     MLX5_SEND_WQE_BB / mlx5e_mpwrq_umr_entry_size(umr_mode));
 }
 
 u32 mlx5e_mpwrq_max_num_entries(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index e12a856331b8..4b2df2895505 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -66,9 +66,10 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	umr_wqe->ctrl.opmod_idx_opcode =
 		cpu_to_be32((icosq->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) | MLX5_OPCODE_UMR);
 
+	/* Optimized for speed: keep in sync with mlx5e_mpwrq_umr_entry_size. */
 	offset = ix * rq->mpwqe.mtts_per_wqe;
 	if (likely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_ALIGNED))
-		offset = MLX5_ALIGNED_MTTS_OCTW(offset);
+		offset = offset * sizeof(struct mlx5_mtt) / MLX5_OCTWORD;
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(offset);
 
 	icosq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b5a416ff1603..2093b6cc6c7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -205,14 +205,11 @@ static void mlx5e_disable_blocking_events(struct mlx5e_priv *priv)
 
 static u16 mlx5e_mpwrq_umr_octowords(u32 entries, enum mlx5e_mpwrq_umr_mode umr_mode)
 {
-	switch (umr_mode) {
-	case MLX5E_MPWRQ_UMR_MODE_ALIGNED:
-		return MLX5_MTT_OCTW(entries);
-	case MLX5E_MPWRQ_UMR_MODE_UNALIGNED:
-		return MLX5_KSM_OCTW(entries);
-	}
-	WARN_ONCE(1, "MPWRQ UMR mode %d is not known\n", umr_mode);
-	return 0;
+	u8 umr_entry_size = mlx5e_mpwrq_umr_entry_size(umr_mode);
+
+	WARN_ON_ONCE(entries * umr_entry_size % MLX5_OCTWORD);
+
+	return entries * umr_entry_size / MLX5_OCTWORD;
 }
 
 static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b61604d87701..58084650151f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -682,7 +682,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		cpu_to_be32((sq->pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
 			    MLX5_OPCODE_UMR);
 
-	offset = MLX5_ALIGNED_MTTS_OCTW(ix * rq->mpwqe.mtts_per_wqe);
+	offset = (ix * rq->mpwqe.mtts_per_wqe) * sizeof(struct mlx5_mtt) / MLX5_OCTWORD;
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(offset);
 
 	sq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
-- 
2.37.3

