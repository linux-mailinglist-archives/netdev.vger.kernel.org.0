Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAEA48BA6F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 23:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345603AbiAKWFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 17:05:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51544 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345416AbiAKWFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 17:05:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B59460C2C;
        Tue, 11 Jan 2022 22:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000ADC36AE3;
        Tue, 11 Jan 2022 22:05:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="feUSDu3s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641938720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81oB8eaidO+xLFqjuIq9tnsTP2xJoidbMjbRIz3Pr2s=;
        b=feUSDu3sH8AYyHEwh0jHNYYc79o0Pjfw1QFZV1/+tMYfKEWEbtcI5U5KbHjc8lofM5/4Gl
        w0rJAhS5MTQStCR9hu9gUtdnk7+6zPW+opadfDUbuujQ3KS9tBEbEHnpsMHz/hhpc4IIA+
        CNdzN++CdfmQRETMC2DYLxtXbuGPy0I=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bcf52eb2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 11 Jan 2022 22:05:20 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, geert@linux-m68k.org, tytso@mit.edu,
        gregkh@linuxfoundation.org, jeanphilippe.aumasson@gmail.com,
        ardb@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH crypto v3 1/2] lib/crypto: blake2s: move hmac construction into wireguard
Date:   Tue, 11 Jan 2022 23:05:05 +0100
Message-Id: <20220111220506.742067-2-Jason@zx2c4.com>
In-Reply-To: <20220111220506.742067-1-Jason@zx2c4.com>
References: <20220111181037.632969-1-Jason@zx2c4.com>
 <20220111220506.742067-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basically nobody should use blake2s in an HMAC construction; it already
has a keyed variant. But unfortunately for historical reasons, Noise,
used by WireGuard, uses HKDF quite strictly, which means we have to use
this. Because this really shouldn't be used by others, this commit moves
it into wireguard's noise.c locally, so that kernels that aren't using
WireGuard don't get this superfluous code baked in. On m68k systems,
this shaves off ~314 bytes.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/noise.c | 45 ++++++++++++++++++++++++++++++-----
 include/crypto/blake2s.h      |  3 ---
 lib/crypto/blake2s-selftest.c | 31 ------------------------
 lib/crypto/blake2s.c          | 37 ----------------------------
 4 files changed, 39 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index c0cfd9b36c0b..720952b92e78 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -302,6 +302,41 @@ void wg_noise_set_static_identity_private_key(
 		static_identity->static_public, private_key);
 }
 
+static void hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen, const size_t keylen)
+{
+	struct blake2s_state state;
+	u8 x_key[BLAKE2S_BLOCK_SIZE] __aligned(__alignof__(u32)) = { 0 };
+	u8 i_hash[BLAKE2S_HASH_SIZE] __aligned(__alignof__(u32));
+	int i;
+
+	if (keylen > BLAKE2S_BLOCK_SIZE) {
+		blake2s_init(&state, BLAKE2S_HASH_SIZE);
+		blake2s_update(&state, key, keylen);
+		blake2s_final(&state, x_key);
+	} else
+		memcpy(x_key, key, keylen);
+
+	for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
+		x_key[i] ^= 0x36;
+
+	blake2s_init(&state, BLAKE2S_HASH_SIZE);
+	blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
+	blake2s_update(&state, in, inlen);
+	blake2s_final(&state, i_hash);
+
+	for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
+		x_key[i] ^= 0x5c ^ 0x36;
+
+	blake2s_init(&state, BLAKE2S_HASH_SIZE);
+	blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
+	blake2s_update(&state, i_hash, BLAKE2S_HASH_SIZE);
+	blake2s_final(&state, i_hash);
+
+	memcpy(out, i_hash, BLAKE2S_HASH_SIZE);
+	memzero_explicit(x_key, BLAKE2S_BLOCK_SIZE);
+	memzero_explicit(i_hash, BLAKE2S_HASH_SIZE);
+}
+
 /* This is Hugo Krawczyk's HKDF:
  *  - https://eprint.iacr.org/2010/264.pdf
  *  - https://tools.ietf.org/html/rfc5869
@@ -322,14 +357,14 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
 		 ((third_len || third_dst) && (!second_len || !second_dst))));
 
 	/* Extract entropy from data into secret */
-	blake2s256_hmac(secret, data, chaining_key, data_len, NOISE_HASH_LEN);
+	hmac(secret, data, chaining_key, data_len, NOISE_HASH_LEN);
 
 	if (!first_dst || !first_len)
 		goto out;
 
 	/* Expand first key: key = secret, data = 0x1 */
 	output[0] = 1;
-	blake2s256_hmac(output, output, secret, 1, BLAKE2S_HASH_SIZE);
+	hmac(output, output, secret, 1, BLAKE2S_HASH_SIZE);
 	memcpy(first_dst, output, first_len);
 
 	if (!second_dst || !second_len)
@@ -337,8 +372,7 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
 
 	/* Expand second key: key = secret, data = first-key || 0x2 */
 	output[BLAKE2S_HASH_SIZE] = 2;
-	blake2s256_hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1,
-			BLAKE2S_HASH_SIZE);
+	hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1, BLAKE2S_HASH_SIZE);
 	memcpy(second_dst, output, second_len);
 
 	if (!third_dst || !third_len)
@@ -346,8 +380,7 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
 
 	/* Expand third key: key = secret, data = second-key || 0x3 */
 	output[BLAKE2S_HASH_SIZE] = 3;
