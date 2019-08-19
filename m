Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD2949F8
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfHSQcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:32:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:55208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726879AbfHSQcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 310AAAFAE;
        Mon, 19 Aug 2019 16:32:01 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH v5 00/17] Use MFD framework for SGI IOC3 drivers
Date:   Mon, 19 Aug 2019 18:31:23 +0200
Message-Id: <20190819163144.3478-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GI IOC3 ASIC includes support for ethernet, PS2 keyboard/mouse,
NIC (number in a can), GPIO and a byte  bus. By attaching a
SuperIO chip to it, it also supports serial lines and a parallel
port. The chip is used on a variety of SGI systems with different
configurations. This patchset moves code out of the network driver,
which doesn't belong there, into its new place a MFD driver and
specific platform drivers for the different subfunctions.

Changes in v5:
 - requested by Jakub I've splitted ioc3 ethernet driver changes into
   more steps to make the transition more visible; on the way there 
   I've "checkpatched" the driver and reduced code reorderings
 - dropped all uint16_t and uint32_t
 - added nvmem API extension to the documenation file
 - changed to use request_irq/free_irq in serio driver
 - removed wrong kfree() in serio error path

Changes in v4:
 - added w1 drivers to the series after merge in 5.3 failed because
   of no response from maintainer and other parts of this series
   won't work without that drivers
 - moved ip30 systemboard support to the ip30 series, which will
   deal with rtc oddity Lee found
 - converted to use devm_platform_ioremap_resource
 - use PLATFORM_DEVID_AUTO for serial, ethernet and serio in mfd driver
 - fixed reverse christmas order in ioc3-eth.c
 - formating issue found by Lee
 - re-worked irq request/free in serio driver to avoid crashes during
   probe/remove

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

Thomas Bogendoerfer (17):
  w1: add 1-wire master driver for IP block found in SGI ASICs
  w1: add DS2501, DS2502, DS2505 EPROM device driver
  nvmem: core: add nvmem_device_find
  MIPS: PCI: refactor ioc3 special handling
  MIPS: PCI: use information from 1-wire PROM for IOC3 detection
  MIPS: SGI-IP27: remove ioc3 ethernet init
  MIPS: SGI-IP27: restructure ioc3 register access
  net: sgi: ioc3-eth: remove checkpatch errors/warning
  net: sgi: ioc3-eth: use defines for constants dealing with desc rings
  net: sgi: ioc3-eth: rework skb rx handling
  net: sgi: ioc3-eth: no need to stop queue set_multicast_list
  net: sgi: ioc3-eth: use dma-direct for dma allocations
  net: sgi: ioc3-eth: use csum_fold
  net: sgi: ioc3-eth: Fix IPG settings
  mfd: ioc3: Add driver for SGI IOC3 chip
  MIPS: SGI-IP27: fix readb/writeb addressing
  Input: add IOC3 serio driver

 Documentation/driver-api/nvmem.rst            |    2 +
 arch/mips/include/asm/mach-ip27/mangle-port.h |    4 +-
 arch/mips/include/asm/pci/bridge.h            |    1 +
 arch/mips/include/asm/sn/ioc3.h               |  364 +++----
 arch/mips/pci/pci-xtalk-bridge.c              |  296 ++++--
 arch/mips/sgi-ip27/ip27-console.c             |    5 +-
 arch/mips/sgi-ip27/ip27-init.c                |   13 -
 arch/mips/sgi-ip27/ip27-timer.c               |   20 -
 arch/mips/sgi-ip27/ip27-xtalk.c               |   38 +-
 drivers/input/serio/Kconfig                   |   10 +
 drivers/input/serio/Makefile                  |    1 +
 drivers/input/serio/ioc3kbd.c                 |  160 +++
 drivers/mfd/Kconfig                           |   13 +
 drivers/mfd/Makefile                          |    1 +
 drivers/mfd/ioc3.c                            |  586 +++++++++++
 drivers/net/ethernet/sgi/Kconfig              |    4 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           | 1405 +++++++++----------------
 drivers/nvmem/core.c                          |   62 +-
 drivers/rtc/rtc-m48t35.c                      |   11 +
 drivers/tty/serial/8250/8250_ioc3.c           |   98 ++
 drivers/tty/serial/8250/Kconfig               |   11 +
 drivers/tty/serial/8250/Makefile              |    1 +
 drivers/w1/masters/Kconfig                    |    9 +
 drivers/w1/masters/Makefile                   |    1 +
 drivers/w1/masters/sgi_w1.c                   |  130 +++
 drivers/w1/slaves/Kconfig                     |    6 +
 drivers/w1/slaves/Makefile                    |    1 +
 drivers/w1/slaves/w1_ds250x.c                 |  293 ++++++
 include/linux/nvmem-consumer.h                |    9 +
 include/linux/platform_data/sgi-w1.h          |   15 +
 include/linux/w1.h                            |    2 +
 31 files changed, 2266 insertions(+), 1306 deletions(-)
 create mode 100644 drivers/input/serio/ioc3kbd.c
 create mode 100644 drivers/mfd/ioc3.c
 create mode 100644 drivers/tty/serial/8250/8250_ioc3.c
 create mode 100644 drivers/w1/masters/sgi_w1.c
 create mode 100644 drivers/w1/slaves/w1_ds250x.c
 create mode 100644 include/linux/platform_data/sgi-w1.h

-- 
2.13.7

