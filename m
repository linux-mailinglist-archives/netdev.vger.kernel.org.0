Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5395135366A
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhDDEUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhDDEUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8A936137E;
        Sun,  4 Apr 2021 04:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510008;
        bh=viv3ppIWMwPl3knTefeY2e31FE6W/lGp7FtoHKEdIdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7kMZ5pRaKOq7KXpOB97VTf7JkRxEnYuq3ALJKn9msWirJAe6NQDkoiLwHJaFutkH
         PpREtRya+ewM3nkY3QoBLpiEfpxhVzOBJG+B1/4Josf3zOT2wPPetYTK1K6O+1N8TN
         H81QfanBEij4bodUWWr26vg4jUQ6xtPNY5nBwvnk7vpdEXBGIJHBH/hLBRb87S3v44
         P/45KNI7VpKzOS6gn74D2Tvqa21nQqJZBCsglXj4VsUgPunlgi5ASZxBN2Ddg/xCar
         xa0Xccbq7Ox4Mh14Yha0EBr7nJSEtt1GW0psMhOABBIz3KkhxKRwFoXkY9ldbfm356
         0KqyDZIL+2big==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/16] net/mlx5: E-Switch, move QoS specific fields to existing qos struct
Date:   Sat,  3 Apr 2021 21:19:41 -0700
Message-Id: <20210404041954.146958-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Function QoS related fields are already defined in qos related struct.
min and max rate are left out to mlx5_vport_info struct.

Move them to existing qos struct.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 26 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  4 +--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6b260dacf853..6cf04a366f99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1235,7 +1235,7 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 		return err;
 
 	/* Attach vport to the eswitch rate limiter */
-	esw_vport_enable_qos(esw, vport, vport->info.max_rate, vport->qos.bw_share);
+	esw_vport_enable_qos(esw, vport, vport->qos.max_rate, vport->qos.bw_share);
 
 	if (mlx5_esw_is_manager_vport(esw, vport_num))
 		return 0;
@@ -2078,8 +2078,8 @@ int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
 	ivi->qos = evport->info.qos;
 	ivi->spoofchk = evport->info.spoofchk;
 	ivi->trusted = evport->info.trusted;
-	ivi->min_tx_rate = evport->info.min_rate;
-	ivi->max_tx_rate = evport->info.max_rate;
+	ivi->min_tx_rate = evport->qos.min_rate;
+	ivi->max_tx_rate = evport->qos.max_rate;
 	mutex_unlock(&esw->state_lock);
 
 	return 0;
@@ -2319,9 +2319,9 @@ static u32 calculate_vports_min_rate_divider(struct mlx5_eswitch *esw)
 	int i;
 
 	mlx5_esw_for_all_vports(esw, i, evport) {
-		if (!evport->enabled || evport->info.min_rate < max_guarantee)
+		if (!evport->enabled || evport->qos.min_rate < max_guarantee)
 			continue;
-		max_guarantee = evport->info.min_rate;
+		max_guarantee = evport->qos.min_rate;
 	}
 
 	if (max_guarantee)
@@ -2343,8 +2343,8 @@ static int normalize_vports_min_rate(struct mlx5_eswitch *esw)
 	mlx5_esw_for_all_vports(esw, i, evport) {
 		if (!evport->enabled)
 			continue;
-		vport_min_rate = evport->info.min_rate;
-		vport_max_rate = evport->info.max_rate;
+		vport_min_rate = evport->qos.min_rate;
+		vport_max_rate = evport->qos.max_rate;
 		bw_share = 0;
 
 		if (divider)
@@ -2391,24 +2391,24 @@ int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *esw, u16 vport,
 
 	mutex_lock(&esw->state_lock);
 
-	if (min_rate == evport->info.min_rate)
+	if (min_rate == evport->qos.min_rate)
 		goto set_max_rate;
 
-	previous_min_rate = evport->info.min_rate;
-	evport->info.min_rate = min_rate;
+	previous_min_rate = evport->qos.min_rate;
+	evport->qos.min_rate = min_rate;
 	err = normalize_vports_min_rate(esw);
 	if (err) {
-		evport->info.min_rate = previous_min_rate;
+		evport->qos.min_rate = previous_min_rate;
 		goto unlock;
 	}
 
 set_max_rate:
-	if (max_rate == evport->info.max_rate)
+	if (max_rate == evport->qos.max_rate)
 		goto unlock;
 
 	err = esw_vport_qos_config(esw, evport, max_rate, evport->qos.bw_share);
 	if (!err)
-		evport->info.max_rate = max_rate;
+		evport->qos.max_rate = max_rate;
 
 unlock:
 	mutex_unlock(&esw->state_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 0adffab20244..64db903068c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -120,8 +120,6 @@ struct mlx5_vport_info {
 	u16                     vlan;
 	u64                     node_guid;
 	int                     link_state;
-	u32                     min_rate;
-	u32                     max_rate;
 	u8                      qos;
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
@@ -154,6 +152,8 @@ struct mlx5_vport {
 		bool            enabled;
 		u32             esw_tsar_ix;
 		u32             bw_share;
+		u32 min_rate;
+		u32 max_rate;
 	} qos;
 
 	bool                    enabled;
-- 
2.30.2

