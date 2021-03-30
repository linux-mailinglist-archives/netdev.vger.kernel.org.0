Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC7734E0BC
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 07:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhC3FjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 01:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhC3FjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 01:39:19 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E98BC061762;
        Mon, 29 Mar 2021 22:39:18 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c204so11397759pfc.4;
        Mon, 29 Mar 2021 22:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IHkI6fler+gKZzpEPqKqZABFTS9siFIBbIyAmA4FHaQ=;
        b=Kl5DSletUESY3OArfu+XFFljjiyKxOrjfsepKHL3JMSIX5st/CrBlnxTVvPz5aKweB
         CKvCYc6PkMMmJ1CI8PyPC2LyUIwRooYO5hCoYej/Bimz4jyjYkywkeLA29tIUHt7wW0E
         BI0Ki6Errkkq52h01LOHgzWNoSFt0zjXsdiBfwzeaIHWy6D6CiRqrciKrj/c2PI/k3sZ
         3EjPDkmdqMv4qCG42y1Bb45pi6bPGz+6XxEYf6TMm7ev1mSHY1K9HKWG8rp80nblzlFp
         VDu70jyAZmMYMXuchlaVMWTo5bRlnIlyljEjgkS0veTBmOr7rkzokj8ctwF9z9ovUgsB
         kcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IHkI6fler+gKZzpEPqKqZABFTS9siFIBbIyAmA4FHaQ=;
        b=R1DljIiprZi/VbeyE0LX181OPKGT3xaHpk5yck6WaKkTbRNVFZ6pmb9ImXxcHSK098
         12lhsLZrFwWLQ6yNEcRF2wKrWmpI+8yPAtlSBgfldeUaOERqEixvkveHEJc2YHM/v3/W
         4uu4Kw2Nb00oyGKjeQrIViOH9/uzvyCvBXz7nsFz3eNDqbZgMptZaSU2oiP8f7R4gG8M
         fSaTEMK/VcslIq9MWKGnx/SZuBxs6D7Z3BqVn/Y0atZ5oSE7LOFRspsTsSpLa7piHTLb
         CIAF5kml8ST2RgG84AFyeM/h1sPqoa2pEwbKxDF62qpdbo5EPFhTc8qBwYnD8oo+Bo0Z
         IuCQ==
X-Gm-Message-State: AOAM530P6it5yZQJfMnyPET0wXZsLXJ2ZQNoK8yc2q6+pkNM52oIUlTJ
        fE/GeSeCoIAdXjOTCkgyzB/luUCTWeRu1lLa/bA=
X-Google-Smtp-Source: ABdhPJz9fKj5DhRKuwZCvkeFi7yOGIwoP3zSHEk7RgYkoo59iKUWPnatcuBpUfL+/7C0JfDTq/UZ7DvChyrzvJvU450=
X-Received: by 2002:a63:6a41:: with SMTP id f62mr14388647pgc.428.1617082758076;
 Mon, 29 Mar 2021 22:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-10-xiyou.wangcong@gmail.com> <60623e6fdd870_401fb20818@john-XPS-13-9370.notmuch>
