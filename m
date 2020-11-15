Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27602B3517
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 14:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgKONnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 08:43:22 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41363 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726900AbgKONnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 08:43:21 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 15 Nov 2020 15:43:14 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AFDhDYR028844;
        Sun, 15 Nov 2020 15:43:13 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: [PATCH net-next 2/2] bond: Add TLS TX offload support
Date:   Sun, 15 Nov 2020 15:42:51 +0200
Message-Id: <20201115134251.4272-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201115134251.4272-1-tariqt@nvidia.com>
References: <20201115134251.4272-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement TLS TX device offload for bonding interfaces.
This allows kTLS sockets running on a bond to benefit from the
device offload on capable slaves.

To allow a simple and fast maintenance of the TLS context in SW and
slaves devices, we bind the TLS socket to a specific slave in
the tls_dev_add operation.
To acheive a behavior similar to SW kTLS, we support only balance-xor
and 802.3ad modes, with xmit_hash_policy=layer3+4.
For the above configuration, the SW implementation keeps picking the
same exact slave for all the socket's SKBs.

We keep the bond feature bit independent from the slaves bits.
In case a non-capable slave is picked, the socket falls-back to
SW kTLS.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 drivers/net/bonding/bond_main.c    | 203 ++++++++++++++++++++++++++++-
 drivers/net/bonding/bond_options.c |  10 +-
 include/net/bonding.h              |   4 +
 3 files changed, 210 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 71c9677d135f..ed6d70e80ce9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -83,6 +83,9 @@
 #include <net/bonding.h>
 #include <net/bond_3ad.h>
 #include <net/bond_alb.h>
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+#include <net/tls.h>
+#endif
 
 #include "bonding_priv.h"
 
@@ -301,6 +304,17 @@ netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
 	return dev_queue_xmit(skb);
 }
 
+static u32 bond_hash_ip(u32 hash, struct flow_keys *flow)
+{
+	hash ^= (__force u32)flow_get_u32_dst(flow) ^
+		(__force u32)flow_get_u32_src(flow);
+	hash ^= (hash >> 16);
+	hash ^= (hash >> 8);
+
+	/* discard lowest hash bit to deal with the common even ports pattern */
+	return hash >> 1;
+}
+
 /*---------------------------------- VLAN -----------------------------------*/
 
 /* In the following 2 functions, bond_vlan_rx_add_vid and bond_vlan_rx_kill_vid,
@@ -467,6 +481,143 @@ static const struct xfrmdev_ops bond_xfrmdev_ops = {
 };
 #endif /* CONFIG_XFRM_OFFLOAD */
 
