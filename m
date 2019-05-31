Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D16B31252
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfEaQ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:27:30 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33370 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726818AbfEaQ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:27:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hWkNL-0005gV-PE; Fri, 31 May 2019 18:27:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v3 3/7] devinet: use in_dev_for_each_ifa_rcu in more places
Date:   Fri, 31 May 2019 18:27:05 +0200
Message-Id: <20190531162709.9895-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531162709.9895-1-fw@strlen.de>
References: <20190531162709.9895-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This also replaces spots that used for_primary_ifa().

for_primary_ifa() aborts the loop on the first secondary address seen.

Replace it with either the rcu or rtnl variant of in_dev_for_each_ifa(),
but two places will now also consider secondary addresses too:
inet_addr_onlink() and inet_ifa_byprefix().

I do not understand why they should ignore secondary addresses.

Why would a secondary address not be considered 'on link'?
When matching a prefix, why ignore a matching secondary address?

Other places get converted as well, but gain "->flags & SECONDARY" check.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/devinet.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 7803a4d2951c..b45421b2b734 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -327,15 +327,17 @@ static void inetdev_destroy(struct in_device *in_dev)
 
 int inet_addr_onlink(struct in_device *in_dev, __be32 a, __be32 b)
 {
+	const struct in_ifaddr *ifa;
+
 	rcu_read_lock();
-	for_primary_ifa(in_dev) {
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
 		if (inet_ifa_match(a, ifa)) {
 			if (!b || inet_ifa_match(b, ifa)) {
 				rcu_read_unlock();
 				return 1;
 			}
 		}
-	} endfor_ifa(in_dev);
+	}
 	rcu_read_unlock();
 	return 0;
 }
@@ -580,12 +582,14 @@ EXPORT_SYMBOL(inetdev_by_index);
 struct in_ifaddr *inet_ifa_byprefix(struct in_device *in_dev, __be32 prefix,
 				    __be32 mask)
 {
+	struct in_ifaddr *ifa;
+
 	ASSERT_RTNL();
 
-	for_primary_ifa(in_dev) {
+	in_dev_for_each_ifa_rtnl(ifa, in_dev) {
 		if (ifa->ifa_mask == mask && inet_ifa_match(prefix, ifa))
 			return ifa;
-	} endfor_ifa(in_dev);
+	}
 	return NULL;
 }
 
@@ -1245,17 +1249,22 @@ static int inet_gifconf(struct net_device *dev, char __user *buf, int len, int s
 static __be32 in_dev_select_addr(const struct in_device *in_dev,
 				 int scope)
 {
-	for_primary_ifa(in_dev) {
+	const struct in_ifaddr *ifa;
+
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
+		if (ifa->ifa_flags & IFA_F_SECONDARY)
+			continue;
 		if (ifa->ifa_scope != RT_SCOPE_LINK &&
 		    ifa->ifa_scope <= scope)
 			return ifa->ifa_local;
-	} endfor_ifa(in_dev);
+	}
 
 	return 0;
 }
 
 __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 {
+	const struct in_ifaddr *ifa;
 	__be32 addr = 0;
 	struct in_device *in_dev;
 	struct net *net = dev_net(dev);
@@ -1266,7 +1275,9 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 	if (!in_dev)
 		goto no_in_dev;
 
-	for_primary_ifa(in_dev) {
+	in_dev_for_each_ifa_rcu(ifa, in_dev) {
+		if (ifa->ifa_flags & IFA_F_SECONDARY)
+			continue;
 		if (ifa->ifa_scope > scope)
 			continue;
 		if (!dst || inet_ifa_match(dst, ifa)) {
@@ -1275,7 +1286,7 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 		}
 		if (!addr)
 			addr = ifa->ifa_local;
-	} endfor_ifa(in_dev);
+	}
 
 	if (addr)
 		goto out_unlock;
-- 
2.21.0

