Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE7A3D8160
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhG0VRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbhG0VRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:17:09 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D135C061383
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:17:02 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d1so79483pll.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ibPaLxAc/NFYXEd84iy35IUTQUE28nEM5YCULtJR8dg=;
        b=aQxokW3YfovH2R9lQq5bGanIcUexzmrJMsApRQLe9yBPXSZ31vn6QvItbx2uDdk+W0
         9/qdNKNNnx7d4wQnAym1gA0YsmDuN0bMozc1ajMV5YkLFSrI42yVdagAUizXm5KLaXyh
         Vnl5hmCPAsODNLeyfuC17ZJRaC0Si7xq2rRBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ibPaLxAc/NFYXEd84iy35IUTQUE28nEM5YCULtJR8dg=;
        b=T5KM4+1EBoPUc4WBDqJbggVw3NFqwVJRJpx9jqtD4JJdcK0NDkH98BY6tnesahEuRs
         j90zAa3sBotvLAqWDg+H9IlC2cjHz1tDu3/Y5DPKBlqqTJzRqGjYROqhAeqtFI+MPOAU
         Tof2IXUecBxGBCnNdz4MvhDA6A1utkvYvgFLtaJgH8muzV3gUlXprvIvcAOShTB8I0Z9
         KvfukDF2419ArSF1HQNYs6j1DaMPyWzuWmKaOO+bf72gUlqJGXzyM55jNKbk8gt4LzDo
         2zgBvHuDxnDExSFKx4riaV4jWJitUPCfZptIOhgOfW9TNNNCd9Wq64HGo7WXB5VtkAP6
         IaUA==
X-Gm-Message-State: AOAM532NbNMHmJ0PvB/+tDDC3ih5Sk6/kTLNMd+loYczW8LIJTkIJ3Jm
        58O6+M2K967gfH0K6fvcWjhMqg==
X-Google-Smtp-Source: ABdhPJwsJnNW/diQ1EXmQ7EsscqU4npeiDtC0U1W4G3QLqp4JIraxDZHitrcQfDjhXWADC8CuegLAA==
X-Received: by 2002:a05:6a00:1693:b029:333:da3a:8c86 with SMTP id k19-20020a056a001693b0290333da3a8c86mr25562440pfc.41.1627420621589;
        Tue, 27 Jul 2021 14:17:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w145sm4786105pfc.39.2021.07.27.14.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:16:58 -0700 (PDT)
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
Subject: [PATCH 34/64] fortify: Detect struct member overflows in memcpy() at compile-time
Date:   Tue, 27 Jul 2021 13:58:25 -0700
Message-Id: <20210727205855.411487-35-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=21586; h=from:subject; bh=0rtSTY6ewefwYEiVstondxrsFx8RNrfWuejX/TiZifs=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOHsB2yySTqo2hnRFVcLoddc1yuuKCyaNSzDThl 6ZQaBmmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhwAKCRCJcvTf3G3AJpAED/ kBPbjorMQIfZ9DBpaM6ewcsxpM4D6eh10/B5u9jI3v3Synmf4/nlI2t3Rmrh9vJ4ZtfEbMLSliUCN/ Dy4ikOdJ13Jiv0xVTqrzdID798atk973HrZwlisKwjXKD9zjHoUHWIUJm8YYdVZau63O1/rpcpr5X1 i5+wL/wBLyz/Kr9UuxG2O4ymCPHIzbsfp1pWORzBVHnKwpYZHQ8GruAUo2TmN0XwDnlK+woOpnzLEd th3/1+njZLlDAKVOdakkvwLXDg2n0Yxht4DoGjLbMBTxeWFQstTNaEzVgiEY6SoewmjwAlmCyCfWvI t1xtRdJKR1NvJzHdkk1wiFJwD/m5iqWoRLhfnqrk4Hsz0ibnm9Euo7HifwKDSHoL5LBX801uGSuLvH cxZ5noCZfiZpWXczYwEfuDIMneWd444JQwF12TWtUcIkJZK1irLhcjt8f+WqHTf5DYIlysRcP0zvXS ek8wEPQwxWin5O3wQK39FRQXebfQnui1Kv8NGhUXS5kx58S355pkM+kzbm6V+zeaIqSbbc03/QBMFd KMQYwsQwv8SpKX387B8hpEATXRo5TW93CV40o9ujKiU4G0wNSOXUd0ArtyR13IEbJ/TYuhT++qrcBR bCxwh5NUiEPZ6MGsnHW+lEXF806euNtgsscb1q9aKUhevKeiKMZMsdUQkdvA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memcpy() is dead; long live memcpy()

