Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C51A2ACF70
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 07:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731991AbgKJGKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 01:10:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:17477 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731738AbgKJGKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 01:10:31 -0500
IronPort-SDR: 8bs48ESgLPZfuAwkPnGI/U00LqrSxzcnYo0V0NmMIRLonUHjxd+T4hGkKwlWoI7jvWuEmE1MB0
 eIF0GaOmtTog==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="170035025"
X-IronPort-AV: E=Sophos;i="5.77,465,1596524400"; 
   d="scan'208";a="170035025"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 22:10:29 -0800
IronPort-SDR: teItR5/P0xCamLBtQwgKh6GvVvAS7WDiHEp7hq3MQAnhc2J1V+ci8XadyScA795iMiolu99EqE
 684PKBYzdJTw==
X-IronPort-AV: E=Sophos;i="5.77,465,1596524400"; 
   d="scan'208";a="365752844"
Received: from eevans-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.97.1])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 22:10:28 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, andre.guedes@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org
Subject: [PATCH next-queue v2 0/3] igc: Add support for PCIe PTM
Date:   Mon,  9 Nov 2020 22:10:16 -0800
Message-Id: <20201110061019.519589-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes from v1:
  - This now should cross compile better, convert_art_ns_to_tsc() will
    only be used if CONFIG_X86_TSC is enabled;
  - PCIe PTM errors reported by the NIC are logged and PTM cycles are
    restarted in case an error is detected;

Original cover letter:

This adds support for PCIe PTM (Precision Time Measurement) to the igc
driver. PCIe PTM allows the NIC and Host clocks to be compared more
precisely, improving the clock synchronization accuracy.

Patch 1/3 reverts a commit that made pci_enable_ptm() private to the
PCI subsystem, reverting makes it possible for it to be called from
the drivers.

Patch 2/3 calls pci_enable_ptm() from the igc driver.

Patch 3/3 implements the PCIe PTM support. It adds a workqueue that
reads the PTM registers periodically and collects the information so a
subsequent call to getcrosststamp() has all the timestamps needed.

Some questions are raised (also pointed out in the commit message):

1. Using convert_art_ns_to_tsc() is too x86 specific, there should be
   a common way to create a 'system_counterval_t' from a timestamp.

2. convert_art_ns_to_tsc() says that it should only be used when
   X86_FEATURE_TSC_KNOWN_FREQ is true, but during tests it works even
   when it returns false. Should that check be done?

Cheers,


Vinicius Costa Gomes (3):
  Revert "PCI: Make pci_enable_ptm() private"
  igc: Enable PCIe PTM
  igc: Add support for PTP getcrosststamp()

 drivers/net/ethernet/intel/igc/igc.h         |   7 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  27 +++
 drivers/net/ethernet/intel/igc/igc_main.c    |   7 +
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 209 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  23 ++
 drivers/pci/pci.h                            |   3 -
 include/linux/pci.h                          |   7 +
 7 files changed, 280 insertions(+), 3 deletions(-)

-- 
2.29.0

