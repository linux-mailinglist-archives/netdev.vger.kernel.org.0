Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD663EC32D
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 16:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238563AbhHNOXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 10:23:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:45183 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbhHNOXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 10:23:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="279426297"
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="279426297"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2021 07:22:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="447568428"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 14 Aug 2021 07:22:50 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 intel-next 0/9] XDP_TX improvements for ice
Date:   Sat, 14 Aug 2021 16:08:03 +0200
Message-Id: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the v5, I think it's time for a proper change log.

v4->v5:
* fix issues pointed by lkp; variables used for updating ring stats
  could be un-inited
* s/ice_ring/ice_rx_ring; it looks now symmetric given that we have
  ice_tx_ring struct dedicated for Tx ring
* go through the code and use ice_for_each_* macros; it was spotted by
  Brett that there was a place around that code that this set is
  touching that was not using the ice_for_each_txq. Turned out that there
  were more such places
* take care of coalesce related code; carry the info about type of ring
  container in ice_ring_container
* pull out getting rid of @ring_active onto separate patch, as suggested
  by Brett

v3->v4:
* fix lkp issues;

v2->v3:
* improve XDP_TX in a proper way
* split ice_ring
* propagate XDP ring pointer to Rx ring

v1->v2:
* try to improve XDP_TX processing

v4 : https://lore.kernel.org/bpf/20210806095539.34423-1-maciej.fijalkowski@intel.com/
v3 : https://lore.kernel.org/bpf/20210805230046.28715-1-maciej.fijalkowski@intel.com/
v2 : https://lore.kernel.org/bpf/20210705164338.58313-1-maciej.fijalkowski@intel.com/
v1 : https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/

Thanks!
Maciej

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
 drivers/net/ethernet/intel/ice/ice_base.c     |  51 ++---
 drivers/net/ethernet/intel/ice/ice_base.h     |   8 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   9 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  10 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  93 +++++----
 drivers/net/ethernet/intel/ice/ice_lib.c      |  88 +++++----
 drivers/net/ethernet/intel/ice/ice_lib.h      |   6 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 142 +++++++++-----
 drivers/net/ethernet/intel/ice/ice_ptp.c      |   2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_trace.h    |  28 +--
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 183 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 126 +++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  98 ++++++++--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  14 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  70 ++++---
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  20 +-
 20 files changed, 607 insertions(+), 390 deletions(-)

-- 
2.20.1

