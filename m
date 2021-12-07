Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2AB46B6B6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhLGJON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:14:13 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52269 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbhLGJOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:14:12 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id E479BE0012;
        Tue,  7 Dec 2021 09:10:38 +0000 (UTC)
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
Subject: [PATCH net-next v5 0/4] Add FDMA support on ocelot switch driver
Date:   Tue,  7 Dec 2021 10:08:49 +0100
Message-Id: <20211207090853.308328-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the Frame DMA present on the VSC7514
switch. The FDMA is able to extract and inject packets on the various
ethernet interfaces present on the switch.

------------------
Changes in V5:
  - Add skb freeing for TX and fix RX ring skb not being freed
  - Fix napi init in case of netdev registration failure
  - Reorganize FDMA register definitions
  - Used regmap targets from ocelot structure to get fdma pointer
  - s/page_count/page_ref_count
  - Move napi back in struct ocelot_fdma

Changes in V4:
  - Use regmap for register access
  - Removed yaml bindings convertion as well as mac address from dt
  - Removed pre-computed IFH for the moment
  - Fixed timestamp reading for PTP in FDMA
  - Fixed wrong exit path for fdma netdev init
  - Removed spinlock from TX cleanup
  - Add asynchronous RX chan stop before refilling
  - Reduce CH_SAFE wait time to 10us
  - Reduce waiting time for channel to be safe
  - Completely rework rx to use page recycling (code from gianfar)
  - Reenable MTU change support since FDMA now supports it transparently
  - Split TX and RX ring size
  - Larger RX size to lower page allocation rate
  - Add static key to check for FDMA to be enabled in fast path

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
  net: ocelot: export ocelot_ifh_port_set() to setup IFH
  net: ocelot: add and export ocelot_ptp_rx_timestamp()
  net: ocelot: add support for ndo_change_mtu
  net: ocelot: add FDMA support

 drivers/net/ethernet/mscc/Makefile         |   1 +
 drivers/net/ethernet/mscc/ocelot.c         |  59 +-
 drivers/net/ethernet/mscc/ocelot.h         |   3 +
 drivers/net/ethernet/mscc/ocelot_fdma.c    | 886 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_fdma.h    | 166 ++++
 drivers/net/ethernet/mscc/ocelot_net.c     |  39 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  22 +
 include/soc/mscc/ocelot.h                  |   6 +
 8 files changed, 1156 insertions(+), 26 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.h

-- 
2.34.1

