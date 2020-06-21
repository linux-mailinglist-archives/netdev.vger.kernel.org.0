Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B68202D8C
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 00:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgFUW4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 18:56:01 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54244 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbgFUW4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 18:56:00 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 498342007B0;
        Mon, 22 Jun 2020 00:55:58 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3D08320059D;
        Mon, 22 Jun 2020 00:55:58 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C128720414;
        Mon, 22 Jun 2020 00:55:57 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 0/9] net: phy: add Lynx PCS MDIO module
Date:   Mon, 22 Jun 2020 01:54:42 +0300
Message-Id: <20200621225451.12435-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the Lynx PCS as a separate module in drivers/net/phy/.
The advantage of this structure is that multiple ethernet or switch
drivers used on NXP hardware (ENETC, Felix DSA switch etc) can share the
same implementation of PCS configuration and runtime management.

The PCS is represented as an mdio_device and the callbacks exported are
highly tied with PHYLINK and can't be used without it.

The first 3 patches add some missing pieces in PHYLINK and the locked
mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
standalone module. The majority of the code is extracted from the Felix
DSA driver. The last patch makes the necessary changes in the Felix
driver in order to use the new common PCS implementation.

At the moment, USXGMII (only with in-band AN and speeds up to 2500),
SGMII, QSGMII (with and without in-band AN) and 2500Base-X (only w/o
in-band AN) are supported by the Lynx PCS MDIO module since these were
also supported by Felix and no functional change is intended at this
time.

Changes in v2:
 * got rid of the mdio_lynx_pcs structure and directly exported the
 functions without the need of an indirection
 * made the necessary adjustments for this in the Felix DSA driver
 * solved the broken allmodconfig build test by making the module
 tristate instead of bool
 * fixed a memory leakage in the Felix driver (the pcs structure was
 allocated twice)

Changes in v3:
 * added support for PHYLINK PCS ops in DSA (patch 5/9)
 * cleanup in Felix PHYLINK operations and migrate to
 phylink_mac_link_up() being the callback of choice for applying MAC
 configuration (patches 6-8)

As per Russell's request, the DSA core now exports PHYLINK PCS ops.
DSA adds a phylink_pcs_ops structure to PHYLINK only when a switch
driver is implementing all of the 4 PCS operations (get_state,
an_restart, config, link_up).

Note that there is no longer anything to be done in phylink_mac_config()
for Felix and, likely, for any other driver which uses the new PHYLINK
format. However, PHYLINK does want the phylink_mac_config() pointer to
be present. Currently, the DSA core supplied a stub and happily doesn't
do anything because felix_phylink_mac_config() is missing.

Felix's migration from mac_config() to mac_link_up() was added directly
into this patch set since everything in this general area is
intertwined and splitting would have been difficult.

Ioana Ciornei (5):
  net: phylink: consider QSGMII interface mode in
    phylink_mii_c22_pcs_get_state
  net: mdiobus: add clause 45 mdiobus write accessor
  net: phy: add Lynx PCS module
  net: dsa: add support for phylink_pcs_ops
  net: dsa: felix: use the Lynx PCS helpers

Russell King (1):
  net: phylink: add interface to configure clause 22 PCS PHY

Vladimir Oltean (3):
  net: dsa: felix: unconditionally configure MAC speed to 1000Mbps
  net: dsa: felix: set proper pause frame timers based on link speed
  net: dsa: felix: use resolved link config in mac_link_up()

 MAINTAINERS                            |   7 +
 drivers/net/dsa/ocelot/Kconfig         |   1 +
 drivers/net/dsa/ocelot/felix.c         | 129 ++++++---
 drivers/net/dsa/ocelot/felix.h         |  16 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 385 +++----------------------
 drivers/net/phy/Kconfig                |   6 +
 drivers/net/phy/Makefile               |   1 +
 drivers/net/phy/pcs-lynx.c             | 337 ++++++++++++++++++++++
 drivers/net/phy/phylink.c              |  38 +++
 include/linux/fsl/enetc_mdio.h         |  21 --
 include/linux/mdio.h                   |   6 +
 include/linux/pcs-lynx.h               |  25 ++
 include/linux/phylink.h                |   3 +
 include/net/dsa.h                      |  12 +
 net/dsa/dsa_priv.h                     |   1 +
 net/dsa/port.c                         |  46 +++
 net/dsa/slave.c                        |   6 +
 17 files changed, 617 insertions(+), 423 deletions(-)
 create mode 100644 drivers/net/phy/pcs-lynx.c
 create mode 100644 include/linux/pcs-lynx.h

-- 
2.25.1

