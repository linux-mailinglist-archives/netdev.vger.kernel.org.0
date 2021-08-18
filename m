Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEC73EFB6C
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbhHRGMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240420AbhHRGKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:10:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4898FC0698CF
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:03 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oa17so1963181pjb.1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=24kJIAEB6l7w/rhOBw7zIER4xYF+Qa9/jIWUD7WdGH8=;
        b=CAUQzirnqpaXsXvaOdsMkZHpuIpR3JhaBPR3ggeDgaq18XJdg2yqZnMCtyB/cc27j3
         BZ5GJkqG5ou8T5gobo5mo/ZBkQ/dTaPrBm9NhLud7PzgXgmMF3l0zcwK/JcOFM6/b+XF
         nM/3QdEhrpGIxmU5xIPT00h7TLrBixDXsWwdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=24kJIAEB6l7w/rhOBw7zIER4xYF+Qa9/jIWUD7WdGH8=;
        b=ADcpb2i73kWC2/1W1aaEUNCG2hv5uNcqI03dTVCfyG8qRp3xtCYCfbvOl1FYHA1fYg
         GIv2HBAUgCv8FKhBWXl9mQy7t+Hix/52Ei9ZM+hbbNUd8Nv6U6aNKXpjXJrcMbbNwq8N
         biR6oxAZqo2p83yAiHlcpWTnskZr70qE5Jzaa0VgI2sCNUeN5MZf9whYQg4vYQI5bJ3H
         Tp/+hWKPnWriuvYZUGbFsqpgub4uFKb0o6v2lJb5jlVvoLE2ftkrLKa53uE7h8sd70b5
         ckhYGW+8RUE5miFTq3SApN4p+rwaBukCStEIojcfolC5RGNdaSQNfvylKajF69clqy80
         66Zg==
X-Gm-Message-State: AOAM532CUYe0ncOlx74qlKwTEMnb15HtCbHCR/4/lPZ++Ml/nrZhsluX
        xjx0Oaeh+/aw1EOiyV6PUa5PGQ==
X-Google-Smtp-Source: ABdhPJw9tsazysLIZ4O0HIEYqZJyN/LtFV1XCD5WQBCwUvHyi+03vebL9EIRXOwVxHVE2g9yDaoK1Q==
X-Received: by 2002:a17:90a:17a8:: with SMTP id q37mr4764229pja.177.1629266763527;
        Tue, 17 Aug 2021 23:06:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r16sm4015029pje.10.2021.08.17.23.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:06:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 35/63] fortify: Detect struct member overflows in memmove() at compile-time
Date:   Tue, 17 Aug 2021 23:05:05 -0700
Message-Id: <20210818060533.3569517-36-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3921; h=from:subject; bh=Sc9iLSXfmFAQB6MEpEEuTn+7NF3Srx3T0CPKcvxZXTU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMldDKLxaagYEOz2y02LQlqkNv+irs+MsEpzkMu 3MdrhsSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjJQAKCRCJcvTf3G3AJvDuD/ wKE56AIL4EP7Vjz/QS5YbzobA7gkvOJu4dByH3vGhD9uwSz2raqgiS3N5zizAS9MSzKWvBQ85esh09 6sm/qa0W3g3z2D8hmZ9qQxrmxx9p6YL6HNlmwGIzYzeaTmzot8reJM1FI2V5fY1FoCKnId33EqbK06 vqaiAkMJyUkqy2YrdaS/D/HgN0HLmJDdiroxYBt1R8yVDAYBjyJvrr/8wk9JyAVLKiYY/jIfyWbg2c E5+sdvJ/2KKN5V6glg0K8IYFw4en5EXtjm44p7v2bhXKdErI0NqzapP+ztt5zhbTW8RzB7WZkbDp07 M0C/0rGk9rC34jGkNKto2nWPpipLIdU/eyZamr4A1LpeEA9hoguUtw/AAdnoO8mpdh7lGfxJZSHpqI Xg1U7m/fXv3nA1hWCphA2+k4XAdbf8fEQXSNPaEjroJbLDdocMcTLm01NCjGJ1X1xWeJ7tfjMvYNVc GbnZyJ47Ronjn0frwpKfRajoJfHpRFabO0kCXXgg+hxxb4UFvycYPsT3STVNF3NOHjyT9TUYT5VFW+ goL1hLcifbtfSqElh/fEtLY2DakkjO1Dml7F0gtwpJ0l15ZJmjLRtJXZ9RQ64AvLssTCVqTOwdf0YU CxAFNcJrYg9+l28nNI8luHr7I5sEMyS1JBVMEIMDHSgcoWOw+oBMyQU79SwQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As done for memcpy(), also update memmove() to use the same tightened
compile-time checks under CONFIG_FORTIFY_SOURCE.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/misc.c               |  3 ++-
 arch/x86/lib/memcpy_32.c                      |  1 +
 include/linux/fortify-string.h                | 21 ++++---------------
 .../read_overflow2_field-memmove.c            |  5 +++++
 .../write_overflow_field-memmove.c            |  5 +++++
 5 files changed, 17 insertions(+), 18 deletions(-)
 create mode 100644 lib/test_fortify/read_overflow2_field-memmove.c
 create mode 100644 lib/test_fortify/write_overflow_field-memmove.c

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 743f13ea25c1..83ff4354970e 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -34,10 +34,11 @@
  * try to define their own functions if these are not defined as macros.
  */
 #define memzero(s, n)	memset((s), 0, (n))
