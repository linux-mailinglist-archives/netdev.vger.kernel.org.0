Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94300399B24
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhFCHBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:01:21 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46916 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhFCHBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:01:13 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 323E9219EC; Thu,  3 Jun 2021 14:52:31 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH RFC net-next 07/16] mctp: Add initial routing framework
Date:   Thu,  3 Jun 2021 14:52:09 +0800
Message-Id: <20210603065218.570867-8-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603065218.570867-1-jk@codeconstruct.com.au>
References: <20210603065218.570867-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple routing table, and a couple of route output handlers, and
the mctp packet_type & handler.

Includes changes from Matt Johnston <matt@codeconstruct.com.au>.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 MAINTAINERS                 |   1 +
 include/net/mctp.h          |  75 +++++++++
 include/net/net_namespace.h |   4 +
 include/net/netns/mctp.h    |  16 ++
 net/mctp/Makefile           |   2 +-
 net/mctp/af_mctp.c          |   7 +
 net/mctp/device.c           |   7 +-
 net/mctp/route.c            | 320 ++++++++++++++++++++++++++++++++++++
 8 files changed, 427 insertions(+), 5 deletions(-)
 create mode 100644 include/net/netns/mctp.h
 create mode 100644 net/mctp/route.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a12c7386986..d1fd014f9484 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10877,6 +10877,7 @@ S:	Maintained
 F:	drivers/net/mctp/
 F:	include/net/mctp.h
 F:	include/net/mctpdevice.h
+F:	include/net/netns/mctp.h
 F:	net/mctp/
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
diff --git a/include/net/mctp.h b/include/net/mctp.h
index 24d02fa96425..79ac1202f8e5 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -11,6 +11,7 @@
 
 #include <linux/bits.h>
 #include <linux/mctp.h>
