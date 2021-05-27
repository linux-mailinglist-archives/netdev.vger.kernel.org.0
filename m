Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C732392685
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhE0Eim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234405AbhE0EiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DBB2613D4;
        Thu, 27 May 2021 04:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090202;
        bh=2rd1W00vHy8UjgvFM2FUE1tslDVmc0vnnWiXkQB9i+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZC/bZEM0rDFBQPzQmwRi/FYf3ts4R3SIBd+1Vnptyv9wOYQiOEa9IIluuLXlEGx7
         sOUoLOmdsp8LmYL34mlJTesEXn60bZ+WBMNLpUvNSvoK5ZDYTQTRj8502jkCxslhvU
         2ySJ3TI6TaAHbWDBZF4ZPQeWBqw6Od4pxE8FKnmJi6Yntk7E37T1tJJ+UHllma1EzH
         yhyScueFZLNn+P0lrglCg45TJE1J5eRQpnspJu4R/uTz8pCvLJtsEaROsMTCPhyt5/
         kk26QG8J62SmPvrj5NKhQnla9w3mkYcqUy5fMiQQ3jqiEeAhdHs9OsKcRDjaRH+dIM
         TdMVTbqDTkaCQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 17/17] net/mlx5: Improve performance in SF allocation
Date:   Wed, 26 May 2021 21:36:09 -0700
Message-Id: <20210527043609.654854-18-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Avoid second traversal on the SF table by recording the first free entry
and using it in case the looked up entry was not found in the table.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index ef5f892aafad..0c1fbf711fe6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -74,26 +74,29 @@ static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_table *table, u32 control
 				     u32 usr_sfnum)
 {
 	struct mlx5_sf_hwc_table *hwc;
+	int free_idx = -1;
 	int i;
 
 	hwc = mlx5_sf_controller_to_hwc(table->dev, controller);
 	if (!hwc->sfs)
 		return -ENOSPC;
 
-	/* Check if sf with same sfnum already exists or not. */
-	for (i = 0; i < hwc->max_fn; i++) {
-		if (hwc->sfs[i].allocated && hwc->sfs[i].usr_sfnum == usr_sfnum)
-			return -EEXIST;
-	}
-	/* Find the free entry and allocate the entry from the array */
 	for (i = 0; i < hwc->max_fn; i++) {
 		if (!hwc->sfs[i].allocated) {
-			hwc->sfs[i].usr_sfnum = usr_sfnum;
-			hwc->sfs[i].allocated = true;
-			return i;
+			free_idx = free_idx == -1 ? i : -1;
+			continue;
 		}
+
+		if (hwc->sfs[i].usr_sfnum == usr_sfnum)
+			return -EEXIST;
 	}
-	return -ENOSPC;
+
+	if (free_idx == -1)
+		return -ENOSPC;
+
+	hwc->sfs[free_idx].usr_sfnum = usr_sfnum;
+	hwc->sfs[free_idx].allocated = true;
+	return 0;
 }
 
 static void mlx5_sf_hw_table_id_free(struct mlx5_sf_hw_table *table, u32 controller, int id)
-- 
2.31.1

