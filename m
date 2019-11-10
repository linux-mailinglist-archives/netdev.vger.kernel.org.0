Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA28F6425
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 03:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbfKJC5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:57:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729411AbfKJC4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 303D82256C;
        Sun, 10 Nov 2019 02:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354117;
        bh=6A8AMzApxeD633JBTo2GcM4Q0z+6kicVCh4alMGaeGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZjaBEQ9ZgqYfScvNWKnHhnt8vYWTtTplqj3ZEDiyRBeCgOW/+YfOOZZj2qhRIRbH
         DMnTwb0HkGa0eFdZdOQKLCa1N4++qS71jxVX7SZZvmEh2s4WQlepAjJgtMiK3j3PZx
         r1xhOl71tXILjrUARig8yg3m+acREg8+nivlauEY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tan Hu <tan.hu@zte.com.cn>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 105/109] netfilter: masquerade: don't flush all conntracks if only one address deleted on device
Date:   Sat,  9 Nov 2019 21:45:37 -0500
Message-Id: <20191110024541.31567-105-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Hu <tan.hu@zte.com.cn>

[ Upstream commit 097f95d319f817e651bd51f8846aced92a55a6a1 ]

We configured iptables as below, which only allowed incoming data on
established connections:

iptables -t mangle -A PREROUTING -m state --state ESTABLISHED -j ACCEPT
iptables -t mangle -P PREROUTING DROP

When deleting a secondary address, current masquerade implements would
flush all conntracks on this device. All the established connections on
primary address also be deleted, then subsequent incoming data on the
connections would be dropped wrongly because it was identified as NEW
connection.

So when an address was delete, it should only flush connections related
with the address.

Signed-off-by: Tan Hu <tan.hu@zte.com.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 22 ++++++++++++++++++---
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 19 +++++++++++++++---
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
index 0c366aad89cb4..b531fe204323d 100644
--- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
@@ -105,12 +105,26 @@ static int masq_device_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
+static int inet_cmp(struct nf_conn *ct, void *ptr)
+{
+	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
+	struct net_device *dev = ifa->ifa_dev->dev;
+	struct nf_conntrack_tuple *tuple;
+
+	if (!device_cmp(ct, (void *)(long)dev->ifindex))
+		return 0;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	return ifa->ifa_address == tuple->dst.u3.ip;
+}
+
 static int masq_inet_event(struct notifier_block *this,
 			   unsigned long event,
 			   void *ptr)
 {
 	struct in_device *idev = ((struct in_ifaddr *)ptr)->ifa_dev;
-	struct netdev_notifier_info info;
+	struct net *net = dev_net(idev->dev);
 
 	/* The masq_dev_notifier will catch the case of the device going
 	 * down.  So if the inetdev is dead and being destroyed we have
@@ -120,8 +134,10 @@ static int masq_inet_event(struct notifier_block *this,
 	if (idev->dead)
 		return NOTIFY_DONE;
 
-	netdev_notifier_info_init(&info, idev->dev);
-	return masq_device_event(this, event, &info);
+	if (event == NETDEV_DOWN)
+		nf_ct_iterate_cleanup_net(net, inet_cmp, ptr, 0, 0);
+
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block masq_dev_notifier = {
diff --git a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
index 98f61fcb91088..b0f3745d1bee9 100644
--- a/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
@@ -88,18 +88,30 @@ static struct notifier_block masq_dev_notifier = {
 struct masq_dev_work {
 	struct work_struct work;
 	struct net *net;
+	struct in6_addr addr;
 	int ifindex;
 };
 
+static int inet_cmp(struct nf_conn *ct, void *work)
+{
+	struct masq_dev_work *w = (struct masq_dev_work *)work;
+	struct nf_conntrack_tuple *tuple;
+
+	if (!device_cmp(ct, (void *)(long)w->ifindex))
+		return 0;
+
+	tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+
+	return ipv6_addr_equal(&w->addr, &tuple->dst.u3.in6);
+}
+
 static void iterate_cleanup_work(struct work_struct *work)
 {
 	struct masq_dev_work *w;
-	long index;
 
 	w = container_of(work, struct masq_dev_work, work);
 
-	index = w->ifindex;
-	nf_ct_iterate_cleanup_net(w->net, device_cmp, (void *)index, 0, 0);
+	nf_ct_iterate_cleanup_net(w->net, inet_cmp, (void *)w, 0, 0);
 
 	put_net(w->net);
 	kfree(w);
@@ -148,6 +160,7 @@ static int masq_inet_event(struct notifier_block *this,
 		INIT_WORK(&w->work, iterate_cleanup_work);
 		w->ifindex = dev->ifindex;
 		w->net = net;
+		w->addr = ifa->addr;
 		schedule_work(&w->work);
 
 		return NOTIFY_DONE;
-- 
2.20.1

