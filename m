Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E176B9D6B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjCNRt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCNRtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:49:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558408F53D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E053F61884
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FB4C433AC;
        Tue, 14 Mar 2023 17:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816190;
        bh=KpoGng78hCrFX8AFMfujUHw+WpdGg4u/eB903JWTZpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZI9IsyntKzmug6HAN23+zTR/rie13Ebq9jWj2FjlDzb1zRHPB+8dyaAxki8F2OXAz
         7uNUfHUtvR76Kd5z66DzeKTaSsk/95te23vi+OSJrWJbtY0nppCv27ctUmbYbkGZXa
         S/yRWazv5xFTjWYjBjY1GBFThVm6i5AmEZJZunfxndpEjKRFkPiHsHoPtGByPHF9dK
         sdCDn+MXGSwvzooINXIoqELMTrO9FgnmfFLQqPx9MbdxXTi4xHY3kxv30tmqOEwr3k
         IjeZasQBw4h3uYewjoes25hyDncE+s7a6DLxBHbpq3jSdTRUwgBReibVxJmhGf2hj/
         qFfm3uZgUbqTA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: [net 03/14] net/mlx5: Fix setting ec_function bit in MANAGE_PAGES
Date:   Tue, 14 Mar 2023 10:49:29 -0700
Message-Id: <20230314174940.62221-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314174940.62221-1-saeed@kernel.org>
References: <20230314174940.62221-1-saeed@kernel.org>
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

From: Parav Pandit <parav@nvidia.com>

When ECPF is a page supplier, reclaim pages missed to honor the
ec_function bit provided by the firmware. It always used the ec_function
to true during driver unload flow for ECPF. This is incorrect.

Honor the ec_function bit provided by device during page allocation
request event.

Fixes: d6945242f45d ("net/mlx5: Hold pages RB tree per VF")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/pagealloc.c    | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 64d4e7125e9b..bd2712b2317d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -82,6 +82,16 @@ static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_funct
 	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
 }
 
+static u32 get_ec_function(u32 function)
+{
+	return function >> 16;
+}
+
+static u32 get_func_id(u32 function)
+{
+	return function & 0xffff;
+}
+
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
 {
 	struct rb_root *root;
@@ -665,7 +675,7 @@ static int optimal_reclaimed_pages(void)
 }
 
 static int mlx5_reclaim_root_pages(struct mlx5_core_dev *dev,
-				   struct rb_root *root, u16 func_id)
+				   struct rb_root *root, u32 function)
 {
 	u64 recl_pages_to_jiffies = msecs_to_jiffies(mlx5_tout_ms(dev, RECLAIM_PAGES));
 	unsigned long end = jiffies + recl_pages_to_jiffies;
@@ -674,11 +684,11 @@ static int mlx5_reclaim_root_pages(struct mlx5_core_dev *dev,
 		int nclaimed;
 		int err;
 
-		err = reclaim_pages(dev, func_id, optimal_reclaimed_pages(),
-				    &nclaimed, false, mlx5_core_is_ecpf(dev));
+		err = reclaim_pages(dev, get_func_id(function), optimal_reclaimed_pages(),
+				    &nclaimed, false, get_ec_function(function));
 		if (err) {
 			mlx5_core_warn(dev, "failed reclaiming pages (%d) for func id 0x%x\n",
-				       err, func_id);
+				       err, get_func_id(function));
 			return err;
 		}
 
-- 
2.39.2

