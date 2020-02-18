Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A88E162A5A
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 17:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBRQZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 11:25:34 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55722 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgBRQZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 11:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TuGSrvtELJKmIcTw7/lXFrOIqywCrRTKxNNZt6j2szI=; b=zIDHrQxrA7hSQMKjFT/5Wgaky
        YJVsedvMcMrIA0Oq186C6D6WsSc6xdXZxOwNN39v6eZiw08CVhMZN5/6QACTXqSm7vg7by/N7I6Bi
        vLhz1Nk5dweWrxImvZQiH6vUAFT7AS5gjk08k8lL/4gcDyu901t/qejvUJJNrHC/ZxY8trbhoTNi5
        SYocZZ5ESMMe9zGRVYEjjORsEY8iopdR6/KKfN6EQsFsi3WUbQ3SImgbsCWnlF1EtSxscDVOVC3HO
        HKCSnVq3VWfHE8kssCu2auajXwVflDXCJe+I7p86tisIojWRpOA4tWotZ8chWqDA649LJSeKPx7iu
        IznYaGVMQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:42040)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j45gb-0008FW-QW; Tue, 18 Feb 2020 16:25:25 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j45gY-0000ZK-Ex; Tue, 18 Feb 2020 16:25:22 +0000
Date:   Tue, 18 Feb 2020 16:25:22 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
Message-ID: <20200218162522.GH25745@shell.armlinux.org.uk>
References: <20200204181319.27381-1-dmurphy@ti.com>
 <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <170d6518-ea82-08d3-0348-228c72425e64@ti.com>
 <7569617d-f69f-9190-1223-77d3be637753@gmail.com>
 <c7a7bd71-3a1c-1cf3-5faa-204b10ea8b78@ti.com>
 <44499cb2-ec72-75a1-195b-fbadd8463e1c@ti.com>
 <6f800f83-0008-c138-c33a-c00a95862463@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f800f83-0008-c138-c33a-c00a95862463@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 12:31:52PM -0600, Dan Murphy wrote:
> Grygorii
> 
> On 2/14/20 12:32 PM, Grygorii Strashko wrote:
> > I think it's good idea to have this message as just wrong cable might be
> > used.
> > 
> > But this notifier make no sense in it current form - it will produce
> > noise in case of forced 100m/10M.
> > 
> > FYI. PHY sequence to update link:
> > phy_state_machine()
> > |-phy_check_link_status()
> >   |-phy_link_down/up()
> >     |- .phy_link_change()->phy_link_change()
> >     |-adjust_link() ----> netdev callback
> > |-phydev->drv->link_change_notify(phydev);
> > 
> > So, log output has to be done or in .read_status() or
> > some info has to be saved in .read_status() and then re-used in
> > .link_change_notify().
> > 
> OK I will try to find a way to give some sort of message.

How do you know the speed that the PHY downshifted to?

If the speed and duplex are available in some PHY specific status
register, then one way you can detect downshift is to decode the
negotiated speed/duplex from the advertisements (specifically the LPA
read from the registers and the advertisement that we should be
advertising - some PHYs modify their registers when downshifting) and
check whether it matches the negotiated parameters in the PHY
specific status register.

Alternatively, if the PHY modifies the advertisement register on
downshift, comparing the advertisement register with what it should
be will tell you if downshift has occurred.

Note, however, that if both ends of the link are capable of
downshift, and they downshift at the same time, it can be difficult
to reliably tell whether the downshift was performed by the local
PHY or the remote PHY - even if the local PHY gives you status bits
for downshift, you won't know if the remote end downshifted instead.

It's a bit like auto MDI/MDIX - if pairswap is needed, either end
may do it, and which end does it may change each time the link comes
up.

So, reporting downshift in the kernel log may not be all that useful,
it may be more suited to being reported through a future ethtool
interface just like MDI/MDIX.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
