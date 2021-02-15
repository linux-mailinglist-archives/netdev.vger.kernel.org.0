Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D6631BC94
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhBOPbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbhBOPa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:30:28 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC6CC061574
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 07:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lvOqceh+nfAlxcPWWk0dEbT+2Btn93+7CESLmdlhHHQ=; b=Icw3dcPWCBkTnG1lRw0v1vQV0
        03TnrFPqBBnuFmK3BvqVj6eDU0FTKtFCuL2LmuYa5/bz3mzw5I8Z7pIoGeNdO3CqWgX7KMo2FJhQF
        NYeO24K/+RrdlLjvamK3TGpoqs191DR2D/2AqeV7XfXgsBGgWJuiwJepEsMMfAi93zOGywVv9SrwC
        sXpM8wZfb51bAfTo4Odlzf8qKOEYZrIjUI7T7fcdvpbATjup0PyATQFE/qA2AnGUgBV2jkCuCd13H
        bwUglK9pCSSZaiihKhrHaaisiKhxoXIZI0U2eWPa5R9goqyQ/SnEHMxsYc39UYidPJKbM3PzI82px
        nyE00tgaA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43754)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lBfon-0001Bk-PM; Mon, 15 Feb 2021 15:29:45 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lBfom-0001nW-Jy; Mon, 15 Feb 2021 15:29:44 +0000
Date:   Mon, 15 Feb 2021 15:29:44 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Nathan Rossi <nathan@nathanrossi.com>, netdev@vger.kernel.org,
        Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: prevent 2500BASEX mode override
Message-ID: <20210215152944.GY1463@shell.armlinux.org.uk>
References: <20210215061559.1187396-1-nathan@nathanrossi.com>
 <20210215144756.76846c9b@nic.cz>
 <20210215145757.GX1463@shell.armlinux.org.uk>
 <20210215161627.63c3091c@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215161627.63c3091c@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 04:16:27PM +0100, Marek Behun wrote:
> On Mon, 15 Feb 2021 14:57:57 +0000
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Mon, Feb 15, 2021 at 02:47:56PM +0100, Marek Behun wrote:
> > > On Mon, 15 Feb 2021 06:15:59 +0000
> > > Nathan Rossi <nathan@nathanrossi.com> wrote:
> > >   
> > > > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> > > > index 54aa942eed..5c52906b29 100644
> > > > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > > > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > > > @@ -650,6 +650,13 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
> > > >  	if (chip->info->ops->phylink_validate)
> > > >  		chip->info->ops->phylink_validate(chip, port, mask, state);
> > > >  
> > > > +	/* Advertise 2500BASEX only if 1000BASEX is not configured, this
> > > > +	 * prevents phylink_helper_basex_speed from always overriding the
> > > > +	 * 1000BASEX mode since auto negotiation is always enabled.
> > > > +	 */
> > > > +	if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
> > > > +		phylink_clear(mask, 2500baseX_Full);
> > > > +  
> > > 
> > > I don't quite like this. This problem should be either solved in
> > > phylink_helper_basex_speed() or somewhere in the mv88e6xxx code, but near
> > > the call to phylink_helper_basex_speed().
> > > 
> > > Putting a solution to the behaviour of phylink_helper_basex_speed() it
> > > into the validate() method when phylink_helper_basex_speed() is called
> > > from a different place will complicate debugging in the future. If
> > > we start solving problems in this kind of way, the driver will become
> > > totally unreadable, IMO.  
> > 
> > If we can't switch between 1000base-X and 2500base-X, then we should
> > not be calling phylink_helper_basex_speed() - and only one of those
> > two capabilities should be set in the validation callback. I thought
> > there were DSA switches where we could program the CMODE to switch
> > between these two...
> 
> There are. At least Peridot, Topaz and Amethyst support switching
> between these modes. But only on some ports.
> 
> This problem happnes on Peridot X, I think.
> 
> On Peridot X there are
> - port 0: RGMII
> - ports 9-10: capable of 1, 2.5 and 10G SerDes (10G via
>   XAUI/RXAUI, so multiple lanes)
> - ports 1-8: with copper PHYs
>   - some of these can instead be set to use the unused SerDes lanes
>     of ports 9-10, but only in 1000base-x mode
> 
> So the problem can happen if you set port 9 or 10 to only use one
> SerDes lane, and use the spare lanes for the 1G ports.
> On these ports 2500base-x is not supported, only 1000base-x (maybe
> sgmii, I don't remember)

It sounds like the modes are not reporting correctly then before calling
phylink_helper_basex_speed(). If the port can only be used at 1000base-X,
then it should not be allowing 2500base-X to be set prior to calling
phylink_helper_basex_speed().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
