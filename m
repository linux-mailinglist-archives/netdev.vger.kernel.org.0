Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF985ECEB6
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiI0UhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiI0Ugv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8697844C2
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 449C161BA2
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9436DC433D6;
        Tue, 27 Sep 2022 20:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664311009;
        bh=JCks4xhqVpfPEYb9qtuYpejRPQIGe09WxnWZXjMYN7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLlf/dEIfSywxPGDHP/oM6JGJl/2OQqRwAcER8inwVeCVfTSWj/LqAbzQhqlDuvtz
         Khtn8z1H4SCyZxQ8u+IbuX8aMYXddeVYkzijrTL30p2R09kZ4s11Lkc97vYJekODMt
         Ccbr69pMQrfWIjF/P7UKmVr5nLD/L0c1bRvpAChNiG2X5xMImE6tpKwRh7FKIE0h5d
         jQhuZjG1g3Tiwe36ppd6nLFKWJRrIqUXgE6mSoW0Ev3q0UMyyKbbnK/sJB2Y2pOZmm
         oCw3+pklRA5p6d0CKe2uN+oRgi+wwpiAIllsFyKbxkELqBbLalwQOz0u9zfqD4s8gG
         LiUjlYy4c03hQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 11/16] net/mlx5e: Simplify stride size calculation for linear RQ
Date:   Tue, 27 Sep 2022 13:36:06 -0700
Message-Id: <20220927203611.244301-12-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
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

Linear RX buffers must be big enough to fit the MTU-sized packet along
with the headroom. On the other hand, they must be small enough to fit
into a page (or into an XSK frame). A straightforward way to check
whether the linear mode is possible would be comparing the required
buffer size to PAGE_SIZE or XSK frame size.

Stride size in the linear mode is defined by the following constraints:

1. A stride is at least as big as the buffer size, and it's a power of
two.

2. If non-XSK XDP is enabled, the stride size is PAGE_SIZE, because
mlx5e requires each packet to be in its own page when XDP is in use. The
previous constraint is automatically fulfilled, because buffer size
can't be bigger than PAGE_SIZE.

3. XSK uses stride size equal to PAGE_SIZE, but the following commits
will allow it to use roundup_pow_of_two(XSK frame size), by allowing the
NIC's MMU to use page sizes not equal to the CPU page size.

This commit puts the above requirements and constraints straight to the
code in an attempt to simplify it and to prepare it for changes made in
the next patches.

For the reference, the old code uses an equivalent, but trickier
calculation (high-level simplified pseudocode):

    if XDP or XSK:
        mlx5e_rx_get_linear_frag_sz := max(buffer size, PAGE_SIZE)
    else:
        mlx5e_rx_get_linear_frag_sz := buffer size
    mlx5e_rx_is_linear_skb := mlx5e_rx_get_linear_frag_sz <= PAGE_SIZE
    stride size := roundup_pow_of_two(mlx5e_rx_get_linear_frag_sz)

The new code effectively removes mlx5e_rx_get_linear_frag_sz that used
to return either buffer size or stride size, depending on the situation,
making it hard to work with and to make changes:

    if XDP or XSK:
        mlx5e_rx_get_linear_stride_sz := PAGE_SIZE
    else
        mlx5e_rx_get_linear_stride_sz := roundup_pow_of_two(buffer size)
    mlx5e_rx_is_linear_skb := buffer size <= (PAGE_SIZE or XSK frame sz)
    stride size := mlx5e_rx_get_linear_stride_sz

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 74 ++++++++++---------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 2c8fe2e60e17..bb039c3c4039 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -39,55 +39,58 @@ u32 mlx5e_rx_get_min_frag_sz(struct mlx5e_params *params,
 	return linear_rq_headroom + hw_mtu;
 }
 
