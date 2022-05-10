Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E98DE5223F0
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348907AbiEJS1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348928AbiEJS1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:27:32 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29C920CA71;
        Tue, 10 May 2022 11:27:29 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id r11so32244108ybg.6;
        Tue, 10 May 2022 11:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3OCqh2mYw3QgKC672idPhEd0r2B5dkUy1mPsWmu3c0M=;
        b=Ua5OFgDEuo3cHD6zZ21i2W1A0HC0JN4bP173Uys+Yxx1BJ6ZtM5cxORccSSrqRekFQ
         oqjLh1UvfjSyC9+hCUHwPrpweJoqt1G5QXRSgBW/7VrIJ4T1AN9PqZ1FubLgK86gN3O2
         vya8fCgvPwFXf9L9j4MZmjcUsOLyjkWTc1sRWI2PRUZgIdb+NsdHbQAkuqSe9FIgncUK
         73AUjLogdpoZaWnsFN4+H4p0QKqsXBTfZYLzqb+x/jJEnBzX64vh9NWzjcgpCPvuRHuK
         WlFKB1dEXTauPx0+aEaqpgz484VAzKG2ybl30WUqJ31dzAqTIoi8TVCfdaEAzjOwB2T4
         snUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3OCqh2mYw3QgKC672idPhEd0r2B5dkUy1mPsWmu3c0M=;
        b=uKagxpvVbkQRKTQfAJb5hS27cICii3ZI4iysg8ForvQSNwIPuMLTJVHiMPEgAJY7KH
         JxBF3RkTyWCXTPpg3ZJ702Qn6bkxUu9GvaHtfa9sueCxmmfPOVi2SI3O7Dnlv569aWVx
         E+/Ikl71Ge1nemRLE49Mu6WAWZGnpxS1X2nvuCLvBdcNsJtivo6YYF2V+2EjDPcWuP4h
         OSS0eOdda/a6yOXx3zIAUAA0OcGw8mRby1fadL/7VQePuE8/4BjgV7aFXEN+Kyp8lV65
         8kqnavtX+4OmXGlWCsyeywWIz9O7uHQG8di09hkb2+RjFIE8L1WHE9cybJXt9cBZQA+d
         65aA==
X-Gm-Message-State: AOAM532ZoAX2f0PcspYpXJXnzNVeNdzuANej68VE65PLv+AXTj4Jydp3
        8yrtmJRaUUa/dm7kZk73Cw4yEFfx8E6/2kF4Nao=
X-Google-Smtp-Source: ABdhPJwizLNqI3hm3knnTmifDlWtRxuUFS4vudYH6d0lzSHBO51Va1gNEtHy8p7z2NneXBdResWsBIC5gjJWslpiYoM=
X-Received: by 2002:a25:848d:0:b0:648:961b:5c2b with SMTP id
 v13-20020a25848d000000b00648961b5c2bmr19485318ybk.41.1652207249018; Tue, 10
 May 2022 11:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220502182345.306970-1-xiyou.wangcong@gmail.com>
 <20220502182345.306970-2-xiyou.wangcong@gmail.com> <CANn89i+fXaDBptNMYjUqKhAuZrRX7+0v7sv5DZqK4seLCzBO3A@mail.gmail.com>
