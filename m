Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B46359270
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 05:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhDIDDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 23:03:50 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:49234 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhDIDDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 23:03:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1617937411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7dh6luOjZQLh1aBy5+G8C9A6OrurtWSDGVgjtVnLptQ=;
        b=cLLBUvMl0IOmHBQKnlo7YKRTbmOvO00u7fgKLpQnaKgB+xYM/T8FVjtZi3ywrm3wa044tw
        1JQhs0jDiq1c2E1n6s7o2bKVFWpVANLVfBJAX/VsmsI4hKoqKiJ4qcg/5yelcK4Eshm9f0
        xs6FDlX5rPSg8gANvb1dE5Cz0us88SY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 78f4a530 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 9 Apr 2021 03:03:31 +0000 (UTC)
Date:   Thu, 8 Apr 2021 21:03:29 -0600
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Simo Sorce <simo@redhat.com>, Netdev <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Message-ID: <YG/EAePSEeYdonA0@zx2c4.com>
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com>
 <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
 <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
 <20210409024143.GL2900@Leo-laptop-t470s>
 <CAHmME9oqK9iXRn3wxAB-MZvX3k_hMbtjHF_V9UY96u6NLcczAw@mail.gmail.com>
 <20210409024907.GN2900@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210409024907.GN2900@Leo-laptop-t470s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 10:49:07AM +0800, Hangbin Liu wrote:
> On Thu, Apr 08, 2021 at 08:44:35PM -0600, Jason A. Donenfeld wrote:
> > Since it's just a normal module library, you can simply do this in the
> > module_init function, rather than deep within registration
> > abstractions.
> 
> I did a try but looks it's not that simple. Not sure if it's because wireguard
> calls the library directly. Need to check more...

Something like the below should work...

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index a408f4bcfd62..47212f9421c1 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -14,6 +14,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fips.h>

 #include <asm/cputype.h>
 #include <asm/hwcap.h>
