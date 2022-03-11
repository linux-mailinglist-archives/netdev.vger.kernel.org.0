Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465554D5C90
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245286AbiCKHlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242144AbiCKHlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9811B756C
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86F4D61E01
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C88C340F6;
        Fri, 11 Mar 2022 07:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984442;
        bh=iQ6awQqLrxrQiMjacfdTWr7yPApj/idTeEcO3vSfIRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCu2TYEYEIHNjxW+cG0DDKvneDP5aXjuhF90eJkYr11xZrUBeUjkwTvA711YB+yTJ
         T1Lwml0cU7y5x1FwHHi4ZVMYLMMmtdKsZpRBcVJ/AnWYBz8tG+Ta9OtRxu6wHGBtnx
         t5XGLaks6e4xmgazAXx/bdHcud+kIqvZRWsmH9wV6ghzn8ktc05Lq/ymCCz4bkftMY
         rHaRXUfz3l/e36nZXme6h1rFbx7dvL3z6SpvI4SQcY34hmvbRGZZwg7WhsExJdutG3
         j/0HKOKKeIM7KaPMMg2nBJaRhbxK8mEM6M4duZLzXCq8oUmkt9dbbVHFhBdsGWPn7Y
         KUoJB1SVYw1YQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Node-aware allocation for the IRQ table
Date:   Thu, 10 Mar 2022 23:40:19 -0800
Message-Id: <20220311074031.645168-4-saeed@kernel.org>
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
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 351ea0a41a03..db77f1d2eeb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -600,7 +600,8 @@ int mlx5_irq_table_init(struct mlx5_core_dev *dev)
 	if (mlx5_core_is_sf(dev))
 		return 0;
 
-	irq_table = kvzalloc(sizeof(*irq_table), GFP_KERNEL);
+	irq_table = kvzalloc_node(sizeof(*irq_table), GFP_KERNEL,
+				  dev->priv.numa_node);
 	if (!irq_table)
 		return -ENOMEM;
 
-- 
2.35.1

