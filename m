Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8CB433E75
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhJSSe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:34:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:51639 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231783AbhJSSe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:34:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="226058554"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="226058554"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 11:32:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="444602696"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 19 Oct 2021 11:32:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/10][pull request] 100GbE Intel Wired LAN Driver Updates 2021-10-19
Date:   Tue, 19 Oct 2021 11:30:17 -0700
Message-Id: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Brett implements support for ndo_set_vf_rate allowing for min_tx_rate
and max_tx_rate to be set for a VF.

Jesse updates DIM moderation to improve latency and resolves problems
with reported rate limit and extra software generated interrupts.

Wojciech moves a check for trusted VFs to the correct function,
disables lb_en for switchdev offloads, and refactors ethtool ops due
to differences in support for PF and port representor support.

Cai Huoqing utilizes the helper function devm_add_action_or_reset().

Gustavo A. R. Silva replaces uses of allocation to devm_kcalloc() as
applicable.

Dan Carpenter propagates an error instead of returning success.

The following are changes since commit 05be94633783ffb3ad5b0aca7f6cff08cad6868d:
  net: ethernet: ixp4xx: Make use of dma_pool_zalloc() instead of dma_pool_alloc/memset()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Brett Creeley (1):
  ice: Add support for VF rate limiting

Cai Huoqing (1):
  ice: Make use of the helper function devm_add_action_or_reset()

Dan Carpenter (1):
  ice: fix an error code in ice_ena_vfs()

Gustavo A. R. Silva (1):
  ice: use devm_kcalloc() instead of devm_kzalloc()

Jesse Brandeburg (3):
  ice: update dim usage and moderation
  ice: fix rate limit update after coalesce change
  ice: fix software generating extra interrupts

Wojciech Drewek (3):
  ice: Forbid trusted VFs in switchdev mode
  ice: Manage act flags for switchdev offloads
  ice: Refactor PR ethtool ops

 drivers/net/ethernet/intel/ice/ice_devlink.c  |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 116 +++++++---
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |   4 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c     | 127 -----------
 drivers/net/ethernet/intel/ice/ice_fltr.h     |   4 -
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
 drivers/net/ethernet/intel/ice/ice_lib.c      | 203 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.h      |   5 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 120 ++++++-----
 drivers/net/ethernet/intel/ice/ice_sched.c    | 130 +++++++++++
 drivers/net/ethernet/intel/ice/ice_sched.h    |   6 +
 drivers/net/ethernet/intel/ice/ice_switch.c   |   9 +-
 drivers/net/ethernet/intel/ice/ice_switch.h   |  11 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |   8 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 114 +++++-----
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 173 ++++++++++++++-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |  15 +-
 17 files changed, 764 insertions(+), 286 deletions(-)

-- 
2.31.1

