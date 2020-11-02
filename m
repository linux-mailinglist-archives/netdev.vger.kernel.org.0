Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB862A3672
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgKBWYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:24:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:16120 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgKBWYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:24:16 -0500
IronPort-SDR: gm0IkIr63KWtlCGkA1R+E16odZ9G+4JkcBoFFcRuDXVWYzWU7527/yfzSc7DMHloxEURO43uqe
 Q3HjHtyF4xgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="253670957"
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="253670957"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 14:24:16 -0800
IronPort-SDR: fu+niZVxn4Ai0KwQjxl+u1tHf19H4RXUUGVfU8hwECOP2VmcI8ImWVcQ+F89Obq3KpB02UezQI
 DcW71vGVenFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,446,1596524400"; 
   d="scan'208";a="305591756"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2020 14:24:15 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2020-11-02
Date:   Mon,  2 Nov 2020 14:23:23 -0800
Message-Id: <20201102222338.1442081-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Bruce changes the allocation of ice_flow_prof_params from stack to heap to
avoid excessive stack usage. Corrects a misleading comment and silences a
sparse warning that is not a problem.

Tony renames Flow Director functions to be more generic as their use
is expanded.

Real expands ntuple support to allow for mask values to be specified. This
is done by implementing ACL filtering in HW.

Paul allows for HW initialization to continue if PHY abilities cannot
be obtained.

Jeb removes bypassing FW link override and reading Option ROM and
netlist information for non-E810 devices as this is now available on
other devices.

Nick removes vlan_ena field as this information can be gathered by
checking num_vlan.

Jake combines format strings and debug prints to the same line.

Simon adds a space to fix string concatenation.

The following are changes since commit c43fd36f7fec6c227c5e8a8ddd7d3fe97472182f:
  net: bridge: mcast: fix stub definition of br_multicast_querier_exists
and are available in the git repository at:
  https://github.com/anguy11/next-queue.git 100GbE

Bruce Allan (3):
  ice: cleanup stack hog
  ice: cleanup misleading comment
  ice: silence static analysis warning

Jacob Keller (1):
  ice: join format strings to same line as ice_debug

Jeb Cramer (2):
  ice: Enable Support for FW Override (E82X)
  ice: Remove gate to OROM init

Nick Nunley (1):
  ice: Remove vlan_ena from vsi structure

Paul M Stillwell Jr (1):
  ice: don't always return an error for Get PHY Abilities AQ command

Real Valiquette (5):
  ice: initialize ACL table
  ice: initialize ACL scenario
  ice: create flow profile
  ice: create ACL entry
  ice: program ACL entry

Simon Perron Caissy (1):
  ice: Add space to unknown speed

Tony Nguyen (1):
  ice: rename shared Flow Director functions

 drivers/net/ethernet/intel/ice/Makefile       |    3 +
 drivers/net/ethernet/intel/ice/ice.h          |   26 +-
 drivers/net/ethernet/intel/ice/ice_acl.c      |  482 +++++++
 drivers/net/ethernet/intel/ice/ice_acl.h      |  188 +++
 drivers/net/ethernet/intel/ice/ice_acl_ctrl.c | 1145 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_acl_main.c |  328 +++++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  400 +++++-
 drivers/net/ethernet/intel/ice/ice_common.c   |  108 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c |   42 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |    8 +-
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  448 ++++--
 drivers/net/ethernet/intel/ice/ice_fdir.c     |   15 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h     |    5 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   40 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |    7 +
 drivers/net/ethernet/intel/ice/ice_flow.c     | 1253 ++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_flow.h     |   38 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |    3 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   10 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   70 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c      |   61 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |   21 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |   15 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |    5 +
 24 files changed, 4355 insertions(+), 366 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl_ctrl.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_acl_main.c

-- 
2.26.2

