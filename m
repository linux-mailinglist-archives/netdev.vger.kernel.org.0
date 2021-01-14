Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72B3B2F68D1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbhANSDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:03:04 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:57097 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729263AbhANSCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:02:44 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 14 Jan 2021 20:01:52 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10EI1pYL001704;
        Thu, 14 Jan 2021 20:01:51 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V2 3/8] net/bonding: Implement ndo_sk_get_slave
Date:   Thu, 14 Jan 2021 20:01:30 +0200
Message-Id: <20210114180135.11556-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210114180135.11556-1-tariqt@nvidia.com>
References: <20210114180135.11556-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ndo_sk_get_slave() implementation for bond interfaces.

Support only for the cases where the socket's and SKBs' hash
yields identical value for the whole connection lifetime.

Here we restrict it to L3+4 sockets only, with
xmit_hash_policy==LAYER34 and bond modes xor/802.3ad.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
---
 drivers/net/bonding/bond_main.c | 93 +++++++++++++++++++++++++++++++++
 include/net/bonding.h           |  2 +
 2 files changed, 95 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 8bc7629a2805..717ce6164780 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -301,6 +301,19 @@ netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
 	return dev_queue_xmit(skb);
 }
 
+bool bond_sk_check(struct bonding *bond)
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
+
 /*---------------------------------- VLAN -----------------------------------*/
 
 /* In the following 2 functions, bond_vlan_rx_add_vid and bond_vlan_rx_kill_vid,
@@ -4553,6 +4566,85 @@ static struct net_device *bond_xmit_get_slave(struct net_device *master_dev,
 	return NULL;
 }
 
+static void bond_sk_to_flow(struct sock *sk, struct flow_keys *flow)
+{
+	switch (sk->sk_family) {
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		if (sk->sk_ipv6only ||
+		    ipv6_addr_type(&sk->sk_v6_daddr) != IPV6_ADDR_MAPPED) {
+			flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+			flow->addrs.v6addrs.src = inet6_sk(sk)->saddr;
+			flow->addrs.v6addrs.dst = sk->sk_v6_daddr;
+			break;
+		}
+		fallthrough;
+#endif
+	default: /* AF_INET */
+		flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		flow->addrs.v4addrs.src = inet_sk(sk)->inet_rcv_saddr;
+		flow->addrs.v4addrs.dst = inet_sk(sk)->inet_daddr;
+		break;
+	}
+
+	flow->ports.src = inet_sk(sk)->inet_sport;
+	flow->ports.dst = inet_sk(sk)->inet_dport;
+}
+
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
+	struct flow_keys flow;
+	u32 hash;
+
+	bond_sk_to_flow(sk, &flow);
+
+	/* L4 */
+	memcpy(&hash, &flow.ports.ports, sizeof(hash));
+	/* L3 */
+	return bond_ip_hash(hash, &flow);
+}
+
+static struct net_device *__bond_sk_get_slave_dev(struct bonding *bond,
+						  struct sock *sk)
+{
+	struct bond_up_slave *slaves;
+	struct slave *slave;
+	unsigned int count;
+	u32 hash;
+
+	slaves = rcu_dereference(bond->usable_slaves);
+	count = slaves ? READ_ONCE(slaves->count) : 0;
+	if (unlikely(!count))
+		return NULL;
+
+	hash = bond_sk_hash_l34(sk);
+	slave = slaves->arr[hash % count];
+
+	return slave->dev;
+}
+
+static struct net_device *bond_sk_get_slave(struct net_device *master_dev,
+					    struct sock *sk)
+{
+	struct bonding *bond = netdev_priv(master_dev);
+	struct net_device *slave_dev = NULL;
+
+	rcu_read_lock();
+	if (bond_sk_check(bond))
+		slave_dev = __bond_sk_get_slave_dev(bond, sk);
+	rcu_read_unlock();
+
+	return slave_dev;
+}
+
 static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bonding *bond = netdev_priv(dev);
@@ -4689,6 +4781,7 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_fix_features	= bond_fix_features,
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_xmit_slave	= bond_xmit_get_slave,
+	.ndo_sk_get_slave	= bond_sk_get_slave,
 };
 
 static const struct device_type bond_type = {
diff --git a/include/net/bonding.h b/include/net/bonding.h
index adc3da776970..21497193c4a4 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -265,6 +265,8 @@ struct bond_vlan_tag {
 	unsigned short	vlan_id;
 };
 
+bool bond_sk_check(struct bonding *bond);
+
 /**
  * Returns NULL if the net_device does not belong to any of the bond's slaves
  *
-- 
2.21.0

