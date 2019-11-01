Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706C7EC0C5
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 10:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfKAJtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 05:49:24 -0400
Received: from plaes.org ([188.166.43.21]:36840 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbfKAJtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 05:49:23 -0400
Received: from plaes.org (localhost [127.0.0.1])
        by plaes.org (Postfix) with ESMTPSA id 4AA0D406BF;
        Fri,  1 Nov 2019 09:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1572601761; bh=vTQE2D9Ehk2EbBZJ/BaZkZDiZ+MyLScMBosIZvBBQuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AlXIBXh9DAGqMMR0ZUoWur3Oq3aFwjVBGQTHOxbBXHLq3uYgF+IEgFh/43YgTsGTL
         e0mOYmJEr05dDjVHYX4mmWc5WW379RjMdyiYRsCFV/CJ+wN5229E1AwolDbJP2VSLw
         WGTwEFteRVtU/8iTtRzkb5RHOF3oOvsUMlcdG2f37nw1QR66CjsJX+0ZJL2KqP44Nk
         9mH7BemOrEJKpphm4ixOc55HM/uEpB2TzA/kBAqjSJ4cVq5+JuUhCu68nGFVqaf1LI
         PhBuTjC4HUmlqcXDdIj41IhCCkGnzr7llKG4f6qU+RFdXhv256odH7svmLhQ5iMLZH
         uroRWQfn1Eg0Q==
Date:   Fri, 1 Nov 2019 09:49:20 +0000
From:   Priit Laes <plaes@plaes.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "wens@csie.org" <wens@csie.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>
Subject: Re: sun7i-dwmac: link detection failure with 1000Mbit parters
Message-ID: <20191101094920.GB12834@plaes.org>
References: <20191030202117.GA29022@plaes.org>
 <BN8PR12MB32660687285D2C76E7CF2FF6D3630@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20191031103841.GI25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031103841.GI25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 10:38:41AM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Oct 31, 2019 at 08:39:06AM +0000, Jose Abreu wrote:
> > ++ Florian, Andrew, Heiner, Russell
> > 
> > Can you please attach your dmesg log ? PHYLINK provides some useful 
> > debug logs.
> > 
> > From: Priit Laes <plaes@plaes.org>
> > Date: Oct/30/2019, 20:21:17 (UTC+00:00)
> > 
> > > Heya!
> > > 
> > > I have noticed that with sun7i-dwmac driver (OLinuxino Lime2 eMMC), link
> > > detection fails consistently with certain 1000Mbit partners (for example Huawei
> > > B525s-23a 4g modem ethernet outputs and RTL8153-based USB3.0 ethernet dongle),
> > > but the same hardware works properly with certain other link partners (100Mbit GL AR150
> > > for example).
> > > 
> > > (Just need to test with another 1000Mbit switch at the office).
> > > 
> > > I first thought it could be a regression, but I went from current master to as far back
> > > as 5.2.0-rc6 where it was still broken.
> 
> The stmmac conversion to phylink was v5.3-rc1, so that's likely not the
> issue if v5.2-rc6 also exhibits this behaviour.
> 
> My guess is that the problem lies in phylib, especially as the link LEDs
> go off when the link is configured.  I notice that it's using the
> generic PHY driver rather than a specific driver.

Yup, it turned out to be a phy-related issue - I was using generic PHY
driver, but the board is using Micrel KSZ9031 which has some quirks that
MICREL_PHY=y managed to work around.

> 
>   mii-diag -v eth0
> 
> would be useful to see for the case where the link has failed, without
> replugging the ethernet cable.

mii-diag seems to be quite an useful tool, but unfortunately has not been
packaged anymore on newer distro releases like Debian stable and latest
Ubuntu LTS.

> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
