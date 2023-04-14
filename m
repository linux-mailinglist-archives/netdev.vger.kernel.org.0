Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F006E2C57
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjDNWKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjDNWJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5244744AE
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CD6C64A9F
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660AAC433D2;
        Fri, 14 Apr 2023 22:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510192;
        bh=J9C3VVKiF3EaLsmgj6hKrVkH/GXc7OVGVC9nvIUXemw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwbN67FVPz/U7XqF6NpCI9u0n1pwvPn8yT/iAyx6dAA8yzsG8J2pWunexopjmQtoT
         dBqMmFh765VcTWoAFwC8jnDkgI/K4ubYGSaO5lfJEBzpLUh2o3W+s3GT1Z2ZTVP4vg
         5IKztkNRFpVVAbbVNPmc9MAH72Afwt44fUfB83uajZHyRRR4Ze3AeOtFlFlQqedOcq
         JrGD3PsZSYEykOPUKfSsNg4fXXGlHNoxAXiLzIWONsPv/t2RtHaSMLy1pbbq/skaCe
         bMQetlJiovY5S+WMiY5/H5S3pcS86r4tZH9wIHdf31Dim/XF11K0hZ5LHp8UY5O+63
         FuNx/L1rNVxcg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 14/15] net/mlx5: DR, Add support for the pattern/arg parameters in debug dump
Date:   Fri, 14 Apr 2023 15:09:38 -0700
Message-Id: <20230414220939.136865-15-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Support the pattern/args-based MODIFY_HDR and TNL_L3_TO_L2 actions in dbg dump

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_dbg.c      | 30 +++++++++++++++++--
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index db81d881d38e..1ff8bde90e1e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -140,10 +140,31 @@ dr_dump_rule_action_mem(struct seq_file *file, const u64 rule_id,
 			   action->flow_tag->flow_tag);
 		break;
 	case DR_ACTION_TYP_MODIFY_HDR:
-		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
+	{
+		struct mlx5dr_ptrn_obj *ptrn = action->rewrite->ptrn;
+		struct mlx5dr_arg_obj *arg = action->rewrite->arg;
+		u8 *rewrite_data = action->rewrite->data;
+		bool ptrn_arg;
+		int i;
+
+		ptrn_arg = !action->rewrite->single_action_opt && ptrn && arg;
+
+		seq_printf(file, "%d,0x%llx,0x%llx,0x%x,%d,0x%x,0x%x,0x%x",
 			   DR_DUMP_REC_TYPE_ACTION_MODIFY_HDR, action_id,
-			   rule_id, action->rewrite->index);
+			   rule_id, action->rewrite->index,
+			   action->rewrite->single_action_opt,
+			   action->rewrite->num_of_actions,
+			   ptrn_arg ? ptrn->index : 0,
+			   ptrn_arg ? mlx5dr_arg_get_obj_id(arg) : 0);
+
+		for (i = 0; i < action->rewrite->num_of_actions; i++) {
+			seq_printf(file, ",0x%016llx",
+				   be64_to_cpu(((__be64 *)rewrite_data)[i]));
+		}
+
+		seq_puts(file, "\n");
 		break;
+	}
 	case DR_ACTION_TYP_VPORT:
 		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
 			   DR_DUMP_REC_TYPE_ACTION_VPORT, action_id, rule_id,
@@ -157,7 +178,10 @@ dr_dump_rule_action_mem(struct seq_file *file, const u64 rule_id,
 	case DR_ACTION_TYP_TNL_L3_TO_L2:
 		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
 			   DR_DUMP_REC_TYPE_ACTION_DECAP_L3, action_id,
-			   rule_id, action->rewrite->index);
+			   rule_id,
+			   (action->rewrite->ptrn && action->rewrite->arg) ?
+			   mlx5dr_arg_get_obj_id(action->rewrite->arg) :
+			   action->rewrite->index);
 		break;
 	case DR_ACTION_TYP_L2_TO_TNL_L2:
 		seq_printf(file, "%d,0x%llx,0x%llx,0x%x\n",
-- 
2.39.2

