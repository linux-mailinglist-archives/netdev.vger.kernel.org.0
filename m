Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E3A5F0FF4
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiI3Q3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiI3Q33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:29:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1004C169E54
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A13266235A
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 16:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDCEC433C1;
        Fri, 30 Sep 2022 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664555368;
        bh=kfdzOiaZ6wMKpxagJ586NMMIN7jod7X+CVygyO2AUfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIgzosKI0Hxzp/BpT/FYEVV5AHO/NbILFA2forogyn7Zp2Ebqkd9UfjTyLXOPvN1o
         9vOUcdezuo1T3b1wmE8YQKJdvMDswhkZBAKe1o3zIU7Eogt3BmcvRxhjRr67Hup2GF
         AGMKhYO4C/A2OmnF8wa8KX/GSAsbJg8XXhANswxY3CMjFQU7UrcN9SvTkWgAYVMQqb
         LaI0J95dlCmYSqnQo8+buSX3vKlFdRuTpmN1fYjLjQMGaKpUs837Vxwk4vxGywZdU2
         SV1c4eN6X1BH53c65Wf0aQBkAGpPZjHaNfVzabGj2EUxTD3jl7EE3tEGTSqb6Spp6G
         xzAPaWUQ4Ufmw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 02/16] net/mlx5e: xsk: Drop the check for XSK state in mlx5e_xsk_wakeup
Date:   Fri, 30 Sep 2022 09:28:49 -0700
Message-Id: <20220930162903.62262-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930162903.62262-1-saeed@kernel.org>
References: <20220930162903.62262-1-saeed@kernel.org>
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

The MLX5E_CHANNEL_STATE_XSK flag checked in mlx5e_xsk_wakeup indicates
that XSK queues are open, but not necessarily activated. This check is
not very useful, because:

0. Both XSK setup and netdev state transitions take the same state_lock
mutex, so they can't happen at the same time.

1. If the netdev is up, xsk_is_bound can return true only when
MLX5E_CHANNEL_STATE_XSK is set on the corresponding channel.
mlx5e_xsk_wakeup is only called when xsk_is_bound is true.

2. If the XSK socket is bound, and the netdev is going up or down,
mlx5e_xsk_wakeup can take one of two branches, depending on the return
value of napi_if_scheduled_mark_missed:

2.1. True means one of two things: either NAPI was enabled at this
point, which means MLX5E_CHANNEL_STATE_XSK was also set; or NAPI was
disabled, and nothing really happened.

2.2. False means that NAPI was enabled by this point, which also implies
MLX5E_CHANNEL_STATE_XSK was set. Additionally, mlx5e_xsk_wakeup contains
a following check for MLX5E_SQ_STATE_ENABLED on async_icosq, and this
flag implies MLX5E_CHANNEL_STATE_XSK too on XSK channels.

As checking this flag doesn't cut any flows, remove the check.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 5129b9bf534f..d7dfc7d2c058 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -154,7 +154,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 void mlx5e_close_xsk(struct mlx5e_channel *c)
 {
 	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
-	synchronize_net(); /* Sync with the XSK wakeup and with NAPI. */
+	synchronize_net(); /* Sync with NAPI. */
 
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 1203d7d5f9bd..c856fc3f197e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -22,9 +22,6 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 
 	c = priv->channels.c[ix];
 
-	if (unlikely(!test_bit(MLX5E_CHANNEL_STATE_XSK, c->state)))
-		return -EINVAL;
-
 	if (!napi_if_scheduled_mark_missed(&c->napi)) {
 		/* To avoid WQE overrun, don't post a NOP if async_icosq is not
 		 * active and not polled by NAPI. Return 0, because the upcoming
-- 
2.37.3

