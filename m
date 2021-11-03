Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBCE443F40
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhKCJXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:23:04 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:42891 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhKCJXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:23:03 -0400
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 2E443100008;
        Wed,  3 Nov 2021 09:20:23 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH v2 0/6] Add FDMA support on ocelot switch driver
Date:   Wed,  3 Nov 2021 10:19:37 +0100
Message-Id: <20211103091943.3878621-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the Frame DMA present on the VSC7514
switch. The FDMA is able to extract and inject packets on the various
ethernet interfaces present on the switch.

While adding FDMA support, bindings were switched from .txt to .yaml
and MAC address reading from device-tree was added for testing
purposes. Jumbo frame support was also added since it gives a large
performance improvement with FDMA.

------------------
Changes in V2:
- Read MAC for each port and not as switch base MAC address
- Add missing static for some functions in ocelot_fdma.c
- Split change_mtu from fdma commit
- Add jumbo support for register based xmit
- Move precomputed header into ocelot_port struct
- Remove use of QUIRK_ENDIAN_LITTLE due to misconfiguration for tests
- Remove fragmented packet sending which has not been tested

Clément Léger (6):
  net: ocelot: add support to get port mac from device-tree
  dt-bindings: net: convert mscc,vsc7514-switch bindings to yaml
  net: ocelot: pre-compute injection frame header content
  net: ocelot: add support for ndo_change_mtu
  net: ocelot: add FDMA support
  net: ocelot: add jumbo frame support for FDMA

 .../bindings/net/mscc,vsc7514-switch.yaml     | 184 +++++
 .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --
 drivers/net/ethernet/mscc/Makefile            |   1 +
 drivers/net/ethernet/mscc/ocelot.c            |  23 +-
 drivers/net/ethernet/mscc/ocelot.h            |   3 +
 drivers/net/ethernet/mscc/ocelot_fdma.c       | 754 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_fdma.h       |  60 ++
 drivers/net/ethernet/mscc/ocelot_net.c        |  37 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  15 +
 include/soc/mscc/ocelot.h                     |   7 +
 10 files changed, 1075 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.h

-- 
2.33.0

