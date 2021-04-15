Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A406F35FED9
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhDOA2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:28:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:27420 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231417AbhDOA2s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:48 -0400
IronPort-SDR: ubFIcoJznlWYD/XezHq9hmfEhu2+nqbT1CtwcHC5M8iYsT32JGQzdZwmSHHo6FeonZ2d0uGnVX
 h3aENHvGRPeA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262220"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262220"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:26 -0700
IronPort-SDR: oxFzncmYtjpcmxjw5I38r3xCqMz2cOPSg4w4QGun3MCqlhE8EiZeo9m9fXJxlQnrN1FnTHoFMJ
 ThgkHFLOZmDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379491"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2021-04-14
Date:   Wed, 14 Apr 2021 17:29:58 -0700
Message-Id: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Bruce changes and removes open coded values to instead use existing
kernel defines and suppresses false cppcheck issues.

Ani adds new VSI states to track netdev allocation and registration. He
also removes leading underscores in the ice_pf_state enum.

Jesse refactors ITR by introducing helpers to reduce duplicated code and
structures to simplify checking of ITR mode. He also triggers a software
interrupt when exiting napi poll or busy-poll to ensure all work is
processed. Modifies /proc/iomem to display driver name instead of PCI
address. He also changes the checks of vsi->type to use a local variable
in ice_vsi_rebuild() and removes an unneeded struct member.

Jake replaces the driver's adaptive interrupt moderation algorithm to
use the kernel's DIM library implementation.

Scott reworks module reads to reduce the number of reads needed and
remove excessive increment of QSFP page.

Brett sets the vsi->vf_id to invalid for non-VF VSIs.

Paul removes the return value from ice_vsi_manage_rss_lut() as it's not
communicating anything critical. He also reduces the scope of a
variable.

The following are changes since commit 3a1aa533f7f676aad68f8dbbbba10b9502903770:
  Merge tag 'linux-can-next-for-5.13-20210414' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anirudh Venkataramanan (2):
  ice: Drop leading underscores in enum ice_pf_state
  ice: Add new VSI states to track netdev alloc/registration

Brett Creeley (1):
  ice: Set vsi->vf_id as ICE_INVAL_VFID for non VF VSI types

Bruce Allan (2):
  ice: use kernel definitions for IANA protocol ports and ether-types
  ice: suppress false cppcheck issues

Jacob Keller (1):
  ice: replace custom AIM algorithm with kernel's DIM library

Jesse Brandeburg (6):
  ice: refactor interrupt moderation writes
  ice: manage interrupts during poll exit
  ice: refactor ITR data structures
  ice: print name in /proc/iomem
  ice: use local for consistency
  ice: remove unused struct member

Paul M Stillwell Jr (2):
  ice: remove return variable
  ice: reduce scope of variable

Scott W Taylor (1):
  ice: Reimplement module reads used by ethtool

 drivers/net/ethernet/intel/Kconfig            |   1 +
 drivers/net/ethernet/intel/ice/ice.h          |  78 ++--
 drivers/net/ethernet/intel/ice/ice_base.c     |  25 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c |   6 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h |   1 -
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   8 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 105 ++++--
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |   2 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   3 +
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 236 ++++++------
 drivers/net/ethernet/intel/ice/ice_lib.h      |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 353 ++++++++++++------
 drivers/net/ethernet/intel/ice/ice_nvm.c      |   1 +
 drivers/net/ethernet/intel/ice/ice_sched.c    |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 314 +++-------------
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  36 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 -
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    |   6 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  25 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   9 +-
 22 files changed, 597 insertions(+), 624 deletions(-)

-- 
2.26.2

