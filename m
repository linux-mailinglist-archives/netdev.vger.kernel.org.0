Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BAC3D8148
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhG0VRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhG0VQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:16:57 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AE9C061799
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:56 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so1268711pjd.0
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/OVgTbTtEQVoBvCYg6jSmmU2Jgo9MSvA0i/isq2f++M=;
        b=Wm+Rznum7P688B/j40t8dWZbI3yL279fIwcyE8kRrWHtUSw2wnQuFT9lnz2fc4+43S
         VfkMQShGeL8RgeifHwa+1Gb4HuwEbMHW1NdNSoXO6NwhzZS18EWYDI2Rgakw6baZcLDS
         jAADfGvlUDiysfwlDOKPNJGXo8MmEW8NRVWiA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/OVgTbTtEQVoBvCYg6jSmmU2Jgo9MSvA0i/isq2f++M=;
        b=Vbh4KQYnHF28LFo1HoMBkdTNXe4dxxCY/VyY7jy392RROAlnMYBkSXQ1WqzS/vHHMD
         1fJpIq2Y4RTZtNPo+3lqChyGzG82Aqm0i/qIMYqKveZtQ62bWKvDlCDZkZ2WGhP7cXGC
         uzOxFFUSfeQGJJmux5XM2EmpOE5AzU2CH6W74dEReNk9U4u0yQN/aBb/QJ7ll5Dl8wO4
         pioxjmcFtwy81qGi/QJ187nbgMO/uBOMl0otHoVMLL/WGHOCVRQiEoQFyYklcGnL7AAY
         /hv8LGl5NaGocyaXn/KW+nmXlzScnhOL/+sublArhQ/pdMmPZHT7gYa5A+GvZlKBU168
         0meQ==
X-Gm-Message-State: AOAM5305T6Ht9YOU3r/B+/VZeeBdqhU9p+XrJ6qvUrxms2asSe5Q+IX3
        iDfoS17s7dOSRT+NIgT4c0Y4tA==
X-Google-Smtp-Source: ABdhPJzGt/TIZEMxb0jzYjcSPNZqHmgh+Y9I/xLu9VXGsQFFdjJSOJYeTkh6wOBuz86gO+ElXByK/Q==
X-Received: by 2002:aa7:88d3:0:b029:32b:75d0:fa92 with SMTP id k19-20020aa788d30000b029032b75d0fa92mr25046135pff.23.1627420616406;
        Tue, 27 Jul 2021 14:16:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 16sm4884267pfu.109.2021.07.27.14.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:16:54 -0700 (PDT)
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
Subject: [PATCH 60/64] fortify: Work around Clang inlining bugs
Date:   Tue, 27 Jul 2021 13:58:51 -0700
Message-Id: <20210727205855.411487-61-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5531; h=from:subject; bh=ngORCtAEDkc0H50xemEev9lyKw3n/iy6PZa3T6iXU20=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHONyzkRh/fY4SBFQw0UvjjNrDOdvLbPeIhyRa2i rGIomkmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzjQAKCRCJcvTf3G3AJvcJD/ 9ExL37cKA3LzSQ4zLIwXWTofeLwiWaiJD2+4i6tZEdnlJ8ccIL6btbcA2/oKfwlt1Q/3aES1AfKvIp jX6QjMKLDVKoWDUwiV9cOfOSRNzlAJh+OWfd2UXFfAdjQ1Z+kurhqEfopYDzlXfZM/8Ll43JIXMy41 vRqzlXgxfU15MNxESA/2XVgVEq3AvADRrvMCLGF5sHXCGgcveDW73AuUPS9mFcuZNUwF4gXoC4tYAe iEknP/dsD2B1XUNWe6UXbC/nVA5fKWvikUxIgbeQvEJhFaAhEzz12AGCMWmYr5bBsiq4nE6SDMBRoB NxxYclKyhzZsf8NgLPDl1jnyOm5aK7+ppgvnl8/juecTXhoAeF5t4LcfgM9j6/nf6smMrbxkzvh8Hu kSMfLMSRbarT8DEYRsB4cOqvhtdunaoyyYS/iYbqXjCi/CBVLwAMrtD4Vm2UbWbz6opAzxWpLDHNIC NMoz0rNe69d8YBgNkUvq2oy1LcwrK/wAqTye/+4JUEY8Z7oz3apJZXgKntDIsiLVEafejl1w23aM9S qSKmhPAxUfHYW+msCimLNAvgWiEwVFHUIXg7Xo7PaOutDbMyl60C4HlzrSbkkF0HfkVZ7GF2sc+Kme /Kcbctx//Q2WSaC6OpP3OUv2AZUQXGVOv3FbJkiHhmwXwhzfjA6IB+t2CxqA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To enable FORTIFY_SOURCE support for Clang, the kernel must work around
a pair of bugs, related to Clang's inlining.

Change all the fortified APIs into macros with different inline names to
bypass Clang's broken inline-of-a-builtin detection:
https://bugs.llvm.org/show_bug.cgi?id=50322

Lift all misbehaving __builtin_object_size() calls into the macros to
bypass Clang's broken __builtin_object_size() arguments-of-an-inline
visibility:
https://github.com/ClangBuiltLinux/linux/issues/1401

