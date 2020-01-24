Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7174B148D31
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403820AbgAXRqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:25 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58298 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403766AbgAXRqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:24 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00OHjNAF018406;
        Fri, 24 Jan 2020 09:46:17 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dthc8g-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Jan 2020 09:46:17 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jan
 2020 09:45:27 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Jan 2020 09:45:27 -0800
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 84E7C3F703F;
        Fri, 24 Jan 2020 09:45:25 -0800 (PST)
From:   <sunil.kovvuri@gmail.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kubakici@wp.pl>, <mkubecek@suse.cz>,
        <maciej.fijalkowski@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v5 00/17] octeontx2-pf: Add network driver for physical function
Date:   Fri, 24 Jan 2020 23:15:04 +0530
Message-ID: <1579887921-22098-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_06:2020-01-24,2020-01-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

OcteonTX2 SOC's resource virtualization unit (RVU) supports
multiple physical and virtual functions. Each of the PF's
functionality is determined by what kind of resources are attached
to it. If NPA and NIX blocks are attached to a PF it can function
as a highly capable network device.

This patch series add a network driver for the PF. Initial set of
patches adds mailbox communication with admin function (RVU AF)
and configuration of queues. Followed by Rx and tx pkts NAPI
handler and then support for HW offloads like RSS, TSO, Rxhash etc.
Ethtool support to extract stats, config RSS, queue sizes, queue
count is also added.

Added documentation to give a high level overview of HW and
different drivers which will be upstreamed and how they interact.

Changes from v4:
   * Replaced pci_set_dma_mask and pci_set_consistent_dma_mask
     fn()s with dma_set_mask_and_coherent().
   * Fixed receive buffer segmnetation logic in otx2_alloc_rbuf()
   * Removed all unused BIG_ENDIAN structure definitions.
   * Removed unnecessary memory barriers
   * Some additonal code cleanup.
     - Sugested by Jakub Kicinski
   * Fixed mailbox initalization failure handling
   * Removed unused function parameter in otx2_skb_add_frag()
     - Suggested by Maciej Fijalkowski

Changes from v3:
   * Fixed receive side scaling reinitialization during interface
     DOWN and UP to retain user configured settings, if any.
   * Removed driver version from ethtool.
   * Fixed otx2_set_rss_hash_opts() to return error incase RSS is
     not enabled.
     - Sugested by Jakub Kicinski

Changes from v2:
   * Removed frames, bytes, dropped packet stats from ethtool to avoid
     duplication of same stats in netlink and ethtool.
     - Sugested by Jakub Kicinski
   * Removed number of channels and ringparam upper bound checking
     in ethtool support.
   * Fixed RSS hash option setting to reject unsupported config.
     - Suggested by Michal Kubecek

Changes from v1:
   * Made driver dependent on 64bit, to fix build errors related to
     non availability of writeq/readq APIs for 32bit platforms.
     - Reported by kbuild test robot

Christina Jacob (1):
  octeontx2-pf: Add basic ethtool support

Geetha sowjanya (2):
  octeontx2-pf: Error handling support
  octeontx2-pf: Add ndo_get_stats64

Linu Cherian (1):
  octeontx2-pf: Register and handle link notifications

Sunil Goutham (13):
  octeontx2-pf: Add Marvell OcteonTX2 NIC driver
  octeontx2-pf: Mailbox communication with AF
  octeontx2-pf: Attach NIX and NPA block LFs
  octeontx2-pf: Initialize and config queues
  octeontx2-pf: Setup interrupts and NAPI handler
  octeontx2-pf: Receive packet handling support
  octeontx2-pf: Add packet transmission support
  octeontx2-pf: MTU, MAC and RX mode config support
  octeontx2-pf: Receive side scaling support
  octeontx2-pf: TCP segmentation offload support
  octeontx2-pf: ethtool RSS config support
  Documentation: net: octeontx2: Add RVU HW and drivers overview
  MAINTAINERS: Add entry for Marvell OcteonTX2 Physical Function driver

 Documentation/networking/device_drivers/index.rst  |    1 +
 .../device_drivers/marvell/octeontx2.rst           |  159 +++
 MAINTAINERS                                        |   10 +
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |    8 +
 drivers/net/ethernet/marvell/octeontx2/Makefile    |    2 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |    9 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |    8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   17 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   10 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 1410 ++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  615 +++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  662 +++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 1349 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  147 ++
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  276 ++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  848 ++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  162 +++
 17 files changed, 5690 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/marvell/octeontx2.rst
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/Makefile
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h

-- 
2.7.4

