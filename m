Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FC12B5B04
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 09:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgKQIcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 03:32:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbgKQIcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 03:32:03 -0500
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACC0824671;
        Tue, 17 Nov 2020 08:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605601918;
        bh=KjI7SbjUKM1KtG62AJFGbCe+BsHHqCWYCmKEf7o3nSk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hlMEDnObOz0H7a+fhzVqVmbeVA0yls7t+87GvtUTRCRvV+EFW7unzy0lUga/s5ZdA
         ql2K2YYB5FUjb+HCcxG2CuKQuHZ1sBodTo6uYqffYFzUjgRjlMeGPjACPqr7MWeTB0
         4D0orHV1phKlsg46VE24Wl+mIJwtcHoy8po4pgQI=
Received: by mail-oi1-f173.google.com with SMTP id o25so21807916oie.5;
        Tue, 17 Nov 2020 00:31:58 -0800 (PST)
X-Gm-Message-State: AOAM533ZeR/T9tb4Tn3OTYArui9mI8AZu0BjBTa52TLVafi8O/T4ZNoh
        aqlRcceDtTjlnP1raLK78mJhGbaS16EB84DzBT0=
X-Google-Smtp-Source: ABdhPJx87pkDMDRNHqijbs9tYiCjEScp3Qs4xLt/hfcXi96o9PcFOYDZCJyFq+Xmt5xm3EiF5Txkanq61bOXlMdqSWE=
X-Received: by 2002:aca:d583:: with SMTP id m125mr1580937oig.47.1605601917672;
 Tue, 17 Nov 2020 00:31:57 -0800 (PST)
MIME-Version: 1.0
References: <20201117021839.4146-1-a@unstable.cc>
In-Reply-To: <20201117021839.4146-1-a@unstable.cc>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 17 Nov 2020 09:31:44 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFxk31wtD3H8V0KbMd82UL_babEWpVTSkfqPpNjSqPNLA@mail.gmail.com>
Message-ID: <CAMj1kXFxk31wtD3H8V0KbMd82UL_babEWpVTSkfqPpNjSqPNLA@mail.gmail.com>
Subject: Re: [PATCH cryptodev] crypto: lib/chacha20poly1305 - allow users to
 specify 96bit nonce
To:     Antonio Quartulli <a@unstable.cc>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        wireguard@lists.zx2c4.com,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Antonio Quartulli <antonio@openvpn.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 at 03:45, Antonio Quartulli <a@unstable.cc> wrote:
>
> From: Antonio Quartulli <antonio@openvpn.net>
>
> The current interface limits the nonce 64bit, however, new users
> may want to specify a 96bit nonce, as dictated by the
> AEAD_CHACHA20_POLY1305 construction in RFC7539 Section 2.8.
>
> This patch changes the interface from accepting the nonce as single u64
> variable to an array of 12 bytes.
>
> Since ChaCha still expects an IV of 16 bytes, the nonce is transferred
> to a termporary 16byte long buffer, where the initial 8 bytes are set to
> 0 (ChaCha block counter).
>
> At the end of the procedure, the IV is explicitly overwritten with
> zeros.
>
> The only two in-tree users of this interface are:
> - WireGuard[tm]
> - security/keys/big_key.c
> Both have been modified accordingly to accommodate the new API.
>
> The chacha20poly1305-selftest has also been updated by getting rid of the
> _bignonce() wrapper and by prepending every 8byte long nonce with 4
> 0-octects..
>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
> ---
>
> Note: I am not 100% sure that the WireGuard[tm] adaptation to the new
> API is optimal. But after several attempts, this is the simplest I could
> come up with. Feedback is welcome!
>
> *******
> For the curious reader: the "other user" I am concerned about is
> ovpn-dco.
> ovpn-dco is the implementation of the OpenVPN data channel offload in
> kernelspace.
>
> It is currently under heavy development and the source code is available
> online at: git@gitlab.com:openvpn/ovpn-dco.git
>
> Next to AES-GCM it will also support ChaCha20Poly1305 and therefore we
> decided to re-use this relatively new API.

If you are going back to the drawing board with in-kernel acceleration
for OpenVPN, I strongly suggest to:
a) either stick to one implementation, and use the library interface,
or use dynamic dispatch using the crypto API AEAD abstraction, which
already implements 96-bit nonces for ChaCha20Poly1305,
b) consider using Aegis128 instead of AES-GCM or ChaChaPoly - it is
one of the winners of the CAESAR competition, and on hardware that
supports AES instructions, it is extremely efficient, and not
encumbered by the same issues that make AES-GCM tricky to use.

We might implement a library interface for Aegis128 if that is preferable.


