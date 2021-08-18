Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DB53EFBCE
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbhHRGOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239160AbhHRGNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:13:38 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D01CC0363D8
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:07 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id q2so1141477pgt.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WJrpMRxjlck/EUZE2DWpbaWpfbq9vwWWxHEHR5bnD5E=;
        b=Y4RaduW1rzoHa2IpujBCd5gie/q9/2hiLeyjeu9ex0Lvtmxof39Ph82c32u/wEVwec
         BeorvJNM0QtxRwnxngByb5MimEYl+Js8IDKmdRfuXrPFuDqHj3Cmg2kZQWZ0j6OqZuGi
         4aE9yiwILQW91Q1hmTVcwZmAEbqQUR+FHPZhQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WJrpMRxjlck/EUZE2DWpbaWpfbq9vwWWxHEHR5bnD5E=;
        b=iSuFIY5ml93V0hJJqxQt6c9jGSKblubq67ftxTqJc3il6UGY4yeM9c+EMPmfzjP2a7
         vmQaOk3qIV532R5sqrg04ZwTK7469wyJN5kQZ233yES+ZBKS4Oerw5Az7AqoXclWBwl9
         n/Nj+OP4VQ0zhWeDXUDI6BH0ehnCZ3AVBlU1Y+2cXj0c7kU5/7NxP3HJY3bIqDpWt4C/
         cLsjHNUNMfPAD8g2cUiTL+ZFqzNywONrywgVn7atqfrxTlQYUMZofTdmAFfsX/DCij3b
         3pjQPUygj33X24/ZTd6Q0rbuzsVyl7vl0pYauY8yc5zJbnwRZ6bOlJaDyTZVo23j6R6e
         /kmg==
X-Gm-Message-State: AOAM533q4aGnu48SIW8MF9vIOaMkvL3hHIOJnwMs0ELH3ZdgWxNpfZzz
        WENnoINnaMwUC9FlhErNUhUTQQ==
X-Google-Smtp-Source: ABdhPJw+fxDkXxOl4PBdv0otPn1lIDXevnmHeNda+XtjMx2DvEazLyVTOr/SWrLlENk4ZB/InQEloQ==
X-Received: by 2002:a62:dbc3:0:b029:3e0:ec4a:6e60 with SMTP id f186-20020a62dbc30000b02903e0ec4a6e60mr7438793pfg.25.1629266767474;
        Tue, 17 Aug 2021 23:06:07 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s5sm5498942pgp.81.2021.08.17.23.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:06:05 -0700 (PDT)
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
Subject: [PATCH v2 62/63] fortify: Detect struct member overflows in memset() at compile-time
Date:   Tue, 17 Aug 2021 23:05:32 -0700
Message-Id: <20210818060533.3569517-63-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3657; h=from:subject; bh=x4SNp17MkJsMDii5dKL06SU0zDLItyjvjIE8yvAGOLw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMsuEVllcthHvVoZOOtiNzdZSQL+MVxm5lZYC08 cYuVeeiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjLAAKCRCJcvTf3G3AJhFJD/ 0YywcHnMj1c/NexxJTDTdAYqmtmTUD8x82Ns/wjrQAyODC3hv/6fd7/lXy7KLnBf3O7mSQRPo1siWq mi4sD6BTm3hIo3GuFOJ8CTfGgnxxwdN6j/TkfuxlpJSHWlG8CdQJaYNCYJgI7QT0k7mcvIcU0Yiu5/ YaVOOC0zQ85PA//3PbzguuPv50kBbxQ5bQSD5XS5ptljehOSJcCJ66K/cFUtnJoZrfF5m7naOzclM+ YSn8wlMr9aQqL6DEc6etgSVI2n22I9gcsWaObJAPYCut15PH0LnKu3TXUtF2oQy91xDTCZ0kCAuzqt 5poO59eUPNtjb6apuyTyI2sng4UXAVOqnFeKce+zQIoGAdIb5GjE13ffC5AAon3CmAbxRE5FUufUrx zUIYqjgohnwHn6YDtth4aIZB/W2kLG2W2q4TWuZjMxEaw0SVrnd4P2jJSHU8B8d1a6PkAs8epAq0gc D69QvVpSd/j5KuzMZUdDpOKxgIKUXFGXliJiDsu+4vuCdioBLapgoOTvVDBi1LirQl6lP45HoxFQ0b S64cenON/jFuSH9ZmumaJj1QScmPVkoNRRs09YB5f0juMR7C0bopH+EEmaqk++upwBm1nP/e/Dtxew r7vE625A/r6FGg4xIb9flyd3LdIf3HsRkH/Bt6+5XCnDvRxE/u5ev7V+yD8w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As done for memcpy(), also update memset() to use the same tightened
compile-time bounds checking under CONFIG_FORTIFY_SOURCE.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/fortify-string.h                | 54 ++++++++++++++++---
 .../write_overflow_field-memset.c             |  5 ++
 2 files changed, 51 insertions(+), 8 deletions(-)
 create mode 100644 lib/test_fortify/write_overflow_field-memset.c

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 0120d463ba33..7de4673dfe2c 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -198,17 +198,56 @@ __FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
 	return p;
 }
 
