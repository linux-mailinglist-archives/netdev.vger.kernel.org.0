Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588503E2831
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244939AbhHFKJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:09:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:29484 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244907AbhHFKJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 06:09:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="214074273"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="214074273"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 03:09:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="513338592"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Aug 2021 03:09:05 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v4 intel-next 2/6] ice: unify xdp_rings accesses
Date:   Fri,  6 Aug 2021 11:55:35 +0200
Message-Id: <20210806095539.34423-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806095539.34423-1-maciej.fijalkowski@intel.com>
References: <20210806095539.34423-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been a long lasting issue of improper xdp_rings indexing for
XDP_TX and XDP_REDIRECT actions. Given that currently rx_ring->q_index
is mixed with smp_processor_id(), there could be a situation where Tx
descriptors are produced onto XDP Tx ring, but tail is never bumped -
for example pin a particular queue id to non-matching IRQ line.

Address this problem by ignoring the user ring count setting and always
initialize the xdp_rings array to be of num_possible_cpus() size. Then,
always use the smp_processor_id() as an index to xdp_rings array. This
provides serialization as at given time only a single softirq can run on
a particular CPU.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c      | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     | 2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index ac0d7a52406b..d44a657384e6 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3152,7 +3152,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 		ice_vsi_map_rings_to_vectors(vsi);
 		if (ice_is_xdp_ena_vsi(vsi)) {
-			vsi->num_xdp_txq = vsi->alloc_rxq;
+			vsi->num_xdp_txq = num_possible_cpus();
 			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
 			if (ret)
 				goto err_vectors;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index cbcb4ad60852..8a1603301726 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2625,7 +2625,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	}
 
 	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
-		vsi->num_xdp_txq = vsi->alloc_rxq;
+		vsi->num_xdp_txq = num_possible_cpus();
 		xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 74519c603872..152703e202e2 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -295,7 +295,7 @@ void ice_finalize_xdp_rx(struct ice_ring *rx_ring, unsigned int xdp_res)
 
 	if (xdp_res & ICE_XDP_TX) {
 		struct ice_tx_ring *xdp_ring =
-			rx_ring->vsi->xdp_rings[rx_ring->q_index];
+			rx_ring->vsi->xdp_rings[smp_processor_id()];
 
 		ice_xdp_ring_update_tail(xdp_ring);
 	}
-- 
2.20.1

