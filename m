Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511B934783E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 13:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbhCXMT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 08:19:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhCXMTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 08:19:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F7C1619B4;
        Wed, 24 Mar 2021 12:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616588377;
        bh=g3QpnsnwTPi/Tg6+gkouW2j40tjerv0wDeLnR0N2ajY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N6SsOa/hmmFY5fe4y3Tr1toEbNGth8V2VE02ccG0u73F+uQJ0iqF2jE33du5rIiUT
         8UjrAzEPkncJCwslm55UN6/KxMIw4W/BlG98M12P169E2RMmKgqGqt7EunVZkwAelB
         yOV+nANDI25ngfD9GWQ7IweaFiiMUDswKDtzQIIwHNgAr5uVpaph3OCPEnMJ6ew9oU
         8D+U8sEdC9WP8/LBTujHl5uhZbXlP47gtw+jS2CokCzGtV1mtnwAMuKpEmiebobVy7
         GEKpWoxeBgJKEhEqdPF6fVFYh7zoQefNO1nFAQXh6N0NI3NjDDQU/eBH0iUCb3OSzn
         bMfQfnx7uHg4Q==
Date:   Wed, 24 Mar 2021 14:19:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        yejune@gmail.com
Subject: Re: [PATCH 1/2] net: ipv4: route.c: add likely() statements
Message-ID: <YFsuVDncNFiuonSx@unreal>
References: <20210324030923.17203-1-yejune.deng@gmail.com>
 <YFsVzP6P9l0aaIVo@unreal>
 <CABWKuGUPkMHZj6qsAYmCnc==4pP8vyYK-3TRJ9oG8mk=nJBLAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABWKuGUPkMHZj6qsAYmCnc==4pP8vyYK-3TRJ9oG8mk=nJBLAw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 07:01:19PM +0800, Yejune Deng wrote:
> My reasons are as following: ipv4_confirm_neigh() belongs to
> ipv4_dst_ops that family is AF_INET, and ipv4_neigh_lookup() is also
> added likely() when rt->rt_gw_family is equal to AF_INET.

It is part of that cargo cult. Please support your claim with
performance numbers when this likely/unlikely will give any difference.

Thanks

> 
> On Wed, Mar 24, 2021 at 6:34 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Mar 24, 2021 at 11:09:22AM +0800, Yejune Deng wrote:
> > > Add likely() statements in ipv4_confirm_neigh() for 'rt->rt_gw_family
> > > == AF_INET'.
> >
> > Why? Such macros are beneficial in only specific cases, most of the time,
> > likely/unlikely is cargo cult.
> >
> > >
> > > Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> > > ---
> > >  net/ipv4/route.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> > > index fa68c2612252..5762d9bc671c 100644
> > > --- a/net/ipv4/route.c
> > > +++ b/net/ipv4/route.c
> > > @@ -440,7 +440,7 @@ static void ipv4_confirm_neigh(const struct dst_entry *dst, const void *daddr)
> > >       struct net_device *dev = dst->dev;
> > >       const __be32 *pkey = daddr;
> > >
> > > -     if (rt->rt_gw_family == AF_INET) {
> > > +     if (likely(rt->rt_gw_family == AF_INET)) {
> > >               pkey = (const __be32 *)&rt->rt_gw4;
> > >       } else if (rt->rt_gw_family == AF_INET6) {
> > >               return __ipv6_confirm_neigh_stub(dev, &rt->rt_gw6);
> > > --
> > > 2.29.0
> > >
