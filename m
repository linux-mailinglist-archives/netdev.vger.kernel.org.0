Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEAB2AD24B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbgKJJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:20:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:51675 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731404AbgKJJUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 04:20:22 -0500
IronPort-SDR: FVvMmgfExPR0vNp+Wt4fg+8YpAAmwEP1cfhivHMfRUU9/M3H+tQG6GTgT6ACEGUnqaWrGx7QPW
 wgUPIZPsYjsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="170096892"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="170096892"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 01:20:00 -0800
IronPort-SDR: c54hT1T5lZ8d7JzCSNSkxwPV5ymv6sI/qspykrPneEmfcgWjSoLM4lV5VwMPaiaOSKSmTpf7lR
 60lPC/4x2EMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="308311814"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 10 Nov 2020 01:19:58 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 3CFC31EA; Tue, 10 Nov 2020 11:19:57 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 00/10] thunderbolt: Add DMA traffic test driver
Date:   Tue, 10 Nov 2020 12:19:47 +0300
Message-Id: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This series adds a new Thunderbolt service driver that can be used on
manufacturing floor to test that each Thunderbolt/USB4 port is functional.
It can be done either using a special loopback dongle that has RX and TX
lanes crossed, or by connecting a cable back to the host (for those who
don't have these dongles).

This takes advantage of the existing XDomain protocol and creates XDomain
devices for the loops back to the host where the DMA traffic test driver
can bind to.

The DMA traffic test driver creates a tunnel through the fabric and then
sends and receives data frames over the tunnel checking for different
errors.

The previous version can be found here:

  https://lore.kernel.org/linux-usb/20201104140030.6853-1-mika.westerberg@linux.intel.com/

Changes from the previous version:

  * Fix resource leak in tb_xdp_handle_request() (patch 2/10)
  * Use debugfs_remove_recursive() in tb_service_debugfs_remove() (patch 6/10)
  * Add tags from Yehezkel

Isaac Hazan (4):
  thunderbolt: Add link_speed and link_width to XDomain
  thunderbolt: Add functions for enabling and disabling lane bonding on XDomain
  thunderbolt: Add DMA traffic test driver
  MAINTAINERS: Add Isaac as maintainer of Thunderbolt DMA traffic test driver

Mika Westerberg (6):
  thunderbolt: Do not clear USB4 router protocol adapter IFC and ISE bits
  thunderbolt: Find XDomain by route instead of UUID
  thunderbolt: Create XDomain devices for loops back to the host
  thunderbolt: Create debugfs directory automatically for services
  thunderbolt: Make it possible to allocate one directional DMA tunnel
  thunderbolt: Add support for end-to-end flow control

 .../ABI/testing/sysfs-bus-thunderbolt         |  28 +
 MAINTAINERS                                   |   6 +
 drivers/net/thunderbolt.c                     |   2 +-
 drivers/thunderbolt/Kconfig                   |  13 +
 drivers/thunderbolt/Makefile                  |   3 +
 drivers/thunderbolt/ctl.c                     |   4 +-
 drivers/thunderbolt/debugfs.c                 |  24 +
 drivers/thunderbolt/dma_test.c                | 736 ++++++++++++++++++
 drivers/thunderbolt/nhi.c                     |  36 +-
 drivers/thunderbolt/path.c                    |  13 +-
 drivers/thunderbolt/switch.c                  |  33 +-
 drivers/thunderbolt/tb.h                      |   8 +
 drivers/thunderbolt/tunnel.c                  |  50 +-
 drivers/thunderbolt/xdomain.c                 | 148 +++-
 include/linux/thunderbolt.h                   |  18 +-
 15 files changed, 1080 insertions(+), 42 deletions(-)
 create mode 100644 drivers/thunderbolt/dma_test.c

-- 
2.28.0

