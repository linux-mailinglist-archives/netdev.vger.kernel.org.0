Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A85344B0C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhCVQTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:19:53 -0400
Received: from mga07.intel.com ([134.134.136.100]:21216 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231626AbhCVQTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:19:35 -0400
IronPort-SDR: /dz+JhLGp4W0pVzjjPaSviNl0fDNEDBW+cZO56uqZ2WOPAvy2UFgNbPDWIL4etW7qkzWgUp+QK
 ugVxpsFHnFyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="254301394"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="254301394"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 09:19:24 -0700
IronPort-SDR: HQ3akpnHPpLHDT7mmhoaVazRlWDreeTdYyLA9dC2UX0DyvS5mBjryokClXhGTKY6YrPNCHFRic
 dUkCadlmTnGw==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="407893515"
Received: from canguven-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.255.87.118])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 09:19:22 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        sasha.neftin@intel.com, anthony.l.nguyen@intel.com,
        linux-pci@vger.kernel.org, bhelgaas@google.com,
        netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: [PATCH next-queue v3 0/3] igc: Add support for PCIe PTM
Date:   Mon, 22 Mar 2021 09:18:19 -0700
Message-Id: <20210322161822.1546454-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes from v2:
  - Now the PTM timestamps are retrieved synchronously with the
    ioctl();
  - Fixed some typos in constants;
  - The IGC_PTM_STAT register is write-1-to-clear, document this more
    clearly;

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

 drivers/net/ethernet/intel/igc/igc.h         |   1 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  31 ++++
 drivers/net/ethernet/intel/igc/igc_main.c    |   6 +
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 173 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  23 +++
 drivers/pci/pci.h                            |   3 -
 include/linux/pci.h                          |   7 +
 7 files changed, 241 insertions(+), 3 deletions(-)

-- 
2.31.0

