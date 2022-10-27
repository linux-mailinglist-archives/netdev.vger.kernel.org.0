Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7909A60FAEF
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiJ0O5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiJ0O5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CB9C895C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5177B62367
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40328C433C1;
        Thu, 27 Oct 2022 14:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882647;
        bh=cSp6A9X9L3EK5rsVVbMBjEYjbjnDd4RX89Hzi++7BTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRaHcykkpgGme98nKrIQXXH89rivvPQr0h+9qDhIgRbOIL3Mvrbs4z3Tl+YKBrFXj
         MRI6TN2686CLky6SUxD71ikHSLb/4mYM7AZPwtf4Yilb7TjLvSv9+QY79S+4q+rfYp
         L+6ZOlOY9+zUxICgADPzZMmREPaDGADPp8H1YOwJu5W3Ojq94HQnmynuLywFukFLiW
         SPC0nzsbMhPgy/x6zPuq73EW6k28kQv+E94475XrZykzu3xUJ+gOSgnIDA8BqV8ufe
         D9sXQ9U78lD8myumuXiahL2XZvqneF5XrxSK5m0apNAjkTQqD46cDnB7CBz+uJgt57
         6YuNclERXgp9A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 06/14] net/mlx5: DR, Initialize chunk's ste_arrays at chunk creation
Date:   Thu, 27 Oct 2022 15:56:35 +0100
Message-Id: <20221027145643.6618-7-saeed@kernel.org>
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

Rather than cleaning the corresponding chunk's section of ste_arrays on
chunk deletion, initialize these areas upon chunk creation.

Chunk destruction tend to come in large batches (during pool syncing).
To reduce the "hiccup" in such cases, moving ste_arrays init from chunk
destruction to initialization.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 25 +++----------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 4cdc9e9a54e1..7ca1ef073f55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -177,42 +177,25 @@ static int dr_icm_buddy_get_ste_size(struct mlx5dr_icm_buddy_mem *buddy)
 
 static void dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk, int offset)
 {
+	int num_of_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(chunk);
 	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
+	int ste_size = dr_icm_buddy_get_ste_size(buddy);
 	int index = offset / DR_STE_SIZE;
 
 	chunk->ste_arr = &buddy->ste_arr[index];
 	chunk->miss_list = &buddy->miss_list[index];
-	chunk->hw_ste_arr = buddy->hw_ste_arr +
-			    index * dr_icm_buddy_get_ste_size(buddy);
-}
-
-static void dr_icm_chunk_ste_cleanup(struct mlx5dr_icm_chunk *chunk)
-{
-	int num_of_entries = mlx5dr_icm_pool_get_chunk_num_of_entries(chunk);
-	struct mlx5dr_icm_buddy_mem *buddy = chunk->buddy_mem;
+	chunk->hw_ste_arr = buddy->hw_ste_arr + index * ste_size;
 
-	memset(chunk->hw_ste_arr, 0,
-	       num_of_entries * dr_icm_buddy_get_ste_size(buddy));
+	memset(chunk->hw_ste_arr, 0, num_of_entries * ste_size);
 	memset(chunk->ste_arr, 0,
 	       num_of_entries * sizeof(chunk->ste_arr[0]));
 }
 
-static enum mlx5dr_icm_type
-get_chunk_icm_type(struct mlx5dr_icm_chunk *chunk)
-{
-	return chunk->buddy_mem->pool->icm_type;
-}
-
 static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk)
 {
-	enum mlx5dr_icm_type icm_type = get_chunk_icm_type(chunk);
-
 	chunk->buddy_mem->used_memory -= mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 	list_del(&chunk->chunk_list);
 
-	if (icm_type == DR_ICM_TYPE_STE)
-		dr_icm_chunk_ste_cleanup(chunk);
-
 	kvfree(chunk);
 }
 
-- 
2.37.3

