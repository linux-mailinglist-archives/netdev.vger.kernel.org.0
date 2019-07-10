Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A1762972
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 21:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404078AbfGHTZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 15:25:40 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:42327 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729229AbfGHTZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 15:25:39 -0400
Received: by mail-pl1-f180.google.com with SMTP id ay6so8767475plb.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 12:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id;
        bh=1dP/zwhmzMB9vkMBfGquwVdLp++VSGlpX32AFkHYz48=;
        b=fy/OJcEov6KmuTCeUkNt+4j5REVETiYHmDy7ceAls2WoPmJqReshXyt6lnCjhPJw2i
         K2+hkfgrlS5PZ1AQ8lzLFt1ux4/IfQz5icusGeis3dT2iktzQ4p115FadH/m5vUVrt2H
         ncjgFPmE4vl/2ZtgZd8qB2fPyIjkY7dajpvy8w2TY8dAWBCBgfKAwOg/a/CFxkz5gnoN
         UmYPifXxng8aSd2UwvH3ChR4qGEdqZi9B9NUmxRAVKSGi1XDsRkLJ/qvxzyv6hCa2FMC
         h48U0Hpt1jJu35bQyuRHf7ffLALTLhqJ72W2GzgRep7/sfW/1xDIyjpL+gIEAYaApI7h
         ubGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=1dP/zwhmzMB9vkMBfGquwVdLp++VSGlpX32AFkHYz48=;
        b=mGbzkp05ljqguHJ18suQ1Q3RZjaMhJvCYQC+Z8aFF5ZksFZN2bg9tzXOBtozzyNL8I
         6OIqZ5V9z6fwonJDE5njqwkzpcsLya2UIHM3pNnr+O/NWup+QzcRBtVWa2hxKT33oUEf
         9ISUVgVs8ALvNiY6hXBgGVcesYqmPoPlCVmcXuxHrp6e5J/Bd+Fmkgq7cphO748td4+r
         000uvs4nzFj/UP+ZJcyKCP/iygUEJ0xiBuYMv97tA5aBrhaXEzLwpGc2BYqxy1QPfVN2
         Cg2LMczZbyOjLfOeje1Gmgl6Ch0aw1rpNSpeut/TXFMdMv4MkuHeoNnYu45cDie3BA0A
         OcUA==
X-Gm-Message-State: APjAAAXdW4WbcDYVQhRChclPP7N2zduuio0GTuOW21OzlNhLre2JzHBh
        0o3EjZUNwFb0pcgaAaCutW0YwfkZKrU=
X-Google-Smtp-Source: APXvYqz0TaGSgbh9hHYK84umdVUxRozbZgUpiA8HEEN09VI3sdyUQxmqhaCnzCXjKH5Jglw+ufA9Dg==
X-Received: by 2002:a17:902:ba98:: with SMTP id k24mr21013651pls.294.1562613938099;
        Mon, 08 Jul 2019 12:25:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id n19sm20006770pfa.11.2019.07.08.12.25.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 12:25:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 00/19] Add ionic driver
Date:   Mon,  8 Jul 2019 12:25:13 -0700
Message-Id: <20190708192532.27420-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patch series that adds the ionic driver, supporting the Pensando
ethernet device.

In this initial patchset we implement basic transmit and receive.  Later
patchsets will add more advanced features.

Our thanks to Andrew Lunn, Michal Kubecek, Jacub Kicinski, and the ever
present kbuild test robots for their comments and suggestions.

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
 drivers/net/ethernet/pensando/ionic/ionic.h   |   72 +
 .../net/ethernet/pensando/ionic/ionic_bus.h   |   16 +
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  291 ++
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  283 ++
 .../ethernet/pensando/ionic/ionic_debugfs.h   |   38 +
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  535 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  284 ++
 .../ethernet/pensando/ionic/ionic_devlink.c   |   89 +
 .../ethernet/pensando/ionic/ionic_devlink.h   |   12 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  788 +++++
 .../ethernet/pensando/ionic/ionic_ethtool.h   |    9 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 2552 +++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 2262 +++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  270 ++
 .../net/ethernet/pensando/ionic/ionic_main.c  |  553 ++++
 .../net/ethernet/pensando/ionic/ionic_regs.h  |  133 +
 .../ethernet/pensando/ionic/ionic_rx_filter.c |  142 +
 .../ethernet/pensando/ionic/ionic_rx_filter.h |   34 +
 .../net/ethernet/pensando/ionic/ionic_stats.c |  333 +++
 .../net/ethernet/pensando/ionic/ionic_stats.h |   53 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  879 ++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   15 +
 30 files changed, 9764 insertions(+)
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

