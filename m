Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84BA10462E
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfKTVyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:54:31 -0500
Received: from mail-il1-f171.google.com ([209.85.166.171]:42826 "EHLO
        mail-il1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTVyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:54:31 -0500
Received: by mail-il1-f171.google.com with SMTP id n18so1125735ilt.9
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 13:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oKeP7m/q+Qz7M+vSbIsEHiVBRFlkNfZoezDW8+L7BPI=;
        b=D7bfVZzwGPVsoJ8NBlYS4BG4Of2QRnH7ynfwV8ChkUvitbGYzDpt/tNgtRvzRuN2YN
         lBwDtnCObORl0gVNsxqEKCLlLW3l6mdrKCxZIGCw3IjsOYKKH8/TrRLIm+sxOU+rxRwf
         J5Cn0QSbjebTxIFxE2sLd5wPX3CdVZsFUv8C2OKtjxui2oyCt+DZg8KafEcARuc/OcvK
         B0c3eYfYLhjtBcg05cVcSYcCDxcZ4zOYGMcYhFxC65eUCpwxUtOcSYUiYrqvajr7HsE6
         cZ0vaIBublC3Kh694+tcHo1HWhV4qu+OjLAfIn88+NswhVrsGCRG23jF5ixJGfTFRb1g
         c6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oKeP7m/q+Qz7M+vSbIsEHiVBRFlkNfZoezDW8+L7BPI=;
        b=Aaj1fBMuqxcfcZrC8RIjAfFHQKkyfHaEOiRKQMjeWvYa51UgMIiHVU8neqWlkrf+bR
         MtdgCCK5pg5hNI4QUjbY1YuoOxXEY477fvRlLp4MWc4Ykzv4WbA2RSMBdGH1toI3uHa2
         A8Kx4M0zpPcKDsRIwU8QY4zegbUrMc72IfiWF8RbfIjHjoLZhbFqSeWAQDsDTHqSD9Em
         Au78CcmZ2ZIUihpvBmIZX5QUQUB29ot27tWjp54J7GWuJn0X4cvitbs5w8cwPtpbPbCJ
         8sFqrrOvJrChGaK8Gt7NjBkPi6Z0dEw97ooiXAaDjrsB1XZ0Jk4WrzxRBSNyGOhBNYIK
         kVjg==
X-Gm-Message-State: APjAAAWXTePYxxdnSAR/vCOiIXNGzi/xFfywnDF4oov9ZmcNec9G3TGE
        7T7/Js2R1RqeJzYosFkSzyjeGKYS31oCIAH89GusnA==
X-Google-Smtp-Source: APXvYqyhlKWJKvp7c79HjmAEye9+9jc1uJhunkW8INPlBnz9/qS8ZdpUFfhYx+vHEKXmX8Yew2X/ueUycN5yPJy4HVA=
X-Received: by 2002:a92:ca8d:: with SMTP id t13mr5832413ilo.58.1574286870288;
 Wed, 20 Nov 2019 13:54:30 -0800 (PST)
MIME-Version: 1.0
References: <20191120083919.GH27852@unicorn.suse.cz> <CANn89iJYXh7AwK8_Aiz3wXqugG0icPNW6OPsPxwOvpH90kr+Ew@mail.gmail.com>
 <20191120181046.GA29650@unicorn.suse.cz> <CANn89iLfX2CYKU7hPZkPTNiUoCUyW2PLznsVnxomu4JEWmkefQ@mail.gmail.com>
 <20191120195226.GB29650@unicorn.suse.cz> <e9d19a66-94af-b4e8-255d-38a8cdc6f218@gmail.com>
 <20191120204948.GC29650@unicorn.suse.cz> <CANn89iJeq2CCBrdgt=fFxG3Uk7f4CHbLfsOM2S8q3ucC6znzEA@mail.gmail.com>
 <20191120211348.GD29650@unicorn.suse.cz>
In-Reply-To: <20191120211348.GD29650@unicorn.suse.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 20 Nov 2019 13:54:18 -0800
Message-ID: <CANn89i+a7LHSN6sx2NCUXyUph6Uk7B5vh5ZTUAoVExphN0GmTQ@mail.gmail.com>
Subject: Re: possible race in __inet_lookup_established()
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>, Firo Yang <firo.yang@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 1:13 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Wed, Nov 20, 2019 at 12:57:48PM -0800, Eric Dumazet wrote:
> > On Wed, Nov 20, 2019 at 12:49 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > > Firo suggested something like
> > >
> > > ------------------------------------------------------------------------
> > > --- a/net/ipv4/inet_hashtables.c
> > > +++ b/net/ipv4/inet_hashtables.c
> > > @@ -362,6 +362,8 @@ struct sock *__inet_lookup_established(struct net *net,
> > >
> > >  begin:
> > >         sk_nulls_for_each_rcu(sk, node, &head->chain) {
> > > +               if (unlikely(!node))
> > > +                       goto begin;
> > >                 if (sk->sk_hash != hash)
> > >                         continue;
> > >                 if (likely(INET_MATCH(sk, net, acookie,
> > > ------------------------------------------------------------------------
> > >
> > > It depends on implementation details but I believe it would work. It
> > > would be nicer if we could detect the switch to a listening socket but
> > > I don't see how to make such test race free without introducing
> > > unacceptable performance penalty.
> >
> > No, we do not want to add more checks in the fast path really.
> >
> > I was more thinking about not breaking the RCU invariants.
> >
> > (ie : adding back the nulls stuff that I removed in 3b24d854cb35
> > ("tcp/dccp: do not touch
> > listener sk_refcnt under synflood")
>
> Yes, that would do the trick. It would add some cycles to listener
> lookup but that is less harm than slowing down established socket
> lookup.
>

It should not change cycles spent in listener lookup.

Only the test to check for the iteration end will not use NULL, that's about it.
