Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037F74505D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfFMX4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:56:46 -0400
Received: from inva021.nxp.com ([92.121.34.21]:34600 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbfFMX4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 19:56:33 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5919420050F;
        Fri, 14 Jun 2019 01:56:31 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4C305200503;
        Fri, 14 Jun 2019 01:56:31 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E2CDC205DC;
        Fri, 14 Jun 2019 01:56:30 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, hkallweit1@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, alexandru.marginean@nxp.com,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RFC 0/6] DPAA2 MAC Driver
Date:   Fri, 14 Jun 2019 02:55:47 +0300
Message-Id: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After today's discussion with Russell King about what phylink exposes in
.mac_config(): https://marc.info/?l=linux-netdev&m=156043794316709&w=2
I am submitting for initial review the dpaa2-mac driver model.

At the moment, pause frame support is missing so inherently all the USXGMII
modes that rely on backpressure applied by the PHY in rate adaptation between
network side and system side don't work properly.

As next steps, the driver will have to be integrated with the SFP bus so
commands such as 'ethtool --dump-module-eeprom' will have to work through the
current callpath through firmware. This poses somewhat of a problem, as
dpaa2-eth lacks any handle to the phy so it will probably need further
modification to the API that the firmware exposes (same applies to 'ethtool
--phy-statistics').

The documentation patch provides a more complete view of the software
architecture and the current implementation.

Ioana Ciornei (4):
  net: phy: update the autoneg state in phylink_phy_change
  dpaa2-mac: add MC API for the DPMAC object
  dpaa2-mac: add initial driver
  net: documentation: add MAC/PHY proxy driver documentation

Ioana Radulescu (2):
  dpaa2-eth: add support for new link state APIs
  dpaa2-eth: add autoneg support

 .../freescale/dpaa2/dpmac-driver.rst               | 159 ++++++
 .../device_drivers/freescale/dpaa2/index.rst       |   1 +
 MAINTAINERS                                        |   8 +
 drivers/net/ethernet/freescale/dpaa2/Kconfig       |  13 +
 drivers/net/ethernet/freescale/dpaa2/Makefile      |   2 +
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  83 +++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   | 541 +++++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h   | 107 ++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.c       | 369 ++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h       | 210 ++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |  35 ++
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |  70 +++
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |  27 +
 drivers/net/phy/phylink.c                          |   1 +
 14 files changed, 1612 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/freescale/dpaa2/dpmac-driver.rst
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.h

-- 
1.9.1

