Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53A33160139
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 01:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgBPAAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 19:00:35 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39462 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgBPAAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 19:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BwU/yMMrRpxpo5udSyMV4AC0NmXPbP6oD4rg0+6KT3M=; b=dK6FLqd7z28eL6c+bbhH+0pPg
        pN5L6qSsXxB3Jr9exAZmQTlBp3tI948E+Y6+tOZpOJtE+o3I3r7ZTsRcOxBRLpLJJQ7SAJCjawaAP
        NPutExc8UIqpnGXM5DPYv360MKbtgh5fZljqYOhJpzVN8wTM25ePln+z6UiA7mmJ5yeunPdza13GK
        WITC4yArEh5jttnQx5jZZ/QCAdhvu0pVx1ju1s6APrmjh/QoPEY6nncCr/VvLsBzJv/ZHP80NNiUO
        uaLZYqtPntJuQ7LPElrwLz3F2aAiAUPwZxQ6bXbyZ54mWzzFx3DPyYwo6gKanLV4LLY0laTkCHuwB
        zP2h73hEw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:40862)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j37ML-0007ur-Pe; Sun, 16 Feb 2020 00:00:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j37MK-0004kg-Rk; Sun, 16 Feb 2020 00:00:28 +0000
Date:   Sun, 16 Feb 2020 00:00:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] Pause updates for phylib and phylink
Message-ID: <20200216000028.GU25745@shell.armlinux.org.uk>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <db876d85-94d3-9295-a21f-d338c1be3b36@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db876d85-94d3-9295-a21f-d338c1be3b36@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 01:11:16PM -0800, Florian Fainelli wrote:
> 
> 
> On 2/15/2020 7:48 AM, Russell King - ARM Linux admin wrote:
> > Currently, phylib resolves the speed and duplex settings, which MAC
> > drivers use directly. phylib also extracts the "Pause" and "AsymPause"
> > bits from the link partner's advertisement, and stores them in struct
> > phy_device's pause and asym_pause members with no further processing.
> > It is left up to each MAC driver to implement decoding for this
> > information.
> > 
> > phylink converted drivers are able to take advantage of code therein
> > which resolves the pause advertisements for the MAC driver, but this
> > does nothing for unconverted drivers. It also does not allow us to
> > make use of hardware-resolved pause states offered by several PHYs.
> > 
> > This series aims to address this by:
> > 
> > 1. Providing a generic implementation, linkmode_resolve_pause(), that
> >    takes the ethtool linkmode arrays for the link partner and local
> >    advertisements, decoding the result to whether pause frames should
> >    be allowed to be transmitted or received and acted upon.  I call
> >    this the pause enablement state.
> > 
> > 2. Providing a phylib implementation, phy_get_pause(), which allows
> >    MAC drivers to request the pause enablement state from phylib.
> > 
> > 3. Providing a generic linkmode_set_pause() for setting the pause
> >    advertisement according to the ethtool tx/rx flags - note that this
> >    design has some shortcomings, see the comments in the kerneldoc for
> >    this function.
> > 
> > 4. Remove the ability in phylink to set the pause states for fixed
> >    links, which brings them into line with how we deal with the speed
> >    and duplex parameters; we can reintroduce this later if anyone
> >    requires it.  This could be a userspace-visible change.
> > 
> > 5. Split application of manual pause enablement state from phylink's
> >    resolution of the same to allow use of phylib's new phy_get_pause()
> >    interface by phylink, and make that switch.
> > 
> > 6. Resolve the fixed-link pause enablement state using the generic
> >    linkmode_resolve_pause() helper introduced earlier. This, in
> >    connection with the previous commits, allows us to kill the
> >    MLO_PAUSE_SYM and MLO_PAUSE_ASYM flags.
> > 
> > 7. make phylink's ethtool pause setting implementation update the
> >    pause advertisement in the same way that phylib does, with the
> >    same caveats that are present there (as mentioned above w.r.t
> >    linkmode_set_pause()).
> > 
> > 8. create a more accurate initial configuration for MACs, used when
> >    phy_start() is called or a SFP is detected. In particular, this
> >    ensures that the pause bits seen by MAC drivers in state->pause
> >    are accurate for SGMII.
> > 
> > 9. finally, update the kerneldoc descriptions for mac_config() for
> >    the above changes.
> > 
> > This series has been build-tested against net-next; the boot tested
> > patches are in my "phy" branch against v5.5 plus the queued phylink
> > changes that were merged for 5.6.
> > 
> > The next series will introduce the ability for phylib drivers to
> > provide hardware resolved pause enablement state.  These patches can
> > be found in my "phy" branch.
> 
> I do not think that patch #1 made it to the mailing-list though, so if
> nothing else you may want to resend it:
> 
> http://patchwork.ozlabs.org/project/netdev/list/?series=158739

You're right, it was missing the Cc line.  Resent just that - which
makes the series complete in patchwork, although not sure if the
order is correct.  Does it sort a patch series by sent date?

> 
> > 
> >  drivers/net/phy/Makefile     |   3 +-
> >  drivers/net/phy/linkmode.c   |  95 +++++++++++++++++++++++++
> >  drivers/net/phy/phy_device.c |  43 +++++++-----
> >  drivers/net/phy/phylink.c    | 162 +++++++++++++++++++++++++++----------------
> >  include/linux/linkmode.h     |   8 ++-
> >  include/linux/phy.h          |   3 +
> >  include/linux/phylink.h      |  34 +++++----
> >  7 files changed, 258 insertions(+), 90 deletions(-)
> >  create mode 100644 drivers/net/phy/linkmode.c
> > 
> 
> -- 
> Florian
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
