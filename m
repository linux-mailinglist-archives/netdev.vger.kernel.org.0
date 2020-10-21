Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E146D294AB3
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 11:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441436AbgJUJnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 05:43:20 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42793 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409025AbgJUJnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 05:43:20 -0400
Received: by mail-oi1-f196.google.com with SMTP id 16so1431041oix.9;
        Wed, 21 Oct 2020 02:43:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A+dGe9E1y4GPCOVuJDYhJc0nPB3hrbmcXhf7DfkQJig=;
        b=AiE915EBb1PQmO+5Z2Som/TotP5ENyM/3iMN/b4j5gKn+688sPNy6MgNmq/pDY0vQ4
         WDi8YYhK3mdJsp3ySKnA26KAr+C/4JvMDk6HyB8d81UjmWLALp/oQ+effbUvyc0vC3sp
         f7JicHXUkgxZxYRxnmMqhiGOBnA04CW9Uy/HHcpUAjFuDKlB8R9fNxSpGq4TlDGn4sV8
         ovcMkoR1YIYriBcB1LThRlf8mnJVe+cY9BmXSZj3Vg/pAvqHeZDbf1jWfCrqcx/ZroKC
         4ntSoIRAtkMNVdrdlBzjJEzhcs7jHOVT9UQ850idZ2932nnzC4lhG+o4kKiGPEYqfszE
         7Lig==
X-Gm-Message-State: AOAM531RxlkJ2MY77yRn8g+LvgQYVDYoqOpnIB7ZYzikDntODIpB1WS8
        lAMGxtB21naHyghPnrYHR9ul51+Lpk2oyn5Ld15WqsSat/o=
X-Google-Smtp-Source: ABdhPJy4Tf8wU+QYVdZMdYtJjbTZtwdQcw4M6zGJ9rRcrIUbKKvYiPQbQSXqfnfBTz2Yo/ryu1rM/cq2TVa/+1u3UqY=
X-Received: by 2002:a05:6808:8f5:: with SMTP id d21mr1520482oic.153.1603273399452;
 Wed, 21 Oct 2020 02:43:19 -0700 (PDT)
MIME-Version: 1.0
References: <20201020073839.29226-1-geert@linux-m68k.org> <5dddd3fe-86d7-d07f-dbc9-51b89c7c8173@tessares.net>
 <20201020205647.20ab7009@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020205647.20ab7009@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 21 Oct 2020 11:43:08 +0200
Message-ID: <CAMuHMdW=1LfE8UoGRVBvrvrintQMNKUdTe5PPQz=PN3=gJmw=Q@mail.gmail.com>
Subject: Re: [PATCH] mptcp: MPTCP_IPV6 should depend on IPV6 instead of
 selecting it
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev <netdev@vger.kernel.org>, mptcp@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Oct 21, 2020 at 5:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 20 Oct 2020 11:26:34 +0200 Matthieu Baerts wrote:
> > On 20/10/2020 09:38, Geert Uytterhoeven wrote:
> > > MPTCP_IPV6 selects IPV6, thus enabling an optional feature the user may
> > > not want to enable.  Fix this by making MPTCP_IPV6 depend on IPV6, like
> > > is done for all other IPv6 features.
> >
> > Here again, the intension was to select IPv6 from MPTCP but I understand
> > the issue: if we enable MPTCP, we will select IPV6 as well by default.
> > Maybe not what we want on some embedded devices with very limited memory
> > where IPV6 is already off. We should instead enable MPTCP_IPV6 only if
> > IPV6=y. LGTM then!
> >
> > Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
>
> Applied, thanks!

My apologies, this fails for the CONFIG_IPV6=m and CONFIG_MPTCP=y
case:
  + error: net/mptcp/protocol.o: undefined reference to
`inet6_getname':  => .rodata+0x19c)
  + error: net/mptcp/protocol.o: undefined reference to `inet6_ioctl':
 => .rodata+0x1a4)
  + error: net/mptcp/protocol.o: undefined reference to
`inet6_recvmsg':  => .rodata+0x1c4)
  + error: net/mptcp/protocol.o: undefined reference to
`inet6_release':  => .rodata+0x188)
  + error: net/mptcp/protocol.o: undefined reference to
`inet6_sendmsg':  => .rodata+0x1c0)
  + error: protocol.c: undefined reference to `inet6_destroy_sock':
=> .text+0x4994)
  + error: protocol.c: undefined reference to
`inet6_register_protosw':  => .init.text+0xc6)
  + error: protocol.c: undefined reference to `inet6_stream_ops':  =>
.text+0x2bb0)
  + error: protocol.c: undefined reference to `tcpv6_prot':  => .text+0x2ba8)
  + error: subflow.c: undefined reference to
`tcp_request_sock_ipv6_ops':  => .text+0x8e2)
  + error: undefined reference to `ipv6_specific':  => (.init.text+0xea)
  + error: undefined reference to `tcp_request_sock_ipv6_ops':  =>
(.init.text+0xc4)

So those issues have to be fixed first

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
