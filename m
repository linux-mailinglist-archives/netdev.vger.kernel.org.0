Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB756E6C93
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjDRTEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjDRTEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:04:46 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690A719A2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 12:04:45 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id x8so12356791uau.9
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 12:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681844684; x=1684436684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuOF8fEXtz00ku5ArqvkynU3NIVBn3OKtTM0c0zZvX4=;
        b=RFZhMUsmbmuQeiFNdg6JGjCpm/p6DVqHP/+9QG5/XxAJupuc5mYzpJxXVpNGR6d+Il
         gfxbt0p5444ERIEnKaeDrgq6sOx7F6a52p6bmdk+iYOOAGH2dfTaYdDrQjwG1dfYItkh
         mSMkvvNX/5IYZIyLdyGqzDsv/9uf2U9vTpvr+2hPlcAafbXAn61hSRWZeHNW7SmFuiUG
         qNnwpJZEEc1KjKzqswqFIaY+fsQkoJEv/446kENpmAgbZs2bC4g5biZRbmT84uh8nNv3
         qcpC4dFLJJvHf7jDR5ZI+4NEAHDBaiFPVgN0yDDE7FABxTQXPtMuA4AOI8waklbmSAhl
         HCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681844684; x=1684436684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EuOF8fEXtz00ku5ArqvkynU3NIVBn3OKtTM0c0zZvX4=;
        b=PFSDYppfqPMuC9ISzTQL066jeN+c0rcY+0SJh1/smFEwas1J2YmFHlEddT7o45Pux8
         TWEZKVAePENNgtEyoR+EddC+2di4nqBXFypNRGKCnjiAYCxsE3icIyGtm8E89hrr/1HK
         5irbqrmqgGgRRyHBmUXlvgGMvFAwkuV9t9XqHuzKdFpQbU3BPMq2FUKaZ63PAK/7dTqK
         UH02925zriphJd4zHg0m/Y2zqxORRIbJyQTdkAKEPuOf7snFdTMj7pp55IiX4vVUoaeV
         rwiz8XFBRXaX5MPu4XgFTINXp+6DgCGfcMId7hhDGdEd4kUzXjNXDWc5QKvTg0WpESox
         wxOA==
X-Gm-Message-State: AAQBX9f2iOmRdQQDrh+xdqvRDVqS9Y7ZX0IhtkjFIDO/bENlX2p5ef0T
        6pVT7zbO+WN3FjVoSAigoQUiDNysaOIf08HMYVwn/w==
X-Google-Smtp-Source: AKy350alU9r4uk85Nw2uhL7x3GzP3bWXvvLJv92ES2wbabxe+yLtMOE+blAUFMVWuug4YDqfR2/f3CDCU76oPlZjWi4=
X-Received: by 2002:a1f:1943:0:b0:43f:cad6:2874 with SMTP id
 64-20020a1f1943000000b0043fcad62874mr10184370vkz.1.1681844684239; Tue, 18 Apr
 2023 12:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+y=vdj5p_BRSRPYoY+Bdp3vrdPSB=DyCbikHw37q80ww@mail.gmail.com>
 <20230418184413.85516-1-kuniyu@amazon.com>
In-Reply-To: <20230418184413.85516-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Apr 2023 21:04:32 +0200
Message-ID: <CANn89iJ3MhBYtU3vCNjLLo45tu3eyp4TbJBGP1t8yxarK2Sziw@mail.gmail.com>
Subject: Re: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with
 TX timestamp.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller@googlegroups.com, willemb@google.com
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

