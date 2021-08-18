Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63EB3EFB49
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbhHRGKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238375AbhHRGJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:09:29 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEC6C061D7E
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:01 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f3so1151024plg.3
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/IK2hUcT/4MYA89svC69IqQzJMxj9iX8eWhKLXV32Iw=;
        b=Qk0Yz6lf1elHUTBtp4C2PYtCn7PIFLnNofb8ZAFlDdG4MWjk2P3OaV86YbdgUyM7dY
         p5uUZRrMjW9T3n9vwb+/beYXH7FS8a6aFx9wvyxcLlDC639Mj5fKZjSOHMOoCJZ9CqB8
         zyXlq2w/M//Z/z6+X7i6enEtE9dSCC78+dKrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/IK2hUcT/4MYA89svC69IqQzJMxj9iX8eWhKLXV32Iw=;
        b=oTTSPvv3Mb208jYJWMJZt6JDyl45WiWIjgnOKs+rl9AN9G74qXMDWUdaHLVqUltWKf
         1MpzkQG5tuXN7bomdSXBl9nvCjG9I7Lny1LjRz/fNJXxKaiFSdl7SUd6BXR9AWcvpMqM
         Wv4jmTT/Vno6nDlNaBhnb9IOee3Ao1gmLqbEgs7m2waeUi7Rfl1Ua6L6NMflouYAyDv3
         /YytTbwzmpC8YMTtjGCHkUkf795GvOviQwUdokz3BoAUFqioMK2YfR9SYprgeWEzxV7i
         D+9zEcwstorh5f+JYdc/mmE9ihev26kZ/06O92t2IbRAWVd0y1MOdMA0kbJfZqWZFcTs
         0ZUw==
X-Gm-Message-State: AOAM531AEDYZMLX3K4OH4WwrqzVWhE9E3KaYGDj/+7kgOa0Pol9XN6bR
        XvzhN/bqZwILdQdolzkVqEy2jQ==
X-Google-Smtp-Source: ABdhPJwEgHsXijuO9XlN7yS/zuRdw2vU1CmLoC5NvWxHWcUZp3RabJGNl5c6cwBjXYc7xJwspuAu9w==
X-Received: by 2002:a17:902:9046:b029:12c:b5b7:e443 with SMTP id w6-20020a1709029046b029012cb5b7e443mr5821798plz.31.1629266760522;
        Tue, 17 Aug 2021 23:06:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y2sm4445932pfe.146.2021.08.17.23.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:05:58 -0700 (PDT)
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
Subject: [PATCH v2 31/63] fortify: Allow strlen() and strnlen() to pass compile-time known lengths
Date:   Tue, 17 Aug 2021 23:05:01 -0700
Message-Id: <20210818060533.3569517-32-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4037; h=from:subject; bh=A8Geo8n4i5qwpvkI4vHxNJg+9VAd1dz9Zyf2I1wPWkI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMk1/syAnC8eDuJXMCDQbQtT/FS9k5h9kcLncy9 eJedf0qJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjJAAKCRCJcvTf3G3AJrkGD/ sGA1st6iXQakkMrv5jlDBfJfIKpPRffAM37N71hpqxpr1Fr7DdDm3SkcllpDVPtIqv1i9Cq8eZToIP /UfE6TKceHuZ3LA8KcaYA/hx0EQstrTKbvGo5hJu7X3Ycoxw2wvax9yM+VwquMUfmLBHH9kP6tLV/S ggDpCb8GF8AfsdQOxNJZwtuEQHOY/3Vmylwx85UDPcvrJnGAuwc/dEkRVikDg+jmDVeQw6BaEXhsWz VXTUlkQl/+6v0SasN6VTLBRMwAYtijt48hQvZlvCmLFOaRFPlX5PrsmqzeNzTt2J+7R/0dz5cgjoYm 2YSDE0BDUQ1VbBkMkcUoz0ev1b819hruB/JCr91xtsNo+R4R3LVnQHBJVjoctZ0f0mVe+/NM97Zajx Phb9H24sbFTLbi334Ac+II/djOciKyoZNRy1Gozfa6LM2cQPWUQ5sk0ezJ8yxOetb6Xz3m/ygEhbSZ qTJRhaE4vTVKHV9994E/MKPsHd+xSG+9/hzqiL1h5P9/FhRZenRL0+KQ1oW+Z1W3wQmOBsJfj8Qe93 52bnf9k2WzJVmTp3cwaPCp8Uvuh5Ype/IYtfxoP8YApi2HbanWdnrLIMsD9pCtnzhoSncNnH//7lUf iI0pELVQiyQsjoUfQ6MDPhEkqWTauXrhO0J2TxH8JfEbbkLp6/lRYfH8bPiA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under CONFIG_FORTIFY_SOURCE, it is possible for the compiler to perform
strlen() and strnlen() at compile-time when the string size is known.
This is required to support compile-time overflow checking in strlcpy().

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/fortify-string.h | 47 ++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index a3cb1d9aacce..e232a63fd826 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -10,6 +10,18 @@ void __read_overflow(void) __compiletime_error("detected read beyond size of obj
 void __read_overflow2(void) __compiletime_error("detected read beyond size of object (2nd parameter)");
 void __write_overflow(void) __compiletime_error("detected write beyond size of object (1st parameter)");
 
+#define __compiletime_strlen(p)	({		\
+	size_t ret = (size_t)-1;			\
+	size_t p_size = __builtin_object_size(p, 1);	\
+	if (p_size != (size_t)-1) {			\
+		size_t p_len = p_size - 1;		\
+		if (__builtin_constant_p(p[p_len]) &&	\
+		    p[p_len] == '\0')			\
+			ret = __builtin_strlen(p);	\
+	}						\
+	ret;						\
+})
+
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 extern void *__underlying_memchr(const void *p, int c, __kernel_size_t size) __RENAME(memchr);
 extern int __underlying_memcmp(const void *p, const void *q, __kernel_size_t size) __RENAME(memcmp);
