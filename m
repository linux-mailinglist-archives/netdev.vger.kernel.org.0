Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB64E122D0A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbfLQNik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:38:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56712 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:38:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TbL+OrtMRHVuUc3yIkYf4w5dF+aMY7NtHoOlVD3NC8U=; b=OI/gA61eoe+gm5aijqY9IXhM/
        86gwbCXj3PtuRwGING7X/77vo/W3aZZl32Lhp0aaj9Y6JP4ZXnvki3nYmHUTAAiMjuuqYJtjYYsq/
        rRco00z/3OdvzkjDtw5rvKLejdTB29Yth5rLG+uJi9QHPZeSEeU/IP1Jsyy/uqj0TeH9BRG7eY5ba
        uqXc7x8PKdIsesJk/EtqSPQ5chZlEVCciANgDr0Fjn02lvrwmFGOBNo+4s8rpAuZyVFLtlMs368tC
        K1k4h3qrFz2AYoTxXArTVmV0Qr5jhoSaKqPgNZLlr/C5OLTvip4vz0hHS3dywT72OQ/p6QHEDEfOF
        Jcmaq2yrA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50084)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihD3W-0006EM-NW; Tue, 17 Dec 2019 13:38:30 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihD3T-0003Qt-Am; Tue, 17 Dec 2019 13:38:27 +0000
Date:   Tue, 17 Dec 2019 13:38:27 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/11] phylib consolidation
Message-ID: <20191217133827.GQ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Over the last few releases, there has been a push to clean up and
consolidate the phylib code. Some cases have been missed, and this
series catches those cases.

1. Remove redundant .aneg_done initialisers; calling genphy_aneg_done()
   for clause 22 PHYs is the default when .aneg_done is not set.

2. Some PHY drivers manually set phydev->pause and phydev->asym_pause,
   but we have a helper for this - phy_resolve_aneg_pause(), introduced
   in 2d880b8709c0 ("net: phy: extract pause mode").  Use this in the
   lxt, marvell and uPD60620 drivers.

   Incidentally, this brings up the question whether marvell fiber mode
   is correctly interpreting and advertising the pause parameters.

3. Add a genphy_check_and_restart_aneg() helper, which complements the
   clause 45 version of this. This will be useful for PHY drivers that
   open code this logic (e.g. marvell.c)

4. Add a genphy_read_status_fixed() helper to read the fixed-mode
   status from a clause 22 PHY.  lxt and marvell both contain copies
   of this code, so convert them over.

5. Arrange marvell driver to use genphy_read_lpa() for copper mode.
   This needs some rearrangement of the code in
   marvell_read_status_page_an(), but preserves using the PHY specific
   status register to derive the current negotiation results.

6. Simplify the marvell driver so we can use the
   genphy_read_status_fixed() helper directly rather than
   marvell_read_status_page_fixed().

7. Use positive logic in the marvell driver to determine the link
   state, and get rid of the REGISTER_LINK_STATUS definition; we
   already have a definition for this.

8. The marvell driver reads the PHY specific status register multiple
   times when determining the status: once in marvell_update_link()
   and again in marvell_read_status_page_an(). This is a waste;
   rearrange to read the status register once, and pass its value into
   marvell_read_status_page_an().  We preserve using
   genphy_update_link() for the copper side.

9. The marvell driver was using private clause 37 definitions, but we
   have clause 37 definitions in uapi/linux/mii.h. Use the generic
   definitions.

10. Switch the marvell driver to use phy_modify_changed() to modify
    the fiber advertisement.

11. Switch the marvell driver to use genphy_check_and_restart_aneg()
    introduced above rather than open-coding this functionality.

 drivers/net/phy/lxt.c        |  24 +----
 drivers/net/phy/marvell.c    | 209 ++++++++++++-------------------------------
 drivers/net/phy/mscc.c       |   6 --
 drivers/net/phy/phy_device.c |  98 +++++++++++++-------
 drivers/net/phy/uPD60620.c   |   7 +-
 include/linux/phy.h          |   2 +
 6 files changed, 129 insertions(+), 217 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
