Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C896C47073C
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhLJRhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244673AbhLJRhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:37:02 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A79CC0617A1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:27 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so10308118otg.4
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MYhfIoJvlZ3UvjgjTfCOCi8477KYN3hMlQaW6RBS+ig=;
        b=af9yfAM2vzCaX+swy2klbMoSrH2tkjLgvNjPp0zQZByY6sB9n0hkrMVuGwo8y7p4sl
         iEWkYM32+PBDmuzOdK0fJYMVX7YbtQRe7QOqh9iRvdW29YJVTnwap6Ilz1qoldCsQCyH
         0rote55FZD2B/vSw6df149TN+E2Br2fgnwzyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MYhfIoJvlZ3UvjgjTfCOCi8477KYN3hMlQaW6RBS+ig=;
        b=b4s5jUvt4UF+nc+P5KVqKGLVnIwVVndsLZUijI9Tf88hMYX6/Pc3m9/Y/RGxl2f02k
         L9hWRRXzcQ/mhcrXYzt8RqRGY4rICS1o6Uipum7K6i9J6wiGxJLJNDh7wDgxqXnDWK86
         L04KpRBqfKso4/Ju1y/WHFhTN1tZFAD/tbyR+JJKp47a/tu8SShua3CghTLPBb2ZUFTY
         tT63EEhdRx+MXGlbs2lrzohNopIEtayDJUE751Ftk+bYGQuXL/uWsloqz6ZXutTvDiNx
         Np/oN5gxGnZiLGIkJtyZ2otvhPexhe4YbQ9yuV1ld5S2TJha3ddtZeGZxiRkGwYQ8TwP
         29hA==
X-Gm-Message-State: AOAM530X59eVpT8tuluze1LZgf1tEPIuw/oVmUuIxPPU7Y5NkqBj0F1L
        iqzTSpExOAe41F9re9GEK9W9WA==
X-Google-Smtp-Source: ABdhPJz+fdxZhcaBb0aXL1/U4YYsysQrmZmbnuOBIm+WLfQTPZbTuKYEVakW8zy1Ps1nYPL431Nd1w==
X-Received: by 2002:a9d:69ce:: with SMTP id v14mr12130459oto.312.1639157606779;
        Fri, 10 Dec 2021 09:33:26 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x4sm892224oiv.35.2021.12.10.09.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:33:26 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        keescook@chromium.org, mic@digikod.net, davem@davemloft.net,
        kuba@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        boqun.feng@gmail.com, akpm@linux-foundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 01/12] tools: fix ARRAY_SIZE defines in tools and selftests hdrs
Date:   Fri, 10 Dec 2021 10:33:11 -0700
Message-Id: <30585e0f0acfb523c6f7a93e0b916ae756e0c7e7.1639156389.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1639156389.git.skhan@linuxfoundation.org>
References: <cover.1639156389.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tools/include/linux/kernel.h and kselftest_harness.h are missing
ifndef guard around ARRAY_SIZE define. Fix them to avoid duplicate
define errors during compile when another file defines it. This
problem was found when compiling selftests that include a header
with ARRAY_SIZE define.

ARRAY_SIZE is defined in several selftests. There are about 25+
duplicate defines in various selftests source and header files.
Add ARRAY_SIZE to kselftest.h in preparation for removing duplicate
ARRAY_SIZE defines from individual test files.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/include/linux/kernel.h                | 2 ++
 tools/testing/selftests/kselftest.h         | 4 ++++
 tools/testing/selftests/kselftest_harness.h | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/tools/include/linux/kernel.h b/tools/include/linux/kernel.h
index 3e8df500cfbd..9701e8307db0 100644
--- a/tools/include/linux/kernel.h
+++ b/tools/include/linux/kernel.h
@@ -92,7 +92,9 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
 int scnprintf(char * buf, size_t size, const char * fmt, ...);
 int scnprintf_pad(char * buf, size_t size, const char * fmt, ...);
 
+#ifndef ARRAY_SIZE
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#endif
 
 #define current_gfp_context(k) 0
 #define synchronize_rcu()
diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
index 8d50483fe204..f1180987492c 100644
--- a/tools/testing/selftests/kselftest.h
+++ b/tools/testing/selftests/kselftest.h
@@ -48,6 +48,10 @@
 #include <stdarg.h>
 #include <stdio.h>
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#endif
+
 /* define kselftest exit codes */
 #define KSFT_PASS  0
 #define KSFT_FAIL  1
diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index ae0f0f33b2a6..75164e23f036 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -671,7 +671,9 @@
 #define EXPECT_STRNE(expected, seen) \
 	__EXPECT_STR(expected, seen, !=, 0)
 
+#ifndef ARRAY_SIZE
 #define ARRAY_SIZE(a)	(sizeof(a) / sizeof(a[0]))
+#endif
 
 /* Support an optional handler after and ASSERT_* or EXPECT_*.  The approach is
  * not thread-safe, but it should be fine in most sane test scenarios.
-- 
2.32.0

