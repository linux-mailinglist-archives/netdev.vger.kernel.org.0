Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C62461B38
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 16:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344236AbhK2PpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 10:45:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43428 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237130AbhK2PnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 10:43:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3151461569;
        Mon, 29 Nov 2021 15:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FB7C53FAD;
        Mon, 29 Nov 2021 15:39:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="h3QJzSPc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638200392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W7rnA5GFOsN7Sz4kkspUD6nttpjznhi4aCzWfp9emg0=;
        b=h3QJzSPcBxBsyCdTQM/9kqe80Om0YGHW8KBNrx9YYrzKVu+eZ50tsYKHE3U0B6x0oWHfp1
        xX6rVhziKRu7mW2VPHjtlSCtFLPWhh3l70bss2TDXyLT7Zy8BCpkN8Qgx8B691sD7aQwes
        7J93WsM0eGSzuNjEAbBhLfUSO/P1OFc=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id c5a62dc4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 29 Nov 2021 15:39:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        stable@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH net 10/10] siphash: use _unaligned version by default
Date:   Mon, 29 Nov 2021 10:39:29 -0500
Message-Id: <20211129153929.3457-11-Jason@zx2c4.com>
In-Reply-To: <20211129153929.3457-1-Jason@zx2c4.com>
References: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

On ARM v6 and later, we define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
because the ordinary load/store instructions (ldr, ldrh, ldrb) can
tolerate any misalignment of the memory address. However, load/store
double and load/store multiple instructions (ldrd, ldm) may still only
be used on memory addresses that are 32-bit aligned, and so we have to
use the CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS macro with care, or we
may end up with a severe performance hit due to alignment traps that
require fixups by the kernel. Testing shows that this currently happens
with clang-13 but not gcc-11. In theory, any compiler version can
produce this bug or other problems, as we are dealing with undefined
behavior in C99 even on architectures that support this in hardware,
see also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100363.

Fortunately, the get_unaligned() accessors do the right thing: when
building for ARMv6 or later, the compiler will emit unaligned accesses
using the ordinary load/store instructions (but avoid the ones that
require 32-bit alignment). When building for older ARM, those accessors
will emit the appropriate sequence of ldrb/mov/orr instructions. And on
architectures that can truly tolerate any kind of misalignment, the
get_unaligned() accessors resolve to the leXX_to_cpup accessors that
operate on aligned addresses.

Since the compiler will in fact emit ldrd or ldm instructions when
building this code for ARM v6 or later, the solution is to use the
unaligned accessors unconditionally on architectures where this is
known to be fast. The _aligned version of the hash function is
however still needed to get the best performance on architectures
that cannot do any unaligned access in hardware.

This new version avoids the undefined behavior and should produce
the fastest hash on all architectures we support.

Link: https://lore.kernel.org/linux-arm-kernel/20181008211554.5355-4-ard.biesheuvel@linaro.org/
Link: https://lore.kernel.org/linux-crypto/CAK8P3a2KfmmGDbVHULWevB0hv71P2oi2ZCHEAqT=8dQfa0=cqQ@mail.gmail.com/
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Fixes: 2c956a60778c ("siphash: add cryptographically secure PRF")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/siphash.h | 14 ++++----------
 lib/siphash.c           | 12 ++++++------
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/include/linux/siphash.h b/include/linux/siphash.h
index bf21591a9e5e..0cda61855d90 100644
--- a/include/linux/siphash.h
+++ b/include/linux/siphash.h
@@ -27,9 +27,7 @@ static inline bool siphash_key_is_zero(const siphash_key_t *key)
 }
 
 u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key);
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key);
-#endif
 
 u64 siphash_1u64(const u64 a, const siphash_key_t *key);
 u64 siphash_2u64(const u64 a, const u64 b, const siphash_key_t *key);
