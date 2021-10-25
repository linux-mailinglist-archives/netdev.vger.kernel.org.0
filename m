Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECA843A50E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhJYU47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230464AbhJYU46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1389F61073;
        Mon, 25 Oct 2021 20:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195275;
        bh=SkWGNoyrFi/HNvnUEYjPF/EfVyvaQVn4pdzjGIL1VJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+cCnrkwR7pSt8djiRsM6RSGD2l3Cak1LcYCS52qUYBCdPiLbw/8VXG6OEoe9LeWL
         4/vk7MFMYAn7ldPR+mplwqEJVanz6py46W4U7MQyWfzCEBQtBwvKHbGnwPY9o705Zd
         W2Ivs3DDFlM5YYy+kOFQpcScrOl35Eb1m+U91moVkQs/EXq/AK4tobuqEULOjSWvqc
         NWCWzuBwoV92lG55LB9NnoXhZxnAx7mcovobRDd5faLeZlUC8WfmiGntQMvPE7i8cX
         c0TCeGKipIiv1N9j3juCAio572VEaXPqPxzbAaj5F6yY3wjYjjjCr3K9rgcwFgucwn
         Nov4HG4mnCqwQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Avihai Horon <avihaih@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/14] net/mlx5: Reduce flow counters bulk query buffer size for SFs
Date:   Mon, 25 Oct 2021 13:54:21 -0700
Message-Id: <20211025205431.365080-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Currently, the flow counters bulk query buffer takes a little more than
512KB of memory, which is aligned to the next power of 2, to 1MB.

The buffer size determines the maximum number of flow counters that can
be queried at a time. Thus, having a bigger buffer can improve
performance for users that need to query many flow counters.

SFs don't use many flow counters and don't need a big buffer. Since this
size is critical with large scale, reduce the size of the bulk query
buffer for SFs.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index f542a36be62c..60c9df1bc912 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -40,6 +40,7 @@
 #define MLX5_FC_STATS_PERIOD msecs_to_jiffies(1000)
 /* Max number of counters to query in bulk read is 32K */
 #define MLX5_SW_MAX_COUNTERS_BULK BIT(15)
+#define MLX5_SF_NUM_COUNTERS_BULK 6
 #define MLX5_FC_POOL_MAX_THRESHOLD BIT(18)
 #define MLX5_FC_POOL_USED_BUFF_RATIO 10
 
@@ -146,8 +147,12 @@ static void mlx5_fc_stats_remove(struct mlx5_core_dev *dev,
 
 static int get_max_bulk_query_len(struct mlx5_core_dev *dev)
 {
-	return min_t(int, MLX5_SW_MAX_COUNTERS_BULK,
-			  (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
+	int num_counters_bulk = mlx5_core_is_sf(dev) ?
+					MLX5_SF_NUM_COUNTERS_BULK :
+					MLX5_SW_MAX_COUNTERS_BULK;
+
+	return min_t(int, num_counters_bulk,
+		     (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
 }
 
 static void update_counter_cache(int index, u32 *bulk_raw_data,
-- 
2.31.1