-__FORTIFY_INLINE void *memset(void *p, int c, __kernel_size_t size)
+__FORTIFY_INLINE void fortify_memset_chk(__kernel_size_t size,
+					 const size_t p_size,
+					 const size_t p_size_field)
 {
-	size_t p_size = __builtin_object_size(p, 0);
+	if (__builtin_constant_p(size)) {
+		/*
+		 * Length argument is a constant expression, so we
+		 * can perform compile-time bounds checking where
+		 * buffer sizes are known.
+		 */
 
-	if (__builtin_constant_p(size) && p_size < size)
-		__write_overflow();
-	if (p_size < size)
-		fortify_panic(__func__);
-	return __underlying_memset(p, c, size);
+		/* Error when size is larger than enclosing struct. */
+		if (p_size > p_size_field && p_size < size)
+			__write_overflow();
+
+		/* Warn when write size is larger than dest field. */
+		if (p_size_field < size)
+			__write_overflow_field(p_size_field, size);
+	}
+	/*
+	 * At this point, length argument may not be a constant expression,
+	 * so run-time bounds checking can be done where buffer sizes are
+	 * known. (This is not an "else" because the above checks may only
+	 * be compile-time warnings, and we want to still warn for run-time
+	 * overflows.)
+	 */
+
+	/*
+	 * Always stop accesses beyond the struct that contains the
+	 * field, when the buffer's remaining size is known.
+	 * (The -1 test is to optimize away checks where the buffer
+	 * lengths are unknown.)
+	 */
+	if (p_size != (size_t)(-1) && p_size < size)
+		fortify_panic("memset");
 }
 
+#define __fortify_memset_chk(p, c, size, p_size, p_size_field) ({	\
+	size_t __fortify_size = (size_t)(size);				\
+	fortify_memset_chk(__fortify_size, p_size, p_size_field),	\
+	__underlying_memset(p, c, __fortify_size);			\
+})
+
+/*
+ * __builtin_object_size() must be captured here to avoid evaluating argument
+ * side-effects further into the macro layers.
+ */
+#define memset(p, c, s) __fortify_memset_chk(p, c, s,			\
+		__builtin_object_size(p, 0), __builtin_object_size(p, 1))
+
 /*
  * To make sure the compiler can enforce protection against buffer overflows,
  * memcpy(), memmove(), and memset() must not be used beyond individual
@@ -399,7 +438,6 @@ __FORTIFY_INLINE char *strcpy(char *p, const char *q)
 /* Don't use these outside the FORITFY_SOURCE implementation */
 #undef __underlying_memchr
 #undef __underlying_memcmp
-#undef __underlying_memset
 #undef __underlying_strcat
 #undef __underlying_strcpy
 #undef __underlying_strlen
diff --git a/lib/test_fortify/write_overflow_field-memset.c b/lib/test_fortify/write_overflow_field-memset.c
new file mode 100644
index 000000000000..2331da26909e
--- /dev/null
+++ b/lib/test_fortify/write_overflow_field-memset.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memset(instance.buf, 0x42, sizeof(instance.buf) + 1)
+
+#include "test_fortify.h"
-- 
2.30.2

