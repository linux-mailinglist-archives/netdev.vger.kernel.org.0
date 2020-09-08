Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CDF2614BB
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbgIHQfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732041AbgIHQdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:33:20 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA95C061757
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 09:33:06 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id d21so7136pjw.0
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 09:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=CANcWdmkfHocbgVKTAAE9dJkc5hHdQokKhQjsEB1KnE=;
        b=vnAzXgXnVVnlPrwhtix3PGdB4bxu4RglJmzXo+f+f7F62CokdgVLb0tuJRPbdPVbc8
         w06zo1pPDysBOFCrFK+32SwVnFYivbrZgchZrc6wXnWsxHwUz4EquvDbTasycuKnL6EB
         3y0vyptT80/i8+m6Cn6cg6d6oMwQbmp9s6KjhtexFhZHOVO3rdKIq5m96j1Z4Z6dwsVx
         //IQzVHpk3ZwqP0quOFuiboaKe2Jxa0HRvGfxJ7HWrMvNqmQQ/eMf7gdU9r6kA1+t1+4
         xGWOovztoXUJSS3lNX+GXa0WcGF4XLFhumezuuM6Uy1y5gJ4pYUqRbX8fs6XIpVmAjP6
         ZdQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=CANcWdmkfHocbgVKTAAE9dJkc5hHdQokKhQjsEB1KnE=;
        b=jDxqkNrfQUJOlJ6487MPdd5WS1afkCGZnuR+nnuyvaLgRhu5JBYYs7rp+546dR2en7
         Krp3O1M7h2iVQuTCrWrkF/XLTDRFndpsqObpwCQJikKr25/RFsPuGBK95GpmFXcZUq6m
         pMLeoqZ7fe3Bio5bD9cz1Xf5UfxSpO8iaxJVhtxg4xOlmnFy2xpSjoBby8gYhniMRF8N
         LBJpkoiM4nRiXsTwI5K+q8Xztud6QHdDgKlIUTyIV9jF2NYLrYhvYvtJmd9ZpFoK7VBS
         5HcoPwD9y0Z0guFSYTUi8JX1DvXDGSfbUiYrhCE7NoRymzOyeKZobNZSKXR8FwWz+3Z0
         Pq3A==
X-Gm-Message-State: AOAM533K6r3KK0/8kA8WFOlEreiCqzREQr1EqATaiklrGfpe8K97fktp
        5Muz5FmNgOEPZdqNMrOMTdrRMhFWpS52
X-Google-Smtp-Source: ABdhPJw8HTxak1y58y4eThfivoBBfNjQI2nL+3HJ5ywB683wMLKEawkjBkDqxjTuYE1x3wZHkXnL1MGaRodZ
X-Received: from brianvv.svl.corp.google.com ([2620:15c:2c4:201:a28c:fdff:fee1:c370])
 (user=brianvv job=sendgmr) by 2002:a17:90b:80f:: with SMTP id
 bk15mr8833pjb.36.1599582784358; Tue, 08 Sep 2020 09:33:04 -0700 (PDT)
Date:   Tue,  8 Sep 2020 09:33:00 -0700
Message-Id: <20200908163300.729113-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2] fib: fix fib_rule_ops indirect call wrappers when CONFIG_IPV6=m
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
Fixes: 41d707b7332f ("fib: fix fib_rules_ops indirect calls wrappers")
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
v2:
-amend fixes tag to the right one

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

