Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9731F21811A
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 09:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgGHHY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 03:24:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:57654 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730049AbgGHHY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 03:24:29 -0400
IronPort-SDR: LW+T/ts982h/Rlgj/EIAQsSF7djvHKF6ft1j4U5h9Ibr06WY1Kjkk/H9FTBKKDT1k4txdFWyDV
 JLlZQxMv+3Fg==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="135985885"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="135985885"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 00:24:28 -0700
IronPort-SDR: uxgm0yFvNeDoUoEWgV6tb0Cp+SlATvRZc2hMkNp/t8NVtEMRBaa+MTjSpssDf2vzKQg7mUfK46
 wjsZa2/6nLMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="358024867"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga001.jf.intel.com with ESMTP; 08 Jul 2020 00:24:25 -0700
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     Thor Thayer <thor.thayer@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dalon Westergreen <dalon.westergreen@linux.intel.com>,
        Joyce Ooi <joyce.ooi@intel.com>,
        Tan Ley Foon <ley.foon.tan@intel.com>,
        See Chin Liang <chin.liang.see@intel.com>,
        Dinh Nguyen <dinh.nguyen@intel.com>
Subject: [PATCH v4 00/10] net: eth: altera: tse: Add PTP and mSGDMA prefetcher
Date:   Wed,  8 Jul 2020 15:23:51 +0800
Message-Id: <20200708072401.169150-1-joyce.ooi@intel.com>
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
 drivers/net/ethernet/altera/altera_tse_ethtool.c   |  29 ++
 drivers/net/ethernet/altera/altera_tse_main.c      | 216 +++++++++--
 drivers/net/ethernet/altera/altera_utils.c         |  29 ++
 drivers/net/ethernet/altera/altera_utils.h         |  51 +++
 drivers/net/ethernet/altera/intel_fpga_tod.c       | 358 +++++++++++++++++
 drivers/net/ethernet/altera/intel_fpga_tod.h       |  56 +++
 17 files changed, 1428 insertions(+), 153 deletions(-)
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.c
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.h
 create mode 100644 drivers/net/ethernet/altera/altera_msgdmahw_prefetcher.h
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.c
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.h

-- 
2.13.0

