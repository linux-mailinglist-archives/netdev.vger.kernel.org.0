Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7429D58473C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiG1UrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbiG1UrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:47:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345DC6BD50
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7044615C4
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0195EC433B5;
        Thu, 28 Jul 2022 20:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041219;
        bh=AOJ7+j2UVnqqZjbSqPDCJFdqIkXQMH0SIGU6//SdM20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZzgo1PUmrvdISsAIdgbJgZd0Io31Rr7kleEqFkEur6G7X/cRMa7DHyhY6/NvOUT/
         3mlhFr3UTOVygjbmKwEA7F9gkicyZ5U2LSZI48frao4k5/TVxbqHvQQBmVB/EapgNR
         Vq4otR3n4djLqLIBRKRihEss26fSJLki98BChn83zD63KjdsIVKtvCeE10j9Hb/KTj
         lYa3v9KPL9xzig4VIFwH3KDTi2NXggiwwJeBx2CLH9PcGJJKzPt6QCAPuVBYkbPCnb
         xIVuFlWjw99em87x2hqTMCB8kMNGn85Y0ZasHQG96HX4SCgh1lq0e9890BuCseSwij
         3siB03TwOqcnw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net 8/9] net/mlx5: DR, Fix SMFS steering info dump format
Date:   Thu, 28 Jul 2022 13:46:39 -0700
Message-Id: <20220728204640.139990-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220728204640.139990-1-saeed@kernel.org>
References: <20220728204640.139990-1-saeed@kernel.org>
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

Fix several issues in SMFS steering info dump:
 - Fix outdated macro value for matcher mask in the SMFS debug dump format.
   The existing value denotes the old format of the matcher mask, as it was
   used during the early stages of development, and it results in wrong
   parsing by the steering dump parser - wrong fields are shown in the
   parsed output.
 - Add the missing destination table to the dumped action.
   The missing dest table handle breaks the ability to associate between
   the "go to table" action and the actual table in the steering info.

Fixes: 9222f0b27da2 ("net/mlx5: DR, Add support for dumping steering info")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c   | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index d5998ef59be4..7adcf0eec13b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -21,10 +21,11 @@ enum dr_dump_rec_type {
 	DR_DUMP_REC_TYPE_TABLE_TX = 3102,
 
 	DR_DUMP_REC_TYPE_MATCHER = 3200,
-	DR_DUMP_REC_TYPE_MATCHER_MASK = 3201,
+	DR_DUMP_REC_TYPE_MATCHER_MASK_DEPRECATED = 3201,
 	DR_DUMP_REC_TYPE_MATCHER_RX = 3202,
 	DR_DUMP_REC_TYPE_MATCHER_TX = 3203,
 	DR_DUMP_REC_TYPE_MATCHER_BUILDER = 3204,
+	DR_DUMP_REC_TYPE_MATCHER_MASK = 3205,
 
 	DR_DUMP_REC_TYPE_RULE = 3300,
 	DR_DUMP_REC_TYPE_RULE_RX_ENTRY_V0 = 3301,
@@ -114,13 +115,15 @@ dr_dump_rule_action_mem(struct seq_file *file, const u64 rule_id,
 		break;
 	case DR_ACTION_TYP_FT:
 		if (action->dest_tbl->is_fw_tbl)
-			seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			seq_printf(file, "%d,0x%llx,0x%llx,0x%x,0x%x\n",
 				   DR_DUMP_REC_TYPE_ACTION_FT, action_id,
-				   rule_id, action->dest_tbl->fw_tbl.id);
+				   rule_id, action->dest_tbl->fw_tbl.id,
+				   -1);
 		else
-			seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+			seq_printf(file, "%d,0x%llx,0x%llx,0x%x,0x%llx\n",
 				   DR_DUMP_REC_TYPE_ACTION_FT, action_id,
-				   rule_id, action->dest_tbl->tbl->table_id);
+				   rule_id, action->dest_tbl->tbl->table_id,
+				   DR_DBG_PTR_TO_ID(action->dest_tbl->tbl));
 
 		break;
 	case DR_ACTION_TYP_CTR:
-- 
2.37.1

