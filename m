Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575266822A3
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjAaDNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjAaDMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB5938EBC
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5832D61381
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9831C433D2;
        Tue, 31 Jan 2023 03:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134740;
        bh=luS0tx8G7HuGM1jwx0YHas0NSy3Na3MNDqESCB0LL4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5ieD52KSv/apWzPA5NumGMJmsn6/JvjaqQup++4Tj+s67kViDL1Fh157rTCI9uME
         1uSZBDYXWj+SeYLuqgCggyKmp/KaxRTb22TFCVLZDCvWA+FelXBQ3SzPxk1jJmRD6C
         taG14SHs8H8+Lebk7MqLvL1fuVsw/YcbjLMSW1YbFhY1mYWOL5U9Dp896GLLjPiVUE
         oNqGpS1gWxLFHuNGKf5Y2LsXNPqcUiKdzIUew+pEEp2LAC7CYH5C6+2unm1eJ1o7jP
         X7cEWSShZjwa1PlgSTf+kZM1PwAnfWEN8R6yVcibdcMApuu5TIzI0EzxrRqCd65hX4
         vKcrv8CAguJYw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 14/15] net/mlx5: Keep only one bulk of full available DEKs
Date:   Mon, 30 Jan 2023 19:12:00 -0800
Message-Id: <20230131031201.35336-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131031201.35336-1-saeed@kernel.org>
References: <20230131031201.35336-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

One bulk with full available keys is left undestroyed, to service the
possible requests from users quickly.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/crypto.c   | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index e078530ef37d..3a94b8f8031e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -506,12 +506,19 @@ static void mlx5_crypto_dek_bulk_reset_synced(struct mlx5_crypto_dek_pool *pool,
 	}
 }
 
-static void mlx5_crypto_dek_bulk_handle_avail(struct mlx5_crypto_dek_pool *pool,
+/* Return true if the bulk is reused, false if destroyed with delay */
+static bool mlx5_crypto_dek_bulk_handle_avail(struct mlx5_crypto_dek_pool *pool,
 					      struct mlx5_crypto_dek_bulk *bulk,
 					      struct list_head *destroy_list)
 {
+	if (list_empty(&pool->avail_list)) {
+		list_move(&bulk->entry, &pool->avail_list);
+		return true;
+	}
+
 	mlx5_crypto_dek_pool_remove_bulk(pool, bulk, true);
 	list_add(&bulk->entry, destroy_list);
+	return false;
 }
 
 static void mlx5_crypto_dek_pool_splice_destroy_list(struct mlx5_crypto_dek_pool *pool,
@@ -535,7 +542,7 @@ static void mlx5_crypto_dek_pool_free_wait_keys(struct mlx5_crypto_dek_pool *poo
 
 /* For all the bulks in each list, reset the bits while sync.
  * Move them to different lists according to the number of available DEKs.
- * Destrory all the idle bulks for now.
+ * Destrory all the idle bulks, except one for quick service.
  * And free DEKs in the waiting list at the end of this func.
  */
 static void mlx5_crypto_dek_pool_reset_synced(struct mlx5_crypto_dek_pool *pool)
@@ -562,11 +569,12 @@ static void mlx5_crypto_dek_pool_reset_synced(struct mlx5_crypto_dek_pool *pool)
 	}
 
 	list_for_each_entry_safe(bulk, tmp, &pool->sync_list, entry) {
-		memset(bulk->need_sync, 0, BITS_TO_BYTES(bulk->num_deks));
-		bulk->avail_start = 0;
 		bulk->avail_deks = bulk->num_deks;
 		pool->avail_deks += bulk->num_deks;
-		mlx5_crypto_dek_bulk_handle_avail(pool, bulk, &destroy_list);
+		if (mlx5_crypto_dek_bulk_handle_avail(pool, bulk, &destroy_list)) {
+			memset(bulk->need_sync, 0, BITS_TO_BYTES(bulk->num_deks));
+			bulk->avail_start = 0;
+		}
 	}
 
 	mlx5_crypto_dek_pool_free_wait_keys(pool);
-- 
2.39.1

