Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0871022D1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfKSLRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:17:51 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:38352 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSLRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:17:51 -0500
Received: by mail-pf1-f178.google.com with SMTP id c13so12019785pfp.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 03:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gZqlFeQuksRWCkgT+MlJdoryCyEyyb2EGknttFWwbp8=;
        b=uhMcH4qtoAWKIkT2yFRGuKC3jF019c+gc4OhPmeiwE1zcK/mpBa0ONgkwhne6PJ1tA
         Wh+cGwEEjmvqsPRxqzs9x7P0h/ldRKtjpZIgUwBaDxMWNc0GqrskNqwzGdv5qcB81kya
         gGkmjKrUTnJfOze8aydpEovIKg9uVpPPtDUSJN41DNt+fgvRkQbvE/npDJRHsBHYFQ/2
         tygjxFkzISeUMWNRvquo9tplGPUVtuY0OnGiZ3RGMlx2XmmOVu2zcnMmV23eWCcXHKvf
         uvuqpdsyX/OlLjwmEPuJv/Jk7HZk34SosCXhhvFIU2LzAbTDeBd8PTrSzzD/XhY3YZ6p
         vjNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gZqlFeQuksRWCkgT+MlJdoryCyEyyb2EGknttFWwbp8=;
        b=Aq1rM+HWH/QA6WWe2U7Lv1DJg5hMYn+LsC/tget7wDNXGanVOOIQHsa+uaFKBuRIp9
         HwDjFntmJO9i53SafohI9r0U5o6v6ISwImmhSRPL/abIk9HbjwkIJ0arAEmQqj9opIf/
         7kbcdTibLoqzM3+a3ByCnvu58tNBcGn2g64FulxKMVk5a7JTJqhNdtwiRo0Ag+LMkVBB
         xvO0TuyCDDPtcPY5wDYZpxK3GRz0WKG6L0PQp0iZ2aJm5/KipIE8VPje7PbZYHHjSpPv
         xVoIGbl3OqZNO9SDmcRaPUvqVa17SLdDlrkxoDOkA/+l0f6Z2dCRSj+74D9CLhvfrXqI
         nGWw==
X-Gm-Message-State: APjAAAUZXtZ0dAeiFCqoI7hB4G/WHlGmhiGBtN26umRVE+LYN6fg22oP
        4kozWb/0Kn5/B+2xDHojAp2hRBOv+TE=
X-Google-Smtp-Source: APXvYqzIQZWRmd8BbKp8WRBN3Eh6IDE7xiVT1/QzulaG0oLuM5SAPthE2Dx/5K47KK01lhe7osZlbg==
X-Received: by 2002:a62:5216:: with SMTP id g22mr4978736pfb.78.1574162270179;
        Tue, 19 Nov 2019 03:17:50 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id 6sm25918453pfy.43.2019.11.19.03.17.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Nov 2019 03:17:49 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 00/15] octeontx2-af: SSO, TIM HW blocks and other config support
Date:   Tue, 19 Nov 2019 16:47:24 +0530
Message-Id: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

SSO HW block provides packet (or work) queueing, scheduling and
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

Sunil Goutham (2):
  octeontx2-af: Cleanup CGX config permission checks
  octeontx2-af: Set discovery ID for RVUM block

 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  434 +++++++-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   26 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |   78 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  322 +++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  197 +++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   72 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  178 ++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  699 ++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  388 ++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |  243 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  282 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  192 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_sso.c    | 1146 ++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   44 +
 .../net/ethernet/marvell/octeontx2/af/rvu_tim.c    |  322 ++++++
 16 files changed, 4489 insertions(+), 137 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_tim.c

-- 
2.7.4

