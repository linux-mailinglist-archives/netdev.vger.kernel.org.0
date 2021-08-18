Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D276A3EFBAD
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbhHRGOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237974AbhHRGNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:13:37 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0EDC0363CE
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:07 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m26so1068125pff.3
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0bRXcGnjUc7NVLeCTdRJyE4ge8RgoyPp9mDS2KzOq8s=;
        b=WQqdtls/I5KQTun/hms341YldczQzpNKS3BfKfWY/GwZZ0hWoG9we6ibSjWW7lx/A3
         n6thS6+Nyek/C9pXuosZvP3ZzBi7YorfMd8mKDm8qDfvHb0EJADzUaECrtRMe9FIa9KN
         qz2Nc4X0B0W57jPUBjUc42oG7dCdby25RRrX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0bRXcGnjUc7NVLeCTdRJyE4ge8RgoyPp9mDS2KzOq8s=;
        b=XATzozpJ/evwEhwMd5fT9W9lXjcwmzmDmF/IWPip+MwMm/CIO6Rs3+6TRPyqBbcWvp
         Tzd4sa9TK4Vq7voaxkdJ5kTFeKS9yz8h0Xstnou1jMjUnoMVNbuctRbCBmRtALIXCa5O
         r5rV94nDh4iFmJJiTrDO6a6vL7K9cf9v9D5lMmxMwmEzFFz2/oGogRiUhClqL1fiQm3r
         bbp+2xi+M0d3ao3vTFQoUH9Yo7Ut1lvVP8lmPjCilde/gHsAFRbUQkQbavhi69MMpwFE
         78/1+egolDhjeP91xCHgnStjWimR6VmgQCOnDa5zOhw9NZeILOJB+CfEZcAXJ74kfSbN
         KUQw==
X-Gm-Message-State: AOAM530dQKWRn0VEsE/+4wI+P+rLWI23/T4EvEUj8C/pPTRyh6b0exJo
        yH2PRheJStx0iXCfKvGL/vOM/g==
X-Google-Smtp-Source: ABdhPJzf07hn4/UJFD8k9v/PFTouOU2hjIEruQiURQ/GtTe5NoEQV+QNXrPpXGYcUZ9Mijvig6sL0A==
X-Received: by 2002:aa7:8206:0:b029:3c6:2846:3f9f with SMTP id k6-20020aa782060000b02903c628463f9fmr7834685pfi.30.1629266766977;
        Tue, 17 Aug 2021 23:06:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l18sm4571594pff.24.2021.08.17.23.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:06:04 -0700 (PDT)
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
Subject: [PATCH v2 63/63] fortify: Work around Clang inlining bugs
Date:   Tue, 17 Aug 2021 23:05:33 -0700
Message-Id: <20210818060533.3569517-64-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7591; h=from:subject; bh=Hec0xxMOh0cK4yBYBOcb5aqhxRAjnc34rm5FBOgOGD0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMs6ml8yWGswBEn8BNaWTcv46iAfG0OJbmF8YMg oAEj0wmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjLAAKCRCJcvTf3G3AJmy1EA Cxa4AsWTCF8/uDP8AV7JotgjiK7+Wd6hTmjaB2izxSIO3ujFU7lf++q7Flx4Rk0Khk2tYC5yFzkf1q KsVqRI+lR033mk6KdPSJ9FrfNzNJz8wPKrUcmvO1yC5Ew7NsSbVcFG9rAJTpUGSp6PB33hEZa7ao6X g00L0SWHv3JrcPqQxfPVH40XS0edTmHg2xsJ5mtz/NsFH7sjkVvbomQwzPWIWneWOUFnBoNs+gvf6t vSf2XOihAR71V0F5AszPaupkbs6G5njj1px9/ENBv3HIa208Q3y8DpqsvqamaITfm+fmWG8CrO/7OT jWWUwcLUoiPAzcKaa+OKE5ii0xStgjRPNhoJKsOJU0dDqt0/5/X37hzygJ+A+cggmAIfMoTzmE9a8f appSBcljh4nYutCtxDKnbc2yqCBtKYTAlZ+vqGGAe35wFrXKhNNsQK7c8ciBk7F+G4tdWcsfmTfE+h Z4gxHVqy2JU4v0EWPwh/KVUbbHw6edMeAslLgW8TyhklAWJSFhjGecLkyTpx66usdMKTWdYMmrbu8O PytqhJuULFGtFs5i5jkysrms3SGobkhoweDZHzjT82RPdfsZchVOG0LZfHsmuh54DBoXEf/9bw4Zgm QQ4sjZ4Ski2g83oskEkT+N7EABOdA+mCeKE78rnk61IM+xXh4/vRHiEA0ipw==
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
 include/linux/fortify-string.h | 55 +++++++++++++++++++++-------------
 security/Kconfig               |  2 +-
 2 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 7de4673dfe2c..e62d3633a329 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -48,10 +48,10 @@ extern char *__underlying_strncpy(char *p, const char *q, __kernel_size_t size)
 #define __underlying_strncpy	__builtin_strncpy
 #endif
 
-__FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
+#define strncpy(p, q, s) __fortify_strncpy(p, q, s, __builtin_object_size(p, 1))
+__FORTIFY_INLINE char *__fortify_strncpy(char *p, const char *q,
+					 __kernel_size_t size, size_t p_size)
 {
-	size_t p_size = __builtin_object_size(p, 1);
-
 	if (__builtin_constant_p(size) && p_size < size)
 		__write_overflow();
 	if (p_size < size)
@@ -71,9 +71,10 @@ __FORTIFY_INLINE char *strcat(char *p, const char *q)
 }
 
 extern __kernel_size_t __real_strnlen(const char *, __kernel_size_t) __RENAME(strnlen);
