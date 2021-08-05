Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBFA3E1F37
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 01:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242232AbhHEXOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 19:14:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:23383 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhHEXOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 19:14:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="278023042"
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="278023042"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 16:14:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="503591582"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 05 Aug 2021 16:14:04 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 intel-next 0/6] XDP_TX improvements for ice
Date:   Fri,  6 Aug 2021 01:00:40 +0200
Message-Id: <20210805230046.28715-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

it's been a while. Here's another revision of XDP_TX improvements for
ice. This time I decided to split the generic ring struct that was
serving both Tx and Rx sides onto separate entities. It is due to the
fact that this set introduces few Tx specific fields onto ring.

Also, when compared to v2, Xdp ring is propagated onto Rx ring.
Accessing vsi->xdp_rings array, especially in fallback path, is not
convenient.

Finally patch 5 introduces yet another cleaning logic, different from
v2. For more info please see commit messages.

Thanks!
Maciej

v2 : https://lore.kernel.org/bpf/20210705164338.58313-1-maciej.fijalkowski@intel.com/
v1 : https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/

Maciej Fijalkowski (6):
  ice: split ice_ring onto Tx/Rx separate structs
  ice: unify xdp_rings accesses
  ice: do not create xdp_frame on XDP_TX
  ice: propagate xdp_ring onto rx_ring
  ice: optimize XDP_TX workloads
  ice: introduce XDP_TX fallback path

 drivers/net/ethernet/intel/ice/ice.h          |  30 +++-
 drivers/net/ethernet/intel/ice/ice_base.c     |  27 ++--
 drivers/net/ethernet/intel/ice/ice_base.h     |   6 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   5 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |   6 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  17 ++-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  32 ++--
 drivers/net/ethernet/intel/ice/ice_lib.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 101 +++++++++----
 drivers/net/ethernet/intel/ice/ice_trace.h    |   8 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 139 +++++++++++-------
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  94 +++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  86 +++++++++--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |   8 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  52 ++++---
 drivers/net/ethernet/intel/ice/ice_xsk.h      |   8 +-
 17 files changed, 408 insertions(+), 217 deletions(-)

-- 
2.20.1