tl;dr: In order to eliminate a large class of common buffer overflow
flaws that continue to persist in the kernel, have memcpy() (under
CONFIG_FORTIFY_SOURCE) perform bounds checking of the destination struct
member when they have a known size. This would have caught all of the
memcpy()-related buffer write overflow flaws identified in at least the
last three years.

Background and analysis:

While stack-based buffer overflow flaws are largely mitigated by stack
canaries (and similar) features, heap-based buffer overflow flaws continue
to regularly appear in the kernel. Many classes of heap buffer overflows
are mitigated by FORTIFY_SOURCE when using the strcpy() family of
functions, but a significant number remain exposed through the memcpy()
family of functions.

At its core, FORTIFY_SOURCE uses the compiler's __builtin_object_size()
internal[0] to determine the available size at a target address based on
the compile-time known structure layout details. It operates in two
modes: outer bounds (0) and inner bounds (1). In mode 0, the size of the
enclosing structure is used. In mode 1, the size of the specific field
is used. For example:

	struct object {
		u16 scalar1;	/* 2 bytes */
		char array[6];	/* 6 bytes */
		u64 scalar2;	/* 8 bytes */
		u32 scalar3;	/* 4 bytes */
	} instance;

__builtin_object_size(instance.array, 0) == 18, since the remaining size
of the enclosing structure starting from "array" is 18 bytes (6 + 8 + 4).

__builtin_object_size(instance.array, 1) == 6, since the remaining size
of the specific field "array" is 6 bytes.

The initial implementation of FORTIFY_SOURCE used mode 0 because there
were many cases of both strcpy() and memcpy() functions being used to
write (or read) across multiple fields in a structure. For example,
this would catch this, which is writing 2 bytes beyond the end of
"instance":

	memcpy(&instance.array, data, 20);

While this didn't protect against overwriting adjacent fields in a given
structure, it would at least stop overflows from reaching beyond the
end of the structure into neighboring memory, and provided a meaningful
mitigation of a subset of buffer overflow flaws. However, many desirable
targets remain within the enclosing structure (for example function
pointers).

As it happened, there were very few cases of strcpy() family functions
intentionally writing beyond the end of a string buffer. Once all known
cases were removed from the kernel, the strcpy() family was tightened[1]
to use mode 1, providing greater mitigation coverage.

What remains is switching memcpy() to mode 1 as well, but making the
switch is much more difficult because of how frustrating it can be to
find existing "normal" uses of memcpy() that expect to write (or read)
across multiple fields. The root cause of the problem is that the C
language lacks a common pattern to indicate the intent of an author's
use of memcpy(), and is further complicated by the available compile-time
and run-time mitigation behaviors.

The FORTIFY_SOURCE mitigation comes in two halves: the compile-time half,
when both the buffer size _and_ the length of the copy is known, and the
run-time half, when only the buffer size is known. If neither size is
known, there is no bounds checking possible. At compile-time when the
compiler sees that a length will always exceed a known buffer size,
a warning can be deterministically emitted. For the run-time half,
the length is tested against the known size of the buffer, and the
overflowing operation is detected. (The performance overhead for these
tests is virtually zero.)

It is relatively easy to find compile-time false-positives since a warning
is always generated. Fixing the false positives, however, can be very
time-consuming as there are hundreds of instances. While it's possible
some over-read conditions could lead to kernel memory exposures, the bulk
of the risk comes from the run-time flaws where the length of a write
may end up being attacker-controlled and lead to an overflow.

Many of the compile-time false-positives take a form similar to this:

	memcpy(&instance.scalar2, data, sizeof(instance.scalar2) +
					sizeof(instance.scalar3));

