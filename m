Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774D8D6B8F
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 00:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbfJNWMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 18:12:25 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58152 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730369AbfJNWMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 18:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bdiOmpZ5RXcC/f/ihPKAhcTaPuRDCg1OJyatxTXbycA=; b=M7x+OyYci8CeJM4I9gxZ/lDOZ
        7JCz/6Qn66QpeEL89nFUfLj/GDC+A4/4zdT0YgwHy2GCKXl7GbT7Qa44ILvPEzFZstTfROg0ff0Pw
        qxUxovho9gxZIB3aK4eE3evWWHHMJUWio2XGDWhWY9pYJZxtw96kDnDRGsEdK1ci7oewwITn+zhpK
        ERGqqNqeZKGF150G62cTrd6grs92JGlQvEJkUXced9mlaaTMUI9Q1QlUwDNdNpKYE5S5FsC3FMCHo
        HmPef99Ty6+75vJ3RTTbL7i/iGMV3pEcdVJ7b2uYehudwPOx+yVSUHyTnDqpM1tppmEC+jA+5IQm+
        nNczPBotA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43726)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iK8Zb-0000Ht-Hz; Mon, 14 Oct 2019 23:12:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iK8ZX-0004mu-Rt; Mon, 14 Oct 2019 23:12:11 +0100
Date:   Mon, 14 Oct 2019 23:12:11 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Stefan Wahren <wahrenst@gmx.net>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Daniel Wagner <dwagner@suse.de>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: lan78xx and phy_state_machine
Message-ID: <20191014221211.GR25745@shell.armlinux.org.uk>
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191014163004.GP25745@shell.armlinux.org.uk>
 <20191014192529.z7c5x6hzixxeplvw@beryllium.lan>
 <25cfc92d-f72b-d195-71b1-f5f238c7988d@gmx.net>
 <b9afd836-613a-dc63-f77b-f9a77d33acc4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9afd836-613a-dc63-f77b-f9a77d33acc4@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 10:20:15PM +0200, Heiner Kallweit wrote:
> On 14.10.2019 21:51, Stefan Wahren wrote:
> > [add more recipients]
> > 
> > Am 14.10.19 um 21:25 schrieb Daniel Wagner:
> >> Moving the phy_prepare_link() up in phy_connect_direct() ensures that
> >> phydev->adjust_link is set when the phy_check_link_status() is called.
> >>
> >> diff --git a/drivers/net/phy/phy_device.c
> >> b/drivers/net/phy/phy_device.c index 9d2bbb13293e..2a61812bcb0d 100644
> >> --- a/drivers/net/phy/phy_device.c +++ b/drivers/net/phy/phy_device.c
> >> @@ -951,11 +951,12 @@ int phy_connect_direct(struct net_device *dev,
> >> struct phy_device *phydev, if (!dev) return -EINVAL;
> >>
> >> +       phy_prepare_link(phydev, handler);
> >> +
> >>         rc = phy_attach_direct(dev, phydev, phydev->dev_flags, interface);
> >>         if (rc)
> 
> If phy_attach_direct() fails we may have to reset phydev->adjust_link to NULL,
> as we do in phy_disconnect(). Apart from that change looks good to me.

Sorry, but it doesn't look good to me.

I think there's a deeper question here - why is the phy state machine
trying to call the link change function during attach?

At this point, the PHY hasn't been "started" so it shouldn't be
doing that.

Note the documentation, specifically phy.rst's "Keeping Close Tabs on
the PAL" section.  Drivers are at liberty to use phy_prepare_link()
_after_ phy_attach(), which means there is a window for
phydev->adjust_link to be NULL.  It should _not_ be called at this
point.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
