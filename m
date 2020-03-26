Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D74193CE4
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 11:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgCZKU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 06:20:26 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44711 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgCZKU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 06:20:26 -0400
Received: by mail-oi1-f194.google.com with SMTP id v134so4961924oie.11
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 03:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Ou958zyhsDYQ/ks25N+pQXJ3t+VMiViuMpgt3OjfrE=;
        b=hzMjklkbo8OalW+4Co8gHQTKDS+eTFrCAaazRKliFE0k8A397+fMNHaHtpIMYPruno
         iS9dMnlAfWFbfHIXE8XcMYf+pghNaGbjumvAyru/og2V/0aJsn6ovLtTWTN3tlXoXthW
         4JM2uWO17KaBHVm8h4N4bN/biWd1Krnze3dW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Ou958zyhsDYQ/ks25N+pQXJ3t+VMiViuMpgt3OjfrE=;
        b=l/nsxlCd/hqJiI739qt3gGRUmg2ITIvsFMbL6obid4UbcwtReMzscZ9J6G3hctl+4e
         iS9nwWRnjFFprI2TIys13cOSwgr/dlCO43L30h52C1BVLw1F3DkTf/dwvTlDmYay1Dve
         eTXnYKWhfshqyz/3hWyPVxTS6dcLOAYamHHD7oDgBTwBn7ysj38xXOsfq1t9MQNbEurL
         eKgO3P6C5ycgR4TU7OwscKyhuvC0VvtagnmE+5/A1lZipcjNSHWMpdDuRymetf6mFmUZ
         SjSwmfN/dDbhid/cMBWwBPrCuNwTK5Wu4hKTLOXxozIZ8oODyoGAysTdX5ya6nZ+6rhG
         OMcw==
X-Gm-Message-State: ANhLgQ1uTOpNehNP8EMP85+EANKmTqzBTLx7rCNbha2AY8yZflbSlbfS
        qm3oSOF3UzYyDOjjleMi5ZDXdTqkEnV/XQxkUTHhBg==
X-Google-Smtp-Source: ADFU+vvjooMPm1pO3DPN0m4KYV8vALUhU7yayr+ed5P3H+Z91ADsNsub0miXeGSwLpLLtGAKNFaeTX6gGlZgVQSQXfI=
X-Received: by 2002:aca:c415:: with SMTP id u21mr1219894oif.102.1585218025192;
 Thu, 26 Mar 2020 03:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-5-joe@wand.net.nz>
 <CACAyw9_17E3TNCFsnXzQ4K2zSmwn8J+BcZqbjiK==WQH=zNzvg@mail.gmail.com> <CAOftzPipEjfy1p_98V+JmV3p_WJPzhE-_KfqC3UE3d-TYYxyww@mail.gmail.com>
