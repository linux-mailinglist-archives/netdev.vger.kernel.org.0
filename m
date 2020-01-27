Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC39714A472
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgA0NFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:05:46 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:33948 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgA0NFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:05:45 -0500
Received: by mail-pl1-f180.google.com with SMTP id q13so3742760pls.1
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1SIL4f2C2sejdKsuB2G2Lk4C4DVWPI4rwUPmXeB+REY=;
        b=LZh8/2EbXpGUC2vRymzNX4UWw8t7aeP2/Y98extqbklBn9fjW98pYPCBCuYf/m9/pF
         27FtKtO+EqbxmMa/JfKni2sw/4SU2ip+kYdqRKEmnLyHBH6YCoAH3x8N/Taj/PSmA40Y
         43nn2lSC7O/PB0xt9NdO7/kbTJzbzqN0gOomP50KYzt7zcmPyfHj+hc97YmIxv323tw/
         VcJZjCGwVaPGW+GYN+p2ci0xxMBNqI+eftqj8P2D3MZefMlWybZSMPWn6Bx5rly/0h1O
         1n1A4+kHIhdkblNu+so8wfnVTxhOQ7E5+Sq8oX8qc9pYXM2HJRJEmH6Qdop24OVp3Vhk
         XKfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1SIL4f2C2sejdKsuB2G2Lk4C4DVWPI4rwUPmXeB+REY=;
        b=IO3lO725PesflCoVjilpy5I84j29CJ+bSnViVbC/J3C3V+UxdfLv5PVZUpVItMBW9M
         L6O4hHhyqm2eB7uN540YG3432PH6vnIVfJciBA0leYZsBOz8MmN435MMvQmcePyMDlpm
         WwkdPaSWvOGQwakH5YclLP4gyE9fA2PRLbPsawnCDb7ytsJviZfm+hZU+XB/yysYUEdz
         XOMP0k/bmTRFuTWChM3NBg/yj3qeeoX9IgndOvafpmFqGI6nV1YSqm2tz9b9RJ6WbiNX
         hwuPVjEX5h08XEZ835VZ3wc8GJu/7XYomkp1NHIbxhwsYsRko33kQ6wIRYLBldN7icgs
         1sXA==
X-Gm-Message-State: APjAAAVpPDMj97J1CX4qXl2t7kxzs5QAZvLnJEvpV6WYOEVQSItF4xUX
        CLvK0+XiHDO1BX3YxgH3nlJuwCTYNCQ=
X-Google-Smtp-Source: APXvYqzSee9JHDZYGaj0GbobO10QmdBema4coUErI23aXDJah6XilaFP9kiAhyxZDFHnMeHlL9Hl6A==
X-Received: by 2002:a17:902:7797:: with SMTP id o23mr16554555pll.298.1580130344533;
        Mon, 27 Jan 2020 05:05:44 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm17241717pja.30.2020.01.27.05.05.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 05:05:43 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v6 00/17] octeontx2-pf: Add network driver for physical function
Date:   Mon, 27 Jan 2020 18:35:14 +0530
Message-Id: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
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

Changes from v5:
   * Fixed otx2_atomic64_add() non ARM64 fallback definition.
     - Suggested by David Miller

Changes from v4:
   * Replaced pci_set_dma_mask and pci_set_consistent_dma_mask
     fn()s with dma_set_mask_and_coherent().
   * Some additonal code cleanup.
   * Fixed receive buffer segmnetation logic in otx2_alloc_rbuf()
   * Removed all unused BIG_ENDIAN structure definitions.
   * Removed unnecessary memory barriers
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

