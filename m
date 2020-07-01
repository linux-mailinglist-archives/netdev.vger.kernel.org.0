Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC48C211617
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgGAWeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:25457 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgGAWeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:22 -0400
IronPort-SDR: 80LSr1qcD2H/47VhocV5Kbq8EfaNLVNz65csF5KNcqbqKO3J3IMvoNqLZvOeIchKXh0zqcb6hT
 xZkwCeQBaidg==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178598"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178598"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:21 -0700
IronPort-SDR: lZo96DzsUlgq1LVsIOJ0CdJcevru8UnVc3syajIo2FnRFtIkEgBXxhAID4xAgdDLFIBLZdlkni
 RvdX5682YN8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276096"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com
Subject: [net-next 00/12][pull request] Intel Wired LAN Driver Updates 2020-07-01
Date:   Wed,  1 Jul 2020 15:34:00 -0700
Message-Id: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to all Intel drivers, but a majority of the
changes are to the i40e driver.

Jeff converts 'fall through' comments to the 'fallthrough;' keyword for
all Intel drivers. Removed unnecessary delay in the ixgbe ethtool
diagnostics test.

Arkadiusz implements Total Port Shutdown for i40e. This is the revised
patch based on Jakub's feedback from an earlier submission of this
patch, where additional code comments and description was needed to
describe the functionality.

Wei Yongjun fixes return error code for iavf_init_get_resources().

Magnus optimizes XDP code in i40e; starting with AF_XDP zero-copy
transmit completion path. Then by only executing a division when
necessary in the napi_poll data path. Move the check for transmit ring
full outside the send loop to increase performance.

Ciara add XDP ring statistics to i40e and the ability to dump these
statistics and descriptors.

Tony fixes reporting iavf statistics.

Radoslaw adds support for 2.5 and 5 Gbps by implementing the newer ethtool
ksettings API in ixgbe.

The following are changes since commit 2b04a66156159592156a97553057e8c36de2ee70:
  Merge branch 'cxgb4-add-mirror-action-support-for-TC-MATCHALL'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Arkadiusz Kubalewski (1):
  i40e: Add support for a new feature Total Port Shutdown

Ciara Loftus (3):
  i40e: add XDP ring statistics to VSI stats
  i40e: add XDP ring statistics to dump VSI debug output
  i40e: introduce new dump desc XDP command

Jeff Kirsher (2):
  ethernet/intel: Convert fallthrough code comments
  ixgbe: Cleanup unneeded delay in ethtool test

Magnus Karlsson (3):
  i40e: optimize AF_XDP Tx completion path
  i40e: eliminate division in napi_poll data path
  i40e: move check of full Tx ring to outside of send loop

Radoslaw Tyl (1):
  ixgbe: Add ethtool support to enable 2.5 and 5.0 Gbps support

Tony Nguyen (1):
  iavf: Fix updating statistics

Wei Yongjun (1):
  iavf: fix error return code in iavf_init_get_resources()

 drivers/net/ethernet/intel/e1000/e1000_hw.c   |   4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |   3 +-
 .../net/ethernet/intel/e1000/e1000_param.c    |   2 +-
 drivers/net/ethernet/intel/e1000e/82571.c     |   4 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  11 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c   |  14 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  30 +-
 drivers/net/ethernet/intel/e1000e/param.c     |   2 +-
 drivers/net/ethernet/intel/e1000e/phy.c       |   2 +-
 drivers/net/ethernet/intel/e1000e/ptp.c       |   3 +-
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |   4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |   4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c  |   6 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |   2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c   |   8 +-
 drivers/net/ethernet/intel/i40e/i40e.h        |  22 ++
 drivers/net/ethernet/intel/i40e/i40e_adminq.c |   2 +-
 .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |   1 +
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 100 ++++++-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  11 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 147 ++++++++--
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  23 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  61 ++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.h    |   3 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   |   9 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |   2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c  |   4 +-
 drivers/net/ethernet/intel/igb/e1000_nvm.c    |   2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c    |   4 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |   8 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  26 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c      |   2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |   4 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |  16 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |   5 +-
 .../net/ethernet/intel/ixgbe/ixgbe_82598.c    |   2 +-
 .../net/ethernet/intel/ixgbe/ixgbe_82599.c    |   6 +-
 .../net/ethernet/intel/ixgbe/ixgbe_common.c   |   4 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 277 ++++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  36 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |   4 +-
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c |  10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |   4 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  10 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c       |   6 +-
 49 files changed, 606 insertions(+), 313 deletions(-)

-- 
2.26.2

