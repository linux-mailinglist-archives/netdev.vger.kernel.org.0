Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAE6FFAA8
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfKQQOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:14:37 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:39486 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfKQQOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:14:36 -0500
Received: by mail-pl1-f172.google.com with SMTP id o9so8229918plk.6
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 08:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iB+H/ta8HgeyfVt9HLJZo6FP51dcMmywzGnvEAq4eww=;
        b=C0GM6INcgwHUJ9PC4gWnG1C+/KWm4zlL73OYLwv19YgT52CL8NYnTxtsHZCeAcZ8ka
         hAVVrCCBW28G209kXJKuRtdwHNDltdiRRnAcNASDIIw7mz6o7IyCy9GdPh8iWbSiMZzb
         aCYRnKsnx7NgEm+Uzg8MW7c4nj0TKeS0mim9jhJcqpd//OsyAYcMWihPPLJgEwTBkLTe
         HJdldxUrLBi9rez0dzes8A46nldEO/wacbTWN6YyWMy7sdPYFxcGFN3I5e+CDDDZ4Tut
         Gb+f+fdq+1MOLNxBWNW3fZJ2ScWwfj3UEGyRuf4XS0GdAFs++3/jC+NMpzm2q+EDXgyJ
         FkSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iB+H/ta8HgeyfVt9HLJZo6FP51dcMmywzGnvEAq4eww=;
        b=aAtOJKy4NBH+KIC0eDxwYyR1QWYYwFvKkKgtU5gsQPwTGYsuwDAdNKsuG1gduZrOX5
         E5p8jOp5+F4tmR9JEp/YPJR+jOfiFYXtGyRsi/t7MrLwqgIFrsZ7h0NQrKajol9Jr3Wf
         kXyOUZXJKQngtn+AAoJPR9AtYG2l9+3VD3vINek/Q6mNpNeVo97/0EOK4pN4bAQKRYBH
         m9/1BgSUrpZ+yMH8xtgt/eXz0UaRV72blP3vSmTGHf8WxOhgA6W63pfXHkoAGYnKxbe0
         5OVKf8WA6JBAbrN5riWCPPw2r+2vIhE4DLsHj50/4XoWbWpG2tfSpxEhCZBFgw9+1xAB
         svHw==
X-Gm-Message-State: APjAAAVXaZ4mvNC26BQ4RT2ZpLubnJPuMpPbSsfWCk3lCmo4ufzZe63I
        nJUw+XSelmNomN4Ygay9YHJQFzkiWDU=
X-Google-Smtp-Source: APXvYqyaFIjy2w15GoWZUDTPMweskVlsLlGPGZbjGV8MJfBrm31wVAs9CMeal9nbloIuZoP9sOPchA==
X-Received: by 2002:a17:90a:b385:: with SMTP id e5mr34581725pjr.115.1574007274507;
        Sun, 17 Nov 2019 08:14:34 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v2sm2675231pgi.79.2019.11.17.08.14.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:14:33 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 00/15] octeontx2-af: SSO, TIM HW blocks and other config support
Date:   Sun, 17 Nov 2019 21:44:11 +0530
Message-Id: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
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
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  196 +++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   72 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  178 ++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  699 ++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  388 ++++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |  243 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  282 ++++-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  192 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_sso.c    | 1146 ++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   44 +
 .../net/ethernet/marvell/octeontx2/af/rvu_tim.c    |  341 ++++++
 16 files changed, 4507 insertions(+), 137 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_tim.c

-- 
2.7.4

