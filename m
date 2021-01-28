Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28FF306859
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhA1ABy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:01:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhA1ABs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:01:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4uk5-002wYP-7G; Thu, 28 Jan 2021 01:00:57 +0100
Date:   Thu, 28 Jan 2021 01:00:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Mike Looijmans <mike.looijmans@topic.nl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
Message-ID: <YBH+uUUatjfwqFWq@lunn.ch>
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
 <YBAVwFlLsfVEHd+E@lunn.ch>
 <20210126134937.GI1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126134937.GI1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 01:49:38PM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Jan 26, 2021 at 02:14:40PM +0100, Andrew Lunn wrote:
> > On Tue, Jan 26, 2021 at 08:33:37AM +0100, Mike Looijmans wrote:
> > > The mdio_bus reset code first de-asserted the reset by allocating with
> > > GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, if
> > > the reset signal defaulted to asserted, there'd be a short "spike"
> > > before the reset.
> > > 
> > > Instead, directly assert the reset signal using GPIOD_OUT_HIGH, this
> > > removes the spike and also removes a line of code since the signal
> > > is already high.
> > 
> > Hi Mike
> > 
> > This however appears to remove the reset pulse, if the reset line was
> > already low to start with. Notice you left
> > 
> > fsleep(bus->reset_delay_us);
> > 
> > without any action before it? What are we now waiting for?  Most data
> > sheets talk of a reset pulse. Take the reset line high, wait for some
> > time, take the reset low, wait for some time, and then start talking
> > to the PHY. I think with this patch, we have lost the guarantee of a
> > low to high transition.
> > 
> > Is this spike, followed by a pulse actually causing you problems? If
> > so, i would actually suggest adding another delay, to stretch the
> > spike. We have no control over the initial state of the reset line, it
> > is how the bootloader left it, we have to handle both states.
> 
> Andrew, I don't get what you're saying.
> 
> Here is what happens depending on the pre-existing state of the
> reset signal:
> 
> Reset (previously asserted):   ~~~|_|~~~~|_______
> Reset (previously deasserted): _____|~~~~|_______
>                                   ^ ^    ^
>                                   A B    C
> 
> At point A, the low going transition is because the reset line is
> requested using GPIOD_OUT_LOW. If the line is successfully requested,
> the first thing we do is set it high _without_ any delay. This is
> point B. So, a glitch occurs between A and B.
> 
> We then fsleep() and finally set the GPIO low at point C.
> 
> Requesting the line using GPIOD_OUT_HIGH eliminates the A and B
> transitions. Instead we get:
> 
> Reset (previously asserted)  : ~~~~~~~~~~|______
> Reset (previously deasserted): ____|~~~~~|______
>                                    ^     ^
>                                    A     C
> 
> Where A and C are the points described above in the code. Point B
> has been eliminated.
> 
> Therefore, to me the patch looks entirely reasonable and correct.

I wonder if there are any PHYs which actually need a pulse? Would it
be better to have:

 Reset (previously asserted):   ~~~|____|~~~~|_______
 Reset (previously deasserted): ________|~~~~|_______
                                   ^    ^    ^    ^
                                   A    B    C    D

Point D is where we actually start talking to the PHY. C-D is
reset-post-delay-us, and defaults to 0, but can be set via DT.  B-C is
reset-delay-us, and defaults to 10us, but can be set via DT.
Currently A-B is '0', so we get the glitch. But should we make A-B the
same as B-C, so we get a real pulse?

     Andrew
