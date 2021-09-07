Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7A240303D
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348719AbhIGVZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348325AbhIGVZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B54B61151;
        Tue,  7 Sep 2021 21:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049869;
        bh=Hew74U7GpmfcRZXgkKrDNFf6XZrY2RoCliwDnX+TIvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJhPGIXI4xRy4vqnHDCaM0eP73tInargL78OuH6jGwZgu8ZbG8DZuC8FrKA1+ZkKu
         sYgGzMCvQ17E++3IrL3ev8uAwrMWg7xTIJtN6yuVfKl3gkNE2zDvC+fZ1U9T4hp4/R
         4E1ctNpmK7EfBASZ2P+1Ts2KFAKXwr34VwZ/OfD53ZpmIDp9Pi8J/gsfDrcvLGxtYx
         PruP/ZCjK27f/3/kZWkOXAUL7UIoJy05+NZMGYf/M8vb66y+jG2U99aBUecXEij1g3
         C++lsaC3uwI2OcHjEM8w0E5hIfIZY0w6HIvBgOb51YscUHtt5EZbNdYKYwlO0HVYOC
         4tphsDqQOXnCg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/7] net/mlx5: Lag, don't update lag if lag isn't supported
Date:   Tue,  7 Sep 2021 14:24:16 -0700
Message-Id: <20210907212420.28529-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210907212420.28529-1-saeed@kernel.org>
References: <20210907212420.28529-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

In NICs that don't support LAG, the LAG control structure won't be
allocated. If it wasn't allocated it means LAG doesn't exists and can be
skipped.

Fixes: cac1eb2cf2e3 ("net/mlx5: Lag, properly lock eswitch if needed")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 49ca57c6d31d..ca5690b0a7ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -927,9 +927,12 @@ void mlx5_lag_disable_change(struct mlx5_core_dev *dev)
 	struct mlx5_core_dev *dev1;
 	struct mlx5_lag *ldev;
 
+	ldev = mlx5_lag_dev(dev);
+	if (!ldev)
+		return;
+
 	mlx5_dev_list_lock();
 
-	ldev = mlx5_lag_dev(dev);
 	dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	dev1 = ldev->pf[MLX5_LAG_P2].dev;
 
@@ -946,8 +949,11 @@ void mlx5_lag_enable_change(struct mlx5_core_dev *dev)
 {
 	struct mlx5_lag *ldev;
 
-	mlx5_dev_list_lock();
 	ldev = mlx5_lag_dev(dev);
+	if (!ldev)
+		return;
+
+	mlx5_dev_list_lock();
 	ldev->mode_changes_in_progress--;
 	mlx5_dev_list_unlock();
 	mlx5_queue_bond_work(ldev, 0);
-- 
2.31.1

