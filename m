Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8297A13F9BE
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbgAPTrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:47:43 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40853 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbgAPTrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 14:47:43 -0500
Received: by mail-pl1-f196.google.com with SMTP id s21so8778387plr.7
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 11:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HLXM1czWWtfgsXiDgym90fK4nzBZI+FqNwkCTAJCrYs=;
        b=gaScYpqeFAhf02LkyjyQF3artoNcY38QO3CqflMga1LQNHNfZTyC4M9W3fAhFWkbqd
         phou2AKDl46ebhfaHdb6QwW/7XQvciIwvBGlgyv2uPD+ywaD7SHswIvXbFJlYPm1Wwit
         Opsuc/e6OY/UCxvPuavJv96RPHQxkVT5dO4g85mBlxRLrmCybIPk5oL96Yfc+0Fj/WCT
         4F101wK1PNvOKpbC4Ms40qzVRcuXWPebNWe2C4F0Fezd12mzViDCL31n4x4QjWdcdHXA
         891zrQJ3pCiNPi0YXD/GylJsSZlxMpcqkPEHcSCNTENJjyiqLQfIE1COIGJdlRpgCw9a
         1G7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HLXM1czWWtfgsXiDgym90fK4nzBZI+FqNwkCTAJCrYs=;
        b=OiVNotrg/WqQegr7jMFfTJxdKsYNrsiXMnaxviglqQmniPHOAJAW3G7VJqwxvP7P8c
         dnv49IRmiWxWYicuZcnJhIyMZkh9lj/KflEQ3AkT6Anwrpcy+wR7MxoSlRk7iyRCpQhz
         JnDfyvaDVT7i0+xqCxipCiUCLsJZuL9HU45TCKYXwnW/bLHvvvdoqe+MXEkAv3fXN+e4
         T2B8p0ihklw9pPsCcpflRV39Aek8iQNkccm6CzzeajLuFvfbcPXqTaLXipHUmDRXCyKy
         ShmBkAjawTx32Cjdknb1I3P7j+UNBE5//yqpVM+UakJ6rzWWtrrUcENha8qOs4P887Lz
         jHxA==
X-Gm-Message-State: APjAAAUkD4kCOvaomjvCeAEDSHWrYTn8lZqTydNq4+oXKUBmFXVv0cDV
        y0hbojQVRAtULyhUvUV0RU3t4kZCew8=
X-Google-Smtp-Source: APXvYqw58VEtXymi0TAFFEHmOLOmUTNJ1817ZlUrVhOuO35x6vcKsxZTKs73BVDBvTe0F4M9y5V8Bw==
X-Received: by 2002:a17:90a:2729:: with SMTP id o38mr1005749pje.45.1579204062268;
        Thu, 16 Jan 2020 11:47:42 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j28sm26174623pgb.36.2020.01.16.11.47.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 16 Jan 2020 11:47:41 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 00/17] octeontx2-pf: Add network driver for physical function
Date:   Fri, 17 Jan 2020 01:17:16 +0530
Message-Id: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
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
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 1409 ++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  615 +++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  661 +++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 1361 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  147 ++
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  439 ++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  863 ++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  162 +++
 17 files changed, 5878 insertions(+), 3 deletions(-)
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

