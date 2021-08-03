Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1693DE468
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhHCC3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233768AbhHCC3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65CC06109F;
        Tue,  3 Aug 2021 02:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957745;
        bh=aHxhjioWJt1uh/5MOVmlScWsAmjZCCFzRKcbng3miMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYDJgruuYaPtNPnIr830JCFGg6XFLvDsJ0J1/7W4/7K1LO71CpGbzqHG8Tx3JXNAT
         lyrMU7fE++7zmnvHhZ4COUtXN2WbnU32Vb4Jt9zprYbHGB/3SrQF/TU/iwnNAlVS0r
         2i4apn1dUvEvFWFrddVzResjGq8R8OFGCL7aoh1TooUaAM5lWyNGJT2qs0uVd5GV/g
         xayH3Ln3Umra8OnMLn96DoC7teJLmsCx1p3CoxnMnRU2mPLwk6V5Bg9gjOQvva5+Vm
         eS6HtZIjBKuuYqSwIitCfzjRKiXnw2BfzH92xQt/01n2ZIiv+ij2n57zlSQiwiBP/l
         dhKbuhacFxCbg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/16] net/mlx5e: Remove redundant parse_attr arg
Date:   Mon,  2 Aug 2021 19:28:50 -0700
Message-Id: <20210803022853.106973-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Passing parse_attr is redundant in parse_tc_nic_actions() and
mlx5e_tc_add_nic_flow() as we can get it from flow.
This is the same as with parse_tc_fdb_actions() and mlx5e_tc_add_fdb_flow().

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3453f37a0741..472c0c756a69 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1031,15 +1031,17 @@ mlx5e_add_offloaded_nic_rule(struct mlx5e_priv *priv,
 
 static int
 mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
-		      struct mlx5e_tc_flow_parse_attr *parse_attr,
 		      struct mlx5e_tc_flow *flow,
 		      struct netlink_ext_ack *extack)
 {
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_core_dev *dev = priv->mdev;
 	struct mlx5_fc *counter = NULL;
 	int err;
 
+	parse_attr = attr->parse_attr;
+
 	if (flow_flag_test(flow, HAIRPIN)) {
 		err = mlx5e_hairpin_flow_add(priv, flow, parse_attr, extack);
 		if (err)
@@ -3327,10 +3329,10 @@ static int validate_goto_chain(struct mlx5e_priv *priv,
 
 static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 				struct flow_action *flow_action,
-				struct mlx5e_tc_flow_parse_attr *parse_attr,
 				struct mlx5e_tc_flow *flow,
 				struct netlink_ext_ack *extack)
 {
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct pedit_headers_action hdrs[2] = {};
 	const struct flow_action_entry *act;
@@ -3346,8 +3348,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 
 	nic_attr = attr->nic_attr;
-
 	nic_attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
+	parse_attr = attr->parse_attr;
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
@@ -4418,11 +4420,11 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
-	err = parse_tc_nic_actions(priv, &rule->action, parse_attr, flow, extack);
+	err = parse_tc_nic_actions(priv, &rule->action, flow, extack);
 	if (err)
 		goto err_free;
 
-	err = mlx5e_tc_add_nic_flow(priv, parse_attr, flow, extack);
+	err = mlx5e_tc_add_nic_flow(priv, flow, extack);
 	if (err)
 		goto err_free;
 
-- 
2.31.1

