Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2FB1E93D0
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgE3VIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:08:36 -0400
Received: from inva021.nxp.com ([92.121.34.21]:60738 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728741AbgE3VIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 17:08:36 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id D3EB72013B1;
        Sat, 30 May 2020 23:08:33 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C566A200200;
        Sat, 30 May 2020 23:08:33 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8D9C1203C0;
        Sat, 30 May 2020 23:08:33 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 0/7] dpaa2-eth: add PFC support
Date:   Sun, 31 May 2020 00:08:07 +0300
Message-Id: <20200530210814.348-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for Priority Flow Control in DPAA2 Ethernet
devices.

The first patch make the necessary changes so that multiple
traffic classes are configured. The dequeue priority
of the maximum 8 traffic classes is configured to be equal.
The second patch adds a static distribution to said traffic
classes based on the VLAN PCP field. In the future, this could be
extended through the .setapp() DCB callback for dynamic configuration.

Also, add support for the congestion group taildrop mechanism that
allows us to control the number of frames that can accumulate on a group
of Rx frame queues belonging to the same traffic class.

The basic subset of the DCB ops is implemented so that the user can
query the number of PFC capable traffic classes, their state and
reconfigure them if necessary.

Changes in v3:
 - add patches 6-7 which add the PFC functionality
 - patch 2/7: revert to explicitly cast mask to u16 * to not get into
   sparse warnings
Changes in v4:
 - really fix the sparse warnings in 2/7

Ioana Ciornei (2):
  dpaa2-eth: Add PFC support through DCB ops
  dpaa2-eth: Keep congestion group taildrop enabled when PFC on

Ioana Radulescu (5):
  dpaa2-eth: Add support for Rx traffic classes
  dpaa2-eth: Distribute ingress frames based on VLAN prio
  dpaa2-eth: Add helper functions
  dpaa2-eth: Add congestion group taildrop
  dpaa2-eth: Update FQ taildrop threshold and buffer pool count

 drivers/net/ethernet/freescale/dpaa2/Kconfig  |  10 +
 drivers/net/ethernet/freescale/dpaa2/Makefile |   1 +
 .../ethernet/freescale/dpaa2/dpaa2-eth-dcb.c  | 150 +++++++++++
 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |   7 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 250 +++++++++++++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  69 ++++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  24 +-
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  59 +++++
 drivers/net/ethernet/freescale/dpaa2/dpni.c   | 177 +++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  97 +++++++
 10 files changed, 787 insertions(+), 57 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c

-- 
2.17.1