+/*---------------------------------- TLS ------------------------------------*/
+
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+/**
+ * bond_sk_hash_l34 - generate a hash value based on the socket's L3 and L4 fields
+ * @sk: socket to use for headers
+ *
+ * This function will extract the necessary field from the socket and use
+ * them to generate a hash based on the LAYER34 xmit_policy.
+ * Assumes that sk is a TCP or UDP socket.
+ */
+static u32 bond_sk_hash_l34(struct sock *sk)
+{
+	struct flow_keys flow = {};
+	u32 hash;
+
+	switch (sk->sk_family) {
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		if (sk->sk_ipv6only ||
+		    ipv6_addr_type(&sk->sk_v6_daddr) != IPV6_ADDR_MAPPED) {
+			flow.control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+			flow.addrs.v6addrs.src = inet6_sk(sk)->saddr;
+			flow.addrs.v6addrs.dst = sk->sk_v6_daddr;
+			break;
+		}
+		fallthrough;
+#endif
+	default: /* AF_INET */
+		flow.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		flow.addrs.v4addrs.src = inet_sk(sk)->inet_rcv_saddr;
+		flow.addrs.v4addrs.dst = inet_sk(sk)->inet_daddr;
+		break;
+	}
+
+	flow.ports.src = inet_sk(sk)->inet_sport;
+	flow.ports.dst = inet_sk(sk)->inet_dport;
+
+	memcpy(&hash, &flow.ports.ports, sizeof(hash));
+
+	return bond_hash_ip(hash, &flow);
+}
+
+static struct slave *bond_sk_3ad_xor_slave_get(struct bonding *bond, struct sock *sk)
+{
+	struct bond_up_slave *slaves;
+	unsigned int count;
+	u32 hash;
+
+	if (bond->params.xmit_policy != BOND_XMIT_POLICY_LAYER34)
+		return NULL;
+
+	slaves = rcu_dereference(bond->usable_slaves);
+	count = slaves ? READ_ONCE(slaves->count) : 0;
+	if (unlikely(!count))
+		return NULL;
+
+	hash = bond_sk_hash_l34(sk);
+	return slaves->arr[hash % count];
+}
+
+static struct net_device *bond_sk_get_slave_dev(struct bonding *bond, struct sock *sk)
+{
+	struct slave *slave = NULL;
+
+	switch (BOND_MODE(bond)) {
+	case BOND_MODE_8023AD:
+	case BOND_MODE_XOR:
+		slave = bond_sk_3ad_xor_slave_get(bond, sk);
+		break;
+	default:
+		break;
+	}
+
+	return slave ? slave->dev : NULL;
+}
+
+static int bond_tls_add(struct net_device *bond_dev, struct sock *sk,
+			enum tls_offload_ctx_dir direction,
+			struct tls_crypto_info *crypto_info,
+			u32 start_offload_tcp_sn)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct bonding *bond = netdev_priv(bond_dev);
+	struct net_device *slave_dev;
+
+	if (unlikely(direction != TLS_OFFLOAD_CTX_DIR_TX))
+		return -EOPNOTSUPP;
+
+	slave_dev = bond_sk_get_slave_dev(bond, sk);
+	if (unlikely(!slave_dev))
+		return -EINVAL;
+
+	if (!slave_dev->tlsdev_ops ||
+	    !slave_dev->tlsdev_ops->tls_dev_add ||
+	    !slave_dev->tlsdev_ops->tls_dev_del ||
+	    !slave_dev->tlsdev_ops->tls_dev_resync)
+		return -EINVAL;
+
+	if (!(slave_dev->features & NETIF_F_HW_TLS_TX))
+		return -EINVAL;
+
+	tls_ctx->real_dev = slave_dev;
+	return slave_dev->tlsdev_ops->tls_dev_add(slave_dev, sk, direction, crypto_info,
+						  start_offload_tcp_sn);
+}
+
+static void bond_tls_del(struct net_device *bond_dev, struct tls_context *tls_ctx,
+			 enum tls_offload_ctx_dir direction)
+{
+	struct net_device *slave_dev = tls_ctx->real_dev;
+
+	if (unlikely(direction != TLS_OFFLOAD_CTX_DIR_TX))
+		return;
+
+	slave_dev->tlsdev_ops->tls_dev_del(slave_dev, tls_ctx, direction);
+}
+
+static int bond_tls_resync(struct net_device *bond_dev,
+			   struct sock *sk, u32 seq, u8 *rcd_sn,
+			   enum tls_offload_ctx_dir direction)
+{
+	struct net_device *slave_dev = tls_get_ctx(sk)->real_dev;
+
+	if (unlikely(direction != TLS_OFFLOAD_CTX_DIR_TX))
+		return -EOPNOTSUPP;
+
+	return slave_dev->tlsdev_ops->tls_dev_resync(slave_dev, sk, seq, rcd_sn, direction);
+}
+
+static const struct tlsdev_ops bond_tls_ops = {
+	.tls_dev_add = bond_tls_add,
+	.tls_dev_del = bond_tls_del,
+	.tls_dev_resync = bond_tls_resync,
+};
+#endif
+
 /*------------------------------- Link status -------------------------------*/
 
 /* Set the carrier state for the master according to the state of its
@@ -1204,6 +1355,21 @@ static void bond_netpoll_cleanup(struct net_device *bond_dev)
 
 /*---------------------------------- IOCTL ----------------------------------*/
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+bool bond_state_support_tls(struct bonding *bond)
+{
+	switch (BOND_MODE(bond)) {
+	case BOND_MODE_8023AD:
+	case BOND_MODE_XOR:
+		if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER34)
+			return true;
+		fallthrough;
+	default:
+		return false;
+	}
+}
+#endif
+
 static netdev_features_t bond_fix_features(struct net_device *dev,
 					   netdev_features_t features)
 {
@@ -1212,6 +1378,11 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 	struct slave *slave;
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if ((features & BOND_TLS_FEATURES) && !bond_state_support_tls(bond))
+		features &= ~BOND_TLS_FEATURES;
+#endif
+
 	mask = features;
 
 	features &= ~NETIF_F_ONE_FOR_ALL;
@@ -3544,12 +3715,8 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
 		else
 			memcpy(&hash, &flow.ports.ports, sizeof(hash));
 	}
