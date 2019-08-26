Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5689D9D87A
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbfHZVdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:33:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34331 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfHZVdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:33:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id b24so12663260pfp.1
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id;
        bh=e/6EI/63tm5Z1sEhzwvi8onb/Z+a6O/RQIZ2QZP7gPk=;
        b=LeQWe4ZfDGbKlxSHTAQ6vDusVRJKSoZSwYZxzojb9WE5KdjHfOFq3ADK92lbXjHCEh
         BdpwAMGKlYow2o4HzO7l7P/Q7fZJi7MNpUqnljnvsOBzywGbbhUZwYteCseqHtsFEG3c
         Bk0FXdhoHkPatSuwOTsvbF63vwplbDdHBJ96cl+1wVfSVCPPaJoRkNe28Vmy/aDETymt
         eyesTq3S27WJg9fSZsFZHvPo+WHABhP022yPfOy7LqPDqs4Ul2rCvfn2b/Oe4A4Ciexu
         I/nt0GzwOBWh0LPfFqAPwOjiiI3kLKocepVOcZI3oydeXNq3K3Y2ByrhX/lY3ESUP+FV
         r6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=e/6EI/63tm5Z1sEhzwvi8onb/Z+a6O/RQIZ2QZP7gPk=;
        b=bDpZEE9oGf/1qmWl/sR/zy/J7BHx6QsTDsovBnezWa0kuKjPUIaFv3SeBbd3L0xYsN
         AZKJRi8Xk6UDujR6NQNG0VvF08cv4wnPebABJ77hYrFPhmgmvMSAYAQT7NT199DcjLFK
         0X9uGwyZatD7dSZPUXOl3bFJPgy7uFyvNkZlhTeae4vJl2G6p6J5gWoZx/8s93j0i0hh
         JQxgtc/YtJMnlNBjg3ZdGypgRGZpp14EjPy5mFFLfdHiX5Xwm3HnSLVPG5fT9Nf2DuQH
         WQxG6pR5um4tLb3bxi4JF2vj7fcbhK4u3NbzYvJwzrnkYoWyJalQ7K/R91PFABMEoXVL
         YTXw==
X-Gm-Message-State: APjAAAVAuogWs1On0iT6T9+PxGDLcJ4Nb5tOu6VUh5E1Y9793nvnYiHj
        dg5dAaekRT2qoDEyeXKgWvgqhg==
X-Google-Smtp-Source: APXvYqyYnxEhZSPwDF/ZGhKEupvrZ9TOh8XVsf1jOcO4ay6JVD9Q2wLBwx6h8n9/9hbwsd3Wdaz61A==
X-Received: by 2002:aa7:8108:: with SMTP id b8mr6150901pfi.197.1566855228719;
        Mon, 26 Aug 2019 14:33:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.33.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:33:48 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 00/18] ionic: Add ionic driver
Date:   Mon, 26 Aug 2019 14:33:21 -0700
Message-Id: <20190826213339.56909-1-snelson@pensando.io>
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
Jacub Kicinski, Jiri Pirko, and the ever present kbuild test robots for
their comments and suggestions.

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

Shannon Nelson (18):
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
 MAINTAINERS                                   |    8 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/pensando/Kconfig         |   32 +
 drivers/net/ethernet/pensando/Makefile        |    6 +
 drivers/net/ethernet/pensando/ionic/Makefile  |    8 +
 drivers/net/ethernet/pensando/ionic/ionic.h   |   74 +
 .../net/ethernet/pensando/ionic/ionic_bus.h   |   16 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  292 ++
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  269 ++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   34 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  524 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  306 ++
 .../ethernet/pensando/ionic/ionic_devlink.c   |   95 +
 .../ethernet/pensando/ionic/ionic_devlink.h   |   14 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  780 ++++++
 .../ethernet/pensando/ionic/ionic_ethtool.h   |    9 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 2482 +++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 2266 +++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  302 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  554 ++++
 .../net/ethernet/pensando/ionic/ionic_regs.h  |  136 +
 .../ethernet/pensando/ionic/ionic_rx_filter.c |  150 +
 .../ethernet/pensando/ionic/ionic_rx_filter.h |   35 +
 .../net/ethernet/pensando/ionic/ionic_stats.c |  334 +++
 .../net/ethernet/pensando/ionic/ionic_stats.h |   53 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  894 ++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   15 +
 30 files changed, 9734 insertions(+)
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

