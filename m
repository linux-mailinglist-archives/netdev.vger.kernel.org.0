Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CA55F2162
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiJBFOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJBFON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB50F51428
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EC8D60DEC
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F26AC433B5;
        Sun,  2 Oct 2022 05:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687643;
        bh=cB836AVV5bCa3hKfO4cej7tLnl96QU8ws7DQTiNGZVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQy3NhY9gpwEyQnzAfYp3b9xFFr4vnve2hVOhM6TU8oRCoAi28Z7MsCoGJOwj06n8
         j3/RyDILeJmycaL//DkVQMGsPcW6ud04DHrlw98oYgE+U+7jL2D00C9Jaqx5jP92PF
         RhgV2Qe7xNpkKuocG+dTrK/j2Wk7VPnXZ/9E/pLsR2oWWcabY6qTBwsM14BSA9qpg/
         vE2mr4VxwLHNXqTZQK0OjlyA+z7zlDdDaveVJsT/AjFj/d1AfolkLcF3eGoNqUgEd3
         8uB6X1fVkgAP5dPKGjT8R0gBe0QV66AEwbHPUJDYPjdNnSrGrqqTlAe8DvA6Zl9UD0
         RMlvvXZHIz7zg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 08/15] net/mlx5e: xsk: Print a warning in slow configurations
Date:   Sat,  1 Oct 2022 21:56:25 -0700
Message-Id: <20221002045632.291612-9-saeed@kernel.org>
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

On striding RQ, when the XSK frame size doesn't match the MKey page
size, KLM is used for memory mappings, which is a slower mechanism than
MTT or KSM. It may happen in two cases:

1. Frame size is not a power of two (only possible in the unaligned mode
of XSK).

2. Frame size is 2048 bytes, and the firmware doesn't support MKey pages
smaller than 4096 bytes.

Depending on the case, print a warning and recommend to disable striding
RQ or upgrade the firmware.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 8b09e2f58a4d..ebada0c5af3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -99,6 +99,15 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 
 	mlx5e_build_xsk_param(pool, &xsk);
 
+	if (priv->channels.params.rq_wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ &&
+	    mlx5e_mpwrq_umr_mode(priv->mdev, &xsk) == MLX5E_MPWRQ_UMR_MODE_OVERSIZED) {
+		const char *recommendation = is_power_of_2(xsk.chunk_size) ?
+			"Upgrade firmware" : "Disable striding RQ";
+
+		mlx5_core_warn(priv->mdev, "Expected slowdown with XSK frame size %u. %s for better performance.\n",
+			       xsk.chunk_size, recommendation);
+	}
+
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		/* XSK objects will be created on open. */
 		goto validate_closed;
-- 
2.37.3

