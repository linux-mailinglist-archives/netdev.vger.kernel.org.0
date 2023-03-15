Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E416BC04A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbjCOW7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjCOW64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:58:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0A980E01
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CEC3B81F98
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D732EC4339B;
        Wed, 15 Mar 2023 22:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921131;
        bh=7JyGO28J7Vk9t73YoOSjSsg36uHPEAZiz+NioNRiafo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhx4rqguTm4qJdsOaSOkEvNnYXP5QcnBWPYSkC6W7vem/3x1tcOswTJKWUyF0otce
         3asWJl/Sq4V1JOBfhpb2A7T8ZufifPisVzfIdvyFE1k20//qiSCQo7h3h9b+OSZRiM
         f1uHI94UCESvdpBYw2SjEiN7IZOXv/xxOAeOycF9ySivILjUPjR5r85qPxPrP8poCO
         gvcWhNxYYuceRp6S0c1gIHA2FTQ40uyRMDvHn204SfIC7kOciqLHPihOAvQRZFEGu/
         YIaWJjmwVA7PxZ0HSf91cXEgKNodwaVzMlf2FyD/wOxk0qNIodhvW6mfSqQZxlpTOp
         8AkRItAEC0Ytw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: [net V2 03/14] net/mlx5: Fix setting ec_function bit in MANAGE_PAGES
Date:   Wed, 15 Mar 2023 15:58:36 -0700
Message-Id: <20230315225847.360083-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315225847.360083-1-saeed@kernel.org>
References: <20230315225847.360083-1-saeed@kernel.org>
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
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 64d4e7125e9b..95dc67fb3001 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -82,6 +82,16 @@ static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_funct
 	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
 }
 
+static u32 mlx5_get_ec_function(u32 function)
+{
+	return function >> 16;
+}
+
+static u32 mlx5_get_func_id(u32 function)
+{
+	return function & 0xffff;
+}
+
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
 {
 	struct rb_root *root;
@@ -665,20 +675,22 @@ static int optimal_reclaimed_pages(void)
 }
 
 static int mlx5_reclaim_root_pages(struct mlx5_core_dev *dev,
-				   struct rb_root *root, u16 func_id)
+				   struct rb_root *root, u32 function)
 {
 	u64 recl_pages_to_jiffies = msecs_to_jiffies(mlx5_tout_ms(dev, RECLAIM_PAGES));
 	unsigned long end = jiffies + recl_pages_to_jiffies;
 
 	while (!RB_EMPTY_ROOT(root)) {
+		u32 ec_function = mlx5_get_ec_function(function);
+		u32 function_id = mlx5_get_func_id(function);
 		int nclaimed;
 		int err;
 
-		err = reclaim_pages(dev, func_id, optimal_reclaimed_pages(),
-				    &nclaimed, false, mlx5_core_is_ecpf(dev));
+		err = reclaim_pages(dev, function_id, optimal_reclaimed_pages(),
+				    &nclaimed, false, ec_function);
 		if (err) {
-			mlx5_core_warn(dev, "failed reclaiming pages (%d) for func id 0x%x\n",
-				       err, func_id);
+			mlx5_core_warn(dev, "reclaim_pages err (%d) func_id=0x%x ec_func=0x%x\n",
+				       err, function_id, ec_function);
 			return err;
 		}
 
-- 
2.39.2

