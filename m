Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1A2162B0A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgBRQtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:49:36 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56058 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgBRQtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:49:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hEE4kCWREkSm0Oc9d5h/VOreG3QEVJqcehyNik4NrM0=; b=O/skXcutYj+w21R10NkiVDuGw
        YTrlwuelTpSxA1TcbiAPjF2iHCy32jfirOYaGvnK2j91GOeHSg4J1wqB1VOmDJk0IIiCaAwcgE0sT
        fb3zQV2i2IxhSLFr9fZjnwjKlGC6v5c30dXU4fvnqfCvcGldC+X9vFwyqHE+Iv9aDFMMsT8MOHrIK
        jPbGGQqUwgol3Q7gR+oRiJRNqcyJGoFwmKOdHExmmVRksiDvKRHRjpiub11uKiTV8ZKXZBRkLWgpP
        eYmy5gbg7RqC+4AahXGl+2U8dQIXRl3uPvLRKL1QqrdcTyQj4AikzQJP8rV8+2qpv0luyPEH+DRRl
        3WmeA+bxA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:49566)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j463t-0008N4-FJ; Tue, 18 Feb 2020 16:49:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j463s-0000af-D8; Tue, 18 Feb 2020 16:49:28 +0000
Date:   Tue, 18 Feb 2020 16:49:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
Message-ID: <20200218164928.GJ25745@shell.armlinux.org.uk>
References: <20200204181319.27381-1-dmurphy@ti.com>
 <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <170d6518-ea82-08d3-0348-228c72425e64@ti.com>
 <7569617d-f69f-9190-1223-77d3be637753@gmail.com>
 <c7a7bd71-3a1c-1cf3-5faa-204b10ea8b78@ti.com>
 <44499cb2-ec72-75a1-195b-fbadd8463e1c@ti.com>
 <6f800f83-0008-c138-c33a-c00a95862463@ti.com>
 <20200218162522.GH25745@shell.armlinux.org.uk>
 <1346e6b0-1d20-593f-d994-37de87ede891@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1346e6b0-1d20-593f-d994-37de87ede891@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 10:36:47AM -0600, Dan Murphy wrote:
> Russell
> 
> On 2/18/20 10:25 AM, Russell King - ARM Linux admin wrote:
> > On Fri, Feb 14, 2020 at 12:31:52PM -0600, Dan Murphy wrote:
> > > Grygorii
> > > 
> > > On 2/14/20 12:32 PM, Grygorii Strashko wrote:
> > > > I think it's good idea to have this message as just wrong cable might be
> > > > used.
> > > > 
> > > > But this notifier make no sense in it current form - it will produce
> > > > noise in case of forced 100m/10M.
> > > > 
> > > > FYI. PHY sequence to update link:
> > > > phy_state_machine()
> > > > |-phy_check_link_status()
> > > >    |-phy_link_down/up()
> > > >      |- .phy_link_change()->phy_link_change()
> > > >      |-adjust_link() ----> netdev callback
> > > > |-phydev->drv->link_change_notify(phydev);
> > > > 
> > > > So, log output has to be done or in .read_status() or
> > > > some info has to be saved in .read_status() and then re-used in
> > > > .link_change_notify().
> > > > 
> > > OK I will try to find a way to give some sort of message.
> > How do you know the speed that the PHY downshifted to?
> 
> The DP83867 has a register PHYSTS where BIT 15:14 indicate the speed that
> the PHY negotiated.
> 
> In the same register BIT 13 indicates the duplex mode.
> 
> > If the speed and duplex are available in some PHY specific status
> > register, then one way you can detect downshift is to decode the
> > negotiated speed/duplex from the advertisements (specifically the LPA
> > read from the registers and the advertisement that we should be
> > advertising - some PHYs modify their registers when downshifting) and
> > check whether it matches the negotiated parameters in the PHY
> > specific status register.
> > 
> > Alternatively, if the PHY modifies the advertisement register on
> > downshift, comparing the advertisement register with what it should
> > be will tell you if downshift has occurred.
> 
> The ISR register BIT 5 indicates if a downshift occurred or not. So we can
> indicate that the PHY downshifted but there is no cause in the registers bit
> field.  My concern for this bit though is the register is clear on read so
> all other interrupts are lost if we only read to check downshift.  And the
> link_change_notifier is called before the interrupt ACK call back.  We could
> call the interrupt function and get the downshift status but again it will
> clear the interrupt register and any other statuses may be lost.

What's wrong with having an ack_interrupt() method that reads the
PHY ISR register, and records in a driver private flag that bit 5
has been set?  The read_status() method can clear the flag if link
goes down, or check the flag if link is up and report that a
downshift event occurred.

If IRQs are not in use, then read_status() would have to read the
ISR itself.

It may be better to move ack_interrupt() to did_interrupt(), which
will ensure that it gets executed before the PHY state machine is
triggered by phy_interrupt().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
