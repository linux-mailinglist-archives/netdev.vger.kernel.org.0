Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF43115FF0F
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 16:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgBOPsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 10:48:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34046 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgBOPsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 10:48:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UjfX2AP1iMcPasH8o8JSGL+9hyYdgh0qEjcx8ALipPE=; b=Zu+vS9VQiH+fA5OpjXMEAZcvq
        cr1iH14hnzpxv/s1lqPuaDlCwv+TKnB3IqyBYfIudV8gKrpuex0JeHaxQvi6nrT4Z6XnyVVp2x7sk
        eWchvLdHeyMVk+Nl1uBmTjm6dm+NRD+OrBnLPxtJ5GCiXZ4U94ugLmbQl3c2gywZcaxPx5RiQHBCg
        r9K0MeVtEiFnFebHQy9bFQlWpdR87vWEjXUDTB5LaabbGaldh8YqyTOrvXHX3fdZFNeCEHHrRJaQd
        QebKrwgWFSkih88bXg7VwoP3kwCLCv1P6H9ox8VmLZrohXg2Zp3z9/m4K8bfXyuo5VVCVxA6VkkIw
        dJEeuCiOw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:40708)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j2zgQ-0005ip-6o; Sat, 15 Feb 2020 15:48:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j2zgN-0004SW-He; Sat, 15 Feb 2020 15:48:39 +0000
Date:   Sat, 15 Feb 2020 15:48:39 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/10] Pause updates for phylib and phylink
Message-ID: <20200215154839.GR25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, phylib resolves the speed and duplex settings, which MAC
drivers use directly. phylib also extracts the "Pause" and "AsymPause"
bits from the link partner's advertisement, and stores them in struct
phy_device's pause and asym_pause members with no further processing.
It is left up to each MAC driver to implement decoding for this
information.

phylink converted drivers are able to take advantage of code therein
which resolves the pause advertisements for the MAC driver, but this
does nothing for unconverted drivers. It also does not allow us to
make use of hardware-resolved pause states offered by several PHYs.

This series aims to address this by:

1. Providing a generic implementation, linkmode_resolve_pause(), that
   takes the ethtool linkmode arrays for the link partner and local
   advertisements, decoding the result to whether pause frames should
   be allowed to be transmitted or received and acted upon.  I call
   this the pause enablement state.

2. Providing a phylib implementation, phy_get_pause(), which allows
   MAC drivers to request the pause enablement state from phylib.

3. Providing a generic linkmode_set_pause() for setting the pause
   advertisement according to the ethtool tx/rx flags - note that this
   design has some shortcomings, see the comments in the kerneldoc for
   this function.

4. Remove the ability in phylink to set the pause states for fixed
   links, which brings them into line with how we deal with the speed
   and duplex parameters; we can reintroduce this later if anyone
   requires it.  This could be a userspace-visible change.

5. Split application of manual pause enablement state from phylink's
   resolution of the same to allow use of phylib's new phy_get_pause()
   interface by phylink, and make that switch.

6. Resolve the fixed-link pause enablement state using the generic
   linkmode_resolve_pause() helper introduced earlier. This, in
   connection with the previous commits, allows us to kill the
   MLO_PAUSE_SYM and MLO_PAUSE_ASYM flags.

7. make phylink's ethtool pause setting implementation update the
   pause advertisement in the same way that phylib does, with the
   same caveats that are present there (as mentioned above w.r.t
   linkmode_set_pause()).

8. create a more accurate initial configuration for MACs, used when
   phy_start() is called or a SFP is detected. In particular, this
   ensures that the pause bits seen by MAC drivers in state->pause
   are accurate for SGMII.

9. finally, update the kerneldoc descriptions for mac_config() for
   the above changes.

This series has been build-tested against net-next; the boot tested
patches are in my "phy" branch against v5.5 plus the queued phylink
changes that were merged for 5.6.

The next series will introduce the ability for phylib drivers to
provide hardware resolved pause enablement state.  These patches can
be found in my "phy" branch.

 drivers/net/phy/Makefile     |   3 +-
 drivers/net/phy/linkmode.c   |  95 +++++++++++++++++++++++++
 drivers/net/phy/phy_device.c |  43 +++++++-----
 drivers/net/phy/phylink.c    | 162 +++++++++++++++++++++++++++----------------
 include/linux/linkmode.h     |   8 ++-
 include/linux/phy.h          |   3 +
 include/linux/phylink.h      |  34 +++++----
 7 files changed, 258 insertions(+), 90 deletions(-)
 create mode 100644 drivers/net/phy/linkmode.c

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
