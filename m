Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5F630B82F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhBBG6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232287AbhBBG4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AA7364EEB;
        Tue,  2 Feb 2021 06:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248922;
        bh=6moxk7iP6pTGh8zRTf6oYUXl2YmLqHoglZOH8b7c7K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtWLqVvonnPiLkjThiyVk/Ms2mGBLqjeLVI3H68RzLYzte6xMMTPlJXzgIMQZChCQ
         xCjFt6UvAJXqg6EdW5ciuseLFDfQKG+VVsG0aNoiCSFrbYYYH4BHYqV+e8R+hbkeZ9
         NYj7LtcGBCAhjtSOoWyw7ZWzXKKWZF853IJjAj6c3vd9lLLemFkX5YA0h2+ESRfzpk
         rCDAn5GDkn81srG2h1zkeCSKyPzqsGl4pJZCIe619f4hW9lZGuv5QlfGGOAA8ILpvI
         naOF2FxZG8us0hVS5D6eW7PiTyv5Oer7EX3FXOZCChO3GRdyflAbxysxbdNQdmUqvJ
         YYjMqhnS4KYOg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/14] net/mlx5e: kTLS, Improve TLS RX workqueue scope
Date:   Mon,  1 Feb 2021 22:54:54 -0800
Message-Id: <20210202065457.613312-12-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

The TLS RX workqueue is needed only when kTLS RX device offload
is supported.

Move its creation from the general TLS init function to the
kTLS RX init.
Create it once at init time if supported, avoid creation/destroy
everytime the feature bit is toggled.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls.c        | 24 ++++++++++++++++---
 .../mellanox/mlx5/core/en_accel/tls.c         |  7 ------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 1b392696280d..95293ee0d38d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2019 Mellanox Technologies.
 
 #include "en.h"
+#include "en_accel/tls.h"
 #include "en_accel/ktls.h"
 #include "en_accel/ktls_utils.h"
 #include "en_accel/fs_tcp.h"
@@ -86,16 +87,33 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
 
 int mlx5e_ktls_init_rx(struct mlx5e_priv *priv)
 {
-	int err = 0;
+	int err;
 
-	if (priv->netdev->features & NETIF_F_HW_TLS_RX)
+	if (!mlx5_accel_is_ktls_rx(priv->mdev))
+		return 0;
+
+	priv->tls->rx_wq = create_singlethread_workqueue("mlx5e_tls_rx");
+	if (!priv->tls->rx_wq)
+		return -ENOMEM;
+
+	if (priv->netdev->features & NETIF_F_HW_TLS_RX) {
 		err = mlx5e_accel_fs_tcp_create(priv);
+		if (err) {
+			destroy_workqueue(priv->tls->rx_wq);
+			return err;
+		}
+	}
 
-	return err;
+	return 0;
 }
 
 void mlx5e_ktls_cleanup_rx(struct mlx5e_priv *priv)
 {
+	if (!mlx5_accel_is_ktls_rx(priv->mdev))
+		return;
+
 	if (priv->netdev->features & NETIF_F_HW_TLS_RX)
 		mlx5e_accel_fs_tcp_destroy(priv);
+
+	destroy_workqueue(priv->tls->rx_wq);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index fee991f5ee7c..d6b21b899dbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -231,12 +231,6 @@ int mlx5e_tls_init(struct mlx5e_priv *priv)
 	if (!tls)
 		return -ENOMEM;
 
-	tls->rx_wq = create_singlethread_workqueue("mlx5e_tls_rx");
-	if (!tls->rx_wq) {
-		kfree(tls);
-		return -ENOMEM;
-	}
-
 	priv->tls = tls;
 	return 0;
 }
@@ -248,7 +242,6 @@ void mlx5e_tls_cleanup(struct mlx5e_priv *priv)
 	if (!tls)
 		return;
 
-	destroy_workqueue(tls->rx_wq);
 	kfree(tls);
 	priv->tls = NULL;
 }
-- 
2.29.2

