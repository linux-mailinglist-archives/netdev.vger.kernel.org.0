Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61F327034D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgIRR3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbgIRR26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:58 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAD72235FA;
        Fri, 18 Sep 2020 17:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450136;
        bh=lzNlB/4750kpl7EN/tJulcz4LA6vId+2wTaW9zTtqkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMDQWm3RY1PXgGeJr8CoUByRJla8Y7/jyhKf8i8BaJuAhbPuO3IYRxr9QSqYNebJO
         YkHsOxAZG6cX3CwhsH7T1IYuLVTis/1fkJvAlkM+qNz+qpf5qV4STWfQlw1KBTJX9k
         QuNN8KTtndCsY0FkOL3FHmtfK2jb06ISDO1azSX4=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/15] net/mlx5e: kTLS, Fix napi sync and possible use-after-free
Date:   Fri, 18 Sep 2020 10:28:35 -0700
Message-Id: <20200918172839.310037-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
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

