Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EA047587B
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242322AbhLOMMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:12:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:37879 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbhLOMMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 07:12:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639570341; x=1671106341;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m9QBJpZz4/ferBt8KqIYlmt6kaPOZfY4lUKVJ/DH49M=;
  b=akz9txQq2To4/mE6Fo+3pBsWq8sF34H544Dn6jRFn1AOvXoMSgc/rOpN
   7syHF3b07yZRoslJ2ZEQ4p2zTc2I0wSZhMd0aMyiVqB14CZ5LCIZw782Z
   IB4MW3Idizg4p7uvqXkODOeWABh25Akr9O2PMTfIw0AeF0EsX2RC4Nbvi
   ou+gGNbMi/Yhik7zy+27jTm6d7J4ZowrJGwniwREdZtvePKFGHwN4fORs
   uYmg5jPlhRtt7IytLbzGdcIv1RkT5pVoawBPCxge9S1O+TGcoras35zYT
   n4Y0A/kuvBCmqpvozz/4HMT9oQXcvMQPjCzreiaAGqL8tPm+ivgsT14F7
   Q==;
IronPort-SDR: a4k9LYkVbBm6ueNGJNx8mKcxIwuWaKV3Irte5FEFFXx1EPDeC6Pj1TcVWqDeXypVQtWtyDXDCC
 e+B//CfifqbG+z45xwvcHnBaZTx8Jg7C6TWi+2hkITOHdYrc25Noy/B5g5pZ9Fithl//BFLxhX
 2bDghbiRvcrIw4lX6yCQF1acs/n8abNaJWo8WUMRpAthQbzO2XIJ/UESw1C3muRqTDXgr7M8gd
 7iy9jL5T403f+xsTlqHo3fqaDguiS3cgpiagiwlETSa2Fo/xB6VK7ppqgipoDN9gEC8zQ/AzJd
 KHS4KmAjqiXjxgjfGOFKFQlJ
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="146742453"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Dec 2021 05:12:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Dec 2021 05:12:19 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 15 Dec 2021 05:12:16 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 0/9] net: lan966x: Add switchdev and vlan support
Date:   Wed, 15 Dec 2021 13:13:00 +0100
Message-ID: <20211215121309.3669119-1-horatiu.vultur@microchip.com>
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
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 246 ++++++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 342 +++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c | 109 +++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  80 ++-
 .../ethernet/microchip/lan966x/lan966x_regs.h | 129 ++++
 .../microchip/lan966x/lan966x_switchdev.c     | 557 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_vlan.c | 448 ++++++++++++++
 10 files changed, 1886 insertions(+), 31 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c

-- 
2.33.0

