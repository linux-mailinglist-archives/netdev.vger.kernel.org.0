Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B55731255
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfEaQ1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:27:37 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33376 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbfEaQ1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:27:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hWkNT-0005gy-7v; Fri, 31 May 2019 18:27:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v3 5/7] net: use new in_dev_ifa iterators
Date:   Fri, 31 May 2019 18:27:07 +0200
Message-Id: <20190531162709.9895-6-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531162709.9895-1-fw@strlen.de>
References: <20190531162709.9895-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use in_dev_for_each_ifa_rcu/rtnl instead.
This prevents sparse warnings once proper __rcu annotations are added.

Signed-off-by: Florian Westphal <fw@strlen.de>

t di# Last commands done (6 commands done):
---
 net/ipv4/fib_frontend.c | 24 +++++++++++++++++-------
 net/ipv4/igmp.c         |  5 +++--
 net/ipv6/addrconf.c     |  4 +---
 net/sctp/protocol.c     |  2 +-
 net/smc/smc_clc.c       | 11 +++++++----
 5 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 76055c66326a..c7cdb8d0d164 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -540,14 +540,22 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 		cfg->fc_oif = dev->ifindex;
 		cfg->fc_table = l3mdev_fib_table(dev);
 		if (colon) {
-			struct in_ifaddr *ifa;
-			struct in_device *in_dev = __in_dev_get_rtnl(dev);
+			const struct in_ifaddr *ifa;
+			struct in_device *in_dev;
+
+			in_dev = __in_dev_get_rtnl(dev);
 			if (!in_dev)
 				return -ENODEV;
+
 			*colon = ':';
-			for (ifa = in_dev->ifa_list; ifa; ifa = ifa->ifa_next)
+
+			rcu_read_lock();
+			in_dev_for_each_ifa_rcu(ifa, in_dev) {
 				if (strcmp(ifa->ifa_label, devname) == 0)
 					break;
+			}
+			rcu_read_unlock();
+
 			if (!ifa)
 				return -ENODEV;
 			cfg->fc_prefsrc = ifa->ifa_local;
@@ -1177,8 +1185,8 @@ void fib_del_ifaddr(struct in_ifaddr *ifa, struct in_ifaddr *iprim)
 	 *
 	 * Scan address list to be sure that addresses are really gone.
 	 */
-
-	for (ifa1 = in_dev->ifa_list; ifa1; ifa1 = ifa1->ifa_next) {
+	rcu_read_lock();
+	in_dev_for_each_ifa_rcu(ifa1, in_dev) {
 		if (ifa1 == ifa) {
 			/* promotion, keep the IP */
 			gone = 0;
@@ -1246,6 +1254,7 @@ void fib_del_ifaddr(struct in_ifaddr *ifa, struct in_ifaddr *iprim)
 			}
 		}
 	}
+	rcu_read_unlock();
 
 no_promotions:
 	if (!(ok & BRD_OK))
@@ -1415,6 +1424,7 @@ static int fib_netdev_event(struct notifier_block *this, unsigned long event, vo
 	struct netdev_notifier_info_ext *info_ext = ptr;
 	struct in_device *in_dev;
 	struct net *net = dev_net(dev);
+	struct in_ifaddr *ifa;
 	unsigned int flags;
 
 	if (event == NETDEV_UNREGISTER) {
@@ -1429,9 +1439,9 @@ static int fib_netdev_event(struct notifier_block *this, unsigned long event, vo
 
 	switch (event) {
 	case NETDEV_UP:
-		for_ifa(in_dev) {
+		in_dev_for_each_ifa_rtnl(ifa, in_dev) {
 			fib_add_ifaddr(ifa);
-		} endfor_ifa(in_dev);
+		}
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 		fib_sync_up(dev, RTNH_F_DEAD);
 #endif
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6c2febc39dca..719bd8e4eea4 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -325,14 +325,15 @@ static __be32 igmpv3_get_srcaddr(struct net_device *dev,
 				 const struct flowi4 *fl4)
 {
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	const struct in_ifaddr *ifa;
 
 	if (!in_dev)
 		return htonl(INADDR_ANY);
 
-	for_ifa(in_dev) {
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
 		if (fl4->saddr == ifa->ifa_local)
 			return fl4->saddr;
-	} endfor_ifa(in_dev);
+	}
 
 	return htonl(INADDR_ANY);
 }
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 683613e7355b..40b154d45ab4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3127,11 +3127,9 @@ static void sit_add_v4_addrs(struct inet6_dev *idev)
 		struct in_device *in_dev = __in_dev_get_rtnl(dev);
 		if (in_dev && (dev->flags & IFF_UP)) {
 			struct in_ifaddr *ifa;
-
 			int flag = scope;
 
-			for (ifa = in_dev->ifa_list; ifa; ifa = ifa->ifa_next) {
-
+			in_dev_for_each_ifa_rtnl(ifa, in_dev) {
 				addr.s6_addr32[3] = ifa->ifa_local;
 
 				if (ifa->ifa_scope == RT_SCOPE_LINK)
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index f0631bf486b6..e29cf27cb633 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -96,7 +96,7 @@ static void sctp_v4_copy_addrlist(struct list_head *addrlist,
 		return;
 	}
 
-	for (ifa = in_dev->ifa_list; ifa; ifa = ifa->ifa_next) {
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
 		/* Add the address to the local list.  */
 		addr = kzalloc(sizeof(*addr), GFP_ATOMIC);
 		if (addr) {
diff --git a/net/smc/smc_clc.c b/net/smc/smc_clc.c
index 745afd82f281..49bcebff6378 100644
--- a/net/smc/smc_clc.c
+++ b/net/smc/smc_clc.c
@@ -97,17 +97,19 @@ static int smc_clc_prfx_set4_rcu(struct dst_entry *dst, __be32 ipv4,
 				 struct smc_clc_msg_proposal_prefix *prop)
 {
 	struct in_device *in_dev = __in_dev_get_rcu(dst->dev);
+	const struct in_ifaddr *ifa;
 
 	if (!in_dev)
 		return -ENODEV;
-	for_ifa(in_dev) {
+
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
 		if (!inet_ifa_match(ipv4, ifa))
 			continue;
 		prop->prefix_len = inet_mask_len(ifa->ifa_mask);
 		prop->outgoing_subnet = ifa->ifa_address & ifa->ifa_mask;
 		/* prop->ipv6_prefixes_cnt = 0; already done by memset before */
 		return 0;
-	} endfor_ifa(in_dev);
+	}
 	return -ENOENT;
 }
 
@@ -190,14 +192,15 @@ static int smc_clc_prfx_match4_rcu(struct net_device *dev,
 				   struct smc_clc_msg_proposal_prefix *prop)
 {
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
+	const struct in_ifaddr *ifa;
 
 	if (!in_dev)
 		return -ENODEV;
-	for_ifa(in_dev) {
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
 		if (prop->prefix_len == inet_mask_len(ifa->ifa_mask) &&
 		    inet_ifa_match(prop->outgoing_subnet, ifa))
 			return 0;
-	} endfor_ifa(in_dev);
+	}
 
 	return -ENOENT;
 }
-- 
2.21.0

