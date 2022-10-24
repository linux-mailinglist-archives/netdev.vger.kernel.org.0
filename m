Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F6260B190
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiJXQ1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiJXQ1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:27:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000EB4DB76
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 725C761382
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DA7C433C1;
        Mon, 24 Oct 2022 14:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666620055;
        bh=juJk5TR4mb03cF8R3ottFHcTn6utxbLn5HwMbi+LY6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eoc/Dzuo6pkyfsQx7mMvi6npFJ9xUHGA55rJ3/KzUMjV72ECiVLJjz1nUonRVmJYl
         Y+v/Ixtn6f4GTy6pK6DI5pjO6pg2EMMYISR4fjNAexSeGa+jFJl2lx6/BsQ+99Rsqi
         hZSrybaXd2UEtQgxjmo7xrPxHpU5N0g/vF4fYM/dX76PRXvnt8ff8zDXmbOmAaIlEO
         bgECsX75uWjmOt2nATz0tmXc4miHcwDqMp6GbzngVqM9KLCVhqmOUngN9mc43xiCXb
         ZDkBzfpxsfmxBFIf4yJxOVw2DxBlYZYZU5uwmjAaJQRYKWcJ9m4rLyUbQuifjjX3kS
         /ODoAbdZUO8iQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 12/14] net/mlx5: DR, Lower sync threshold for ICM hot memory
Date:   Mon, 24 Oct 2022 14:57:32 +0100
Message-Id: <20221024135734.69673-13-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024135734.69673-1-saeed@kernel.org>
References: <20221024135734.69673-1-saeed@kernel.org>
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

