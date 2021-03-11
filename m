Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9783D3369BD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhCKBfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhCKBfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:35:13 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60146C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:13 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id z6so171885qts.2
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=cGFy0Tnvylt4LZdGihf8eHHsCvptUxZPZzwu3GGPgnQ=;
        b=mGmRrUw2IaEEqVO0FC7rdPuj1wxJrp5r5d1wVyadLhtu1TNW3//dXut+CBeA3M2lRI
         qg4LMmKnaZFwn7liKCxoorpgB8PJFOJWh41towIyoYuLp/HGjz2S2u5ThEodBqhSShcw
         2AN/AdJfATSUm6NI/gIjpHn5A4vRt1TZV8DUpH+Zm5k6I7ztLxjxKNehUVahns6jcFb0
         gEug4XkugUXTnTx973Zcv4OiGwi1WZM73a6G5hmi7WCEwlsWpp8FRzwzh6WBErdyNbEi
         5nbQGdapY7uFIWTCR8JVYtL4ybqB3XJiuGssHqOyEd+xgfPA94ddEmlNfNiffc4LKZPY
         5/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=cGFy0Tnvylt4LZdGihf8eHHsCvptUxZPZzwu3GGPgnQ=;
        b=DgFMvPLySiMVz8V0SSDwgos9c3Lu7HiPA4IaL/qbvUFarJgSy0BiSvEUHKuCPbASHz
         dB6YbT32TfjLGQBKWWdWeSvqE8q8Z0saQzzsQGYjQkA49hc2ry7ZzOu72nb1xaRRR9Ov
         QXZ7QmRe/iKXumPHzMJdZK7+tbR5JMsldo7euANSO4JdQx7YwfKVwtnJgpp3DnrLJjjf
         qSzwGgpN0KZB0SSIqvBbhRMsr+yu+Rq+zoppKQ53K62Al7FxArXVOhL53qQrV8U6okNR
         Sj99SzZGNdAJDqG0KLDA8z6P/DERMPoo4BgAVnbtRQAU3H5ZSXDyaYKmcgJ0Z7t5iBMc
         /8aw==
X-Gm-Message-State: AOAM5303wHlAc5yO833NUVXpL5BZO8pjH6SGxVgP2yfQAk7zKvr0Tj36
        CfA84X5NyfLjygw3rsNHrnw=
X-Google-Smtp-Source: ABdhPJzat83bmnIvYnVpwumkmXGe6REerEJy5SkcUb2EUReo2szHOIV5BQmiM7sJHene+dBNgnNS1Q==
X-Received: by 2002:ac8:1117:: with SMTP id c23mr5417652qtj.297.1615426512243;
        Wed, 10 Mar 2021 17:35:12 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id n140sm830580qka.124.2021.03.10.17.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:35:11 -0800 (PST)
Subject: [RFC PATCH 00/10] ethtool: Factor out common code related to writing
 ethtool strings
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kuba@kernel.org
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
        alexanderduyck@fb.com
Date:   Wed, 10 Mar 2021 17:35:08 -0800
Message-ID: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
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
the code so that we have one central function, ethtool_gsprintf that does
all this whch takes a double pointer to access the data, a formatted string
to print, and the variable arguments that are associated with the string.


---

Alexander Duyck (10):
      ethtool: Add common function for filling out strings
      intel: Update drivers to use ethtool_gsprintf
      nfp: Replace nfp_pr_et with ethtool_gsprintf
      hisilicon: Update drivers to use ethtool_gsprintf
      ena: Update driver to use ethtool_gsprintf
      netvsc: Update driver to use ethtool_gsprintf
      virtio_net: Update driver to use ethtool_gsprintf
      vmxnet3: Update driver to use ethtool_gsprintf
      bna: Update driver to use ethtool_gsprintf
      ionic: Update driver to use ethtool_gsprintf


 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  25 +-
 .../net/ethernet/brocade/bna/bnad_ethtool.c   | 266 +++++++-----------
 .../ethernet/hisilicon/hns/hns_dsaf_gmac.c    |   7 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_ppe.c |  37 +--
 .../net/ethernet/hisilicon/hns/hns_dsaf_rcb.c |  89 ++----
 .../ethernet/hisilicon/hns/hns_dsaf_xgmac.c   |   6 +-
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  97 +++----
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
 18 files changed, 381 insertions(+), 631 deletions(-)

--

