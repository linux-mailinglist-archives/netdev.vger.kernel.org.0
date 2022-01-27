Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2004A49EC96
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344092AbiA0Uk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344067AbiA0UkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDEDC06174A
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 12:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D88F3B8238E
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 20:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C36C340EE;
        Thu, 27 Jan 2022 20:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643316014;
        bh=QnEtz5kDWxhIHeiZ+P6LdtPZD2K/54BywLZpn9WBfmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMAxUhqp1aujm5Q3kFNepUk7momRtmOeY7lrGqHR9I68kQiUGlBfYjOLjXLZnGNGf
         mEl+OKi/cY7r3aBzQ/g7M1KLKNG5D89BK4VqOsKy29G0el3LjYIgTm/l7VaHcOHU69
         evdvQD5bYNm8zub99zsecx9DVSyLaVSSIzHvTCmaiXUBoXpvJJ7Gx5a/7/Fmwyov/r
         zgQQpaNyOn5rl7Y6pJjf+alM+AYs1W+r1A/p1QnB+vM7esXoXsFS2C7Mvz5eo9ynvn
         2uB15dp4tkHO41ttq0BogA1GGyongx4iK3AW9UNNKH9mZLcz26Vp0QSXlZb3sSqZhH
         ZBjHyow1FSGCQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next RESEND 08/17] net/mlx5e: TC, Reject rules with multiple CT actions
Date:   Thu, 27 Jan 2022 12:39:58 -0800
Message-Id: <20220127204007.146300-9-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127204007.146300-1-saeed@kernel.org>
References: <20220127204007.146300-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The driver doesn't support multiple CT actions.
Multiple CT clear actions are ok as they are redundant also with
another CT actions.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/act.h    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 04734e59bbc4..bfbc91c116a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -16,6 +16,7 @@ struct mlx5e_tc_act_parse_state {
 	unsigned int num_actions;
 	struct mlx5e_tc_flow *flow;
 	struct netlink_ext_ack *extack;
+	bool ct;
 	bool encap;
 	bool decap;
 	bool mpls_push;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 0d08cc35ea6f..4a04e0a7a52e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -11,6 +11,7 @@ tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		      int act_index,
 		      struct mlx5_flow_attr *attr)
 {
+	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
 	struct netlink_ext_ack *extack = parse_state->extack;
 
 	if (flow_flag_test(parse_state->flow, SAMPLE)) {
@@ -19,6 +20,11 @@ tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		return false;
 	}
 
+	if (parse_state->ct && !clear_action) {
+		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supoported");
+		return false;
+	}
+
 	return true;
 }
 
@@ -28,6 +34,7 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		struct mlx5e_priv *priv,
 		struct mlx5_flow_attr *attr)
 {
+	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
 	int err;
 
 	err = mlx5_tc_ct_parse_action(parse_state->ct_priv, attr,
@@ -41,6 +48,9 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	if (mlx5e_is_eswitch_flow(parse_state->flow))
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
+	if (!clear_action)
+		parse_state->ct = true;
+
 	return 0;
 }
 
-- 
2.34.1

