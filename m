Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24362614BD
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfGGLx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58839 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726341AbfGGLx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:26 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLo031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 01/16] Revert "net/mlx5e: Fix mlx5e_tx_reporter_create return value"
Date:   Sun,  7 Jul 2019 14:52:53 +0300
Message-Id: <1562500388-16847-2-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

This reverts commit 2e5b0534622fa87fd570d54af2d01ce304b88077.

This commit was needed prior to commit f6b19b354d50 ("net: devlink:
select NET_DEVLINK from drivers") Then, reporter's pointer could have
been a NULL. But with NET_DEVLINK mandatory to MLX5_CORE in Kconfig,
pointer can only hold an error in bad path.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 476dd97f7f2f..24626bb55598 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -302,7 +302,7 @@ int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
 		netdev_warn(priv->netdev,
 			    "Failed to create tx reporter, err = %ld\n",
 			    PTR_ERR(priv->tx_reporter));
-	return IS_ERR_OR_NULL(priv->tx_reporter);
+	return PTR_ERR_OR_ZERO(priv->tx_reporter);
 }
 
 void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv)
-- 
1.8.3.1