In-Reply-To: <CANn89i+fXaDBptNMYjUqKhAuZrRX7+0v7sv5DZqK4seLCzBO3A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 May 2022 11:27:18 -0700
Message-ID: <CAM_iQpXbkk00C4h8HJsDkTGC3aem9yj0xQQ6W=iYRc8C0k-7=Q@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 1/4] tcp: introduce tcp_read_skb()
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 2, 2022 at 5:02 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, May 2, 2022 at 11:24 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This patch inroduces tcp_read_skb() based on tcp_read_sock(),
> > a preparation for the next patch which actually introduces
> > a new sock ops.
> >
> > TCP is special here, because it has tcp_read_sock() which is
> > mainly used by splice(). tcp_read_sock() supports partial read
> > and arbitrary offset, neither of them is needed for sockmap.
> >
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/net/tcp.h |  2 ++
> >  net/ipv4/tcp.c    | 63 +++++++++++++++++++++++++++++++++++++++++------
> >  2 files changed, 57 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > index 94a52ad1101c..ab7516e5cc56 100644
> > --- a/include/net/tcp.h
> > +++ b/include/net/tcp.h
> > @@ -667,6 +667,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
> >  /* Read 'sendfile()'-style from a TCP socket */
> >  int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >                   sk_read_actor_t recv_actor);
> > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > +                sk_read_actor_t recv_actor);
> >
> >  void tcp_initialize_rcv_mss(struct sock *sk);
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index db55af9eb37b..8d48126e3694 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1600,7 +1600,7 @@ static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
> >         __kfree_skb(skb);
> >  }
> >
> > -static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
> > +static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off, bool unlink)
> >  {
> >         struct sk_buff *skb;
> >         u32 offset;
> > @@ -1613,6 +1613,8 @@ static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
> >                 }
> >                 if (offset < skb->len || (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)) {
> >                         *off = offset;
> > +                       if (unlink)
> > +                               __skb_unlink(skb, &sk->sk_receive_queue);
>
> Why adding this @unlink parameter ?
> This makes your patch more invasive than needed.
> Can not this unlink happen from your new helper instead ? See [3] later.

Good point, I was trying to reuse the code there, but it is just one
__skb_unlink().

>
> >                         return skb;
> >                 }
> >                 /* This looks weird, but this can happen if TCP collapsing
> > @@ -1646,7 +1648,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >
> >         if (sk->sk_state == TCP_LISTEN)
> >                 return -ENOTCONN;
> > -       while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
> > +       while ((skb = tcp_recv_skb(sk, seq, &offset, false)) != NULL) {
> >                 if (offset < skb->len) {
> >                         int used;
> >                         size_t len;
> > @@ -1677,7 +1679,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >                          * getting here: tcp_collapse might have deleted it
> >                          * while aggregating skbs from the socket queue.
> >                          */
> > -                       skb = tcp_recv_skb(sk, seq - 1, &offset);
> > +                       skb = tcp_recv_skb(sk, seq - 1, &offset, false);
> >                         if (!skb)
> >                                 break;
> >                         /* TCP coalescing might have appended data to the skb.
> > @@ -1702,13 +1704,58 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
> >
> >         /* Clean up data we have read: This will do ACK frames. */
> >         if (copied > 0) {
> > -               tcp_recv_skb(sk, seq, &offset);
> > +               tcp_recv_skb(sk, seq, &offset, false);
> >                 tcp_cleanup_rbuf(sk, copied);
> >         }
> >         return copied;
> >  }
> >  EXPORT_SYMBOL(tcp_read_sock);
> >
> > +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> > +                sk_read_actor_t recv_actor)
> > +{
> > +       struct tcp_sock *tp = tcp_sk(sk);
> > +       u32 seq = tp->copied_seq;
> > +       struct sk_buff *skb;
> > +       int copied = 0;
> > +       u32 offset;
> > +
> > +       if (sk->sk_state == TCP_LISTEN)
> > +               return -ENOTCONN;
> > +
> > +       while ((skb = tcp_recv_skb(sk, seq, &offset, true)) != NULL) {
>
> [3]
>             The unlink from sk->sk_receive_queue could happen here.

Right.

>
> > +               int used = recv_actor(desc, skb, 0, skb->len);
> > +
> > +               if (used <= 0) {
> > +                       if (!copied)
> > +                               copied = used;
> > +                       break;
> > +               }
> > +               seq += used;
> > +               copied += used;
> > +
> > +               if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> > +                       kfree_skb(skb);
>
> [1]
>
> The two kfree_skb() ([1] & [2]) should be a consume_skb() ?

Hm, it is tricky here, we use the skb refcount after this patchset, so
it could be a real drop from another kfree_skb() in net/core/skmsg.c
which initiates the drop.

Thanks.
