Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9578F3EE05C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 01:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhHPXXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 19:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233956AbhHPXXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 19:23:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7297B60F36;
        Mon, 16 Aug 2021 23:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629156154;
        bh=BcXNJ2vEQuRX8M4CartZnk1XSSULHnkUs2UstHPH/B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYlL/P2NFRN32wMHveTJkNjCQtldxGaSj2psGzFW+lGRiOBYOhf95o7VGwxc83UDh
         z8B/pKJgdMyNbCyLwO/8cFSGRhaev2AzV8DWivBSmuqSfChTGgo6lOpiIZ73E1RPar
         xZ6fQrXwLUfLwtJszI3QjhliO7GjSskuCADt4jTEKVRk5Da6YDOSRgRJ7vyqz2m/+u
         3OHErhYKnMt+O6wjpEM5SQMjpXUF2QZ1cZr0SVQ58/sPBsHij9ZBttLNtNgokGIm0j
         syYBNh9UjIfHFokwap3ocaQl6X+P/SMbVF/rxJhxSP0SWArkf9AYWm+mSEwkGgN8tR
         AgnRW1WeumIbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 10/17] net/mlx5e: Handle errors of netdev_set_num_tc()
Date:   Mon, 16 Aug 2021 16:22:12 -0700
Message-Id: <20210816232219.557083-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816232219.557083-1-saeed@kernel.org>
References: <20210816232219.557083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Add handling for failures in netdev_set_num_tc().
Let mlx5e_netdev_set_tcs return an int.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0d84eb17707e..f5c89a00214d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2263,22 +2263,28 @@ void mlx5e_set_netdev_mtu_boundaries(struct mlx5e_priv *priv)
 				ETH_MAX_MTU);
 }
 
-static void mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc)
+static int mlx5e_netdev_set_tcs(struct net_device *netdev, u16 nch, u8 ntc)
 {
-	int tc;
+	int tc, err;
 
 	netdev_reset_tc(netdev);
 
 	if (ntc == 1)
-		return;
+		return 0;
 
-	netdev_set_num_tc(netdev, ntc);
+	err = netdev_set_num_tc(netdev, ntc);
+	if (err) {
+		netdev_WARN(netdev, "netdev_set_num_tc failed (%d), ntc = %d\n", err, ntc);
+		return err;
+	}
 
 	/* Map netdev TCs to offset 0
 	 * We have our own UP to TXQ mapping for QoS
 	 */
 	for (tc = 0; tc < ntc; tc++)
 		netdev_set_tc_queue(netdev, tc, nch, 0);
+
+	return 0;
 }
 
 int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv)
@@ -2315,8 +2321,9 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	ntc = mlx5e_get_dcb_num_tc(&priv->channels.params);
 	num_rxqs = nch * priv->profile->rq_groups;
 
-	mlx5e_netdev_set_tcs(netdev, nch, ntc);
-
+	err = mlx5e_netdev_set_tcs(netdev, nch, ntc);
+	if (err)
+		goto err_out;
 	err = mlx5e_update_tx_netdev_queues(priv);
 	if (err)
 		goto err_tcs;
@@ -2338,6 +2345,7 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 
 err_tcs:
 	mlx5e_netdev_set_tcs(netdev, old_num_txqs / old_ntc, old_ntc);
+err_out:
 	return err;
 }
 
-- 
2.31.1

