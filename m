Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1609060B198
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiJXQ2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbiJXQ1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:27:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0471F167FA
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:14:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 322816135F
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D82C433D7;
        Mon, 24 Oct 2022 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666620028;
        bh=s/aJYptzcdOX2k3977wmknI4CbCWdi9CHT2wA/mmowM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jWhylzcAYVmakfoXTNSInnK+NYWaZG+Os0no3eVXz6By1r/+lbSn5r2FoPlp1m/Ua
         C7mYLLlAqXN5F+ej1YrtBNbARHYEj7SSgve7Or19PbsQbK3TmvJSVkQPQhy5fcKtfD
         xcE1/+JQu3JFiv2cQo3GNMltRRrYWZ2ZJnAEGqQQFq6IhzucpPmhc+6yQX9Pz6nTEP
         v/uxRRBf6m1TQzDJAqxZ8JWyPHNRdd5kFT+y5PjC3X1T2OPVkAzmSGfwLgHIvKBYou
         pMoj0ULkq61VObvNa3cWKToYnB7os9tTf+wGXNdEfrFGdkJextmlGQVZ52I4/Sa29c
         NFUJkN/8yoEQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 05/14] net/mlx5: DR, Allocate ste_arr on stack instead of dynamically
Date:   Mon, 24 Oct 2022 14:57:25 +0100
Message-Id: <20221024135734.69673-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024135734.69673-1-saeed@kernel.org>
References: <20221024135734.69673-1-saeed@kernel.org>
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

While creting rule, ste_arr is a short array that is allocated in
the beginning of the function and freed at the end.
To avoid memory allocation "hiccups" that sometimes take up to 10ms,
allocate it on stack.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_rule.c   | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index ddfaf7891188..cd90f0a02434 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -1089,6 +1089,7 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 			size_t num_actions,
 			struct mlx5dr_action *actions[])
 {
+	u8 hw_ste_arr[DR_RULE_MAX_STE_CHAIN * DR_STE_SIZE] = {};
 	struct mlx5dr_ste_send_info *ste_info, *tmp_ste_info;
 	struct mlx5dr_matcher *matcher = rule->matcher;
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
@@ -1098,7 +1099,6 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	struct mlx5dr_ste_htbl *cur_htbl;
 	struct mlx5dr_ste *ste = NULL;
 	LIST_HEAD(send_ste_list);
-	u8 *hw_ste_arr = NULL;
 	u32 new_hw_ste_arr_sz;
 	int ret, i;
 
@@ -1109,10 +1109,6 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 			 rule->flow_source))
 		return 0;
 
-	hw_ste_arr = kzalloc(DR_RULE_MAX_STE_CHAIN * DR_STE_SIZE, GFP_KERNEL);
-	if (!hw_ste_arr)
-		return -ENOMEM;
-
 	mlx5dr_domain_nic_lock(nic_dmn);
 
 	ret = mlx5dr_matcher_add_to_tbl_nic(dmn, nic_matcher);
@@ -1187,8 +1183,6 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 	mlx5dr_domain_nic_unlock(nic_dmn);
 
-	kfree(hw_ste_arr);
-
 	return 0;
 
 free_rule:
@@ -1204,7 +1198,6 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 free_hw_ste:
 	mlx5dr_domain_nic_unlock(nic_dmn);
-	kfree(hw_ste_arr);
 	return ret;
 }
 
-- 
2.37.3

