Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D48730D7
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfGXOD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:03:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfGXOD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 10:03:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5FC7930833C1;
        Wed, 24 Jul 2019 14:03:58 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.205.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64F0B19C70;
        Wed, 24 Jul 2019 14:03:57 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] mlx4/en_netdev: update vlan features with tunnel offloads
Date:   Wed, 24 Jul 2019 16:02:53 +0200
Message-Id: <c3ccd45ee8742fb1a35fcfd41955907329e8112b.1563976690.git.dcaratti@redhat.com>
In-Reply-To: <cover.1563976690.git.dcaratti@redhat.com>
References: <cover.1563976690.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 24 Jul 2019 14:03:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ConnectX-3 Pro can offload transmission of VLAN packets with VXLAN inside:
enable tunnel offloads in dev->vlan_features, like it's done with other
NIC drivers (e.g. be2net and ixgbe).

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index c1438ae52a11..52500f744a0e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3415,6 +3415,17 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	if (mdev->LSO_support)
 		dev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
 
+	if (mdev->dev->caps.tunnel_offload_mode ==
+	    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
+		dev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
+				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
+				    NETIF_F_GSO_PARTIAL;
+		dev->features    |= NETIF_F_GSO_UDP_TUNNEL |
+				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
+				    NETIF_F_GSO_PARTIAL;
+		dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	}
+
 	dev->vlan_features = dev->hw_features;
 
 	dev->hw_features |= NETIF_F_RXCSUM | NETIF_F_RXHASH;
@@ -3483,16 +3494,6 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		priv->rss_hash_fn = ETH_RSS_HASH_TOP;
 	}
 
-	if (mdev->dev->caps.tunnel_offload_mode == MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
-		dev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_PARTIAL;
-		dev->features    |= NETIF_F_GSO_UDP_TUNNEL |
-				    NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				    NETIF_F_GSO_PARTIAL;
-		dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
-	}
-
 	/* MTU range: 68 - hw-specific max */
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = priv->max_mtu;
-- 
2.20.1

