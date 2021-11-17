Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7499D454EB7
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 21:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhKQUuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 15:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhKQUuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 15:50:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03A0C61AED;
        Wed, 17 Nov 2021 20:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637182028;
        bh=RBBvp9wqNCI5uPemEr/vkumlgg05bRAYE/Vd0ArtB+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y2oFqYEL9ywl31ryvnCZsY34dYu7vJgHumobj4MQTE79f6ej5HBbR/WsdHTFJT2G2
         dt8TjE2PNlJcY2cvrn3nnXtb0nu7tLUjRLu+zweL7aYduXLsHu7oPPXnePckTjhJ4b
         kWh/UXI+ybxpzfRLDxV1wdJIoyl4T1kK7ZlNeS4xyIdrVvo6M2HytkTqoYdRJvTMqN
         zdzLmvBI5BQkRMU2NTlTc9VXsPkSjjByFe6dT1PHJmEggOnuhkHd9hxB8WSJxAC1m6
         y+v4eiIWx69f6VU6/o+DArTiUSLYq/Ikw3sfJkYls0mWexyEfWTw2X6O/+TZVhc+Or
         p9CE5QdrmDJtA==
Date:   Wed, 17 Nov 2021 12:47:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
Message-ID: <20211117124706.79fd08c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJ8HLjjpBPyFOn3xTXSnOJCbOGq5gORgPnsws-+sB8ipA@mail.gmail.com>
References: <20211117192031.3906502-1-eric.dumazet@gmail.com>
        <20211117192031.3906502-2-eric.dumazet@gmail.com>
        <20211117120347.5176b96f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJ8HLjjpBPyFOn3xTXSnOJCbOGq5gORgPnsws-+sB8ipA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 12:16:15 -0800 Eric Dumazet wrote:
> On Wed, Nov 17, 2021 at 12:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Looks great, this is what I had in mind when I said:
> >
> > | In the future we can extend this structure to also catch those
> > | who fail to release the ref on unregistering notification.
> >
> > I realized today we can get quite a lot of coverage by just plugging
> > in object debug infra.
> >
> > The main differences I see:
> >  - do we ever want to use this in prod? - if not why allocate the
> >    tracker itself dynamically? The double pointer interface seems
> >    harder to compile out completely  
> 
> I think that maintaining the tracking state in separate storage would
> detect cases where the object has been freed, without the help of KASAN.

Makes sense, I guess we can hang more of the information of a secondary
object?

Maybe I'm missing a trick on how to make the feature consume no space
when disabled via Kconfig.

> >  - whether one stored netdev ptr can hold multiple refs  
> 
> For a same stack depot then ?

Not necessarily.

> Problem is that at the time of dev_hold(), we do not know if
> there is one associated dev_put() or multiple ones (different stack depot)

Ack. My thinking was hold all stacks until tracker is completely
drained of refs. We'd have to collect both hold and put stacks in
that case and if ref leak happens try to match them up manually 
later (manually == human).

But if we can get away without allowing multiple refs with one tracker
that makes life easier, and is probably a cleaner API, anyway.

> >  - do we want to wrap the pointer itself or have the "tracker" object
> >    be a separate entity
> >  - do we want to catch "use after free" when ref is accessed after
> >    it was already released
> >
> > No strong preference either way.  
> 
> BTW my current suspicion about reported leaks is in
> rt6_uncached_list_flush_dev()
> 
> I was considering something like
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 5e8f2f15607db7e6589b8bdb984e62512ad30589..233931b7c547d852ed3adeaa15f0a48f437b6596
> 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -163,9 +163,6 @@ static void rt6_uncached_list_flush_dev(struct net
> *net, struct net_device *dev)
>         struct net_device *loopback_dev = net->loopback_dev;
>         int cpu;
> 
> -       if (dev == loopback_dev)
> -               return;
> -
>         for_each_possible_cpu(cpu) {
>                 struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
>                 struct rt6_info *rt;
> @@ -175,7 +172,7 @@ static void rt6_uncached_list_flush_dev(struct net
> *net, struct net_device *dev)
>                         struct inet6_dev *rt_idev = rt->rt6i_idev;
>                         struct net_device *rt_dev = rt->dst.dev;
> 
> -                       if (rt_idev->dev == dev) {
> +                       if (rt_idev->dev == dev && dev != loopback_dev) {
>                                 rt->rt6i_idev = in6_dev_get(loopback_dev);
>                                 in6_dev_put(rt_idev);
>                         }

Interesting.
