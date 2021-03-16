Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A9A33D3AE
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 13:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCPMSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 08:18:52 -0400
Received: from mga18.intel.com ([134.134.136.126]:49319 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230113AbhCPMS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 08:18:28 -0400
IronPort-SDR: UxaKiUh1IOiM7oNgmQIXrdjw4A8AuyG0seDZmqd0k4+3Cs8HrPTx0Gzf1WHPsHWBgGl/0dBj8U
 L2IdYz5RgEUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="176844043"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="176844043"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 05:18:27 -0700
IronPort-SDR: hfN8W7PNV5itwFmITqi3spDA4QeDpgxF6ahDdPoZxhENQvr4KdyCNAe8h7yOBykFXS/d3E11ib
 lFLKrnLPnnmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="449703375"
Received: from climb.png.intel.com ([10.221.118.165])
  by orsmga001.jf.intel.com with ESMTP; 16 Mar 2021 05:18:24 -0700
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
Subject: [RESEND v1 net-next 0/5] net: stmmac: enable multi-vector MSI
Date:   Tue, 16 Mar 2021 20:18:18 +0800
Message-Id: <20210316121823.18659-1-weifeng.voon@intel.com>
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

Ong Boon Leong (4):
  net: stmmac: introduce DMA interrupt status masking per traffic
    direction
  net: stmmac: make stmmac_interrupt() function more friendly to MSI
  net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX
  stmmac: intel: add support for multi-vector msi and msi-x

Wong, Vee Khee (1):
  net: stmmac: use interrupt mode INTM=1 for multi-MSI

 drivers/net/ethernet/stmicro/stmmac/common.h  |  21 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 112 +++-
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  24 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |   8 +
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  24 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  30 +-
 .../net/ethernet/stmicro/stmmac/dwmac_dma.h   |  22 +-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |   8 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2.h    |   6 +
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |   8 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  16 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 482 +++++++++++++++---
 include/linux/stmmac.h                        |   9 +
 14 files changed, 676 insertions(+), 96 deletions(-)

-- 
2.17.1

