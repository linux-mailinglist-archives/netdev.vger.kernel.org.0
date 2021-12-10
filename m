Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2DFD470234
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhLJOE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:04:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:18427 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234344AbhLJOE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 09:04:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639144852; x=1670680852;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+3xcxnlr+0V9wAyeoMluAwgNokJlt0chsySF41otqNk=;
  b=GKK4xjSpR9nGJN1KQ9ONToCqDKYOMw8ouS/055Vjq4em96rc+dTsFBGa
   zsc/s2xJ6zTK+26i1e1Yi1HhEtv4g+1zyO5z/htTMXHcV1zn4GgNHVyVk
   aqp9mT7YHJXlB3+C1K5/wWeuoWvzd2Jf6e1PyUKAzyWRpuv5nEOo2FrCR
   Ur2qAVgI8sJcfR+Uoqdgi7srXF7OH/k5Y1wLpK0a0doSbzIdpnoGv8ipX
   hQgabQtJeI8YMt3+cP8qIgQBpu27N7fxbq73fsmH6ZOC7ysqXiQew+zVO
   7NnUTQjcAF4Vpcgo5l8KnlfHJyGWMz+0q9GQ502A/8Nucrn5UZx/E2Th5
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="238150679"
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="238150679"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 06:00:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="612934611"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by orsmga004.jf.intel.com with ESMTP; 10 Dec 2021 06:00:48 -0800
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, arkadiusz.kubalewski@intel.com
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        petrm@nvidia.com
Subject: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Date:   Fri, 10 Dec 2021 14:45:46 +0100
Message-Id: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synchronous Ethernet networks use a physical layer clock to syntonize
the frequency across different network elements.

Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
Equipment Clock (EEC) and have the ability to synchronize to reference
frequency sources.

This patch series is a prerequisite for EEC object and adds ability
to enable recovered clocks in the physical layer of the netdev object.
Recovered clocks can be used as one of the reference signal by the EEC.

Further work is required to add the DPLL subsystem, link it to the
netdev object and create API to read the EEC DPLL state.

v5:
- rewritten the documentation
- fixed doxygen headers

v4:
- Dropped EEC_STATE reporting (TBD: DPLL subsystem)
- moved recovered clock configuration to ethtool netlink

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


Maciej Machnikowski (4):
  ice: add support detecting features based on netlist
  ethtool: Add ability to configure recovered clock for SyncE feature
  ice: add support for monitoring SyncE DPLL state
  ice: add support for recovered clocks

 Documentation/networking/ethtool-netlink.rst  |  62 ++++
 drivers/net/ethernet/intel/ice/ice.h          |   7 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  70 ++++-
 drivers/net/ethernet/intel/ice/ice_common.c   | 224 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  20 +-
 drivers/net/ethernet/intel/ice/ice_devids.h   |   3 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  96 +++++++
 drivers/net/ethernet/intel/ice/ice_lib.c      |   6 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  35 +++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  49 ++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  36 +++
 drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
 include/linux/ethtool.h                       |   9 +
 include/uapi/linux/ethtool_netlink.h          |  21 ++
 net/ethtool/Makefile                          |   3 +-
 net/ethtool/netlink.c                         |  20 ++
 net/ethtool/netlink.h                         |   4 +
 net/ethtool/synce.c                           | 267 ++++++++++++++++++
 18 files changed, 929 insertions(+), 4 deletions(-)
 create mode 100644 net/ethtool/synce.c

-- 
2.26.3

