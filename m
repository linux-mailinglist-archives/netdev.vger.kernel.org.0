Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0FBE730D8
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbfGXOEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:04:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbfGXOEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 10:04:00 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D695B5859E;
        Wed, 24 Jul 2019 14:03:59 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.205.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C14E519C67;
        Wed, 24 Jul 2019 14:03:58 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] mlx4/en_netdev: call notifiers when hw_enc_features change
Date:   Wed, 24 Jul 2019 16:02:54 +0200
Message-Id: <e157af6e79d9385df37444d817cf3c166878c8f6.1563976690.git.dcaratti@redhat.com>
In-Reply-To: <cover.1563976690.git.dcaratti@redhat.com>
References: <cover.1563976690.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 24 Jul 2019 14:03:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ensure to call netdev_features_change() when the driver flips its
hw_enc_features bits.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 39 ++++++++++++-------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 52500f744a0e..1b484dc6e1c2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2628,6 +2628,30 @@ static int mlx4_en_get_phys_port_id(struct net_device *dev,
 	return 0;
 }
 
+#define MLX4_GSO_PARTIAL_FEATURES (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM | \
+				   NETIF_F_RXCSUM | \
+				   NETIF_F_TSO | NETIF_F_TSO6 | \
+				   NETIF_F_GSO_UDP_TUNNEL | \
+				   NETIF_F_GSO_UDP_TUNNEL_CSUM | \
+				   NETIF_F_GSO_PARTIAL)
+
+static void mlx4_set_vxlan_offloads(struct net_device *dev, bool enable)
+{
+	netdev_features_t hw_enc_features;
+
+	rtnl_lock();
+	hw_enc_features = dev->hw_enc_features;
+	if (enable)
+		dev->hw_enc_features |= MLX4_GSO_PARTIAL_FEATURES;
+	else
+		dev->hw_enc_features &= ~MLX4_GSO_PARTIAL_FEATURES;
+
+	if (hw_enc_features ^ dev->hw_enc_features)
+		netdev_features_change(dev);
+
+	rtnl_unlock();
+}
+
 static void mlx4_en_add_vxlan_offloads(struct work_struct *work)
 {
 	int ret;
@@ -2647,12 +2671,7 @@ static void mlx4_en_add_vxlan_offloads(struct work_struct *work)
 	}
 
 	/* set offloads */
-	priv->dev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				      NETIF_F_RXCSUM |
-				      NETIF_F_TSO | NETIF_F_TSO6 |
-				      NETIF_F_GSO_UDP_TUNNEL |
-				      NETIF_F_GSO_UDP_TUNNEL_CSUM |
-				      NETIF_F_GSO_PARTIAL;
+	mlx4_set_vxlan_offloads(priv->dev, true);
 }
 
 static void mlx4_en_del_vxlan_offloads(struct work_struct *work)
@@ -2661,13 +2680,7 @@ static void mlx4_en_del_vxlan_offloads(struct work_struct *work)
 	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
 						 vxlan_del_task);
 	/* unset offloads */
-	priv->dev->hw_enc_features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-					NETIF_F_RXCSUM |
-					NETIF_F_TSO | NETIF_F_TSO6 |
-					NETIF_F_GSO_UDP_TUNNEL |
-					NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_PARTIAL);
-
+	mlx4_set_vxlan_offloads(priv->dev, false);
 	ret = mlx4_SET_PORT_VXLAN(priv->mdev->dev, priv->port,
 				  VXLAN_STEER_BY_OUTER_MAC, 0);
 	if (ret)
-- 
2.20.1

