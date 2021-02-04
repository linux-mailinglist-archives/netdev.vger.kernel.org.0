Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39B430F206
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhBDLZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:25:43 -0500
Received: from [1.6.215.26] ([1.6.215.26]:51984 "EHLO hyd1soter2"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S235551AbhBDLZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 06:25:38 -0500
Received: from hyd1soter2.caveonetworks.com (localhost [127.0.0.1])
        by hyd1soter2 (8.15.2/8.15.2/Debian-3) with ESMTP id 114BOaDF051712;
        Thu, 4 Feb 2021 16:54:36 +0530
Received: (from geetha@localhost)
        by hyd1soter2.caveonetworks.com (8.15.2/8.15.2/Submit) id 114BOY8B051711;
        Thu, 4 Feb 2021 16:54:34 +0530
From:   Geetha sowjanya <gakula@marvell.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        sbhatta@marvell.com, hkelam@marvell.com, jerinj@marvell.com,
        lcherian@marvell.com, Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v3 00/14] Add Marvell CN10K support
Date:   Thu,  4 Feb 2021 16:54:32 +0530
Message-Id: <1612437872-51671-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current admin function (AF) driver and the netdev driver supports
OcteonTx2 silicon variants. The same OcteonTx2's
Resource Virtualization Unit (RVU) is carried forward to the next-gen
silicon ie OcteonTx3, with some changes and feature enhancements.

This patch set adds support for OcteonTx3 (CN10K) silicon and gets
the drivers to the same level as OcteonTx2. No new OcteonTx3 specific
features are added.

Changes cover below HW level differences
- PCIe BAR address changes wrt shared mailbox memory region
- Receive buffer freeing to HW
- Transmit packet's descriptor submission to HW
- Programmable HW interface identifiers (channels)
- Increased MTU support
- A Serdes MAC block (RPM) configuration

v2-v3
Reposting as a single thread.
Rebased on top latest net-next branch.

v1-v2
Fixed check-patch reported issues.

Geetha sowjanya (6):
  octeontx2-af: cn10k: Add mbox support for CN10K platform
  octeontx2-af: cn10k: Update NIX/NPA context structure
  octeontx2-af: cn10k: Update NIX and NPA context in debugfs
  octeontx2-pf: cn10k: Initialise NIX context
  octeontx2-pf: cn10k: Map LMTST region
  octeontx2-pf: cn10k: Use LMTST lines for NPA/NIX operations

Hariprasad Kelam (5):
  octeontx2-af: cn10k: Add RPM MAC support
  octeontx2-af: cn10K: Add MTU configuration
  octeontx2-pf: cn10k: Get max mtu supported from admin function
  octeontx2-af: cn10k: Add RPM Rx/Tx stats support
  octeontx2-af: cn10k: MAC internal loopback support

Rakesh Babu (1):
  octeontx2-af: cn10k: Add RPM LMAC pause frame support

Subbaraya Sundeep (2):
  octeontx2-pf: cn10k: Add mbox support for CN10K
  octeontx2-af: cn10k: Add support for programmable channels

 MAINTAINERS                                        |   2 +
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |  10 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 315 ++++++++---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  15 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |   1 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   5 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    | 131 +++++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |  59 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  70 ++-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |  12 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    | 272 ++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  57 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 159 +++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  71 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 134 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  | 261 +++++++++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 339 +++++++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 112 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  24 +
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h | 604 ++++++---------------
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |  10 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c | 182 +++++++
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |  17 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 145 +++--
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 105 +++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  73 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |   4 +
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  10 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  70 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  52 +-
 include/linux/soc/marvell/octeontx2/asm.h          |   8 +
 33 files changed, 2606 insertions(+), 735 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rpm.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h

-- 
2.7.4

