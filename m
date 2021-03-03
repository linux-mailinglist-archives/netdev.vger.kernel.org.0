Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D420D32C455
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392276AbhCDANI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:08 -0500
Received: from mga14.intel.com ([192.55.52.115]:39539 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241111AbhCCPa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:30:28 -0500
IronPort-SDR: 9X3WCiI2nxIHO7d5/H0/HRx0ReedIRcjgFF1P1YA4/0kB1T5F+4jmOZWNfP7NZsYq/69c36SoJ
 VxVuYct0DHOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="186564101"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="186564101"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 07:28:01 -0800
IronPort-SDR: tiVx67nZorZLEMZqXymk8KfgYz8ZZmXH/hXhYa+Hb9MioKxvFew3SZVoui8icgJ+FFf9mzcFIf
 div9VDpHszHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="399758550"
Received: from climb.png.intel.com ([10.221.118.165])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 07:27:58 -0800
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH v1 net-next 0/5] net: stmmac: enable multi-vector MSI
Date:   Wed,  3 Mar 2021 23:27:52 +0800
Message-Id: <20210303152757.18959-1-weifeng.voon@intel.com>
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

