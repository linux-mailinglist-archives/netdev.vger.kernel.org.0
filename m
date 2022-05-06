Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7207F51DE98
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 20:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388765AbiEFSHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 14:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389227AbiEFSHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 14:07:36 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434466D4C4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 11:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651860230; x=1683396230;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Xq6j4OfKoXD0TmPJiyn66iAr/sE2rtgxV8o5sUIT24I=;
  b=Nh8O6PupgHYlAmUU83QW2oBm7Kfyi1nEDtQtSeCI4qVd3ZGEqRu8VTiQ
   EqhEhbpMyTrghng/LAktBmztGeQBaTvdnUGrYSmJf6eTOmIyCPOe2o6H0
   jcp0x8rsCEDrgEB852V7vQoYa9v9nT8VG9mPKgySu5PQnlzxALK+50+Mb
   UDsqt0C4jZI3jL5DPDUTF3tgWX1oRhtxTfaNPgkqBHNf8xI8trRmRTBnN
   uWaDkxOIMXNB+lJJrhA4Inle1jICuLAat37POrrDk7BNEnLzTV5LM3Q6+
   u2K2/ndynIl0m6cOqtvJxnoXa+++a4t+i0Sp4rzSgD8WTG85bs2F9PrZX
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="354971158"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="354971158"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 11:03:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="600670826"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 06 May 2022 11:03:49 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        marcin.szycik@linux.intel.com
Subject: [PATCH net-next 0/2][pull request] 100GbE Intel Wired LAN Driver Updates 2022-05-06
Date:   Fri,  6 May 2022 11:00:50 -0700
Message-Id: <20220506180052.5256-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcin Szycik says:

This patchset adds support for systemd defined naming scheme for port
representors, as well as re-enables displaying PCI bus-info in ethtool.

bus-info information has previously been removed from ethtool for port
representors, as a workaround for a bug in lshw tool, where the tool would
sometimes display wrong descriptions for port representors/PF. Now the bug
has been fixed in lshw tool [1].

Removing the workaround can be considered a regression (user might be
running an older, unpatched version of lshw) (see [2] for discussion).
However, calling SET_NETDEV_DEV also produces the same effect as removing
the workaround, i.e. lshw is able to access PCI bus-info (this time not
via ethtool, but in some other way) and the bug can occur.

Adding SET_NETDEV_DEV is important, as it greatly improves netdev naming -
- port representors are named based on PF name. Currently port representors
are named "ethX", which might be confusing, especially when spawning VFs on
multiple PFs. Furthermore, it's currently harder to determine to which PF
does a particular port representor belong, as bus-info is not shown in
ethtool.

Consider the following three cases:


Case 1: current code - driver workaround in place, no SET_NETDEV_DEV,
lshw with or without fix. Port representors are not displayed because they
don't have bus-info (the workaround), PFs are labelled correctly:

$ sudo ./lshw -c net -businfo
Bus info          Device      Class          Description
========================================================
pci@0000:02:00.0  ens6f0      network        Ethernet Controller E810-XXV for SFP <-- PF
pci@0000:02:00.1  ens6f1      network        Ethernet Controller E810-XXV for SFP
pci@0000:02:01.0  ens6f0v0    network        Ethernet Adaptive Virtual Function <-- VF
pci@0000:02:01.1  ens6f0v1    network        Ethernet Adaptive Virtual Function
...


Case 2: driver workaround in place, SET_NETDEV_DEV, no lshw fix. Port
representors have predictable names. lshw is able to get bus-info because
of SET_NETDEV_DEV and netdevs CAN be mislabelled:

$ sudo ./lshw -c net -businfo
Bus info          Device           Class          Description
=============================================================
pci@0000:02:00.0  ens6f0npf0vf60   network        Ethernet Controller E810-XXV for SFP <-- mislabeled port representor
pci@0000:02:00.1  ens6f1           network        Ethernet Controller E810-XXV for SFP
pci@0000:02:01.0  ens6f0v0         network        Ethernet Adaptive Virtual Function
pci@0000:02:01.1  ens6f0v1         network        Ethernet Adaptive Virtual Function
...
pci@0000:02:00.0  ens6f0npf0vf26   network        Ethernet interface
pci@0000:02:00.0  ens6f0           network        Ethernet interface <-- mislabeled PF
pci@0000:02:00.0  ens6f0npf0vf81   network        Ethernet interface
...
$ sudo ethtool -i ens6f0npf0vf60
driver: ice
...
bus-info:
...

Output of lshw would be the same with workaround removed; it does not
change the fact that lshw labels netdevs incorrectly, while at the same
time it prevents ethtool from displaying potentially useful data
(bus-info).


Case 3: workaround removed, SET_NETDEV_DEV, lshw fix:

$ sudo ./lshw -c net -businfo
Bus info          Device           Class          Description
=============================================================
pci@0000:02:00.0  ens6f0npf0vf73   network        Ethernet Controller E810-XXV for SFP
pci@0000:02:00.1  ens6f1           network        Ethernet Controller E810-XXV for SFP
pci@0000:02:01.0  ens6f0v0         network        Ethernet Adaptive Virtual Function
pci@0000:02:01.1  ens6f0v1         network        Ethernet Adaptive Virtual Function
...
pci@0000:02:00.0  ens6f0npf0vf5    network        Ethernet Controller E810-XXV for SFP
pci@0000:02:00.0  ens6f0           network        Ethernet Controller E810-XXV for SFP
pci@0000:02:00.0  ens6f0npf0vf60   network        Ethernet Controller E810-XXV for SFP
...
$ sudo ethtool -i ens6f0npf0vf73
driver: ice
...
bus-info: 0000:02:00.0
...

In this case poort representors have predictable names, netdevs are not
mislabelled in lshw, and bus-info is shown in ethtool.

[1] https://ezix.org/src/pkg/lshw/commit/9bf4e4c9c1
[2] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220321144731.3935-1-marcin.szycik@linux.intel.com

The following are changes since commit 95730d65708397828f75ca7dbca838edf6727bfd:
  Merge branch 'tso-gso-limit-split'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Marcin Szycik (1):
  Revert "ice: Hide bus-info in ethtool for PRs in switchdev mode"

Michal Swiatkowski (1):
  ice: link representors to PCI device

 drivers/net/ethernet/intel/ice/ice_ethtool.c | 8 +++-----
 drivers/net/ethernet/intel/ice/ice_repr.c    | 1 +
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
2.35.1

