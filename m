Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C831330E20
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfEaM3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:29:44 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60490 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727263AbfEaM3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 08:29:42 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hWgfD-0004Jj-TA; Fri, 31 May 2019 14:29:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v2 4/7] netfilter: use in_dev_for_each_ifa_rcu
Date:   Fri, 31 May 2019 14:22:11 +0200
Message-Id: <20190531122214.18616-5-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531122214.18616-1-fw@strlen.de>
References: <20190531122214.18616-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netfilter hooks are always running under rcu read lock, use
the new iterator macro so sparse won't complain once we add
proper __rcu annotations.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_tproxy_ipv4.c    | 9 +++++++--
 net/netfilter/nf_conntrack_broadcast.c | 9 +++++++--
 net/netfilter/nfnetlink_osf.c          | 5 ++---
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 164714104965..40c93b3bd731 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -53,6 +53,7 @@ EXPORT_SYMBOL_GPL(nf_tproxy_handle_time_wait4);
 
 __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
 {
+	const struct in_ifaddr *ifa;
 	struct in_device *indev;
 	__be32 laddr;
 
@@ -61,10 +62,14 @@ __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
 
 	laddr = 0;
 	indev = __in_dev_get_rcu(skb->dev);
-	for_primary_ifa(indev) {
+
+	in_dev_for_each_ifa_rcu(ifa, indev) {
+		if (ifa->ifa_flags & IFA_F_SECONDARY)
+			continue;
+
 		laddr = ifa->ifa_local;
 		break;
-	} endfor_ifa(indev);
+	}
 
 	return laddr ? laddr : daddr;
 }
diff --git a/net/netfilter/nf_conntrack_broadcast.c b/net/netfilter/nf_conntrack_broadcast.c
index 5423b197d98a..a5dbc3676a4f 100644
--- a/net/netfilter/nf_conntrack_broadcast.c
+++ b/net/netfilter/nf_conntrack_broadcast.c
@@ -41,12 +41,17 @@ int nf_conntrack_broadcast_help(struct sk_buff *skb,
 
 	in_dev = __in_dev_get_rcu(rt->dst.dev);
 	if (in_dev != NULL) {
-		for_primary_ifa(in_dev) {
+		const struct in_ifaddr *ifa;
+
+		in_dev_for_each_ifa_rcu(ifa, in_dev) {
+			if (ifa->ifa_flags & IFA_F_SECONDARY)
+				continue;
+
 			if (ifa->ifa_broadcast == iph->daddr) {
 				mask = ifa->ifa_mask;
 				break;
 			}
-		} endfor_ifa(in_dev);
+		}
 	}
 
 	if (mask == 0)
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index f42326b40d6f..9f5dea0064ea 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -33,6 +33,7 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 {
 	struct in_device *in_dev = __in_dev_get_rcu(skb->dev);
 	const struct iphdr *ip = ip_hdr(skb);
+	const struct in_ifaddr *ifa;
 	int ret = 0;
 
 	if (ttl_check == NF_OSF_TTL_TRUE)
@@ -42,15 +43,13 @@ static inline int nf_osf_ttl(const struct sk_buff *skb,
 	else if (ip->ttl <= f_ttl)
 		return 1;
 
-	for_ifa(in_dev) {
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
 		if (inet_ifa_match(ip->saddr, ifa)) {
 			ret = (ip->ttl == f_ttl);
 			break;
 		}
 	}
 
-	endfor_ifa(in_dev);
-
 	return ret;
 }
 
-- 
2.21.0

