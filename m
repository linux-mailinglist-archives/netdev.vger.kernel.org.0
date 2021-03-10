Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F68733477A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbhCJTE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233737AbhCJTD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE2DB64FD2;
        Wed, 10 Mar 2021 19:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403038;
        bh=ZUjyA8N+pMuQlyM89SMlb2F8eUQlUOx8diIbUALvw4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERlBwGUS20ZpVFhXX6qqKoRjOFn7jdgP3MleISHg6AhdQpmAotJJxY9ui3RHSZkyZ
         etxtkFXYRHcmmCYdoKXDeblrHsTzQ9X7LywlpYA8ei+lYQhJ5aaRbqnIt0aMn1xEVq
         r8sIabiuKfUOOujui22V3iRM8mPGXXb05Q2xxOEJAQZZZZvG9qSTTYg7ThHl6ekdEZ
         mOpeND81ysVI/FfCKbkcwWqVP1c6KBxPwColgz7JsnN0G5Qy6zdqKFPmLUXlUpqbyO
         17WLUK8WebAvnK674XEcQb2BZ4Ll6LEEIUyW/5wB3YAR+B6swd+Agx9ZUwpe+8Zw66
         Y5n7s5g+28Z6Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/18] net/mlx5e: Check correct ip_version in decapsulation route resolution
Date:   Wed, 10 Mar 2021 11:03:33 -0800
Message-Id: <20210310190342.238957-10-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

flow_attr->ip_version has the matching that should be done inner/outer.
When working with chains, decapsulation is done on chain0 and next chain
match on outer header which is the original inner which could be ipv4.
So in tunnel route resolution we cannot use that to know which ip version
we are at so save tun_ip_version when parsing the tunnel match and use
that.

Fixes: a508728a4c8b ("net/mlx5e: VF tunnel RX traffic offloading")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c       | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h           | 1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index f8075a604605..172e0474f2e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -685,14 +685,14 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 	u16 vport_num;
 	int err = 0;
 
-	if (flow_attr->ip_version == 4) {
+	if (flow_attr->tun_ip_version == 4) {
 		/* Addresses are swapped for decap */
 		attr.fl.fl4.saddr = esw_attr->rx_tun_attr->dst_ip.v4;
 		attr.fl.fl4.daddr = esw_attr->rx_tun_attr->src_ip.v4;
 		err = mlx5e_route_lookup_ipv4_get(priv, priv->netdev, &attr);
 	}
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
-	else if (flow_attr->ip_version == 6) {
+	else if (flow_attr->tun_ip_version == 6) {
 		/* Addresses are swapped for decap */
 		attr.fl.fl6.saddr = esw_attr->rx_tun_attr->dst_ip.v6;
 		attr.fl.fl6.daddr = esw_attr->rx_tun_attr->src_ip.v6;
@@ -718,10 +718,10 @@ int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
 	esw_attr->rx_tun_attr->decap_vport = vport_num;
 
 out:
-	if (flow_attr->ip_version == 4)
+	if (flow_attr->tun_ip_version == 4)
 		mlx5e_route_lookup_ipv4_put(&attr);
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
-	else if (flow_attr->ip_version == 6)
+	else if (flow_attr->tun_ip_version == 6)
 		mlx5e_route_lookup_ipv6_put(&attr);
 #endif
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 6a116335bb21..7f7b0f6dcdf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -89,6 +89,7 @@ int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
 	 * required to establish routing.
 	 */
 	flow_flag_set(flow, TUN_RX);
+	flow->attr->tun_ip_version = ip_version;
 	return 0;
 }
 
@@ -1091,7 +1092,7 @@ int mlx5e_attach_decap_route(struct mlx5e_priv *priv,
 	if (err || !esw_attr->rx_tun_attr->decap_vport)
 		goto out;
 
-	key.ip_version = attr->ip_version;
+	key.ip_version = attr->tun_ip_version;
 	if (key.ip_version == 4)
 		key.endpoint_ip.v4 = esw_attr->rx_tun_attr->dst_ip.v4;
 	else
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 89003ae7775a..25c091795bcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -79,6 +79,7 @@ struct mlx5_flow_attr {
 	u8 inner_match_level;
 	u8 outer_match_level;
 	u8 ip_version;
+	u8 tun_ip_version;
 	u32 flags;
 	union {
 		struct mlx5_esw_flow_attr esw_attr[0];
-- 
2.29.2

