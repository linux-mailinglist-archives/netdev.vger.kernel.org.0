Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5751C184D
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgEAOqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729581AbgEAOpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:11 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0469249A0;
        Fri,  1 May 2020 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344307;
        bh=g0xl92nV93LD4/lKfrxGhjaAWkLh3HtF4UtH247ZGKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xd/NL49/dvuO0ZhMkB1C0YKdTBggjnhIVkBTXcQpOsalVpfR/jdOC7RX/0ezpdC4W
         ktpvl6lE0vFsCIBK8YuzPDGVbtlWcJ/LObGkjRRaAGN3cend7heH8ycDn2XugiB9j7
         IuOLIsq79r7dN8BKpgzP8o/MnCoRhdCN3upuYilo=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuU-00FCf6-2B; Fri, 01 May 2020 16:45:02 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 32/37] docs: networking: device drivers: convert ti/cpsw_switchdev.txt to ReST
Date:   Fri,  1 May 2020 16:44:54 +0200
Message-Id: <f7e5b2407ae1731d6776aebe983e516de48ea85f.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- use :field: markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/index.rst       |   1 +
 ...{cpsw_switchdev.txt => cpsw_switchdev.rst} | 239 ++++++++++--------
 2 files changed, 137 insertions(+), 103 deletions(-)
 rename Documentation/networking/device_drivers/ti/{cpsw_switchdev.txt => cpsw_switchdev.rst} (51%)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index 3479e6f576c3..b3c0c473de2b 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -47,6 +47,7 @@ Contents:
    qualcomm/rmnet
    sb1000
    smsc/smc9
+   ti/cpsw_switchdev
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/ti/cpsw_switchdev.txt b/Documentation/networking/device_drivers/ti/cpsw_switchdev.rst
similarity index 51%
rename from Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
rename to Documentation/networking/device_drivers/ti/cpsw_switchdev.rst
index 12855ab268b8..1241ecac73bd 100644
--- a/Documentation/networking/device_drivers/ti/cpsw_switchdev.txt
+++ b/Documentation/networking/device_drivers/ti/cpsw_switchdev.rst
@@ -1,30 +1,44 @@
-* Texas Instruments CPSW switchdev based ethernet driver 2.0
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================================
+Texas Instruments CPSW switchdev based ethernet driver
+======================================================
+
+:Version: 2.0
+
+Port renaming
+=============
 
-- Port renaming
 On older udev versions renaming of ethX to swXpY will not be automatically
 supported
-In order to rename via udev:
-ip -d link show dev sw0p1 | grep switchid
 
-SUBSYSTEM=="net", ACTION=="add", ATTR{phys_switch_id}==<switchid>, \
-        ATTR{phys_port_name}!="", NAME="sw0$attr{phys_port_name}"
+In order to rename via udev::
 
+    ip -d link show dev sw0p1 | grep switchid
+
+    SUBSYSTEM=="net", ACTION=="add", ATTR{phys_switch_id}==<switchid>, \
+	    ATTR{phys_port_name}!="", NAME="sw0$attr{phys_port_name}"
+
+
+Dual mac mode
+=============
 
-====================
-# Dual mac mode
-====================
 - The new (cpsw_new.c) driver is operating in dual-emac mode by default, thus
-working as 2 individual network interfaces. Main differences from legacy CPSW
-driver are:
+  working as 2 individual network interfaces. Main differences from legacy CPSW
+  driver are:
+
  - optimized promiscuous mode: The P0_UNI_FLOOD (both ports) is enabled in
-addition to ALLMULTI (current port) instead of ALE_BYPASS.
-So, Ports in promiscuous mode will keep possibility of mcast and vlan filtering,
-which is provides significant benefits when ports are joined to the same bridge,
-but without enabling "switch" mode, or to different bridges.
+   addition to ALLMULTI (current port) instead of ALE_BYPASS.
+   So, Ports in promiscuous mode will keep possibility of mcast and vlan
+   filtering, which is provides significant benefits when ports are joined
+   to the same bridge, but without enabling "switch" mode, or to different
+   bridges.
  - learning disabled on ports as it make not too much sense for
    segregated ports - no forwarding in HW.
  - enabled basic support for devlink.
 
+   ::
+
 	devlink dev show
 		platform/48484000.switch
 
@@ -38,22 +52,25 @@ but without enabling "switch" mode, or to different bridges.
 		cmode runtime value false
 
 Devlink configuration parameters
-====================
+================================
+
 See Documentation/networking/devlink/ti-cpsw-switch.rst
 
