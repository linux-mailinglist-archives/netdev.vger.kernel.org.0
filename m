Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127BE6E6C20
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjDRSeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDRSd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:33:59 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE8359FE
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 11:33:57 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id dl6so14101913vsb.7
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 11:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681842836; x=1684434836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPq+fzjJqrxlSML+/NoVX0XV7Ohlp1ClzsoWWs/ufVc=;
        b=LQAVrwo37EDHHba8SZDWchNeJNmLq68lZbVGShOBlV79mHkPwy92tYq1tRedFrrKj+
         DvlI8twyc1ECzQqD5nb9Sj4/rmh5U5do/MmzTkfF5iHA/Q02N5ZbFaAX09pI91FWFaPq
         UPMILWSZj/gMgYW8ZCfS+9dbEgiVR2nGra1eIjHgTYo27wXisnbZW0MZ2yIh1F4zy85Z
         ho1mFEIcnwNfnBewDiLKuZrWosi2mZtpSHuuT0XxpeKSHIy7YX/C7W/tkZWdKwakh+7Q
         8DsUzB92IxWdiUyqM3racMTjo4TjchQAOOFWGi3rrfBkpMQAmDZ930KKkpwKfvOsgTEw
         h2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681842836; x=1684434836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VPq+fzjJqrxlSML+/NoVX0XV7Ohlp1ClzsoWWs/ufVc=;
        b=mAT0azG3IoUhUV1Y5zaYgb5ogoJGI6WVYQkhGsP9AfzvoRJYqVnVrkdJo+sgaFI/65
         5dar7EGQR7ND+LI/nifLqLQzBkKEKgYFJ70YfN85RpKxGO/FWaM3UCMXTKuFekrJv4Rq
         TZail4FhVS2mUlF9VV/iaCDKB1g3/Af6udenWE59o+LGtUmxpiMe6TiU7Isy0Atmk3UH
         gd6UCc51m4xzHfv7lP1otdWKjea7Yq7WTjJG5fIblniTIeYFOFq4ZnlK5yyIcgVnneUR
         Jtbir0Jkkc+xb9DZx2Fw5YG/L1j4gqNnDzsureyEjIvtNbgCix2f1fvMZf3RkhpZfN52
         3bGQ==
X-Gm-Message-State: AAQBX9fOMPQBneKFHgyg3KjW0HLqJkNNHvwEtfXMAPU80wkarFo9KuHM
        MLnbBHDOg4o/SFkD4LvxGc7pH00AooFP0CjUJ084+MayGYHZmiDREyur1DQT
X-Google-Smtp-Source: AKy350bhqhJebZj1OlR46EOHtIP7ZBuOEsNsys6O1oWEphrZaxrQyN9h+MHx6o1D9GQAFhq9u1fGLbJNI94SLLUs9sY=
X-Received: by 2002:a67:d591:0:b0:42e:6005:2b1d with SMTP id
 m17-20020a67d591000000b0042e60052b1dmr6851843vsj.7.1681842836253; Tue, 18 Apr
 2023 11:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230418180832.81430-1-kuniyu@amazon.com>
In-Reply-To: <20230418180832.81430-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Apr 2023 20:33:44 +0200
Message-ID: <CANn89i+y=vdj5p_BRSRPYoY+Bdp3vrdPSB=DyCbikHw37q80ww@mail.gmail.com>
Subject: Re: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with
 TX timestamp.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 8:09=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> skbs.  We can reproduce the problem with these sequences:
