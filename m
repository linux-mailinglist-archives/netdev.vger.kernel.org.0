Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8139AA252A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbfH2S1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:27:53 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:45059 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfH2S1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:27:49 -0400
Received: by mail-pl1-f170.google.com with SMTP id y8so1956410plr.12
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id;
        bh=YuC2vJNQHNDscH1t/IJxIH5aXzY7r8rAs+/tb1QP95Y=;
        b=qptAWJKW2zgpgNmheHakS++z1GbJPGZW6Kv5ZJouOF+A3T6zIN1N8a3QRiXblBf0ps
         By7fQaSsmSgLcuR5C4w1Yg+5Kzzy//MWJapfgvZcmvWHNwKT/5m5GXA+WX6A5VWofZIH
         IVwHKtOyxVxFuQDopMJvYUeOqBM5LD7EYKxnxmjHjDy7kmtcmvV9kwY1J6dhgcpPZ21r
         LvFFbFUwMYgDFmmw0t6vBKWhpeoEj9/RsSftAoXLi6yAIx7fRJnBglNnMcnzTqOOp81q
         n293PZHuivpwkTqG77owd4qFOeiIMOSuxr1rklUrDFDzY7oXGbts2WJ+UfHlhHFsnYzL
         SplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=YuC2vJNQHNDscH1t/IJxIH5aXzY7r8rAs+/tb1QP95Y=;
        b=ZfEVpglGfTWyXq4YSDiYntjVfkl2reTwV4FlplnSHS+Jmo8z/ra2vvUltQwqlYOwKu
         UK5/5bnK0Uc7oC1K0IMoRjeMhfO34JF3XOZYWYFwKZj4dQhgsm+noOgPnh3wbtYIH+zM
         PhVnkKbjgJotQ70tQ0blXvR89GAc01J5wsLv3EIFYfpI0CkPQMHftTYwi26bSNENrsZz
         aUu2yzsOFUJgEYz1MOjK3sfLsrhvPUZOPzQo6CU5Hib0d232pUmFsF5DQl5Tm8nveueX
         l0LdZSHxl/RUrQ/5I3ELRqoJijk3fSKLYr80JkPFdjUk60ADSWfGf81aVQQI9b0vpYY2
         /dTw==
X-Gm-Message-State: APjAAAWDvk0HLcqNRxHD4oIJwWxnpCTuSmjHNuYO3hYYpZMMAqfnMV/w
        IasGpM5S2GItb0W/sC9M5azZMMZpcG0=
X-Google-Smtp-Source: APXvYqxgune5dikFXW9vXgAmu/MxdUgo4OC9c42OdVpZcuab7fhfxo8w1+SHtR/0LqdlIk08AH0iAQ==
X-Received: by 2002:a17:902:e9:: with SMTP id a96mr11691011pla.169.1567103268941;
        Thu, 29 Aug 2019 11:27:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.27.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:27:48 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v6 net-next 00/19] ionic: Add ionic driver
Date:   Thu, 29 Aug 2019 11:27:01 -0700
Message-Id: <20190829182720.68419-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patch series that adds the ionic driver, supporting the Pensando
ethernet device.

In this initial patchset we implement basic transmit and receive.  Later
patchsets will add more advanced features.

Our thanks to Saeed Mahameed, David Miller, Andrew Lunn, Michal Kubecek,
Jacub Kicinski, Jiri Pirko, Yunsheng Lin, and the ever present kbuild
test robots for their comments and suggestions.

New in v6:
 - added a new patch with devlink info tags for ASIC and general FW
 - use the new devlink info tags in the driver
 - fixed up TxRx cleanup on setup failure
 - allow for possible 0 address from dma mapping of Tx buffers
 - remove a few more unnecessary debugfs error checks
 - use innocuous hardcoded strings in the identify message
 - removed a couple of unused functions and definitions
 - fix a leak in the error handling of port_info setup
 - changed from BUILD_BUG_ON() to static_assert()

New in v5:
 - code reorganized for more sane layout, with a side benefit of getting
   rid of a "defined but not used" complaint after patch 5
 - added "ionic_" prefix to struct definitions and fixed up remaining
   reverse christmas tree formatting (I think I got them all...)
 - ndo_open and ndo_stop reworked for better error recovery
 - interrupt coalescing enabled at driver start
 - unnecessary log messaging removed from events
 - double copy added in the module prom read to assure a clean copy
 - added BQL counting
 - fixed a TSO unmap issue found in testing
 - generalize a bit-flag wait with timeout
 - added devlink into earlier code and dropped patch 19

