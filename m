Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C349D3FA045
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhH0UFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:05:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231151AbhH0UFG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 16:05:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ejKXtKAr8+r9AdwhEiiNoR0BPS8+PQv/LW1hlHh2I78=; b=fH8Q2+rqn+iwZzAPUcqFfXhC7R
        Qp7n5zNSDxWpdzBZ0vFeCOqEE9J69KozW3Ya7enfaJZin8ECHxyng1yoFYPnerHdShvP8P6yDnUlo
        AfyX+rA6hg57sPXyXMSRzPRGs8Ix/xTelseAPKpIsOZfOyYYpwypqNQIA9xmIRHXLSnQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJi5G-004A77-Sf; Fri, 27 Aug 2021 22:04:14 +0200
Date:   Fri, 27 Aug 2021 22:04:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: stop calling
 irq_domain_add_simple with the reg_lock held
Message-ID: <YSlFPhtmcI116ciO@lunn.ch>
References: <20210827180101.2330929-1-vladimir.oltean@nxp.com>
 <YSkwOWoynVOs5i8n@lunn.ch>
 <20210827184525.p44pir5or4h5nwgk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827184525.p44pir5or4h5nwgk@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 09:45:25PM +0300, Vladimir Oltean wrote:
> On Fri, Aug 27, 2021 at 08:34:33PM +0200, Andrew Lunn wrote:
> > On Fri, Aug 27, 2021 at 09:01:01PM +0300, Vladimir Oltean wrote:
> > > The mv88e6xxx IRQ setup code has some pretty horrible locking patterns,
> > > and wrong.
> >
> > I agree about the patterns. But it has been lockdep clean, i spent a
> > while testing it, failed probes, unloads etc, and adding comments.
> >
> > I suspect it is now wrong because of core changes.
> 
> It's true, it is lockdep-clean the way it is structured now, but I
> suspect that is purely by chance. I had to shift code around a bit to
> get lockdep to shout, my bad for not really mentioning it: I moved
> mv88e6xxx_mdios_register from mv88e6xxx_probe to mv88e6xxx_setup, all in
> all a relatively superficial change (I am trying to test something out),

That move is actually quite interesting. It can cut down the probe
time quite a bit, which is important when you know the first probe is
going to fail anyway with an EPRODE_DEFER. But we have to be careful
with MDIO busses, as you can see from the other discussions.

> I empathize with working in the blind w.r.t. locking, when rtnl_mutex
> covers everything. As you point out, threaded interrupts do not the
> rtnl_lock, so that is a good opportunity to analyze what needs serialization,
> which I do not have on sja1105. Nonetheless, my experience is that
> hardware is a pretty parallel/reentrant beast, a "register lock" is
> almost always the wrong answer.

That lock has been there since forever. And the driver was written by
a Marvell Switch engineer. Maybe it is not needed, but i'm hesitant to
take it out.

> Ok, retarget to "net-next"?

I would prefer to wait until you have finished your testing and have
something which builds upon it. If its not broken, don't fix it...

	  Andrew
