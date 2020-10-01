Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8B52803C8
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbgJAQW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730534AbgJAQW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:22:56 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62528C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:22:56 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d6so4990140pfn.9
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 09:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=wlwUCLLe/KUwK6WvNspEASjJDgj1cIzzNp9HpCBzgGs=;
        b=w7t1Ukn8oAlrQwuAt7SN5UFY9JyWSwFcQzs63EQ371dkPYnqQajT7w6mazwfLonPQC
         XP9nsXAoC7G2OV3pwquICaJbhjby/9nxEEMC+bKM+4iR0FgjYQVIg66inUAYVsMFndeT
         KCUyoMy5mSbM5WgOL6ALNz3hMdC6p7NYylKBlf/FpyqpMWECfOYBecVm/KpUR1L9oNT8
         DoHiImCAywJNryOxwY1iO5j0k+20y3uaLhOeycXYtpmQjS8OuwNujeDxgm2n6Mgsb2YC
         /DObVEA+LrRlNyKcLyGkMk8VKBfsyO39XRnxyh0yr7kt6CTDjSLxVk+z7OpxJ+t3xXs3
         KPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wlwUCLLe/KUwK6WvNspEASjJDgj1cIzzNp9HpCBzgGs=;
        b=bzQtqCza4Z0uwrZ+1dVXSFhi+ih+Ucs+hFLqhL8+/w0U7tN9D8BlXQpcjW6yavZLjm
         G7ABuzZVF7t9zZn3YQhj4HseHuqWZesdB+poF7ovFmv+kLIg9K/dv1ovaXA1H0VYRZY+
         6pNsINNv1xIezuuIHjqUINcxSyF1MhE8M2DHpcW02mw43Ct+eXnWR4JYnXzjbL/Lr1hh
         cmu1Ooav373Xu4Pg/5zKfiJKOWPM1C8Abd+34HwlWYQ2vmofGqIBn/6DWwRAopkzYAT7
         7wKDyaxehPPv5CfhCa0sDwJQiqH4WBe1EhhfIIyvqsljiyXciOn4dMhmdGnrzIGzGUGn
         Fcug==
X-Gm-Message-State: AOAM530/Vk+ZdWwUNxmadHtqAAT6mC1S2U8i9Jx5G4XHENKOZirMNUiX
        du3zs3Hn9HAJcbHfv93Gf+4DBPGW6w56jg==
X-Google-Smtp-Source: ABdhPJy2y7KNvB6vIEabcCh/3rh4u3IXjG+gz+lkBq9Z9XdrHdYtIcwfo/lv1iQCodfGtu8+5sny1g==
X-Received: by 2002:aa7:9f10:0:b029:142:2501:34d4 with SMTP id g16-20020aa79f100000b0290142250134d4mr7950106pfr.45.1601569375265;
        Thu, 01 Oct 2020 09:22:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k2sm6380066pfi.169.2020.10.01.09.22.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2020 09:22:54 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/8] ionic error recovery
Date:   Thu,  1 Oct 2020 09:22:38 -0700
Message-Id: <20201001162246.18508-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set of patches comes mostly from error recovery path testing,
as well as a couple of upstream review comments.

Shannon Nelson (8):
  ionic: contiguous memory for notifyq
  ionic: drain the work queue
  ionic: clear linkcheck bit on alloc fail
  ionic: check qcq ptr in ionic_qcq_disable
  ionic: disable all queue napi contexts on timeout
  ionic: refill lif identity after fw_up
  ionic: use lif ident for filter count
  ionic: add new bad firmware error code

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  10 +-
 .../net/ethernet/pensando/ionic/ionic_if.h    |   1 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 193 +++++++++++-------
 .../net/ethernet/pensando/ionic/ionic_main.c  |  18 +-
 4 files changed, 134 insertions(+), 88 deletions(-)

-- 
2.17.1

