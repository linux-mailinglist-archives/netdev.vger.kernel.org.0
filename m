Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7834B9A3C
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbiBQH5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:57:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiBQH47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B37DE93
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57BFD61B41
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7097AC340EC;
        Thu, 17 Feb 2022 07:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084601;
        bh=gHWOk8T3YF+VtfXDQZeDcHojmZElcGG1zKkBBFgQdzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSNNUuKa31jDVKCu+Mz42mCyzz+WipYO8JIBBMjUl2Hw1R9YQ61hrjtL9jrfzOdH7
         uRlgfcqpTul7tV4VOaSB48RZluuxpQz/Zh7q8iHJ2xomebSky0uYwGthwogbB/6HX2
         rmw+AAum7JQZjjL/9JtKTtnib/oWaYdKWdH0eUWWMIj2oGfcbpIjcjvZGHv4hhR2Bm
         vgP1//ZaxoAasqfwqeZGzDxRQMUWRDex0l1o6cLgbxLwBNrt/G4n9KvnAyI9ABzR2r
         M2EaWfFBAznqej5sllV9d9DGPS0z1MQP4rrPwrLuvDgbvyr90ggRDgxMtRP4lGMWDE
         iz0+y4zqT0Orw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: TC, Make post_act parse CT and sample actions
Date:   Wed, 16 Feb 2022 23:56:31 -0800
Message-Id: <20220217075632.831542-15-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

Before this commit post_act can be used for normal rules
and didn't handle special cases like CT and sample.
With this commit post_act rule can also handle the special cases
when needed.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index 32abc91adf23..dea137dd744b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
+#include "en/tc_priv.h"
 #include "en_tc.h"
 #include "post_act.h"
 #include "mlx5_core.h"
@@ -89,7 +90,7 @@ mlx5e_tc_post_act_offload(struct mlx5e_post_act *post_act,
 	/* Post action rule matches on fte_id and executes original rule's tc rule action */
 	mlx5e_tc_match_to_reg_match(spec, FTEID_TO_REG, handle->id, MLX5_POST_ACTION_MASK);
 
-	handle->rule = mlx5_tc_rule_insert(post_act->priv, spec, handle->attr);
+	handle->rule = mlx5e_tc_rule_offload(post_act->priv, spec, handle->attr);
 	if (IS_ERR(handle->rule)) {
 		err = PTR_ERR(handle->rule);
 		netdev_warn(post_act->priv->netdev, "Failed to add post action rule");
@@ -152,7 +153,7 @@ void
 mlx5e_tc_post_act_unoffload(struct mlx5e_post_act *post_act,
 			    struct mlx5e_post_act_handle *handle)
 {
-	mlx5_tc_rule_delete(post_act->priv, handle->rule, handle->attr);
+	mlx5e_tc_rule_unoffload(post_act->priv, handle->rule, handle->attr);
 	handle->rule = NULL;
 }
 
-- 
2.34.1

