Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F90C39ABA2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhFCUNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230004AbhFCUNq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E9EC61405;
        Thu,  3 Jun 2021 20:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751121;
        bh=OxER+KxgaszW0H4zAI6C/lbvSBD0E1epiP3pA7s5kwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cD5MLNsiux3+XjxRwcjBCDqsreaw+YoalW56O5N8YCgnx23lxZz1QbT78avvJ+rOB
         gYkaJDHA0elREKhv4KA0qgeibRJ80vAJokuf5I9kgcVX6aMAansa7HqA9mMjVf7LZ+
         n2EZ6n/lm8KbktOHXEXJzIo/QrSTWDsdtgavC0j2xcofU29+vTXESKZuedT4Zu8tX5
         sZ8PbH7Jm3ug0d4UyMCuYEdh7pyuXAgPjX0JdTgoMBIXfccn530sZSev3Vv9Xhr2Uz
         OUE9rW/8w6bV0bDtLBYRShtny/3SqyEPbHeEOXsoTRjBKZ2J1Ri7E6NHc1kEysw0/B
         O6+KuiptqSh8w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/10] net/mlx5: check for allocation failure in mlx5_ft_pool_init()
Date:   Thu,  3 Jun 2021 13:11:48 -0700
Message-Id: <20210603201155.109184-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

Add a check for if the kzalloc() fails.

Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all firmware steering")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
index 526fbb669142..c14590acc772 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
@@ -27,6 +27,8 @@ int mlx5_ft_pool_init(struct mlx5_core_dev *dev)
 	int i;
 
 	ft_pool = kzalloc(sizeof(*ft_pool), GFP_KERNEL);
+	if (!ft_pool)
+		return -ENOMEM;
 
 	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--)
 		ft_pool->ft_left[i] = FT_SIZE / FT_POOLS[i];
-- 
2.31.1

