Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4969C48AFD1
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 15:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242514AbiAKOoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 09:44:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41596 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242201AbiAKOoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 09:44:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FA8C616A3;
        Tue, 11 Jan 2022 14:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE9AC36AEB;
        Tue, 11 Jan 2022 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641912245;
        bh=9QtNgp4GexGBqtOwirvi47YwIzGmn/bXKQBw5RQx9qA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PS/GyHe2IojWJ1YN8K5T2hpa2Af5LOomqMwD4LuKDc+DGtw/iGvD4R3ncsLJXIYRl
         SS4ldPslXZc/e0b2PpOohkQsy07shAQNTq3zh39/F64JJyOExerHz5WdIUiheJsrTM
         sqQ3/Wj965F5bgkVpNJKYo0MdXMj/nj9picVUTRZYElHBNTrb9EuAdhsW4tAZUWVr9
         f7glDSpPaGqJh5bleVODz2QjWvzMiothj3La3PyL+fuMbO2obmvJxbaZL1w1FMLADu
         dbczHv4gPJBmPVjCeh9rkbZA9DSr+1PNQtbLhsGpzC+98wKbE2RiLr78eWoYxlQDXC
         TlTeVU/RQI6UA==
Received: by mail-wr1-f47.google.com with SMTP id d19so2879099wrb.0;
        Tue, 11 Jan 2022 06:44:05 -0800 (PST)
X-Gm-Message-State: AOAM533HM9V+jpYsLp3o/DHhUgzIgmfehYP7EW0JzDDmZHDCOi3uWV4e
        ohV2fTgNOr6ZNRIzLEhT9heGOw2QWacSYbncJvY=
X-Google-Smtp-Source: ABdhPJz/w2V6Pid5D3w0qEs9I5COP+6n2xpVD080JqwBmLeVHA6oNfaUY4ZgnqPHsQ3vI53XZqOv8T2Gy6+VTAIQUzM=
X-Received: by 2002:a5d:4087:: with SMTP id o7mr4115239wrp.189.1641912244034;
 Tue, 11 Jan 2022 06:44:04 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
 <20220111134934.324663-1-Jason@zx2c4.com> <20220111134934.324663-3-Jason@zx2c4.com>
In-Reply-To: <20220111134934.324663-3-Jason@zx2c4.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 11 Jan 2022 15:43:52 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFynd4K7Zp6czgTWnDp9RHimizyMs4Yo2RsjCsEfa89fA@mail.gmail.com>
Message-ID: <CAMj1kXFynd4K7Zp6czgTWnDp9RHimizyMs4Yo2RsjCsEfa89fA@mail.gmail.com>
Subject: Re: [PATCH crypto 2/2] lib/crypto: blake2s: move hmac construction
 into wireguard
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, wireguard@lists.zx2c4.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <bpf@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 at 14:49, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Basically nobody should use blake2s in an HMAC construction; it already
> has a keyed variant. But for unfortunately historical reasons, Noise,

-ly

