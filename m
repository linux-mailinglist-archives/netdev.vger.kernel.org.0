Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A2045F2E7
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhKZRdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:33:06 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:56195 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbhKZRbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 12:31:05 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 6A93F240003;
        Fri, 26 Nov 2021 17:27:48 +0000 (UTC)
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next v3 0/4] Add FDMA support on ocelot switch driver
Date:   Fri, 26 Nov 2021 18:27:35 +0100
Message-Id: <20211126172739.329098-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.1
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
purposes.

------------------
Changes in V3:
  - Add timeouts for hardware registers read
  - Add cleanup path in fdma_init
  - Rework injection and extraction to used ring like structure
  - Added PTP support to FDMA
  - Use pskb_expand_head instead of skb_copy_expand in xmit
  - Drop jumbo support
  - Use of_get_ethdev_address
  - Add ocelot_fdma_netdev_init/deinit

Changes in V2:
  - Read MAC for each port and not as switch base MAC address
  - Add missing static for some functions in ocelot_fdma.c
  - Split change_mtu from fdma commit
  - Add jumbo support for register based xmit
  - Move precomputed header into ocelot_port struct
  - Remove use of QUIRK_ENDIAN_LITTLE due to misconfiguration for tests
  - Remove fragmented packet sending which has not been tested

Clément Léger (4):
  dt-bindings: net: mscc,vsc7514-switch: convert txt bindings to yaml
  net: ocelot: add support to get port mac from device-tree
  net: ocelot: pre-compute injection frame header content
  net: ocelot: add FDMA support

 .../bindings/net/mscc,vsc7514-switch.yaml     | 191 +++++
 .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --
 drivers/net/ethernet/mscc/Makefile            |   1 +
 drivers/net/ethernet/mscc/ocelot.c            |  66 +-
 drivers/net/ethernet/mscc/ocelot.h            |   1 +
 drivers/net/ethernet/mscc/ocelot_fdma.c       | 713 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_fdma.h       |  96 +++
 drivers/net/ethernet/mscc/ocelot_net.c        |  23 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  13 +
 include/soc/mscc/ocelot.h                     |   9 +
 10 files changed, 1087 insertions(+), 109 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.h

-- 
2.33.1

