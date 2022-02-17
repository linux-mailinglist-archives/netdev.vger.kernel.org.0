Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BAF4B9A44
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiBQH5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:57:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236769AbiBQH4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:56:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348C37669
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C438161B43
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8071C340EC;
        Thu, 17 Feb 2022 07:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084599;
        bh=02a3t8FMz5ygEV00ngcv97iXTHPEBeSlw/9WkjCGZ/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQW1g9pPcvdD4MPc0eAdNc9jdUYLJigJy6ZvcF7ABffLJvg6dBNJtQc56spiOtUX5
         gxYKQJPpsJzIAjv6dQQhkS7AbkFQW7JCMJa+h4MsBl7c6qPFKZVjyj2obyZAikilsG
         6qm3+v0+I6+aQELXBMkrpQnnQLirS2srHYL/3kpImk8KXsZpAx88T3v5ZAPfpWwLZM
         NaFQ0qP8kcYWc2LrELU7AzfQ+jp4ghGTpcT8FtGBQrdIKA2IzGK/38D/WJjXFvuRIZ
         3sbyk5rPHOjNI2Pdl4hOJt4FDBiUxul8NeBVFlinZKJzizSjjrx63+GavqPEmnYB6G
         10aBdIeLUsX3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Pass actions param to actions_match_supported()
Date:   Wed, 16 Feb 2022 23:56:26 -0800
Message-Id: <20220217075632.831542-10-saeed@kernel.org>
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

Currently the mlx5_flow object contains a single mlx5_attr instance.
However, multi table actions (e.g. CT) instantiate multiple attr instances.

Currently action_match_supported() reads the actions flag from the
flow's attribute instance. Modify the function to receive the action
flags as a parameter which is set by the calling function and
pass the aggregated actions to actions_match_supported().

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/act.h    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index bfbc91c116a5..fc7c06688b51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -16,6 +16,7 @@ struct mlx5e_tc_act_parse_state {
 	unsigned int num_actions;
 	struct mlx5e_tc_flow *flow;
 	struct netlink_ext_ack *extack;
+	u32 actions;
 	bool ct;
 	bool encap;
 	bool decap;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 342ab0688f13..a709b2e9f3f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3257,11 +3257,11 @@ actions_match_supported_fdb(struct mlx5e_priv *priv,
 static bool
 actions_match_supported(struct mlx5e_priv *priv,
 			struct flow_action *flow_action,
+			u32 actions,
 			struct mlx5e_tc_flow_parse_attr *parse_attr,
 			struct mlx5e_tc_flow *flow,
 			struct netlink_ext_ack *extack)
 {
-	u32 actions = flow->attr->action;
 	bool ct_flow, ct_clear;
 
 	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
@@ -3344,6 +3344,8 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 		err = tc_act->parse_action(parse_state, act, priv, attr);
 		if (err)
 			return err;
+
+		parse_state->actions |= attr->action;
 	}
 
 	flow_action_for_each(i, act, flow_action) {
@@ -3445,7 +3447,8 @@ parse_tc_nic_actions(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
+	if (!actions_match_supported(priv, flow_action, parse_state->actions,
+				     parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
 	return 0;
@@ -3574,7 +3577,8 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
+	if (!actions_match_supported(priv, flow_action, parse_state->actions,
+				     parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
 	return 0;
-- 
2.34.1