-__FORTIFY_INLINE __kernel_size_t strnlen(const char *p, __kernel_size_t maxlen)
+#define strnlen(p, s) __fortify_strnlen(p, s, __builtin_object_size(p, 1))
+__FORTIFY_INLINE __kernel_size_t __fortify_strnlen(const char *p, size_t maxlen,
+						   size_t p_size)
 {
-	size_t p_size = __builtin_object_size(p, 1);
 	size_t p_len = __compiletime_strlen(p);
 	size_t ret;
 
@@ -108,10 +109,14 @@ __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
 
 /* defined after fortified strlen to reuse it */
 extern size_t __real_strlcpy(char *, const char *, size_t) __RENAME(strlcpy);
-__FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
+#define strlcpy(p, q, s) __fortify_strlcpy(p, q, s,			\
+					   __builtin_object_size(p, 1),	\
+					   __builtin_object_size(q, 1))
+__FORTIFY_INLINE size_t __fortify_strlcpy(char *p, const char *q,
+					  size_t size,
+					  const size_t p_size,
+					  const size_t q_size)
 {
-	size_t p_size = __builtin_object_size(p, 1);
-	size_t q_size = __builtin_object_size(q, 1);
 	size_t q_len;	/* Full count of source string length. */
 	size_t len;	/* Count of characters going into destination. */
 
@@ -135,12 +140,15 @@ __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
 
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
@@ -181,11 +189,13 @@ __FORTIFY_INLINE ssize_t strscpy(char *p, const char *q, size_t size)
 }
 
 /* defined after fortified strlen and strnlen to reuse them */
-__FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
+#define strncat(p, q, count)	__fortify_strncat(p, q, count, \
+						  __builtin_object_size(p, 1), \
+						  __builtin_object_size(q, 1))
+__FORTIFY_INLINE char *__fortify_strncat(char *p, const char *q, size_t count,
+					 size_t p_size, size_t q_size)
 {
 	size_t p_len, copy_len;
-	size_t p_size = __builtin_object_size(p, 1);
-	size_t q_size = __builtin_object_size(q, 1);
 
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __underlying_strncat(p, q, count);
@@ -352,7 +362,8 @@ __FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
 		memmove)
 
 extern void *__real_memscan(void *, int, __kernel_size_t) __RENAME(memscan);
-__FORTIFY_INLINE void *memscan(void *p, int c, __kernel_size_t size)
+#define memscan(p, c, s) __fortify_memscan(p, c, s)
+__FORTIFY_INLINE void *__fortify_memscan(void *p, int c, __kernel_size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
 
@@ -363,7 +374,8 @@ __FORTIFY_INLINE void *memscan(void *p, int c, __kernel_size_t size)
 	return __real_memscan(p, c, size);
 }
 
-__FORTIFY_INLINE int memcmp(const void *p, const void *q, __kernel_size_t size)
+#define memcmp(p, q, s) __fortify_memcmp(p, q, s)
+__FORTIFY_INLINE int __fortify_memcmp(const void *p, const void *q, __kernel_size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
 	size_t q_size = __builtin_object_size(q, 0);
@@ -379,7 +391,8 @@ __FORTIFY_INLINE int memcmp(const void *p, const void *q, __kernel_size_t size)
 	return __underlying_memcmp(p, q, size);
 }
 
-__FORTIFY_INLINE void *memchr(const void *p, int c, __kernel_size_t size)
+#define memchr(p, c, s) __fortify_memchr(p, c, s)
+__FORTIFY_INLINE void *__fortify_memchr(const void *p, int c, __kernel_size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
 
@@ -391,7 +404,8 @@ __FORTIFY_INLINE void *memchr(const void *p, int c, __kernel_size_t size)
 }
 
 void *__real_memchr_inv(const void *s, int c, size_t n) __RENAME(memchr_inv);
-__FORTIFY_INLINE void *memchr_inv(const void *p, int c, size_t size)
+#define memchr_inv(p, c, s) __fortify_memchr_inv(p, c, s)
+__FORTIFY_INLINE void *__fortify_memchr_inv(const void *p, int c, size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
 
@@ -415,7 +429,8 @@ __FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
 }
 
 /* Defined after fortified strlen to reuse it. */
-__FORTIFY_INLINE char *strcpy(char *p, const char *q)
+#define strcpy(p, q) __fortify_strcpy(p, q)
+__FORTIFY_INLINE char *__fortify_strcpy(char *p, const char *q)
 {
 	size_t p_size = __builtin_object_size(p, 1);
 	size_t q_size = __builtin_object_size(q, 1);
diff --git a/security/Kconfig b/security/Kconfig
index fe6c0395fa02..530a15566b1d 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -193,7 +193,7 @@ config FORTIFY_SOURCE
 	depends on ARCH_HAS_FORTIFY_SOURCE
 	# https://bugs.llvm.org/show_bug.cgi?id=50322
 	# https://bugs.llvm.org/show_bug.cgi?id=41459
-	depends on !CC_IS_CLANG
+	depends on !CC_IS_CLANG || CLANG_VERSION >= 130000
 	help
 	  Detect overflows of buffers in common string and memory functions
 	  where the compiler can determine and validate the buffer sizes.
-- 
2.30.2

