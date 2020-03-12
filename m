Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A807183BB8
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgCLVu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:50:28 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:54318 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:50:27 -0400
Received: by mail-pj1-f41.google.com with SMTP id np16so3093396pjb.4
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=3ycOyotT2gUlTXlwUIxgnZpId7Y0by9TK/mRuePO1+o=;
        b=Ewm9Afj3rVCXsETKBj9G5p2juLV44dDXHnoCR0maTHVfE4QugXklvdNd7l23DujxQ7
         XG2WH9GOEVFf9uBpzqoqR08TqgRvjwmWY7q9wr8Nz0ijA7RPb0FQT7S5TC9BGLTws0aT
         IgKq0PIWp7FvRe3lXu1P3EXR94oRM13mc7YWoaN0xnKnspv18hVwSDwUVzDViRqB0CYh
         jVWCm+NCRLbnpalXuM4q1rIjtYXGDqIlCBTfkvLCIjijy4krvDKFe+ThzLBMAETjdOV2
         qdvNz4vwehc3i+CzqF6xBVJF5XquTwlEwZXzlDQ2UYtRcCfMGve0xVc2wZngTF5WNo+H
         7Vaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3ycOyotT2gUlTXlwUIxgnZpId7Y0by9TK/mRuePO1+o=;
        b=URJrSlbxl7LmJMqL5Md2onfG8lhznt7EX0n4VI6xUJn2LalyypmdctcwHGazRBokK7
         D6uKaKtN/n1rwxLnIKzQsCjmTuJSotB54w8wOTqGF/Ja6j+rNNCbP/nTgPjrIVbXkpD/
         XY8TI4F2QkIPS4G5ubaEphtujhqjFwUQgJyzhov9YVkY6lk8MUs26ftsJ4YbSPoVA5sx
         i+n0Agq9zr1gxfY59AgG/Bl8zhcsLvolAwGboRSsE+hDPpm0BB0HHPmbTcatSL+c1pBu
         Fistr14h74/3lzDIAT9JldxiYg+dSVgMHM/b1gwbsLAMwoRudHAa/EXY1uh5UxL902Jq
         hIVw==
X-Gm-Message-State: ANhLgQ2zG2eQvur5mJKNqcqJBxbkYfpywpA3JHRkmMlsZ4H6u+cYJ+wN
        TcxsALdLiiyK2KLGdcyg4sCOuLDXVZg=
X-Google-Smtp-Source: ADFU+vvhsqLtCI1jIcPqqsjtXkS7Y/210iTTo/QARoCVf+ugph3Yjp1RtDDIv+a61AZr9Ean6vVl2A==
X-Received: by 2002:a17:902:8498:: with SMTP id c24mr9978350plo.233.1584049826367;
        Thu, 12 Mar 2020 14:50:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p2sm38281203pfb.41.2020.03.12.14.50.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Mar 2020 14:50:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/7] ionic support for firmware upgrade
Date:   Thu, 12 Mar 2020 14:50:08 -0700
Message-Id: <20200312215015.69547-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Pensando Distributed Services Card can get firmware upgrades from
the off-host centralized management suite, and can be upgraded without a
host reboot or driver reload.  This patchset sets up the support for fw
upgrade in the Linux driver.

When the upgrade begins, the DSC first brings the link down, then stops
the firmware.  The driver will notice this and quiesce itself by stopping
the queues and releasing DMA resources, then monitoring for firmware to
start back up.  When the upgrade is finished the firmware is restarted
and link is brought up, and the driver rebuilds the queues and restarts
traffic flow.  Typical link down time is around 30 seconds.

First we fix up the state machine so that we take the Tx and Rx queues
completely down and back up when we get LINK_DOWN and LINK_UP events.
Next, we attend to a few error handling details.  Lastly, we add handling
of the FW reset itself, tearing down and rebuilding the lif internals.

Depending on timing of net updates into net-next, the 4th patch may have a
minor conflict with 905fc4f8a399 ("ionic: fix vf op lock usage")

Shannon Nelson (7):
  ionic: tx and rx queues state follows link state
  ionic: keep old lif dentry
  ionic: ignore eexist on rx filter add
  ionic: add a flag for FW in reset
  ionic: remove lifs on fw reset
  ionic: trigger fw reset response on fw_status
  ionic: check for link when link down

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |   4 +
 .../ethernet/pensando/ionic/ionic_debugfs.c   |   8 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  56 +++-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   1 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  17 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 263 +++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   6 +
 .../net/ethernet/pensando/ionic/ionic_main.c  |  16 +-
 8 files changed, 296 insertions(+), 75 deletions(-)

-- 
2.17.1

