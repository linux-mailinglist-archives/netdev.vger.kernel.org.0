Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548D82B1426
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgKMCGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:06:45 -0500
Received: from smtp.netregistry.net ([202.124.241.204]:46828 "EHLO
        smtp.netregistry.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgKMCGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 21:06:44 -0500
Received: from 124-148-94-203.tpgi.com.au ([124.148.94.203]:42516 helo=192-168-1-16.tpgi.com.au)
        by smtp-1.servers.netregistry.net protocol: esmtpa (Exim 4.84_2 #1 (Debian))
        id 1kdOU2-0006ji-UT
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:06:42 +1100
Date:   Fri, 13 Nov 2020 12:06:37 +1000
From:   Russell Strong <russell@strong.id.au>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: DSCP in IPv4 routing
Message-ID: <20201113120637.39c45f3f@192-168-1-16.tpgi.com.au>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Authenticated-User: russell@strong.id.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TOS handling in ipv4 routing does not support using dscp.
This change widens masks to use the 6 DSCP bits in routing.

Tested with

ip rule add dsfield EF lookup main
ip rule
0:	from all lookup local
32765:	from all tos EF lookup main
32766:	from all lookup main
32767:	from all lookup default

and verified that lookups are indeed performed from the
correct table.

This now works instead of failing with "Error: Invalid tos."

Signed-off-by: Russell Strong <russell@strong.id.au>
---
 include/net/route.h           | 2 +-
 include/uapi/linux/in_route.h | 2 +-
 include/uapi/linux/ip.h       | 2 ++
 net/ipv4/fib_rules.c          | 2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index ff021cab657e..519448ad37d0 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -255,7 +255,7 @@ static inline void ip_rt_put(struct rtable *rt)
 	dst_release(&rt->dst);
 }
 
-#define IPTOS_RT_MASK	(IPTOS_TOS_MASK & ~3)
+#define IPTOS_RT_MASK	(IPTOS_DS_MASK & ~3)
 
 extern const __u8 ip_tos2prio[16];
 
diff --git a/include/uapi/linux/in_route.h
b/include/uapi/linux/in_route.h index 0cc2c23b47f8..db5d236b9c50 100644
--- a/include/uapi/linux/in_route.h
+++ b/include/uapi/linux/in_route.h
@@ -28,6 +28,6 @@
 
 #define RTCF_NAT	(RTCF_DNAT|RTCF_SNAT)
 
-#define RT_TOS(tos)	((tos)&IPTOS_TOS_MASK)
+#define RT_TOS(tos)	((tos)&IPTOS_DS_MASK)
 
 #endif /* _LINUX_IN_ROUTE_H */
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..fafd9470ae78 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -20,6 +20,8 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
+#define IPTOS_DS_MASK		0xfc
+#define IPTOS_DS(tos)		((tos)&IPTOS_DS_MASK)
 #define IPTOS_TOS_MASK		0x1E
 #define IPTOS_TOS(tos)		((tos)&IPTOS_TOS_MASK)
 #define	IPTOS_LOWDELAY		0x10
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index ce54a30c2ef1..1499105d1efd 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -229,7 +229,7 @@ static int fib4_rule_configure(struct fib_rule
*rule, struct sk_buff *skb, int err = -EINVAL;
 	struct fib4_rule *rule4 = (struct fib4_rule *) rule;
 
-	if (frh->tos & ~IPTOS_TOS_MASK) {
+	if (frh->tos & ~IPTOS_RT_MASK) {
 		NL_SET_ERR_MSG(extack, "Invalid tos");
 		goto errout;
 	}
-- 
2.26.2

