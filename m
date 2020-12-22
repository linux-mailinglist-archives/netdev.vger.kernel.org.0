Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A022E0A21
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 13:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgLVMnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 07:43:50 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:47483 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726644AbgLVMnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 07:43:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=weichen.chen@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0UJRQD2S_1608640950;
Received: from localhost(mailfrom:weichen.chen@linux.alibaba.com fp:SMTPD_---0UJRQD2S_1608640950)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Dec 2020 20:43:00 +0800
From:   weichenchen <weichen.chen@linux.alibaba.com>
Cc:     splendidsky.cwc@alibaba-inc.com, yanxu.zw@alibaba-inc.com,
        weichenchen <weichen.chen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@kernel.org>, Jeff Dike <jdike@akamai.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: neighbor: fix a crash caused by mod zero
Date:   Tue, 22 Dec 2020 20:38:33 +0800
Message-Id: <20201222123838.12951-1-weichen.chen@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20201221113240.2ae38a77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201221113240.2ae38a77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pneigh_enqueue() tries to obtain a random delay by mod
NEIGH_VAR(p, PROXY_DELAY). However, NEIGH_VAR(p, PROXY_DELAY)
migth be zero at that point because someone could write zero
to /proc/sys/net/ipv4/neigh/[device]/proxy_delay after the
callers check it.

This patch makes pneigh_enqueue() get a delay time passed in
by the callers and the callers guarantee it is not zero.

Signed-off-by: weichenchen <weichen.chen@linux.alibaba.com>
---
V3:
    - Callers need to pass the delay time to pneigh_enqueue()
      now and they should guarantee it is not zero.
    - Use READ_ONCE() to read NEIGH_VAR(p, PROXY_DELAY) in both
      of the existing callers of pneigh_enqueue() and then pass
      it to pneigh_enqueue().
V2:
    - Use READ_ONCE() to prevent the complier from re-reading
      NEIGH_VAR(p, PROXY_DELAY).
    - Give a hint to the complier that delay <= 0 is unlikely
      to happen.
---
 include/net/neighbour.h | 2 +-
 net/core/neighbour.c    | 5 ++---
 net/ipv4/arp.c          | 8 +++++---
 net/ipv6/ndisc.c        | 6 +++---
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 22ced1381ede..f7564dc5304d 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -352,7 +352,7 @@ struct net *neigh_parms_net(const struct neigh_parms *parms)
 unsigned long neigh_rand_reach_time(unsigned long base);
 
 void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
-		    struct sk_buff *skb);
+		    struct sk_buff *skb, int delay);
 struct pneigh_entry *pneigh_lookup(struct neigh_table *tbl, struct net *net,
 				   const void *key, struct net_device *dev,
 				   int creat);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9500d28a43b0..b440f966d109 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1567,12 +1567,11 @@ static void neigh_proxy_process(struct timer_list *t)
 }
 
 void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
-		    struct sk_buff *skb)
+		    struct sk_buff *skb, int delay)
 {
 	unsigned long now = jiffies;
 
-	unsigned long sched_next = now + (prandom_u32() %
-					  NEIGH_VAR(p, PROXY_DELAY));
+	unsigned long sched_next = now + (prandom_u32() % delay);
 
 	if (tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)) {
 		kfree_skb(skb);
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 922dd73e5740..6ddce6e0a648 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -841,20 +841,22 @@ static int arp_process(struct net *net, struct sock *sk, struct sk_buff *skb)
 			     arp_fwd_pvlan(in_dev, dev, rt, sip, tip) ||
 			     (rt->dst.dev != dev &&
 			      pneigh_lookup(&arp_tbl, net, &tip, dev, 0)))) {
+				int delay;
+
 				n = neigh_event_ns(&arp_tbl, sha, &sip, dev);
 				if (n)
 					neigh_release(n);
 
+				delay = READ_ONCE(NEIGH_VAR(in_dev->arp_parms, PROXY_DELAY));
 				if (NEIGH_CB(skb)->flags & LOCALLY_ENQUEUED ||
-				    skb->pkt_type == PACKET_HOST ||
-				    NEIGH_VAR(in_dev->arp_parms, PROXY_DELAY) == 0) {
+				    skb->pkt_type == PACKET_HOST || delay == 0) {
 					arp_send_dst(ARPOP_REPLY, ETH_P_ARP,
 						     sip, dev, tip, sha,
 						     dev->dev_addr, sha,
 						     reply_dst);
 				} else {
 					pneigh_enqueue(&arp_tbl,
-						       in_dev->arp_parms, skb);
+						       in_dev->arp_parms, skb, delay);
 					goto out_free_dst;
 				}
 				goto out_consume_skb;
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 76717478f173..efdaaab47535 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -892,10 +892,10 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 		    (idev->cnf.forwarding &&
 		     (net->ipv6.devconf_all->proxy_ndp || idev->cnf.proxy_ndp) &&
 		     (is_router = pndisc_is_router(&msg->target, dev)) >= 0)) {
+			int delay = READ_ONCE(NEIGH_VAR(idev->nd_parms, PROXY_DELAY));
 			if (!(NEIGH_CB(skb)->flags & LOCALLY_ENQUEUED) &&
 			    skb->pkt_type != PACKET_HOST &&
-			    inc &&
-			    NEIGH_VAR(idev->nd_parms, PROXY_DELAY) != 0) {
+			    inc && delay != 0) {
 				/*
 				 * for anycast or proxy,
 				 * sender should delay its response
@@ -905,7 +905,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 				 */
 				struct sk_buff *n = skb_clone(skb, GFP_ATOMIC);
 				if (n)
-					pneigh_enqueue(&nd_tbl, idev->nd_parms, n);
+					pneigh_enqueue(&nd_tbl, idev->nd_parms, n, delay);
 				goto out;
 			}
 		} else
-- 
2.20.1 (Apple Git-117)

