Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3619E329265
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243340AbhCAUoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 15:44:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243716AbhCAUjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 15:39:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA45964DD2;
        Mon,  1 Mar 2021 19:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614628103;
        bh=L7z+bXEPGaQ2t0yMpM59Ocy8uSDZcIvGcE4M5DwvzBc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=inksxpgOZ6/sqkNUMr/xdZG6XCduJYrjol1/glETKf06x0ju7y+0HEtI6sQlDVN2p
         8Hr4IojW4b2c1l+sgjw+i3pyuPGdYOG+umF6Ve94JBl843tqzBpMxzuZPuGyXK7NL1
         ih0saGOgGbtJrgEzVbngTCpEr8IIFk8TbMhruk/RG0x9S0FGLgqAqEEd6VoaRl6cH1
         4GIYq98SMEo5PzKiZpvR9RI3X1orRXVVFtzvtarA3Oab7zDUAU5dtxE04AEVY2ZRHM
         hsF8yL0L2TkyTrYCh/oVYOxEbNcYhq9ydSBZJy98AHOmCztiDKqf0s4wEk0tl7Sles
         0TfeCbphfHgaw==
Date:   Mon, 1 Mar 2021 11:48:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Sven Schuchmann <schuchmann@schleissheimer.de>
Subject: Re: [PATCH net] net: phy: ti: take into account all possible
 interrupt sources
Message-ID: <20210301114821.50413b73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210301082114.4cniggpjletsnibj@skbuf>
References: <20210226153020.867852-1-ciorneiioana@gmail.com>
        <20210228120027.76488180@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210301082114.4cniggpjletsnibj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Mar 2021 10:21:14 +0200 Ioana Ciornei wrote:
> On Sun, Feb 28, 2021 at 12:00:27PM -0800, Jakub Kicinski wrote:
> > On Fri, 26 Feb 2021 17:30:20 +0200 Ioana Ciornei wrote:  
> > > diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
> > > index be1224b4447b..f7a2ec150e54 100644
> > > --- a/drivers/net/phy/dp83822.c
> > > +++ b/drivers/net/phy/dp83822.c
> > > @@ -290,6 +290,7 @@ static int dp83822_config_intr(struct phy_device *phydev)
> > >  
> > >  static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
> > >  {
> > > +	bool trigger_machine = false;
> > >  	int irq_status;
> > >  
> > >  	/* The MISR1 and MISR2 registers are holding the interrupt status in
> > > @@ -305,7 +306,7 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
> > >  		return IRQ_NONE;
> > >  	}
> > >  	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
> > > -		goto trigger_machine;
> > > +		trigger_machine = true;
> > >  
> > >  	irq_status = phy_read(phydev, MII_DP83822_MISR2);
> > >  	if (irq_status < 0) {
> > > @@ -313,11 +314,11 @@ static irqreturn_t dp83822_handle_interrupt(struct phy_device *phydev)
> > >  		return IRQ_NONE;
> > >  	}
> > >  	if (irq_status & ((irq_status & GENMASK(7, 0)) << 8))
> > > -		goto trigger_machine;
> > > +		trigger_machine = true;
> > >  
> > > -	return IRQ_NONE;
> > > +	if (!trigger_machine)
> > > +		return IRQ_NONE;
> > >  
> > > -trigger_machine:
> > >  	phy_trigger_machine(phydev);
> > >  
> > >  	return IRQ_HANDLED;  
> > 
> > Would it be better to code it up as:
> > 
> > 	irqreturn_t ret = IRQ_NONE;
> > 
> > 	if (irq_status & ...)
> > 		ret = IRQ_HANDLED;
> > 
> > 	/* .. */
> > 
> > 	if (ret != IRQ_NONE)
> > 		phy_trigger_machine(phydev);
> > 
> > 	return ret;
> > 
> > That reads a tiny bit better to me, but it's probably majorly
> > subjective so I'm happy with existing patch if you prefer it.  
> 
> I think I prefer it as it is and this is because it would be in line
> with all the other PHY drivers which do this:
> 
> 	if (!(irq_status & int_enabled))
> 		return IRQ_NONE;
> 
> 	phy_trigger_machine(phydev);
> 

Okay, applied, thanks!