New in v4:
 - use devlink struct alloc for ionic device specific struct
 - add support for devlink_port
 - fixup devlink fixed vs running version usage
 - use bitmap_copy() instead of memcpy() for link_ksettings
 - don't bother to zero out the advertising bits before copying
   in the support bits
 - drop unknown xcvr types (will be expanded on later)
 - flap the connection to force auto-negotiation
 - use is_power_of_2() rather than open code
 - simplify set/get_pauseparam use of pause->autoneg
 - add a couple comments about NIC status data updated in DMA spaces

New in v3:
 - use le32_to_cpu() on queue_count[] values in debugfs
 - dma_free_coherent() can handle NULL pointers
 - remove unused SS_TEST from ethtool handlers
 - one more case of stop the tx ring if there is no room
 - remove a couple of stray // comments

New in v2:
 - removed debugfs error checking and cut down on debugfs use
 - remove redundant bounds checking on incoming values for mtu and ethtool
 - don't alloc rx_filter memory until the match type has been checked
 - free the ionic struct on remove
 - simplified link_up and netif_carrier_ok comparison
 - put stats into ethtool -S, out of debugfs
 - moved dev_cmd and dev_info dumping to ethtool -d, out of debugfs
 - added devlink support
 - used kernel's rss init routines rather than open code
 - set the Kbuild dependant on 64BIT
 - cut down on some unnecessary log messaging
 - cleaned up ionic_get_link_ksettings
 - cleaned up other little code bits here and there

Shannon Nelson (19):
  devlink: Add new info version tags for ASIC and FW
  ionic: Add basic framework for IONIC Network device driver
  ionic: Add hardware init and device commands
  ionic: Add port management commands
  ionic: Add basic lif support
  ionic: Add interrupts and doorbells
  ionic: Add basic adminq support
  ionic: Add adminq action
  ionic: Add notifyq support
  ionic: Add the basic NDO callbacks for netdev support
  ionic: Add management of rx filters
  ionic: Add Rx filter and rx_mode ndo support
  ionic: Add async link status check and basic stats
  ionic: Add initial ethtool support
  ionic: Add Tx and Rx handling
  ionic: Add netdev-event handling
  ionic: Add driver stats
  ionic: Add RSS support
  ionic: Add coalesce and other features

 .../networking/device_drivers/index.rst       |    1 +
 .../device_drivers/pensando/ionic.rst         |   43 +
 .../networking/devlink-info-versions.rst      |   16 +
 MAINTAINERS                                   |    8 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/pensando/Kconfig         |   32 +
 drivers/net/ethernet/pensando/Makefile        |    6 +
 drivers/net/ethernet/pensando/ionic/Makefile  |    8 +
 drivers/net/ethernet/pensando/ionic/ionic.h   |   73 +
 .../net/ethernet/pensando/ionic/ionic_bus.h   |   16 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  292 ++
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  248 ++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   34 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  500 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  299 ++
 .../ethernet/pensando/ionic/ionic_devlink.c   |   96 +
 .../ethernet/pensando/ionic/ionic_devlink.h   |   14 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  776 ++++++
 .../ethernet/pensando/ionic/ionic_ethtool.h   |    9 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 2482 +++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 2266 +++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  277 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  561 ++++
 .../net/ethernet/pensando/ionic/ionic_regs.h  |  136 +
 .../ethernet/pensando/ionic/ionic_rx_filter.c |  150 +
 .../ethernet/pensando/ionic/ionic_rx_filter.h |   35 +
 .../net/ethernet/pensando/ionic/ionic_stats.c |  334 +++
 .../net/ethernet/pensando/ionic/ionic_stats.h |   53 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  912 ++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   15 +
 include/net/devlink.h                         |    7 +
 32 files changed, 9701 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/pensando/ionic.rst
 create mode 100644 drivers/net/ethernet/pensando/Kconfig
 create mode 100644 drivers/net/ethernet/pensando/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/Makefile
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_debugfs.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_dev.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_dev.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_devlink.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_if.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_lif.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_main.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_regs.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_txrx.h

-- 
2.17.1

