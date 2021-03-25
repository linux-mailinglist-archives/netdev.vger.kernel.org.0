Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF50349864
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCYRjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:39:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:27389 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhCYRjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 13:39:21 -0400
IronPort-SDR: eCMT3yTW2EGZfcHUZ2cznwuD39V1r3Wv8rWYBODxCpbcZsPd8dLMaJUQBDcigvG3+HOb4pWxD+
 oOH07vNPzr7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191016762"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="191016762"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 10:39:20 -0700
IronPort-SDR: 0TVUNNIh1zGMOZkz9T8MOMTbvezKxkBGMPrRwvQYfSYl3crsztv7KNCfOsmDbicfxRs66uxUql
 uPdv8m+t/djg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="416112200"
Received: from climb.png.intel.com ([10.221.118.165])
  by orsmga008.jf.intel.com with ESMTP; 25 Mar 2021 10:39:16 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH v2 net-next 0/5] net: stmmac: enable multi-vector MSI
Date:   Fri, 26 Mar 2021 01:39:11 +0800
Message-Id: <20210325173916.13203-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for multi MSI interrupts in addition to
current single common interrupt implementation. Each MSI interrupt is tied
to a newly introduce interrupt service routine(ISR). Hence, each interrupt
will only go through the corresponding ISR.

In order to increase the efficiency, enabling multi MSI interrupt will
automatically select the interrupt mode configuration INTM=1. When INTM=1,
the TX/RX transfer complete signal will only asserted on corresponding
sbd_perch_tx_intr_o[] or sbd_perch_rx_intr_o[] without asserting signal
on the common sbd_intr_o. Hence, for each TX/RX interrupts, only the
corresponding ISR will be triggered.

Every vendor might have different MSI vector assignment. So, this patchset
only includes multi-vector MSI assignment for Intel platform.

Changes:
v1 -> v2
 patch 2/5
 -Remove defensive check for invalid dev pointer

 patch 3/5
 - Refactor out a huge if statement into separate subfunctions.
 - Removed the netdev_info for every successful request of IRQs.
 - Return 0 for each successful request of IRQs.

 patch 4/5
 - Moved the msi tx/rx base vector check before alloc irq
 - Restuctured the clean up code after fail to alloc irq and fail to probe
 - Unprepared and unregistered the stmmac-clk if fail to alloc irq

 patch 5/5
 -Moved the readl and writel into the if statement as it is only executed
  when multi msi is enabled

Ong Boon Leong (4):
  net: stmmac: introduce DMA interrupt status masking per traffic
    direction
  net: stmmac: make stmmac_interrupt() function more friendly to MSI
  net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX
  stmmac: intel: add support for multi-vector msi and msi-x

Wong, Vee Khee (1):
  net: stmmac: use interrupt mode INTM=1 for multi-MSI

 drivers/net/ethernet/stmicro/stmmac/common.h  |  21 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 120 ++++-
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  24 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |   7 +
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  24 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  30 +-
 .../net/ethernet/stmicro/stmmac/dwmac_dma.h   |  22 +-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |   8 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2.h    |   6 +
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |   8 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  16 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 499 +++++++++++++++---
 include/linux/stmmac.h                        |   9 +
 14 files changed, 697 insertions(+), 99 deletions(-)

-- 
2.17.1

