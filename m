Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FA7234C08
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgGaUPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgGaUPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 16:15:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCCEC061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 13:15:44 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c6so7916601pje.1
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 13:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1w4K2BOI7xp1MDM7cbT9QjKKmNijlmvPgOhDKIVQC+8=;
        b=SDvtutkI2z7D5e4vetVlitYaO9dWOD/xdkcPlzauvuoWNmeJosylCj47y/kAeBhfkJ
         lgwCQpFUm20F7uoKXmSurEWhscbiGbpBnb9tk26JhcqMvvFJftNifVGTvmM8Sb+yTuCv
         7Qw1crU4BkPMuaHua1lK9j3g4chkrc1tVmFCx2inCtyFITWbNUATFfXwuaEPUdKMRz7s
         q1V/r5kLTzwGsCgYkKM0m9H9uyDmRYR/ZTDo4tYA5TAo8UKVyce3KKB5RZQAJWXor5bZ
         ehmqghuAwy7J8S1TMZmUJ6ZeZeXfEflcQJ2JrPxZ/gW/2eghV1QQCUFOXchTeP9Y/bAN
         V+mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1w4K2BOI7xp1MDM7cbT9QjKKmNijlmvPgOhDKIVQC+8=;
        b=NxdkxqPRlrK3+vpwKKJsU8SLOB07mFglh03I4LMyDMDh4iODJzYkEgtqefBaHUdP3u
         4o4GJKwrnSIrAiyum86NLeu3xbYXKsthkAYIgFXBMDS1EjTgS21eRzti2CMJXEXGvoVq
         vkWa/JXB1vySQWxyXp0ngzXguUOuQb9exmXaavfnyXqqmLrVT8wW05VEoH3tjbNAto7G
         lhcmSQDU/8O4PovumIb4fdMOE+Bm0GDacpCcQ5DabSUNVe/Wj0iKvgTWJnRJay6cnW3V
         Tw3ns9zsOMjSU2NwEYEIutWfy+zb3FX6t80uJMRIWqnbu+LackU2a0gG9+mpo72ZUYSQ
         n9zQ==
X-Gm-Message-State: AOAM532dRDwrmxmL4RnecojwL8md23o19Q5W/7OuhQVQtYJPStIfx6Sq
        0+dBc08ypVhCTHpvJI7xohWVd+8q/zY=
X-Google-Smtp-Source: ABdhPJwihM9BKNWRQvYNhVrGHr4QO4sdCs6IKwiYzzcb7QusYtRk8Tp7mPGPc8jPIY/kr+mAUYX/WQ==
X-Received: by 2002:a17:90a:3645:: with SMTP id s63mr5627321pjb.30.1596226543705;
        Fri, 31 Jul 2020 13:15:43 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h1sm11470513pgn.41.2020.07.31.13.15.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2020 13:15:43 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 0/3] ionic txrx updates
Date:   Fri, 31 Jul 2020 13:15:33 -0700
Message-Id: <20200731201536.18246-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few patches to do some cleanup in the packet
handling and give us more flexibility in tuning performance
by allowing us to put Tx handling on separate interrupts
when it makes sense for particular traffic loads.

v3: simplified queue count change logging, removed unnecessary
    check for no count change
v2: dropped the original patch 2 for ringsize change
    changed the separated tx/rx interrupts to use ethtool -L

Shannon Nelson (3):
  ionic: use fewer firmware doorbells on rx fill
  ionic: tx separate servicing
  ionic: separate interrupt for Tx and Rx

 .../ethernet/pensando/ionic/ionic_ethtool.c   |  96 +++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  42 +++-
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   5 +
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 188 ++++++++++++------
 .../net/ethernet/pensando/ionic/ionic_txrx.h  |   2 +
 5 files changed, 240 insertions(+), 93 deletions(-)

-- 
2.17.1

