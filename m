Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9345F2164
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiJBFOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiJBFON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772DE5143B
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD8C60DFC
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C46AC433B5;
        Sun,  2 Oct 2022 05:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687644;
        bh=QWnZvIEpj6ZoQbRfaWQo0KPVlQ0hpjq8YrdQQ17kj+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtQI2rpLVu5h8FH6LdWMgVp+LsjZXalqYtz0E7u6zMiQRA1WFwN/NsKFcEX+0d9AY
         vJnA8nkhzDXzOTgAxZ69ftlGsuEL/aPops341wCRf2GCUDsyOB7C9fxEQ3MpChB0HF
         hVtjeBmFUL72ZT0ClTRcePe6vGPLVr8Cy7zdd4s/qh8clTFQWSeq7Sjkrmg47qlEkU
         68a8jQvICQYG6de4uTiYQveS7qnmtNAo3zhRU/ttx3on0XN+fJxUaPytoYci38nlr4
         aw7vxuU57p/p+f++dYU5E9IFNAAdeWkTfX520yQ1NHlXoIyXGs/baUUHpVirfuS//3
         aX2rz8uv30+Mg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 09/15] net/mlx5e: xsk: Optimize for unaligned mode with 3072-byte frames
Date:   Sat,  1 Oct 2022 21:56:26 -0700
Message-Id: <20221002045632.291612-10-saeed@kernel.org>
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

When XSK frame size is 3072 (or another power of two multiplied by 3),
KLM mechanism for NIC virtual memory page mapping can be optimized by
replacing it with KSM.

Before this change, two KLM entries were needed to map an XSK frame that
is not a power of two: one entry maps the UMEM memory up to the frame
length, the other maps the rest of the stride to the garbage page.

When the frame length divided by 3 is a power of two, it can be mapped
using 3 KSM entries, and the fourth will map the rest of the stride to
the garbage page. All 4 KSM entries are of the same size, which allows
for a much faster lookup.

Frame size 3072 is useful in certain use cases, because it allows
packing 4 frames into 3 pages. Generally speaking, other frame sizes
equal to PAGE_SIZE minus a power of two can be optimized in a similar
way, but it will require many more KSMs per frame, which slows down UMRs
a little bit, but more importantly may hit the limit for the maximum
number of KSM entries.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../ethernet/mellanox/mlx5/core/en/params.c   | 20 ++++++++++++++-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 18 +++++++++++--
 4 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7c6861d6148d..26a23047f1f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -681,6 +681,7 @@ enum mlx5e_mpwrq_umr_mode {
 	MLX5E_MPWRQ_UMR_MODE_ALIGNED,
 	MLX5E_MPWRQ_UMR_MODE_UNALIGNED,
 	MLX5E_MPWRQ_UMR_MODE_OVERSIZED,
+	MLX5E_MPWRQ_UMR_MODE_TRIPLE,
 };
 
 struct mlx5e_rq {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 203448ee9594..29dd3a04c154 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -56,8 +56,16 @@ mlx5e_mpwrq_umr_mode(struct mlx5_core_dev *mdev, struct mlx5e_xsk_param *xsk)
 	 * stride is mapped to a garbage page, resulting in two mappings of
 	 * different sizes per frame.
 	 */
-	if (oversized)
+	if (oversized) {
+		/* An optimization for frame sizes equal to 3 * power_of_two.
+		 * 3 KSMs point to the frame, and one KSM points to the garbage
+		 * page, which works faster than KLM.
+		 */
+		if (xsk->chunk_size % 3 == 0 && is_power_of_2(xsk->chunk_size / 3))
+			return MLX5E_MPWRQ_UMR_MODE_TRIPLE;
+
 		return MLX5E_MPWRQ_UMR_MODE_OVERSIZED;
+	}
 
 	/* XSK frames can start at arbitrary unaligned locations, but they all
 	 * have the same size which is a power of two. It allows to optimize to
@@ -82,6 +90,8 @@ u8 mlx5e_mpwrq_umr_entry_size(enum mlx5e_mpwrq_umr_mode mode)
 		return sizeof(struct mlx5_ksm);
 	case MLX5E_MPWRQ_UMR_MODE_OVERSIZED:
 		return sizeof(struct mlx5_klm) * 2;
+	case MLX5E_MPWRQ_UMR_MODE_TRIPLE:
+		return sizeof(struct mlx5_ksm) * 4;
 	}
 	WARN_ONCE(1, "MPWRQ UMR mode %d is not known\n", mode);
 	return 0;
@@ -179,6 +189,9 @@ u32 mlx5e_mpwrq_max_num_entries(struct mlx5_core_dev *mdev,
 	case MLX5E_MPWRQ_UMR_MODE_OVERSIZED:
 		/* Each entry is two KLMs. */
 		return klm_limit / 2;
+	case MLX5E_MPWRQ_UMR_MODE_TRIPLE:
+		/* Each entry is four KSMs. */
+		return klm_limit / 4;
 	}
 	WARN_ONCE(1, "MPWRQ UMR mode %d is not known\n", umr_mode);
 	return 0;
@@ -1121,6 +1134,11 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 			xsk.chunk_size -= 1;
 			max_xsk_wqebbs = max(max_xsk_wqebbs,
 				mlx5e_mpwrq_total_umr_wqebbs(mdev, params, &xsk));
