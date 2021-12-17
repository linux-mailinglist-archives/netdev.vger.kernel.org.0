Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F14478AF9
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 13:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhLQMJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 07:09:03 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:22791 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbhLQMJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 07:09:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639742942; x=1671278942;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5yNcl5PFaEnlsYrSY4XKFQvCoguXPjXXv39ZU+sDjYk=;
  b=s6RG5N3o7C4aQp8vnb8Bz9UXLwVt6/iQ6hmJV1Q62AWsjaCilXmbF1Vx
   88gKQXPX9O/Kfw2en9mVLkVqUbnuQoN9tUdK6kDcOTsN1l3mT+rYwSqZx
   DQ4ZEKdpRJqctsBlAjkm/c6X1pmxMUU5IhqgvDaTqsSKCNWOi1Dp8ZaEE
   q20Fo/8t8MAO8R++BWxVyoH/hs5U8y7at5CmivFQbTcamI4PPCOjS38kA
   T5Ljn2GVzOD780SAnP0rjxW/kS1S3MEIcfGbZDlag8CMaVU8Jj4xQGddb
   wvbbFy4r7CMzU8VmqnG/0wlG0JermiGhf67ZQ03Ii+HQquYRNzr2wHQT6
   w==;
IronPort-SDR: xrS5fY5L/u5gYAf4IqzPmpLMqrcP8FdVLtpdZPGG6EuZUpkXw/knxp1mjPsha108y67IQHGXyD
 tTGth3wU0cAb7ER4bAhM5c7p8OYyZukxbt0FC7APC3usT1qLNzdbUqQKga/qe2fb4r8t04egeQ
 A8zfDrQ8IbYc+gYl/+cToPMO0+kMH7kZic3MgJxeoxRQB8ItBxRC0gXOD9jpkF48awzu3sVpFt
 /8SohDYWfqOmZ1OEngYUDlX/BYvEYAtlbrvii08PpgsuK6Svjy/uXEqmSlHmUorXzO7NuCUy50
 ElxP5Nmz8bKfMAbanL3Pe4zc
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="79909733"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2021 05:09:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 05:09:02 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Dec 2021 05:08:59 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v6 0/9] net: lan966x: Add switchdev and vlan support
Date:   Fri, 17 Dec 2021 13:10:08 +0100
Message-ID: <20211217121017.282481-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends lan966x with switchdev and vlan support.
The first patches just adds new registers and extend the MAC table to
handle the interrupts when a new address is learn/forget.

v5->v6:
- fix issues with the singletones, they were not really singletons
- simplify the case where lan966x ports are added to bridges with foreign
  ports
- drop the cases NETDEV_PRE_UP and NETDEV_DOWN
- fix the change of MAC address
- drop the callbacks .ndo_set_features, .ndo_vlan_rx_add_vid,
  .ndo_vlan_rx_kill_vid
- remove duplicate code when port was added in a vlan, the MAC entries
  will be added by the fdb

v4->v5:
- make the notifier_block from lan966x to be singletones
- use switchdev_handle_port_obj_add and switchdev_handle_fdb_event_to_device
  when getting callbacks in the lan966x
- merge the two vlan patches in a single one

v3->v4:
- split the last patch in multiple patches
- replace spin_lock_irqsave/restore with spin_lock/spin_unlock
- remove lan966x_port_change_rx_flags because it was copying all the frames to
  the CPU instead of removing all RX filters.
- implement SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS
- remove calls to __dev_mc_unsync/sync as they are not needed
- replace 0/1 with false/true
- make sure that the lan966x ports are not added to bridges that have other
  interfaces except lan966x
- and allow the lan966x ports to be part of only the same bridge.

v2->v3:
- separate the PVID used when the port is in host mode or vlan unaware
- fix issue when the port was leaving the bridge

v1->v2:
- when allocating entries for the mac table use kzalloc instead of
  devm_kzalloc
- also use GFP_KERNEL instead of GFP_ATOMIC, because is never called
  in atomic context
- when deleting an mac table entry, the order of operations was wrong
- if ana irq is enabled make sure it gets disabled when the driver is
  removed

Horatiu Vultur (9):
  net: lan966x: Add registers that are used for switch and vlan
    functionality
  dt-bindings: net: lan966x: Extend with the analyzer interrupt
  net: lan966x: add support for interrupts from analyzer
  net: lan966x: More MAC table functionality
  net: lan966x: Remove .ndo_change_rx_flags
  net: lan966x: Add support to offload the forwarding.
  net: lan966x: Add vlan support.
  net: lan966x: Extend switchdev bridge flags
  net: lan966x: Extend switchdev with fdb support

 .../net/microchip,lan966x-switch.yaml         |   2 +
 .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 244 +++++++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 342 +++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  95 +++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  64 ++-
 .../ethernet/microchip/lan966x/lan966x_regs.h | 129 +++++
 .../microchip/lan966x/lan966x_switchdev.c     | 468 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_vlan.c | 312 ++++++++++++
 10 files changed, 1632 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c

-- 
2.33.0

