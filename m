Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC0C258471
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 01:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgHaXgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 19:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgHaXgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 19:36:07 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F84CC061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:07 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 31so1598264pgy.13
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 16:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=toZNVi8bWxv2zIdez96NhALKyrgWXeVd5Cx+MkjqPEc=;
        b=S0tgg0mAu7Numu4yHHX/WOrt/Z6FoA1cncmtaKVjb+Uru/bVzEE5YbbbekAI4CxT0C
         YaQsmQ1xa48G8kTTsQT8HDX+DEbSzAnHRU2G2gqnyndF8U6dBVpYPeCnMuYPV6WwCky6
         yzXWM6woXL0svpqYvLI4lDAoyzE0PpaYk72IrGQ645OfHlE4nRYEkeS17PAVz7IF64jW
         coek8/BgFakRHR9NTKpurcsgz7UWRQ8JWO7LKD2cgJXj9vL6L/PYTRraiKQkplTpUl8X
         HFVZtb4W+FgmdcLg/O9Zzb/jqSoRgBvBSbg5VUNA8rVq1GCVhFDanKZNeNW3uaB77qsA
         V3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=toZNVi8bWxv2zIdez96NhALKyrgWXeVd5Cx+MkjqPEc=;
        b=K9mEyBpIGmWnc9A4u0mPPKFjMCUxNIcnUaMI7lV+OS+7T19kg79fF0Wv2Ob462NiKA
         lboS3x7Rqi3D1NwtNbN7YUBehGE1gueawR/FQ1g9ONxj5SezaNIs9D31ayLdegDnGK/d
         P1bjLSl/30IY0gI17fjTLffvoUC2J+Pu2PyT8uIVikcVZynbphkz3XqHU3jpqNdFbPGK
         v5/1p/5ZAL35/DtiYyQL1mobnmBewIHf5ePGQDp0QVFzJjmj+7IH3T7CQNLgDeqN1BEv
         z0jZkNKcjdu5GQWXdQkTb2Zw/RLnqS9G4zemhq5Q8agYL7N5bLQOOMLmD8AJDcYr25FX
         PvwA==
X-Gm-Message-State: AOAM531Bkn2BEtomQYkyBjpCRZkGxkXmwRwkmmmmf3av+5AYhp6z2JVU
        VB0mKJrXkpLoj3lC1ngFmiY0fenYZs4wGQ==
X-Google-Smtp-Source: ABdhPJwEUMLZhs8nf//NzzdUk2QpgrMrLTJyRv49s4O6HJWJka2mxW5S4AqNXqh4Ce4mlid4XTQcKQ==
X-Received: by 2002:a65:6545:: with SMTP id a5mr3191430pgw.43.1598916966119;
        Mon, 31 Aug 2020 16:36:06 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 65sm9082651pfx.104.2020.08.31.16.36.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Aug 2020 16:36:05 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/5] ionic: struct cleanups
Date:   Mon, 31 Aug 2020 16:35:53 -0700
Message-Id: <20200831233558.71417-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset has a few changes for better cacheline use,
to cleanup a page handling API, and to streamline the
Adminq/Notifyq queue handling.

Shannon Nelson (5):
  ionic: clean up page handling code
  ionic: smaller coalesce default
  ionic: struct reorder for faster access
  ionic: clean up desc_info and cq_info structs
  ionic: clean adminq service routine

 drivers/net/ethernet/pensando/ionic/ionic.h   |  3 -
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 33 +-------
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 26 +++---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 44 +++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.h   | 14 ++--
 .../net/ethernet/pensando/ionic/ionic_main.c  | 26 ------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 81 +++++++++++--------
 7 files changed, 92 insertions(+), 135 deletions(-)

-- 
2.17.1

