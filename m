Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B772EC580
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbhAFVHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbhAFVHu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 16:07:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D21172313E;
        Wed,  6 Jan 2021 21:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609967229;
        bh=5BRwOShLYCsI24mD5+HOeWoxDkgwu1U8cqfOSj3IOWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbluE49bFDF8n0oe7ykr71rPqfdOGTZ3n4+WFW/kqSqgogiF3hU84mo6Ih4yHBRSw
         bZym2+9SsTl70WlC+ilQopo8st4b1i4Nn749PDhevlRwqno09xfRuWm+JhPVprMvIw
         K23j5NogncyoODZTvoJMDfw+OPfoZqnfUS6+cH3tT2H/v2htRO1CeojV6+9XnSABhC
         pqr8k/hb+LNumDrvYy1ADLJtBnhy+/kK68v/AgW25E7bSmUvdqwGALx8GBWby7aCMH
         4QLsMKpq+vWpPqsDHqCGElvduPg+K2jXWgI8iVPyOzeA/+90NqXJ0fwZ5fDyxnPevn
         t04o8rtYXLdDQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, thomas.lendacky@amd.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        michael.chan@broadcom.com, rajur@chelsio.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, GR-Linux-NIC-Dev@marvell.com,
        ecree.xilinx@gmail.com, simon.horman@netronome.com,
        alexander.duyck@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/4] udp_tunnel: hard-wire NDOs to udp_tunnel_nic_*_port() helpers
Date:   Wed,  6 Jan 2021 13:06:34 -0800
Message-Id: <20210106210637.1839662-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106210637.1839662-1-kuba@kernel.org>
References: <20210106210637.1839662-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All drivers use udp_tunnel_nic_*_port() helpers, prepare for
NDO removal by invoking those helpers directly.

The helpers are safe to call on all devices, they check if
device has the UDP tunnel state initialized.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c             |  2 +-
 net/ipv4/udp_tunnel_core.c | 18 ++++++------------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8fa739259041..7afbb642e203 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10002,7 +10002,7 @@ int register_netdevice(struct net_device *dev)
 	dev->hw_features |= (NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF);
 	dev->features |= NETIF_F_SOFT_FEATURES;
 
-	if (dev->netdev_ops->ndo_udp_tunnel_add) {
+	if (dev->udp_tunnel_nic_info) {
 		dev->features |= NETIF_F_RX_UDP_TUNNEL_PORT;
 		dev->hw_features |= NETIF_F_RX_UDP_TUNNEL_PORT;
 	}
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 3eecba0874aa..376a085be7ed 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -90,15 +90,14 @@ void udp_tunnel_push_rx_port(struct net_device *dev, struct socket *sock,
 	struct sock *sk = sock->sk;
 	struct udp_tunnel_info ti;
 
-	if (!dev->netdev_ops->ndo_udp_tunnel_add ||
-	    !(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
 		return;
 
 	ti.type = type;
 	ti.sa_family = sk->sk_family;
 	ti.port = inet_sk(sk)->inet_sport;
 
-	dev->netdev_ops->ndo_udp_tunnel_add(dev, &ti);
+	udp_tunnel_nic_add_port(dev, &ti);
 }
 EXPORT_SYMBOL_GPL(udp_tunnel_push_rx_port);
 
@@ -108,15 +107,14 @@ void udp_tunnel_drop_rx_port(struct net_device *dev, struct socket *sock,
 	struct sock *sk = sock->sk;
 	struct udp_tunnel_info ti;
 
-	if (!dev->netdev_ops->ndo_udp_tunnel_del ||
-	    !(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
 		return;
 
 	ti.type = type;
 	ti.sa_family = sk->sk_family;
 	ti.port = inet_sk(sk)->inet_sport;
 
-	dev->netdev_ops->ndo_udp_tunnel_del(dev, &ti);
+	udp_tunnel_nic_del_port(dev, &ti);
 }
 EXPORT_SYMBOL_GPL(udp_tunnel_drop_rx_port);
 
@@ -134,11 +132,9 @@ void udp_tunnel_notify_add_rx_port(struct socket *sock, unsigned short type)
 
 	rcu_read_lock();
 	for_each_netdev_rcu(net, dev) {
-		if (!dev->netdev_ops->ndo_udp_tunnel_add)
-			continue;
 		if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
 			continue;
-		dev->netdev_ops->ndo_udp_tunnel_add(dev, &ti);
+		udp_tunnel_nic_add_port(dev, &ti);
 	}
 	rcu_read_unlock();
 }
@@ -158,11 +154,9 @@ void udp_tunnel_notify_del_rx_port(struct socket *sock, unsigned short type)
 
 	rcu_read_lock();
 	for_each_netdev_rcu(net, dev) {
-		if (!dev->netdev_ops->ndo_udp_tunnel_del)
-			continue;
 		if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
 			continue;
-		dev->netdev_ops->ndo_udp_tunnel_del(dev, &ti);
+		udp_tunnel_nic_del_port(dev, &ti);
 	}
 	rcu_read_unlock();
 }
-- 
2.26.2

