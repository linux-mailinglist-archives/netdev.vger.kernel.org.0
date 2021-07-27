Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41E73D8008
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhG0U7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbhG0U73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C72CC06179E
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so1035995pjh.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c29mjakfJ2fQ2aKIFDDh6/0VPCMzD6jfrBsIcDqvz00=;
        b=RlPhQG4tFupRcF9Zo5SGLaxAzNDapbwIteB7u6rkSzbogSBMZllEF/VrAqnEiZD/3N
         jMu0vVlQLCR6LveoC6Xen5g1970529LJ0bSbtflIp3scLv5bGM33uM5lba5O2TQIAKEO
         uBM3AH5sYjQq47126sIPL2SS3WLMhjNYiSJLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c29mjakfJ2fQ2aKIFDDh6/0VPCMzD6jfrBsIcDqvz00=;
        b=G6pQ96LRMamff0hsE5V8Y1c6CQMD9wWl9oSj1hSukIV1mCZ6EYXn1GdcoNdaFBkEPa
         mY4q3K1rl8dJFGD9t3QML8PaQiednPrDrrst3xBfS1FFEusVGjVapbUqhk58xdga7eyi
         w8kDs+os4Zc4/NRgy+nMZscbVS3xIWfnQ3I5YnWEjQ5MGnnDg3sjvaJmKdsu+eU3uCKT
         Cl8IAN+t2bYeU0A2ZnaQNyXotVzbwo5vsbxO3aN6EPyrkZZmN9sW9QFunjHQPCrM6e8G
         LSLBkZ5EU4d7EDb2YAVbGFKLqHVL76FnP21EIAwOd4cSsONRiy4dSblEI50cHzPVZZZh
         hqtA==
X-Gm-Message-State: AOAM5309xGvn8+vf0sYJEHO2VyOBF9YFqlrwfdq+IY8I2VuhmuPLKxGA
        Nmc5r+/1d63ilDtAD5ymkQTWdA==
X-Google-Smtp-Source: ABdhPJy4n6zLpIfc83AEqeykgnFel2hLbQQnKIVQqjjF1PsMpjqsZGXLxGOhII4TmSA9tlI0HY9XsA==
X-Received: by 2002:a17:902:8606:b029:12c:2625:76cf with SMTP id f6-20020a1709028606b029012c262576cfmr9776543plo.17.1627419552543;
        Tue, 27 Jul 2021 13:59:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d2sm5224630pgk.57.2021.07.27.13.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:12 -0700 (PDT)
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
Subject: [PATCH 29/64] lib/string: Move helper functions out of string.c
Date:   Tue, 27 Jul 2021 13:58:20 -0700
Message-Id: <20210727205855.411487-30-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14604; h=from:subject; bh=S7ayvaB/WvgQx4Mye8ZmTgp4lMn5gOzwUYIKOkIvxtk=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOGtU59dpyaXNjl7+40exQadXHRV8ojrTSYXlDX 8jxwuf2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhgAKCRCJcvTf3G3AJulfEA CDk2ls2fJR5urOPfvp3kBHnCCLyfSNh+jPPHNyx3njttSgb5Bp0TaONW7u9SunWJSpt0Zqy8auK9DG VUiEbT2hpBZvJBdpuNTQG5gk1mRWTr70dKmgNc60pPNvGircEZx9kMkwcEHeS6wGR1r+ubabC/oV8i jmOCgbQbDU5f7pOy6qr4NojU8Y5uVCI1NGL/tRntYbV97PJ9zd7M7lEWGUo4GtqciXyWnoLBtGEGAc 1M/nrNNJ9uBCzDxWmLQKIM9ilUj1nmF7RLtEQtWBUt7cKYrAYamljDFYRgBUKWMN9XcKvUs9GPzoGa NkYrTO7ue4cIUZ5tMUOKdJo/VXnnhn+QDgHUkmp/GJJmbGZDGwVeDCBXb10nuGwlSJL8CwE4T8tgxC vLCDGkzpu3WvJ82rW8NYlvkO6kTjm4Ur47mhyoT8p2mwTB7fbt8l+/xjGv7I96Y4snCJ5Z+HqW2wtk m6e1bffmtgbHM9KBdjccvPUjllFMLaw63f7/AVanB9wg2CebfEQLRWvXFgLImuR/zmCj0xSukFk9eG 9S13IXRFRUv/Rvq5ehsZX17XBhJMqkYSVTeOkPYx73MaNz6lkT72s0zmHkKSTYfysl5jA06XK5wMzD p+/hAezOPeAb0HoqGG9vEIRql0f+pgVzuVd+Yw1HRFjX05rn3Kzzg7DtKaVQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The core functions of string.c are those that may be implemented by
per-architecture functions, or overloaded by FORTIFY_SOURCE. As a
result, it needs to be built with __NO_FORTIFY. Without this, macros
will collide with function declarations. This was accidentally working
due to -ffreestanding (on some architectures). Make this deterministic
by explicitly setting __NO_FORTIFY and move all the helper functions
into string_helpers.c so that they gain the fortification coverage they
had been missing.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/s390/lib/string.c   |   3 +
 arch/x86/lib/string_32.c |   1 +
 lib/string.c             | 210 ++-------------------------------------
 lib/string_helpers.c     | 193 +++++++++++++++++++++++++++++++++++
 4 files changed, 203 insertions(+), 204 deletions(-)