and the run-time ones are similar, but lack a constant expression for the
size of the copy:

	memcpy(instance.array, data, length);

The former is meant to cover multiple fields (though its style has been
frowned upon more recently), but has been technically legal. Both lack
any expressivity in the C language about the author's _intent_ in a way
that a compiler can check when the length isn't known at compile time.
A comment doesn't work well because what's needed is something a compiler
can directly reason about. Is a given memcpy() call expected to overflow
into neighbors? Is it not? By using the new struct_group() macro, this
intent can be much more easily encoded.

It is not as easy to find the run-time false-positives since the code path
to exercise a seemingly out-of-bounds condition that is actually expected
may not be trivially reachable. Tightening the restrictions to block an
operation for a false positive will either potentially create a greater
flaw (if a copy is truncated by the mitigation), or destabilize the kernel
(e.g. with a BUG()), making things completely useless for the end user.

As a result, tightening the memcpy() restriction (when there is a
reasonable level of uncertainty of the number of false positives), needs
to first WARN() with no truncation. (Though any sufficiently paranoid
end-user can always opt to set the panic_on_warn=1 sysctl.) Once enough
development time has passed, the mitigation can be further intensified.

Given the potential frustrations of weeding out all the false positives
when tightening the run-time checks, it is reasonable to wonder if these
changes would actually add meaningful protection. Looking at just the
last three years, there are 23 identified flaws with a CVE that mention
"buffer overflow", and 11 are memcpy()-related buffer overflows.

(For the remaining 12: 7 are array index overflows that would be
mitigated by systems built with CONFIG_UBSAN_BOUNDS=y: CVE-2019-0145,
CVE-2019-14835, CVE-2019-14896, CVE-2019-14897, CVE-2019-14901,
CVE-2019-17666, CVE-2021-28952. 2 are miscalculated allocation
sizes which could be mitigated with memory tagging: CVE-2019-16746,
CVE-2019-2181. 1 is an iovec buffer bug maybe mitigated by memory tagging:
CVE-2020-10742. 1 is a type confusion bug mitigated by stack canaries:
CVE-2020-10942. 1 is a string handling logic bug with no mitigation I'm
aware of: CVE-2021-28972.)

At my last count on an x86_64 allmodconfig build, there are 25,018 calls
to memcpy(). With callers instrumented to report all places where the
buffer size is known but the length remains unknown (i.e. a run-time
bounds check is added), we can count how many new run-time bounds checks
are added when the destination and source arguments of memcpy() are
changed to use "mode 1" bounds checking: 1540. In addition, there were
146 new compile-time warnings to evaluate and fix.

With this it's also possible to compare the places where the known 11
memcpy() flaw overflows happened against the resulting list of potential
new bounds checks, as a measure of potential efficacy of the tightened
mitigation. Much to my surprise, horror, and delight, all 11 flaws would
have been detected by the newly added run-time bounds checks, making this
a distinctly clear mitigation improvement: 100% coverage for memcpy()
flaws, with a possible 2 orders of magnitude gain in coverage over
existing but undiscovered run-time dynamic length flaws, against only 6%
of all callers maybe gaining a false positive run-time check, with fewer
than 150 new compile-time instances needing evaluation.

Specifically these would have been mitigated:
CVE-2020-24490 https://git.kernel.org/linus/a2ec905d1e160a33b2e210e45ad30445ef26ce0e
CVE-2020-12654 https://git.kernel.org/linus/3a9b153c5591548612c3955c9600a98150c81875
CVE-2020-12653 https://git.kernel.org/linus/b70261a288ea4d2f4ac7cd04be08a9f0f2de4f4d
CVE-2019-14895 https://git.kernel.org/linus/3d94a4a8373bf5f45cf5f939e88b8354dbf2311b
CVE-2019-14816 https://git.kernel.org/linus/7caac62ed598a196d6ddf8d9c121e12e082cac3a
CVE-2019-14815 https://git.kernel.org/linus/7caac62ed598a196d6ddf8d9c121e12e082cac3a
CVE-2019-14814 https://git.kernel.org/linus/7caac62ed598a196d6ddf8d9c121e12e082cac3a
CVE-2019-10126 https://git.kernel.org/linus/69ae4f6aac1578575126319d3f55550e7e440449
CVE-2019-9500  https://git.kernel.org/linus/1b5e2423164b3670e8bc9174e4762d297990deff
no-CVE-yet     https://git.kernel.org/linus/130f634da1af649205f4a3dd86cbe5c126b57914
no-CVE-yet     https://git.kernel.org/linus/d10a87a3535cce2b890897914f5d0d83df669c63

