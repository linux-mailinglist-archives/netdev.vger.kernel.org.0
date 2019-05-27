Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8286E2BBAC
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfE0VWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:22:50 -0400
Received: from inva021.nxp.com ([92.121.34.21]:50716 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726346AbfE0VWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 17:22:50 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5F8C720000C;
        Mon, 27 May 2019 23:22:47 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5235B200C5B;
        Mon, 27 May 2019 23:22:47 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B1A962061C;
        Mon, 27 May 2019 23:22:46 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, maxime.chevallier@bootlin.com,
        olteanv@gmail.com, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 00/11] Decoupling PHYLINK from struct net_device
Date:   Tue, 28 May 2019 00:21:56 +0300
Message-Id: <1558992127-26008-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following two separate discussion threads in:
  https://www.spinics.net/lists/netdev/msg569087.html
and:
  https://www.spinics.net/lists/netdev/msg570450.html

Previous RFC patch set: https://www.spinics.net/lists/netdev/msg571995.html

PHYLINK was reworked in order to accept multiple operation types,
PHYLINK_NETDEV and PHYLINK_DEV, passed through a phylink_config
structure alongside the corresponding struct device.

One of the main concerns expressed in the RFC was that using notifiers
to signal the corresponding phylink_mac_ops would break PHYLINK's API
unity and that it would become harder to grep for its users.
Using the current approach, we maintain a common API for all users.
Also, printing useful information in PHYLINK, when decoupled from a
net_device, is achieved using dev_err&co on the struct device received
(in DSA's case is the device corresponding to the dsa_switch).

PHYLIB (which PHYLINK uses) was reworked to the extent that it does not
crash when connecting to a PHY and the net_device pointer is NULL.

Lastly, DSA has been reworked in its way that it handles PHYs for ports
that lack a net_device (CPU and DSA ports).  For these, it was
previously using PHYLIB and is now using the PHYLINK_DEV operation type.
Previously, a driver that wanted to support PHY operations on CPU/DSA
ports has to implement .adjust_link(). This patch set not only gives
drivers the options to use PHYLINK uniformly but also urges them to
convert to it. For compatibility, the old code is kept but it will be
removed once all drivers switch over.

The patchset was tested on the NXP LS1021A-TSN board having the
following Ethernet layout:
  https://lkml.org/lkml/2019/5/5/279
The CPU port was moved from the internal RGMII fixed-link (enet2 ->
switch port 4) to an external loopback Cat5 cable between the enet1 port
and the front-facing swp2 SJA1105 port. In this mode, both the master
and the CPU port have an attached PHY which detects link change events:

[   49.105426] fsl-gianfar soc:ethernet@2d50000 eth1: Link is Down
[   50.305486] sja1105 spi0.1: Link is Down
[   53.265596] fsl-gianfar soc:ethernet@2d50000 eth1: Link is Up - 1Gbps/Full - flow control off
[   54.466304] sja1105 spi0.1: Link is Up - 1Gbps/Full - flow control off

Ioana Ciornei (9):
  net: phy: Guard against the presence of a netdev
  net: phy: Check against net_device being NULL
  net: phy: Add phy_standalone sysfs entry
  net: phylink: Add phylink_mac_link_{up,down} wrapper functions
  net: phylink: Add struct phylink_config to PHYLINK API
  net: phylink: Add PHYLINK_DEV operation type
  net: phylink: Add phylink_{printk,err,warn,info,dbg} macros
  net: dsa: Move the phylink driver calls into port.c
  net: dsa: Use PHYLINK for the CPU/DSA ports

Vladimir Oltean (2):
  net: phy: Add phy_sysfs_create_links helper function
  net: dsa: sja1105: Fix broken fixed-link interfaces on user ports

 Documentation/networking/sfp-phylink.rst      |   5 +-
 drivers/net/dsa/sja1105/sja1105_main.c        |  11 +-
 drivers/net/ethernet/marvell/mvneta.c         |  36 ++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   1 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  43 ++--
 drivers/net/phy/phy_device.c                  | 100 ++++++--
 drivers/net/phy/phylink.c                     | 220 +++++++++++-------
 include/linux/phylink.h                       |  57 +++--
 include/net/dsa.h                             |   2 +
 net/dsa/dsa_priv.h                            |  17 ++
 net/dsa/port.c                                | 157 +++++++++++++
 net/dsa/slave.c                               |  99 +-------
 12 files changed, 491 insertions(+), 257 deletions(-)

-- 
2.21.0

