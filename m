Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017456C71F0
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjCWUzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWUzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:55:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0207AB3;
        Thu, 23 Mar 2023 13:55:32 -0700 (PDT)
Message-ID: <20230323102800.101763813@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679604930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=hkHQ0iTngxG13UkvP/TjosHXNw7lXOMqMuZo5ApdX6M=;
        b=C1841qRox1pkq0T60no0X5no6imEgAczoEQ3thBsG2fa4vhRnnLloMptti4Gv/aB2755L8
        Zw09iCxcHIREgxODEYOOtVfqVUiV2TIWbMp0PY4L+xkQQ7hk5spPviSoeOjimY1L6gio4v
        FO6hGYl3tJLH8aHJIOdUbx0MZ1ldaJFwbAJJsisIgtW/7FC+jiLmTRZAFFznTGKzIAmTw4
        ctaJCB9WKVHCFjRKPT+cWpLt6uCTXEidQMiudkTewLGSHBEwFETyHS1LoyfLvo7rQZQ31n
        KzHBINBr15q03fytwPt3ZtjiHsL05owhjTvFnmVYCelzgcHV7Gl6S32U0E2dXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679604930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=hkHQ0iTngxG13UkvP/TjosHXNw7lXOMqMuZo5ApdX6M=;
        b=nKgQv5A592T+NK56P/si/yFJeSfs56lmzHlK8IYKMSgH1RutBOScfPoPlp25xyzeHr/B29
        xeD7iLmaTvTQKlBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [patch V3 2/4] atomics: Provide atomic_add_negative() variants
References: <20230323102649.764958589@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 23 Mar 2023 21:55:30 +0100 (CET)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

atomic_add_negative() does not provide the relaxed/acquire/release
variants.

Provide them in preparation for a new scalable reference count algorithm.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
V3: Fix typos (Mark). Make kernel doc correct vs. ordering variants
V2: New patch
---
 include/linux/atomic/atomic-arch-fallback.h |  208 ++++++++++++++++++++++++++--
 include/linux/atomic/atomic-instrumented.h  |   68 +++++++++
 include/linux/atomic/atomic-long.h          |   38 ++++-
 scripts/atomic/atomics.tbl                  |    2 
 scripts/atomic/fallbacks/add_negative       |   11 -
 5 files changed, 309 insertions(+), 18 deletions(-)

--- a/include/linux/atomic/atomic-arch-fallback.h
+++ b/include/linux/atomic/atomic-arch-fallback.h
@@ -1208,15 +1208,21 @@ arch_atomic_inc_and_test(atomic_t *v)
 #define arch_atomic_inc_and_test arch_atomic_inc_and_test
 #endif
 
+#ifndef arch_atomic_add_negative_relaxed
+#ifdef arch_atomic_add_negative
+#define arch_atomic_add_negative_acquire arch_atomic_add_negative
+#define arch_atomic_add_negative_release arch_atomic_add_negative
+#define arch_atomic_add_negative_relaxed arch_atomic_add_negative
+#endif /* arch_atomic_add_negative */
+
 #ifndef arch_atomic_add_negative
 /**
- * arch_atomic_add_negative - add and test if negative
+ * arch_atomic_add_negative - Add and test if negative
  * @i: integer value to add
  * @v: pointer of type atomic_t
  *
- * Atomically adds @i to @v and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
+ * Atomically adds @i to @v and returns true if the result is negative,
+ * or false when the result is greater than or equal to zero.
  */
 static __always_inline bool
 arch_atomic_add_negative(int i, atomic_t *v)
