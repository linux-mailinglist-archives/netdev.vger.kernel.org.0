Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AE93EFBFD
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240556AbhHRGRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbhHRGQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:16:48 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE1CC029834
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:25 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s11so1160174pgr.11
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yostY7DgtNEMxgC+z6nJc1wNrs0N6emskwhOe9bgfvc=;
        b=AeeVJhrfSUwjNkJmHYssbuRGtvwH8MtYjEmQTdlM+zGDSxyBJ28HUKoShXRQriCQzc
         fJG8YQplcuYQRtRQ2YMV0te2Q2U0QO6Xwj/zC20UVKGNd8srvQxwJqSouXymq5Dm9l9U
         kg3aDet5N6dWH1hOI5Ptu5TDuJ7GU9hh7JwQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yostY7DgtNEMxgC+z6nJc1wNrs0N6emskwhOe9bgfvc=;
        b=C0ZKbti4a4iifGjyrB1Q++l7LwhVPnZGRg8FIgxIXzSyC5WDsO29GTZK4GQXIrNL5M
         NAK9H0CYvsQwNkvX97HUrTnYs6sw1S9v/4m9lzv1RHA/CBpzcO34nVHf4fbGiyNNT6/9
         e+yXjR6+/kcJNBkC+KJKtCvE70WbpbjcpvDZDXb/QiyDXB4FgQKSOQ9sLLX8azE5nhgU
         ISwTQomq973WnClzZn9cgGBC6RY0NrNWOFsA6AJ7/yNtbFoq1wOjmfduQJUq9W6LyHPx
         yBfrOJoQbVwR6UVtsezk/G1qS4ovIGCQW/WaEm1l0x2pKAC2Sh2jWDrer6zUi5Q316Eg
         53oQ==
X-Gm-Message-State: AOAM530hrxmJNYOBb24lpMSHxxJsbERhfIUj56v+pthwHT0ozVCdYpN4
        LBJBITd0OtV/nz+TWBo5g3xAOQ==
X-Google-Smtp-Source: ABdhPJx1biBS3JeL8+/6G287ajSKc6EnHKozD5KJ2i1ni7/MspHuQbMRsOEesEpJ1k8lOCChLRw6ow==
X-Received: by 2002:a63:a58:: with SMTP id z24mr7368490pgk.175.1629267264619;
        Tue, 17 Aug 2021 23:14:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j12sm4592066pfj.54.2021.08.17.23.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:14:21 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 27/63] fortify: Move remaining fortify helpers into fortify-string.h
Date:   Tue, 17 Aug 2021 23:04:57 -0700
Message-Id: <20210818060533.3569517-28-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3427; h=from:subject; bh=0VUkvjsb3JE/e2CXDissoloibGhlZ4bMl0ZngnkvP5A=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMjq105jppvlrAL+Uq+MQY6ED6Y9FMI8zm1hPrE ykvADZuJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjIwAKCRCJcvTf3G3AJgxoEA CHX4+YbgJVBHEw9Sn3IX5V504yG/NCxhHF4JykNAz36dr+RFRl0Kcyz2B7nwjZusR5Vmt/ef1uwVpD vUFACpJ9hm3dLxu/TOzjSDpY+dbijOGFsfmjsCnfpZ7Aw7arFR+dueXGHyuppqtxwjiei2VBv7NkLH fIaz4akk3zsm7p8PDUMHVqHTa5KJadN2q9rNGGe0+Vrymyn4W+SQwMoF1brOLKkMdDqC2uxEL+WomR ayeuwznYVE7clbnasPBBK+c0w94SjONDN0Ng+k+qk7s79GdMHv49Bdvc3qSjI4w82/rTLISttfrK8h 8crj7mVMeHx8pEPFSL6XYe9Hp6I0AMkhfaY5SXOS+yzS/kN0cyCbdH2Jz2S2OXNz8FG8XxB4b00ouF va0zZRAIbKaayow+9up5yQAZpQVL+Ck/qd/5shLDnS765J4ldO0QpW00Aqnsheh76nhHtTSkhARFnb nOrWU/S+u9e2w9TiYLMlKl2i29H9TKu/q898ZLUW4WvARATseAhjhoWIIDqDA0tNHartcKh2XPoZUM 6tsR542P5E0Jb+HyJZv13FvgiN/pmDXHx0d4dxAPEXFJ+pJ+KOmNqdeULjuvuwtcy6zKPpS+zTHIhL 71tIGGPwH5X3B5sHrfSSzU26nlZ4bBr+0WqJaLk5Kysl4udUeW+KXqBYHTcQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When commit a28a6e860c6c ("string.h: move fortified functions definitions
in a dedicated header.") moved the fortify-specific code, some helpers
were left behind. Moves the remaining fortify-specific helpers into
fortify-string.h so they're together where they're used. This requires
that any FORTIFY helper function prototypes be conditionally built to
avoid "no prototype" warnings. Additionally removes unused helpers.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Francis Laniel <laniel_francis@privacyrequired.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/fortify-string.h | 7 +++++++
 include/linux/string.h         | 9 ---------
 lib/string_helpers.c           | 2 ++
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index c1be37437e77..7e67d02764db 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -2,6 +2,13 @@
 #ifndef _LINUX_FORTIFY_STRING_H_
 #define _LINUX_FORTIFY_STRING_H_
 
+#define __FORTIFY_INLINE extern __always_inline __attribute__((gnu_inline))
+#define __RENAME(x) __asm__(#x)
+
+void fortify_panic(const char *name) __noreturn __cold;
+void __read_overflow(void) __compiletime_error("detected read beyond size of object (1st parameter)");
+void __read_overflow2(void) __compiletime_error("detected read beyond size of object (2nd parameter)");
+void __write_overflow(void) __compiletime_error("detected write beyond size of object (1st parameter)");
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 extern void *__underlying_memchr(const void *p, int c, __kernel_size_t size) __RENAME(memchr);
diff --git a/include/linux/string.h b/include/linux/string.h
index b48d2d28e0b1..9473f81b9db2 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -249,15 +249,6 @@ static inline const char *kbasename(const char *path)
 	return tail ? tail + 1 : path;
 }
 
-#define __FORTIFY_INLINE extern __always_inline __attribute__((gnu_inline))
-#define __RENAME(x) __asm__(#x)
-
-void fortify_panic(const char *name) __noreturn __cold;
-void __read_overflow(void) __compiletime_error("detected read beyond size of object passed as 1st parameter");
-void __read_overflow2(void) __compiletime_error("detected read beyond size of object passed as 2nd parameter");
-void __read_overflow3(void) __compiletime_error("detected read beyond size of object passed as 3rd parameter");
-void __write_overflow(void) __compiletime_error("detected write beyond size of object passed as 1st parameter");
-
 #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) && defined(CONFIG_FORTIFY_SOURCE)
 #include <linux/fortify-string.h>
 #endif
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index bde13612c25d..faa9d8e4e2c5 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -883,9 +883,11 @@ char *strreplace(char *s, char old, char new)
 }
 EXPORT_SYMBOL(strreplace);
 
+#ifdef CONFIG_FORTIFY_SOURCE
 void fortify_panic(const char *name)
 {
 	pr_emerg("detected buffer overflow in %s\n", name);
 	BUG();
 }
 EXPORT_SYMBOL(fortify_panic);
+#endif /* CONFIG_FORTIFY_SOURCE */
-- 
2.30.2

