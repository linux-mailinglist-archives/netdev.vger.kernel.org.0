Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71F71FB43A
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgFPO00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgFPO00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:26:26 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4ACC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:26:25 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id i8so5393148lfo.4
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ZOeHhEyMcgdvfj81lAu9cuYx0dDNeRXOzRvD3oT0zo=;
        b=uVMw29YDVYJwE4+fHMPYyu57v6sk4I/kZxiTWir5tbjbhLs1RUofSoZ61r5ETwbcQc
         0cpTCfT3wWZGK0pFGZBrIU/fnL1e/ZiOnIeEKz7ZszOo4E/F57bqusmH+GPXIOIxt8ig
         EX12+IeC9KmzkFcunv7EJBwrZEecPBv7lhXrLOswnEKHhEsMKD5egI5MqVDMkpxdwtL2
         b3cARr8B6rqPxa6ipKhzdB3d3nrU6eG2jDaNigb6kEuoGDh3NVzrHLt5Y7zKTsJcVb/D
         3R+WrX1zYt2X7E0OYrHFCfGBYhb7gQl6xqvxTkBoVNzynz/s1th146F8Hi05mt934X4q
         DFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ZOeHhEyMcgdvfj81lAu9cuYx0dDNeRXOzRvD3oT0zo=;
        b=nEn8zNchLEkn9e91+Fg7kgA068IT3nfJhTK+EPOqAJBvCCu5nWyRsk/MpW66Ytm3Hw
         d4qGQ0toxyurC3RYdJGVndx0alm2J+UnKsbn6fo6POyzdbkNd21xkz2VcBakF9M8hbHZ
         NR4U+zN6XwJfzN383pK/Eh3oG8wc43MBz/ug/pH9P6NyO9URjHaNnTAGy2eS3l/cWd9n
         Qijjd25m8j4F11GkdOqmxO6pOuPGF3CA01pXzYLHOI9zwybK7l4pDIZB78ONLwJAYVv6
         Cpl3hT7rHZZ4ztkiZri03iVO1EqL1tcvQamK/eB5nxjcxeMp+6Ax9kp+DfY+Idm3ZrOr
         ocSg==
X-Gm-Message-State: AOAM531I5D69bakHvhLhpDQPRG1NvQoOvKWau99UTk6M857Cto7CNK4c
        +jfDJ0BjtKNU6D7wRsV95y1vyoBBXFMsS6A+gMg=
X-Google-Smtp-Source: ABdhPJy7C9YgwRoStEvMoJPRDtvhlxVi8leIQ6CcGOTAOyf1W5tevC2Bg4PXTpex9XuNPw7GE0sKZT6MRMCS5W6JwCQ=
X-Received: by 2002:a19:c311:: with SMTP id t17mr1861769lff.58.1592317583936;
 Tue, 16 Jun 2020 07:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200615150613.21698-1-ap420073@gmail.com> <e879112d-3285-d6d8-457b-2ae2f8d38aaf@gmail.com>
In-Reply-To: <e879112d-3285-d6d8-457b-2ae2f8d38aaf@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 16 Jun 2020 23:26:12 +0900
Message-ID: <CAMArcTWgUtyqf+wa90TbwebWoYhbeyhv9nK3xDtyc6smNQp8qQ@mail.gmail.com>
Subject: Re: [PATCH net] ip_tunnel: fix use-after-free in ip_tunnel_lookup()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, pshelar@nicira.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 01:02, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>

Hi Eric,
Thank you for the review!