@@ -1226,6 +1232,95 @@ arch_atomic_add_negative(int i, atomic_t
 #define arch_atomic_add_negative arch_atomic_add_negative
 #endif
 
+#ifndef arch_atomic_add_negative_acquire
+/**
+ * arch_atomic_add_negative_acquire - Add and test if negative
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns true if the result is negative,
+ * or false when the result is greater than or equal to zero.
+ */
+static __always_inline bool
+arch_atomic_add_negative_acquire(int i, atomic_t *v)
+{
+	return arch_atomic_add_return_acquire(i, v) < 0;
+}
+#define arch_atomic_add_negative_acquire arch_atomic_add_negative_acquire
+#endif
+
+#ifndef arch_atomic_add_negative_release
+/**
+ * arch_atomic_add_negative_release - Add and test if negative
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns true if the result is negative,
+ * or false when the result is greater than or equal to zero.
+ */
+static __always_inline bool
+arch_atomic_add_negative_release(int i, atomic_t *v)
+{
+	return arch_atomic_add_return_release(i, v) < 0;
+}
+#define arch_atomic_add_negative_release arch_atomic_add_negative_release
+#endif
+
+#ifndef arch_atomic_add_negative_relaxed
+/**
+ * arch_atomic_add_negative_relaxed - Add and test if negative
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns true if the result is negative,
+ * or false when the result is greater than or equal to zero.
+ */
+static __always_inline bool
+arch_atomic_add_negative_relaxed(int i, atomic_t *v)
+{
+	return arch_atomic_add_return_relaxed(i, v) < 0;
+}
+#define arch_atomic_add_negative_relaxed arch_atomic_add_negative_relaxed
+#endif
+
+#else /* arch_atomic_add_negative_relaxed */
+
+#ifndef arch_atomic_add_negative_acquire
+static __always_inline bool
+arch_atomic_add_negative_acquire(int i, atomic_t *v)
+{
+	bool ret = arch_atomic_add_negative_relaxed(i, v);
+	__atomic_acquire_fence();
+	return ret;
+}
+#define arch_atomic_add_negative_acquire arch_atomic_add_negative_acquire
+#endif
+
+#ifndef arch_atomic_add_negative_release
+static __always_inline bool
+arch_atomic_add_negative_release(int i, atomic_t *v)
+{
+	__atomic_release_fence();
+	return arch_atomic_add_negative_relaxed(i, v);
+}
+#define arch_atomic_add_negative_release arch_atomic_add_negative_release
+#endif
+
+#ifndef arch_atomic_add_negative
+static __always_inline bool
+arch_atomic_add_negative(int i, atomic_t *v)
+{
+	bool ret;
+	__atomic_pre_full_fence();
+	ret = arch_atomic_add_negative_relaxed(i, v);
+	__atomic_post_full_fence();
+	return ret;
+}
+#define arch_atomic_add_negative arch_atomic_add_negative
+#endif
+
+#endif /* arch_atomic_add_negative_relaxed */
+
 #ifndef arch_atomic_fetch_add_unless
 /**
  * arch_atomic_fetch_add_unless - add unless the number is already a given value
@@ -2329,15 +2424,21 @@ arch_atomic64_inc_and_test(atomic64_t *v
 #define arch_atomic64_inc_and_test arch_atomic64_inc_and_test
 #endif
 
+#ifndef arch_atomic64_add_negative_relaxed
+#ifdef arch_atomic64_add_negative
+#define arch_atomic64_add_negative_acquire arch_atomic64_add_negative
+#define arch_atomic64_add_negative_release arch_atomic64_add_negative
+#define arch_atomic64_add_negative_relaxed arch_atomic64_add_negative
+#endif /* arch_atomic64_add_negative */
+
 #ifndef arch_atomic64_add_negative
 /**
- * arch_atomic64_add_negative - add and test if negative
+ * arch_atomic64_add_negative - Add and test if negative
  * @i: integer value to add
  * @v: pointer of type atomic64_t
  *
- * Atomically adds @i to @v and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
+ * Atomically adds @i to @v and returns true if the result is negative,
+ * or false when the result is greater than or equal to zero.
  */
 static __always_inline bool
 arch_atomic64_add_negative(s64 i, atomic64_t *v)
@@ -2347,6 +2448,95 @@ arch_atomic64_add_negative(s64 i, atomic
 #define arch_atomic64_add_negative arch_atomic64_add_negative
 #endif
 
+#ifndef arch_atomic64_add_negative_acquire
+/**
+ * arch_atomic64_add_negative_acquire - Add and test if negative
+ * @i: integer value to add
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically adds @i to @v and returns true if the result is negative,
+ * or false when the result is greater than or equal to zero.
+ */
+static __always_inline bool
+arch_atomic64_add_negative_acquire(s64 i, atomic64_t *v)
+{
+	return arch_atomic64_add_return_acquire(i, v) < 0;
+}
+#define arch_atomic64_add_negative_acquire arch_atomic64_add_negative_acquire
+#endif
+
+#ifndef arch_atomic64_add_negative_release
+/**
+ * arch_atomic64_add_negative_release - Add and test if negative
+ * @i: integer value to add
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically adds @i to @v and returns true if the result is negative,
+ * or false when the result is greater than or equal to zero.
+ */
+static __always_inline bool
+arch_atomic64_add_negative_release(s64 i, atomic64_t *v)
+{
+	return arch_atomic64_add_return_release(i, v) < 0;
+}
+#define arch_atomic64_add_negative_release arch_atomic64_add_negative_release
+#endif
+
+#ifndef arch_atomic64_add_negative_relaxed
+/**
+ * arch_atomic64_add_negative_relaxed - Add and test if negative
+ * @i: integer value to add
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically adds @i to @v and returns true if the result is negative,
+ * or false when the result is greater than or equal to zero.
+ */
+static __always_inline bool
+arch_atomic64_add_negative_relaxed(s64 i, atomic64_t *v)
+{
+	return arch_atomic64_add_return_relaxed(i, v) < 0;
+}
+#define arch_atomic64_add_negative_relaxed arch_atomic64_add_negative_relaxed
+#endif
+
+#else /* arch_atomic64_add_negative_relaxed */
+
+#ifndef arch_atomic64_add_negative_acquire
+static __always_inline bool
+arch_atomic64_add_negative_acquire(s64 i, atomic64_t *v)
+{
+	bool ret = arch_atomic64_add_negative_relaxed(i, v);
+	__atomic_acquire_fence();
+	return ret;
+}
+#define arch_atomic64_add_negative_acquire arch_atomic64_add_negative_acquire
+#endif
+
+#ifndef arch_atomic64_add_negative_release
+static __always_inline bool
+arch_atomic64_add_negative_release(s64 i, atomic64_t *v)
+{
+	__atomic_release_fence();
+	return arch_atomic64_add_negative_relaxed(i, v);
+}
+#define arch_atomic64_add_negative_release arch_atomic64_add_negative_release
+#endif
+
+#ifndef arch_atomic64_add_negative
+static __always_inline bool
+arch_atomic64_add_negative(s64 i, atomic64_t *v)
+{
+	bool ret;
+	__atomic_pre_full_fence();
+	ret = arch_atomic64_add_negative_relaxed(i, v);
+	__atomic_post_full_fence();
+	return ret;
+}
+#define arch_atomic64_add_negative arch_atomic64_add_negative
+#endif
+
+#endif /* arch_atomic64_add_negative_relaxed */
+
 #ifndef arch_atomic64_fetch_add_unless
 /**
  * arch_atomic64_fetch_add_unless - add unless the number is already a given value
@@ -2456,4 +2646,4 @@ arch_atomic64_dec_if_positive(atomic64_t
 #endif
 
 #endif /* _LINUX_ATOMIC_FALLBACK_H */
-// b5e87bdd5ede61470c29f7a7e4de781af3770f09
+// 00071fffa021cec66f6290d706d69c91df87bade
--- a/include/linux/atomic/atomic-instrumented.h
+++ b/include/linux/atomic/atomic-instrumented.h
@@ -592,6 +592,28 @@ atomic_add_negative(int i, atomic_t *v)
 	return arch_atomic_add_negative(i, v);
 }
 
+static __always_inline bool
+atomic_add_negative_acquire(int i, atomic_t *v)
+{
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic_add_negative_acquire(i, v);
+}
+
+static __always_inline bool
+atomic_add_negative_release(int i, atomic_t *v)
+{
+	kcsan_release();
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic_add_negative_release(i, v);
+}
+
+static __always_inline bool
+atomic_add_negative_relaxed(int i, atomic_t *v)
+{
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic_add_negative_relaxed(i, v);
+}
+
 static __always_inline int
 atomic_fetch_add_unless(atomic_t *v, int a, int u)
 {
@@ -1211,6 +1233,28 @@ atomic64_add_negative(s64 i, atomic64_t
 	return arch_atomic64_add_negative(i, v);
 }
 
+static __always_inline bool
+atomic64_add_negative_acquire(s64 i, atomic64_t *v)
+{
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic64_add_negative_acquire(i, v);
+}
+
+static __always_inline bool
+atomic64_add_negative_release(s64 i, atomic64_t *v)
+{
+	kcsan_release();
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic64_add_negative_release(i, v);
+}
+
+static __always_inline bool
+atomic64_add_negative_relaxed(s64 i, atomic64_t *v)
+{
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic64_add_negative_relaxed(i, v);
+}
+
 static __always_inline s64
 atomic64_fetch_add_unless(atomic64_t *v, s64 a, s64 u)
 {
@@ -1830,6 +1874,28 @@ atomic_long_add_negative(long i, atomic_
 	return arch_atomic_long_add_negative(i, v);
 }
 
+static __always_inline bool
+atomic_long_add_negative_acquire(long i, atomic_long_t *v)
+{
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic_long_add_negative_acquire(i, v);
+}
+
+static __always_inline bool
+atomic_long_add_negative_release(long i, atomic_long_t *v)
+{
+	kcsan_release();
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic_long_add_negative_release(i, v);
+}
+
+static __always_inline bool
+atomic_long_add_negative_relaxed(long i, atomic_long_t *v)
+{
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic_long_add_negative_relaxed(i, v);
+}
+
 static __always_inline long
 atomic_long_fetch_add_unless(atomic_long_t *v, long a, long u)
 {
@@ -2083,4 +2149,4 @@ atomic_long_dec_if_positive(atomic_long_
 })
 
 #endif /* _LINUX_ATOMIC_INSTRUMENTED_H */
-// 764f741eb77a7ad565dc8d99ce2837d5542e8aee
+// 1b485de9cbaa4900de59e14ee2084357eaeb1c3a
--- a/include/linux/atomic/atomic-long.h
+++ b/include/linux/atomic/atomic-long.h
@@ -479,6 +479,24 @@ arch_atomic_long_add_negative(long i, at
 	return arch_atomic64_add_negative(i, v);
 }
 
+static __always_inline bool
+arch_atomic_long_add_negative_acquire(long i, atomic_long_t *v)
+{
+	return arch_atomic64_add_negative_acquire(i, v);
+}
+
+static __always_inline bool
+arch_atomic_long_add_negative_release(long i, atomic_long_t *v)
+{
+	return arch_atomic64_add_negative_release(i, v);
+}
+
+static __always_inline bool
+arch_atomic_long_add_negative_relaxed(long i, atomic_long_t *v)
+{
+	return arch_atomic64_add_negative_relaxed(i, v);
+}
+
 static __always_inline long
 arch_atomic_long_fetch_add_unless(atomic_long_t *v, long a, long u)
 {
@@ -973,6 +991,24 @@ arch_atomic_long_add_negative(long i, at
 	return arch_atomic_add_negative(i, v);
 }
 
+static __always_inline bool
+arch_atomic_long_add_negative_acquire(long i, atomic_long_t *v)
+{
+	return arch_atomic_add_negative_acquire(i, v);
+}
+
+static __always_inline bool
+arch_atomic_long_add_negative_release(long i, atomic_long_t *v)
+{
+	return arch_atomic_add_negative_release(i, v);
+}
+
+static __always_inline bool
+arch_atomic_long_add_negative_relaxed(long i, atomic_long_t *v)
+{
+	return arch_atomic_add_negative_relaxed(i, v);
+}
+
 static __always_inline long
 arch_atomic_long_fetch_add_unless(atomic_long_t *v, long a, long u)
 {
@@ -1011,4 +1047,4 @@ arch_atomic_long_dec_if_positive(atomic_
 
 #endif /* CONFIG_64BIT */
 #endif /* _LINUX_ATOMIC_LONG_H */
-// e8f0e08ff072b74d180eabe2ad001282b38c2c88
+// a194c07d7d2f4b0e178d3c118c919775d5d65f50
--- a/scripts/atomic/atomics.tbl
+++ b/scripts/atomic/atomics.tbl
@@ -33,7 +33,7 @@ try_cmpxchg		B	v	p:old	i:new
 sub_and_test		b	i	v
 dec_and_test		b	v
 inc_and_test		b	v
-add_negative		b	i	v
+add_negative		B	i	v
 add_unless		fb	v	i:a	i:u
 inc_not_zero		b	v
 inc_unless_negative	b	v
--- a/scripts/atomic/fallbacks/add_negative
+++ b/scripts/atomic/fallbacks/add_negative
@@ -1,16 +1,15 @@
 cat <<EOF
 /**
- * arch_${atomic}_add_negative - add and test if negative
+ * arch_${atomic}_add_negative${order} - Add and test if negative
  * @i: integer value to add
  * @v: pointer of type ${atomic}_t
  *
- * Atomically adds @i to @v and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
+ * Atomically adds @i to @v and returns true if the result is negative,
+ * or false when the result is greater than or equal to zero.
  */
 static __always_inline bool
-arch_${atomic}_add_negative(${int} i, ${atomic}_t *v)
+arch_${atomic}_add_negative${order}(${int} i, ${atomic}_t *v)
 {
-	return arch_${atomic}_add_return(i, v) < 0;
+	return arch_${atomic}_add_return${order}(i, v) < 0;
 }
 EOF

