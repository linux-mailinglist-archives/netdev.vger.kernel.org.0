Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460F348C47B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240885AbiALNMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353411AbiALNM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:12:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0D1C061751;
        Wed, 12 Jan 2022 05:12:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E63BB81ECB;
        Wed, 12 Jan 2022 13:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C06C36AEA;
        Wed, 12 Jan 2022 13:12:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="CtiJEVe5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641993144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=By/tQK/8VZLYbqA4VX4X7pTOoqXILmSD8IlvO0zFDDg=;
        b=CtiJEVe58E6TStIi0KWjif9TlOYjgW1NCCnlDbrfF3Yo2XQDR47bwXTfVM5zcVEQKsjY+9
        D9qsmYizK37P70/1gNT/9rlZDGClAQ3qJVvotOksBdQcGxUBGdHc7SJrWl1aNbo/JcD/Wm
        mKNoNgEPYEv2R6poOGDc0luN8HyO7Ko=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bfb5e05b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 13:12:24 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH RFC v1 3/3] crypto: sha1_generic - import lib/sha1.c locally
Date:   Wed, 12 Jan 2022 14:12:04 +0100
Message-Id: <20220112131204.800307-4-Jason@zx2c4.com>
In-Reply-To: <20220112131204.800307-1-Jason@zx2c4.com>
References: <20220112131204.800307-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With no non-crypto API users of this function, we can move it into the
generic crypto/ code where it belongs.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/sha1_generic.c | 114 +++++++++++++++++++++++++++++++++++
 include/crypto/sha1.h |  10 ---
 lib/Makefile          |   2 +-
 lib/sha1.c            | 137 ------------------------------------------
 4 files changed, 115 insertions(+), 148 deletions(-)
 delete mode 100644 lib/sha1.c

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 325b57fe28dc..a2b019803561 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -16,9 +16,123 @@
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
+	B = ror32(B, 2); \
+	TEMP = E; E = D; D = C; C = B; B = A; A = TEMP; } while (0)
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
+	unsigned int i = 0;
+
+	A = digest[0];
+	B = digest[1];
+	C = digest[2];
+	D = digest[3];
+	E = digest[4];
+
+	/* Round 1 - iterations 0-16 take their input from 'data' */
+	for (; i < 16; ++i)
+		T_0_15(i, A, B, C, D, E);
+
+	/* Round 1 - tail. Input from 512-bit mixing array */
+	for (; i < 20; ++i)
+		T_16_19(i, A, B, C, D, E);
+
+	/* Round 2 */
+	for (; i < 40; ++i)
+		T_20_39(i, A, B, C, D, E);
+
+	/* Round 3 */
+	for (; i < 60; ++i)
+		T_40_59(i, A, B, C, D, E);
+
+	/* Round 4 */
+	for (; i < 80; ++i)
+		T_60_79(i, A, B, C, D, E);
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
index 364c23f15578..83ac3f0c1fbe 100644
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
index 0494766fc574..000000000000
--- a/lib/sha1.c
+++ /dev/null
@@ -1,137 +0,0 @@
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
-#include <linux/string.h>
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
-	B = ror32(B, 2); \
-	TEMP = E; E = D; D = C; C = B; B = A; A = TEMP; } while (0)
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
-	unsigned int i = 0;
-
-	A = digest[0];
-	B = digest[1];
-	C = digest[2];
-	D = digest[3];
-	E = digest[4];
-
-	/* Round 1 - iterations 0-16 take their input from 'data' */
-	for (; i < 16; ++i)
-		T_0_15(i, A, B, C, D, E);
-
-	/* Round 1 - tail. Input from 512-bit mixing array */
-	for (; i < 20; ++i)
-		T_16_19(i, A, B, C, D, E);
-
-	/* Round 2 */
-	for (; i < 40; ++i)
-		T_20_39(i, A, B, C, D, E);
-
-	/* Round 3 */
-	for (; i < 60; ++i)
-		T_40_59(i, A, B, C, D, E);
-
-	/* Round 4 */
-	for (; i < 80; ++i)
-		T_60_79(i, A, B, C, D, E);
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

