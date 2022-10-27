Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1765060FAEE
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbiJ0O5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235719AbiJ0O51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E6FD8F7E
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04391B8267B
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47616C4347C;
        Thu, 27 Oct 2022 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882643;
        bh=PAlp8f8afcdooKce2v1rUiB1e+ucDf9LXyzMFajWHeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDkxzV77u/79kZBgS423GywJHvQgisp52U0CIMrgQQsApIR7HLBCg9znj1j5FGvNk
         B/29/HwiwWjjwismQBCds9ydiGrUNNDx8KhER8k4mz5LL+xPxS5Qv7wrbF8FeMUn+t
         bZX9JFnqCCoJzdigLgG0EFcjoYbIHKkVot5RXE2qQVGl6xBaMSuZ+3Ie+zb3iTTBLp
         VOIDj+7dNOcCXIGwcR94LEM32f0C4xBTxaJsBnRu07AyIsyLPWsO3odUUvzVtWj2M0
         RfwXgFQ9CVYBqCrWauXN7/Vcsfw24cWDVD1zXEJFhKnYaHEsWiZd8vnmgTZLRZHSpe
         w+4vgVGjwaa2Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 05/14] net/mlx5: DR, For short chains of STEs, avoid allocating ste_arr dynamically
Date:   Thu, 27 Oct 2022 15:56:34 +0100
Message-Id: <20221027145643.6618-6-saeed@kernel.org>
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

While creating rule, ste_arr is an array that is allocated at the start
of the function and freed at the end.
This memory allocation can sometimes lead to "hiccups" of up to 10ms.
However, the common use case is short chains of STEs. For such cases,
we can use a local buffer on stack instead.

Changes in v2:
  Use small local array for short rules, allocate dynamically for long rules

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     | 40 +++++++++++++------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index ddfaf7891188..6cbc444ad791 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -3,7 +3,8 @@
 
 #include "dr_types.h"
 
-#define DR_RULE_MAX_STE_CHAIN (DR_RULE_MAX_STES + DR_ACTION_MAX_STES)
+#define DR_RULE_MAX_STES_OPTIMIZED 5
+#define DR_RULE_MAX_STE_CHAIN_OPTIMIZED (DR_RULE_MAX_STES_OPTIMIZED + DR_ACTION_MAX_STES)
 
 static int dr_rule_append_to_miss_list(struct mlx5dr_ste_ctx *ste_ctx,
 				       struct mlx5dr_ste *new_last_ste,
@@ -1089,6 +1090,7 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 			size_t num_actions,
 			struct mlx5dr_action *actions[])
 {
+	u8 hw_ste_arr_optimized[DR_RULE_MAX_STE_CHAIN_OPTIMIZED * DR_STE_SIZE] = {};
 	struct mlx5dr_ste_send_info *ste_info, *tmp_ste_info;
 	struct mlx5dr_matcher *matcher = rule->matcher;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
@@ -1098,6 +1100,7 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	struct mlx5dr_ste_htbl *cur_htbl;
 	struct mlx5dr_ste *ste = NULL;
 	LIST_HEAD(send_ste_list);
+	bool hw_ste_arr_is_opt;
 	u8 *hw_ste_arr = NULL;
 	u32 new_hw_ste_arr_sz;
 	int ret, i;
@@ -1109,9 +1112,23 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 			 rule->flow_source))
 		return 0;
 
-	hw_ste_arr = kzalloc(DR_RULE_MAX_STE_CHAIN * DR_STE_SIZE, GFP_KERNEL);
-	if (!hw_ste_arr)
-		return -ENOMEM;
+	ret = mlx5dr_matcher_select_builders(matcher,
+					     nic_matcher,
+					     dr_rule_get_ipv(&param->outer),
+					     dr_rule_get_ipv(&param->inner));
+	if (ret)
+		return ret;
+
+	hw_ste_arr_is_opt = nic_matcher->num_of_builders <= DR_RULE_MAX_STES_OPTIMIZED;
+	if (likely(hw_ste_arr_is_opt)) {
+		hw_ste_arr = hw_ste_arr_optimized;
+	} else {
+		hw_ste_arr = kzalloc((nic_matcher->num_of_builders + DR_ACTION_MAX_STES) *
+				     DR_STE_SIZE, GFP_KERNEL);
+
+		if (!hw_ste_arr)
+			return -ENOMEM;
+	}
 
 	mlx5dr_domain_nic_lock(nic_dmn);
 
@@ -1119,13 +1136,6 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	if (ret)
 		goto free_hw_ste;
 
-	ret = mlx5dr_matcher_select_builders(matcher,
-					     nic_matcher,
-					     dr_rule_get_ipv(&param->outer),
-					     dr_rule_get_ipv(&param->inner));
-	if (ret)
-		goto remove_from_nic_tbl;
-
 	/* Set the tag values inside the ste array */
 	ret = mlx5dr_ste_build_ste_arr(matcher, nic_matcher, param, hw_ste_arr);
 	if (ret)
@@ -1187,7 +1197,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 	mlx5dr_domain_nic_unlock(nic_dmn);
 
-	kfree(hw_ste_arr);
+	if (unlikely(!hw_ste_arr_is_opt))
+		kfree(hw_ste_arr);
 
 	return 0;
 
@@ -1204,7 +1215,10 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 free_hw_ste:
 	mlx5dr_domain_nic_unlock(nic_dmn);
-	kfree(hw_ste_arr);
+
+	if (unlikely(!hw_ste_arr_is_opt))
+		kfree(hw_ste_arr);
+
 	return ret;
 }
 
-- 
2.37.3

