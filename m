Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA5A22D3AE
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 03:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgGYBt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 21:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgGYBt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 21:49:28 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBB9C0619E4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 18:49:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x62so7557482pfc.20
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 18:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=y5e7Kxmj3rxBUzNftUQkhmDiDPvu1uklbrqjcw+cOAo=;
        b=oVS+HTlNET/lpmLPN+f2LJEMactBsk7fHorTNCz/B4rgLPfoGBZXue3+9E2i+EmgTg
         hrg72xs9Jl/1Jl58qIGykv2MolfPAlLKRk2GHQKWlkKrQcOsLIGvmDJxjO3Zm38KzA0V
         xMfX0+Uq/+BHNqRACXlt5IHNo9jWwzo2hEFEVo748FhokavqEOmLC970yY1erjOhPtUl
         mwXGvul2GQ9qdo4sOssrOVREhR91QZwhRcVdDD8QVaTMHJASIlmUVyI6cU8GNELrtxdr
         vfJcq6kSH4m43QZ6pMGhPaBj2bDBuneK+nnk81tfzQLO4PtbgRkG+ityf4EVAqF99trA
         BLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=y5e7Kxmj3rxBUzNftUQkhmDiDPvu1uklbrqjcw+cOAo=;
        b=hmMdfQM+ZxDOJ83exLbj1PEwJAhvi/tXFsaFjj+rT4tuUC1j/+LpSSKem4/aWc5NvR
         0AwIUSP8KmnblX9E5VDb3VzvJ4jb4Cc9UhZKFAhYpfSmk0Xws8mYROBQMxFTOZdSdJG1
         seDx92NGU8zVu8j9OMguBikogXuJkt4Pd0+VlR4J04mf7QwHHTI56Et3F69pUs5VHBgB
         Gmghn+m7Ht1WCKJJlk4A+eC4XjbrGLxLK4EudyCFhBJflX7xbOdm7yFQvrfy2SA6ivPP
         ZQCt+4l1lrJCwHJZ2lfZAjWnN2bQnzAImjiuGUsosl+w/qQEQW5aNup41maO3+IopTl/
         8nbQ==
X-Gm-Message-State: AOAM533IMbk2tZv/+HYwI3vxHqQcmwXEA8MfgVaX7MSHOzLYxFk0xWwD
        qZNUn6d6g+8IF7/D5Y6+axKoTQpV01+W
X-Google-Smtp-Source: ABdhPJy2sS+P9lS1/SV1ZFFj/ZzqjbvfkdDsmQF7YTKz7RmUObF387CBf5ZOkVxHBF9lM209xqgCqka9g081
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr7860640pjb.186.1595641767239;
 Fri, 24 Jul 2020 18:49:27 -0700 (PDT)
Date:   Fri, 24 Jul 2020 18:49:09 -0700
Message-Id: <20200725014909.614068-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH net-next] fib: use indirect call wrappers in the most common fib_rules_ops
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This avoids another inderect call per RX packet which save us around
20-40 ns.

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 net/core/fib_rules.c  | 32 ++++++++++++++++++++++++++++----
 net/ipv4/fib_rules.c  | 12 ++++++++----
 net/ipv6/fib6_rules.c | 12 ++++++++----
 3 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index bd7eba9066f8d..ceef012dd0e65 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -14,6 +14,7 @@
 #include <net/sock.h>
 #include <net/fib_rules.h>
 #include <net/ip_tunnels.h>
+#include <linux/indirect_call_wrapper.h>
 
 static const struct fib_kuid_range fib_kuid_range_unset = {
 	KUIDT_INIT(0),
@@ -242,6 +243,10 @@ static int nla_put_port_range(struct sk_buff *skb, int attrtype,
 	return nla_put(skb, attrtype, sizeof(*range), range);
 }
 
+INDIRECT_CALLABLE_DECLARE(int fib6_rule_match(struct fib_rule *rule,
+					    struct flowi *fl, int flags));
+INDIRECT_CALLABLE_DECLARE(int fib4_rule_match(struct fib_rule *rule,
+					    struct flowi *fl, int flags));
 static int fib_rule_match(struct fib_rule *rule, struct fib_rules_ops *ops,
 			  struct flowi *fl, int flags,
 			  struct fib_lookup_arg *arg)
@@ -267,11 +272,24 @@ static int fib_rule_match(struct fib_rule *rule, struct fib_rules_ops *ops,
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
 
+INDIRECT_CALLABLE_DECLARE(int fib6_rule_action(struct fib_rule *rule,
+			    struct flowi *flp, int flags,
+			    struct fib_lookup_arg *arg));
+INDIRECT_CALLABLE_DECLARE(int fib4_rule_action(struct fib_rule *rule,
+			    struct flowi *flp, int flags,
+			    struct fib_lookup_arg *arg));
+INDIRECT_CALLABLE_DECLARE(bool fib6_rule_suppress(struct fib_rule *rule,
+						struct fib_lookup_arg *arg));
+INDIRECT_CALLABLE_DECLARE(bool fib4_rule_suppress(struct fib_rule *rule,
+						struct fib_lookup_arg *arg));
 int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 		     int flags, struct fib_lookup_arg *arg)
 {
@@ -298,9 +316,15 @@ int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 		} else if (rule->action == FR_ACT_NOP)
 			continue;
 		else
-			err = ops->action(rule, fl, flags, arg);
-
-		if (!err && ops->suppress && ops->suppress(rule, arg))
+			err = INDIRECT_CALL_INET(ops->action,
+					       fib6_rule_action,
+					       fib4_rule_action,
+					       rule, fl, flags, arg);
+
+		if (!err && ops->suppress && INDIRECT_CALL_INET(ops->suppress,
+								fib6_rule_suppress,
+								fib4_rule_suppress,
+								rule, arg))
 			continue;
 
 		if (err != -EAGAIN) {
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index f99e3bac5cab2..fd3def3ffa6df 100644
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
+			    struct flowi *flp, int flags,
+			    struct fib_lookup_arg *arg)
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
index 6053ef8515555..fb4db803a2531 100644
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
+			    struct flowi *flp, int flags,
+			    struct fib_lookup_arg *arg)
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

