Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F303256CD2
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 10:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgH3Ieh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 04:34:37 -0400
Received: from inva021.nxp.com ([92.121.34.21]:43720 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgH3Ieg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 04:34:36 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id CFEBC20039B;
        Sun, 30 Aug 2020 10:34:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C39472001D4;
        Sun, 30 Aug 2020 10:34:34 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 65DA020306;
        Sun, 30 Aug 2020 10:34:34 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        andrew@lunn.ch, linux@armlinux.org.uk, f.fainelli@gmail.com,
        olteanv@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 0/5] net: phy: add Lynx PCS MDIO module
Date:   Sun, 30 Aug 2020 11:33:57 +0300
Message-Id: <20200830083402.11047-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the Lynx PCS as a separate module in drivers/net/phy/.
The advantage of this structure is that multiple ethernet or switch
drivers used on NXP hardware (ENETC, Seville, Felix DSA switch etc) can
share the same implementation of PCS configuration and runtime
management.

The module implements phylink_pcs_ops and exports a phylink_pcs
(incorporated into a lynx_pcs) which can be directly passed to phylink
through phylink_pcs_set.

The first 3 patches add some missing pieces in phylink and the locked
mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
standalone module. The majority of the code is extracted from the Felix
DSA driver. The last patch makes the necessary changes in the Felix and
Seville drivers in order to use the new common PCS implementation.

At the moment, USXGMII (only with in-band AN), SGMII, QSGMII (with and
without in-band AN) and 2500Base-X (only w/o in-band AN) are supported
by the Lynx PCS MDIO module since these were also supported by Felix and
no functional change is intended at this time.

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

Changes in v4:
 * use the newly introduced phylink PCS mechanism
 * install the phylink_pcs in the phylink_mac_config DSA ops
 * remove the direct implementations of the PCS ops
 * do no use the SGMII_ prefix when referring to the IF_MORE register
 * add a phylink helper to decode the USXGMII code word
 * remove cleanup patches for Felix (these have been already accepted)
 * Seville (recently introduced) now has PCS support through the same
 Lynx PCS module

Changes in v5:
 - move the pcs-lynx driver to drivers/net/pcs
 - reword the commit message a bit in 4/5
 - add error checking and error propagation in 4/5
 - s/IF_MODE_DUPLEX/IF_MODE_HALF_DUPLEX in 4/5

Ioana Ciornei (5):
  net: phylink: add helper function to decode USXGMII word
  net: phylink: consider QSGMII interface mode in
    phylink_mii_c22_pcs_get_state
  net: mdiobus: add clause 45 mdiobus write accessor
  net: phy: add Lynx PCS module
  net: dsa: ocelot: use the Lynx PCS helpers in Felix and Seville

 MAINTAINERS                              |   7 +
 drivers/net/dsa/ocelot/Kconfig           |   1 +
 drivers/net/dsa/ocelot/felix.c           |  28 +-
 drivers/net/dsa/ocelot/felix.h           |  20 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 374 ++---------------------
 drivers/net/dsa/ocelot/seville_vsc9953.c |  21 +-
 drivers/net/pcs/Kconfig                  |   6 +
 drivers/net/pcs/Makefile                 |   1 +
 drivers/net/pcs/pcs-lynx.c               | 312 +++++++++++++++++++
 drivers/net/phy/phylink.c                |  44 +++
 include/linux/mdio.h                     |   6 +
 include/linux/pcs-lynx.h                 |  21 ++
 include/linux/phylink.h                  |   3 +
 13 files changed, 440 insertions(+), 404 deletions(-)
 create mode 100644 drivers/net/pcs/pcs-lynx.c
 create mode 100644 include/linux/pcs-lynx.h

-- 
2.25.1

