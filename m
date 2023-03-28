Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6676CCBB4
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjC1U5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjC1U5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:57:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8EB2117
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:57:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68BD3B81E74
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15248C433EF;
        Tue, 28 Mar 2023 20:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680037019;
        bh=IUZ8xjtr5IR2EnJKE79NvLe78eYmdkm6LCKiGVkFafQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLxA6z1aoXL1yF2X3XIpPnqubINIXi8LsH9bIUfnxeCsmXpy3VWOoBJom9AZAfGaw
         +IUHXbkqSSVrMj1Q6EhtKfoo9luRl3CfH/T48Dk94XdSox9553OpqyDc8GNbbOnRy+
         rhN3YlB/Lq80+BPE1Q/h9GJ/Vi/ua7NgwnYSemrhjcv1KXygRY+Xqn+F36hR7ZuxDs
         drBfcmXUzn7GCMO6PjcRJkH+fyr3scfvxB8/bqNUfbEjKR4ar9BU9PK71zQ2ijM7Kh
         2yIepglNfDCsB096VQSJIQj24PqtzRI/GpXLlgNLRK15ZPa/mHDpm54D5AiZZmaWnR
         s4u53Id/+Ao6w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: RX, Increase WQE bulk size for legacy rq
Date:   Tue, 28 Mar 2023 13:56:21 -0700
Message-Id: <20230328205623.142075-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328205623.142075-1-saeed@kernel.org>
References: <20230328205623.142075-1-saeed@kernel.org>
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

From: Dragos Tatulea <dtatulea@nvidia.com>

Deferred page release was added to legacy rq but its desired effect
(driver releases last fragment to page pool cache) is not yet visible
due to the WQE bulks being too small.

This patch increases the WQE bulk size to span 512 KB and clip it to
one quarter of the rx queue size.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/params.c   | 47 +++++++++++++++++--
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 613a7daf9595..a087c433366b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -670,7 +670,7 @@ struct mlx5e_rq_frags_info {
 	struct mlx5e_rq_frag_info arr[MLX5E_MAX_RX_FRAGS];
 	u8 num_frags;
 	u8 log_num_frags;
-	u8 wqe_bulk;
+	u16 wqe_bulk;
 	u8 wqe_index_mask;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 561da78d3b5c..40218d77ef34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -667,6 +667,43 @@ static int mlx5e_max_nonlinear_mtu(int first_frag_size, int frag_size, bool xdp)
 	return first_frag_size + (MLX5E_MAX_RX_FRAGS - 2) * frag_size + PAGE_SIZE;
 }
 
+static void mlx5e_rx_compute_wqe_bulk_params(struct mlx5e_params *params,
+					     struct mlx5e_rq_frags_info *info)
+{
+	u16 bulk_bound_rq_size = (1 << params->log_rq_mtu_frames) / 4;
+	u32 bulk_bound_rq_size_in_bytes;
+	u32 sum_frag_strides = 0;
+	u32 wqe_bulk_in_bytes;
+	u32 wqe_bulk;
+	int i;
+
+	for (i = 0; i < info->num_frags; i++)
+		sum_frag_strides += info->arr[i].frag_stride;
+
+	/* For MTUs larger than PAGE_SIZE, align to PAGE_SIZE to reflect
+	 * amount of consumed pages per wqe in bytes.
+	 */
+	if (sum_frag_strides > PAGE_SIZE)
+		sum_frag_strides = ALIGN(sum_frag_strides, PAGE_SIZE);
+
+	bulk_bound_rq_size_in_bytes = bulk_bound_rq_size * sum_frag_strides;
+
+#define MAX_WQE_BULK_BYTES(xdp) ((xdp ? 256 : 512) * 1024)
+
+	/* A WQE bulk should not exceed min(512KB, 1/4 of rq size). For XDP
+	 * keep bulk size smaller to avoid filling the page_pool cache on
+	 * every bulk refill.
+	 */
+	wqe_bulk_in_bytes = min_t(u32, MAX_WQE_BULK_BYTES(params->xdp_prog),
+				  bulk_bound_rq_size_in_bytes);
+	wqe_bulk = DIV_ROUND_UP(wqe_bulk_in_bytes, sum_frag_strides);
+
+	/* Make sure that allocations don't start when the page is still used
+	 * by older WQEs.
+	 */
+	info->wqe_bulk = max_t(u16, info->wqe_index_mask + 1, wqe_bulk);
+}
+
 #define DEFAULT_FRAG_SIZE (2048)
 
 static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
@@ -774,11 +811,13 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	}
 
 out:
-	/* Bulking optimization to skip allocation until at least 8 WQEs can be
-	 * allocated in a row. At the same time, never start allocation when
-	 * the page is still used by older WQEs.
+	/* Bulking optimization to skip allocation until a large enough number
+	 * of WQEs can be allocated in a row. Bulking also influences how well
+	 * deferred page release works.
 	 */
-	info->wqe_bulk = max_t(u8, info->wqe_index_mask + 1, 8);
+	mlx5e_rx_compute_wqe_bulk_params(params, info);
+
+	mlx5_core_dbg(mdev, "%s: wqe_bulk = %u\n", __func__, info->wqe_bulk);
 
 	info->log_num_frags = order_base_2(info->num_frags);
 
-- 
2.39.2

