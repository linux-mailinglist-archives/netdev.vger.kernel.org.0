Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B564F46155E
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhK2Mrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:47:43 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:50652 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbhK2Mpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:45:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638189746; x=1669725746;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2fF2gdhh81H4IXvZ9AxkXM++9a9tO8/Cf6+Jb+mEg24=;
  b=A4jhspbKEq/tSse8nlxHaMsRpwPupNFr38q0kQe/CCPxFtX8gCJdSX7u
   Jl6bN/KaOhC+jY8nj8y4UHITNd484LOKsmWq64slUHw/VHEozg85J+ub5
   O42bXF9YOMMWi0/XbDlAGG+HjNVroLigjWbdr2Ft34FDx5EDsyf9aKyNG
   82fWe1OqBL4ETh+Mpoy1tpH9ZYO2N5jCm3fXx6ywR5tQ7j6fnfHYVWLJ9
   Mh/uSYgji8KQAvrQuTjhDsSdHC1lpftscY6Y5KCJ0uLhPhx3ZOtGj4Yhg
   fwYIPUx1KS02DWL0mosPTI4H/8mnQWK72lNg4IJ5OGGxX73bg3xXXZIJg
   g==;
IronPort-SDR: +dVc8r7rGbqa6u9cAMeqvchDE11Yfcs9/6+P611R9j2gom6Y44jBzpvlnJChFZYo+fsqhrDFik
 QtnQlVwAttNqEEOmfybGQxKcYDu+EaY6yzy31B52QhOJjfD6LNNFGv5wURxV59UKw9q2DzpcV2
 MGzK85NNm2aN0r7+Qz5eOm4pNUNpVi+S6jYV+xZGkaXj/P6Yi6isADlY08pdZqqo73BnB7FuiP
 N1/DpCe3sPxQevhBHXzGCvooUUNfGuKOMwlBP39wdIsyWv6qWKFlIC4VXk/FtR2XKqfvSB23qQ
 68HtwDQo3xATdOsgHaQSlaMs
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="144833693"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2021 05:42:26 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 29 Nov 2021 05:42:24 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 29 Nov 2021 05:42:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 0/6] net: lan966x: Add lan966x switch driver
Date:   Mon, 29 Nov 2021 13:43:53 +0100
Message-ID: <20211129124359.4069432-1-horatiu.vultur@microchip.com>
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

v4->v5:
- more fixes to the reset of the switch, require all resources before
  activating the hardware
- fix to lan966x-switch binding
- implement get/set_pauseparam in ethtool_ops
- stop calling lan966x_port_link_down when calling lan966x_port_pcs_set and
  call it in lan966x_phylink_mac_link_down

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

 .../net/microchip,lan966x-switch.yaml         | 158 +++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/microchip/Kconfig        |   1 +
 drivers/net/ethernet/microchip/Makefile       |   1 +
 .../net/ethernet/microchip/lan966x/Kconfig    |   7 +
 .../net/ethernet/microchip/lan966x/Makefile   |   9 +
 .../microchip/lan966x/lan966x_ethtool.c       | 682 +++++++++++++
 .../ethernet/microchip/lan966x/lan966x_ifh.h  | 173 ++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 101 ++
 .../ethernet/microchip/lan966x/lan966x_main.c | 946 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h | 192 ++++
 .../microchip/lan966x/lan966x_phylink.c       | 127 +++
 .../ethernet/microchip/lan966x/lan966x_port.c | 412 ++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 730 ++++++++++++++
 14 files changed, 3546 insertions(+)
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

