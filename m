Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73E538582
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbiE3Pxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 11:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240989AbiE3Pxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 11:53:31 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F06D21B6
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 08:28:35 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id t31so6641820ybi.2
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 08:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fB3apY8xbVHthr1QEWHAXtgcu7IrOhAj3wmtPI6ossk=;
        b=ioHJfIftxUNz0BY07JyYItCLkJmGYaaXpyHWWwHc2fdMgDoCI5jK1O4cSLQRd9aSRi
         N0Ds0OjrvtSxBPVkHMQN8RBLUw696uBCQ50evtjXg51GFtBbnGZAAiP37Yxn0GG69QnV
         HyM0gDeeHyEPb1+BvynzteSlmmWDVqzoXYJT8vNjm/HAw8Gez/VHHdnjOGVVI9LL4r0/
         mtZzhHM0sEbUuQimXzupEDuDpKg07B2gFOYbGhgg7oveT0AMPkRrZU8o6G0sDXFEitsg
         5LJT1Az6E86ynvoBSr+tU5pCuyZnfj7h1rKB6ttCrAvyYgecQ3I3HxE0wfhm1HE7IvQv
         cHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fB3apY8xbVHthr1QEWHAXtgcu7IrOhAj3wmtPI6ossk=;
        b=qtBIYSsRlwT/UslUNRe/zoL/1iCifUvrBsy18rqiQ3zaqcLVP0OnBFuTzQ4w8CHUK9
         XbL1FllZw7L4R+9JvZ9q58ovojobbkN1J1di2F8hPtRqmmg9i1MLLx5Jv+6+DoEl+Ikp
         xBlQhoX94Y8pT4Hin/9hGRdLYSDCGJAGoKb7fgkTwc+cU3NmQHuNXmbuO0XIprIJu+Lr
         TTVYmG3p9ABjC/MJe1ivAaF+qPSqmNXFXMMsLfRZIQg+FSOGOynsTyY++kY8yTNrYEJY
         JULeRRwLeAH8JNZW9i1v7OTqX4vnhatLDV1JIZSLfvZYTjumhYpzpc9bKauimiIXATPb
         ELKg==
X-Gm-Message-State: AOAM530OihfxX14WdiuvrYcmpJ+pqqsQsn9dF0weyKWbhCm4paLMfe+K
        H22DuRrm2NDmWnxR511+yaKCsZG+jiR7z5DMIjUPjA==
X-Google-Smtp-Source: ABdhPJwBbuoNLiU+ub4GeMdZhTi/65EG8GrXhRaAVZ/1Ukt0actQJeRoz7J3e9sZ4AF1mojFsuCxpjJG4pQAJth+4OE=
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr9873470ybh.36.1653924514380; Mon, 30
 May 2022 08:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <5099dc39-c6d9-115a-855b-6aa98d17eb4b@collabora.com>
 <CANn89i+R9RgmD=AQ4vX1Vb_SQAj4c3fi7-ZtQz-inYY4Sq4CMQ@mail.gmail.com> <8eb9b438-7018-4fe3-8be6-bb023df99594@collabora.com>
In-Reply-To: <8eb9b438-7018-4fe3-8be6-bb023df99594@collabora.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 30 May 2022 08:28:23 -0700
Message-ID: <CANn89iJ1DfmuPz5pGdw=j9o+3O4R9tnTNFKi-ppW1O2sfmnN4g@mail.gmail.com>
Subject: Re: [RFC] EADDRINUSE from bind() on application restart after killing
To:     Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        open list <linux-kernel@vger.kernel.org>,
        Collabora Kernel ML <kernel@collabora.com>,
        Paul Gofman <pgofman@codeweavers.com>,
        "open list:NETWORKING [TCP]" <netdev@vger.kernel.org>,
        Sami Farin <hvtaifwkbgefbaei@gmail.com>
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

On Mon, May 30, 2022 at 6:15 AM Muhammad Usama Anjum
<usama.anjum@collabora.com> wrote:
>
> Hi,
>
> Thank you for your reply.
>
> On 5/25/22 3:13 AM, Eric Dumazet wrote:
> > On Tue, May 24, 2022 at 1:19 AM Muhammad Usama Anjum
> > <usama.anjum@collabora.com> wrote:
> >>
> >> Hello,
> >>
> >> We have a set of processes which talk with each other through a local
> >> TCP socket. If the process(es) are killed (through SIGKILL) and
> >> restarted at once, the bind() fails with EADDRINUSE error. This error
> >> only appears if application is restarted at once without waiting for 60
> >> seconds or more. It seems that there is some timeout of 60 seconds for
> >> which the previous TCP connection remains alive waiting to get closed
> >> completely. In that duration if we try to connect again, we get the error.
> >>
> >> We are able to avoid this error by adding SO_REUSEADDR attribute to the
> >> socket in a hack. But this hack cannot be added to the application
> >> process as we don't own it.
> >>
> >> I've looked at the TCP connection states after killing processes in
> >> different ways. The TCP connection ends up in 2 different states with
> >> timeouts:
> >>
> >> (1) Timeout associated with FIN_WAIT_1 state which is set through
> >> `tcp_fin_timeout` in procfs (60 seconds by default)
> >>
> >> (2) Timeout associated with TIME_WAIT state which cannot be changed. It
> >> seems like this timeout has come from RFC 1337.
> >>
> >> The timeout in (1) can be changed. Timeout in (2) cannot be changed. It
> >> also doesn't seem feasible to change the timeout of TIME_WAIT state as
> >> the RFC mentions several hazards. But we are talking about a local TCP
> >> connection where maybe those hazards aren't applicable directly? Is it
> >> possible to change timeout for TIME_WAIT state for only local
> >> connections without any hazards?
> >>
> >> We have tested a hack where we replace timeout of TIME_WAIT state from a
> >> value in procfs for local connections. This solves our problem and
> >> application starts to work without any modifications to it.
> >>
> >> The question is that what can be the best possible solution here? Any
> >> thoughts will be very helpful.
> >>
> >
> > One solution would be to extend TCP diag to support killing TIME_WAIT sockets.
> > (This has been raised recently anyway)
> I think this has been raised here:
> https://lore.kernel.org/netdev/ba65f579-4e69-ae0d-4770-bc6234beb428@gmail.com/
>
> >
> > Then you could zap all sockets, before re-starting your program.
> >
> > ss -K -ta src :listen_port
> >
> > Untested patch:
> The following command and patch work for my use case. The socket in
> TIME_WAIT_2 or TIME_WAIT state are closed when zapped.
>
> Can you please upstream this patch?

Yes, I will when net-next reopens, thanks for testing it.

>
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 9984d23a7f3e1353d2e1fc9053d98c77268c577e..1b7bde889096aa800b2994c64a3a68edf3b62434
> > 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4519,6 +4519,15 @@ int tcp_abort(struct sock *sk, int err)
> >                         local_bh_enable();
> >                         return 0;
> >                 }
> > +               if (sk->sk_state == TCP_TIME_WAIT) {
> > +                       struct inet_timewait_sock *tw = inet_twsk(sk);
> > +
> > +                       refcount_inc(&tw->tw_refcnt);
> > +                       local_bh_disable();
> > +                       inet_twsk_deschedule_put(tw);
> > +                       local_bh_enable();
> > +                       return 0;
> > +               }
> >                 return -EOPNOTSUPP;
> >         }
>
> --
> Muhammad Usama Anjum
