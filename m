Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01815453EED
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhKQDc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbhKQDc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 22:32:26 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75FEC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:28 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso1316906pjb.0
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OzLXpL1lbULPhH3JAAd9MG2bk81Om3cVeA45J1Nibc=;
        b=NrZvpt/D1sK0cL6mp+E3rADwEB7hWZKqdkrf34W/y3UsGCwSM6rXG9h5l7JUMh2vYr
         DLP91AgS7yqvOukw8LWg+EJBas84wJeAuU6BB2fjs6f7LmsPqwyookF07dNJ2GNtaU4I
         2zi22kFnDcP71b7fxnVZKEpIKDrzPVfMYNpyt4vb2ydycdjozDOP1s9ey0VghZ0K+M08
         tLuXnlYq4yPIHKPc8gYYMv9US0h8YK+oI4dna8GVE5bd8/A9Xpfn1efUlNF59kb15XEg
         yNYiYQPFC0l66A5xVOzSnJop+PkY/lus125LGZz4rYqWt2W8x0Iyrd/v/nHAZXq2aH25
         wyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OzLXpL1lbULPhH3JAAd9MG2bk81Om3cVeA45J1Nibc=;
        b=TSb1ucYWdbqZ4+c1CtNhLYz8Ruw8xB4TX5INBS28vnZVf1BI1DI1mv4bDQs1u6KA9D
         Rolpn2nYxoJ8Dz/cHEMvXAfohm6g3/U+NQcGuRkADIYn4pfynQW2BzJBOd71LrZVS7rf
         A2zx1O1BVxoAs6rjRz+cZpQZBay58owFgMeQJLtELzZEaVYvHqj83d4Kaf8i0vMEDyR9
         alY5C0nKVwUpGMnBf7dC22VLK/YaLVYspGLB/AZIxcti4wxiPvoj+WzniOiTeK2tBGXR
         4pWpEwPXW3Cr+lnhyA4VOKzoypxYiwxg2xJ9sanVEIdp+x+DWK19XOwtA+6nrcwClCyC
         72gA==
X-Gm-Message-State: AOAM532dU8TmPJ4F6E8EY6I+LGTEG8ioLU/XM9OHooElLvKqAzUD0rba
        SUmMBbORMQZj3JGMoIKtfyg=
X-Google-Smtp-Source: ABdhPJy819YHTvGaCYCb9DUP89Zqk/SCqpf2AwnEpECXrhkp9xCu3qsKbODhDypYO0MsOG2Rryuv0Q==
X-Received: by 2002:a17:90b:3890:: with SMTP id mu16mr5578601pjb.73.1637119768316;
        Tue, 16 Nov 2021 19:29:28 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bea:143e:3360:c708])
        by smtp.gmail.com with ESMTPSA id mi18sm4042394pjb.13.2021.11.16.19.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 19:29:27 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/4] net: make dev_watchdog() less intrusive
Date:   Tue, 16 Nov 2021 19:29:20 -0800
Message-Id: <20211117032924.1740327-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

dev_watchdog() is used on many NIC to periodically monitor TX queues
to detect hangs.

Problem is : It stops all queues, then check them, then 'unfreeze' them.

Not only this stops feeding the NIC, it also migrates all qdiscs
to be serviced on the cpu calling netif_tx_unlock(), causing
a potential latency artifact.

With many TX queues, this is becoming more visible.

Eric Dumazet (4):
  net: use an atomic_long_t for queue->trans_timeout
  net: annotate accesses to queue->trans_start
  net: do not inline netif_tx_lock()/netif_tx_unlock()
  net: no longer stop all TX queues in dev_watchdog()

 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 drivers/net/ethernet/atheros/ag71xx.c         |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  4 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  4 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/virtio_net.c                      |  2 +-
 drivers/net/wireless/marvell/mwifiex/init.c   |  2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c     |  2 +-
 include/linux/netdevice.h                     | 57 +++++----------
 net/core/net-sysfs.c                          |  6 +-
 net/sched/sch_generic.c                       | 69 ++++++++++++++++---
 15 files changed, 94 insertions(+), 70 deletions(-)

-- 
2.34.0.rc1.387.gb447b232ab-goog