In-Reply-To: <CAOftzPipEjfy1p_98V+JmV3p_WJPzhE-_KfqC3UE3d-TYYxyww@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 26 Mar 2020 10:20:14 +0000
Message-ID: <CACAyw99SDN0U+VWi=WqS0V-M+riGehXfj3frTzSa6YcvOgWJtQ@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 4/5] bpf: Don't refcount LISTEN sockets in sk_assign()
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 at 20:47, Joe Stringer <joe@wand.net.nz> wrote:
>
> On Wed, Mar 25, 2020 at 3:29 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Wed, 25 Mar 2020 at 05:58, Joe Stringer <joe@wand.net.nz> wrote:
> > >
> > > Avoid taking a reference on listen sockets by checking the socket type
> > > in the sk_assign and in the corresponding skb_steal_sock() code in the
> > > the transport layer, and by ensuring that the prefetch free (sock_pfree)
> > > function uses the same logic to check whether the socket is refcounted.
> > >
> > > Suggested-by: Martin KaFai Lau <kafai@fb.com>
> > > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > > ---
> > > v2: Initial version
> > > ---
> > >  include/net/sock.h | 25 +++++++++++++++++--------
> > >  net/core/filter.c  |  6 +++---
> > >  net/core/sock.c    |  3 ++-
> > >  3 files changed, 22 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > index 1ca2e808cb8e..3ec1865f173e 100644
> > > --- a/include/net/sock.h
> > > +++ b/include/net/sock.h
> > > @@ -2533,6 +2533,21 @@ skb_sk_is_prefetched(struct sk_buff *skb)
> > >         return skb->destructor == sock_pfree;
> > >  }
> > >
> > > +/* This helper checks if a socket is a full socket,
> > > + * ie _not_ a timewait or request socket.
> > > + */
> > > +static inline bool sk_fullsock(const struct sock *sk)
> > > +{
> > > +       return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
> > > +}
> > > +
> > > +static inline bool
> > > +sk_is_refcounted(struct sock *sk)
> > > +{
> > > +       /* Only full sockets have sk->sk_flags. */
> > > +       return !sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE);
> > > +}
> > > +
> > >  /**
> > >   * skb_steal_sock
> > >   * @skb to steal the socket from
> > > @@ -2545,6 +2560,8 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
> > >                 struct sock *sk = skb->sk;
> > >
> > >                 *refcounted = true;
> > > +               if (skb_sk_is_prefetched(skb))
> > > +                       *refcounted = sk_is_refcounted(sk);
> > >                 skb->destructor = NULL;
> > >                 skb->sk = NULL;
> > >                 return sk;
> > > @@ -2553,14 +2570,6 @@ skb_steal_sock(struct sk_buff *skb, bool *refcounted)
> > >         return NULL;
> > >  }
> > >
> > > -/* This helper checks if a socket is a full socket,
> > > - * ie _not_ a timewait or request socket.
> > > - */
> > > -static inline bool sk_fullsock(const struct sock *sk)
> > > -{
> > > -       return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
> > > -}
> > > -
> > >  /* Checks if this SKB belongs to an HW offloaded socket
> > >   * and whether any SW fallbacks are required based on dev.
> > >   * Check decrypted mark in case skb_orphan() cleared socket.
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 0fada7fe9b75..997b8606167e 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -5343,8 +5343,7 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
> > >
> > >  BPF_CALL_1(bpf_sk_release, struct sock *, sk)
> > >  {
> > > -       /* Only full sockets have sk->sk_flags. */
> > > -       if (!sk_fullsock(sk) || !sock_flag(sk, SOCK_RCU_FREE))
> > > +       if (sk_is_refcounted(sk))
> > >                 sock_gen_put(sk);
> > >         return 0;
> > >  }
> > > @@ -5870,7 +5869,8 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> > >                 return -ESOCKTNOSUPPORT;
> > >         if (unlikely(dev_net(skb->dev) != sock_net(sk)))
> > >                 return -ENETUNREACH;
> > > -       if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > > +       if (sk_is_refcounted(sk) &&
> > > +           unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > >                 return -ENOENT;
> > >
> > >         skb_orphan(skb);
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index cfaf60267360..a2ab79446f59 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -2076,7 +2076,8 @@ EXPORT_SYMBOL(sock_efree);
> > >   */
> > >  void sock_pfree(struct sk_buff *skb)
> > >  {
> > > -       sock_edemux(skb);
> > > +       if (sk_is_refcounted(skb->sk))
> > > +               sock_edemux(skb);
> >
> > sock_edemux calls sock_gen_put, which is also called by
> > bpf_sk_release. Is it worth teaching sock_gen_put about
> > sk_fullsock, and dropping the other helpers? I was considering this
> > when fixing up sk_release, but then forgot
> > about it.
>
> I like the idea, but I'm concerned about breaking things outside the
> focus of this new helper if the skb_sk_is_prefetched() function from
> patch 1 is allowed to return true for sockets other than the ones
> assigned from the bpf_sk_assign() helper. At a glance there's users of
> sock_efree (which sock_edemux can be defined to) like netem_enqueue()
> which may inadvertently trigger unexpected paths here. I think it's
> more explicit so more obviously correct if the destructor pointer used
> in this series is unique compared to other paths, even if the
> underlying code is the same.

Sorry, I didn't mean to get rid of sock_pfree, I was referring to
sk_fullsock and
sk_is_refcounted. My point was that it's weird that sock_gen_put isn't
actually generic because it doesn't properly handle SOCK_RCU_FREE.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
