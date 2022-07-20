Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E770457B310
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbiGTIhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiGTIhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:37:20 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7A04E621
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:37:14 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-31e560aa854so54221697b3.6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=scLMFAqTrMRHPHLKXgqI6VJc+q74hWtmCpjHzQ9gZME=;
        b=lmcWDXCzWaIXrU4su+XpGcYnEJMU2rkxnboVTZnIQ/XYqGKR5oBQUpVxn4fXJy2P3n
         b5iEqlLblN5jifoWqlslM6a+LbVS8vAkTHtxzaeyIvKSrnMXzpSvcF+3sVFfQ36U38Uv
         kR7Exowae3nJ4/d4Us1BdQtRG9+2vJG1wLtOwHDvPTheHxSrrLMNk0mwz661QSrF5uKZ
         PyYGpAtBLWZqrnPWlpbcW78F12XF3eiIqVXPpclkwADk2bLgCpHqPvfGBAcxVZojiF20
         qWHWZtylC9pOUpjpQUxCN91AJS9ETknVRcl5UL46epabd5nk6FSxJkgsVTnT4y1lwav6
         2Kbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=scLMFAqTrMRHPHLKXgqI6VJc+q74hWtmCpjHzQ9gZME=;
        b=QJ2ngisAb8JEQUymc3ucbTKeZJng2l2Tep+CeeulP+8ccreNaEoPlssv0d/K0HJpsu
         xZNFYhXnEp+BzxEKZKj5zC+SdBPqAt5GAIIjXvnrX+H+Ne+1y/rESxYDXw9aM1bpGHSl
         4RB177bK7okCTgfefcuIha7F5cF8vXFyDsrf75ufIypFw3WbOTJ9us7NU1V+Ouvbskdj
         YV/B8z5KznTDxFe8po1If2+dbgjy5QNBZPS1gMAONJYIC8bCQyyMWyS33Me+5v8avaW4
         BEanDgVX07HbAE/TOcTB3mXb3e6el2pyI46P3GjqTmxlVEtE/Zie9ljtP7zD8TvYZ3nc
         y7sQ==
X-Gm-Message-State: AJIora9eNSNgMy9vPwgatxF+I3mUbs+fGSpgjF4cC8V27/+Yvh/fYPn2
        tYMMqTAR7pT9MY8Me9V3HI0C+gK91eK7Q9MbOwjQ6g==
X-Google-Smtp-Source: AGRyM1uToWZ4XCb744SkD4lKYZ4rTdp+neoxEfC994mSH/v6vSjpVFj1Ab2OBJT2S1npbl5uSfFF/WQmnQ7jAjT9LE4=
X-Received: by 2002:a05:690c:730:b0:31e:6237:533e with SMTP id
 bt16-20020a05690c073000b0031e6237533emr5709940ywb.55.1658306233842; Wed, 20
 Jul 2022 01:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220715052235.1452170-1-kuba@kernel.org> <20220715052235.1452170-2-kuba@kernel.org>
