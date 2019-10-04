Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51507CC014
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 18:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390318AbfJDQFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 12:05:40 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33700 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390313AbfJDQFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 12:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=c1LZkbE3WJlLV3D13dLzT5Yfl+jFMFZb9kvKH1WixU8=; b=nGHMr28soVxa890/XPVCI0Df/
        BxLbQeD9mQcdZS2t16HKOwhm1W6JZCdZhlfeCNlH04ekFtqjnXjbAbRs+jFMdBwF+xXyD/qRpLZAu
        GH49BnOfcqrX7CGmANWgRK7e5Ap4J6VQRnvvzieqeOIhb1kxeoXWySc0hP5sE+CmHYj/U++Ah6GvJ
        mJK6kxWSAFv8rv8g/ZL7INKo7qwHHexwtCtuZlBK1c+bG8RGJv0/nN5D3DR6q4k59pO6Z9xbZsT6c
        IUcgLB0Laflxe8DevkN3/UQ6avRlUI654gi8qivw6/RlE4KGaF/M5hIFR4wqtXShBAhErwg4qCLBs
        DzWpBEKRg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:40024)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iGQ5B-0005Kp-9Q; Fri, 04 Oct 2019 17:05:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iGQ57-0002sq-FH; Fri, 04 Oct 2019 17:05:25 +0100
Date:   Fri, 4 Oct 2019 17:05:25 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/4] Fix regression with AR8035 speed downgrade
Message-ID: <20191004160525.GZ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following series attempts to address an issue spotted by tinywrkb
with the AR8035 on the Cubox-i2 in a situation where the PHY downgrades
the negotiated link.

This is version 2, not much has changed other than rebasing on the
current net tree.  Changes have happend to patch 2 due to conflicts,
so I dropped Andrew's reviewed-by.  Minor context changes to patch 4
which I don't consider important enough to warrant dropping the
reviewed-by.

Before commit 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode in
genphy_read_status"), we would read not only the link partner's
advertisement, but also our own advertisement from the PHY registers,
and use both to derive the PHYs current link mode.  This works when the
AR8035 downgrades the speed, because it appears that the AR8035 clears
link mode bits in the advertisement registers as part of the downgrade.

Commentary: what is not yet known is whether the AR8035 restores the
            advertisement register when the link goes down to the
	    previous state.

However, since the above referenced commit, we no longer use the PHYs
advertisement registers, instead converting the link partner's
advertisement to the ethtool link mode array, and combine that with
phylib's cached version of our advertisement - which is not updated on
speed downgrade.

This results in phylib disagreeing with the actual operating mode of
the PHY.

Commentary: I wonder how many more PHY drivers are broken by this
	    commit, but have yet to be discovered.

The obvious way to address this would be to disable the downgrade
feature, and indeed this does fix the problem in tinywrkb's case - his
link partner instead downgrades the speed by reducing its
advertisement, resulting in phylib correctly evaluating a slower speed.

However, it has a serious drawback - the gigabit control register (MII
register 9) appears to become read only.  It seems the only way to
update the register is to re-enable the downgrade feature, reset the
PHY, changing register 9, disable the downgrade feature, and reset the
PHY again.

This series attempts to address the problem using a different approach,
similar to the approach taken with Marvell PHYs.  The AR8031, AR8033
and AR8035 have a PHY-Specific Status register which reports the
actual operating mode of the PHY - both speed and duplex.  This
register correctly reports the operating mode irrespective of whether
autoneg is enabled or not.  We use this register to fill in phylib's
speed and duplex parameters.

In detail:

Patch 1 fixes a bug where writing to register 9 does not update
phylib's advertisement mask in the same way that writing register 4
does; this looks like an omission from when gigabit PHY support came
into being.

Patch 2 seperates the generic phylib code which reads the link partners
advertisement from the PHY, so that we can re-use this in the Atheros
PHY driver.

Patch 3 seperates the generic phylib pause mode; phylib provides no
help for MAC drivers to ascertain the negotiated pause mode, it merely
copies the link partner's pause mode bits into its own variables.

Commentary: Both the aforementioned Atheros PHYs and Marvell PHYs
            provide the resolved pause modes in terms of whether 
	    we should transmit pause frames, or whether we should
	    allow reception of pause frames.  Surely the resolution
	    of this should be in phylib?

Patch 4 provides the Atheros PHY driver with a private "read_status"
implementation that fills in phylib's speed and duplex settings
depending on the PHY-Specific status register.  This ensures that
phylib and the MAC driver match the operating mode that the PHY has
decided to use.  Since the register also gives us MDIX status, we
can trivially fill that status in as well.

Note that, although the bits mentioned in this patch for this register
match those in th Marvell PHY driver, and it is located at the same
address, the meaning of other register bits varies between the PHYs.
Therefore, I do not feel that it would be appropriate to make this some
kind of generic function.

 drivers/net/phy/at803x.c     | 69 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/phy/phy-core.c   | 20 ++++++++-----
 drivers/net/phy/phy.c        |  5 ++++
 drivers/net/phy/phy_device.c | 65 +++++++++++++++++++++++++----------------
 include/linux/mii.h          |  9 ++++++
 include/linux/phy.h          |  2 ++
 6 files changed, 138 insertions(+), 32 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
