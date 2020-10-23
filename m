Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268A6296D2C
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462633AbgJWK5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 06:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462577AbgJWK4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 06:56:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35C6C0613D4
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 03:56:39 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukG-00087m-Kp; Fri, 23 Oct 2020 12:56:28 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kVukF-0001k0-C3; Fri, 23 Oct 2020 12:56:27 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, linux-can@vger.kernel.org
Subject: [RFC PATCH v1 0/6] add initial CAN PHY support
Date:   Fri, 23 Oct 2020 12:56:20 +0200
Message-Id: <20201023105626.6534-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is introducing PHY support for CAN.

Why it is needed?
- A usual CAN PHY has an enable or silent mode pin. This pin needs to be
  pulled into the correct direction, so that the CAN controller can
  access the CAN network. So far this has been "hacked" into the
  CAN controller driver, by enabling/disabling regulators. Better use
  proper PHY drivers instead.
- Bit rate limits. There are different types of CAN PHYs not all support
  all bit rates. Further the upper limit of CAN FD PHYs is not given by
  the standard by by the PHY itself. Use the PHY link framework to
  validate bit rate limits.
- The upcoming CAN SIC and CAN SIC XL PHYs use a different interface to
  the CAN controller. This means the controller needs to know which type
  of PHY is attached to configure the interface in the correct mode. Use
  PHY link for that, too.
- Another topic is cable testing/diagnostics. Unfortunately this is not
  standardized in CAN, but there are several boards that implement CAN
  cable testing in some way or another. Use PHY framework as an
  abstraction.
- The class of CAN low-speed PHYs has enhanced error detection
  capabilities, compared to normal (CAN high-speed and CAN FD) PHYs.
  Use PHY framework to implement CAN low-speed PHY drivers.

Oleksij Rempel (6):
  net: phy: add CAN PHY Virtual Bus
  net: phy: add a driver for generic CAN PHYs
  net: phy: add CAN interface mode
  net: add CAN specific link modes
  can: flexcan: add phylink support
  can: flexcan: add ethtool support

 drivers/net/can/Kconfig       |   2 +
 drivers/net/can/flexcan.c     | 244 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/Kconfig       |  14 ++
 drivers/net/phy/Makefile      |   2 +
 drivers/net/phy/can_phy_bus.c | 196 +++++++++++++++++++++++++++
 drivers/net/phy/can_phy_drv.c | 236 ++++++++++++++++++++++++++++++++
 drivers/net/phy/phy-core.c    |   2 +-
 drivers/net/phy/phy.c         |   2 +
 include/linux/can/phy.h       |  21 +++
 include/linux/phy.h           |   3 +
 include/uapi/linux/ethtool.h  |   9 ++
 net/ethtool/common.c          |   7 +
 net/ethtool/linkmodes.c       |   7 +
 13 files changed, 743 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/phy/can_phy_bus.c
 create mode 100644 drivers/net/phy/can_phy_drv.c
 create mode 100644 include/linux/can/phy.h

-- 
2.28.0

