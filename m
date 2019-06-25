Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADFFA5507C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 15:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbfFYNh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 09:37:56 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34170 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfFYNh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 09:37:56 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so27249750edb.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 06:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IKDbl6c3sMle1J6ScTzCsi3GFMhYp5cHOuyymy4HrmE=;
        b=N6pRjp/MVGXnTrWfC1m03yTi68cOkhX2yvheP0mis96icW1wS4v/lhspLBQMbPpbMg
         I1i89SC08FrZ68/Ph7iYeejyTEGB2eNh4cGdg3S72k5iPlbYx8jbCd/pHnr28U1F3EIt
         wMlxNM5UDjs23XIt4natuS436iRf0sOtRvzCf0RMAcX5ogu2t54XzIK44HBCjll4ZN7O
         IAgz3bIZZGnUKNa9G0nyNtn74EHql2MjicMxbka+fpFjNC924EVgxndpQezkhefxEo2O
         ugiBB4/BtHEReG6YZgxs8w2avSBHghsCQaqUPgvzkr4JZr0sG4M9PzlC6vujm0tK+nFd
         Apgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IKDbl6c3sMle1J6ScTzCsi3GFMhYp5cHOuyymy4HrmE=;
        b=p3wFOVpaMK032sWhRVNrU5/DpCA5+OfCQkV9ZAQdq4EqQn/lw3l8wOvtxg+qm512mb
         eFrTguvvToikP2Uv5E9Jl05F2mRMztV0Hs2Es8auy1etUhVkZIijn2Xi4PgGFFo9AwHl
         M0+GrLjYrPRhPN9Tu7heHVmbaPelsTQwFAdFvliYL7RPcgYVhDnfVbJvlguJJa2dsKnm
         G4MbQud8BLpZ/UvS/TdfVLeOZG/TfB7W6/KNkD+Vyu8CJr9GRrvqMqGCbyNxJ8V2pYvK
         DPbtr7nFEc7apD2hinD018X7X8ZI1J848txpHp7GHtbpzvcAUMhdkSDG2/1d/Dxhrq4q
         xcPg==
X-Gm-Message-State: APjAAAXcl05nfZj34L++QSUt9YJeDF8A0SG0I1oL1h4fA6MoF7YeSo1S
        5XcxiwLLG/a5eFPrUo9dthLlBwi3Mhg0kzVxBxQ=
X-Google-Smtp-Source: APXvYqyFyxmeNYkttCq+JNtMFLsycHFyd/QwGiA21swrREjA/PGzAT8jA3ksOJTD/5x+57SnHfz6dFFji8aVJ+ZhOiY=
X-Received: by 2002:a17:906:2acf:: with SMTP id m15mr15211481eje.31.1561469874612;
 Tue, 25 Jun 2019 06:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190619202533.4856-1-nhorman@tuxdriver.com> <20190624004604.25607-1-nhorman@tuxdriver.com>
 <CAF=yD-JE9DEbmh6hJEN=DEdc+SCz_5Lv74mngPBuv=4nNH=zxQ@mail.gmail.com>
 <20190624215142.GA8181@hmswarspite.think-freely.org> <CAF=yD-L2dgypSCTDwdEXa7EUYyWTcD_hLwW_kuUkk0tA_iggDw@mail.gmail.com>
 <20190625110247.GA29902@hmswarspite.think-freely.org>
