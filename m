Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA43C481059
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbhL2GZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58284 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238959AbhL2GZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 150C0B81827
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6797FC36AEE;
        Wed, 29 Dec 2021 06:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759113;
        bh=jmvw/fe9fhe8rMfbIEmpeXEd49626CsMbNDO4PzFyoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UndxsY20c3AGi7J9YhLS9NdVy82q3c1IUFW1g06ayM9bZQhpaNccnhZ8kIxix1GAU
         HvuMfBjwSic4kfOr0baMwSmZLATlMFJ7PpvF9zuMn633O9M/l2gsyW5KhDSdncHaKt
         0r/wEcrr/tVFwpOJmAQAH+gYW3D+HVXvmzZSjhFGQA+LqK3JxkLosBUoQUGIf62Y+B
         y7RTsq5dCFOrxoDBjt8LHPZbpPjv3knwdmY8dfKMxHdV4YTl13hYsAXQfjBymG/ok0
         YVfKt69Llu75uXsfIiYHrs9CrAtJmR4Og437NaGALDXMFWB9dteeP2CU8IjCE2uSmx
         Xbzhzd5clkYEQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  15/16] net/mlx5: DR, Ignore modify TTL if device doesn't support it
Date:   Tue, 28 Dec 2021 22:25:01 -0800
Message-Id: <20211229062502.24111-16-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When modifying TTL, packet's csum has to be recalculated.
Due to HW issue in ConnectX-5, csum recalculation for modify TTL
is supported through a work-around that is specifically enabled
by configuration.
If the work-around isn't enabled, ignore the modify TTL action
rather than adding an unsupported action.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 21 ++++++++++++++++---
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index f0faf04536d3..c61a5e83c78c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1560,6 +1560,12 @@ dr_action_modify_check_is_ttl_modify(const void *sw_action)
 	return sw_field == MLX5_ACTION_IN_FIELD_OUT_IP_TTL;
 }
 
+static bool dr_action_modify_ttl_ignore(struct mlx5dr_domain *dmn)
+{
+	return !mlx5dr_ste_supp_ttl_cs_recalc(&dmn->info.caps) &&
+	       !MLX5_CAP_ESW_FLOWTABLE(dmn->mdev, fdb_ipv4_ttl_modify);
+}
+
 static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 					    u32 max_hw_actions,
 					    u32 num_sw_actions,
@@ -1591,8 +1597,13 @@ static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 		if (ret)
 			return ret;
 
-		if (!(*modify_ttl))
-			*modify_ttl = dr_action_modify_check_is_ttl_modify(sw_action);
+		if (!(*modify_ttl) &&
+		    dr_action_modify_check_is_ttl_modify(sw_action)) {
+			if (dr_action_modify_ttl_ignore(dmn))
+				continue;
+
+			*modify_ttl = true;
+		}
 
 		/* Convert SW action to HW action */
 		ret = dr_action_modify_sw_to_hw(dmn,
@@ -1631,7 +1642,7 @@ static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 			 * modify actions doesn't exceeds the limit
 			 */
 			hw_idx++;
-			if ((num_sw_actions + hw_idx - i) >= max_hw_actions) {
+			if (hw_idx >= max_hw_actions) {
 				mlx5dr_dbg(dmn, "Modify header action number exceeds HW limit\n");
 				return -EINVAL;
 			}
@@ -1642,6 +1653,10 @@ static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 		hw_idx++;
 	}
 
+	/* if the resulting HW actions list is empty, add NOP action */
+	if (!hw_idx)
+		hw_idx++;
+
 	*num_hw_actions = hw_idx;
 
 	return 0;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index deaa0f71213f..598ac3bcc901 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -833,7 +833,7 @@ struct mlx5_ifc_flow_table_eswitch_cap_bits {
 	u8      fdb_to_vport_reg_c_id[0x8];
 	u8      reserved_at_8[0xd];
 	u8      fdb_modify_header_fwd_to_table[0x1];
-	u8      reserved_at_16[0x1];
+	u8      fdb_ipv4_ttl_modify[0x1];
 	u8      flow_source[0x1];
 	u8      reserved_at_18[0x2];
 	u8      multi_fdb_encap[0x1];
-- 
2.33.1

