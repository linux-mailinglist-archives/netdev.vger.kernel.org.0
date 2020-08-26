Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7551625351A
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgHZQm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgHZQmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:42:23 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE75C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:22 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh1so1150243plb.12
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 09:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=wI04vQSA/1MyrjugkR/vsy4vDl47Fzlpi3lu9vqjRxQ=;
        b=v9JvaDF3u8PdqJooUf0BrevJJACBATt3o91UhMENzDr5jJYJBfurcPkeJI6ccGz6Z9
         NofUPLUpdexAXPAZov+7JVYS2AeKY34vV0OX31XkkPkQLQvXvlxIm0OCP6L+6/crxRpN
         XdzLuq4QS5rM14+pUHYs9CB0MkSmXBIfiI1Og6UznPg63q27w3OfrJlRzLPo4EGbwD8I
         4rpSJgJvF68N1PhMmUzfF1zJWPUVuRIDrIGapIo7dZmJJcpTbyiW5mC0BmLjf9gqhoWz
         PiJT9g0y/Kurye5YPSgcvoPDW8cvcHgsRNAcmGUQFyZq66jeYYe8mqegh4t+g27zmqNJ
         hR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wI04vQSA/1MyrjugkR/vsy4vDl47Fzlpi3lu9vqjRxQ=;
        b=eKJllLjSQQOVajYbJq5WrdHy16FpOrcD6bYNYtccYSjGSj71Rc+TUgJ0eIF1DeRlEk
         SaEEo0o15/ActnqMrGW+YiC4a0FK2ZzGNbnYq9ijfavQVu/UzVxFPJlDrQ/Psva1UVc7
         cVFhW0iB3bSbjXSyw1vBrrDdPVoMrZQSYAE+bHp9vo0BxF2w8hkFtR2yyc1I9tOo8IP1
         2939L/mBegi445JWz2n2CfpZnS38MpUqrmnqOHT7Uv/4ZdOSkL4evszgzc0x2srUcWx4
         LRTOW1QvDrgHLpo5oJTFVDkMbn9IlFVdncmofYWftE4w7yOAU9uEwGDNak02b+cr7DWW
         MTYw==
X-Gm-Message-State: AOAM533Xiy7wDYqiVzbIgw5R0fWYg8MplEeznckp1o+afwEPE4rq3vA6
        iCuPnrJY/ZPl1Cn00hyj/GPF5jG/cufQYw==
X-Google-Smtp-Source: ABdhPJwOftV8JtxByC7y8ENtNBp90EAly44rD5CHLCf0gYh+2jMMppEJijwzchKz+Xk6RAQ+1C+C/Q==
X-Received: by 2002:a17:90a:450d:: with SMTP id u13mr6435587pjg.99.1598460142042;
        Wed, 26 Aug 2020 09:42:22 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h193sm2986052pgc.42.2020.08.26.09.42.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Aug 2020 09:42:21 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 00/12] ionic memory usage rework
Date:   Wed, 26 Aug 2020 09:42:02 -0700
Message-Id: <20200826164214.31792-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous review comments have suggested [1],[2] that this driver
needs to rework how queue resources are managed and reconfigured
so that we don't do a full driver reset and to better handle
potential allocation failures.  This patchset is intended to
address those comments.

The first few patches clean some general issues and
simplify some of the memory structures.  The last 4 patches
specifically address queue parameter changes without a full
ionic_stop()/ionic_open().

[1] https://lore.kernel.org/netdev/20200706103305.182bd727@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
[2] https://lore.kernel.org/netdev/20200724.194417.2151242753657227232.davem@davemloft.net/

Shannon Nelson (12):
  ionic: set MTU floor at ETH_MIN_MTU
  ionic: fix up a couple of debug strings
  ionic: use kcalloc for new arrays
  ionic: remove lif list concept
  ionic: rework and simplify handling of the queue stats block
  ionic: clean up unnecessary non-static functions
  ionic: reduce contiguous memory allocation requirement
  ionic: use index not pointer for queue tracking
  ionic: change mtu without full queue rebuild
  ionic: change the descriptor ring length without full reset
  ionic: change queue count with no reset
  ionic: pull reset_queues into tx_timeout handler

 drivers/net/ethernet/pensando/ionic/ionic.h   |   4 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  32 +-
 .../ethernet/pensando/ionic/ionic_debugfs.c   |  29 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  46 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  49 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |   2 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 127 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 793 +++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  94 ++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  26 +-
 .../net/ethernet/pensando/ionic/ionic_stats.c |  48 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  82 +-
 12 files changed, 800 insertions(+), 532 deletions(-)

-- 
2.17.1