-	blake2s256_hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1,
-			BLAKE2S_HASH_SIZE);
+	hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1, BLAKE2S_HASH_SIZE);
 	memcpy(third_dst, output, third_len);
 
 out:
diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
index bc3fb59442ce..4e30e1799e61 100644
--- a/include/crypto/blake2s.h
+++ b/include/crypto/blake2s.h
@@ -101,7 +101,4 @@ static inline void blake2s(u8 *out, const u8 *in, const u8 *key,
 	blake2s_final(&state, out);
 }
 
-void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
-		     const size_t keylen);
-
 #endif /* _CRYPTO_BLAKE2S_H */
diff --git a/lib/crypto/blake2s-selftest.c b/lib/crypto/blake2s-selftest.c
index 5d9ea53be973..409e4b728770 100644
--- a/lib/crypto/blake2s-selftest.c
+++ b/lib/crypto/blake2s-selftest.c
@@ -15,7 +15,6 @@
  * #include <stdio.h>
  *
  * #include <openssl/evp.h>
- * #include <openssl/hmac.h>
  *
  * #define BLAKE2S_TESTVEC_COUNT	256
  *
@@ -58,16 +57,6 @@
  *	}
  *	printf("};\n\n");
  *
- *	printf("static const u8 blake2s_hmac_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {\n");
- *
- *	HMAC(EVP_blake2s256(), key, sizeof(key), buf, sizeof(buf), hash, NULL);
- *	print_vec(hash, BLAKE2S_OUTBYTES);
- *
- *	HMAC(EVP_blake2s256(), buf, sizeof(buf), key, sizeof(key), hash, NULL);
- *	print_vec(hash, BLAKE2S_OUTBYTES);
- *
- *	printf("};\n");
- *
  *	return 0;
  *}
  */
@@ -554,15 +543,6 @@ static const u8 blake2s_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
     0xd6, 0x98, 0x6b, 0x07, 0x10, 0x65, 0x52, 0x65, },
 };
 
-static const u8 blake2s_hmac_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
-  { 0xce, 0xe1, 0x57, 0x69, 0x82, 0xdc, 0xbf, 0x43, 0xad, 0x56, 0x4c, 0x70,
-    0xed, 0x68, 0x16, 0x96, 0xcf, 0xa4, 0x73, 0xe8, 0xe8, 0xfc, 0x32, 0x79,
-    0x08, 0x0a, 0x75, 0x82, 0xda, 0x3f, 0x05, 0x11, },
-  { 0x77, 0x2f, 0x0c, 0x71, 0x41, 0xf4, 0x4b, 0x2b, 0xb3, 0xc6, 0xb6, 0xf9,
-    0x60, 0xde, 0xe4, 0x52, 0x38, 0x66, 0xe8, 0xbf, 0x9b, 0x96, 0xc4, 0x9f,
-    0x60, 0xd9, 0x24, 0x37, 0x99, 0xd6, 0xec, 0x31, },
-};
-
 bool __init blake2s_selftest(void)
 {
 	u8 key[BLAKE2S_KEY_SIZE];
@@ -607,16 +587,5 @@ bool __init blake2s_selftest(void)
 		}
 	}
 
-	if (success) {
-		blake2s256_hmac(hash, buf, key, sizeof(buf), sizeof(key));
-		success &= !memcmp(hash, blake2s_hmac_testvecs[0], BLAKE2S_HASH_SIZE);
-
-		blake2s256_hmac(hash, key, buf, sizeof(key), sizeof(buf));
-		success &= !memcmp(hash, blake2s_hmac_testvecs[1], BLAKE2S_HASH_SIZE);
-
-		if (!success)
-			pr_err("blake2s256_hmac self-test: FAIL\n");
-	}
-
 	return success;
 }
diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 93f2ae051370..9364f79937b8 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -30,43 +30,6 @@ void blake2s_final(struct blake2s_state *state, u8 *out)
 }
 EXPORT_SYMBOL(blake2s_final);
 
-void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
-		     const size_t keylen)
-{
-	struct blake2s_state state;
-	u8 x_key[BLAKE2S_BLOCK_SIZE] __aligned(__alignof__(u32)) = { 0 };
-	u8 i_hash[BLAKE2S_HASH_SIZE] __aligned(__alignof__(u32));
-	int i;
-
-	if (keylen > BLAKE2S_BLOCK_SIZE) {
-		blake2s_init(&state, BLAKE2S_HASH_SIZE);
-		blake2s_update(&state, key, keylen);
-		blake2s_final(&state, x_key);
-	} else
-		memcpy(x_key, key, keylen);
-
-	for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
-		x_key[i] ^= 0x36;
-
-	blake2s_init(&state, BLAKE2S_HASH_SIZE);
-	blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
-	blake2s_update(&state, in, inlen);
-	blake2s_final(&state, i_hash);
-
-	for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
-		x_key[i] ^= 0x5c ^ 0x36;
-
-	blake2s_init(&state, BLAKE2S_HASH_SIZE);
-	blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
-	blake2s_update(&state, i_hash, BLAKE2S_HASH_SIZE);
-	blake2s_final(&state, i_hash);
-
-	memcpy(out, i_hash, BLAKE2S_HASH_SIZE);
-	memzero_explicit(x_key, BLAKE2S_BLOCK_SIZE);
-	memzero_explicit(i_hash, BLAKE2S_HASH_SIZE);
-}
-EXPORT_SYMBOL(blake2s256_hmac);
-
 static int __init blake2s_mod_init(void)
 {
 	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
-- 
2.34.1

