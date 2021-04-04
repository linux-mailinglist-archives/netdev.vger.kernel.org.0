Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7759353671
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhDDEUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232315AbhDDEUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE39E61388;
        Sun,  4 Apr 2021 04:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510011;
        bh=1SMCHHtJahYWMxBOC07Z+5dsD2UuWDDwZXGn2+6mB24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nm9E74ZldtK1gbpL8nag/zQnZmB6fcKzkq5kqWBr3XYpb6P/4wF7jUxx3o3kWi6YA
         cj68zRqFIaXCVZkIiLyFKpApbT5UdnMPYlAv1vcd5p9xoNepoOXJXUzfPu9MqHiTyW
         j6iik6ueFbKoi6q1x/oeGLx19BYMf4iQii7fAzuV/enMwe3DM2Tsz+2xwHLnoN+Gh6
         4RGcCI1dh8j+A5Qp25n9hdmorlQwdYr9CFMqjv5uFM0z4JmJcYkbkfzlBXY/HrXDEC
         +z3D273mdk7z7IgHCL+NkgUhRGdLDUtLROwvzJ8uZxIO3OITNCvt48TbdFkKI8GbQO
         /fsnH5k5Rf3TA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/16] net/mlx5: Pair mutex_destory with mutex_init for rate limit table
Date:   Sat,  3 Apr 2021 21:19:48 -0700
Message-Id: <20210404041954.146958-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add missing mutex_destroy() to pair with mutex_init().

This should be done only when table is initialized, hence perform
mutex_init() only when table is initialized.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index 0526e3798c09..7161220afe30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -367,12 +367,13 @@ int mlx5_init_rl_table(struct mlx5_core_dev *dev)
 {
 	struct mlx5_rl_table *table = &dev->priv.rl_table;
 
-	mutex_init(&table->rl_lock);
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, packet_pacing)) {
 		table->max_size = 0;
 		return 0;
 	}
 
+	mutex_init(&table->rl_lock);
+
 	/* First entry is reserved for unlimited rate */
 	table->max_size = MLX5_CAP_QOS(dev, packet_pacing_rate_table_size) - 1;
 	table->max_rate = MLX5_CAP_QOS(dev, packet_pacing_max_rate);
@@ -394,4 +395,5 @@ void mlx5_cleanup_rl_table(struct mlx5_core_dev *dev)
 		return;
 
 	mlx5_rl_table_free(dev, table);
+	mutex_destroy(&table->rl_lock);
 }
-- 
2.30.2

