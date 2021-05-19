Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE8738874F
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243165AbhESGHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238532AbhESGHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C83B0613AD;
        Wed, 19 May 2021 06:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404371;
        bh=BteojUMIh0wQJoonHHZWziOMGkNzXhieAt9oMNJo5Io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyBH74uk9W9GGuSv6p+48GGQGB5Bn0WdNHadXvZpAESaiCvs6GZt6U4Nz0MZqx0vt
         zbT0Plj3YK2w8ZeVh6CYcdcLoWP86gbwWSkg3Gk/dO1UQOldRxBkX0m64pjmxcXdvi
         RzN4J9IKfoQXUtHq6aqcRxW+kzPod91XhJgO1lmjJE6OnH7YNEjx9QG9iKHb0XeT7D
         8PgwyrnsbsWIjgABcXRH+aGPSkDDtcnZxbnSig/UOqR2x2wpN6rmOmvNeoIHRxNN3e
         CLTQRHNX5Znrk5BW6IGENbgHqkGSK/9D1NWrzrMGlg/lkhlzp0G1sVks/B6nEHzUT0
         F00dATQ1zl3gg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/16] net/mlx5e: Fix error path of updating netdev queues
Date:   Tue, 18 May 2021 23:05:19 -0700
Message-Id: <20210519060523.17875-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Avoid division by zero in the error flow. In the driver TC number can be
either 1 or 8. When TC count is set to 1, driver zero netdev->num_tc.
Hence, need to convert it back from 0 to 1 in the error flow.

Fixes: fa3748775b92 ("net/mlx5e: Handle errors from netif_set_real_num_{tx,rx}_queues")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 89937b055070..d1b9a4040d60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2697,7 +2697,7 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	int err;
 
 	old_num_txqs = netdev->real_num_tx_queues;
-	old_ntc = netdev->num_tc;
+	old_ntc = netdev->num_tc ? : 1;
 
 	nch = priv->channels.params.num_channels;
 	ntc = priv->channels.params.num_tc;
-- 
2.31.1

