Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6581DEA7A9
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfJ3XTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:19:31 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60386 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbfJ3XTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 19:19:30 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E4A321A048B;
        Thu, 31 Oct 2019 00:19:27 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D82871A01D8;
        Thu, 31 Oct 2019 00:19:27 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8A4F8205E9;
        Thu, 31 Oct 2019 00:19:27 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@armlinux.org.uk, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 0/5] dpaa2-eth: add MAC/PHY support through phylink
Date:   Thu, 31 Oct 2019 01:18:27 +0200
Message-Id: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpaa2-eth driver now has support for connecting to its associated PHY
device found through standard OF bindings. The PHY interraction is handled
by PHYLINK and even though, at the moment, only RGMII_* phy modes are
supported by the driver, this is just the first step into adding the
necessary changes to support the entire spectrum of capabilities.

This comes after feedback on the initial DPAA2 MAC RFC submitted here:
https://lwn.net/Articles/791182/

The notable change is that now, the DPMAC is not a separate driver, and
communication between the DPMAC and DPNI no longer happens through
firmware. Rather, the DPMAC is now a set of API functions that other
net_device drivers (DPNI, DPSW, etc) can use for PHY management.

The change is incremental, because the DPAA2 architecture has many modes of
connecting net devices in hardware loopback (for example DPNI to DPNI).
Those operating modes do not have a DPMAC and phylink instance.

The documentation patch provides a more complete view of the software
architecture and the current implementation.

Changes in v2:
 - added patch 1/5 in order to fix module build
 - use -ENOTCONN as a proper return error of dprc_get_connection()
 - move the locks to rtnl outside of dpaa2_eth_[dis]connect_mac functions
 - remove setting supported/advertised from .validate()

Changes in v3:
 - remove an unused variable

Changes in v4:
 - use ERR_PTR instead of plain NULL


Ioana Ciornei (5):
  bus: fsl-mc: export device types present on the bus
  bus: fsl-mc: add the fsl_mc_get_endpoint function
  dpaa2-eth: update the TX frame queues on
    DPNI_IRQ_EVENT_ENDPOINT_CHANGED
  dpaa2-eth: add MAC/PHY support through phylink
  net: documentation: add docs for MAC/PHY support in DPAA2

 .../device_drivers/freescale/dpaa2/index.rst       |   1 +
 .../freescale/dpaa2/mac-phy-support.rst            | 191 +++++++++++++
 MAINTAINERS                                        |   4 +
 drivers/bus/fsl-mc/dprc-driver.c                   |   6 +-
 drivers/bus/fsl-mc/dprc.c                          |  53 ++++
 drivers/bus/fsl-mc/fsl-mc-bus.c                    |  43 +++
 drivers/bus/fsl-mc/fsl-mc-private.h                |  42 +++
 drivers/net/ethernet/freescale/dpaa2/Makefile      |   2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 126 +++++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |   3 +
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |  25 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   | 301 +++++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |  32 +++
 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h   |  62 +++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.c       | 149 ++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h       | 144 ++++++++++
 include/linux/fsl/mc.h                             |   2 +
 17 files changed, 1157 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/freescale/dpaa2/mac-phy-support.rst
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpmac.h

-- 
1.9.1

