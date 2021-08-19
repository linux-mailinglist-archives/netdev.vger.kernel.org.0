Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CF63F18E6
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238878AbhHSMPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:15:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:50600 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233610AbhHSMPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 08:15:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="277560935"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="277560935"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 05:15:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="532195059"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 19 Aug 2021 05:15:10 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v7 intel-next 0/9] XDP_TX improvements for ice
Date:   Thu, 19 Aug 2021 13:59:55 +0200
Message-Id: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I didn't realize that on v6 I didn't have CONFIG_NET_SWITCHDEV option
set in the kernel config. I removed ice_eswitch_remap_ring but didn't
adjust the q_vector's ring pointer to the new Rx/Tx union.

Hope that it's the last time of embarrassment :)

v6->v7:
* fix compilation issues when CONFIG_NET_SWITCHDEV=y

v5->v6:
* rebase set on Tony's dev-queue
* adjust switchdev code to ring split
* compile with W=1 C=2 and fix outstanding kdoc issues

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

v6 : https://lore.kernel.org/bpf/20210818135916.25007-1-maciej.fijalkowski@intel.com/
v5 : https://lore.kernel.org/bpf/20210818075256.GA16780@ranger.igk.intel.com/
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
 drivers/net/ethernet/intel/ice/ice_txrx.h     | 126 +++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  98 ++++++++--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  14 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  70 ++++---
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  20 +-
 22 files changed, 629 insertions(+), 424 deletions(-)

-- 
2.20.1

