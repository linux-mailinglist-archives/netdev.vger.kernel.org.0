Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D9635FA47
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352303AbhDNSHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352121AbhDNSGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 972EA611F0;
        Wed, 14 Apr 2021 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423577;
        bh=N3cRa2k/BT1JCmO7ZB/H3Z4+qM9i/LrvzgaV+/uLyus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7sbVT4da3k0umXzMe6CiE/0hhQ0/WVLEh+jhO/pZ1OkVAdduuWvc18p+ADRs2U4R
         66YULUxv8FouCy75drB9Hr1wHhEN/chj9Tz4v0of2gC/uNM8w6OSDPaxtsSCDhX8VO
         IVKotCEO2W9+ZfDC08YS95rle6ogzE73xWACqZQP13oYllzULdyBlpuggpx9kByglT
         Ilk+nwwAssW/0/1MW2noca5Zl0DTSfksg1n/pR/H2WR8bzarR7T5KIsXWr8jQi+8L5
         ktDNwiMJkFOwz77496w8kTzSmpeN38YiKVBiEcbvTzplyadDeRHfHG/1oYuB2Aixd1
         vL4u6yEorVczQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 11/16] net/mlx5: DR, Alloc cmd buffer with kvzalloc() instead of kzalloc()
Date:   Wed, 14 Apr 2021 11:06:00 -0700
Message-Id: <20210414180605.111070-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The cmd size is 8K so use kvzalloc().

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c  | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 30b0136b5bc7..461473d31e2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -287,7 +287,7 @@ int mlx5dr_cmd_create_empty_flow_group(struct mlx5_core_dev *mdev,
 	u32 *in;
 	int err;
 
-	in = kzalloc(inlen, GFP_KERNEL);
+	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
 
@@ -302,7 +302,7 @@ int mlx5dr_cmd_create_empty_flow_group(struct mlx5_core_dev *mdev,
 	*group_id = MLX5_GET(create_flow_group_out, out, group_id);
 
 out:
-	kfree(in);
+	kvfree(in);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 24acced415d3..c1926d927008 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -406,7 +406,7 @@ static int dr_get_tbl_copy_details(struct mlx5dr_domain *dmn,
 		alloc_size = *num_stes * DR_STE_SIZE;
 	}
 
-	*data = kzalloc(alloc_size, GFP_KERNEL);
+	*data = kvzalloc(alloc_size, GFP_KERNEL);
 	if (!*data)
 		return -ENOMEM;
 
@@ -505,7 +505,7 @@ int mlx5dr_send_postsend_htbl(struct mlx5dr_domain *dmn,
 	}
 
 out_free:
-	kfree(data);
+	kvfree(data);
 	return ret;
 }
 
@@ -562,7 +562,7 @@ int mlx5dr_send_postsend_formatted_htbl(struct mlx5dr_domain *dmn,
 	}
 
 out_free:
-	kfree(data);
+	kvfree(data);
 	return ret;
 }
 
-- 
2.30.2