@@ -60,21 +72,31 @@ extern __kernel_size_t __real_strnlen(const char *, __kernel_size_t) __RENAME(st
 __FORTIFY_INLINE __kernel_size_t strnlen(const char *p, __kernel_size_t maxlen)
 {
 	size_t p_size = __builtin_object_size(p, 1);
-	__kernel_size_t ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
+	size_t p_len = __compiletime_strlen(p);
+	size_t ret;
+
+	/* We can take compile-time actions when maxlen is const. */
+	if (__builtin_constant_p(maxlen) && p_len != (size_t)-1) {
+		/* If p is const, we can use its compile-time-known len. */
+		if (maxlen >= p_size)
+			return p_len;
+	}
 
+	/* Do no check characters beyond the end of p. */
+	ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
 	if (p_size <= ret && maxlen != ret)
 		fortify_panic(__func__);
 	return ret;
 }
 
+/* defined after fortified strnlen to reuse it. */
 __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
 {
 	__kernel_size_t ret;
 	size_t p_size = __builtin_object_size(p, 1);
 
-	/* Work around gcc excess stack consumption issue */
-	if (p_size == (size_t)-1 ||
-		(__builtin_constant_p(p[p_size - 1]) && p[p_size - 1] == '\0'))
+	/* Give up if we don't know how large p is. */
+	if (p_size == (size_t)-1)
 		return __underlying_strlen(p);
 	ret = strnlen(p, p_size);
 	if (p_size <= ret)
@@ -86,24 +108,27 @@ __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
 extern size_t __real_strlcpy(char *, const char *, size_t) __RENAME(strlcpy);
 __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
 {
-	size_t ret;
 	size_t p_size = __builtin_object_size(p, 1);
 	size_t q_size = __builtin_object_size(q, 1);
+	size_t q_len;	/* Full count of source string length. */
+	size_t len;	/* Count of characters going into destination. */
 
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __real_strlcpy(p, q, size);
-	ret = strlen(q);
-	if (size) {
-		size_t len = (ret >= size) ? size - 1 : ret;
-
-		if (__builtin_constant_p(len) && len >= p_size)
+	q_len = strlen(q);
+	len = (q_len >= size) ? size - 1 : q_len;
+	if (__builtin_constant_p(size) && __builtin_constant_p(q_len) && size) {
+		/* Write size is always larger than destintation. */
+		if (len >= p_size)
 			__write_overflow();
+	}
+	if (size) {
 		if (len >= p_size)
 			fortify_panic(__func__);
 		__underlying_memcpy(p, q, len);
 		p[len] = '\0';
 	}
-	return ret;
+	return q_len;
 }
 
 /* defined after fortified strnlen to reuse it */
-- 
2.30.2

