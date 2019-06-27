Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3281D58027
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfF0KY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:24:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52954 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0KY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:24:28 -0400
Received: from [5.158.153.52] (helo=mitra.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hgRZm-0007Wg-F5; Thu, 27 Jun 2019 12:24:22 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH 1/1] Documentation: net: dsa: b53: Describe b53 configuration
Date:   Thu, 27 Jun 2019 12:15:06 +0200
Message-Id: <20190627101506.19727-2-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627101506.19727-1-b.spranger@linutronix.de>
References: <39b134ed-9f3e-418a-bf26-c1e716018e7e@gmail.com>
 <20190627101506.19727-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the different needs of documentation for the b53 driver.

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 Documentation/networking/dsa/b53.rst | 300 +++++++++++++++++++++++++++
 1 file changed, 300 insertions(+)
 create mode 100644 Documentation/networking/dsa/b53.rst

diff --git a/Documentation/networking/dsa/b53.rst b/Documentation/networking/dsa/b53.rst
new file mode 100644
index 000000000000..5838cf6230da
--- /dev/null
+++ b/Documentation/networking/dsa/b53.rst
@@ -0,0 +1,300 @@
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
+The driver is located in ``drivers/net/dsa/bcm_sf2.c`` and is implemented as a
+DSA driver; see ``Documentation/networking/dsa/dsa.rst`` for details on the
+subsystemand what it provides.
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
+Configuration with tagging support
+----------------------------------
+
+The tagging based configuration is desired.
+
+To use the b53 DSA driver some configuration need to be performed. As
+example configuration the following scenarios are used:
+
+*single port*
+  Every switch port acts as a different configurable ethernet port
+
+*bridge*
+  Every switch port is part of one configurable ethernet bridge
+
+*gateway*
+  Every switch port except one upstream port is part of a configurable
+  ethernet bridge.
+  The upstream port acts as different configurable ethernet port.
+
+All configurations are performed with tools from iproute2, wich is available at
+https://www.kernel.org/pub/linux/utils/net/iproute2/
+
+In this documentation the following ethernet ports are used:
+
+*eth0*
+  CPU port
+
+*LAN1*
+  a switch port
+
+*LAN2*
+  another switch port
+
+*WAN*
+  A switch port dedicated as upstream port
+
+Further ethernet ports can be configured similar.
+The configured IPs and networks are:
+
+*single port*
+  *  wan: 192.0.2.1/30 (192.0.2.0 - 192.0.2.3)
+  * lan1: 192.0.2.5/30 (192.0.2.4 - 192.0.2.7)
+  * lan2: 192.0.2.9/30 (192.0.2.8 - 192.0.2.11)
+
+*bridge*
+  * br0: 192.0.2.129/25 (192.0.2.128 - 192.0.2.255)
+
+*gateway*
+  * br0: 192.0.2.129/25 (192.0.2.128 - 192.0.2.255)
+  * wan: 192.0.2.1/30 (192.0.2.0 - 192.0.2.3)
+
+single port
+~~~~~~~~~~~
+
+.. code-block:: sh
+
+  # configure each interface
+  ip addr add 192.0.2.1/30 dev wan
+  ip addr add 192.0.2.5/30 dev lan1
+  ip addr add 192.0.2.9/30 dev lan2
+
+  # The master interface needs to be brought up before the slave ports.
+  ip link set eth0 up
+
+  # bring up the slave interfaces
+  ip link set wan up
+  ip link set lan1 up
+  ip link set lan2 up
+
+bridge
+~~~~~~
+
+.. code-block:: sh
+
+  # create bridge
+  ip link add name br0 type bridge
+
+  # add ports to bridge
+  ip link set dev wan master br0
+  ip link set dev lan1 master br0
+  ip link set dev lan2 master br0
+
+  # configure the bridge
+  ip addr add 192.0.2.129/25 dev br0
+
+  # The master interface needs to be brought up before the slave ports.
+  ip link set eth0 up
+
+  # bring up the slave interfaces
+  ip link set wan up
+  ip link set lan1 up
+  ip link set lan2 up
+
+  # bring up the bridge
+  ip link set dev br0 up
+
+gateway
+~~~~~~~
+
+.. code-block:: sh
+
+  # create bridge
+  ip link add name br0 type bridge
+
+  # add ports to bridge
+  ip link set dev lan1 master br0
+  ip link set dev lan2 master br0
+
+  # configure the bridge
+  ip addr add 192.0.2.129/25 dev br0
+
+  # configure the upstream port
+  ip addr add 192.0.2.1/30 dev wan
+
+  # The master interface needs to be brought up before the slave ports.
+  ip link set eth0 up
+
+  # bring up the slave interfaces
+  ip link set wan up
+  ip link set lan1 up
+  ip link set lan2 up
+
+  # bring up the bridge
+  ip link set dev br0 up
+
+Configuration without tagging support
+-------------------------------------
+
+Older models (5325, 5365) support a different tag format that is not supported
+yet. 539x and 531x5 require managed mode and some special handling, which is
+also not yet supported. The tagging support is disabled in these cases and the
+switch need a different configuration.
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
+  # create bridges
+  ip link add name br0 type bridge
+  ip link add name br1 type bridge
+  ip link add name br2 type bridge
+
+  # activate VLAN filtering
+  ip link set dev br0 type bridge vlan_filtering 1
+  ip link set dev br1 type bridge vlan_filtering 1
+  ip link set dev br2 type bridge vlan_filtering 1
+
+  # add ports to bridges
+  ip link set dev wan master br0
+  ip link set eth0.1 master br0
+  ip link set dev lan1 master br1
+  ip link set eth0.2 master br1
+  ip link set dev lan2 master br2
+  ip link set eth0.3 master br2
+
+  # tag traffic on ports
+  bridge vlan add dev lan1 vid 2 pvid untagged
+  bridge vlan del dev lan1 vid 1
+  bridge vlan add dev lan2 vid 3 pvid untagged
+  bridge vlan del dev lan2 vid 1
+
+  # configure the bridges
+  ip addr add 192.0.2.1/30 dev br0
+  ip addr add 192.0.2.5/30 dev br1
+  ip addr add 192.0.2.9/30 dev br2
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
+  # bring up the bridge devices
+  ip link set br0 up
+  ip link set br1 up
+  ip link set br2 up
+
+bridge
+~~~~~~
+
+.. code-block:: sh
+
+  # tag traffic on CPU port
+  ip link add link eth0 name eth0.1 type vlan id 1
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
+  # The master interface needs to be brought up before the slave ports.
+  ip link set eth0 up
+  ip link set eth0.1 up
+
+  # bring up the slave interfaces
+  ip link set wan up
+  ip link set lan1 up
+  ip link set lan2 up
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
+  # create bridges
+  ip link add name br0 type bridge
+  ip link add name br1 type bridge
+
+  # activate VLAN filtering
+  ip link set dev br0 type bridge vlan_filtering 1
+  ip link set dev br1 type bridge vlan_filtering 1
+
+  # add ports to bridges
+  ip link set dev wan master br0
+  ip link set eth0.1 master br0
+  ip link set dev lan1 master br1
+  ip link set dev lan2 master br1
+  ip link set eth0.2 master br1
+
+  # tag traffic on ports
+  bridge vlan add dev lan1 vid 2 pvid untagged
+  bridge vlan add dev lan2 vid 2 pvid untagged
+  bridge vlan del dev lan1 vid 1
+  bridge vlan del dev lan2 vid 1
+
+  # configure the bridges
+  ip addr add 192.0.2.1/30 dev br0
+  ip addr add 192.0.2.129/25 dev br1
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
+  # bring up the bridge devices
+  ip link set br0 up
+  ip link set br1 up
-- 
2.20.1

