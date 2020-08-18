Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C557B248AC9
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgHRPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:47:06 -0400
Received: from mga05.intel.com ([192.55.52.43]:61047 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgHRPqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 11:46:39 -0400
IronPort-SDR: o7Jx+xhYr0uzkGnBRktiGla2EL5K9RZYZlohq3y5tFrLwbPp79eN6c9UgJ8z+pcni0qvKLRWK2
 GPMH9qAr52pQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="239764578"
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="239764578"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 08:46:38 -0700
IronPort-SDR: bXhhCgaI4SpGafK6goF4Iy0xecS55diLmCWD2TpOYA2OMaSe8hh8Pniz6ZhcS2vFBU3gaMZDNK
 g5qMnM9sw9oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,327,1592895600"; 
   d="scan'208";a="400530163"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by fmsmga001.fm.intel.com with ESMTP; 18 Aug 2020 08:46:36 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
Subject: [PATCH v6 00/10] net: eth: altera: tse: Add PTP and mSGDMA prefetcher
Date:   Tue, 18 Aug 2020 23:46:03 +0800
Message-Id: <20200818154613.148921-1-joyce.ooi@intel.com>
X-Mailer: git-send-email 2.13.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joyce Ooi <joyce.ooi@intel.com>

This patch series cleans up the Altera TSE driver and adds support
for the newer msgdma prefetcher as well as ptp support when using
the msgdma prefetcher.

v2: Rename altera_ptp to intel_fpga_tod, modify msgdma and sgdma tx_buffer
    functions to be of type netdev_tx_t, and minor suggested edits
v3: Modify tx_buffer to stop queue before returning NETDEV_TX_BUSY
v4: Fix build warnings
v5: Rename 'ptp_enable' variable to 'has_ptp' and initialize hardware clock
    to 0 in intel_fpga_tod, and make minor suggested changes
v6: Fix build warning and remove return error to allow PHY with
    timestamping support to pass through ioctl

Dalon Westergreen (10):
  net: eth: altera: tse_start_xmit ignores tx_buffer call response
  net: eth: altera: set rx and tx ring size before init_dma call
  net: eth: altera: fix altera_dmaops declaration
  net: eth: altera: add optional function to start tx dma
  net: eth: altera: Move common functions to altera_utils
  net: eth: altera: Add missing identifier names to function
    declarations
  net: eth: altera: change tx functions to type netdev_tx_t
  net: eth: altera: add support for ptp and timestamping
  net: eth: altera: add msgdma prefetcher
  net: eth: altera: update devicetree bindings documentation

 .../devicetree/bindings/net/altera_tse.txt         | 103 ++++-
 drivers/net/ethernet/altera/Kconfig                |   1 +
 drivers/net/ethernet/altera/Makefile               |   3 +-
 drivers/net/ethernet/altera/altera_msgdma.c        |   5 +-
 drivers/net/ethernet/altera/altera_msgdma.h        |  30 +-
 .../net/ethernet/altera/altera_msgdma_prefetcher.c | 431 +++++++++++++++++++++
 .../net/ethernet/altera/altera_msgdma_prefetcher.h |  30 ++
 .../ethernet/altera/altera_msgdmahw_prefetcher.h   |  87 +++++
 drivers/net/ethernet/altera/altera_sgdma.c         |  22 +-
 drivers/net/ethernet/altera/altera_sgdma.h         |  32 +-
 drivers/net/ethernet/altera/altera_tse.h           |  98 ++---
 drivers/net/ethernet/altera/altera_tse_ethtool.c   |  30 ++
 drivers/net/ethernet/altera/altera_tse_main.c      | 200 ++++++++--
 drivers/net/ethernet/altera/altera_utils.c         |  29 ++
 drivers/net/ethernet/altera/altera_utils.h         |  51 +++
 drivers/net/ethernet/altera/intel_fpga_tod.c       | 341 ++++++++++++++++
 drivers/net/ethernet/altera/intel_fpga_tod.h       |  56 +++
 17 files changed, 1396 insertions(+), 153 deletions(-)
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.c
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.h
 create mode 100644 drivers/net/ethernet/altera/altera_msgdmahw_prefetcher.h
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.c
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.h

-- 
2.13.0

