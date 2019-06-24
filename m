Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5037B50296
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 08:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfFXGzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 02:55:47 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:52003 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726399AbfFXGzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 02:55:47 -0400
X-Greylist: delayed 653 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jun 2019 02:55:44 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 4AFEE45887;
        Mon, 24 Jun 2019 16:44:48 +1000 (AEST)
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fx8p1iYoQmKo; Mon, 24 Jun 2019 16:44:48 +1000 (AEST)
Received: from cba01.dek-tpc.internal (cba01.dek-tpc.internal [172.16.83.49])
        by mail.dektech.com.au (Postfix) with ESMTP id 316D84586B;
        Mon, 24 Jun 2019 16:44:48 +1000 (AEST)
Received: by cba01.dek-tpc.internal (Postfix, from userid 1014)
        id 201671812EC; Mon, 24 Jun 2019 16:44:48 +1000 (AEST)
From:   john.rutherford@dektech.com.au
To:     netdev@vger.kernel.org
Cc:     John Rutherford <john.rutherford@dektech.com.au>
Subject: [net-next v2] tipc: add loopback device tracking
Date:   Mon, 24 Jun 2019 16:44:35 +1000
Message-Id: <20190624064435.22357-1-john.rutherford@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since node internal messages are passed directly to socket it is not
possible to observe this message exchange via tcpdump or wireshark.

We now remedy this by making it possible to clone such messages and send
the clones to the loopback interface.  The clones are dropped at reception
and have no functional role except making the traffic visible.

The feature is turned on/off by enabling/disabling the loopback "bearer"
"eth:lo".

Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>
---
 net/tipc/bcast.c  |  4 +++-
 net/tipc/bearer.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/tipc/bearer.h |  3 +++
 net/tipc/core.c   |  5 ++++-
 net/tipc/core.h   | 12 ++++++++++
 net/tipc/node.c   |  1 +
 net/tipc/topsrv.c |  2 ++
 7 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 6c997d4..235331d 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -406,8 +406,10 @@ int tipc_mcast_xmit(struct net *net, struct sk_buff_head *pkts,
 			rc = tipc_bcast_xmit(net, pkts, cong_link_cnt);
 	}
 
-	if (dests->local)
+	if (dests->local) {
+		tipc_loopback_trace(net, &localq);
 		tipc_sk_mcast_rcv(net, &localq, &inputq);
+	}
 exit:
 	/* This queue should normally be empty by now */
 	__skb_queue_purge(pkts);
diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 2bed658..27b4fd7 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -836,6 +836,12 @@ int __tipc_nl_bearer_disable(struct sk_buff *skb, struct genl_info *info)
 
 	name = nla_data(attrs[TIPC_NLA_BEARER_NAME]);
 
+	if (!strcmp(name, "eth:lo")) {
+		tipc_net(net)->loopback_trace = false;
+		pr_info("Disabled packet tracing on loopback interface\n");
+		return 0;
+	}
+
 	bearer = tipc_bearer_find(net, name);
 	if (!bearer)
 		return -EINVAL;
@@ -881,6 +887,12 @@ int __tipc_nl_bearer_enable(struct sk_buff *skb, struct genl_info *info)
 
 	bearer = nla_data(attrs[TIPC_NLA_BEARER_NAME]);
 
+	if (!strcmp(bearer, "eth:lo")) {
+		tipc_net(net)->loopback_trace = true;
+		pr_info("Enabled packet tracing on loopback interface\n");
+		return 0;
+	}
+
 	if (attrs[TIPC_NLA_BEARER_DOMAIN])
 		domain = nla_get_u32(attrs[TIPC_NLA_BEARER_DOMAIN]);
 
