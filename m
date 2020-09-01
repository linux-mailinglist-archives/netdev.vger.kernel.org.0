Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81E0259DFF
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgIASUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIASUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:20:32 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A986AC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:20:31 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id j11so945565plk.9
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 11:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dMvyn+/yTpGtliky5KJiNnjhQsmcW4R6ClYIilqtMGk=;
        b=L2EOorUdiUGdxsIN+ZoaOPSHFNh53WK9N3D7AV4VlFR6CNi8p6mqNENFvIj2m/7PhA
         1fsI4wnJHXsAupu5Dy8MW/gEYkhQMO2wtItvGGKFGaIe5at4re9E0m1SZsb19+nhaq9P
         Tl6lYMyHzDHKOcuANEDzyt9PaJtDIMnk3qlWTD8nCYTrDKtjmDG+5EcZ38FmhfzKbQJZ
         QLrtChFlG4wVNraw6TAmezVKj3SH6Invy8uXyXMRkqgZooSOCnHf6Pv6g6D+XmhfUNBH
         8xJbuCJLrryWrIhQGMQjPfF0TLNZ0/SvT2FfXo+wxexAWWLoSTfZSlsPsOo/63ts/ZD8
         Pd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dMvyn+/yTpGtliky5KJiNnjhQsmcW4R6ClYIilqtMGk=;
        b=UDPp7ev0h0C29Nc8hauyeNORvJGFXVD3HcHJ+pPiyJGsvlDCGK9K9ElJWdELFcRjeo
         zCHVruryxsQKI1hr+uiZH3sSU6jiwU8PjFMd7r23wqwOD/PQ4mwXjQsMlpi6qoRZpt5w
         VV2GP98f3FCYCT8mAA0RskcqTTNRyO6e4I9bK3TyCr7Fu1McZfSHvVj2K0q5zKbPSBW4
         9GfmL7i9+0fdULq/0mVRSXccpf+2hbJHUwvGsq+zP5yHq7Qwdqfi9+9ky1mJsRAlNnCd
         Er7NFVhz0CjAzOmiRXjxX48VQoakj2txCLVa9xeEEmheLDG8ZnelTXhYOnl8x0JYF538
         oG9g==
X-Gm-Message-State: AOAM5304uEyasfN6hlgjJUyk/1KvKVNjk1B1Q4fNOXWXvZBeCdPEt+V3
        /KHWhO+XbXQ4wHcfBttfx3vjr9C5yJ/4xw==
X-Google-Smtp-Source: ABdhPJz+Gwpah95+b+IbwpIrJBplKfZiDYCDozTv3rcIPi7BNvqr3nq0a8McuqgLrarHwZ4betDXWQ==
X-Received: by 2002:a17:902:b40b:: with SMTP id x11mr2537181plr.196.1598984430867;
        Tue, 01 Sep 2020 11:20:30 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id j81sm2747086pfd.213.2020.09.01.11.20.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 11:20:30 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/6] ionic: struct cleanups
Date:   Tue,  1 Sep 2020 11:20:18 -0700
Message-Id: <20200901182024.64101-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset has a few changes for better cacheline use,
to cleanup a page handling API, and to streamline the
Adminq/Notifyq queue handling.  Lastly, we also have a couple
of fixes pointed out by the friendly kernel test robot.

v2: dropped change to irq coalesce default
    fixed Neel's attributions to Co-developed-by
    dropped the unnecessary new call to dma_sync_single_for_cpu()
    added 2 patches from kernel test robot results

Shannon Nelson (6):
  ionic: clean up page handling code
  ionic: struct reorder for faster access
  ionic: clean up desc_info and cq_info structs
  ionic: clean adminq service routine
  ionic: remove unused variable
  ionic: clarify boolean precedence

 drivers/net/ethernet/pensando/ionic/ionic.h   |  3 -
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 33 +-------
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 24 +++---
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 44 +++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.h   | 14 ++--
 .../net/ethernet/pensando/ionic/ionic_main.c  | 26 ------
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 81 ++++++++++---------
 8 files changed, 91 insertions(+), 138 deletions(-)

-- 
2.17.1

