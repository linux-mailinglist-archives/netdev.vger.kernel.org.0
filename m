Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE611FBBE0
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgFPQhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728860AbgFPQhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 12:37:55 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A6EC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:37:54 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y11so24396234ljm.9
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H/PkMNu3EGHUvRSoM2VBWjp9m9bP5mTdUAT45PhR6+0=;
        b=lidvq+J6lY0JeurytV0NEiwpxa5X+6Z5rGOgEBUpJF/M6IAZZQz4rS5KL5Bo0Y9sql
         neRGF1NfU8/iZh9H7ix20V3PB4KRUE0WhFZ1ayD/ajsW/tcT1QJ5YCkStUu+562pux8z
         qmhJ1qIIs3RTa10KTOSkO6rChUPxZbnCZB/9JacFPrNQS9BoZR5ah+5dqpDoOiBfik2Q
         hSX1j4oSVvqdNpYhNbXPwWaSakiLhkKeL0ri2tR7ddrOYu32IKEyeoPEe/cm1T+7PuYj
         NTgFnJJAs2GOP7BkLkZTJ77DPAOKs93Bd8/N/UXFWm8onmeJseBONfMNXUOyRFPy13BB
         Si3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H/PkMNu3EGHUvRSoM2VBWjp9m9bP5mTdUAT45PhR6+0=;
        b=StWMqD5mri1mzmppwmK2S0th6itEvTNg6+lq3AV7pVwPRNboJBCC4B7VxpjPzJWA0y
         sYEUC8AGNDp86jmYTuBWESwl2edF5g+KOM57CRr6n/qfCtbpV6UW7ilZXpMr5U7q7KBD
         3H+b4pH6e0wKkYwGU2xpuogDV9JQFf+4KBxMZq6ZxceUx8vTa3H1rLDXT8OgmedBDUoe
         jKALavbIQxgqOA/XIH4TrpwKrU4fZu3PixH5kwd/KL5FKPWZZA95XNaIlMyqPRN0UTI3
         IGlNpMtGQedjcGTrgN6t3zZXOVlh4yzv/UF1wUxMF39FaGuSXxuKRSYlcT4TFNt8c6OH
         cDOw==
X-Gm-Message-State: AOAM530jrHeZKZvtiO9IkCYv1zXI5CZ5Ne0UHi56N61/mkKUzXFf0l0P
        5MqWOXaAT20sU10PUwicdcCxzWafu1y0sYbrPPk=
X-Google-Smtp-Source: ABdhPJzR12O5u26mquNCI67vzC7klk04bGfep/We9lDW/Av/WOi0Zs6rH27qCEgiWaUvTOJ0+WE+94aegTCjeZo5xpE=
X-Received: by 2002:a2e:5c2:: with SMTP id 185mr1751283ljf.260.1592325472742;
 Tue, 16 Jun 2020 09:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200616160153.8479-1-ap420073@gmail.com> <fd5f2683-caac-6ed1-7da7-11e8fce2fe42@gmail.com>
In-Reply-To: <fd5f2683-caac-6ed1-7da7-11e8fce2fe42@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 17 Jun 2020 01:37:41 +0900
Message-ID: <CAMArcTXY4NNBuJPgj1YW0EH=pivom9MM96nSUsxrg=sgY_BXcQ@mail.gmail.com>
Subject: Re: [PATCH net v2] ip_tunnel: fix use-after-free in ip_tunnel_lookup()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, pshelar@nicira.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 at 01:16, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>

Hi Eric,
Thank you for the review :)

>
> On 6/16/20 9:01 AM, Taehee Yoo wrote:
> > In the datapath, the ip_tunnel_lookup() is used and it internally uses
> > fallback tunnel device pointer, which is fb_tunnel_dev.
> > This pointer variable should be set to NULL when a fb interface is deleted.
> > But there is no routine to set fb_tunnel_dev pointer to NULL.
> > So, this pointer will be still used after interface is deleted and
> > it eventually results in the use-after-free problem.
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
> > Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >
> > v1 -> v2:
> >  - Do not add a new variable.
> >
> >  net/ipv4/ip_tunnel.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> > index f4f1d11eab50..701f150f11e1 100644
> > --- a/net/ipv4/ip_tunnel.c
> > +++ b/net/ipv4/ip_tunnel.c
> > @@ -85,9 +85,10 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
> >                                  __be32 remote, __be32 local,
> >                                  __be32 key)
> >  {
> > -     unsigned int hash;
> >       struct ip_tunnel *t, *cand = NULL;
> >       struct hlist_head *head;
> > +     struct net_device *ndev;
> > +     unsigned int hash;
> >
> >       hash = ip_tunnel_hash(key, remote);
> >       head = &itn->tunnels[hash];
> > @@ -162,8 +163,9 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
> >       if (t && t->dev->flags & IFF_UP)
> >               return t;
> >
> > -     if (itn->fb_tunnel_dev && itn->fb_tunnel_dev->flags & IFF_UP)
> > -             return netdev_priv(itn->fb_tunnel_dev);
> > +     ndev = READ_ONCE(itn->fb_tunnel_dev);
> > +     if (ndev && ndev->flags & IFF_UP)
> > +             return netdev_priv(ndev);
> >
> >       return NULL;
> >  }
> > @@ -1260,8 +1262,9 @@ void ip_tunnel_uninit(struct net_device *dev)
> >
> >       itn = net_generic(net, tunnel->ip_tnl_net_id);
> >       /* fb_tunnel_dev will be unregisted in net-exit call. */
>
> Is this comment still correct ?
>

I think this comment is not valid anymore.
I will remove this comment in a v3 patch.

Thanks a lot!
Taehee Yoo
