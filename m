Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F2510B437
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfK0RPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 12:15:34 -0500
Received: from mail-qk1-f171.google.com ([209.85.222.171]:42345 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfK0RPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 12:15:34 -0500
Received: by mail-qk1-f171.google.com with SMTP id i3so20159858qkk.9
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 09:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f4ldvuOmO63uCRz3a1twSBGoWeqGzd9rk6Fux24jGxc=;
        b=mGrCyX8HZwO2xVG+z524Lw1l5msHDYREM1POwD020U8F8Dm3BIJ/1uHFVKbF7mK87+
         nPCnmMYPpNdLPs+1K8gM4On5VTvizON+qWD45g9+y6hJxP1392BXGBll77wMuzlYDhL2
         GyNafbzc3h+kDBbgk6Xeh0fY3XkmSOTG6tazU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f4ldvuOmO63uCRz3a1twSBGoWeqGzd9rk6Fux24jGxc=;
        b=Tw+PywR5WEO1ilCSI+oUlQ2qAogO30+94XQkdKZ8+xkbVEzcrXfBrW+vaBelXq63o8
         6uX2dSi70ZE2IIuGgwfj4SL2ewWzT8GcZHNhnMXtN1IWe0MdjoKL/Dd47kM1jBsM7479
         UKgLqd72AZp0AlM5nFwAeZtAG9ttT04yiOTWajIlBCsiyrFWuY4h8tWhsLE6b5fQdx55
         X9iwR2BUDfqlSWnGe1nWEuV9atFJV8lV1QUPmf2VEN1urXqmsZKz2TIrJpF+LS3+NpF5
         E3YCpznyHX2LZyd/QdqNRdO9RdnddoBQnp8fVlpr8Dw41+YVJY0Uts/J5etUaw+1QHAG
         IocQ==
X-Gm-Message-State: APjAAAU9lFuv4lAELBdrTwZKP4mTYN5fZ1x1KIR9W30uBcqCDKSBDY4t
        PIdxJCrGS82PB/2kOxVcNAOnouD4RuKnvcPUeSEvVg==
X-Google-Smtp-Source: APXvYqxlRZGyFKrx1+sRlxNu/un8jTcmX3nkXdTlj/ZeO/yLhvb34vQRcD7EhWDGOhIHWKgvDXpHxO3u6OGc7fc+CC0=
X-Received: by 2002:a37:ae05:: with SMTP id x5mr5384026qke.243.1574874932684;
 Wed, 27 Nov 2019 09:15:32 -0800 (PST)
MIME-Version: 1.0
References: <CAJPywTJzpZAXGdgZLJ+y7G2JoQMyd_JG+G8kgG+xruVVmZD-OA@mail.gmail.com>
 <CANP3RGfAT199GyqWC7Wbr2983jO1vaJ1YJBSSXtFJmGJaY+wiQ@mail.gmail.com> <CANP3RGfLkxodi=SB3KuS+Vhv==Akb0Ep16qNkXd+h4x23PaG=Q@mail.gmail.com>
In-Reply-To: <CANP3RGfLkxodi=SB3KuS+Vhv==Akb0Ep16qNkXd+h4x23PaG=Q@mail.gmail.com>
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Wed, 27 Nov 2019 18:15:21 +0100
Message-ID: <CAJPywTJv=pFK2dFcHRsZPR89DQVbQX8J6OAcSkZk5MkOP43kvQ@mail.gmail.com>
Subject: Re: Delayed source port allocation for connected UDP sockets
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There may be a valid socket underneath. Consider socket() followed by bind(=
):

udp UNCONN *:* 0.0.0.0:1703  -> master
udp UNCONN *:* 192.0.2.1:1703 -> worker

Them after connect() is done, the socket will move to ESTAB:

udp UNCONN *:* 0.0.0.0:1703  -> master
udp ESTAB 198.18.0.1:58910 192.0.2.1:1703 -> worker

I want to avoid this race. For this brief moment now I have two UNCONN
sockets. I don't want that. I want other sources to be routed to the
wildcard address. I', thinking that IP_BIND_ADDRESS_NO_PORT should be
basically a request for delayed binding. For me it makes sense to
delay the actual binding to the connect().

Marek

On Wed, Nov 27, 2019 at 5:19 PM Maciej =C5=BBenczykowski <maze@google.com> =
wrote:
>
> On Wed, Nov 27, 2019 at 8:09 AM Maciej =C5=BBenczykowski <maze@google.com=
> wrote:
> >
> > On Wed, Nov 27, 2019 at 6:08 AM Marek Majkowski <marek@cloudflare.com> =
wrote:
> > >
> > > Morning,
> > >
> > > In my applications I need something like a connectx()[1] syscall. On
> > > Linux I can get quite far with using bind-before-connect and
> > > IP_BIND_ADDRESS_NO_PORT. One corner case is missing though.
> > >
> > > For various UDP applications I'm establishing connected sockets from
> > > specific 2-tuple. This is working fine with bind-before-connect, but
> > > in UDP it creates a slight race condition. It's possible the socket
> > > will receive packet from arbitrary source after bind():
> > >
> > > s =3D socket(SOCK_DGRAM)
> > > s.bind((192.0.2.1, 1703))
> > > # here be dragons
> > > s.connect((198.18.0.1, 58910))
> > >
> > > For the short amount of time after bind() and before connect(), the
> > > socket may receive packets from any peer. For situations when I don't
> > > need to specify source port, IP_BIND_ADDRESS_NO_PORT flag solves the
> > > issue. This code is fine:
> > >
> > > s =3D socket(SOCK_DGRAM)
> > > s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> > > s.bind((192.0.2.1, 0))
> > > s.connect((198.18.0.1, 58910))
> > >
> > > But the IP_BIND_ADDRESS_NO_PORT doesn't work when the source port is
> > > selected. It seems natural to expand the scope of
> > > IP_BIND_ADDRESS_NO_PORT flag. Perhaps this could be made to work:
> > >
> > > s =3D socket(SOCK_DGRAM)
> > > s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> > > s.bind((192.0.2.1, 1703))
> > > s.connect((198.18.0.1, 58910))
> > >
> > > I would like such code to delay the binding to port 1703 up until the
> > > connect(). IP_BIND_ADDRESS_NO_PORT only makes sense for connected
> > > sockets anyway. This raises a couple of questions though:
> > >
> > >  - IP_BIND_ADDRESS_NO_PORT name is confusing - we specify the port
> > > number in the bind!
> > >
> > >  - Where to store the source port in __inet_bind. Neither
> > > inet->inet_sport nor inet->inet_num seem like correct places to store
> > > the user-passed source port hint. The alternative is to introduce
> > > yet-another field onto inet_sock struct, but that is wasteful.
> > >
> > > Suggestions?
> > >
> > > Marek
> > >
> > > [1] https://www.unix.com/man-page/mojave/2/connectx/
> >
> > attack BPF socket filter drop all, then bind, then connect, then replac=
e it.
>
> Although I guess perhaps you'd consider dropping the packets to be bad...=
?
> Then I think you might be able to do the same trick with
> SO_BINDTODEVICE("dummy0") instead of bpf and then SO_BINDTODEVICE("")
> That unfortunately requires privs though.
