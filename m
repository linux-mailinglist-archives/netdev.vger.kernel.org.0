Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E2C42F823
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241357AbhJOQdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:33:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:37917 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241276AbhJOQdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 12:33:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10138"; a="208059617"
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="208059617"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2021 09:31:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,376,1624345200"; 
   d="scan'208";a="528205554"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 15 Oct 2021 09:31:03 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kpsingh@kernel.org,
        kafai@fb.com, yhs@fb.com, songliubraving@fb.com,
        bpf@vger.kernel.org
Subject: [PATCH net-next 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2021-10-15
Date:   Fri, 15 Oct 2021 09:28:59 -0700
Message-Id: <20211015162908.145341-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Maciej makes improvements centered around XDP. Changes include removing
an unused field from the ring structure, creating separate Tx and Rx
ring structures, and using ice_for_each macros for iterating rings.
Some calls and parameters are changed to reduce unneeded overhead for
further optimization. New fields are added for tracking to aid in
improving workloads. He also unifies XDP indexing to a single
methodology and adds a fallback patch when XDP Tx queue per CPU is not
met.

The following are changes since commit 295711fa8fec42a55623bf6997d05a21d7855132:
  Merge branch 'dpaa2-irq-coalescing'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Maciej Fijalkowski (9):
  ice: remove ring_active from ice_ring
  ice: move ice_container_type onto ice_ring_container
  ice: split ice_ring onto Tx/Rx separate structs
  ice: unify xdp_rings accesses
  ice: do not create xdp_frame on XDP_TX
  ice: propagate xdp_ring onto rx_ring
  ice: optimize XDP_TX workloads
  ice: introduce XDP_TX fallback path
  ice: make use of ice_for_each_* macros

 drivers/net/ethernet/intel/ice/ice.h          |  41 +++-
 drivers/net/ethernet/intel/ice/ice_arfs.c     |   2 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  59 +++---
 drivers/net/ethernet/intel/ice/ice_base.h     |   8 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   9 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  10 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c  |  35 ++--
 drivers/net/ethernet/intel/ice/ice_eswitch.h  |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  95 +++++----
 drivers/net/ethernet/intel/ice/ice_lib.c      |  92 +++++----
 drivers/net/ethernet/intel/ice/ice_lib.h      |   6 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 145 +++++++++-----
 drivers/net/ethernet/intel/ice/ice_ptp.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_trace.h    |  28 +--
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 183 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 121 ++++++++----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  98 ++++++++--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  14 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  70 ++++---
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  20 +-
 22 files changed, 628 insertions(+), 420 deletions(-)

-- 
2.31.1

