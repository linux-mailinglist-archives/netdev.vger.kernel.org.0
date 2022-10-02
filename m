Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD51F5F215B
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiJBFN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJBFN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:13:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D5A5072C
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D42FC60DEA
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BD5C433C1;
        Sun,  2 Oct 2022 05:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687636;
        bh=Y+i+EahBdf8ffW+Tn9akH2Ka9VK3Km5sp3Q47QkeYPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UKM+vK40t1Z3PhsB9RydyRCV2tKYpMTtwNdh1U8FeKzcF2lNPEloGvvSEa46uSp37
         3iXgNIeaBMI2rL1SiNAtD0y7QVYIhL2JcEb4Yo69fPCmDQ4kkH15ksaWlKAEuVVX4c
         wvIMcGFtX38IYmWP+UEOf732g4oUp/ItR6GriKwclE3/19iBWsgpNqIIMURY0sC3eF
         tk/XpXwp/4DU2RBO+6fn1Ro33Jr8yc4OB2DtQWNSB3rZEG8n4WEFLVpYBBQ5a6aSs7
         qKmK01D3thQYm3NzV4qmP/IPBHu4b13cVnNca/ZZ6vrdSwuXOqFJ88GRFqGFVErkej
         I+DrEEo6pGJ7A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 01/15] net/mlx5e: xsk: Flush RQ on XSK activation to save memory
Date:   Sat,  1 Oct 2022 21:56:18 -0700
Message-Id: <20221002045632.291612-2-saeed@kernel.org>
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

The regular RQ remains open after opening an XSK socket, in order to
guarantee that closing the XSK socket never fails due to an error when
reopening the regular RQ.

To save memory, the regular RQ can be deactivated and flushed, releasing
all pages, when an XSK socket is open.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |  9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 14 +++++++++-----
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 6bc6472b98f2..9e6347a67fd2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1036,6 +1036,7 @@ struct mlx5e_rq_param;
 int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 		  struct mlx5e_xsk_param *xsk, int node,
 		  struct mlx5e_rq *rq);
+#define MLX5E_RQ_WQES_TIMEOUT 20000 /* msecs */
 int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time);
 void mlx5e_close_rq(struct mlx5e_rq *rq);
 int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 9804ef15a4d6..8b09e2f58a4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -126,6 +126,9 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 
 	mlx5e_rx_res_xsk_update(priv->rx_res, &priv->channels, ix, true);
 
+	mlx5e_deactivate_rq(&c->rq);
+	mlx5e_flush_rq(&c->rq, MLX5_RQC_STATE_RDY);
+
 	return 0;
 
 err_remove_pool:
@@ -165,7 +168,13 @@ static int mlx5e_xsk_disable_locked(struct mlx5e_priv *priv, u16 ix)
 		goto remove_pool;
 
 	c = priv->channels.c[ix];
+
+	mlx5e_activate_rq(&c->rq);
+	mlx5e_trigger_napi_icosq(c);
+	mlx5e_wait_for_min_rx_wqes(&c->rq, MLX5E_RQ_WQES_TIMEOUT);
+
 	mlx5e_rx_res_xsk_update(priv->rx_res, &priv->channels, ix, false);
+
 	mlx5e_deactivate_xsk(c);
 	mlx5e_close_xsk(c);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 21fe43406d88..10428ade96c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2408,10 +2408,11 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 		mlx5e_activate_txqsq(&c->sq[tc]);
 	mlx5e_activate_icosq(&c->icosq);
 	mlx5e_activate_icosq(&c->async_icosq);
-	mlx5e_activate_rq(&c->rq);
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_activate_xsk(c);
+	else
+		mlx5e_activate_rq(&c->rq);
 
 	mlx5e_trigger_napi_icosq(c);
 }
@@ -2422,8 +2423,9 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_deactivate_xsk(c);
+	else
+		mlx5e_deactivate_rq(&c->rq);
 
-	mlx5e_deactivate_rq(&c->rq);
 	mlx5e_deactivate_icosq(&c->async_icosq);
 	mlx5e_deactivate_icosq(&c->icosq);
 	for (tc = 0; tc < c->num_tc; tc++)
@@ -2515,8 +2517,6 @@ static void mlx5e_activate_channels(struct mlx5e_channels *chs)
 		mlx5e_ptp_activate_channel(chs->ptp);
 }
 
-#define MLX5E_RQ_WQES_TIMEOUT 20000 /* msecs */
-
 static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
 {
 	int err = 0;
@@ -2524,8 +2524,12 @@ static int mlx5e_wait_channels_min_rx_wqes(struct mlx5e_channels *chs)
 
 	for (i = 0; i < chs->num; i++) {
 		int timeout = err ? 0 : MLX5E_RQ_WQES_TIMEOUT;
+		struct mlx5e_channel *c = chs->c[i];
+
+		if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
+			continue;
 
-		err |= mlx5e_wait_for_min_rx_wqes(&chs->c[i]->rq, timeout);
+		err |= mlx5e_wait_for_min_rx_wqes(&c->rq, timeout);
 
 		/* Don't wait on the XSK RQ, because the newer xdpsock sample
 		 * doesn't provide any Fill Ring entries at the setup stage.
-- 
2.37.3

