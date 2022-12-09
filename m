Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DC8647A99
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLIAO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiLIAOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BF08D1BA
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DE8AB826B9
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264DFC43398;
        Fri,  9 Dec 2022 00:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544878;
        bh=llV0dPz7snSS27wu8zWXTqYoC34y5Nb7DBCFpdDPEGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUC+UIToV8J6hLcOCp8aSv3JVP+4XUMnlu4Melco7kNtxuNMUfVbjcu27CQ/LfBlK
         YOtRZ1h8MpJf0PTUBIt7I5d1KyQnnKX8DpPF8wNC6XDcJmUO5SRfjGobclRNIHEUQj
         wU2T8JOkpzLHEIsT97opzMw+Kzmccduy6tHU2G9aL6eaMuQgHlkX2/udV5pe1VByl3
         7qOgr27m2jTJO9sdy2ofFxda0Dyttl+wYeC6gQhKtfeQkk1ARWHN9KZb6D+EhwixDZ
         pn98YXwd5nZjIAc0IH4+Pva6UwnxMh245WJcDlYWEYxxR8Q5DWF3S6UEESYgoswe9t
         UlQyWx+RR339g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 07/15] net/mlx5: DR, Some refactoring of miss address handling
Date:   Thu,  8 Dec 2022 16:14:12 -0800
Message-Id: <20221209001420.142794-8-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
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

In preparation for MATCH RANGE STE support, create a function
to set the miss address of an STE.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_rule.c     | 24 +++++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index 7879991048ce..3351b2a1ba18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -35,16 +35,25 @@ static int dr_rule_append_to_miss_list(struct mlx5dr_domain *dmn,
 	return 0;
 }
 
+static void dr_rule_set_last_ste_miss_addr(struct mlx5dr_matcher *matcher,
+					   struct mlx5dr_matcher_rx_tx *nic_matcher,
+					   u8 *hw_ste)
+{
+	struct mlx5dr_ste_ctx *ste_ctx = matcher->tbl->dmn->ste_ctx;
+	u64 icm_addr;
+
+	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
+	mlx5dr_ste_set_miss_addr(ste_ctx, hw_ste, icm_addr);
+}
+
 static struct mlx5dr_ste *
 dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
 			      struct mlx5dr_matcher_rx_tx *nic_matcher,
 			      u8 *hw_ste)
 {
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
-	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_ste_htbl *new_htbl;
 	struct mlx5dr_ste *ste;
-	u64 icm_addr;
 
 	/* Create new table for miss entry */
 	new_htbl = mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
@@ -58,8 +67,7 @@ dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
 
 	/* One and only entry, never grows */
 	ste = new_htbl->chunk->ste_arr;
-	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
-	mlx5dr_ste_set_miss_addr(ste_ctx, hw_ste, icm_addr);
+	dr_rule_set_last_ste_miss_addr(matcher, nic_matcher, hw_ste);
 	mlx5dr_htbl_get(new_htbl);
 
 	return ste;
@@ -241,7 +249,6 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 	bool use_update_list = false;
 	u8 hw_ste[DR_STE_SIZE] = {};
 	struct mlx5dr_ste *new_ste;
-	u64 icm_addr;
 	int new_idx;
 	u8 sb_idx;
 
@@ -250,9 +257,8 @@ dr_rule_rehash_copy_ste(struct mlx5dr_matcher *matcher,
 	mlx5dr_ste_set_bit_mask(hw_ste, nic_matcher->ste_builder[sb_idx].bit_mask);
 
 	/* Copy STE control and tag */
-	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
 	memcpy(hw_ste, mlx5dr_ste_get_hw_ste(cur_ste), DR_STE_SIZE_REDUCED);
-	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste, icm_addr);
+	dr_rule_set_last_ste_miss_addr(matcher, nic_matcher, hw_ste);
 
 	new_idx = mlx5dr_ste_calc_hash_index(hw_ste, new_htbl);
 	new_ste = &new_htbl->chunk->ste_arr[new_idx];
@@ -773,7 +779,6 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 {
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_ste_send_info *ste_info;
-	u64 icm_addr;
 
 	/* Take ref on table, only on first time this ste is used */
 	mlx5dr_htbl_get(cur_htbl);
@@ -781,8 +786,7 @@ static int dr_rule_handle_empty_entry(struct mlx5dr_matcher *matcher,
 	/* new entry -> new branch */
 	list_add_tail(&ste->miss_list_node, miss_list);
 
-	icm_addr = mlx5dr_icm_pool_get_chunk_icm_addr(nic_matcher->e_anchor->chunk);
-	mlx5dr_ste_set_miss_addr(dmn->ste_ctx, hw_ste, icm_addr);
+	dr_rule_set_last_ste_miss_addr(matcher, nic_matcher, hw_ste);
 
 	ste->ste_chain_location = ste_location;
 
-- 
2.38.1

