Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755756EA118
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjDUBjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbjDUBjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208C13C38
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8D0C642F7
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89575C433EF;
        Fri, 21 Apr 2023 01:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041155;
        bh=Mv9E/1L/Pt3sjm/Ya+iv1X5REHba8Ekm7UtaRqvJ3Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W14gfZfziHlT6wjBDEFk1W5ftbQESW5IQ1YT5jSi03xiilSZzdlPG9fctudekd2SW
         ThRjjlJqYqAEW3jvIpfQ4NfH88DXLx9eH9Nf3hQy+B2Lf1lDYUHmm/suZyiG9DfGlY
         DC90SYjrvBFz/YH5rQ8Vod7/rWD43xExGNvuayo+yNvD0a3a6wJ3W8arlcSHei6w/o
         R6EAnKIHcf6E457Yjv9x9yBq2Tcw20sazCGWOKqV6FubAZK5WMs0X6tWYECJ7Nengr
         Nz1f0welDl31Q8BPaBkxsrMToeIO5Bw7wa7iPFMFd/UMn4AU9BogqGiivPAvFtN9q/
         bAEXWceUoV71A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 04/15] net/mlx5: DR, Add memory statistics for domain object
Date:   Thu, 20 Apr 2023 18:38:39 -0700
Message-Id: <20230421013850.349646-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add counters for number of buddies that are currently in use per domain
per buddy type (STE, MODIFY-HEADER, MODIFY-PATTERN).

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c | 7 +++++--
 .../ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c    | 8 +++++++-
 .../net/ethernet/mellanox/mlx5/core/steering/dr_types.h   | 3 +++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index 552c7857ca1f..7e36e1062139 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -633,7 +633,7 @@ dr_dump_domain(struct seq_file *file, struct mlx5dr_domain *dmn)
 	u64 domain_id = DR_DBG_PTR_TO_ID(dmn);
 	int ret;
 
-	seq_printf(file, "%d,0x%llx,%d,0%x,%d,%u.%u.%u,%s,%d\n",
+	seq_printf(file, "%d,0x%llx,%d,0%x,%d,%u.%u.%u,%s,%d,%u,%u,%u\n",
 		   DR_DUMP_REC_TYPE_DOMAIN,
 		   domain_id, dmn->type, dmn->info.caps.gvmi,
 		   dmn->info.supp_sw_steering,
@@ -641,7 +641,10 @@ dr_dump_domain(struct seq_file *file, struct mlx5dr_domain *dmn)
 		   LINUX_VERSION_MAJOR, LINUX_VERSION_PATCHLEVEL,
 		   LINUX_VERSION_SUBLEVEL,
 		   pci_name(dmn->mdev->pdev),
-		   0); /* domain flags */
+		   0, /* domain flags */
+		   dmn->num_buddies[DR_ICM_TYPE_STE],
+		   dmn->num_buddies[DR_ICM_TYPE_MODIFY_ACTION],
+		   dmn->num_buddies[DR_ICM_TYPE_MODIFY_HDR_PTRN]);
 
 	ret = dr_dump_domain_info(file, &dmn->info, domain_id);
 	if (ret < 0)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index 19e9b4d78454..0b5af9f3f605 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -288,6 +288,8 @@ static int dr_icm_buddy_create(struct mlx5dr_icm_pool *pool)
 	/* add it to the -start- of the list in order to search in it first */
 	list_add(&buddy->list_node, &pool->buddy_mem_list);
 
+	pool->dmn->num_buddies[pool->icm_type]++;
+
 	return 0;
 
 err_cleanup_buddy:
@@ -301,13 +303,17 @@ static int dr_icm_buddy_create(struct mlx5dr_icm_pool *pool)
 
 static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 {
+	enum mlx5dr_icm_type icm_type = buddy->pool->icm_type;
+
 	dr_icm_pool_mr_destroy(buddy->icm_mr);
 
 	mlx5dr_buddy_cleanup(buddy);
 
-	if (buddy->pool->icm_type == DR_ICM_TYPE_STE)
+	if (icm_type == DR_ICM_TYPE_STE)
 		dr_icm_buddy_cleanup_ste_cache(buddy);
 
+	buddy->pool->dmn->num_buddies[icm_type]--;
+
 	kvfree(buddy);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 37b7b1a79f93..678a993ab053 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -72,6 +72,7 @@ enum mlx5dr_icm_type {
 	DR_ICM_TYPE_STE,
 	DR_ICM_TYPE_MODIFY_ACTION,
 	DR_ICM_TYPE_MODIFY_HDR_PTRN,
+	DR_ICM_TYPE_MAX,
 };
 
 static inline enum mlx5dr_icm_chunk_size
@@ -955,6 +956,8 @@ struct mlx5dr_domain {
 	struct list_head dbg_tbl_list;
 	struct mlx5dr_dbg_dump_info dump_info;
 	struct xarray definers_xa;
+	/* memory management statistics */
+	u32 num_buddies[DR_ICM_TYPE_MAX];
 };
 
 struct mlx5dr_table_rx_tx {
-- 
2.39.2

