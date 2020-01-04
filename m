Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85BBB130044
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgADCuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:50:23 -0500
Received: from mga12.intel.com ([192.55.52.136]:64694 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbgADCtz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757849"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/16][pull request] 100GbE Intel Wired LAN Driver Updates 2020-01-03
Date:   Fri,  3 Jan 2020 18:49:37 -0800
Message-Id: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Brett adds support for UDP segmentation offload (USO) based on the work
Alex Duyck did for other Intel drivers. Refactored how the VF sets
spoof checking to resolve a couple of issues found in
ice_set_vf_spoofchk().  Adds the ability to track of the dflt_vsI
(default VSI), since we cannot have more than one default VSI.  Add a
macro for commonly used "for loop" used repeatedly in the code.  Cleaned
up and made the VF link flows all similar.  Refactor the flows of adding
and deleting MAC addresses in order to simplify the logic for error
conditions and setting/clearing the VF's default MAC address field. 

Michal moves the setting of the default ITR value from ice_cfg_itr() to
the function we allocate queue vectors.  Adds support for saving and
restoring the ITR value for each queue.  Adds a check for all invalid
or unused parameters to log the information and return an error.

Vignesh cleans up the driver where we were trying to write to read-only
registers for the receive flex descriptors.

Tony changes a netdev_info() to netdev_dbg() when the MTU value is
changed.

Bruce suppresses a coverity reported error that was not really an error
by adding a code comment.

Mitch adds a check for a NULL receive descriptor to resolve a coverity
reported issue.

Krzysztof prevents a potential general protection fault by adding a
boundary check to see if the queue id is greater than the size of a UMEM
array.  Adds additional code comments to assist coverity in its scans to
prevent false positives.

Jake adds support for E822 devices to the driver.

The following are changes since commit 3c85efb8f15ffa5bd165881b9fd1f9e5dd1d705f:
  bna: remove set but not used variable 'pgoff'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Brett Creeley (6):
  ice: Support UDP segmentation offload
  ice: Fix VF spoofchk
  ice: Add code to keep track of current dflt_vsi
  ice: Add ice_for_each_vf() macro
  ice: Fix VF link state when it's IFLA_VF_LINK_STATE_AUTO
  ice: Enable ip link show on the PF to display VF unicast MAC(s)

Bruce Allan (1):
  ice: suppress checked_return error

Jacob Keller (1):
  ice: Add device ids for E822 devices

Krzysztof Kazimierczak (2):
  ice: Add a boundary check in ice_xsk_umem()
  ice: Suppress Coverity warnings for xdp_rxq_info_reg

Michal Swiatkowski (3):
  ice: Set default value for ITR in alloc function
  ice: Restore interrupt throttle settings after VSI rebuild
  ice: Return error on not supported ethtool -C parameters

Mitch Williams (1):
  ice: add extra check for null Rx descriptor

Tony Nguyen (1):
  ice: Demote MTU change print to debug

Vignesh Sridhar (1):
  ice: Remove Rx flex descriptor programming

 drivers/net/ethernet/intel/ice/ice.h          |   8 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  16 +-
 drivers/net/ethernet/intel/ice/ice_common.c   | 104 ----
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   6 +
 drivers/net/ethernet/intel/ice/ice_devids.h   |  18 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  57 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   9 -
 drivers/net/ethernet/intel/ice/ice_lib.c      | 254 ++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.h      |   8 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  64 ++-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |  12 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  28 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   6 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 485 +++++++++---------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   3 +-
 16 files changed, 672 insertions(+), 410 deletions(-)

-- 
2.24.1

