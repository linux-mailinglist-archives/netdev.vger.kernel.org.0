Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D1368ECF4
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjBHKch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjBHKc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:32:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E733546D6A
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:32:24 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pPhkN-00047b-JF; Wed, 08 Feb 2023 11:32:15 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pPhkL-003Uho-N5; Wed, 08 Feb 2023 11:32:14 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pPhkK-00Aa3o-Ow; Wed, 08 Feb 2023 11:32:12 +0100
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
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v6 0/9] net: add EEE support for KSZ9477 and AR8035 with i.MX6
Date:   Wed,  8 Feb 2023 11:32:02 +0100
Message-Id: <20230208103211.2521836-1-o.rempel@pengutronix.de>
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

changes v6:
- split patch set and send only first 9 patches
- Add Reviewed-by: Andrew Lunn <andrew@lunn.ch>
- use 0xffff instead of GENMASK
- Document @supported_eee
- use "()" with function name in comments

changes v5:
- spell fixes
- move part of genphy_c45_read_eee_abilities() to
  genphy_c45_read_eee_cap1()
- validate MDIO_PCS_EEE_ABLE register against 0xffff val.
- rename *eee_100_10000* to *eee_cap1*
- use linkmode_intersects(phydev->supported, PHY_EEE_CAP1_FEATURES)
  instead of !linkmode_empty()
- add documentation to linkmode/register helpers

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

Oleksij Rempel (9):
  net: dsa: microchip: enable EEE support
  net: phy: add genphy_c45_read_eee_abilities() function
  net: phy: micrel: add ksz9477_get_features()
  net: phy: export phy_check_valid() function
  net: phy: add genphy_c45_ethtool_get/set_eee() support
  net: phy: c22: migrate to genphy_c45_write_eee_adv()
  net: phy: c45: migrate to genphy_c45_write_eee_adv()
  net: phy: migrate phy_init_eee() to genphy_c45_eee_is_active()
  net: phy: start using genphy_c45_ethtool_get/set_eee()

 drivers/net/dsa/microchip/ksz_common.c |  65 +++++
 drivers/net/phy/micrel.c               |  21 ++
 drivers/net/phy/phy-c45.c              | 316 ++++++++++++++++++++++++-
 drivers/net/phy/phy.c                  | 153 ++----------
 drivers/net/phy/phy_device.c           |  26 +-
 include/linux/mdio.h                   |  84 +++++++
 include/linux/phy.h                    |  14 ++
 include/uapi/linux/mdio.h              |   8 +
 8 files changed, 550 insertions(+), 137 deletions(-)

-- 
2.30.2

