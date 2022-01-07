Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C105486F4D
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344925AbiAGA7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344867AbiAGA6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A30BC034000
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:58:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD39361E7A
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71D3C36AE0;
        Fri,  7 Jan 2022 00:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517128;
        bh=RTHwN0Pn9iVqkwFi2wz4Wz3T/fZA+pECkM6mNSK/aAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qu49EphSFOCPZOevwUzgOefQH24D9+ucI8l6Q+wzVt2OvkZl6CG/CnB/+SLEXUo9U
         BBynWSCP7b6g5yeMMbPVoPp+AuIlLAWJSHQypP5GOIwhvlvSyq8Esa7XgVi2UsZTMz
         2f4zW7tAyHDcYzqu9lJcc5HwQWV6uVqu1OO9UGII2d4shVRviMPOdxngj+syYNsAhR
         M8CcIltbi9GPapx0awM9jiKMdPV818KyZ7D+SZ1VCpyiG6wfOjgMWx++seeR97eg23
         aMm/kQ9kK2QNG16ULhbB1n916JCbb2O3MNGQRB3RGI0phb2CUCdGc/gD7KgIcpofR/
         rRcMwULJbziEw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/11] net/mlx5e: Sync VXLAN udp ports during uplink representor profile change
Date:   Thu,  6 Jan 2022 16:58:29 -0800
Message-Id: <20220107005831.78909-10-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Currently during NIC profile disablement all VXLAN udp ports offloaded to the
HW are flushed and during its enablement the driver send notification to
the stack to inform the core that the entire UDP tunnel port state has been
lost, uplink representor doesn't have the same behavior which can cause
VXLAN udp ports offload to be in bad state while moving between modes while
VXLAN interface exist.

Fixed by aligning the uplink representor profile behavior to the NIC behavior.

Fixes: 84db66124714 ("net/mlx5e: Move set vxlan nic info to profile init")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 48895d79796a..c0df4b1115b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -50,6 +50,7 @@
 #include "fs_core.h"
 #include "lib/mlx5.h"
 #include "lib/devcom.h"
+#include "lib/vxlan.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
 #include "en_accel/ipsec.h"
@@ -1027,6 +1028,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(netdev))
 		mlx5e_open(netdev);
+	udp_tunnel_nic_reset_ntf(priv->netdev);
 	netif_device_attach(netdev);
 	rtnl_unlock();
 }
@@ -1048,6 +1050,7 @@ static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
 	mlx5e_rep_tc_disable(priv);
 	mlx5_lag_remove_netdev(mdev, priv->netdev);
+	mlx5_vxlan_reset_to_default(mdev->vxlan);
 }
 
 static MLX5E_DEFINE_STATS_GRP(sw_rep, 0);
-- 
2.33.1

