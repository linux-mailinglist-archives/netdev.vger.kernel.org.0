Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A346A45A42B
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhKWN6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:58:48 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:61026 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhKWN6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:58:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637675739; x=1669211739;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SDj1J2644xrzfk6WUAevIlbr/Wz8DgYG54FJrFRTNDg=;
  b=k/qIVmWW8Jo5Xmm42jzULpPdmANQz/owfYYzsoADuVhpDXw7o7ogb0ZH
   XVqNlSC4yDfFV0dwE9ajU57PxqD4y5bUm91aN7n0T5Gobz7W1BzVpHaDI
   r835B89V+kl775E1rgwNJi2ptXZUyN/+o1H3GEc0ANaode9/aW28Dvsny
   eBcYCJ+ND4FsxQrN7OnGJekdDZWFQ/3CKBXs6ZybLoMP1J2cJ312l/Fic
   dFaPJgd125XvbTZy4O+RpCORLgOtE8ZdQ82qpagXEpP/cW3ok0EJcunQn
   3hZSbum2UYymrcVNgOcBmE+hk4u+ylv61R1wiG1pO8QCsTA4ga3YvOyMr
   w==;
IronPort-SDR: 6arYVt1PNEHhxMBd5GDSFygHpyUnGa3249iNXLsZtfsP8uWuisr4es607mJdjMkBQ2X6shSKfA
 9byUThhYaF13X+GAm/YhqDjnJE/IUruzCDcUgPWn1Y+5NtRhUL9g8Uzf8t30Ewnb3VzQ0Ipzgk
 NC2M1OoPQjCWIqWZ0Yn9ky2/4TeC7nTfPXCtDZ7bAvCSn8tetOq0pC8O+8oAxqC37Q2/lRALo3
 eO6FP2AUZjzLPDhu3nh0Llb9ZKqaOc4Pxy13CshaAucmPU05BZlKg9Ye5orh40tGrPfklYLMXF
 FGJvm081MvqJO7U2Rrg6JmoI
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="137464836"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2021 06:55:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 23 Nov 2021 06:55:39 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 23 Nov 2021 06:55:35 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/6] net: lan966x: Add lan966x switch driver
Date:   Tue, 23 Nov 2021 14:55:11 +0100
Message-ID: <20211123135517.4037557-1-horatiu.vultur@microchip.com>
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

Intially it adds support only for the ports to behave as simple
NIC cards. In the future patches it would be extended with other
functionality like Switchdev, PTP, Frame DMA, VCAP, etc.

v1->v2:
- add new patch for MAINTAINERS
- add functions lan966x_mac_cpu_learn/forget
- fix build issues with second patch
- fix the reset of the switch, return error if there is no reset controller
- start to use phylink_mii_c22_pcs_decode_state and
  phylink_mii_c22_pcs_encode_advertisement do remove duplicate code

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
 .../ethernet/microchip/lan966x/lan966x_main.c | 944 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h | 201 ++++
 .../microchip/lan966x/lan966x_phylink.c       |  96 ++
 .../ethernet/microchip/lan966x/lan966x_port.c | 422 ++++++++
 .../ethernet/microchip/lan966x/lan966x_regs.h | 730 ++++++++++++++
 14 files changed, 3505 insertions(+)
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

