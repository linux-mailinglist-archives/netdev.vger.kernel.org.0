Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AC241E4AE
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348891AbhI3XWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230201AbhI3XWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 789A261A38;
        Thu, 30 Sep 2021 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044054;
        bh=mZd39VXb6DfqK2P+lYlt4o9h/pa/C8YrBVfaqcxLCHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjGT/KnfzMc5vuphzuMphBpQIKwtz5WT7rNW6J0zbXUa1zDs++aOW+xY3rnkh4p/6
         46QjKt9yqF9C7snBKnT/Zu0PtVChYhoyiuoH9mdqqi5Ej0QtpUct34ADyDlZjx5RR3
         ru/zvmjZXwI+blnFtseSrVnH9jzeGyUxuj4A3/brpgXTOPrQIAS6U3KuRZKYYtJPxE
         QboM8MvLTnCTHRB2dXdRjPJrn1fcyPymuDsUw0H/SpBYNHTel0ic7EmXLBggl9yeE8
         VGgPgNzu7+jkXbMYzeHyHmbT3il2G/DMz2796us7yv9qdMaZo0xdfxvit/7X6OMzpy
         sIMoUGHRwihCw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5: DR, Replace local WIRE_PORT macro with the existing MLX5_VPORT_UPLINK
Date:   Thu, 30 Sep 2021 16:20:37 -0700
Message-Id: <20210930232050.41779-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

SW steering defines its own macro for uplink vport number.
Replace this macro with an already existing mlx5 macro.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_action.c   | 2 +-
 .../net/ethernet/mellanox/mlx5/core/steering/dr_domain.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 4 ++--
 .../net/ethernet/mellanox/mlx5/core/steering/dr_types.h    | 7 +++----
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 032b4a2546d3..8ca8fb804798 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -669,7 +669,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			attr.hit_gvmi = action->vport->caps->vhca_gvmi;
 			dest_action = action;
 			if (rx_rule) {
-				if (action->vport->caps->num == WIRE_PORT) {
+				if (action->vport->caps->num == MLX5_VPORT_UPLINK) {
 					mlx5dr_dbg(dmn, "Device doesn't support Loopback on WIRE vport\n");
 					return -EOPNOTSUPP;
 				}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index ca299d480579..73646322c7bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -170,7 +170,7 @@ static int dr_domain_query_vports(struct mlx5dr_domain *dmn)
 
 	/* Last vport is the wire port */
 	wire_vport = &dmn->info.caps.vports_caps[vport];
-	wire_vport->num = WIRE_PORT;
+	wire_vport->num = MLX5_VPORT_UPLINK;
 	wire_vport->icm_address_rx = esw_caps->uplink_icm_address_rx;
 	wire_vport->icm_address_tx = esw_caps->uplink_icm_address_tx;
 	wire_vport->vport_gvmi = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index aca80efc28fa..323ea138ad99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -1042,10 +1042,10 @@ static bool dr_rule_skip(enum mlx5dr_domain_type domain,
 		return false;
 
 	if (mask->misc.source_port) {
-		if (rx && value->misc.source_port != WIRE_PORT)
+		if (rx && value->misc.source_port != MLX5_VPORT_UPLINK)
 			return true;
 
-		if (!rx && value->misc.source_port == WIRE_PORT)
+		if (!rx && value->misc.source_port == MLX5_VPORT_UPLINK)
 			return true;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 441c03e645db..8e171a6d3a9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -4,7 +4,7 @@
 #ifndef	_DR_TYPES_
 #define	_DR_TYPES_
 
-#include <linux/mlx5/driver.h>
+#include <linux/mlx5/vport.h>
 #include <linux/refcount.h>
 #include "fs_core.h"
 #include "wq.h"
@@ -14,7 +14,6 @@
 
 #define DR_RULE_MAX_STES 18
 #define DR_ACTION_MAX_STES 5
-#define WIRE_PORT 0xFFFF
 #define DR_STE_SVLAN 0x1
 #define DR_STE_CVLAN 0x2
 #define DR_SZ_MATCH_PARAM (MLX5_ST_SZ_DW_MATCH_PARAM * 4)
@@ -1106,10 +1105,10 @@ static inline struct mlx5dr_cmd_vport_cap *
 mlx5dr_get_vport_cap(struct mlx5dr_cmd_caps *caps, u16 vport)
 {
 	if (!caps->vports_caps ||
-	    (vport >= caps->num_vports && vport != WIRE_PORT))
+	    (vport >= caps->num_vports && vport != MLX5_VPORT_UPLINK))
 		return NULL;
 
-	if (vport == WIRE_PORT)
+	if (vport == MLX5_VPORT_UPLINK)
 		vport = caps->num_vports;
 
 	return &caps->vports_caps[vport];
-- 
2.31.1