To accelerate the review of potential run-time false positives, it's
also worth noting that it is possible to partially automate checking
by examining memcpy() buffer argument fields to see if they have
a neighboring. It is reasonable to expect that the vast majority of
run-time false positives would look like the already evaluated and fixed
compile-time false positives, where the most common pattern is neighboring
arrays. (And, FWIW, several of the compile-time fixes were actual bugs.)

Implementation:

Tighten the memcpy() buffer size checking to use the actual ("mode 1")
target buffer size as the bounds check instead of their enclosing
structure's ("mode 0") size. Use a common inline for memcpy() (and
memmove() in a following patch), since all the tests are the same. All new
cross-field memcpy() uses must use the struct_group() macro or similar
to target a specific range of fields, so that FORTIFY_SOURCE can reason
about the size and safety of the copy.

For run-time, the "mode 0" size checking and mitigation is left unchanged,
with "mode 1" added only to writes, and only performing a WARN() for
now. This way any missed run-time false positives can be flushed out over
the coming several development cycles, but system builders who have tested
their workloads to be WARN()-free can enable the panic_on_warn=1 sysctl
to immediately gain a mitigation against this class of buffer overflows.

For now, cross-member "mode 1" read detection at compile-time will be
limited to W=1 builds, since it is, unfortunately, very common. As the
priority is solving write overflows, read overflows can be the next
phase. Similarly, run-time cross-member "mode 1" read detection will be
added at a later time, once write false-positives have been handled.

Related classes of flaws that remain unmitigated:

- memcpy() with raw pointers (e.g. void *, char *, etc) have no good
  mitigation beyond memory tagging (and even that would only protect
  against inter-object overflow, not intra-object neighboring field
  overflows). Some kind of "fat pointer" solution is likely needed to
  gain proper size-of-buffer awareness.

- type confusion where a higher level type's allocation size does
  not match the resulting cast type eventually passed to a deeper
  memcpy() call where the compiler cannot see the true type. In
  theory, greater static analysis could catch these.

[0] https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html
[1] https://git.kernel.org/linus/6a39e62abbafd1d58d1722f40c7d26ef379c6a2f

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/fortify-string.h                | 111 ++++++++++++++++--
 include/linux/string.h                        |   5 +-
 lib/Makefile                                  |   3 +-
 lib/string_helpers.c                          |   6 +
 .../read_overflow2_field-memcpy.c             |   5 +
 .../write_overflow_field-memcpy.c             |   5 +
 6 files changed, 120 insertions(+), 15 deletions(-)
 create mode 100644 lib/test_fortify/read_overflow2_field-memcpy.c
 create mode 100644 lib/test_fortify/write_overflow_field-memcpy.c

diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 7e67d02764db..5e79e626172b 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -2,13 +2,17 @@
 #ifndef _LINUX_FORTIFY_STRING_H_
 #define _LINUX_FORTIFY_STRING_H_
 
+#include <linux/bug.h>
+
 #define __FORTIFY_INLINE extern __always_inline __attribute__((gnu_inline))
 #define __RENAME(x) __asm__(#x)
 
 void fortify_panic(const char *name) __noreturn __cold;
 void __read_overflow(void) __compiletime_error("detected read beyond size of object (1st parameter)");
 void __read_overflow2(void) __compiletime_error("detected read beyond size of object (2nd parameter)");
+void __read_overflow2_field(void) __compiletime_warning("detected read beyond size of field (2nd parameter); maybe use struct_group()?");
 void __write_overflow(void) __compiletime_error("detected write beyond size of object (1st parameter)");
