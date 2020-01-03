Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4D912F7CB
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 12:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbgACLvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 06:51:40 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40006 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgACLvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 06:51:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PpBtuak8qUL7f5RLjOLw2ZkNLqAt2sDHkfTbc2zkOpY=; b=MC95k6Qv4KZnJSUB2RkPdQ3Ln
        zPOwJKGUW/11XhudDKFk1Yvdmv41sdJRjc+xKjCr+TzP6zNfLAYbEVSe2bppO34S354uKe68sUFhF
        cgTqETOZng+wLMWGQ+Wvoak66bVDj7bZ6kxvc+e6OQr4BEzgLavhyAz1aRf3ZUgWbFZiXqTKjEmbH
        NMiEZD1ZqPMuJnbNPM/pfH68kOcKmNAdVlborEdumPdtxqaxm5YqpCp7UdmLnXyTmukfg7yKFbtxc
        OESeLboU9X5IgvC1HNDG6yv8ZLms56HyFpjFuWSYX2bLl/bOI9TAuht6euZ4YYTkEvIA2cldhZdne
        S6Xj7c9Tg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:50010)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1inLUG-0001rX-PZ; Fri, 03 Jan 2020 11:51:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1inLUD-00036R-UD; Fri, 03 Jan 2020 11:51:25 +0000
Date:   Fri, 3 Jan 2020 11:51:25 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Fix 10G PHY interface types
Message-ID: <20200103115125.GC25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent discussion has revealed that our current usage of the 10GKR
phy_interface_t is not correct. This is based on a misunderstanding
caused in part by the various specifications being difficult to
obtain. Now that a better understanding has been reached, we ought
to correct this.

This series introduce PHY_INTERFACE_MODE_10GBASER to replace the
existing usage of 10GKR mode, and document their differences in the
phylib documentation. Then switch PHY, SFP/phylink, the Marvell
PP2 network driver, and its associated comphy driver over to use
the correct interface mode. None of the existing platform usage
was actually using 10GBASE-KR.

In order to maintain compatibility with existing DT files, arrange
for the Marvell PP2 driver to rewrite the phy interface mode; this
allows other drivers to adopt correct behaviour w.r.t whether the
10G connection conforms to the backplane 10GBASE-KR protocol vs
normal 10GBASE-R protocol.

After applying these locally to net-next I've validated that the
only places which mention the old PHY_INTERFACE_MODE_10GKR
definition are:

Documentation/networking/phy.rst:``PHY_INTERFACE_MODE_10GKR``
drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:        if (phy_mode == PHY_INTERFACE_MODE_10GKR)
drivers/net/phy/aquantia_main.c:                phydev->interface = PHY_INTERFACE_MODE_10GKR;
drivers/net/phy/aquantia_main.c:            phydev->interface != PHY_INTERFACE_MODE_10GKR &&
include/linux/phy.h:    PHY_INTERFACE_MODE_10GKR,
include/linux/phy.h:    case PHY_INTERFACE_MODE_10GKR:

which is as expected.  The only users of "10gbase-kr" in DT are:

arch/arm64/boot/dts/marvell/armada-7040-db.dts: phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts:     phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode = "10gbase-kr";arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode = "10gbase-kr";arch/arm64/boot/dts/marvell/cn9130-db.dts:      phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/cn9131-db.dts:      phy-mode = "10gbase-kr";
arch/arm64/boot/dts/marvell/cn9132-db.dts:      phy-mode = "10gbase-kr";

which all use the mvpp2 driver, and these will be updated in a
separate patch to be submitted in the following kernel cycle.

 Documentation/networking/phy.rst                | 18 ++++++++++++++++++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 13 ++++++++-----
 drivers/net/phy/aquantia_main.c                 |  7 +++++--
 drivers/net/phy/bcm84881.c                      |  4 ++--
 drivers/net/phy/marvell10g.c                    | 11 ++++++-----
 drivers/net/phy/phylink.c                       |  1 +
 drivers/net/phy/sfp-bus.c                       |  2 +-
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c    | 20 ++++++++++----------
 include/linux/phy.h                             | 12 ++++++++----
 9 files changed, 59 insertions(+), 29 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
