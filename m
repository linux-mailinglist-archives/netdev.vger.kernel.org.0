Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87681672722
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjARSgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjARSgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:36:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D007B5956F
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 10:36:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85A5AB81EA0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 18:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D68C433F0;
        Wed, 18 Jan 2023 18:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674066973;
        bh=ULgvir7S2zal74kxmOA4K8SIEb4jFUVcIjCGNwM7e20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jT7tXBCAVJBNVxLRqQyoMALafcJ4217ZH76e6LF3e1KBPAG8PNqaRHgykEFRaPcBF
         wlt17DO9wJ83A0ruAyzGzfhs0HkhnAVnGYRyb19/bIeXWEkqqKvfIfDox7RbePDzM0
         c/hTqRGq9AyWNun1Mu1WzaYfAYI+XuzYoR37H638LCuQ5FASRcJdELMCktnwMoXdgr
         ECb7nyFMavzhjeOb6T55555UFh/6LBeYTVXbmwvezKYRRVl1B9d/X71EtVMLQM7sKh
         WS9j3JCct9GnOq6hKYDMfjge25zFABaXMWkBirODM6qlH4JVE4vQXWxwjZEut4I6l0
         uNqxu7gRCvZpQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Fail with messages when params are not valid for XSK
Date:   Wed, 18 Jan 2023 10:35:53 -0800
Message-Id: <20230118183602.124323-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118183602.124323-1-saeed@kernel.org>
References: <20230118183602.124323-1-saeed@kernel.org>
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

From: Adham Faris <afaris@nvidia.com>

Current XSK prerequisites validation implementation
(setup.c/mlx5e_validate_xsk_param()) fails silently when xsk
prerequisites are not fulfilled.
Add error messages to the kernel log to help the user understand what
went wrong when params are not valid for XSK.

Signed-off-by: Adham Faris <afaris@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   |  9 +++++++--
 .../mellanox/mlx5/core/en/xsk/setup.c         | 19 +++++++++++++++++--
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 585bdc8383ee..a17b768b81f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -581,11 +581,16 @@ int mlx5e_mpwrq_validate_xsk(struct mlx5_core_dev *mdev, struct mlx5e_params *pa
 	bool unaligned = xsk ? xsk->unaligned : false;
 	u16 max_mtu_pkts;
 
-	if (!mlx5e_check_fragmented_striding_rq_cap(mdev, page_shift, umr_mode))
+	if (!mlx5e_check_fragmented_striding_rq_cap(mdev, page_shift, umr_mode)) {
+		mlx5_core_err(mdev, "Striding RQ for XSK can't be activated with page_shift %u and umr_mode %d\n",
+			      page_shift, umr_mode);
 		return -EOPNOTSUPP;
+	}
 
-	if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk))
+	if (!mlx5e_rx_mpwqe_is_linear_skb(mdev, params, xsk)) {
+		mlx5_core_err(mdev, "Striding RQ linear mode for XSK can't be activated with current params\n");
 		return -EINVAL;
+	}
 
 	/* Current RQ length is too big for the given frame size, the
 	 * needed number of WQEs exceeds the maximum.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index ff03c43833bb..81a567e17264 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -7,6 +7,18 @@
 #include "en/health.h"
 #include <net/xdp_sock_drv.h>
 
+static int mlx5e_legacy_rq_validate_xsk(struct mlx5_core_dev *mdev,
+					struct mlx5e_params *params,
+					struct mlx5e_xsk_param *xsk)
+{
+	if (!mlx5e_rx_is_linear_skb(mdev, params, xsk)) {
+		mlx5_core_err(mdev, "Legacy RQ linear mode for XSK can't be activated with current params\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* The limitation of 2048 can be altered, but shouldn't go beyond the minimal
  * stride size of striding RQ.
  */
@@ -17,8 +29,11 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 			      struct mlx5_core_dev *mdev)
 {
 	/* AF_XDP doesn't support frames larger than PAGE_SIZE. */
-	if (xsk->chunk_size > PAGE_SIZE || xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE)
+	if (xsk->chunk_size > PAGE_SIZE || xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE) {
+		mlx5_core_err(mdev, "XSK chunk size %u out of bounds [%u, %lu]\n", xsk->chunk_size,
+			      MLX5E_MIN_XSK_CHUNK_SIZE, PAGE_SIZE);
 		return false;
+	}
 
 	/* frag_sz is different for regular and XSK RQs, so ensure that linear
 	 * SKB mode is possible.
@@ -27,7 +42,7 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
 		return !mlx5e_mpwrq_validate_xsk(mdev, params, xsk);
 	default: /* MLX5_WQ_TYPE_CYCLIC */
-		return mlx5e_rx_is_linear_skb(mdev, params, xsk);
+		return !mlx5e_legacy_rq_validate_xsk(mdev, params, xsk);
 	}
 }
 
-- 
2.39.0

