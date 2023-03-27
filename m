Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE006CAB54
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjC0RDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbjC0RCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:02:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BAD4EEC
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=pxGW9HWHc7a5/zLrrtzpAqSeHhK8bTLpIt8ZSdDy6nI=; b=0KZ+ia5y4f46QC+5cg++U+6+0c
        AD02SSyv9FdC3TpBdiagiYuwxjV7KWDJxwdO/wyFGftre9Xp8wKDk12JZWTYVmliZ7BuIy6teEk8k
        IeCC9qwk6hMDu6ZpljEWLiDu8byyYOZNAAWUt74DzSPRK0kryFyDCU+Eel9g4GeYGYqY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgqEU-008XqJ-Ds; Mon, 27 Mar 2023 19:02:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFT 00/23] net: ethernet: Rework EEE
Date:   Mon, 27 Mar 2023 19:01:38 +0200
Message-Id: <20230327170201.2036708-1-andrew@lunn.ch>
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

There is some overlap here with the addition of SMART EEE. This needs
to be solved before either patchset is merged. This patchset is also
large, so might need splitting into adding new infrastructure,
migrating MAC drivers, removing old code.

I deliberately reduced the Cc: list down to just a few developers, who
i hope can test the core and a couple of the MAC drivers, and review
if the new API makes sense, before the other MAC drivers are reviewed.

Andrew Lunn (23):
  net: phy: Add phydev->eee_active to simplify adjust link callbacks
  net: phylink: Plumb eee_active in mac_link_up call
  net: phy: Add helper to set EEE Clock stop enable bit
  net: phy: Keep track of EEE tx_lpi_enabled
  net: phy: Immediately call adjust_link if only tx_lpi_enabled changes
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

 drivers/net/dsa/b53/b53_common.c              |  8 +-
 drivers/net/dsa/b53/b53_priv.h                |  3 +-
 drivers/net/dsa/bcm_sf2.c                     |  3 +-
 drivers/net/dsa/lan9303-core.c                |  2 +-
 drivers/net/dsa/lantiq_gswip.c                |  3 +-
 drivers/net/dsa/microchip/ksz_common.c        | 10 ++-
 drivers/net/dsa/microchip/ksz_common.h        |  3 +-
 drivers/net/dsa/mt7530.c                      |  8 +-
 drivers/net/dsa/mv88e6xxx/chip.c              |  3 +-
 drivers/net/dsa/ocelot/felix.c                |  3 +-
 drivers/net/dsa/qca/ar9331.c                  |  3 +-
 drivers/net/dsa/qca/qca8k-8xxx.c              |  3 +-
 drivers/net/dsa/realtek/rtl8365mb.c           |  2 +-
 drivers/net/dsa/realtek/rtl8366rb.c           |  3 +-
 drivers/net/dsa/rzn1_a5psw.c                  |  3 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  3 +-
 drivers/net/dsa/xrs700x/xrs700x.c             |  3 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  3 +-
 drivers/net/ethernet/atheros/ag71xx.c         |  3 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 42 +++------
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  3 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c  |  3 +
 drivers/net/ethernet/cadence/macb_main.c      |  3 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  3 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  3 +-
 drivers/net/ethernet/freescale/fec_main.c     | 88 ++++++++-----------
 .../net/ethernet/freescale/fman/fman_dtsec.c  |  3 +-
 .../net/ethernet/freescale/fman/fman_memac.c  |  3 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   |  3 +-
 drivers/net/ethernet/marvell/mvneta.c         | 24 ++---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  5 +-
 .../ethernet/marvell/prestera/prestera_main.c |  3 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  3 +-
 .../net/ethernet/microchip/lan743x_ethtool.c  | 22 -----
 drivers/net/ethernet/microchip/lan743x_main.c |  9 ++
 .../microchip/lan966x/lan966x_phylink.c       |  3 +-
 .../microchip/sparx5/sparx5_phylink.c         |  3 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  3 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_common.h |  3 -
 .../ethernet/samsung/sxgbe/sxgbe_ethtool.c    | 21 +----
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   | 39 +++-----
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 -
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  7 --
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 13 +--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  3 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  3 +-
 drivers/net/phy/phy-c45.c                     | 11 ++-
 drivers/net/phy/phy-core.c                    | 11 +++
 drivers/net/phy/phy.c                         | 57 ++++++------
 drivers/net/phy/phy_device.c                  | 37 ++++----
 drivers/net/phy/phylink.c                     | 37 ++++----
 drivers/net/usb/asix_devices.c                |  2 +-
 drivers/net/usb/lan78xx.c                     | 38 ++++----
 include/linux/phy.h                           | 10 ++-
 include/linux/phylink.h                       | 25 +++---
 include/net/dsa.h                             |  3 +-
 net/dsa/port.c                                |  9 +-
 57 files changed, 295 insertions(+), 336 deletions(-)

-- 
2.39.2

