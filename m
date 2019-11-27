Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1085810B026
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfK0N13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:27:29 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:56354 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbfK0N12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 08:27:28 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7F7B6D52F418488E1238;
        Wed, 27 Nov 2019 21:27:26 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 27 Nov 2019
 21:27:19 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <saeedm@mellanox.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <eli@mellanox.com>, <roid@mellanox.com>, <elibr@mellanox.com>,
        <kliteyn@mellanox.com>, <ozsh@mellanox.com>, <pablo@netfilter.org>,
        <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/mlx5e: Fix build error without IPV6
Date:   Wed, 27 Nov 2019 21:27:00 +0800
Message-ID: <20191127132700.25872-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IPV6 is not set and CONFIG_MLX5_ESWITCH is y,
building fails:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:322:5: error: redefinition of mlx5e_tc_tun_create_header_ipv6
 int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:7:0:
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:67:1: note: previous definition of mlx5e_tc_tun_create_header_ipv6 was here
 mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use #ifdef to guard this, also move mlx5e_route_lookup_ipv6
to cleanup unused warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e689e998e102 ("net/mlx5e: TC, Stub out ipv6 tun create header function")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 74 +++++++++++-----------
 1 file changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 784b1e2..6ed8753 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -130,42 +130,6 @@ static const char *mlx5e_netdev_kind(struct net_device *dev)
 		return "unknown";
 }
 
-static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
-				   struct net_device *mirred_dev,
-				   struct net_device **out_dev,
-				   struct net_device **route_dev,
-				   struct flowi6 *fl6,
-				   struct neighbour **out_n,
-				   u8 *out_ttl)
-{
-	struct dst_entry *dst;
-	struct neighbour *n;
-
-	int ret;
-
-	ret = ipv6_stub->ipv6_dst_lookup(dev_net(mirred_dev), NULL, &dst,
-					 fl6);
-	if (ret < 0)
-		return ret;
-
-	if (!(*out_ttl))
-		*out_ttl = ip6_dst_hoplimit(dst);
-
-	ret = get_route_and_out_devs(priv, dst->dev, route_dev, out_dev);
-	if (ret < 0) {
-		dst_release(dst);
-		return ret;
-	}
-
-	n = dst_neigh_lookup(dst, &fl6->daddr);
-	dst_release(dst);
-	if (!n)
-		return -ENOMEM;
-
-	*out_n = n;
-	return 0;
-}
-
 static int mlx5e_gen_ip_tunnel_header(char buf[], __u8 *ip_proto,
 				      struct mlx5e_encap_entry *e)
 {
@@ -319,6 +283,43 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	return err;
 }
 
+#if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
+static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *priv,
+				   struct net_device *mirred_dev,
+				   struct net_device **out_dev,
+				   struct net_device **route_dev,
+				   struct flowi6 *fl6,
+				   struct neighbour **out_n,
+				   u8 *out_ttl)
+{
+	struct dst_entry *dst;
+	struct neighbour *n;
+
+	int ret;
+
+	ret = ipv6_stub->ipv6_dst_lookup(dev_net(mirred_dev), NULL, &dst,
+					 fl6);
+	if (ret < 0)
+		return ret;
+
+	if (!(*out_ttl))
+		*out_ttl = ip6_dst_hoplimit(dst);
+
+	ret = get_route_and_out_devs(priv, dst->dev, route_dev, out_dev);
+	if (ret < 0) {
+		dst_release(dst);
+		return ret;
+	}
+
+	n = dst_neigh_lookup(dst, &fl6->daddr);
+	dst_release(dst);
+	if (!n)
+		return -ENOMEM;
+
+	*out_n = n;
+	return 0;
+}
+
 int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 				    struct net_device *mirred_dev,
 				    struct mlx5e_encap_entry *e)
@@ -436,6 +437,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	neigh_release(n);
 	return err;
 }
+#endif
 
 bool mlx5e_tc_tun_device_to_offload(struct mlx5e_priv *priv,
 				    struct net_device *netdev)
-- 
2.7.4


