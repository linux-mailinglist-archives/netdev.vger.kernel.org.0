Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A74E472916
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241589AbhLMKR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:17:59 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:44515 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243905AbhLMKO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:14:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639390496; x=1670926496;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=20gYSmgf7tNLbzpLDB1Yj0/QuQNdYvNJn3kDVCycGkc=;
  b=ZsRccbO231hMhXpO83Sknss9JUvJbifrfy/zjh3ZoVxA9tUmurj7AfFi
   kIMzrVWl997o28H7V7L5kcWJsoj+BakHBSRR1lQrk4WdaN21z2ZtKk/d/
   bk//KK4scvA5Q88GfBzOrKYpCRq60tc6BmK2914KZDyN/1l0ZE8gt89ZU
   XDbrBr8QYbz8be2AHxr1bZK451eo/bF4/gV1vRlcwagRnbpB2qH+cFWOT
   q8YCHQlsExj7M/4OCdT2cc5OcAT0ClBhPMK8SKcw61x09vWERoY26Qsu6
   e99xyNRUG8e4B9BRzDv+nU3QeewJIWwhOTejyBw13BVpAB0C1uPeMcC+O
   Q==;
IronPort-SDR: 8KewfYW6UW34AHCevt2OdV5VaAKakIthkOaEk7OKfNSgHx3mEOEX3/uPDoyvYilrFDQLPrkTg1
 fG8+YJnw0HffFsnpJfA9Z0hZ+fOa8porRDPgxGb2wNyQcw7NTPp7g2CCC4PQ05YK0+120J6lB9
 tjVpH/xbbxf89uWNKwd9F4IJTWf2s/oBGnp506Jqj36jif65eEu3f0BONUXJMUPrwZPZDhGTgu
 e8dcF1ksiVzXO+aMdoZPPghS8MQm4Ckb+OU3rCg/wwO3Q02cAy+lEykp34vSbMitZieqPvTPyN
 Pw2pTjLYU1mamI21LKpwV7LP
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="139554873"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 03:14:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 03:14:54 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 13 Dec 2021 03:14:51 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 00/10] net: lan966x: Add switchdev and vlan support
Date:   Mon, 13 Dec 2021 11:14:22 +0100
Message-ID: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
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

Horatiu Vultur (10):
  net: lan966x: Add registers that are used for switch and vlan
    functionality
  dt-bindings: net: lan966x: Extend with the analyzer interrupt
  net: lan966x: add support for interrupts from analyzer
  net: lan966x: More MAC table functionality
  net: lan966x: Add vlan support
  net: lan966x: Remove .ndo_change_rx_flags
  net: lan966x: Add support to offload the forwarding.
  net: lan966x: Extend switchdev with vlan support
  net: lan966x: Extend switchdev bridge flags
  net: lan966x: Extend switchdev with fdb support

 .../net/microchip,lan966x-switch.yaml         |   2 +
 .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
 .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
 .../ethernet/microchip/lan966x/lan966x_fdb.c  | 214 +++++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 342 +++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c | 112 +++-
 .../ethernet/microchip/lan966x/lan966x_main.h |  83 ++-
 .../ethernet/microchip/lan966x/lan966x_regs.h | 129 ++++
 .../microchip/lan966x/lan966x_switchdev.c     | 554 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_vlan.c | 446 ++++++++++++++
 10 files changed, 1855 insertions(+), 31 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c

-- 
2.33.0

