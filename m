Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEA1F3AFF
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfKGWOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:14:41 -0500
Received: from mga07.intel.com ([134.134.136.100]:16680 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfKGWOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 17:14:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 14:14:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,279,1569308400"; 
   d="scan'208";a="233420877"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 07 Nov 2019 14:14:39 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2019-11-07
Date:   Thu,  7 Nov 2019 14:14:23 -0800
Message-Id: <20191107221438.17994-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another series that contains updates to the ice driver only.

Anirudh cleans up the code of kernel config of ifdef wrappers by moving
code that is needed by DCB to disable and enable the PF VSI for
configuration.  Implements ice_vsi_type_str() to convert an VSI type
enum value to its string equivalent to help identify VSI types from
module print statements.

Usha and Tarun add support for setting the maximum per-queue bit rate
for transmit queues.

Dave implements dcb_nl set functions and supporting software DCB
functions to support the callbacks defined in the dcbnl_rtnl_ops
structure.

Henry adds a check to ensure we are not resetting the device when trying
to configure it, and to return -EBUSY during a reset.

Usha fixes a call trace caused by the receive/transmit descriptor size
change request via ethtool when DCB is configured by using the number of
enabled queues and not the total number of allocated queues.

Paul cleans up and refactors the software LLDP configuration to handle
when firmware DCBX is disabled.

Akeem adds checks to ensure the VF or PF is not disabled before honoring
mailbox messages to configure the VF.

Brett corrects the check to make sure the vector_id passed down from
iavf is less than the max allowed interrupts per VF.  Updates a flag bit
to align with the current specification.

Bruce updates a switch statement to use the correct status of the
Download Package AQ command.  Does some housekeeping by cleaning up a
conditional check that is not needed.

Mitch shortens up the delay for SQ responses to resolve issues with VF
resets failing.

Jake cleans up the code reducing namespace pollution and to simplify
ice_debug_cq() since it always uses the same mask, not need to pass it
in.  Improve debugging by adding the command opcode in the debug
messages that print an error code.

The following are changes since commit 1c8dd9cb4697a425ecb9e9fb8a6c05955642e141:
  net_sched: gen_estimator: extend packet counter to 64bit
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Akeem G Abodunrin (1):
  ice: Check if VF is disabled for Opcode and other operations

Anirudh Venkataramanan (2):
  ice: Use ice_ena_vsi and ice_dis_vsi in DCB configuration flow
  ice: Introduce and use ice_vsi_type_str

Brett Creeley (2):
  ice: Change max MSI-x vector_id check in cfg_irq_map
  ice: Update enum ice_flg64_bits to current specification

Bruce Allan (2):
  ice: use pkg_dwnld_status instead of sq_last_status
  ice: remove unnecessary conditional check

Dave Ertman (1):
  ice: Implement DCBNL support

Henry Tieman (1):
  ice: avoid setting features during reset

Jacob Keller (2):
  ice: use more accurate ICE_DBG mask types
  ice: print opcode when printing controlq errors

Mitch Williams (1):
  ice: delay less

Paul Greenwalt (1):
  ice: configure software LLDP in ice_init_pf_dcb

Usha Ketineni (2):
  ice: Add NDO callback to set the maximum per-queue bitrate
  ice: Fix to change Rx/Tx ring descriptor size via ethtool with DCBx

 drivers/net/ethernet/intel/ice/Makefile       |    2 +-
 drivers/net/ethernet/intel/ice/ice.h          |    6 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   46 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   60 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |    4 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c |   65 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h |    5 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   71 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   23 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |  933 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_dcb_nl.h   |   19 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   19 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    3 +
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |    2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |   92 +-
 drivers/net/ethernet/intel/ice/ice_lib.h      |    6 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  154 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    | 1264 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_sched.h    |   39 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |    3 +-
 drivers/net/ethernet/intel/ice/ice_switch.h   |    5 -
 drivers/net/ethernet/intel/ice/ice_type.h     |   65 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   82 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |    1 +
 24 files changed, 2751 insertions(+), 218 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dcb_nl.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dcb_nl.h

-- 
2.21.0

