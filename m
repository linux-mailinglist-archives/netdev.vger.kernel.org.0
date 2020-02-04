Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7F415212F
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 20:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgBDTcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 14:32:47 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54924 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbgBDTcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 14:32:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NEyB+td276ts8YTAgKy+Wd6aG//Mg77+7niimGcvraE=; b=MS7LtFiH+GHOwbhBv+vWvw2G6
        GGWaM353Shw+BRBXs3RPScYYjeHQWFMROBIpEnJT7HGRbSG1i8cbmhXaKODdxvHybU3ar6gtLPDjK
        v7CeOGLDXcMudmwpzsdOQT8Tg3F1uCEx98i+Uv6jo4DSh0TY7l0+Oq1AzLR124wiV8lWBE+CtiRzt
        H1JY2UDAKt+Sv2+BWrf3iA9Jkf/+VFwVJraFRdDYOAiVKA70VZuRUOCEckZxy2i9fRi38TAP0VZni
        Zxa04NpiTRK6Y50rqsQgLNI2xlxelTAhwhieQKXV7XbA7I79pi+7flkAWySufmzU+MTigSV/8khep
        JPfNySMhQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:35968)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iz3w3-00040d-Fm; Tue, 04 Feb 2020 19:32:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iz3vy-0001AI-Sy; Tue, 04 Feb 2020 19:32:30 +0000
Date:   Tue, 4 Feb 2020 19:32:30 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200204193230.GT25745@shell.armlinux.org.uk>
References: <20200127114600.GU25745@shell.armlinux.org.uk>
 <20200127140038.GD13647@lunn.ch>
 <20200127140834.GW25745@shell.armlinux.org.uk>
 <20200127145107.GE13647@lunn.ch>
 <20200127161132.GX25745@shell.armlinux.org.uk>
 <20200127162206.GJ13647@lunn.ch>
 <c3e863b8-2143-fee3-bb0b-65699661d7ab@gmail.com>
 <BN8PR12MB3266B69DA09E1CC215843C3CD30A0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200204172603.GS25745@shell.armlinux.org.uk>
 <20200204174318.GB1364@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204174318.GB1364@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 04, 2020 at 06:43:18PM +0100, Andrew Lunn wrote:
> > There, there is one MAC, but there are multiple different PCS - one
> > for SGMII and 1000base-X, another for 10G, another for 25G, etc.
> > These PCS are accessed via a MDIO adapter embedded in each of the
> > MAC hardware blocks.
> 
> Hi Russell
> 
> Marvell mv88e6390X switches are like this is a well. There is a PCS
> for SGMII and 1000Base-X, and a second one for 10G. And it dynamically
> swaps between them depending on the port mode, the so called cmode.
> 
> So a generic solution is required, and please take your time to build
> one.

Well, DSA is quite a mixed bag...

As far as I can work out, the situation with the CPU and DSA ports is
quite hopeless - you've claimed that a change in phylink has broken it,
I can't find what that may be.  The fact is, phylink has never had any
link information for DSA links when no fixed-link property has been
specified in DT.  As I've already said in a previous email about this,
I can't see *any* sane way to fix that - but there was no response.


On a more positive note...

The mac_link_up() changes that I've talked about should work for DSA,
if only there was a reasonable way to reconfigure the ports.  If you
look at the "phy" branch, you will notice that there's a patch there -
"net: mv88e6xxx: use resolved link config in mac_link_up()" which adds
the support to configure the MAC manually.  It's rather messy, and I
see no way to deal with the pause settings.  There is support in some
Marvell DSA switches to force flow control but that's not supported
through the current mid-layer at all (port_set_pause doesn't do it.)
I'm not sure whether the "mv88e6xxx_phy_is_internal()" check there is
the right test for every DSA switch correct either.

What is missing is reading the results from the PCS (aka serdes) and
forwarding them into phylink - I did have a quick look at how that might
be possible, but the DSA code structure (consisting of multiple
mid-layers) makes it hard without rewriting quite a lot of code.  That's
fine if you know all the DSA chips inside out, but I don't - and that's
where we need someone who has the knowledge of all DSA switches that we
support.  Or, we get rid of the multiple mid-layers and switch to a
library approach, so that we can modify support for one DSA switch
without affecting everything.  It may be a simple matter of dropping the
existing serdes workaround, but I'm not sure at the moment.

I've tried this code out on the ZII rev B, I haven't tried it on the rev
C which has the 6390 switches yet.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
