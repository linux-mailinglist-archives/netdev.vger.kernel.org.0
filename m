Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4A0102246
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfKSKu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:50:58 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49634 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSKu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 05:50:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rTGmdtHfB8D+RXUW/nszfm1Tcj14HyPbpRvI//ea+GA=; b=drUfrpN76KRffTDF1jsGzfqTC
        /VufvbrXBdvCeS/Bn72PdKZ6nWw7FS8HuMuNK6xDZ+EbF0RmLiJyRL+++KnDkfKzhfelqu4Tly/fz
        o3EtlTtN6ka0Z7PZKQxe1JAmh0FYvEYUw9t6bOJM9sc5NuejfDTOgsIwdNRrCSv32oK1hPEgwA9JE
        jzaeI+Z/E3/hAEwQNbogIKkg6hx+jRucW/zYdeaxL+SlUFSlrVShNU/atb/epVueWAOMWVHJ9IpYW
        osIjd/7baZcWM6egLSc9GfDA23Hpfi/XQolc/gYd4hJNY/mpqyUYjQFvolV2s6eCvNYS4GlK1kK2K
        yjrdNvjNw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:37534)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iX15t-0000kB-5o; Tue, 19 Nov 2019 10:50:49 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iX15p-0000et-Nh; Tue, 19 Nov 2019 10:50:45 +0000
Date:   Tue, 19 Nov 2019 10:50:45 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     hkallweit1@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: phy: add callback for custom
 interrupt handler to struct phy_driver
Message-ID: <20191119105045.GY25745@shell.armlinux.org.uk>
References: <acb8507d-d5a3-2190-8d5c-988f1062f2e7@gmail.com>
 <bd47f8e1ebc04fa98856ed8d89b91419@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd47f8e1ebc04fa98856ed8d89b91419@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 11:33:47AM +0100, Michael Walle wrote:
> 
> Hi,
> 
> this is an old thread and I know its already applied. But I'd like to hear
> your opinion on the following problem below.
> 
> > The phylib interrupt handler handles link change events only currently.
> > However PHY drivers may want to use other interrupt sources too,
> > e.g. to report temperature monitoring events. Therefore add a callback
> > to struct phy_driver allowing PHY drivers to implement a custom
> > interrupt handler.
> > 
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/phy.c | 9 +++++++--
> >  include/linux/phy.h   | 3 +++
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index d90d9863e..068f0a126 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -772,8 +772,13 @@ static irqreturn_t phy_interrupt(int irq, void
> > *phy_dat)
> >  	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
> >  		return IRQ_NONE;
> > 
> > -	/* reschedule state queue work to run as soon as possible */
> > -	phy_trigger_machine(phydev);
> > +	if (phydev->drv->handle_interrupt) {
> > +		if (phydev->drv->handle_interrupt(phydev))
> > +			goto phy_err;
> 
> There are PHYs which clears the interrupt already by reading the interrupt
> status register. To do something useful in handle_interrupt() I have to read
> the interrupt status register, thus clearing the pending interrupts.
> 
> 
> > +	} else {
> > +		/* reschedule state queue work to run as soon as possible */
> > +		phy_trigger_machine(phydev);
> > +	}
> > 
> >  	if (phy_clear_interrupt(phydev))
> >  		goto phy_err;
> 
> But here the interrupts are cleared again, which means we might loose
> interrupt causes in between.
> 
> I could think of two different fixes:
>  (1) handle_interrupt() has to take care to clear the interrupts and skip
> the phy_clear_interrupt() above.
>  (2) handle_interrupt() might return a special return code which skips the
> phy_clear_interrupt
> 
> TBH, I'd prefer (1) but I don't know if it is allowed to change semantics
> afterwards. (Also, I've found no driver where handle_interrupt() is actually
> used for now?)

I made the argument at the time that phylib should stop being a middle-
layer, but instead let PHY drivers take care of interrupt handling
themselves, just like we do elsewhere in the kernel.  I think your
case just shows that trying to keep the interrupt handling structured
inside phylib and trying to make all PHYs fit is just going to be
painful.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
