Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331F147E7E4
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349938AbhLWTEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37720 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349929AbhLWTEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E909F61F6E
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06444C36AE9;
        Thu, 23 Dec 2021 19:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286292;
        bh=flVLDsw9vyQSnxL8tQSGqDAMPkHQTMOk9MhzhFyIamU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzkJsAHgcUUWZhnExJHaMEx75iixgWulowmYYQJvEvG1EjVef1Zb1/VEuJjf6lmoV
         GFeV+UCAVQNnrLWcuOrs3rWcYN7HPgb07xh3Tf5YqPHDAaKCQ3T+RQXTX65N09M2gI
         77H0BM7ckmn3LTCMWvFBKI+lCJGIE7h06kqO4zZbniPkeUx4Gif93+vd/KaENADuTS
         4v/WYFBH6cMTSdquDJGvv3pS1nwNNXOdhZ1ShErvUim/gNPlEf1OimcVdWpn3pqaoH
         MW6XpRjJ/ENHvAzH1vf120hoWZIQ84vT9lLwnCGJA8sJQh4A6gI243XynGASbugD04
         EMCY6P6QWhYUA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 11/12] net/mlx5e: Delete forward rule for ct or sample action
Date:   Thu, 23 Dec 2021 11:04:40 -0800
Message-Id: <20211223190441.153012-12-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

When there is ct or sample action, the ct or sample rule will be deleted
and return. But if there is an extra mirror action, the forward rule can't
be deleted because of the return.

Fix it by removing the return.

Fixes: 69e2916ebce4 ("net/mlx5: CT: Add support for mirroring")
Fixes: f94d6389f6a8 ("net/mlx5e: TC, Add support to offload sample action")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3d45f4ae80c0..f633448c3cc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1196,21 +1196,16 @@ void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 	if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
 		goto offload_rule_0;
 
-	if (flow_flag_test(flow, CT)) {
-		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
-		return;
-	}
-
-	if (flow_flag_test(flow, SAMPLE)) {
-		mlx5e_tc_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
-		return;
-	}
-
 	if (attr->esw_attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
 
+	if (flow_flag_test(flow, CT))
+		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
+	else if (flow_flag_test(flow, SAMPLE))
+		mlx5e_tc_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
+	else
 offload_rule_0:
-	mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
+		mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
 }
 
 struct mlx5_flow_handle *
-- 
2.33.1

