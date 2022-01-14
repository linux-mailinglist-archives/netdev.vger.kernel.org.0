Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A122948EB8E
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238038AbiANOUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238008AbiANOUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:20:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09642C061574;
        Fri, 14 Jan 2022 06:20:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AC7661D0D;
        Fri, 14 Jan 2022 14:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416BBC36AE5;
        Fri, 14 Jan 2022 14:20:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ir2iB1Rl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642170043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2M0plqEKxWINnvXmEwZigA0qBNxyVTO7bInRkdCgSbI=;
        b=Ir2iB1RlDHtlSVT2J9bpjhsBW361nOkoDQYwV9aKUGllgEca/La0x3mqfh54zrZDk+Dsyh
        S1e5g8YjMDcMOdFUSMSAxMPjobcBRzSizR6J9kyrjHcIhSpJth0fZn3oY34PYyh6D/YzV3
        Xl+xywK0YDmwqcujcMKjq0PHniYwbUA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6101a9e0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 14:20:43 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH RFC v2 3/3] crypto: sha1_generic - import lib/sha1.c locally
Date:   Fri, 14 Jan 2022 15:20:15 +0100
Message-Id: <20220114142015.87974-4-Jason@zx2c4.com>
In-Reply-To: <20220114142015.87974-1-Jason@zx2c4.com>
References: <20220114142015.87974-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With no non-crypto API users of this function, we can move it into the
generic crypto/ code where it belongs.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/sha1_generic.c | 182 +++++++++++++++++++++++++++++++++++++
 include/crypto/sha1.h |  10 ---
 lib/Makefile          |   2 +-
 lib/sha1.c            | 204 ------------------------------------------
 4 files changed, 183 insertions(+), 215 deletions(-)
 delete mode 100644 lib/sha1.c

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 325b57fe28dc..1475a0fbbf4e 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -16,9 +16,191 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
+#include <linux/string.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
+
+#define SHA1_DIGEST_WORDS	(SHA1_DIGEST_SIZE / 4)
+#define SHA1_WORKSPACE_WORDS	16
+
+/*
+ * If you have 32 registers or more, the compiler can (and should)
+ * try to change the array[] accesses into registers. However, on
+ * machines with less than ~25 registers, that won't really work,
+ * and at least gcc will make an unholy mess of it.
+ *
+ * So to avoid that mess which just slows things down, we force
+ * the stores to memory to actually happen (we might be better off
+ * with a 'W(t)=(val);asm("":"+m" (W(t))' there instead, as
+ * suggested by Artur Skawina - that will also make gcc unable to
+ * try to do the silly "optimize away loads" part because it won't
+ * see what the value will be).
+ *
+ * Ben Herrenschmidt reports that on PPC, the C version comes close
+ * to the optimized asm with this (ie on PPC you don't want that
+ * 'volatile', since there are lots of registers).
+ *
+ * On ARM we get the best code generation by forcing a full memory barrier
+ * between each SHA_ROUND, otherwise gcc happily get wild with spilling and
+ * the stack frame size simply explode and performance goes down the drain.
+ */
+
+#ifdef CONFIG_X86
+  #define setW(x, val) (*(volatile __u32 *)&W(x) = (val))
+#elif defined(CONFIG_ARM)
+  #define setW(x, val) do { W(x) = (val); __asm__("":::"memory"); } while (0)
+#else
+  #define setW(x, val) (W(x) = (val))
+#endif
+
+/* This "rolls" over the 512-bit array */
+#define W(x) (array[(x)&15])
+
+/*
+ * Where do we get the source from? The first 16 iterations get it from
+ * the input data, the next mix it from the 512-bit array.
+ */
+#define SHA_SRC(t) get_unaligned_be32((__u32 *)data + t)
+#define SHA_MIX(t) rol32(W(t+13) ^ W(t+8) ^ W(t+2) ^ W(t), 1)
+
+#define SHA_ROUND(t, input, fn, constant, A, B, C, D, E) do { \
+	__u32 TEMP = input(t); setW(t, TEMP); \
+	E += TEMP + rol32(A,5) + (fn) + (constant); \
+	B = ror32(B, 2); } while (0)
+
+#define T_0_15(t, A, B, C, D, E)  SHA_ROUND(t, SHA_SRC, (((C^D)&B)^D) , 0x5a827999, A, B, C, D, E )
+#define T_16_19(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (((C^D)&B)^D) , 0x5a827999, A, B, C, D, E )
+#define T_20_39(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (B^C^D) , 0x6ed9eba1, A, B, C, D, E )
+#define T_40_59(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, ((B&C)+(D&(B^C))) , 0x8f1bbcdc, A, B, C, D, E )
+#define T_60_79(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (B^C^D) ,  0xca62c1d6, A, B, C, D, E )
+
+/**
+ * sha1_transform - single block SHA1 transform (deprecated)
+ *
+ * @digest: 160 bit digest to update
+ * @data:   512 bits of data to hash
+ * @array:  16 words of workspace (see note)
+ *
+ * This function executes SHA-1's internal compression function.  It updates the
+ * 160-bit internal state (@digest) with a single 512-bit data block (@data).
+ *
+ * Don't use this function.  SHA-1 is no longer considered secure.  And even if
+ * you do have to use SHA-1, this isn't the correct way to hash something with
+ * SHA-1 as this doesn't handle padding and finalization.
+ *
+ * Note: If the hash is security sensitive, the caller should be sure
+ * to clear the workspace. This is left to the caller to avoid
+ * unnecessary clears between chained hashing operations.
+ */
+static void sha1_transform(__u32 *digest, const char *data, __u32 *array)
+{
+	__u32 A, B, C, D, E;
+
+	A = digest[0];
+	B = digest[1];
+	C = digest[2];
+	D = digest[3];
+	E = digest[4];
+
+	/* Round 1 - iterations 0-16 take their input from 'data' */
+	T_0_15( 0, A, B, C, D, E);
+	T_0_15( 1, E, A, B, C, D);
+	T_0_15( 2, D, E, A, B, C);
+	T_0_15( 3, C, D, E, A, B);
+	T_0_15( 4, B, C, D, E, A);
+	T_0_15( 5, A, B, C, D, E);
+	T_0_15( 6, E, A, B, C, D);
+	T_0_15( 7, D, E, A, B, C);
+	T_0_15( 8, C, D, E, A, B);
+	T_0_15( 9, B, C, D, E, A);
+	T_0_15(10, A, B, C, D, E);
+	T_0_15(11, E, A, B, C, D);
+	T_0_15(12, D, E, A, B, C);
+	T_0_15(13, C, D, E, A, B);
+	T_0_15(14, B, C, D, E, A);
+	T_0_15(15, A, B, C, D, E);
+
+	/* Round 1 - tail. Input from 512-bit mixing array */
+	T_16_19(16, E, A, B, C, D);
+	T_16_19(17, D, E, A, B, C);
+	T_16_19(18, C, D, E, A, B);
+	T_16_19(19, B, C, D, E, A);
+
+	/* Round 2 */
+	T_20_39(20, A, B, C, D, E);
+	T_20_39(21, E, A, B, C, D);
+	T_20_39(22, D, E, A, B, C);
+	T_20_39(23, C, D, E, A, B);
+	T_20_39(24, B, C, D, E, A);
+	T_20_39(25, A, B, C, D, E);
+	T_20_39(26, E, A, B, C, D);
+	T_20_39(27, D, E, A, B, C);
+	T_20_39(28, C, D, E, A, B);
+	T_20_39(29, B, C, D, E, A);
+	T_20_39(30, A, B, C, D, E);
+	T_20_39(31, E, A, B, C, D);
+	T_20_39(32, D, E, A, B, C);
+	T_20_39(33, C, D, E, A, B);
+	T_20_39(34, B, C, D, E, A);
+	T_20_39(35, A, B, C, D, E);
+	T_20_39(36, E, A, B, C, D);
+	T_20_39(37, D, E, A, B, C);
+	T_20_39(38, C, D, E, A, B);
+	T_20_39(39, B, C, D, E, A);
+
+	/* Round 3 */
+	T_40_59(40, A, B, C, D, E);
+	T_40_59(41, E, A, B, C, D);
+	T_40_59(42, D, E, A, B, C);
+	T_40_59(43, C, D, E, A, B);
+	T_40_59(44, B, C, D, E, A);
+	T_40_59(45, A, B, C, D, E);
+	T_40_59(46, E, A, B, C, D);
+	T_40_59(47, D, E, A, B, C);
+	T_40_59(48, C, D, E, A, B);
+	T_40_59(49, B, C, D, E, A);
+	T_40_59(50, A, B, C, D, E);
+	T_40_59(51, E, A, B, C, D);
+	T_40_59(52, D, E, A, B, C);
+	T_40_59(53, C, D, E, A, B);
+	T_40_59(54, B, C, D, E, A);
+	T_40_59(55, A, B, C, D, E);
+	T_40_59(56, E, A, B, C, D);
+	T_40_59(57, D, E, A, B, C);
+	T_40_59(58, C, D, E, A, B);
+	T_40_59(59, B, C, D, E, A);
+
+	/* Round 4 */
+	T_60_79(60, A, B, C, D, E);
+	T_60_79(61, E, A, B, C, D);
+	T_60_79(62, D, E, A, B, C);
+	T_60_79(63, C, D, E, A, B);
+	T_60_79(64, B, C, D, E, A);
+	T_60_79(65, A, B, C, D, E);
+	T_60_79(66, E, A, B, C, D);
+	T_60_79(67, D, E, A, B, C);
+	T_60_79(68, C, D, E, A, B);
+	T_60_79(69, B, C, D, E, A);
+	T_60_79(70, A, B, C, D, E);
+	T_60_79(71, E, A, B, C, D);
+	T_60_79(72, D, E, A, B, C);
+	T_60_79(73, C, D, E, A, B);
+	T_60_79(74, B, C, D, E, A);
+	T_60_79(75, A, B, C, D, E);
+	T_60_79(76, E, A, B, C, D);
+	T_60_79(77, D, E, A, B, C);
+	T_60_79(78, C, D, E, A, B);
+	T_60_79(79, B, C, D, E, A);
+
+	digest[0] += A;
+	digest[1] += B;
+	digest[2] += C;
+	digest[3] += D;
+	digest[4] += E;
+}
 
 const u8 sha1_zero_message_hash[SHA1_DIGEST_SIZE] = {
 	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
diff --git a/include/crypto/sha1.h b/include/crypto/sha1.h
index 044ecea60ac8..118a3cad5eb3 100644
--- a/include/crypto/sha1.h
+++ b/include/crypto/sha1.h
@@ -33,14 +33,4 @@ extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 extern int crypto_sha1_finup(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, u8 *hash);
 
-/*
- * An implementation of SHA-1's compression function.  Don't use in new code!
- * You shouldn't be using SHA-1, and even if you *have* to use SHA-1, this isn't
- * the correct way to hash something with SHA-1 (use crypto_shash instead).
- */
-#define SHA1_DIGEST_WORDS	(SHA1_DIGEST_SIZE / 4)
-#define SHA1_WORKSPACE_WORDS	16
-void sha1_init(__u32 *buf);
-void sha1_transform(__u32 *digest, const char *data, __u32 *W);
-
 #endif /* _CRYPTO_SHA1_H */
diff --git a/lib/Makefile b/lib/Makefile
index b213a7bbf3fd..233a2fd2aba4 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -29,7 +29,7 @@ endif
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o timerqueue.o xarray.o \
-	 idr.o extable.o sha1.o irq_regs.o argv_split.o \
+	 idr.o extable.o irq_regs.o argv_split.o \
 	 flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
diff --git a/lib/sha1.c b/lib/sha1.c
deleted file mode 100644
index 9bd1935a1472..000000000000
--- a/lib/sha1.c
+++ /dev/null
@@ -1,204 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * SHA1 routine optimized to do word accesses rather than byte accesses,
- * and to avoid unnecessary copies into the context array.
- *
- * This was based on the git SHA1 implementation.
- */
-
-#include <linux/kernel.h>
-#include <linux/export.h>
-#include <linux/bitops.h>
-#include <crypto/sha1.h>
-#include <asm/unaligned.h>
-
-/*
- * If you have 32 registers or more, the compiler can (and should)
- * try to change the array[] accesses into registers. However, on
- * machines with less than ~25 registers, that won't really work,
- * and at least gcc will make an unholy mess of it.
- *
- * So to avoid that mess which just slows things down, we force
- * the stores to memory to actually happen (we might be better off
- * with a 'W(t)=(val);asm("":"+m" (W(t))' there instead, as
- * suggested by Artur Skawina - that will also make gcc unable to
- * try to do the silly "optimize away loads" part because it won't
- * see what the value will be).
- *
- * Ben Herrenschmidt reports that on PPC, the C version comes close
- * to the optimized asm with this (ie on PPC you don't want that
- * 'volatile', since there are lots of registers).
- *
- * On ARM we get the best code generation by forcing a full memory barrier
- * between each SHA_ROUND, otherwise gcc happily get wild with spilling and
- * the stack frame size simply explode and performance goes down the drain.
- */
-
-#ifdef CONFIG_X86
-  #define setW(x, val) (*(volatile __u32 *)&W(x) = (val))
-#elif defined(CONFIG_ARM)
-  #define setW(x, val) do { W(x) = (val); __asm__("":::"memory"); } while (0)
-#else
-  #define setW(x, val) (W(x) = (val))
-#endif
-
-/* This "rolls" over the 512-bit array */
-#define W(x) (array[(x)&15])
-
-/*
- * Where do we get the source from? The first 16 iterations get it from
- * the input data, the next mix it from the 512-bit array.
- */
-#define SHA_SRC(t) get_unaligned_be32((__u32 *)data + t)
-#define SHA_MIX(t) rol32(W(t+13) ^ W(t+8) ^ W(t+2) ^ W(t), 1)
-
-#define SHA_ROUND(t, input, fn, constant, A, B, C, D, E) do { \
-	__u32 TEMP = input(t); setW(t, TEMP); \
-	E += TEMP + rol32(A,5) + (fn) + (constant); \
-	B = ror32(B, 2); } while (0)
-
-#define T_0_15(t, A, B, C, D, E)  SHA_ROUND(t, SHA_SRC, (((C^D)&B)^D) , 0x5a827999, A, B, C, D, E )
-#define T_16_19(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (((C^D)&B)^D) , 0x5a827999, A, B, C, D, E )
-#define T_20_39(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (B^C^D) , 0x6ed9eba1, A, B, C, D, E )
-#define T_40_59(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, ((B&C)+(D&(B^C))) , 0x8f1bbcdc, A, B, C, D, E )
-#define T_60_79(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (B^C^D) ,  0xca62c1d6, A, B, C, D, E )
-
-/**
- * sha1_transform - single block SHA1 transform (deprecated)
- *
- * @digest: 160 bit digest to update
- * @data:   512 bits of data to hash
- * @array:  16 words of workspace (see note)
- *
- * This function executes SHA-1's internal compression function.  It updates the
- * 160-bit internal state (@digest) with a single 512-bit data block (@data).
- *
- * Don't use this function.  SHA-1 is no longer considered secure.  And even if
- * you do have to use SHA-1, this isn't the correct way to hash something with
- * SHA-1 as this doesn't handle padding and finalization.
- *
- * Note: If the hash is security sensitive, the caller should be sure
- * to clear the workspace. This is left to the caller to avoid
- * unnecessary clears between chained hashing operations.
- */
-void sha1_transform(__u32 *digest, const char *data, __u32 *array)
-{
-	__u32 A, B, C, D, E;
-
-	A = digest[0];
-	B = digest[1];
-	C = digest[2];
-	D = digest[3];
-	E = digest[4];
-
-	/* Round 1 - iterations 0-16 take their input from 'data' */
-	T_0_15( 0, A, B, C, D, E);
-	T_0_15( 1, E, A, B, C, D);
-	T_0_15( 2, D, E, A, B, C);
-	T_0_15( 3, C, D, E, A, B);
-	T_0_15( 4, B, C, D, E, A);
-	T_0_15( 5, A, B, C, D, E);
-	T_0_15( 6, E, A, B, C, D);
-	T_0_15( 7, D, E, A, B, C);
-	T_0_15( 8, C, D, E, A, B);
-	T_0_15( 9, B, C, D, E, A);
-	T_0_15(10, A, B, C, D, E);
-	T_0_15(11, E, A, B, C, D);
-	T_0_15(12, D, E, A, B, C);
-	T_0_15(13, C, D, E, A, B);
-	T_0_15(14, B, C, D, E, A);
-	T_0_15(15, A, B, C, D, E);
-
-	/* Round 1 - tail. Input from 512-bit mixing array */
-	T_16_19(16, E, A, B, C, D);
-	T_16_19(17, D, E, A, B, C);
-	T_16_19(18, C, D, E, A, B);
-	T_16_19(19, B, C, D, E, A);
-
-	/* Round 2 */
-	T_20_39(20, A, B, C, D, E);
-	T_20_39(21, E, A, B, C, D);
-	T_20_39(22, D, E, A, B, C);
-	T_20_39(23, C, D, E, A, B);
-	T_20_39(24, B, C, D, E, A);
-	T_20_39(25, A, B, C, D, E);
-	T_20_39(26, E, A, B, C, D);
-	T_20_39(27, D, E, A, B, C);
-	T_20_39(28, C, D, E, A, B);
-	T_20_39(29, B, C, D, E, A);
-	T_20_39(30, A, B, C, D, E);
-	T_20_39(31, E, A, B, C, D);
-	T_20_39(32, D, E, A, B, C);
-	T_20_39(33, C, D, E, A, B);
-	T_20_39(34, B, C, D, E, A);
-	T_20_39(35, A, B, C, D, E);
-	T_20_39(36, E, A, B, C, D);
-	T_20_39(37, D, E, A, B, C);
-	T_20_39(38, C, D, E, A, B);
-	T_20_39(39, B, C, D, E, A);
-
-	/* Round 3 */
-	T_40_59(40, A, B, C, D, E);
-	T_40_59(41, E, A, B, C, D);
-	T_40_59(42, D, E, A, B, C);
-	T_40_59(43, C, D, E, A, B);
-	T_40_59(44, B, C, D, E, A);
-	T_40_59(45, A, B, C, D, E);
-	T_40_59(46, E, A, B, C, D);
-	T_40_59(47, D, E, A, B, C);
-	T_40_59(48, C, D, E, A, B);
-	T_40_59(49, B, C, D, E, A);
-	T_40_59(50, A, B, C, D, E);
-	T_40_59(51, E, A, B, C, D);
-	T_40_59(52, D, E, A, B, C);
-	T_40_59(53, C, D, E, A, B);
-	T_40_59(54, B, C, D, E, A);
-	T_40_59(55, A, B, C, D, E);
-	T_40_59(56, E, A, B, C, D);
-	T_40_59(57, D, E, A, B, C);
-	T_40_59(58, C, D, E, A, B);
-	T_40_59(59, B, C, D, E, A);
-
-	/* Round 4 */
-	T_60_79(60, A, B, C, D, E);
-	T_60_79(61, E, A, B, C, D);
-	T_60_79(62, D, E, A, B, C);
-	T_60_79(63, C, D, E, A, B);
-	T_60_79(64, B, C, D, E, A);
-	T_60_79(65, A, B, C, D, E);
-	T_60_79(66, E, A, B, C, D);
-	T_60_79(67, D, E, A, B, C);
-	T_60_79(68, C, D, E, A, B);
-	T_60_79(69, B, C, D, E, A);
-	T_60_79(70, A, B, C, D, E);
-	T_60_79(71, E, A, B, C, D);
-	T_60_79(72, D, E, A, B, C);
-	T_60_79(73, C, D, E, A, B);
-	T_60_79(74, B, C, D, E, A);
-	T_60_79(75, A, B, C, D, E);
-	T_60_79(76, E, A, B, C, D);
-	T_60_79(77, D, E, A, B, C);
-	T_60_79(78, C, D, E, A, B);
-	T_60_79(79, B, C, D, E, A);
-
-	digest[0] += A;
-	digest[1] += B;
-	digest[2] += C;
-	digest[3] += D;
-	digest[4] += E;
-}
-EXPORT_SYMBOL(sha1_transform);
-
-/**
- * sha1_init - initialize the vectors for a SHA1 digest
- * @buf: vector to initialize
- */
-void sha1_init(__u32 *buf)
-{
-	buf[0] = 0x67452301;
-	buf[1] = 0xefcdab89;
-	buf[2] = 0x98badcfe;
-	buf[3] = 0x10325476;
-	buf[4] = 0xc3d2e1f0;
-}
-EXPORT_SYMBOL(sha1_init);
-- 
2.34.1