-	hash ^= (__force u32)flow_get_u32_dst(&flow) ^
-		(__force u32)flow_get_u32_src(&flow);
-	hash ^= (hash >> 16);
-	hash ^= (hash >> 8);
 
-	return hash >> 1;
+	return bond_hash_ip(hash, &flow);
 }
 
 /*-------------------------- Device entry points ----------------------------*/
@@ -4522,6 +4689,16 @@ static struct net_device *bond_xmit_get_slave(struct net_device *master_dev,
 	return NULL;
 }
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+static netdev_tx_t bond_tls_device_xmit(struct bonding *bond, struct sk_buff *skb,
+					struct net_device *dev)
+{
+	if (likely(bond_get_slave_by_dev(bond, tls_get_ctx(skb->sk)->real_dev)))
+		return bond_dev_queue_xmit(bond, skb, tls_get_ctx(skb->sk)->real_dev);
+	return bond_tx_drop(dev, skb);
+}
+#endif
+
 static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
@@ -4530,6 +4707,11 @@ static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev
 	    !bond_slave_override(bond, skb))
 		return NETDEV_TX_OK;
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if (skb->sk && tls_is_sk_tx_device_offloaded(skb->sk))
+		return bond_tls_device_xmit(bond, skb, dev);
+#endif
+
 	switch (BOND_MODE(bond)) {
 	case BOND_MODE_ROUNDROBIN:
 		return bond_xmit_roundrobin(skb, dev);
@@ -4702,7 +4884,9 @@ void bond_setup(struct net_device *bond_dev)
 	bond_dev->xfrmdev_ops = &bond_xfrmdev_ops;
 	bond->xs = NULL;
 #endif /* CONFIG_XFRM_OFFLOAD */
-
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	bond_dev->tlsdev_ops = &bond_tls_ops;
+#endif
 	/* don't acquire bond device's netif_tx_lock when transmitting */
 	bond_dev->features |= NETIF_F_LLTX;
 
@@ -4724,6 +4908,9 @@ void bond_setup(struct net_device *bond_dev)
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_features |= BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	bond_dev->hw_features |= BOND_TLS_FEATURES;
+#endif
 	bond_dev->features |= bond_dev->hw_features;
 	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
 #ifdef CONFIG_XFRM_OFFLOAD
@@ -4731,6 +4918,10 @@ void bond_setup(struct net_device *bond_dev)
 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
 		bond_dev->features &= ~BOND_XFRM_FEATURES;
 #endif /* CONFIG_XFRM_OFFLOAD */
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if (!bond_state_support_tls(bond))
+		bond_dev->features &= ~BOND_TLS_FEATURES;
+#endif
 }
 
 /* Destroy a bonding device.
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 9abfaae1c6f7..3ad97cc55421 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -772,13 +772,16 @@ static int bond_option_mode_set(struct bonding *bond,
 		bond->dev->wanted_features |= BOND_XFRM_FEATURES;
 	else
 		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
-	netdev_change_features(bond->dev);
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 	/* don't cache arp_validate between modes */
 	bond->params.arp_validate = BOND_ARP_VALIDATE_NONE;
 	bond->params.mode = newval->value;
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE) || defined(CONFIG_XFRM_OFFLOAD)
+	netdev_change_features(bond->dev);
+#endif
+
 	return 0;
 }
 
@@ -1211,6 +1214,11 @@ static int bond_option_xmit_hash_policy_set(struct bonding *bond,
 		   newval->string, newval->value);
 	bond->params.xmit_policy = newval->value;
 
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+	if (bond->dev->wanted_features & BOND_TLS_FEATURES)
+		netdev_change_features(bond->dev);
+#endif
+
 	return 0;
 }
 
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 7d132cc1e584..00e2c06732c5 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -90,6 +90,10 @@
 #define BOND_XFRM_FEATURES (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM | \
 			    NETIF_F_GSO_ESP)
 #endif /* CONFIG_XFRM_OFFLOAD */
+#if IS_ENABLED(CONFIG_TLS_DEVICE)
+#define BOND_TLS_FEATURES (NETIF_F_HW_TLS_TX)
+bool bond_state_support_tls(struct bonding *bond);
+#endif
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 extern atomic_t netpoll_block_tx;
-- 
2.21.0

