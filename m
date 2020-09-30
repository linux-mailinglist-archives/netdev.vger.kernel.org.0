Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D8227F330
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbgI3USZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3USZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:18:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2D6C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 13:18:25 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kNiYQ-0002Qt-6v; Wed, 30 Sep 2020 22:18:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2020-09-30
Date:   Wed, 30 Sep 2020 22:18:03 +0200
Message-Id: <20200930201816.1032054-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

this is a pull request of 13 patches for net-next.

The first 10 target the mcp25xxfd driver (which is renamed to mcp251xfd during
this series).

The first two patches are by Thomas Kopp, which adds reference to the just
related errata and updates the documentation and log messages.

Dan Carpenter's patch fixes a resource leak during ifdown.

A patch by me adds the missing initialization of a variable.

Oleksij Rempel updates the DT binding documentation as requested by Rob
Herring.

The next 5 patches are by Thomas Kopp and me. During review Geert Uytterhoeven
suggested to use "microchip,mcp251xfd" instead of "microchip,mcp25xxfd" as the
DT autodetection compatible to avoid clashes with future but incompatible
devices. We decided not only to rename the compatible but the whole driver from
"mcp25xxfd" to "mcp251xfd". This is done in several patches.

Joakim Zhang contributes three patches for the flexcan driver. The first one
adds support for the ECC feature, which is implemented on some modern IP cores,
by initializing the controller's memory during ifup. The next patch adds
support for the i.MX8MP (which supports ECC) and the last patch properly
disables the runtime PM if device registration fails.

---

The following changes since commit 879456bedbe54f2d38b15c21dc5e3c30232b53e1:

  net: mvneta: avoid possible cache misses in mvneta_rx_swbm (2020-09-29 18:10:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.10-20200930

for you to fetch changes up to 5a9323f55d52c9246ce85f2c9c6a8ec45413b1d0:

  can: flexcan: disable runtime PM if register flexcandev failed (2020-09-30 21:56:58 +0200)

----------------------------------------------------------------
linux-can-next-for-5.10-20200930

----------------------------------------------------------------
Dan Carpenter (1):
      can: mcp25xxfd: mcp25xxfd_ring_free(): fix memory leak during cleanup

Joakim Zhang (3):
      can: flexcan: initialize all flexcan memory for ECC function
      can: flexcan: add flexcan driver for i.MX8MP
      can: flexcan: disable runtime PM if register flexcandev failed

Marc Kleine-Budde (4):
      can: mcp25xxfd: mcp25xxfd_irq(): add missing initialization of variable set_normal mode
      can: mcp251xfd: rename driver files and subdir to mcp251xfd
      can: mcp251xfd: rename all user facing strings to mcp251xfd
      can: mcp251xfd: rename all remaining occurrence to mcp251xfd

Oleksij Rempel (1):
      dt-binding: can: mcp25xxfd: documentation fixes

Thomas Kopp (4):
      can: mcp25xxfd: mcp25xxfd_handle_eccif(): add ECC related errata and update log messages
      can: mcp25xxfd: mcp25xxfd_probe(): add SPI clk limit related errata information
      dt-binding: can: mcp251xfd: narrow down wildcards in device tree bindings to "microchip,mcp251xfd"
      can: mcp25xxfd: narrow down wildcards in device tree bindings to "microchip,mcp251xfd"

 ...hip,mcp25xxfd.yaml => microchip,mcp251xfd.yaml} |   16 +-
 drivers/net/can/flexcan.c                          |   64 +-
 drivers/net/can/spi/Kconfig                        |    2 +-
 drivers/net/can/spi/Makefile                       |    2 +-
 .../net/can/spi/{mcp25xxfd => mcp251xfd}/Kconfig   |   10 +-
 drivers/net/can/spi/mcp251xfd/Makefile             |    8 +
 .../mcp251xfd-core.c}                              | 1386 ++++++++++----------
 .../mcp251xfd-crc16.c}                             |   24 +-
 .../mcp251xfd-regmap.c}                            |  232 ++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |  835 ++++++++++++
 drivers/net/can/spi/mcp25xxfd/Makefile             |    8 -
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h          |  835 ------------
 12 files changed, 1749 insertions(+), 1673 deletions(-)
 rename Documentation/devicetree/bindings/net/can/{microchip,mcp25xxfd.yaml => microchip,mcp251xfd.yaml} (87%)
 rename drivers/net/can/spi/{mcp25xxfd => mcp251xfd}/Kconfig (62%)
 create mode 100644 drivers/net/can/spi/mcp251xfd/Makefile
 rename drivers/net/can/spi/{mcp25xxfd/mcp25xxfd-core.c => mcp251xfd/mcp251xfd-core.c} (54%)
 rename drivers/net/can/spi/{mcp25xxfd/mcp25xxfd-crc16.c => mcp251xfd/mcp251xfd-crc16.c} (81%)
 rename drivers/net/can/spi/{mcp25xxfd/mcp25xxfd-regmap.c => mcp251xfd/mcp251xfd-regmap.c} (60%)
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd.h
 delete mode 100644 drivers/net/can/spi/mcp25xxfd/Makefile
 delete mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h


