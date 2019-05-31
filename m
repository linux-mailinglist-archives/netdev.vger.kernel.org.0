Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5058630E1D
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfEaM3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:29:39 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60482 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727106AbfEaM3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 08:29:39 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hWgfA-0004JQ-Vs; Fri, 31 May 2019 14:29:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v2 2/7] net: inetdevice: provide replacement iterators for in_ifaddr walk
Date:   Fri, 31 May 2019 14:22:09 +0200
Message-Id: <20190531122214.18616-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531122214.18616-1-fw@strlen.de>
References: <20190531122214.18616-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ifa_list is protected either by rcu or rtnl lock, but the
current iterators do not account for this.

This adds two iterators as replacement, a later patch in
the series will update them with the needed rcu/rtnl_dereference calls.

Its not done in this patch yet to avoid sparse warnings -- the fields
lack the proper __rcu annotation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/inetdevice.h | 10 +++++++++-
 net/ipv4/devinet.c         | 31 ++++++++++++++++---------------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 367dc2a0f84a..d5d05503a04b 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -186,7 +186,7 @@ __be32 inet_confirm_addr(struct net *net, struct in_device *in_dev, __be32 dst,
 struct in_ifaddr *inet_ifa_byprefix(struct in_device *in_dev, __be32 prefix,
 				    __be32 mask);
 struct in_ifaddr *inet_lookup_ifaddr_rcu(struct net *net, __be32 addr);
-static __inline__ bool inet_ifa_match(__be32 addr, struct in_ifaddr *ifa)
+static inline bool inet_ifa_match(__be32 addr, const struct in_ifaddr *ifa)
 {
 	return !((addr^ifa->ifa_address)&ifa->ifa_mask);
 }
@@ -215,6 +215,14 @@ static __inline__ bool bad_mask(__be32 mask, __be32 addr)
 
 #define endfor_ifa(in_dev) }
 
+#define in_dev_for_each_ifa_rtnl(ifa, in_dev)			\
+	for (ifa = (in_dev)->ifa_list; ifa;			\
+	     ifa = ifa->ifa_next)
+
+#define in_dev_for_each_ifa_rcu(ifa, in_dev)			\
+	for (ifa = (in_dev)->ifa_list; ifa;			\
+	     ifa = ifa->ifa_next)
+
 static inline struct in_device *__in_dev_get_rcu(const struct net_device *dev)
 {
 	return rcu_dereference(dev->ip_ptr);
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 701c5d113a34..7803a4d2951c 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -873,13 +873,12 @@ static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
 static struct in_ifaddr *find_matching_ifa(struct in_ifaddr *ifa)
 {
 	struct in_device *in_dev = ifa->ifa_dev;
-	struct in_ifaddr *ifa1, **ifap;
+	struct in_ifaddr *ifa1;
 
 	if (!ifa->ifa_local)
 		return NULL;
 
-	for (ifap = &in_dev->ifa_list; (ifa1 = *ifap) != NULL;
-	     ifap = &ifa1->ifa_next) {
+	in_dev_for_each_ifa_rtnl(ifa1, in_dev) {
 		if (ifa1->ifa_mask == ifa->ifa_mask &&
 		    inet_ifa_match(ifa1->ifa_address, ifa) &&
 		    ifa1->ifa_local == ifa->ifa_local)
@@ -1208,7 +1207,7 @@ int devinet_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr)
 static int inet_gifconf(struct net_device *dev, char __user *buf, int len, int size)
 {
 	struct in_device *in_dev = __in_dev_get_rtnl(dev);
-	struct in_ifaddr *ifa;
+	const struct in_ifaddr *ifa;
 	struct ifreq ifr;
 	int done = 0;
 
@@ -1218,7 +1217,7 @@ static int inet_gifconf(struct net_device *dev, char __user *buf, int len, int s
 	if (!in_dev)
 		goto out;
 
-	for (ifa = in_dev->ifa_list; ifa; ifa = ifa->ifa_next) {
+	in_dev_for_each_ifa_rtnl(ifa, in_dev) {
 		if (!buf) {
 			done += size;
 			continue;
@@ -1321,10 +1320,11 @@ EXPORT_SYMBOL(inet_select_addr);
 static __be32 confirm_addr_indev(struct in_device *in_dev, __be32 dst,
 			      __be32 local, int scope)
 {
-	int same = 0;
+	const struct in_ifaddr *ifa;
 	__be32 addr = 0;
+	int same = 0;
 
-	for_ifa(in_dev) {
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
 		if (!addr &&
 		    (local == ifa->ifa_local || !local) &&
 		    ifa->ifa_scope <= scope) {
@@ -1350,7 +1350,7 @@ static __be32 confirm_addr_indev(struct in_device *in_dev, __be32 dst,
 				same = 0;
 			}
 		}
-	} endfor_ifa(in_dev);
+	}
 
 	return same ? addr : 0;
 }
@@ -1424,7 +1424,7 @@ static void inetdev_changename(struct net_device *dev, struct in_device *in_dev)
 	struct in_ifaddr *ifa;
 	int named = 0;
 
-	for (ifa = in_dev->ifa_list; ifa; ifa = ifa->ifa_next) {
+	in_dev_for_each_ifa_rtnl(ifa, in_dev) {
 		char old[IFNAMSIZ], *dot;
 
 		memcpy(old, ifa->ifa_label, IFNAMSIZ);
@@ -1454,10 +1454,9 @@ static void inetdev_send_gratuitous_arp(struct net_device *dev,
 					struct in_device *in_dev)
 
 {
-	struct in_ifaddr *ifa;
+	const struct in_ifaddr *ifa;
 
-	for (ifa = in_dev->ifa_list; ifa;
-	     ifa = ifa->ifa_next) {
+	in_dev_for_each_ifa_rtnl(ifa, in_dev) {
 		arp_send(ARPOP_REQUEST, ETH_P_ARP,
 			 ifa->ifa_local, dev,
 			 ifa->ifa_local, NULL,
@@ -1727,15 +1726,17 @@ static int in_dev_dump_addr(struct in_device *in_dev, struct sk_buff *skb,
 	int ip_idx = 0;
 	int err;
 
-	for (ifa = in_dev->ifa_list; ifa; ifa = ifa->ifa_next, ip_idx++) {
-		if (ip_idx < s_ip_idx)
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
+		if (ip_idx < s_ip_idx) {
+			ip_idx++;
 			continue;
-
+		}
 		err = inet_fill_ifaddr(skb, ifa, fillargs);
 		if (err < 0)
 			goto done;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+		ip_idx++;
 	}
 	err = 0;
 
-- 
2.21.0