In-Reply-To: <20220715052235.1452170-2-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Jul 2022 10:37:02 +0200
Message-ID: <CANn89iLtDU+w=5bb89Om5FGx6MrQwsDBQKp8UL6=O21wS0LFqw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 01/11] tls: rx: allow only one reader at a time
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, vfedorenko@novek.ru
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 7:22 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> recvmsg() in TLS gets data from the skb list (rx_list) or fresh
> skbs we read from TCP via strparser. The former holds skbs which were
> already decrypted for peek or decrypted and partially consumed.
>
> tls_wait_data() only notices appearance of fresh skbs coming out
> of TCP (or psock). It is possible, if there is a concurrent call
> to peek() and recv() that the peek() will move the data from input
> to rx_list without recv() noticing. recv() will then read data out
> of order or never wake up.
>
> This is not a practical use case/concern, but it makes the self
> tests less reliable. This patch solves the problem by allowing
> only one reader in.
>
> Because having multiple processes calling read()/peek() is not
> normal avoid adding a lock and try to fast-path the single reader
> case.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/tls.h |  3 +++
>  net/tls/tls_sw.c  | 61 +++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 57 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/tls.h b/include/net/tls.h
> index 8742e13bc362..e8935cfe0cd6 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -116,11 +116,14 @@ struct tls_sw_context_rx {
>         void (*saved_data_ready)(struct sock *sk);
>
>         struct sk_buff *recv_pkt;
> +       u8 reader_present;
>         u8 async_capable:1;
>         u8 zc_capable:1;
> +       u8 reader_contended:1;
>         atomic_t decrypt_pending;
>         /* protect crypto_wait with decrypt_pending*/
>         spinlock_t decrypt_compl_lock;
> +       struct wait_queue_head wq;
>  };
>
>  struct tls_record_info {
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 68d79ee48a56..761a63751616 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1753,6 +1753,51 @@ tls_read_flush_backlog(struct sock *sk, struct tls_prot_info *prot,
>         sk_flush_backlog(sk);
>  }
>
> +static long tls_rx_reader_lock(struct sock *sk, struct tls_sw_context_rx *ctx,
> +                              bool nonblock)
> +{
> +       long timeo;
> +
> +       lock_sock(sk);
> +
> +       timeo = sock_rcvtimeo(sk, nonblock);
> +
> +       while (unlikely(ctx->reader_present)) {
> +               DEFINE_WAIT_FUNC(wait, woken_wake_function);
> +
> +               ctx->reader_contended = 1;
> +
> +               add_wait_queue(&ctx->wq, &wait);
> +               sk_wait_event(sk, &timeo,
> +                             !READ_ONCE(ctx->reader_present), &wait);
> +               remove_wait_queue(&ctx->wq, &wait);
> +
> +               if (!timeo)
> +                       return -EAGAIN;

We return with socket lock held, and callers seem to not release the lock.

> +               if (signal_pending(current))
> +                       return sock_intr_errno(timeo);

same here.

Let's wait for syzbot to catch up :)

> +       }
> +
> +       WRITE_ONCE(ctx->reader_present, 1);
> +
> +       return timeo;
> +}
> +
> +static void tls_rx_reader_unlock(struct sock *sk, struct tls_sw_context_rx *ctx)
> +{
> +       if (unlikely(ctx->reader_contended)) {
> +               if (wq_has_sleeper(&ctx->wq))
> +                       wake_up(&ctx->wq);
> +               else
> +                       ctx->reader_contended = 0;
> +
> +               WARN_ON_ONCE(!ctx->reader_present);
> +       }
> +
> +       WRITE_ONCE(ctx->reader_present, 0);
> +       release_sock(sk);
> +}
> +
>  int tls_sw_recvmsg(struct sock *sk,
>                    struct msghdr *msg,
>                    size_t len,
> @@ -1782,7 +1827,9 @@ int tls_sw_recvmsg(struct sock *sk,
>                 return sock_recv_errqueue(sk, msg, len, SOL_IP, IP_RECVERR);
>
>         psock = sk_psock_get(sk);
> -       lock_sock(sk);
> +       timeo = tls_rx_reader_lock(sk, ctx, flags & MSG_DONTWAIT);
> +       if (timeo < 0)
> +               return timeo;
>         bpf_strp_enabled = sk_psock_strp_enabled(psock);
>
>         /* If crypto failed the connection is broken */
> @@ -1801,7 +1848,6 @@ int tls_sw_recvmsg(struct sock *sk,
>
>         target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
>         len = len - copied;
> -       timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>
>         zc_capable = !bpf_strp_enabled && !is_kvec && !is_peek &&
>                 ctx->zc_capable;
> @@ -1956,7 +2002,7 @@ int tls_sw_recvmsg(struct sock *sk,
>         copied += decrypted;
>
>  end:
> -       release_sock(sk);
> +       tls_rx_reader_unlock(sk, ctx);
>         if (psock)
>                 sk_psock_put(sk, psock);
>         return copied ? : err;
> @@ -1978,9 +2024,9 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
>         long timeo;
>         int chunk;
>
> -       lock_sock(sk);
> -
> -       timeo = sock_rcvtimeo(sk, flags & SPLICE_F_NONBLOCK);
> +       timeo = tls_rx_reader_lock(sk, ctx, flags & SPLICE_F_NONBLOCK);
> +       if (timeo < 0)
> +               return timeo;
>
>         from_queue = !skb_queue_empty(&ctx->rx_list);
>         if (from_queue) {
> @@ -2029,7 +2075,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
>         }
>
>  splice_read_end:
> -       release_sock(sk);
> +       tls_rx_reader_unlock(sk, ctx);
>         return copied ? : err;
>  }
>
> @@ -2371,6 +2417,7 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
>         } else {
>                 crypto_init_wait(&sw_ctx_rx->async_wait);
>                 spin_lock_init(&sw_ctx_rx->decrypt_compl_lock);
> +               init_waitqueue_head(&sw_ctx_rx->wq);
>                 crypto_info = &ctx->crypto_recv.info;
>                 cctx = &ctx->rx;
>                 skb_queue_head_init(&sw_ctx_rx->rx_list);
> --
> 2.36.1
>