-====================
-# Bridging in dual mac mode
-====================
+Bridging in dual mac mode
+=========================
+
 The dual_mac mode requires two vids to be reserved for internal purposes,
 which, by default, equal CPSW Port numbers. As result, bridge has to be
-configured in vlan unaware mode or default_pvid has to be adjusted.
+configured in vlan unaware mode or default_pvid has to be adjusted::
 
 	ip link add name br0 type bridge
 	ip link set dev br0 type bridge vlan_filtering 0
 	echo 0 > /sys/class/net/br0/bridge/default_pvid
 	ip link set dev sw0p1 master br0
 	ip link set dev sw0p2 master br0
- - or -
+
+or::
+
 	ip link add name br0 type bridge
 	ip link set dev br0 type bridge vlan_filtering 0
 	echo 100 > /sys/class/net/br0/bridge/default_pvid
@@ -61,11 +78,12 @@ configured in vlan unaware mode or default_pvid has to be adjusted.
 	ip link set dev sw0p1 master br0
 	ip link set dev sw0p2 master br0
 
-====================
-# Enabling "switch"
-====================
+Enabling "switch"
+=================
+
 The Switch mode can be enabled by configuring devlink driver parameter
-"switch_mode" to 1/true:
+"switch_mode" to 1/true::
+
 	devlink dev param set platform/48484000.switch \
 	name switch_mode value 1 cmode runtime
 
@@ -79,9 +97,11 @@ marking packets with offload_fwd_mark flag unless "ale_bypass=0"
 
 All configuration is implemented via switchdev API.
 
-====================
-# Bridge setup
-====================
+Bridge setup
+============
+
+::
+
 	devlink dev param set platform/48484000.switch \
 	name switch_mode value 1 cmode runtime
 
@@ -91,56 +111,65 @@ All configuration is implemented via switchdev API.
 	ip link set dev sw0p2 up
 	ip link set dev sw0p1 master br0
 	ip link set dev sw0p2 master br0
+
 	[*] bridge vlan add dev br0 vid 1 pvid untagged self
 
-[*] if vlan_filtering=1. where default_pvid=1
+	[*] if vlan_filtering=1. where default_pvid=1
 
-=================
-# On/off STP
-=================
-ip link set dev BRDEV type bridge stp_state 1/0
+	Note. Steps [*] are mandatory.
 
-Note. Steps [*] are mandatory.
 
-====================
-# VLAN configuration
-====================
-bridge vlan add dev br0 vid 1 pvid untagged self <---- add cpu port to VLAN 1
+On/off STP
+==========
+
+::
+
+	ip link set dev BRDEV type bridge stp_state 1/0
+
+VLAN configuration
+==================
+
+::
+
+  bridge vlan add dev br0 vid 1 pvid untagged self <---- add cpu port to VLAN 1
 
 Note. This step is mandatory for bridge/default_pvid.
 
-=================
-# Add extra VLANs
-=================
- 1. untagged:
-    bridge vlan add dev sw0p1 vid 100 pvid untagged master
-    bridge vlan add dev sw0p2 vid 100 pvid untagged master
-    bridge vlan add dev br0 vid 100 pvid untagged self <---- Add cpu port to VLAN100
-
- 2. tagged:
-    bridge vlan add dev sw0p1 vid 100 master
-    bridge vlan add dev sw0p2 vid 100 master
-    bridge vlan add dev br0 vid 100 pvid tagged self <---- Add cpu port to VLAN100
-
-====
+Add extra VLANs
+===============
+
+ 1. untagged::
+
+	bridge vlan add dev sw0p1 vid 100 pvid untagged master
+	bridge vlan add dev sw0p2 vid 100 pvid untagged master
+	bridge vlan add dev br0 vid 100 pvid untagged self <---- Add cpu port to VLAN100
+
+ 2. tagged::
+
+	bridge vlan add dev sw0p1 vid 100 master
+	bridge vlan add dev sw0p2 vid 100 master
+	bridge vlan add dev br0 vid 100 pvid tagged self <---- Add cpu port to VLAN100
+
 FDBs
-====
+----
+
 FDBs are automatically added on the appropriate switch port upon detection
 
-Manually adding FDBs:
-bridge fdb add aa:bb:cc:dd:ee:ff dev sw0p1 master vlan 100
-bridge fdb add aa:bb:cc:dd:ee:fe dev sw0p2 master <---- Add on all VLANs
+Manually adding FDBs::
+
+    bridge fdb add aa:bb:cc:dd:ee:ff dev sw0p1 master vlan 100
+    bridge fdb add aa:bb:cc:dd:ee:fe dev sw0p2 master <---- Add on all VLANs
 
-====
 MDBs
