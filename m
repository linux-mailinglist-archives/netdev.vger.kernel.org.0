Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B664068E667
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjBHDD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:03:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjBHDDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:03:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7683E62B
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DE66B81BC5
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BDEC433EF;
        Wed,  8 Feb 2023 03:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675825396;
        bh=u7tjKW7iN4gYMQhLmRcnW6BP9HwrEh8bdIjMVy+CxY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMJ6VzR3BOcI31JiNzJVj42Mf15kmPmBUNDHbLr1BNCYzA4YxzTEHfiK0W/y7tRD8
         cjVndakdr3WsBBoEb3oONCZhqXiJe4Fe2khSzBTnXqnjRDVslixQvqOzsVs8VEGJSN
         Kr/Er0FOGustwNMW/bzS6/5GlKqPGIMolTs0Yc8XlaCW4q2ZEGjtFpwvYF6cH1vKek
         +pGQIsa5lPF7qKiU7vng5frvav0zI1W99RXwHQ1J+saE2YTYQYIUsjusqfSA0tZyLt
         t+08CnEFKkMjg+H4DL+l/mrGXPWNK0mJQ9ebw9m+PSHPq2O41aeQVWwq/G61fyU/9d
         mmzAKcjwDbhdg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [net 07/10] net/mlx5: Expose SF firmware pages counter
Date:   Tue,  7 Feb 2023 19:02:59 -0800
Message-Id: <20230208030302.95378-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208030302.95378-1-saeed@kernel.org>
References: <20230208030302.95378-1-saeed@kernel.org>
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

From: Maher Sanalla <msanalla@nvidia.com>

Currently, each core device has VF pages counter which stores number of
fw pages used by its VFs and SFs.

The current design led to a hang when performing firmware reset on DPU,
where the DPU PFs stalled in sriov unload flow due to waiting on release
of SFs pages instead of waiting on only VFs pages.

Thus, Add a separate counter for SF firmware pages, which will prevent
the stall scenario described above.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 2 +-
 include/linux/mlx5/driver.h                         | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index c3e7c24a0971..bb95b40d25eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -246,6 +246,7 @@ void mlx5_pages_debugfs_init(struct mlx5_core_dev *dev)
 
 	debugfs_create_u32("fw_pages_total", 0400, pages, &dev->priv.fw_pages);
 	debugfs_create_u32("fw_pages_vfs", 0400, pages, &dev->priv.page_counters[MLX5_VF]);
+	debugfs_create_u32("fw_pages_sfs", 0400, pages, &dev->priv.page_counters[MLX5_SF]);
 	debugfs_create_u32("fw_pages_host_pf", 0400, pages, &dev->priv.page_counters[MLX5_HOST_PF]);
 	debugfs_create_u32("fw_pages_alloc_failed", 0400, pages, &dev->priv.fw_pages_alloc_failed);
 	debugfs_create_u32("fw_pages_give_dropped", 0400, pages, &dev->priv.give_pages_dropped);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 9f99292ab5ce..0eb50be175cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -79,7 +79,7 @@ static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_funct
 	if (!func_id)
 		return mlx5_core_is_ecpf(dev) && !ec_function ? MLX5_HOST_PF : MLX5_PF;
 
-	return MLX5_VF;
+	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
 }
 
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 82a9bd4274b8..333c1fec72f8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -576,6 +576,7 @@ struct mlx5_debugfs_entries {
 enum mlx5_func_type {
 	MLX5_PF,
 	MLX5_VF,
+	MLX5_SF,
 	MLX5_HOST_PF,
 	MLX5_FUNC_TYPE_NUM,
 };
-- 
2.39.1

