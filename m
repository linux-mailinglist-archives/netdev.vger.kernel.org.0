Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D019FAB6
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfH1GoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:44:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:35206 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbfH1GoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:44:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 23:44:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="171443780"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 23:44:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] Intel Wired LAN Driver Updates 2019-08-27
Date:   Tue, 27 Aug 2019 23:43:52 -0700
Message-Id: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a variety of cold and hot savoury changes to Intel
drivers.  Some of the fixes could be considered for stable even though
the author did not request it.

Hulk Robert cleans up (i.e. removes) a function that has no caller for
the iavf driver.

Radoslaw fixes an issue when there is no link in the VM after the
hypervisor is restored from a low-power state due to the driver not
properly restoring features in the device that had been disabled during
the suspension for ixgbevf.

Kai-Heng Feng modified e1000e to use mod_delayed_work() to help resolve
a hot plug speed detection issue by adding a deterministic 1 second
delay before running watchdog task after an interrupt.

Sasha moves functions around to avoid forward declarations, since the
forward declarations are not necessary for these static functions in
igc.  Also added a check for igc during driver probe to validate the NVM
checksum.  Cleaned up code defines that were not being used in the igc
driver.  Adds support for IP generic transmit checksum offload in the
igc driver.

Updated the iavf kernel documentation by a developer with no life.

Jake provides another fm10k update to a local variable for ease of code
readability.

Mitch fixes the iavf driver to allow the VF to override the MAC address
set by the host, if the VF is in "trusted" mode.

Mauro S. M. Rodrigues provides several changes for i40e driver, first
with resolving hw_dbg usage and referencing a i40e_hw attribute.  Also
implemented a debug macro using pr_debug, since the use of netdev_dbg
could cause a NULL pointer dereference during probe.  Finally cleaned up
code that is no longer used or needed.

Firo Yang provides a change in the ixgbe driver to ensure we sync the
first fragment unconditionally to help resolve an issue seen in the XEN
environment when the upper network stack could receive an incomplete
network packet.

Mariusz adds a missing device to the i40e PCI table in the driver.

The following are changes since commit 68aaf4459556b1f9370c259fd486aecad2257552:
  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 10GbE

Firo Yang (1):
  ixgbe: sync the first fragment unconditionally

Jacob Keller (1):
  fm10k: use a local variable for the frag pointer

Jeff Kirsher (1):
  Documentation: iavf: Update the Intel LAN driver doc for iavf

Kai-Heng Feng (1):
  e1000e: Make speed detection on hotplugging cable more reliable

Mariusz Stachura (1):
  i40e: Add support for X710 device

Mauro S. M. Rodrigues (3):
  i40e: fix hw_dbg usage in i40e_hmc_get_object_va
  i40e: Implement debug macro hw_dbg using pr_debug
  i40e: Remove EMPR traces from debugfs facility

Mitch Williams (1):
  iavf: allow permanent MAC address to change

Radoslaw Tyl (1):
  ixgbevf: Link lost in VM on ixgbevf when restoring from freeze or
    suspend

Sasha Neftin (4):
  igc: Remove useless forward declaration
  igc: Add NVM checksum validation
  igc: Remove unneeded PCI bus defines
  igc: Add tx_csum offload functionality

YueHaibing (1):
  iavf: remove unused debug function iavf_debug_d

 .../networking/device_drivers/intel/iavf.rst  | 115 ++++++++---
 drivers/net/ethernet/intel/e1000e/netdev.c    |  12 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |   8 +-
 drivers/net/ethernet/intel/i40e/i40e.h        |   1 -
 drivers/net/ethernet/intel/i40e/i40e_common.c |   1 +
 .../net/ethernet/intel/i40e/i40e_debugfs.c    |   4 -
 drivers/net/ethernet/intel/i40e/i40e_hmc.c    |   1 +
 .../net/ethernet/intel/i40e/i40e_lan_hmc.c    |  14 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
 drivers/net/ethernet/intel/i40e/i40e_osdep.h  |   7 +-
 drivers/net/ethernet/intel/iavf/iavf.h        |   1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  26 ---
 drivers/net/ethernet/intel/igc/igc.h          |   4 +
 drivers/net/ethernet/intel/igc/igc_base.h     |   8 +
 drivers/net/ethernet/intel/igc/igc_defines.h  |   9 +-
 drivers/net/ethernet/intel/igc/igc_mac.c      |  73 ++++---
 drivers/net/ethernet/intel/igc/igc_main.c     | 106 ++++++++++
 drivers/net/ethernet/intel/igc/igc_phy.c      | 192 +++++++++---------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  16 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
 20 files changed, 372 insertions(+), 228 deletions(-)

-- 
2.21.0

