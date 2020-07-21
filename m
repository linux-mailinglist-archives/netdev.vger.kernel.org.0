Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDAC227C67
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgGUKDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:03:37 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:59189 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUKDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 06:03:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595325816; x=1626861816;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5y3M4erh4o4gJ1AXNqxre7Fy7SpM8TICAXCLcUxyKsc=;
  b=t7NLAUNVX/a4F8H7/d3eNAtnBKai9DC5e+0Bu+8D9WP2PISX7moz69JY
   qSLmPHMI0TEMsJbSelsdK7f9PDNs7M7CyEPQEIEppl8+oJjYIEnrIRdU/
   WvxvurT73Zt+kDxIf7BtfPOvE39eGRz64QJDERR9e5XMJjUz4Dis0B1Lw
   niaou7nUrBs1U96LBiAISDjfzxCoJ1jBW2ZaV51MkjmXY3tS9s0cd0u65
   MNRjmIrCIdqWPrfWjOpcqhVy8QnZT8/P/iLLexqUIngN3iQsCJnj0auJb
   YCcN4gf2VQBspCcVqA782L5TA3ocLYIIeiCLgFIuKImFj/FY4Cb2PAAC8
   w==;
IronPort-SDR: RF2hcI+2CPrJIAMlvIW6uHgzNso0kBEUp9dkwPK3HLRF9xj9S4qITBBAeSgve+gI0ZyJQwrsPO
 46loHL0oL+9FizR3Tl6e1wl2cNTD+t77o/LxACX09pYedQpnbnOb7KBORRYkggxLVhwcAT1b+p
 S29k79JLjrIfhLW/1Omp1Owt5AGouSjxdhZmmG06yL/owc5pMysaeREx+NCPvWbdu7kwsHnKqB
 RbF0s+0jYThhG0DJ479e1yNW5CS7ZKH4UIw4VEPqQu2UddNfbWkJ8otaz3qlxFsTEbixqlobKd
 BXs=
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="82644217"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 03:03:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 03:03:34 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 03:02:15 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next 0/7] Add an MDIO sub-node under MACB
Date:   Tue, 21 Jul 2020 13:02:27 +0300
Message-ID: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding the PHY nodes directly under the Ethernet node became deprecated,
so the aim of this patch series is to make MACB use an MDIO node as
container for MDIO devices.
This patch series starts with a small patch to use the device-managed
devm_mdiobus_alloc(). In the next two patches we update the bindings and
adapt macb driver to parse the device-tree PHY nodes from under an MDIO
node. The last patches add the MDIO node in the device-trees of sama5d2,
sama5d3, samad4 and sam9x60 boards.

Codrin Ciubotariu (7):
  net: macb: use device-managed devm_mdiobus_alloc()
  macb: bindings doc: use an MDIO node as a container for PHY nodes
  net: macb: parse PHY nodes found under an MDIO node
  ARM: dts: at91: sama5d2: add an mdio sub-node to macb
  ARM: dts: at91: sama5d3: add an mdio sub-node to macb
  ARM: dts: at91: sama5d4: add an mdio sub-node to macb
  ARM: dts: at91: sam9x60: add an mdio sub-node to macb

 .../devicetree/bindings/net/macb.txt          | 15 ++++++++++++---
 arch/arm/boot/dts/at91-sam9x60ek.dts          |  8 ++++++--
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi     | 16 ++++++++++------
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi   | 17 ++++++++++-------
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts     | 13 ++++++++-----
 arch/arm/boot/dts/at91-sama5d2_xplained.dts   | 12 ++++++++----
 arch/arm/boot/dts/at91-sama5d3_xplained.dts   | 16 ++++++++++++----
 arch/arm/boot/dts/at91-sama5d4_xplained.dts   | 12 ++++++++----
 drivers/net/ethernet/cadence/macb_main.c      | 19 ++++++++++++-------
 9 files changed, 86 insertions(+), 42 deletions(-)

-- 
2.25.1

