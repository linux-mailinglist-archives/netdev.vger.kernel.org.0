Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C28560E76
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiF3BAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 21:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiF3BAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80554403E8
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B85261F5B
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DE5C341C8;
        Thu, 30 Jun 2022 01:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656550821;
        bh=uG53DEbn6nzDZ/NEOII6OfduWeBL5Uxz0EiJiOXAJDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WterAaiDSIkO7q2YSLbgN6LfORX9c0krVRpY0mYF3JE7hpv6dFbGv/amDfTUDg76t
         J8ujQynQYxMTsQzjLYxVnn2BIuZGO9izV82kC4VVU2cKRSI0doc35y7HgRlJdw0Lnz
         moOfpqLxDAnRJ1qsvOBUDuDSNr+1rREtQ2YKK/8yy9hDqs8e9cexjk83VuRHcH6Nc8
         RgBlRbLnio6fVgHOqpxDGkS0f6Y/ZWkfMKb6ouFk91HxXASOdYqRoZaOKyhnPOJkW5
         lIn/mX/253IJIVb+Z71W3ISKU3d0mFlNe/xaWD08pUIESozlvggdx6SqbDX3MEvDzF
         wVvDdZTv8U83Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Add flow_action to parse state
Date:   Wed, 29 Jun 2022 18:00:04 -0700
Message-Id: <20220630010005.145775-15-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630010005.145775-1-saeed@kernel.org>
References: <20220630010005.145775-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

As a preparation for validating police action, adds flow_action to
parse state, which is to passed to parsing callbacks.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 2755c25ba324..c66aff41374f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -106,8 +106,8 @@ mlx5e_tc_act_init_parse_state(struct mlx5e_tc_act_parse_state *parse_state,
 {
 	memset(parse_state, 0, sizeof(*parse_state));
 	parse_state->flow = flow;
-	parse_state->num_actions = flow_action->num_entries;
 	parse_state->extack = extack;
+	parse_state->flow_action = flow_action;
 }
 
 void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index f34714c5ddd4..f027beba7096 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -13,7 +13,7 @@
 struct mlx5_flow_attr;
 
 struct mlx5e_tc_act_parse_state {
-	unsigned int num_actions;
+	struct flow_action *flow_action;
 	struct mlx5e_tc_flow *flow;
 	struct netlink_ext_ack *extack;
 	u32 actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
index a7d9eab19e4a..53b270f652b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
@@ -12,7 +12,7 @@ tc_act_can_offload_trap(struct mlx5e_tc_act_parse_state *parse_state,
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
 
-	if (parse_state->num_actions != 1) {
+	if (parse_state->flow_action->num_entries != 1) {
 		NL_SET_ERR_MSG_MOD(extack, "action trap is supported as a sole action only");
 		return false;
 	}
-- 
2.36.1