In-Reply-To: <60623e6fdd870_401fb20818@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 29 Mar 2021 22:39:06 -0700
Message-ID: <CAM_iQpVgdP1w73skJ3W-MHkO-pPVKT7WM06Fqc35XkXjDcWf_Q@mail.gmail.com>
Subject: Re: [Patch bpf-next v7 09/13] udp: implement ->read_sock() for sockmap
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 1:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This is similar to tcp_read_sock(), except we do not need
> > to worry about connections, we just need to retrieve skb
> > from UDP receive queue.
> >
> > Note, the return value of ->read_sock() is unused in
> > sk_psock_verdict_data_ready().
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/net/udp.h   |  2 ++
> >  net/ipv4/af_inet.c  |  1 +
> >  net/ipv4/udp.c      | 35 +++++++++++++++++++++++++++++++++++
> >  net/ipv6/af_inet6.c |  1 +
> >  4 files changed, 39 insertions(+)
> >
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index df7cc1edc200..347b62a753c3 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -329,6 +329,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
> >                              struct sk_buff *skb);
> >  struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
> >                                __be16 sport, __be16 dport);
> > +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > +               sk_read_actor_t recv_actor);
> >
> >  /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
> >   * possibly multiple cache miss on dequeue()
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 1355e6c0d567..f17870ee558b 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -1070,6 +1070,7 @@ const struct proto_ops inet_dgram_ops = {
> >       .setsockopt        = sock_common_setsockopt,
> >       .getsockopt        = sock_common_getsockopt,
> >       .sendmsg           = inet_sendmsg,
> > +     .read_sock         = udp_read_sock,
> >       .recvmsg           = inet_recvmsg,
> >       .mmap              = sock_no_mmap,
> >       .sendpage          = inet_sendpage,
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 38952aaee3a1..04620e4d64ab 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -1782,6 +1782,41 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
> >  }
> >  EXPORT_SYMBOL(__skb_recv_udp);
> >
> > +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> > +               sk_read_actor_t recv_actor)
> > +{
> > +     int copied = 0;
> > +
> > +     while (1) {
> > +             int offset = 0, err;
>
> Should this be
>
>  int offset = sk_peek_offset()?

What are you really suggesting? sk_peek_offset() is just 0 unless
we have MSG_PEEK here and we don't, because we really want to
dequeue the skb rather than peeking it.

Are you suggesting we should do peeking? I am afraid we can't.
Please be specific, guessing your mind is not an effective way to
address your reviews.

>
> MSG_PEEK should work from recv side, at least it does on TCP side. If
> its handled in some following patch a comment would be nice. I was
> just reading udp_recvmsg() so maybe its not needed.

Please explain why do we need peeking in sockmap? At very least
it has nothing to do with my patchset.

I do not know why you want to use TCP as a "standard" here, TCP
also supports splice(), UDP still doesn't even with ->read_sock().
Of course they are very different.

>
> > +             struct sk_buff *skb;
> > +
> > +             skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
> > +             if (!skb)
> > +                     return err;
> > +             if (offset < skb->len) {
> > +                     size_t len;
> > +                     int used;
> > +
> > +                     len = skb->len - offset;
> > +                     used = recv_actor(desc, skb, offset, len);
> > +                     if (used <= 0) {
> > +                             if (!copied)
> > +                                     copied = used;
> > +                             break;
> > +                     } else if (used <= len) {
> > +                             copied += used;
> > +                             offset += used;
>
> The while loop is going to zero this? What are we trying to do
> here with offset?

offset only matters for MSG_PEEK and we do not support peeking
in sockmap case, hence it is unnecessary here. I "use" it here just
to make the code as complete as possible.

To further answer your question, it is set to 0 when we return a
valid skb on line 201 inside __skb_try_recv_from_queue(), as
"_off" is set to 0 and won't change unless we have MSG_PEEK.

173         bool peek_at_off = false;
174         struct sk_buff *skb;
175         int _off = 0;
176
177         if (unlikely(flags & MSG_PEEK && *off >= 0)) {
178                 peek_at_off = true;
179                 _off = *off;
180         }
181
182         *last = queue->prev;
183         skb_queue_walk(queue, skb) {
184                 if (flags & MSG_PEEK) {
185                         if (peek_at_off && _off >= skb->len &&
186                             (_off || skb->peeked)) {
187                                 _off -= skb->len;
188                                 continue;
189                         }
190                         if (!skb->len) {
191                                 skb = skb_set_peeked(skb);
192                                 if (IS_ERR(skb)) {
193                                         *err = PTR_ERR(skb);
194                                         return NULL;
195                                 }
196                         }
197                         refcount_inc(&skb->users);
198                 } else {
199                         __skb_unlink(skb, queue);
200                 }
201                 *off = _off;
202                 return skb;

Of course, when we return NULL, we return immediately without
using offset:

1794                 skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
1795                 if (!skb)
1796                         return err;

This should not be hard to figure out. Hope it is clear now.

Thanks.
