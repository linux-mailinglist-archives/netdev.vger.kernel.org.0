Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4596835E71A
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348116AbhDMTbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346020AbhDMTay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC28D61220;
        Tue, 13 Apr 2021 19:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342234;
        bh=N3cRa2k/BT1JCmO7ZB/H3Z4+qM9i/LrvzgaV+/uLyus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1rimqm0w5rH9lSZrKpEVJ7RxNbbWgzJS4oYXtVKTcmomiH7nARdl7LT6212uIGL9
         RWZvEZd2lynlPvM4FYTZkHnp/pJbX7L25zbCjqoh/4fgilICU0tGL8/dMOQjRjYhs1
         li8ypv7OIxvrB8F0tdfZnQEpZSVi7bh8SCm+R+LwAa6jGFsRer9mFL2li4mh0razez
         MkiifEI7Aj9/e7aCDA6eCkFHJop04ichY+OPNpBhhjlYXI59Z4s8M+LI/JGBUS40AE
         fIYsfNr2pZomFBvDeLip2VWHUWKb+wwfH5mx14zjL6+7atCk2rmbY1DaLpoptgW7rR
         iYYozsdzhBZYw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/16] net/mlx5: DR, Alloc cmd buffer with kvzalloc() instead of kzalloc()
Date:   Tue, 13 Apr 2021 12:30:01 -0700
Message-Id: <20210413193006.21650-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
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

