Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF348564255
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 21:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbiGBTFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 15:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiGBTEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 15:04:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C813E0D6
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 12:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F8F61009
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 19:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE1DC34114;
        Sat,  2 Jul 2022 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656788674;
        bh=uG53DEbn6nzDZ/NEOII6OfduWeBL5Uxz0EiJiOXAJDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAboG301YPgSvBbKK1GKGh2wJKSR8L/jx9gyU81I/FIeTTD2MrPooQ9mmvbxKTozK
         TKEQFR+C+iYwOxILYj3OVCUX0cuhjcus2U8eTqsP4UOtp/hGEmaRsZMmSMGq24JUNz
         rcyFaZrfJDaW5h1z523pdwgC8F9aPHN0AuWecSz4dm8CkZ/xZIwlgXcruVOfGkVu5O
         mF7RfW3Kyh5oecty78XqZO5sM6gV+HcS10nTk6qxVTBxEFehXmAEtSDlKBK3Qo/xam
         MZRKc7TUZimu/XRMoSwHQcjAqt9Y+uIOTOjmn1/pgUOr6eEl09crAM01blF397DCEo
         XU1BDisSJ3yZg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next v2 14/15] net/mlx5e: Add flow_action to parse state
Date:   Sat,  2 Jul 2022 12:02:12 -0700
Message-Id: <20220702190213.80858-15-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702190213.80858-1-saeed@kernel.org>
References: <20220702190213.80858-1-saeed@kernel.org>
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

