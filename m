Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E27D6EA115
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbjDUBjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbjDUBjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF63E3C29
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4799D62D29
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237EFC433EF;
        Fri, 21 Apr 2023 01:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041142;
        bh=znJeVfox0tf7no+lQwnaWZtYNCfe3SZROSGs3Osdd94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVTU/xxKr7fKPAC0tkjbcDxd32iiydcaJNhPNxnI88f8Yi25SKhCcQ2qnw7Onhy5S
         gv3PhdUTXKM0S2oTKs7l68JsTuDlM3lJZ1s0wcdM+L1zKFmYCcEEWOz9+Mzpsxqmf2
         kKqImxUWxqHzXvJwCqGRH+LQXSRth8Tm/Ho7o2JGi9JNebrNPImrpAjqjFLea2rXg6
         RlqNrAlKz2bz210JfJL3vqNNUdUb06/FSAs49mKenkG/vdNOdpWIBtAivr1f0BjtTr
         u8ZurWcmYKN0iFN9rnvPh9ZgnSbpGIaFAzCXVd2mQPXIvfggBqQHYLA2avXSnFCIZZ
         IpsBSA2DJKwBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [net-next 01/15] net/mlx5: DR, Fix dumping of legacy modify_hdr in debug dump
Date:   Thu, 20 Apr 2023 18:38:36 -0700
Message-Id: <20230421013850.349646-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421013850.349646-1-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
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

The steering dump parser expects to see 0 as rewrite num of actions
in case pattern/args aren't supported - parsing of legacy modify header
is based on this assumption.
Fix this to align to parser's expectation.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c  | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
index 1ff8bde90e1e..ea9f27db4c74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
@@ -153,13 +153,15 @@ dr_dump_rule_action_mem(struct seq_file *file, const u64 rule_id,
 			   DR_DUMP_REC_TYPE_ACTION_MODIFY_HDR, action_id,
 			   rule_id, action->rewrite->index,
 			   action->rewrite->single_action_opt,
-			   action->rewrite->num_of_actions,
+			   ptrn_arg ? action->rewrite->num_of_actions : 0,
 			   ptrn_arg ? ptrn->index : 0,
 			   ptrn_arg ? mlx5dr_arg_get_obj_id(arg) : 0);
 
-		for (i = 0; i < action->rewrite->num_of_actions; i++) {
-			seq_printf(file, ",0x%016llx",
-				   be64_to_cpu(((__be64 *)rewrite_data)[i]));
+		if (ptrn_arg) {
+			for (i = 0; i < action->rewrite->num_of_actions; i++) {
+				seq_printf(file, ",0x%016llx",
+					   be64_to_cpu(((__be64 *)rewrite_data)[i]));
+			}
 		}
 
 		seq_puts(file, "\n");
-- 
2.39.2