Thankfully, due to how the inlining already behaves in GCC, this change
has no effect on GCC builds, but allows Clang to finally gain full
FORTIFY coverage.

However, because of a third bug which had no work-arounds, FORTIFY_SOURCE
will only work with Clang version 13 and later. Update the Kconfig to
reflect the new requirements.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/fortify-string.h | 33 +++++++++++++++++++++------------
 security/Kconfig               |  2 +-
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 718325331021..4afd42079d3b 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -38,10 +38,11 @@ extern char *__underlying_strncpy(char *p, const char *q, __kernel_size_t size)
 #define __underlying_strncpy	__builtin_strncpy
 #endif
 
-__FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
+#define strncpy(p, q, s) __fortify_strncpy(p, q, s, __builtin_object_size(p, 1))
+__FORTIFY_INLINE char *__fortify_strncpy(char *p, const char *q,
+					 __kernel_size_t size,
+					 const size_t p_size)
 {
-	size_t p_size = __builtin_object_size(p, 1);
-
 	if (__builtin_constant_p(size) && p_size < size)
 		__write_overflow();
 	if (p_size < size)
@@ -112,12 +113,15 @@ __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
 
 /* defined after fortified strnlen to reuse it */
 extern ssize_t __real_strscpy(char *, const char *, size_t) __RENAME(strscpy);
-__FORTIFY_INLINE ssize_t strscpy(char *p, const char *q, size_t size)
+#define strscpy(p, q, s) __fortify_strscpy(p, q, s,			\
+					   __builtin_object_size(p, 1),	\
+					   __builtin_object_size(q, 1))
+__FORTIFY_INLINE ssize_t __fortify_strscpy(char *p, const char *q,
+					   size_t size,
+					   const size_t p_size,
+					   const size_t q_size)
 {
 	size_t len;
-	/* Use string size rather than possible enclosing struct size. */
-	size_t p_size = __builtin_object_size(p, 1);
-	size_t q_size = __builtin_object_size(q, 1);
 
 	/* If we cannot get size of p and q default to call strscpy. */
 	if (p_size == (size_t) -1 && q_size == (size_t) -1)
@@ -329,7 +333,8 @@ __FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
 		memmove)
 
 extern void *__real_memscan(void *, int, __kernel_size_t) __RENAME(memscan);
-__FORTIFY_INLINE void *memscan(void *p, int c, __kernel_size_t size)
+#define memscan(p, c, s) __fortify_memscan(p, c, s)
+__FORTIFY_INLINE void *__fortify_memscan(void *p, int c, __kernel_size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
 
@@ -340,7 +345,8 @@ __FORTIFY_INLINE void *memscan(void *p, int c, __kernel_size_t size)
 	return __real_memscan(p, c, size);
 }
 
-__FORTIFY_INLINE int memcmp(const void *p, const void *q, __kernel_size_t size)
+#define memcmp(p, q, s) __fortify_memcmp(p, q, s)
+__FORTIFY_INLINE int __fortify_memcmp(const void *p, const void *q, __kernel_size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
 	size_t q_size = __builtin_object_size(q, 0);
@@ -356,7 +362,8 @@ __FORTIFY_INLINE int memcmp(const void *p, const void *q, __kernel_size_t size)
 	return __underlying_memcmp(p, q, size);
 }
 
-__FORTIFY_INLINE void *memchr(const void *p, int c, __kernel_size_t size)
+#define memchr(p, c, s) __fortify_memchr(p, c, s)
+__FORTIFY_INLINE void *__fortify_memchr(const void *p, int c, __kernel_size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
 
@@ -368,7 +375,8 @@ __FORTIFY_INLINE void *memchr(const void *p, int c, __kernel_size_t size)
 }
 
 void *__real_memchr_inv(const void *s, int c, size_t n) __RENAME(memchr_inv);
-__FORTIFY_INLINE void *memchr_inv(const void *p, int c, size_t size)
+#define memchr_inv(p, c, s) __fortify_memchr_inv(p, c, s)
+__FORTIFY_INLINE void *__fortify_memchr_inv(const void *p, int c, size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
 
@@ -392,7 +400,8 @@ __FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
 }
 
 /* Defined after fortified strlen to reuse it. */
-__FORTIFY_INLINE char *strcpy(char *p, const char *q)
+#define strcpy(p, q) __fortify_strcpy(p, q)
+__FORTIFY_INLINE char *__fortify_strcpy(char *p, const char *q)
 {
 	size_t p_size = __builtin_object_size(p, 1);
 	size_t q_size = __builtin_object_size(q, 1);
diff --git a/security/Kconfig b/security/Kconfig
index 8f0e675e70a4..509ec61bc54b 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -193,7 +193,7 @@ config FORTIFY_SOURCE
 	depends on ARCH_HAS_FORTIFY_SOURCE
 	# https://bugs.llvm.org/show_bug.cgi?id=50322
 	# https://bugs.llvm.org/show_bug.cgi?id=41459
-	depends on !CONFIG_CC_IS_CLANG
+	depends on !CONFIG_CC_IS_CLANG || CLANG_VERSION >= 130000
 	help
 	  Detect overflows of buffers in common string and memory functions
 	  where the compiler can determine and validate the buffer sizes.
-- 
2.30.2

