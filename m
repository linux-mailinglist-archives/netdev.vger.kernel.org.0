Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAD027B87A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgI1Xxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:53:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:45483 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbgI1Xxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:53:43 -0400
IronPort-SDR: atp8UjPapY17nFr8Uxr6yE4U1St5una6DktyaIFMGXqr2hJQbnC0h3SmJ9q7YBArUwB7yxi/HM
 0in/P9Yl53+w==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142086317"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="142086317"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
IronPort-SDR: Z0XB1BVAiraeGNmHNkb0qdli3485cL9QcEreQrZNBtrUEEa051MPl36MWvnELgIFKbFbw7pOXn
 Zb1EZxPfC+Dg==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="311962092"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 00/15] 1GbE Intel Wired LAN Driver Updates 2020-09-28
Date:   Mon, 28 Sep 2020 14:50:03 -0700
Message-Id: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igb, igc, and e1000e drivers.

Sven Auhagen adds XDP support for igb.

Gal Hammer allows for 82576 to display part number string correctly for
igb.

Sasha adds device IDs for i221 and i226 parts. Exposes LPI counters and
removes unused fields in structures for igc. He also adds Meteor Lake
support for e1000e.

For igc, Andre renames IGC_TSYNCTXCTL_VALID to IGC_TSYNCTXCTL_TXTT_0 to
match the datasheet and adds a warning if it's not set when expected.
Removes the PTP Tx timestamp check in igc_ptp_tx_work() as it's already
checked in the watchdog_task. Cleans up some code by removing invalid error
bits, renaming a bit to match datasheet naming, and removing a, now
unneeded, macro.

Vinicius makes changes for igc PTP: removes calling SYSTIMR to latch timer
value, stores PTP time before a reset, and rejects schedules with times in
the future.

v2: Remove 'inline' from igb_xdp_tx_queue_mapping() and igb_rx_offset()
for patch 1

The following are changes since commit bcbf1be0ad49eed35f3cf27fb668f77e0c94f5f7:
  Merge branch 'udp_tunnel-convert-Intel-drivers-with-shared-tables'
and are available in the git repository at:
  https://github.com/anguy11/next-queue.git 1GbE

Andre Guedes (4):
  igc: Rename IGC_TSYNCTXCTL_VALID macro
  igc: Don't reschedule ptp_tx work
  igc: Remove timeout check from ptp_tx work
  igc: Clean RX descriptor error flags

Gal Hammer (1):
  igb: read PBA number from flash

Sasha Neftin (5):
  igc: Add new device ID's
  igc: Expose LPI counters
  igc: Remove reset disable flag
  igc: Clean up nvm_info structure
  e1000e: Add support for Meteor Lake

Sven Auhagen (1):
  igb: add XDP support

Vinicius Costa Gomes (4):
  igc: Remove references to SYSTIMR register
  igc: Save PTP time before a reset
  igc: Export a way to read the PTP timer
  igc: Reject schedules with a base_time in the future

 drivers/net/ethernet/intel/e1000e/ethtool.c  |   2 +
 drivers/net/ethernet/intel/e1000e/hw.h       |   5 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c  |   7 +
 drivers/net/ethernet/intel/e1000e/netdev.c   |   6 +
 drivers/net/ethernet/intel/e1000e/ptp.c      |   1 +
 drivers/net/ethernet/intel/igb/igb.h         |  80 +++-
 drivers/net/ethernet/intel/igb/igb_ethtool.c |   4 +
 drivers/net/ethernet/intel/igb/igb_main.c    | 437 +++++++++++++++++--
 drivers/net/ethernet/intel/igc/igc.h         |   3 +
 drivers/net/ethernet/intel/igc/igc_base.c    |   5 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  16 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c |   3 +
 drivers/net/ethernet/intel/igc/igc_hw.h      |  11 +-
 drivers/net/ethernet/intel/igc/igc_main.c    |  39 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c     |  58 +--
 15 files changed, 591 insertions(+), 86 deletions(-)

-- 
2.26.2

