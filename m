Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6445B198291
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729976AbgC3Rl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:41:26 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55916 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729654AbgC3Rl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MPknVRVqf3cjXzMTU1R+fhO3GbG3Mj56RWcr6uAPo/4=; b=jdiwFJp8wSM94WHqaxAAUF/oZ
        qWAMC2vbKFTHvrZmSdq85MME8kz7V/8dpy/aDPNxTvz5HXiQgIpvk41xnvXCTmZCN3PcFhYGM8vU/
        IqTDSEEiXvfioQpJCyV204YvHXjAc0uA0VjtJdtKhmSm0mTQnEgqBUXH0ojw60BQjTEvt3l/3eAK/
        YbCb2kDlbTrBqlDtjAMq55yHXAQq6XhRTRXQ0etN5pomK50D+Jo7QYuOdnA69TP3dLIrcu5rix3zS
        LGMvSTnW5pBJKqNrtGKpJ1p74gP22Vwf4fwhGwT/942zSuiSQf+31ZsfzmVck+3Vs9eKD50f5edew
        9T/GlLzIw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:39286)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jIyPW-0003Uo-Cv; Mon, 30 Mar 2020 18:41:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jIyPS-0007JO-C8; Mon, 30 Mar 2020 18:41:14 +0100
Date:   Mon, 30 Mar 2020 18:41:14 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200330174114.GG25745@shell.armlinux.org.uk>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 10:33:03AM -0700, Florian Fainelli wrote:
> 
> 
> On 3/29/2020 10:26 PM, Oleksij Rempel wrote:
> > Hi Andrew,
> > 
> > On Sun, Mar 29, 2020 at 05:08:54PM +0200, Andrew Lunn wrote:
> >> On Sun, Mar 29, 2020 at 01:04:57PM +0200, Oleksij Rempel wrote:
> >>
> >> Hi Oleksij
> >>
> >>> +config DEPRECATED_PHY_FIXUPS
> >>> +	bool "Enable deprecated PHY fixups"
> >>> +	default y
> >>> +	---help---
> >>> +	  In the early days it was common practice to configure PHYs by adding a
> >>> +	  phy_register_fixup*() in the machine code. This practice turned out to
> >>> +	  be potentially dangerous, because:
> >>> +	  - it affects all PHYs in the system
> >>> +	  - these register changes are usually not preserved during PHY reset
> >>> +	    or suspend/resume cycle.
> >>> +	  - it complicates debugging, since these configuration changes were not
> >>> +	    done by the actual PHY driver.
> >>> +	  This option allows to disable all fixups which are identified as
> >>> +	  potentially harmful and give the developers a chance to implement the
> >>> +	  proper configuration via the device tree (e.g.: phy-mode) and/or the
> >>> +	  related PHY drivers.
> >>
> >> This appears to be an IMX only problem. Everybody else seems to of got
> >> this right. There is no need to bother everybody with this new
> >> option. Please put this in arch/arm/mach-mxs/Kconfig and have IMX in
> >> the name.
> > 
> > Actually, all fixups seems to do wring thing:
> > arch/arm/mach-davinci/board-dm644x-evm.c:915:		phy_register_fixup_for_uid(LXT971_PHY_ID, LXT971_PHY_MASK,
> > 
> > Increased MII drive strength. Should be probably enabled by the PHY
> > driver.
> > 
> > arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> > arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> > arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
> > arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,

As far as I'm concerned, the AR8035 fixup is there with good reason.
It's not just "random" but is required to make the AR8035 usable with
the iMX6 SoCs.  Not because of a board level thing, but because it's
required for the AR8035 to be usable with an iMX6 SoC.

So, having it registered by the iMX6 SoC code is entirely logical and
correct.

That's likely true of the AR8031 situation as well.

I can't speak for any of the others.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
