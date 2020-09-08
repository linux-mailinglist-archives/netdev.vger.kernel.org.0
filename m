Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA5C26169A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731894AbgIHROq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731777AbgIHQSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:18:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4EDC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 09:18:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u18so9850842ybu.0
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 09:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=x95DT5jtosgYGGefTlj6NP8d+p2HyfRsrJ4ad9R8zWg=;
        b=vEAvtJV1mZC5g6CtNtuc1RMBhTCoauFGpyTyKhAUJ/l8U7+S+jFND8ivZyM0HZUL9G
         /K9GAkbQLWDrN9HBiVaizvVbEzzg8FhH/GvHRzPAXOT+ZgfwOsr2nHH/ogS+8LoaNkQ7
         hjEISner+UeNA1r568bv4fUydN5RrUGAQ4NwK1YlfwF4LRI1HpywGTt/FQ7HsOnBloI/
         mv26PTYzLSGrfOBj32MRiM6h/m+UutV/K+Ozm70tXcvvC1ZgGRBUWSS4csaJY1IWW12W
         modcc45TYxK1F54JrtcofO+RXmszyvRGpkgJ0NHsU/ge2bFKPE+N2ZX9vbpaeM7qMWDI
         1GuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=x95DT5jtosgYGGefTlj6NP8d+p2HyfRsrJ4ad9R8zWg=;
        b=cB9WOHL2DeiDlN7YoJpwg1P3j8hfNch7cQto0A/sUEQe/KAFU06yet7d4ZlRSgLKgZ
         GK3moIx1bm66rW3xsDo1tcoYzQ2GSX2ib+gbCXrsLNv0lsMw32XOM3MK/WzNMmqasRMs
         dOT3j9CPpr6FtEy7ASWFQ07B1MHjS7XGYqHHjBoRRZSXKWmI8+/JEtGcZ9Auzykkd92J
         3vFb++fMS37dO/3uoeVIwS5s7ivgC2Q6lV9h+eigQ5HKOMSGMd7QeGwIiyr1zJzOsg1J
         Ojw7Kiv34FiyGhm6jxK84tQb19Md3IXghlU62Et1eZ1wZ/vaYpuw20N5Y9/5oOqtiRZe
         2CHQ==
X-Gm-Message-State: AOAM532pliHGjJ5EY+YL9hAFxSSM7SSiSc0NjSm7K6CADvOcmOe3I23i
        6y527LIvcMpmlNVT2y/Y37MIg/fGhDBg
X-Google-Smtp-Source: ABdhPJySE73XVegcNqbVF+9mab6MmrRL1nEIcLINZ2tVaa7rCwF8UXgmoVqBCwlx6WA3rld8VdOhhWvOkzMl
X-Received: from brianvv.svl.corp.google.com ([2620:15c:2c4:201:a28c:fdff:fee1:c370])
 (user=brianvv job=sendgmr) by 2002:a25:e0d5:: with SMTP id
 x204mr554925ybg.57.1599581931886; Tue, 08 Sep 2020 09:18:51 -0700 (PDT)
Date:   Tue,  8 Sep 2020 09:18:12 -0700
Message-Id: <20200908161812.723044-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH] fib: fix fib_rule_ops indirect call wrappers when CONFIG_IPV6=m
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sven Joachim <svenjoac@gmx.de>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_IPV6=m, the IPV6 functions won't be found by the linker:

ld: net/core/fib_rules.o: in function `fib_rules_lookup':
fib_rules.c:(.text+0x606): undefined reference to `fib6_rule_match'
ld: fib_rules.c:(.text+0x611): undefined reference to `fib6_rule_match'
ld: fib_rules.c:(.text+0x68c): undefined reference to `fib6_rule_action'
ld: fib_rules.c:(.text+0x693): undefined reference to `fib6_rule_action'
ld: fib_rules.c:(.text+0x6aa): undefined reference to `fib6_rule_suppress'
ld: fib_rules.c:(.text+0x6bc): undefined reference to `fib6_rule_suppress'
make: *** [Makefile:1166: vmlinux] Error 1

Reported-by: Sven Joachim <svenjoac@gmx.de>
Fixes: b9aaec8f0be5 ("fib: use indirect call wrappers in the most common fib_rules_ops")
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 net/core/fib_rules.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 51678a528f85..7bcfb16854cb 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -16,7 +16,7 @@
 #include <net/ip_tunnels.h>
 #include <linux/indirect_call_wrapper.h>
 
-#ifdef CONFIG_IPV6_MULTIPLE_TABLES
+#if defined(CONFIG_IPV6) && defined(CONFIG_IPV6_MULTIPLE_TABLES)
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 #define INDIRECT_CALL_MT(f, f2, f1, ...) \
 	INDIRECT_CALL_INET(f, f2, f1, __VA_ARGS__)
-- 
2.28.0.526.ge36021eeef-goog

