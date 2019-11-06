Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19130F1F0B
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfKFTh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:37:58 -0500
Received: from mga04.intel.com ([192.55.52.120]:25882 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727319AbfKFTh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 14:37:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 11:37:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="402473253"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2019 11:37:57 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 00/14][pull request] 100GbE Intel Wired LAN Driver Updates 2019-11-06
Date:   Wed,  6 Nov 2019 11:37:42 -0800
Message-Id: <20191106193756.23819-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Jesse implements set_eeprom functionality in ethtool by adding functions
to enable reading of the NVM image.

Scott adds ethtool -m support so that we can read eeprom data on SFP/OSFP
modules.

Anirudh updates the return value to properly reflect when SRIOV is not
supported.

Md Fahad updates the driver to handle a change in the NVM, where the
boot configuration section was moved to the Preserved Field Area (PFA)
of the NVM.

Paul resolves an issue when DCBx requests non-contiguous TCs, transmit
hangs could occur, so configure a default traffic class (TC0) in these
cases to prevent traffic hangs.  Adds a print statement to notify the
user when unsupported modules are inserted.

Bruce fixes up the driver unload code flow to ensure we do not clear the
interrupt scheme until the reset is complete, otherwise a hardware error
may occur.

Dave updates the DCB initialization to set is_sw_lldp boolean when the
firmware has been detected to be in an untenable state.  This will
ensure that the firmware is in a known state.

Michal saves off the PCI state and I/O BARs address after PCI bus reset
so that after the reset, device registers can be read.  Also adds a NULL
pointer check to prevent a potential kernel panic.

Mitch resolves an issue where VF's on PF's other than 0 were not seeing
resets by using the per-PF VF ID instead of the absolute VF ID.

Krzysztof does some code cleanup to remove a unneeded wrapper and
reduces the code complexity.

Brett reduces confusion by changing the name of ice_vc_dis_vf() to
ice_vc_reset_vf() to better describe what the function is actually
doing.

v2: dropped patch 3 "ice: Add support for FW recovery mode detection"
    from the origin al series, while Ani makes changes based on
    community feedback to implement devlink into the changes.

The following are changes since commit a3ead21d6eec4d18b48466c7b978566bc9cab676:
  Merge tag 'wireless-drivers-next-2019-11-05' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Fix return value when SR-IOV is not supported

Brett Creeley (1):
  ice: Rename VF function ice_vc_dis_vf to match its behavior

Bruce Allan (1):
  ice: fix driver unload flow

Dave Ertman (1):
  ice: Adjust DCB INIT for SW mode

Jesse Brandeburg (1):
  ice: implement set_eeprom functionality

Krzysztof Kazimierczak (1):
  ice: Get rid of ice_cleanup_header

Md Fahad Iqbal Polash (1):
  ice: Update Boot Configuration Section read of NVM

Michal Swiatkowski (2):
  ice: save PCI state in probe
  ice: Check for null pointer dereference when setting rings

Mitch Williams (1):
  ice: write register with correct offset

Paul Greenwalt (3):
  ice: handle DCBx non-contiguous TC request
  ice: print unsupported module message
  ice: print PCI link speed and width

Scott W Taylor (1):
  ice: add ethtool -m support for reading i2c eeprom modules

 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  36 ++
 drivers/net/ethernet/intel/ice/ice_common.c   | 112 ++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  11 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   6 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  | 141 +++++--
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 272 ++++++++++++-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  24 ++
 drivers/net/ethernet/intel/ice/ice_lib.h      |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  32 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 380 +++++++++++++-----
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  80 ++++
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  27 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  16 +-
 15 files changed, 948 insertions(+), 196 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_nvm.h

-- 
2.21.0

