Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D2F22E32B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 00:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgGZWsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 18:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgGZWsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 18:48:21 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E95C0619D4
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 15:48:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q145so5652096ybg.8
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 15:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Z7rJkPFkicEqRXa8H2H+eAkbcV3x2za6M1WWwBBQe94=;
        b=h+6c/Wtv3G/E0Q5G7yq37gVbb2jPhWO4oajjn5Uqw65uikpw4CMnwnc4W18oCatp4H
         Q1sVmi3uLly0vXXQiwm7/m2N14lerVEpteTuHvcfGadl04JOS6EVa5i8+cYR+n+CydFr
         1j+0acIV1gWBHroI0eR5XGoiEj0QOqo2yXwXjhCeCsUOqcXju+hO4znR9yG85/F1JWY8
         QgakH3G9WbZVi951IkRJ0kIQMzFUoTT0xIcZEG25b/L06+4YgQWPXCWUDCV7KE6mLO+G
         +nMHY4VMUERkvqRin3aJxZzQpVaqsDuFPXXxmPhxkycWocsmWuyaTJQ4pjZ5S0ubBGRp
         s8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Z7rJkPFkicEqRXa8H2H+eAkbcV3x2za6M1WWwBBQe94=;
        b=MSGC8v8ZSRfXEN1UGbiFSiOhzE0tyYAAqLKQsUF8kxw0o4NuADCqZc/lSGDURn4tZV
         POO0RQbMLd9vB7tsZhegTzb6NU3gGbLUGYuJ0HezVlFb8ilR9Hsx0bGpf+dPllSoj6ym
         VrqcxT/IwXoq9nYUk1AEhFSiNkOz6CEsAx1Pt5cDX6Bce/didXBZG2xtoR7LZrMRJOdi
         D/5aq79q6xt8zz2nZazqFrMjAKF6eIBWPzvlqcaouHQJVR6dj8gLPyD1DECiS9f5mz/p
         mT7QvlAFylBkKSVWFNlR4ytowgW6A31CqJGEe4BPimdg9MmXfIVXH0WqvCdDkiwGofnh
         T0EQ==
X-Gm-Message-State: AOAM532bQg0ubQGbYpis/ipIDb9mc3E4jUJo/FD2F+pfyDsXfU7mTFlq
        G7EABKOGcF2so/LYgajMFgZGed0KSleO
X-Google-Smtp-Source: ABdhPJz6soGdCdpY/T8IWZ8l4ICluj41UMvB+JcGPoP1P6aJcG+ZLJe84sSr2KDFxBTFwoXGbpPB9rKOQdaA
X-Received: by 2002:a25:c615:: with SMTP id k21mr28496351ybf.379.1595803700661;
 Sun, 26 Jul 2020 15:48:20 -0700 (PDT)
Date:   Sun, 26 Jul 2020 15:48:16 -0700
Message-Id: <20200726224816.1819557-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH V2 net-next] fib: use indirect call wrappers in the most
 common fib_rules_ops
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This avoids another inderect call per RX packet which save us around
20-40 ns.

Changelog:

v1 -> v2:
- Move declaraions to fib_rules.h to remove warnings

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 include/net/fib_rules.h | 18 ++++++++++++++++++
 net/core/fib_rules.c    | 18 ++++++++++++++----
 net/ipv4/fib_rules.c    | 12 ++++++++----
 net/ipv6/fib6_rules.c   | 12 ++++++++----
 4 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index a259050f84afc..4b10676c69d19 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -10,6 +10,7 @@
 #include <net/flow.h>
 #include <net/rtnetlink.h>
 #include <net/fib_notifier.h>
+#include <linux/indirect_call_wrapper.h>
 
 struct fib_kuid_range {
 	kuid_t start;
@@ -203,4 +204,21 @@ int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh,
 		   struct netlink_ext_ack *extack);
 int fib_nl_delrule(struct sk_buff *skb, struct nlmsghdr *nlh,
 		   struct netlink_ext_ack *extack);
+
+INDIRECT_CALLABLE_DECLARE(int fib6_rule_match(struct fib_rule *rule,
+					    struct flowi *fl, int flags));
+INDIRECT_CALLABLE_DECLARE(int fib4_rule_match(struct fib_rule *rule,
+					    struct flowi *fl, int flags));
+
+INDIRECT_CALLABLE_DECLARE(int fib6_rule_action(struct fib_rule *rule,
+			    struct flowi *flp, int flags,
+			    struct fib_lookup_arg *arg));
+INDIRECT_CALLABLE_DECLARE(int fib4_rule_action(struct fib_rule *rule,
+			    struct flowi *flp, int flags,
+			    struct fib_lookup_arg *arg));
+
+INDIRECT_CALLABLE_DECLARE(bool fib6_rule_suppress(struct fib_rule *rule,
+						struct fib_lookup_arg *arg));
+INDIRECT_CALLABLE_DECLARE(bool fib4_rule_suppress(struct fib_rule *rule,
+						struct fib_lookup_arg *arg));
 #endif
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index bd7eba9066f8d..e7a8f87b0bb2b 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -14,6 +14,7 @@
 #include <net/sock.h>
 #include <net/fib_rules.h>
 #include <net/ip_tunnels.h>
