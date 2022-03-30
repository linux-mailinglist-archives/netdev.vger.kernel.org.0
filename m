Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E364ECEFD
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 23:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351320AbiC3VqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 17:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351321AbiC3VqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 17:46:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69F2B859;
        Wed, 30 Mar 2022 14:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55FB76171B;
        Wed, 30 Mar 2022 21:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0C3C34110;
        Wed, 30 Mar 2022 21:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648676656;
        bh=aM5mAmK19Mmcbly0+Z8gAQpXnfdX++fFzWKDjWvJamA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YVms58oeRQIRHD+lDm8U3Fj7oDVn8CVdEfQPPGYYU+ckHpeztbY2KwDnPChZouShA
         2qLDA3HcY9KngfFQeVSIStt+7fG6GyMlkiQ5zTZQnxd6Qz8VBToY3c4djMrxe1iT9F
         84ts3qlMLatnOyh6sIy2p5sw2Gx1OwEylvyL58V31YurGyAvQDv2lPqkHQKhUq0qjZ
         QCyVRCxfPd8ZMprBCTrST0fL2EzWA2yxY0uVCzsY9Uim5UZDyhydAie2C828cDibAi
         laIZnPzNWtUUpZs6TQx5DogiLpNC/QRLykiIK5ro96lAlN0B7CbkIcxuRLEu69IGyr
         x61KZ7RCmF8sw==
Received: by mail-oi1-f181.google.com with SMTP id e189so23436624oia.8;
        Wed, 30 Mar 2022 14:44:16 -0700 (PDT)
X-Gm-Message-State: AOAM533wVN7wmNRoHfg6/dKEvqY6REE5GwjdkxuOq9qhkn6M/kj54RCF
        jZDtezAloHi5gPNyb9tzIHLGYskvDcuOb1juIZQ=
X-Google-Smtp-Source: ABdhPJy9FW8z4Z13CGtrAM0Geq+heEQplHHsw3+w6FJjJlrct7i2m/ObXAxCutmtNa0cX1vpgYEaEymrnGT3HsYk52g=
X-Received: by 2002:aca:674c:0:b0:2d9:c460:707c with SMTP id
 b12-20020aca674c000000b002d9c460707cmr1139478oiy.126.1648676655872; Wed, 30
 Mar 2022 14:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220330085009.1011614-1-william.xuanziyang@huawei.com>
 <20220330093925.2d8ee6ca@kernel.org> <20220330132406.633c2da8@kernel.org>
