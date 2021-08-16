Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1D43ECE83
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 08:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhHPGTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 02:19:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:31371 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhHPGTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 02:19:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="202960676"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="202960676"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2021 23:18:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="678986694"
Received: from vijay.png.intel.com ([10.88.229.73])
  by fmsmga005.fm.intel.com with ESMTP; 15 Aug 2021 23:18:54 -0700
From:   Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     vee.khee.wong@intel.com, weifeng.voon@intel.com,
        vijayakannan.ayyathurai@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 0/3] net: stmmac: Add ethtool per-queue statistic
Date:   Mon, 16 Aug 2021 14:15:57 +0800
Message-Id: <cover.1629092894.git.vijayakannan.ayyathurai@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding generic ethtool per-queue statistic framework to display the
statistics for each rx/tx queue. In future, users can avail it to add
more per-queue specific counters. Number of rx/tx queues displayed is
depending on the available rx/tx queues in that particular MAC config
and this number is limited up to the MTL_MAX_{RX|TX}_QUEUES defined
in the driver.

Ethtool per-queue statistic display will look like below, when users
start adding more counters.

Example - 1:
 q0_tx_statA:
 q0_tx_statB:
 q0_tx_statC:
 |
 q0_tx_statX:
 .
 .
 .
 qMAX_tx_statA:
 qMAX_tx_statB:
 qMAX_tx_statC:
 |
 qMAX_tx_statX:

 q0_rx_statA:
 q0_rx_statB:
 q0_rx_statC:
 |
 q0_rx_statX:
 .
 .
 .
 qMAX_rx_statA:
 qMAX_rx_statB:
 qMAX_rx_statC:
 |
 qMAX_rx_statX:

Example - 2: Ping test using the tx queue 3.

$ tc qdisc add dev enp0s30f4 root mqprio num_tc 2 map 1 0 0 0 0 0 0 0
 0 0 0 0 0 0 0 0 queues 3@0 1@3 hw 0

Statistic before ping:
---------------------
$ ethtool -S enp0s30f4

[ snip ]
     q3_tx_pkt_n: 7916
     q3_tx_irq_n: 316
[ snip ]

$ cat /proc/interrupts

[ snip ]
 143:          0          0          0        316          0          0

         0          0  IR-PCI-MSI 499719-edge      enp0s30f4:tx-3
[ snip ]

$ ping -I enp0s30f4 192.168.1.10 -i 0.01 -c 100 > /dev/null

Statistic after ping:
---------------------
$ ethtool -S enp0s30f4

[ snip ]
     q3_tx_pkt_n: 8016
     q3_tx_irq_n: 320
[ snip ]

$ cat /proc/interrupts

[ snip ]
143:          0          0          0        320          0          0

         0          0  IR-PCI-MSI 499719-edge      enp0s30f4:tx-3
[ snip ]

Vijayakannan Ayyathurai (2):
  net: stmmac: add ethtool per-queue statistic framework
  net: stmmac: add ethtool per-queue irq statistic support

Voon Weifeng (1):
  net: stmmac: fix INTR TBU status affecting irq count statistic

 drivers/net/ethernet/stmicro/stmmac/common.h  | 13 ++++
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  7 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 67 ++++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  5 ++
 4 files changed, 89 insertions(+), 3 deletions(-)


base-commit: e4637f621203cb482f3ddb590cfe9f65045d92a6
-- 
2.17.1

