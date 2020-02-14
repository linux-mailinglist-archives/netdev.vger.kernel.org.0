Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1E715F7E0
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgBNUm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:42:57 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50146 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729672AbgBNUm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:42:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XFFAmhMXB9q8e2gTt5qrezHwKnZ+PJ643S2eN+cDqgQ=; b=y6P+mFE1rLvfgJ9efxv0aMig6
        FdlfVf7BvAg0edQS5wSpWnyh18m49gdKNcE94S8a++qfOrNgsFYpVk7/52LDJWYezidz2BR06HPKX
        FRYygtv9Yh/FA4J5m4yztAziCBzOf8xLHO7X4hPzfXEtAohUXpgSbe8ZvO28lLB+f01TVfJYMpPt+
        JpXxhfNFiX3woTHNQYKZV9cyEPQXZusQ/wfgfpcvkA0DkOGajcG2Hl0lGN9MBjSUqNyaTC3woN1lq
        5z2WiU6NVJAcKaJvhYf2/Zg00CW/DDjK54zNRXnl6T3tMJMngw54z6pnb55EiGzbbduXsebpuDrWt
        l7l3RIfNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52012)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j2hnT-0000uM-PZ; Fri, 14 Feb 2020 20:42:47 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j2hnN-0003ew-B1; Fri, 14 Feb 2020 20:42:41 +0000
Date:   Fri, 14 Feb 2020 20:42:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Heads up: phylink changes for next merge window
Message-ID: <20200214204241.GQ25745@shell.armlinux.org.uk>
References: <20200213133831.GM25745@shell.armlinux.org.uk>
 <20200213144615.GH18808@shell.armlinux.org.uk>
 <20200213160004.GC31084@lunn.ch>
 <20200213171602.GO25745@shell.armlinux.org.uk>
 <20200213174500.GI18808@shell.armlinux.org.uk>
 <20200214104148.GJ18808@shell.armlinux.org.uk>
 <20200214150826.GF15299@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214150826.GF15299@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 04:08:26PM +0100, Andrew Lunn wrote:
> > The reasoning is, if the PHY detect bit is set, the PPU should be
> > polling the attached PHY and automatically updating the MAC to reflect
> > the PHY status.  This seems great...
> > 
> > On the ZII dev rev C, we have the following port status values:
> > - port 0 = 0xe04
> > - port 1 through 8 = 0x100f
> > - port 9 = 0x49
> > - port 10 = 0xcf4c
> > 
> > On the ZII dev rev B, port 4 (which is one of the optical ports) has a
> > value of 0xde09, despite being linked to the on-board serdes.  It seems
> > that the PPU on the 88e6352 automatically propagates the status from the
> > serdes there.
> > 
> > So, it looks to me like using the PHY detect bit is the right solution,
> > we just need access to it at this mid-layer...
> 
> Hi Russell
> 
> We need to be careful of the PPU. I'm assuming it uses MDIO to access
> the PHY registers. We have code which allows the PHY page to the
> changed, e.g. hwmon to get the temperature sensors, and i will soon
> have code for cable diagnostics. We don't want the PPU reading some
> temperature sensor registers and configuring the MAC based on that.
> 
> For cases not using a PHY, e.g. the SERDES on the 6352, it might be
> safe to use the PPU.

Bear in mind that the PPU has been used for some time.

However, what I read in some of the functional specs is the built-in
PHYs use a more "direct" method to communicate their negotiated results
to the MAC.  Whether that also applies to the 6352 Serdes or not, I
don't know, but as port 4 will automatically switch between the
built-in copper PHY and Serdes depending on which link comes up first.

It's interesting, however, reading some of the functional specs, where
some say that the PPU must be globally disabled before access is
allowed to the MDIO bus, others the bit for globally disabling the PPU
is "reserved".

That all said, using the PPU PHY_DETECT bit seems to me to be the right
solution - if the chip is polling the PHYs itself, we want to unforce
the speed, duplex and pause, otherwise we need to force them to the
link parameters.  If we need to disable the PPU for a port, then
disabling PHY_DETECT seems like the right answer.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
