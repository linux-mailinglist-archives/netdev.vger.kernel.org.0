Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A6254B8FD
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357043AbiFNSm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356942AbiFNSlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:41:51 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DED84AE1A
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:41:42 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id x187so9889694vsb.0
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zIqO96kC9J0kVdtPw13CgVRgqvyQssnRblB0jPzQKf0=;
        b=KzEU4yQ8Pl26tYu9DutOviYmzntjjkDrr+6/brhJ4njRn5n8uso6BbwpeHrMEx4Sp5
         GpYF/WZQBhExD8LSwpH8cwVr0m1wIxHl6IrBg2tBNO9cmgBvsFKhqCcdKzP5Hs4ts+CU
         cjbgshxanwZaInlliTtmt7Ry8mFUEzkJjwViMKlUuoXEad/ZZcc/cjYXobh1rGviTG4E
         Ra0z6Z3EUyukCKSzcORI78dxEYKn3fwfTBwPABF0Vy5ISjQBLKa51VfPVjY0CRp0tbOf
         kp1CLSRc4k0QCk9fNz8Ta5Kn0fUiHqS8or/2u8uOfH8T7iBL4H6WxYcritf+SeIdd4vh
         fpig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zIqO96kC9J0kVdtPw13CgVRgqvyQssnRblB0jPzQKf0=;
        b=6p0+uPkxn7v12NpxGcGx9YcyByRPgwoZkZAIJWWs90bVxYcDTLtVSXtRTN0A2eK2ok
         3L0360TV/E62rGVaC1gGsnn+H9GAT0+R9AG6r3UA1AMcZ1dBpC1lu/6oLeYhfaVDMusE
         +OZvm6ukUH2BUD4CM+QjYnsOdrWzsRsAkLAevfmvYY0z61MeR50hWKTsN7INAiuBkoDv
         C59+rsogD5J1ZJh+GVKWNmVPMdOkAIQKW0Z5eIXCfSwif9BzBfn0oR4hf2vRjc1B7tau
         iz4aGUgEpwfYc5Tzu82OX7OaI6N/wxCUC8JYZ9D9d1KsqbZqN0XP8Zfy/mQOBOGyJhJP
         XMOg==
X-Gm-Message-State: AJIora9uieINcV96fkIswuOnGXWnDY+HGO8kKqESi62T7rmVc6pqy4xy
        iPcZlBgGuUUFarXANfHGKtC2cAVPYO3U1GaOAMXUpQ==
X-Google-Smtp-Source: AGRyM1u+BlpwPySbXC4wgIFjgg8sxGzKe34D4a8/4exRJdOMFpmx39XcHxdUxMFlrAIltxwkqXWuSKo8B+oD1AXwvDE=
X-Received: by 2002:a67:d606:0:b0:34b:efba:a5f9 with SMTP id
 n6-20020a67d606000000b0034befbaa5f9mr3039258vsj.0.1655232101341; Tue, 14 Jun
 2022 11:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220614171734.1103875-1-eric.dumazet@gmail.com>
 <20220614171734.1103875-3-eric.dumazet@gmail.com> <CACSApvZPx8G8+TaZbxqS19M8tmBmcSq4uGtQskGxD=dGwm7T3A@mail.gmail.com>
