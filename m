Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4476CCB37
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 22:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjC1UHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 16:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjC1UHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 16:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC383AB9
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 13:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F411F61940
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 20:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4848EC4339B;
        Tue, 28 Mar 2023 20:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680034060;
        bh=OVIn6yZUGcZMLGnDuTopjWzgEg4mmL0YM8Ip9bEdeM0=;
        h=From:To:Cc:Subject:Date:From;
        b=AYs5lDZA+hZbBtwigATlCUJ0CCXI1zYtVk/QK2jKLyr4Js0AsjnA7tOqeCgqLGVek
         KUGn6SBYd3/meE6dRsGFvZiPskVz3T2wVU7naLs4zZoRfxmS0ycWjWr5YDcU/RQZa0
         rrlT4EbYpiQP24dqqk7T7laZ9lciqggaTvizg/1jfOnjfI5eECVE+VS/vXId88DqSf
         uFkBIUU36YCp0nzLLiNG7UdQ4t3Q52tJHiwlQAiaSAdFW71JHqXE2FMIRvq57Zs49H
         evp1A3ofY0uv/l1De7ppGM4cUOGt38qmvplpms2XqTgkWGHeM0D06b2DqHytNX9vX7
         UDk0FCEvvbbhA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next] net/mlx5e: Fix build break on 32bit
Date:   Tue, 28 Mar 2023 13:07:23 -0700
Message-Id: <20230328200723.125122-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

The cited commit caused the following build break in mlx5 due to a change
in size of MAX_SKB_FRAGS.

error: format '%lu' expects argument of type 'long unsigned int',
       but argument 7 has type 'unsigned int' [-Werror=format=]

Fix this by explicit casting.

Fixes: 3948b05950fd ("net: introduce a config option to tweak MAX_SKB_FRAGS")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 90eac1aa5f6b..6db1aff8778d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5725,8 +5725,8 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 
 	/* Validate the max_wqe_size_sq capability. */
 	if (WARN_ON_ONCE(mlx5e_get_max_sq_wqebbs(priv->mdev) < MLX5E_MAX_TX_WQEBBS)) {
-		mlx5_core_warn(priv->mdev, "MLX5E: Max SQ WQEBBs firmware capability: %u, needed %lu\n",
-			       mlx5e_get_max_sq_wqebbs(priv->mdev), MLX5E_MAX_TX_WQEBBS);
+		mlx5_core_warn(priv->mdev, "MLX5E: Max SQ WQEBBs firmware capability: %u, needed %u\n",
+			       mlx5e_get_max_sq_wqebbs(priv->mdev), (unsigned int)MLX5E_MAX_TX_WQEBBS);
 		return -EIO;
 	}
 
-- 
2.39.2

