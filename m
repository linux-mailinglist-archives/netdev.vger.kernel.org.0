Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208A2641963
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiLCWOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiLCWNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:13:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFC01C92C
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3371BB807ED
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69B1C43470;
        Sat,  3 Dec 2022 22:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105626;
        bh=/qbyTmPgNv+Z/qj/vSO0xJFvVVoAW1E2Wcyl5xOzbVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKpRaRFHgRtYUxkH95OigFvVKOzal4R0eLvrAe1InJTk0AFWAEOGCt0ItQ2xNj7UF
         WLhTWCjUkHwBrgqadiEe2od5PY3VNt3sKIygzzokkq5r84099mXzcTrCcYlRWPKb3E
         garWhk3a+y0toJZMboLTGbAbReoSuc5nLfcgPOdP9U0NCTOGSHLPIviP5iqMYNUVkJ
         tYh34tcJUfM7yN8TzWUnpjg0EgTCWbjXwvBKkiD5uTn2PP0QwHPpNXumrrj5MYHO/g
         3RKdPTzysrl0lMPorxIY7/upvGsiAmk0RgO6nfqS0qCjDiCAqvr0kpiuXku40tSfg5
         +eePdEyL7jvgQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 04/15] net/mlx5e: TC, add terminating actions
Date:   Sat,  3 Dec 2022 14:13:26 -0800
Message-Id: <20221203221337.29267-5-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203221337.29267-1-saeed@kernel.org>
References: <20221203221337.29267-1-saeed@kernel.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

Extend act api to identify actions that terminate action list.
Pre-step for terminating branching actions.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h    | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c   | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c | 7 +++++++
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c | 1 +
 7 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
index 21aab96357b5..a278f52d52b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
@@ -28,4 +28,5 @@ tc_act_parse_accept(struct mlx5e_tc_act_parse_state *parse_state,
 struct mlx5e_tc_act mlx5e_tc_act_accept = {
 	.can_offload = tc_act_can_offload_accept,
 	.parse_action = tc_act_parse_accept,
+	.is_terminating_action = true,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 3337241cfd84..eba0c8698926 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -11,7 +11,7 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	[FLOW_ACTION_DROP] = &mlx5e_tc_act_drop,
 	[FLOW_ACTION_TRAP] = &mlx5e_tc_act_trap,
 	[FLOW_ACTION_GOTO] = &mlx5e_tc_act_goto,
-	[FLOW_ACTION_REDIRECT] = &mlx5e_tc_act_mirred,
+	[FLOW_ACTION_REDIRECT] = &mlx5e_tc_act_redirect,
 	[FLOW_ACTION_MIRRED] = &mlx5e_tc_act_mirred,
 	[FLOW_ACTION_REDIRECT_INGRESS] = &mlx5e_tc_act_redirect_ingress,
 	[FLOW_ACTION_VLAN_PUSH] = &mlx5e_tc_act_vlan,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index e1570ff056ae..8ede44902284 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -60,6 +60,8 @@ struct mlx5e_tc_act {
 
 	int (*stats_action)(struct mlx5e_priv *priv,
 			    struct flow_offload_action *fl_act);
+
+	bool is_terminating_action;
 };
 
 struct mlx5e_tc_flow_action {
@@ -81,6 +83,7 @@ extern struct mlx5e_tc_act mlx5e_tc_act_vlan_mangle;
 extern struct mlx5e_tc_act mlx5e_tc_act_mpls_push;
 extern struct mlx5e_tc_act mlx5e_tc_act_mpls_pop;
 extern struct mlx5e_tc_act mlx5e_tc_act_mirred;
+extern struct mlx5e_tc_act mlx5e_tc_act_redirect;
 extern struct mlx5e_tc_act mlx5e_tc_act_mirred_nic;
 extern struct mlx5e_tc_act mlx5e_tc_act_ct;
 extern struct mlx5e_tc_act mlx5e_tc_act_sample;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
index dd025a95c439..7d16aeabb119 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
@@ -27,4 +27,5 @@ tc_act_parse_drop(struct mlx5e_tc_act_parse_state *parse_state,
 struct mlx5e_tc_act mlx5e_tc_act_drop = {
 	.can_offload = tc_act_can_offload_drop,
 	.parse_action = tc_act_parse_drop,
+	.is_terminating_action = true,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
index 25174f68613e..0923e6db2d0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
@@ -121,4 +121,5 @@ struct mlx5e_tc_act mlx5e_tc_act_goto = {
 	.can_offload = tc_act_can_offload_goto,
 	.parse_action = tc_act_parse_goto,
 	.post_parse = tc_act_post_parse_goto,
+	.is_terminating_action = true,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index 4ac7de3f6afa..78c427b38048 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -334,4 +334,11 @@ tc_act_parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 struct mlx5e_tc_act mlx5e_tc_act_mirred = {
 	.can_offload = tc_act_can_offload_mirred,
 	.parse_action = tc_act_parse_mirred,
+	.is_terminating_action = false,
+};
+
+struct mlx5e_tc_act mlx5e_tc_act_redirect = {
+	.can_offload = tc_act_can_offload_mirred,
+	.parse_action = tc_act_parse_mirred,
+	.is_terminating_action = true,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
index 90b4c1b34776..7f409692b18f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
@@ -48,4 +48,5 @@ tc_act_parse_mirred_nic(struct mlx5e_tc_act_parse_state *parse_state,
 struct mlx5e_tc_act mlx5e_tc_act_mirred_nic = {
 	.can_offload = tc_act_can_offload_mirred_nic,
 	.parse_action = tc_act_parse_mirred_nic,
+	.is_terminating_action = true,
 };
-- 
2.38.1

