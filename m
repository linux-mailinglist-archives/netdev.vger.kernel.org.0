Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE734474B5C
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbhLNTAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:00:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:50829 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237253AbhLNTAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 14:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639508410; x=1671044410;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=A1M4GLY8vppEONsJyYCFbyxk2gj+Cn/f56NP9nkf18s=;
  b=KD4LPjKC7pqmrF3pCdBS+QGUjvmtarztXh1oXtaBbe7QuWWrZCYCObd2
   gdl/y0k8wh9E2vPBlUwFWHcC/oi7RwiT0L/FKd5tFEoFJUksW5d/xnqM4
   mjbyUVueLhCyTwEKwXeauCo7F/MrfJ9yLYadOwi6qe51cY3vVxVviAlYT
   5MYAwbFjKHBGSeBMTJmLs3gk6U+5eJCMQPECGk4eTqRofqaOtyBTUmMFj
   h0YqBgXmCGoblQ+0ze3eDBpvKl4ugSo/358QS8qryKxRJGkvz9fnKfhPT
   T/g+Y0rhHFk69tdFNbK3fs3tDAaQfKC0ajSPg2nVpmSHv21G5Y/gcB4FQ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="263200018"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="263200018"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 10:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="583712717"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2021 10:30:05 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 00/12][pull request] 100GbE Intel Wired LAN Driver Updates 2021-12-14
Date:   Tue, 14 Dec 2021 10:28:56 -0800
Message-Id: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Haiyue adds support to query hardware for supported PTYPEs.

Jeff changes PTYPE validation to utilize the capabilities queried from
the hardware instead of maintaining a per DDP support list.

Brett refactors promiscuous functions to provide common and clear
interfaces to call for configuration.

Wojciech modifies DDP package load to simplify determining the final
state of the load.

Tony removes the use of ice_status from the driver. This involves
removing string conversion functions, converting variables and values to
standard errors, and clean up. He also removes an unused define.

Dan Carpenter removes unneeded casts.

The following are changes since commit fe4c82a7e0f06abdf5a6978aa00457b63bd46680:
  ibmvnic: remove unused defines
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Brett Creeley (1):
  ice: Refactor promiscuous functions

Dan Carpenter (1):
  ice: Remove unnecessary casts

Haiyue Wang (1):
  ice: Add package PTYPE enable information

Jeff Guo (1):
  ice: refactor PTYPE validating

Tony Nguyen (7):
  ice: Remove string printing for ice_status
  ice: Use int for ice_status
  ice: Remove enum ice_status
  ice: Cleanup after ice_status removal
  ice: Remove excess error variables
  ice: Propagate error codes
  ice: Remove unused ICE_FLOW_SEG_HDRS_L2_MASK

Wojciech Drewek (1):
  ice: Refactor status flow for DDP load

 drivers/net/ethernet/intel/ice/ice.h          |   1 -
 drivers/net/ethernet/intel/ice/ice_base.c     |  22 +-
 drivers/net/ethernet/intel/ice/ice_common.c   | 403 +++++-----
 drivers/net/ethernet/intel/ice/ice_common.h   |  96 +--
 drivers/net/ethernet/intel/ice/ice_controlq.c | 120 ++-
 drivers/net/ethernet/intel/ice/ice_dcb.c      |  92 ++-
 drivers/net/ethernet/intel/ice/ice_dcb.h      |  27 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  50 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 143 ++--
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  44 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c     |  20 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h     |  12 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    | 696 +++++++++++-------
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |  83 ++-
 .../net/ethernet/intel/ice/ice_flex_type.h    |  42 ++
 drivers/net/ethernet/intel/ice/ice_flow.c     | 163 ++--
 drivers/net/ethernet/intel/ice/ice_flow.h     |  21 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c     | 144 ++--
 drivers/net/ethernet/intel/ice/ice_fltr.h     |  40 +-
 .../net/ethernet/intel/ice/ice_fw_update.c    |  74 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      | 233 +++---
 drivers/net/ethernet/intel/ice/ice_lib.h      |   6 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 596 ++++++---------
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 143 ++--
 drivers/net/ethernet/intel/ice/ice_nvm.h      |  36 +-
 drivers/net/ethernet/intel/ice/ice_sched.c    | 402 +++++-----
 drivers/net/ethernet/intel/ice/ice_sched.h    |  37 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c    |  40 +-
 drivers/net/ethernet/intel/ice/ice_sriov.h    |  12 +-
 drivers/net/ethernet/intel/ice/ice_status.h   |  44 --
 drivers/net/ethernet/intel/ice/ice_switch.c   | 463 ++++++------
 drivers/net/ethernet/intel/ice/ice_switch.h   |  56 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  12 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |   4 +-
 .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 298 +-------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 457 ++++++------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   2 +
 38 files changed, 2391 insertions(+), 2745 deletions(-)
 delete mode 100644 drivers/net/ethernet/intel/ice/ice_status.h

-- 
2.31.1