> *******
>
>  drivers/net/wireguard/noise.c          |   5 +-
>  drivers/net/wireguard/receive.c        |  18 +-
>  drivers/net/wireguard/send.c           |  19 +-
>  include/crypto/chacha20poly1305.h      |  10 +-
>  lib/crypto/chacha20poly1305-selftest.c | 309 ++++++++++++++-----------
>  lib/crypto/chacha20poly1305.c          |  44 ++--
>  security/keys/big_key.c                |   6 +-
>  7 files changed, 242 insertions(+), 169 deletions(-)
>
> diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
> index c0cfd9b36c0b..6f773807eba0 100644
> --- a/drivers/net/wireguard/noise.c
> +++ b/drivers/net/wireguard/noise.c
> @@ -433,7 +433,7 @@ static void message_encrypt(u8 *dst_ciphertext, const u8 *src_plaintext,
>  {
>         chacha20poly1305_encrypt(dst_ciphertext, src_plaintext, src_len, hash,
>                                  NOISE_HASH_LEN,
> -                                0 /* Always zero for Noise_IK */, key);
> +                                page_address(ZERO_PAGE(0)) /* Always zero for Noise_IK */, key);
>         mix_hash(hash, dst_ciphertext, noise_encrypted_len(src_len));
>  }
>
> @@ -443,7 +443,8 @@ static bool message_decrypt(u8 *dst_plaintext, const u8 *src_ciphertext,
>  {
>         if (!chacha20poly1305_decrypt(dst_plaintext, src_ciphertext, src_len,
>                                       hash, NOISE_HASH_LEN,
> -                                     0 /* Always zero for Noise_IK */, key))
> +                                     page_address(ZERO_PAGE(0)) /* Always zero for Noise_IK */,
> +                                     key))
>                 return false;
>         mix_hash(hash, src_ciphertext, src_len);
>         return true;
> diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
> index 2c9551ea6dc7..ab736cc34e93 100644
> --- a/drivers/net/wireguard/receive.c
> +++ b/drivers/net/wireguard/receive.c
> @@ -248,9 +248,11 @@ static void keep_key_fresh(struct wg_peer *peer)
>  static bool decrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
>  {
>         struct scatterlist sg[MAX_SKB_FRAGS + 8];
> +       u8 nonce[CHACHA20POLY1305_NONCE_SIZE];
>         struct sk_buff *trailer;
>         unsigned int offset;
>         int num_frags;
> +       bool ret;
>
>         if (unlikely(!keypair))
>                 return false;
> @@ -265,6 +267,14 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
>         PACKET_CB(skb)->nonce =
>                 le64_to_cpu(((struct message_data *)skb->data)->counter);
>
> +       /* the nonce is 96-bit long:
> +        * - 00..31: zero
> +        * - 31..95: packet counter in LE
> +        */
> +       memset(nonce, 0, 4);
> +       memcpy(nonce + 4, &((struct message_data *)skb->data)->counter,
> +              sizeof(((struct message_data *)skb->data)->counter));
> +
>         /* We ensure that the network header is part of the packet before we
>          * call skb_cow_data, so that there's no chance that data is removed
>          * from the skb, so that later we can extract the original endpoint.
> @@ -281,9 +291,11 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
>         if (skb_to_sgvec(skb, sg, 0, skb->len) <= 0)
>                 return false;
>
> -       if (!chacha20poly1305_decrypt_sg_inplace(sg, skb->len, NULL, 0,
> -                                                PACKET_CB(skb)->nonce,
> -                                                keypair->receiving.key))
> +       ret = chacha20poly1305_decrypt_sg_inplace(sg, skb->len, NULL, 0, nonce,
> +                                                 keypair->receiving.key);
> +
> +       memzero_explicit(nonce, sizeof(nonce));
> +       if (!ret)
>                 return false;
>
>         /* Another ugly situation of pushing and pulling the header so as to
> diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
> index f74b9341ab0f..77042624e1ab 100644
> --- a/drivers/net/wireguard/send.c
> +++ b/drivers/net/wireguard/send.c
> @@ -163,9 +163,10 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
>  {
>         unsigned int padding_len, plaintext_len, trailer_len;
>         struct scatterlist sg[MAX_SKB_FRAGS + 8];
> +       u8 nonce[CHACHA20POLY1305_NONCE_SIZE];
>         struct message_data *header;
>         struct sk_buff *trailer;
> -       int num_frags;
> +       int ret, num_frags;
>
>         /* Force hash calculation before encryption so that flow analysis is
>          * consistent over the inner packet.
> @@ -213,9 +214,19 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
>         if (skb_to_sgvec(skb, sg, sizeof(struct message_data),
>                          noise_encrypted_len(plaintext_len)) <= 0)
>                 return false;
> -       return chacha20poly1305_encrypt_sg_inplace(sg, plaintext_len, NULL, 0,
> -                                                  PACKET_CB(skb)->nonce,
> -                                                  keypair->sending.key);
> +
> +       /* the nonce is 96-bit long:
> +        * - 00..31: zero
> +        * - 31..95: packet counter in LE
> +        */
> +       memset(nonce, 0, 4);
> +       memcpy(nonce + 4, &header->counter, sizeof(header->counter));
> +
> +       ret = chacha20poly1305_encrypt_sg_inplace(sg, plaintext_len, NULL, 0, nonce,
> +                                                 keypair->sending.key);
> +
> +       memzero_explicit(nonce, sizeof(nonce));
> +       return ret;
>  }
>
>  void wg_packet_send_keepalive(struct wg_peer *peer)
> diff --git a/include/crypto/chacha20poly1305.h b/include/crypto/chacha20poly1305.h
> index d2ac3ff7dc1e..9e74710aea6a 100644
> --- a/include/crypto/chacha20poly1305.h
> +++ b/include/crypto/chacha20poly1305.h
> @@ -12,17 +12,19 @@
>  enum chacha20poly1305_lengths {
>         XCHACHA20POLY1305_NONCE_SIZE = 24,
>         CHACHA20POLY1305_KEY_SIZE = 32,
> +       CHACHA20POLY1305_NONCE_SIZE = 12,
>         CHACHA20POLY1305_AUTHTAG_SIZE = 16
>  };
>
>  void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>                               const u8 *ad, const size_t ad_len,
> -                             const u64 nonce,
> +                             const u8 nonce[CHACHA20POLY1305_NONCE_SIZE],
>                               const u8 key[CHACHA20POLY1305_KEY_SIZE]);
>
>  bool __must_check
>  chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
> -                        const u8 *ad, const size_t ad_len, const u64 nonce,
> +                        const u8 *ad, const size_t ad_len,
> +                        const u8 nonce[CHACHA20POLY1305_NONCE_SIZE],
>                          const u8 key[CHACHA20POLY1305_KEY_SIZE]);
>
>  void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
> @@ -37,12 +39,12 @@ bool __must_check xchacha20poly1305_decrypt(
>
>  bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t src_len,
>                                          const u8 *ad, const size_t ad_len,
> -                                        const u64 nonce,
> +                                        const u8 nonce[CHACHA20POLY1305_NONCE_SIZE],
>                                          const u8 key[CHACHA20POLY1305_KEY_SIZE]);
>
>  bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t src_len,
>                                          const u8 *ad, const size_t ad_len,
> -                                        const u64 nonce,
> +                                        const u8 nonce[CHACHA20POLY1305_NONCE_SIZE],
>                                          const u8 key[CHACHA20POLY1305_KEY_SIZE]);
>
>  bool chacha20poly1305_selftest(void);
> diff --git a/lib/crypto/chacha20poly1305-selftest.c b/lib/crypto/chacha20poly1305-selftest.c
> index fa43deda2660..cf7edc44cb60 100644
> --- a/lib/crypto/chacha20poly1305-selftest.c
> +++ b/lib/crypto/chacha20poly1305-selftest.c
> @@ -7,7 +7,6 @@
>  #include <crypto/chacha.h>
>  #include <crypto/poly1305.h>
>
> -#include <asm/unaligned.h>
>  #include <linux/bug.h>
>  #include <linux/init.h>
>  #include <linux/mm.h>
> @@ -106,7 +105,8 @@ static const u8 enc_assoc001[] __initconst = {
>         0x00, 0x00, 0x4e, 0x91
>  };
>  static const u8 enc_nonce001[] __initconst = {
> -       0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
> +       0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04,
> +       0x05, 0x06, 0x07, 0x08
>  };
>  static const u8 enc_key001[] __initconst = {
>         0x1c, 0x92, 0x40, 0xa5, 0xeb, 0x55, 0xd3, 0x8a,
> @@ -122,7 +122,8 @@ static const u8 enc_output002[] __initconst = {
>  };
>  static const u8 enc_assoc002[] __initconst = { };
>  static const u8 enc_nonce002[] __initconst = {
> -       0xca, 0xbf, 0x33, 0x71, 0x32, 0x45, 0x77, 0x8e
> +       0x00, 0x00, 0x00, 0x00, 0xca, 0xbf, 0x33, 0x71,
> +       0x32, 0x45, 0x77, 0x8e
>  };
>  static const u8 enc_key002[] __initconst = {
>         0x4c, 0xf5, 0x96, 0x83, 0x38, 0xe6, 0xae, 0x7f,
> @@ -140,7 +141,8 @@ static const u8 enc_assoc003[] __initconst = {
>         0x33, 0x10, 0x41, 0x12, 0x1f, 0xf3, 0xd2, 0x6b
>  };
>  static const u8 enc_nonce003[] __initconst = {
> -       0x3d, 0x86, 0xb5, 0x6b, 0xc8, 0xa3, 0x1f, 0x1d
> +       0x00, 0x00, 0x00, 0x00, 0x3d, 0x86, 0xb5, 0x6b,
> +       0xc8, 0xa3, 0x1f, 0x1d
>  };
>  static const u8 enc_key003[] __initconst = {
>         0x2d, 0xb0, 0x5d, 0x40, 0xc8, 0xed, 0x44, 0x88,
> @@ -161,7 +163,8 @@ static const u8 enc_assoc004[] __initconst = {
>         0x6a, 0xe2, 0xad, 0x3f, 0x88, 0x39, 0x5a, 0x40
>  };
>  static const u8 enc_nonce004[] __initconst = {
> -       0xd2, 0x32, 0x1f, 0x29, 0x28, 0xc6, 0xc4, 0xc4
> +       0x00, 0x00, 0x00, 0x00, 0xd2, 0x32, 0x1f, 0x29,
> +       0x28, 0xc6, 0xc4, 0xc4
>  };
>  static const u8 enc_key004[] __initconst = {
>         0x4b, 0x28, 0x4b, 0xa3, 0x7b, 0xbe, 0xe9, 0xf8,
> @@ -180,7 +183,8 @@ static const u8 enc_output005[] __initconst = {
>  };
>  static const u8 enc_assoc005[] __initconst = { };
>  static const u8 enc_nonce005[] __initconst = {
> -       0x20, 0x1c, 0xaa, 0x5f, 0x9c, 0xbf, 0x92, 0x30
> +       0x00, 0x00, 0x00, 0x00, 0x20, 0x1c, 0xaa, 0x5f,
> +       0x9c, 0xbf, 0x92, 0x30
>  };
>  static const u8 enc_key005[] __initconst = {
>         0x66, 0xca, 0x9c, 0x23, 0x2a, 0x4b, 0x4b, 0x31,
> @@ -233,7 +237,8 @@ static const u8 enc_assoc006[] __initconst = {
>         0x70, 0xd3, 0x33, 0xf3, 0x8b, 0x18, 0x0b
>  };
>  static const u8 enc_nonce006[] __initconst = {
> -       0xdf, 0x51, 0x84, 0x82, 0x42, 0x0c, 0x75, 0x9c
> +       0x00, 0x00, 0x00, 0x00, 0xdf, 0x51, 0x84, 0x82,
> +       0x42, 0x0c, 0x75, 0x9c
>  };
>  static const u8 enc_key006[] __initconst = {
>         0x68, 0x7b, 0x8d, 0x8e, 0xe3, 0xc4, 0xdd, 0xae,
> @@ -314,7 +319,8 @@ static const u8 enc_output007[] __initconst = {
>  };
>  static const u8 enc_assoc007[] __initconst = { };
>  static const u8 enc_nonce007[] __initconst = {
> -       0xde, 0x7b, 0xef, 0xc3, 0x65, 0x1b, 0x68, 0xb0
> +       0x00, 0x00, 0x00, 0x00, 0xde, 0x7b, 0xef, 0xc3,
> +       0x65, 0x1b, 0x68, 0xb0
>  };
>  static const u8 enc_key007[] __initconst = {
>         0x8d, 0xb8, 0x91, 0x48, 0xf0, 0xe7, 0x0a, 0xbd,
> @@ -459,7 +465,8 @@ static const u8 enc_output008[] __initconst = {
>  };
>  static const u8 enc_assoc008[] __initconst = { };
>  static const u8 enc_nonce008[] __initconst = {
> -       0x0e, 0x0d, 0x57, 0xbb, 0x7b, 0x40, 0x54, 0x02
> +       0x00, 0x00, 0x00, 0x00, 0x0e, 0x0d, 0x57, 0xbb,
> +       0x7b, 0x40, 0x54, 0x02
>  };
>  static const u8 enc_key008[] __initconst = {
>         0xf2, 0xaa, 0x4f, 0x99, 0xfd, 0x3e, 0xa8, 0x53,
> @@ -609,7 +616,8 @@ static const u8 enc_assoc009[] __initconst = {
>         0xef
>  };
>  static const u8 enc_nonce009[] __initconst = {
> -       0xef, 0x2d, 0x63, 0xee, 0x6b, 0x80, 0x8b, 0x78
> +       0x00, 0x00, 0x00, 0x00, 0xef, 0x2d, 0x63, 0xee,
> +       0x6b, 0x80, 0x8b, 0x78
>  };
>  static const u8 enc_key009[] __initconst = {
>         0xea, 0xbc, 0x56, 0x99, 0xe3, 0x50, 0xff, 0xc5,
> @@ -885,7 +893,8 @@ static const u8 enc_assoc010[] __initconst = {
>         0xba, 0x73, 0x0f, 0xbf, 0x3d, 0x1e, 0x82, 0xb2
>  };
>  static const u8 enc_nonce010[] __initconst = {
> -       0xdb, 0x92, 0x0f, 0x7f, 0x17, 0x54, 0x0c, 0x30
> +       0x00, 0x00, 0x00, 0x00, 0xdb, 0x92, 0x0f, 0x7f,
> +       0x17, 0x54, 0x0c, 0x30
>  };
>  static const u8 enc_key010[] __initconst = {
>         0x47, 0x11, 0xeb, 0x86, 0x2b, 0x2c, 0xab, 0x44,
> @@ -1388,7 +1397,8 @@ static const u8 enc_assoc011[] __initconst = {
>         0xd6, 0x31, 0xda, 0x5d, 0x42, 0x5e, 0xd7
>  };
>  static const u8 enc_nonce011[] __initconst = {
> -       0xfd, 0x87, 0xd4, 0xd8, 0x62, 0xfd, 0xec, 0xaa
> +       0x00, 0x00, 0x00, 0x00, 0xfd, 0x87, 0xd4, 0xd8,
> +       0x62, 0xfd, 0xec, 0xaa
>  };
>  static const u8 enc_key011[] __initconst = {
>         0x35, 0x4e, 0xb5, 0x70, 0x50, 0x42, 0x8a, 0x85,
> @@ -1918,7 +1928,8 @@ static const u8 enc_assoc012[] __initconst = {
>         0x76, 0x75, 0xe0, 0xf3, 0x74, 0xe2, 0xc9
>  };
>  static const u8 enc_nonce012[] __initconst = {
> -       0x05, 0xa3, 0x93, 0xed, 0x30, 0xc5, 0xa2, 0x06
> +       0x00, 0x00, 0x00, 0x00, 0x05, 0xa3, 0x93, 0xed,
> +       0x30, 0xc5, 0xa2, 0x06
>  };
>  static const u8 enc_key012[] __initconst = {
>         0xb3, 0x35, 0x50, 0x03, 0x54, 0x2e, 0x40, 0x5e,
> @@ -3045,7 +3056,8 @@ static const u8 enc_assoc053[] __initconst = {
>         0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
>  };
>  static const u8 enc_nonce053[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key053[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3082,7 +3094,8 @@ static const u8 enc_assoc054[] __initconst = {
>         0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
>  };
>  static const u8 enc_nonce054[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key054[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3135,7 +3148,8 @@ static const u8 enc_assoc055[] __initconst = {
>         0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
>  };
>  static const u8 enc_nonce055[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key055[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3164,7 +3178,8 @@ static const u8 enc_assoc056[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce056[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key056[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3201,7 +3216,8 @@ static const u8 enc_assoc057[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce057[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key057[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3254,7 +3270,8 @@ static const u8 enc_assoc058[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce058[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key058[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3283,7 +3300,8 @@ static const u8 enc_assoc059[] __initconst = {
>         0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
>  };
>  static const u8 enc_nonce059[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key059[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3320,7 +3338,8 @@ static const u8 enc_assoc060[] __initconst = {
>         0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
>  };
>  static const u8 enc_nonce060[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key060[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3373,7 +3392,8 @@ static const u8 enc_assoc061[] __initconst = {
>         0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
>  };
>  static const u8 enc_nonce061[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key061[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3402,7 +3422,8 @@ static const u8 enc_assoc062[] __initconst = {
>         0xff, 0xff, 0xff, 0x7f, 0xff, 0xff, 0xff, 0x7f
>  };
>  static const u8 enc_nonce062[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key062[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3439,7 +3460,8 @@ static const u8 enc_assoc063[] __initconst = {
>         0xff, 0xff, 0xff, 0x7f, 0xff, 0xff, 0xff, 0x7f
>  };
>  static const u8 enc_nonce063[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key063[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3492,7 +3514,8 @@ static const u8 enc_assoc064[] __initconst = {
>         0xff, 0xff, 0xff, 0x7f, 0xff, 0xff, 0xff, 0x7f
>  };
>  static const u8 enc_nonce064[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key064[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3521,7 +3544,8 @@ static const u8 enc_assoc065[] __initconst = {
>         0x7f, 0xff, 0xff, 0xff, 0x7f, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce065[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key065[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3558,7 +3582,8 @@ static const u8 enc_assoc066[] __initconst = {
>         0x7f, 0xff, 0xff, 0xff, 0x7f, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce066[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key066[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3611,7 +3636,8 @@ static const u8 enc_assoc067[] __initconst = {
>         0x7f, 0xff, 0xff, 0xff, 0x7f, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce067[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key067[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3640,7 +3666,8 @@ static const u8 enc_assoc068[] __initconst = {
>         0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce068[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key068[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3677,7 +3704,8 @@ static const u8 enc_assoc069[] __initconst = {
>         0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce069[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key069[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3730,7 +3758,8 @@ static const u8 enc_assoc070[] __initconst = {
>         0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce070[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key070[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3759,7 +3788,8 @@ static const u8 enc_assoc071[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00
>  };
>  static const u8 enc_nonce071[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key071[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3796,7 +3826,8 @@ static const u8 enc_assoc072[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00
>  };
>  static const u8 enc_nonce072[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key072[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -3849,7 +3880,8 @@ static const u8 enc_assoc073[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00
>  };
>  static const u8 enc_nonce073[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0xee, 0x32, 0x00
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0xee, 0x32, 0x00
>  };
>  static const u8 enc_key073[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -4028,7 +4060,8 @@ static const u8 enc_assoc076[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce076[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x00, 0x07, 0xb4, 0xf0
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x07, 0xb4, 0xf0
>  };
>  static const u8 enc_key076[] __initconst = {
>         0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
> @@ -4087,7 +4120,8 @@ static const u8 enc_assoc077[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce077[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0xfb, 0x66
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x20, 0xfb, 0x66
>  };
>  static const u8 enc_key077[] __initconst = {
>         0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
> @@ -4146,7 +4180,8 @@ static const u8 enc_assoc078[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce078[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0xbb, 0x90
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x38, 0xbb, 0x90
>  };
>  static const u8 enc_key078[] __initconst = {
>         0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
> @@ -4205,7 +4240,8 @@ static const u8 enc_assoc079[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce079[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x48, 0x4a
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x70, 0x48, 0x4a
>  };
>  static const u8 enc_key079[] __initconst = {
>         0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
> @@ -4264,7 +4300,8 @@ static const u8 enc_assoc080[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce080[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x00, 0x93, 0x2f, 0x40
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x93, 0x2f, 0x40
>  };
>  static const u8 enc_key080[] __initconst = {
>         0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
> @@ -4323,7 +4360,8 @@ static const u8 enc_assoc081[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce081[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x00, 0xe2, 0x93, 0x35
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0xe2, 0x93, 0x35
>  };
>  static const u8 enc_key081[] __initconst = {
>         0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
> @@ -4382,7 +4420,8 @@ static const u8 enc_assoc082[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce082[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x00, 0x0e, 0xf7, 0xd5
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x0e, 0xf7, 0xd5
>  };
>  static const u8 enc_key082[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -4441,7 +4480,8 @@ static const u8 enc_assoc083[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce083[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x00, 0x3d, 0xfc, 0xe4
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x00, 0x3d, 0xfc, 0xe4
>  };
>  static const u8 enc_key083[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -4500,7 +4540,8 @@ static const u8 enc_assoc084[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce084[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x01, 0x84, 0x86, 0xa8
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x01, 0x84, 0x86, 0xa8
>  };
>  static const u8 enc_key084[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -4559,7 +4600,8 @@ static const u8 enc_assoc085[] __initconst = {
>         0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce085[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key085[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -4879,7 +4921,8 @@ static const u8 enc_assoc093[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce093[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key093[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -4923,7 +4966,8 @@ static const u8 enc_assoc094[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce094[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key094[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -4967,7 +5011,8 @@ static const u8 enc_assoc095[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce095[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key095[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5003,7 +5048,8 @@ static const u8 enc_assoc096[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce096[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key096[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5047,7 +5093,8 @@ static const u8 enc_assoc097[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce097[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key097[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5091,7 +5138,8 @@ static const u8 enc_assoc098[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce098[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key098[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5127,7 +5175,8 @@ static const u8 enc_assoc099[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce099[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key099[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5163,7 +5212,8 @@ static const u8 enc_assoc100[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce100[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key100[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5203,7 +5253,8 @@ static const u8 enc_assoc101[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce101[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key101[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5243,7 +5294,8 @@ static const u8 enc_assoc102[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce102[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key102[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5283,7 +5335,8 @@ static const u8 enc_assoc103[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce103[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key103[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5323,7 +5376,8 @@ static const u8 enc_assoc104[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce104[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key104[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5363,7 +5417,8 @@ static const u8 enc_assoc105[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce105[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key105[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5403,7 +5458,8 @@ static const u8 enc_assoc106[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce106[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key106[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5447,7 +5503,8 @@ static const u8 enc_assoc107[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce107[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key107[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5487,7 +5544,8 @@ static const u8 enc_assoc108[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce108[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key108[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5531,7 +5589,8 @@ static const u8 enc_assoc109[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce109[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key109[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5575,7 +5634,8 @@ static const u8 enc_assoc110[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce110[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key110[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5619,7 +5679,8 @@ static const u8 enc_assoc111[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce111[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key111[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5663,7 +5724,8 @@ static const u8 enc_assoc112[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce112[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key112[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5707,7 +5769,8 @@ static const u8 enc_assoc113[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce113[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key113[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5747,7 +5810,8 @@ static const u8 enc_assoc114[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce114[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key114[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5787,7 +5851,8 @@ static const u8 enc_assoc115[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce115[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key115[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5831,7 +5896,8 @@ static const u8 enc_assoc116[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce116[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key116[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5875,7 +5941,8 @@ static const u8 enc_assoc117[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce117[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key117[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -5919,7 +5986,8 @@ static const u8 enc_assoc118[] __initconst = {
>         0xff, 0xff, 0xff, 0xff
>  };
>  static const u8 enc_nonce118[] __initconst = {
> -       0x00, 0x00, 0x00, 0x00, 0x06, 0x4c, 0x2d, 0x52
> +       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +       0x06, 0x4c, 0x2d, 0x52
>  };
>  static const u8 enc_key118[] __initconst = {
>         0x80, 0x81, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
> @@ -6247,7 +6315,8 @@ static const u8 dec_assoc001[] __initconst = {
>         0x00, 0x00, 0x4e, 0x91
>  };
>  static const u8 dec_nonce001[] __initconst = {
> -       0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
> +       0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04,
> +       0x05, 0x06, 0x07, 0x08
>  };
>  static const u8 dec_key001[] __initconst = {
>         0x1c, 0x92, 0x40, 0xa5, 0xeb, 0x55, 0xd3, 0x8a,
> @@ -6263,7 +6332,8 @@ static const u8 dec_input002[] __initconst = {
>  static const u8 dec_output002[] __initconst = { };
>  static const u8 dec_assoc002[] __initconst = { };
>  static const u8 dec_nonce002[] __initconst = {
> -       0xca, 0xbf, 0x33, 0x71, 0x32, 0x45, 0x77, 0x8e
> +       0x00, 0x00, 0x00, 0x00, 0xca, 0xbf, 0x33, 0x71,
> +       0x32, 0x45, 0x77, 0x8e
>  };
>  static const u8 dec_key002[] __initconst = {
>         0x4c, 0xf5, 0x96, 0x83, 0x38, 0xe6, 0xae, 0x7f,
> @@ -6281,7 +6351,8 @@ static const u8 dec_assoc003[] __initconst = {
>         0x33, 0x10, 0x41, 0x12, 0x1f, 0xf3, 0xd2, 0x6b
>  };
>  static const u8 dec_nonce003[] __initconst = {
> -       0x3d, 0x86, 0xb5, 0x6b, 0xc8, 0xa3, 0x1f, 0x1d
> +       0x00, 0x00, 0x00, 0x00, 0x3d, 0x86, 0xb5, 0x6b,
> +       0xc8, 0xa3, 0x1f, 0x1d
>  };
>  static const u8 dec_key003[] __initconst = {
>         0x2d, 0xb0, 0x5d, 0x40, 0xc8, 0xed, 0x44, 0x88,
> @@ -6302,7 +6373,8 @@ static const u8 dec_assoc004[] __initconst = {
>         0x6a, 0xe2, 0xad, 0x3f, 0x88, 0x39, 0x5a, 0x40
>  };
>  static const u8 dec_nonce004[] __initconst = {
> -       0xd2, 0x32, 0x1f, 0x29, 0x28, 0xc6, 0xc4, 0xc4
> +       0x00, 0x00, 0x00, 0x00, 0xd2, 0x32, 0x1f, 0x29,
> +       0x28, 0xc6, 0xc4, 0xc4
>  };
>  static const u8 dec_key004[] __initconst = {
>         0x4b, 0x28, 0x4b, 0xa3, 0x7b, 0xbe, 0xe9, 0xf8,
> @@ -6321,7 +6393,8 @@ static const u8 dec_output005[] __initconst = {
>  };
>  static const u8 dec_assoc005[] __initconst = { };
>  static const u8 dec_nonce005[] __initconst = {
> -       0x20, 0x1c, 0xaa, 0x5f, 0x9c, 0xbf, 0x92, 0x30
> +       0x00, 0x00, 0x00, 0x00, 0x20, 0x1c, 0xaa, 0x5f,
> +       0x9c, 0xbf, 0x92, 0x30
>  };
>  static const u8 dec_key005[] __initconst = {
>         0x66, 0xca, 0x9c, 0x23, 0x2a, 0x4b, 0x4b, 0x31,
> @@ -6374,7 +6447,8 @@ static const u8 dec_assoc006[] __initconst = {
>         0x70, 0xd3, 0x33, 0xf3, 0x8b, 0x18, 0x0b
>  };
>  static const u8 dec_nonce006[] __initconst = {
> -       0xdf, 0x51, 0x84, 0x82, 0x42, 0x0c, 0x75, 0x9c
> +       0x00, 0x00, 0x00, 0x00, 0xdf, 0x51, 0x84, 0x82,
> +       0x42, 0x0c, 0x75, 0x9c
>  };
>  static const u8 dec_key006[] __initconst = {
>         0x68, 0x7b, 0x8d, 0x8e, 0xe3, 0xc4, 0xdd, 0xae,
> @@ -6455,7 +6529,8 @@ static const u8 dec_output007[] __initconst = {
>  };
>  static const u8 dec_assoc007[] __initconst = { };
>  static const u8 dec_nonce007[] __initconst = {
> -       0xde, 0x7b, 0xef, 0xc3, 0x65, 0x1b, 0x68, 0xb0
> +       0x00, 0x00, 0x00, 0x00, 0xde, 0x7b, 0xef, 0xc3,
> +       0x65, 0x1b, 0x68, 0xb0
>  };
>  static const u8 dec_key007[] __initconst = {
>         0x8d, 0xb8, 0x91, 0x48, 0xf0, 0xe7, 0x0a, 0xbd,
> @@ -6600,7 +6675,8 @@ static const u8 dec_output008[] __initconst = {
>  };
>  static const u8 dec_assoc008[] __initconst = { };
>  static const u8 dec_nonce008[] __initconst = {
> -       0x0e, 0x0d, 0x57, 0xbb, 0x7b, 0x40, 0x54, 0x02
> +       0x00, 0x00, 0x00, 0x00, 0x0e, 0x0d, 0x57, 0xbb,
> +       0x7b, 0x40, 0x54, 0x02
>  };
>  static const u8 dec_key008[] __initconst = {
>         0xf2, 0xaa, 0x4f, 0x99, 0xfd, 0x3e, 0xa8, 0x53,
> @@ -6750,7 +6826,8 @@ static const u8 dec_assoc009[] __initconst = {
>         0xef
>  };
>  static const u8 dec_nonce009[] __initconst = {
> -       0xef, 0x2d, 0x63, 0xee, 0x6b, 0x80, 0x8b, 0x78
> +       0x00, 0x00, 0x00, 0x00, 0xef, 0x2d, 0x63, 0xee,
> +       0x6b, 0x80, 0x8b, 0x78
>  };
>  static const u8 dec_key009[] __initconst = {
>         0xea, 0xbc, 0x56, 0x99, 0xe3, 0x50, 0xff, 0xc5,
> @@ -7026,7 +7103,8 @@ static const u8 dec_assoc010[] __initconst = {
>         0xba, 0x73, 0x0f, 0xbf, 0x3d, 0x1e, 0x82, 0xb2
>  };
>  static const u8 dec_nonce010[] __initconst = {
> -       0xdb, 0x92, 0x0f, 0x7f, 0x17, 0x54, 0x0c, 0x30
> +       0x00, 0x00, 0x00, 0x00, 0xdb, 0x92, 0x0f, 0x7f,
> +       0x17, 0x54, 0x0c, 0x30
>  };
>  static const u8 dec_key010[] __initconst = {
>         0x47, 0x11, 0xeb, 0x86, 0x2b, 0x2c, 0xab, 0x44,
> @@ -7529,7 +7607,8 @@ static const u8 dec_assoc011[] __initconst = {
>         0xd6, 0x31, 0xda, 0x5d, 0x42, 0x5e, 0xd7
>  };
>  static const u8 dec_nonce011[] __initconst = {
> -       0xfd, 0x87, 0xd4, 0xd8, 0x62, 0xfd, 0xec, 0xaa
> +       0x00, 0x00, 0x00, 0x00, 0xfd, 0x87, 0xd4, 0xd8,
> +       0x62, 0xfd, 0xec, 0xaa
>  };
>  static const u8 dec_key011[] __initconst = {
>         0x35, 0x4e, 0xb5, 0x70, 0x50, 0x42, 0x8a, 0x85,
> @@ -8059,7 +8138,8 @@ static const u8 dec_assoc012[] __initconst = {
>         0x76, 0x75, 0xe0, 0xf3, 0x74, 0xe2, 0xc9
>  };
>  static const u8 dec_nonce012[] __initconst = {
> -       0x05, 0xa3, 0x93, 0xed, 0x30, 0xc5, 0xa2, 0x06
> +       0x00, 0x00, 0x00, 0x00, 0x05, 0xa3, 0x93, 0xed,
> +       0x30, 0xc5, 0xa2, 0x06
>  };
>  static const u8 dec_key012[] __initconst = {
>         0xb3, 0x35, 0x50, 0x03, 0x54, 0x2e, 0x40, 0x5e,
> @@ -8589,7 +8669,8 @@ static const u8 dec_assoc013[] __initconst = {
>         0x76, 0x75, 0xe0, 0xf3, 0x74, 0xe2, 0xc9
>  };
>  static const u8 dec_nonce013[] __initconst = {
> -       0x05, 0xa3, 0x93, 0xed, 0x30, 0xc5, 0xa2, 0x06
> +       0x00, 0x00, 0x00, 0x00, 0x05, 0xa3, 0x93, 0xed,
> +       0x30, 0xc5, 0xa2, 0x06
>  };
>  static const u8 dec_key013[] __initconst = {
>         0xb3, 0x35, 0x50, 0x03, 0x54, 0x2e, 0x40, 0x5e,
> @@ -8821,55 +8902,15 @@ xchacha20poly1305_dec_vectors[] __initconst = {
>           sizeof(xdec_input001), sizeof(xdec_assoc001), sizeof(xdec_nonce001) }
>  };
>
> -/* This is for the selftests-only, since it is only useful for the purpose of
> - * testing the underlying primitives and interactions.
> - */
> -static void __init
> -chacha20poly1305_encrypt_bignonce(u8 *dst, const u8 *src, const size_t src_len,
> -                                 const u8 *ad, const size_t ad_len,
> -                                 const u8 nonce[12],
> -                                 const u8 key[CHACHA20POLY1305_KEY_SIZE])
> -{
> -       const u8 *pad0 = page_address(ZERO_PAGE(0));
> -       struct poly1305_desc_ctx poly1305_state;
> -       u32 chacha20_state[CHACHA_STATE_WORDS];
> -       union {
> -               u8 block0[POLY1305_KEY_SIZE];
> -               __le64 lens[2];
> -       } b = {{ 0 }};
> -       u8 bottom_row[16] = { 0 };
> -       u32 le_key[8];
> -       int i;
> -
> -       memcpy(&bottom_row[4], nonce, 12);
> -       for (i = 0; i < 8; ++i)
> -               le_key[i] = get_unaligned_le32(key + sizeof(le_key[i]) * i);
> -       chacha_init(chacha20_state, le_key, bottom_row);
> -       chacha20_crypt(chacha20_state, b.block0, b.block0, sizeof(b.block0));
> -       poly1305_init(&poly1305_state, b.block0);
> -       poly1305_update(&poly1305_state, ad, ad_len);
> -       poly1305_update(&poly1305_state, pad0, (0x10 - ad_len) & 0xf);
> -       chacha20_crypt(chacha20_state, dst, src, src_len);
> -       poly1305_update(&poly1305_state, dst, src_len);
> -       poly1305_update(&poly1305_state, pad0, (0x10 - src_len) & 0xf);
> -       b.lens[0] = cpu_to_le64(ad_len);
> -       b.lens[1] = cpu_to_le64(src_len);
> -       poly1305_update(&poly1305_state, (u8 *)b.lens, sizeof(b.lens));
> -       poly1305_final(&poly1305_state, dst + src_len);
> -}
> -
>  static void __init
>  chacha20poly1305_selftest_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>                                   const u8 *ad, const size_t ad_len,
>                                   const u8 *nonce, const size_t nonce_len,
>                                   const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
> -       if (nonce_len == 8)
> +       if (nonce_len == 12)
>                 chacha20poly1305_encrypt(dst, src, src_len, ad, ad_len,
> -                                        get_unaligned_le64(nonce), key);
> -       else if (nonce_len == 12)
> -               chacha20poly1305_encrypt_bignonce(dst, src, src_len, ad,
> -                                                 ad_len, nonce, key);
> +                                        nonce, key);
>         else
>                 BUG();
>  }
> @@ -8929,7 +8970,7 @@ bool __init chacha20poly1305_selftest(void)
>                         chacha20poly1305_enc_vectors[i].ilen,
>                         chacha20poly1305_enc_vectors[i].assoc,
>                         chacha20poly1305_enc_vectors[i].alen,
> -                       get_unaligned_le64(chacha20poly1305_enc_vectors[i].nonce),
> +                       chacha20poly1305_enc_vectors[i].nonce,
>                         chacha20poly1305_enc_vectors[i].key);
>                 if (!ret || memcmp(computed_output,
>                                    chacha20poly1305_enc_vectors[i].output,
> @@ -8948,7 +8989,7 @@ bool __init chacha20poly1305_selftest(void)
>                         chacha20poly1305_dec_vectors[i].ilen,
>                         chacha20poly1305_dec_vectors[i].assoc,
>                         chacha20poly1305_dec_vectors[i].alen,
> -                       get_unaligned_le64(chacha20poly1305_dec_vectors[i].nonce),
> +                       chacha20poly1305_dec_vectors[i].nonce,
>                         chacha20poly1305_dec_vectors[i].key);
>                 if (!decryption_success(ret,
>                                 chacha20poly1305_dec_vectors[i].failure,
> @@ -8971,7 +9012,7 @@ bool __init chacha20poly1305_selftest(void)
>                         chacha20poly1305_dec_vectors[i].ilen,
>                         chacha20poly1305_dec_vectors[i].assoc,
>                         chacha20poly1305_dec_vectors[i].alen,
> -                       get_unaligned_le64(chacha20poly1305_dec_vectors[i].nonce),
> +                       chacha20poly1305_dec_vectors[i].nonce,
>                         chacha20poly1305_dec_vectors[i].key);
>                 if (!decryption_success(ret,
>                         chacha20poly1305_dec_vectors[i].failure,
> @@ -9042,23 +9083,25 @@ bool __init chacha20poly1305_selftest(void)
>
>                                 if (!chacha20poly1305_encrypt_sg_inplace(sg_src,
>                                         total_len - POLY1305_DIGEST_SIZE, NULL, 0,
> -                                       0, enc_key001))
> +                                       page_address(ZERO_PAGE(0)), enc_key001))
>                                         goto chunkfail;
>                                 chacha20poly1305_encrypt(computed_output,
>                                         computed_output,
> -                                       total_len - POLY1305_DIGEST_SIZE, NULL, 0, 0,
> -                                       enc_key001);
> +                                       total_len - POLY1305_DIGEST_SIZE, NULL, 0,
> +                                       page_address(ZERO_PAGE(0)), enc_key001);
>                                 if (memcmp(computed_output, input, total_len))
>                                         goto chunkfail;
>                                 if (!chacha20poly1305_decrypt(computed_output,
> -                                       input, total_len, NULL, 0, 0, enc_key001))
> +                                       input, total_len, NULL, 0, page_address(ZERO_PAGE(0)),
> +                                       enc_key001))
>                                         goto chunkfail;
>                                 for (k = 0; k < total_len - POLY1305_DIGEST_SIZE; ++k) {
>                                         if (computed_output[k])
>                                                 goto chunkfail;
>                                 }
>                                 if (!chacha20poly1305_decrypt_sg_inplace(sg_src,
> -                                       total_len, NULL, 0, 0, enc_key001))
> +                                       total_len, NULL, 0, page_address(ZERO_PAGE(0)),
> +                                       enc_key001))
>                                         goto chunkfail;
>                                 for (k = 0; k < total_len - POLY1305_DIGEST_SIZE; ++k) {
>                                         if (input[k])
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index 5850f3b87359..53458d7e33e8 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -33,6 +33,16 @@ static void chacha_load_key(u32 *k, const u8 *in)
>         k[7] = get_unaligned_le32(in + 28);
>  }
>
> +static void chacha_load_iv(u8 *iv, const u8 *in)
> +{
> +       BUILD_BUG_ON(CHACHA_IV_SIZE != 4 + CHACHA20POLY1305_NONCE_SIZE);
> +
> +       /* 32 bit block counter */
> +       memset(iv, 0, 4);
> +       /* 96 bit nonce */
> +       memcpy(iv + 4, in, CHACHA20POLY1305_NONCE_SIZE);
> +}
> +
>  static void xchacha_init(u32 *chacha_state, const u8 *key, const u8 *nonce)
>  {
>         u32 k[CHACHA_KEY_WORDS];
> @@ -89,19 +99,17 @@ __chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>
>  void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>                               const u8 *ad, const size_t ad_len,
> -                             const u64 nonce,
> +                             const u8 nonce[CHACHA20POLY1305_NONCE_SIZE],
>                               const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
>         u32 chacha_state[CHACHA_STATE_WORDS];
>         u32 k[CHACHA_KEY_WORDS];
> -       __le64 iv[2];
> +       u8 iv[CHACHA_IV_SIZE];
>
>         chacha_load_key(k, key);
> +       chacha_load_iv(iv, nonce);
>
> -       iv[0] = 0;
> -       iv[1] = cpu_to_le64(nonce);
> -
> -       chacha_init(chacha_state, k, (u8 *)iv);
> +       chacha_init(chacha_state, k, iv);
>         __chacha20poly1305_encrypt(dst, src, src_len, ad, ad_len, chacha_state);
>
>         memzero_explicit(iv, sizeof(iv));
> @@ -167,20 +175,18 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>
>  bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>                               const u8 *ad, const size_t ad_len,
> -                             const u64 nonce,
> +                             const u8 nonce[CHACHA20POLY1305_NONCE_SIZE],
>                               const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
>         u32 chacha_state[CHACHA_STATE_WORDS];
>         u32 k[CHACHA_KEY_WORDS];
> -       __le64 iv[2];
> +       u8 iv[CHACHA_IV_SIZE];
>         bool ret;
>
>         chacha_load_key(k, key);
> +       chacha_load_iv(iv, nonce);
>
> -       iv[0] = 0;
> -       iv[1] = cpu_to_le64(nonce);
> -
> -       chacha_init(chacha_state, k, (u8 *)iv);
> +       chacha_init(chacha_state, k, iv);
>         ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
>                                          chacha_state);
>
> @@ -208,7 +214,7 @@ static
>  bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>                                        const size_t src_len,
>                                        const u8 *ad, const size_t ad_len,
> -                                      const u64 nonce,
> +                                      const u8 nonce[CHACHA20POLY1305_NONCE_SIZE],
>                                        const u8 key[CHACHA20POLY1305_KEY_SIZE],
>                                        int encrypt)
>  {
> @@ -223,7 +229,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>         union {
>                 struct {
>                         u32 k[CHACHA_KEY_WORDS];
> -                       __le64 iv[2];
> +                       u8 iv[CHACHA_IV_SIZE];
>                 };
>                 u8 block0[POLY1305_KEY_SIZE];
>                 u8 chacha_stream[CHACHA_BLOCK_SIZE];
> @@ -237,11 +243,9 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>                 return false;
>
>         chacha_load_key(b.k, key);
> +       chacha_load_iv(b.iv, nonce);
>
> -       b.iv[0] = 0;
> -       b.iv[1] = cpu_to_le64(nonce);
> -
> -       chacha_init(chacha_state, b.k, (u8 *)b.iv);
> +       chacha_init(chacha_state, b.k, b.iv);
>         chacha20_crypt(chacha_state, b.block0, pad0, sizeof(b.block0));
>         poly1305_init(&poly1305_state, b.block0);
>
> @@ -332,7 +336,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>
>  bool chacha20poly1305_encrypt_sg_inplace(struct scatterlist *src, size_t src_len,
>                                          const u8 *ad, const size_t ad_len,
> -                                        const u64 nonce,
> +                                        const u8 nonce[CHACHA20POLY1305_NONCE_SIZE],
>                                          const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
>         return chacha20poly1305_crypt_sg_inplace(src, src_len, ad, ad_len,
> @@ -342,7 +346,7 @@ EXPORT_SYMBOL(chacha20poly1305_encrypt_sg_inplace);
>
>  bool chacha20poly1305_decrypt_sg_inplace(struct scatterlist *src, size_t src_len,
>                                          const u8 *ad, const size_t ad_len,
> -                                        const u64 nonce,
> +                                        const u8 nonce[CHACHA20POLY1305_NONCE_SIZE],
>                                          const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
>         if (unlikely(src_len < POLY1305_DIGEST_SIZE))
> diff --git a/security/keys/big_key.c b/security/keys/big_key.c
> index 691347dea3c1..df37929c7b1d 100644
> --- a/security/keys/big_key.c
> +++ b/security/keys/big_key.c
> @@ -97,7 +97,7 @@ int big_key_preparse(struct key_preparsed_payload *prep)
>
>                 /* encrypt data */
>                 chacha20poly1305_encrypt(buf, prep->data, datalen, NULL, 0,
> -                                        0, enckey);
> +                                        page_address(ZERO_PAGE(0)), enckey);
>
>                 /* save aligned data to file */
>                 file = shmem_kernel_file_setup("", enclen, 0);
> @@ -260,8 +260,8 @@ long big_key_read(const struct key *key, char *buffer, size_t buflen)
>                         goto err_fput;
>                 }
>
> -               ret = chacha20poly1305_decrypt(buf, buf, enclen, NULL, 0, 0,
> -                                              enckey) ? 0 : -EBADMSG;
> +               ret = chacha20poly1305_decrypt(buf, buf, enclen, NULL, 0,
> +                                              page_address(ZERO_PAGE(0)), enckey) ? 0 : -EBADMSG;
>                 if (unlikely(ret))
>                         goto err_fput;
>
> --
> 2.29.2
>
