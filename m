Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63D469A47F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjBQDnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBQDm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675D7F749
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=mU57SgDP99U39alqvJ8nwLpAMY9z01MoAOs/4JVdreY=; b=J2rLk1jOpfnOMqqMOslEDnvaWn
        zvzoND+LcscjMWbI/PG3zStodqWE1bxVL/nxMUOkG1Jvf2Tdrg+mnN+mzeuMOvz7QQ3jLO/E0/dUf
        EZ4hFmtRl5Zp8dtyzALV4ObT+IqI3fSsznaiXU3VLY8E5jqJOuTRtG0GyReQCXrFNJls=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSrdz-005F60-TL; Fri, 17 Feb 2023 04:42:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 00/18] Rework MAC drivers EEE support
Date:   Fri, 17 Feb 2023 04:42:12 +0100
Message-Id: <20230217034230.1249661-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_init_eee() is supposed to be called once auto-neg has been
completed to determine if EEE should be used with the current link
mode. The MAC hardware should then be configured to either enable or
disable EEE. Many drivers get this wrong, calling phy_init_eee() once,
or only in the ethtool set_eee callback.

This patchset changes the API, such that EEE becomes the same as other
parameters which are determined by auto-neg. As will speed and duplex,
active EEE is now indicated in the phydev structure, and the
adjust_link callbacks have been modified to act upon its value.

eee_set and eee_get have been simplified, given that the phylib
functions act upon most of the data in eee_set, and fill in most of
the information needed for eee_set.

Andrew Lunn (18):
  net: phy: Add phydev->eee_active to simplify adjust link callbacks
  net: phy: Add helper to set EEE Clock stop enable bit
  net: marvell: mvneta: Simplify EEE configuration
  net: stmmac: Drop usage of phy_init_eee()
  net: stmmac: Simplify ethtool get eee
  net: lan743x: Fixup EEE
  net: fec: Move fec_enet_eee_mode_set() and helper earlier
  net: FEC: Fixup EEE
  net: genet: Fixup EEE
  net: sxgdb: Fixup EEE
  net: dsa: mt7530: Swap to using phydev->eee_active
  net: dsa: mt7530: Call phylib for set_eee and get_eee
  net: dsa: b53: Swap to using phydev->eee_active
  net: dsa: b53: Call phylib for set_eee and get_eee
  net: phylink: Remove unused phylink_init_eee()
  net: phylink: Update comment about configuring EEE in mac_link_up()
  net: phy: remove unused phy_init_eee()
  net: usb: lan78xx: Fixup EEE

 drivers/net/dsa/b53/b53_common.c              | 11 ++-
 drivers/net/dsa/mt7530.c                      |  8 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 31 +++----
 .../net/ethernet/broadcom/genet/bcmgenet.h    |  1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c  |  1 +
 drivers/net/ethernet/freescale/fec_main.c     | 84 ++++++++-----------
 drivers/net/ethernet/marvell/mvneta.c         | 12 +--
 .../net/ethernet/microchip/lan743x_ethtool.c  | 20 -----
 drivers/net/ethernet/microchip/lan743x_main.c |  7 ++
 .../net/ethernet/samsung/sxgbe/sxgbe_common.h |  4 +-
 .../ethernet/samsung/sxgbe/sxgbe_ethtool.c    | 23 +----
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   | 37 +++-----
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |  2 -
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  5 +-
 drivers/net/phy/phy.c                         | 36 +++-----
 drivers/net/phy/phylink.c                     | 18 ----
 drivers/net/usb/lan78xx.c                     | 36 ++++----
 include/linux/phy.h                           |  4 +-
 include/linux/phylink.h                       |  7 +-
 19 files changed, 121 insertions(+), 226 deletions(-)

-- 
2.39.1

