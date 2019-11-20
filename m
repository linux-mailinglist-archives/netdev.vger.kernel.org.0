Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E17E104267
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfKTRsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:48:17 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:46056 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfKTRsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:48:17 -0500
Received: by mail-pg1-f180.google.com with SMTP id k1so61794pgg.12
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kfwd6o/B4wTdPHroXp8plb7makuSyAsm1O51sSrr52E=;
        b=L+8k1NT8lp8gvIusBmuxtdEsPGp03J00Pa4/bA0Ftq240Qf6u1/IATHqXlaHe9K+9/
         HhXmQJhjdzZP/iTFp28dkst9jt8+xEEeSZCc2cEa0CttcENigNbl6QMdh1R4EPBy2no3
         8ejJ1YJXyBFuy74Qz2/6mulst5XsavKqNTwE0bl8z1dN2Ksegm9PhZiy+NjyFrRjoCUj
         vgRK6/3lvZDXCcMIutrbVpfIUaUQ+VjxpvjNQnHuhH1PEEvxSC5c5lj0/sjU3VOTOU19
         6TZ7YelxlgFZz94doLlAX1TxB5g+AOsp48JniqPfMSlJTpPr/7u9ZpRkmmtEV0eQomQA
         iq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kfwd6o/B4wTdPHroXp8plb7makuSyAsm1O51sSrr52E=;
        b=rNuFpfk4avXSB2BIkU12lVQyUbDl4wmy6sY4UWhi2lqDj/t2K3bOVlu86tv2RAytoG
         XcsdwAp+H+KY+rNRuxEk+iwF3gz5vuJ9T0g+h0xo50Pr1Iibk72PlLmKX9p8pxfhwGm2
         GSygKXflTpWwfwbW41/GK60jrMSLHBBOyBlip+NxSn0CCfdoH56NhUVKgzZ1PIIirGt4
         Li3ENnioL9Wx5keX0ho5aLlko495l3gU+HfcTub3RjDRFP6azw6gmUTN6UQ7sXEKpvid
         FWD2syhMuVjjTEMRQzITi+PvOy81wmhuzopJz1x852gMU+tyobGVzXLi5oFoAG0fls+J
         CHLA==
X-Gm-Message-State: APjAAAXjXMNuSg+MSdSYff0BY/MJDlV4JcLEpmyfPajGi7CjNjCWtP3T
        D+8XRohAipHmU19n8BPsp5eQGrTX
X-Google-Smtp-Source: APXvYqxcKzywXTdd/xrePiyHkHcG1jmH3ML53n/X3fn2/KlcZOwsoZgYaCE4PtMBcXS7Lm6w0WyABw==
X-Received: by 2002:a63:4961:: with SMTP id y33mr4708437pgk.264.1574272095978;
        Wed, 20 Nov 2019 09:48:15 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y24sm32230522pfr.116.2019.11.20.09.48.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 09:48:15 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 00/16] octeontx2-af: SSO, TIM HW blocks and other config support
Date:   Wed, 20 Nov 2019 23:17:50 +0530
Message-Id: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

SO HW block provides packet (or work) queueing, scheduling and
synchronization. Also supports priorities and ordering. TIM or the
timer HW block enables software to schedule SSO work for a future time.

This patch series adds support for SSO and TIM HW blocks, enables them
to be configured and used by RVU PF/VF devices or drivers.

Also added support for
- Backpressure configuration.
- Pause frames or flow control enabling/disabling.
- Added a shared data structure between firmware and RVU admin function
  (AF) which will be used to get static information like interface MAC
  addresses, link modes, speeds, autoneg support etc.
- FEC (Forward error correction) config support for CGX.
- Retrieve FEC stats, PHY EEPROM etc from firmware
- Retrieving CGX LMAC info and to toggle it.
- Added debug prints for each of error interrupts raised by NIX,
  NPA and SSO blocks. These will help in identifying configuration
  and underlying HW functionality issues.

Changes from v2:
   * Added documentation to give a high level overview of HW and
     different drivers which will be upstreamed and how they interact.
   * Fixed white space issues.
      - Sugested by Jakub Kicinski

Changes from v1:
   * Made changes to TIM HW block support patch to use
      generic API to get HW ticks.
   * Removed inline keyword
     - Suggested by David Miller.
   * Fixed sparse warnings
     - Reported by Kbuild test robot.

Andrew Pinski (1):
  octeontx2-af: Add TIM unit support.

Christina Jacob (1):
  octeontx2-af: Support to get CGX link info like current speed, fec etc

Geetha sowjanya (2):
  octeontx2-af: Interface backpressure configuration support
  octeontx2-af: Ingress and egress pause frame configuration

Jerin Jacob (2):
  octeontx2-af: add debug msgs for NPA block errors
  octeontx2-af: add debug msgs for NIX block errors

Kiran Kumar K (1):
  octeontx2-af: NPC Tx parsed data key extraction profile

Linu Cherian (1):
  octeontx2-af: Add support for importing firmware data

Pavan Nikhilesh (3):
  octeontx2-af: Config support for per HWGRP thresholds
  octeontx2-af: add debug msgs for SSO block errors
  octeontx2-af: add debugfs support for sso

Radha Mohan Chintakuntla (1):
  octeontx2-af: Add SSO unit support to the AF driver

Subbaraya Sundeep (1):
  octeontx2-af: verify ingress channel in MCAM entry

Sunil Goutham (3):
  octeontx2-af: Cleanup CGX config permission checks
  octeontx2-af: Set discovery ID for RVUM block
  Documentation: net: octeontx2: Add RVU HW and drivers overview.

 Documentation/networking/device_drivers/index.rst  |    1 +
 .../device_drivers/marvell/octeontx2.rst           |  162 +
 .../marvell/resource_virtualization_unit.svg       | 3297 ++++++++++++++++++++
 MAINTAINERS                                        |    1 +
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  434 ++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   26 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |   78 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  322 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  197 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   72 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  178 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  699 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  388 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |  243 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  282 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  192 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_sso.c    | 1146 +++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   44 +
 .../net/ethernet/marvell/octeontx2/af/rvu_tim.c    |  322 ++
 20 files changed, 7950 insertions(+), 137 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/marvell/octeontx2.rst
 create mode 100644 Documentation/networking/device_drivers/marvell/resource_virtualization_unit.svg
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_tim.c

-- 
2.7.4