+void __write_overflow_field(void) __compiletime_warning("detected write beyond size of field (1st parameter); maybe use struct_group()?");
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 extern void *__underlying_memchr(const void *p, int c, __kernel_size_t size) __RENAME(memchr);
@@ -182,22 +186,105 @@ __FORTIFY_INLINE void *memset(void *p, int c, __kernel_size_t size)
 	return __underlying_memset(p, c, size);
 }
 
-__FORTIFY_INLINE void *memcpy(void *p, const void *q, __kernel_size_t size)
+/*
+ * To make sure the compiler can enforce protection against buffer overflows,
+ * memcpy(), memmove(), and memset() must not be used beyond individual
+ * struct members. If you need to copy across multiple members, please use
+ * struct_group() to create a named mirror of an anonymous struct union.
+ * (e.g. see struct sk_buff.)
+ *
+ * Mitigation coverage
+ *					Bounds checking at:
+ *					+-------+-------+-------+-------+
+ *					| Compile time  | Run time      |
+ * memcpy() argument sizes:		| write | read  | write | read  |
+ *					+-------+-------+-------+-------+
+ * memcpy(known,   known,   constant)	|   y   |   y   |  n/a  |  n/a  |
+ * memcpy(unknown, known,   constant)	|   n   |   y   |   V   |  n/a  |
+ * memcpy(known,   unknown, constant)	|   y   |   n   |  n/a  |   V   |
+ * memcpy(unknown, unknown, constant)	|   n   |   n   |   V   |   V   |
+ * memcpy(known,   known,   dynamic)	|   n   |   n   |   b   |   B   |
+ * memcpy(unknown, known,   dynamic)	|   n   |   n   |   V   |   B   |
+ * memcpy(known,   unknown, dynamic)	|   n   |   n   |   b   |   V   |
+ * memcpy(unknown, unknown, dynamic)	|   n   |   n   |   V   |   V   |
+ *					+-------+-------+-------+-------+
+ *
+ * y = deterministic compile-time bounds checking
+ * n = cannot do deterministic compile-time bounds checking
+ * n/a = no run-time bounds checking needed since compile-time deterministic
+ * b = perform run-time bounds checking
+ * B = can perform run-time bounds checking, but current unenforced
+ * V = vulnerable to run-time overflow
+ *
+ */
+__FORTIFY_INLINE void fortify_memcpy_chk(__kernel_size_t size,
+					 const size_t p_size,
+					 const size_t q_size,
+					 const size_t p_size_field,
+					 const size_t q_size_field,
+					 const char *func)
 {
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
-
 	if (__builtin_constant_p(size)) {
-		if (p_size < size)
+		/*
+		 * Length argument is a constant expression, so we
+		 * can perform compile-time bounds checking where
+		 * buffer sizes are known.
+		 */
+
+		/* Error when size is larger than enclosing struct. */
+		if (p_size > p_size_field && p_size < size)
 			__write_overflow();
-		if (q_size < size)
+		if (q_size > q_size_field && q_size < size)
 			__read_overflow2();
+
+		/* Warn when write size argument larger than dest field. */
+		if (p_size_field < size)
+			__write_overflow_field();
+		/*
+		 * Warn for source field over-read when building with W=1
+		 * or when an over-write happened, so both can be fixed at
+		 * the same time.
+		 */
+		if ((IS_ENABLED(KBUILD_EXTRA_WARN1) || p_size_field < size) &&
+		    q_size_field < size)
+			__read_overflow2_field();
 	}
-	if (p_size < size || q_size < size)
-		fortify_panic(__func__);
-	return __underlying_memcpy(p, q, size);
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
+	if ((p_size != (size_t)(-1) && p_size < size) ||
+	    (q_size != (size_t)(-1) && q_size < size))
+		fortify_panic(func);
 }
 
+#define __fortify_memcpy_chk(p, q, size, p_size, q_size,		\
+			     p_size_field, q_size_field, op) ({		\
+	size_t __fortify_size = (size_t)(size);				\
+	fortify_memcpy_chk(__fortify_size, p_size, q_size,		\
+			   p_size_field, q_size_field, #op);		\
+	__underlying_##op(p, q, __fortify_size);			\
+})
+
+/*
+ * __builtin_object_size() must be captured here to avoid evaluating argument
+ * side-effects further into the macro layers.
+ */
+#define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,			\
+		__builtin_object_size(p, 0), __builtin_object_size(q, 0), \
+		__builtin_object_size(p, 1), __builtin_object_size(q, 1), \
+		memcpy)
+
 __FORTIFY_INLINE void *memmove(void *p, const void *q, __kernel_size_t size)
 {
 	size_t p_size = __builtin_object_size(p, 0);
@@ -277,27 +364,27 @@ __FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
 	return __real_kmemdup(p, size, gfp);
 }
 
