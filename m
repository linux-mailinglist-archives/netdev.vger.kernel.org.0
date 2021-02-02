Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F0F30B832
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhBBG6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:58:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232284AbhBBG4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 851F964EEC;
        Tue,  2 Feb 2021 06:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248919;
        bh=+WK38TP6EVN7zNCfMhGRFRphu9hzERyTcfMl9qdXwP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dxl+Xbiq3C0sHXQjNi6w7uQWgToGATfsyev8kgXs3zftvS4rXmsdwDenNyeT9yUE9
         qnTNMRkFea3WPAPkwcE+jEG5E5leKm6ffjT9DCJzKdqBfzkoG+OQ8nLAAjEtBrNZXG
         D8rWAVvvhbyvYDe/kVqh5ckEPbZOyASC1Tn1zwTedrVcMsfM261TmrCyTAk9/88CDa
         q/CR7aDoJCRIH9C4r4pfniR38DN5OXXI5eO0LLYaTBCF1bU+onLciYrZ9KqvTOwm+/
         xMqSOawV9BAF/j5AWQf46uq7jxhmv68Bi+643IJzpSIQQAvzz9Eail2vv/c/+cBbFx
         8lJZule2+Pevg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Noam Stolero <noams@nvidia.com>, Tal Gilboa <talgi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/14] net/mlx5e: Increase indirection RQ table size to 256
Date:   Mon,  1 Feb 2021 22:54:52 -0800
Message-Id: <20210202065457.613312-10-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Noam Stolero <noams@nvidia.com>

Increasing the indirection RQ table size from 128 to 256 improves the
packet distribution over the NIC HW queues for various cases.

Let's take a look at the following scenario:
Assuming RSS result distributed uniformly and indirection table is filled
with queues in a cyclic manner.
Let N be the number of queues on a given setup.
If 256%N = 128%N = 0, then all queues have the same probability to be
chosen for a given RSS result.
This case doesn't improves nor degrade by this change.

If 256%N != 0 and 128%N != 0, there is a remainder which will favor some
queues. Increasing the indirection RQ table size to 256 reduce the ratio
between the favored queues probability to be selected to the rest of the
queues and improves the distribution.

For example, let's assume the number of queues is 56.
For a table size of 128, we have 128%56=16 queues which will have a 3/128
probability to be chosen and 2/128 for the rest 40.
16 queues have 1.5 times the probability to be chosen over the other 40.

For a table size of 256, we have 256%56=32 queues which will have a 5/256
probability to be chosen and 4/256 probability for the rest 24 queues.
Here 32 queues have 1.25 more probability to be chosen over the other 24.

This shows that the larger indirection table size would more likely cause
an even distribution.

This change also aligns our mlx5 driver's indirection table size with
other vendors.

Signed-off-by: Noam Stolero <noams@nvidia.com>
Reviewed-by: Tal Gilboa <talgi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8cc80c31341f..a8e31cdd4a4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -137,10 +137,10 @@ struct page_pool;
 #define MLX5E_PARAMS_DEFAULT_MIN_RX_WQES                0x80
 #define MLX5E_PARAMS_DEFAULT_MIN_RX_WQES_MPW            0x2
 
-#define MLX5E_LOG_INDIR_RQT_SIZE       0x7
+#define MLX5E_LOG_INDIR_RQT_SIZE       0x8
 #define MLX5E_INDIR_RQT_SIZE           BIT(MLX5E_LOG_INDIR_RQT_SIZE)
 #define MLX5E_MIN_NUM_CHANNELS         0x1
-#define MLX5E_MAX_NUM_CHANNELS         MLX5E_INDIR_RQT_SIZE
+#define MLX5E_MAX_NUM_CHANNELS         (MLX5E_INDIR_RQT_SIZE / 2)
 #define MLX5E_MAX_NUM_SQS              (MLX5E_MAX_NUM_CHANNELS * MLX5E_MAX_NUM_TC)
 #define MLX5E_TX_CQ_POLL_BUDGET        128
 #define MLX5E_TX_XSK_POLL_BUDGET       64
-- 
2.29.2

