Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B635EEED2
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbiI2HWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbiI2HWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1823E3699
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D55F62062
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BBBC433D6;
        Thu, 29 Sep 2022 07:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436160;
        bh=+8rJaM+Ye2oy+K9s6aGi6FlDUzQxDpY2CdYhmosY0EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PWKMMDAZYAhPBi74arODr+ZjstIYxu8Y0eqmodvmKPFE3OMxmuA4tOpCl9mXZIYim
         xMTH70kVrxwRP8LIZQbVdRaAFDR0xgbTz1jCuMFm1U2aQrhi5ha5kzgcGhXYeojnkA
         VxA9vbcntCnzcKO2Q3dvqGVxnc49QwidB3dKUWXrQFrSnrUkyDbR4kQ8vjJ9NyNsyg
         a0lanpiI89nvi+b2BAd3eJuBq52tVqL7YDA8kkQrehCAYvJDdZW6vZzr91xSwvE7Yp
         jFfpuCLpKP1xhFpzeRqRu5/KnUDzcGsd0voIOz6sZ0hAHbO2EpRRxOomgX7GPk9iBc
         zHDz4rnKyExew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 03/16] net/mlx5e: xsk: Use XSK frame size as striding RQ page size
Date:   Thu, 29 Sep 2022 00:21:43 -0700
Message-Id: <20220929072156.93299-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
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

XSK RQs support striding RQ linear mode, but the stride size is always
set to PAGE_SIZE. It may be larger than the XSK frame size,
unnecessarily reducing the useful space in a WQE, but more importantly
causing UMEM data corruption in certain cases.

Normally, stride size bigger than XSK frame size is not a problem if the
hardware enforces the MTU. However, traffic between vports skips the
hardware MTU check, and oversized packets may be received.

If an oversized packet is bigger than the XSK frame but not bigger than
the stride, it will cause overwriting of the adjacent UMEM region. If
the packet takes more than one stride, they can be recycled for reuse
so it's not a problem when the XSK frame size matches the stride size.

To reduce the impact of the above issue, attempt to use the MTT page
size for striding RQ that matches the XSK frame size, allowing to safely
use 2048-byte frames on an up-to-date firmware.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 37 ++++++++++++++++---
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 1a0d8f9102df..593b684d21d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -6,6 +6,7 @@
 #include "en/port.h"
 #include "en_accel/en_accel.h"
 #include "en_accel/ipsec.h"
+#include <net/xdp_sock_drv.h>
 
 static u8 mlx5e_mpwrq_min_page_shift(struct mlx5_core_dev *mdev)
 {
@@ -16,8 +17,8 @@ static u8 mlx5e_mpwrq_min_page_shift(struct mlx5_core_dev *mdev)
 
 u8 mlx5e_mpwrq_page_shift(struct mlx5_core_dev *mdev, struct mlx5e_xsk_param *xsk)
 {
+	u8 req_page_shift = xsk ? order_base_2(xsk->chunk_size) : PAGE_SHIFT;
 	u8 min_page_shift = mlx5e_mpwrq_min_page_shift(mdev);
-	u8 req_page_shift = PAGE_SHIFT;
 
 	/* Regular RQ uses order-0 pages, the NIC must be able to map them. */
 	if (WARN_ON_ONCE(!xsk && req_page_shift < min_page_shift))
@@ -933,12 +934,36 @@ static u8 mlx5e_build_icosq_log_wq_sz(struct mlx5_core_dev *mdev,
 	/* If XDP program is attached, XSK may be turned on at any time without
 	 * restarting the channel. ICOSQ must be big enough to fit UMR WQEs of
 	 * both regular RQ and XSK RQ.
-	 * Although mlx5e_mpwqe_get_log_rq_size accepts mlx5e_xsk_param, it
-	 * doesn't affect its return value, as long as params->xdp_prog != NULL,
-	 * so we can just multiply by 2.
+	 *
+	 * XSK uses different values of page_shift, and the total number of UMR
+	 * WQEBBs depends on it. This dependency is complex and not monotonic,
+	 * especially taking into consideration that some of the parameters come
+	 * from capabilities. Hence, we have to try all valid values of XSK
+	 * frame size (and page_shift) to find the maximum.
 	 */
-	if (params->xdp_prog)
-		wqebbs *= 2;
+	if (params->xdp_prog) {
+		u32 max_xsk_wqebbs = 0;
+		u8 frame_shift;
+
+		for (frame_shift = XDP_UMEM_MIN_CHUNK_SHIFT;
+		     frame_shift <= PAGE_SHIFT; frame_shift++) {
+			/* The headroom doesn't affect the calculation. */
+			struct mlx5e_xsk_param xsk = {
+				.chunk_size = 1 << frame_shift,
+			};
+			u32 xsk_wqebbs;
+			u8 page_shift;
+
+			page_shift = mlx5e_mpwrq_page_shift(mdev, &xsk);
+			xsk_wqebbs = mlx5e_mpwrq_umr_wqebbs(mdev, page_shift) *
+				(1 << mlx5e_mpwqe_get_log_rq_size(mdev, params, &xsk));
+
+			if (xsk_wqebbs > max_xsk_wqebbs)
+				max_xsk_wqebbs = xsk_wqebbs;
+		}
+
+		wqebbs += max_xsk_wqebbs;
+	}
 
 	if (params->packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO)
 		wqebbs += mlx5e_shampo_icosq_sz(mdev, params, rqp);
-- 
2.37.3

