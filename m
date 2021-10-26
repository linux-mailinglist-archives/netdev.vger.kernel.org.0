Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EF743B87D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhJZRtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:49:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:61969 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232378AbhJZRtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:49:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="316178659"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="316178659"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 10:46:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="494318026"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by fmsmga007.fm.intel.com with ESMTP; 26 Oct 2021 10:46:42 -0700
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com
Subject: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
Date:   Tue, 26 Oct 2021 19:31:41 +0200
Message-Id: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
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

Maciej Machnikowski (5):
  ice: add support detecting features based on netlist
  rtnetlink: Add new RTM_GETEECSTATE message to get SyncE status
  ice: add support for reading SyncE DPLL state
  rtnetlink: Add support for SyncE recovered clock configuration
  ice: add support for SyncE recovered clocks

 drivers/net/ethernet/intel/ice/ice.h          |   7 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  94 ++++++-
 drivers/net/ethernet/intel/ice/ice_common.c   | 175 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  17 +-
 drivers/net/ethernet/intel/ice/ice_devids.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   6 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 138 ++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  34 +++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  94 +++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  25 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 include/linux/netdevice.h                     |  18 ++
 include/uapi/linux/if_link.h                  |  53 ++++
 include/uapi/linux/rtnetlink.h                |  10 +
 net/core/rtnetlink.c                          | 253 ++++++++++++++++++
 security/selinux/nlmsgtab.c                   |   6 +-
 16 files changed, 930 insertions(+), 4 deletions(-)

-- 
2.26.3

