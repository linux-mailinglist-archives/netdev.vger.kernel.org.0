Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156FE2279EF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgGUHzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:55:25 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51844 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgGUHzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 03:55:25 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 22F8D1A0582;
        Tue, 21 Jul 2020 09:55:23 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1719F1A0572;
        Tue, 21 Jul 2020 09:55:23 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DEAC8202A9;
        Tue, 21 Jul 2020 09:55:22 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/6] Add adaptive interrupt coalescing
Date:   Tue, 21 Jul 2020 10:55:16 +0300
Message-Id: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apart from some related cleanup patches, this set
introduces in a straightforward way the support needed
to enable and configure interrupt coalescing for ENETC.

Patch 5 introduces the support needed for configuring the
interrupt coalescing parameters and for switching between
moderated (int. coalescing) and per-packet interrupt modes.
When interrupt coalescing is enabled the Rx/Tx time
thresholds are configurable, packet thresholds are fixed.
To make this work reliably, patch 5 uses the traffic
pause procedure introduced in patch 2.

Patch 6 adds DIM (Dynamic Interrupt Moderation) to implement
adaptive coalescing based on time thresholds, for the Rx 'channel'.
On the Tx side a default optimal value is used instead, optimized for
TCP traffic over 1G and 2.5G links.  This default 'optimal' value can
be overridden anytime via 'ethtool -C tx-usecs'.

netperf -t TCP_MAERTS measurements show a significant CPU load
reduction correlated w/ reduced interrupt rates. For the
measurement results refer to the comments in patch 6.

v2: Replaced Tx DIM with predefined optimal value, giving
better results. This was also suggested by Jakub (cc).
Switched order of patches 4 and 5, for better grouping.

v3: minor cleanup/improvements

Claudiu Manoil (6):
  enetc: Refine buffer descriptor ring sizes
  enetc: Factor out the traffic start/stop procedures
  enetc: Fix interrupt coalescing register naming
  enetc: Drop redundant ____cacheline_aligned_in_smp
  enetc: Add interrupt coalescing support
  enetc: Add adaptive interrupt coalescing

 drivers/net/ethernet/freescale/enetc/Kconfig  |   2 +
 drivers/net/ethernet/freescale/enetc/enetc.c  | 156 ++++++++++++++----
 drivers/net/ethernet/freescale/enetc/enetc.h  |  36 +++-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  84 +++++++++-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  23 ++-
 5 files changed, 257 insertions(+), 44 deletions(-)

-- 
2.17.1