On Tue, Apr 18, 2023 at 8:44=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> From:   Eric Dumazet <edumazet@google.com>
> Date:   Tue, 18 Apr 2023 20:33:44 +0200
> > On Tue, Apr 18, 2023 at 8:09=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazo=
n.com> wrote:
> > >
> > > syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> > > skbs.  We can reproduce the problem with these sequences:
> > >
> > >   sk =3D socket(AF_INET, SOCK_DGRAM, 0)
> > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFT=
WARE)
> > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > >   sk.close()
> > >
> > > sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> > > ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
> > > skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> > > the socket's error queue with the TX timestamp.
> > >
> > > When the original skb is received locally, skb_copy_ubufs() calls
> > > skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt=
.
> > > This additional count is decremented while freeing the skb, but struc=
t
> > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
> > > not called.
> > >
> > > The last refcnt is not released unless we retrieve the TX timestamped
> > > skb by recvmsg().  When we close() the socket holding such skb, we
> > > never call sock_put() and leak the count, skb, and sk.
> > >
> > > To avoid this problem, we must (i) call skb_queue_purge() after
> > > flagging SOCK_DEAD during close() and (ii) make sure that TX tstamp
> > > skb is not queued when SOCK_DEAD is flagged.  UDP lacks (i) and (ii),
> > > and TCP lacks (ii).
> > >
> > > Without (ii), a skb queued in a qdisc or device could be put into
> > > the error queue after skb_queue_purge().
> > >
> > >   sendmsg() /* return immediately, but packets
> > >              * are queued in a qdisc or device
> > >              */
> > >                                     close()
> > >                                       skb_queue_purge()
> > >   __skb_tstamp_tx()
> > >     __skb_complete_tx_timestamp()
> > >       sock_queue_err_skb()
> > >         skb_queue_tail()
> > >
> > > Also, we need to check SOCK_DEAD under sk->sk_error_queue.lock
> > > in sock_queue_err_skb() to avoid this race.
> > >
> > >   if (!sock_flag(sk, SOCK_DEAD))
> > >                                     sock_set_flag(sk, SOCK_DEAD)
> > >                                     skb_queue_purge()
> > >
> > >     skb_queue_tail()
> > >
> > > [0]:
> >
> > > Fixes: f214f915e7db ("tcp: enable MSG_ZEROCOPY")
> > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > ---
> > > v2:
> > >   * Move skb_queue_purge() after setting SOCK_DEAD in udp_destroy_soc=
k()
> > >   * Check SOCK_DEAD in sock_queue_err_skb() with sk_error_queue.lock
> > >   * Add Fixes tag for TCP
> > >
> > > v1: https://lore.kernel.org/netdev/20230417171155.22916-1-kuniyu@amaz=
on.com/
> > > ---
> > >  net/core/skbuff.c | 15 ++++++++++++---
> > >  net/ipv4/udp.c    |  5 +++++
> > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 4c0879798eb8..287b834df9c8 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buff *s=
kb)
> > >   */
> > >  int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
> > >  {
> > > +       unsigned long flags;
> > > +
> > >         if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=3D
> > >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> > >                 return -ENOMEM;
> > > @@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, struct=
 sk_buff *skb)
> > >         /* before exiting rcu section, make sure dst is refcounted */
> > >         skb_dst_force(skb);
> > >
> > > -       skb_queue_tail(&sk->sk_error_queue, skb);
> > > -       if (!sock_flag(sk, SOCK_DEAD))
> > > -               sk_error_report(sk);
> > > +       spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
> > > +       if (sock_flag(sk, SOCK_DEAD)) {
> >
> > SOCK_DEAD is set without holding sk_error_queue.lock, so I wonder why y=
ou
> > want to add a confusing construct.
> >
> > Just bail early ?
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index ef81452759be3fd251faaf76d89cfd002ee79256..fda05cb44f95821e98f8c5c=
05fba840a9d276abb
> > 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -4983,6 +4983,9 @@ int sock_queue_err_skb(struct sock *sk, struct
> > sk_buff *skb)
> >             (unsigned int)READ_ONCE(sk->sk_rcvbuf))
> >                 return -ENOMEM;
> >
> > +       if (sock_flag(sk, SOCK_DEAD))
> > +               return -EINVAL;
> > +
>
> Isn't it possible that these sequences happen
>
>   close()
>     sock_set_flag(sk, SOCK_DEAD);
>     skb_queue_purge(&sk->sk_error_queue)
>
> between the skb_queue_tail() below ? (2nd race mentioned in changelog)
>
> I thought we can guarantee the ordering by taking the same lock.
>

This is fragile.

We could very well rewrite skb_queue_purge() to not acquire the lock
in the common case.
I had the following in my tree for a while, to avoid many atomic and
irq masking operations...

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ef81452759be3fd251faaf76d89cfd002ee79256..f570e7c89248e2d9d9ab50c2e86=
ac7019b837484
100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3606,14 +3606,24 @@ EXPORT_SYMBOL(skb_dequeue_tail);
  *     skb_queue_purge - empty a list
  *     @list: list to empty
  *
- *     Delete all buffers on an &sk_buff list. Each buffer is removed from
- *     the list and one reference dropped. This function takes the list
- *     lock and is atomic with respect to other list locking functions.
+ *     Delete all buffers on an &sk_buff list.
  */
 void skb_queue_purge(struct sk_buff_head *list)
 {
+       struct sk_buff_head priv;
+       unsigned long flags;
        struct sk_buff *skb;
-       while ((skb =3D skb_dequeue(list)) !=3D NULL)
+
+       if (skb_queue_empty_lockless(list))
+               return;
+
+       __skb_queue_head_init(&priv);
+
+       spin_lock_irqsave(&list->lock, flags);
+       skb_queue_splice_init(list, &priv);
+       spin_unlock_irqrestore(&list->lock, flags);
+
+       while ((skb =3D __skb_dequeue(&priv)) !=3D NULL)
                kfree_skb(skb);
 }
 EXPORT_SYMBOL(skb_queue_purge);
