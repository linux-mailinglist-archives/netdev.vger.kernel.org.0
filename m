Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A7641C1E2
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245136AbhI2JrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:47:07 -0400
Received: from mail.katalix.com ([3.9.82.81]:53940 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245139AbhI2JrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 05:47:06 -0400
Received: from jackdaw.fritz.box (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id DEB0783388;
        Wed, 29 Sep 2021 10:45:23 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1632908724; bh=yFmvyY12ArRDa7bj5TxqokEXPsHUlTbUM0WCxc7ba40=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[RFC=20PATCH=20net-next=201/3]=20net/l2
         tp:=20add=20virtual=20tunnel=20device|Date:=20Wed,=2029=20Sep=2020
         21=2010:45:12=20+0100|Message-Id:=20<20210929094514.15048-2-tparki
         n@katalix.com>|In-Reply-To:=20<20210929094514.15048-1-tparkin@kata
         lix.com>|References:=20<20210929094514.15048-1-tparkin@katalix.com
         >;
        b=NkHvpUhz0o2jl2N+4m7QB0gT66QgelswPGG/VJ/0XX97bNRG9kvcI6HWfo6xujzvW
         MFTbNunFFrDjIqrZhproX1X2aIS42ghsrg5BiHV9bsMusBgTA8be0dGJHFA+Nl8WMs
         4vb6Uf1qzgbSiLVMRMqMmNMO44azXzx7ba76VAX7ysYyB97IRu2wJ89k9TIrqQpsQC
         d11/G+k1tjrSffFaUEP7YTXbrkD3XodDrYma0bQSuQC8GZBkaOaFpysNz+o76njd30
         Ej3g7/7MY8NRdpVyYu+DTxUj9FKf5bBCmLnf6rDw8GWSOjsEfyIR/pYEC1ZGhUaPPU
         UL7uvy9RbCCJw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [RFC PATCH net-next 1/3] net/l2tp: add virtual tunnel device
Date:   Wed, 29 Sep 2021 10:45:12 +0100
Message-Id: <20210929094514.15048-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210929094514.15048-1-tparkin@katalix.com>
References: <20210929094514.15048-1-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The traditional L2TP datapath in the kernel requires allocation of a
netdev for each L2TP session.  For larger populations this limits
scalability.

Other protocols (such as geneve) support a mode whereby a single virtual
netdev is used to manage packetflows for multiple logical sessions: a
much more scalable solution.

Extend l2tp to offer a tunnel network device to support this mode of
operation.

l2tp_core.c keeps track of a netdev per tunnel.  The device is allocated
on registration of the tunnel and is named using the local tunnel ID.

Traffic may then be sent over the tunnel socket using dst_metadata set
by e.g. tc's tunnel_key action.  This PoC patch uses the 'id' field to
represent the ID of the session inside the tunnel.

For example:

        # Create a UDP encap tunnel to a peer, and create a session
        # inside the tunnel
        ip l2tp add tunnel \
                remote 192.168.178.30 \
                local 192.168.122.35 \
                tunne1_id 1 \
                peer_tunnel_id 1 \
                encap udp \
                udp_sport 1701 \
                udp_dport 1701
        ip l2tp add session \
                tunnel_id 1 \
                session_id 1 \
                peer_session_id 1
        ip link set dev l2tpt1 up

        # Add tc flower rule to send all eth0 packets over the tunnel:
        # the src_ip and dst_ip parameters here are dummy data ignored
        # by the L2TP data path
        tc qdisc add dev eth0 handle ffff: ingress
        tc filter add dev eth0 \
                parent ffff: \
                matchall \
                action tunnel_key set \
                        src_ip 0.0.0.1 \
                        dst_ip 0.0.0.1 \
                        id 1 \
                action mirred egress redirect dev l2tpt1

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 162 +++++++++++++++++++++++++++++++++++++++++++
 net/l2tp/l2tp_core.h |   1 +
 2 files changed, 163 insertions(+)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 93271a2632b8..6a4d3d785c65 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -56,6 +56,7 @@
 #include <net/inet_ecn.h>
 #include <net/ip6_route.h>
 #include <net/ip6_checksum.h>
+#include <net/dst_metadata.h>
 
 #include <asm/byteorder.h>
 #include <linux/atomic.h>
@@ -101,6 +102,10 @@ struct l2tp_skb_cb {
 
 static struct workqueue_struct *l2tp_wq;
 
+struct l2tp_tunl_dev_priv {
+	u32 tunnel_id;
+};
+
 /* per-net private data for this module */
 static unsigned int l2tp_net_id;
 struct l2tp_net {
@@ -1248,6 +1253,27 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 		}
 	}
 
+	/* If the tunnel has a netdev, release it now.
+	 *
+	 * FIXME: feels like a race condition in the making:
+	 * our alloc_netdev call uses an interface name derived from
+	 * tunnel ID.  Both tunnel ID and interface name must be
+	 * unique, and hence if there's a lag between the tunnel
+	 * removal from the list below and the netdev going away,
+	 * there could be allocation failures.
+	 *
+	 * An alternative scheme might be to let alloc_netdev
+	 * auto-assign the tunnel device name: in this case we would
+	 * need to indicate that name back to userspace using netlink.
+	 *
+	 * Another approach would be to have the netlink tunnel
+	 * create command call out the tunnel device name.
+	 */
+	rtnl_lock();
+	if (tunnel->dev)
+		unregister_netdevice(tunnel->dev);
+	rtnl_unlock();
+
 	/* Remove the tunnel struct from the tunnel list */
 	pn = l2tp_pernet(tunnel->l2tp_net);
 	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
@@ -1452,6 +1478,7 @@ static int l2tp_validate_socket(const struct sock *sk, const struct net *net,
 	return 0;
 }
 
+static struct net_device *l2tp_tunnel_netdev_alloc(struct net *net, u32 tunnel_id);
 int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			 struct l2tp_tunnel_cfg *cfg)
 {
@@ -1520,6 +1547,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
+	tunnel->dev = l2tp_tunnel_netdev_alloc(net, tunnel->tunnel_id);
+
 	return 0;
 
 err_sock:
@@ -1632,6 +1661,139 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 }
 EXPORT_SYMBOL_GPL(l2tp_session_create);
 
+/*****************************************************************************
+ * Tunnel virtual netdev
+ *****************************************************************************/
+
+static int l2tp_tunl_dev_init(struct net_device *dev)
+{
+	netdev_lockdep_set_classes(dev);
+	return 0;
+}
+
+static void l2tp_tunl_dev_uninit(struct net_device *dev)
+{
+}
+
+static netdev_tx_t l2tp_tunl_dev_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	const struct ip_tunnel_info *info;
+	struct l2tp_tunl_dev_priv *priv;
+	struct l2tp_session *session;
+	struct l2tp_tunnel *tunnel;
+	u32 tid, sid;
+
+	info = skb_tunnel_info(skb);
+	if (!info || !(info->mode & IP_TUNNEL_INFO_TX))
+		goto drop;
+
+	priv = netdev_priv(dev);
+	tid = priv->tunnel_id;
+	tunnel = l2tp_tunnel_get(dev_net(dev), tid);
+	if (!tunnel) {
+		pr_err("%s: no tunnel %u in this netns", dev->name, tid);
+		goto drop;
+	}
+
+	sid = be32_to_cpu(tunnel_id_to_key32(info->key.tun_id));
+	session = l2tp_tunnel_get_session(tunnel, sid);
+	if (!session) {
+		pr_err("%s: no session %u in tunnel %u", dev->name, sid, tid);
+		goto drop_unref_tunnel;
+	}
+
+	if (l2tp_xmit_skb(session, skb) != NET_XMIT_SUCCESS)
+		goto drop_unref_tunnel_and_session;
+
+	l2tp_session_dec_refcount(session);
+	l2tp_tunnel_dec_refcount(tunnel);
+
+	return NETDEV_TX_OK;
+
+drop_unref_tunnel_and_session:
+	l2tp_session_dec_refcount(session);
+drop_unref_tunnel:
+	l2tp_tunnel_dec_refcount(tunnel);
+drop:
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
+}
+
+static rx_handler_result_t l2tp_tunl_dev_rx_handler(struct sk_buff **pskb)
+{
+	struct sk_buff *skb = *pskb;
+
+	/* If a packet hasn't been redirected using tc rules we
+	 * don't want it to continue through the network stack,
+	 * so consume it now.
+	 */
+	kfree_skb(skb);
+
+	return RX_HANDLER_CONSUMED;
+}
+
+static const struct net_device_ops l2tp_tunnel_netdev_ops = {
+	.ndo_init		= l2tp_tunl_dev_init,
+	.ndo_uninit		= l2tp_tunl_dev_uninit,
+	.ndo_start_xmit		= l2tp_tunl_dev_xmit,
+};
+
+static struct device_type l2tpvt_type = {
+	.name = "l2tpvt",
+};
+
+static void l2tp_tunnel_netdev_setup(struct net_device *dev)
+{
+	SET_NETDEV_DEVTYPE(dev, &l2tpvt_type);
+	eth_hw_addr_random(dev);
+	ether_setup(dev);
+	eth_hw_addr_random(dev);
+	dev->netdev_ops = &l2tp_tunnel_netdev_ops;
+	dev->features |= NETIF_F_LLTX;
+	dev->min_mtu = ETH_MIN_MTU;
+	dev->max_mtu = ETH_MAX_MTU;
+	dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
+}
+
+static struct net_device *l2tp_tunnel_netdev_alloc(struct net *net, u32 tunnel_id)
+{
+	struct l2tp_tunl_dev_priv *priv;
+	struct net_device *dev;
+	char name[IFNAMSIZ];
+	int ret;
+
+	snprintf(name, IFNAMSIZ, "l2tpt%d", tunnel_id);
+
+	dev = alloc_netdev(sizeof(*priv), name, NET_NAME_USER, l2tp_tunnel_netdev_setup);
+	dev_net_set(dev, net);
+
+	ret = register_netdev(dev);
+	if (ret < 0) {
+		pr_err("%s: register_netdev said %d\n", __func__, ret);
+		free_netdev(dev);
+		return NULL;
+	}
+
+	/* Add rx handler to prevent packets entering the stack.
+	 * The intention here is to allow packets on the tunnel device to
+	 * be seen by sch_handle_ingress (and hence tc classifiers/actions)
+	 * but prevent them from being passed to protocol code.
+	 */
+	rtnl_lock();
+	ret = netdev_rx_handler_register(dev, l2tp_tunl_dev_rx_handler, NULL);
+	rtnl_unlock();
+	if (ret < 0) {
+		pr_err("%s: netdev_rx_handler_register said %d\n", __func__, ret);
+		free_netdev(dev);
+		return NULL;
+	}
+
+	priv = netdev_priv(dev);
+	priv->tunnel_id = tunnel_id;
+
+	return dev;
+}
+
 /*****************************************************************************
  * Init and cleanup
  *****************************************************************************/
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 98ea98eb9567..4d2aeb852f38 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -185,6 +185,7 @@ struct l2tp_tunnel {
 						 */
 
 	struct work_struct	del_work;
+	struct net_device	*dev;
 };
 
 /* Pseudowire ops callbacks for use with the l2tp genetlink interface */
-- 
2.17.1

