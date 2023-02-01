Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE50B68693F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 15:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbjBAO7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 09:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjBAO7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 09:59:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6DB6B980
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 06:59:04 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZY-0002ra-0C; Wed, 01 Feb 2023 15:58:52 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZW-001w1G-Ih; Wed, 01 Feb 2023 15:58:49 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pNEZT-009hUY-6r; Wed, 01 Feb 2023 15:58:47 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v4 00/23] net: add EEE support for KSZ9477 and AR8035 with i.MX6
Date:   Wed,  1 Feb 2023 15:58:22 +0100
Message-Id: <20230201145845.2312060-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v4:
- remove following helpers:
  mmd_eee_cap_to_ethtool_sup_t
  mmd_eee_adv_to_ethtool_adv_t
  ethtool_adv_to_mmd_eee_adv_t
  and port drivers from this helpers to linkmode helpers.
- rebase against latest net-next
- port phy_init_eee() to genphy_c45_eee_is_active()

changes v3:
- rework some parts of EEE infrastructure and move it to c45 code.
- add supported_eee storage and start using it in EEE code and by the
  micrel driver.
- add EEE support for ar8035 PHY
- add SmartEEE support to FEC i.MX series.

changes v2:
- use phydev->supported instead of reading MII_BMSR regiaster
- fix @get_eee > @set_eee

With this patch series we provide EEE control for KSZ9477 family of switches and
AR8035 with i.MX6 configuration.
According to my tests, on a system with KSZ8563 switch and 100Mbit idle link,
we consume 0,192W less power per port if EEE is enabled.

Oleksij Rempel (23):
  net: dsa: microchip: enable EEE support
  net: phy: add genphy_c45_read_eee_abilities() function
  net: phy: micrel: add ksz9477_get_features()
  net: phy: export phy_check_valid() function
  net: phy: add genphy_c45_ethtool_get/set_eee() support
  net: phy: c22: migrate to genphy_c45_write_eee_adv()
  net: phy: c45: migrate to genphy_c45_write_eee_adv()
  net: phy: migrate phy_init_eee() to genphy_c45_eee_is_active()
  net: phy: start using genphy_c45_ethtool_get/set_eee()
  net: phy: add driver specific get/set_eee support
  net: phy: at803x: implement ethtool access to SmartEEE functionality
  net: phy: at803x: ar8035: fix EEE support for half duplex links
  net: phy: add PHY specifica flag to signal SmartEEE support
  net: phy: at803x: add PHY_SMART_EEE flag to AR8035
  net: phy: add phy_has_smarteee() helper
  net: fec: add support for PHYs with SmartEEE support
  e1000e: replace EEE ethtool helpers to linkmode variants
  igb: replace EEE ethtool helpers to linkmode variants
  igc: replace EEE ethtool helpers to linkmode variants
  tg3: replace EEE ethtool helpers to linkmode variants
  r8152: replace EEE ethtool helpers to linkmode variants
  net: usb: ax88179_178a: replace EEE ethtool helpers to linkmode
    variants
  net: mdio: drop EEE ethtool helpers in favor to linkmode variants

 drivers/net/dsa/microchip/ksz_common.c       |  66 ++++
 drivers/net/ethernet/broadcom/tg3.c          |   9 +-
 drivers/net/ethernet/freescale/fec_main.c    |  22 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c  |  16 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c |  23 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  12 +-
 drivers/net/phy/at803x.c                     | 142 ++++++++-
 drivers/net/phy/micrel.c                     |  21 ++
 drivers/net/phy/phy-c45.c                    | 298 ++++++++++++++++++-
 drivers/net/phy/phy.c                        | 155 ++--------
 drivers/net/phy/phy_device.c                 |  26 +-
 drivers/net/usb/ax88179_178a.c               |  24 +-
 drivers/net/usb/r8152.c                      |  34 ++-
 include/linux/mdio.h                         | 136 ++++-----
 include/linux/phy.h                          |  28 ++
 include/uapi/linux/mdio.h                    |   8 +
 16 files changed, 760 insertions(+), 260 deletions(-)

-- 
2.30.2

