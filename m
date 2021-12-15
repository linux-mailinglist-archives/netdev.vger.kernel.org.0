Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C37475226
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 06:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbhLOFdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 00:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbhLOFdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 00:33:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A392C061747
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 21:33:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C69161812
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 05:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F19CC34605;
        Wed, 15 Dec 2021 05:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639546388;
        bh=ftH+i5p50du+YHg6iYZdkM6GcqzjAfr+SPt10P2f6Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5GnyWv6QNPSCh5rHUhdW4UrNbOXXqfhGp2B8Hk1wKZeoznJzIE61MlgVAVesSv+x
         ny4PNMTghkAh6T8DZIewqerFlAFTUgb35u+hsQgHeNcM+DAwYRrUsUuJjZpTbkDDSv
         21g9E3pb9e6sK6lsZENqtTWtxfdV0ijY1liPVLVy3NW67SNnTO0zZpdTye0x/fav+W
         Dwg0UkuXWVlsWkANppuRJhS0x5NO1CR4avidhMi/yeFLZCz2Th8M5uKFxRWXj33nRW
         085+oJ3Rz8RzuDB+dy/QHYD6lQzgliem57d0uWqNr9T9UwDIJKwdO/Ing3L2EtJ6cp
         KJc+4TdfElu5A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 13/16] net/mlx5e: Move sample attr allocation to tc_action sample parse op
Date:   Tue, 14 Dec 2021 21:32:57 -0800
Message-Id: <20211215053300.130679-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215053300.130679-1-saeed@kernel.org>
References: <20211215053300.130679-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

There is no reason to wait with the kmalloc to after parsing all
other actions. There could still be a failure later and before
offloading the rule. So alloc the mem when parsing.
The memory is being released on mlx5e_flow_put() which is called
also on error flow.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/act.h    |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c |  7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        | 10 ----------
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 51c9b9177f28..0aa995a9f674 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -25,7 +25,6 @@ struct mlx5e_tc_act_parse_state {
 	int ifindexes[MLX5_MAX_FLOW_FWD_VPORTS];
 	int if_count;
 	struct mlx5_tc_ct_priv *ct_priv;
-	struct mlx5e_sample_attr sample_attr;
 };
 
 struct mlx5e_tc_act {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
index 0d37fb0cad7c..6699bdf5cf01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
@@ -27,7 +27,11 @@ tc_act_parse_sample(struct mlx5e_tc_act_parse_state *parse_state,
 		    struct mlx5e_priv *priv,
 		    struct mlx5_flow_attr *attr)
 {
-	struct mlx5e_sample_attr *sample_attr = &parse_state->sample_attr;
+	struct mlx5e_sample_attr *sample_attr;
+
+	sample_attr = kzalloc(sizeof(*attr->sample_attr), GFP_KERNEL);
+	if (!sample_attr)
+		return -ENOMEM;
 
 	sample_attr->rate = act->sample.rate;
 	sample_attr->group_num = act->sample.psample_group->group_num;
@@ -35,6 +39,7 @@ tc_act_parse_sample(struct mlx5e_tc_act_parse_state *parse_state,
 	if (act->sample.truncate)
 		sample_attr->trunc_size = act->sample.trunc_size;
 
+	attr->sample_attr = sample_attr;
 	flow_flag_set(parse_state->flow, SAMPLE);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a3f414171ca5..c6c6d20ecd09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3425,16 +3425,6 @@ parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	/* Allocate sample attribute only when there is a sample action and
-	 * no errors after parsing.
-	 */
-	if (flow_flag_test(flow, SAMPLE)) {
-		attr->sample_attr = kzalloc(sizeof(*attr->sample_attr), GFP_KERNEL);
-		if (!attr->sample_attr)
-			return -ENOMEM;
-		*attr->sample_attr = parse_state->sample_attr;
-	}
-
 	return 0;
 }
 
-- 
2.31.1

