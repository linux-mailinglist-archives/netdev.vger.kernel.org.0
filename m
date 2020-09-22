Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9573027377E
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgIVAbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbgIVAbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:19 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 886C023A9C;
        Tue, 22 Sep 2020 00:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734678;
        bh=lzNlB/4750kpl7EN/tJulcz4LA6vId+2wTaW9zTtqkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1snaxaxZoJLi434p/UwbNV9Rav08ODYuwlkImz6NMJIIiZCM5Ez/W2CK7O9waJkV2
         fd+0anFrHuBunjsQ1pAi75F5AxN50SprBNLnquYgiKpEdV5kh1h1GWTw1EWrNM/502
         wmOm07CrvLq/qgmM0/S35SBUBMTjLp+saLgsvFT0=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 11/15] net/mlx5e: kTLS, Fix napi sync and possible use-after-free
Date:   Mon, 21 Sep 2020 17:30:57 -0700
Message-Id: <20200922003101.529117-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Using synchronize_rcu() is sufficient to wait until running NAPI quits.

See similar upstream fix with detailed explanation:
("net/mlx5e: Use synchronize_rcu to sync with NAPI")

This change also fixes a possible use-after-free as the NAPI
might be already released at this stage.

Fixes: 0419d8c9d8f8 ("net/mlx5e: kTLS, Add kTLS RX resync support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index acf6d80a6bb7..f95aa50ab51a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -659,7 +659,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 	priv_rx = mlx5e_get_ktls_rx_priv_ctx(tls_ctx);
 	set_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags);
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, NULL);
-	napi_synchronize(&priv->channels.c[priv_rx->rxq]->napi);
+	synchronize_rcu(); /* Sync with NAPI */
 	if (!cancel_work_sync(&priv_rx->rule.work))
 		/* completion is needed, as the priv_rx in the add flow
 		 * is maintained on the wqe info (wi), not on the socket.
-- 
2.26.2

