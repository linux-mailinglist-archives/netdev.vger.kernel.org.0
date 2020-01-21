Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B299F143DDF
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAUNWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:22:00 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:43401 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUNWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 08:22:00 -0500
Received: by mail-pl1-f173.google.com with SMTP id p27so1326854pli.10
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 05:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uNqCklCBBHt/cbCcuE8LHGMATNwhUO3ifx1cDpfnPg8=;
        b=bY6/A16X53I9cMN9POTrY3CY1IxYiFKHis6iwKyXllJjOINREmfCS9Ptp8yWngfyuW
         4ceLIJRyKeCGk0ApeqW5aDkv+pU0fN3fW3VamLKUCSj6tNpyoHworKAhDqK7MQ+5+XOM
         hrFq3yGyIDCx5Tnifsc2bjL09787/mGNs8plzPoZJyQvLaBPVtW4uYflydDOzOpi6VOy
         09CHQgUC2WlskiXYFiamCwXAaKMNYp8fv6ChSdW8ru9v+MpLwZxZdTHju5/pxNbJ39iE
         Hauj2MvS3AhlyF9N7tNrUEtHJ6MBjMRsMf8No6lN/Iw3mrPJzvulN1QHwMthAGnC1Bjd
         BeZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uNqCklCBBHt/cbCcuE8LHGMATNwhUO3ifx1cDpfnPg8=;
        b=TX3YVrov2KD6yQoyq9LoAIVSyvEJTJUeLOao1GZds287RDwwFIHQDXJhnbianuJC5/
         qLyvlqe/doeV8uDFtIgtUdxtYOltDRUoOZ3pb2czFhGOIkfr6HE92uiGjVqaUhGgn7RK
         4MNlquorJThgWjkQ/+HmqcTc0xAg/T9UOlmFd9+6IfzF3Sb2Hvel95z7pov6ea97TuGS
         NA1tAyHDvxhgF9zcstf2oJFSs2kknDixqH/X/oi9LeRsVe2+NwCaDzQSDLFYEtA7T/Zr
         DxKCeQqoDYZox2xPnY34NhyplkjfOzvM2UeXeBWoHvcz1mlGxLM1aPmAAyO4S1lI5EjT
         bPkA==
X-Gm-Message-State: APjAAAUV3zbNMtt/7P4swCFhENtfuGeLEObCYLz+klSWO65VEFkw0GOr
        3+u+/gpQCRbiZXMDcNg+kQC6dBXopPw=
X-Google-Smtp-Source: APXvYqyuCWe6VaQjHsNH5yR/qIDKUZ9uc+bN+iEIB/nWSnIGUJhXsiaDLPSXqvWOC2Lmtur4qPgzeQ==
X-Received: by 2002:a17:902:7d95:: with SMTP id a21mr5518644plm.198.1579612918777;
        Tue, 21 Jan 2020 05:21:58 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y21sm43328076pfm.136.2020.01.21.05.21.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 05:21:58 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v4 00/17] octeontx2-pf: Add network driver for physical function
Date:   Tue, 21 Jan 2020 18:51:34 +0530
Message-Id: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
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
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 1416 ++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  615 +++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  662 +++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 1361 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  147 ++
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  439 ++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  863 ++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  162 +++
 17 files changed, 5886 insertions(+), 3 deletions(-)
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

