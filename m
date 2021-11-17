Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D20E453F8F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhKQEhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:41540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhKQEhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A633361BE1;
        Wed, 17 Nov 2021 04:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123651;
        bh=NsDOG6DqPNkMKyL/zwFn1yXusXgVPnQ86j1ohVmul50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EaiKZ32IqGMXB7QeI688lkjJmJKl9bqW9BQtIB3ycBXyIp9g+YSwcDIkg5NC4Aac3
         N9IEMNDmv0zCl37icyW3mhnmGmEmx85COZPjH31LzvMaxFODAsUt2ocU4qqgBi1tXv
         Q/S7p4rGM6N8IQ++MG7Svr4oPqOplo+SkJOPJgpIazevIswCCXdwBsl+mXJ2bzxXM7
         ZSmlSA6+tYqhLaIBscp2abcL0jXBXW5K9DDakDacEVUL6mDX/FUZYqTLC6151x0PT0
         bitX9y16s1JVegNEF/H8jmthMqSHGNGlt3kxEkA0wAMOpvXP4NYBlIoruDN5JF5u97
         iYDtAV2J90znA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 10/15] net/mlx5e: Specify out ifindex when looking up decap route
Date:   Tue, 16 Nov 2021 20:33:52 -0800
Message-Id: <20211117043357.345072-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

There is a use case that the local and remote VTEPs are in the same
host. Currently, the out ifindex is not specified when looking up the
decap route for offloads. So in this case, a local route is returned
and the route dev is lo.

Actual tunnel interface can be created with a parameter "dev" [1],
which specifies the physical device to use for tunnel endpoint
communication. Pass this parameter to driver when looking up decap
route for offloads. So that a unicast route will be returned.

[1] ip link add name vxlan1 type vxlan id 100 dev enp4s0f0 remote 1.1.1.1 dstport 4789

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 23 ++++++++++---------
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 ++-
 .../mellanox/mlx5/core/en/tc_tun_encap.c      |  4 ++--
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index a5e450973225..33815246fead 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -103,7 +103,7 @@ static int get_route_and_out_devs(struct mlx5e_priv *priv,
 }
 
 static int mlx5e_route_lookup_ipv4_get(struct mlx5e_priv *priv,
-				       struct net_device *mirred_dev,
+				       struct net_device *dev,
 				       struct mlx5e_tc_tun_route_attr *attr)
 {
 	struct net_device *route_dev;
@@ -122,13 +122,13 @@ static int mlx5e_route_lookup_ipv4_get(struct mlx5e_priv *priv,
 		uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
 		attr->fl.fl4.flowi4_oif = uplink_dev->ifindex;
 	} else {
-		struct mlx5e_tc_tunnel *tunnel = mlx5e_get_tc_tun(mirred_dev);
+		struct mlx5e_tc_tunnel *tunnel = mlx5e_get_tc_tun(dev);
 
 		if (tunnel && tunnel->get_remote_ifindex)
-			attr->fl.fl4.flowi4_oif = tunnel->get_remote_ifindex(mirred_dev);
+			attr->fl.fl4.flowi4_oif = tunnel->get_remote_ifindex(dev);
 	}
 
-	rt = ip_route_output_key(dev_net(mirred_dev), &attr->fl.fl4);
+	rt = ip_route_output_key(dev_net(dev), &attr->fl.fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
@@ -440,10 +440,10 @@ int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
 
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 static int mlx5e_route_lookup_ipv6_get(struct mlx5e_priv *priv,
-				       struct net_device *mirred_dev,
+				       struct net_device *dev,
 				       struct mlx5e_tc_tun_route_attr *attr)
 {
-	struct mlx5e_tc_tunnel *tunnel = mlx5e_get_tc_tun(mirred_dev);
+	struct mlx5e_tc_tunnel *tunnel = mlx5e_get_tc_tun(dev);
 	struct net_device *route_dev;
 	struct net_device *out_dev;
 	struct dst_entry *dst;
@@ -451,8 +451,8 @@ static int mlx5e_route_lookup_ipv6_get(struct mlx5e_priv *priv,
 	int ret;
 
 	if (tunnel && tunnel->get_remote_ifindex)
-		attr->fl.fl6.flowi6_oif = tunnel->get_remote_ifindex(mirred_dev);
-	dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(mirred_dev), NULL, &attr->fl.fl6,
+		attr->fl.fl6.flowi6_oif = tunnel->get_remote_ifindex(dev);
+	dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(dev), NULL, &attr->fl.fl6,
 					      NULL);
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
@@ -708,7 +708,8 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 
 int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 			      struct mlx5_flow_spec *spec,
-			      struct mlx5_flow_attr *flow_attr)
+			      struct mlx5_flow_attr *flow_attr,
+			      struct net_device *filter_dev)
 {
 	struct mlx5_esw_flow_attr *esw_attr = flow_attr->esw_attr;
 	struct mlx5e_tc_int_port *int_port;
@@ -720,14 +721,14 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 		/* Addresses are swapped for decap */
 		attr.fl.fl4.saddr = esw_attr->rx_tun_attr->dst_ip.v4;
 		attr.fl.fl4.daddr = esw_attr->rx_tun_attr->src_ip.v4;
-		err = mlx5e_route_lookup_ipv4_get(priv, priv->netdev, &attr);
+		err = mlx5e_route_lookup_ipv4_get(priv, filter_dev, &attr);
 	}
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 	else if (flow_attr->tun_ip_version == 6) {
 		/* Addresses are swapped for decap */
 		attr.fl.fl6.saddr = esw_attr->rx_tun_attr->dst_ip.v6;
 		attr.fl.fl6.daddr = esw_attr->rx_tun_attr->src_ip.v6;
-		err = mlx5e_route_lookup_ipv6_get(priv, priv->netdev, &attr);
+		err = mlx5e_route_lookup_ipv6_get(priv, filter_dev, &attr);
 	}
 #endif
 	else
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index aa092eaeaec3..b38f693bbb52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -94,7 +94,8 @@ mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 #endif
 int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 			      struct mlx5_flow_spec *spec,
-			      struct mlx5_flow_attr *attr);
+			      struct mlx5_flow_attr *attr,
+			      struct net_device *filter_dev);
 
 bool mlx5e_tc_tun_device_to_offload(struct mlx5e_priv *priv,
 				    struct net_device *netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 660cca73c36c..de16bbc08679 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1153,7 +1153,7 @@ int mlx5e_attach_decap_route(struct mlx5e_priv *priv,
 
 	tbl_time_before = mlx5e_route_tbl_get_last_update(priv);
 	tbl_time_after = tbl_time_before;
-	err = mlx5e_tc_tun_route_lookup(priv, &parse_attr->spec, attr);
+	err = mlx5e_tc_tun_route_lookup(priv, &parse_attr->spec, attr, parse_attr->filter_dev);
 	if (err || !esw_attr->rx_tun_attr->decap_vport)
 		goto out;
 
@@ -1474,7 +1474,7 @@ static void mlx5e_reoffload_decap(struct mlx5e_priv *priv,
 
 		parse_attr = attr->parse_attr;
 		spec = &parse_attr->spec;
-		err = mlx5e_tc_tun_route_lookup(priv, spec, attr);
+		err = mlx5e_tc_tun_route_lookup(priv, spec, attr, parse_attr->filter_dev);
 		if (err) {
 			mlx5_core_warn(priv->mdev, "Failed to lookup route for flow, %d\n",
 				       err);
-- 
2.31.1