-/* defined after fortified strlen and memcpy to reuse them */
+/* Defined after fortified strlen to reuse it. */
 __FORTIFY_INLINE char *strcpy(char *p, const char *q)
 {
 	size_t p_size = __builtin_object_size(p, 1);
 	size_t q_size = __builtin_object_size(q, 1);
 	size_t size;
 
+	/* If neither buffer size is known, immediately give up. */
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __underlying_strcpy(p, q);
 	size = strlen(q) + 1;
 	/* test here to use the more stringent object size */
 	if (p_size < size)
 		fortify_panic(__func__);
-	memcpy(p, q, size);
+	__underlying_memcpy(p, q, size);
 	return p;
 }
 
 /* Don't use these outside the FORITFY_SOURCE implementation */
 #undef __underlying_memchr
 #undef __underlying_memcmp
-#undef __underlying_memcpy
 #undef __underlying_memmove
 #undef __underlying_memset
 #undef __underlying_strcat
diff --git a/include/linux/string.h b/include/linux/string.h
index 9473f81b9db2..cbe889e404e2 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -261,8 +261,9 @@ static inline const char *kbasename(const char *path)
  * @count: The number of bytes to copy
  * @pad: Character to use for padding if space is left in destination.
  */
-static inline void memcpy_and_pad(void *dest, size_t dest_len,
-				  const void *src, size_t count, int pad)
+static __always_inline void memcpy_and_pad(void *dest, size_t dest_len,
+					   const void *src, size_t count,
+					   int pad)
 {
 	if (dest_len > count) {
 		memcpy(dest, src, count);
diff --git a/lib/Makefile b/lib/Makefile
index 083a19336e20..74523fd394bd 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -370,7 +370,8 @@ TEST_FORTIFY_LOG = test_fortify.log
 quiet_cmd_test_fortify = TEST    $@
       cmd_test_fortify = $(CONFIG_SHELL) $(srctree)/scripts/test_fortify.sh \
 			$< $@ "$(NM)" $(CC) $(c_flags) \
-			$(call cc-disable-warning,fortify-source)
+			$(call cc-disable-warning,fortify-source) \
+			-DKBUILD_EXTRA_WARN1
 
 targets += $(TEST_FORTIFY_LOGS)
 clean-files += $(TEST_FORTIFY_LOGS)
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index faa9d8e4e2c5..4d205bf5993c 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -884,6 +884,12 @@ char *strreplace(char *s, char old, char new)
 EXPORT_SYMBOL(strreplace);
 
 #ifdef CONFIG_FORTIFY_SOURCE
+/* These are placeholders for fortify compile-time warnings. */
+void __read_overflow2_field(void) { }
+EXPORT_SYMBOL(__read_overflow2_field);
+void __write_overflow_field(void) { }
+EXPORT_SYMBOL(__write_overflow_field);
+
 void fortify_panic(const char *name)
 {
 	pr_emerg("detected buffer overflow in %s\n", name);
diff --git a/lib/test_fortify/read_overflow2_field-memcpy.c b/lib/test_fortify/read_overflow2_field-memcpy.c
new file mode 100644
index 000000000000..de9569266223
--- /dev/null
+++ b/lib/test_fortify/read_overflow2_field-memcpy.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memcpy(large, instance.buf, sizeof(instance.buf) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow_field-memcpy.c b/lib/test_fortify/write_overflow_field-memcpy.c
new file mode 100644
index 000000000000..28cc81058dd3
--- /dev/null
+++ b/lib/test_fortify/write_overflow_field-memcpy.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memcpy(instance.buf, large, sizeof(instance.buf) + 1)
+
+#include "test_fortify.h"
-- 
2.30.2

