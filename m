Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A005C47495E
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhLNR1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhLNR1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:27:52 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61253C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 09:27:52 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mxBag-0005RO-JI; Tue, 14 Dec 2021 18:27:50 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 2/4] fib: place common code in a helper
Date:   Tue, 14 Dec 2021 18:27:29 +0100
Message-Id: <20211214172731.3591-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211214172731.3591-1-fw@strlen.de>
References: <20211214172731.3591-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After moving the ipv4/ipv6 helpers to the core, there is some
overlapping code that can be collapsed into a helper.

This change has no effect on generated code.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: IPV6=n ifdef for fib6_rule_suppress helper.

 net/core/fib_rules.c | 62 +++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 52e67f8aa0c5..c763b69eea8c 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -291,6 +291,25 @@ static int fib_rule_match(struct fib_rule *rule, struct fib_rules_ops *ops,
 	return (rule->flags & FIB_RULE_INVERT) ? !ret : ret;
 }
 
+static bool fib_rule_should_suppress(const struct fib_rule *rule,
+				     const struct net_device *dev,
+				     int prefixlen)
+{
+	/* do not accept result if the route does
+	 * not meet the required prefix length
+	 */
+	if (prefixlen <= rule->suppress_prefixlen)
+		return true;
+
+	/* do not accept result if the route uses a device
+	 * belonging to a forbidden interface group
+	 */
+	if (rule->suppress_ifgroup != -1 && dev && dev->group == rule->suppress_ifgroup)
+		return true;
+
+	return false;
+}
+
 static bool fib4_rule_suppress(struct fib_rule *rule,
 			       int flags,
 			       struct fib_lookup_arg *arg)
@@ -304,30 +323,19 @@ static bool fib4_rule_suppress(struct fib_rule *rule,
 		dev = nhc->nhc_dev;
 	}
 
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
+	if (fib_rule_should_suppress(rule, dev, result->prefixlen)) {
+		if (!(arg->flags & FIB_LOOKUP_NOREF))
+			fib_info_put(result->fi);
+		return true;
+	}
 	return false;
-
-suppress_route:
-	if (!(arg->flags & FIB_LOOKUP_NOREF))
-		fib_info_put(result->fi);
-	return true;
 }
 
 static bool fib6_rule_suppress(struct fib_rule *rule,
 			       int flags,
 			       struct fib_lookup_arg *arg)
 {
+#if IS_ENABLED(CONFIG_IPV6)
 	struct fib6_result *res = arg->result;
 	struct rt6_info *rt = res->rt6;
 	struct net_device *dev = NULL;
@@ -338,23 +346,13 @@ static bool fib6_rule_suppress(struct fib_rule *rule,
 	if (rt->rt6i_idev)
 		dev = rt->rt6i_idev->dev;
 
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
+	if (fib_rule_should_suppress(rule, dev, rt->rt6i_dst.plen)) {
+		ip6_rt_put_flags(rt, flags);
+		return true;
+	}
 
+#endif
 	return false;
-
-suppress_route:
-	ip6_rt_put_flags(rt, flags);
-	return true;
 }
 
 static bool fib_rule_suppress(int family,
-- 
2.32.0

