Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857051FCE90
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 15:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgFQNgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 09:36:16 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:47973 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgFQNgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 09:36:15 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id D0B9F1BF203;
        Wed, 17 Jun 2020 13:36:08 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net, antoine.tenart@bootlin.com
Subject: [PATCH net-next v2 0/8] net: phy: mscc: PHC and timestamping support
Date:   Wed, 17 Jun 2020 15:31:19 +0200
Message-Id: <20200617133127.628454-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This series aims at adding support for PHC and timestamping operations
in the MSCC PHY driver, for the VSC858x and VSC8575. Those PHYs are
capable of timestamping in 1-step and 2-step for both L2 and L4 traffic.

As of this series, only IPv4 support was implemented when using L4 mode.
This is because of an hardware limitation which prevents us for
supporting both IPv4 and IPv6 at the same time. Implementing support for
IPv6 should be quite easy (I do have the modifications needed for the
hardware configuration) but I did not see a way to retrieve this
information in hwtstamp(). What would you suggest?

Those PHYs are distributed in hardware packages containing multiple
times the PHY. The VSC8584 for example is composed of 4 PHYs. With
hardware packages, parts of the logic is usually common and one of the
PHY has to be used for some parts of the initialization. Following this
logic, the 1588 blocks of those PHYs are shared between two PHYs and
accessing the registers has to be done using the "base" PHY of the
group. This is handled thanks to helpers in the PTP code (and locks).
We also need the MDIO bus lock while performing a single read or write
to the 1588 registers as the read/write are composed of multiple MDIO
transactions (and we don't want other threads updating the page).

To get and set the PHC time, a GPIO has to be used and changes are only
retrieved or committed when on a rising edge. The same GPIO is shared by
all PHYs, so the granularity of the lock protecting it has to be
different from the ones protecting the 1588 registers (the VSC8584 PHY
has 2 1588 blocks, and a single load/save pin).

Patch 1 extends the recently added helpers to share information between
PHYs of the same hardware package; to allow having part of the probe to
be shared (in addition to the already supported init part). This will be
used when adding support for PHC/TS to initialize locks.

Patches 2 and 3 are mostly cosmetic.

Patch 4 takes into account the 1588 block in the MACsec initialization,
to allow having both the MACsec and 1588 blocks initialized on a running
system.

Patches 5 and 6 add support for PHC and timestamping operations in the
MSCC driver. An initialization of the 1588 block (plus all the registers
definition; and helpers) is added first; and then comes a patch to
implement the PHC and timestamping API.

Patches 7 and 8 add the required hardware description for device trees,
to be able to use the load/save GPIO pin on the PCB120 board.

To use this on a PCB120 board, two other series are needed and have
already been sent upstream (one is merged). There are no dependency
between all those series.

Thanks!
Antoine

Since v1:
  - Removed checks in rxtstamp/txtstamp as skb cannot be NULL here.
  - Reworked get_ptp_header_rx/get_ptp_header.
  - Reworked the locking logic between the PHC and timestamping
    operations.
  - Fixed a compilation issue on x86 reported by Jakub.

Antoine Tenart (5):
  net: phy: add support for a common probe between shared PHYs
  net: phy: mscc: fix copyright and author information in MACsec
  net: phy: mscc: take into account the 1588 block in MACsec init
  net: phy: mscc: timestamping and PHC support
  dt-bindings: net: phy: vsc8531: document the load/save GPIO

Quentin Schulz (3):
  net: phy: mscc: remove the TR CLK disable magic value
  net: phy: mscc: 1588 block initialization
  MIPS: dts: ocelot: describe the load/save GPIO

 .../bindings/net/mscc-phy-vsc8531.txt         |    3 +
 arch/mips/boot/dts/mscc/ocelot_pcb120.dts     |   12 +-
 drivers/net/phy/mscc/Makefile                 |    4 +
 drivers/net/phy/mscc/mscc.h                   |   64 +
 drivers/net/phy/mscc/mscc_fc_buffer.h         |    2 +-
 drivers/net/phy/mscc/mscc_mac.h               |    2 +-
 drivers/net/phy/mscc/mscc_macsec.c            |   10 +-
 drivers/net/phy/mscc/mscc_macsec.h            |    2 +-
 drivers/net/phy/mscc/mscc_main.c              |   63 +-
 drivers/net/phy/mscc/mscc_ptp.c               | 1588 +++++++++++++++++
 drivers/net/phy/mscc/mscc_ptp.h               |  477 +++++
 include/linux/phy.h                           |   18 +-
 12 files changed, 2224 insertions(+), 21 deletions(-)
 create mode 100644 drivers/net/phy/mscc/mscc_ptp.c
 create mode 100644 drivers/net/phy/mscc/mscc_ptp.h

-- 
2.26.2

