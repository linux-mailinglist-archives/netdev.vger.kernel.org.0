Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C23CB2A85
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 10:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfINItG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 04:49:06 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47590 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727565AbfINItG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 04:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6jvERkYSmITmaF8ufkZg1MxACwdNs/AIjeCvA3tryAU=; b=ygJ2nzCUk/yt/eP3gvmRxm850
        KV3H/UnTsgP4GrCOrIHUZZqcXsnnouEsm2jW9pY0kP5Ea7qSxw2JMfygu0i9+8rSBWQefUuyIqJjq
        5a2X2daJUgVQ2DBl9BzczB5UnSKwohF6QNUbKD2MuA+lX2iv1KuRvspI6wsW1AQisNJQ4bADwUyMX
        2sG9aKF0hlK6vAlT/1YS4DIo2A/bXcBQkK+BkI6sIRTodOw2/+HNQxjcyBAjaBSUyuiu3UN1as71S
        vEsb4gYU+/mS6Qch3Sj+v7KrixYIvVW/VB4F32plbwSJRGt0TvMrp68DR87yImd4YXT+7qj2UEfw6
        FKNggY3mw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:60074)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i93jn-0007m5-U5; Sat, 14 Sep 2019 09:49:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i93jk-0006h4-VK; Sat, 14 Sep 2019 09:48:57 +0100
Date:   Sat, 14 Sep 2019 09:48:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: SFP support with RGMII MAC via RGMII to SERDES/SGMII PHY?
Message-ID: <20190914084856.GD13294@shell.armlinux.org.uk>
References: <CAFSKS=NmM9bPb0R_zoFN+9AuG=x6DUffTNXpLSNRAHuZz4ki-g@mail.gmail.com>
 <6cd331e5-4e50-d061-439a-f97417645497@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cd331e5-4e50-d061-439a-f97417645497@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 08:31:18PM -0700, Florian Fainelli wrote:
> +Russell, Andrew, Heiner,
> 
> On 9/13/2019 9:44 AM, George McCollister wrote:
> > Every example of phylink SFP support I've seen is using an Ethernet
> > MAC with native SGMII.
> > Can phylink facilitate support of Fiber and Copper SFP modules
> > connected to an RGMII MAC if all of the following are true?
> 
> I don't think that use case has been presented before, but phylink
> sounds like the tool that should help solve it. From your description
> below, it sounds like all the pieces are there to support it. Is the
> Ethernet MAC driver upstream?

It has been presented, and it's something I've been trying to support
for the last couple of years - in fact, I have patches in my tree that
support a very similar scenario on the Macchiatobin with the 88x3310
PHYs.

> > 1) The MAC is connected via RGMII to a transceiver/PHY (such as
> > Marvell 88E1512) which then connects to the SFP via SERDER/SGMII. If
> > you want to see a block diagram it's the first one here:
> > https://www.marvell.com/transceivers/assets/Alaska_88E1512-001_product_brief.pdf

As mentioned above, this is no different from the Macchiatobin,
where we have:

                  .-------- RJ45
MAC ---- 88x3310 PHY
                  `-------- SFP+

except instead of the MAC to PHY link being 10GBASE-R, it's RGMII,
and the PHY to SFP+ link is 10GBASE-R instead of 1000BASE-X.

Note that you're abusing the term "SGMII".  SGMII is a Cisco
modification of the IEEE 802.3 1000BASE-X protocol.  Fiber SFPs
exclusively use 1000BASE-X protocol.  However, some copper SFPs
(with a RJ45) do use SGMII.

> > 2) The 1G Ethernet driver has been converted to use phylink.

This is not necessary for this scenario.  The PHY driver needs to
be updated to know about SFP though.

See:

http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=phy&id=ece56785ee0e9df40dc823fdc39ee74b4a7cd1c4

as an example of the 88x3310 supporting a SFP+ cage.  This patch is
also necessary:

http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=phy&id=ef2d699397ca28c7f89e01cc9e5037989096a990

and if anything is going to stand in the way of progress on this, it
is likely to be that patch.  I'll be attempting to post these after
the next merge window (i.o.w. probably posting them in three weeks
time.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
