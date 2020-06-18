Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CCD1FF142
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 14:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgFRMJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 08:09:10 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48784 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFRMJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 08:09:07 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 64EAE200D44;
        Thu, 18 Jun 2020 14:09:05 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 54F87200D3F;
        Thu, 18 Jun 2020 14:09:05 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E15CB2048B;
        Thu, 18 Jun 2020 14:09:04 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/5] net: phy: add Lynx PCS MDIO module
Date:   Thu, 18 Jun 2020 15:08:32 +0300
Message-Id: <20200618120837.27089-1-ioana.ciornei@nxp.com>
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

The PCS is represented as a mdio_device and the callbacks exported are
highly tied with PHYLINK and can't be used without it.

The first 3 patches add some missing pieces in PHYLINK and the locked
mdiobus write accessor. Next, the Lynx PCS MDIO module is added as a
standalone module. The majority of the code is extracted from the Felix
DSA driver. The last patch makes the necessary changes in the Felix
driver in order to use the new common PCS implementation.

At the moment, USXGMII (only with in-band AN and speeds up to 2500),
SGMII, QSGMII and 2500Base-X (only w/o in-band AN) are supported by the
Lynx PCS MDIO module since these were also supported by Felix and no
funtional change is intended at this time.


Ioana Ciornei (4):
  net: phylink: consider QSGMII interface mode in
    phylink_mii_c22_pcs_get_state
  net: mdiobus: add clause 45 mdiobus write accessor
  net: phy: add Lynx PCS MDIO module
  net: dsa: felix: use the Lynx PCS helpers

Russell King (1):
  net: phylink: add interface to configure clause 22 PCS PHY

 MAINTAINERS                            |   7 +
 drivers/net/dsa/ocelot/Kconfig         |   1 +
 drivers/net/dsa/ocelot/felix.c         |   5 +
 drivers/net/dsa/ocelot/felix.h         |   7 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 385 +++----------------------
 drivers/net/phy/Kconfig                |   6 +
 drivers/net/phy/Makefile               |   1 +
 drivers/net/phy/mdio-lynx-pcs.c        | 358 +++++++++++++++++++++++
 drivers/net/phy/phylink.c              |  38 +++
 include/linux/fsl/enetc_mdio.h         |  21 --
 include/linux/mdio-lynx-pcs.h          |  43 +++
 include/linux/mdio.h                   |   6 +
 include/linux/phylink.h                |   3 +
 13 files changed, 514 insertions(+), 367 deletions(-)
 create mode 100644 drivers/net/phy/mdio-lynx-pcs.c
 create mode 100644 include/linux/mdio-lynx-pcs.h

-- 
2.25.1

