Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD5341F336
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354056AbhJARkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhJARkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:40:11 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EA0C061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:38:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b22so6784449pls.1
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=q/6Ivd02PJ6YswDyabcOB7q0mwE16m5P9ciiMzHVL1U=;
        b=CZKl/MAkQ03AaEWuT4jsQjiGppNVTcpWIZXrxM7ZOCqypfJIzi40smvtQcMzioBput
         zKKGij3fI7wVovouBHfwEMoE3KDJL4fINmnMPsNyNkHAHfA89B8PanMnrEb11Dbi3yaJ
         gFPY/+ducWu7GK5LaZ38rbVVg35MqmdWfOKAhCnNSdu7juFSj/oN7F7uGUKsRhPmYyeO
         qUgwji4oSZdwDuGPhEf1GWtvGwKy6IKdTX9DMgR8UVmKNLhL+QH3XG9S/HfTaPJO0hCG
         T5X+HK0z3+3x0KfvYPvEviWP+raZhOrjd88GMSRm/W81a8ht18BwB3e5RAHveW34L3cL
         d50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=q/6Ivd02PJ6YswDyabcOB7q0mwE16m5P9ciiMzHVL1U=;
        b=fvRDA7RKFYn/i2Hvg3q08AVkoK1UJ+2iCJleSmcdkV8ghgCX9CstjQ6/FsVgIyPPrr
         DT8Mu7RsEFdERJlcJ4d1y0f1R25+fD6HOCtSM8+zTEhJTn3gexyVHjH3BWRdWGOeMaxa
         pCk2H8nt2yUeVlgX6cSdooOPvUib2on9B7YfBTYr6hzPUVx6mtkULF1QL5rdhOVNb0Cz
         +WNs5YGrKsK1F85xZJFeTmJLXr4zWrxy2aEN5Gm5bA/2ipYjo0XZH0xt1hqJjj/RlKSU
         IszNBftb5CBvhnFl+fQFtlGKmT43snXhsSMhb+Qs2xG/ciaayudipDFQup/gK4dnyXre
         k5hg==
X-Gm-Message-State: AOAM532ms0ekvSLM30NS6vZMhOx0H7qK9g3miNL5Ru//Hf7At7aWHmug
        5zwvAuxP4elZwwob3GcLZGUIRg==
X-Google-Smtp-Source: ABdhPJykvixwbS4ul0JQE06Gmk+kWDo/RRs+i+Al6uRlAkHDy+5ir1HniKXPPJ5O2bd71tiicaHobw==
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr14464606pjl.19.1633109906508;
        Fri, 01 Oct 2021 10:38:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 26sm7854462pgx.72.2021.10.01.10.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:38:26 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/7] ionic: housekeeping updates
Date:   Fri,  1 Oct 2021 10:37:51 -0700
Message-Id: <20211001173758.22072-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few changes for code clean up and a couple
more lock management tweaks.

Shannon Nelson (7):
  ionic: remove debug stats
  ionic: check for binary values in FW ver string
  ionic: move lif mutex setup and delete
  ionic: widen queue_lock use around lif init and deinit
  ionic: add polling to adminq wait
  ionic: have ionic_qcq_disable decide on sending to hardware
  ionic: add lif param to ionic_qcq_disable

 drivers/net/ethernet/pensando/ionic/ionic.h   |   1 +
 .../ethernet/pensando/ionic/ionic_debugfs.c   |   2 -
 .../net/ethernet/pensando/ionic/ionic_dev.c   |   1 -
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   4 -
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  38 -----
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  74 ++++++----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  45 ------
 .../net/ethernet/pensando/ionic/ionic_main.c  |  53 +++++--
 .../net/ethernet/pensando/ionic/ionic_stats.c | 130 ------------------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  14 --
 10 files changed, 89 insertions(+), 273 deletions(-)

-- 
2.17.1

