Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9A12E4C1
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 20:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfE2Sro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 14:47:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:45223 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfE2Sro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 14:47:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:47:43 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 29 May 2019 11:47:43 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-05-29
Date:   Wed, 29 May 2019 11:47:39 -0700
Message-Id: <20190529184754.12693-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Bruce cleans up white space issues and fixes complaints about using
bitop assignments using operands of different sizes.

Anirudh cleans up code that is no longer needed now that the firmware
supports the functionality.  Adds support for ethtool selftestto the ice
driver, which includes testing link, interrupts, eeprom, registers and
packet loopback.  Also, cleaned up duplicate code.

Tony implements support for toggling receive VLAN filter via ethtool.

Brett bumps up the minimum receive descriptor count per queue to resolve
dropped packets.  Refactored the interrupt tracking for the ice driver
to resolve issues seen with the co-existence of features and SR-IOV, so
instead of having a hardware IRQ tracker and a software IRQ tracker,
simply use one tracker.  Also adds a helper function to trigger software
interrupts.

Mitch changes how Malicious Driver Detection (MDD) events are handled,
to ensure all VFs checked for MDD events and just log the event instead
of disabling the VF, which was preventing proper release of resources if
the VF is rebooted or the VF driver reloaded.

Dave cleans up a redundant call to register LLDP MIB change events.

Dan adds support to retrieve the current setting of firmware logging
from the hardware to properly initialize the hardware structure.

The following are changes since commit 36f18439ea16ebb670720602bfbf47c95a6691d4:
  macvlan: Replace strncpy() by strscpy()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (3):
  ice: Remove direct write for GLLAN_RCTL_0
  ice: Add handler for ethtool selftest
  ice: Minor cleanup in ice_switch.h

Brett Creeley (4):
  ice: Set minimum default Rx descriptor count to 512
  ice: Don't call ice_cfg_itr() for SR-IOV
  ice: Refactor interrupt tracking
  ice: Add a helper to trigger software interrupt

Bruce Allan (2):
  ice: Fix LINE_SPACING style issue
  ice: Resolve static analysis warning

Dan Nowlin (1):
  ice: Add ice_get_fw_log_cfg to init FW logging

Dave Ertman (1):
  ice: Remove redundant and premature event config

Md Fahad Iqbal Polash (1):
  ice: Configure RSS LUT key only if RSS is enabled

Mitch Williams (2):
  ice: Check all VFs for MDD activity, don't disable
  ice: Change message level

Tony Nguyen (1):
  ice: Implement toggling ethtool rx-vlan-filter

 drivers/net/ethernet/intel/ice/ice.h          |  48 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  24 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  75 ++-
 drivers/net/ethernet/intel/ice/ice_common.h   |   5 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 601 +++++++++++++++++-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   4 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 245 ++++---
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 159 +++--
 drivers/net/ethernet/intel/ice/ice_nvm.c      |  31 +
 drivers/net/ethernet/intel/ice/ice_status.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_switch.h   |   7 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   8 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 186 +++++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   8 +
 16 files changed, 1129 insertions(+), 276 deletions(-)

-- 
2.21.0