In-Reply-To: <CACSApvZPx8G8+TaZbxqS19M8tmBmcSq4uGtQskGxD=dGwm7T3A@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 14 Jun 2022 11:41:30 -0700
Message-ID: <CAEA6p_B43zQnuW6_C06RxMYUhvYdTyVgvshqqNu7+nJZzecWNQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 2/2] tcp: fix possible freeze in tx path under
 memory pressure
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Jun 14, 2022 at 10:42 AM Soheil Hassas Yeganeh
<soheil@google.com> wrote:
>
> On Tue, Jun 14, 2022 at 1:17 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Blamed commit only dealt with applications issuing small writes.
> >
> > Issue here is that we allow to force memory schedule for the sk_buff
> > allocation, but we have no guarantee that sendmsg() is able to
> > copy some payload in it.
> >
> > In this patch, I make sure the socket can use up to tcp_wmem[0] bytes.
> >
> > For example, if we consider tcp_wmem[0] = 4096 (default on x86),
> > and initial skb->truesize being 1280, tcp_sendmsg() is able to
> > copy up to 2816 bytes under memory pressure.
> >
> > Before this patch a sendmsg() sending more than 2816 bytes
> > would either block forever (if persistent memory pressure),
> > or return -EAGAIN.
> >
> > For bigger MTU networks, it is advised to increase tcp_wmem[0]
> > to avoid sending too small packets.
> >
> > v2: deal with zero copy paths.
> >
> > Fixes: 8e4d980ac215 ("tcp: fix behavior for epoll edge trigger")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>
> Very nice find! Thank you!
>
> > ---
> >  net/ipv4/tcp.c | 33 +++++++++++++++++++++++++++++----
> >  1 file changed, 29 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 14ebb4ec4a51f3c55501aa53423ce897599e8637..56083c2497f0b695c660256aa43f8a743d481697 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -951,6 +951,23 @@ static int tcp_downgrade_zcopy_pure(struct sock *sk, struct sk_buff *skb)
> >         return 0;
> >  }
> >
> > +static int tcp_wmem_schedule(struct sock *sk, int copy)
> > +{
> > +       int left;
> > +
> > +       if (likely(sk_wmem_schedule(sk, copy)))
> > +               return copy;
> > +
> > +       /* We could be in trouble if we have nothing queued.
> > +        * Use whatever is left in sk->sk_forward_alloc and tcp_wmem[0]
> > +        * to guarantee some progress.
> > +        */
> > +       left = sock_net(sk)->ipv4.sysctl_tcp_wmem[0] - sk->sk_wmem_queued;
> > +       if (left > 0)
> > +               sk_forced_mem_schedule(sk, min(left, copy));
> > +       return min(copy, sk->sk_forward_alloc);
> > +}
> > +
> >  static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
> >                                       struct page *page, int offset, size_t *size)
> >  {
> > @@ -986,7 +1003,11 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
> >                 tcp_mark_push(tp, skb);
> >                 goto new_segment;
> >         }
> > -       if (tcp_downgrade_zcopy_pure(sk, skb) || !sk_wmem_schedule(sk, copy))
> > +       if (tcp_downgrade_zcopy_pure(sk, skb))
> > +               return NULL;

Do we need to take care of the call to sk_wmem_schedule() inside
tcp_downgrade_zcopy_pure()?

> > +
> > +       copy = tcp_wmem_schedule(sk, copy);
> > +       if (!copy)
> >                 return NULL;
> >
> >         if (can_coalesce) {
> > @@ -1334,8 +1355,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> >
> >                         copy = min_t(int, copy, pfrag->size - pfrag->offset);
> >
> > -                       if (tcp_downgrade_zcopy_pure(sk, skb) ||
> > -                           !sk_wmem_schedule(sk, copy))
> > +                       if (tcp_downgrade_zcopy_pure(sk, skb))
> > +                               goto wait_for_space;
> > +
> > +                       copy = tcp_wmem_schedule(sk, copy);
> > +                       if (!copy)
> >                                 goto wait_for_space;
> >
> >                         err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
> > @@ -1362,7 +1386,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> >                                 skb_shinfo(skb)->flags |= SKBFL_PURE_ZEROCOPY;
> >
> >                         if (!skb_zcopy_pure(skb)) {
> > -                               if (!sk_wmem_schedule(sk, copy))
> > +                               copy = tcp_wmem_schedule(sk, copy);
> > +                               if (!copy)
> >                                         goto wait_for_space;
> >                         }
> >
> > --
> > 2.36.1.476.g0c4daa206d-goog
> >
