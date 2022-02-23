Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3981B4C1946
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243135AbiBWRFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243125AbiBWRFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE214B413
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 543C160FCF
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D370C340F3;
        Wed, 23 Feb 2022 17:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635879;
        bh=gItcOa8zwD9ItJXB+g9jfCZcoHr5h3UyShrku+YHgQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEHNt/8k3m0Koyl6D/IT/zOH48gjncWHRrmcIXvuiK7+GVouQD78sCN4Dne4mDULJ
         ZmccBUBFFNhM5SSx/U6XKsElbSUOkFTTrBhonctJDBmxdmCNuS5HjOb/gzzgweOruz
         0DhNS5Ac67jvcDtsNjpXCVPWydgsL08SxMxArcME2HD60f6UuJ7NMo06pQnRRhtUCQ
         E73OC6+GbSMd9T988hCSfxvpZV3PjGrSbS2uJd8SB4lmfHavVwuRS1jNYwLw0m/+Hm
         kQKQXlI0gSl+VxETYg7jHe9CscXttfktK0Dz24yHbRUqvvOV9bibxDhSvZ8nzgX/p/
         xws08mjYZPn3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/19] net/mlx5: DR, Fix the threshold that defines when pool sync is initiated
Date:   Wed, 23 Feb 2022 09:04:16 -0800
Message-Id: <20220223170430.295595-6-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223170430.295595-1-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When deciding whether to start syncing and actually free all the "hot"
ICM chunks, we need to consider the type of the ICM chunks that we're
dealing with. For instance, the amount of available ICM for MODIFY_ACTION
is significantly lower than the usual STE ICM, so the threshold should
account for that - otherwise we can deplete MODIFY_ACTION memory just by
creating and deleting the same modify header action in a continuous loop.

This patch replaces the hard-coded threshold with a dynamic value.

Fixes: 1c58651412bb ("net/mlx5: DR, ICM memory pools sync optimization")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c         | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index f496b7e9401b..e289cfdbce07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -4,7 +4,6 @@
 #include "dr_types.h"
 
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
-#define DR_ICM_SYNC_THRESHOLD_POOL (64 * 1024 * 1024)
 
 struct mlx5dr_icm_pool {
 	enum mlx5dr_icm_type icm_type;
@@ -324,10 +323,14 @@ dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
 
 static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 {
-	if (pool->hot_memory_size > DR_ICM_SYNC_THRESHOLD_POOL)
-		return true;
+	int allow_hot_size;
 
-	return false;
+	/* sync when hot memory reaches half of the pool size */
+	allow_hot_size =
+		mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
+						   pool->icm_type) / 2;
+
+	return pool->hot_memory_size > allow_hot_size;
 }
 
 static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
-- 
2.35.1

