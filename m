Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257D5400256
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 17:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhICPbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 11:31:22 -0400
Received: from mga14.intel.com ([192.55.52.115]:5963 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349724AbhICPbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 11:31:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10096"; a="219150078"
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="219150078"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 08:30:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,265,1624345200"; 
   d="scan'208";a="500491541"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by fmsmga008.fm.intel.com with ESMTP; 03 Sep 2021 08:30:10 -0700
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [RFC v4 net-next 0/2] Add RTNL interface for SyncE
Date:   Fri,  3 Sep 2021 17:14:34 +0200
Message-Id: <20210903151436.529478-1-maciej.machnikowski@intel.com>
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

Next steps:
 - add interface to enable source clocks and get information about them
 - properly return the EEC_SRC_PORT flag depending on the port recovered
   clock being enabled and locked

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

Maciej Machnikowski (2):
  rtnetlink: Add new RTM_GETEECSTATE message to get SyncE status
  ice: add support for reading SyncE DPLL state

 drivers/net/ethernet/intel/ice/ice.h          |  5 ++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 34 +++++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 62 ++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  4 ++
 drivers/net/ethernet/intel/ice/ice_devids.h   |  3 +
 drivers/net/ethernet/intel/ice/ice_main.c     | 29 ++++++++
 drivers/net/ethernet/intel/ice/ice_ptp.c      | 35 +++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   | 44 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   | 22 ++++++
 include/linux/netdevice.h                     |  6 ++
 include/uapi/linux/if_link.h                  | 31 ++++++++
 include/uapi/linux/rtnetlink.h                |  3 +
 net/core/rtnetlink.c                          | 71 +++++++++++++++++++
 security/selinux/nlmsgtab.c                   |  3 +-
 14 files changed, 351 insertions(+), 1 deletion(-)

-- 
2.26.3

