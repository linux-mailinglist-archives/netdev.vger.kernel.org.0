Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE089B7EB9
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404080AbfISQFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 12:05:24 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:36185 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404060AbfISQFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 12:05:24 -0400
Received: by mail-lj1-f173.google.com with SMTP id v24so4181920ljj.3
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 09:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=oWulYD7B080MVQfmnSpp87cWzUMLXTr6wp3qPP73Jlc=;
        b=Aa3gf0rVn+UXxcLOYGQp70TrEQPIIequrVJ9zMGiCp6udjxIQ8Kazoqh0wDrR1dL3N
         yqKZoRPPm7sZMHI8bNu37kRoDwIEEEUgxrySM8ACD7NkvswaYk7QwaH4ANDK6MjGFA2B
         lymG274elFcNkvhcm4UvZELFHgciyvp7B2JANal60jVrLsft5ciknrwg8idEJ7Qnzkgi
         XaBAcDXAC3wmCBjxZDMvr4RVewwrLrw85eBlc5UrIaRQBR6gfjHLemcDQZ20AYhVDHG3
         YfKVexILIlZOhKWWVPl+fuzx2uAYBFDh3pp+tnXPPmTmFkFqgj9L+LyKvHo8b/yyvdMR
         jJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oWulYD7B080MVQfmnSpp87cWzUMLXTr6wp3qPP73Jlc=;
        b=TN1Td4wUxr0GhnejaCJSYhkFRXQSjfBmOzvkSTPnvbuUkjgk+QyiEkwbfEVJjumOdQ
         dAe9255f4jysTcu5JfhRJgmB3ed45PNCbvyPg49RWezEEMtE3omP4BXy14ArOQfRjJHr
         XMXcQZkLCttjpru3TCMwBNKWLfkP0ELW1EVxF+dRZwQ/PqbwkC4wAop1CDQYYSp1EDId
         KVkkV+68LZgKfVwb5xFEDkFZvSUuUR7XJCoGMpwrGbML2JJc/sj4VzOWN98FnU7DHKv2
         Cij8Hb5Wf7OdpzOqGEAspTvHw9/ZQOdxc8JeCOdQoGED9Ga5p7QYjWkr8L5jUeeLnEm6
         mWdw==
X-Gm-Message-State: APjAAAUJFywUV/wdxxk3bB/vuufduYIIGFGtYmTtP1Xic7jUIk5kGrvq
        cD4JulLULYE6/mh4yy+1d4w9Zw==
X-Google-Smtp-Source: APXvYqz/YDgxnx5B4g6INq61NG3EDGiHS7/lv1YfTLwHNxtOzep+r5dUzDw8bxPOTGNKDifK1CzjYg==
X-Received: by 2002:a05:651c:21b:: with SMTP id y27mr2636904ljn.219.1568909122191;
        Thu, 19 Sep 2019 09:05:22 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id t6sm1719039ljd.102.2019.09.19.09.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 09:05:21 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, andriin@fb.com
Cc:     yhs@fb.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf] libbpf: fix version identification on busybox
Date:   Thu, 19 Sep 2019 19:05:18 +0300
Message-Id: <20190919160518.25901-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's very often for embedded to have stripped version of sort in
busybox, when no -V option present. It breaks build natively on target
board causing recursive loop.

BusyBox v1.24.1 (2019-04-06 04:09:16 UTC) multi-call binary. \
Usage: sort [-nrugMcszbdfimSTokt] [-o FILE] [-k \
start[.offset][opts][,end[.offset][opts]] [-t CHAR] [FILE]...

Lets modify command a little to avoid -V option.

Fixes: dadb81d0afe732 ("libbpf: make libbpf.map source of truth for libbpf version")

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on bpf/master

 tools/lib/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index c6f94cffe06e..a12490ad6215 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -3,7 +3,7 @@
 
 LIBBPF_VERSION := $(shell \
 	grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
-	sort -rV | head -n1 | cut -d'_' -f2)
+	cut -d'_' -f2 | sort -r | head -n1)
 LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
 
 MAKEFLAGS += --no-print-directory
-- 
2.17.1

