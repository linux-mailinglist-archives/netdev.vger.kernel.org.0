Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4293F6A89
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 22:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhHXUkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 16:40:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:49509 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234765AbhHXUkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 16:40:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="204530930"
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="204530930"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 13:39:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="526819945"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Aug 2021 13:39:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        richardcochran@gmail.com
Subject: [PATCH net-next 0/4][pull request] 1GbE Intel Wired LAN Driver Updates 2021-08-24
Date:   Tue, 24 Aug 2021 13:42:44 -0700
Message-Id: <20210824204248.2957134-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius Costa Gomes says:

This adds support for PCIe PTM (Precision Time Measurement) to the igc
driver. PCIe PTM allows the NIC and Host clocks to be compared more
precisely, improving the clock synchronization accuracy.

Patch 1/4 reverts a commit that made pci_enable_ptm() private to the
PCI subsystem, reverting makes it possible for it to be called from
the drivers.

Patch 2/4 adds the pcie_ptm_enabled() helper.

Patch 3/4 calls pci_enable_ptm() from the igc driver.

Patch 4/4 implements the PCIe PTM support. Exposing it via the
.getcrosststamp() API implies that the time measurements are made
synchronously with the ioctl(). The hardware was implemented so the
most convenient way to retrieve that information would be
asynchronously. So, to follow the expectations of the ioctl() we have
to use less convenient ways, triggering an PCIe PTM dialog every time
a ioctl() is received.

Some questions are raised (also pointed out in the commit message):

1. Using convert_art_ns_to_tsc() is too x86 specific, there should be
   a common way to create a 'system_counterval_t' from a timestamp.

2. convert_art_ns_to_tsc() says that it should only be used when
   X86_FEATURE_TSC_KNOWN_FREQ is true, but during tests it works even
   when it returns false. Should that check be done?

The following are changes since commit 3a62c333497b164868fdcd241842a1dd4e331825:
  Merge branch 'ethtool-extend-coalesce-uapi'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE

Vinicius Costa Gomes (4):
  Revert "PCI: Make pci_enable_ptm() private"
  PCI: Add pcie_ptm_enabled()
  igc: Enable PCIe PTM
  igc: Add support for PTP getcrosststamp()

 drivers/net/ethernet/intel/igc/igc.h         |   1 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  31 ++++
 drivers/net/ethernet/intel/igc/igc_main.c    |   6 +
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 179 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  23 +++
 drivers/pci/pci.h                            |   3 -
 drivers/pci/pcie/ptm.c                       |   9 +
 include/linux/pci.h                          |  10 ++
 8 files changed, 259 insertions(+), 3 deletions(-)

-- 
2.26.2

