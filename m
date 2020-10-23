Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06432972F9
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464584AbgJWP4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S464404AbgJWP4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 11:56:19 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915DDC0613D2
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 08:56:19 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id g7so1810115ilr.12
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 08:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fBmYo/+9lN5WrZS8+VFUY+eln77PvkT/0UFmNnb+zKE=;
        b=R2u/jOJdCc2r2g0bTh2jFhXbC7DDyeRfoVvwX+zCogwiQbA2Aco4/iIy3lw0o3KmNo
         II8pZXIGBVTDXxlfQcNLdGz8o2HvAB++eCtSaH6WJjFB8M0/RFa/PDeM91h6vZ5MJARU
         aanxxDvjHk0+EQJTzCQktJS+Q3tnyMTSlGQpikm1LVqiL2wDIvGcqu/Zu2wogzIseGnQ
         Umu28KX02nOXazRg6C243ohZJee/Z5pi+1LrYZmsaOzJHDdJaOgDtAq0v3yGgTCyyy9o
         3ZFV/sazJgyw9CUDGuY7LihsQ1qBR4WKNjC40bb+28IO2n69/Zr0KfCY92Zq4m35hrEl
         EzoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fBmYo/+9lN5WrZS8+VFUY+eln77PvkT/0UFmNnb+zKE=;
        b=kmCFwUoNGowM+C+y40aZ2RMV19QFnXFbZ23ro1eoqpsAy76YH/TjPgYl7kbUNbs1oy
         YvOX2/vx7bN0o7nq899QtjM912deb1GlMEOdnxmwhrbvWGgduazfFVDrK4O0nt6vmgrH
         fFO/EhmD//F7S7TcoTcJJdCtrm/00Cig0YgHZ+vRpBylIR+gHgKP5G7oqPD7sRVGCtU0
         oR6tlvAYfbIS55NxFiX2hx7XYiYtyx17E82xFgk01AO6H1Jb7tv6aJh7kD1/Qz2HaRCH
         wEZTk/E1xcLoZiFmdjc9YC6Qr22GfIQgzKfBm3V2jUQwUUlVFPoOY7OuyzVa3yVOsAu/
         drJw==
X-Gm-Message-State: AOAM530cFoMlG2EgBShUZ2j5dRmQ/gHRifc4YIQRoYtB/G+zqQfqwDgx
        ZguthVNE+ZmuIWp0RsnW5+g5Jh9R2mnjImiNvwgfyQ==
X-Google-Smtp-Source: ABdhPJwZVmJRCIZ1HW5yMYJQnLjHWuS4qa3FazzMGkAaWe7rp2JGflNk9Wz5ooPJKcgM8c6ZhCARF4S5Pm1bJppoZGY=
X-Received: by 2002:a92:c213:: with SMTP id j19mr2252436ilo.205.1603468578629;
 Fri, 23 Oct 2020 08:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201023111352.GA289522@rdias-suse-pc.lan> <CANn89iJDt=XpUZA_uYK98cK8tctW6M=f4RFtGQpTxRaqwnnqSQ@mail.gmail.com>
 <20201023155145.GA316015@rdias-suse-pc.lan>
In-Reply-To: <20201023155145.GA316015@rdias-suse-pc.lan>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 23 Oct 2020 17:56:07 +0200
Message-ID: <CANn89iL2VOH+Mg9-U7pkpMkKykDfhoX-GMRnF-oBmZmCGohDtA@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix race condition when creating child sockets from syncookies
To:     Ricardo Dias <rdias@memsql.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 5:51 PM Ricardo Dias <rdias@memsql.com> wrote:
>
> On Fri, Oct 23, 2020 at 04:03:27PM +0200, Eric Dumazet wrote:
> > On Fri, Oct 23, 2020 at 1:14 PM Ricardo Dias <rdias@memsql.com> wrote:
> > >
> > > When the TCP stack is in SYN flood mode, the server child socket is
> > > created from the SYN cookie received in a TCP packet with the ACK flag
> > > set.
> > >
> > ...
> >
> > This patch only handles IPv4, unless I am missing something ?
>
> Yes, currently the patch only handles IPv4. I'll improve it to also
> handle the IPv6 case.
>
> >
> > It looks like the fix should be done in inet_ehash_insert(), not
> > adding yet another helper in TCP.
> > This would be family generic.
>
> Ok, sounds good as long as there is not problem in changing the
> signature and semantics of the inet_ehash_insert() function, as well as
> changing the inet_ehash_nolisten() function.
>
> >
> > Note that normally, all packets for the same 4-tuple should be handled
> > by the same cpu,
> > so this race is quite unlikely to happen in standard setups.
>
> I was able to write a small client/server program that used the
> loopback interface to create connections, which could hit the race
> condition in 1/200 runs.
>
> The server when accepts a connection sends an 8 byte identifier to
> the client, and then waits for the client to echo the same identifier.
> The client creates hundreds of simultaneous connections to the server,
> and in each connection it sends one byte as soon as the connection is
> established, then reads the 8 byte identifier from the server and sends
> it back to the server.
>
> When we hit the race condition, one of the server connections gets an 8
> byte identifier different from its own identifier.

That is on loopback, right ?

A server under syn flood is usually hit on a physical NIC, and a NIC
will always put all packets of a TCP flow in a single RX queue.
The cpu associated with this single RX queue won't process two packets
in parallel.

Note this issue is known, someone tried to fix it in the past but the
attempt went nowhere.
