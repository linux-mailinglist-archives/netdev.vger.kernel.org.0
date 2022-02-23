Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BE74C1958
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243143AbiBWRF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243146AbiBWRFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838D1532D1
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BB2960B49
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23229C340F3;
        Wed, 23 Feb 2022 17:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635884;
        bh=3gchysYApt8ueOeKCGuaYFFKr1aM+HW11lP6g/VahZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4cAmXLOfkMC2lQNoHYi8jacYMvBHvUCvKsJasv6zCfMrja8qQSs5OyF96CuWXgBg
         EK5+Bx/Y1K2mNPFtaVG08J7ZpSAaxxjtXdUG8phuYfCY3mj01ibIQKB6wgF4tPY/LW
         67Sy+PIseNVvnkIa+j4NR0aMMO3GA3W2eCc2dDRy6YRna32rS6MPKSb/3axFAgEd8K
         Bmp5WRj/HWJ8DIf/Y24LqE2z5aeeSz3ykK276AbjSjQc+Al+m/99jg/vQm4OZyWTZd
         Hq28EpXc+RZd784DP1Pwuaga7lq/pmIDNvBz+G+dWh42mXddr/Hb+cz8SEj7jBH5Qz
         kP846T38wSwLw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 14/19] net/mlx5e: TC, Skip redundant ct clear actions
Date:   Wed, 23 Feb 2022 09:04:25 -0800
Message-Id: <20220223170430.295595-15-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223170430.295595-1-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
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