-====
+----
+
 MDBs are automatically added on the appropriate switch port upon detection
 
-Manually adding MDBs:
-bridge mdb add dev br0 port sw0p1 grp 239.1.1.1 permanent vid 100
-bridge mdb add dev br0 port sw0p1 grp 239.1.1.1 permanent <---- Add on all VLANs
+Manually adding MDBs::
+
+  bridge mdb add dev br0 port sw0p1 grp 239.1.1.1 permanent vid 100
+  bridge mdb add dev br0 port sw0p1 grp 239.1.1.1 permanent <---- Add on all VLANs
 
-==================
 Multicast flooding
 ==================
 CPU port mcast_flooding is always on
@@ -148,9 +177,11 @@ CPU port mcast_flooding is always on
 Turning flooding on/off on swithch ports:
 bridge link set dev sw0p1 mcast_flood on/off
 
-==================
 Access and Trunk port
-==================
+=====================
+
+::
+
  bridge vlan add dev sw0p1 vid 100 pvid untagged master
  bridge vlan add dev sw0p2 vid 100 master
 
@@ -158,52 +189,54 @@ Access and Trunk port
  bridge vlan add dev br0 vid 100 self
  ip link add link br0 name br0.100 type vlan id 100
 
- Note. Setting PVID on Bridge device itself working only for
- default VLAN (default_pvid).
+Note. Setting PVID on Bridge device itself working only for
+default VLAN (default_pvid).
+
+NFS
+===
 
-=====================
- NFS
-=====================
 The only way for NFS to work is by chrooting to a minimal environment when
 switch configuration that will affect connectivity is needed.
 Assuming you are booting NFS with eth1 interface(the script is hacky and
 it's just there to prove NFS is doable).
 
-setup.sh:
-#!/bin/sh
-mkdir proc
-mount -t proc none /proc
-ifconfig br0  > /dev/null
-if [ $? -ne 0 ]; then
-        echo "Setting up bridge"
-        ip link add name br0 type bridge
-        ip link set dev br0 type bridge ageing_time 1000
-        ip link set dev br0 type bridge vlan_filtering 1
+setup.sh::
 
-        ip link set eth1 down
-        ip link set eth1 name sw0p1
-        ip link set dev sw0p1 up
-        ip link set dev sw0p2 up
-        ip link set dev sw0p2 master br0
-        ip link set dev sw0p1 master br0
-        bridge vlan add dev br0 vid 1 pvid untagged self
-        ifconfig sw0p1 0.0.0.0
-        udhchc -i br0
-fi
-umount /proc
+	#!/bin/sh
+	mkdir proc
+	mount -t proc none /proc
+	ifconfig br0  > /dev/null
+	if [ $? -ne 0 ]; then
+		echo "Setting up bridge"
+		ip link add name br0 type bridge
+		ip link set dev br0 type bridge ageing_time 1000
+		ip link set dev br0 type bridge vlan_filtering 1
 
-run_nfs.sh:
-#!/bin/sh
-mkdir /tmp/root/bin -p
-mkdir /tmp/root/lib -p
+		ip link set eth1 down
+		ip link set eth1 name sw0p1
+		ip link set dev sw0p1 up
+		ip link set dev sw0p2 up
+		ip link set dev sw0p2 master br0
+		ip link set dev sw0p1 master br0
+		bridge vlan add dev br0 vid 1 pvid untagged self
+		ifconfig sw0p1 0.0.0.0
+		udhchc -i br0
+	fi
+	umount /proc
 
-cp -r /lib/ /tmp/root/
-cp -r /bin/ /tmp/root/
-cp /sbin/ip /tmp/root/bin
-cp /sbin/bridge /tmp/root/bin
-cp /sbin/ifconfig /tmp/root/bin
-cp /sbin/udhcpc /tmp/root/bin
-cp /path/to/setup.sh /tmp/root/bin
-chroot /tmp/root/ busybox sh /bin/setup.sh
+run_nfs.sh:::
 
-run ./run_nfs.sh
+	#!/bin/sh
+	mkdir /tmp/root/bin -p
+	mkdir /tmp/root/lib -p
+
+	cp -r /lib/ /tmp/root/
+	cp -r /bin/ /tmp/root/
+	cp /sbin/ip /tmp/root/bin
+	cp /sbin/bridge /tmp/root/bin
+	cp /sbin/ifconfig /tmp/root/bin
+	cp /sbin/udhcpc /tmp/root/bin
+	cp /path/to/setup.sh /tmp/root/bin
+	chroot /tmp/root/ busybox sh /bin/setup.sh
+
+	run ./run_nfs.sh
-- 
2.25.4

