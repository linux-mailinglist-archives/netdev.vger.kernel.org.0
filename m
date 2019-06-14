Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA0245B40
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 13:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfFNLPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 07:15:24 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:47029 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbfFNLPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 07:15:23 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so4761924iol.13
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 04:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kGsvaCvQSv853oT5Wt897g4QszXSynzAJL9smkhzIpE=;
        b=sAfN/RgcVfbW/1Y66uS9fooOVxQuxZHUChyuQOf1L6D7MDey6eL0tRx27ZTMYLc/8/
         nu4kVFEn2eolaITk2OScPN5HxCq/9WxnAcOZiiqd1Fxl5OvOSCnCGhaDylsnfsA6AL9T
         W1GlzQwds1c0N6QaraLSCs4Be0+1bhhiSOI/dvEzxjwdU1NBdDKS+mtgv12oCfxp9tSq
         4o46t+lBTSsa/1R2Ly6zAJSyNRSy88IaGyudM8Q6v2mUMpgY6uwlsRlnJfgJ/ctFDLJo
         evWlqEMAB26eAE+FFSCPn+Ef9tKvGLl8XSHi5FGQvvgE88Xgy3kTBkHdHkVg5d32Mn6A
         u1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kGsvaCvQSv853oT5Wt897g4QszXSynzAJL9smkhzIpE=;
        b=k/AAEIJIIEWZoJu/GVPdNFouac3duXDfvq9iTLqYDwoO+pUIEfAKBtnrepnVpBSnuK
         SoQvP9NXsxpudxPplO/q53GEJzZ1aHMJnlDbBWyzSAW1IlR8uzJcpbGwq+mVoKK5ggRT
         tgh+O9JE96zeu5v7bE5UavpaThKAmGGV//4i/zSdoFw0gL8obFufKbuaTnJ5Gcp+qlHq
         Bix82Z7xC74qxDPdfgBFbjLM3vnCn+bJQq9V4EpgoEKKgLE+xe2CZRZRLRrhxLakSBaX
         ZSr9HxTJVtbQ4MLB60rTdhY3l0IjDw5flzB0vga7SH4JhJPmoddbVl1lh1LANvD32DbD
         gi/w==
X-Gm-Message-State: APjAAAXGhu4ywMzVtff5tfn03jIBzHYfW958w8O3k8ay0EIuo7HbYrzM
        HUjSqismbyOxxf+qd70RWDgH4PQ/DINN+0VAGaROg58g1N4=
X-Google-Smtp-Source: APXvYqxQ6GG7E0cCjPscVtRXNnG45uLjGr4SyfRGETM5XcZ/FobcTnAqZO+XINMt3yVszpG8n0AVaQKG0iVhe0g+S5g=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr3106285jar.2.1560510922854;
 Fri, 14 Jun 2019 04:15:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190614111407.26725-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190614111407.26725-1-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 14 Jun 2019 13:15:11 +0200
Message-ID: <CAKv+Gu8SoEbsLyP5GWV+qX_F=z-yT67xdQJEeo2Vuaf2tt2+Qw@mail.gmail.com>
Subject: Re: [RFC PATCH] net: ipv4: move tcp_fastopen server side code to
 SipHash library
To:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(fix Eric's email address)

On Fri, 14 Jun 2019 at 13:14, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> Using a bare block cipher in non-crypto code is almost always a bad idea,
> not only for security reasons (and we've seen some examples of this in
> the kernel in the past), but also for performance reasons.
>
> In the TCP fastopen case, we call into the bare AES block cipher one or
> two times (depending on whether the connection is IPv4 or IPv6). On most
> systems, this results in a call chain such as
>
>   crypto_cipher_encrypt_one(ctx, dst, src)
>     crypto_cipher_crt(tfm)->cit_encrypt_one(crypto_cipher_tfm(tfm), ...);
>       aesni_encrypt
>         kernel_fpu_begin();
>         aesni_enc(ctx, dst, src); // asm routine
>         kernel_fpu_end();
>
> It is highly unlikely that the use of special AES instructions has a
> benefit in this case, especially since we are doing the above twice
> for IPv6 connections, instead of using a transform which can process
> the entire input in one go.
>
> We could switch to the cbcmac(aes) shash, which would at least get
> rid of the duplicated overhead in *some* cases (i.e., today, only
> arm64 has an accelerated implementation of cbcmac(aes), while x86 will
> end up using the generic cbcmac template wrapping the AES-NI cipher,
> which basically ends up doing exactly the above). However, in the given
> context, it makes more sense to use a light-weight MAC algorithm that
> is more suitable for the purpose at hand, such as SipHash.
>
> Since the output size of SipHash already matches our chosen value for
> TCP_FASTOPEN_COOKIE_SIZE, and given that it accepts arbitrary input
> sizes, this greatly simplifies the code as well.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> NOTE: This approach assumes that there are no external dependencies,
>       i.e., that there are no tools that implement the same algorithm
>       to calculate TCP fastopen cookies outside of the kernel.
>
>  include/linux/tcp.h     |  7 +--
>  include/net/tcp.h       |  1 -
>  net/ipv4/tcp_fastopen.c | 55 +++++++-------------
>  3 files changed, 19 insertions(+), 44 deletions(-)
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index 711361af9ce0..ce3319133632 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -58,12 +58,7 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
>
>  /* TCP Fast Open Cookie as stored in memory */
>  struct tcp_fastopen_cookie {
> -       union {
> -               u8      val[TCP_FASTOPEN_COOKIE_MAX];
> -#if IS_ENABLED(CONFIG_IPV6)
> -               struct in6_addr addr;
> -#endif
> -       };
> +       u64     val[TCP_FASTOPEN_COOKIE_MAX / sizeof(u64)];
>         s8      len;
>         bool    exp;    /* In RFC6994 experimental option format */
>  };
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index ac2f53fbfa6b..1630e61bd3e4 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1624,7 +1624,6 @@ bool tcp_fastopen_defer_connect(struct sock *sk, int *err);
>
>  /* Fastopen key context */
>  struct tcp_fastopen_context {
> -       struct crypto_cipher    *tfm;
>         __u8                    key[TCP_FASTOPEN_KEY_LENGTH];
>         struct rcu_head         rcu;
>  };
> diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
> index 018a48477355..4d3ccfa6b7ce 100644
> --- a/net/ipv4/tcp_fastopen.c
> +++ b/net/ipv4/tcp_fastopen.c
> @@ -7,6 +7,7 @@
>  #include <linux/tcp.h>
>  #include <linux/rcupdate.h>
>  #include <linux/rculist.h>
> +#include <linux/siphash.h>
>  #include <net/inetpeer.h>
>  #include <net/tcp.h>
>
> @@ -37,8 +38,7 @@ static void tcp_fastopen_ctx_free(struct rcu_head *head)
>  {
>         struct tcp_fastopen_context *ctx =
>             container_of(head, struct tcp_fastopen_context, rcu);
> -       crypto_free_cipher(ctx->tfm);
> -       kfree(ctx);
> +       kzfree(ctx);
>  }
>
>  void tcp_fastopen_destroy_cipher(struct sock *sk)
> @@ -76,23 +76,9 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
>         ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
>         if (!ctx)
>                 return -ENOMEM;
> -       ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
>
> -       if (IS_ERR(ctx->tfm)) {
> -               err = PTR_ERR(ctx->tfm);
> -error:         kfree(ctx);
> -               pr_err("TCP: TFO aes cipher alloc error: %d\n", err);
> -               return err;
> -       }
> -       err = crypto_cipher_setkey(ctx->tfm, key, len);
> -       if (err) {
> -               pr_err("TCP: TFO cipher key error: %d\n", err);
> -               crypto_free_cipher(ctx->tfm);
> -               goto error;
> -       }
>         memcpy(ctx->key, key, len);
>
> -
>         spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
>         if (sk) {
>                 q = &inet_csk(sk)->icsk_accept_queue.fastopenq;
> @@ -112,11 +98,14 @@ error:             kfree(ctx);
>  }
>
>  static bool __tcp_fastopen_cookie_gen(struct sock *sk, const void *path,
> -                                     struct tcp_fastopen_cookie *foc)
> +                                     int size, struct tcp_fastopen_cookie *foc)
>  {
>         struct tcp_fastopen_context *ctx;
>         bool ok = false;
>
> +       BUILD_BUG_ON(sizeof(siphash_key_t) != TCP_FASTOPEN_KEY_LENGTH);
> +       BUILD_BUG_ON(sizeof(u64) != TCP_FASTOPEN_COOKIE_SIZE);
> +
>         rcu_read_lock();
>
>         ctx = rcu_dereference(inet_csk(sk)->icsk_accept_queue.fastopenq.ctx);
> @@ -124,7 +113,7 @@ static bool __tcp_fastopen_cookie_gen(struct sock *sk, const void *path,
>                 ctx = rcu_dereference(sock_net(sk)->ipv4.tcp_fastopen_ctx);
>
>         if (ctx) {
> -               crypto_cipher_encrypt_one(ctx->tfm, foc->val, path);
> +               foc->val[0] = siphash(path, size, (siphash_key_t *)&ctx->key);
>                 foc->len = TCP_FASTOPEN_COOKIE_SIZE;
>                 ok = true;
>         }
> @@ -132,11 +121,8 @@ static bool __tcp_fastopen_cookie_gen(struct sock *sk, const void *path,
>         return ok;
>  }
>
> -/* Generate the fastopen cookie by doing aes128 encryption on both
> - * the source and destination addresses. Pad 0s for IPv4 or IPv4-mapped-IPv6
> - * addresses. For the longer IPv6 addresses use CBC-MAC.
> - *
> - * XXX (TFO) - refactor when TCP_FASTOPEN_COOKIE_SIZE != AES_BLOCK_SIZE.
> +/* Generate the fastopen cookie by applying SipHash to both the source and
> + * destination addresses.
>   */
>  static bool tcp_fastopen_cookie_gen(struct sock *sk,
>                                     struct request_sock *req,
> @@ -146,25 +132,20 @@ static bool tcp_fastopen_cookie_gen(struct sock *sk,
>         if (req->rsk_ops->family == AF_INET) {
>                 const struct iphdr *iph = ip_hdr(syn);
>
> -               __be32 path[4] = { iph->saddr, iph->daddr, 0, 0 };
> -               return __tcp_fastopen_cookie_gen(sk, path, foc);
> +               return __tcp_fastopen_cookie_gen(sk, &iph->saddr,
> +                                                sizeof(iph->saddr) +
> +                                                sizeof(iph->daddr),
> +                                                foc);
>         }
>
> -#if IS_ENABLED(CONFIG_IPV6)
> -       if (req->rsk_ops->family == AF_INET6) {
> +       if (IS_ENABLED(CONFIG_IPV6) && req->rsk_ops->family == AF_INET6) {
>                 const struct ipv6hdr *ip6h = ipv6_hdr(syn);
> -               struct tcp_fastopen_cookie tmp;
> -
> -               if (__tcp_fastopen_cookie_gen(sk, &ip6h->saddr, &tmp)) {
> -                       struct in6_addr *buf = &tmp.addr;
> -                       int i;
>
> -                       for (i = 0; i < 4; i++)
> -                               buf->s6_addr32[i] ^= ip6h->daddr.s6_addr32[i];
> -                       return __tcp_fastopen_cookie_gen(sk, buf, foc);
> -               }
> +               return __tcp_fastopen_cookie_gen(sk, &ip6h->saddr,
> +                                                sizeof(ip6h->saddr) +
> +                                                sizeof(ip6h->daddr),
> +                                                foc);
>         }
> -#endif
>         return false;
>  }
>
> --
> 2.20.1
>
