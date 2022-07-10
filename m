Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1523556CF2B
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 14:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiGJMhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 08:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiGJMhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 08:37:09 -0400
Received: from smtp.smtpout.orange.fr (smtp10.smtpout.orange.fr [80.12.242.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49ED13F9B
        for <netdev@vger.kernel.org>; Sun, 10 Jul 2022 05:36:41 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id AWAhoAvD20JImAWAho6ELU; Sun, 10 Jul 2022 14:36:24 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 10 Jul 2022 14:36:24 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH] net/mlx5: Use the bitmap API to allocate bitmaps
Date:   Sun, 10 Jul 2022 14:36:22 +0200
Message-Id: <ca036ba3d0c2ee307e1d8cc94aaaab1686ebf1c9.1657456513.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 .../net/ethernet/mellanox/mlx5/core/lib/dm.c  | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
index 7e02cbe8c3b9..9482e51ac82a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -38,8 +38,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 			    MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
 
 		dm->steering_sw_icm_alloc_blocks =
-			kcalloc(BITS_TO_LONGS(steering_icm_blocks),
-				sizeof(unsigned long), GFP_KERNEL);
+			bitmap_zalloc(steering_icm_blocks, GFP_KERNEL);
 		if (!dm->steering_sw_icm_alloc_blocks)
 			goto err_steering;
 	}
@@ -50,8 +49,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 			    MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
 
 		dm->header_modify_sw_icm_alloc_blocks =
-			kcalloc(BITS_TO_LONGS(header_modify_icm_blocks),
-				sizeof(unsigned long), GFP_KERNEL);
+			bitmap_zalloc(header_modify_icm_blocks, GFP_KERNEL);
 		if (!dm->header_modify_sw_icm_alloc_blocks)
 			goto err_modify_hdr;
 	}
@@ -66,8 +64,7 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 			    MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
 
 		dm->header_modify_pattern_sw_icm_alloc_blocks =
-			kcalloc(BITS_TO_LONGS(header_modify_pattern_icm_blocks),
-				sizeof(unsigned long), GFP_KERNEL);
+			bitmap_zalloc(header_modify_pattern_icm_blocks, GFP_KERNEL);
 		if (!dm->header_modify_pattern_sw_icm_alloc_blocks)
 			goto err_pattern;
 	}
@@ -75,10 +72,10 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 	return dm;
 
 err_pattern:
-	kfree(dm->header_modify_sw_icm_alloc_blocks);
+	bitmap_free(dm->header_modify_sw_icm_alloc_blocks);
 
 err_modify_hdr:
-	kfree(dm->steering_sw_icm_alloc_blocks);
+	bitmap_free(dm->steering_sw_icm_alloc_blocks);
 
 err_steering:
 	kfree(dm);
@@ -97,7 +94,7 @@ void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
 		WARN_ON(!bitmap_empty(dm->steering_sw_icm_alloc_blocks,
 				      BIT(MLX5_CAP_DEV_MEM(dev, log_steering_sw_icm_size) -
 					  MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))));
-		kfree(dm->steering_sw_icm_alloc_blocks);
+		bitmap_free(dm->steering_sw_icm_alloc_blocks);
 	}
 
 	if (dm->header_modify_sw_icm_alloc_blocks) {
@@ -105,7 +102,7 @@ void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
 				      BIT(MLX5_CAP_DEV_MEM(dev,
 							   log_header_modify_sw_icm_size) -
 				      MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))));
-		kfree(dm->header_modify_sw_icm_alloc_blocks);
+		bitmap_free(dm->header_modify_sw_icm_alloc_blocks);
 	}
 
 	if (dm->header_modify_pattern_sw_icm_alloc_blocks) {
@@ -113,7 +110,7 @@ void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
 				      BIT(MLX5_CAP_DEV_MEM(dev,
 							   log_header_modify_pattern_sw_icm_size) -
 					  MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))));
-		kfree(dm->header_modify_pattern_sw_icm_alloc_blocks);
+		bitmap_free(dm->header_modify_pattern_sw_icm_alloc_blocks);
 	}
 
 	kfree(dm);
-- 
2.34.1

