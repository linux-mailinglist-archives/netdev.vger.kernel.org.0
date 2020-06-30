Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0E320F811
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 17:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389360AbgF3PQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 11:16:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49534 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730027AbgF3PQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 11:16:50 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jqI06-0003VR-TA; Tue, 30 Jun 2020 15:16:47 +0000
From:   Colin King <colin.king@canonical.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5e: fix memory leak of tls
Date:   Tue, 30 Jun 2020 16:16:46 +0100
Message-Id: <20200630151646.517757-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error return path when create_singlethread_workqueue fails currently
does not kfree tls and leads to a memory leak. Fix this by kfree'ing
tls before returning -ENOMEM.

Addresses-Coverity: ("Resource leak")
Fixes: 1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index 99beb928feff..fee991f5ee7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -232,8 +232,10 @@ int mlx5e_tls_init(struct mlx5e_priv *priv)
 		return -ENOMEM;
 
 	tls->rx_wq = create_singlethread_workqueue("mlx5e_tls_rx");
-	if (!tls->rx_wq)
+	if (!tls->rx_wq) {
+		kfree(tls);
 		return -ENOMEM;
+	}
 
 	priv->tls = tls;
 	return 0;
-- 
2.27.0

