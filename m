Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2053368E665
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjBHDDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBHDDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:03:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2FA222E8
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:03:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75826B81BA5
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192ECC433EF;
        Wed,  8 Feb 2023 03:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675825391;
        bh=WEieYlMUVd7PbvPrG06qDITuzN8wc1+7QFAL39byYqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXpsUzKqrXtd1hhwdm+DvTgffV65+PtNRTd1GZVcBRc+p4UCwNM1RiNfVCn8ABsYE
         DV11tgals4Gd9OTbfIZV7Sj1T5KvAOOdDLPxrhh//z1oBOnuT1nUN8U2X0EG6P8Jv7
         ZiopDKQotHya1fVH8pic3PHrvuTLMTI6vtLrLV2q+TQ96SvC1iutaTwzg1VZ80CaSC
         ChmzI7vbBB/84Dy8r7zNOK2FOs+uphUye3KOVeQGPBqL6IbkSVsP+KnX+SjNT8uhHn
         K1UpLHjrCLUfziJG/78VcRaOoFcWKTxeoYXsy9uArZAwb4PbUj8RZWiAMU60Kio26g
         +WCOvArq28CFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net 02/10] net/mlx5: DR, Fix potential race in dr_rule_create_rule_nic
Date:   Tue,  7 Feb 2023 19:02:54 -0800
Message-Id: <20230208030302.95378-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208030302.95378-1-saeed@kernel.org>
References: <20230208030302.95378-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Selecting builder should be protected by the lock to prevent the case
where a new rule sets a builder in the nic_matcher while the previous
rule is still using the nic_matcher.

Fixing this issue and cleaning the error flow.

Fixes: b9b81e1e9382 ("net/mlx5: DR, For short chains of STEs, avoid allocating ste_arr dynamically")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     | 25 +++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index b851141e03de..042ca0349124 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -1138,12 +1138,14 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 			 rule->flow_source))
 		return 0;
 
+	mlx5dr_domain_nic_lock(nic_dmn);
+
 	ret = mlx5dr_matcher_select_builders(matcher,
 					     nic_matcher,
 					     dr_rule_get_ipv(&param->outer),
 					     dr_rule_get_ipv(&param->inner));
 	if (ret)
-		return ret;
+		goto err_unlock;
 
 	hw_ste_arr_is_opt = nic_matcher->num_of_builders <= DR_RULE_MAX_STES_OPTIMIZED;
 	if (likely(hw_ste_arr_is_opt)) {
@@ -1152,12 +1154,12 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 		hw_ste_arr = kzalloc((nic_matcher->num_of_builders + DR_ACTION_MAX_STES) *
 				     DR_STE_SIZE, GFP_KERNEL);
 
-		if (!hw_ste_arr)
-			return -ENOMEM;
+		if (!hw_ste_arr) {
+			ret = -ENOMEM;
+			goto err_unlock;
+		}
 	}
 
-	mlx5dr_domain_nic_lock(nic_dmn);
-
 	ret = mlx5dr_matcher_add_to_tbl_nic(dmn, nic_matcher);
 	if (ret)
 		goto free_hw_ste;
@@ -1223,7 +1225,10 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 
 	mlx5dr_domain_nic_unlock(nic_dmn);
 
-	goto out;
+	if (unlikely(!hw_ste_arr_is_opt))
+		kfree(hw_ste_arr);
+
+	return 0;
 
 free_rule:
 	dr_rule_clean_rule_members(rule, nic_rule);
@@ -1238,12 +1243,12 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 		mlx5dr_matcher_remove_from_tbl_nic(dmn, nic_matcher);
 
 free_hw_ste:
-	mlx5dr_domain_nic_unlock(nic_dmn);
-
-out:
-	if (unlikely(!hw_ste_arr_is_opt))
+	if (!hw_ste_arr_is_opt)
 		kfree(hw_ste_arr);
 
+err_unlock:
+	mlx5dr_domain_nic_unlock(nic_dmn);
+
 	return ret;
 }
 
-- 
2.39.1

