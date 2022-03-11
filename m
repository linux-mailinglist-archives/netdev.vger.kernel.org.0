Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BD14D5C95
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346798AbiCKHly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346912AbiCKHlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9992F1B757D
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FAE1B82AE4
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766AFC340F4;
        Fri, 11 Mar 2022 07:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984444;
        bh=6Xqra2wPH/TWNZY2JRYdQ5M4iBblPcy3vnxR+0kJ0cg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBXRuchyj5lr548CSEivuualLC++2KZWk6UAiNLvma60xTRPWZdw3Yd7HfJf2P/fo
         2OlJciN1JXJsluAheTPII5awQnj5HXab7QxjUnmjPdR/mVHWw4s4hiG1Ik6MIaud0J
         KHF1BWYaaqe/0fDuMoPkgBjRdrlYKKr+vZs6cr2e6YLo5lTCwksa8dPyypWtPHrz8i
         rRZgN2qgMBDA6YQH5ltc/NQ29BnJ+0BccjGY+rj54/FT1nyu2rSKdYhh3PWSlWmO5F
         dY2dYsTx9imK2WxmxRnwEC1DXqMdewMUYy7zAL52M3aFon2tzUUTNRfQ/QtgOZxQz9
         Xrmj72vdPv4eg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Node-aware allocation for the doorbell pgdir
Date:   Thu, 10 Mar 2022 23:40:23 -0800
Message-Id: <20220311074031.645168-8-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

The function is node-aware and gets the node as an argument.
Use a node-aware allocation for the doorbell pgdir structure.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index 291e427e9e4f..d5408f6ce5a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -183,11 +183,11 @@ static struct mlx5_db_pgdir *mlx5_alloc_db_pgdir(struct mlx5_core_dev *dev,
 	u32 db_per_page = PAGE_SIZE / cache_line_size();
 	struct mlx5_db_pgdir *pgdir;
 
-	pgdir = kzalloc(sizeof(*pgdir), GFP_KERNEL);
+	pgdir = kzalloc_node(sizeof(*pgdir), GFP_KERNEL, node);
 	if (!pgdir)
 		return NULL;
 
-	pgdir->bitmap = bitmap_zalloc(db_per_page, GFP_KERNEL);
+	pgdir->bitmap = bitmap_zalloc_node(db_per_page, GFP_KERNEL, node);
 	if (!pgdir->bitmap) {
 		kfree(pgdir);
 		return NULL;
-- 
2.35.1

