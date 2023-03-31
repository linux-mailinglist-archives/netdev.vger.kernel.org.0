Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A4A6D1475
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjCaA4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjCaAzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C21611149
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=k5L0mtXnsDrZ8MWox1sA7sNIh+rjclaH7GmGaGzlBIc=; b=aXNi5rhyThkDqABLT96UyWCofF
        gPgqDbgIDB+AyHVVUkM2oY3VkEg4kvAT8N8f5w+K/0KF/ZxgTF6dzvGs8T3ckkHkKDyRCFUEVP8Sy
        zH1kVB7iG6lJKkME3slMhwyWKh8lnefIOYpJoM6B1+UOoqRXMlgGLoIpfLnvE4H2bqjY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xK6-9r; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Date:   Fri, 31 Mar 2023 02:54:54 +0200
Message-Id: <20230331005518.2134652-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most MAC drivers get EEE wrong. The API to the PHY is not very
obvious, which is probably why. Rework the API, pushing most of the
EEE handling into phylib core, leaving the MAC drivers to just
enable/disable support for EEE in there change_link call back, or
phylink mac_link_up callback.

MAC drivers are now expect to indicate to phylib/phylink if they
support EEE. If not, no EEE link modes are advertised. If the MAC does
support EEE, on phy_start()/phylink_start() EEE advertisement is
configured.

v3
--
Rework phylink code to add a new callback.
Rework function to indicate clock should be stopped during LPI

Andrew Lunn (24):
  net: phy: Add phydev->eee_active to simplify adjust link callbacks
  net: phylink: Add mac_set_eee() callback
  net: phy: Add helper to set EEE Clock stop enable bit
  net: phy: Keep track of EEE tx_lpi_enabled
  net: phy: Immediately call adjust_link if only tx_lpi_enabled changes
  net: phylink: Handle change in EEE from phylib
  net: marvell: mvneta: Simplify EEE configuration
  net: stmmac: Drop usage of phy_init_eee()
  net: stmmac: Simplify ethtool get eee
  net: lan743x: Fixup EEE
  net: fec: Move fec_enet_eee_mode_set() and helper earlier
  net: FEC: Fixup EEE
  net: genet: Fixup EEE
  net: sxgdb: Fixup EEE
  net: dsa: mt7530: Swap to using phydev->eee_active
  net: dsa: b53: Swap to using phydev->eee_active
  net: phylink: Remove unused phylink_init_eee()
  net: phy: remove unused phy_init_eee()
  net: usb: lan78xx: Fixup EEE
  net: phy: Add phy_support_eee() indicating MAC support EEE
  net: phylink: Add MAC_EEE to mac_capabilites
  net: phylink: Extend mac_capabilities in MAC drivers which support EEE
  net: phylib: call phy_support_eee() in MAC drivers which support EEE
  net: phy: Disable EEE advertisement by default

 drivers/net/dsa/b53/b53_common.c              |  5 +-
 drivers/net/dsa/mt7530.c                      |  2 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 42 +++------
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  3 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c  |  3 +
 drivers/net/ethernet/freescale/fec_main.c     | 88 ++++++++-----------
 drivers/net/ethernet/marvell/mvneta.c         | 28 +++---
 .../net/ethernet/microchip/lan743x_ethtool.c  | 22 -----
 drivers/net/ethernet/microchip/lan743x_main.c |  9 ++
 .../net/ethernet/samsung/sxgbe/sxgbe_common.h |  3 -
 .../ethernet/samsung/sxgbe/sxgbe_ethtool.c    | 21 +----
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   | 39 +++-----
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 -
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  7 --
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++-
 drivers/net/phy/phy-c45.c                     | 35 +++++++-
 drivers/net/phy/phy-core.c                    | 11 +++
 drivers/net/phy/phy.c                         | 83 ++++++++++-------
 drivers/net/phy/phy_device.c                  | 37 ++++----
 drivers/net/phy/phylink.c                     | 47 +++++-----
 drivers/net/usb/lan78xx.c                     | 44 +++++-----
 include/linux/phy.h                           | 11 ++-
 include/linux/phylink.h                       | 62 ++++++++-----
 include/uapi/linux/mdio.h                     |  1 +
 net/dsa/port.c                                |  3 +
 25 files changed, 308 insertions(+), 309 deletions(-)

-- 
2.40.0

