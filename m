Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DFE422898
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhJENxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235413AbhJENwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6CC2615A6;
        Tue,  5 Oct 2021 13:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441860;
        bh=D+8LE65aJeazr7MPs5PYlzMbV8Jvff7TNv/Kb2Y+raE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbLnrR+u8Jy8bOZ4kWX7v6S46RJIxZrkdtHaQBfMcJLt7cVLuR7QKGeMKm6TDhZwc
         nsf4cS1KOWwurEQP97v1YThe28pnXIA6ju+1mtP4Jv1pCbFTsqZSu4t4HBMaO0Z55c
         qe6WoOD0/1hnh+xXm33HxAIRwf7debwS+ak54MXtTH+v8w7LO8Mbm5yGF1b9JFI89V
         r8lcaeOGMGeRde4x5vy9hIQwQAOaLiMP0IXD7NBWL+Ba98QlO1T/BRRJNJ/h0BAIid
         pO0rveTUyAidRraQ2Ts0hiDjaShomYnsaFF3hvUdUSru8qGsRm2aiQ4UAW6HQDE+T6
         6uby/p1h0H8FQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Martin Zaharinov <micron10@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 19/40] netfilter: nf_nat_masquerade: defer conntrack walk to work queue
Date:   Tue,  5 Oct 2021 09:49:58 -0400
Message-Id: <20211005135020.214291-19-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7970a19b71044bf4dc2c1becc200275bdf1884d4 ]

The ipv4 and device notifiers are called with RTNL mutex held.
The table walk can take some time, better not block other RTNL users.

'ip a' has been reported to block for up to 20 seconds when conntrack table
has many entries and device down events are frequent (e.g., PPP).

Reported-and-tested-by: Martin Zaharinov <micron10@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.33.0

