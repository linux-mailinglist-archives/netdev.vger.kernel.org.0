Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A4226D172
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgIQDIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgIQDIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 23:08:07 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9709C061355
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:13 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d19so361840pld.0
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 20:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=y3iIlKq/pnnbVvM61zgnvZl54pIzQmA9YD7RgieevAM=;
        b=480BFvns9Djwe2d6G++Vfjxt0Ht+/QvnwH3j/bdIIxzAa7FZPi1rLGyyxv78DM6JMn
         GPvqx0QByl2NF0oolvd31a/+O7LTsE5EQyoNunNfz3NTTnCUR7hRDbdfvY2xnTcZjuZG
         wssf9DO/MD5SCBsmucnSkL6DSqu07dIUYy9gCLLbwYmaWp8UgNOJ8o6h4WmuuakdJf3g
         /A6vbb1reWSCz9lTw9FIIREnk6Nx0+xY3/POMOvEfDL9IMTFFcvUICBKihwP/A+APjon
         /D/DSLXmHe14ny3ICjda48H+EHfEHVWS+mblJVcfdANRSzi/Ei4LsLwN1HOSnC8hGPQH
         ctpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=y3iIlKq/pnnbVvM61zgnvZl54pIzQmA9YD7RgieevAM=;
        b=L7+EbivQ/NbHiUu0o0pOySVkFCZLbJP+zS/v07LUGq/4/dlSKBYBrgk06S4HThAYje
         p7AnzT1LEbgOYwuHLKZ+yIkyiOxhQIWtPAmbejvmBEg6gjTPQ1DX3f8yVMVqb5lRvB9M
         cqrS7hMzMtfkNekoqlUeE5HedMEdzwtzquheekxeUErfcm4WpULJaNfh4RApqrguvSK4
         mOa0QunMBnxxm3U3u1dkFV1UmzdNs1KvlfqXjFNVHD/VFcPClcHelN1M/v9y3htw+26Z
         Em33JFaMWw1dxuLeSdRsS5L7SrxSbiy95D2P9gXhVY7VBNT4PJ9scqMKvPwFZxfOf97V
         NCgQ==
X-Gm-Message-State: AOAM530I2PIzsKV8e9mKbiR86obPD70yl+TS+42ZQENC8+48q8o5a+ut
        AIAQ2D+Om0ZzrjCMny/TJ/AIkpQmA50VcQ==
X-Google-Smtp-Source: ABdhPJx2gE/mQqMW63vBi5Sq50vF9YV4hVTMYMx1onLAhc1MEup7kOhSZaA4oQRfbsuiCu8aI+7OZw==
X-Received: by 2002:a17:902:c14b:b029:d1:ec9a:aaae with SMTP id 11-20020a170902c14bb02900d1ec9aaaaemr6126523plj.62.1600311732614;
        Wed, 16 Sep 2020 20:02:12 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id b2sm12072498pfp.3.2020.09.16.20.02.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 20:02:11 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 0/5] ionic: add devlink dev flash support
Date:   Wed, 16 Sep 2020 20:01:59 -0700
Message-Id: <20200917030204.50098-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for using devlink's dev flash facility to update the
firmware on an ionic device, and add a new timeout parameter to the
devlink flash netlink message.

For long-running flash commands, we add a timeout element to the dev
flash notify message in order for a userland utility to display a timeout
deadline to the user.  This allows the userland utility to display a
count down to the user when a firmware update action is otherwise going
to go for ahile without any updates.  An example use is added to the
netdevsim module.

The ionic driver uses this timeout element in its new flash function.
The driver uses a simple model of pushing the firmware file to the NIC,
asking the NIC to unpack and install the file into the device, and then
selecting it for the next boot.  If any of these steps fail, the whole
transaction is failed.  A couple of the steps can take a long time,
so we use the timeout status message rather than faking it with bogus
done/total messages.

The driver doesn't currently support doing these steps individually.
In the future we want to be able to list the FW that is installed and
selectable but we don't yet have the API to fully support that.

v4: Added a new devlink status notify message for showing timeout
    information, and modified the ionic fw update to use it for its long
    running firmware commands.

v3: Changed long dev_cmd timeout on status check calls to a loop around
    calls with a normal timeout, which allows for more intermediate log
    messaging when in a long wait, and for letting other threads run
    dev_cmds if waiting.

v2: Changed "Activate" to "Select" in status messages.

Shannon Nelson (5):
  devlink: add timeout information to status_notify
  devlink: collect flash notify params into a struct
  netdevsim: devlink flash timeout message
  ionic: update the fw update api
  ionic: add devlink firmware update

 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |  14 ++
 .../ethernet/pensando/ionic/ionic_devlink.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_fw.c    | 206 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_if.h    |  33 ++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  27 ++-
 drivers/net/netdevsim/dev.c                   |   2 +
 include/net/devlink.h                         |  25 +++
 include/uapi/linux/devlink.h                  |   3 +
 net/core/devlink.c                            |  83 ++++---
 10 files changed, 350 insertions(+), 48 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_fw.c

-- 
2.17.1

