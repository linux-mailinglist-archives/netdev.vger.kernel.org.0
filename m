Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C279660FAF0
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbiJ0O5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235986AbiJ0O5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2A5C459D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CD2F62367
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B577C433C1;
        Thu, 27 Oct 2022 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882651;
        bh=1sSKnHJb/Y9la6H9yG4Ev8kq1D4Z1jBs5fqV+UZpM/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJ4EEf42+mD6IIocNh5wTmjeotWs2K27Xzei+0Yny7ot32RuS6FPSJPhq8lXIXKMt
         8bXwsS3yyQCx+2jiQtLKYAuU88M3St9YqCRnrhvwrtYTi1gfQhd80guBbOyTnu0ikR
         Hhx/0W6SyTlxbRMLFhFKDGgFBrmJ1WEOKYr8XVhWDQSOclHIYYiCtacY7WAK8eWa4A
         ILPYd4bGH0rXqNBJZI6XTMYzDZcZBZ3jnSDNqbxRCga45/mJq4LjiXtRxbBoapH+eS
         Jrea/NqtXitfJJl7Um4VpDAhL2YT6WnauYmHKGgSPxOH96lW76+8himU/apgq0lVfP
         Tm/sOeMdJEbig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 07/14] net/mlx5: DR, Handle domain memory resources init/uninit separately
Date:   Thu, 27 Oct 2022 15:56:36 +0100
Message-Id: <20221027145643.6618-8-saeed@kernel.org>
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

Handle creation/destruction of all the domain's memory pools and other
memory-related fields in a separate init/uninit functions.
This simplifies error flow and allows cleaner addition of new pools.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_domain.c   | 55 +++++++++++++------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index fc6ae49b5ecc..543d655ae3b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -56,6 +56,36 @@ int mlx5dr_domain_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
 	return 0;
 }
 
+static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
+{
+	int ret;
+
+	dmn->ste_icm_pool = mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_STE);
+	if (!dmn->ste_icm_pool) {
+		mlx5dr_err(dmn, "Couldn't get icm memory\n");
+		return -ENOMEM;
+	}
+
+	dmn->action_icm_pool = mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_MODIFY_ACTION);
+	if (!dmn->action_icm_pool) {
+		mlx5dr_err(dmn, "Couldn't get action icm memory\n");
+		ret = -ENOMEM;
+		goto free_ste_icm_pool;
+	}
+
+	return 0;
+
+free_ste_icm_pool:
+	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+	return ret;
+}
+
+static void dr_domain_uninit_mem_resources(struct mlx5dr_domain *dmn)
+{
+	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
+	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+}
+
 static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 {
 	int ret;
@@ -79,32 +109,22 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 		goto clean_pd;
 	}
 
-	dmn->ste_icm_pool = mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_STE);
-	if (!dmn->ste_icm_pool) {
-		mlx5dr_err(dmn, "Couldn't get icm memory\n");
-		ret = -ENOMEM;
+	ret = dr_domain_init_mem_resources(dmn);
+	if (ret) {
+		mlx5dr_err(dmn, "Couldn't create domain memory resources\n");
 		goto clean_uar;
 	}
 
-	dmn->action_icm_pool = mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_MODIFY_ACTION);
-	if (!dmn->action_icm_pool) {
-		mlx5dr_err(dmn, "Couldn't get action icm memory\n");
-		ret = -ENOMEM;
-		goto free_ste_icm_pool;
-	}
-
 	ret = mlx5dr_send_ring_alloc(dmn);
 	if (ret) {
 		mlx5dr_err(dmn, "Couldn't create send-ring\n");
-		goto free_action_icm_pool;
+		goto clean_mem_resources;
 	}
 
 	return 0;
 
-free_action_icm_pool:
-	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
-free_ste_icm_pool:
-	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+clean_mem_resources:
+	dr_domain_uninit_mem_resources(dmn);
 clean_uar:
 	mlx5_put_uars_page(dmn->mdev, dmn->uar);
 clean_pd:
@@ -116,8 +136,7 @@ static int dr_domain_init_resources(struct mlx5dr_domain *dmn)
 static void dr_domain_uninit_resources(struct mlx5dr_domain *dmn)
 {
 	mlx5dr_send_ring_free(dmn, dmn->send_ring);
-	mlx5dr_icm_pool_destroy(dmn->action_icm_pool);
-	mlx5dr_icm_pool_destroy(dmn->ste_icm_pool);
+	dr_domain_uninit_mem_resources(dmn);
 	mlx5_put_uars_page(dmn->mdev, dmn->uar);
 	mlx5_core_dealloc_pd(dmn->mdev, dmn->pdn);
 }
-- 
2.37.3

