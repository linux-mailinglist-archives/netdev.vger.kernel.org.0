Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5708A32B39D
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449844AbhCCED6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579860AbhCBRLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 12:11:12 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DD6C061223
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 09:02:45 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id h82so7628329ybc.13
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 09:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eoUItCqptUNuQGtZ1HfHGjabp6Mm3n8wjddGeaIZCQ0=;
        b=nTBi6DsfQuWGRyGaOKzPqWPu/zVmIUNE9DX7iRRIUOf7WXJTohCx0VKkmHk6e7yxrI
         R0x308qYjQq4f7u4XiVYJcBdMR+OHaNVyMBiqIixP9zykc57nX4EGSP4IdkXfF05x8wf
         5cCLspPoSLSJorxxNY0Srv44D0GgRb7UZKiZ/GXdp5y0e4+JeSSwd4PGMD7Biu+hvqEq
         R+bMtLMO/2j1geLh62abrBxddPe62jutgS1Brhy0L6M695t5tKwX1e2d/+59/Ofs2oJJ
         FW+ChStlkCKtxzQKf/RHS3AL5ecpmBtOGSOrGypDvGyl4PkaifzeBz0YY+k6tsEoD1/8
         2j/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eoUItCqptUNuQGtZ1HfHGjabp6Mm3n8wjddGeaIZCQ0=;
        b=lsE+WZNRq9y9I4xW3oaYGg3lnezwLA59abSq0UCflJ5EZ+SPM/YHMPciRYdzd6XHe5
         pHjCHzY5YdLvdyhwJXNvJiba66VZTaDinExFW2FWU/iyw72nvsYaaW3vm2spNa9MIRyX
         T6toPNJR16kj95KnnFKHSxddACSb06di/3XX8IQXb8Sf6FBzORmZ+fcL/QKivDGqFtyv
         85bNKO8p5cjVGunMN+SRwPXSnmBc/bDTQkoQkQmyOusfS8JjBzsh5/3NnGwo9HPAYzsp
         1P+4MbG+ZLDXTyFOZyYbVZ7Sh6XKEox12OvPmmb9VNaG3YI/iQxqIgv+8QQ0E3wLcFtV
         e6jw==
X-Gm-Message-State: AOAM530lTTAhz/7iVq0/Xo1xKFzxucr0o61zx1cA7RLyScrUqM25V1bp
        y/x/qis01e8FqQEmWYwDO7HN+CYmalxD0J6Mt0g30Q==
X-Google-Smtp-Source: ABdhPJwwbuX3JFPaICYspoV8jJPuSmaIMkzD8+/yNExtSuWC5hVXA/t4Jq6SFqDOufq8RVDhCRcFMQG5IEqAS7QMT6Q=
X-Received: by 2002:a25:2307:: with SMTP id j7mr33935373ybj.518.1614704564086;
 Tue, 02 Mar 2021 09:02:44 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <20210302090003.78664c3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210302090003.78664c3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 2 Mar 2021 18:02:32 +0100
Message-ID: <CANn89iKPgcN1jGozLnskUdbFuOBGQ6r5VuGWSO_4tP-g3O+mwQ@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 6:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 2 Mar 2021 10:38:46 +0100 Eric Dumazet wrote:
> > On Tue, Mar 2, 2021 at 7:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > When receiver does not accept TCP Fast Open it will only ack
> > > the SYN, and not the data. We detect this and immediately queue
> > > the data for (re)transmission in tcp_rcv_fastopen_synack().
> > >
> > > In DC networks with very low RTT and without RFS the SYN-ACK
> > > may arrive before NIC driver reported Tx completion on
> > > the original SYN. In which case skb_still_in_host_queue()
> > > returns true and sender will need to wait for the retransmission
> > > timer to fire milliseconds later.
> > >
> > > Revert back to non-fast clone skbs, this way
> > > skb_still_in_host_queue() won't prevent the recovery flow
> > > from completing.
> > >
> > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > Fixes: 355a901e6cf1 ("tcp: make connect() mem charging friendly")
> >
> > Hmmm, not sure if this Fixes: tag makes sense.
> >
> > Really, if we delay TX completions by say 10 ms, other parts of the
> > stack will misbehave anyway.
> >
> > Also, backporting this patch up to linux-3.19 is going to be tricky.
>
> Indeed, the problem is minor in practical terms. Maybe it's enough if I
> spell that out more in the description? Are you thinking net-next or
> net without a Fixes tag?
>
> > The real issue here is that skb_still_in_host_queue() can give a false positive.
> >
> > I have mixed feelings here, as you can read my answer :/
> >
> > Maybe skb_still_in_host_queue() signal should not be used when a part
> > of the SKB has been received/acknowledged by the remote peer
> > (in this case the SYN part).
>
> FWIW I was pondering this, when the rtx is requested by the receiver
> we are relatively sure we can ignore skb_still_in_host_queue() because
> we know our system should Tx in order so if receiver saw N + 1, N can't
> be in our queues.
>
> But AFAICT generalizing the test doesn't matter much. In cases other
> than TFO worst case a loss probe will chase the rtx out. And I don't
> grasp enough of TCP to implement the general optimization :)
>
> > Alternative is that drivers unable to TX complete their skbs in a
> > reasonable time should call skb_orphan()
> >  to avoid skb_unclone() penalties (and this skb_still_in_host_queue() issue)
> >
> > If you really want to play and delay TX completions, maybe provide a
> > way to disable skb_still_in_host_queue() globally,
> > using a static key ?
>
> I see the TFO issue with rx and tx completions set to 33us both,
> with two different NIC vendors, so the timing just influences the
> likelihood.
>
> > My personal WIP/hack was something like :
>
> LGTM, are you happy with that being the fix?


Yes, this seems a bit less intrusive, and net-next should be fine
(I guess FB can backport this early if needed)

>
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 69a545db80d2ead47ffcf2f3819a6d066e95f35d..666f6f0a6a06fece204199e07a79e21d1faf8f92
> > 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5995,7 +5995,8 @@ static bool tcp_rcv_fastopen_synack(struct sock
> > *sk, struct sk_buff *synack,
> >                 else
> >                         tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
> >                 skb_rbtree_walk_from(data) {
> > -                       if (__tcp_retransmit_skb(sk, data, 1))
> > +                       /* segs = -1 to bypass
> > skb_still_in_host_queue() check */
> > +                       if (__tcp_retransmit_skb(sk, data, -1))
> >                                 break;
> >                 }
> >                 tcp_rearm_rto(sk);
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index fbf140a770d8e21b936369b79abbe9857537acd8..1d1489e596976e352fe7d5ccee7a6eae55fdbcce
> > 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -3155,8 +3155,12 @@ int __tcp_retransmit_skb(struct sock *sk,
> > struct sk_buff *skb, int segs)
> >                   sk->sk_sndbuf))
> >                 return -EAGAIN;
> >
> > -       if (skb_still_in_host_queue(sk, skb))
> > -               return -EBUSY;
> > +       if (segs > 0) {
> > +               if (skb_still_in_host_queue(sk, skb))
> > +                       return -EBUSY;
> > +       } else {
> > +               segs = -segs;
> > +       }
> >
> >         if (before(TCP_SKB_CB(skb)->seq, tp->snd_una)) {
> >                 if (unlikely(before(TCP_SKB_CB(skb)->end_seq, tp->snd_una))) {
>
