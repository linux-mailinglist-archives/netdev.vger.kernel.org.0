Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF252475228
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239934AbhLOFdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51560 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239888AbhLOFdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4632617E1
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9F4C34600;
        Wed, 15 Dec 2021 05:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546389;
        bh=iu7r8P9mBCvPzdTwqDon0jAdndof9YZHXy6dFFjCFkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dw86SNWLYf6UbwbY8RfeAzqYszj8NdaMwmTcIeGZ1kaS8FBBiB2WZxMgNMcwTkRfZ
         oUwIBFtxv123ulyKiGuO2SDOn90nbAJtLz/jP5ngtZY1x7qNRPpP+hx3wtZgCD/4oT
         /0STdgYeuYChoLjslUUAypj8HTjMSKE7aflxRvnMlf0CPd20ltzCYKe2Iwms4Gxqy3
         Q1EI/1eihZQ/UnuI2rDLaojRgUpdPQjDx6Sx0DDiPyvagTliktjac9pbQcAu1xWp2Y
         4e84VwEyMj8nGNCHpBBARodQcy2cdFTE6yZ1xvRHcUKWPe4lpS5HBql8+Wq4fO5K61
         EiY5EpqeLl20Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 14/16] net/mlx5e: Add post_parse() op to tc action infrastructure
Date:   Tue, 14 Dec 2021 21:32:58 -0800
Message-Id: <20211215053300.130679-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215053300.130679-1-saeed@kernel.org>
References: <20211215053300.130679-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The post_parse() op should be called after the parse op was called
for all actions. It could be an action state is dependent on other
actions. In the new op an action can fail the parse if the state
is not valid anymore.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/act.h   |  4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 0aa995a9f674..26efa33de56f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -36,6 +36,10 @@ struct mlx5e_tc_act {
 			    const struct flow_action_entry *act,
 			    struct mlx5e_priv *priv,
 			    struct mlx5_flow_attr *attr);
+
+	int (*post_parse)(struct mlx5e_tc_act_parse_state *parse_state,
+			  struct mlx5e_priv *priv,
+			  struct mlx5_flow_attr *attr);
 };
 
 extern struct mlx5e_tc_act mlx5e_tc_act_drop;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c6c6d20ecd09..2ece349592cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3168,6 +3168,17 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 			return err;
 	}
 
+	flow_action_for_each(i, act, flow_action) {
+		tc_act = mlx5e_tc_act_get(act->id, ns_type);
+		if (!tc_act || !tc_act->post_parse ||
+		    !tc_act->can_offload(parse_state, act, i))
+			continue;
+
+		err = tc_act->post_parse(parse_state, priv, attr);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
2.31.1

