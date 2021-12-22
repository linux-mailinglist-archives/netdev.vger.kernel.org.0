Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3443347D571
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 17:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344019AbhLVQzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 11:55:23 -0500
Received: from mga04.intel.com ([192.55.52.120]:28740 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235517AbhLVQzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 11:55:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640192123; x=1671728123;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2r5w7nqb1bcFqkZUjfTZWm4iuC1IJSP0qx+HAYi18vw=;
  b=Phc0xesC+PE66Z739jywVc9GiW1nQGIQ9zJSISkjJIcE0Rg121fa4k1Y
   Izr7klkAiBjHaJTSrWKLVZE+jE3a3lv63Mbi6yA2sbiaSgZs19llwGDSR
   slAwwV4QLjidxO6PnCNnmAh2WCIx8qsaZZx0uVNSkWhTEcYLHbSqTXfj4
   Rsfx2LOTmvOMrBKNoCN/8hpbPJ9hoDANPmPAJu9OMAQFBeBa/Xcf2qjz6
   NxeRVpEkXQF2U0xC1qiIhqqxrVNAFB6eHyiTPfz23+WewrM3DtDUGj8r2
   reYWRdH4dMc3Yx/hmdz0EgNDRMj/evp9op+nv6VgwuJTdP/3NxQa4zASl
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="239411920"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="239411920"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 08:55:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="468230211"
Received: from lajkonik.igk.intel.com ([10.211.8.72])
  by orsmga006.jf.intel.com with ESMTP; 22 Dec 2021 08:55:17 -0800
From:   Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com,
        petrm@nvidia.com, vfedorenko@novek.ru,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Subject: [PATCH v6 net-next 0/4] Add ethtool interface for RClocks
Date:   Wed, 22 Dec 2021 11:39:49 -0500
Message-Id: <20211222163952.413183-1-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.31.1
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

v6:
- adapt to removal of 'enum ice_status' in net-next

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

Arkadiusz Kubalewski (4):
  ice: add support detecting features based on netlist
  ethtool: Add ability to configure recovered clock for SyncE feature
  ice: add support for monitoring SyncE DPLL state
  ice: add support for recovered clocks

 Documentation/networking/ethtool-netlink.rst  |  62 ++++
 drivers/net/ethernet/intel/ice/ice.h          |   7 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  70 ++++-
 drivers/net/ethernet/intel/ice/ice_common.c   | 224 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  20 ++
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
 18 files changed, 930 insertions(+), 3 deletions(-)
 create mode 100644 net/ethtool/synce.c

-- 
2.31.1

