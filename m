Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659FE13A138
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgANHCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:02:49 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39531 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbgANHCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:02:49 -0500
Received: by mail-pf1-f195.google.com with SMTP id q10so6122138pfs.6
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yS+dDCz3jJN5clkygEs72x15fBXnKYvkoyc4XBea0cg=;
        b=IgKXRxveTM8D7PYATZFLblx/VZsCoO5fYREfW0NyXvUwjEXgfguBcUxOXT5MjYeNcs
         eifkwbfBLuPnlCnpAsGzG3/zDQUFqkD+ve0a6gDVCsFGdsmWQNHddH1sgly70xQgWQ7C
         kkgGRbSGKjle2OrohQZFrCO4rpVlS4ysBV4NtvcBbdDS0Ybhr8rgLb1R5mNWeA1zwJwC
         0DogawljDLDIW/0uWVbtQ1rRi4v44WSudnMOJUDhDPFEu2FuQnliqbJnjn2+O1Uc7sm9
         Vjaq6R7xW9VsZ61YoYhoJQ/7MvK85wC2ofcRvXcgx5MzrG1+fxfIAX9Ybr2Oo8UOxf8t
         F7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yS+dDCz3jJN5clkygEs72x15fBXnKYvkoyc4XBea0cg=;
        b=fFVU1fREf14xE5dvMlqceHietFS5B8iF7nAI6+rFPmDRTA6rni5ozVkGe6ozcIDCE5
         Y+L7CbqJnaEAbwfm5EDQFQGJZGhGIwKTsFj6tTUe/rLyscGjvIpoGxSZAV2TUfnENkSI
         Y40gGnsJTqCmCy4wKgPOcXucHSrYKyPkdRnvGnJwlai6zGeGmjiTivrb9ixto11aMjPR
         sJlRM15WKCSKpgJCEX2GiH4hb0X2Qrzu0fGmQDlH6D+dxjbfpgv+ioU/NG826fSjge8w
         QfpmBGEDM4sMsiPB890X3alE+d6KU4iNEWbM2y9CrHc7I/ncBZsaglACOXiiEaMyG9Iz
         dEXw==
X-Gm-Message-State: APjAAAWIbfIKFEu357TEevN4RCL/koymXsmtYDt1t33urqLMYRPchEoq
        BziP1YGvIdG2vbdrVbYSayJi93xtZBo=
X-Google-Smtp-Source: APXvYqzAuYcVN6p6174skuG8Ic/68F3/00VBIYmCQ4txWkqKkL+asqdB4BXBU+xrdBzNqrWyEJ78HA==
X-Received: by 2002:a63:fb05:: with SMTP id o5mr25700221pgh.355.1578985367828;
        Mon, 13 Jan 2020 23:02:47 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id o19sm2241014pjr.2.2020.01.13.23.02.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 Jan 2020 23:02:47 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 00/17] octeontx2-pf: Add network driver for physical function
Date:   Tue, 14 Jan 2020 12:32:03 +0530
Message-Id: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
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

Changes from v1:
   * Fixed build errors
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
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  659 +++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 1361 +++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  147 ++
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  439 ++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  863 ++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  162 +++
 17 files changed, 5876 insertions(+), 3 deletions(-)
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

