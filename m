Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92FF486F4E
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344177AbiAGA7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344922AbiAGA6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A914C06118A
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52C37B8249D
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27A3C36AE3;
        Fri,  7 Jan 2022 00:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517126;
        bh=aWR0F5rmA3k1EH4P/OkRALPNRqFBKvPqNf9DqOGaA8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+L24UBsIUXWIgx5Z5BQBkeQKoynvjXcF76mN3YXgsrC4MkR3RPMNi85xV619vgLP
         sAy/aAWE38sZ960JAbCBFtuFG2THL/lsuprY0oYAqb0VrfDP4ctwfcJcZR/pr6i4I3
         mYzTYtGXkEstoVWnIvXrjce33QrCpLks6AV28VhGwPLvcwRItF7SONLo/p2qStwOyB
         niDd0+Cfq83OvTenoBTqKznJMzBdhzJiVyX/FypIlWJby8BIMYIaJnUQilYTttTGUy
         tjUTTPfR7inAQFnw140KAsSQp3NpxQaRytZbKnY16MOvcfGaEZa+7e4p/A/wLKXG5a
         wwKVh2HLWN//A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/11] Revert "net/mlx5e: Block offload of outer header csum for UDP tunnels"
Date:   Thu,  6 Jan 2022 16:58:25 -0800
Message-Id: <20220107005831.78909-6-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

This reverts commit 6d6727dddc7f93fcc155cb8d0c49c29ae0e71122.

Although the NIC doesn't support offload of outer header CSUM, using
gso_partial_features allows offloading the tunnel's segmentation. The
driver relies on the stack CSUM calculation of the outer header. For
this, NETIF_F_GSO_UDP_TUNNEL_CSUM must be a member of the device's
features.

Fixes: 6d6727dddc7f ("net/mlx5e: Block offload of outer header csum for UDP tunnels")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 41379844eee1..de8acd3217c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4789,9 +4789,13 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev)) {
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL |
+					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL |
+					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL |
+					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-- 
2.33.1