>
> On 6/15/20 8:06 AM, Taehee Yoo wrote:
> > In the datapath, the ip_tunnel_lookup() is used and it internally uses
> > fallback tunnel device pointer, which is fb_tunnel_dev.
> > This pointer is protected by RTNL. It's not enough to be used
> > in the datapath.
> > So, this pointer would be used after an interface is deleted.
> > It eventually results in the use-after-free problem.
> >
> > In order to avoid the problem, the new tunnel pointer variable is added,
> > which indicates a fallback tunnel device's tunnel pointer.
> > This is protected by both RTNL and RCU.
> > So, it's safe to be used in the datapath.
> >
> > Test commands:
> >     ip netns add A
> >     ip netns add B
> >     ip link add eth0 type veth peer name eth1
> >     ip link set eth0 netns A
> >     ip link set eth1 netns B
> >
> >     ip netns exec A ip link set lo up
> >     ip netns exec A ip link set eth0 up
> >     ip netns exec A ip link add gre1 type gre local 10.0.0.1 \
> >           remote 10.0.0.2
> >     ip netns exec A ip link set gre1 up
> >     ip netns exec A ip a a 10.0.100.1/24 dev gre1
> >     ip netns exec A ip a a 10.0.0.1/24 dev eth0
> >
> >     ip netns exec B ip link set lo up
> >     ip netns exec B ip link set eth1 up
> >     ip netns exec B ip link add gre1 type gre local 10.0.0.2 \
> >           remote 10.0.0.1
> >     ip netns exec B ip link set gre1 up
> >     ip netns exec B ip a a 10.0.100.2/24 dev gre1
> >     ip netns exec B ip a a 10.0.0.2/24 dev eth1
> >     ip netns exec A hping3 10.0.100.2 -2 --flood -d 60000 &
> >     ip netns del B
> >
> > Splat looks like:
> > [  133.319668][    C3] BUG: KASAN: use-after-free in ip_tunnel_lookup+0x9d6/0xde0
> > [  133.343852][    C3] Read of size 4 at addr ffff8880b1701c84 by task hping3/1222
> > [  133.344724][    C3]
> > [  133.345002][    C3] CPU: 3 PID: 1222 Comm: hping3 Not tainted 5.7.0+ #591
> > [  133.345814][    C3] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> > [  133.373336][    C3] Call Trace:
> > [  133.374792][    C3]  <IRQ>
> > [  133.375205][    C3]  dump_stack+0x96/0xdb
> > [  133.375789][    C3]  print_address_description.constprop.6+0x2cc/0x450
> > [  133.376720][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
> > [  133.377431][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
> > [  133.378130][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
> > [  133.378851][    C3]  kasan_report+0x154/0x190
> > [  133.379494][    C3]  ? ip_tunnel_lookup+0x9d6/0xde0
> > [  133.380200][    C3]  ip_tunnel_lookup+0x9d6/0xde0
> > [  133.380894][    C3]  __ipgre_rcv+0x1ab/0xaa0 [ip_gre]
> > [  133.381630][    C3]  ? rcu_read_lock_sched_held+0xc0/0xc0
> > [  133.382429][    C3]  gre_rcv+0x304/0x1910 [ip_gre]
> > [ ... ]
> >
> > Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  include/net/ip_tunnels.h |  1 +
> >  net/ipv4/ip_tunnel.c     | 11 ++++++++---
> >  2 files changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> > index 076e5d7db7d3..7442c517bb75 100644
> > --- a/include/net/ip_tunnels.h
> > +++ b/include/net/ip_tunnels.h
> > @@ -164,6 +164,7 @@ struct ip_tunnel_net {
> >       struct rtnl_link_ops *rtnl_link_ops;
> >       struct hlist_head tunnels[IP_TNL_HASH_SIZE];
> >       struct ip_tunnel __rcu *collect_md_tun;
> > +     struct ip_tunnel __rcu *fb_tun;
> >       int type;
> >  };
> >
> > diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> > index f4f1d11eab50..285b863e2fcc 100644
> > --- a/net/ipv4/ip_tunnel.c
> > +++ b/net/ipv4/ip_tunnel.c
> > @@ -162,8 +162,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
> >       if (t && t->dev->flags & IFF_UP)
> >               return t;
> >
> > -     if (itn->fb_tunnel_dev && itn->fb_tunnel_dev->flags & IFF_UP)
> > -             return netdev_priv(itn->fb_tunnel_dev);
> > +     t = rcu_dereference(itn->fb_tun);
> > +     if (t && t->dev->flags & IFF_UP)
> > +             return t;
> >
>
> There is no need for a new variable.
>
> Your patch does not add any new rcu grace period, so it seems obvious that you
> relied on existing grace periods.
>
> The real question is why ip_tunnel_uninit() does not clear itn->fb_tunnel_dev
>
> And of course why ip_tunnel_lookup() does not a READ_ONCE()
>
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index f4f1d11eab502290f9d74e2c8aafd69bceb58763..2416aa33d3645e1da967ec4c914564c5727a4d80 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -87,6 +87,7 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
>  {
>         unsigned int hash;
>         struct ip_tunnel *t, *cand = NULL;
> +       struct net_device *ndev;
>         struct hlist_head *head;
>
>         hash = ip_tunnel_hash(key, remote);
> @@ -162,8 +163,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
>         if (t && t->dev->flags & IFF_UP)
>                 return t;
>
> -       if (itn->fb_tunnel_dev && itn->fb_tunnel_dev->flags & IFF_UP)
> -               return netdev_priv(itn->fb_tunnel_dev);
> +       ndev = READ_ONCE(itn->fb_tunnel_dev);
> +       if (ndev && ndev->flags & IFF_UP)
> +               return netdev_priv(ndev);
>
>         return NULL;
>  }
>

Thank you for the suggestion.
I tested this approach and it works well,
So, I will send a v2 patch soon.

Thanks a lot!
Taehee Yoo
