Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF4A1E6987
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405856AbgE1ShK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:37:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405787AbgE1ShH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 14:37:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ha0L+pY1ahPfqpCjj/RN++1zumEsiwvIImmndX9b+9Q=; b=NLwFmw6o7SUBUZqhEek8/rKMHu
        pOeRRK6F6HiFbeVkH2l8UhnKYs/tkFRwzdZi9nxN62itwNekyBOLey2Mxj1ODvbAUbqRGw0FAXeRm
        BCaJGxQ0vhyboCdzNjJGAItz1WQz7bzEeYIBk4s+13xM3FbGrALWdgaRBeFfXUTDh0Lg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeNOp-003Z6y-0n; Thu, 28 May 2020 20:37:03 +0200
Date:   Thu, 28 May 2020 20:37:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Amit Cohen <amitc@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>
Subject: Re: Link down reasons
Message-ID: <20200528183703.GB849697@lunn.ch>
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com>
 <20200527213843.GC818296@lunn.ch>
 <AM0PR0502MB38267B345D7829A00790285DD78E0@AM0PR0502MB3826.eurprd05.prod.outlook.com>
 <87zh9stocb.fsf@mellanox.com>
 <20200528154010.GD840827@lunn.ch>
 <87r1v4t2yn.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1v4t2yn.fsf@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 06:54:24PM +0200, Petr Machata wrote:
> 
> Andrew Lunn <andrew@lunn.ch> writes:
> 
> >> Andrew, pardon my ignorance in these matters, can a PHY driver in
> >> general determine that the issue is with the cable, even without running
> >> the fairly expensive cable test?
> >
> > No. To diagnose a problem, you need the link to be idle. If the link
> > peer is sending frames, they interfere with TDR. So all the cable
> > testing i've seen first manipulates the auto-negotiation to make the
> > link peer go quiet. That takes 1 1/2 seconds. There are some
> > optimizations possible, e.g. if the cable is so broken it never
> > establishes link, you can skip this. But Ethernet tends to be robust,
> > it drops back to 100Mbps only using two pairs if one of the four pairs
> > is broken, for example.
> 
> OK, thanks. I suspect our FW is doing this behind the scenes, because it
> can report a shorted cable.
> 
> In another e-mail you suggested this:
> 
>     Link detected: no (cable issue)
> 
> But if the link just silently falls back to 100Mbps, there would never
> be an opportunity for phy to actually report a down reason. So there
> probably is no way for the phy layer to make use of this particular
> down reason.

It is called downshift. And we have support for it in the phylib core,
if the PHY has the needed vendor register.

https://elixir.bootlin.com/linux/v5.7-rc7/source/drivers/net/phy/phy-core.c#L341
https://elixir.bootlin.com/linux/v5.7-rc7/source/drivers/net/phy/phy.c#L95

There are also standard phylib/ethtool ways to configure it, how many
times the PHY should try to establish a 1G link before downshifting to
100M.

So in theory we could report:

Link detected: yes (downshifted)

Assuming your proposed API support a reason why it is up, not just a
reason why it is down?

	Andrew
