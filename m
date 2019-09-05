Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FF3AAD0D
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391648AbfIEUeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:45332 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390393AbfIEUeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136531"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/16][pull request] 100GbE Intel Wired LAN Driver Updates 2019-09-05
Date:   Thu,  5 Sep 2019 13:33:50 -0700
Message-Id: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver.

Brett fixes the setting of num_q_vectors by using the maximum number
between the allocated transmit and receive queues.

Anirudh simplifies the code to use a helper function to return the main
VSI, which is the first element in the pf->vsi array.  Adds a pointer
check to prevent a NULL pointer dereference.  Adds a check to ensure we
do not initialize DCB on devices that are not DCB capable.  Does some
housekeeping on the code to remove unnecessary indirection and reduce
the PF structure by removing elements that are not needed since the
values they were storing can be readily gotten from
ice_get_avail_*_count()'s.  Updates the printed strings to make it
easier to search the logs for driver capabilities.

Jesse cleans up unnecessary function arguments.  Updated the code to use
prefetch() to add some efficiency to the driver to avoid a cache miss.
Did some housekeeping on the code to remove the configurable transmit
work limit via ethtool which ended up creating performance overhead.
Made additional performance enhancements by updating the driver to start
out with a reasonable number of descriptors by changing the default to
2048.

Mitch fixes the reset logic for VFs by clearing VF_MBX_ARQLEN register
when the source of the reset is not PFR.

Lukasz updates the driver to include a similar fix for the i40e driver
by reporting link down for VF's when the PF queues are not enabled.

Akeem updates the driver to report the VF link status once we get VF
resources so that we can reflect the link status similarly to how the PF
reports link speed.

Ashish updates the transmit context structure based on recent changes to
the hardware specification.

Dave updates the DCB logic to allow a delayed registration for MIB
change events so that the driver is not accepting events before it is
ready for them.

The following are changes since commit 0e5b36bc4c1fccfc18dd851d960781589c16dae8:
  r8152: adjust the settings of ups flags
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (1):
  ice: Report VF link status with opcode to get resources

Anirudh Venkataramanan (5):
  ice: Add ice_get_main_vsi to get PF/main VSI
  ice: Check root pointer for validity
  ice: Check for DCB capability before initializing DCB
  ice: Minor refactor in queue management
  ice: Rework around device/function capabilities

Ashish Shah (1):
  ice: update Tx context struct

Brett Creeley (1):
  ice: Update fields in ice_vsi_set_num_qs when reconfiguring

Dave Ertman (1):
  ice: Allow for delayed LLDP MIB change registration

Jesse Brandeburg (5):
  ice: clean up arguments
  ice: move code closer together
  ice: small efficiency fixes
  ice: change work limit to a constant
  ice: change default number of receive descriptors

Lukasz Czapnik (1):
  ice: report link down for VF when PF's queues are not enabled

Mitch Williams (1):
  ice: Reliably reset VFs

 drivers/net/ethernet/intel/ice/ice.h          | 46 +++---------
 drivers/net/ethernet/intel/ice/ice_common.c   | 43 +++++------
 drivers/net/ethernet/intel/ice/ice_dcb.c      | 39 +++++++++-
 drivers/net/ethernet/intel/ice/ice_dcb.h      | 11 +--
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  7 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 24 +++---
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |  1 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 29 ++++----
 drivers/net/ethernet/intel/ice/ice_main.c     | 73 +++++++++++--------
 drivers/net/ethernet/intel/ice/ice_sched.c    |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 53 +++++++-------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 36 +++++----
 12 files changed, 195 insertions(+), 169 deletions(-)

-- 
2.21.0

