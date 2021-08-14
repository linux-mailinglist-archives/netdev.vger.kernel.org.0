Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC63EC32F
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 16:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbhHNOX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 10:23:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:45183 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbhHNOXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 10:23:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="279426302"
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="279426302"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2021 07:22:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="447568433"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 14 Aug 2021 07:22:53 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 intel-next 1/9] ice: remove ring_active from ice_ring
Date:   Sat, 14 Aug 2021 16:08:04 +0200
Message-Id: <20210814140812.46632-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This field is dead and driver is not making any use of it. Simply remove
it.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 2 --
 drivers/net/ethernet/intel/ice/ice_main.c | 1 -
 drivers/net/ethernet/intel/ice/ice_txrx.h | 2 --
 3 files changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index dde9802c6c72..12790f07370e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1296,7 +1296,6 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 
 		ring->q_index = i;
 		ring->reg_idx = vsi->txq_map[i];
-		ring->ring_active = false;
 		ring->vsi = vsi;
 		ring->tx_tstamps = &pf->ptp.port.tx;
 		ring->dev = dev;
@@ -1315,7 +1314,6 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 
 		ring->q_index = i;
 		ring->reg_idx = vsi->rxq_map[i];
-		ring->ring_active = false;
 		ring->vsi = vsi;
 		ring->netdev = vsi->netdev;
 		ring->dev = dev;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 60d55d043a94..b8364710f8fb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2380,7 +2380,6 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 
 		xdp_ring->q_index = xdp_q_idx;
 		xdp_ring->reg_idx = vsi->txq_map[xdp_q_idx];
-		xdp_ring->ring_active = false;
 		xdp_ring->vsi = vsi;
 		xdp_ring->netdev = NULL;
 		xdp_ring->dev = dev;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 1e46e80f3d6f..d2fd90607b70 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -275,8 +275,6 @@ struct ice_ring {
 	u16 q_index;			/* Queue number of ring */
 	u16 q_handle;			/* Queue handle per TC */
 
-	u8 ring_active:1;		/* is ring online or not */
-
 	u16 count;			/* Number of descriptors */
 	u16 reg_idx;			/* HW register index of the ring */
 
-- 
2.20.1

