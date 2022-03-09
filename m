Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896AE4D3AE4
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbiCIUQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbiCIUQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:16:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1405C45539
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 12:15:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3DF4B82167
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F594C340F5;
        Wed,  9 Mar 2022 20:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646856926;
        bh=dgE3YUnRAnzBIaI0paRcGhNsBQkSna81OAJbsNZsrxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c8gHGLME2NZjZgcTHy0/+72wDcvWAlUFoh3l5Z50eCnjorN7h97eXTSUQ/nyRo/04
         8Juk8fWKzA1T6aINN7VhEfZjo4uU/QdFp9ffsbz5etOXUObhfSFI/JeDiGrfqsba27
         ZJ2Umm6mu7V404vZ3V0OdOrZIsORSk074gZ5vkiORnsjIkshXAUE272LRcO/V8Fe26
         y+1AqmbL/XKeIxskkVmewiidk0YeB2Q+GmlkWm0OOJWQnIuS/HL05yob2Ax6GQzVEZ
         hc4CmJCzEpzU86hCsV733gph9JX6fPWqdDJFQTp07M6Pzkw5g1ixeu8WmawkuAJbkA
         ncxdQO39pnjbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/5] net/mlx5e: Lag, Only handle events from highest priority multipath entry
Date:   Wed,  9 Mar 2022 12:15:16 -0800
Message-Id: <20220309201517.589132-5-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309201517.589132-1-saeed@kernel.org>
References: <20220309201517.589132-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

There could be multiple multipath entries but changing the port affinity
for each one doesn't make much sense and there should be a default one.
So only track the entry with lowest priority value.
The commit doesn't affect existing users with a single entry.

Fixes: 544fe7c2e654 ("net/mlx5e: Activate HW multipath and handle port affinity based on FIB events")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 1ca01a5b6cdd..626aa60b6099 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -126,6 +126,10 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 		return;
 	}
 
+	/* Handle multipath entry with lower priority value */
+	if (mp->mfi && mp->mfi != fi && fi->fib_priority >= mp->mfi->fib_priority)
+		return;
+
 	/* Handle add/replace event */
 	nhs = fib_info_num_path(fi);
 	if (nhs == 1) {
@@ -135,12 +139,13 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 			int i = mlx5_lag_dev_get_netdev_idx(ldev, nh_dev);
 
 			if (i < 0)
-				i = MLX5_LAG_NORMAL_AFFINITY;
-			else
-				++i;
+				return;
 
+			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
 		}
+
+		mp->mfi = fi;
 		return;
 	}
 
-- 
2.35.1