>
>   sk =3D socket(AF_INET, SOCK_DGRAM, 0)
>   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE=
)
>   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
>   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
>   sk.close()
>
> sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
> skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> the socket's error queue with the TX timestamp.
>
> When the original skb is received locally, skb_copy_ubufs() calls
> skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt.
> This additional count is decremented while freeing the skb, but struct
> ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
> not called.
>
> The last refcnt is not released unless we retrieve the TX timestamped
> skb by recvmsg().  When we close() the socket holding such skb, we
> never call sock_put() and leak the count, skb, and sk.
>
> To avoid this problem, we must (i) call skb_queue_purge() after
> flagging SOCK_DEAD during close() and (ii) make sure that TX tstamp
> skb is not queued when SOCK_DEAD is flagged.  UDP lacks (i) and (ii),
> and TCP lacks (ii).
>
> Without (ii), a skb queued in a qdisc or device could be put into
> the error queue after skb_queue_purge().
>
>   sendmsg() /* return immediately, but packets
>              * are queued in a qdisc or device
>              */
>                                     close()
>                                       skb_queue_purge()
>   __skb_tstamp_tx()
>     __skb_complete_tx_timestamp()
>       sock_queue_err_skb()
>         skb_queue_tail()
>
> Also, we need to check SOCK_DEAD under sk->sk_error_queue.lock
> in sock_queue_err_skb() to avoid this race.
>
>   if (!sock_flag(sk, SOCK_DEAD))
>                                     sock_set_flag(sk, SOCK_DEAD)
>                                     skb_queue_purge()
>
>     skb_queue_tail()
>
> [0]:

> Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> v2:
>   * Move skb_queue_purge() after setting SOCK_DEAD in udp_destroy_sock()
>   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_queue.lock
>   * Add Fixes tag for TCP
>
> v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kuniyu@amazon.c=
om/
> ---
>  net/core/skbuff.c | 15 ++++++++++++---
>  net/ipv4/udp.c    |  5 +++++
>  2 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4c0879798eb8..287b834df9c8 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buff *skb)
>   */
>  int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
>  {
> +       unsigned long flags;
> +
>         if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=3D
>             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
>                 return -ENOMEM;
> @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, struct sk_=
buff *skb)
>         /* before exiting rcu section, make sure dst is refcounted */
>         skb_dst_force(skb);
>
> -       skb_queue_tail(&sk->sk_error_queue, skb);
> -       if (!sock_flag(sk, SOCK_DEAD))
> -               sk_error_report(sk);
> +       spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
> +       if (sock_flag(sk, SOCK_DEAD)) {

SOCK_DEAD is set without holding sk_error_queue.lock, so I wonder why you
want to add a confusing construct.

Just bail early ?

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ef81452759be3fd251faaf76d89cfd002ee79256..fda05cb44f95821e98f8c5c05fb=
a840a9d276abb
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4983,6 +4983,9 @@ int sock_queue_err_skb(struct sock *sk, struct
sk_buff *skb)
            (unsigned int)READ_ONCE(sk->sk_rcvbuf))
                return -ENOMEM;

+       if (sock_flag(sk, SOCK_DEAD))
+               return -EINVAL;
+
        skb_orphan(skb);
        skb->sk =3D sk;
        skb->destructor =3D sock_rmem_free;
@@ -4993,8 +4996,7 @@ int sock_queue_err_skb(struct sock *sk, struct
sk_buff *skb)
        skb_dst_force(skb);

        skb_queue_tail(&sk->sk_error_queue, skb);
-       if (!sock_flag(sk, SOCK_DEAD))
-               sk_error_report(sk);
+       sk_error_report(sk);
        return 0;
 }
 EXPORT_SYMBOL(sock_queue_err_skb);


> +               spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
> +               return -EINVAL;
> +       }
> +       __skb_queue_tail(&sk->sk_error_queue, skb);
> +       spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
> +
> +       sk_error_report(sk);
> +
>         return 0;
>  }
>  EXPORT_SYMBOL(sock_queue_err_skb);
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index c605d171eb2d..7060a5cda711 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2674,6 +2674,11 @@ void udp_destroy_sock(struct sock *sk)
>                 if (up->encap_enabled)
>                         static_branch_dec(&udp_encap_needed_key);
>         }
> +
> +       /* A zerocopy skb has a refcnt of sk and may be
> +        * put into sk_error_queue with TX timestamp
> +        */
> +       skb_queue_purge(&sk->sk_error_queue);
>  }
>
>  /*
> --
> 2.30.2
>
