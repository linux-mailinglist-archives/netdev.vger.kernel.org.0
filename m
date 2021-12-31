Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879DC4822C2
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242790AbhLaIU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242815AbhLaIUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D474CC06175C
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:20:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EE41B81D19
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C75C36AEE;
        Fri, 31 Dec 2021 08:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938850;
        bh=55FAHFQlaHmGnIEL8r+Yida2dZnKtjV7nsmurxLMxHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0FRj5L9AVjjsfLFw22FQk0I4vNSOAWepbEDg4d0yrOWECV/hRKfPq82AgGMsbB76
         hCdjlIjgpOMx/5S0EDR+XMjInuZkkrQJX3OBjLTtfrSAtpl70D+nRwEksAOuo+cxSE
         EPR0ggKsRRawYK/aEnlCCnj39qc1/dvNv5SdVfiw0VHfye+S8xUZI4TnLqoY+d+nfK
         CqEag0YPAN9G825q3OPGkV8TNZ9Xqz5t7rqjZulExRGpOvclkWmmYVJnO84DTTQj6W
         qk+opFC/5OmTsv6cu37ZHQRRbE42zqjNfw9XmuY4RGqEeSn+6nN6twmVw6S4CnyYXc
         rpBmT0FgtJ7OQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 15/16] net/mlx5: DR, Ignore modify TTL if device doesn't support it
Date:   Fri, 31 Dec 2021 00:20:37 -0800
Message-Id: <20211231082038.106490-16-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
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