+#include <linux/indirect_call_wrapper.h>
 
 static const struct fib_kuid_range fib_kuid_range_unset = {
 	KUIDT_INIT(0),
@@ -267,7 +268,10 @@ static int fib_rule_match(struct fib_rule *rule, struct fib_rules_ops *ops,
 	    uid_gt(fl->flowi_uid, rule->uid_range.end))
 		goto out;
 
-	ret = ops->match(rule, fl, flags);
+	ret = INDIRECT_CALL_INET(ops->match,
+				 fib6_rule_match,
+				 fib4_rule_match,
+				 rule, fl, flags);
 out:
 	return (rule->flags & FIB_RULE_INVERT) ? !ret : ret;
 }
@@ -298,9 +302,15 @@ int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 		} else if (rule->action == FR_ACT_NOP)
 			continue;
 		else
-			err = ops->action(rule, fl, flags, arg);
-
-		if (!err && ops->suppress && ops->suppress(rule, arg))
+			err = INDIRECT_CALL_INET(ops->action,
+						 fib6_rule_action,
+						 fib4_rule_action,
+						 rule, fl, flags, arg);
+
+		if (!err && ops->suppress && INDIRECT_CALL_INET(ops->suppress,
+								fib6_rule_suppress,
+								fib4_rule_suppress,
+								rule, arg))
 			continue;
 
 		if (err != -EAGAIN) {
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index f99e3bac5cab2..ce54a30c2ef1e 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -29,6 +29,7 @@
 #include <net/ip_fib.h>
 #include <net/nexthop.h>
 #include <net/fib_rules.h>
+#include <linux/indirect_call_wrapper.h>
 
 struct fib4_rule {
 	struct fib_rule		common;
@@ -103,8 +104,9 @@ int __fib_lookup(struct net *net, struct flowi4 *flp,
 }
 EXPORT_SYMBOL_GPL(__fib_lookup);
 
-static int fib4_rule_action(struct fib_rule *rule, struct flowi *flp,
-			    int flags, struct fib_lookup_arg *arg)
+INDIRECT_CALLABLE_SCOPE int fib4_rule_action(struct fib_rule *rule,
+					     struct flowi *flp, int flags,
+					     struct fib_lookup_arg *arg)
 {
 	int err = -EAGAIN;
 	struct fib_table *tbl;
@@ -138,7 +140,8 @@ static int fib4_rule_action(struct fib_rule *rule, struct flowi *flp,
 	return err;
 }
 
-static bool fib4_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg)
+INDIRECT_CALLABLE_SCOPE bool fib4_rule_suppress(struct fib_rule *rule,
+						struct fib_lookup_arg *arg)
 {
 	struct fib_result *result = (struct fib_result *) arg->result;
 	struct net_device *dev = NULL;
@@ -169,7 +172,8 @@ static bool fib4_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
 	return true;
 }
 
-static int fib4_rule_match(struct fib_rule *rule, struct flowi *fl, int flags)
+INDIRECT_CALLABLE_SCOPE int fib4_rule_match(struct fib_rule *rule,
+					    struct flowi *fl, int flags)
 {
 	struct fib4_rule *r = (struct fib4_rule *) rule;
 	struct flowi4 *fl4 = &fl->u.ip4;
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 6053ef8515555..8f9a83314de7d 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -13,6 +13,7 @@
 #include <linux/netdevice.h>
 #include <linux/notifier.h>
 #include <linux/export.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <net/fib_rules.h>
 #include <net/ipv6.h>
@@ -255,8 +256,9 @@ static int __fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
 	return err;
 }
 
-static int fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
-			    int flags, struct fib_lookup_arg *arg)
+INDIRECT_CALLABLE_SCOPE int fib6_rule_action(struct fib_rule *rule,
+					     struct flowi *flp, int flags,
+					     struct fib_lookup_arg *arg)
 {
 	if (arg->lookup_ptr == fib6_table_lookup)
 		return fib6_rule_action_alt(rule, flp, flags, arg);
@@ -264,7 +266,8 @@ static int fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
 	return __fib6_rule_action(rule, flp, flags, arg);
 }
 
-static bool fib6_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg)
+INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
+						struct fib_lookup_arg *arg)
 {
 	struct fib6_result *res = arg->result;
 	struct rt6_info *rt = res->rt6;
@@ -296,7 +299,8 @@ static bool fib6_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
 	return true;
 }
 
-static int fib6_rule_match(struct fib_rule *rule, struct flowi *fl, int flags)
+INDIRECT_CALLABLE_SCOPE int fib6_rule_match(struct fib_rule *rule,
+					    struct flowi *fl, int flags)
 {
 	struct fib6_rule *r = (struct fib6_rule *) rule;
 	struct flowi6 *fl6 = &fl->u.ip6;
-- 
2.28.0.rc0.142.g3c755180ce-goog

