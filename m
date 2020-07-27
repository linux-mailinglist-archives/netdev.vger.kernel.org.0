Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE8022E8C1
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgG0JWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:22:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:46426 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbgG0JWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 05:22:23 -0400
IronPort-SDR: 3Lx7hcRiZoHsDQ3+KgjqyQcZi4N9aIJ/Ic4Cz6vFPZs9kthQKC1Sq48ah/nw2/t4R+oHuUHr76
 eja6KSxqs9XQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="152237578"
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="152237578"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 02:22:22 -0700
IronPort-SDR: ha1T5oMCPoh4ZTwjIBVuGLb5a9GKaA0fo791x+29zAVjys+TfUzigBOpz0Hw7ChPFIHeC5FsB4
 r3XrTNy4MRYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,402,1589266800"; 
   d="scan'208";a="303393667"
Received: from pg-nxl3.altera.com ([10.142.129.93])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 02:22:19 -0700
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
Subject: [PATCH v5 00/10] net: eth: altera: tse: Add PTP and mSGDMA prefetcher
Date:   Mon, 27 Jul 2020 17:21:47 +0800
Message-Id: <20200727092157.115937-1-joyce.ooi@intel.com>
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
 drivers/net/ethernet/altera/altera_tse_main.c      | 203 ++++++++--
 drivers/net/ethernet/altera/altera_utils.c         |  29 ++
 drivers/net/ethernet/altera/altera_utils.h         |  51 +++
 drivers/net/ethernet/altera/intel_fpga_tod.c       | 341 ++++++++++++++++
 drivers/net/ethernet/altera/intel_fpga_tod.h       |  56 +++
 17 files changed, 1399 insertions(+), 153 deletions(-)
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.c
 create mode 100644 drivers/net/ethernet/altera/altera_msgdma_prefetcher.h
 create mode 100644 drivers/net/ethernet/altera/altera_msgdmahw_prefetcher.h
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.c
 create mode 100644 drivers/net/ethernet/altera/intel_fpga_tod.h

-- 
2.13.0