In-Reply-To: <20220330132406.633c2da8@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 30 Mar 2022 23:44:04 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHnfOOGR-kDrxXot6JX=ShzKnkoyJjk5ev7Yxew8ogR+A@mail.gmail.com>
Message-ID: <CAMj1kXHnfOOGR-kDrxXot6JX=ShzKnkoyJjk5ev7Yxew8ogR+A@mail.gmail.com>
Subject: Re: [PATCH net] net/tls: fix slab-out-of-bounds bug in decrypt_internal
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ziyang Xuan <william.xuanziyang@huawei.com>, borisp@nvidia.com,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, vakul.garg@nxp.com, davejwatson@fb.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Mar 2022 at 22:24, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 30 Mar 2022 09:39:25 -0700 Jakub Kicinski wrote:
> > On Wed, 30 Mar 2022 16:50:09 +0800 Ziyang Xuan wrote:
> > > The memory size of tls_ctx->rx.iv for AES128-CCM is 12 setting in
> > > tls_set_sw_offload(). The return value of crypto_aead_ivsize()
> > > for "ccm(aes)" is 16. So memcpy() require 16 bytes from 12 bytes
> > > memory space will trigger slab-out-of-bounds bug as following:
> > >
> > > ==================================================================
> > > BUG: KASAN: slab-out-of-bounds in decrypt_internal+0x385/0xc40 [tls]
> > > Read of size 16 at addr ffff888114e84e60 by task tls/10911
> > >
> > > Call Trace:
> > >  <TASK>
> > >  dump_stack_lvl+0x34/0x44
> > >  print_report.cold+0x5e/0x5db
> > >  ? decrypt_internal+0x385/0xc40 [tls]
> > >  kasan_report+0xab/0x120
> > >  ? decrypt_internal+0x385/0xc40 [tls]
> > >  kasan_check_range+0xf9/0x1e0
> > >  memcpy+0x20/0x60
> > >  decrypt_internal+0x385/0xc40 [tls]
> > >  ? tls_get_rec+0x2e0/0x2e0 [tls]
> > >  ? process_rx_list+0x1a5/0x420 [tls]
> > >  ? tls_setup_from_iter.constprop.0+0x2e0/0x2e0 [tls]
> > >  decrypt_skb_update+0x9d/0x400 [tls]
> > >  tls_sw_recvmsg+0x3c8/0xb50 [tls]
> > >
> > > Allocated by task 10911:
> > >  kasan_save_stack+0x1e/0x40
> > >  __kasan_kmalloc+0x81/0xa0
> > >  tls_set_sw_offload+0x2eb/0xa20 [tls]
> > >  tls_setsockopt+0x68c/0x700 [tls]
> > >  __sys_setsockopt+0xfe/0x1b0
> >
> > Interesting, are you running on non-x86 platform or with some crypto
> > accelerator? I wonder why we're not hitting it with KASAN and the
> > selftest we have.
>
> I take that back, I can repro on x86 and 5.17, not sure why we're only
> discovering this now.
>
> Noob question for crypto folks, ivsize for AES CCM is reported
> as 16, but the real nonce size is 13 for TLS (q == 2, n == 13
> using NIST's variable names AFAICT). Are we required to zero out
> the rest of the buffer?
>

Looking at crypto/ccm.c and the arm64 accelerated implementation, it
appears the driver takes care of this: the first byte of the IV (q in
your example, but L in the crypto code) is the number of bytes minus
one that will be used for the counter, which starts at 0x1 for the CTR
cipher stream generation but is reset to 0x0 to encrypt the
authentication tag. Both drivers do a memset() to zero the last q+1
bytes of the IV.

> In particular I think I've seen transient crypto failures with
> SM4 CCM in the past and zeroing the tail of the iv buffer seems
> to make the tests pass reliably.
>

Yes, that seems like a bug, although there is only a single
implementation of the combined SM4-CCM transform in the tree, and
generic SM4 in C would be combined with the CCM chaining mode driver,
which is also used for generic AES.


> > > Reserve MAX_IV_SIZE memory space for iv to be compatible with all
> > > ciphers. And do iv and salt copy like done in tls_do_encryption().
> > >
> > > Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
> > > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> > > ---
> > >  net/tls/tls_sw.c | 10 +++-------
> > >  1 file changed, 3 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> > > index 0024a692f0f8..6b858f995b23 100644
> > > --- a/net/tls/tls_sw.c
> > > +++ b/net/tls/tls_sw.c
> > > @@ -1456,7 +1456,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
> > >     aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
> > >     mem_size = aead_size + (nsg * sizeof(struct scatterlist));
> > >     mem_size = mem_size + prot->aad_size;
> > > -   mem_size = mem_size + crypto_aead_ivsize(ctx->aead_recv);
> > > +   mem_size = mem_size + MAX_IV_SIZE;
> >
> > This change is not strictly required for the patch, right?
> > Can we drop it, and perhaps send as an optimization separately later?
> >
> > >     /* Allocate a single block of memory which contains
> > >      * aead_req || sgin[] || sgout[] || aad || iv.
> > > @@ -1493,12 +1493,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
> > >             kfree(mem);
> > >             return err;
> > >     }
> > > -   if (prot->version == TLS_1_3_VERSION ||
> > > -       prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305)
> > > -           memcpy(iv + iv_offset, tls_ctx->rx.iv,
> > > -                  crypto_aead_ivsize(ctx->aead_recv));
> > > -   else
> > > -           memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
> > > +   memcpy(iv + iv_offset, tls_ctx->rx.iv,
> > > +          prot->iv_size + prot->salt_size);
> >
> > If the IV really is 16B then we're passing 4 bytes of uninitialized
> > data at the end of the buffer, right?
> >
> > >     xor_iv_with_seq(prot, iv + iv_offset, tls_ctx->rx.rec_seq);
>
> FWIW this is the fix I tested:
>
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 0024a692f0f8..dbc6bce01898 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1473,6 +1473,8 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
>         aad = (u8 *)(sgout + n_sgout);
>         iv = aad + prot->aad_size;
>
> +       /* Prepare IV */
> +       memset(iv, 0, crypto_aead_ivsize(ctx->aead_recv));
>         /* For CCM based ciphers, first byte of nonce+iv is a constant */
>         switch (prot->cipher_type) {
>         case TLS_CIPHER_AES_CCM_128:
> @@ -1485,21 +1487,20 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
>                 break;
>         }
>
> -       /* Prepare IV */
> -       err = skb_copy_bits(skb, rxm->offset + TLS_HEADER_SIZE,
> -                           iv + iv_offset + prot->salt_size,
> -                           prot->iv_size);
> -       if (err < 0) {
> -               kfree(mem);
> -               return err;
> -       }
>         if (prot->version == TLS_1_3_VERSION ||
> -           prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305)
> +           prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305) {
>                 memcpy(iv + iv_offset, tls_ctx->rx.iv,
> -                      crypto_aead_ivsize(ctx->aead_recv));
> -       else
> +                      prot->iv_size + prot->salt_size);
> +       } else {
> +               err = skb_copy_bits(skb, rxm->offset + TLS_HEADER_SIZE,
> +                                   iv + iv_offset + prot->salt_size,
> +                                   prot->iv_size);
> +               if (err < 0) {
> +                       kfree(mem);
> +                       return err;
> +               }
>                 memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
> -
> +       }
>         xor_iv_with_seq(prot, iv + iv_offset, tls_ctx->rx.rec_seq);
>
>         /* Prepare AAD */
> --
> 2.34.1
>
>
