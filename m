Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF45EFBF95
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKNF0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:26:53 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:37372 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfKNF0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:26:52 -0500
Received: by mail-pf1-f178.google.com with SMTP id p24so3351607pfn.4
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kz8Op0Gg/wiZosjBel4t4ycJqud2ZUjPFQfEyvmes9w=;
        b=enTQ91pBXa2zuqat7d9F6MyKR5N5S+4c7pqmJK5zANRePp/an909VT8u6ZnM8kEvHN
         80yJIZdqDiZ2Fx+qL0wnKhAoWoSUkPgRBbDykphnlddEmGViB0ZSy8brYXzp4nOXSizN
         2gOoXRC5CZHjtiQkoYK18YqN/JbH7xJslirMjxmvYGdudfLxmmJCukV3AxixkXM4KV+4
         9olyK4DV/hP+5HTiNNqq0IMzH12JdDx7ZTfqxnAkekoOEhYe1fX+xDncUbfIAJQUivmc
         yVD85I3CxttetitJRBv7Dd/+FciL0sO6b4DlE6HETHI5w0zQwDuIR7BlWpbWRBBMNgbF
         FOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kz8Op0Gg/wiZosjBel4t4ycJqud2ZUjPFQfEyvmes9w=;
        b=oFUBknKHuPpoFLHnM13XfQERaU7E+wq36DXz7gwQ0WBPuuYp96zwVhuwWGaYmN844D
         O/HN0EfQQXA8n1r4Me4ya5VBvYtQIxRNhZZbpmxJPn7TmnZro13r6oJRWL32OATimB0C
         0sXwf7rqKgRyZtlmKc1ymArfPbAsfSy82cOfQCYZWjG7bpC1JIMf75ZjJvGgRFxJ3sYu
         FgiRhn4Ls69a8E0vv3/qUcPhuVLf+6xaOCkVc99ROC/nuCd/m0WJuBJUf0wX7MZBOnCB
         Wbjn33oCp/VAmM/c45h3sbDwDFZchqZnvJHcNaWhcBWcKHpC5WVGtgkzokmB+42M9Mvi
         bekw==
X-Gm-Message-State: APjAAAWLaXSZFaiMYjqrHXFR1zi0dit/MDHg2sX2/IKGwFo8LoNO3Ods
        A7wxxGo65+1kqgq3djN3zCeblgAn5C0=
X-Google-Smtp-Source: APXvYqw1twEB7LSUCEdtobtunhwvBlir5Xl63Ool5xuuIKsusHIn2tIEJGDCX8CAHDqnYhdTLxxp1Q==
X-Received: by 2002:aa7:9467:: with SMTP id t7mr9023355pfq.142.1573709211647;
        Wed, 13 Nov 2019 21:26:51 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.26.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:26:50 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 00/18] octeontx2-af: Debugfs support and updates to parser profile
Date:   Thu, 14 Nov 2019 10:56:15 +0530
Message-Id: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patchset adds debugfs support to dump various HW state machine info
which helps in debugging issues. Info includes 
- Current queue context, stats, resource utilization etc
- MCAM entry utilization, miss and pkt drop counter
- CGX ingress and egress stats
- Current RVU block allocation status
- etc.

Rest patches has changes wrt
- Updated packet parsing profile for parsing more protocols.
- RSS algorithms to include inner protocols while generating hash
- Handle current version of silicon's limitations wrt shaping, coloring
  and fixed mapping of transmit limiter queue's configuration.
- Enable broadcast packet replication to PF and it's VFs.
- Support for configurable NDC cache waymask
- etc

Changes from v1:
   Removed inline keyword for newly introduced APIs in few patches.
   - Suggested by David Miller.

Christina Jacob (2):
  octeontx2-af: Dump current resource provisioning status
  octeontx2-af: Add NPA aura and pool contexts to debugfs

Geetha sowjanya (2):
  octeontx2-af: Sync hw mbox with bounce buffer.
  octeontx2-af: Support configurable NDC cache way_mask

Hao Zheng (1):
  octeontx2-af: Update NPC KPU packet parsing profile

Kiran Kumar K (1):
  octeontx2-af: Add more RSS algorithms

Linu Cherian (1):
  octeontx2-af: Add per CGX port level NIX Rx/Tx counters

Nithin Dabilpuram (1):
  octeontx2-af: Clear NPC MCAM entries before update

Prakash Brahmajyosyula (3):
  octeontx2-af: Add NIX RQ, SQ and CQ contexts to debugfs
  octeontx2-af: Add NDC block stats to debugfs.
  octeontx2-af: Add CGX LMAC stats to debugfs

Subbaraya Sundeep (2):
  octeontx2-af: Add macro to generate mbox handlers declarations
  octeontx2-af: Start/Stop traffic in CGX along with NPC

Sunil Goutham (5):
  octeontx2-af: Add NPC MCAM entry allocation status to debugfs
  octeontx2-af: Add mbox API to validate all responses
  octeontx2-af: Support fixed transmit scheduler topology
  octeontx2-af: Enable broadcast packet replication
  octeontx2-af: Add option to disable dynamic entry caching in NDC

 drivers/net/ethernet/marvell/octeontx2/Kconfig     |    10 +
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |     2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |    60 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    13 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |    16 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |    87 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |    28 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |    95 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    | 14946 ++++++++++++++-----
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   116 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   217 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   129 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  1711 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   876 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |    55 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   187 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |    28 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |    36 +-
 18 files changed, 14258 insertions(+), 4354 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c

-- 
2.7.4

