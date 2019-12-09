Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737BF116E7C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfLIODL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:03:11 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34182 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLIODK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:03:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OmpANq62/vlbGPUs94+2+PHxB6W2FGdbudYXcj430BY=; b=Yn44D9pbqvhM9ISxjBXZUoK1O
        /T3kGk+KtSNfpvBMZlBONgozlsnyuNbFj9WMyr4Txrdpcr5wcD2kSy2ikIf/rtZpaTPzdI4ySbf26
        YgMcnkNzZyGYjQBpE6cZ8+BjDBdhPTt6PtBiV4wNxpDkxzbwWK1pvHmRE4Y6H5iDs7/eecGH2EiJB
        4+sHpYA/+p9cUr5Ae5ucym1m/i1ikEDXB2kAXHjSp+qEg2Q037E/6AVup53esQOGLifhdboId1+mB
        ATjEPw6cPvaMxpDexL2CWDMczQ+kYcvEzBI1B9hgIDtjj8/wzUpPFAhKkcqL6XunwPnEuJ/Cwozu4
        uq55bUc2g==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:46484)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ieJcr-0003O3-PU; Mon, 09 Dec 2019 14:03:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ieJco-0003h0-EX; Mon, 09 Dec 2019 14:02:58 +0000
Date:   Mon, 9 Dec 2019 14:02:58 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/14] Add support for SFP+ copper modules
Message-ID: <20191209140258.GI25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for Copper SFP+ modules with Clause 45 PHYs.
Specifically the patches:

1. drop support for the probably never tested 100BASE-*X modules.
2. drop EEPROM ID from sfp_select_interface()
3. add more compliance code definitions from SFF-8024, renaming the
   existing definitions.
4. add module start/stop methods so phylink knows when a module is
   about to become active. The module start method is called after
   we have probed for a PHY on the module.
5. move start/stop of module PHY down into phylink using the new
   module start/stop methods.
6. add support for Clause 45 I2C accesses, tested with Methode DM7052.
   Other modules appear to use the same protocol, but slight
   differences, but I do not have those modules to test with.
   (if someone does, please holler!)
7. rearrange how we attach to PHYs so that we can support Clause 45
   PHYs with indeterminant interface modes.  (Clause 45 PHYs appear
   to like to change their PHY interface mode depending on the
   negotiated speed.)
8. add support for phylink to connect to a clause 45 PHY on a SFP
   module.
9. split the link_an_mode between the configured value and the
   currently selected mode value; some clause 45 PHYs have no
   capability to provide in-band negotiation.
10. split the link configuration on SFP module insertion in phylink
    so we can use it in other code paths.
11. delay MAC configuration for copper modules without a PHY to the
    module start method - after any module PHY has been probed.  If
    the module has a PHY, then we setup the MAC when the PHY is
    detected.
12. the Broadcom 84881 PHY does not support in-band negotiation even
    though it uses SGMII and 2500BASE-X.  Having the MAC operating
    with in-band negotiation enabled, even with AN bypass enabled,
    results in no link - Broadcom say that the host MAC must always
    be forced.
13. add support for the Broadcom 84881 PHY found on the Methode
    DM7052 module.
14. add support to SFP to probe for a Clause 45 PHY on copper SFP+
    modules.

 drivers/net/phy/Kconfig      |   6 +
 drivers/net/phy/Makefile     |   1 +
 drivers/net/phy/bcm84881.c   | 269 +++++++++++++++++++++++++++++++++++++++++++
 drivers/net/phy/marvell10g.c |   2 +-
 drivers/net/phy/mdio-i2c.c   |  28 +++--
 drivers/net/phy/phylink.c    | 229 ++++++++++++++++++++++++++----------
 drivers/net/phy/sfp-bus.c    | 122 ++++++++++++++------
 drivers/net/phy/sfp.c        |  69 ++++++++---
 drivers/net/phy/sfp.h        |   2 +
 include/linux/sfp.h          |  95 ++++++++++-----
 10 files changed, 670 insertions(+), 153 deletions(-)
 create mode 100644 drivers/net/phy/bcm84881.c

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
