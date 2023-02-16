Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4177769891C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBPAJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBPAJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:09:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7222338EA8
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:09:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3297AB824B1
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB24C433A7;
        Thu, 16 Feb 2023 00:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676506164;
        bh=OqSKuD0r+LF6QrGUAbK2G9hVbfXiWjtigeB0AeWIIaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EL8M4GeNCLhTenQD1VVjJddNyOrL8FIgrZS1YakJDXl9N15MeVyc9NvtpqzpapWEl
         jTP5pFLgw1hOCNK/wgA9AlPmOMXEhdO1eLMiznrhOQt2+LcDnMQeD8BPvQsSIDzXCH
         8+CD0v8VIfB+tuh4DQFpnlgfKFGKfw5sc+wJ/IxEZaelWUXRjO5MZZam4CJZIhLcCs
         HrZOEjFMyXt+lH7YgfYl8E7kT3szRVfzcjXyJMgnvaG2aD5Mi/W/jypQMpxUVL0qgY
         KL6XcdrhaPfo5ZEWuxv6KQiZ3M+4TkzOcgbXAJYArzu/ZYwYO7K6y6MoG76d2o6lWt
         KrSPs1zGHIbdg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: [net-next 4/9] net/mlx5: Simplify eq list traversal
Date:   Wed, 15 Feb 2023 16:09:13 -0800
Message-Id: <20230216000918.235103-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216000918.235103-1-saeed@kernel.org>
References: <20230216000918.235103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

EQ list is read only while finding the matching EQ.
Hence, avoid *_safe() version.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 66ec7932f008..38b32e98f3bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -960,11 +960,11 @@ static int vector2eqnirqn(struct mlx5_core_dev *dev, int vector, int *eqn,
 			  unsigned int *irqn)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	struct mlx5_eq_comp *eq, *n;
+	struct mlx5_eq_comp *eq;
 	int err = -ENOENT;
 	int i = 0;
 
-	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
+	list_for_each_entry(eq, &table->comp_eqs_list, list) {
 		if (i++ == vector) {
 			if (irqn)
 				*irqn = eq->core.irqn;
@@ -999,10 +999,10 @@ struct cpumask *
 mlx5_comp_irq_get_affinity_mask(struct mlx5_core_dev *dev, int vector)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
-	struct mlx5_eq_comp *eq, *n;
+	struct mlx5_eq_comp *eq;
 	int i = 0;
 
-	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
+	list_for_each_entry(eq, &table->comp_eqs_list, list) {
 		if (i++ == vector)
 			break;
 	}
-- 
2.39.1

