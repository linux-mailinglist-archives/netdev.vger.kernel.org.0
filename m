Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F474505B
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 01:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfFMX4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 19:56:40 -0400
Received: from inva021.nxp.com ([92.121.34.21]:34672 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfFMX4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 19:56:36 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 43CEA20051B;
        Fri, 14 Jun 2019 01:56:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 36440200503;
        Fri, 14 Jun 2019 01:56:34 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CCC6B205DC;
        Fri, 14 Jun 2019 01:56:33 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     linux@armlinux.org.uk, hkallweit1@gmail.com, f.fainelli@gmail.com,
        andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, alexandru.marginean@nxp.com,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RFC 6/6] net: documentation: add MAC/PHY proxy driver documentation
Date:   Fri, 14 Jun 2019 02:55:53 +0300
Message-Id: <1560470153-26155-7-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation file for the dpaa2-mac driver. This describes the
architecture and implementation of the proxy interface between phylink
and dpaa2-eth.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpmac-driver.rst               | 159 +++++++++++++++++++++
 .../device_drivers/freescale/dpaa2/index.rst       |   1 +
 MAINTAINERS                                        |   1 +
 3 files changed, 161 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/freescale/dpaa2/dpmac-driver.rst

diff --git a/Documentation/networking/device_drivers/freescale/dpaa2/dpmac-driver.rst b/Documentation/networking/device_drivers/freescale/dpaa2/dpmac-driver.rst
new file mode 100644
index 000000000000..ad09aa1c921e
--- /dev/null
+++ b/Documentation/networking/device_drivers/freescale/dpaa2/dpmac-driver.rst
@@ -0,0 +1,159 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. include:: <isonum.txt>
+
+===============================
+DPAA2 MAC / PHY proxy interface
+===============================
+
+:Copyright: |copy| 2019 NXP
+
+
+Overview
+--------
+
+The DPAA2 MAC / PHY proxy interface driver binds to DPAA2 DPMAC objects, which
+are dynamically discovered on the fsl-mc bus. Once probed, the driver looks up
+the device tree for PHYLINK-compatible OF bindings (phy-handle) and does the
+following:
+
+- registers itself with the Management Complex (MC) firmware to receive
+  interrupts for:
+
+        - Link up/down (on the PHY)
+        - Link configuration changes requested
+
+- creates a PHYLINK instance based on its device_node and connects to the
+  specified PHY
+
+- notifies the MC firmware of any link status change received from PHYLINK
+
+
+DPAA2 Software Architecture
+---------------------------
+
+Among other DPAA2 objects, the fsl-mc bus exports DPNI objects (abstracting a
+network interface) and DPMAC objects (abstracting a MAC) which are probed and
+managed by two different drivers: dpaa2-eth and dpaa2-mac.
+
+Data connections may be established between a DPNI and a DPMAC, or between two
+DPNIs.  A DPNI may be directly assigned to a guest software partition, whereas
+a DPMAC object is always managed from the root (most privileged) container.
+
+For netif_carrier_on/netif_carrier_off, the MC firmware presents to the DPNI
+object an abstracted view of the link state:
+
+.. code-block:: none
+
+  Sources of abstracted link state information presented by the MC firmware
+
+                                               +--------------------------------------+
+  +------------+                               |                           xgmac_mdio |
+  | net_device |                 +---------+   |  +-----+  +-----+  +-----+  +-----+  |
+  +------------+                 | phylink |<--|  | PHY |  | PHY |  | PHY |  | PHY |  |
+        ^                        +---------+   |  +-----+  +-----+  +-----+  +-----+  |
+        |                             |        |                    External MDIO bus |
+    dpaa2-eth                     dpaa2-mac    +--------------------------------------+
+        ^                             |
+        |                             |                                           Linux
+  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+        |                             |                                     MC firmware
+        |              /|             V
+  +----------+        / |       +----------+
+  |          |       /  |       |          |
+  |          |       |  |       |          |
+  |   DPNI   |<------|  |<------|   DPMAC  |
+  |          |       |  |       |          |
+  |          |       \  |<---+  |          |
+  +----------+        \ |    |  +----------+
+                       \|    |
+                             |
+           +--------------------------------------+
+           | MC firmware polling MAC PCS for link |
+           |  +-----+  +-----+  +-----+  +-----+  |
+           |  | PCS |  | PCS |  | PCS |  | PCS |  |
+           |  +-----+  +-----+  +-----+  +-----+  |
+           |                    Internal MDIO bus |
+           +--------------------------------------+
+
+
+Depending on an MC firmware configuration setting, each MAC may be in one of two modes:
+
+- DPMAC_LINK_TYPE_FIXED: the link state management is handled exclusively by
+  the MC firmware by polling the MAC PCS.
+
+- DPMAC_LINK_TYPE_PHY: the link state comes as an input to the MC firmware
+  itself through the dpmac_set_link_cfg() function.
+
+In both cases, the MC firmware emits an abstracted link state information to
+the connected DPNI which can be retrieved using the dpni_get_link_state()
+command.  This way, users of DPNI interfaces are not required to implement
+complex PHY drivers.
+
+In DPMAC_LINK_TYPE_FIXED mode, a dpaa2-mac driver is not necessary.
+
+Implementation
+--------------
+
+After the system boots and the DPNIs are connected to DPMACs, all network
+interfaces have their respective net_devices exported and ready to be used.
+
+When the dpaa2-eth interface link is requested to go up, the following set of
+steps must happen::
+
+  Inter-driver communication between fsl-mc bus objects through the MC firmware
+
+                             +-----------+                     +-------------+
+                             |           | ------------------> | MC firmware |
+                             | dpaa2-eth |         (1)         |             |
+                             |           | < - - - - - - - - - |             |
+                             +-----------+         (6)         |             |
+                                   |                           |             |
+                                  eth0                         |             |
+                                                               |             |
+  +---------+                +-----------+                     |             |
+  | PHYLINK | <------------  | dpaa2-mac | <------------------ |             |
+  |         |      (3)       |           |         (2)         |             |
+  |         |                |           |                     |             |
+  |         | ------------>  |           | ------------------> |             |
+  +---------+      (4)       +-----------+         (5)         |             |
+                                                               +-------------+
+
+  (1) dpni_enable() - Enable network interface, allowing receiving/sending frames
+  (2) MC sends DPMAC_IRQ_EVENT_LINK_UP_REQ to the dpmac object
+  (3) The dpaa2-mac driver calls phylink_start() on the PHYLINK instance
+  (4) PHYLINK notifies the dpaa2-mac driver through the .mac_config and
+      .mac_link_up calbacks
+  (5) With the information received in the phylink_link_state structure, the
+      dpaa2-mac driver informs the firmware of the new link state
+  (6) At any later time, the dpaa2-eth driver may find the updated link state
+      by calling dpni_get_link_state() to the MC firmware
+
+And the following output is seen in the console::
+
+ # ip link set dev eth0 up
+ [14894.837845] fsl_dpaa2_mac dpmac.17: configuring for phy/rgmii-id link mode
+ [14896.895953] fsl_dpaa2_mac dpmac.17: Link is Up - 1Gbps/Full - flow control off
+ [14896.897478] fsl_dpaa2_eth dpni.0 eth1: Link Event: state up
+
+
+In case of a link change requested by the user through ethtool on the dpaa2-eth
+interface, the same calling flow as above happens between DPNI driver -> MC ->
+DPMAC driver -> PHYLINK and back. However in this case the functions are
+different::
+
+  (1) The dpaa2-eth driver, on the .set_link_ksettings() callback, sends a
+      dpni_set_link_cfg() to the firmware, informing it about the new
+      configuration requested. This firmware command will carry link state
+      options such as autoneg on/off, advertising, duplex, speed.
+  (2) The MC firmware will trigger an DPMAC_IRQ_EVENT_LINK_CFG_REQ.
+  (3) Upon receiving the interrupt, the dpaa2-mac driver will get the
+      requested configuration parameters and construct a new
+      ethtool_link_ksettings command based on them. This will be passed to
+      phylink_ethtool_ksettings_set.
+  (4) If the link state changes, the .mac_config() routine will be called by
+      PHYLINK.
+  (5) The dpaa2-mac driver passes the current state of link from the
+      phylink_link_state argument and notifies the firmware of all the changes
+      (autoneg, speed, etc) through another dpmac_set_link_state() command.
+  (6) Same as above, the DPNI driver can retrieve the updated link state
+      information at a later time through dpni_get_link_state().
diff --git a/Documentation/networking/device_drivers/freescale/dpaa2/index.rst b/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
index 67bd87fe6c53..2cd5d728da19 100644
--- a/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
+++ b/Documentation/networking/device_drivers/freescale/dpaa2/index.rst
@@ -8,3 +8,4 @@ DPAA2 Documentation
    overview
    dpio-driver
    ethernet-driver
+   dpmac-driver
diff --git a/MAINTAINERS b/MAINTAINERS
index a024ab2b2548..0b9c1df5ff8c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4935,6 +4935,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-mac*
 F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
+F:	Documentation/networking/device_drivers/freescale/dpaa2/dpmac-driver.rst
 
 DPT_I2O SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
-- 
1.9.1

