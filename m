Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F93533E2B1
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhCQAbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhCQAar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:30:47 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063CEC06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:30:31 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id f12so240636qtq.4
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=JyD1AfSdasEn/u8wYDDHXH7XUQ3+kOL4jh+Dl7Iuniw=;
        b=TkbYPePWLa1bTatA0X95043R7hVQxtibwJhPXOIr00EXe42Mx+3/jm4PmyKLMM+dVO
         ZUVvIFWbtt/5NW8/bCioza2a6VLmxhKmw0k/gq1gnaymdwKwWB2h9ggMjc2B3eejiiAN
         0Adds1C2/kYrXkZ5FcEuk1SvjjLv5Kxck/4nMqI6pUo+uQZlfOJEh80ElA0tZ42HWsXe
         WfFbQ6B/t/bS1Yymc4BJ1mSioR+Gs9HgC8QMfetQltxk+tfeTKXD63RkpPdSaJFzH+mY
         CB4O8q1KDrIxyUJZ5bF3kM6mB5TiH7W5rO4x6hLEOQnuesmM1CPSdpiQb0z1VAXoXoK1
         0s7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=JyD1AfSdasEn/u8wYDDHXH7XUQ3+kOL4jh+Dl7Iuniw=;
        b=MBK8MilMWQDEVa1W8ZaYdIV2d++Ctxrpz7skEipgrJhn8oIJsbuz1oPaEDpLI0SsxR
         nIBFV1Wl64iuO9TVgiLIQIRMXiWCI9xK4E4TI98RSlb0myP8yLtS2A6DIHqfDa3hTq2x
         EMhnQXIcgb5g/Ly0dJVq4x2+w7xL0xwNLzRdUCdjC03ZfviZgeuicVw0FNGh/FIGHF5o
         Rf4kxDiNk2CmkOiFbhoTHsjIhRzM91pRh38l3T+UC2txh1QKTd5S9gGGDDfARiWUDyYQ
         bWuBZa8Ykyf8PssV+VknnzoXNvCH4+6yOOyAF7853GC7/nMS9EAmN02qaixK9Xfsmjab
         slYA==
X-Gm-Message-State: AOAM530SRhkdZP5bceWKZWh4IbwEZ7gJA3HpLZ6GVX2IbHTvp48au6eE
        3Me11wCIk0Ycpag2YDFp8OE=
X-Google-Smtp-Source: ABdhPJyNkGcofJay0CXpkXC49lI9UO4OfffPZNulfO4OmD7JkSt7lIcHeDBmta2GuORLdl9OlOpjTQ==
X-Received: by 2002:ac8:5212:: with SMTP id r18mr1453107qtn.290.1615941031027;
        Tue, 16 Mar 2021 17:30:31 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id s133sm16590561qke.1.2021.03.16.17.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:30:30 -0700 (PDT)
Subject: [net-next PATCH v2 00/10] ethtool: Factor out common code related to
 writing ethtool strings
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com, Kernel-team@fb.com
Date:   Tue, 16 Mar 2021 17:30:26 -0700
Message-ID: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is meant to be a cleanup and refactoring of common code bits
from several drivers. Specificlly a number of drivers engage in a pattern
where they will use some variant on an sprintf or memcpy to write a string
into the ethtool string array and then they will increment their pointer by
ETH_GSTRING_LEN.

Instead of having each driver implement this independently I am refactoring
the code so that we have one central function, ethtool_sprintf that does
all this and takes a double pointer to access the data, a formatted string
to print, and the variable arguments that are associated with the string.

Changes from v1:
Fixed usage of char ** vs  unsigned char ** in hisilicon drivers

Changes from RFC:
Renamed ethtool_gsprintf to ethtool_sprintf
Fixed reverse xmas tree issue in patch 2

---

Alexander Duyck (10):
      ethtool: Add common function for filling out strings
      intel: Update drivers to use ethtool_sprintf
      nfp: Replace nfp_pr_et with ethtool_sprintf
      hisilicon: Update drivers to use ethtool_sprintf
      ena: Update driver to use ethtool_sprintf
      netvsc: Update driver to use ethtool_sprintf
      virtio_net: Update driver to use ethtool_sprintf
      vmxnet3: Update driver to use ethtool_sprintf
      bna: Update driver to use ethtool_sprintf
      ionic: Update driver to use ethtool_sprintf


 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  25 +-
 .../net/ethernet/brocade/bna/bnad_ethtool.c   | 266 +++++++-----------
 .../ethernet/hisilicon/hns/hns_dsaf_gmac.c    |   9 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_ppe.c |  41 +--
 .../net/ethernet/hisilicon/hns/hns_dsaf_rcb.c |  91 +++---
 .../ethernet/hisilicon/hns/hns_dsaf_xgmac.c   |   8 +-
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  | 103 +++----
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  16 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  55 ++--
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  40 +--
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  40 +--
 drivers/net/ethernet/netronome/nfp/abm/main.c |   4 +-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  79 +++---
 drivers/net/ethernet/netronome/nfp/nfp_port.h |   2 -
 .../net/ethernet/pensando/ionic/ionic_stats.c | 145 ++++------
 drivers/net/hyperv/netvsc_drv.c               |  33 +--
 drivers/net/virtio_net.c                      |  18 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  53 ++--
 18 files changed, 389 insertions(+), 639 deletions(-)

--

