Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3486842C2
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 05:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfHGDCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 23:02:40 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:37649 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726334AbfHGDCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 23:02:39 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2019 23:02:37 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id F40DA487AC;
        Wed,  7 Aug 2019 12:52:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1565146376; bh=ChSX3
        qnsAtpC1NbJNFuZA3+cM9Wc+xs3zJ81PezW2AI=; b=DWblle9lD5gMJwBU8NWYh
        Urh/NNC93eENh6iEJHRR3kxgDddZ+rBNZxIwsxlm3CER6mw0a9JOyispkVnQQlbX
        idg3a5EsX64NokPl63f5LBCUL8QNIHFZsRXkgabPYTK9VVMChjrab4LfeFgWTqyP
        BCoVph7/HZggWGg0bbdxfo=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mbHtgmuJNNZw; Wed,  7 Aug 2019 12:52:56 +1000 (AEST)
Received: from cba01.dek-tpc.internal (cba01.dek-tpc.internal [172.16.83.49])
        by mail.dektech.com.au (Postfix) with ESMTP id D02F348755;
        Wed,  7 Aug 2019 12:52:56 +1000 (AEST)
Received: by cba01.dek-tpc.internal (Postfix, from userid 1014)
        id 7F7E318179D; Wed,  7 Aug 2019 12:52:56 +1000 (AEST)
From:   john.rutherford@dektech.com.au
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Cc:     John Rutherford <john.rutherford@dektech.com.au>
Subject: [net-next v3] tipc: add loopback device tracking
Date:   Wed,  7 Aug 2019 12:52:29 +1000
Message-Id: <20190807025229.1599-1-john.rutherford@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Rutherford <john.rutherford@dektech.com.au>

Since node internal messages are passed directly to the socket, it is not
possible to observe those messages via tcpdump or wireshark.

We now remedy this by making it possible to clone such messages and send
the clones to the loopback interface.  The clones are dropped at reception
and have no functional role except making the traffic visible.

The feature is enabled if network taps are active for the loopback device.
pcap filtering restrictions require the messages to be presented to the
receiving side of the loopback device.

v3 - Function dev_nit_active used to check for network taps.
   - Procedure netif_rx_ni used to send cloned messages to loopback device.

Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
---
 net/tipc/bcast.c  |  4 +++-
 net/tipc/bearer.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 net/tipc/bearer.h | 10 +++++++++
 net/tipc/core.c   |  5 +++++
 net/tipc/core.h   |  3 +++
 net/tipc/node.c   |  1 +
 net/tipc/topsrv.c |  2 ++
 7 files changed, 88 insertions(+), 1 deletion(-)

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
index 2bed658..93c9616 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -389,6 +389,11 @@ int tipc_enable_l2_media(struct net *net, struct tipc_bearer *b,
 		dev_put(dev);
 		return -EINVAL;
 	}
+	if (dev == net->loopback_dev) {
+		dev_put(dev);
+		pr_info("Enabling <%s> not permitted\n", b->name);
+		return -EINVAL;
+	}
 
 	/* Autoconfigure own node identity if needed */
 	if (!tipc_own_id(net) && hwaddr_len <= NODE_ID_LEN) {
@@ -674,6 +679,65 @@ void tipc_bearer_stop(struct net *net)
 	}
 }
 
+void tipc_clone_to_loopback(struct net *net, struct sk_buff_head *pkts)
+{
+	struct net_device *dev = net->loopback_dev;
+	struct sk_buff *skb, *_skb;
+	int exp;
+
+	skb_queue_walk(pkts, _skb) {
+		skb = pskb_copy(_skb, GFP_ATOMIC);
+		if (!skb)
+			continue;
+
+		exp = SKB_DATA_ALIGN(dev->hard_header_len - skb_headroom(skb));
+		if (exp > 0 && pskb_expand_head(skb, exp, 0, GFP_ATOMIC)) {
+			kfree_skb(skb);
+			continue;
+		}
+
+		skb_reset_network_header(skb);
+		dev_hard_header(skb, dev, ETH_P_TIPC, dev->dev_addr,
+				dev->dev_addr, skb->len);
+		skb->dev = dev;
+		skb->pkt_type = PACKET_HOST;
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+		skb->protocol = eth_type_trans(skb, dev);
+		netif_rx_ni(skb);
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
+
+	dev_hold(dev);
+	tn->loopback_pt.dev = dev;
+	tn->loopback_pt.type = htons(ETH_P_TIPC);
+	tn->loopback_pt.func = tipc_loopback_rcv_pkt;
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
 /* Caller should hold rtnl_lock to protect the bearer */
 static int __tipc_nl_add_bearer(struct tipc_nl_msg *msg,
 				struct tipc_bearer *bearer, int nlflags)
diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index 7f4c569..ea0f3c4 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -232,6 +232,16 @@ void tipc_bearer_xmit(struct net *net, u32 bearer_id,
 		      struct tipc_media_addr *dst);
 void tipc_bearer_bc_xmit(struct net *net, u32 bearer_id,
 			 struct sk_buff_head *xmitq);
+void tipc_clone_to_loopback(struct net *net, struct sk_buff_head *pkts);
+int tipc_attach_loopback(struct net *net);
+void tipc_detach_loopback(struct net *net);
+
+static inline void tipc_loopback_trace(struct net *net,
+				       struct sk_buff_head *pkts)
+{
+	if (unlikely(dev_nit_active(net->loopback_dev)))
+		tipc_clone_to_loopback(net, pkts);
+}
 
 /* check if device MTU is too low for tipc headers */
 static inline bool tipc_mtu_bad(struct net_device *dev, unsigned int reserve)
diff --git a/net/tipc/core.c b/net/tipc/core.c
index c837072..23cb379 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -82,6 +82,10 @@ static int __net_init tipc_init_net(struct net *net)
 	if (err)
 		goto out_bclink;
 
+	err = tipc_attach_loopback(net);
+	if (err)
+		goto out_bclink;
+
 	return 0;
 
 out_bclink:
@@ -94,6 +98,7 @@ static int __net_init tipc_init_net(struct net *net)
 
 static void __net_exit tipc_exit_net(struct net *net)
 {
+	tipc_detach_loopback(net);
 	tipc_net_stop(net);
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 7a68e1b..60d8295 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -125,6 +125,9 @@ struct tipc_net {
 
 	/* Cluster capabilities */
 	u16 capabilities;
+
+	/* Tracing of node internal messages */
+	struct packet_type loopback_pt;
 };
 
 static inline struct tipc_net *tipc_net(struct net *net)
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 550581d..16d251b 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1443,6 +1443,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
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

