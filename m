Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2012444C083
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhKJMCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:02:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:54408 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231808AbhKJMCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 07:02:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="293484796"
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="293484796"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 03:59:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,223,1631602800"; 
   d="scan'208";a="452276498"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by orsmga003.jf.intel.com with ESMTP; 10 Nov 2021 03:59:48 -0800
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        petrm@nvidia.com
Subject: [PATCH v3 net-next 0/6] Add RTNL interface for SyncE
Date:   Wed, 10 Nov 2021 12:44:42 +0100
Message-Id: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synchronous Ethernet networks use a physical layer clock to syntonize
the frequency across different network elements.

Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
Equipment Clock (EEC) and have the ability to recover synchronization
from the synchronization inputs - either traffic interfaces or external
frequency sources.
The EEC can synchronize its frequency (syntonize) to any of those sources.
It is also able to select synchronization source through priority tables
and synchronization status messaging. It also provides neccessary
filtering and holdover capabilities

This patch series introduces basic interface for reading the Ethernet
Equipment Clock (EEC) state on a SyncE capable device. This state gives
information about the source of the syntonization signal (ether my port,
or any external one) and the state of EEC. This interface is required\
to implement Synchronization Status Messaging on upper layers.

v3:
- remove RTM_GETRCLKRANGE
- return state of all possible pins in the RTM_GETRCLKSTATE
- clarify documentation

v2:
- improved documentation
- fixed kdoc warning

RFC history:
v2:
- removed whitespace changes
- fix issues reported by test robot
v3:
- Changed naming from SyncE to EEC
- Clarify cover letter and commit message for patch 1
v4:
- Removed sync_source and pin_idx info
- Changed one structure to attributes
- Added EEC_SRC_PORT flag to indicate that the EEC is synchronized
  to the recovered clock of a port that returns the state
v5:
- add EEC source as an optiona attribute
- implement support for recovered clocks
- align states returned by EEC to ITU-T G.781
v6:
- fix EEC clock state reporting
- add documentation
- fix descriptions in code comments

Maciej Machnikowski (6):
  ice: add support detecting features based on netlist
  rtnetlink: Add new RTM_GETEECSTATE message to get SyncE status
  ice: add support for reading SyncE DPLL state
  rtnetlink: Add support for SyncE recovered clock configuration
  ice: add support for SyncE recovered clocks
  docs: net: Add description of SyncE interfaces

 Documentation/networking/synce.rst            | 124 ++++++++++
 drivers/net/ethernet/intel/ice/ice.h          |   7 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  94 +++++++-
 drivers/net/ethernet/intel/ice/ice_common.c   | 224 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  20 +-
 drivers/net/ethernet/intel/ice/ice_devids.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   6 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 137 +++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  34 +++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  49 ++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  22 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 include/linux/netdevice.h                     |  33 +++
 include/uapi/linux/if_link.h                  |  49 ++++
 include/uapi/linux/rtnetlink.h                |  16 +-
 net/core/rtnetlink.c                          | 189 +++++++++++++++
 security/selinux/nlmsgtab.c                   |   5 +-
 17 files changed, 1005 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/networking/synce.rst

-- 
2.26.3

