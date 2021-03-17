Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0B833E5E0
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhCQBUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:20:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:4724 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhCQA53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:29 -0400
IronPort-SDR: wP23Nwg6HmrHVvqzEhr5Iiy6bAUp/lqolPtu4NKHXqI7zdAGiKIHZAB7IrNf2/fNZ/1qw113yZ
 KmWJ3um0Zyjw==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="253376100"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="253376100"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 17:57:29 -0700
IronPort-SDR: Tzoo0T0/e/VvsdqiFXf5w+S2hVvaoycbT/3o73JtV16PSPMGR1mzExUVI7glE6GzP8hTmveRZ4
 kMKwilN7lwTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="411265350"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga007.jf.intel.com with ESMTP; 16 Mar 2021 17:57:25 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 0/1] net: stmmac: add per-q coalesce support
Date:   Wed, 17 Mar 2021 09:01:22 +0800
Message-Id: <20210317010123.6304-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch adds per-queue RX & TX coalesce control so that user can
adjust the RX & TX interrupt moderation per queue. This is beneficial for
mixed criticality control (according to VLAN priority) by user application.

The v2 patch has been tested (with added negative tests) and results from the
output of the ethtool looks correct.

########################################################################

########################################
# Ethtool: RX and TX coalesce: Show Test
########################################
> ethtool --show-coalesce eth0
Coalesce parameters for eth0:
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

> ethtool --per-queue eth0 queue_mask 0xFF --show-coalesce
Queue: 0
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 1
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 2
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 3
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 4
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 5
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 6
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 7
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

############################################
# Ethtool: RX and TX coalesce: Positive Test
############################################
> ethtool --per-queue eth0 queue_mask 0x02 --coalesce rx-usecs 100 rx-frames 5
> ethtool --per-queue eth0 queue_mask 0x20 --coalesce rx-usecs 100 rx-frames 5
> ethtool --per-queue eth0 queue_mask 0x22 --show-coalesce
Queue: 1
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 99
rx-frames: 5
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 5
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 99
rx-frames: 5
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

> ethtool --per-queue eth0 queue_mask 0x04 --coalesce tx-usecs 156 tx-frames 26
> ethtool --per-queue eth0 queue_mask 0x40 --coalesce tx-usecs 156 tx-frames 26
> ethtool --per-queue eth0 queue_mask 0x44 --show-coalesce
Queue: 2
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 200
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 156
tx-frames: 26
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 6
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 200
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 156
tx-frames: 26
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

############################################
# Ethtool: RX and TX coalesce: Negative Test
############################################
> ethtool --per-queue eth0 queue_mask 0x101 --coalesce rx-usecs 107 rx-frames 7
Cannot get device per queue parameters: Invalid argument
Cannot get device per queue parameters: Invalid argument
> ethtool --per-queue eth0 queue_mask 0x100 --coalesce rx-usecs 107 rx-frames 7
Cannot get device per queue parameters: Invalid argument
Cannot get device per queue parameters: Invalid argument
> ethtool --per-queue eth0 queue_mask 0x101 --coalesce tx-usecs 157 tx-frames 27
Cannot get device per queue parameters: Invalid argument
Cannot get device per queue parameters: Invalid argument
> ethtool --per-queue eth0 queue_mask 0x100 --coalesce tx-usecs 157 tx-frames 27
Cannot get device per queue parameters: Invalid argument
Cannot get device per queue parameters: Invalid argument
> ethtool --per-queue eth0 queue_mask 0x101 --show-coalesce
Cannot get device per queue parameters: Invalid argument
Cannot get device per queue parameters: Invalid argument
> ethtool --per-queue eth0 queue_mask 0x100 --show-coalesce
Cannot get device per queue parameters: Invalid argument
Cannot get device per queue parameters: Invalid argument
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce adaptive-rx on
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce adaptive-tx off
adaptive-tx unmodified, ignoring
Queue 0, no coalesce parameters changed
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce rx-usecs-irq 10
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce rx-frames-irq 10
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce tx-usecs-irq 10
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce tx-frames-irq 10
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce stats-block-usecs 10
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce pkt-rate-low 10
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce rx-usecs-low 100
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce rx-frames-low 100
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce tx-usecs-low 100
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce tx-frames-low 100
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce pkt-rate-high 10
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce rx-usecs-high 100
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce rx-frames-high 100
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce tx-usecs-high 100
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce tx-frames-high 100
Cannot set device per queue parameters: Operation not supported
> ethtool --per-queue eth0 queue_mask 0x01 --coalesce sample-interval 100
Cannot set device per queue parameters: Operation not supported

#########################################################
# Ethtool: RX and TX coalesce: Restore to driver default
#########################################################
> ethtool --per-queue eth0 queue_mask 0xFF --coalesce rx-usecs 204 rx-frames 0
rx-frames unmodified, ignoring
rx-frames unmodified, ignoring
rx-frames unmodified, ignoring
rx-frames unmodified, ignoring
rx-frames unmodified, ignoring
rx-frames unmodified, ignoring
> ethtool --per-queue eth0 queue_mask 0xFF --coalesce tx-usecs 1000 tx-frames 25
tx-usecs unmodified, ignoring
tx-frames unmodified, ignoring
Queue 0, no coalesce parameters changed
tx-usecs unmodified, ignoring
tx-frames unmodified, ignoring
Queue 1, no coalesce parameters changed
tx-usecs unmodified, ignoring
tx-frames unmodified, ignoring
Queue 3, no coalesce parameters changed
tx-usecs unmodified, ignoring
tx-frames unmodified, ignoring
Queue 4, no coalesce parameters changed
tx-usecs unmodified, ignoring
tx-frames unmodified, ignoring
Queue 5, no coalesce parameters changed
tx-usecs unmodified, ignoring
tx-frames unmodified, ignoring
Queue 7, no coalesce parameters changed

########################################
# Ethtool: RX and TX coalesce: Show Test
########################################
> ethtool --show-coalesce eth0
Coalesce parameters for eth0:
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

> ethtool --per-queue eth0 queue_mask 0xFF --show-coalesce
Queue: 0
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 1
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 2
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 3
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 4
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 5
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 6
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

Queue: 7
Adaptive RX: off  TX: off
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 202
rx-frames: 0
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 1000
tx-frames: 25
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frames-low: 0
tx-usecs-low: 0
tx-frames-low: 0

rx-usecs-high: 0
rx-frames-high: 0
tx-usecs-high: 0
tx-frames-high: 0

########################################################################

ChangeLogs:
v1 -> v2:
   * make unsupported queue coalesce params to return '0'.
   * remove unrequired coalesce params check in __stmmac_set_coalesce
     as supported coalesce params are already listed in
     supported_coalesce_params.

Thanks
Boon Leong

Ong Boon Leong (1):
  net: stmmac: add per-queue TX & RX coalesce ethtool support

 .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |   7 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |   7 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   8 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 118 +++++++++++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  48 ++++---
 7 files changed, 143 insertions(+), 49 deletions(-)

-- 
2.25.1

