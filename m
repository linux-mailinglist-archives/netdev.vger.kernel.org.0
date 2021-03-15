Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE27D33ABBA
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 07:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhCOGlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 02:41:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:40258 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhCOGk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 02:40:58 -0400
IronPort-SDR: 0Kzx7PWNrLHt99Qq7pTwAfxNuSE+cOMNVZVkEbfpkRtJGu3Unkkyw5HzGanXVbpAtmR1X9uEx5
 ubEzxc28g9mQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="168958455"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="168958455"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 23:40:57 -0700
IronPort-SDR: A7rqz74PYV7+BE/8VXwnXIoaGSSyVCYgUXNeHtD6MOZyetXIws/wfmY3CWj243ZK6/GigoJsEM
 Z2eTfNb0pHhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="604742500"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga005.fm.intel.com with ESMTP; 14 Mar 2021 23:40:53 -0700
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
Subject: [PATCH net-next 0/1] net: stmmac: add per-q coalesce support
Date:   Mon, 15 Mar 2021 14:44:47 +0800
Message-Id: <20210315064448.16391-1-boon.leong.ong@intel.com>
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

The patch as been tested with following steps and results and the
from the output of ethtool, it looks good.

 ########################################################################

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

Thanks,
Boon Leong

Ong Boon Leong (1):
  net: stmmac: add per-queue TX & RX coalesce ethtool support

 .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  |   7 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |   7 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   8 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 132 ++++++++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  48 ++++---
 7 files changed, 157 insertions(+), 49 deletions(-)

-- 
2.25.1

