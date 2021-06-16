Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5DD3AA6BB
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhFPWmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234031AbhFPWmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 18:42:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74021613F2;
        Wed, 16 Jun 2021 22:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623883230;
        bh=3wJXY7PbF1Lp0INoU9jbrST9aGb9qwm7W1y7VdjaRtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBH3AxujXNlStHT8xYH2qBX1A0j214mSOuJEYBi2dMqyVh2jU1xlWxJ5gEUU7y2j4
         Sq/c6XkZqL960Y5lDHSx1PT1Bw9u2yg6otqwbqmXbB96TtcOt1s09MPbQ4xXlZUR5x
         uMhr1/VGePhvX/uYZeVL2/t63WDFjT+vP6obbc7nYSEHJ1UWazHrWGlId8RUOowBcv
         ZQM1tlNXdUMZMdQw0SEe8TSKDpY3IKLgO61qD/wHdxKS0h0XNLuhtholGeULBSyKvQ
         2eWTpvrEYudF+BZc6wsad+hPIFIoYoxbD6wukeNDhOiYeCo/3T93pPP62ie31gZs0T
         /FY2p3yHtF6Pg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Amir Tzin <amirtz@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 8/8] net/mlx5: Reset mkey index on creation
Date:   Wed, 16 Jun 2021 15:40:15 -0700
Message-Id: <20210616224015.14393-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616224015.14393-1-saeed@kernel.org>
References: <20210616224015.14393-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Reset only the index part of the mkey and keep the variant part. On
devlink reload, driver recreates mkeys, so the mkey index may change.
Trying to preserve the variant part of the mkey, driver mistakenly
merged the mkey index with current value. In case of a devlink reload,
current value of index part is dirty, so the index may be corrupted.

Fixes: 54c62e13ad76 ("{IB,net}/mlx5: Setup mkey variant before mr create command invocation")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 50af84e76fb6..174f71ed5280 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -54,7 +54,7 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
 	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
 	mkey->size = MLX5_GET64(mkc, mkc, len);
-	mkey->key |= mlx5_idx_to_mkey(mkey_index);
+	mkey->key = (u32)mlx5_mkey_variant(mkey->key) | mlx5_idx_to_mkey(mkey_index);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
 	init_waitqueue_head(&mkey->wait);
 
-- 
2.31.1

