Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2216953FF54
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243018AbiFGMsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbiFGMsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:48:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED3E1DA56;
        Tue,  7 Jun 2022 05:47:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AB60B81F6E;
        Tue,  7 Jun 2022 12:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DA1C34115;
        Tue,  7 Jun 2022 12:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654606075;
        bh=nr5wIX3n7k/7HKazdVulI9YN/hkkFCBYkUVklQ4tDKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbPJyqtZ0fgPtPa2BnAsSpjZquOLKjgMFDQCJ3JQ6CaT/JDYPqu59UnMtv2MZiLgh
         EbfBcHLGg6RVNVT4M/72erBhKxzNoNbvCwTGfRzvuIvFru0m5qBpSp3BnWNbjMMEhv
         d4+LdJuRt4IlGso8Vaufm69k5eBV6ibSwnlt2V1ybLFNxtu+lcjeLKyqcejYxX0IRG
         L4NMghNURUDZUo3gO0iXjWAkBUr9uNuSb5KVRelDhWaBMglFnBvRkSAVqLEQhpR0W+
         zGTgJQZ8f0qR9Wz32mA63ufkaYTRRUC6VYdeaft3MXMI8ztw3IMzEKoLgd1T4RIO6y
         7Wj96tNWHRpDQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 2/3] net/mlx5: Manage ICM of type modify-header pattern
Date:   Tue,  7 Jun 2022 15:47:44 +0300
Message-Id: <3d76cbb6e498c23aead29359b88e07facdfe817e.1654605768.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654605768.git.leonro@nvidia.com>
References: <cover.1654605768.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Added support for managing new type of ICM for devices that
support sw_owner_v2.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lib/dm.c  | 42 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  1 +
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
index 3d5e57ff558c..7e02cbe8c3b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c
@@ -12,13 +12,16 @@ struct mlx5_dm {
 	spinlock_t lock;
 	unsigned long *steering_sw_icm_alloc_blocks;
 	unsigned long *header_modify_sw_icm_alloc_blocks;
+	unsigned long *header_modify_pattern_sw_icm_alloc_blocks;
 };
 
 struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 {
+	u64 header_modify_pattern_icm_blocks = 0;
 	u64 header_modify_icm_blocks = 0;
 	u64 steering_icm_blocks = 0;
 	struct mlx5_dm *dm;
+	bool support_v2;
 
 	if (!(MLX5_CAP_GEN_64(dev, general_obj_types) & MLX5_GENERAL_OBJ_TYPES_CAP_SW_ICM))
 		return NULL;
@@ -53,8 +56,27 @@ struct mlx5_dm *mlx5_dm_create(struct mlx5_core_dev *dev)
 			goto err_modify_hdr;
 	}
 
+	support_v2 = MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner_v2) &&
+		     MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner_v2) &&
+		     MLX5_CAP64_DEV_MEM(dev, header_modify_pattern_sw_icm_start_address);
+
+	if (support_v2) {
+		header_modify_pattern_icm_blocks =
+			BIT(MLX5_CAP_DEV_MEM(dev, log_header_modify_pattern_sw_icm_size) -
+			    MLX5_LOG_SW_ICM_BLOCK_SIZE(dev));
+
+		dm->header_modify_pattern_sw_icm_alloc_blocks =
+			kcalloc(BITS_TO_LONGS(header_modify_pattern_icm_blocks),
+				sizeof(unsigned long), GFP_KERNEL);
+		if (!dm->header_modify_pattern_sw_icm_alloc_blocks)
+			goto err_pattern;
+	}
+
 	return dm;
 
+err_pattern:
+	kfree(dm->header_modify_sw_icm_alloc_blocks);
+
 err_modify_hdr:
 	kfree(dm->steering_sw_icm_alloc_blocks);
 
@@ -86,6 +108,14 @@ void mlx5_dm_cleanup(struct mlx5_core_dev *dev)
 		kfree(dm->header_modify_sw_icm_alloc_blocks);
 	}
 
+	if (dm->header_modify_pattern_sw_icm_alloc_blocks) {
+		WARN_ON(!bitmap_empty(dm->header_modify_pattern_sw_icm_alloc_blocks,
+				      BIT(MLX5_CAP_DEV_MEM(dev,
+							   log_header_modify_pattern_sw_icm_size) -
+					  MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))));
+		kfree(dm->header_modify_pattern_sw_icm_alloc_blocks);
+	}
+
 	kfree(dm);
 }
 
@@ -130,6 +160,13 @@ int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
 						log_header_modify_sw_icm_size);
 		block_map = dm->header_modify_sw_icm_alloc_blocks;
 		break;
+	case MLX5_SW_ICM_TYPE_HEADER_MODIFY_PATTERN:
+		icm_start_addr = MLX5_CAP64_DEV_MEM(dev,
+						    header_modify_pattern_sw_icm_start_address);
+		log_icm_size = MLX5_CAP_DEV_MEM(dev,
+						log_header_modify_pattern_sw_icm_size);
+		block_map = dm->header_modify_pattern_sw_icm_alloc_blocks;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -203,6 +240,11 @@ int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type
 		icm_start_addr = MLX5_CAP64_DEV_MEM(dev, header_modify_sw_icm_start_address);
 		block_map = dm->header_modify_sw_icm_alloc_blocks;
 		break;
+	case MLX5_SW_ICM_TYPE_HEADER_MODIFY_PATTERN:
+		icm_start_addr = MLX5_CAP64_DEV_MEM(dev,
+						    header_modify_pattern_sw_icm_start_address);
+		block_map = dm->header_modify_pattern_sw_icm_alloc_blocks;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index aeaedb985c1f..220597c2f436 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -676,6 +676,7 @@ struct mlx5e_resources {
 enum mlx5_sw_icm_type {
 	MLX5_SW_ICM_TYPE_STEERING,
 	MLX5_SW_ICM_TYPE_HEADER_MODIFY,
+	MLX5_SW_ICM_TYPE_HEADER_MODIFY_PATTERN,
 };
 
 #define MLX5_MAX_RESERVED_GIDS 8
-- 
2.36.1

