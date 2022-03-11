Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A744D5C9D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347252AbiCKHlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343932AbiCKHlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A471B756E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3AA161DCB
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31EDC36AE3;
        Fri, 11 Mar 2022 07:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984444;
        bh=eEWNp2AcKPf8e7Qe6okmHSv005/bMPQvxQg6yjvfh7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mePKgXjlAcqnX+Gkf+p3OEavuE4goSEMNHeB6TXEn8+ScRchO6boU5MQl/TUKgVzd
         p/BJlkfWiGaAev5ax+KHFGMbx8VkKywvJAIUAW8gUUQLsaNDTtRCv9dVIj3sZiNHdk
         2iZE547pD7rmBfmiG8YStSgcRif1PyKWCPaDX6wL7B19W8G/I6NV16+KAfpiyzofBr
         nXAGVtQG2tb2836Nm4uFkZ+3vDL3gdZntBWtaTL5G4kEwhaHti5MvFhVMkAftv4JRM
         knn7DKYUanW1CwAW+NPTgX+O1fKfBP3NTSWVV0lQ58v/+9CxO2YbFZ7S14WHEcTB7L
         TNkYja6WNKSOg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Node-aware allocation for UAR
Date:   Thu, 10 Mar 2022 23:40:22 -0800
Message-Id: <20220311074031.645168-7-saeed@kernel.org>
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

Prefer the aware allocation, use the device NUMA node.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/uar.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/uar.c b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
index 9c81fb7c2c3c..8455e79bc44a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/uar.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
@@ -99,19 +99,21 @@ static struct mlx5_uars_page *alloc_uars_page(struct mlx5_core_dev *mdev,
 	int err = -ENOMEM;
 	phys_addr_t pfn;
 	int bfregs;
+	int node;
 	int i;
 
 	bfregs = uars_per_sys_page(mdev) * MLX5_BFREGS_PER_UAR;
-	up = kzalloc(sizeof(*up), GFP_KERNEL);
+	node = mdev->priv.numa_node;
+	up = kzalloc_node(sizeof(*up), GFP_KERNEL, node);
 	if (!up)
 		return ERR_PTR(err);
 
 	up->mdev = mdev;
-	up->reg_bitmap = bitmap_zalloc(bfregs, GFP_KERNEL);
+	up->reg_bitmap = bitmap_zalloc_node(bfregs, GFP_KERNEL, node);
 	if (!up->reg_bitmap)
 		goto error1;
 
-	up->fp_bitmap = bitmap_zalloc(bfregs, GFP_KERNEL);
+	up->fp_bitmap = bitmap_zalloc_node(bfregs, GFP_KERNEL, node);
 	if (!up->fp_bitmap)
 		goto error1;
 
-- 
2.35.1