-static u32 mlx5e_rx_get_linear_frag_sz(struct mlx5e_params *params,
-				       struct mlx5e_xsk_param *xsk)
-{
-	u32 frag_sz = mlx5e_rx_get_min_frag_sz(params, xsk);
-
-	/* AF_XDP doesn't build SKBs in place. */
-	if (!xsk)
-		frag_sz = MLX5_SKB_FRAG_SZ(frag_sz);
-
-	/* XDP in mlx5e doesn't support multiple packets per page. AF_XDP is a
-	 * special case. It can run with frames smaller than a page, as it
-	 * doesn't allocate pages dynamically. However, here we pretend that
-	 * fragments are page-sized: it allows to treat XSK frames like pages
-	 * by redirecting alloc and free operations to XSK rings and by using
-	 * the fact there are no multiple packets per "page" (which is a frame).
-	 * The latter is important, because frames may come in a random order,
-	 * and we will have trouble assemblying a real page of multiple frames.
-	 */
-	if (mlx5e_rx_is_xdp(params, xsk))
-		frag_sz = max_t(u32, frag_sz, PAGE_SIZE);
+static u32 mlx5e_rx_get_linear_sz_xsk(struct mlx5e_params *params,
+				      struct mlx5e_xsk_param *xsk)
+{
+	return mlx5e_rx_get_min_frag_sz(params, xsk);
+}
 
-	/* Even if we can go with a smaller fragment size, we must not put
-	 * multiple packets into a single frame.
+static u32 mlx5e_rx_get_linear_sz_skb(struct mlx5e_params *params)
+{
+	return MLX5_SKB_FRAG_SZ(mlx5e_rx_get_min_frag_sz(params, NULL));
+}
+
+static u32 mlx5e_rx_get_linear_stride_sz(struct mlx5e_params *params,
+					 struct mlx5e_xsk_param *xsk)
+{
+	/* XSK frames are mapped as individual pages, because frames may come in
+	 * an arbitrary order from random locations in the UMEM.
 	 */
 	if (xsk)
-		frag_sz = max_t(u32, frag_sz, xsk->chunk_size);
+		return PAGE_SIZE;
 
-	return frag_sz;
+	/* XDP in mlx5e doesn't support multiple packets per page. */
+	if (params->xdp_prog)
+		return PAGE_SIZE;
+
+	return roundup_pow_of_two(mlx5e_rx_get_linear_sz_skb(params));
 }
 
 u8 mlx5e_mpwqe_log_pkts_per_wqe(struct mlx5e_params *params,
 				struct mlx5e_xsk_param *xsk)
 {
-	u32 linear_frag_sz = mlx5e_rx_get_linear_frag_sz(params, xsk);
+	u32 linear_stride_sz = mlx5e_rx_get_linear_stride_sz(params, xsk);
 
-	return MLX5_MPWRQ_LOG_WQE_SZ - order_base_2(linear_frag_sz);
+	return MLX5_MPWRQ_LOG_WQE_SZ - order_base_2(linear_stride_sz);
 }
 
 bool mlx5e_rx_is_linear_skb(struct mlx5e_params *params,
 			    struct mlx5e_xsk_param *xsk)
 {
-	/* AF_XDP allocates SKBs on XDP_PASS - ensure they don't occupy more
-	 * than one page. For this, check both with and without xsk.
+	if (params->packet_merge.type != MLX5E_PACKET_MERGE_NONE)
+		return false;
+
+	/* Both XSK and non-XSK cases allocate an SKB on XDP_PASS. Packet data
+	 * must fit into a CPU page.
 	 */
-	u32 linear_frag_sz = max(mlx5e_rx_get_linear_frag_sz(params, xsk),
-				 mlx5e_rx_get_linear_frag_sz(params, NULL));
+	if (mlx5e_rx_get_linear_sz_skb(params) > PAGE_SIZE)
+		return false;
+
+	/* XSK frames must be big enough to hold the packet data. */
+	if (xsk && mlx5e_rx_get_linear_sz_xsk(params, xsk) > xsk->chunk_size)
+		return false;
 
-	return params->packet_merge.type == MLX5E_PACKET_MERGE_NONE &&
-		linear_frag_sz <= PAGE_SIZE;
+	return true;
 }
 
 static bool mlx5e_verify_rx_mpwqe_strides(struct mlx5_core_dev *mdev,
@@ -119,7 +122,7 @@ bool mlx5e_rx_mpwqe_is_linear_skb(struct mlx5_core_dev *mdev,
 	if (!mlx5e_rx_is_linear_skb(params, xsk))
 		return false;
 
-	log_stride_sz = order_base_2(mlx5e_rx_get_linear_frag_sz(params, xsk));
+	log_stride_sz = order_base_2(mlx5e_rx_get_linear_stride_sz(params, xsk));
 	log_num_strides = MLX5_MPWRQ_LOG_WQE_SZ - log_stride_sz;
 
 	return mlx5e_verify_rx_mpwqe_strides(mdev, log_stride_sz, log_num_strides);
@@ -164,7 +167,7 @@ u8 mlx5e_mpwqe_get_log_stride_size(struct mlx5_core_dev *mdev,
 				   struct mlx5e_xsk_param *xsk)
 {
 	if (mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk))
-		return order_base_2(mlx5e_rx_get_linear_frag_sz(params, xsk));
+		return order_base_2(mlx5e_rx_get_linear_stride_sz(params, xsk));
 
 	return MLX5_MPWRQ_DEF_LOG_STRIDE_SZ(mdev);
 }
@@ -426,8 +429,7 @@ static int mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	if (mlx5e_rx_is_linear_skb(params, xsk)) {
 		int frag_stride;
 
-		frag_stride = mlx5e_rx_get_linear_frag_sz(params, xsk);
-		frag_stride = roundup_pow_of_two(frag_stride);
+		frag_stride = mlx5e_rx_get_linear_stride_sz(params, xsk);
 
 		info->arr[0].frag_size = byte_count;
 		info->arr[0].frag_stride = frag_stride;
-- 
2.37.3

