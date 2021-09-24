Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A560F417DA7
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347579AbhIXWNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:13:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49796 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345286AbhIXWNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:13:01 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9169A63EBB;
        Sat, 25 Sep 2021 00:10:06 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 12/15] netfilter: nf_nat_masquerade: defer conntrack walk to work queue
Date:   Sat, 25 Sep 2021 00:11:10 +0200
Message-Id: <20210924221113.348767-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924221113.348767-1-pablo@netfilter.org>
References: <20210924221113.348767-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The ipv4 and device notifiers are called with RTNL mutex held.
The table walk can take some time, better not block other RTNL users.

'ip a' has been reported to block for up to 20 seconds when conntrack table
has many entries and device down events are frequent (e.g., PPP).

Reported-and-tested-by: Martin Zaharinov <micron10@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_masquerade.c | 50 +++++++++++++++----------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 415919a6ac1a..acd73f717a08 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -131,13 +131,14 @@ static void nf_nat_masq_schedule(struct net *net, union nf_inet_addr *addr,
 	put_net(net);
 }
 
-static int device_cmp(struct nf_conn *i, void *ifindex)
+static int device_cmp(struct nf_conn *i, void *arg)
 {
 	const struct nf_conn_nat *nat = nfct_nat(i);
+	const struct masq_dev_work *w = arg;
 
 	if (!nat)
 		return 0;
-	return nat->masq_index == (int)(long)ifindex;
+	return nat->masq_index == w->ifindex;
 }
 
 static int masq_device_event(struct notifier_block *this,
@@ -153,8 +154,8 @@ static int masq_device_event(struct notifier_block *this,
 		 * and forget them.
 		 */
 
-		nf_ct_iterate_cleanup_net(net, device_cmp,
-					  (void *)(long)dev->ifindex, 0, 0);
+		nf_nat_masq_schedule(net, NULL, dev->ifindex,
+				     device_cmp, GFP_KERNEL);
 	}
 
 	return NOTIFY_DONE;
@@ -162,35 +163,45 @@ static int masq_device_event(struct notifier_block *this,
 
 static int inet_cmp(struct nf_conn *ct, void *ptr)
 {
-	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
-	struct net_device *dev = ifa->ifa_dev->dev;
 	struct nf_conntrack_tuple *tuple;
+	struct masq_dev_work *w = ptr;
 
-	if (!device_cmp(ct, (void *)(long)dev->ifindex))
+	if (!device_cmp(ct, ptr))
 		return 0;
 
 	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 
-	return ifa->ifa_address == tuple->dst.u3.ip;
+	return nf_inet_addr_cmp(&w->addr, &tuple->dst.u3);
 }
 
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
-	struct in_device *idev = ((struct in_ifaddr *)ptr)->ifa_dev;
-	struct net *net = dev_net(idev->dev);
+	const struct in_ifaddr *ifa = ptr;
+	const struct in_device *idev;
+	const struct net_device *dev;
+	union nf_inet_addr addr;
+
+	if (event != NETDEV_DOWN)
+		return NOTIFY_DONE;
 
 	/* The masq_dev_notifier will catch the case of the device going
 	 * down.  So if the inetdev is dead and being destroyed we have
 	 * no work to do.  Otherwise this is an individual address removal
 	 * and we have to perform the flush.
 	 */
+	idev = ifa->ifa_dev;
 	if (idev->dead)
 		return NOTIFY_DONE;
 
-	if (event == NETDEV_DOWN)
-		nf_ct_iterate_cleanup_net(net, inet_cmp, ptr, 0, 0);
+	memset(&addr, 0, sizeof(addr));
+
+	addr.ip = ifa->ifa_address;
+
+	dev = idev->dev;
+	nf_nat_masq_schedule(dev_net(idev->dev), &addr, dev->ifindex,
+			     inet_cmp, GFP_KERNEL);
 
 	return NOTIFY_DONE;
 }
@@ -253,19 +264,6 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 }
 EXPORT_SYMBOL_GPL(nf_nat_masquerade_ipv6);
 
-static int inet6_cmp(struct nf_conn *ct, void *work)
-{
-	struct masq_dev_work *w = (struct masq_dev_work *)work;
-	struct nf_conntrack_tuple *tuple;
-
-	if (!device_cmp(ct, (void *)(long)w->ifindex))
-		return 0;
-
-	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-
-	return nf_inet_addr_cmp(&w->addr, &tuple->dst.u3);
-}
-
 /* atomic notifier; can't call nf_ct_iterate_cleanup_net (it can sleep).
  *
  * Defer it to the system workqueue.
@@ -289,7 +287,7 @@ static int masq_inet6_event(struct notifier_block *this,
 
 	addr.in6 = ifa->addr;
 
-	nf_nat_masq_schedule(dev_net(dev), &addr, dev->ifindex, inet6_cmp,
+	nf_nat_masq_schedule(dev_net(dev), &addr, dev->ifindex, inet_cmp,
 			     GFP_ATOMIC);
 	return NOTIFY_DONE;
 }
-- 
2.30.2

