Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298616D8D2D
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbjDFCDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbjDFCC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:02:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200CE83E6
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0116262BE7
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C71C433D2;
        Thu,  6 Apr 2023 02:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746569;
        bh=kRxvnizeL8Z4+/26ENS9w6dF7o/P+1gMPPQHrLym5a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MK8/gxyekbcdUOoPHC4bqKZDOh+91OwZIi8ovCnvDdyOcqquoFNOc/N0/zkaIfiWA
         dff4ibeRQzBwWImD3zi8JDaCZNuOTk6IKhUJtG+Lkmvia16sRxRlHCE16ZvX5ldumK
         Fv1PEr6waVoPPk/ACZwGZoigSKA+LIIH1Bs6TxK5cr1ZKpHQMmi5JFru4wgYj2ZxA/
         B7vjo6cTizcqMM9DugXTv+FKPzmCfD8QfkhzFDPUv67bukS9xOSKCpUQYA5INX7pEN
         9WlPitBp+45VBbX+pNQtQGawT9p8i2mjhWmhLGxnK9vkgFO0avKM0sRO6iuZCR+dzm
         VQTHR+7zl7pxg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: TC, Remove multiple ct actions limitation
Date:   Wed,  5 Apr 2023 19:02:24 -0700
Message-Id: <20230406020232.83844-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Multiple ct actions was not supported when only chain was
restored on misses, as CT is a modifying action which could
modify the packet and cause the sw ct rule to not match again
and continue processing.

Now that the misses continue from the relevant tc ct action
in software, this case is supported.

Remove this limitation.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc/act/act.h         |  1 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/ct.c | 18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 033afd44fc4f..0e6e1872ac62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -17,7 +17,6 @@ struct mlx5e_tc_act_parse_state {
 	struct mlx5e_tc_flow *flow;
 	struct netlink_ext_ack *extack;
 	u32 actions;
-	bool ct;
 	bool encap;
 	bool decap;
 	bool mpls_push;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 36bfed07d400..92d3952dfa8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -5,23 +5,6 @@
 #include "en/tc_priv.h"
 #include "en/tc_ct.h"
 
-static bool
-tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
-		      const struct flow_action_entry *act,
-		      int act_index,
-		      struct mlx5_flow_attr *attr)
-{
-	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
-	struct netlink_ext_ack *extack = parse_state->extack;
-
-	if (parse_state->ct && !clear_action) {
-		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supported");
-		return false;
-	}
-
-	return true;
-}
-
 static int
 tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		const struct flow_action_entry *act,
@@ -71,7 +54,6 @@ tc_act_is_missable_ct(const struct flow_action_entry *act)
 }
 
 struct mlx5e_tc_act mlx5e_tc_act_ct = {
-	.can_offload = tc_act_can_offload_ct,
 	.parse_action = tc_act_parse_ct,
 	.post_parse = tc_act_post_parse_ct,
 	.is_multi_table_act = tc_act_is_multi_table_act_ct,
-- 
2.39.2

