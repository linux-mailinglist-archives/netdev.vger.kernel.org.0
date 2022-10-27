Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D373F60FAF5
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbiJ0O6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236002AbiJ0O5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D551D2CDD
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EC15B82681
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4BFC433C1;
        Thu, 27 Oct 2022 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882669;
        bh=juJk5TR4mb03cF8R3ottFHcTn6utxbLn5HwMbi+LY6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgMEMrYWaenVhkOxxXqTTE4ECzYi9kWlsBcxTCalTQ/CeNHvAz6T20ztTouV4oSZM
         SwTJFSS07Cr/geeVVCUNTgngAGTV1oT0caI7U+iKhIlQl29lU4TBYLzeZnPKCfREQn
         JP+CxLfMfAobzRKov703I2dFjiBkCc6V+y7Oo3UlkQEQSZprJkAZrCOlURFgtlUggF
         9nZtKfw3ISXUhEEKfb79SU9yOTJcElQpqLzMukyrhXbx+65tgCyknyMjIT+9Jf3o9x
         KuWjPb+W6apCC0gqh45UnHPKwVHabL0N1D68AyiK2hoP9ZsEYqKebx1xgstGhsN8Yy
         sVJNolegXLR4w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 12/14] net/mlx5: DR, Lower sync threshold for ICM hot memory
Date:   Thu, 27 Oct 2022 15:56:41 +0100
Message-Id: <20221027145643.6618-13-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221027145643.6618-1-saeed@kernel.org>
References: <20221027145643.6618-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Instead of hiding the math in the code, define a value that sets the
fraction of allowed hot memory of ICM pool.
Set the threshold for sync of ICM hot chunks to 1/4 of the pool
instead of 1/2 of the pool. Although we will have more syncs, each
sync will be shorter and will help with insertion rate stability.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c  | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index ca91a0211a5c..286b7ce6bc0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -4,6 +4,7 @@
 #include "dr_types.h"
 
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
+#define DR_ICM_POOL_HOT_MEMORY_FRACTION 4
 
 struct mlx5dr_icm_pool {
 	enum mlx5dr_icm_type icm_type;
@@ -337,10 +338,11 @@ static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 {
 	int allow_hot_size;
 
-	/* sync when hot memory reaches half of the pool size */
+	/* sync when hot memory reaches a certain fraction of the pool size */
 	allow_hot_size =
 		mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz,
-						   pool->icm_type) / 2;
+						   pool->icm_type) /
+		DR_ICM_POOL_HOT_MEMORY_FRACTION;
 
 	return pool->hot_memory_size > allow_hot_size;
 }
-- 
2.37.3