+#ifndef memmove
 #define memmove		memmove
-
 /* Functions used by the included decompressor code below. */
 void *memmove(void *dest, const void *src, size_t n);
+#endif
 
 /*
  * This is set up by the setup-routine at boot-time
diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index e565d1c9019e..f19b7fd07f04 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -4,6 +4,7 @@
 
 #undef memcpy
 #undef memset
+#undef memmove
 
 __visible void *memcpy(void *to, const void *from, size_t n)
 {
diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 25943442f532..0120d463ba33 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -307,22 +307,10 @@ __FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
 		__builtin_object_size(p, 0), __builtin_object_size(q, 0), \
 		__builtin_object_size(p, 1), __builtin_object_size(q, 1), \
 		memcpy)
-
-__FORTIFY_INLINE void *memmove(void *p, const void *q, __kernel_size_t size)
-{
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
-
-	if (__builtin_constant_p(size)) {
-		if (p_size < size)
-			__write_overflow();
-		if (q_size < size)
-			__read_overflow2();
-	}
-	if (p_size < size || q_size < size)
-		fortify_panic(__func__);
-	return __underlying_memmove(p, q, size);
-}
+#define memmove(p, q, s)  __fortify_memcpy_chk(p, q, s,			\
+		__builtin_object_size(p, 0), __builtin_object_size(q, 0), \
+		__builtin_object_size(p, 1), __builtin_object_size(q, 1), \
+		memmove)
 
 extern void *__real_memscan(void *, int, __kernel_size_t) __RENAME(memscan);
 __FORTIFY_INLINE void *memscan(void *p, int c, __kernel_size_t size)
@@ -411,7 +399,6 @@ __FORTIFY_INLINE char *strcpy(char *p, const char *q)
 /* Don't use these outside the FORITFY_SOURCE implementation */
 #undef __underlying_memchr
 #undef __underlying_memcmp
-#undef __underlying_memmove
 #undef __underlying_memset
 #undef __underlying_strcat
 #undef __underlying_strcpy
diff --git a/lib/test_fortify/read_overflow2_field-memmove.c b/lib/test_fortify/read_overflow2_field-memmove.c
new file mode 100644
index 000000000000..6cc2724c8f62
--- /dev/null
+++ b/lib/test_fortify/read_overflow2_field-memmove.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memmove(large, instance.buf, sizeof(instance.buf) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow_field-memmove.c b/lib/test_fortify/write_overflow_field-memmove.c
new file mode 100644
index 000000000000..377fcf9bb2fd
--- /dev/null
+++ b/lib/test_fortify/write_overflow_field-memmove.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memmove(instance.buf, large, sizeof(instance.buf) + 1)
+
+#include "test_fortify.h"
-- 
2.30.2