+#include <net/net_namespace.h>
 
 /* MCTP packet definitions */
 struct mctp_hdr {
@@ -33,6 +34,8 @@ struct mctp_hdr {
 #define MCTP_HDR_TAG_SHIFT	0
 #define MCTP_HDR_TAG_MASK	GENMASK(2, 0)
 
+#define MCTP_HEADER_MAXLEN	4
+
 static inline bool mctp_address_ok(mctp_eid_t eid)
 {
 	return eid >= 8 && eid < 255;
@@ -43,6 +46,78 @@ static inline struct mctp_hdr *mctp_hdr(struct sk_buff *skb)
 	return (struct mctp_hdr *)skb_network_header(skb);
 }
 
+struct mctp_skb_cb {
+	unsigned int	magic;
+	unsigned int	net;
+	mctp_eid_t	src;
+};
+
+/* skb control-block accessors with a little extra debugging for initial
+ * development.
+ *
+ * TODO: remove checks & mctp_skb_cb->magic; replace callers of __mctp_cb
+ * with mctp_cb().
+ *
+ * __mctp_cb() is only for the initial ingress code; we should see ->magic set
+ * at all times after this.
+ */
+static inline struct mctp_skb_cb *__mctp_cb(struct sk_buff *skb)
+{
+	struct mctp_skb_cb *cb = (void *)skb->cb;
+
+	cb->magic = 0x4d435450;
+	return cb;
+}
+
+static inline struct mctp_skb_cb *mctp_cb(struct sk_buff *skb)
+{
+	struct mctp_skb_cb *cb = (void *)skb->cb;
+
+	WARN_ON(cb->magic != 0x4d435450);
+	return (void *)(skb->cb);
+}
+
+/* Route definition.
+ *
+ * These are held in the pernet->mctp.routes list, with RCU protection for
+ * removed routes. We hold a reference to the netdev; routes need to be
+ * dropped on NETDEV_UNREGISTER events.
+ *
+ * Updates to the route table are performed under rtnl; all reads under RCU,
+ * so routes cannot be referenced over a RCU grace period. Specifically: A
+ * caller cannot block between mctp_route_lookup and passing the route to
+ * mctp_do_route.
+ */
+struct mctp_route {
+	mctp_eid_t		min, max;
+
+	struct mctp_dev		*dev;
+	unsigned int		mtu;
+	int			(*output)(struct mctp_route *route,
+					  struct sk_buff *skb);
+
+	struct list_head	list;
+	refcount_t		refs;
+	struct rcu_head		rcu;
+};
+
+/* route interfaces */
+struct mctp_route *mctp_route_lookup(struct net *net, unsigned int dnet,
+				     mctp_eid_t daddr);
+
+int mctp_do_route(struct mctp_route *rt, struct sk_buff *skb);
+
+int mctp_local_output(struct sock *sk, struct mctp_route *rt,
+		      struct sk_buff *skb, mctp_eid_t daddr, u8 req_tag);
+
+/* routing <--> device interface */
+int mctp_route_add_local(struct mctp_dev *mdev, mctp_eid_t addr);
+int mctp_route_remove_local(struct mctp_dev *mdev, mctp_eid_t addr);
+void mctp_route_remove_dev(struct mctp_dev *mdev);
+
+int mctp_routes_init(void);
+void mctp_routes_exit(void);
+
 void mctp_device_init(void);
 void mctp_device_exit(void);
 
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index fa5887143f0d..71fce3086fc3 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -33,6 +33,7 @@
 #include <net/netns/can.h>
 #include <net/netns/xdp.h>
 #include <net/netns/bpf.h>
+#include <net/netns/mctp.h>
 #include <linux/ns_common.h>
 #include <linux/idr.h>
 #include <linux/skbuff.h>
@@ -166,6 +167,9 @@ struct net {
 #ifdef CONFIG_XDP_SOCKETS
 	struct netns_xdp	xdp;
 #endif
+#if IS_ENABLED(CONFIG_MCTP)
+	struct netns_mctp	mctp;
+#endif
 #if IS_ENABLED(CONFIG_CRYPTO_USER)
 	struct sock		*crypto_nlsk;
 #endif
diff --git a/include/net/netns/mctp.h b/include/net/netns/mctp.h
new file mode 100644
index 000000000000..508459b08a59
--- /dev/null
+++ b/include/net/netns/mctp.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * MCTP per-net structures
+ */
+
+#ifndef __NETNS_MCTP_H__
+#define __NETNS_MCTP_H__
+
+#include <linux/types.h>
+
+struct netns_mctp {
+	/* Only updated under RTNL, entries freed via RCU */
+	struct list_head routes;
+};
+
+#endif /* __NETNS_MCTP_H__ */
diff --git a/net/mctp/Makefile b/net/mctp/Makefile
index 2ea98c27b262..b1a330e9d82a 100644
--- a/net/mctp/Makefile
+++ b/net/mctp/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MCTP) += mctp.o
-mctp-objs := af_mctp.o device.o
+mctp-objs := af_mctp.o device.o route.o
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index d77955eee21b..081c7b8005da 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -157,10 +157,16 @@ static __init int mctp_init(void)
 	if (rc)
 		goto err_unreg_sock;
 
+	rc = mctp_routes_init();
+	if (rc)
+		goto err_unreg_proto;
+
 	mctp_device_init();
 
 	return 0;
 
+err_unreg_proto:
+	proto_unregister(&mctp_proto);
 err_unreg_sock:
 	sock_unregister(PF_MCTP);
 
@@ -170,6 +176,7 @@ static __init int mctp_init(void)
 static __exit void mctp_exit(void)
 {
 	mctp_device_exit();
+	mctp_routes_exit();
 	proto_unregister(&mctp_proto);
 	sock_unregister(PF_MCTP);
 }
diff --git a/net/mctp/device.c b/net/mctp/device.c
index 988936936693..273041ed2d3e 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -191,6 +191,8 @@ static int mctp_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	ifaddr->dev = mdev;
 	list_add(&ifaddr->dev_list, &mdev->addrs);
 
+	mctp_route_add_local(mdev, addr->s_addr);
+
 	return 0;
 }
 
@@ -282,10 +284,7 @@ static void mctp_unregister(struct net_device *dev)
 
 	RCU_INIT_POINTER(mdev->dev->mctp_ptr, NULL);
 
-	/* TODO: drop routes, to the point where we can dev_put(); requires
-	 * coordination with the route layer; each route should hold a dev
-	 * reference. We should only need to synchronize_rcu() once for this.
-	 */
+	mctp_route_remove_dev(mdev);
 	list_for_each_entry_safe(ifa, tmp, &mdev->addrs, dev_list) {
 		list_del_rcu(&ifa->dev_list);
 		kfree_rcu(ifa, rcu);
diff --git a/net/mctp/route.c b/net/mctp/route.c
new file mode 100644
index 000000000000..7e2997c67b8e
--- /dev/null
+++ b/net/mctp/route.c
@@ -0,0 +1,320 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Management Controller Transport Protocol (MCTP) - routing
+ * implementation.
+ *
+ * This is currently based on a simple routing table, with no dst cache. The
+ * number of routes should stay fairly small, so the lookup cost is small.
+ *
+ * Copyright (c) 2021 Code Construct
+ * Copyright (c) 2021 Google
+ */
+
+#include <linux/idr.h>
+#include <linux/mctp.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/skbuff.h>
+
+#include <uapi/linux/if_arp.h>
+
+#include <net/mctp.h>
+#include <net/mctpdevice.h>
+
+/* route output callbacks */
+static int mctp_route_discard(struct mctp_route *route, struct sk_buff *skb)
+{
+	kfree_skb(skb);
+	return 0;
+}
+
+static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
+{
+	/* -> to local stack */
+	/* TODO: socket lookup, reassemble */
+	kfree_skb(skb);
+	return 0;
+}
+
+static int __always_unused mctp_route_output(struct mctp_route *route,
+					     struct sk_buff *skb)
+{
+	unsigned int mtu;
+	int rc;
+
+	skb->protocol = htons(ETH_P_MCTP);
+
+	mtu = READ_ONCE(skb->dev->mtu);
+	if (skb->len > mtu) {
+		kfree_skb(skb);
+		return -EMSGSIZE;
+	}
+
+	/* TODO: daddr (from rt->neigh), saddr (from device?)  */
+	rc = dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
+			     NULL, NULL, skb->len);
+	if (rc) {
+		kfree_skb(skb);
+		return -EHOSTUNREACH;
+	}
+
+	rc = dev_queue_xmit(skb);
+	if (rc)
+		rc = net_xmit_errno(rc);
+
+	return rc;
+}
+
+/* route alloc/release */
+static void mctp_route_release(struct mctp_route *rt)
+{
+	if (refcount_dec_and_test(&rt->refs)) {
+		dev_put(rt->dev->dev);
+		kfree_rcu(rt, rcu);
+	}
+}
+
+/* returns a route with the refcount at 1 */
+static struct mctp_route *mctp_route_alloc(void)
+{
+	struct mctp_route *rt;
+
+	rt = kzalloc(sizeof(*rt), GFP_KERNEL);
+	if (!rt)
+		return NULL;
+
+	INIT_LIST_HEAD(&rt->list);
+	refcount_set(&rt->refs, 1);
+	rt->output = mctp_route_discard;
+
+	return rt;
+}
+
+/* routing lookups */
+static inline bool mctp_rt_match_eid(struct mctp_route *rt,
+				     unsigned int net, mctp_eid_t eid)
+{
+	return READ_ONCE(rt->dev->net) == net &&
+		rt->min <= eid && rt->max >= eid;
+}
+
+/* compares match, used for duplicate prevention */
+static bool mctp_rt_compare_exact(struct mctp_route *rt1,
+				  struct mctp_route *rt2)
+{
+	ASSERT_RTNL();
+	return rt1->dev->net == rt2->dev->net &&
+		rt1->min == rt2->min &&
+		rt1->max == rt2->max;
+}
+
+struct mctp_route *mctp_route_lookup(struct net *net, unsigned int dnet,
+				     mctp_eid_t daddr)
+{
+	struct mctp_route *tmp, *rt = NULL;
+
+	list_for_each_entry_rcu(tmp, &net->mctp.routes, list) {
+		/* TODO: add metrics */
+		if (mctp_rt_match_eid(tmp, dnet, daddr)) {
+			if (refcount_inc_not_zero(&tmp->refs)) {
+				rt = tmp;
+				break;
+			}
+		}
+	}
+
+	return rt;
+}
+
+/* sends a skb to rt and releases the route. */
+int mctp_do_route(struct mctp_route *rt, struct sk_buff *skb)
+{
+	int rc;
+
+	rc = rt->output(rt, skb);
+	mctp_route_release(rt);
+	return rc;
+}
+
+int mctp_local_output(struct sock *sk, struct mctp_route *rt,
+		      struct sk_buff *skb, mctp_eid_t daddr, u8 req_tag)
+{
+	struct mctp_skb_cb *cb = mctp_cb(skb);
+	struct mctp_hdr *hdr;
+	mctp_eid_t saddr;
+
+	if (WARN_ON(!rt->dev))
+		return -EINVAL;
+
+	if (list_empty(&rt->dev->addrs))
+		return -EHOSTUNREACH;
+
+	/* use the outbound interface's first address as our source */
+	saddr = list_first_entry(&rt->dev->addrs,
+				 struct mctp_ifaddr, dev_list)->eid;
+
+	/* TODO: we have the route MTU here; packetise */
+
+	skb_reset_transport_header(skb);
+	skb_push(skb, sizeof(struct mctp_hdr));
+	skb_reset_network_header(skb);
+	hdr = mctp_hdr(skb);
+	hdr->ver = 1;
+	hdr->dest = daddr;
+	hdr->src = saddr;
+	hdr->flags_seq_tag = MCTP_HDR_FLAG_SOM | MCTP_HDR_FLAG_EOM; /* TODO */
+
+	skb->protocol = htons(ETH_P_MCTP);
+	skb->priority = 0;
+
+	/* cb->net will have been set on initial ingress */
+	cb->src = saddr;
+
+	return mctp_do_route(rt, skb);
+}
+
+/* route management */
+int mctp_route_add_local(struct mctp_dev *mdev, mctp_eid_t addr)
+{
+	struct net *net = dev_net(mdev->dev);
+	struct mctp_route *rt, *ert;
+
+	rt = mctp_route_alloc();
+	if (!rt)
+		return -ENOMEM;
+
+	rt->min = addr;
+	rt->max = addr;
+	rt->dev = mdev;
+	dev_hold(rt->dev->dev);
+	rt->output = mctp_route_input;
+
+	ASSERT_RTNL();
+	/* Prevent duplicate identical routes. */
+	list_for_each_entry(ert, &net->mctp.routes, list) {
+		if (mctp_rt_compare_exact(rt, ert)) {
+			mctp_route_release(rt);
+			return -EEXIST;
+		}
+	}
+
+	list_add_rcu(&rt->list, &net->mctp.routes);
+
+	return 0;
+}
+
+int mctp_route_remove_local(struct mctp_dev *mdev, mctp_eid_t addr)
+{
+	struct net *net = dev_net(mdev->dev);
+	struct mctp_route *rt, *tmp;
+
+	ASSERT_RTNL();
+
+	list_for_each_entry_safe(rt, tmp, &net->mctp.routes, list) {
+		if (rt->dev == mdev && rt->min == addr && rt->max == addr) {
+			list_del_rcu(&rt->list);
+			/* TODO: immediate RTM_DELROUTE */
+			mctp_route_release(rt);
+		}
+	}
+
+	return 0;
+}
+
+/* removes all entries for a given device */
+void mctp_route_remove_dev(struct mctp_dev *mdev)
+{
+	struct net *net = dev_net(mdev->dev);
+	struct mctp_route *rt, *tmp;
+	ASSERT_RTNL();
+	list_for_each_entry_safe(rt, tmp, &net->mctp.routes, list) {
+		if (rt->dev == mdev) {
+			list_del_rcu(&rt->list);
+			/* TODO: immediate RTM_DELROUTE */
+			mctp_route_release(rt);
+		}
+	}
+}
+
+/* Incoming packet-handling */
+
+static int mctp_pkttype_receive(struct sk_buff *skb, struct net_device *dev,
+				struct packet_type *pt,
+				struct net_device *orig_dev)
+{
+	struct net *net = dev_net(dev);
+	struct mctp_skb_cb *cb;
+	struct mctp_route *rt;
+	struct mctp_hdr *mh;
+
+	/* basic non-data sanity checks */
+	if (dev->type != ARPHRD_MCTP)
+		goto err_drop;
+
+	if (!pskb_may_pull(skb, sizeof(struct mctp_hdr)))
+		goto err_drop;
+
+	skb_reset_transport_header(skb);
+	skb_reset_network_header(skb);
+
+	/* We have enough for a header; decode and route */
+	mh = mctp_hdr(skb);
+	if (mh->ver < MCTP_VER_MIN || mh->ver > MCTP_VER_MAX)
+		goto err_drop;
+
+	cb = __mctp_cb(skb);
+	rcu_read_lock();
+	cb->net = READ_ONCE(__mctp_dev_get(dev)->net);
+	rcu_read_unlock();
+
+	rt = mctp_route_lookup(net, cb->net, mh->dest);
+	if (!rt)
+		goto err_drop;
+
+	mctp_do_route(rt, skb);
+
+	return NET_RX_SUCCESS;
+
+err_drop:
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+static struct packet_type mctp_packet_type = {
+	.type = cpu_to_be16(ETH_P_MCTP),
+	.func = mctp_pkttype_receive,
+};
+
+/* net namespace implementation */
+static int __net_init mctp_routes_net_init(struct net *net)
+{
+	struct netns_mctp *ns = &net->mctp;
+
+	INIT_LIST_HEAD(&ns->routes);
+	return 0;
+}
+
+static void __net_exit mctp_routes_net_exit(struct net *net)
+{
+	struct mctp_route *rt;
+
+	list_for_each_entry_rcu(rt, &net->mctp.routes, list)
+		mctp_route_release(rt);
+}
+
+static struct pernet_operations mctp_net_ops = {
+	.init = mctp_routes_net_init,
+	.exit = mctp_routes_net_exit,
+};
+
+int __init mctp_routes_init(void)
+{
+	dev_add_pack(&mctp_packet_type);
+	return register_pernet_subsys(&mctp_net_ops);
+}
+
+void __exit mctp_routes_exit(void)
+{
+	unregister_pernet_subsys(&mctp_net_ops);
+	dev_remove_pack(&mctp_packet_type);
+}
-- 
2.30.2

