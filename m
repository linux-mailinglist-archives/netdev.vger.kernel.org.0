Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38082140B8
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 17:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfEEPmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 11:42:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35782 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEPmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 11:42:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id w12so589009wrp.2
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 08:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quantonium-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DTOqDOwz5c2f2Hffm3ktmvzvS2NAobYWHGRBOMLEbyE=;
        b=N2Io1kjqQmLmtwPO/1OOYmgu7I5qOPMeFchV/27ompJOl1enBcrOUJmJ4pYRIGqcKJ
         WufECUE0PqFxlXofxei+avvrkUP8oQycPkoxaqqzfjPashqWE7CCpSVwyfuPAgEspEax
         vm4iurqMpBwvZPqnybJ64aiBBxGMHMpAYtx0Q/wmP9anTktRePHLV+IY8QSxhDZI8963
         xeLE/dnjM/3IydjKieu2Oitt3TjURn9AM1gBIemRVWeHNP37F+xuJCOBUag4LbcGOiAZ
         N3nn7yejZZOktByUvezuz796N3Pxise+yrM8axyGRWzGkkQkXqBUwnMp+alvAMaMWDpg
         aabA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DTOqDOwz5c2f2Hffm3ktmvzvS2NAobYWHGRBOMLEbyE=;
        b=ntNDHW/G3lqiz1LLlQjjbneYBFqXjRW368BW7sPIVpx8C+JEly1x0YxWzkgP7NlHH0
         NvYuo2yHvxKLXeGF4WJXsk0iXjHnhFLjS49HCOlZbhB/EBcTdcQNkUva9ZH3ebwgay74
         gaq4pZmh/zc1RUwx8R8jOnVe4F9wT9u98LCBxrmUEX80dPcv+REzfMS8h4vXWZM4Mt7L
         QsUo0h3YP7rssgkk3tgRY9CBwcOYhDslg+Z6ucvbVvOTg89QpnOCet1zm0HXRgjbxTdb
         4OG1k2UpetFszYQcZy+VMbwoO9H2itnhBovBKkIV/q/oIB0tysiiPb7PCK//vSCiivXV
         kQiw==
X-Gm-Message-State: APjAAAUvW17GMP09hZ51Fs7p3e/mCn6QdU4h+G1RBvpkgUY5IKNeDfI4
        JFvmiGn0EZBCa4bLlLisYT2ftYjesHXsXXmRRZNAhA==
X-Google-Smtp-Source: APXvYqy+Y/lOGfuaV09QTcI6KeaqpVtOAz1vKavdzlQlU2G9iY+EHoUhs6ygoOU5/IAHWAKhBSRxHXZFj9nmD7daLl0=
X-Received: by 2002:adf:eb0e:: with SMTP id s14mr4916008wrn.158.1557070938884;
 Sun, 05 May 2019 08:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <1556579717-1554-1-git-send-email-tom@quantonium.net> <20190505.002712.639270971831500623.davem@davemloft.net>
In-Reply-To: <20190505.002712.639270971831500623.davem@davemloft.net>
From:   Tom Herbert <tom@quantonium.net>
Date:   Sun, 5 May 2019 08:42:08 -0700
Message-ID: <CAPDqMepAvcL1ZjMM6GWLuFuDfN=E1BdTNWOB0sGGRHKMVxZzMw@mail.gmail.com>
Subject: Re: [PATCH v9 net-next 0/6] exthdrs: Make ext. headers & options
 useful - Part I
To:     David Miller <davem@davemloft.net>
Cc:     Tom Herbert <tom@herbertland.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 5, 2019 at 12:45 AM David Miller <davem@davemloft.net> wrote:
>
> From: Tom Herbert <tom@herbertland.com>
> Date: Mon, 29 Apr 2019 16:15:11 -0700
>
> > Extension headers are the mechanism of extensibility for the IPv6
> > protocol, however to date they have only seen limited deployment.
> > The reasons for that are because intermediate devices don't handle
> > them well, and there haven't really be any useful extension headers
> > defined. In particular, Destination and Hop-by-Hop options have
> > not been deployed to any extent.
> >
> > The landscape may be changing as there are now a number of serious
> > efforts to define and deploy extension headers. In particular, a number
> > of uses for Hop-by-Hop Options are currently being proposed, Some of
> > these are from router vendors so there is hope that they might start
> > start to fix their brokenness. These proposals include IOAM, Path MTU,
> > Firewall and Service Tickets, SRv6, CRH, etc.
> >
> > Assuming that IPv6 extension headers gain traction, that leaves a
> > noticeable gap in IPv4 support. IPv4 options have long been considered a
> > non-starter for deployment. An alternative being proposed is to enable
> > use of IPv6 options with IPv4 (draft-herbert-ipv4-eh-00).
>
> "Assuming ipv6 extension headers gain traction, my patch set is useful."
>
> Well, when they gain traction you can propose this stuff.
>
> Until then, it's a facility implemented based upon wishful thinking.
>
Hi Dave,

"Assuming" was probably the wrong word here :-). They are gaining
traction. A specific example is In-situ OAM (IOAM) which is being
heavily pushed by Cisco (draft-brockners-inband-oam-data-07). This
requires host to network signalling in data packets which goes far
beyond what information the IP header contains. Their first
inclination was to hack up UDP encapsulation protocols like Geneve,
but that fundamentally doesn't work for various reasons. We were able
to convince them that Hop-by-Hop Options is the correct mechanism so
they are pursuing that in
draft-ioametal-ippm-6man-ioam-ipv6-options-00. Naturally, they want to
support both IPv6 and IPv4 for their products, but there is no usable
mechanism in IPv4 (IP options are effectively obsoleted)-- hence the
motivation for back porting extension headers to IPv4.

In short, we're at a crossroads. Extension headers are "use it or lose
it". If we don't figure out how to make these usable and useful soon,
that may never happen and they'll be relegated to a historical
footnote just like IP options. IMO, it would be a shame if that
happens since we'd be surrendering a valuable feature.

Tom

> Sorry Tom, I kept pushing back using trivial coding style feedback
> because I simply can't justify applying this.
>
