Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9080B69B8E5
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 10:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjBRJFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 04:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjBRJF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 04:05:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50D0457D0
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 01:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D8FE60A71
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0DEC4339B;
        Sat, 18 Feb 2023 09:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676711126;
        bh=TpscqjVHTm0xIYqh3/pZKUU6CkgiJfJTyl4r0w6v1Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRBsFhwCqqG3hTuJVOS4D/6ngfqXQHgras4GazfdDzpUSUQvZxJzCY5V5pMfJ6anz
         vYZL2kJhm+1jXhEI4WlTwVSzEhCe76UVggf2eJkiUK04EeMCObQy4GRKFG6WUu9g3w
         6sR9ypcBwCUai/6lbonJnbERIk58znVcKlZelZ82ugKBQZGQwLXeNIFer93IuOJxbV
         7JpHdzPULTSP4tL5Q9/8YKhCo+uvaecieuUlzRQ+KObf+9mWd3dLkXEOd7wbjhN2lk
         tPk8xumwLrkEiFY+Eo5xM0aVEzc1WFKHaCoIJ82+Bq/BnWCEfgWNDIB7Vu3Mwm46GD
         r6Mjj2COKVnJw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [net-next V2 4/9] net/mlx5: Simplify eq list traversal
Date:   Sat, 18 Feb 2023 01:05:08 -0800
Message-Id: <20230218090513.284718-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230218090513.284718-1-saeed@kernel.org>
References: <20230218090513.284718-1-saeed@kernel.org>
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

EQ list is read only while finding the matching EQ.
Hence, avoid *_safe() version.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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

