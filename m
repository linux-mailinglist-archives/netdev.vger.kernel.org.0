Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8625573FD3
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiGMW7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGMW7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEA42A42B
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6034F61651
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1334C341C0;
        Wed, 13 Jul 2022 22:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753152;
        bh=RtAInv/HJweYJo81jqJhDc5kDIsF4USARigflvaOV24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s4WodDGBjEQA10lKym0ctC+7oyGDMfayFA/N/69pUakjNd/yITG3aYJB49Z6YRwVb
         HSKfnwVTB0IHDAQy8QJlv24KZOVS5/UvcU4xOBBwZHeMumonJvJJq3nBF8fx1qnf4B
         TxjPxmqFsnnJ9IEZvMV9pwxIm1jQbCo8dy5Uei5Px4keLLl+qR+7SXDAcLgQqE6sgo
         wqnw2kt8LejeNB1Xx3Cqilujz+4Vsj+2s9oesgbnPhSFAu45/ncmMZsuFdyUZw+NRp
         GLF1bNqGcRqdaxVvEnZi2EkvNQRkVEG2I0IZh9O9+lmIkY8l7YIpsiXrDEtGLamFG8
         TJVdmA/o3vvng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [net-next 01/15] net/mlx5: Use the bitmap API to allocate bitmaps
Date:   Wed, 13 Jul 2022 15:58:45 -0700
Message-Id: <20220713225859.401241-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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
2.36.1

