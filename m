Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237B245E9E3
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352952AbhKZJJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:09:10 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53174 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347145AbhKZJHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 04:07:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637917437; x=1669453437;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O/6XrJZtcVcad5cHhAaI4qG7APwHS8CpdiHVHyLILXU=;
  b=QTDNg9jqwodIb8PigE6gkT9HkdfUnFipTThMOmlOE7XRJV9dPhJrWONo
   yrSfv0seL3R4cz/cTtuzisbBlSau26OTLTxPsp12YA7aUpH18X8BMRFCK
   B9ctVTzEIlRU42iO5TtL7vQwlqGNxDNTDv3D1I0yGIuaaWckDy56HRRYV
   z0ZkOKRwWdopaRfOzUeI12ASGBTRBARY1MPIzGIewUAY8WdgPjqXVGC+F
   NPRzUW0izazNtWBgzZ4Y5nEsvTznvgCV7dyKHN2BspoXVtf1EqVBTmZc3
   X82D/dCM0+hphVCdIYFdIJJ++nmaeoSupkXUXtY73LW40iFOtouvD8n90
   A==;
IronPort-SDR: UsxKfNTFIpcktP5cQRZCXWJw19QFVTpfMwNBvQOeOkYG+EWa2V4n2L8XLQ9zBGMMNh+HmOZ1AF
 KC+v0LPpOgR4dhVax6esbTm2iI8Q0AicfaAJanPtlfCpbZwSIWrL4tQsS6XKFYf4zAiUUebTXC
 SseJz00blFQoln0JBbjrXa0D25+p+wnipTYORZvrp4ECt551Yaw/OLhReKOgj0yeiwbWN52i1x
 AAt/fcaAdx3MapBJ/v9LX1D3jzRgsWGHplK2X/Rhh+eoEOSaMa7a/LaQXbbNlYC2Squ7ZI6rHZ
 54YTzpyZ/QFNF3QjveM57/ac
X-IronPort-AV: E=Sophos;i="5.87,265,1631602800"; 
   d="scan'208";a="77659845"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Nov 2021 02:03:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 26 Nov 2021 02:03:55 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 26 Nov 2021 02:03:53 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 0/6] net: lan966x: Add lan966x switch driver
Date:   Fri, 26 Nov 2021 10:05:34 +0100
Message-ID: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add support for Microchip lan966x driver

The lan966x switch is a multi-port Gigabit AVB/TSN Ethernet Switch with
two integrated 10/100/1000Base-T PHYs. In addition to the integrated PHYs,
it supports up to 2RGMII/RMII, up to 3BASE-X/SERDES/2.5GBASE-X and up to
2 Quad-SGMII/Quad-USGMII interfaces.

Initially it adds support only for the ports to behave as simple
NIC cards. In the future patches it would be extended with other
functionality like Switchdev, PTP, Frame DMA, VCAP, etc.

v3->v4:
- add timeouts when injecting/extracting frames, in case the HW breaks
- simplify the creation of the IFH
- fix the order of operations in lan966x_cleanup_ports
- fixes to phylink based on Russel review

v2->v3:
- fix compiling issues for x86
- fix resource management in first patch

v1->v2:
- add new patch for MAINTAINERS
- add functions lan966x_mac_cpu_learn/forget
- fix build issues with second patch
- fix the reset of the switch, return error if there is no reset controller
- start to use phylink_mii_c22_pcs_decode_state and
  phylink_mii_c22_pcs_encode_advertisement to remove duplicate code

Horatiu Vultur (6):
  dt-bindings: net: lan966x: Add lan966x-switch bindings
  net: lan966x: add the basic lan966x driver
  net: lan966x: add port module support
  net: lan966x: add mactable support
  net: lan966x: add ethtool configuration and statistics
  net: lan966x: Update MAINTAINERS to include lan966x driver

 .../net/microchip,lan966x-switch.yaml         | 149 +++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/microchip/Kconfig        |   1 +
 drivers/net/ethernet/microchip/Makefile       |   1 +
 .../net/ethernet/microchip/lan966x/Kconfig    |   7 +
 .../net/ethernet/microchip/lan966x/Makefile   |   9 +
 .../microchip/lan966x/lan966x_ethtool.c       | 664 ++++++++++++
 .../ethernet/microchip/lan966x/lan966x_ifh.h  | 173 ++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 101 ++
 .../ethernet/microchip/lan966x/lan966x_main.c | 945 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h | 192 ++++
 .../microchip/lan966x/lan966x_phylink.c       | 116 +++
 .../ethernet/microchip/lan966x/lan966x_port.c | 422 ++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 730 ++++++++++++++
 14 files changed, 3517 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Makefile
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_port.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_regs.h

-- 
2.33.0

