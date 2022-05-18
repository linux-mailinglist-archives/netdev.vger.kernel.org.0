Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75A852B2AD
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiERGt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbiERGtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:49:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24522228A
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7359C60B8C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9345C385A5;
        Wed, 18 May 2022 06:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856587;
        bh=tapj29CQ1/xfrfaxd3hwtC1iFjuTc61DoIrWaBhaMUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5+f4Zf07Xl4ycUes0EvksKNQBLjNIk5eN268IfXnjgw3MjNuKy9CVoAH10U/I431
         adtVgylc9zx2xO7McYNxkTfr4pm/l9QXtnbGMw5xrADpKZVeAt1jgsh5/uu6VbW55o
         5D4mq9zvkJUTmal+UGAQvMG+bzCetmvJAYsE2rMoPIWvjzqPhIlP/lpDncaLyeE2LE
         UsgaVTuez9dhewmLRMggRYqRs2kN9MZfVaA1S5zpy/1UswHGSKmo1St9oUdfVnLi5o
         n3WY0kZ/iWFPl6nn/JuXjeNH/A/ZhdfrVevwykD+UGrKE9aRkUeor3mLAF1Cw2tCy6
         46McWqVx8gfrQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/16] net/mlx5: Allocate virtually contiguous memory in pci_irq.c
Date:   Tue, 17 May 2022 23:49:27 -0700
Message-Id: <20220518064938.128220-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Physical continuity is not necessary, and requested allocation size might
be larger than PAGE_SIZE.
Hence, use v-alloc/free API.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index db77f1d2eeb4..662f1d55e30e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -94,8 +94,8 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 	if (msix_vec_count > max_msix)
 		return -EOVERFLOW;
 
-	query_cap = kzalloc(query_sz, GFP_KERNEL);
-	hca_cap = kzalloc(set_sz, GFP_KERNEL);
+	query_cap = kvzalloc(query_sz, GFP_KERNEL);
+	hca_cap = kvzalloc(set_sz, GFP_KERNEL);
 	if (!hca_cap || !query_cap) {
 		ret = -ENOMEM;
 		goto out;
@@ -118,8 +118,8 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 		 MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1);
 	ret = mlx5_cmd_exec_in(dev, set_hca_cap, hca_cap);
 out:
-	kfree(hca_cap);
-	kfree(query_cap);
+	kvfree(hca_cap);
+	kvfree(query_cap);
 	return ret;
 }
 
-- 
2.36.1

