Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA773972B8
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhFALsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:48:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:47599 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230308AbhFALry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 07:47:54 -0400
IronPort-SDR: 7yhy6LEglqoLjV4DAQUUSbqroqQJ6cascV/AtnlE/oX+IKSiTz6Yy78a2ad2DeH60vaDL14Ii8
 PyQ+rY2pNxlQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="190884039"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="190884039"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 04:46:13 -0700
IronPort-SDR: H9Z+QO7IZYdfqbUZq4+8NU2zWy761vwd7F6Sx/MWXw6y5Tp7iFXDHF1hSTRF7q2vsj9z0KJMdx
 wXctbumdoFKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="446931353"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 01 Jun 2021 04:46:11 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-next 1/2] ice: unify xdp_rings accesses
Date:   Tue,  1 Jun 2021 13:32:35 +0200
Message-Id: <20210601113236.42651-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210601113236.42651-1-maciej.fijalkowski@intel.com>
References: <20210601113236.42651-1-maciej.fijalkowski@intel.com>
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
Moreover, user can reduce the count of Rx queues which is the base for
sizing xdp_rings array so smp_processor_id() could cause an out of
bounds access.

Address that problem by ignoring the user ring count setting and always
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
index 2c33b0c56c94..3c8668d8b964 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3099,7 +3099,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 
 		ice_vsi_map_rings_to_vectors(vsi);
 		if (ice_is_xdp_ena_vsi(vsi)) {
-			vsi->num_xdp_txq = vsi->alloc_rxq;
+			vsi->num_xdp_txq = num_possible_cpus();
 			ret = ice_prepare_xdp_rings(vsi, vsi->xdp_prog);
 			if (ret)
 				goto err_vectors;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0eb2307325d3..1915b6a734e2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2534,7 +2534,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 	}
 
 	if (!ice_is_xdp_ena_vsi(vsi) && prog) {
-		vsi->num_xdp_txq = vsi->alloc_rxq;
+		vsi->num_xdp_txq = num_possible_cpus();
 		xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 207f6ee3a7f6..e1c05d69f017 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -279,7 +279,7 @@ void ice_finalize_xdp_rx(struct ice_ring *rx_ring, unsigned int xdp_res)
 
 	if (xdp_res & ICE_XDP_TX) {
 		struct ice_ring *xdp_ring =
-			rx_ring->vsi->xdp_rings[rx_ring->q_index];
+			rx_ring->vsi->xdp_rings[smp_processor_id()];
 
 		ice_xdp_ring_update_tail(xdp_ring);
 	}
-- 
2.20.1