@@ -297,6 +298,9 @@ static int __init chacha_simd_mod_init(void)
 {
 	int err = 0;

+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (IS_REACHABLE(CONFIG_CRYPTO_BLKCIPHER)) {
 		err = crypto_register_skciphers(arm_algs, ARRAY_SIZE(arm_algs));
 		if (err)
diff --git a/arch/arm/crypto/curve25519-glue.c b/arch/arm/crypto/curve25519-glue.c
index 31eb75b6002f..d03f810fdaf3 100644
--- a/arch/arm/crypto/curve25519-glue.c
+++ b/arch/arm/crypto/curve25519-glue.c
@@ -14,6 +14,7 @@
 #include <crypto/internal/simd.h>
 #include <linux/types.h>
 #include <linux/module.h>
+#include <linux/fips.h>
 #include <linux/init.h>
 #include <linux/jump_label.h>
 #include <linux/scatterlist.h>
@@ -114,6 +115,9 @@ static struct kpp_alg curve25519_alg = {

 static int __init mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (elf_hwcap & HWCAP_NEON) {
 		static_branch_enable(&have_neon);
 		return IS_REACHABLE(CONFIG_CRYPTO_KPP) ?
diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
index 3023c1acfa19..30d6c6de7a27 100644
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -17,6 +17,7 @@
 #include <linux/crypto.h>
 #include <linux/jump_label.h>
 #include <linux/module.h>
+#include <linux/fips.h>

 void poly1305_init_arm(void *state, const u8 *key);
 void poly1305_blocks_arm(void *state, const u8 *src, u32 len, u32 hibit);
@@ -240,6 +241,9 @@ static struct shash_alg arm_poly1305_algs[] = {{

 static int __init arm_poly1305_mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&
 	    (elf_hwcap & HWCAP_NEON))
 		static_branch_enable(&have_neon);
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index 1d9824c4ae43..1696993326b5 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -26,6 +26,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fips.h>

 #include <asm/hwcap.h>
 #include <asm/neon.h>
@@ -214,6 +215,9 @@ static struct skcipher_alg algs[] = {

 static int __init chacha_simd_mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (!cpu_have_named_feature(ASIMD))
 		return 0;

diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
index f33ada70c4ed..ac257a52be4d 100644
--- a/arch/arm64/crypto/poly1305-glue.c
+++ b/arch/arm64/crypto/poly1305-glue.c
@@ -17,6 +17,7 @@
 #include <linux/crypto.h>
 #include <linux/jump_label.h>
 #include <linux/module.h>
+#include <linux/fips.h>

 asmlinkage void poly1305_init_arm64(void *state, const u8 *key);
 asmlinkage void poly1305_blocks(void *state, const u8 *src, u32 len, u32 hibit);
@@ -208,6 +209,9 @@ static struct shash_alg neon_poly1305_alg = {

 static int __init neon_poly1305_mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (!cpu_have_named_feature(ASIMD))
 		return 0;

diff --git a/arch/mips/crypto/chacha-glue.c b/arch/mips/crypto/chacha-glue.c
index 90896029d0cd..31f8294f2a31 100644
--- a/arch/mips/crypto/chacha-glue.c
+++ b/arch/mips/crypto/chacha-glue.c
@@ -12,6 +12,7 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fips.h>

 asmlinkage void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src,
 				  unsigned int bytes, int nrounds);
@@ -128,6 +129,9 @@ static struct skcipher_alg algs[] = {

 static int __init chacha_simd_mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	return IS_REACHABLE(CONFIG_CRYPTO_BLKCIPHER) ?
 		crypto_register_skciphers(algs, ARRAY_SIZE(algs)) : 0;
 }
diff --git a/arch/mips/crypto/poly1305-glue.c b/arch/mips/crypto/poly1305-glue.c
index fc881b46d911..f5edec10cef8 100644
--- a/arch/mips/crypto/poly1305-glue.c
+++ b/arch/mips/crypto/poly1305-glue.c
@@ -12,6 +12,7 @@
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
+#include <linux/fips.h>

 asmlinkage void poly1305_init_mips(void *state, const u8 *key);
 asmlinkage void poly1305_blocks_mips(void *state, const u8 *src, u32 len, u32 hibit);
@@ -173,6 +174,9 @@ static struct shash_alg mips_poly1305_alg = {

 static int __init mips_poly1305_mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	return IS_REACHABLE(CONFIG_CRYPTO_HASH) ?
 		crypto_register_shash(&mips_poly1305_alg) : 0;
 }
diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
index 94ac5bdd9f6f..968762fcc8b2 100644
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -11,6 +11,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fips.h>

 #include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
@@ -194,6 +195,9 @@ static struct shash_alg blake2s_algs[] = {{

 static int __init blake2s_mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (!boot_cpu_has(X86_FEATURE_SSSE3))
 		return 0;

diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index 4c4dc64398cb..15e6cd084598 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -12,6 +12,7 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fips.h>
 #include <asm/simd.h>

 asmlinkage void chacha_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
@@ -278,6 +279,9 @@ static struct skcipher_alg algs[] = {

 static int __init chacha_simd_mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (!boot_cpu_has(X86_FEATURE_SSSE3))
 		return 0;

diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index a9edb6f8a0ba..b840c7e49aa1 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -11,6 +11,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fips.h>

 #include <asm/cpufeature.h>
 #include <asm/processor.h>
@@ -1488,6 +1489,9 @@ static struct kpp_alg curve25519_alg = {

 static int __init curve25519_mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (boot_cpu_has(X86_FEATURE_BMI2) && boot_cpu_has(X86_FEATURE_ADX))
 		static_branch_enable(&curve25519_use_bmi2_adx);
 	else
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index b69e362730d0..eb1940c74c7b 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -11,6 +11,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fips.h>
 #include <asm/intel-family.h>
 #include <asm/simd.h>

@@ -258,6 +259,9 @@ static struct shash_alg alg = {

 static int __init poly1305_simd_mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (IS_ENABLED(CONFIG_AS_AVX) && boot_cpu_has(X86_FEATURE_AVX) &&
 	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL))
 		static_branch_enable(&poly1305_use_avx);
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 41025a30c524..8d244eeb277e 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/bug.h>
+#include <linux/fips.h>
 #include <asm/unaligned.h>

 bool blake2s_selftest(void);
@@ -109,6 +110,9 @@ EXPORT_SYMBOL(blake2s256_hmac);

 static int __init mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
 	    WARN_ON(!blake2s_selftest()))
 		return -ENODEV;
diff --git a/lib/crypto/chacha.c b/lib/crypto/chacha.c
index 65ead6b0c7e0..4f0087717faf 100644
--- a/lib/crypto/chacha.c
+++ b/lib/crypto/chacha.c
@@ -11,6 +11,9 @@
 #include <linux/bitops.h>
 #include <linux/string.h>
 #include <linux/cryptohash.h>
+#include <linux/fips.h>
+#include <linux/errno.h>
+#include <linux/module.h>
 #include <asm/unaligned.h>
 #include <crypto/chacha.h>

@@ -113,3 +116,12 @@ void hchacha_block_generic(const u32 *state, u32 *stream, int nrounds)
 	memcpy(&stream[4], &x[12], 16);
 }
 EXPORT_SYMBOL(hchacha_block_generic);
+
+static int __init mod_init(void)
+{
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+module_init(mod_init);
diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index 1fec56e5dd51..d19278c5813d 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/fips.h>

 #define CHACHA_KEY_WORDS	(CHACHA_KEY_SIZE / sizeof(u32))

@@ -358,6 +359,9 @@ EXPORT_SYMBOL(chacha20poly1305_decrypt_sg_inplace);

 static int __init mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
 	    WARN_ON(!chacha20poly1305_selftest()))
 		return -ENODEV;
diff --git a/lib/crypto/curve25519.c b/lib/crypto/curve25519.c
index 288a62cd29b2..f759d49b0b57 100644
--- a/lib/crypto/curve25519.c
+++ b/lib/crypto/curve25519.c
@@ -12,11 +12,15 @@
 #include <crypto/curve25519.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/fips.h>

 bool curve25519_selftest(void);

 static int __init mod_init(void)
 {
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
 	    WARN_ON(!curve25519_selftest()))
 		return -ENODEV;
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index 9d2d14df0fee..ae4255957d31 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -10,6 +10,7 @@
 #include <crypto/internal/poly1305.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/fips.h>
 #include <asm/unaligned.h>

 void poly1305_init_generic(struct poly1305_desc_ctx *desc, const u8 *key)
@@ -73,5 +74,14 @@ void poly1305_final_generic(struct poly1305_desc_ctx *desc, u8 *dst)
 }
 EXPORT_SYMBOL_GPL(poly1305_final_generic);

+static int __init mod_init(void)
+{
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+module_init(mod_init);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");


