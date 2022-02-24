Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12C04C207E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245195AbiBXANK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245184AbiBXAMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07625F4D1
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B69360B53
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71201C340F1;
        Thu, 24 Feb 2022 00:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661543;
        bh=IussuuEZE5fjly9wYoXpmoryxkM9tqbskd4W+/lTQto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNS5e6dEqIAUGx7jEVW0egfzK6wcDZDxihFSeTpkDoQM6RF4n+ib9/bY+GdQuYPXx
         zdQ3N1xVcYChw2TCabDo6c1ZNMCem5jk1MFHRizB0K45Ddj5gUJvoZorRFm4rSqvQk
         aBkchvXokJZpusHfaquEHc925nP/ZliWGjlgvLRPA0//bCttAPom6r0lhXHMxEXNwx
         jGATsYEv5A8zFdAHdezN9bP4o4et/G3OyIcmeD81GlqAjWbMChR7hv3tjm37vtzFa0
         01nraQxeVT2TojoC8lJiz27/XxqZ5gfms/0/axLkhjoHlOjCecCoElQCuxyFp/cO7/
         3UH9JzFMx7T1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 12/19] net/mlx5e: TC, Reject rules with drop and modify hdr action
Date:   Wed, 23 Feb 2022 16:11:16 -0800
Message-Id: <20220224001123.365265-13-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

This kind of action is not supported by firmware and generates a
syndrome.

kernel: mlx5_core 0000:08:00.0: mlx5_cmd_check:777:(pid 102063): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x8708c3)

Fixes: d7e75a325cb2 ("net/mlx5e: Add offloading of E-Switch TC pedit (header re-write) actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2022fa4a9598..34700cf1285e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3204,6 +3204,12 @@ actions_match_supported(struct mlx5e_priv *priv,
 		return false;
 	}
 
+	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");
+		return false;
+	}
+
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    !modify_header_match_supported(priv, &parse_attr->spec, flow_action,
 					   actions, ct_flow, ct_clear, extack))
-- 
2.35.1

