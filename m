Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1090919320E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 21:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCYUrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 16:47:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36049 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgCYUrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 16:47:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id g62so4596412wme.1;
        Wed, 25 Mar 2020 13:47:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aZh1lVl+Z3AA4oBgpFUkwMGmFnCKYdp+eUJRXxG73Gw=;
        b=d7PO0NeJBCI8z67pKgtmhAVJyYcRnO4Mu1TV7PNFYgYXbvxX64LDAj3CekGObH5iAJ
         sI6oqYEd6RX/UPOB/eeHTNAqUz6z0Sjw2AzHX8oMTrOvnKurQrzmHbZ5QKG+l3VZi8cf
         i1OHNwiFBAaS76FeY1Ab50kqp9DtEwH2CfVRLNlxtF0H/ikI0EVTfl4U/V36dYXEvT9v
         veA/u+GUVjRa8mrTmTMpoBcTSvvWYuDXq2MOOYb2llsEYkbgiW4R17AO/RfPaod3UAi1
         EarrYO6sdj0Nuz4ei6MfjroMPKrJ2hQMMgN7Nxx/+bpNT9KV+DCFJgZ59DeZ7tOpcIUI
         H+Mw==
X-Gm-Message-State: ANhLgQ1/vuSfpZ250M+XxvXz1v9IiCpHUN90wKTI8yIExPonMswWuWgW
        RdqYzCFOKufaG8AZfpp4nMryGTPxTck5qx4D0XW1kokv
X-Google-Smtp-Source: ADFU+vvpd6YlyFCKzdFNPtYw8HfkafiZJ8fbVl3DgPbQgCQsZgcNy7ZcN4FN4VANfV1M1WU5QxioUigiX+QFyYW9LwQ=
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr5503845wme.185.1585169226063;
 Wed, 25 Mar 2020 13:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-5-joe@wand.net.nz>
 <CACAyw9_17E3TNCFsnXzQ4K2zSmwn8J+BcZqbjiK==WQH=zNzvg@mail.gmail.com>
In-Reply-To: <CACAyw9_17E3TNCFsnXzQ4K2zSmwn8J+BcZqbjiK==WQH=zNzvg@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Wed, 25 Mar 2020 13:46:43 -0700
Message-ID: <CAOftzPipEjfy1p_98V+JmV3p_WJPzhE-_KfqC3UE3d-TYYxyww@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 4/5] bpf: Don't refcount LISTEN sockets in sk_assign()
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 3:29 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Wed, 25 Mar 2020 at 05:58, Joe Stringer <joe@wand.net.nz> wrote:
> >
> > Avoid taking a reference on listen sockets by checking the socket type
> > in the sk_assign and in the corresponding skb_steal_sock() code in the
> > the transport layer, and by ensuring that the prefetch free (sock_pfree)
> > function uses the same logic to check whether the socket is refcounted.
> >
> > Suggested-by: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > ---
> > v2: Initial version
> > ---
> >  include/net/sock.h | 25 +++++++++++++++++--------
> >  net/core/filter.c  |  6 +++---
> >  net/core/sock.c    |  3 ++-
> >  3 files changed, 22 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 1ca2e808cb8e..3ec1865f173e 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -2533,6 +2533,21 @@ skb_sk_is_prefetched(struct sk_buff *skb)
> >         return skb->destructor == sock_pfree;
> >  }
> >
> > +/* This helper checks if a socket is a full socket,
> > + * ie _not_ a timewait or request socket.
> > + */
> > +static inline bool sk_fullsock(const struct sock *sk)
> > +{
> > +       return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
> > +}
> > +
> > +static inline bool
> > +sk_is_refcounted(struct sock *sk)
> > +{
> > +       /* Only full sockets have sk->sk_flags. */
> > +       return !sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE);
> > +}
> > +
> >  /**
> >   * skb_steal_sock
> >   * @skb to steal the socket from
> > @@ -2545,6 +2560,8 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
> >                 struct sock *sk = skb->sk;
> >
> >                 *refcounted = true;
> > +               if (skb_sk_is_prefetched(skb))
> > +                       *refcounted = sk_is_refcounted(sk);
> >                 skb->destructor = NULL;
> >                 skb->sk = NULL;
> >                 return sk;
> > @@ -2553,14 +2570,6 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
> >         return NULL;
> >  }
> >
> > -/* This helper checks if a socket is a full socket,
> > - * ie _not_ a timewait or request socket.
> > - */
> > -static inline bool sk_fullsock(const struct sock *sk)
> > -{
> > -       return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
> > -}
> > -
> >  /* Checks if this SKB belongs to an HW offloaded socket
> >   * and whether any SW fallbacks are required based on dev.
> >   * Check decrypted mark in case skb_orphan() cleared socket.
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 0fada7fe9b75..997b8606167e 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5343,8 +5343,7 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
> >
> >  BPF_CALL_1(bpf_sk_release, struct sock *, sk)
> >  {
> > -       /* Only full sockets have sk->sk_flags. */
> > -       if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))
> > +       if (sk_is_refcounted(sk))
> >                 sock_gen_put(sk);
> >         return 0;
> >  }
> > @@ -5870,7 +5869,8 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> >                 return -ESOCKTNOSUPPORT;
> >         if (unlikely(dev_net(skb->dev) != sock_net(sk)))
> >                 return -ENETUNREACH;
> > -       if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > +       if (sk_is_refcounted(sk) &&
> > +           unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> >                 return -ENOENT;
> >
> >         skb_orphan(skb);
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index cfaf60267360..a2ab79446f59 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -2076,7 +2076,8 @@ EXPORT_SYMBOL(sock_efree);
> >   */
> >  void sock_pfree(struct sk_buff *skb)
> >  {
> > -       sock_edemux(skb);
> > +       if (sk_is_refcounted(skb->sk))
> > +               sock_edemux(skb);
>
> sock_edemux calls sock_gen_put, which is also called by
> bpf_sk_release. Is it worth teaching sock_gen_put about
> sk_fullsock, and dropping the other helpers? I was considering this
> when fixing up sk_release, but then forgot
> about it.

I like the idea, but I'm concerned about breaking things outside the
focus of this new helper if the skb_sk_is_prefetched() function from
patch 1 is allowed to return true for sockets other than the ones
assigned from the bpf_sk_assign() helper. At a glance there's users of
sock_efree (which sock_edemux can be defined to) like netem_enqueue()
which may inadvertently trigger unexpected paths here. I think it's
more explicit so more obviously correct if the destructor pointer used
in this series is unique compared to other paths, even if the
underlying code is the same.
