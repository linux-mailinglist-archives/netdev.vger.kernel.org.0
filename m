Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B733F9B8FA
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfHWXiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:38:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:14902 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbfHWXhw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:37:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 16:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="184354404"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 23 Aug 2019 16:37:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/14][pull request] 100GbE Intel Wired LAN Driver Updates 2019-08-23
Date:   Fri, 23 Aug 2019 16:37:36 -0700
Message-Id: <20190823233750.7997-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Dave adds logic for the necessary bits to be set in the VSI context for
the PF_VSI and the TX_descriptors for control packets egressing the
PF_VSI.  Updated the logic to detect both DCBx and LLDP states in the
firmware engine to account for situations where DCBx is enabled and LLDP
is disabled.  Fixed the driver to treat the DCBx state of "NOT_STARTED"
as a valid state and should not assume "is_fw_lldp" true automatically.
Since "enable-fw-lldp" flag was confusing and cumbersome, change the
flag to "fw-lldp-agent" with a value of on or off to help clarify
whether the LLDP agent is running or not.

Brett fixes an issue where synchronize_irq() was being called from the
host of VF's, which should not be done.

Michal fixed an issue when rebuilding the DCBx configuration while in
IEEE mode versus CEE mode, so add a check before copying the
configuration value to ensure we are only in CEE mode.

Jake fixes the PF to reject any VF request to setup head writeback since
the support has been deprecated.

Mitch adds an additional check to ensure the VF is active before sending
out an error message that a message was unable to be sent to a
particular VF.

Chinh updates the driver to use "topology" mode when checking the PHY
for status, since this mode provides us the current module type that is
available.  Fixes the driver from clearing the auto_fec_enable bit which
was blocking a user from forcing non-spec compliant FEC configurations.

Amruth does a refactor on the code to first check, then assign in the
virtual channel space.

Bruce updates the driver to actually update the stats when a user runs
the ethtool command 'ethtool -S <iface>' instead of providing a snapshot
of the stats that maybe from a second ago.

Akeem fixes up the adding/removing of VSI MAC filters for VFs, so that
VFs cannot add/remove a filter from another VSI.  We now track the
number of filters added right from when the VF resources get allocated
and won't get into MAC filter mis-match issue in the switch.

The following are changes since commit 6d24e14140053febc5ac1ce46baca6a4334c5f6c:
  net/ncsi: update response packet length for GCPS/GNS/GNPTS commands
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (2):
  ice: Fix issues updating VSI MAC filters
  ice: Don't allow VSI to remove unassociated ucast filter

Amruth G.P (1):
  ice: Add input handlers for virtual channel handlers

Brett Creeley (1):
  ice: Don't call synchronize_irq() for VF's from the host

Bruce Allan (1):
  ice: update ethtool stats on-demand

Chinh T Cao (2):
  ice: Fix flag used for module query
  ice: Don't clear auto_fec bit in ice_cfg_phy_fec()

Dave Ertman (4):
  ice: Allow egress control packets from PF_VSI
  ice: Account for all states of FW DCBx and LLDP
  ice: Treat DCBx state NOT_STARTED as valid
  ice: Rename ethtool private flag for lldp

Jacob Keller (1):
  ice: reject VF attempts to enable head writeback

Michal Swiatkowski (1):
  ice: Copy dcbx configuration only if mode is correct

Mitch Williams (1):
  ice: silence some bogus error messages

 drivers/net/ethernet/intel/ice/ice.h          |   4 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_common.c   |  11 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   3 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  42 +++----
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  13 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  45 ++++++-
 drivers/net/ethernet/intel/ice/ice_lib.h      |   4 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  70 +++--------
 drivers/net/ethernet/intel/ice/ice_switch.c   |  56 +++++++++
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  11 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 113 +++++++++---------
 12 files changed, 225 insertions(+), 148 deletions(-)

-- 
2.21.0

