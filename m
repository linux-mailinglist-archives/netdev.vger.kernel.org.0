Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F10844872
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393456AbfFMRG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:06:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:52056 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393384AbfFMRG5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 13:06:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7BB62ADCB;
        Thu, 13 Jun 2019 17:06:55 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH v3 0/7] Use MFD framework for SGI IOC3 drivers
Date:   Thu, 13 Jun 2019 19:06:26 +0200
Message-Id: <20190613170636.6647-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGI IOC3 ASIC includes support for ethernet, PS2 keyboard/mouse,
NIC (number in a can), GPIO and a byte  bus. By attaching a
SuperIO chip to it, it also supports serial lines and a parallel
port. The chip is used on a variety of SGI systems with different
configurations. This patchset moves code out of the network driver,
which doesn't belong there, into its new place a MFD driver and
specific platform drivers for the different subfunctions.

Changes in v3:
 - use 1-wire subsystem for handling proms
 - pci-xtalk driver uses prom information to create PCI subsystem
   ids for use in MFD driver
 - changed MFD driver to only use static declared mfd_cells
 - added IP30 system board setup to MFD driver
 - mac address is now read from ioc3-eth driver with nvmem framework 

Changes in v2:
 - fixed issue in ioc3kbd.c reported by Dmitry Torokhov
 - merged IP27 RTC removal and 8250 serial driver addition into
   main MFD patch to keep patches bisectable

Thomas Bogendoerfer (7):
  nvmem: core: add nvmem_device_find
  MIPS: PCI: refactor ioc3 special handling
  MIPS: PCI: use information from 1-wire PROM for IOC3 detection
  MIPS: SGI-IP27: remove ioc3 ethernet init
  mfd: ioc3: Add driver for SGI IOC3 chip
  MIPS: SGI-IP27: fix readb/writeb addressing
  Input: add IOC3 serio driver

 arch/mips/include/asm/mach-ip27/mangle-port.h |    4 +-
 arch/mips/include/asm/pci/bridge.h            |    1 +
 arch/mips/include/asm/sn/ioc3.h               |  356 ++---
 arch/mips/pci/pci-xtalk-bridge.c              |  296 ++--
 arch/mips/sgi-ip27/ip27-console.c             |    5 +-
 arch/mips/sgi-ip27/ip27-init.c                |   13 -
 arch/mips/sgi-ip27/ip27-timer.c               |   20 -
 arch/mips/sgi-ip27/ip27-xtalk.c               |   38 +-
 drivers/input/serio/Kconfig                   |   10 +
 drivers/input/serio/Makefile                  |    1 +
 drivers/input/serio/ioc3kbd.c                 |  158 ++
 drivers/mfd/Kconfig                           |   13 +
 drivers/mfd/Makefile                          |    1 +
 drivers/mfd/ioc3.c                            |  683 +++++++++
 drivers/net/ethernet/sgi/Kconfig              |    4 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           | 1932 ++++++++++---------------
 drivers/nvmem/core.c                          |   62 +-
 drivers/rtc/rtc-m48t35.c                      |   11 +
 drivers/tty/serial/8250/8250_ioc3.c           |   98 ++
 drivers/tty/serial/8250/Kconfig               |   11 +
 drivers/tty/serial/8250/Makefile              |    1 +
 include/linux/nvmem-consumer.h                |    9 +
 22 files changed, 2152 insertions(+), 1575 deletions(-)
 create mode 100644 drivers/input/serio/ioc3kbd.c
 create mode 100644 drivers/mfd/ioc3.c
 create mode 100644 drivers/tty/serial/8250/8250_ioc3.c

-- 
2.13.7

