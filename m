Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38367334783
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbhCJTEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233766AbhCJTEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:04:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F83C64FD0;
        Wed, 10 Mar 2021 19:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403042;
        bh=GUnko2cH/KeDbj/s3T5xHycJYzy2NsWuBKqlpQY9zqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnAmQCRZGTCU9DASkTg/4dJhUjqEFFWNBlMQFjKreYbKS8DdijnhnJYok40f+BdRJ
         WDn1o9n7u8KenHMS9KpVzRhmwpyon8Hrs0GlHv8JpLjHyIHsdPbMr7dJEdeC+tGweT
         QyKihNUb1I8W/snjUC4KQAmEz1RmjDYhSgKfBqkrgQgkdkCcMv3yxGOtW6RQY6rmfW
         3W63oMY4aIkaSq3qEpburTh+gkasNiogu2BTTwfUJIIQkyupXrqZtW+Wxddxz64JZL
         ZN3PdkFG83gWg43gGk/Z/xuVCQttPy7ZT4/02YKj43ZEGmk8ZamU4dwrLAuTFRcAhS
         nnUrv29HUGoYg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 17/18] net/mlx5: SF: Fix error flow of SFs allocation flow
Date:   Wed, 10 Mar 2021 11:03:41 -0800
Message-Id: <20210310190342.238957-18-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

When SF id is unavailable, code jumps to wrong label that accesses
sw id array outside of its range.
Hence, when SF id is not allocated, avoid accessing such array.

Fixes: 8f0105418668 ("net/mlx5: SF, Add port add delete functionality")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 58b6be0b03d7..0914909806cb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -64,7 +64,7 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 	}
 	if (sw_id == -ENOSPC) {
 		err = -ENOSPC;
-		goto err;
+		goto exist_err;
 	}
 
 	hw_fn_id = mlx5_sf_sw_to_hw_id(table->dev, sw_id);
-- 
2.29.2