> used by WireGuard, uses HKDF quite strictly, which means we have to use
> this. Because this really shouldn't be used by others, this commit moves
> it into wireguard's noise.c locally, so that kernels that aren't using
> WireGuard don't get this superfluous code baked in. On m68k systems,
> this shaves off ~314 bytes.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: wireguard@lists.zx2c4.com
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  drivers/net/wireguard/noise.c | 45 ++++++++++++++++++++++++++++++-----
>  include/crypto/blake2s.h      |  3 ---
>  lib/crypto/blake2s-selftest.c | 31 ------------------------
>  lib/crypto/blake2s.c          | 37 ----------------------------
>  4 files changed, 39 insertions(+), 77 deletions(-)
>
> diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
> index c0cfd9b36c0b..720952b92e78 100644
> --- a/drivers/net/wireguard/noise.c
> +++ b/drivers/net/wireguard/noise.c
> @@ -302,6 +302,41 @@ void wg_noise_set_static_identity_private_key(
>                 static_identity->static_public, private_key);
>  }
>
> +static void hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen, const size_t keylen)
> +{
> +       struct blake2s_state state;
> +       u8 x_key[BLAKE2S_BLOCK_SIZE] __aligned(__alignof__(u32)) = { 0 };
> +       u8 i_hash[BLAKE2S_HASH_SIZE] __aligned(__alignof__(u32));
> +       int i;
> +
> +       if (keylen > BLAKE2S_BLOCK_SIZE) {
> +               blake2s_init(&state, BLAKE2S_HASH_SIZE);
> +               blake2s_update(&state, key, keylen);
> +               blake2s_final(&state, x_key);
> +       } else
> +               memcpy(x_key, key, keylen);
> +
> +       for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
> +               x_key[i] ^= 0x36;
> +
> +       blake2s_init(&state, BLAKE2S_HASH_SIZE);
> +       blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
> +       blake2s_update(&state, in, inlen);
> +       blake2s_final(&state, i_hash);
> +
> +       for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
> +               x_key[i] ^= 0x5c ^ 0x36;
> +
> +       blake2s_init(&state, BLAKE2S_HASH_SIZE);
> +       blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
> +       blake2s_update(&state, i_hash, BLAKE2S_HASH_SIZE);
> +       blake2s_final(&state, i_hash);
> +
> +       memcpy(out, i_hash, BLAKE2S_HASH_SIZE);
> +       memzero_explicit(x_key, BLAKE2S_BLOCK_SIZE);
> +       memzero_explicit(i_hash, BLAKE2S_HASH_SIZE);
> +}
> +
>  /* This is Hugo Krawczyk's HKDF:
>   *  - https://eprint.iacr.org/2010/264.pdf
>   *  - https://tools.ietf.org/html/rfc5869
> @@ -322,14 +357,14 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
>                  ((third_len || third_dst) && (!second_len || !second_dst))));
>
>         /* Extract entropy from data into secret */
> -       blake2s256_hmac(secret, data, chaining_key, data_len, NOISE_HASH_LEN);
> +       hmac(secret, data, chaining_key, data_len, NOISE_HASH_LEN);
>
>         if (!first_dst || !first_len)
>                 goto out;
>
>         /* Expand first key: key = secret, data = 0x1 */
>         output[0] = 1;
> -       blake2s256_hmac(output, output, secret, 1, BLAKE2S_HASH_SIZE);
> +       hmac(output, output, secret, 1, BLAKE2S_HASH_SIZE);
>         memcpy(first_dst, output, first_len);
>
>         if (!second_dst || !second_len)
> @@ -337,8 +372,7 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
>
>         /* Expand second key: key = secret, data = first-key || 0x2 */
>         output[BLAKE2S_HASH_SIZE] = 2;
> -       blake2s256_hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1,
> -                       BLAKE2S_HASH_SIZE);
> +       hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1, BLAKE2S_HASH_SIZE);
>         memcpy(second_dst, output, second_len);
>
>         if (!third_dst || !third_len)
> @@ -346,8 +380,7 @@ static void kdf(u8 *first_dst, u8 *second_dst, u8 *third_dst, const u8 *data,
>
>         /* Expand third key: key = secret, data = second-key || 0x3 */
>         output[BLAKE2S_HASH_SIZE] = 3;
> -       blake2s256_hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1,
> -                       BLAKE2S_HASH_SIZE);
> +       hmac(output, output, secret, BLAKE2S_HASH_SIZE + 1, BLAKE2S_HASH_SIZE);
>         memcpy(third_dst, output, third_len);
>
>  out:
> diff --git a/include/crypto/blake2s.h b/include/crypto/blake2s.h
> index bc3fb59442ce..4e30e1799e61 100644
> --- a/include/crypto/blake2s.h
> +++ b/include/crypto/blake2s.h
> @@ -101,7 +101,4 @@ static inline void blake2s(u8 *out, const u8 *in, const u8 *key,
>         blake2s_final(&state, out);
>  }
>
> -void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
> -                    const size_t keylen);
> -
>  #endif /* _CRYPTO_BLAKE2S_H */
> diff --git a/lib/crypto/blake2s-selftest.c b/lib/crypto/blake2s-selftest.c
> index 5d9ea53be973..409e4b728770 100644
> --- a/lib/crypto/blake2s-selftest.c
> +++ b/lib/crypto/blake2s-selftest.c
> @@ -15,7 +15,6 @@
>   * #include <stdio.h>
>   *
>   * #include <openssl/evp.h>
> - * #include <openssl/hmac.h>
>   *
>   * #define BLAKE2S_TESTVEC_COUNT       256
>   *
> @@ -58,16 +57,6 @@
>   *     }
>   *     printf("};\n\n");
>   *
> - *     printf("static const u8 blake2s_hmac_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {\n");
> - *
> - *     HMAC(EVP_blake2s256(), key, sizeof(key), buf, sizeof(buf), hash, NULL);
> - *     print_vec(hash, BLAKE2S_OUTBYTES);
> - *
> - *     HMAC(EVP_blake2s256(), buf, sizeof(buf), key, sizeof(key), hash, NULL);
> - *     print_vec(hash, BLAKE2S_OUTBYTES);
> - *
> - *     printf("};\n");
> - *
>   *     return 0;
>   *}
>   */
> @@ -554,15 +543,6 @@ static const u8 blake2s_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
>      0xd6, 0x98, 0x6b, 0x07, 0x10, 0x65, 0x52, 0x65, },
>  };
>
> -static const u8 blake2s_hmac_testvecs[][BLAKE2S_HASH_SIZE] __initconst = {
> -  { 0xce, 0xe1, 0x57, 0x69, 0x82, 0xdc, 0xbf, 0x43, 0xad, 0x56, 0x4c, 0x70,
> -    0xed, 0x68, 0x16, 0x96, 0xcf, 0xa4, 0x73, 0xe8, 0xe8, 0xfc, 0x32, 0x79,
> -    0x08, 0x0a, 0x75, 0x82, 0xda, 0x3f, 0x05, 0x11, },
> -  { 0x77, 0x2f, 0x0c, 0x71, 0x41, 0xf4, 0x4b, 0x2b, 0xb3, 0xc6, 0xb6, 0xf9,
> -    0x60, 0xde, 0xe4, 0x52, 0x38, 0x66, 0xe8, 0xbf, 0x9b, 0x96, 0xc4, 0x9f,
> -    0x60, 0xd9, 0x24, 0x37, 0x99, 0xd6, 0xec, 0x31, },
> -};
> -
>  bool __init blake2s_selftest(void)
>  {
>         u8 key[BLAKE2S_KEY_SIZE];
> @@ -607,16 +587,5 @@ bool __init blake2s_selftest(void)
>                 }
>         }
>
> -       if (success) {
> -               blake2s256_hmac(hash, buf, key, sizeof(buf), sizeof(key));
> -               success &= !memcmp(hash, blake2s_hmac_testvecs[0], BLAKE2S_HASH_SIZE);
> -
> -               blake2s256_hmac(hash, key, buf, sizeof(key), sizeof(buf));
> -               success &= !memcmp(hash, blake2s_hmac_testvecs[1], BLAKE2S_HASH_SIZE);
> -
> -               if (!success)
> -                       pr_err("blake2s256_hmac self-test: FAIL\n");
> -       }
> -
>         return success;
>  }
> diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
> index 93f2ae051370..9364f79937b8 100644
> --- a/lib/crypto/blake2s.c
> +++ b/lib/crypto/blake2s.c
> @@ -30,43 +30,6 @@ void blake2s_final(struct blake2s_state *state, u8 *out)
>  }
>  EXPORT_SYMBOL(blake2s_final);
>
> -void blake2s256_hmac(u8 *out, const u8 *in, const u8 *key, const size_t inlen,
> -                    const size_t keylen)
> -{
> -       struct blake2s_state state;
> -       u8 x_key[BLAKE2S_BLOCK_SIZE] __aligned(__alignof__(u32)) = { 0 };
> -       u8 i_hash[BLAKE2S_HASH_SIZE] __aligned(__alignof__(u32));
> -       int i;
> -
> -       if (keylen > BLAKE2S_BLOCK_SIZE) {
> -               blake2s_init(&state, BLAKE2S_HASH_SIZE);
> -               blake2s_update(&state, key, keylen);
> -               blake2s_final(&state, x_key);
> -       } else
> -               memcpy(x_key, key, keylen);
> -
> -       for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
> -               x_key[i] ^= 0x36;
> -
> -       blake2s_init(&state, BLAKE2S_HASH_SIZE);
> -       blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
> -       blake2s_update(&state, in, inlen);
> -       blake2s_final(&state, i_hash);
> -
> -       for (i = 0; i < BLAKE2S_BLOCK_SIZE; ++i)
> -               x_key[i] ^= 0x5c ^ 0x36;
> -
> -       blake2s_init(&state, BLAKE2S_HASH_SIZE);
> -       blake2s_update(&state, x_key, BLAKE2S_BLOCK_SIZE);
> -       blake2s_update(&state, i_hash, BLAKE2S_HASH_SIZE);
> -       blake2s_final(&state, i_hash);
> -
> -       memcpy(out, i_hash, BLAKE2S_HASH_SIZE);
> -       memzero_explicit(x_key, BLAKE2S_BLOCK_SIZE);
> -       memzero_explicit(i_hash, BLAKE2S_HASH_SIZE);
> -}
> -EXPORT_SYMBOL(blake2s256_hmac);
> -
>  static int __init blake2s_mod_init(void)
>  {
>         if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
> --
> 2.34.1
>
