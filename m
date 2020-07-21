Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073112286EF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgGUROm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:14:42 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:64752 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729967AbgGUROl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:14:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595351681; x=1626887681;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fkusY/rZnoHUUkkCkx7on0e3uqJv5otXccNgfSdW2xg=;
  b=ejmxlAvDm8Cz0FzZgb3N9g5RSwE/5t88WGc+dSihwDp88hpO8ucY+Uhf
   lb4xA/M1BdH+voemaQxWLhvZgwL8mUAPBALgEkAaRWmRey3u47HzgSs8U
   +mYLtlue1oySuflMVcJA/gHMhCRBGP1UKNU2SOqLwA6owEP3isvaNeQCo
   LB8q2s4SDADZdS8KxASOUYf1r0ie6iTxkaFkwyncVSURcgjuzG24Z2cO/
   A0UyMCX73EA+LIgoBjg8nWe1naat5QjdqpAzhNeAoRVQ2ZDFmvrUV/0Vy
   Za+9yMtfGXowpSB/IWOtiYFFjkMnKaHyZkZbqkDTGdtFsnLcwaZ/z07RO
   Q==;
IronPort-SDR: W9KznHSrzhC9ttuaNSxXdfKqAcbuJXO89ByKoBbzXLX4fj4ZWbJ0it0/7IZUuoyvFnnhZBSiP0
 5nhlppiN+uFiiwRGxU/wz1k4g39Iq3MqtDiM2hSkSu0HerguObUv3HmRXvQATqry/AGqTdwsR7
 tD+T8mGt7Ka+R7FRyE4btIZlnh/gUIyueVzfSuogCoSFvdgm1jEa3q12v/eUhhVnp3dWVzx4o3
 s+GPsc9p4/cFLv1kZhqpS1E63CIGfknbH7iZja6REiYs3URENjFCfTCr/uYBFZsWUOjnvh0wjr
 e34=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="84811168"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 10:14:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 10:14:40 -0700
Received: from rob-ult-m19940.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 21 Jul 2020 10:13:46 -0700
From:   Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>
Subject: [PATCH net-next v2 0/7] Add an MDIO sub-node under MACB
Date:   Tue, 21 Jul 2020 20:13:09 +0300
Message-ID: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
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

Changes in v2:
 - renamed patch 2/7 from "macb: bindings doc: use an MDIO node as a
   container for PHY nodes" to "dt-bindings: net: macb: use an MDIO
   node as a container for PHY nodes"
 - added back a newline removed by mistake in patch 3/7

Codrin Ciubotariu (7):
  net: macb: use device-managed devm_mdiobus_alloc()
  dt-bindings: net: macb: use an MDIO node as a container for PHY nodes
  net: macb: parse PHY nodes found under an MDIO node
  ARM: dts: at91: sama5d2: add an mdio sub-node to macb
  ARM: dts: at91: sama5d3: add an mdio sub-node to macb
  ARM: dts: at91: sama5d4: add an mdio sub-node to macb
  ARM: dts: at91: sam9x60: add an mdio sub-node to macb

 Documentation/devicetree/bindings/net/macb.txt | 15 ++++++++++++---
 arch/arm/boot/dts/at91-sam9x60ek.dts           |  8 ++++++--
 arch/arm/boot/dts/at91-sama5d27_som1.dtsi      | 16 ++++++++++------
 arch/arm/boot/dts/at91-sama5d27_wlsom1.dtsi    | 17 ++++++++++-------
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts      | 13 ++++++++-----
 arch/arm/boot/dts/at91-sama5d2_xplained.dts    | 12 ++++++++----
 arch/arm/boot/dts/at91-sama5d3_xplained.dts    | 16 ++++++++++++----
 arch/arm/boot/dts/at91-sama5d4_xplained.dts    | 12 ++++++++----
 drivers/net/ethernet/cadence/macb_main.c       | 18 ++++++++++++------
 9 files changed, 86 insertions(+), 41 deletions(-)

-- 
2.25.1

