Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAA623246B
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 20:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgG2SKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 14:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgG2SKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 14:10:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47255C0619D2
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 11:10:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a127so30436063ybb.14
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 11:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NJgVNE3qVbUu930lPz5yhQZ0xcOIMGZyL4mDwfy0Ps4=;
        b=TM3zDmSWm8vlffvSbUJcRRTfjNm/WwHI4uolVELMqMw0iNnS/TFZZ0UefotLuKWrBx
         B+5U7uauClFTmtskmiAgyveFyZQCVdBgSIAPAv/3KthEd1nToAKkWJI5+vL7Q00aM1yF
         BHUnvrRbB2IOzwg2Sxq4JL8WuBboHb3I9j4F6lQxBwax+zCw0yUED/PO3zytqUqeiiEF
         JfVeyRKrEi8/VZDLoWseKBu4Kp2vbLgVBmUXlDDB1V8gzvNQrpdPni3vkSRK6Ppf8z5I
         R/IXM+FBvP+n6AwvQ31zKokfcZx6gyPbYsUMoIVNrMgp+x4cLfP6NPp75qN/cmQryJ9U
         Pe8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NJgVNE3qVbUu930lPz5yhQZ0xcOIMGZyL4mDwfy0Ps4=;
        b=uYXGu6Xtw9OxwsJv0i6liuwliAnlrbIjJy5nzHgk8TU+dmkt86A3BnDziDB476na5B
         PGrL/kCC/g/aj0fC7wD2nPU42icPX3Z+wjxXfnP9yfAyJMJTHtyx89yLwAu1V/hMsRe0
         SBY8p2WRRrIrE7RRtWT5Qg4ZgE6pCxsyHlSMP0tto97tkcAkwFEFB5VL2lfu8CbjxXOj
         xi9vPKrNEBZjXRWx0LB4nw6l6jeqbBLyV8rdt6R0HHM907Z3akQ4MQeiFtQNxmlbqEqt
         bb9IfdSVR5a/FV1SVYpLMGcAEEDRMQ5dSbQ5mBp9zZ0jQgsydZbNm7ACoeR6Xrzrl5Wd
         XSpw==
X-Gm-Message-State: AOAM530GFgs2wMThJ8GmXWi46R0YDczTkMgflqil7qty2IrflmmMk7zv
        X7Y7XDRpYghb5Mb7+qtPaj4SQdwsTEBs
X-Google-Smtp-Source: ABdhPJzuMQBFkFbJv5tQyMNORzLZOuztWA+PuSMOWeDcAh5lAN7EqpkyWPllfYfvjRddwxQP72utmmp0OYqj
X-Received: by 2002:a25:7006:: with SMTP id l6mr26693708ybc.197.1596046222464;
 Wed, 29 Jul 2020 11:10:22 -0700 (PDT)
Date:   Wed, 29 Jul 2020 11:10:18 -0700
Message-Id: <20200729181018.3221288-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH net-next] fib: fix fib_rules_ops indirect calls wrappers
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes:
commit b9aaec8f0be5 ("fib: use indirect call wrappers in the most common
fib_rules_ops") which didn't consider the case when
CONFIG_IPV6_MULTIPLE_TABLES is not set.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: b9aaec8f0be5 ("fib: use indirect call wrappers in the most common fib_rules_ops")
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 net/core/fib_rules.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index e7a8f87b0bb2b..fce645f6b9b10 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -16,6 +16,13 @@
 #include <net/ip_tunnels.h>
 #include <linux/indirect_call_wrapper.h>
 
+#ifdef CONFIG_IPV6_MULTIPLE_TABLES
+#define INDIRECT_CALL_MT(f, f2, f1, ...) \
+	INDIRECT_CALL_INET(f, f2, f1, __VA_ARGS__)
+#else
+#define INDIRECT_CALL_MT(f, f2, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
+#endif
+
 static const struct fib_kuid_range fib_kuid_range_unset = {
 	KUIDT_INIT(0),
 	KUIDT_INIT(~0),
@@ -268,10 +275,10 @@ static int fib_rule_match(struct fib_rule *rule, struct fib_rules_ops *ops,
 	    uid_gt(fl->flowi_uid, rule->uid_range.end))
 		goto out;
 
-	ret = INDIRECT_CALL_INET(ops->match,
-				 fib6_rule_match,
-				 fib4_rule_match,
-				 rule, fl, flags);
+	ret = INDIRECT_CALL_MT(ops->match,
+			       fib6_rule_match,
+			       fib4_rule_match,
+			       rule, fl, flags);
 out:
 	return (rule->flags & FIB_RULE_INVERT) ? !ret : ret;
 }
@@ -302,15 +309,15 @@ int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 		} else if (rule->action == FR_ACT_NOP)
 			continue;
 		else
-			err = INDIRECT_CALL_INET(ops->action,
-						 fib6_rule_action,
-						 fib4_rule_action,
-						 rule, fl, flags, arg);
-
-		if (!err && ops->suppress && INDIRECT_CALL_INET(ops->suppress,
-								fib6_rule_suppress,
-								fib4_rule_suppress,
-								rule, arg))
+			err = INDIRECT_CALL_MT(ops->action,
+					       fib6_rule_action,
+					       fib4_rule_action,
+					       rule, fl, flags, arg);
+
+		if (!err && ops->suppress && INDIRECT_CALL_MT(ops->suppress,
+							      fib6_rule_suppress,
+							      fib4_rule_suppress,
+							      rule, arg))
 			continue;
 
 		if (err != -EAGAIN) {
-- 
2.28.0.rc0.142.g3c755180ce-goog

