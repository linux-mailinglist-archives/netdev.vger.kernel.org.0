Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE89C9113
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfJBSrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:47:17 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45924 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJBSrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 14:47:16 -0400
Received: by mail-yw1-f66.google.com with SMTP id x65so54744ywf.12
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 11:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7JVin1kqUOq6pd7g6dk8gXfOlc8WH7AfmihcT3Jtvqs=;
        b=kDgykesRZ3FAmOfW/McuPhMumDRCKlouJcplo8GKslZyM6FUwbBU++Tx9nD8SD2QI6
         Dr2uLw1IulnAAMoZSl9quNP+yeirgyFL4t8WJC+nSrrZCiCb6bhEVdCIi3bRbaL56Raq
         inczKtBp8VrWymYjUXchRPkbo+FydqCgRDGAjuz8t2/t022c7l/yuab9vTWFiFZgeWrJ
         xXhmguS6VzbPwHtEFAYzgR4F8HIqP32wlyfBZxBLDNroeWpIJm/dVreKuZ2bcqeMFgVS
         R3D6WQnkdGx17O7qKT70mu13FuJLABgFyr4RNBb+RXedB5h0qyfQMEreTS/sm95tm18s
         TCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7JVin1kqUOq6pd7g6dk8gXfOlc8WH7AfmihcT3Jtvqs=;
        b=QsJwiCcRuUq1bOHqkF26nGJ3+VWkF9s16ctM2OKUz9ySh4LRNfHcBFyCbQ30CbxSSF
         PGchRyNMT6mXg4h3xQxXwpj9i5YjKy0rOWAlirsVnLnLGEdiEC1MefJm4Se1A81wvkb3
         6zGKm2Vt7eNXtBfa/hlWKcYHLLFfrtac98N4aflh6uqjuQZoAykgnMnH5I3ILW51yLqy
         J/+skLs90BH4bWmjRfV+5e5KLE3IStAsAv6fFJlkWvYAMad+GZEH86eOGxH6OCf9IfYj
         r8CwrPZBvbVm6bOiwcye+XJ9psaaFrlqGpgs4TOGMpD5XERkHt9kybBl/0iGSPWCMVPN
         0q+Q==
X-Gm-Message-State: APjAAAVuNt/ht4ySUMZ7ot8WkuO6mvwBD005+mhOpsKMXhbE/Vshfk5K
        y58YBlcVgba7HAKORGz5gLujsDELCdHwNQMJVPMjqg==
X-Google-Smtp-Source: APXvYqz7t6f555WtgNmSid/XtC5c7aqJyD55D2yw0hsc1TBKP5uuB+QPAxKHAmPDTRmcDUDkJL4v3WfQnhL5ylSQeq8=
X-Received: by 2002:a0d:db56:: with SMTP id d83mr3600144ywe.135.1570042035518;
 Wed, 02 Oct 2019 11:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <20191002163855.145178-1-edumazet@google.com> <20191002183856.GA13866@breakpoint.cc>
In-Reply-To: <20191002183856.GA13866@breakpoint.cc>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Oct 2019 11:47:04 -0700
Message-ID: <CANn89iLsrAm80Snk9YzEASWtrskqWFpEU11Y253pt1S=75B4wA@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: drop incoming packets having a v4mapped source address
To:     Florian Westphal <fw@strlen.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 11:38 AM Florian Westphal <fw@strlen.de> wrote:
>
> Eric Dumazet <edumazet@google.com> wrote:
> > The dual stack API automatically forces the traffic to be IPv4
> > if v4mapped addresses are used at bind() or connect(), so it makes
> > no sense to allow IPv6 traffic to use the same v4mapped class.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Florian Westphal <fw@strlen.de>
> > Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > ---
> >  net/ipv6/ip6_input.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > index d432d0011c160f41aec09640e95179dd7b364cfc..2bb0b66181a741c7fb73cacbdf34c5160f52d186 100644
> > --- a/net/ipv6/ip6_input.c
> > +++ b/net/ipv6/ip6_input.c
> > @@ -223,6 +223,16 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >       if (ipv6_addr_is_multicast(&hdr->saddr))
> >               goto err;
> >
> > +     /* While RFC4291 is not explicit about v4mapped addresses
> > +      * in IPv6 headers, it seems clear linux dual-stack
> > +      * model can not deal properly with these.
> > +      * Security models could be fooled by ::ffff:127.0.0.1 for example.
> > +      *
> > +      * https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02
> > +      */
> > +     if (ipv6_addr_v4mapped(&hdr->saddr))
> > +             goto err;
> > +
>
> Any reason to only consider ->saddr instead of checking daddr as well?

I do not see reasons the packet should be accepted for sane configurations ?

I would rather have a separate patch for daddr if someone needs it.

(This also comes at a cpu cost for all received packets :/ )
