Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABE44A8C0D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiBCS6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiBCS6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:58:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCDFC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 10:58:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0E516193E
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 18:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6F3C340E8;
        Thu,  3 Feb 2022 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643914724;
        bh=8DihN9W4zrfwKu78/gu8BmLnMbMpZD4PpZcdoeNaaes=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M65rwIZJTg24olIoyXGqRrB4Rzuy1zg+bg/ftVnc0Lqn+S0+448NLreT2bBjuSmsx
         BfqvuEMo2pCKzkUt90PVY8wnnFTcD6U+NYqvkneMXoJhGFo69EFIsw/cw89iKk2Vf1
         SiTPK2w2jVPk0mgTxxoprv88NEMfkExWdICUhEAeWLTZZN2dCC6QbPJQRutljWz/NL
         cLtbWu+ad31PiSoCimU/M+F2HbypxJRlZq9RDJV1mwwrzD6irUe9hsQvQJV4uOGDy3
         szgtExFljk7SupbdxniFSMrxiVKdax0SrcdhKZC+tA5QvccSrSp3mu6rUaZmKiyQs9
         NQZSLpEoQVenw==
Date:   Thu, 3 Feb 2022 10:58:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH net-next 01/15] net: add netdev->tso_ipv6_max_size
 attribute
Message-ID: <20220203105842.60c25d46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iKd-M6Ry+K7m+n5Voo641K7S24qm27SwrP4VAAchVPT4A@mail.gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
        <20220203015140.3022854-2-eric.dumazet@gmail.com>
        <20220203083407.523721a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKd-M6Ry+K7m+n5Voo641K7S24qm27SwrP4VAAchVPT4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 08:56:56 -0800 Eric Dumazet wrote:
> On Thu, Feb 3, 2022 at 8:34 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed,  2 Feb 2022 17:51:26 -0800 Eric Dumazet wrote:  
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > Some NIC (or virtual devices) are LSOv2 compatible.
> > >
> > > BIG TCP plans using the large LSOv2 feature for IPv6.
> > >
> > > New netlink attribute IFLA_TSO_IPV6_MAX_SIZE is defined.
> > >
> > > Drivers should use netif_set_tso_ipv6_max_size() to advertize their limit.
> > >
> > > Unchanged drivers are not allowing big TSO packets to be sent.  
> >
> > Many drivers will have a limit on how many buffer descriptors they
> > can chain, not the size of the super frame, I'd think. Is that not
> > the case? We can't assume all pages but the first and last are full,
> > right?  
> 
> In our case, we have a 100Gbit Google NIC which has these limits:
> 
> - TX descriptor has a 16bit field filled with skb->len
> - No more than 21 frags per 'packet'
> 
> In order to support BIG TCP on it, we had to split the bigger TCP packets
> into smaller chunks, to satisfy both constraints (even if the second
> constraint is hardly hit once you chop to ~60KB packets, given our 4K
> MTU)
> 
> ndo_features_check() might help to take care of small oddities.

Makes sense, I was curious if we can do more in the core so that fewer
changes are required in the drivers. Both so that drivers don't have to
strip the header and so that drivers with limitations can be served 
pre-cooked smaller skbs.

> For instance I will insert the following in the next version of the series:
> 
> commit 26644be08edc2f14f6ec79f650cc4a5d380df498
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Feb 2 23:22:01 2022 -0800
> 
>     net: typhoon: implement ndo_features_check method
> 
>     Instead of disabling TSO if MAX_SKB_FRAGS > 32, implement
>     ndo_features_check() method for this driver.
> 
>     If skb has more than 32 frags, use the following heuristic:
> 
>     1) force GSO for gso packets
>     2) Otherwise force linearization.
> 
>     Most locally generated TCP packets will use a small number of fragments
>     anyway.
> 
>     Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> diff --git a/drivers/net/ethernet/3com/typhoon.c
> b/drivers/net/ethernet/3com/typhoon.c
> index 8aec5d9fbfef2803c181387537300502a937caf0..216e26a49e9c272ba7483bfa06941ff11ea40e3c
> 100644
> --- a/drivers/net/ethernet/3com/typhoon.c
> +++ b/drivers/net/ethernet/3com/typhoon.c
> @@ -138,11 +138,6 @@ MODULE_PARM_DESC(use_mmio, "Use MMIO (1) or
> PIO(0) to access the NIC. "
>  module_param(rx_copybreak, int, 0);
>  module_param(use_mmio, int, 0);
> 
> -#if defined(NETIF_F_TSO) && MAX_SKB_FRAGS > 32
> -#warning Typhoon only supports 32 entries in its SG list for TSO, disabling TSO
> -#undef NETIF_F_TSO
> -#endif

I wonder how many drivers just assumed MAX_SKB_FRAGS will never 
change :S What do you think about a device-level check in the core 
for number of frags?
