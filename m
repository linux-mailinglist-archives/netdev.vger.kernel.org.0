Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A558270B99
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbfGVVk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:40:29 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35515 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729004AbfGVVk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so19720293plp.2
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id;
        bh=jvh0CKx8XtfJKzqjThvE2kFc1UemrdOqwfwA9Obr8CI=;
        b=dM0SoCb4nkORqA5Fi8ve5y/P1G0VbmV+a5gjhq+bhMTYGCoazh+Wxlq5jkbqb+rOTk
         EfXs2lMcMhGMnKjj+Xf13H1KAHOe0R3z150csSfdlHaC+wWVnmGg+2kSBAYsVcBYZzys
         CSt/bLuYMcQt1XwIw8D8G7dzULsWX4MEMpCPUeMv8TnqLwzYaq2hI48eVAtIRzcAIuZ7
         4jWiFmSHqW6T3iIKGCX7Z6oXuy2KtptOT1di1oLNgI9Z1dZIY370hGthh0ZH8hlruT/5
         cI6QFWKzyAOLn3YnSscdPU6OaoLD0wzzr7TLF5VD60Pj8Iendq9Y2DaP6BtSNoDkUq1M
         8J8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=jvh0CKx8XtfJKzqjThvE2kFc1UemrdOqwfwA9Obr8CI=;
        b=QBHNUXkGw406A3lPqqkfcPruErtDO0VKhz8g9HXp3Bz6Cd5+CjNvaSTgSlJReFrW8D
         NyHr9RmnRmC8ji15C3HZYcIy4LKa07zuBcPJylKpxcv9lMyKuakho3gAnZMS4HlyQBfI
         OFpNq6Hbyf8DBVSY1edZfumvG31OetSG3g/JYBi/PynOo2hFeVqkHsaTWv8luO+8RbWD
         rk+lhnsUnaEo349HtobAq82hk5AUmpMGZupKYB8ZBGYdRLReyPlor1ihqXl90HXFULRn
         VPObPP1JV12XqPLO4+Kfys5j5D2FTLhDXzoQjkdDy50R6yRKzO3zlo04rUnytNh2JL7g
         DDSQ==
X-Gm-Message-State: APjAAAUvor+enFpDyhN/0W2iNb8M2nXv1PTAuVbW/whWftZxZIah5LOF
        arIqpXj9LOA6uv1fJV7fwVRsuw==
X-Google-Smtp-Source: APXvYqwMyQIZSvFubzkNpVD63wL8KlNzbqDsqlxkE6NDfTK/sF0CV2vLW0/VeAN3q9v+iL2Vrg8VxQ==
X-Received: by 2002:a17:902:a607:: with SMTP id u7mr77813712plq.43.1563831628681;
        Mon, 22 Jul 2019 14:40:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:28 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 00/19] Add ionic driver
Date:   Mon, 22 Jul 2019 14:40:04 -0700
Message-Id: <20190722214023.9513-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patch series that adds the ionic driver, supporting the Pensando
ethernet device.

In this initial patchset we implement basic transmit and receive.  Later
patchsets will add more advanced features.

Our thanks to Andrew Lunn, Michal Kubecek, Jacub Kicinski, Jiri Pirko, and
the ever present kbuild test robots for their comments and suggestions.

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
  ionic: Add basic devlink interface

 .../networking/device_drivers/index.rst       |    1 +
 .../device_drivers/pensando/ionic.rst         |   64 +
 MAINTAINERS                                   |    8 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/pensando/Kconfig         |   32 +
 drivers/net/ethernet/pensando/Makefile        |    6 +
 drivers/net/ethernet/pensando/ionic/Makefile  |    8 +
 drivers/net/ethernet/pensando/ionic/ionic.h   |   74 +
 .../net/ethernet/pensando/ionic/ionic_bus.h   |   16 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  290 ++
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  279 ++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   38 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  535 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  284 ++
 .../ethernet/pensando/ionic/ionic_devlink.c   |   93 +
 .../ethernet/pensando/ionic/ionic_devlink.h   |   14 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  774 +++++
 .../ethernet/pensando/ionic/ionic_ethtool.h   |    9 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 2552 +++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 2262 +++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  270 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  553 ++++
 .../net/ethernet/pensando/ionic/ionic_regs.h  |  133 +
 .../ethernet/pensando/ionic/ionic_rx_filter.c |  143 +
 .../ethernet/pensando/ionic/ionic_rx_filter.h |   35 +
 .../net/ethernet/pensando/ionic/ionic_stats.c |  333 +++
 .../net/ethernet/pensando/ionic/ionic_stats.h |   53 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  879 ++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   15 +
 30 files changed, 9755 insertions(+)
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

