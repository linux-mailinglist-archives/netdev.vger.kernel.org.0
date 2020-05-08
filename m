Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71A21CB0F4
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgEHNuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:50:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49374 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbgEHNuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 09:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0CvO3nzCeYzmAG7v4H3v1bnPTQEvZI0XVb0THrLVHZU=; b=qEbku4E7tGdn4bvZ2AqCPogEiY
        yJJ/wVjw710t9vomjNZoyvJwryIFnxXfumu6ROEH1IwG01MvQWyABUTALl0EFi2XAispGNha+aVUr
        bnngalDTZHRWZPQdmasRhs3qYNJDw9FJkDqSaQTHlgMXpROGlGclCZ3iQJhgIOaT57fA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jX3OM-001NQQ-H2; Fri, 08 May 2020 15:50:18 +0200
Date:   Fri, 8 May 2020 15:50:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 7/7] net: atlantic: unify
 get_mac_permanent
Message-ID: <20200508135018.GE298574@lunn.ch>
References: <20200507081510.2120-1-irusskikh@marvell.com>
 <20200507081510.2120-8-irusskikh@marvell.com>
 <20200507122957.5dd4b84b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <628e45f4-048a-2b8f-10c8-5b1908d54cc8@marvell.com>
 <20200508131042.GP208718@lunn.ch>
 <41cbd649-6896-9284-694d-316c10ca17ea@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41cbd649-6896-9284-694d-316c10ca17ea@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 04:22:40PM +0300, Igor Russkikh wrote:
> 
> >>> Right, but why do you have your own mac generation rather than using
> >>> eth_hw_addr_random(). You need to set NET_ADDR_RANDOM for example,
> >>> just use standard helpers, please.
> >>
> >> We want this still be an Aquantia vendor id MAC, not a fully random mac.
> >> Thats why the logic below randomizes only low three octets.
> > 
> > Hi Igor
> > 
> > How safe is that?  It reduces the available pool space by 22
> > bits. It greatly increases the likelihood of a collision.
> 
> >>>> +	get_random_bytes(&rnd, sizeof(unsigned int));
> >>>> +	l = 0xE300 0000U | (0xFFFFU & rnd) | (0x00 << 16);
> >>>> +	h = 0x8001300EU;
> > 
> > Is this Marvell/Aquantias OUI? Are you setting the locally
> > administered bit? You probably should be, since this is local, not
> > issued with a guarantee of being unique. 
> 
> Yes, thats Aquantia's ID: 300EE3
> 
> Honestly, the subject of the discussion are only adapters with zeroed, not
> burned MACs. In production there could not exist such adapters. We do have
> this code mainly to cover engineering samples some of which comes unflashed.
> 
> So overall, I feel its abit overkill to care about collisions.
> But we still like to see our engineering samples to have our OUI for ease of
> scripting and maintenance.

Hi Igor

At minimum, you need to put this as a comment.

And since it is not supposed to happen, you might want to throw a
WARN_ON(). The fact you are somewhat hiding the problem the FLASH is
empty, makes it more likely you actually ship unflashed devices to the
customers. A big scary looking kernel stack trace should swing the
risk back towards the safer side, and if manufacturing does mess up,
you are likely to get feedback from customers pretty quickly.

     Andrew
