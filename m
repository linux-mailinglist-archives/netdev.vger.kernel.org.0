Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FA53068A5
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhA1A13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhA1A06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 19:26:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14505C06174A;
        Wed, 27 Jan 2021 16:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rFBuMS2tjYDKpM8WxueTglpTPZjBKKc9LM/AhTqrSxg=; b=DGrIpVSj7hgqSfObvaMbGkQQm
        4rb9r8jfJiO81ddjuEMYK/g09ZO4y1q1gZuwogs5QZ12xh9Ijh1e37PJ1DO5mOGoq+0aJ1XL4YriV
        KPOdddlykdpogSY8ucLd173YrbQYYJKqpaV6MHfYg/SX0JKbtc0LlHozbCj5t03dOCGuWCfpywzYF
        JmWKJW5Kgr0IIHDfiIkMVK11bIjcpe2WQWscYBp/eMDK2eUCkTcN59zh83uvuzDboM4KMItLMq2GT
        DS1bEq2g8qILW2TkGdM7CQXEWgG+oQVWFvO93VUraXDaBsgTbweA35LhPyb3CRoqRQhm8xQhmbkxY
        X8N2FFz8A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53576)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l4v8G-00068o-O6; Thu, 28 Jan 2021 00:25:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l4v8F-0005Gj-5q; Thu, 28 Jan 2021 00:25:55 +0000
Date:   Thu, 28 Jan 2021 00:25:55 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mike Looijmans <mike.looijmans@topic.nl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
Message-ID: <20210128002555.GQ1551@shell.armlinux.org.uk>
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
 <YBAVwFlLsfVEHd+E@lunn.ch>
 <20210126134937.GI1551@shell.armlinux.org.uk>
 <YBH+uUUatjfwqFWq@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBH+uUUatjfwqFWq@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 01:00:57AM +0100, Andrew Lunn wrote:
> On Tue, Jan 26, 2021 at 01:49:38PM +0000, Russell King - ARM Linux admin wrote:
> > On Tue, Jan 26, 2021 at 02:14:40PM +0100, Andrew Lunn wrote:
> > > On Tue, Jan 26, 2021 at 08:33:37AM +0100, Mike Looijmans wrote:
> > > > The mdio_bus reset code first de-asserted the reset by allocating with
> > > > GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, if
> > > > the reset signal defaulted to asserted, there'd be a short "spike"
> > > > before the reset.
> > > > 
> > > > Instead, directly assert the reset signal using GPIOD_OUT_HIGH, this
> > > > removes the spike and also removes a line of code since the signal
> > > > is already high.
> > > 
> > > Hi Mike
> > > 
> > > This however appears to remove the reset pulse, if the reset line was
> > > already low to start with. Notice you left
> > > 
> > > fsleep(bus->reset_delay_us);
> > > 
> > > without any action before it? What are we now waiting for?  Most data
> > > sheets talk of a reset pulse. Take the reset line high, wait for some
> > > time, take the reset low, wait for some time, and then start talking
> > > to the PHY. I think with this patch, we have lost the guarantee of a
> > > low to high transition.
> > > 
> > > Is this spike, followed by a pulse actually causing you problems? If
> > > so, i would actually suggest adding another delay, to stretch the
> > > spike. We have no control over the initial state of the reset line, it
> > > is how the bootloader left it, we have to handle both states.
> > 
> > Andrew, I don't get what you're saying.
> > 
> > Here is what happens depending on the pre-existing state of the
> > reset signal:
> > 
> > Reset (previously asserted):   ~~~|_|~~~~|_______
> > Reset (previously deasserted): _____|~~~~|_______
> >                                   ^ ^    ^
> >                                   A B    C
> > 
> > At point A, the low going transition is because the reset line is
> > requested using GPIOD_OUT_LOW. If the line is successfully requested,
> > the first thing we do is set it high _without_ any delay. This is
> > point B. So, a glitch occurs between A and B.
> > 
> > We then fsleep() and finally set the GPIO low at point C.
> > 
> > Requesting the line using GPIOD_OUT_HIGH eliminates the A and B
> > transitions. Instead we get:
> > 
> > Reset (previously asserted)  : ~~~~~~~~~~|______
> > Reset (previously deasserted): ____|~~~~~|______
> >                                    ^     ^
> >                                    A     C
> > 
> > Where A and C are the points described above in the code. Point B
> > has been eliminated.
> > 
> > Therefore, to me the patch looks entirely reasonable and correct.
> 
> I wonder if there are any PHYs which actually need a pulse? Would it
> be better to have:
> 
>  Reset (previously asserted):   ~~~|____|~~~~|_______
>  Reset (previously deasserted): ________|~~~~|_______
>                                    ^    ^    ^    ^
>                                    A    B    C    D
> 
> Point D is where we actually start talking to the PHY. C-D is
> reset-post-delay-us, and defaults to 0, but can be set via DT.  B-C is
> reset-delay-us, and defaults to 10us, but can be set via DT.
> Currently A-B is '0', so we get the glitch. But should we make A-B the
> same as B-C, so we get a real pulse?

I do not see any need for A-B - what is the reason for it? You will
find most datasheets talk about a clock must be active for some number
of clock cycles prior to the reset signal being released, or minimum
delay after power up before reset is released, or talking about a
minimum pulse width.

Note that looking at a few of the Marvell PHY datasheets, they require
a minimum reset pulse width of 10ms and between 5ms and 50ms before
the first access. AR8035 also talks about 10ms.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
