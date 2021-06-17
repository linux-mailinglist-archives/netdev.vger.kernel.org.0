Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B303ABA1C
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhFQRBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:01:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:63633 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231484AbhFQRBP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:01:15 -0400
IronPort-SDR: 9EBFEriETGRtWTGSCMPKhN0GHbGD0W3wicbeG/pz4URUAyMx4AbqcbggZI9++iq5JMDhN8+5/m
 1xT0LeDAIqQg==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="193723050"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="193723050"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 09:59:05 -0700
IronPort-SDR: oNMZ+V7j6LtN/TeK6OecNG652qK0LfGvejaePBUMERrcsiK0vnm40+izRN2QgiP1AKyWgXWq1G
 IkqsUySgdC6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="scan'208";a="404706800"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 Jun 2021 09:59:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 3/8] ice: reduce scope of variables
Date:   Thu, 17 Jun 2021 10:01:40 -0700
Message-Id: <20210617170145.4092904-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
References: <20210617170145.4092904-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

There are some places where the scope of a variable can
be reduced so do that.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 8 ++++----
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a46aba5e9c12..cb858be8f4de 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1205,11 +1205,11 @@ static int ice_vsi_setup_vector_base(struct ice_vsi *vsi)
 	num_q_vectors = vsi->num_q_vectors;
 	/* reserve slots from OS requested IRQs */
 	if (vsi->type == ICE_VSI_CTRL && vsi->vf_id != ICE_INVAL_VFID) {
-		struct ice_vf *vf;
 		int i;
 
 		ice_for_each_vf(pf, i) {
-			vf = &pf->vf[i];
+			struct ice_vf *vf = &pf->vf[i];
+
 			if (i != vsi->vf_id && vf->ctrl_vsi_idx != ICE_NO_VSI) {
 				base = pf->vsi[vf->ctrl_vsi_idx]->base_vector;
 				break;
@@ -2873,11 +2873,11 @@ int ice_vsi_release(struct ice_vsi *vsi)
 	 * cleared in the same manner.
 	 */
 	if (vsi->type == ICE_VSI_CTRL && vsi->vf_id != ICE_INVAL_VFID) {
-		struct ice_vf *vf;
 		int i;
 
 		ice_for_each_vf(pf, i) {
-			vf = &pf->vf[i];
+			struct ice_vf *vf = &pf->vf[i];
+
 			if (i != vsi->vf_id && vf->ctrl_vsi_idx != ICE_NO_VSI)
 				break;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 96276533822e..dbf4a5493ea7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5631,7 +5631,6 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi, struct ice_ring **rings,
 static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 {
 	struct rtnl_link_stats64 *vsi_stats = &vsi->net_stats;
-	struct ice_ring *ring;
 	u64 pkts, bytes;
 	int i;
 
@@ -5655,7 +5654,8 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 
 	/* update Rx rings counters */
 	ice_for_each_rxq(vsi, i) {
-		ring = READ_ONCE(vsi->rx_rings[i]);
+		struct ice_ring *ring = READ_ONCE(vsi->rx_rings[i]);
+
 		ice_fetch_u64_stats_per_ring(ring, &pkts, &bytes);
 		vsi_stats->rx_packets += pkts;
 		vsi_stats->rx_bytes += bytes;
-- 
2.26.2

