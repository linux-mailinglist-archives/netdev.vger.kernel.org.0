Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A05148D2A
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390835AbgAXRqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:03 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44276 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390021AbgAXRqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:03 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so1467686pgl.11
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VMHZ4c+1SEJMgMKN8JqBplPDMwgmszGVNkGNq06KHUg=;
        b=ghLT06qu7WymufsOvXBlXCs7wYjlah4logC+t37JeYu1t7th/DjfxatpAusDCiNkOR
         0WZvT/K4TzAGEQsumJSn+DLU1ebig3QyzG85qNu0KeKk4cQdo5U4SJjqy8g/zF+NsjSo
         bZA2qB2w51nvog6HfrYTHp/gddoE41cM8uQw+veCCJxDPomxvGOlfeWj1YqvBml8g5xo
         RULWjp0aMQZjBxJ2geaUSRB7NkzWwNmI797+lUZpggRtxnOODNfs2RPiDYD5qwcTRej6
         gab4msMz4jNIXwDLHRTMYAkOf4ogS6R8qbCkmfRRbjohAX9dsr++DyNqwlGRphEMSeio
         9JSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VMHZ4c+1SEJMgMKN8JqBplPDMwgmszGVNkGNq06KHUg=;
        b=BmW0MN51Y7FFuaej+3RAT4r34reCWYpHJRIOeDYT03opVuILsctyqx8vmaykxo+Lcl
         hWDEp7eijv+3V6yLFLaHDgi8WfW8mSqZpRbS3J7uq39wGy8XKWo7PZ55SejDa1X1/TcP
         qtVtLfVKYgBoAYFAVkj2/EduJNDcqUN0O2CpvxkPt24VA/NDv/BT/Ule/qTRKTWZmW+I
         FCPPzUWGlC7oMJzVhbNpoMp+mHTfGs0S5nafhe+Z5lkoT7aEecYgbrDrWIYcBKNBc2rI
         h6K3bj75axErtc+WVvwru9w4EMkZ/7A1wFIVJZQDu6RPVDOejcRzZnN6Lw8ugVwuSncd
         gOtw==
X-Gm-Message-State: APjAAAWy8STRHvyyPm2sVPcdEr4NE+XxnfV5fZA/SnY74nRkO94qkseK
        1xja2CmcB/GVXrcgIRb1LkRxq1RDpnw=
X-Google-Smtp-Source: APXvYqzw+5mlHa/3DJZoec1YpQe2Ybrprb0WzwUaun9+L8x3nvp9NpWJbCGg6BtLklhVhoVC4/wssw==
X-Received: by 2002:a63:2d44:: with SMTP id t65mr5658891pgt.112.1579887961984;
        Fri, 24 Jan 2020 09:46:01 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm7310849pgs.60.2020.01.24.09.45.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 09:46:01 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v5 00/17] octeontx2-pf: Add network driver for physical function
Date:   Fri, 24 Jan 2020 23:15:38 +0530
Message-Id: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
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

