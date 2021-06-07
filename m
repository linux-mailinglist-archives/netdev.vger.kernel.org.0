Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D69E39E488
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 18:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhFGQxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 12:53:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:16640 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231419AbhFGQxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 12:53:05 -0400
IronPort-SDR: KuNc64MPpUR29L1XPD+Q+/+RRt7SgEAFj6UXc6yVx8wHm9wD/cMoy4IM8CuQ5JfKmmL0RaqTUV
 A5Zv3yk5ELdg==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="268516243"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="268516243"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:50:52 -0700
IronPort-SDR: d+9n/r41a9dh9HzoY3PicUW4Yww6OI8JGXRXuCqBr9Kf/IbILjfV7uDVaa4q4MhXCn6dR7Sf1r
 YDFz/XeYkbHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="484841209"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2021 09:50:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/15][pull request] 100GbE Intel Wired LAN Driver Updates 2021-06-07
Date:   Mon,  7 Jun 2021 09:53:10 -0700
Message-Id: <20210607165325.182087-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to virtchnl header file and ice driver.

Brett adds capability bits to virtchnl to specify whether a primary or
secondary MAC address is being requested and adds the implementation to
ice. He also adds storing of VF MAC address so that it will be preserved
across reboots of VM and refactors VF queue configuration to remove the
expectation that configuration be done all at once.

Krzysztof refactors ice_setup_rx_ctx() to remove configuration not
related to Rx context into a new function, ice_vsi_cfg_rxq().

Liwei Song extends the wait time for the global config timeout.

Salil Mehta refactors code in ice_vsi_set_num_qs() to remove an
unnecessary call when the user has requested specific number of Rx or Tx
queues.

Jesse converts define macros to static inlines for NOP configurations.

Jake adds messaging when devlink fails to read device capabilities and
when pldmfw cannot find the requested firmware. Adds a wait for reset
completion when reporting devlink info and reinitializes NVM during
rebuild to ensure values are current.

Ani adds detection and reporting of modules exceeding supported power
levels and changes an error message to a debug message.

Paul fixes a clang warning for deadcode.DeadStores.

The following are changes since commit 1a42624aecba438f1d114430a14b640cdfa51c87:
  net: dsa: xrs700x: allow HSR/PRP supervision dupes for node_table
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Anirudh Venkataramanan (2):
  ice: Detect and report unsupported module power levels
  ice: downgrade error print to debug print

Brett Creeley (4):
  virtchnl: Use pad byte in virtchnl_ether_addr to specify MAC type
  ice: Manage VF's MAC address for both legacy and new cases
  ice: Save VF's MAC across reboot
  ice: Refactor VIRTCHNL_OP_CONFIG_VSI_QUEUES handling

Jacob Keller (4):
  ice: add extack when unable to read device caps
  ice: add error message when pldmfw_flash_image fails
  ice: wait for reset before reporting devlink info
  ice: (re)initialize NVM fields when rebuilding

Jesse Brandeburg (1):
  ice: use static inline for dummy functions

Krzysztof Kazimierczak (1):
  ice: Refactor ice_setup_rx_ctx

Liwei Song (1):
  ice: set the value of global config lock timeout longer

Paul M Stillwell Jr (1):
  ice: fix clang warning regarding deadcode.DeadStores

Salil Mehta (1):
  ice: Re-organizes reqstd/avail {R, T}XQ check/code for efficiency

 drivers/net/ethernet/intel/ice/ice.h          |   3 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   6 +-
 drivers/net/ethernet/intel/ice/ice_arfs.h     |  12 +-
 drivers/net/ethernet/intel/ice/ice_base.c     | 120 ++++++----
 drivers/net/ethernet/intel/ice/ice_base.h     |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |   2 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  15 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.h   |   9 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   9 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   6 +-
 .../net/ethernet/intel/ice/ice_fw_update.c    |  10 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  81 +++++--
 drivers/net/ethernet/intel/ice/ice_lib.h      |   5 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  51 ++++
 drivers/net/ethernet/intel/ice/ice_type.h     |   3 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 226 ++++++++++++++----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  31 ++-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.h      |   4 +-
 include/linux/avf/virtchnl.h                  |  29 ++-
 20 files changed, 474 insertions(+), 152 deletions(-)

-- 
2.26.2

