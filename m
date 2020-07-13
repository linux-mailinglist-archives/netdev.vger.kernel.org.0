Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A6421D665
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgGMM4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:56:17 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56492 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgGMM4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 08:56:13 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9B8871A0EB7;
        Mon, 13 Jul 2020 14:56:10 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8F23F1A007E;
        Mon, 13 Jul 2020 14:56:10 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 67E95204BE;
        Mon, 13 Jul 2020 14:56:10 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/6] enetc: Add adaptive interrupt coalescing
Date:   Mon, 13 Jul 2020 15:56:04 +0300
Message-Id: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apart from some related cleanup patches, this set
introduces in a straightforward way the support needed
to enable and configure interrupt coalescing for ENETC.

Patch 4 introduces the framework for configuring
interrupt coalescing parameters and switching between
moderated (int. coalescing) and per-packet interrupt modes.
When interrupt coalescing is enabled the Rx/Tx time
thresholds are configurable, packet thresholds are fixed.
To make this work reliably, patch 4 calls the traffic
pause procedure introduced in patch 2.

Patch 6 adds DIM (Dynamic Interrupt Moderation) to implement
adaptive coalescing based on time thresholds, for both Rx and
Tx processing 'channels' independently.
netperf -t TCP_MAERTS measurements show a significant CPU load
reduction correlated w/ reduced interrupt rates. For a single
TCP flow (mostly Rx), when both RX and Tx paths are processed
on the same CPU, the CPU load improvement is not so great though
the interrupt rate is ~3x smaller than before. I think part of this
can be attributed to the overhead of supporting interrupt coalescing.
But if the Rx and Tx channels are processed on separate CPUs the
improvement is stunning.
Nevertheless, for a system load test involving 8 TCP threads the
CPU utilization improvement is important.  Below are the
measurement results pasted from patch 6's comments, for reference:

2 ARM Cortex-A72 @1.3Ghz CPUs system, 32 KB L1 data cache,
using netperf @ 1Gbit link (maximum throughput):

1) 1 Rx TCP flow, both Rx and Tx processed by the same NAPI
thread on the same CPU:
        CPU utilization         int rate (ints/sec)
Before: 50%-60% (over 50%)              92k
After:  just under 50%                  35k
Comment:  Small CPU utilization improvement for a single flow
          Rx TCP flow (i.e. netperf -t TCP_MAERTS) on a single
          CPU.

2) 1 Rx TCP flow, Rx processing on CPU0, Tx on CPU1:
        Total CPU utilization   Total int rate (ints/sec)
Before: 60%-70%                 85k CPU0 + 42k CPU1
After:  15%                     3.5k CPU0 + 3.5k CPU1
Comment:  Huge improvement in total CPU utilization
          correlated w/a a huge decrease in interrupt rate.

3) 4 Rx TCP flows + 4 Tx TCP flows (+ pings to check the latency):
        Total CPU utilization   Total int rate (ints/sec)
Before: ~80% (spikes to 90%)            ~100k
After:   60% (more steady)               ~10k
Comment:  Important improvement for this load test, while the
          ping test outcome was not impacted.


Claudiu Manoil (6):
  enetc: Refine buffer descriptor ring sizes
  enetc: Factor out the traffic start/stop procedures
  enetc: Fix interrupt coalescing register naming
  enetc: Add interrupt coalescing support
  enetc: Drop redundant ____cacheline_aligned_in_smp
  enetc: Add adaptive interrupt coalescing

 drivers/net/ethernet/freescale/enetc/Kconfig  |   2 +
 drivers/net/ethernet/freescale/enetc/enetc.c  | 215 ++++++++++++++----
 drivers/net/ethernet/freescale/enetc/enetc.h  |  40 +++-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  92 +++++++-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  23 +-
 5 files changed, 322 insertions(+), 50 deletions(-)

-- 
2.17.1