diff --git a/arch/s390/lib/string.c b/arch/s390/lib/string.c
index cfcdf76d6a95..392fb9f4f4db 100644
--- a/arch/s390/lib/string.c
+++ b/arch/s390/lib/string.c
@@ -8,6 +8,9 @@
  */
 
 #define IN_ARCH_STRING_C 1
+#ifndef __NO_FORTIFY
+# define __NO_FORTIFY
+#endif
 
 #include <linux/types.h>
 #include <linux/string.h>
diff --git a/arch/x86/lib/string_32.c b/arch/x86/lib/string_32.c
index d15fdae9656e..53b3f202267c 100644
--- a/arch/x86/lib/string_32.c
+++ b/arch/x86/lib/string_32.c
@@ -11,6 +11,7 @@
  * strings.
  */
 
+#define __NO_FORTIFY
 #include <linux/string.h>
 #include <linux/export.h>
 
diff --git a/lib/string.c b/lib/string.c
index 4fec38fc6e58..4e111d9dd6d5 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -6,20 +6,15 @@
  */
 
 /*
- * stupid library routines.. The optimized versions should generally be found
- * as inline code in <asm-xx/string.h>
+ * This file should be used only for "library" routines that may have
+ * alternative implementations on specific architectures (generally
+ * found in <asm-xx/string.h>), or get overloaded by FORTIFY_SOURCE.
+ * (Specifically, this file is built with __NO_FORTIFY.)
  *
- * These are buggy as well..
- *
- * * Fri Jun 25 1999, Ingo Oeser <ioe@informatik.tu-chemnitz.de>
- * -  Added strsep() which will replace strtok() soon (because strsep() is
- *    reentrant and should be faster). Use only strsep() in new code, please.
- *
- * * Sat Feb 09 2002, Jason Thomas <jason@topic.com.au>,
- *                    Matthew Hawkins <matt@mh.dropbear.id.au>
- * -  Kissed strtok() goodbye
+ * Other helper functions should live in string_helpers.c.
  */
 
+#define __NO_FORTIFY
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
@@ -254,40 +249,6 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
 EXPORT_SYMBOL(strscpy);
 #endif
 
