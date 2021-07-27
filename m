Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2843D813A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhG0VRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbhG0VQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:16:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0804C061796
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso1066994pjf.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=25sRwmW5CNRat3e6IvuHGLhvZkVof8m0C579IfALAdI=;
        b=m4YGoh/P3tKU4Lxl4SRQWXdflOLrwwURErbp5YNr36KzJ2PuJLJ2p4gf7WuRawRpXx
         ekHTI/ED4PKpoCyWnDVdzHypaNY3kdi6x5gvRjEtla6K+zhkWVqZiQKl6mdS5GbyZlsJ
         5buVRA6MDRcJoXqbDVxmoBQ7/cFClrIrN8l/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=25sRwmW5CNRat3e6IvuHGLhvZkVof8m0C579IfALAdI=;
        b=SbeJHNB84GAGceA9TMwgLi7ls1X32LH+LMhnD8ldmxC3ro2MD/LJjLBLItRelyV+b4
         Y9xcgdS1pS0YRdY8m2xtVDGLFeGp0H7LdoBRnBNs3m+2gxyKV80GeJ/2o0G/3AcvKhy7
         BlESkr8vnKy0Axm52RMYMZDRp+7scunQc9XqUOY1Ux5WpOIr2bKUL02D+ak6AYVnTGxo
         RNhW3U4zD7Bz9FgqgE0D/zxndt/liD/6WlONq8N/KjOFCyE5muLxdWzY7zk7KQAI3glM
         mH3GCzYTqyYA+dUr95uYXQ6iXASrG6OVF8b22vTnXV4CCTg8lzUG4cYj8j+rx4Vr2Tsh
         UHCA==
X-Gm-Message-State: AOAM533n4/gYTSh+3a1XdKpnY+7Guylc2e1iLYsxrsw17kdRMksKs2Ms
        4JwK707e0MqHej3K9QbRHxhUzA==
X-Google-Smtp-Source: ABdhPJwY+2ofr2EBPgGu3EgOIhKgQL5Y+IWBO4KDp9LuyiE+gYeW+mz8aBLAfLtF0V2SpR3iUs1lFw==
X-Received: by 2002:a65:6118:: with SMTP id z24mr25262434pgu.325.1627420613440;
        Tue, 27 Jul 2021 14:16:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d6sm4820202pgq.88.2021.07.27.14.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:16:50 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 35/64] fortify: Detect struct member overflows in memmove() at compile-time
Date:   Tue, 27 Jul 2021 13:58:26 -0700
Message-Id: <20210727205855.411487-36-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3921; h=from:subject; bh=JPEM6DOHRS2oe2a1K9Mco8cbthiXTkdHcDm8bzIdvDM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOIEjRLBnznqeqc0ATaynhwVRI6QziDo5Tbtcjp u3qp3HeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBziAAKCRCJcvTf3G3AJrXKD/ 94GyBKZP5zi92YuEpTiW8hf7nEaF+eTLr5/G5tuNyw/8MMBbAPfHaLhXNhTanfvzpp8TPnNigqBzZN m9iZqfI8yZpLaxppQ9Oue/gSMjkVQ8Z6PwaJgYlsEoo9aYJFd6VLIBMq+5hMmYof9dHNVShSVBOjhQ yqOcoEc/vuV6Gn5m8fVUDpSXzFzI0W83yF6EaqJA4jnkvtCRFWrRx24aruLDQ3COq+F96/K+19poxN 9tXuCQtyWluR2GeGK3aqbCsdd9JsJ6csueQv36meVfK6nUUn4SFf1Gckjs7/NYsRHY0HfKFPEEApNR SdEADkgOZDVu2ihgyc9U/vYjlu+NmXrU+GI19763ZRZILtYs4UiDc3hHccbLOaGc7q4aGj095zy2M5 LT2zvzlHJs1L5Nz9jeCVcNhAY1cRNCMGhEqTLl22Bu8v1n/vrjbB4RFcjdhpNEBdErfv7mIzJ1Vr6T tgaFmScPBEF5DbvMEmTlR+21ZFYURngdg0XOO3SecQMHrTygR5y+cK0fGJFWhMT9JbMn8c9T7xRRuQ /Bzsd+0RDz2WQoOImzblcsio31vDsh/sOB8v+lpGof3ke96PD98VcfZfUSfI4QCK+lMSWiMHdsCrpu zqGA8h8aFNOzCl5HT2jwHjibZd3aIc3rEWNjtQZbIIjLIJihjZjelQ3pbFKQ==
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
index 5e79e626172b..2ffa5224aaac 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -284,22 +284,10 @@ __FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
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
@@ -385,7 +373,6 @@ __FORTIFY_INLINE char *strcpy(char *p, const char *q)
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

