Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0963A47495D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhLNR1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhLNR1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:27:48 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19CEC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 09:27:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mxBac-0005RB-Fm; Tue, 14 Dec 2021 18:27:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 1/4] fib: remove suppress indirection
Date:   Tue, 14 Dec 2021 18:27:28 +0100
Message-Id: <20211214172731.3591-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211214172731.3591-1-fw@strlen.de>
References: <20211214172731.3591-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only used by ipv4 and ipv6.
Both functions are small and do not use any internal data
structures.  Move this to core and remove the indirection.

Object size increase is small:
before:
   text	   data	    bss	    dec	    hex	filename
  10335	    158	      0	  10493	   28fd	fib_rules.o
after:
  10615	    158	      0	  10773	   2a15	fib_rules.o

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: don't rely on implicit includes, broke build with IPV6=n.

 include/net/fib_rules.h |  9 -----
 net/core/fib_rules.c    | 88 +++++++++++++++++++++++++++++++++++++++--
 net/ipv4/fib_rules.c    | 34 ----------------
 net/ipv6/fib6_rules.c   | 34 ----------------
 4 files changed, 84 insertions(+), 81 deletions(-)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index bd07484ab9dd..d15e5638b937 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -69,8 +69,6 @@ struct fib_rules_ops {
 	int			(*action)(struct fib_rule *,
 					  struct flowi *, int,
 					  struct fib_lookup_arg *);
-	bool			(*suppress)(struct fib_rule *, int,
-					    struct fib_lookup_arg *);
 	int			(*match)(struct fib_rule *,
 					 struct flowi *, int);
 	int			(*configure)(struct fib_rule *,
@@ -216,11 +214,4 @@ INDIRECT_CALLABLE_DECLARE(int fib6_rule_action(struct fib_rule *rule,
 INDIRECT_CALLABLE_DECLARE(int fib4_rule_action(struct fib_rule *rule,
 			    struct flowi *flp, int flags,
 			    struct fib_lookup_arg *arg));
-
-INDIRECT_CALLABLE_DECLARE(bool fib6_rule_suppress(struct fib_rule *rule,
-						int flags,
-						struct fib_lookup_arg *arg));
-INDIRECT_CALLABLE_DECLARE(bool fib4_rule_suppress(struct fib_rule *rule,
-						int flags,
-						struct fib_lookup_arg *arg));
 #endif
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 1bb567a3b329..52e67f8aa0c5 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -11,9 +11,11 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <net/net_namespace.h>
+#include <net/nexthop.h>
 #include <net/sock.h>
 #include <net/fib_rules.h>
 #include <net/ip_tunnels.h>
+#include <net/ip6_route.h>
 #include <linux/indirect_call_wrapper.h>
 
 #if defined(CONFIG_IPV6) && defined(CONFIG_IPV6_MULTIPLE_TABLES)
@@ -289,6 +291,87 @@ static int fib_rule_match(struct fib_rule *rule, struct fib_rules_ops *ops,
 	return (rule->flags & FIB_RULE_INVERT) ? !ret : ret;
 }
 
+static bool fib4_rule_suppress(struct fib_rule *rule,
+			       int flags,
+			       struct fib_lookup_arg *arg)
+{
+	struct fib_result *result = (struct fib_result *)arg->result;
+	struct net_device *dev = NULL;
+
+	if (result->fi) {
+		struct fib_nh_common *nhc = fib_info_nhc(result->fi, 0);
+
+		dev = nhc->nhc_dev;
+	}
+
+	/* do not accept result if the route does
+	 * not meet the required prefix length
+	 */
+	if (result->prefixlen <= rule->suppress_prefixlen)
+		goto suppress_route;
+
+	/* do not accept result if the route uses a device
+	 * belonging to a forbidden interface group
+	 */
+	if (rule->suppress_ifgroup != -1 && dev && dev->group == rule->suppress_ifgroup)
+		goto suppress_route;
+
+	return false;
+
+suppress_route:
+	if (!(arg->flags & FIB_LOOKUP_NOREF))
+		fib_info_put(result->fi);
+	return true;
+}
+
+static bool fib6_rule_suppress(struct fib_rule *rule,
+			       int flags,
+			       struct fib_lookup_arg *arg)
+{
+	struct fib6_result *res = arg->result;
+	struct rt6_info *rt = res->rt6;
+	struct net_device *dev = NULL;
+
+	if (!rt)
+		return false;
+
+	if (rt->rt6i_idev)
+		dev = rt->rt6i_idev->dev;
+
+	/* do not accept result if the route does
+	 * not meet the required prefix length
+	 */
+	if (rt->rt6i_dst.plen <= rule->suppress_prefixlen)
+		goto suppress_route;
+
+	/* do not accept result if the route uses a device
+	 * belonging to a forbidden interface group
+	 */
+	if (rule->suppress_ifgroup != -1 && dev && dev->group == rule->suppress_ifgroup)
+		goto suppress_route;
+
+	return false;
+
+suppress_route:
+	ip6_rt_put_flags(rt, flags);
+	return true;
+}
+
+static bool fib_rule_suppress(int family,
+			      struct fib_rule *rule,
+			      int flags,
+			      struct fib_lookup_arg *arg)
+{
+	switch (family) {
+	case AF_INET:
+		return fib4_rule_suppress(rule, flags, arg);
+	case AF_INET6:
+		return fib6_rule_suppress(rule, flags, arg);
+	}
+
+	return false;
+}
+
 int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 		     int flags, struct fib_lookup_arg *arg)
 {
@@ -320,10 +403,7 @@ int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 					       fib4_rule_action,
 					       rule, fl, flags, arg);
 
-		if (!err && ops->suppress && INDIRECT_CALL_MT(ops->suppress,
-							      fib6_rule_suppress,
-							      fib4_rule_suppress,
-							      rule, flags, arg))
+		if (!err && fib_rule_suppress(ops->family, rule, flags, arg))
 			continue;
 
 		if (err != -EAGAIN) {
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index d279cb8ac158..560702a9bed4 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -140,39 +140,6 @@ INDIRECT_CALLABLE_SCOPE int fib4_rule_action(struct fib_rule *rule,
 	return err;
 }
 
-INDIRECT_CALLABLE_SCOPE bool fib4_rule_suppress(struct fib_rule *rule,
-						int flags,
-						struct fib_lookup_arg *arg)
-{
-	struct fib_result *result = (struct fib_result *) arg->result;
-	struct net_device *dev = NULL;
-
-	if (result->fi) {
-		struct fib_nh_common *nhc = fib_info_nhc(result->fi, 0);
-
-		dev = nhc->nhc_dev;
-	}
-
-	/* do not accept result if the route does
-	 * not meet the required prefix length
-	 */
-	if (result->prefixlen <= rule->suppress_prefixlen)
-		goto suppress_route;
-
-	/* do not accept result if the route uses a device
-	 * belonging to a forbidden interface group
-	 */
-	if (rule->suppress_ifgroup != -1 && dev && dev->group == rule->suppress_ifgroup)
-		goto suppress_route;
-
-	return false;
-
-suppress_route:
-	if (!(arg->flags & FIB_LOOKUP_NOREF))
-		fib_info_put(result->fi);
-	return true;
-}
-
 INDIRECT_CALLABLE_SCOPE int fib4_rule_match(struct fib_rule *rule,
 					    struct flowi *fl, int flags)
 {
@@ -377,7 +344,6 @@ static const struct fib_rules_ops __net_initconst fib4_rules_ops_template = {
 	.rule_size	= sizeof(struct fib4_rule),
 	.addr_size	= sizeof(u32),
 	.action		= fib4_rule_action,
-	.suppress	= fib4_rule_suppress,
 	.match		= fib4_rule_match,
 	.configure	= fib4_rule_configure,
 	.delete		= fib4_rule_delete,
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index dcedfe29d9d9..6b6718844fee 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -266,39 +266,6 @@ INDIRECT_CALLABLE_SCOPE int fib6_rule_action(struct fib_rule *rule,
 	return __fib6_rule_action(rule, flp, flags, arg);
 }
 
-INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
-						int flags,
-						struct fib_lookup_arg *arg)
-{
-	struct fib6_result *res = arg->result;
-	struct rt6_info *rt = res->rt6;
-	struct net_device *dev = NULL;
-
-	if (!rt)
-		return false;
-
-	if (rt->rt6i_idev)
-		dev = rt->rt6i_idev->dev;
-
-	/* do not accept result if the route does
-	 * not meet the required prefix length
-	 */
-	if (rt->rt6i_dst.plen <= rule->suppress_prefixlen)
-		goto suppress_route;
-
-	/* do not accept result if the route uses a device
-	 * belonging to a forbidden interface group
-	 */
-	if (rule->suppress_ifgroup != -1 && dev && dev->group == rule->suppress_ifgroup)
-		goto suppress_route;
-
-	return false;
-
-suppress_route:
-	ip6_rt_put_flags(rt, flags);
-	return true;
-}
-
 INDIRECT_CALLABLE_SCOPE int fib6_rule_match(struct fib_rule *rule,
 					    struct flowi *fl, int flags)
 {
@@ -452,7 +419,6 @@ static const struct fib_rules_ops __net_initconst fib6_rules_ops_template = {
 	.addr_size		= sizeof(struct in6_addr),
 	.action			= fib6_rule_action,
 	.match			= fib6_rule_match,
-	.suppress		= fib6_rule_suppress,
 	.configure		= fib6_rule_configure,
 	.delete			= fib6_rule_delete,
 	.compare		= fib6_rule_compare,
-- 
2.32.0

