Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE892A65B3
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730278AbgKDOAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:00:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:47942 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730203AbgKDOAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:00:36 -0500
IronPort-SDR: 4FCflTJyn+1mrvkKqqRHq0oWtZ6L8rdEP/bn7/4bLSFhy/57M7iB6agukgPpm7KzOc5NxiidID
 NRxze1CSz/9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="187077836"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="187077836"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 06:00:34 -0800
IronPort-SDR: KNFQ9mLLbNQg7JIRyZggq9tHUHfJQpEtGklvhIRX7LZAMFGG5mUk/WRXjx8XdFvAZY+q9hylfN
 G+UDhatgXmzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="352684825"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 04 Nov 2020 06:00:31 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id D017614B; Wed,  4 Nov 2020 16:00:30 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 00/10] thunderbolt: Add DMA traffic test driver
Date:   Wed,  4 Nov 2020 17:00:20 +0300
Message-Id: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
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
 drivers/thunderbolt/xdomain.c                 | 144 +++-
 include/linux/thunderbolt.h                   |  18 +-
 15 files changed, 1077 insertions(+), 41 deletions(-)
 create mode 100644 drivers/thunderbolt/dma_test.c

-- 
2.28.0

