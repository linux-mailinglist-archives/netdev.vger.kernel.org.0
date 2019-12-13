Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BCE11E3B6
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 13:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfLMMm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 07:42:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:42696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727052AbfLMMm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 07:42:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C368AB089;
        Fri, 13 Dec 2019 12:42:54 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH v11 net-next 0/2] Use MFD framework for SGI IOC3 drivers
Date:   Fri, 13 Dec 2019 13:42:18 +0100
Message-Id: <20191213124221.25775-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Changes in v11:
 - dropped accepted patches out of the series
 - moved byte swapping patch first in series
 - added ip30 system board support

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

Thomas Bogendoerfer (2):
  MIPS: SGI-IP27: fix readb/writeb addressing
  mfd: ioc3: Add driver for SGI IOC3 chip

 arch/mips/include/asm/mach-ip27/mangle-port.h |   4 +-
 arch/mips/include/asm/sn/ioc3.h               |  38 +-
 arch/mips/sgi-ip27/ip27-timer.c               |  20 -
 drivers/mfd/Kconfig                           |  13 +
 drivers/mfd/Makefile                          |   1 +
 drivers/mfd/ioc3.c                            | 700 ++++++++++++++++++
 drivers/net/ethernet/sgi/Kconfig              |   5 +-
 drivers/net/ethernet/sgi/ioc3-eth.c           | 544 +++-----------
 drivers/rtc/rtc-m48t35.c                      |  11 +
 drivers/tty/serial/8250/8250_ioc3.c           |  98 +++
 drivers/tty/serial/8250/Kconfig               |  11 +
 drivers/tty/serial/8250/Makefile              |   1 +
 12 files changed, 956 insertions(+), 490 deletions(-)
 create mode 100644 drivers/mfd/ioc3.c
 create mode 100644 drivers/tty/serial/8250/8250_ioc3.c

-- 
2.24.0

