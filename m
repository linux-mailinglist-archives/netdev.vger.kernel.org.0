Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D5B23533C
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgHAQSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:08 -0400
Received: from mga05.intel.com ([192.55.52.43]:19604 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgHAQSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:07 -0400
IronPort-SDR: CwHmgcvTkfwK2eC3i+9Ru7dL7dj3Oyovk6xa8BRg03l8eoXz1bajTJJt40lYqNrSSMk1fVLwF9
 LULnpozweRVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810840"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810840"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:07 -0700
IronPort-SDR: t7IdeNJuHyYACdlpuRiF5sGEUYYKxB6jjA/YNF1smRQjhjX1BZ+4It9XEo0fcRaPN4Q3wD7O8h
 YN8eu2V6ragw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457686"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next 00/14][pull request] 100GbE Intel Wired LAN Driver Updates 2020-08-01
Date:   Sat,  1 Aug 2020 09:17:48 -0700
Message-Id: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Wei Yongjun marks power management functions with __maybe_unused.

Nick disables VLAN pruning in promiscuous mode and renames grst_delay to
grst_timeout.

Kiran modifies the check for linearization and corrects the vsi_id mask
value.

Vignesh replaces the use of flow profile locks to RSS profile locks for RSS
rule removal. Destroys flow profile lock on clearing XLT table and
clears extraction sequence entries.

Jesse adds some statistics and removes an unreported one.

Brett allows for 2 queue configuration for VFs.

Surabhi adds a check for failed allocation of an extraction sequence
table.

Tony updates the PTYPE lookup table and makes other trivial fixes.

Victor extends profile ID locks to be held until all references are
completed.

The following are changes since commit 8f3f330da28ede9d106cd9d5c5ccd6a3e7e9b50b:
  tun: add missing rcu annotation in tun_set_ebpf()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Brett Creeley (1):
  ice: Allow 2 queue pairs per VF on SR-IOV initialization

Jesse Brandeburg (2):
  ice: remove page_reuse statistic
  ice: add useful statistics

Kiran Patil (2):
  ice: fix the vsi_id mask to be 10 bit for set_rss_lut
  ice: port fix for chk_linearlize

Nick Nunley (2):
  ice: rename misleading grst_delay variable
  ice: Disable VLAN pruning in promiscuous mode

Surabhi Boob (1):
  ice: Graceful error handling in HW table calloc failure

Tony Nguyen (2):
  ice: update PTYPE lookup table
  ice: Misc minor fixes

Victor Raj (1):
  ice: adjust profile ID map locks

Vignesh Sridhar (2):
  ice: Fix RSS profile locks
  ice: Clear and free XLT entries on reset

Wei Yongjun (1):
  ice: mark PM functions as __maybe_unused

 drivers/net/ethernet/intel/ice/ice.h          |   1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |   2 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  15 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   4 +
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 100 +++---
 drivers/net/ethernet/intel/ice/ice_flow.c     |  13 +-
 .../net/ethernet/intel/ice/ice_hw_autogen.h   |   4 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 314 ++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.c      |   7 +
 drivers/net/ethernet/intel/ice/ice_main.c     |  11 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  35 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   7 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   6 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   2 -
 19 files changed, 445 insertions(+), 87 deletions(-)

-- 
2.26.2