-/**
- * strscpy_pad() - Copy a C-string into a sized buffer
- * @dest: Where to copy the string to
- * @src: Where to copy the string from
- * @count: Size of destination buffer
- *
- * Copy the string, or as much of it as fits, into the dest buffer.  The
- * behavior is undefined if the string buffers overlap.  The destination
- * buffer is always %NUL terminated, unless it's zero-sized.
- *
- * If the source string is shorter than the destination buffer, zeros
- * the tail of the destination buffer.
- *
- * For full explanation of why you may want to consider using the
- * 'strscpy' functions please see the function docstring for strscpy().
- *
- * Returns:
- * * The number of characters copied (not including the trailing %NUL)
- * * -E2BIG if count is 0 or @src was truncated.
- */
-ssize_t strscpy_pad(char *dest, const char *src, size_t count)
-{
-	ssize_t written;
-
-	written = strscpy(dest, src, count);
-	if (written < 0 || written == count - 1)
-		return written;
-
-	memset(dest + written + 1, 0, count - written - 1);
-
-	return written;
-}
-EXPORT_SYMBOL(strscpy_pad);
-
 /**
  * stpcpy - copy a string from src to dest returning a pointer to the new end
  *          of dest, including src's %NUL-terminator. May overrun dest.
@@ -530,46 +491,6 @@ char *strnchr(const char *s, size_t count, int c)
 EXPORT_SYMBOL(strnchr);
 #endif
 
-/**
- * skip_spaces - Removes leading whitespace from @str.
- * @str: The string to be stripped.
- *
- * Returns a pointer to the first non-whitespace character in @str.
- */
-char *skip_spaces(const char *str)
-{
-	while (isspace(*str))
-		++str;
-	return (char *)str;
-}
-EXPORT_SYMBOL(skip_spaces);
-
-/**
- * strim - Removes leading and trailing whitespace from @s.
- * @s: The string to be stripped.
- *
- * Note that the first trailing whitespace is replaced with a %NUL-terminator
- * in the given string @s. Returns a pointer to the first non-whitespace
- * character in @s.
- */
-char *strim(char *s)
-{
-	size_t size;
-	char *end;
-
-	size = strlen(s);
-	if (!size)
-		return s;
-
-	end = s + size - 1;
-	while (end >= s && isspace(*end))
-		end--;
-	*(end + 1) = '\0';
-
-	return skip_spaces(s);
-}
-EXPORT_SYMBOL(strim);
-
 #ifndef __HAVE_ARCH_STRLEN
 /**
  * strlen - Find the length of a string
@@ -704,101 +625,6 @@ char *strsep(char **s, const char *ct)
 EXPORT_SYMBOL(strsep);
 #endif
 
-/**
- * sysfs_streq - return true if strings are equal, modulo trailing newline
- * @s1: one string
- * @s2: another string
- *
- * This routine returns true iff two strings are equal, treating both
- * NUL and newline-then-NUL as equivalent string terminations.  It's
- * geared for use with sysfs input strings, which generally terminate
- * with newlines but are compared against values without newlines.
- */
-bool sysfs_streq(const char *s1, const char *s2)
-{
-	while (*s1 && *s1 == *s2) {
-		s1++;
-		s2++;
-	}
-
-	if (*s1 == *s2)
-		return true;
-	if (!*s1 && *s2 == '\n' && !s2[1])
-		return true;
-	if (*s1 == '\n' && !s1[1] && !*s2)
-		return true;
-	return false;
-}
-EXPORT_SYMBOL(sysfs_streq);
-
-/**
- * match_string - matches given string in an array
- * @array:	array of strings
- * @n:		number of strings in the array or -1 for NULL terminated arrays
- * @string:	string to match with
- *
- * This routine will look for a string in an array of strings up to the
- * n-th element in the array or until the first NULL element.
- *
- * Historically the value of -1 for @n, was used to search in arrays that
- * are NULL terminated. However, the function does not make a distinction
- * when finishing the search: either @n elements have been compared OR
- * the first NULL element was found.
- *
- * Return:
- * index of a @string in the @array if matches, or %-EINVAL otherwise.
- */
-int match_string(const char * const *array, size_t n, const char *string)
-{
-	int index;
-	const char *item;
-
-	for (index = 0; index < n; index++) {
-		item = array[index];
-		if (!item)
-			break;
-		if (!strcmp(item, string))
-			return index;
-	}
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL(match_string);
-
-/**
- * __sysfs_match_string - matches given string in an array
- * @array: array of strings
- * @n: number of strings in the array or -1 for NULL terminated arrays
- * @str: string to match with
- *
- * Returns index of @str in the @array or -EINVAL, just like match_string().
- * Uses sysfs_streq instead of strcmp for matching.
- *
- * This routine will look for a string in an array of strings up to the
- * n-th element in the array or until the first NULL element.
- *
- * Historically the value of -1 for @n, was used to search in arrays that
- * are NULL terminated. However, the function does not make a distinction
- * when finishing the search: either @n elements have been compared OR
- * the first NULL element was found.
- */
-int __sysfs_match_string(const char * const *array, size_t n, const char *str)
-{
-	const char *item;
-	int index;
-
-	for (index = 0; index < n; index++) {
-		item = array[index];
-		if (!item)
-			break;
-		if (sysfs_streq(item, str))
-			return index;
-	}
-
-	return -EINVAL;
-}
-EXPORT_SYMBOL(__sysfs_match_string);
-
 #ifndef __HAVE_ARCH_MEMSET
 /**
  * memset - Fill a region of memory with the given value
@@ -1221,27 +1047,3 @@ void *memchr_inv(const void *start, int c, size_t bytes)
 	return check_bytes8(start, value, bytes % 8);
 }
 EXPORT_SYMBOL(memchr_inv);
-
-/**
- * strreplace - Replace all occurrences of character in string.
- * @s: The string to operate on.
- * @old: The character being replaced.
- * @new: The character @old is replaced with.
- *
- * Returns pointer to the nul byte at the end of @s.
- */
-char *strreplace(char *s, char old, char new)
-{
-	for (; *s; ++s)
-		if (*s == old)
-			*s = new;
-	return s;
-}
-EXPORT_SYMBOL(strreplace);
-
-void fortify_panic(const char *name)
-{
-	pr_emerg("detected buffer overflow in %s\n", name);
-	BUG();
-}
-EXPORT_SYMBOL(fortify_panic);
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 3806a52ce697..bde13612c25d 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -696,3 +696,196 @@ void kfree_strarray(char **array, size_t n)
 	kfree(array);
 }
 EXPORT_SYMBOL_GPL(kfree_strarray);
