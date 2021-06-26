Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8928F3B4D7D
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 09:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhFZHrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 03:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhFZHrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 03:47:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 780476186A;
        Sat, 26 Jun 2021 07:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624693496;
        bh=LUow8aDu7UyIBr9vl+NV9KscFpX4p3SkIVKvtQSBEcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2aTOwuHY+hsNdwxAEjvnhwTv6qrY7wZjOpJ2cPThex0DNzGMXyRGIUDGhlXYunbC
         kmzhye810+FiDCcCtuvcCDDkqyKYCYEeWh4S6AbMwWxWiBBMM3fof+QN1qUutqQ31d
         UNRtT839GhU29fpOkEM1RiOqsJ2u9e0HD+P7bk7mqgdGA4tP9KTLWzdhUv+Nfs+sS0
         sf/h9j8RhPkk5/1asMAsZb3GXux6ruQAqheglp8c8pTMyxkw2jpUSK5iNaqhB6JlLE
         R39z4DdBS5JoEdh3cKeKU9+0I3/h+ImR6kupfjHAn7OMWWAO1+I60O6xOrOsFQsIhr
         6oK8594h72VZQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 4/6] net/mlx5: SF, Improve performance in SF allocation
Date:   Sat, 26 Jun 2021 00:44:15 -0700
Message-Id: <20210626074417.714833-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210626074417.714833-1-saeed@kernel.org>
References: <20210626074417.714833-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Avoid second traversal on the SF table by recording the first free entry
and using it in case the looked up entry was not found in the table.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 500c71fb6f6d..d9c69123c1ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -73,26 +73,29 @@ static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_table *table, u32 control
 				     u32 usr_sfnum)
 {
 	struct mlx5_sf_hwc_table *hwc;
+	int free_idx = -1;
 	int i;
 
 	hwc = mlx5_sf_controller_to_hwc(table->dev, controller);
 	if (!hwc->sfs)
 		return -ENOSPC;
 
-	/* Check if sf with same sfnum already exists or not. */
 	for (i = 0; i < hwc->max_fn; i++) {
+		if (!hwc->sfs[i].allocated && free_idx == -1) {
+			free_idx = i;
+			continue;
+		}
+
 		if (hwc->sfs[i].allocated && hwc->sfs[i].usr_sfnum == usr_sfnum)
 			return -EEXIST;
 	}
-	/* Find the free entry and allocate the entry from the array */
-	for (i = 0; i < hwc->max_fn; i++) {
-		if (!hwc->sfs[i].allocated) {
-			hwc->sfs[i].usr_sfnum = usr_sfnum;
-			hwc->sfs[i].allocated = true;
-			return i;
-		}
-	}
-	return -ENOSPC;
+
+	if (free_idx == -1)
+		return -ENOSPC;
+
+	hwc->sfs[free_idx].usr_sfnum = usr_sfnum;
+	hwc->sfs[free_idx].allocated = true;
+	return free_idx;
 }
 
 static void mlx5_sf_hw_table_id_free(struct mlx5_sf_hw_table *table, u32 controller, int id)
-- 
2.31.1

