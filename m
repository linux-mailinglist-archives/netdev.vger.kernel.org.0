Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBAE421B97
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhJEBQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhJEBQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4400361458;
        Tue,  5 Oct 2021 01:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396486;
        bh=c1YYo1ZxEUw5t4Krl0AgURJMkA/HvDWAdVCi2ZfnTp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i81dmtXJk0azrRNVkCF6eM9Cim1pTv2PSrW893JE6WJTvx8t5By8/uTA4csFQK1uJ
         ZyXV7xOH20BvaSru0DPePEbUWBOiiUMdTnP+FEz4QNdLujoaS1aW4rVMMuHWeh3QEa
         QvAd7NnCW78HghJl9JOaAPr9xcCK3KDUYQw8UkVPYL0EeLC0L6LtJjbpn2VITTyUBT
         +kwX4d2M4pjtuu0QVceojhnK+T5LgHDRz+iWYuBCbMj1vdSiDp84Dq1gUFShwyolL5
         A5rmOD15zQWemzbENHHsWCcSCWDFpk5QdQWAsN2PLwA0hYQZv6slNsT0BsrJe2k3WO
         vEUafmKcQ/kZA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Specify out ifindex when looking up encap route
Date:   Mon,  4 Oct 2021 18:12:55 -0700
Message-Id: <20211005011302.41793-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

There is a use case that the local and remote VTEPs are in the same
host. Currently, the out ifindex is not specified when looking up the
encap route for offloads. So in this case, a local route is returned
and the route dev is lo.

Actual tunnel interface can be created with a parameter "dev" [1],
which specifies the physical device to use for tunnel endpoint
communication. Pass this parameter to driver when looking up encap
route for offloads. So that a unicast route will be returned.

[1] ip link add name vxlan1 type vxlan id 100 dev enp4s0f0 remote 1.1.1.1 dstport 4789

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c      | 8 ++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h      | 1 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c    | 9 +++++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index b4e986818794..cc7d7b895b80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -118,6 +118,11 @@ static int mlx5e_route_lookup_ipv4_get(struct mlx5e_priv *priv,
 
 		uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
 		attr->fl.fl4.flowi4_oif = uplink_dev->ifindex;
+	} else {
+		struct mlx5e_tc_tunnel *tunnel = mlx5e_get_tc_tun(mirred_dev);
+
+		if (tunnel && tunnel->get_remote_ifindex)
+			attr->fl.fl4.flowi4_oif = tunnel->get_remote_ifindex(mirred_dev);
 	}
 
 	rt = ip_route_output_key(dev_net(mirred_dev), &attr->fl.fl4);
@@ -435,12 +440,15 @@ static int mlx5e_route_lookup_ipv6_get(struct mlx5e_priv *priv,
 				       struct net_device *mirred_dev,
 				       struct mlx5e_tc_tun_route_attr *attr)
 {
+	struct mlx5e_tc_tunnel *tunnel = mlx5e_get_tc_tun(mirred_dev);
 	struct net_device *route_dev;
 	struct net_device *out_dev;
 	struct dst_entry *dst;
 	struct neighbour *n;
 	int ret;
 
+	if (tunnel && tunnel->get_remote_ifindex)
+		attr->fl.fl6.flowi6_oif = tunnel->get_remote_ifindex(mirred_dev);
 	dst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(mirred_dev), NULL, &attr->fl.fl6,
 					      NULL);
 	if (IS_ERR(dst))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 9350ca05ce65..aa092eaeaec3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -51,6 +51,7 @@ struct mlx5e_tc_tunnel {
 			    void *headers_v);
 	bool (*encap_info_equal)(struct mlx5e_encap_key *a,
 				 struct mlx5e_encap_key *b);
+	int (*get_remote_ifindex)(struct net_device *mirred_dev);
 };
 
 extern struct mlx5e_tc_tunnel vxlan_tunnel;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 4267f3a1059e..fd07c4cbfd1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -141,6 +141,14 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static int mlx5e_tc_tun_get_remote_ifindex(struct net_device *mirred_dev)
+{
+	const struct vxlan_dev *vxlan = netdev_priv(mirred_dev);
+	const struct vxlan_rdst *dst = &vxlan->default_dst;
+
+	return dst->remote_ifindex;
+}
+
 struct mlx5e_tc_tunnel vxlan_tunnel = {
 	.tunnel_type          = MLX5E_TC_TUNNEL_TYPE_VXLAN,
 	.match_level          = MLX5_MATCH_L4,
@@ -151,4 +159,5 @@ struct mlx5e_tc_tunnel vxlan_tunnel = {
 	.parse_udp_ports      = mlx5e_tc_tun_parse_udp_ports_vxlan,
 	.parse_tunnel         = mlx5e_tc_tun_parse_vxlan,
 	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_generic,
+	.get_remote_ifindex   = mlx5e_tc_tun_get_remote_ifindex,
 };
-- 
2.31.1