+
+/**
+ * strscpy_pad() - Copy a C-string into a sized buffer
+ * @dest: Where to copy the string to
+ * @src: Where to copy the string from
+ * @count: Size of destination buffer
+ *
+ * Copy the string, or as much of it as fits, into the dest buffer.  The
+ * behavior is undefined if the string buffers overlap.  The destination
+ * buffer is always %NUL terminated, unless it's zero-sized.
+ *
+ * If the source string is shorter than the destination buffer, zeros
+ * the tail of the destination buffer.
+ *
+ * For full explanation of why you may want to consider using the
+ * 'strscpy' functions please see the function docstring for strscpy().
+ *
+ * Returns:
+ * * The number of characters copied (not including the trailing %NUL)
+ * * -E2BIG if count is 0 or @src was truncated.
+ */
+ssize_t strscpy_pad(char *dest, const char *src, size_t count)
+{
+	ssize_t written;
+
+	written = strscpy(dest, src, count);
+	if (written < 0 || written == count - 1)
+		return written;
+
+	memset(dest + written + 1, 0, count - written - 1);
+
+	return written;
+}
+EXPORT_SYMBOL(strscpy_pad);
+
+/**
+ * skip_spaces - Removes leading whitespace from @str.
+ * @str: The string to be stripped.
+ *
+ * Returns a pointer to the first non-whitespace character in @str.
+ */
+char *skip_spaces(const char *str)
+{
+	while (isspace(*str))
+		++str;
+	return (char *)str;
+}
+EXPORT_SYMBOL(skip_spaces);
+
+/**
+ * strim - Removes leading and trailing whitespace from @s.
+ * @s: The string to be stripped.
+ *
+ * Note that the first trailing whitespace is replaced with a %NUL-terminator
+ * in the given string @s. Returns a pointer to the first non-whitespace
+ * character in @s.
+ */
+char *strim(char *s)
+{
+	size_t size;
+	char *end;
+
+	size = strlen(s);
+	if (!size)
+		return s;
+
+	end = s + size - 1;
+	while (end >= s && isspace(*end))
+		end--;
+	*(end + 1) = '\0';
+
+	return skip_spaces(s);
+}
+EXPORT_SYMBOL(strim);
+
+/**
+ * sysfs_streq - return true if strings are equal, modulo trailing newline
+ * @s1: one string
+ * @s2: another string
+ *
+ * This routine returns true iff two strings are equal, treating both
+ * NUL and newline-then-NUL as equivalent string terminations.  It's
+ * geared for use with sysfs input strings, which generally terminate
+ * with newlines but are compared against values without newlines.
+ */
+bool sysfs_streq(const char *s1, const char *s2)
+{
+	while (*s1 && *s1 == *s2) {
+		s1++;
+		s2++;
+	}
+
+	if (*s1 == *s2)
+		return true;
+	if (!*s1 && *s2 == '\n' && !s2[1])
+		return true;
+	if (*s1 == '\n' && !s1[1] && !*s2)
+		return true;
+	return false;
+}
+EXPORT_SYMBOL(sysfs_streq);
+
+/**
+ * match_string - matches given string in an array
+ * @array:	array of strings
+ * @n:		number of strings in the array or -1 for NULL terminated arrays
+ * @string:	string to match with
+ *
+ * This routine will look for a string in an array of strings up to the
+ * n-th element in the array or until the first NULL element.
+ *
+ * Historically the value of -1 for @n, was used to search in arrays that
+ * are NULL terminated. However, the function does not make a distinction
+ * when finishing the search: either @n elements have been compared OR
+ * the first NULL element was found.
+ *
+ * Return:
+ * index of a @string in the @array if matches, or %-EINVAL otherwise.
+ */
+int match_string(const char * const *array, size_t n, const char *string)
+{
+	int index;
+	const char *item;
+
+	for (index = 0; index < n; index++) {
+		item = array[index];
+		if (!item)
+			break;
+		if (!strcmp(item, string))
+			return index;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(match_string);
+
+/**
+ * __sysfs_match_string - matches given string in an array
+ * @array: array of strings
+ * @n: number of strings in the array or -1 for NULL terminated arrays
+ * @str: string to match with
+ *
+ * Returns index of @str in the @array or -EINVAL, just like match_string().
+ * Uses sysfs_streq instead of strcmp for matching.
+ *
+ * This routine will look for a string in an array of strings up to the
+ * n-th element in the array or until the first NULL element.
+ *
+ * Historically the value of -1 for @n, was used to search in arrays that
+ * are NULL terminated. However, the function does not make a distinction
+ * when finishing the search: either @n elements have been compared OR
+ * the first NULL element was found.
+ */
+int __sysfs_match_string(const char * const *array, size_t n, const char *str)
+{
+	const char *item;
+	int index;
+
+	for (index = 0; index < n; index++) {
+		item = array[index];
+		if (!item)
+			break;
+		if (sysfs_streq(item, str))
+			return index;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(__sysfs_match_string);
+
+/**
+ * strreplace - Replace all occurrences of character in string.
+ * @s: The string to operate on.
+ * @old: The character being replaced.
+ * @new: The character @old is replaced with.
+ *
+ * Returns pointer to the nul byte at the end of @s.
+ */
+char *strreplace(char *s, char old, char new)
+{
+	for (; *s; ++s)
+		if (*s == old)
+			*s = new;
+	return s;
+}
+EXPORT_SYMBOL(strreplace);
+
+void fortify_panic(const char *name)
+{
+	pr_emerg("detected buffer overflow in %s\n", name);
+	BUG();
+}
+EXPORT_SYMBOL(fortify_panic);
-- 
2.30.2