@@ -1021,6 +1033,61 @@ int tipc_nl_bearer_set(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+void tipc_clone_to_loopback(struct net *net, struct sk_buff_head *xmitq)
+{
+	struct net_device *dev = net->loopback_dev;
+	struct sk_buff *skb, *_skb;
+	int exp;
+
+	skb_queue_walk(xmitq, _skb) {
+		skb = pskb_copy(_skb, GFP_ATOMIC);
+		if (!skb)
+			continue;
+		exp = SKB_DATA_ALIGN(dev->hard_header_len - skb_headroom(skb));
+		if (exp > 0 && pskb_expand_head(skb, exp, 0, GFP_ATOMIC)) {
+			kfree_skb(skb);
+			continue;
+		}
+		skb_reset_network_header(skb);
+		skb->dev = dev;
+		skb->protocol = htons(ETH_P_TIPC);
+		dev_hard_header(skb, dev, ETH_P_TIPC, dev->dev_addr,
+				dev->dev_addr, skb->len);
+		dev_queue_xmit(skb);
+	}
+}
+
+static int tipc_loopback_rcv_pkt(struct sk_buff *skb, struct net_device *dev,
+				 struct packet_type *pt, struct net_device *od)
+{
+	consume_skb(skb);
+	return NET_RX_SUCCESS;
+}
+
+int tipc_attach_loopback(struct net *net)
+{
+	struct net_device *dev = net->loopback_dev;
+	struct tipc_net *tn = tipc_net(net);
+
+	if (!dev)
+		return -ENODEV;
+	dev_hold(dev);
+	tn->loopback_pt.dev = dev;
+	tn->loopback_pt.type = htons(ETH_P_TIPC);
+	tn->loopback_pt.func = tipc_loopback_rcv_pkt;
+	tn->loopback_trace = false;
+	dev_add_pack(&tn->loopback_pt);
+	return 0;
+}
+
+void tipc_detach_loopback(struct net *net)
+{
+	struct tipc_net *tn = tipc_net(net);
+
+	dev_remove_pack(&tn->loopback_pt);
+	dev_put(net->loopback_dev);
+}
+
 static int __tipc_nl_add_media(struct tipc_nl_msg *msg,
 			       struct tipc_media *media, int nlflags)
 {
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index 7f4c569..ef7fad9 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -232,6 +232,9 @@ void tipc_bearer_xmit(struct net *net, u32 bearer_id,
 		      struct tipc_media_addr *dst);
 void tipc_bearer_bc_xmit(struct net *net, u32 bearer_id,
 			 struct sk_buff_head *xmitq);
+void tipc_clone_to_loopback(struct net *net, struct sk_buff_head *xmitq);
+int tipc_attach_loopback(struct net *net);
+void tipc_detach_loopback(struct net *net);
 
 /* check if device MTU is too low for tipc headers */
 static inline bool tipc_mtu_bad(struct net_device *dev, unsigned int reserve)
diff --git a/net/tipc/core.c b/net/tipc/core.c
index ed536c0..1867687 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -81,7 +81,9 @@ static int __net_init tipc_init_net(struct net *net)
 	err = tipc_bcast_init(net);
 	if (err)
 		goto out_bclink;
-
+	err = tipc_attach_loopback(net);
+	if (err)
+		goto out_bclink;
 	return 0;
 
 out_bclink:
@@ -94,6 +96,7 @@ static int __net_init tipc_init_net(struct net *net)
 
 static void __net_exit tipc_exit_net(struct net *net)
 {
+	tipc_detach_loopback(net);
 	tipc_net_stop(net);
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 7a68e1b..c1c2906 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -67,6 +67,7 @@ struct tipc_link;
 struct tipc_name_table;
 struct tipc_topsrv;
 struct tipc_monitor;
+void tipc_clone_to_loopback(struct net *net, struct sk_buff_head *pkts);
 
 #define TIPC_MOD_VER "2.0.0"
 
@@ -125,6 +126,10 @@ struct tipc_net {
 
 	/* Cluster capabilities */
 	u16 capabilities;
+
+	/* Tracing of node internal messages */
+	struct packet_type loopback_pt;
+	bool loopback_trace;
 };
 
 static inline struct tipc_net *tipc_net(struct net *net)
@@ -152,6 +157,13 @@ static inline struct tipc_topsrv *tipc_topsrv(struct net *net)
 	return tipc_net(net)->topsrv;
 }
 
+static inline void tipc_loopback_trace(struct net *net,
+				       struct sk_buff_head *pkts)
+{
+	if (unlikely(tipc_net(net)->loopback_trace))
+		tipc_clone_to_loopback(net, pkts);
+}
+
 static inline unsigned int tipc_hashfn(u32 addr)
 {
 	return addr & (NODE_HTABLE_SIZE - 1);
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 9e106d3..7e58831 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1439,6 +1439,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 	int rc;
 
 	if (in_own_node(net, dnode)) {
+		tipc_loopback_trace(net, list);
 		tipc_sk_rcv(net, list);
 		return 0;
 	}
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index f345662..e3a6ba1 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -40,6 +40,7 @@
 #include "socket.h"
 #include "addr.h"
 #include "msg.h"
+#include "bearer.h"
 #include <net/sock.h>
 #include <linux/module.h>
 
@@ -608,6 +609,7 @@ static void tipc_topsrv_kern_evt(struct net *net, struct tipc_event *evt)
 	memcpy(msg_data(buf_msg(skb)), evt, sizeof(*evt));
 	skb_queue_head_init(&evtq);
 	__skb_queue_tail(&evtq, skb);
+	tipc_loopback_trace(net, &evtq);
 	tipc_sk_rcv(net, &evtq);
 }
 
-- 
2.11.0

