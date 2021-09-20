Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E239411220
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbhITJwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:52:49 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46449 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhITJwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131476; x=1663667476;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nG1+qtmEDFsFcOLpAMVYCqRxXWk4yUD9XWvxrO9U8y4=;
  b=jLq+SBaa4blASjaa/d2Wlu+JetaEfK3mc+tC+KU1pdS3vR3ERnPuzJw3
   qkba5eENrZIZLP5Q9Kkqpk9+2e+gc60tpT5GBXbBdpGSklXKCIre0aXAS
   P2rrp6I4YKhqKvGdHzfBeXTtGhIYcb7VoUXn+ufapqjeMglXd0LHsu/Sb
   UFdqZXkLYnzlzdiXmkbjrDr2/twm5yFlxG8C2HsT3NjHXA0oX5eJbux/p
   Cb4ICHB/g2MU/WJw0PKs+5ss+qZvJc29G6DulF6f1vhN5Ot5BzAbLrziv
   /uQqYKhi+P6JZJEB9OBqazqRvOp4CzPcSRdD2dlcRWZagF1976DLEOWRj
   w==;
IronPort-SDR: 0/4JdHHAnTdixmi1+h8qKSF54uSsd5GNf0W1J8QZC9s8uYTPpMJgp681X64gAWuhj7lBEo2bBe
 4kXlYrPpmdNCiQH0CsXPbfmg7priVDZL29mFJF+MfVQmQR2Yku7xgrslpB/FFMXhQ3zQ9OYrWW
 hw3yoBWsor6tQXVXgMLVS88DFvyw/JezNNf1jYlToarXcicL4Q5ku4X2MyozxzDlKYnrDNY6c9
 LGhkXArdP5tbRQTexbsqzfhg0/ngvLA30Wlmk5PHygJbPvV3xDWexjQDl6rz4nENC+yPctb+11
 pweguuHzFbLzl3nLP/uryNp0
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="132434705"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:12 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:09 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 00/12] Add lan966x driver
Date:   Mon, 20 Sep 2021 11:52:06 +0200
Message-ID: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series cover multiple drivers but I have put everything in one
single series so it would be easier to follow the big picture. Eventually
this series will be split in multiple ones once we drop the RFC.

The Microchip LAN966X is a compact and cost-effective, multi-port Gigabit
AVB/TSN Ethernet Switches with two integrated 10/100/1000BASE-T PHYs and a
600 MHz ARM Cortex A7 CPU subsystem. The LAN966X includes eight ports.

In addition to the two integrated PHYs, the lAN966X supports up to
2 RGMII/RMII, up to 3 1000BASE-X/SerDes/ 2.5GBASE-X/KX, and up to
2 Quad-SGMII/Quad-USGMII interfaces. The LAN966X fully supports the IEEE
family of Audio Video Bridging (AVB) and Time Sensitive Networking (TSN)
standards, including the current IEC/IEEE draft 60802 TSN profile,
which in concert provide high Quality of Service (QoS) for latency
sensitive traffic streams over Ethernet.

The LAN966X supports TSN domain protection though IEEE 802.1Qci Per Stream
Filtering and Policing, advanced classification rules, and tunneling by
adding VLAN tags. Each egress port supports eight priorities. Prior to
scheduling, traffic can be shaped using dual-leaky bucket shaping,
IEEE 802.1Qav Credit Based Shaping, and IEEE 802.1Qbv Time Aware Shaping,
thus also supporting IEEE 802.1Q Enhanced Transmission Selection.

Low latency is possible though latency optimized architecture,
cut-through, and IEEE 802.1Qbu/802.3br Preemption. For higher traffic
availability, the LAN966X supports Multiple Spanning Tree, IEEE 802.1CB
Frame Replication and Elimination for Redundancy, IEC 62439-2 MRP,
ODVA DLR, in addition to ITU-T G.8031 and G.8032 linear and ring
protection.

The LAN966X supports IEEE 802.1AS-2020 (gPTP) and IEEE 1588-2019 (PTP)
time synchronization with time stamping in multiple domains in
support of Working Clock and Global Time distribution.

The LAN966X can operate either as a standalone switch or as a system
co-processor with an external host CPU. The external host can manage the
switch via PCIe or an Ethernet port.

This series provides support for:
- support for integrated PHY
- host mode providing register based injection and extraction

More support will be added in future patches.

Horatiu Vultur (12):
  net: mdio: mscc-miim: Fix the mdio controller
  net: phy: mchp: Add support for LAN8804 PHY
  phy: Add lan966x ethernet serdes PHY driver
  dt-bindings: reset: Add lan966x switch reset bindings
  reset: lan966x: Add switch reset driver
  dt-bindings: reset: Add lan966x power reset bindings
  power: reset: Add lan966x power reset driver
  dt-bindings: net: lan966x: Add lan966x-switch bindings
  net: lan966x: add the basic lan966x driver
  net: lan966x: add port module support
  net: lan966x: add mactable support
  net: lan966x: add ethtool configuration and statistics

 .../net/microchip,lan966x-switch.yaml         | 114 ++
 .../bindings/power/lan966x,power.yaml         |  49 +
 .../bindings/reset/lan966x,rst.yaml           |  58 +
 drivers/net/ethernet/microchip/Kconfig        |   1 +
 drivers/net/ethernet/microchip/Makefile       |   1 +
 .../net/ethernet/microchip/lan966x/Kconfig    |   7 +
 .../net/ethernet/microchip/lan966x/Makefile   |   9 +
 .../microchip/lan966x/lan966x_ethtool.c       | 578 ++++++++++
 .../ethernet/microchip/lan966x/lan966x_ifh.h  | 173 +++
 .../ethernet/microchip/lan966x/lan966x_main.c | 994 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h | 192 ++++
 .../microchip/lan966x/lan966x_phylink.c       |  92 ++
 .../ethernet/microchip/lan966x/lan966x_port.c | 301 ++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 704 +++++++++++++
 drivers/net/mdio/mdio-mscc-miim.c             |  14 +-
 drivers/net/phy/micrel.c                      |  73 ++
 drivers/phy/microchip/Kconfig                 |   8 +
 drivers/phy/microchip/Makefile                |   1 +
 drivers/phy/microchip/lan966x_serdes.c        | 525 +++++++++
 drivers/phy/microchip/lan966x_serdes_regs.h   | 482 +++++++++
 drivers/power/reset/Kconfig                   |   6 +
 drivers/power/reset/Makefile                  |   1 +
 drivers/power/reset/lan966x-reset.c           |  90 ++
 drivers/reset/Kconfig                         |   8 +
 drivers/reset/Makefile                        |   1 +
 drivers/reset/reset-lan966x.c                 | 128 +++
 include/dt-bindings/phy/lan966x_serdes.h      |  14 +
 include/linux/micrel_phy.h                    |   1 +
 28 files changed, 4620 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
 create mode 100644 Documentation/devicetree/bindings/power/lan966x,power.yaml
 create mode 100644 Documentation/devicetree/bindings/reset/lan966x,rst.yaml
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Makefile
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_port.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
 create mode 100644 drivers/phy/microchip/lan966x_serdes.c
 create mode 100644 drivers/phy/microchip/lan966x_serdes_regs.h
 create mode 100644 drivers/power/reset/lan966x-reset.c
 create mode 100644 drivers/reset/reset-lan966x.c
 create mode 100644 include/dt-bindings/phy/lan966x_serdes.h

-- 
2.31.1

