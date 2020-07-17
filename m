Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BD7223FB0
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgGQPhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:37:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60688 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgGQPhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 11:37:07 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EDD771A0414;
        Fri, 17 Jul 2020 17:37:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E1C031A036A;
        Fri, 17 Jul 2020 17:37:04 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B4C1C20466;
        Fri, 17 Jul 2020 17:37:04 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/6] Add adaptive interrupt coalescing
Date:   Fri, 17 Jul 2020 18:36:58 +0300
Message-Id: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
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

Claudiu Manoil (6):
  enetc: Refine buffer descriptor ring sizes
  enetc: Factor out the traffic start/stop procedures
  enetc: Fix interrupt coalescing register naming
  enetc: Drop redundant ____cacheline_aligned_in_smp
  enetc: Add interrupt coalescing support
  enetc: Add adaptive interrupt coalescing

 drivers/net/ethernet/freescale/enetc/Kconfig  |   2 +
 drivers/net/ethernet/freescale/enetc/enetc.c  | 156 ++++++++++++++----
 drivers/net/ethernet/freescale/enetc/enetc.h  |  37 ++++-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  91 +++++++++-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  23 ++-
 5 files changed, 265 insertions(+), 44 deletions(-)

-- 
2.17.1

