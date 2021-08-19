Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660EF3F18F7
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239342AbhHSMQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:16:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:50609 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238314AbhHSMQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 08:16:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="277560991"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="277560991"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 05:15:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="532195116"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 19 Aug 2021 05:15:22 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v7 intel-next 4/9] ice: unify xdp_rings accesses
Date:   Thu, 19 Aug 2021 13:59:59 +0200
Message-Id: <20210819120004.34392-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
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
index ff403d6a5156..d76e34515483 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3221,7 +3221,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 		ice_vsi_map_rings_to_vectors(vsi);
 		if (ice_is_xdp_ena_vsi(vsi)) {
-			vsi->num_xdp_txq = vsi->alloc_rxq;
+			vsi->num_xdp_txq = num_possible_cpus();
 			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
 			if (ret)
 				goto err_vectors;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5645b6e95fbe..8dc00a14ef56 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2694,7 +2694,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	}
 
 	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
-		vsi->num_xdp_txq = vsi->alloc_rxq;
+		vsi->num_xdp_txq = num_possible_cpus();
 		xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index d6d71f82142f..bc64610df7cb 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -297,7 +297,7 @@ void ice_finalize_xdp_rx(struct ice_rx_ring *rx_ring, unsigned int xdp_res)
 
 	if (xdp_res & ICE_XDP_TX) {
 		struct ice_tx_ring *xdp_ring =
-			rx_ring->vsi->xdp_rings[rx_ring->q_index];
+			rx_ring->vsi->xdp_rings[smp_processor_id()];
 
 		ice_xdp_ring_update_tail(xdp_ring);
 	}
-- 
2.20.1

