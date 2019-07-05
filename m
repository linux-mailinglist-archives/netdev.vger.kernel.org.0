Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF0E603C6
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 12:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfGEKHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 06:07:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33628 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfGEKG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 06:06:59 -0400
Received: from [5.158.153.52] (helo=mitra.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hjL7G-00045l-NQ; Fri, 05 Jul 2019 12:06:54 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH v3 2/2] Documentation: net: dsa: b53: Describe b53 configuration
Date:   Fri,  5 Jul 2019 11:57:19 +0200
Message-Id: <20190705095719.24095-3-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190705095719.24095-1-b.spranger@linutronix.de>
References: <20190705095719.24095-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the different needs of documentation for the b53 driver.

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 Documentation/networking/dsa/b53.rst   | 183 +++++++++++++++++++++++++
 Documentation/networking/dsa/index.rst |   1 +
 2 files changed, 184 insertions(+)
 create mode 100644 Documentation/networking/dsa/b53.rst

diff --git a/Documentation/networking/dsa/b53.rst b/Documentation/networking/dsa/b53.rst
new file mode 100644
index 000000000000..b41637cdb82b
--- /dev/null
+++ b/Documentation/networking/dsa/b53.rst
@@ -0,0 +1,183 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========================================
+Broadcom RoboSwitch Ethernet switch driver
+==========================================
+
+The Broadcom RoboSwitch Ethernet switch family is used in quite a range of
+xDSL router, cable modems and other multimedia devices.
+
+The actual implementation supports the devices BCM5325E, BCM5365, BCM539x,
+BCM53115 and BCM53125 as well as BCM63XX.
+
+Implementation details
+======================
+
+The driver is located in ``drivers/net/dsa/b53/`` and is implemented as a
+DSA driver; see ``Documentation/networking/dsa/dsa.rst`` for details on the
+subsystem and what it provides.
+
+The switch is, if possible, configured to enable a Broadcom specific 4-bytes
+switch tag which gets inserted by the switch for every packet forwarded to the
+CPU interface, conversely, the CPU network interface should insert a similar
+tag for packets entering the CPU port. The tag format is described in
+``net/dsa/tag_brcm.c``.
+
+The configuration of the device depends on whether or not tagging is
+supported.
+
+The interface names and example network configuration are used according the
+configuration described in the :ref:`dsa-config-showcases`.
+
+Configuration with tagging support
+----------------------------------
+
+The tagging based configuration is desired. It is not specific to the b53
+DSA driver and will work like all DSA drivers which supports tagging.
+
+See :ref:`dsa-tagged-configuration`.
+
+Configuration without tagging support
+-------------------------------------
+
+Older models (5325, 5365) support a different tag format that is not supported
+yet. 539x and 531x5 require managed mode and some special handling, which is
+also not yet supported. The tagging support is disabled in these cases and the
+switch need a different configuration.
+
+The configuration slightly differ from the :ref:`dsa-vlan-configuration`.
+
+The b53 tags the CPU port in all VLANs, since otherwise any PVID untagged
+VLAN programming would basically change the CPU port's default PVID and make
+it untagged, undesirable.
+
+In difference to the configuration described in :ref:`dsa-vlan-configuration`
+the default VLAN 1 has to be removed from the slave interface configuration in
+single port and gateway configuration, while there is no need to add an extra
+VLAN configuration in the bridge showcase.
+
+single port
+~~~~~~~~~~~
+The configuration can only be set up via VLAN tagging and bridge setup.
+By default packages are tagged with vid 1:
+
+.. code-block:: sh
+
+  # tag traffic on CPU port
+  ip link add link eth0 name eth0.1 type vlan id 1
+  ip link add link eth0 name eth0.2 type vlan id 2
+  ip link add link eth0 name eth0.3 type vlan id 3
+
+  # The master interface needs to be brought up before the slave ports.
+  ip link set eth0 up
+  ip link set eth0.1 up
+  ip link set eth0.2 up
+  ip link set eth0.3 up
+
+  # bring up the slave interfaces
+  ip link set wan up
+  ip link set lan1 up
+  ip link set lan2 up
+
+  # create bridge
+  ip link add name br0 type bridge
+
+  # activate VLAN filtering
+  ip link set dev br0 type bridge vlan_filtering 1
+
+  # add ports to bridges
+  ip link set dev wan master br0
+  ip link set dev lan1 master br0
+  ip link set dev lan2 master br0
+
+  # tag traffic on ports
+  bridge vlan add dev lan1 vid 2 pvid untagged
+  bridge vlan del dev lan1 vid 1
+  bridge vlan add dev lan2 vid 3 pvid untagged
+  bridge vlan del dev lan2 vid 1
+
+  # configure the VLANs
+  ip addr add 192.0.2.1/30 dev eth0.1
+  ip addr add 192.0.2.5/30 dev eth0.2
+  ip addr add 192.0.2.9/30 dev eth0.3
+
+  # bring up the bridge devices
+  ip link set br0 up
+
+
+bridge
+~~~~~~
+
+.. code-block:: sh
+
+  # tag traffic on CPU port
+  ip link add link eth0 name eth0.1 type vlan id 1
+
+  # The master interface needs to be brought up before the slave ports.
+  ip link set eth0 up
+  ip link set eth0.1 up
+
+  # bring up the slave interfaces
+  ip link set wan up
+  ip link set lan1 up
+  ip link set lan2 up
+
+  # create bridge
+  ip link add name br0 type bridge
+
+  # activate VLAN filtering
+  ip link set dev br0 type bridge vlan_filtering 1
+
+  # add ports to bridge
+  ip link set dev wan master br0
+  ip link set dev lan1 master br0
+  ip link set dev lan2 master br0
+  ip link set eth0.1 master br0
+
+  # configure the bridge
+  ip addr add 192.0.2.129/25 dev br0
+
+  # bring up the bridge
+  ip link set dev br0 up
+
+gateway
+~~~~~~~
+
+.. code-block:: sh
+
+  # tag traffic on CPU port
+  ip link add link eth0 name eth0.1 type vlan id 1
+  ip link add link eth0 name eth0.2 type vlan id 2
+
+  # The master interface needs to be brought up before the slave ports.
+  ip link set eth0 up
+  ip link set eth0.1 up
+  ip link set eth0.2 up
+
+  # bring up the slave interfaces
+  ip link set wan up
+  ip link set lan1 up
+  ip link set lan2 up
+
+  # create bridge
+  ip link add name br0 type bridge
+
+  # activate VLAN filtering
+  ip link set dev br0 type bridge vlan_filtering 1
+
+  # add ports to bridges
+  ip link set dev wan master br0
+  ip link set eth0.1 master br0
+  ip link set dev lan1 master br0
+  ip link set dev lan2 master br0
+
+  # tag traffic on ports
+  bridge vlan add dev wan vid 2 pvid untagged
+  bridge vlan del dev wan vid 1
+
+  # configure the VLANs
+  ip addr add 192.0.2.1/30 dev eth0.2
+  ip addr add 192.0.2.129/25 dev br0
+
+  # bring up the bridge devices
+  ip link set br0 up
diff --git a/Documentation/networking/dsa/index.rst b/Documentation/networking/dsa/index.rst
index c279cfbf9083..ee631e2d646f 100644
--- a/Documentation/networking/dsa/index.rst
+++ b/Documentation/networking/dsa/index.rst
@@ -6,6 +6,7 @@ Distributed Switch Architecture
    :maxdepth: 1
 
    dsa
+   b53
    bcm_sf2
    lan9303
    sja1105
-- 
2.20.1