In-Reply-To: <20190625110247.GA29902@hmswarspite.think-freely.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 25 Jun 2019 09:37:17 -0400
Message-ID: <CAF=yD-KEZBds_SRDFnOjqvidW30E=NG-2X=hBdcGx_--PAmjew@mail.gmail.com>
Subject: Re: [PATCH v3 net] af_packet: Block execution of tasks waiting for
 transmit to complete in AF_PACKET
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 7:03 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Mon, Jun 24, 2019 at 06:15:29PM -0400, Willem de Bruijn wrote:
> > > > > +               if (need_wait && !packet_next_frame(po, &po->tx_ring, TP_STATUS_SEND_REQUEST)) {
> > > > > +                       po->wait_on_complete = 1;
> > > > > +                       timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
> > > >
> > > > This resets timeout on every loop. should only set above the loop once.
> > > >
> > > I explained exactly why I did that in the change log.  Its because I reuse the
> > > timeout variable to get the return value of the wait_for_complete call.
> > > Otherwise I need to add additional data to the stack, which I don't want to do.
> > > Sock_sndtimeo is an inline function and really doesn't add any overhead to this
> > > path, so I see no reason not to reuse the variable.
> >
> > The issue isn't the reuse. It is that timeo is reset to sk_sndtimeo
> > each time. Whereas wait_for_common and its variants return the
> > number of jiffies left in case the loop needs to sleep again later.
> >
> > Reading sock_sndtimeo once and passing it to wait_.. repeatedly is a
> > common pattern across the stack.
> >
> But those patterns are unique to those situations.  For instance, in
> tcp_sendmsg_locked, we aquire the value of the socket timeout, and use that to
> wait for the entire message send operation to complete, which consists of
> potentially several blocking operations (waiting for the tcp connection to be
> established, waiting for socket memory, etc).  In that situation we want to wait
> for all of those operations to complete to send a single message, and fail if
> they exceed the timeout in aggregate.  The semantics are different with
> AF_PACKET.  In this use case, the message is in effect empty, and just used to
> pass some control information.  tpacket_snd, sends as many frames from the
> memory mapped buffer as possible, and on each iteration we want to wait for the
> specified timeout for those frames to complete sending.  I think resetting the
> timeout on each wait instance is the right way to go here.

I disagree. If a SO_SNDTIMEO of a given time is set, the thread should
not wait beyond that. Else what is the point of passing a specific
duration in the syscall?

Btw, we can always drop the timeo and go back to unconditional (bar
signals) waiting.

>
> > > > > @@ -2728,6 +2755,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
> > > > >                         err = net_xmit_errno(err);
> > > > >                         if (err && __packet_get_status(po, ph) ==
> > > > >                                    TP_STATUS_AVAILABLE) {
> > > > > +                               /* re-init completion queue to avoid subsequent fallthrough
> > > > > +                                * on a future thread calling wait_on_complete_interruptible_timeout
> > > > > +                                */
> > > > > +                               po->wait_on_complete = 0;
> > > >
> > > > If setting where sleeping, no need for resetting if a failure happens
> > > > between those blocks.
> > > >
> > > > > +                               init_completion(&po->skb_completion);
> > > >
> > > > no need to reinit between each use?
> > > >
> > > I explained exactly why I did this in the comment above.  We have to set
> > > wait_for_complete prior to calling transmit, so as to ensure that we call
> > > wait_for_completion before we exit the loop. However, in this error case, we
> > > exit the loop prior to calling wait_for_complete, so we need to reset the
> > > completion variable and the wait_for_complete flag.  Otherwise we will be in a
> > > case where, on the next entrace to this loop we will have a completion variable
> > > with completion->done > 0, meaning the next wait will be a fall through case,
> > > which we don't want.
> >
> > By moving back to the point where schedule() is called, hopefully this
> > complexity automatically goes away. Same as my comment to the line
> > immediately above.
> >
> Its going to change what the complexity is, actually.  I was looking at this
> last night, and I realized that your assertion that we could remove
> packet_next_frame came at a cost.  This is because we need to determine if we
> have to wait before we call po->xmit, but we need to actually do the wait after
> po->xmit

Why? The existing method using schedule() doesn't.

Can we not just loop while sending and sleep immediately when
__packet_get_status returns !TP_STATUS_AVAILABLE?

I don't understand the need to probe the next packet to send instead
of the current.

This seems to be the crux of the disagreement. My guess is that it has
to do with setting wait_on_complete, but I don't see the problem. It
can be set immediately before going to sleep.

I don't meant to draw this out, btw, or add to your workload. If you
prefer, I can take a stab at my (admittedly hand-wavy) suggestion.

> (to ensure that wait_on_complete is set properly when the desructor is
> called).  By moving the wait to the top of the loop and getting rid of
> packet_next_frame we now have a race condition in which we might call
> tpacket_destruct_skb with wait_on_complete set to false, causing us to wait for
> the maximum timeout erroneously.  So I'm going to have to find a new way to
> signal the need to call complete, which I think will introduce a different level
> of complexity.
