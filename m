Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32923173CD0
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgB1QZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 11:25:27 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36273 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgB1QZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 11:25:27 -0500
Received: by mail-ed1-f67.google.com with SMTP id j17so4026064edp.3
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 08:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aPuMnJEdibqw6iFNmYkguUK/gciG7EmtyihfXtwnpkI=;
        b=CFwwkn1YFyFx/qhgixSLQR7cfwZH86uFnnNtpzdbsn6cWxfmbl5GAbPKTTQLm6jfor
         Jivmb0s28oKC0sOjtxmj4NmBDOITo47Za3Jc9rrZxSJEHy/nZ23A/Aqe5NQZfOc/res7
         s48V2VKDcEZ52O9AVgxbTyBy1lkQux8K+wXmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aPuMnJEdibqw6iFNmYkguUK/gciG7EmtyihfXtwnpkI=;
        b=DL2+tdbrwvNUDLbnkk6QMk9Fz98Y7NEluHbSDaJFz1Ept9sRelOUehBeVUEd4yfpFD
         TUH3aPknzshprYo04JmRLpauEBh0NbrrrOwSVthOn8638/EHgZa8QaUKUgLGoTbpFNYW
         9b+omqwiK+TOf5qwXkbAwY65eWZUkfmWT3058uJydaXLLgWxbp0rSxhFRNDZv1O3VudO
         1bJOGaC8C5Pc5nzN35UsYSJYa+8TzDtmhQiTAZ0sZR4Z+PQHhxo6tph3xcCMtWRu2EV4
         JllmH6eiPbWlbFMdYn9og4T96dv7FNfNTDPh0Tm+kyrKOGM0nnlJIM9zgBFTNSJad2KQ
         Okyg==
X-Gm-Message-State: APjAAAXOGfBBm3aZE3S22i+77GzdZibEvt5++ivxMI9eDZoh95r+U49H
        DpVihe2eFVNxRfKlEU37CyHSgE4DioPh0WSLFh7N3dHx
X-Google-Smtp-Source: APXvYqxMYqH5A3TdGbCe8p+H/qlJ6NSgk9+HYFZq3moxcar1Yw+gsQNLYt5/jTnhS0b+OuMagZRoOObfbeUqMqcOOE0=
X-Received: by 2002:a05:6402:945:: with SMTP id h5mr4858013edz.275.1582907124904;
 Fri, 28 Feb 2020 08:25:24 -0800 (PST)
MIME-Version: 1.0
References: <20200228091858.19729-1-liuhangbin@gmail.com>
In-Reply-To: <20200228091858.19729-1-liuhangbin@gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Fri, 28 Feb 2020 08:32:34 -0800
Message-ID: <CAJieiUiuYG9LZ5Ugx=0C5kwhAw6EoOOYz4uW9w=HzVt=XA=Ctw@mail.gmail.com>
Subject: Re: [PATCH net] net/ipv6: use configured matric when add peer route
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jianlin Shi <jishi@redhat.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 1:19 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> When we add peer address with metric configured, IPv4 could set the dest
> metric correctly, but IPv6 do not. e.g.
>
> ]# ip addr add 192.0.2.1 peer 192.0.2.2/32 dev eth1 metric 20
> ]# ip route show dev eth1
> 192.0.2.2 proto kernel scope link src 192.0.2.1 metric 20
> ]# ip addr add 2001:db8::1 peer 2001:db8::2/128 dev eth1 metric 20
> ]# ip -6 route show dev eth1
> 2001:db8::1 proto kernel metric 20 pref medium
> 2001:db8::2 proto kernel metric 256 pref medium
>
> Fix this by using configured matric instead of default one.
>
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---

noticed the typo in the patch title : s/matric/metric/


>  net/ipv6/addrconf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index cb493e15959c..164c71c54b5c 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -5983,9 +5983,9 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
>                 if (ifp->idev->cnf.forwarding)
>                         addrconf_join_anycast(ifp);
>                 if (!ipv6_addr_any(&ifp->peer_addr))
> -                       addrconf_prefix_route(&ifp->peer_addr, 128, 0,
> -                                             ifp->idev->dev, 0, 0,
> -                                             GFP_ATOMIC);
> +                       addrconf_prefix_route(&ifp->peer_addr, 128,
> +                                             ifp->rt_priority, ifp->idev->dev,
> +                                             0, 0, GFP_ATOMIC);
>                 break;
>         case RTM_DELADDR:
>                 if (ifp->idev->cnf.forwarding)
> --
> 2.19.2
>