+
+			/* XSK unaligned mode, frame size is a triple power of two. */
+			xsk.chunk_size = (1 << frame_shift) / 4 * 3;
+			max_xsk_wqebbs = max(max_xsk_wqebbs,
+				mlx5e_mpwrq_total_umr_wqebbs(mdev, params, &xsk));
 		}
 
 		wqebbs += max_xsk_wqebbs;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 78d746704345..c91b54d9ff27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -58,6 +58,29 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 				.va = cpu_to_be64(addr),
 			};
 		}
+	} else if (likely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_TRIPLE)) {
+		u32 mapping_size = 1 << (rq->mpwqe.page_shift - 2);
+
+		for (i = 0; i < batch; i++) {
+			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
+
+			umr_wqe->inline_ksms[i << 2] = (struct mlx5_ksm) {
+				.key = rq->mkey_be,
+				.va = cpu_to_be64(addr),
+			};
+			umr_wqe->inline_ksms[(i << 2) + 1] = (struct mlx5_ksm) {
+				.key = rq->mkey_be,
+				.va = cpu_to_be64(addr + mapping_size),
+			};
+			umr_wqe->inline_ksms[(i << 2) + 2] = (struct mlx5_ksm) {
+				.key = rq->mkey_be,
+				.va = cpu_to_be64(addr + mapping_size * 2),
+			};
+			umr_wqe->inline_ksms[(i << 2) + 3] = (struct mlx5_ksm) {
+				.key = rq->mkey_be,
+				.va = cpu_to_be64(rq->wqe_overflow.addr),
+			};
+		}
 	} else {
 		__be32 pad_size = cpu_to_be32((1 << rq->mpwqe.page_shift) -
 					      rq->xsk_pool->chunk_size);
@@ -91,6 +114,8 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		offset = offset * sizeof(struct mlx5_mtt) / MLX5_OCTWORD;
 	else if (unlikely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_OVERSIZED))
 		offset = offset * sizeof(struct mlx5_klm) * 2 / MLX5_OCTWORD;
+	else if (unlikely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_TRIPLE))
+		offset = offset * sizeof(struct mlx5_ksm) * 4 / MLX5_OCTWORD;
 	umr_wqe->uctrl.xlt_offset = cpu_to_be16(offset);
 
 	icosq->db.wqe_info[pi] = (struct mlx5e_icosq_wqe_info) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ae728745379d..d4f03ff7b0e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -301,6 +301,8 @@ static u8 mlx5e_mpwrq_access_mode(enum mlx5e_mpwrq_umr_mode umr_mode)
 		return MLX5_MKC_ACCESS_MODE_KSM;
 	case MLX5E_MPWRQ_UMR_MODE_OVERSIZED:
 		return MLX5_MKC_ACCESS_MODE_KLMS;
+	case MLX5E_MPWRQ_UMR_MODE_TRIPLE:
+		return MLX5_MKC_ACCESS_MODE_KSM;
 	}
 	WARN_ONCE(1, "MPWRQ UMR mode %d is not known\n", umr_mode);
 	return 0;
@@ -322,7 +324,8 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	int err;
 	int i;
 
-	if (umr_mode == MLX5E_MPWRQ_UMR_MODE_UNALIGNED &&
+	if ((umr_mode == MLX5E_MPWRQ_UMR_MODE_UNALIGNED ||
+	     umr_mode == MLX5E_MPWRQ_UMR_MODE_TRIPLE) &&
 	    !MLX5_CAP_GEN(mdev, fixed_buffer_size)) {
 		mlx5_core_warn(mdev, "Unaligned AF_XDP requires fixed_buffer_size capability\n");
 		return -EINVAL;
@@ -351,7 +354,9 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 	MLX5_SET(mkc, mkc, pd, mdev->mlx5e_res.hw_objs.pdn);
 	MLX5_SET64(mkc, mkc, len, npages << page_shift);
 	MLX5_SET(mkc, mkc, translations_octword_size, octwords);
-	if (umr_mode != MLX5E_MPWRQ_UMR_MODE_OVERSIZED)
+	if (umr_mode == MLX5E_MPWRQ_UMR_MODE_TRIPLE)
+		MLX5_SET(mkc, mkc, log_page_size, page_shift - 2);
+	else if (umr_mode != MLX5E_MPWRQ_UMR_MODE_OVERSIZED)
 		MLX5_SET(mkc, mkc, log_page_size, page_shift);
 	MLX5_SET(create_mkey_in, in, translations_octword_actual_size, octwords);
 
@@ -392,6 +397,15 @@ static int mlx5e_create_umr_mkey(struct mlx5_core_dev *mdev,
 				.ptag = cpu_to_be64(filler_addr),
 			};
 		break;
+	case MLX5E_MPWRQ_UMR_MODE_TRIPLE:
+		ksm = MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
+		for (i = 0; i < npages * 4; i++) {
+			ksm[i] = (struct mlx5_ksm) {
+				.key = cpu_to_be32(mdev->mlx5e_res.hw_objs.mkey),
+				.va = cpu_to_be64(filler_addr),
+			};
+		}
+		break;
 	}
 
 	err = mlx5_core_create_mkey(mdev, umr_mkey, in, inlen);
-- 
2.37.3

