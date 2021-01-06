Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775372EC583
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbhAFVHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:07:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbhAFVHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 16:07:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAF5B2332A;
        Wed,  6 Jan 2021 21:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609967232;
        bh=nf+3+I4jrYU1dTuxYoUkfqFHJxWhhbGt1Dw58iuwwhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JL+3zITJQeoSvyv6Vgt+AbbrRjJg7sm7T91igpG4Us2DFhupfRaZrrFWXw8ADb4r6
         WUArk3N3+AhZFcURIPiRqTukuadU5+vuJ8+ATU7BFXXL0Ur0IX5zRUfnl69OQ/uRUS
         0Fb8yzJzh9hjtVW0/zSyaHqojWMAjC18n1Nx1isnd00VS6wfEwMOYR7tq+ZdyqMuLa
         0WwqzBadBsLKAxy4R0p0LfEfD0DSSLC3Ox9pyRiOm+IY9lrNr7j4O88x1QsE9A0Nsl
         M6JNOHvQtJGaV8Kn0+CNg8nWNV4Lqmhd/VUT++L7whn3bS65BBTbRS2Y/D9sHT7hvG
         e0CN3xcWvezdw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, thomas.lendacky@amd.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        michael.chan@broadcom.com, rajur@chelsio.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, GR-Linux-NIC-Dev@marvell.com,
        ecree.xilinx@gmail.com, simon.horman@netronome.com,
        alexander.duyck@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/4] udp_tunnel: reshuffle NETIF_F_RX_UDP_TUNNEL_PORT checks
Date:   Wed,  6 Jan 2021 13:06:37 -0800
Message-Id: <20210106210637.1839662-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106210637.1839662-1-kuba@kernel.org>
References: <20210106210637.1839662-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the NETIF_F_RX_UDP_TUNNEL_PORT feature check into
udp_tunnel_nic_*_port() helpers, since they're always
done right before the call.

Add similar checks before calling the notifier.
udp_tunnel_nic invokes the notifier without checking
features which could result in some wasted cycles.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/udp_tunnel.h   |  8 ++++++++
 net/ipv4/udp_tunnel_core.c | 10 ----------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
index 2ea453dac876..282d10ee60e1 100644
--- a/include/net/udp_tunnel.h
+++ b/include/net/udp_tunnel.h
@@ -129,12 +129,16 @@ void udp_tunnel_notify_del_rx_port(struct socket *sock, unsigned short type);
 static inline void udp_tunnel_get_rx_info(struct net_device *dev)
 {
 	ASSERT_RTNL();
+	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+		return;
 	call_netdevice_notifiers(NETDEV_UDP_TUNNEL_PUSH_INFO, dev);
 }
 
 static inline void udp_tunnel_drop_rx_info(struct net_device *dev)
 {
 	ASSERT_RTNL();
+	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+		return;
 	call_netdevice_notifiers(NETDEV_UDP_TUNNEL_DROP_INFO, dev);
 }
 
@@ -323,6 +327,8 @@ udp_tunnel_nic_set_port_priv(struct net_device *dev, unsigned int table,
 static inline void
 udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
 {
+	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+		return;
 	if (udp_tunnel_nic_ops)
 		udp_tunnel_nic_ops->add_port(dev, ti);
 }
@@ -330,6 +336,8 @@ udp_tunnel_nic_add_port(struct net_device *dev, struct udp_tunnel_info *ti)
 static inline void
 udp_tunnel_nic_del_port(struct net_device *dev, struct udp_tunnel_info *ti)
 {
+	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
+		return;
 	if (udp_tunnel_nic_ops)
 		udp_tunnel_nic_ops->del_port(dev, ti);
 }
diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 376a085be7ed..b97e3635acf5 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -90,9 +90,6 @@ void udp_tunnel_push_rx_port(struct net_device *dev, struct socket *sock,
 	struct sock *sk = sock->sk;
 	struct udp_tunnel_info ti;
 
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
-		return;
-
 	ti.type = type;
 	ti.sa_family = sk->sk_family;
 	ti.port = inet_sk(sk)->inet_sport;
@@ -107,9 +104,6 @@ void udp_tunnel_drop_rx_port(struct net_device *dev, struct socket *sock,
 	struct sock *sk = sock->sk;
 	struct udp_tunnel_info ti;
 
-	if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
-		return;
-
 	ti.type = type;
 	ti.sa_family = sk->sk_family;
 	ti.port = inet_sk(sk)->inet_sport;
@@ -132,8 +126,6 @@ void udp_tunnel_notify_add_rx_port(struct socket *sock, unsigned short type)
 
 	rcu_read_lock();
 	for_each_netdev_rcu(net, dev) {
-		if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
-			continue;
 		udp_tunnel_nic_add_port(dev, &ti);
 	}
 	rcu_read_unlock();
@@ -154,8 +146,6 @@ void udp_tunnel_notify_del_rx_port(struct socket *sock, unsigned short type)
 
 	rcu_read_lock();
 	for_each_netdev_rcu(net, dev) {
-		if (!(dev->features & NETIF_F_RX_UDP_TUNNEL_PORT))
-			continue;
 		udp_tunnel_nic_del_port(dev, &ti);
 	}
 	rcu_read_unlock();
-- 
2.26.2