@@ -82,10 +80,9 @@ static inline u64 ___siphash_aligned(const __le64 *data, size_t len,
 static inline u64 siphash(const void *data, size_t len,
 			  const siphash_key_t *key)
 {
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	if (!IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+	    !IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
 		return __siphash_unaligned(data, len, key);
-#endif
 	return ___siphash_aligned(data, len, key);
 }
 
@@ -96,10 +93,8 @@ typedef struct {
 
 u32 __hsiphash_aligned(const void *data, size_t len,
 		       const hsiphash_key_t *key);
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_unaligned(const void *data, size_t len,
 			 const hsiphash_key_t *key);
-#endif
 
 u32 hsiphash_1u32(const u32 a, const hsiphash_key_t *key);
 u32 hsiphash_2u32(const u32 a, const u32 b, const hsiphash_key_t *key);
@@ -135,10 +130,9 @@ static inline u32 ___hsiphash_aligned(const __le32 *data, size_t len,
 static inline u32 hsiphash(const void *data, size_t len,
 			   const hsiphash_key_t *key)
 {
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	if (!IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+	    !IS_ALIGNED((unsigned long)data, HSIPHASH_ALIGNMENT))
 		return __hsiphash_unaligned(data, len, key);
-#endif
 	return ___hsiphash_aligned(data, len, key);
 }
 
diff --git a/lib/siphash.c b/lib/siphash.c
index a90112ee72a1..72b9068ab57b 100644
--- a/lib/siphash.c
+++ b/lib/siphash.c
@@ -49,6 +49,7 @@
 	SIPROUND; \
 	return (v0 ^ v1) ^ (v2 ^ v3);
 
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key)
 {
 	const u8 *end = data + len - (len % sizeof(u64));
@@ -80,8 +81,8 @@ u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key)
 	POSTAMBLE
 }
 EXPORT_SYMBOL(__siphash_aligned);
+#endif
 
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key)
 {
 	const u8 *end = data + len - (len % sizeof(u64));
@@ -113,7 +114,6 @@ u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key)
 	POSTAMBLE
 }
 EXPORT_SYMBOL(__siphash_unaligned);
-#endif
 
 /**
  * siphash_1u64 - compute 64-bit siphash PRF value of a u64
@@ -250,6 +250,7 @@ EXPORT_SYMBOL(siphash_3u32);
 	HSIPROUND; \
 	return (v0 ^ v1) ^ (v2 ^ v3);
 
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
 {
 	const u8 *end = data + len - (len % sizeof(u64));
@@ -280,8 +281,8 @@ u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
 	HPOSTAMBLE
 }
 EXPORT_SYMBOL(__hsiphash_aligned);
+#endif
 
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_unaligned(const void *data, size_t len,
 			 const hsiphash_key_t *key)
 {
@@ -313,7 +314,6 @@ u32 __hsiphash_unaligned(const void *data, size_t len,
 	HPOSTAMBLE
 }
 EXPORT_SYMBOL(__hsiphash_unaligned);
-#endif
 
 /**
  * hsiphash_1u32 - compute 64-bit hsiphash PRF value of a u32
@@ -418,6 +418,7 @@ EXPORT_SYMBOL(hsiphash_4u32);
 	HSIPROUND; \
 	return v1 ^ v3;
 
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
 {
 	const u8 *end = data + len - (len % sizeof(u32));
@@ -438,8 +439,8 @@ u32 __hsiphash_aligned(const void *data, size_t len, const hsiphash_key_t *key)
 	HPOSTAMBLE
 }
 EXPORT_SYMBOL(__hsiphash_aligned);
+#endif
 
-#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 u32 __hsiphash_unaligned(const void *data, size_t len,
 			 const hsiphash_key_t *key)
 {
@@ -461,7 +462,6 @@ u32 __hsiphash_unaligned(const void *data, size_t len,
 	HPOSTAMBLE
 }
 EXPORT_SYMBOL(__hsiphash_unaligned);
-#endif
 
 /**
  * hsiphash_1u32 - compute 32-bit hsiphash PRF value of a u32
-- 
2.34.1

