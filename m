Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AFB77118
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 20:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbfGZSSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 14:18:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbfGZSSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 14:18:21 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DD7F307D974;
        Fri, 26 Jul 2019 18:18:21 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-199.brq.redhat.com [10.40.204.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9B425FC17;
        Fri, 26 Jul 2019 18:18:15 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2] mlx4/en_netdev: allow offloading VXLAN over VLAN
Date:   Fri, 26 Jul 2019 20:18:12 +0200
Message-Id: <2beb05557960e04aa588ecc09e9ee5e5a19fc651.1564164688.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 26 Jul 2019 18:18:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ConnectX-3 Pro can offload transmission of VLAN packets with VXLAN inside:
enable tunnel offloads in dev->vlan_features, like it's done with other
NIC drivers (e.g. be2net and ixgbe).

It's no more necessary to change dev->hw_enc_features when VXLAN are added
or removed, since .ndo_features_check() already checks for VXLAN packet
where the UDP destination port matches the configured value. Just set
dev->hw_enc_features when the NIC is initialized, so that overlying VLAN
can correctly inherit the tunnel offload capabilities.

Changes since v1:
- avoid flipping hw_enc_features, instead of calling netdev notifiers,
  thanks to Saeed Mahameed
- squash two patches into a single one

CC: Paolo Abeni <pabeni@redhat.com>
CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 43 ++++++++-----------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index c1438ae52a11..40ec5acf79c0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2645,14 +2645,6 @@ static void mlx4_en_add_vxlan_offloads(struct work_struct *work)
 		en_err(priv, "failed setting L2 tunnel configuration ret %d\n", ret);
 		return;
 	}
-
-	/* set offloads */
-	priv->dev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				      NETIF_F_RXCSUM |
-				      NETIF_F_TSO | NETIF_F_TSO6 |
-				      NETIF_F_GSO_UDP_TUNNEL |
-				      NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				      NETIF_F_GSO_PARTIAL;
 }
 
 static void mlx4_en_del_vxlan_offloads(struct work_struct *work)
@@ -2660,14 +2652,6 @@ static void mlx4_en_del_vxlan_offloads(struct work_struct *work)
 	int ret;
 	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
 						 vxlan_del_task);
-	/* unset offloads */
-	priv->dev->hw_enc_features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-					NETIF_F_RXCSUM |
-					NETIF_F_TSO | NETIF_F_TSO6 |
-					NETIF_F_GSO_UDP_TUNNEL |
-					NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_PARTIAL);
-
 	ret = mlx4_SET_PORT_VXLAN(priv->mdev->dev, priv->port,
 				  VXLAN_STEER_BY_OUTER_MAC, 0);
 	if (ret)
@@ -3415,6 +3399,23 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
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
+		dev->hw_enc_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
+				       NETIF_F_RXCSUM |
+				       NETIF_F_TSO | NETIF_F_TSO6 |
+				       NETIF_F_GSO_UDP_TUNNEL |
+				       NETIF_F_GSO_UDP_TUNNEL_CSUM |
+				       NETIF_F_GSO_PARTIAL;
+	}
+
 	dev->vlan_features = dev->hw_features;
 
 	dev->hw_features |= NETIF_F_RXCSUM | NETIF_F_RXHASH;
@@ -3483,16 +3484,6 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
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

