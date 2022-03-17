Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07234DCE33
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbiCQS4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiCQSzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E773B165AA8
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C253617B6
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F095DC340F2;
        Thu, 17 Mar 2022 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647543276;
        bh=i6ufKBbj6RUDiMTeu3D5eHbhE6zqs8JdvkPgV4bcoRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3fmWferd3O6/ud5LxJg4h6ufsOxB+MxaMUSHb7l7J52GuHhZ0RTDodu/7pRoCSMK
         iQP+LdQqO0wp2g8p3yfKR0clNMfmQPz/M9k4xLRNy+6pjfshYBjy4wiVm5GeO5xFEJ
         iB9vbozvCqr0Bn4XYhKNTCAVxbLwRyWPUhBJUAnflaD/aGz1kC7SBXQwDwLTv56E9Z
         s2RZcI41OzprAnc2IYLpSzlMAzeplhjq4hL1d5fZd/VX91vqLnDuxTU41/UPSfF763
         CEonvPeLmFMt9CLAv+m8hgIruhNkbVIgRT/MfViOCqFJzX8kHqBeOQ2WzwJQ+Wq8RU
         OV4tmvVknEfNw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: Remove unused fill page array API function
Date:   Thu, 17 Mar 2022 11:54:24 -0700
Message-Id: <20220317185424.287982-16-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317185424.287982-1-saeed@kernel.org>
References: <20220317185424.287982-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

mlx5_fill_page_array API function is not used.
Remove it, reduce the number of exported functions.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c | 13 -------------
 include/linux/mlx5/driver.h                     |  1 -
 2 files changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index 1762c5c36042..e52b0bac09da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -239,19 +239,6 @@ void mlx5_db_free(struct mlx5_core_dev *dev, struct mlx5_db *db)
 }
 EXPORT_SYMBOL_GPL(mlx5_db_free);
 
-void mlx5_fill_page_array(struct mlx5_frag_buf *buf, __be64 *pas)
-{
-	u64 addr;
-	int i;
-
-	for (i = 0; i < buf->npages; i++) {
-		addr = buf->frags->map + (i << buf->page_shift);
-
-		pas[i] = cpu_to_be64(addr);
-	}
-}
-EXPORT_SYMBOL_GPL(mlx5_fill_page_array);
-
 void mlx5_fill_page_frag_array_perm(struct mlx5_frag_buf *buf, __be64 *pas, u8 perm)
 {
 	int i;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a386aec1eb65..96cd740d94a3 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1036,7 +1036,6 @@ int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev);
 void mlx5_register_debugfs(void);
 void mlx5_unregister_debugfs(void);
 
-void mlx5_fill_page_array(struct mlx5_frag_buf *buf, __be64 *pas);
 void mlx5_fill_page_frag_array_perm(struct mlx5_frag_buf *buf, __be64 *pas, u8 perm);
 void mlx5_fill_page_frag_array(struct mlx5_frag_buf *frag_buf, __be64 *pas);
 int mlx5_vector2eqn(struct mlx5_core_dev *dev, int vector, int *eqn);
-- 
2.35.1

