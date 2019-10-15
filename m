Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DD8D75FC
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 14:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbfJOMKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 08:10:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:58160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726540AbfJOMKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 08:10:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F0B0B397;
        Tue, 15 Oct 2019 12:10:01 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH v10 0/6] Use MFD framework for SGI IOC3 drivers
Date:   Tue, 15 Oct 2019 14:09:45 +0200
Message-Id: <20191015120953.2597-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
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

Changes in v10:
 - generation of fake subdevice ID had vendor and device ID swapped

Changes in v9:
 - remove generated MFD devices, when driver is removed or in case
   of a mfd device setup error
 - remove irq domain, if setup of mfd devices failed
 - pci_iounmap on exit/error cases
 - added irq domain unmap function

Changes in v8:
 - Re-worked comments in drivers/mfd/ioc3.c
 - Added select CRC16 to ioc3-eth.c
 - Patches 1 and 2 are already taken to mips-next, but
   for completeness of the series they are still included.
   What's missing to get the remaining 3 patches via the MIPS
   tree is an ack from a network maintainer

Changes in v7:
 - added patch to enable ethernet phy for Origin 200 systems
 - depend on 64bit for ioc3 mfd driver

Changes in v6:
 - dropped patches accepted for v5.4-rc1
 - moved serio patch to ip30 patch series
 - adapted nvmem patch

Changes in v5:
 - requested by Jakub I've splited ioc3 ethernet driver changes into
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

Thomas Bogendoerfer (6):
  nvmem: core: add nvmem_device_find
  MIPS: PCI: use information from 1-wire PROM for IOC3 detection
  MIPS: PCI: Fix fake subdevice ID for IOC3
  mfd: ioc3: Add driver for SGI IOC3 chip
  MIPS: SGI-IP27: fix readb/writeb addressing
  MIPS: SGI-IP27: Enable ethernet phy on second Origin 200 module

 Documentation/driver-api/nvmem.rst            |   2 +
 arch/mips/include/asm/mach-ip27/mangle-port.h |   4 +-
 arch/mips/include/asm/pci/bridge.h            |   1 +
 arch/mips/include/asm/sn/ioc3.h               |  47 +-
 arch/mips/pci/pci-ip27.c                      |  22 +
 arch/mips/pci/pci-xtalk-bridge.c              | 135 +++++-
 arch/mips/sgi-ip27/ip27-timer.c               |  20 -
 arch/mips/sgi-ip27/ip27-xtalk.c               |  38 +-
 drivers/mfd/Kconfig                           |  13 +
 drivers/mfd/Makefile                          |   1 +
 drivers/mfd/ioc3.c                            | 605 ++++++++++++++++++++++++++
 drivers/net/ethernet/sgi/Kconfig              |   5 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           | 561 +++++-------------------
 drivers/nvmem/core.c                          |  61 ++-
 drivers/rtc/rtc-m48t35.c                      |  11 +
 drivers/tty/serial/8250/8250_ioc3.c           |  98 +++++
 drivers/tty/serial/8250/Kconfig               |  11 +
 drivers/tty/serial/8250/Makefile              |   1 +
 include/linux/nvmem-consumer.h                |   9 +
 19 files changed, 1097 insertions(+), 548 deletions(-)
 create mode 100644 drivers/mfd/ioc3.c
 create mode 100644 drivers/tty/serial/8250/8250_ioc3.c

-- 
2.16.4

