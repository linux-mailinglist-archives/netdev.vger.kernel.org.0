Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B54D31457A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhBIBRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:17:22 -0500
Received: from mga07.intel.com ([134.134.136.100]:36409 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhBIBRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:17:10 -0500
IronPort-SDR: yVmUCIL8qBws299TgKJWkIM1m+Ew2KoC0rqS16AvWtWgkcCaZpu8uHaQZa3g0L0GnvViMuB0au
 ymVSwjMEofCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="245879728"
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="245879728"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 17:15:46 -0800
IronPort-SDR: XTk9UOIrKE7acFeRQiuREAMR6atB0WsWbKDD32512LrwO6CrEQvLVm91WB89MbqdKhSSfWJPA3
 crM6q6gsp+aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,163,1610438400"; 
   d="scan'208";a="487669584"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 08 Feb 2021 17:15:46 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/12][pull request] 100GbE Intel Wired LAN Driver Updates 2021-02-08
Date:   Mon,  8 Feb 2021 17:16:24 -0800
Message-Id: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver and documentation.

Brett adds a log message when a trusted VF goes in and out of promiscuous
for consistency with i40e driver.

Dave implements a new LLDP command that allows adding VSI destinations to
existing filters and adds support for netdev bonding events, current
support is software based.

Michal refactors code to move from VSI stored xsk_buff_pools to
netdev-provided ones.

Kiran implements the creation scheduler aggregator nodes and distributing
VSIs within the nodes.

Ben modifies rate limit calculations to use clock frequency from the
hardware instead of using a hardcoded one.

Jesse adds support for user to control writeback frequency.

Chinh refactors DCB variables out of the ice_port_info struct.

Bruce removes some unnecessary casting.

Mitch fixes an error message that was reported as if_up instead of if_down.

Tony adjusts fallback allocation for MSI-X to use all given vectors instead
of using only the minimum configuration and updates documentation for
the ice driver.

The following are changes since commit 08cbabb77e9098ec6c4a35911effac53e943c331:
  Merge tag 'mlx5-updates-2021-02-04' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Ben Shelton (1):
  ice: Use PSM clock frequency to calculate RL profiles

Brett Creeley (1):
  ice: log message when trusted VF goes in/out of promisc mode

Bruce Allan (1):
  ice: remove unnecessary casts

Chinh T Cao (1):
  ice: Refactor DCB related variables out of the ice_port_info struct

Dave Ertman (2):
  ice: implement new LLDP filter command
  ice: Add initial support framework for LAG

Jesse Brandeburg (1):
  ice: fix writeback enable logic

Kiran Patil (1):
  ice: create scheduler aggregator node config and move VSIs

Michal Swiatkowski (1):
  ice: Remove xsk_buff_pool from VSI structure

Mitch Williams (1):
  ice: Fix trivial error message

Tony Nguyen (2):
  ice: Improve MSI-X fallback logic
  Documentation: ice: update documentation

 .../device_drivers/ethernet/intel/ice.rst     | 1027 ++++++++++++-
 drivers/net/ethernet/intel/ice/Makefile       |    1 +
 drivers/net/ethernet/intel/ice/ice.h          |   52 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   25 +
 drivers/net/ethernet/intel/ice/ice_common.c   |   58 +-
 drivers/net/ethernet/intel/ice/ice_common.h   |    3 +
 drivers/net/ethernet/intel/ice/ice_controlq.c |    4 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |   40 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   47 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c   |   50 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   14 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |   10 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |    3 +
 drivers/net/ethernet/intel/ice/ice_lag.c      |  445 ++++++
 drivers/net/ethernet/intel/ice/ice_lag.h      |   87 ++
 drivers/net/ethernet/intel/ice/ice_lib.c      |  142 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   87 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    | 1283 +++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_sched.h    |   24 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |    2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   61 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |    1 -
 drivers/net/ethernet/intel/ice/ice_type.h     |   27 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   72 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   71 +-
 25 files changed, 3234 insertions(+), 402 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_lag.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_lag.h

-- 
2.26.2

