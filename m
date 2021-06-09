Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57733A1E39
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 22:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhFIUrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 16:47:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:64104 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhFIUr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 16:47:29 -0400
IronPort-SDR: c99qMWCB3VhUFXszt/oyaAx/gWxgn8V7JWcWcpIzzBHDY4TxHRYS2HH1yIMlHfzppEN9BJblVE
 OIdZsk8O8JSQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="266318590"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="266318590"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 13:45:31 -0700
IronPort-SDR: AksZcWHSkfrzqklg0uYyLDRZoJxYwRg+d3OaRxk+yc17QZPXVrqYIH7Rk7/LO2cNtCUcJvVP0w
 PZPgU4fXRlGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="413861111"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2021 13:45:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 2/2] ice: parameterize functions responsible for Tx ring management
Date:   Wed,  9 Jun 2021 13:48:03 -0700
Message-Id: <20210609204803.234983-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210609204803.234983-1-anthony.l.nguyen@intel.com>
References: <20210609204803.234983-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Commit ae15e0ba1b33 ("ice: Change number of XDP Tx queues to match
number of Rx queues") tried to address the incorrect setting of XDP
queue count that was based on the Tx queue count, whereas in theory we
should provide the XDP queue per Rx queue. However, the routines that
setup and destroy the set of Tx resources are still based on the
vsi->num_txq.

Ice supports the asynchronous Tx/Rx queue count, so for a setup where
vsi->num_txq > vsi->num_rxq, ice_vsi_stop_tx_rings and ice_vsi_cfg_txqs
will be accessing the vsi->xdp_rings out of the bounds.

Parameterize two mentioned functions so they get the size of Tx resources
array as the input.

Fixes: ae15e0ba1b33 ("ice: Change number of XDP Tx queues to match number of Rx queues")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index d70ee573fde5..27f9dac8719c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1717,12 +1717,13 @@ int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
  * ice_vsi_cfg_txqs - Configure the VSI for Tx
  * @vsi: the VSI being configured
  * @rings: Tx ring array to be configured
+ * @count: number of Tx ring array elements
  *
  * Return 0 on success and a negative value on error
  * Configure the Tx VSI for operation.
  */
 static int
-ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings)
+ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings, u16 count)
 {
 	struct ice_aqc_add_tx_qgrp *qg_buf;
 	u16 q_idx = 0;
@@ -1734,7 +1735,7 @@ ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings)
 
 	qg_buf->num_txqs = 1;
 
-	for (q_idx = 0; q_idx < vsi->num_txq; q_idx++) {
+	for (q_idx = 0; q_idx < count; q_idx++) {
 		err = ice_vsi_cfg_txq(vsi, rings[q_idx], qg_buf);
 		if (err)
 			goto err_cfg_txqs;
@@ -1754,7 +1755,7 @@ ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings)
  */
 int ice_vsi_cfg_lan_txqs(struct ice_vsi *vsi)
 {
-	return ice_vsi_cfg_txqs(vsi, vsi->tx_rings);
+	return ice_vsi_cfg_txqs(vsi, vsi->tx_rings, vsi->num_txq);
 }
 
 /**
@@ -1769,7 +1770,7 @@ int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
 	int ret;
 	int i;
 
-	ret = ice_vsi_cfg_txqs(vsi, vsi->xdp_rings);
+	ret = ice_vsi_cfg_txqs(vsi, vsi->xdp_rings, vsi->num_xdp_txq);
 	if (ret)
 		return ret;
 
@@ -2009,17 +2010,18 @@ int ice_vsi_stop_all_rx_rings(struct ice_vsi *vsi)
  * @rst_src: reset source
  * @rel_vmvf_num: Relative ID of VF/VM
  * @rings: Tx ring array to be stopped
+ * @count: number of Tx ring array elements
  */
 static int
 ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
-		      u16 rel_vmvf_num, struct ice_ring **rings)
+		      u16 rel_vmvf_num, struct ice_ring **rings, u16 count)
 {
 	u16 q_idx;
 
 	if (vsi->num_txq > ICE_LAN_TXQ_MAX_QDIS)
 		return -EINVAL;
 
-	for (q_idx = 0; q_idx < vsi->num_txq; q_idx++) {
+	for (q_idx = 0; q_idx < count; q_idx++) {
 		struct ice_txq_meta txq_meta = { };
 		int status;
 
@@ -2047,7 +2049,7 @@ int
 ice_vsi_stop_lan_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 			  u16 rel_vmvf_num)
 {
-	return ice_vsi_stop_tx_rings(vsi, rst_src, rel_vmvf_num, vsi->tx_rings);
+	return ice_vsi_stop_tx_rings(vsi, rst_src, rel_vmvf_num, vsi->tx_rings, vsi->num_txq);
 }
 
 /**
@@ -2056,7 +2058,7 @@ ice_vsi_stop_lan_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
  */
 int ice_vsi_stop_xdp_tx_rings(struct ice_vsi *vsi)
 {
-	return ice_vsi_stop_tx_rings(vsi, ICE_NO_RESET, 0, vsi->xdp_rings);
+	return ice_vsi_stop_tx_rings(vsi, ICE_NO_RESET, 0, vsi->xdp_rings, vsi->num_xdp_txq);
 }
 
 /**
-- 
2.26.2

