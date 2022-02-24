Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD404C2077
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245202AbiBXANM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245201AbiBXAM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FCC5F4D0
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52BDFB8228B
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ADAC340F0;
        Thu, 24 Feb 2022 00:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661545;
        bh=3gchysYApt8ueOeKCGuaYFFKr1aM+HW11lP6g/VahZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyeFnU5USFxX7eBYKxcWbRUenTvu5P37GAFp4dh0QQfzUeS+uq3cqHkpFGDIdyg2O
         F24OYsscuYw4PzCcxE4zLU2nu6x/thpgM5ZcpuMBNsCCA8xE31fJLFUvowepgW2AVz
         alNRu7abL/1DvEH38WVUtnSLLpLwy9cU0o8nQtFACAot6Vqd4ZWpEgcJxzo2oJSXWZ
         wz28FoeN4hxue9CccBx58iegJTUdLuTGpuYudN/8CV4pJ5ISOhv864eoDdalFadmZJ
         QeZicvZ1hf7Sul2QRPaik6j/KKkgQhmkU9J7Rr8vESuVzN0mRprx/Yd38bg05HGt+g
         U5PQIR3ev2ksw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 14/19] net/mlx5e: TC, Skip redundant ct clear actions
Date:   Wed, 23 Feb 2022 16:11:18 -0800
Message-Id: <20220224001123.365265-15-saeed@kernel.org>
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

Offload of ct clear action is just resetting the reg_c register.
It's done by allocating modify hdr resources which is limited.
Doing it multiple times is redundant and wasting modify hdr resources
and if resources depleted the driver will fail offloading the rule.
Ignore redundant ct clear actions after the first one.

Fixes: 806401c20a0f ("net/mlx5e: CT, Fix multiple allocations and memleak of mod acts")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c  | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 26efa33de56f..10a40487d536 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -16,6 +16,7 @@ struct mlx5e_tc_act_parse_state {
 	unsigned int num_actions;
 	struct mlx5e_tc_flow *flow;
 	struct netlink_ext_ack *extack;
+	bool ct_clear;
 	bool encap;
 	bool decap;
 	bool mpls_push;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 06ec30cdb269..58cc33f1363d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -27,8 +27,13 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		struct mlx5e_priv *priv,
 		struct mlx5_flow_attr *attr)
 {
+	bool clear_action = act->ct.action & TCA_CT_ACT_CLEAR;
 	int err;
 
+	/* It's redundant to do ct clear more than once. */
+	if (clear_action && parse_state->ct_clear)
+		return 0;
+
 	err = mlx5_tc_ct_parse_action(parse_state->ct_priv, attr,
 				      &attr->parse_attr->mod_hdr_acts,
 				      act, parse_state->extack);
@@ -40,6 +45,8 @@ tc_act_parse_ct(struct mlx5e_tc_act_parse_state *parse_state,
 	if (mlx5e_is_eswitch_flow(parse_state->flow))
 		attr->esw_attr->split_count = attr->esw_attr->out_count;
 
+	parse_state->ct_clear = clear_action;
+
 	return 0;
 }
 
-- 
2.35.1

