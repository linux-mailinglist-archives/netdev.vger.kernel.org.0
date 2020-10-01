Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BD227F8BB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgJAEdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbgJAEdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:18 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D2E6221EC;
        Thu,  1 Oct 2020 04:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526797;
        bh=M0iJ79BUdj2mRhQbHTNqUdyuBlXq6GcbnwxzzKrksdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAXpM7XKFHlKoWFacvWrsb/ouna67wYz86z/1bErtpEOuey61xov8WhjAxKMu+aP9
         U56o/8rj1RJRs71MPeEzVh5o5BwiP+DmSmuc3hOc+yTSzKTCfDiOA+NajJxVMcBL5j
         d1Z36knuMPkQ/lOWw5BN4xvQnalK4OvZXrJepHoE=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5: E-switch, Use helper function to load unload representor
Date:   Wed, 30 Sep 2020 21:32:56 -0700
Message-Id: <20201001043302.48113-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

To register and unregister devlink ports when loading/unload
representors, refactor the code to helper functions.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 29 ++++++++++++++-----
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index eea16a21fb01..f021cb8e6ad4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1820,15 +1820,12 @@ static void __unload_reps_all_vport(struct mlx5_eswitch *esw, u8 rep_type)
 	__esw_offloads_unload_rep(esw, rep, rep_type);
 }
 
-int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
+static int mlx5_esw_offloads_rep_load(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_eswitch_rep *rep;
 	int rep_type;
 	int err;
 
-	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
-		return 0;
-
 	rep = mlx5_eswitch_get_rep(esw, vport_num);
 	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++)
 		if (atomic_cmpxchg(&rep->rep_data[rep_type].state,
@@ -1847,19 +1844,35 @@ int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
 	return err;
 }
 
-void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
+static void mlx5_esw_offloads_rep_unload(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_eswitch_rep *rep;
 	int rep_type;
 
-	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
-		return;
-
 	rep = mlx5_eswitch_get_rep(esw, vport_num);
 	for (rep_type = NUM_REP_TYPES - 1; rep_type >= 0; rep_type--)
 		__esw_offloads_unload_rep(esw, rep, rep_type);
 }
 
+int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	int err;
+
+	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
+		return 0;
+
+	err = mlx5_esw_offloads_rep_load(esw, vport_num);
+	return err;
+}
+
+void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num)
+{
+	if (esw->mode != MLX5_ESWITCH_OFFLOADS)
+		return;
+
+	mlx5_esw_offloads_rep_unload(esw, vport_num);
+}
+
 #define ESW_OFFLOADS_DEVCOM_PAIR	(0)
 #define ESW_OFFLOADS_DEVCOM_UNPAIR	(1)
 
-- 
2.26.2

