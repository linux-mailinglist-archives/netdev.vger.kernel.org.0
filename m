Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF937334782
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhCJTEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhCJTED (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:04:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C423664FCD;
        Wed, 10 Mar 2021 19:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403043;
        bh=AsCp7Q3ASY5fQ3uCys1QXS4icwVJ/QYriXknYc6Ii6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t89z4xbLWjvMJnBWTqHlX+pJQt/RXHEdPi0OVvakwMfKTPENnAMkrrZEbnDbrMINP
         mNs4hmzRvZo8YeJ54JDS50vkawFvCy7AnhuJSwCmGliPHVxfcEDmw8WC9NUrcV5lZN
         kG151lNtqg+SrJrBZeGMaeEdVc8UjrEZtPVEITS9qb2mc7yKVAZLszqiHZvrwgUI7+
         g213IH4N7sx528oLl1h68rm6WwJzmWUywPqDm8NWoH6smoSRLIYpevow3syJesAOYj
         MbhYAUXqNul+MZmFjMIiPTsSvbos0Dz+09hC/bKKJJaekrbDttNgpedbeK+z2nKQIc
         VorBx632U2Glg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 18/18] net/mlx5: DR, Fix potential shift wrapping of 32-bit value in STEv1 getter
Date:   Wed, 10 Mar 2021 11:03:42 -0800
Message-Id: <20210310190342.238957-19-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Fix 32-bit variable shift wrapping in dr_ste_v1_get_miss_addr.

Fixes: a6098129c781 ("net/mlx5: DR, Add STEv1 setters and getters")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 4088d6e51508..9143ec326ebf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -264,8 +264,8 @@ static void dr_ste_v1_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
 static u64 dr_ste_v1_get_miss_addr(u8 *hw_ste_p)
 {
 	u64 index =
-		(MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_31_6) |
-		 MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_39_32) << 26);
+		((u64)MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_31_6) |
+		 ((u64)MLX5_GET(ste_match_bwc_v1, hw_ste_p, miss_address_39_32)) << 26);
 
 	return index << 6;
 }
-- 
2.29.2

