Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E1CF7EFC
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbfKKSi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:38:26 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36322 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbfKKSiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:38:25 -0500
Received: by mail-pl1-f196.google.com with SMTP id d7so6249173pls.3
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fJokKN/kqj9P4bkNlR78VGRGCEeWbWy9Ft5png3CrC0=;
        b=IDE32DyQgKMK5iSJBGz6Fm//X4n+aWHqXbSBxFRlfqzjwiCejwtApf/lMKCL7nn/VP
         oMWTvuobAi7FkyWRmv10hWjsFUTz4XztPgImoGNQBzDjgovx6JwCvo4naeBkaxSD4CBT
         fk6MFfwBGnWPoXHRwod1xvgZPQUSKuj8tN2HFNwpm5DRep5bZGQyZEPELm76zii4jkkI
         lNfwQxa0aTQWsTdoDPL+dPQJndcoeytPNHSgf/U7IqivYP+yqryZiWYysg5baGcMM/Xn
         /R9ia2f37fCPa3Z5OdX23gbhD9iBbNRYaOu9Ct72KpTpNc3YCY+R1ss9RDzl/p9OHn1o
         Phww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fJokKN/kqj9P4bkNlR78VGRGCEeWbWy9Ft5png3CrC0=;
        b=ON+LzD1iKiv6IvdTLCFrmnYqyhr1y5SnEFWfl0Ink1KzYGCz65TevUQmLMgk3bCjwh
         SOCZPuEPXw3boUgUswu0d3UpXvs8EaC3/+3OBAjaTjZj0VOc9fMNv2H5wZm4GBc6NX5u
         oEv80ZhAToWrebLke7/65FtRC5dHcgmpanP+F5rvXiUQtNrbJAg6FbaIVKoWZBfpnRZN
         7nHuo5RXmIwxxLZP0BgUX7QakO3FDZeE/WTitBy7l9QtQPVY4PBtEA5xn9JsvMXbuUY9
         kzSH4dSP2P5DRYznMQaYHixQd0a74slI6/4p7vrZ+gJylQxqOSWpIzDnP3f63WyGcBqX
         NUBw==
X-Gm-Message-State: APjAAAW8MM9dg0U01UdStjosU3zMmdkCigQ+BAvedOlIrHaHmcOggbjg
        QkhT/hhXtgl/RKKDMLuf6vVi0kW1LeI=
X-Google-Smtp-Source: APXvYqyYtvRJgw3muyNhRm2c9aB5TW6TEjODbGnapvDaJOi8JgcCr0/h+zOgCiH5rnzb52hkUWUkzw==
X-Received: by 2002:a17:902:6b0a:: with SMTP id o10mr20416814plk.15.1573497504441;
        Mon, 11 Nov 2019 10:38:24 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id b5sm16921762pfp.149.2019.11.11.10.38.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 10:38:23 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 00/18] octeontx-af: Debugfs support and updates to parser profile
Date:   Tue, 12 Nov 2019 00:07:56 +0530
Message-Id: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
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
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   125 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  1711 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   876 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |    55 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   187 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |    28 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |    36 +-
 18 files changed, 14256 insertions(+), 4352 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c

-- 
2.7.4

