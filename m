Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D2C234F89
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 05:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgHADBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 23:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgHADBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 23:01:14 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3C5C061756
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 20:01:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id nl2so11831054pjb.7
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 20:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RNPIMUZGL7vWT+JvfOiEDMKbcRoPVihXyc30/AYvQPA=;
        b=nRo2l8PsWIMgTFvFLo9BYbU4Qqp+qZEnO2DJ9fHLVvRlGCRSvEr4I1zg2yDRdKPMd2
         RHLrqoNjZikT9If1scOVkYV8Hb5gtfwj6mUywDp0IvY28z2cDNzAtaaiyaVw8rOdJdgO
         FkZ+j86I9UNflMCm5u3+5P30GhxYR1l747+nhfJUUFiiR5EWk/I+BL4rlHZmUW/B0fdV
         FNCq1t0JglJMMOWZ7RIX1qnZN4lEZBR1e68ZNGaDS0o3oJ5XZDzFoWDqhomi3hboGddm
         ELCaUYM8bzbpZpdHpLytVI6DLqrH1HXeQXgfZYx+rtgVQC+ABlgUNHHKeJbG0j3jCpso
         e4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RNPIMUZGL7vWT+JvfOiEDMKbcRoPVihXyc30/AYvQPA=;
        b=oGAs1z7eDETD5uXUOkoxIXaHYq/80CGWmdf5ZcjXmBvUB8Zasns4RPgnMfbHApBzm8
         vgR6rrynRoeOtfAVdQImNoSrGgDK42bsrX5CFc7WCAtcmEB5jXAkWze9DiLoYbb6Zzl4
         trGHeMQGMq9obU9tKVWWTirPQ5WVnsNRXIlOyXjAQ7MnVM6efNcI1fyvOTrkqk8Gh62x
         mCpSUlkeg12Gp1ZfdH1MboK+hqMeWF5ptRRchGk2drf/6PBrptshY7agaDOH95dPmepG
         9RppKwqn/ralNph/DqRBV2ai2tuxJ21jFj87FdOfhi4fOQdb7x4Y6KnwrKTxnlzqcB2c
         D06Q==
X-Gm-Message-State: AOAM531QjywDZAEHc5o8+KRKIBZBUxTdZ2/YQLKf0jo6Ae7eQB5o9bKD
        PoPB8XkiuhW/mBm1NL2Oc+yZ3MfIqNxv
X-Google-Smtp-Source: ABdhPJwDhMjrPaRKzEdSU4fOynBTgNIiCSD3A9TewtBpeaM/+nNnn5cUl3YC55tWS029i7m4KUojFPg/qJXV
X-Received: by 2002:a62:3741:: with SMTP id e62mr6119344pfa.127.1596250873449;
 Fri, 31 Jul 2020 20:01:13 -0700 (PDT)
Date:   Fri, 31 Jul 2020 20:01:10 -0700
Message-Id: <20200801030110.747164-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH net-next] fib: fix another fib_rules_ops indirect call wrapper problem
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It turns out that on commit 41d707b7332f ("fib: fix fib_rules_ops
indirect calls wrappers") I forgot to include the case when
CONFIG_IP_MULTIPLE_TABLES is not set.

Fixes: 41d707b7332f ("fib: fix fib_rules_ops indirect calls wrappers")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 net/core/fib_rules.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index fce645f6b9b10..a7a3f500a857b 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -17,10 +17,16 @@
 #include <linux/indirect_call_wrapper.h>
 
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
+#ifdef CONFIG_IP_MULTIPLE_TABLES
 #define INDIRECT_CALL_MT(f, f2, f1, ...) \
 	INDIRECT_CALL_INET(f, f2, f1, __VA_ARGS__)
 #else
+#define INDIRECT_CALL_MT(f, f2, f1, ...) INDIRECT_CALL_1(f, f2, __VA_ARGS__)
+#endif
+#elif CONFIG_IP_MULTIPLE_TABLES
 #define INDIRECT_CALL_MT(f, f2, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
+#else
+#define INDIRECT_CALL_MT(f, f2, f1, ...) f(__VA_ARGS__)
 #endif
 
 static const struct fib_kuid_range fib_kuid_range_unset = {
-- 
2.28.0.163.g6104cc2f0b6-goog

