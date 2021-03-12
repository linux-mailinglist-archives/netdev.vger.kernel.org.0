Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90133956B
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhCLRsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbhCLRsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:48:03 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10598C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:03 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q5so3679894pgk.5
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=JujqZ6a4DmxzimQ0g7KvclcEk5s4VwtmJHbcoMqSQjc=;
        b=rcxMYdpEO6lHAHPh4RETobEtXCQrqgLx3Rb0IfqN5vgUEEsWzH8qrSCptI0QhoZrnS
         +INuncQS3/J7CWxHGN+7ln5hdUcL0m7ew3JrvUXcNLoKu/q/UzEuyq5Gmp0u83Igy9eD
         HCruWTBcSG4vl0Ex8UOWxX+JeW1atjEXj3tN73nYFmSYjWx2QiTjeUoQEsi1pQMR5T9e
         C3Ov/dk9ZT4F1x6AmaSkrd/x1qv8xPL3f0DlT3PQxgdIpIw/mm1uNaR8zUNda1+2gqzA
         TZJhijEpykqn3J4V6g4s+avtx4RcveFwGqRS+WxZMEO4+bZq0Vd8vHwRazauuA9CPZUB
         nWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=JujqZ6a4DmxzimQ0g7KvclcEk5s4VwtmJHbcoMqSQjc=;
        b=jPMii6/FTgc6RZypYyHW75iGOgRrF+dN+O2AgcHfNW0ARgg29tAUl4vBcnmegyVVob
         bEDTl/K4xWIUdLaD7lorlVAp7d9JvX2X+lcumdbxyShuV2RUMhgFlDpDIgH4dNjPNCK9
         eFCBGVgyfban/6s3mVOPCQjVoJ2DjzqpUpjHEZMm6s6+Vqmtj1U/TqIZuZFVmR+PyQo/
         CBakZ/ohRB3FJP45LKCen3hJ/Shok6pVWUHXMHpFMDipTodg7VwvsyYZAwHwohSTn8bS
         1Q5LhmWiP1TwZsm6gooOiJvad0B97hSXJ3dTGgGriYKmeuk6FoTtQqiOBM0UsmOmfsGt
         g9JQ==
X-Gm-Message-State: AOAM530Wxm2vBQnj+QYmBJalAGisQMw775UnAseYaMtjiTTJISBHyXGj
        yXLqPJKgOuEkqz7luGaiR/c=
X-Google-Smtp-Source: ABdhPJxIxzPr/Sn3NRSXifls8FfVyr98rA8KnH45DnR3NedshdnHABjldzx3v6Va9KmFVinuZA9pMA==
X-Received: by 2002:a62:bd05:0:b029:1ab:6d2:5edf with SMTP id a5-20020a62bd050000b02901ab06d25edfmr13189721pff.32.1615571282442;
        Fri, 12 Mar 2021 09:48:02 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id e190sm6273082pfe.3.2021.03.12.09.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:48:02 -0800 (PST)
Subject: [net-next PATCH 00/10] ethtool: Factor out common code related to
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
Date:   Fri, 12 Mar 2021 09:48:00 -0800
Message-ID: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is meant to be a cleanup and refactoring of common code bits
from several drivers. Specifically a number of drivers engage in a pattern
where they will use some variant on an sprintf or memcpy to write a string
into the ethtool string array and then they will increment their pointer by
ETH_GSTRING_LEN.

Instead of having each driver implement this independently I am refactoring
the code so that we have one central function, ethtool_sprintf that does
all this and takes a double pointer to access the data, a formatted string
to print, and the variable arguments that are associated with the string.

Changes from RFC:
Renamed ethtool_gsprintf to ethtool_sprintf
Fixed reverse xmas tree issue in patch 2
Added Acked-by/Reviewed-by tags from RFC review

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

